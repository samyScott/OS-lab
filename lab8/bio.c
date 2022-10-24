// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"
#include "proc.h"

struct {
  struct spinlock lock;
  struct buf buf[NBUF];
} bcache;

#define NBUCKET 13
struct {
  struct buf head;
  struct spinlock lock;
} bucket[NBUCKET];  

void
binit(void)
{
  struct buf *b;

  for(int i = 0; i < NBUCKET; i ++) {
    initlock(&bucket[i].lock, "bcache.bucket");
  }  

  initlock(&bcache.lock, "bcache");
  for(b = bcache.buf;b < bcache.buf + NBUF; b ++) {
    b->next = bucket[0].head.next;
    if(b->next != 0)
      b->next->prev = b;
    bucket[0].head.next = b;
    b->prev = &bucket[0].head;
    b->bucketno = 0;
    initsleeplock(&b->lock, "buffer");
  }  
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{	

  uint idx = (dev * 131 + blockno) % 13;
  
  // check is cache
  acquire(&bucket[idx].lock);

  struct buf *b = bucket[idx].head.next;
  while(b != 0) {
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bucket[idx].lock);
      acquiresleep(&b->lock);
      return b;
    }
    b = b->next;
  }

  release(&bucket[idx].lock);

  // not cache, seralize the execution of multiplexing cache, which avoids dead lock.
  acquire(&bcache.lock);
  
  // one more time to check is cache, because the cache maybe is exist.
  b = bucket[idx].head.next;
  acquire(&bucket[idx].lock);
  while(b != 0) {
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bucket[idx].lock);
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
    b = b->next;
  }
  release(&bucket[idx].lock);

  // get the earliest using buffer, until a larger timestap of buffer is obtained, the lock on the bucket where the original largest cache block is located cannot be released.
  uint64 ticks = -1;
  for(int i = 0; i < NBUCKET; i ++) {
    int f = 1;
    acquire(&bucket[i].lock);
    struct buf *t = bucket[i].head.next;
    while(t != 0) {
      if(t->refcnt == 0) {
        if(ticks == -1) {
  	  b = t;
	  f = 0;
	} else if(ticks > b->ticks) {
  	  f = 0;
	  release(&bucket[b->bucketno].lock);
	  b = t;
	}
	ticks = b->ticks;
      }
      t = t->next;
    }

    if(f) release(&bucket[i].lock);
  }
  
  if(b == 0) {
    release(&bcache.lock);
    panic("bget: no buffers");
  }

  // remove the buffer block to new bucket.
  uint oldbucketno = b->bucketno;
  if(oldbucketno != idx)
    acquire(&bucket[idx].lock);

  b->refcnt = 1;
  b->bucketno = idx;
  b->dev = dev;
  b->blockno = blockno;
  b->valid = 0;

  b->prev->next = b->next;
  if(b->next != 0) b->next->prev = b->prev;
  
  b->next = bucket[idx].head.next;
  if(b->next != 0) b->next->prev = b;
  bucket[idx].head.next = b;
  b->prev = &bucket[idx].head;

  if(oldbucketno == idx)
    release(&bucket[oldbucketno].lock);
  else {
    release(&bucket[oldbucketno].lock);
    release(&bucket[idx].lock);
  }

  release(&bcache.lock);
  acquiresleep(&b->lock);
  
  return b;
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bucket[b->bucketno].lock);
  b->refcnt--;
  if (b->refcnt == 0) {
    b->ticks = ticks;
  }
  release(&bucket[b->bucketno].lock);
}

void
bpin(struct buf *b) {
  acquire(&bucket[b->bucketno].lock);
  b->refcnt++;
  release(&bucket[b->bucketno].lock);
}

void
bunpin(struct buf *b) {
  acquire(&bucket[b->bucketno].lock);
  b->refcnt--;
  release(&bucket[b->bucketno].lock);
}


