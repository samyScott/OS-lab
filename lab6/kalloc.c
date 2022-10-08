// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
		   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct ref{
  struct spinlock lock;
  uint64 ref_cnt[PHYSTOP / PGSIZE];
} kref;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&kref.lock, "kref");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    kref.ref_cnt[(uint64)p / PGSIZE] = 1;	  
    kfree(p);
  }
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");
  
  acquire(&kref.lock);
  if(-- kref.ref_cnt[(uint64)pa / PGSIZE] == 0) {
  // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;

    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
  }
  release(&kref.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kref.lock);
  
  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    kref.ref_cnt[(uint64)r / PGSIZE] = 1;
  }
  release(&kref.lock);

  return (void*)r;
}

void
decref(uint64 pa) {
  kref.ref_cnt[pa / PGSIZE] --;
}

void 
incref(uint64 pa) {
  kref.ref_cnt[pa / PGSIZE] ++;
}

uint64
getref(uint64 pa) {
  return kref.ref_cnt[pa / PGSIZE];
}

void 
acquire_ref_lock() {
  acquire(&kref.lock);
}

void 
release_ref_lock() {
  release(&kref.lock);
}

  

