
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001f117          	auipc	sp,0x1f
    80000004:	48010113          	addi	sp,sp,1152 # 8001f480 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	756060ef          	jal	ra,8000676c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00027797          	auipc	a5,0x27
    80000034:	55078793          	addi	a5,a5,1360 # 80027580 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	00090913          	mv	s2,s2
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	0fe080e7          	jalr	254(ra) # 80007158 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2) # 8000a068 <kmem+0x18>
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	19e080e7          	jalr	414(ra) # 8000720c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	b84080e7          	jalr	-1148(ra) # 80006c0e <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00009597          	auipc	a1,0x9
    800000e8:	f3458593          	addi	a1,a1,-204 # 80009018 <etext+0x18>
    800000ec:	0000a517          	auipc	a0,0xa
    800000f0:	f6450513          	addi	a0,a0,-156 # 8000a050 <kmem>
    800000f4:	00007097          	auipc	ra,0x7
    800000f8:	fd4080e7          	jalr	-44(ra) # 800070c8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00027517          	auipc	a0,0x27
    80000104:	48050513          	addi	a0,a0,1152 # 80027580 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	0000a497          	auipc	s1,0xa
    80000126:	f2e48493          	addi	s1,s1,-210 # 8000a050 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00007097          	auipc	ra,0x7
    80000130:	02c080e7          	jalr	44(ra) # 80007158 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	0000a517          	auipc	a0,0xa
    8000013e:	f1650513          	addi	a0,a0,-234 # 8000a050 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00007097          	auipc	ra,0x7
    80000148:	0c8080e7          	jalr	200(ra) # 8000720c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	0000a517          	auipc	a0,0xa
    8000016a:	eea50513          	addi	a0,a0,-278 # 8000a050 <kmem>
    8000016e:	00007097          	auipc	ra,0x7
    80000172:	09e080e7          	jalr	158(ra) # 8000720c <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	00a5f963          	bgeu	a1,a0,800001f0 <memmove+0x18>
    800001e2:	02061713          	slli	a4,a2,0x20
    800001e6:	9301                	srli	a4,a4,0x20
    800001e8:	00e587b3          	add	a5,a1,a4
    800001ec:	02f56563          	bltu	a0,a5,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	ce11                	beqz	a2,80000210 <memmove+0x38>
    800001f6:	1682                	slli	a3,a3,0x20
    800001f8:	9281                	srli	a3,a3,0x20
    800001fa:	0685                	addi	a3,a3,1
    800001fc:	96ae                	add	a3,a3,a1
    800001fe:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0785                	addi	a5,a5,1
    80000204:	fff5c703          	lbu	a4,-1(a1)
    80000208:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    8000020c:	fed59ae3          	bne	a1,a3,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000218:	fff6069b          	addiw	a3,a2,-1
    8000021c:	da75                	beqz	a2,80000210 <memmove+0x38>
    8000021e:	02069613          	slli	a2,a3,0x20
    80000222:	9201                	srli	a2,a2,0x20
    80000224:	fff64613          	not	a2,a2
    80000228:	963e                	add	a2,a2,a5
      *--d = *--s;
    8000022a:	17fd                	addi	a5,a5,-1
    8000022c:	177d                	addi	a4,a4,-1
    8000022e:	0007c683          	lbu	a3,0(a5)
    80000232:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000236:	fec79ae3          	bne	a5,a2,8000022a <memmove+0x52>
    8000023a:	bfd9                	j	80000210 <memmove+0x38>

000000008000023c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000023c:	1141                	addi	sp,sp,-16
    8000023e:	e406                	sd	ra,8(sp)
    80000240:	e022                	sd	s0,0(sp)
    80000242:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000244:	00000097          	auipc	ra,0x0
    80000248:	f94080e7          	jalr	-108(ra) # 800001d8 <memmove>
}
    8000024c:	60a2                	ld	ra,8(sp)
    8000024e:	6402                	ld	s0,0(sp)
    80000250:	0141                	addi	sp,sp,16
    80000252:	8082                	ret

0000000080000254 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000254:	1141                	addi	sp,sp,-16
    80000256:	e422                	sd	s0,8(sp)
    80000258:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000025a:	ce11                	beqz	a2,80000276 <strncmp+0x22>
    8000025c:	00054783          	lbu	a5,0(a0)
    80000260:	cf89                	beqz	a5,8000027a <strncmp+0x26>
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	00f71a63          	bne	a4,a5,8000027a <strncmp+0x26>
    n--, p++, q++;
    8000026a:	367d                	addiw	a2,a2,-1
    8000026c:	0505                	addi	a0,a0,1
    8000026e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000270:	f675                	bnez	a2,8000025c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000272:	4501                	li	a0,0
    80000274:	a809                	j	80000286 <strncmp+0x32>
    80000276:	4501                	li	a0,0
    80000278:	a039                	j	80000286 <strncmp+0x32>
  if(n == 0)
    8000027a:	ca09                	beqz	a2,8000028c <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000027c:	00054503          	lbu	a0,0(a0)
    80000280:	0005c783          	lbu	a5,0(a1)
    80000284:	9d1d                	subw	a0,a0,a5
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret
    return 0;
    8000028c:	4501                	li	a0,0
    8000028e:	bfe5                	j	80000286 <strncmp+0x32>

0000000080000290 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000290:	1141                	addi	sp,sp,-16
    80000292:	e422                	sd	s0,8(sp)
    80000294:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000296:	872a                	mv	a4,a0
    80000298:	8832                	mv	a6,a2
    8000029a:	367d                	addiw	a2,a2,-1
    8000029c:	01005963          	blez	a6,800002ae <strncpy+0x1e>
    800002a0:	0705                	addi	a4,a4,1
    800002a2:	0005c783          	lbu	a5,0(a1)
    800002a6:	fef70fa3          	sb	a5,-1(a4)
    800002aa:	0585                	addi	a1,a1,1
    800002ac:	f7f5                	bnez	a5,80000298 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ae:	00c05d63          	blez	a2,800002c8 <strncpy+0x38>
    800002b2:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b4:	0685                	addi	a3,a3,1
    800002b6:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ba:	fff6c793          	not	a5,a3
    800002be:	9fb9                	addw	a5,a5,a4
    800002c0:	010787bb          	addw	a5,a5,a6
    800002c4:	fef048e3          	bgtz	a5,800002b4 <strncpy+0x24>
  return os;
}
    800002c8:	6422                	ld	s0,8(sp)
    800002ca:	0141                	addi	sp,sp,16
    800002cc:	8082                	ret

00000000800002ce <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e422                	sd	s0,8(sp)
    800002d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d4:	02c05363          	blez	a2,800002fa <safestrcpy+0x2c>
    800002d8:	fff6069b          	addiw	a3,a2,-1
    800002dc:	1682                	slli	a3,a3,0x20
    800002de:	9281                	srli	a3,a3,0x20
    800002e0:	96ae                	add	a3,a3,a1
    800002e2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e4:	00d58963          	beq	a1,a3,800002f6 <safestrcpy+0x28>
    800002e8:	0585                	addi	a1,a1,1
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff5c703          	lbu	a4,-1(a1)
    800002f0:	fee78fa3          	sb	a4,-1(a5)
    800002f4:	fb65                	bnez	a4,800002e4 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f6:	00078023          	sb	zero,0(a5)
  return os;
}
    800002fa:	6422                	ld	s0,8(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret

0000000080000300 <strlen>:

int
strlen(const char *s)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e422                	sd	s0,8(sp)
    80000304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000306:	00054783          	lbu	a5,0(a0)
    8000030a:	cf91                	beqz	a5,80000326 <strlen+0x26>
    8000030c:	0505                	addi	a0,a0,1
    8000030e:	87aa                	mv	a5,a0
    80000310:	4685                	li	a3,1
    80000312:	9e89                	subw	a3,a3,a0
    80000314:	00f6853b          	addw	a0,a3,a5
    80000318:	0785                	addi	a5,a5,1
    8000031a:	fff7c703          	lbu	a4,-1(a5)
    8000031e:	fb7d                	bnez	a4,80000314 <strlen+0x14>
    ;
  return n;
}
    80000320:	6422                	ld	s0,8(sp)
    80000322:	0141                	addi	sp,sp,16
    80000324:	8082                	ret
  for(n = 0; s[n]; n++)
    80000326:	4501                	li	a0,0
    80000328:	bfe5                	j	80000320 <strlen+0x20>

000000008000032a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000032a:	1101                	addi	sp,sp,-32
    8000032c:	ec06                	sd	ra,24(sp)
    8000032e:	e822                	sd	s0,16(sp)
    80000330:	e426                	sd	s1,8(sp)
    80000332:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000334:	00001097          	auipc	ra,0x1
    80000338:	b62080e7          	jalr	-1182(ra) # 80000e96 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    8000033c:	0000a497          	auipc	s1,0xa
    80000340:	cc448493          	addi	s1,s1,-828 # 8000a000 <started>
  if(cpuid() == 0){
    80000344:	c531                	beqz	a0,80000390 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000346:	8526                	mv	a0,s1
    80000348:	00007097          	auipc	ra,0x7
    8000034c:	f22080e7          	jalr	-222(ra) # 8000726a <lockfree_read4>
    80000350:	d97d                	beqz	a0,80000346 <main+0x1c>
      ;
    __sync_synchronize();
    80000352:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000356:	00001097          	auipc	ra,0x1
    8000035a:	b40080e7          	jalr	-1216(ra) # 80000e96 <cpuid>
    8000035e:	85aa                	mv	a1,a0
    80000360:	00009517          	auipc	a0,0x9
    80000364:	cd850513          	addi	a0,a0,-808 # 80009038 <etext+0x38>
    80000368:	00007097          	auipc	ra,0x7
    8000036c:	8f0080e7          	jalr	-1808(ra) # 80006c58 <printf>
    kvminithart();    // turn on paging
    80000370:	00000097          	auipc	ra,0x0
    80000374:	0e8080e7          	jalr	232(ra) # 80000458 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	7a8080e7          	jalr	1960(ra) # 80001b20 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000380:	00005097          	auipc	ra,0x5
    80000384:	e04080e7          	jalr	-508(ra) # 80005184 <plicinithart>
  }

  scheduler();        
    80000388:	00001097          	auipc	ra,0x1
    8000038c:	06a080e7          	jalr	106(ra) # 800013f2 <scheduler>
    consoleinit();
    80000390:	00006097          	auipc	ra,0x6
    80000394:	790080e7          	jalr	1936(ra) # 80006b20 <consoleinit>
    printfinit();
    80000398:	00007097          	auipc	ra,0x7
    8000039c:	aa6080e7          	jalr	-1370(ra) # 80006e3e <printfinit>
    printf("\n");
    800003a0:	00009517          	auipc	a0,0x9
    800003a4:	ca850513          	addi	a0,a0,-856 # 80009048 <etext+0x48>
    800003a8:	00007097          	auipc	ra,0x7
    800003ac:	8b0080e7          	jalr	-1872(ra) # 80006c58 <printf>
    printf("xv6 kernel is booting\n");
    800003b0:	00009517          	auipc	a0,0x9
    800003b4:	c7050513          	addi	a0,a0,-912 # 80009020 <etext+0x20>
    800003b8:	00007097          	auipc	ra,0x7
    800003bc:	8a0080e7          	jalr	-1888(ra) # 80006c58 <printf>
    printf("\n");
    800003c0:	00009517          	auipc	a0,0x9
    800003c4:	c8850513          	addi	a0,a0,-888 # 80009048 <etext+0x48>
    800003c8:	00007097          	auipc	ra,0x7
    800003cc:	890080e7          	jalr	-1904(ra) # 80006c58 <printf>
    kinit();         // physical page allocator
    800003d0:	00000097          	auipc	ra,0x0
    800003d4:	d0c080e7          	jalr	-756(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003d8:	00000097          	auipc	ra,0x0
    800003dc:	350080e7          	jalr	848(ra) # 80000728 <kvminit>
    kvminithart();   // turn on paging
    800003e0:	00000097          	auipc	ra,0x0
    800003e4:	078080e7          	jalr	120(ra) # 80000458 <kvminithart>
    procinit();      // process table
    800003e8:	00001097          	auipc	ra,0x1
    800003ec:	a16080e7          	jalr	-1514(ra) # 80000dfe <procinit>
    trapinit();      // trap vectors
    800003f0:	00001097          	auipc	ra,0x1
    800003f4:	708080e7          	jalr	1800(ra) # 80001af8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003f8:	00001097          	auipc	ra,0x1
    800003fc:	728080e7          	jalr	1832(ra) # 80001b20 <trapinithart>
    plicinit();      // set up interrupt controller
    80000400:	00005097          	auipc	ra,0x5
    80000404:	d5a080e7          	jalr	-678(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000408:	00005097          	auipc	ra,0x5
    8000040c:	d7c080e7          	jalr	-644(ra) # 80005184 <plicinithart>
    binit();         // buffer cache
    80000410:	00002097          	auipc	ra,0x2
    80000414:	e82080e7          	jalr	-382(ra) # 80002292 <binit>
    iinit();         // inode cache
    80000418:	00002097          	auipc	ra,0x2
    8000041c:	512080e7          	jalr	1298(ra) # 8000292a <iinit>
    fileinit();      // file table
    80000420:	00003097          	auipc	ra,0x3
    80000424:	4c4080e7          	jalr	1220(ra) # 800038e4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000428:	00005097          	auipc	ra,0x5
    8000042c:	e84080e7          	jalr	-380(ra) # 800052ac <virtio_disk_init>
    pci_init();
    80000430:	00006097          	auipc	ra,0x6
    80000434:	20a080e7          	jalr	522(ra) # 8000663a <pci_init>
    sockinit();
    80000438:	00006097          	auipc	ra,0x6
    8000043c:	df8080e7          	jalr	-520(ra) # 80006230 <sockinit>
    userinit();      // first user process
    80000440:	00001097          	auipc	ra,0x1
    80000444:	d4c080e7          	jalr	-692(ra) # 8000118c <userinit>
    __sync_synchronize();
    80000448:	0ff0000f          	fence
    started = 1;
    8000044c:	4785                	li	a5,1
    8000044e:	0000a717          	auipc	a4,0xa
    80000452:	baf72923          	sw	a5,-1102(a4) # 8000a000 <started>
    80000456:	bf0d                	j	80000388 <main+0x5e>

0000000080000458 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000458:	1141                	addi	sp,sp,-16
    8000045a:	e422                	sd	s0,8(sp)
    8000045c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000045e:	0000a797          	auipc	a5,0xa
    80000462:	baa7b783          	ld	a5,-1110(a5) # 8000a008 <kernel_pagetable>
    80000466:	83b1                	srli	a5,a5,0xc
    80000468:	577d                	li	a4,-1
    8000046a:	177e                	slli	a4,a4,0x3f
    8000046c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000046e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000472:	12000073          	sfence.vma
  sfence_vma();
}
    80000476:	6422                	ld	s0,8(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret

000000008000047c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000047c:	7139                	addi	sp,sp,-64
    8000047e:	fc06                	sd	ra,56(sp)
    80000480:	f822                	sd	s0,48(sp)
    80000482:	f426                	sd	s1,40(sp)
    80000484:	f04a                	sd	s2,32(sp)
    80000486:	ec4e                	sd	s3,24(sp)
    80000488:	e852                	sd	s4,16(sp)
    8000048a:	e456                	sd	s5,8(sp)
    8000048c:	e05a                	sd	s6,0(sp)
    8000048e:	0080                	addi	s0,sp,64
    80000490:	84aa                	mv	s1,a0
    80000492:	89ae                	mv	s3,a1
    80000494:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000496:	57fd                	li	a5,-1
    80000498:	83e9                	srli	a5,a5,0x1a
    8000049a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000049c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000049e:	04b7f263          	bgeu	a5,a1,800004e2 <walk+0x66>
    panic("walk");
    800004a2:	00009517          	auipc	a0,0x9
    800004a6:	bae50513          	addi	a0,a0,-1106 # 80009050 <etext+0x50>
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	764080e7          	jalr	1892(ra) # 80006c0e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004b2:	060a8663          	beqz	s5,8000051e <walk+0xa2>
    800004b6:	00000097          	auipc	ra,0x0
    800004ba:	c62080e7          	jalr	-926(ra) # 80000118 <kalloc>
    800004be:	84aa                	mv	s1,a0
    800004c0:	c529                	beqz	a0,8000050a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004c2:	6605                	lui	a2,0x1
    800004c4:	4581                	li	a1,0
    800004c6:	00000097          	auipc	ra,0x0
    800004ca:	cb2080e7          	jalr	-846(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ce:	00c4d793          	srli	a5,s1,0xc
    800004d2:	07aa                	slli	a5,a5,0xa
    800004d4:	0017e793          	ori	a5,a5,1
    800004d8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004dc:	3a5d                	addiw	s4,s4,-9
    800004de:	036a0063          	beq	s4,s6,800004fe <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e2:	0149d933          	srl	s2,s3,s4
    800004e6:	1ff97913          	andi	s2,s2,511
    800004ea:	090e                	slli	s2,s2,0x3
    800004ec:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ee:	00093483          	ld	s1,0(s2)
    800004f2:	0014f793          	andi	a5,s1,1
    800004f6:	dfd5                	beqz	a5,800004b2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004f8:	80a9                	srli	s1,s1,0xa
    800004fa:	04b2                	slli	s1,s1,0xc
    800004fc:	b7c5                	j	800004dc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004fe:	00c9d513          	srli	a0,s3,0xc
    80000502:	1ff57513          	andi	a0,a0,511
    80000506:	050e                	slli	a0,a0,0x3
    80000508:	9526                	add	a0,a0,s1
}
    8000050a:	70e2                	ld	ra,56(sp)
    8000050c:	7442                	ld	s0,48(sp)
    8000050e:	74a2                	ld	s1,40(sp)
    80000510:	7902                	ld	s2,32(sp)
    80000512:	69e2                	ld	s3,24(sp)
    80000514:	6a42                	ld	s4,16(sp)
    80000516:	6aa2                	ld	s5,8(sp)
    80000518:	6b02                	ld	s6,0(sp)
    8000051a:	6121                	addi	sp,sp,64
    8000051c:	8082                	ret
        return 0;
    8000051e:	4501                	li	a0,0
    80000520:	b7ed                	j	8000050a <walk+0x8e>

0000000080000522 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000522:	57fd                	li	a5,-1
    80000524:	83e9                	srli	a5,a5,0x1a
    80000526:	00b7f463          	bgeu	a5,a1,8000052e <walkaddr+0xc>
    return 0;
    8000052a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000052c:	8082                	ret
{
    8000052e:	1141                	addi	sp,sp,-16
    80000530:	e406                	sd	ra,8(sp)
    80000532:	e022                	sd	s0,0(sp)
    80000534:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000536:	4601                	li	a2,0
    80000538:	00000097          	auipc	ra,0x0
    8000053c:	f44080e7          	jalr	-188(ra) # 8000047c <walk>
  if(pte == 0)
    80000540:	c105                	beqz	a0,80000560 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000542:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000544:	0117f693          	andi	a3,a5,17
    80000548:	4745                	li	a4,17
    return 0;
    8000054a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000054c:	00e68663          	beq	a3,a4,80000558 <walkaddr+0x36>
}
    80000550:	60a2                	ld	ra,8(sp)
    80000552:	6402                	ld	s0,0(sp)
    80000554:	0141                	addi	sp,sp,16
    80000556:	8082                	ret
  pa = PTE2PA(*pte);
    80000558:	00a7d513          	srli	a0,a5,0xa
    8000055c:	0532                	slli	a0,a0,0xc
  return pa;
    8000055e:	bfcd                	j	80000550 <walkaddr+0x2e>
    return 0;
    80000560:	4501                	li	a0,0
    80000562:	b7fd                	j	80000550 <walkaddr+0x2e>

0000000080000564 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000564:	715d                	addi	sp,sp,-80
    80000566:	e486                	sd	ra,72(sp)
    80000568:	e0a2                	sd	s0,64(sp)
    8000056a:	fc26                	sd	s1,56(sp)
    8000056c:	f84a                	sd	s2,48(sp)
    8000056e:	f44e                	sd	s3,40(sp)
    80000570:	f052                	sd	s4,32(sp)
    80000572:	ec56                	sd	s5,24(sp)
    80000574:	e85a                	sd	s6,16(sp)
    80000576:	e45e                	sd	s7,8(sp)
    80000578:	0880                	addi	s0,sp,80
    8000057a:	8aaa                	mv	s5,a0
    8000057c:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    8000057e:	777d                	lui	a4,0xfffff
    80000580:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000584:	167d                	addi	a2,a2,-1
    80000586:	00b609b3          	add	s3,a2,a1
    8000058a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000058e:	893e                	mv	s2,a5
    80000590:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000594:	6b85                	lui	s7,0x1
    80000596:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059a:	4605                	li	a2,1
    8000059c:	85ca                	mv	a1,s2
    8000059e:	8556                	mv	a0,s5
    800005a0:	00000097          	auipc	ra,0x0
    800005a4:	edc080e7          	jalr	-292(ra) # 8000047c <walk>
    800005a8:	c51d                	beqz	a0,800005d6 <mappages+0x72>
    if(*pte & PTE_V)
    800005aa:	611c                	ld	a5,0(a0)
    800005ac:	8b85                	andi	a5,a5,1
    800005ae:	ef81                	bnez	a5,800005c6 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005b0:	80b1                	srli	s1,s1,0xc
    800005b2:	04aa                	slli	s1,s1,0xa
    800005b4:	0164e4b3          	or	s1,s1,s6
    800005b8:	0014e493          	ori	s1,s1,1
    800005bc:	e104                	sd	s1,0(a0)
    if(a == last)
    800005be:	03390863          	beq	s2,s3,800005ee <mappages+0x8a>
    a += PGSIZE;
    800005c2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c4:	bfc9                	j	80000596 <mappages+0x32>
      panic("remap");
    800005c6:	00009517          	auipc	a0,0x9
    800005ca:	a9250513          	addi	a0,a0,-1390 # 80009058 <etext+0x58>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	640080e7          	jalr	1600(ra) # 80006c0e <panic>
      return -1;
    800005d6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005d8:	60a6                	ld	ra,72(sp)
    800005da:	6406                	ld	s0,64(sp)
    800005dc:	74e2                	ld	s1,56(sp)
    800005de:	7942                	ld	s2,48(sp)
    800005e0:	79a2                	ld	s3,40(sp)
    800005e2:	7a02                	ld	s4,32(sp)
    800005e4:	6ae2                	ld	s5,24(sp)
    800005e6:	6b42                	ld	s6,16(sp)
    800005e8:	6ba2                	ld	s7,8(sp)
    800005ea:	6161                	addi	sp,sp,80
    800005ec:	8082                	ret
  return 0;
    800005ee:	4501                	li	a0,0
    800005f0:	b7e5                	j	800005d8 <mappages+0x74>

00000000800005f2 <kvmmap>:
{
    800005f2:	1141                	addi	sp,sp,-16
    800005f4:	e406                	sd	ra,8(sp)
    800005f6:	e022                	sd	s0,0(sp)
    800005f8:	0800                	addi	s0,sp,16
    800005fa:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005fc:	86b2                	mv	a3,a2
    800005fe:	863e                	mv	a2,a5
    80000600:	00000097          	auipc	ra,0x0
    80000604:	f64080e7          	jalr	-156(ra) # 80000564 <mappages>
    80000608:	e509                	bnez	a0,80000612 <kvmmap+0x20>
}
    8000060a:	60a2                	ld	ra,8(sp)
    8000060c:	6402                	ld	s0,0(sp)
    8000060e:	0141                	addi	sp,sp,16
    80000610:	8082                	ret
    panic("kvmmap");
    80000612:	00009517          	auipc	a0,0x9
    80000616:	a4e50513          	addi	a0,a0,-1458 # 80009060 <etext+0x60>
    8000061a:	00006097          	auipc	ra,0x6
    8000061e:	5f4080e7          	jalr	1524(ra) # 80006c0e <panic>

0000000080000622 <kvmmake>:
{
    80000622:	1101                	addi	sp,sp,-32
    80000624:	ec06                	sd	ra,24(sp)
    80000626:	e822                	sd	s0,16(sp)
    80000628:	e426                	sd	s1,8(sp)
    8000062a:	e04a                	sd	s2,0(sp)
    8000062c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	aea080e7          	jalr	-1302(ra) # 80000118 <kalloc>
    80000636:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000638:	6605                	lui	a2,0x1
    8000063a:	4581                	li	a1,0
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	b3c080e7          	jalr	-1220(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000644:	4719                	li	a4,6
    80000646:	6685                	lui	a3,0x1
    80000648:	10000637          	lui	a2,0x10000
    8000064c:	100005b7          	lui	a1,0x10000
    80000650:	8526                	mv	a0,s1
    80000652:	00000097          	auipc	ra,0x0
    80000656:	fa0080e7          	jalr	-96(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000065a:	4719                	li	a4,6
    8000065c:	6685                	lui	a3,0x1
    8000065e:	10001637          	lui	a2,0x10001
    80000662:	100015b7          	lui	a1,0x10001
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f8a080e7          	jalr	-118(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80000670:	4719                	li	a4,6
    80000672:	100006b7          	lui	a3,0x10000
    80000676:	30000637          	lui	a2,0x30000
    8000067a:	300005b7          	lui	a1,0x30000
    8000067e:	8526                	mv	a0,s1
    80000680:	00000097          	auipc	ra,0x0
    80000684:	f72080e7          	jalr	-142(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80000688:	4719                	li	a4,6
    8000068a:	000206b7          	lui	a3,0x20
    8000068e:	40000637          	lui	a2,0x40000
    80000692:	400005b7          	lui	a1,0x40000
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f5a080e7          	jalr	-166(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	004006b7          	lui	a3,0x400
    800006a6:	0c000637          	lui	a2,0xc000
    800006aa:	0c0005b7          	lui	a1,0xc000
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f42080e7          	jalr	-190(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006b8:	00009917          	auipc	s2,0x9
    800006bc:	94890913          	addi	s2,s2,-1720 # 80009000 <etext>
    800006c0:	4729                	li	a4,10
    800006c2:	80009697          	auipc	a3,0x80009
    800006c6:	93e68693          	addi	a3,a3,-1730 # 9000 <_entry-0x7fff7000>
    800006ca:	4605                	li	a2,1
    800006cc:	067e                	slli	a2,a2,0x1f
    800006ce:	85b2                	mv	a1,a2
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f20080e7          	jalr	-224(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006da:	4719                	li	a4,6
    800006dc:	46c5                	li	a3,17
    800006de:	06ee                	slli	a3,a3,0x1b
    800006e0:	412686b3          	sub	a3,a3,s2
    800006e4:	864a                	mv	a2,s2
    800006e6:	85ca                	mv	a1,s2
    800006e8:	8526                	mv	a0,s1
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	f08080e7          	jalr	-248(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006f2:	4729                	li	a4,10
    800006f4:	6685                	lui	a3,0x1
    800006f6:	00008617          	auipc	a2,0x8
    800006fa:	90a60613          	addi	a2,a2,-1782 # 80008000 <_trampoline>
    800006fe:	040005b7          	lui	a1,0x4000
    80000702:	15fd                	addi	a1,a1,-1
    80000704:	05b2                	slli	a1,a1,0xc
    80000706:	8526                	mv	a0,s1
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	eea080e7          	jalr	-278(ra) # 800005f2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000710:	8526                	mv	a0,s1
    80000712:	00000097          	auipc	ra,0x0
    80000716:	656080e7          	jalr	1622(ra) # 80000d68 <proc_mapstacks>
}
    8000071a:	8526                	mv	a0,s1
    8000071c:	60e2                	ld	ra,24(sp)
    8000071e:	6442                	ld	s0,16(sp)
    80000720:	64a2                	ld	s1,8(sp)
    80000722:	6902                	ld	s2,0(sp)
    80000724:	6105                	addi	sp,sp,32
    80000726:	8082                	ret

0000000080000728 <kvminit>:
{
    80000728:	1141                	addi	sp,sp,-16
    8000072a:	e406                	sd	ra,8(sp)
    8000072c:	e022                	sd	s0,0(sp)
    8000072e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000730:	00000097          	auipc	ra,0x0
    80000734:	ef2080e7          	jalr	-270(ra) # 80000622 <kvmmake>
    80000738:	0000a797          	auipc	a5,0xa
    8000073c:	8ca7b823          	sd	a0,-1840(a5) # 8000a008 <kernel_pagetable>
}
    80000740:	60a2                	ld	ra,8(sp)
    80000742:	6402                	ld	s0,0(sp)
    80000744:	0141                	addi	sp,sp,16
    80000746:	8082                	ret

0000000080000748 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000748:	715d                	addi	sp,sp,-80
    8000074a:	e486                	sd	ra,72(sp)
    8000074c:	e0a2                	sd	s0,64(sp)
    8000074e:	fc26                	sd	s1,56(sp)
    80000750:	f84a                	sd	s2,48(sp)
    80000752:	f44e                	sd	s3,40(sp)
    80000754:	f052                	sd	s4,32(sp)
    80000756:	ec56                	sd	s5,24(sp)
    80000758:	e85a                	sd	s6,16(sp)
    8000075a:	e45e                	sd	s7,8(sp)
    8000075c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000075e:	03459793          	slli	a5,a1,0x34
    80000762:	e795                	bnez	a5,8000078e <uvmunmap+0x46>
    80000764:	8a2a                	mv	s4,a0
    80000766:	892e                	mv	s2,a1
    80000768:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000076a:	0632                	slli	a2,a2,0xc
    8000076c:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000770:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	6b05                	lui	s6,0x1
    80000774:	0935e263          	bltu	a1,s3,800007f8 <uvmunmap+0xb0>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000778:	60a6                	ld	ra,72(sp)
    8000077a:	6406                	ld	s0,64(sp)
    8000077c:	74e2                	ld	s1,56(sp)
    8000077e:	7942                	ld	s2,48(sp)
    80000780:	79a2                	ld	s3,40(sp)
    80000782:	7a02                	ld	s4,32(sp)
    80000784:	6ae2                	ld	s5,24(sp)
    80000786:	6b42                	ld	s6,16(sp)
    80000788:	6ba2                	ld	s7,8(sp)
    8000078a:	6161                	addi	sp,sp,80
    8000078c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000078e:	00009517          	auipc	a0,0x9
    80000792:	8da50513          	addi	a0,a0,-1830 # 80009068 <etext+0x68>
    80000796:	00006097          	auipc	ra,0x6
    8000079a:	478080e7          	jalr	1144(ra) # 80006c0e <panic>
      panic("uvmunmap: walk");
    8000079e:	00009517          	auipc	a0,0x9
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80009080 <etext+0x80>
    800007a6:	00006097          	auipc	ra,0x6
    800007aa:	468080e7          	jalr	1128(ra) # 80006c0e <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007ae:	862a                	mv	a2,a0
    800007b0:	85ca                	mv	a1,s2
    800007b2:	00009517          	auipc	a0,0x9
    800007b6:	8de50513          	addi	a0,a0,-1826 # 80009090 <etext+0x90>
    800007ba:	00006097          	auipc	ra,0x6
    800007be:	49e080e7          	jalr	1182(ra) # 80006c58 <printf>
      panic("uvmunmap: not mapped");
    800007c2:	00009517          	auipc	a0,0x9
    800007c6:	8de50513          	addi	a0,a0,-1826 # 800090a0 <etext+0xa0>
    800007ca:	00006097          	auipc	ra,0x6
    800007ce:	444080e7          	jalr	1092(ra) # 80006c0e <panic>
      panic("uvmunmap: not a leaf");
    800007d2:	00009517          	auipc	a0,0x9
    800007d6:	8e650513          	addi	a0,a0,-1818 # 800090b8 <etext+0xb8>
    800007da:	00006097          	auipc	ra,0x6
    800007de:	434080e7          	jalr	1076(ra) # 80006c0e <panic>
      uint64 pa = PTE2PA(*pte);
    800007e2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e4:	0532                	slli	a0,a0,0xc
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	836080e7          	jalr	-1994(ra) # 8000001c <kfree>
    *pte = 0;
    800007ee:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f2:	995a                	add	s2,s2,s6
    800007f4:	f93972e3          	bgeu	s2,s3,80000778 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f8:	4601                	li	a2,0
    800007fa:	85ca                	mv	a1,s2
    800007fc:	8552                	mv	a0,s4
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	c7e080e7          	jalr	-898(ra) # 8000047c <walk>
    80000806:	84aa                	mv	s1,a0
    80000808:	d959                	beqz	a0,8000079e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    8000080a:	6108                	ld	a0,0(a0)
    8000080c:	00157793          	andi	a5,a0,1
    80000810:	dfd9                	beqz	a5,800007ae <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000812:	3ff57793          	andi	a5,a0,1023
    80000816:	fb778ee3          	beq	a5,s7,800007d2 <uvmunmap+0x8a>
    if(do_free){
    8000081a:	fc0a8ae3          	beqz	s5,800007ee <uvmunmap+0xa6>
    8000081e:	b7d1                	j	800007e2 <uvmunmap+0x9a>

0000000080000820 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000820:	1101                	addi	sp,sp,-32
    80000822:	ec06                	sd	ra,24(sp)
    80000824:	e822                	sd	s0,16(sp)
    80000826:	e426                	sd	s1,8(sp)
    80000828:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	8ee080e7          	jalr	-1810(ra) # 80000118 <kalloc>
    80000832:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000834:	c519                	beqz	a0,80000842 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	93e080e7          	jalr	-1730(ra) # 80000178 <memset>
  return pagetable;
}
    80000842:	8526                	mv	a0,s1
    80000844:	60e2                	ld	ra,24(sp)
    80000846:	6442                	ld	s0,16(sp)
    80000848:	64a2                	ld	s1,8(sp)
    8000084a:	6105                	addi	sp,sp,32
    8000084c:	8082                	ret

000000008000084e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084e:	7179                	addi	sp,sp,-48
    80000850:	f406                	sd	ra,40(sp)
    80000852:	f022                	sd	s0,32(sp)
    80000854:	ec26                	sd	s1,24(sp)
    80000856:	e84a                	sd	s2,16(sp)
    80000858:	e44e                	sd	s3,8(sp)
    8000085a:	e052                	sd	s4,0(sp)
    8000085c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085e:	6785                	lui	a5,0x1
    80000860:	04f67863          	bgeu	a2,a5,800008b0 <uvminit+0x62>
    80000864:	8a2a                	mv	s4,a0
    80000866:	89ae                	mv	s3,a1
    80000868:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000086a:	00000097          	auipc	ra,0x0
    8000086e:	8ae080e7          	jalr	-1874(ra) # 80000118 <kalloc>
    80000872:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000874:	6605                	lui	a2,0x1
    80000876:	4581                	li	a1,0
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	900080e7          	jalr	-1792(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000880:	4779                	li	a4,30
    80000882:	86ca                	mv	a3,s2
    80000884:	6605                	lui	a2,0x1
    80000886:	4581                	li	a1,0
    80000888:	8552                	mv	a0,s4
    8000088a:	00000097          	auipc	ra,0x0
    8000088e:	cda080e7          	jalr	-806(ra) # 80000564 <mappages>
  memmove(mem, src, sz);
    80000892:	8626                	mv	a2,s1
    80000894:	85ce                	mv	a1,s3
    80000896:	854a                	mv	a0,s2
    80000898:	00000097          	auipc	ra,0x0
    8000089c:	940080e7          	jalr	-1728(ra) # 800001d8 <memmove>
}
    800008a0:	70a2                	ld	ra,40(sp)
    800008a2:	7402                	ld	s0,32(sp)
    800008a4:	64e2                	ld	s1,24(sp)
    800008a6:	6942                	ld	s2,16(sp)
    800008a8:	69a2                	ld	s3,8(sp)
    800008aa:	6a02                	ld	s4,0(sp)
    800008ac:	6145                	addi	sp,sp,48
    800008ae:	8082                	ret
    panic("inituvm: more than a page");
    800008b0:	00009517          	auipc	a0,0x9
    800008b4:	82050513          	addi	a0,a0,-2016 # 800090d0 <etext+0xd0>
    800008b8:	00006097          	auipc	ra,0x6
    800008bc:	356080e7          	jalr	854(ra) # 80006c0e <panic>

00000000800008c0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c0:	1101                	addi	sp,sp,-32
    800008c2:	ec06                	sd	ra,24(sp)
    800008c4:	e822                	sd	s0,16(sp)
    800008c6:	e426                	sd	s1,8(sp)
    800008c8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008ca:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008cc:	00b67d63          	bgeu	a2,a1,800008e6 <uvmdealloc+0x26>
    800008d0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1
    800008d6:	00f60733          	add	a4,a2,a5
    800008da:	767d                	lui	a2,0xfffff
    800008dc:	8f71                	and	a4,a4,a2
    800008de:	97ae                	add	a5,a5,a1
    800008e0:	8ff1                	and	a5,a5,a2
    800008e2:	00f76863          	bltu	a4,a5,800008f2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e6:	8526                	mv	a0,s1
    800008e8:	60e2                	ld	ra,24(sp)
    800008ea:	6442                	ld	s0,16(sp)
    800008ec:	64a2                	ld	s1,8(sp)
    800008ee:	6105                	addi	sp,sp,32
    800008f0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f2:	8f99                	sub	a5,a5,a4
    800008f4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f6:	4685                	li	a3,1
    800008f8:	0007861b          	sext.w	a2,a5
    800008fc:	85ba                	mv	a1,a4
    800008fe:	00000097          	auipc	ra,0x0
    80000902:	e4a080e7          	jalr	-438(ra) # 80000748 <uvmunmap>
    80000906:	b7c5                	j	800008e6 <uvmdealloc+0x26>

0000000080000908 <uvmalloc>:
  if(newsz < oldsz)
    80000908:	0ab66163          	bltu	a2,a1,800009aa <uvmalloc+0xa2>
{
    8000090c:	7139                	addi	sp,sp,-64
    8000090e:	fc06                	sd	ra,56(sp)
    80000910:	f822                	sd	s0,48(sp)
    80000912:	f426                	sd	s1,40(sp)
    80000914:	f04a                	sd	s2,32(sp)
    80000916:	ec4e                	sd	s3,24(sp)
    80000918:	e852                	sd	s4,16(sp)
    8000091a:	e456                	sd	s5,8(sp)
    8000091c:	0080                	addi	s0,sp,64
    8000091e:	8aaa                	mv	s5,a0
    80000920:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000922:	6985                	lui	s3,0x1
    80000924:	19fd                	addi	s3,s3,-1
    80000926:	95ce                	add	a1,a1,s3
    80000928:	79fd                	lui	s3,0xfffff
    8000092a:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092e:	08c9f063          	bgeu	s3,a2,800009ae <uvmalloc+0xa6>
    80000932:	894e                	mv	s2,s3
    mem = kalloc();
    80000934:	fffff097          	auipc	ra,0xfffff
    80000938:	7e4080e7          	jalr	2020(ra) # 80000118 <kalloc>
    8000093c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093e:	c51d                	beqz	a0,8000096c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000940:	6605                	lui	a2,0x1
    80000942:	4581                	li	a1,0
    80000944:	00000097          	auipc	ra,0x0
    80000948:	834080e7          	jalr	-1996(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000094c:	4779                	li	a4,30
    8000094e:	86a6                	mv	a3,s1
    80000950:	6605                	lui	a2,0x1
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	c0e080e7          	jalr	-1010(ra) # 80000564 <mappages>
    8000095e:	e905                	bnez	a0,8000098e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000960:	6785                	lui	a5,0x1
    80000962:	993e                	add	s2,s2,a5
    80000964:	fd4968e3          	bltu	s2,s4,80000934 <uvmalloc+0x2c>
  return newsz;
    80000968:	8552                	mv	a0,s4
    8000096a:	a809                	j	8000097c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000096c:	864e                	mv	a2,s3
    8000096e:	85ca                	mv	a1,s2
    80000970:	8556                	mv	a0,s5
    80000972:	00000097          	auipc	ra,0x0
    80000976:	f4e080e7          	jalr	-178(ra) # 800008c0 <uvmdealloc>
      return 0;
    8000097a:	4501                	li	a0,0
}
    8000097c:	70e2                	ld	ra,56(sp)
    8000097e:	7442                	ld	s0,48(sp)
    80000980:	74a2                	ld	s1,40(sp)
    80000982:	7902                	ld	s2,32(sp)
    80000984:	69e2                	ld	s3,24(sp)
    80000986:	6a42                	ld	s4,16(sp)
    80000988:	6aa2                	ld	s5,8(sp)
    8000098a:	6121                	addi	sp,sp,64
    8000098c:	8082                	ret
      kfree(mem);
    8000098e:	8526                	mv	a0,s1
    80000990:	fffff097          	auipc	ra,0xfffff
    80000994:	68c080e7          	jalr	1676(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000998:	864e                	mv	a2,s3
    8000099a:	85ca                	mv	a1,s2
    8000099c:	8556                	mv	a0,s5
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	f22080e7          	jalr	-222(ra) # 800008c0 <uvmdealloc>
      return 0;
    800009a6:	4501                	li	a0,0
    800009a8:	bfd1                	j	8000097c <uvmalloc+0x74>
    return oldsz;
    800009aa:	852e                	mv	a0,a1
}
    800009ac:	8082                	ret
  return newsz;
    800009ae:	8532                	mv	a0,a2
    800009b0:	b7f1                	j	8000097c <uvmalloc+0x74>

00000000800009b2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b2:	7179                	addi	sp,sp,-48
    800009b4:	f406                	sd	ra,40(sp)
    800009b6:	f022                	sd	s0,32(sp)
    800009b8:	ec26                	sd	s1,24(sp)
    800009ba:	e84a                	sd	s2,16(sp)
    800009bc:	e44e                	sd	s3,8(sp)
    800009be:	e052                	sd	s4,0(sp)
    800009c0:	1800                	addi	s0,sp,48
    800009c2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c4:	84aa                	mv	s1,a0
    800009c6:	6905                	lui	s2,0x1
    800009c8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ca:	4985                	li	s3,1
    800009cc:	a821                	j	800009e4 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ce:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009d0:	0532                	slli	a0,a0,0xc
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	fe0080e7          	jalr	-32(ra) # 800009b2 <freewalk>
      pagetable[i] = 0;
    800009da:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009de:	04a1                	addi	s1,s1,8
    800009e0:	03248163          	beq	s1,s2,80000a02 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e6:	00f57793          	andi	a5,a0,15
    800009ea:	ff3782e3          	beq	a5,s3,800009ce <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ee:	8905                	andi	a0,a0,1
    800009f0:	d57d                	beqz	a0,800009de <freewalk+0x2c>
      panic("freewalk: leaf");
    800009f2:	00008517          	auipc	a0,0x8
    800009f6:	6fe50513          	addi	a0,a0,1790 # 800090f0 <etext+0xf0>
    800009fa:	00006097          	auipc	ra,0x6
    800009fe:	214080e7          	jalr	532(ra) # 80006c0e <panic>
    }
  }
  kfree((void*)pagetable);
    80000a02:	8552                	mv	a0,s4
    80000a04:	fffff097          	auipc	ra,0xfffff
    80000a08:	618080e7          	jalr	1560(ra) # 8000001c <kfree>
}
    80000a0c:	70a2                	ld	ra,40(sp)
    80000a0e:	7402                	ld	s0,32(sp)
    80000a10:	64e2                	ld	s1,24(sp)
    80000a12:	6942                	ld	s2,16(sp)
    80000a14:	69a2                	ld	s3,8(sp)
    80000a16:	6a02                	ld	s4,0(sp)
    80000a18:	6145                	addi	sp,sp,48
    80000a1a:	8082                	ret

0000000080000a1c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a1c:	1101                	addi	sp,sp,-32
    80000a1e:	ec06                	sd	ra,24(sp)
    80000a20:	e822                	sd	s0,16(sp)
    80000a22:	e426                	sd	s1,8(sp)
    80000a24:	1000                	addi	s0,sp,32
    80000a26:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a28:	e999                	bnez	a1,80000a3e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a2a:	8526                	mv	a0,s1
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	f86080e7          	jalr	-122(ra) # 800009b2 <freewalk>
}
    80000a34:	60e2                	ld	ra,24(sp)
    80000a36:	6442                	ld	s0,16(sp)
    80000a38:	64a2                	ld	s1,8(sp)
    80000a3a:	6105                	addi	sp,sp,32
    80000a3c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3e:	6605                	lui	a2,0x1
    80000a40:	167d                	addi	a2,a2,-1
    80000a42:	962e                	add	a2,a2,a1
    80000a44:	4685                	li	a3,1
    80000a46:	8231                	srli	a2,a2,0xc
    80000a48:	4581                	li	a1,0
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	cfe080e7          	jalr	-770(ra) # 80000748 <uvmunmap>
    80000a52:	bfe1                	j	80000a2a <uvmfree+0xe>

0000000080000a54 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a54:	c679                	beqz	a2,80000b22 <uvmcopy+0xce>
{
    80000a56:	715d                	addi	sp,sp,-80
    80000a58:	e486                	sd	ra,72(sp)
    80000a5a:	e0a2                	sd	s0,64(sp)
    80000a5c:	fc26                	sd	s1,56(sp)
    80000a5e:	f84a                	sd	s2,48(sp)
    80000a60:	f44e                	sd	s3,40(sp)
    80000a62:	f052                	sd	s4,32(sp)
    80000a64:	ec56                	sd	s5,24(sp)
    80000a66:	e85a                	sd	s6,16(sp)
    80000a68:	e45e                	sd	s7,8(sp)
    80000a6a:	0880                	addi	s0,sp,80
    80000a6c:	8b2a                	mv	s6,a0
    80000a6e:	8aae                	mv	s5,a1
    80000a70:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a72:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a74:	4601                	li	a2,0
    80000a76:	85ce                	mv	a1,s3
    80000a78:	855a                	mv	a0,s6
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	a02080e7          	jalr	-1534(ra) # 8000047c <walk>
    80000a82:	c531                	beqz	a0,80000ace <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a84:	6118                	ld	a4,0(a0)
    80000a86:	00177793          	andi	a5,a4,1
    80000a8a:	cbb1                	beqz	a5,80000ade <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a8c:	00a75593          	srli	a1,a4,0xa
    80000a90:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a94:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a98:	fffff097          	auipc	ra,0xfffff
    80000a9c:	680080e7          	jalr	1664(ra) # 80000118 <kalloc>
    80000aa0:	892a                	mv	s2,a0
    80000aa2:	c939                	beqz	a0,80000af8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa4:	6605                	lui	a2,0x1
    80000aa6:	85de                	mv	a1,s7
    80000aa8:	fffff097          	auipc	ra,0xfffff
    80000aac:	730080e7          	jalr	1840(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab0:	8726                	mv	a4,s1
    80000ab2:	86ca                	mv	a3,s2
    80000ab4:	6605                	lui	a2,0x1
    80000ab6:	85ce                	mv	a1,s3
    80000ab8:	8556                	mv	a0,s5
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	aaa080e7          	jalr	-1366(ra) # 80000564 <mappages>
    80000ac2:	e515                	bnez	a0,80000aee <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac4:	6785                	lui	a5,0x1
    80000ac6:	99be                	add	s3,s3,a5
    80000ac8:	fb49e6e3          	bltu	s3,s4,80000a74 <uvmcopy+0x20>
    80000acc:	a081                	j	80000b0c <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ace:	00008517          	auipc	a0,0x8
    80000ad2:	63250513          	addi	a0,a0,1586 # 80009100 <etext+0x100>
    80000ad6:	00006097          	auipc	ra,0x6
    80000ada:	138080e7          	jalr	312(ra) # 80006c0e <panic>
      panic("uvmcopy: page not present");
    80000ade:	00008517          	auipc	a0,0x8
    80000ae2:	64250513          	addi	a0,a0,1602 # 80009120 <etext+0x120>
    80000ae6:	00006097          	auipc	ra,0x6
    80000aea:	128080e7          	jalr	296(ra) # 80006c0e <panic>
      kfree(mem);
    80000aee:	854a                	mv	a0,s2
    80000af0:	fffff097          	auipc	ra,0xfffff
    80000af4:	52c080e7          	jalr	1324(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af8:	4685                	li	a3,1
    80000afa:	00c9d613          	srli	a2,s3,0xc
    80000afe:	4581                	li	a1,0
    80000b00:	8556                	mv	a0,s5
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	c46080e7          	jalr	-954(ra) # 80000748 <uvmunmap>
  return -1;
    80000b0a:	557d                	li	a0,-1
}
    80000b0c:	60a6                	ld	ra,72(sp)
    80000b0e:	6406                	ld	s0,64(sp)
    80000b10:	74e2                	ld	s1,56(sp)
    80000b12:	7942                	ld	s2,48(sp)
    80000b14:	79a2                	ld	s3,40(sp)
    80000b16:	7a02                	ld	s4,32(sp)
    80000b18:	6ae2                	ld	s5,24(sp)
    80000b1a:	6b42                	ld	s6,16(sp)
    80000b1c:	6ba2                	ld	s7,8(sp)
    80000b1e:	6161                	addi	sp,sp,80
    80000b20:	8082                	ret
  return 0;
    80000b22:	4501                	li	a0,0
}
    80000b24:	8082                	ret

0000000080000b26 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b26:	1141                	addi	sp,sp,-16
    80000b28:	e406                	sd	ra,8(sp)
    80000b2a:	e022                	sd	s0,0(sp)
    80000b2c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2e:	4601                	li	a2,0
    80000b30:	00000097          	auipc	ra,0x0
    80000b34:	94c080e7          	jalr	-1716(ra) # 8000047c <walk>
  if(pte == 0)
    80000b38:	c901                	beqz	a0,80000b48 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b3a:	611c                	ld	a5,0(a0)
    80000b3c:	9bbd                	andi	a5,a5,-17
    80000b3e:	e11c                	sd	a5,0(a0)
}
    80000b40:	60a2                	ld	ra,8(sp)
    80000b42:	6402                	ld	s0,0(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret
    panic("uvmclear");
    80000b48:	00008517          	auipc	a0,0x8
    80000b4c:	5f850513          	addi	a0,a0,1528 # 80009140 <etext+0x140>
    80000b50:	00006097          	auipc	ra,0x6
    80000b54:	0be080e7          	jalr	190(ra) # 80006c0e <panic>

0000000080000b58 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b58:	c6bd                	beqz	a3,80000bc6 <copyout+0x6e>
{
    80000b5a:	715d                	addi	sp,sp,-80
    80000b5c:	e486                	sd	ra,72(sp)
    80000b5e:	e0a2                	sd	s0,64(sp)
    80000b60:	fc26                	sd	s1,56(sp)
    80000b62:	f84a                	sd	s2,48(sp)
    80000b64:	f44e                	sd	s3,40(sp)
    80000b66:	f052                	sd	s4,32(sp)
    80000b68:	ec56                	sd	s5,24(sp)
    80000b6a:	e85a                	sd	s6,16(sp)
    80000b6c:	e45e                	sd	s7,8(sp)
    80000b6e:	e062                	sd	s8,0(sp)
    80000b70:	0880                	addi	s0,sp,80
    80000b72:	8b2a                	mv	s6,a0
    80000b74:	8c2e                	mv	s8,a1
    80000b76:	8a32                	mv	s4,a2
    80000b78:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b7a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b7c:	6a85                	lui	s5,0x1
    80000b7e:	a015                	j	80000ba2 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b80:	9562                	add	a0,a0,s8
    80000b82:	0004861b          	sext.w	a2,s1
    80000b86:	85d2                	mv	a1,s4
    80000b88:	41250533          	sub	a0,a0,s2
    80000b8c:	fffff097          	auipc	ra,0xfffff
    80000b90:	64c080e7          	jalr	1612(ra) # 800001d8 <memmove>

    len -= n;
    80000b94:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b98:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b9a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9e:	02098263          	beqz	s3,80000bc2 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000ba2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba6:	85ca                	mv	a1,s2
    80000ba8:	855a                	mv	a0,s6
    80000baa:	00000097          	auipc	ra,0x0
    80000bae:	978080e7          	jalr	-1672(ra) # 80000522 <walkaddr>
    if(pa0 == 0)
    80000bb2:	cd01                	beqz	a0,80000bca <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb4:	418904b3          	sub	s1,s2,s8
    80000bb8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bba:	fc99f3e3          	bgeu	s3,s1,80000b80 <copyout+0x28>
    80000bbe:	84ce                	mv	s1,s3
    80000bc0:	b7c1                	j	80000b80 <copyout+0x28>
  }
  return 0;
    80000bc2:	4501                	li	a0,0
    80000bc4:	a021                	j	80000bcc <copyout+0x74>
    80000bc6:	4501                	li	a0,0
}
    80000bc8:	8082                	ret
      return -1;
    80000bca:	557d                	li	a0,-1
}
    80000bcc:	60a6                	ld	ra,72(sp)
    80000bce:	6406                	ld	s0,64(sp)
    80000bd0:	74e2                	ld	s1,56(sp)
    80000bd2:	7942                	ld	s2,48(sp)
    80000bd4:	79a2                	ld	s3,40(sp)
    80000bd6:	7a02                	ld	s4,32(sp)
    80000bd8:	6ae2                	ld	s5,24(sp)
    80000bda:	6b42                	ld	s6,16(sp)
    80000bdc:	6ba2                	ld	s7,8(sp)
    80000bde:	6c02                	ld	s8,0(sp)
    80000be0:	6161                	addi	sp,sp,80
    80000be2:	8082                	ret

0000000080000be4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000be4:	c6bd                	beqz	a3,80000c52 <copyin+0x6e>
{
    80000be6:	715d                	addi	sp,sp,-80
    80000be8:	e486                	sd	ra,72(sp)
    80000bea:	e0a2                	sd	s0,64(sp)
    80000bec:	fc26                	sd	s1,56(sp)
    80000bee:	f84a                	sd	s2,48(sp)
    80000bf0:	f44e                	sd	s3,40(sp)
    80000bf2:	f052                	sd	s4,32(sp)
    80000bf4:	ec56                	sd	s5,24(sp)
    80000bf6:	e85a                	sd	s6,16(sp)
    80000bf8:	e45e                	sd	s7,8(sp)
    80000bfa:	e062                	sd	s8,0(sp)
    80000bfc:	0880                	addi	s0,sp,80
    80000bfe:	8b2a                	mv	s6,a0
    80000c00:	8a2e                	mv	s4,a1
    80000c02:	8c32                	mv	s8,a2
    80000c04:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c06:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c08:	6a85                	lui	s5,0x1
    80000c0a:	a015                	j	80000c2e <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c0c:	9562                	add	a0,a0,s8
    80000c0e:	0004861b          	sext.w	a2,s1
    80000c12:	412505b3          	sub	a1,a0,s2
    80000c16:	8552                	mv	a0,s4
    80000c18:	fffff097          	auipc	ra,0xfffff
    80000c1c:	5c0080e7          	jalr	1472(ra) # 800001d8 <memmove>

    len -= n;
    80000c20:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c24:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c26:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c2a:	02098263          	beqz	s3,80000c4e <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c32:	85ca                	mv	a1,s2
    80000c34:	855a                	mv	a0,s6
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	8ec080e7          	jalr	-1812(ra) # 80000522 <walkaddr>
    if(pa0 == 0)
    80000c3e:	cd01                	beqz	a0,80000c56 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c40:	418904b3          	sub	s1,s2,s8
    80000c44:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c46:	fc99f3e3          	bgeu	s3,s1,80000c0c <copyin+0x28>
    80000c4a:	84ce                	mv	s1,s3
    80000c4c:	b7c1                	j	80000c0c <copyin+0x28>
  }
  return 0;
    80000c4e:	4501                	li	a0,0
    80000c50:	a021                	j	80000c58 <copyin+0x74>
    80000c52:	4501                	li	a0,0
}
    80000c54:	8082                	ret
      return -1;
    80000c56:	557d                	li	a0,-1
}
    80000c58:	60a6                	ld	ra,72(sp)
    80000c5a:	6406                	ld	s0,64(sp)
    80000c5c:	74e2                	ld	s1,56(sp)
    80000c5e:	7942                	ld	s2,48(sp)
    80000c60:	79a2                	ld	s3,40(sp)
    80000c62:	7a02                	ld	s4,32(sp)
    80000c64:	6ae2                	ld	s5,24(sp)
    80000c66:	6b42                	ld	s6,16(sp)
    80000c68:	6ba2                	ld	s7,8(sp)
    80000c6a:	6c02                	ld	s8,0(sp)
    80000c6c:	6161                	addi	sp,sp,80
    80000c6e:	8082                	ret

0000000080000c70 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c70:	c6c5                	beqz	a3,80000d18 <copyinstr+0xa8>
{
    80000c72:	715d                	addi	sp,sp,-80
    80000c74:	e486                	sd	ra,72(sp)
    80000c76:	e0a2                	sd	s0,64(sp)
    80000c78:	fc26                	sd	s1,56(sp)
    80000c7a:	f84a                	sd	s2,48(sp)
    80000c7c:	f44e                	sd	s3,40(sp)
    80000c7e:	f052                	sd	s4,32(sp)
    80000c80:	ec56                	sd	s5,24(sp)
    80000c82:	e85a                	sd	s6,16(sp)
    80000c84:	e45e                	sd	s7,8(sp)
    80000c86:	0880                	addi	s0,sp,80
    80000c88:	8a2a                	mv	s4,a0
    80000c8a:	8b2e                	mv	s6,a1
    80000c8c:	8bb2                	mv	s7,a2
    80000c8e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c90:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c92:	6985                	lui	s3,0x1
    80000c94:	a035                	j	80000cc0 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c96:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c9a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c9c:	0017b793          	seqz	a5,a5
    80000ca0:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca4:	60a6                	ld	ra,72(sp)
    80000ca6:	6406                	ld	s0,64(sp)
    80000ca8:	74e2                	ld	s1,56(sp)
    80000caa:	7942                	ld	s2,48(sp)
    80000cac:	79a2                	ld	s3,40(sp)
    80000cae:	7a02                	ld	s4,32(sp)
    80000cb0:	6ae2                	ld	s5,24(sp)
    80000cb2:	6b42                	ld	s6,16(sp)
    80000cb4:	6ba2                	ld	s7,8(sp)
    80000cb6:	6161                	addi	sp,sp,80
    80000cb8:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cba:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cbe:	c8a9                	beqz	s1,80000d10 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cc0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc4:	85ca                	mv	a1,s2
    80000cc6:	8552                	mv	a0,s4
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	85a080e7          	jalr	-1958(ra) # 80000522 <walkaddr>
    if(pa0 == 0)
    80000cd0:	c131                	beqz	a0,80000d14 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cd2:	41790833          	sub	a6,s2,s7
    80000cd6:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd8:	0104f363          	bgeu	s1,a6,80000cde <copyinstr+0x6e>
    80000cdc:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cde:	955e                	add	a0,a0,s7
    80000ce0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce4:	fc080be3          	beqz	a6,80000cba <copyinstr+0x4a>
    80000ce8:	985a                	add	a6,a6,s6
    80000cea:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cec:	41650633          	sub	a2,a0,s6
    80000cf0:	14fd                	addi	s1,s1,-1
    80000cf2:	9b26                	add	s6,s6,s1
    80000cf4:	00f60733          	add	a4,a2,a5
    80000cf8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd7a80>
    80000cfc:	df49                	beqz	a4,80000c96 <copyinstr+0x26>
        *dst = *p;
    80000cfe:	00e78023          	sb	a4,0(a5)
      --max;
    80000d02:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d06:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d08:	ff0796e3          	bne	a5,a6,80000cf4 <copyinstr+0x84>
      dst++;
    80000d0c:	8b42                	mv	s6,a6
    80000d0e:	b775                	j	80000cba <copyinstr+0x4a>
    80000d10:	4781                	li	a5,0
    80000d12:	b769                	j	80000c9c <copyinstr+0x2c>
      return -1;
    80000d14:	557d                	li	a0,-1
    80000d16:	b779                	j	80000ca4 <copyinstr+0x34>
  int got_null = 0;
    80000d18:	4781                	li	a5,0
  if(got_null){
    80000d1a:	0017b793          	seqz	a5,a5
    80000d1e:	40f00533          	neg	a0,a5
}
    80000d22:	8082                	ret

0000000080000d24 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80000d24:	1101                	addi	sp,sp,-32
    80000d26:	ec06                	sd	ra,24(sp)
    80000d28:	e822                	sd	s0,16(sp)
    80000d2a:	e426                	sd	s1,8(sp)
    80000d2c:	1000                	addi	s0,sp,32
    80000d2e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80000d30:	00006097          	auipc	ra,0x6
    80000d34:	3ae080e7          	jalr	942(ra) # 800070de <holding>
    80000d38:	c909                	beqz	a0,80000d4a <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80000d3a:	749c                	ld	a5,40(s1)
    80000d3c:	00978f63          	beq	a5,s1,80000d5a <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80000d40:	60e2                	ld	ra,24(sp)
    80000d42:	6442                	ld	s0,16(sp)
    80000d44:	64a2                	ld	s1,8(sp)
    80000d46:	6105                	addi	sp,sp,32
    80000d48:	8082                	ret
    panic("wakeup1");
    80000d4a:	00008517          	auipc	a0,0x8
    80000d4e:	40650513          	addi	a0,a0,1030 # 80009150 <etext+0x150>
    80000d52:	00006097          	auipc	ra,0x6
    80000d56:	ebc080e7          	jalr	-324(ra) # 80006c0e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80000d5a:	4c98                	lw	a4,24(s1)
    80000d5c:	4785                	li	a5,1
    80000d5e:	fef711e3          	bne	a4,a5,80000d40 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80000d62:	4789                	li	a5,2
    80000d64:	cc9c                	sw	a5,24(s1)
}
    80000d66:	bfe9                	j	80000d40 <wakeup1+0x1c>

0000000080000d68 <proc_mapstacks>:
proc_mapstacks(pagetable_t kpgtbl) {
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
    80000d7c:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d7e:	00009497          	auipc	s1,0x9
    80000d82:	70a48493          	addi	s1,s1,1802 # 8000a488 <proc>
    uint64 va = KSTACK((int) (p - proc));
    80000d86:	8b26                	mv	s6,s1
    80000d88:	00008a97          	auipc	s5,0x8
    80000d8c:	278a8a93          	addi	s5,s5,632 # 80009000 <etext>
    80000d90:	04000937          	lui	s2,0x4000
    80000d94:	197d                	addi	s2,s2,-1
    80000d96:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d98:	0000fa17          	auipc	s4,0xf
    80000d9c:	0f0a0a13          	addi	s4,s4,240 # 8000fe88 <tickslock>
    char *pa = kalloc();
    80000da0:	fffff097          	auipc	ra,0xfffff
    80000da4:	378080e7          	jalr	888(ra) # 80000118 <kalloc>
    80000da8:	862a                	mv	a2,a0
    if(pa == 0)
    80000daa:	c131                	beqz	a0,80000dee <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000dac:	416485b3          	sub	a1,s1,s6
    80000db0:	858d                	srai	a1,a1,0x3
    80000db2:	000ab783          	ld	a5,0(s5)
    80000db6:	02f585b3          	mul	a1,a1,a5
    80000dba:	2585                	addiw	a1,a1,1
    80000dbc:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dc0:	4719                	li	a4,6
    80000dc2:	6685                	lui	a3,0x1
    80000dc4:	40b905b3          	sub	a1,s2,a1
    80000dc8:	854e                	mv	a0,s3
    80000dca:	00000097          	auipc	ra,0x0
    80000dce:	828080e7          	jalr	-2008(ra) # 800005f2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	16848493          	addi	s1,s1,360
    80000dd6:	fd4495e3          	bne	s1,s4,80000da0 <proc_mapstacks+0x38>
}
    80000dda:	70e2                	ld	ra,56(sp)
    80000ddc:	7442                	ld	s0,48(sp)
    80000dde:	74a2                	ld	s1,40(sp)
    80000de0:	7902                	ld	s2,32(sp)
    80000de2:	69e2                	ld	s3,24(sp)
    80000de4:	6a42                	ld	s4,16(sp)
    80000de6:	6aa2                	ld	s5,8(sp)
    80000de8:	6b02                	ld	s6,0(sp)
    80000dea:	6121                	addi	sp,sp,64
    80000dec:	8082                	ret
      panic("kalloc");
    80000dee:	00008517          	auipc	a0,0x8
    80000df2:	36a50513          	addi	a0,a0,874 # 80009158 <etext+0x158>
    80000df6:	00006097          	auipc	ra,0x6
    80000dfa:	e18080e7          	jalr	-488(ra) # 80006c0e <panic>

0000000080000dfe <procinit>:
{
    80000dfe:	7139                	addi	sp,sp,-64
    80000e00:	fc06                	sd	ra,56(sp)
    80000e02:	f822                	sd	s0,48(sp)
    80000e04:	f426                	sd	s1,40(sp)
    80000e06:	f04a                	sd	s2,32(sp)
    80000e08:	ec4e                	sd	s3,24(sp)
    80000e0a:	e852                	sd	s4,16(sp)
    80000e0c:	e456                	sd	s5,8(sp)
    80000e0e:	e05a                	sd	s6,0(sp)
    80000e10:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80000e12:	00008597          	auipc	a1,0x8
    80000e16:	34e58593          	addi	a1,a1,846 # 80009160 <etext+0x160>
    80000e1a:	00009517          	auipc	a0,0x9
    80000e1e:	25650513          	addi	a0,a0,598 # 8000a070 <pid_lock>
    80000e22:	00006097          	auipc	ra,0x6
    80000e26:	2a6080e7          	jalr	678(ra) # 800070c8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2a:	00009497          	auipc	s1,0x9
    80000e2e:	65e48493          	addi	s1,s1,1630 # 8000a488 <proc>
      initlock(&p->lock, "proc");
    80000e32:	00008b17          	auipc	s6,0x8
    80000e36:	336b0b13          	addi	s6,s6,822 # 80009168 <etext+0x168>
      p->kstack = KSTACK((int) (p - proc));
    80000e3a:	8aa6                	mv	s5,s1
    80000e3c:	00008a17          	auipc	s4,0x8
    80000e40:	1c4a0a13          	addi	s4,s4,452 # 80009000 <etext>
    80000e44:	04000937          	lui	s2,0x4000
    80000e48:	197d                	addi	s2,s2,-1
    80000e4a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4c:	0000f997          	auipc	s3,0xf
    80000e50:	03c98993          	addi	s3,s3,60 # 8000fe88 <tickslock>
      initlock(&p->lock, "proc");
    80000e54:	85da                	mv	a1,s6
    80000e56:	8526                	mv	a0,s1
    80000e58:	00006097          	auipc	ra,0x6
    80000e5c:	270080e7          	jalr	624(ra) # 800070c8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e60:	415487b3          	sub	a5,s1,s5
    80000e64:	878d                	srai	a5,a5,0x3
    80000e66:	000a3703          	ld	a4,0(s4)
    80000e6a:	02e787b3          	mul	a5,a5,a4
    80000e6e:	2785                	addiw	a5,a5,1
    80000e70:	00d7979b          	slliw	a5,a5,0xd
    80000e74:	40f907b3          	sub	a5,s2,a5
    80000e78:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e7a:	16848493          	addi	s1,s1,360
    80000e7e:	fd349be3          	bne	s1,s3,80000e54 <procinit+0x56>
}
    80000e82:	70e2                	ld	ra,56(sp)
    80000e84:	7442                	ld	s0,48(sp)
    80000e86:	74a2                	ld	s1,40(sp)
    80000e88:	7902                	ld	s2,32(sp)
    80000e8a:	69e2                	ld	s3,24(sp)
    80000e8c:	6a42                	ld	s4,16(sp)
    80000e8e:	6aa2                	ld	s5,8(sp)
    80000e90:	6b02                	ld	s6,0(sp)
    80000e92:	6121                	addi	sp,sp,64
    80000e94:	8082                	ret

0000000080000e96 <cpuid>:
{
    80000e96:	1141                	addi	sp,sp,-16
    80000e98:	e422                	sd	s0,8(sp)
    80000e9a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e9c:	8512                	mv	a0,tp
}
    80000e9e:	2501                	sext.w	a0,a0
    80000ea0:	6422                	ld	s0,8(sp)
    80000ea2:	0141                	addi	sp,sp,16
    80000ea4:	8082                	ret

0000000080000ea6 <mycpu>:
mycpu(void) {
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e422                	sd	s0,8(sp)
    80000eaa:	0800                	addi	s0,sp,16
    80000eac:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80000eae:	2781                	sext.w	a5,a5
    80000eb0:	079e                	slli	a5,a5,0x7
}
    80000eb2:	00009517          	auipc	a0,0x9
    80000eb6:	1d650513          	addi	a0,a0,470 # 8000a088 <cpus>
    80000eba:	953e                	add	a0,a0,a5
    80000ebc:	6422                	ld	s0,8(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret

0000000080000ec2 <myproc>:
myproc(void) {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	1000                	addi	s0,sp,32
  push_off();
    80000ecc:	00006097          	auipc	ra,0x6
    80000ed0:	240080e7          	jalr	576(ra) # 8000710c <push_off>
    80000ed4:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80000ed6:	2781                	sext.w	a5,a5
    80000ed8:	079e                	slli	a5,a5,0x7
    80000eda:	00009717          	auipc	a4,0x9
    80000ede:	19670713          	addi	a4,a4,406 # 8000a070 <pid_lock>
    80000ee2:	97ba                	add	a5,a5,a4
    80000ee4:	6f84                	ld	s1,24(a5)
  pop_off();
    80000ee6:	00006097          	auipc	ra,0x6
    80000eea:	2c6080e7          	jalr	710(ra) # 800071ac <pop_off>
}
    80000eee:	8526                	mv	a0,s1
    80000ef0:	60e2                	ld	ra,24(sp)
    80000ef2:	6442                	ld	s0,16(sp)
    80000ef4:	64a2                	ld	s1,8(sp)
    80000ef6:	6105                	addi	sp,sp,32
    80000ef8:	8082                	ret

0000000080000efa <forkret>:
{
    80000efa:	1141                	addi	sp,sp,-16
    80000efc:	e406                	sd	ra,8(sp)
    80000efe:	e022                	sd	s0,0(sp)
    80000f00:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80000f02:	00000097          	auipc	ra,0x0
    80000f06:	fc0080e7          	jalr	-64(ra) # 80000ec2 <myproc>
    80000f0a:	00006097          	auipc	ra,0x6
    80000f0e:	302080e7          	jalr	770(ra) # 8000720c <release>
  if (first) {
    80000f12:	00009797          	auipc	a5,0x9
    80000f16:	96e7a783          	lw	a5,-1682(a5) # 80009880 <first.1720>
    80000f1a:	eb89                	bnez	a5,80000f2c <forkret+0x32>
  usertrapret();
    80000f1c:	00001097          	auipc	ra,0x1
    80000f20:	c1c080e7          	jalr	-996(ra) # 80001b38 <usertrapret>
}
    80000f24:	60a2                	ld	ra,8(sp)
    80000f26:	6402                	ld	s0,0(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret
    first = 0;
    80000f2c:	00009797          	auipc	a5,0x9
    80000f30:	9407aa23          	sw	zero,-1708(a5) # 80009880 <first.1720>
    fsinit(ROOTDEV);
    80000f34:	4505                	li	a0,1
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	974080e7          	jalr	-1676(ra) # 800028aa <fsinit>
    80000f3e:	bff9                	j	80000f1c <forkret+0x22>

0000000080000f40 <allocpid>:
allocpid() {
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f4c:	00009917          	auipc	s2,0x9
    80000f50:	12490913          	addi	s2,s2,292 # 8000a070 <pid_lock>
    80000f54:	854a                	mv	a0,s2
    80000f56:	00006097          	auipc	ra,0x6
    80000f5a:	202080e7          	jalr	514(ra) # 80007158 <acquire>
  pid = nextpid;
    80000f5e:	00009797          	auipc	a5,0x9
    80000f62:	92678793          	addi	a5,a5,-1754 # 80009884 <nextpid>
    80000f66:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f68:	0014871b          	addiw	a4,s1,1
    80000f6c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f6e:	854a                	mv	a0,s2
    80000f70:	00006097          	auipc	ra,0x6
    80000f74:	29c080e7          	jalr	668(ra) # 8000720c <release>
}
    80000f78:	8526                	mv	a0,s1
    80000f7a:	60e2                	ld	ra,24(sp)
    80000f7c:	6442                	ld	s0,16(sp)
    80000f7e:	64a2                	ld	s1,8(sp)
    80000f80:	6902                	ld	s2,0(sp)
    80000f82:	6105                	addi	sp,sp,32
    80000f84:	8082                	ret

0000000080000f86 <proc_pagetable>:
{
    80000f86:	1101                	addi	sp,sp,-32
    80000f88:	ec06                	sd	ra,24(sp)
    80000f8a:	e822                	sd	s0,16(sp)
    80000f8c:	e426                	sd	s1,8(sp)
    80000f8e:	e04a                	sd	s2,0(sp)
    80000f90:	1000                	addi	s0,sp,32
    80000f92:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f94:	00000097          	auipc	ra,0x0
    80000f98:	88c080e7          	jalr	-1908(ra) # 80000820 <uvmcreate>
    80000f9c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f9e:	c121                	beqz	a0,80000fde <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fa0:	4729                	li	a4,10
    80000fa2:	00007697          	auipc	a3,0x7
    80000fa6:	05e68693          	addi	a3,a3,94 # 80008000 <_trampoline>
    80000faa:	6605                	lui	a2,0x1
    80000fac:	040005b7          	lui	a1,0x4000
    80000fb0:	15fd                	addi	a1,a1,-1
    80000fb2:	05b2                	slli	a1,a1,0xc
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	5b0080e7          	jalr	1456(ra) # 80000564 <mappages>
    80000fbc:	02054863          	bltz	a0,80000fec <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fc0:	4719                	li	a4,6
    80000fc2:	05893683          	ld	a3,88(s2)
    80000fc6:	6605                	lui	a2,0x1
    80000fc8:	020005b7          	lui	a1,0x2000
    80000fcc:	15fd                	addi	a1,a1,-1
    80000fce:	05b6                	slli	a1,a1,0xd
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	fffff097          	auipc	ra,0xfffff
    80000fd6:	592080e7          	jalr	1426(ra) # 80000564 <mappages>
    80000fda:	02054163          	bltz	a0,80000ffc <proc_pagetable+0x76>
}
    80000fde:	8526                	mv	a0,s1
    80000fe0:	60e2                	ld	ra,24(sp)
    80000fe2:	6442                	ld	s0,16(sp)
    80000fe4:	64a2                	ld	s1,8(sp)
    80000fe6:	6902                	ld	s2,0(sp)
    80000fe8:	6105                	addi	sp,sp,32
    80000fea:	8082                	ret
    uvmfree(pagetable, 0);
    80000fec:	4581                	li	a1,0
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	a2c080e7          	jalr	-1492(ra) # 80000a1c <uvmfree>
    return 0;
    80000ff8:	4481                	li	s1,0
    80000ffa:	b7d5                	j	80000fde <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ffc:	4681                	li	a3,0
    80000ffe:	4605                	li	a2,1
    80001000:	040005b7          	lui	a1,0x4000
    80001004:	15fd                	addi	a1,a1,-1
    80001006:	05b2                	slli	a1,a1,0xc
    80001008:	8526                	mv	a0,s1
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	73e080e7          	jalr	1854(ra) # 80000748 <uvmunmap>
    uvmfree(pagetable, 0);
    80001012:	4581                	li	a1,0
    80001014:	8526                	mv	a0,s1
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	a06080e7          	jalr	-1530(ra) # 80000a1c <uvmfree>
    return 0;
    8000101e:	4481                	li	s1,0
    80001020:	bf7d                	j	80000fde <proc_pagetable+0x58>

0000000080001022 <proc_freepagetable>:
{
    80001022:	1101                	addi	sp,sp,-32
    80001024:	ec06                	sd	ra,24(sp)
    80001026:	e822                	sd	s0,16(sp)
    80001028:	e426                	sd	s1,8(sp)
    8000102a:	e04a                	sd	s2,0(sp)
    8000102c:	1000                	addi	s0,sp,32
    8000102e:	84aa                	mv	s1,a0
    80001030:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001032:	4681                	li	a3,0
    80001034:	4605                	li	a2,1
    80001036:	040005b7          	lui	a1,0x4000
    8000103a:	15fd                	addi	a1,a1,-1
    8000103c:	05b2                	slli	a1,a1,0xc
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	70a080e7          	jalr	1802(ra) # 80000748 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001046:	4681                	li	a3,0
    80001048:	4605                	li	a2,1
    8000104a:	020005b7          	lui	a1,0x2000
    8000104e:	15fd                	addi	a1,a1,-1
    80001050:	05b6                	slli	a1,a1,0xd
    80001052:	8526                	mv	a0,s1
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	6f4080e7          	jalr	1780(ra) # 80000748 <uvmunmap>
  uvmfree(pagetable, sz);
    8000105c:	85ca                	mv	a1,s2
    8000105e:	8526                	mv	a0,s1
    80001060:	00000097          	auipc	ra,0x0
    80001064:	9bc080e7          	jalr	-1604(ra) # 80000a1c <uvmfree>
}
    80001068:	60e2                	ld	ra,24(sp)
    8000106a:	6442                	ld	s0,16(sp)
    8000106c:	64a2                	ld	s1,8(sp)
    8000106e:	6902                	ld	s2,0(sp)
    80001070:	6105                	addi	sp,sp,32
    80001072:	8082                	ret

0000000080001074 <freeproc>:
{
    80001074:	1101                	addi	sp,sp,-32
    80001076:	ec06                	sd	ra,24(sp)
    80001078:	e822                	sd	s0,16(sp)
    8000107a:	e426                	sd	s1,8(sp)
    8000107c:	1000                	addi	s0,sp,32
    8000107e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001080:	6d28                	ld	a0,88(a0)
    80001082:	c509                	beqz	a0,8000108c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001084:	fffff097          	auipc	ra,0xfffff
    80001088:	f98080e7          	jalr	-104(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000108c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001090:	68a8                	ld	a0,80(s1)
    80001092:	c511                	beqz	a0,8000109e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001094:	64ac                	ld	a1,72(s1)
    80001096:	00000097          	auipc	ra,0x0
    8000109a:	f8c080e7          	jalr	-116(ra) # 80001022 <proc_freepagetable>
  p->pagetable = 0;
    8000109e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010a2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010a6:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800010aa:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    800010ae:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010b2:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800010b6:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800010ba:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800010be:	0004ac23          	sw	zero,24(s1)
}
    800010c2:	60e2                	ld	ra,24(sp)
    800010c4:	6442                	ld	s0,16(sp)
    800010c6:	64a2                	ld	s1,8(sp)
    800010c8:	6105                	addi	sp,sp,32
    800010ca:	8082                	ret

00000000800010cc <allocproc>:
{
    800010cc:	1101                	addi	sp,sp,-32
    800010ce:	ec06                	sd	ra,24(sp)
    800010d0:	e822                	sd	s0,16(sp)
    800010d2:	e426                	sd	s1,8(sp)
    800010d4:	e04a                	sd	s2,0(sp)
    800010d6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d8:	00009497          	auipc	s1,0x9
    800010dc:	3b048493          	addi	s1,s1,944 # 8000a488 <proc>
    800010e0:	0000f917          	auipc	s2,0xf
    800010e4:	da890913          	addi	s2,s2,-600 # 8000fe88 <tickslock>
    acquire(&p->lock);
    800010e8:	8526                	mv	a0,s1
    800010ea:	00006097          	auipc	ra,0x6
    800010ee:	06e080e7          	jalr	110(ra) # 80007158 <acquire>
    if(p->state == UNUSED) {
    800010f2:	4c9c                	lw	a5,24(s1)
    800010f4:	cf81                	beqz	a5,8000110c <allocproc+0x40>
      release(&p->lock);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00006097          	auipc	ra,0x6
    800010fc:	114080e7          	jalr	276(ra) # 8000720c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001100:	16848493          	addi	s1,s1,360
    80001104:	ff2492e3          	bne	s1,s2,800010e8 <allocproc+0x1c>
  return 0;
    80001108:	4481                	li	s1,0
    8000110a:	a0b9                	j	80001158 <allocproc+0x8c>
  p->pid = allocpid();
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	e34080e7          	jalr	-460(ra) # 80000f40 <allocpid>
    80001114:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	002080e7          	jalr	2(ra) # 80000118 <kalloc>
    8000111e:	892a                	mv	s2,a0
    80001120:	eca8                	sd	a0,88(s1)
    80001122:	c131                	beqz	a0,80001166 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	e60080e7          	jalr	-416(ra) # 80000f86 <proc_pagetable>
    8000112e:	892a                	mv	s2,a0
    80001130:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001132:	c129                	beqz	a0,80001174 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001134:	07000613          	li	a2,112
    80001138:	4581                	li	a1,0
    8000113a:	06048513          	addi	a0,s1,96
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	03a080e7          	jalr	58(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001146:	00000797          	auipc	a5,0x0
    8000114a:	db478793          	addi	a5,a5,-588 # 80000efa <forkret>
    8000114e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001150:	60bc                	ld	a5,64(s1)
    80001152:	6705                	lui	a4,0x1
    80001154:	97ba                	add	a5,a5,a4
    80001156:	f4bc                	sd	a5,104(s1)
}
    80001158:	8526                	mv	a0,s1
    8000115a:	60e2                	ld	ra,24(sp)
    8000115c:	6442                	ld	s0,16(sp)
    8000115e:	64a2                	ld	s1,8(sp)
    80001160:	6902                	ld	s2,0(sp)
    80001162:	6105                	addi	sp,sp,32
    80001164:	8082                	ret
    release(&p->lock);
    80001166:	8526                	mv	a0,s1
    80001168:	00006097          	auipc	ra,0x6
    8000116c:	0a4080e7          	jalr	164(ra) # 8000720c <release>
    return 0;
    80001170:	84ca                	mv	s1,s2
    80001172:	b7dd                	j	80001158 <allocproc+0x8c>
    freeproc(p);
    80001174:	8526                	mv	a0,s1
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	efe080e7          	jalr	-258(ra) # 80001074 <freeproc>
    release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00006097          	auipc	ra,0x6
    80001184:	08c080e7          	jalr	140(ra) # 8000720c <release>
    return 0;
    80001188:	84ca                	mv	s1,s2
    8000118a:	b7f9                	j	80001158 <allocproc+0x8c>

000000008000118c <userinit>:
{
    8000118c:	1101                	addi	sp,sp,-32
    8000118e:	ec06                	sd	ra,24(sp)
    80001190:	e822                	sd	s0,16(sp)
    80001192:	e426                	sd	s1,8(sp)
    80001194:	1000                	addi	s0,sp,32
  p = allocproc();
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	f36080e7          	jalr	-202(ra) # 800010cc <allocproc>
    8000119e:	84aa                	mv	s1,a0
  initproc = p;
    800011a0:	00009797          	auipc	a5,0x9
    800011a4:	e6a7b823          	sd	a0,-400(a5) # 8000a010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011a8:	03400613          	li	a2,52
    800011ac:	00008597          	auipc	a1,0x8
    800011b0:	6f458593          	addi	a1,a1,1780 # 800098a0 <initcode>
    800011b4:	6928                	ld	a0,80(a0)
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	698080e7          	jalr	1688(ra) # 8000084e <uvminit>
  p->sz = PGSIZE;
    800011be:	6785                	lui	a5,0x1
    800011c0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011c2:	6cb8                	ld	a4,88(s1)
    800011c4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c8:	6cb8                	ld	a4,88(s1)
    800011ca:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011cc:	4641                	li	a2,16
    800011ce:	00008597          	auipc	a1,0x8
    800011d2:	fa258593          	addi	a1,a1,-94 # 80009170 <etext+0x170>
    800011d6:	15848513          	addi	a0,s1,344
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	0f4080e7          	jalr	244(ra) # 800002ce <safestrcpy>
  p->cwd = namei("/");
    800011e2:	00008517          	auipc	a0,0x8
    800011e6:	f9e50513          	addi	a0,a0,-98 # 80009180 <etext+0x180>
    800011ea:	00002097          	auipc	ra,0x2
    800011ee:	0ee080e7          	jalr	238(ra) # 800032d8 <namei>
    800011f2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f6:	4789                	li	a5,2
    800011f8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011fa:	8526                	mv	a0,s1
    800011fc:	00006097          	auipc	ra,0x6
    80001200:	010080e7          	jalr	16(ra) # 8000720c <release>
}
    80001204:	60e2                	ld	ra,24(sp)
    80001206:	6442                	ld	s0,16(sp)
    80001208:	64a2                	ld	s1,8(sp)
    8000120a:	6105                	addi	sp,sp,32
    8000120c:	8082                	ret

000000008000120e <growproc>:
{
    8000120e:	1101                	addi	sp,sp,-32
    80001210:	ec06                	sd	ra,24(sp)
    80001212:	e822                	sd	s0,16(sp)
    80001214:	e426                	sd	s1,8(sp)
    80001216:	e04a                	sd	s2,0(sp)
    80001218:	1000                	addi	s0,sp,32
    8000121a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	ca6080e7          	jalr	-858(ra) # 80000ec2 <myproc>
    80001224:	892a                	mv	s2,a0
  sz = p->sz;
    80001226:	652c                	ld	a1,72(a0)
    80001228:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000122c:	00904f63          	bgtz	s1,8000124a <growproc+0x3c>
  } else if(n < 0){
    80001230:	0204cc63          	bltz	s1,80001268 <growproc+0x5a>
  p->sz = sz;
    80001234:	1602                	slli	a2,a2,0x20
    80001236:	9201                	srli	a2,a2,0x20
    80001238:	04c93423          	sd	a2,72(s2)
  return 0;
    8000123c:	4501                	li	a0,0
}
    8000123e:	60e2                	ld	ra,24(sp)
    80001240:	6442                	ld	s0,16(sp)
    80001242:	64a2                	ld	s1,8(sp)
    80001244:	6902                	ld	s2,0(sp)
    80001246:	6105                	addi	sp,sp,32
    80001248:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000124a:	9e25                	addw	a2,a2,s1
    8000124c:	1602                	slli	a2,a2,0x20
    8000124e:	9201                	srli	a2,a2,0x20
    80001250:	1582                	slli	a1,a1,0x20
    80001252:	9181                	srli	a1,a1,0x20
    80001254:	6928                	ld	a0,80(a0)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	6b2080e7          	jalr	1714(ra) # 80000908 <uvmalloc>
    8000125e:	0005061b          	sext.w	a2,a0
    80001262:	fa69                	bnez	a2,80001234 <growproc+0x26>
      return -1;
    80001264:	557d                	li	a0,-1
    80001266:	bfe1                	j	8000123e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001268:	9e25                	addw	a2,a2,s1
    8000126a:	1602                	slli	a2,a2,0x20
    8000126c:	9201                	srli	a2,a2,0x20
    8000126e:	1582                	slli	a1,a1,0x20
    80001270:	9181                	srli	a1,a1,0x20
    80001272:	6928                	ld	a0,80(a0)
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	64c080e7          	jalr	1612(ra) # 800008c0 <uvmdealloc>
    8000127c:	0005061b          	sext.w	a2,a0
    80001280:	bf55                	j	80001234 <growproc+0x26>

0000000080001282 <fork>:
{
    80001282:	7179                	addi	sp,sp,-48
    80001284:	f406                	sd	ra,40(sp)
    80001286:	f022                	sd	s0,32(sp)
    80001288:	ec26                	sd	s1,24(sp)
    8000128a:	e84a                	sd	s2,16(sp)
    8000128c:	e44e                	sd	s3,8(sp)
    8000128e:	e052                	sd	s4,0(sp)
    80001290:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001292:	00000097          	auipc	ra,0x0
    80001296:	c30080e7          	jalr	-976(ra) # 80000ec2 <myproc>
    8000129a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	e30080e7          	jalr	-464(ra) # 800010cc <allocproc>
    800012a4:	c175                	beqz	a0,80001388 <fork+0x106>
    800012a6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012a8:	04893603          	ld	a2,72(s2)
    800012ac:	692c                	ld	a1,80(a0)
    800012ae:	05093503          	ld	a0,80(s2)
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	7a2080e7          	jalr	1954(ra) # 80000a54 <uvmcopy>
    800012ba:	04054863          	bltz	a0,8000130a <fork+0x88>
  np->sz = p->sz;
    800012be:	04893783          	ld	a5,72(s2)
    800012c2:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    800012c6:	0329b023          	sd	s2,32(s3)
  *(np->trapframe) = *(p->trapframe);
    800012ca:	05893683          	ld	a3,88(s2)
    800012ce:	87b6                	mv	a5,a3
    800012d0:	0589b703          	ld	a4,88(s3)
    800012d4:	12068693          	addi	a3,a3,288
    800012d8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012dc:	6788                	ld	a0,8(a5)
    800012de:	6b8c                	ld	a1,16(a5)
    800012e0:	6f90                	ld	a2,24(a5)
    800012e2:	01073023          	sd	a6,0(a4)
    800012e6:	e708                	sd	a0,8(a4)
    800012e8:	eb0c                	sd	a1,16(a4)
    800012ea:	ef10                	sd	a2,24(a4)
    800012ec:	02078793          	addi	a5,a5,32
    800012f0:	02070713          	addi	a4,a4,32
    800012f4:	fed792e3          	bne	a5,a3,800012d8 <fork+0x56>
  np->trapframe->a0 = 0;
    800012f8:	0589b783          	ld	a5,88(s3)
    800012fc:	0607b823          	sd	zero,112(a5)
    80001300:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001304:	15000a13          	li	s4,336
    80001308:	a03d                	j	80001336 <fork+0xb4>
    freeproc(np);
    8000130a:	854e                	mv	a0,s3
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	d68080e7          	jalr	-664(ra) # 80001074 <freeproc>
    release(&np->lock);
    80001314:	854e                	mv	a0,s3
    80001316:	00006097          	auipc	ra,0x6
    8000131a:	ef6080e7          	jalr	-266(ra) # 8000720c <release>
    return -1;
    8000131e:	54fd                	li	s1,-1
    80001320:	a899                	j	80001376 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001322:	00002097          	auipc	ra,0x2
    80001326:	654080e7          	jalr	1620(ra) # 80003976 <filedup>
    8000132a:	009987b3          	add	a5,s3,s1
    8000132e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001330:	04a1                	addi	s1,s1,8
    80001332:	01448763          	beq	s1,s4,80001340 <fork+0xbe>
    if(p->ofile[i])
    80001336:	009907b3          	add	a5,s2,s1
    8000133a:	6388                	ld	a0,0(a5)
    8000133c:	f17d                	bnez	a0,80001322 <fork+0xa0>
    8000133e:	bfcd                	j	80001330 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001340:	15093503          	ld	a0,336(s2)
    80001344:	00001097          	auipc	ra,0x1
    80001348:	7a0080e7          	jalr	1952(ra) # 80002ae4 <idup>
    8000134c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001350:	4641                	li	a2,16
    80001352:	15890593          	addi	a1,s2,344
    80001356:	15898513          	addi	a0,s3,344
    8000135a:	fffff097          	auipc	ra,0xfffff
    8000135e:	f74080e7          	jalr	-140(ra) # 800002ce <safestrcpy>
  pid = np->pid;
    80001362:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001366:	4789                	li	a5,2
    80001368:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00006097          	auipc	ra,0x6
    80001372:	e9e080e7          	jalr	-354(ra) # 8000720c <release>
}
    80001376:	8526                	mv	a0,s1
    80001378:	70a2                	ld	ra,40(sp)
    8000137a:	7402                	ld	s0,32(sp)
    8000137c:	64e2                	ld	s1,24(sp)
    8000137e:	6942                	ld	s2,16(sp)
    80001380:	69a2                	ld	s3,8(sp)
    80001382:	6a02                	ld	s4,0(sp)
    80001384:	6145                	addi	sp,sp,48
    80001386:	8082                	ret
    return -1;
    80001388:	54fd                	li	s1,-1
    8000138a:	b7f5                	j	80001376 <fork+0xf4>

000000008000138c <reparent>:
{
    8000138c:	7179                	addi	sp,sp,-48
    8000138e:	f406                	sd	ra,40(sp)
    80001390:	f022                	sd	s0,32(sp)
    80001392:	ec26                	sd	s1,24(sp)
    80001394:	e84a                	sd	s2,16(sp)
    80001396:	e44e                	sd	s3,8(sp)
    80001398:	e052                	sd	s4,0(sp)
    8000139a:	1800                	addi	s0,sp,48
    8000139c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000139e:	00009497          	auipc	s1,0x9
    800013a2:	0ea48493          	addi	s1,s1,234 # 8000a488 <proc>
      pp->parent = initproc;
    800013a6:	00009a17          	auipc	s4,0x9
    800013aa:	c6aa0a13          	addi	s4,s4,-918 # 8000a010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013ae:	0000f997          	auipc	s3,0xf
    800013b2:	ada98993          	addi	s3,s3,-1318 # 8000fe88 <tickslock>
    800013b6:	a029                	j	800013c0 <reparent+0x34>
    800013b8:	16848493          	addi	s1,s1,360
    800013bc:	03348363          	beq	s1,s3,800013e2 <reparent+0x56>
    if(pp->parent == p){
    800013c0:	709c                	ld	a5,32(s1)
    800013c2:	ff279be3          	bne	a5,s2,800013b8 <reparent+0x2c>
      acquire(&pp->lock);
    800013c6:	8526                	mv	a0,s1
    800013c8:	00006097          	auipc	ra,0x6
    800013cc:	d90080e7          	jalr	-624(ra) # 80007158 <acquire>
      pp->parent = initproc;
    800013d0:	000a3783          	ld	a5,0(s4)
    800013d4:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    800013d6:	8526                	mv	a0,s1
    800013d8:	00006097          	auipc	ra,0x6
    800013dc:	e34080e7          	jalr	-460(ra) # 8000720c <release>
    800013e0:	bfe1                	j	800013b8 <reparent+0x2c>
}
    800013e2:	70a2                	ld	ra,40(sp)
    800013e4:	7402                	ld	s0,32(sp)
    800013e6:	64e2                	ld	s1,24(sp)
    800013e8:	6942                	ld	s2,16(sp)
    800013ea:	69a2                	ld	s3,8(sp)
    800013ec:	6a02                	ld	s4,0(sp)
    800013ee:	6145                	addi	sp,sp,48
    800013f0:	8082                	ret

00000000800013f2 <scheduler>:
{
    800013f2:	711d                	addi	sp,sp,-96
    800013f4:	ec86                	sd	ra,88(sp)
    800013f6:	e8a2                	sd	s0,80(sp)
    800013f8:	e4a6                	sd	s1,72(sp)
    800013fa:	e0ca                	sd	s2,64(sp)
    800013fc:	fc4e                	sd	s3,56(sp)
    800013fe:	f852                	sd	s4,48(sp)
    80001400:	f456                	sd	s5,40(sp)
    80001402:	f05a                	sd	s6,32(sp)
    80001404:	ec5e                	sd	s7,24(sp)
    80001406:	e862                	sd	s8,16(sp)
    80001408:	e466                	sd	s9,8(sp)
    8000140a:	1080                	addi	s0,sp,96
    8000140c:	8792                	mv	a5,tp
  int id = r_tp();
    8000140e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001410:	00779c13          	slli	s8,a5,0x7
    80001414:	00009717          	auipc	a4,0x9
    80001418:	c5c70713          	addi	a4,a4,-932 # 8000a070 <pid_lock>
    8000141c:	9762                	add	a4,a4,s8
    8000141e:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001422:	00009717          	auipc	a4,0x9
    80001426:	c6e70713          	addi	a4,a4,-914 # 8000a090 <cpus+0x8>
    8000142a:	9c3a                	add	s8,s8,a4
      if(p->state == RUNNABLE) {
    8000142c:	4a89                	li	s5,2
        c->proc = p;
    8000142e:	079e                	slli	a5,a5,0x7
    80001430:	00009b17          	auipc	s6,0x9
    80001434:	c40b0b13          	addi	s6,s6,-960 # 8000a070 <pid_lock>
    80001438:	9b3e                	add	s6,s6,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000143a:	0000fa17          	auipc	s4,0xf
    8000143e:	a4ea0a13          	addi	s4,s4,-1458 # 8000fe88 <tickslock>
    int nproc = 0;
    80001442:	4c81                	li	s9,0
    80001444:	a8a1                	j	8000149c <scheduler+0xaa>
        p->state = RUNNING;
    80001446:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    8000144a:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    8000144e:	06048593          	addi	a1,s1,96
    80001452:	8562                	mv	a0,s8
    80001454:	00000097          	auipc	ra,0x0
    80001458:	63a080e7          	jalr	1594(ra) # 80001a8e <swtch>
        c->proc = 0;
    8000145c:	000b3c23          	sd	zero,24(s6)
      release(&p->lock);
    80001460:	8526                	mv	a0,s1
    80001462:	00006097          	auipc	ra,0x6
    80001466:	daa080e7          	jalr	-598(ra) # 8000720c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000146a:	16848493          	addi	s1,s1,360
    8000146e:	01448d63          	beq	s1,s4,80001488 <scheduler+0x96>
      acquire(&p->lock);
    80001472:	8526                	mv	a0,s1
    80001474:	00006097          	auipc	ra,0x6
    80001478:	ce4080e7          	jalr	-796(ra) # 80007158 <acquire>
      if(p->state != UNUSED) {
    8000147c:	4c9c                	lw	a5,24(s1)
    8000147e:	d3ed                	beqz	a5,80001460 <scheduler+0x6e>
        nproc++;
    80001480:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    80001482:	fd579fe3          	bne	a5,s5,80001460 <scheduler+0x6e>
    80001486:	b7c1                	j	80001446 <scheduler+0x54>
    if(nproc <= 2) {   // only init and sh exist
    80001488:	013aca63          	blt	s5,s3,8000149c <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001490:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001494:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001498:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000149c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014a4:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    800014a8:	89e6                	mv	s3,s9
    for(p = proc; p < &proc[NPROC]; p++) {
    800014aa:	00009497          	auipc	s1,0x9
    800014ae:	fde48493          	addi	s1,s1,-34 # 8000a488 <proc>
        p->state = RUNNING;
    800014b2:	4b8d                	li	s7,3
    800014b4:	bf7d                	j	80001472 <scheduler+0x80>

00000000800014b6 <sched>:
{
    800014b6:	7179                	addi	sp,sp,-48
    800014b8:	f406                	sd	ra,40(sp)
    800014ba:	f022                	sd	s0,32(sp)
    800014bc:	ec26                	sd	s1,24(sp)
    800014be:	e84a                	sd	s2,16(sp)
    800014c0:	e44e                	sd	s3,8(sp)
    800014c2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	9fe080e7          	jalr	-1538(ra) # 80000ec2 <myproc>
    800014cc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014ce:	00006097          	auipc	ra,0x6
    800014d2:	c10080e7          	jalr	-1008(ra) # 800070de <holding>
    800014d6:	c93d                	beqz	a0,8000154c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014da:	2781                	sext.w	a5,a5
    800014dc:	079e                	slli	a5,a5,0x7
    800014de:	00009717          	auipc	a4,0x9
    800014e2:	b9270713          	addi	a4,a4,-1134 # 8000a070 <pid_lock>
    800014e6:	97ba                	add	a5,a5,a4
    800014e8:	0907a703          	lw	a4,144(a5)
    800014ec:	4785                	li	a5,1
    800014ee:	06f71763          	bne	a4,a5,8000155c <sched+0xa6>
  if(p->state == RUNNING)
    800014f2:	4c98                	lw	a4,24(s1)
    800014f4:	478d                	li	a5,3
    800014f6:	06f70b63          	beq	a4,a5,8000156c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014fa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014fe:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001500:	efb5                	bnez	a5,8000157c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001502:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001504:	00009917          	auipc	s2,0x9
    80001508:	b6c90913          	addi	s2,s2,-1172 # 8000a070 <pid_lock>
    8000150c:	2781                	sext.w	a5,a5
    8000150e:	079e                	slli	a5,a5,0x7
    80001510:	97ca                	add	a5,a5,s2
    80001512:	0947a983          	lw	s3,148(a5)
    80001516:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001518:	2781                	sext.w	a5,a5
    8000151a:	079e                	slli	a5,a5,0x7
    8000151c:	00009597          	auipc	a1,0x9
    80001520:	b7458593          	addi	a1,a1,-1164 # 8000a090 <cpus+0x8>
    80001524:	95be                	add	a1,a1,a5
    80001526:	06048513          	addi	a0,s1,96
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	564080e7          	jalr	1380(ra) # 80001a8e <swtch>
    80001532:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001534:	2781                	sext.w	a5,a5
    80001536:	079e                	slli	a5,a5,0x7
    80001538:	97ca                	add	a5,a5,s2
    8000153a:	0937aa23          	sw	s3,148(a5)
}
    8000153e:	70a2                	ld	ra,40(sp)
    80001540:	7402                	ld	s0,32(sp)
    80001542:	64e2                	ld	s1,24(sp)
    80001544:	6942                	ld	s2,16(sp)
    80001546:	69a2                	ld	s3,8(sp)
    80001548:	6145                	addi	sp,sp,48
    8000154a:	8082                	ret
    panic("sched p->lock");
    8000154c:	00008517          	auipc	a0,0x8
    80001550:	c3c50513          	addi	a0,a0,-964 # 80009188 <etext+0x188>
    80001554:	00005097          	auipc	ra,0x5
    80001558:	6ba080e7          	jalr	1722(ra) # 80006c0e <panic>
    panic("sched locks");
    8000155c:	00008517          	auipc	a0,0x8
    80001560:	c3c50513          	addi	a0,a0,-964 # 80009198 <etext+0x198>
    80001564:	00005097          	auipc	ra,0x5
    80001568:	6aa080e7          	jalr	1706(ra) # 80006c0e <panic>
    panic("sched running");
    8000156c:	00008517          	auipc	a0,0x8
    80001570:	c3c50513          	addi	a0,a0,-964 # 800091a8 <etext+0x1a8>
    80001574:	00005097          	auipc	ra,0x5
    80001578:	69a080e7          	jalr	1690(ra) # 80006c0e <panic>
    panic("sched interruptible");
    8000157c:	00008517          	auipc	a0,0x8
    80001580:	c3c50513          	addi	a0,a0,-964 # 800091b8 <etext+0x1b8>
    80001584:	00005097          	auipc	ra,0x5
    80001588:	68a080e7          	jalr	1674(ra) # 80006c0e <panic>

000000008000158c <exit>:
{
    8000158c:	7179                	addi	sp,sp,-48
    8000158e:	f406                	sd	ra,40(sp)
    80001590:	f022                	sd	s0,32(sp)
    80001592:	ec26                	sd	s1,24(sp)
    80001594:	e84a                	sd	s2,16(sp)
    80001596:	e44e                	sd	s3,8(sp)
    80001598:	e052                	sd	s4,0(sp)
    8000159a:	1800                	addi	s0,sp,48
    8000159c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	924080e7          	jalr	-1756(ra) # 80000ec2 <myproc>
    800015a6:	89aa                	mv	s3,a0
  if(p == initproc)
    800015a8:	00009797          	auipc	a5,0x9
    800015ac:	a687b783          	ld	a5,-1432(a5) # 8000a010 <initproc>
    800015b0:	0d050493          	addi	s1,a0,208
    800015b4:	15050913          	addi	s2,a0,336
    800015b8:	02a79363          	bne	a5,a0,800015de <exit+0x52>
    panic("init exiting");
    800015bc:	00008517          	auipc	a0,0x8
    800015c0:	c1450513          	addi	a0,a0,-1004 # 800091d0 <etext+0x1d0>
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	64a080e7          	jalr	1610(ra) # 80006c0e <panic>
      fileclose(f);
    800015cc:	00002097          	auipc	ra,0x2
    800015d0:	3fc080e7          	jalr	1020(ra) # 800039c8 <fileclose>
      p->ofile[fd] = 0;
    800015d4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800015d8:	04a1                	addi	s1,s1,8
    800015da:	01248563          	beq	s1,s2,800015e4 <exit+0x58>
    if(p->ofile[fd]){
    800015de:	6088                	ld	a0,0(s1)
    800015e0:	f575                	bnez	a0,800015cc <exit+0x40>
    800015e2:	bfdd                	j	800015d8 <exit+0x4c>
  begin_op();
    800015e4:	00002097          	auipc	ra,0x2
    800015e8:	f10080e7          	jalr	-240(ra) # 800034f4 <begin_op>
  iput(p->cwd);
    800015ec:	1509b503          	ld	a0,336(s3)
    800015f0:	00001097          	auipc	ra,0x1
    800015f4:	6ec080e7          	jalr	1772(ra) # 80002cdc <iput>
  end_op();
    800015f8:	00002097          	auipc	ra,0x2
    800015fc:	f7c080e7          	jalr	-132(ra) # 80003574 <end_op>
  p->cwd = 0;
    80001600:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80001604:	00009497          	auipc	s1,0x9
    80001608:	a0c48493          	addi	s1,s1,-1524 # 8000a010 <initproc>
    8000160c:	6088                	ld	a0,0(s1)
    8000160e:	00006097          	auipc	ra,0x6
    80001612:	b4a080e7          	jalr	-1206(ra) # 80007158 <acquire>
  wakeup1(initproc);
    80001616:	6088                	ld	a0,0(s1)
    80001618:	fffff097          	auipc	ra,0xfffff
    8000161c:	70c080e7          	jalr	1804(ra) # 80000d24 <wakeup1>
  release(&initproc->lock);
    80001620:	6088                	ld	a0,0(s1)
    80001622:	00006097          	auipc	ra,0x6
    80001626:	bea080e7          	jalr	-1046(ra) # 8000720c <release>
  acquire(&p->lock);
    8000162a:	854e                	mv	a0,s3
    8000162c:	00006097          	auipc	ra,0x6
    80001630:	b2c080e7          	jalr	-1236(ra) # 80007158 <acquire>
  struct proc *original_parent = p->parent;
    80001634:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80001638:	854e                	mv	a0,s3
    8000163a:	00006097          	auipc	ra,0x6
    8000163e:	bd2080e7          	jalr	-1070(ra) # 8000720c <release>
  acquire(&original_parent->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00006097          	auipc	ra,0x6
    80001648:	b14080e7          	jalr	-1260(ra) # 80007158 <acquire>
  acquire(&p->lock);
    8000164c:	854e                	mv	a0,s3
    8000164e:	00006097          	auipc	ra,0x6
    80001652:	b0a080e7          	jalr	-1270(ra) # 80007158 <acquire>
  reparent(p);
    80001656:	854e                	mv	a0,s3
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	d34080e7          	jalr	-716(ra) # 8000138c <reparent>
  wakeup1(original_parent);
    80001660:	8526                	mv	a0,s1
    80001662:	fffff097          	auipc	ra,0xfffff
    80001666:	6c2080e7          	jalr	1730(ra) # 80000d24 <wakeup1>
  p->xstate = status;
    8000166a:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000166e:	4791                	li	a5,4
    80001670:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80001674:	8526                	mv	a0,s1
    80001676:	00006097          	auipc	ra,0x6
    8000167a:	b96080e7          	jalr	-1130(ra) # 8000720c <release>
  sched();
    8000167e:	00000097          	auipc	ra,0x0
    80001682:	e38080e7          	jalr	-456(ra) # 800014b6 <sched>
  panic("zombie exit");
    80001686:	00008517          	auipc	a0,0x8
    8000168a:	b5a50513          	addi	a0,a0,-1190 # 800091e0 <etext+0x1e0>
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	580080e7          	jalr	1408(ra) # 80006c0e <panic>

0000000080001696 <yield>:
{
    80001696:	1101                	addi	sp,sp,-32
    80001698:	ec06                	sd	ra,24(sp)
    8000169a:	e822                	sd	s0,16(sp)
    8000169c:	e426                	sd	s1,8(sp)
    8000169e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016a0:	00000097          	auipc	ra,0x0
    800016a4:	822080e7          	jalr	-2014(ra) # 80000ec2 <myproc>
    800016a8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016aa:	00006097          	auipc	ra,0x6
    800016ae:	aae080e7          	jalr	-1362(ra) # 80007158 <acquire>
  p->state = RUNNABLE;
    800016b2:	4789                	li	a5,2
    800016b4:	cc9c                	sw	a5,24(s1)
  sched();
    800016b6:	00000097          	auipc	ra,0x0
    800016ba:	e00080e7          	jalr	-512(ra) # 800014b6 <sched>
  release(&p->lock);
    800016be:	8526                	mv	a0,s1
    800016c0:	00006097          	auipc	ra,0x6
    800016c4:	b4c080e7          	jalr	-1204(ra) # 8000720c <release>
}
    800016c8:	60e2                	ld	ra,24(sp)
    800016ca:	6442                	ld	s0,16(sp)
    800016cc:	64a2                	ld	s1,8(sp)
    800016ce:	6105                	addi	sp,sp,32
    800016d0:	8082                	ret

00000000800016d2 <sleep>:
{
    800016d2:	7179                	addi	sp,sp,-48
    800016d4:	f406                	sd	ra,40(sp)
    800016d6:	f022                	sd	s0,32(sp)
    800016d8:	ec26                	sd	s1,24(sp)
    800016da:	e84a                	sd	s2,16(sp)
    800016dc:	e44e                	sd	s3,8(sp)
    800016de:	1800                	addi	s0,sp,48
    800016e0:	89aa                	mv	s3,a0
    800016e2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016e4:	fffff097          	auipc	ra,0xfffff
    800016e8:	7de080e7          	jalr	2014(ra) # 80000ec2 <myproc>
    800016ec:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800016ee:	05250663          	beq	a0,s2,8000173a <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800016f2:	00006097          	auipc	ra,0x6
    800016f6:	a66080e7          	jalr	-1434(ra) # 80007158 <acquire>
    release(lk);
    800016fa:	854a                	mv	a0,s2
    800016fc:	00006097          	auipc	ra,0x6
    80001700:	b10080e7          	jalr	-1264(ra) # 8000720c <release>
  p->chan = chan;
    80001704:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001708:	4785                	li	a5,1
    8000170a:	cc9c                	sw	a5,24(s1)
  sched();
    8000170c:	00000097          	auipc	ra,0x0
    80001710:	daa080e7          	jalr	-598(ra) # 800014b6 <sched>
  p->chan = 0;
    80001714:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00006097          	auipc	ra,0x6
    8000171e:	af2080e7          	jalr	-1294(ra) # 8000720c <release>
    acquire(lk);
    80001722:	854a                	mv	a0,s2
    80001724:	00006097          	auipc	ra,0x6
    80001728:	a34080e7          	jalr	-1484(ra) # 80007158 <acquire>
}
    8000172c:	70a2                	ld	ra,40(sp)
    8000172e:	7402                	ld	s0,32(sp)
    80001730:	64e2                	ld	s1,24(sp)
    80001732:	6942                	ld	s2,16(sp)
    80001734:	69a2                	ld	s3,8(sp)
    80001736:	6145                	addi	sp,sp,48
    80001738:	8082                	ret
  p->chan = chan;
    8000173a:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000173e:	4785                	li	a5,1
    80001740:	cd1c                	sw	a5,24(a0)
  sched();
    80001742:	00000097          	auipc	ra,0x0
    80001746:	d74080e7          	jalr	-652(ra) # 800014b6 <sched>
  p->chan = 0;
    8000174a:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000174e:	bff9                	j	8000172c <sleep+0x5a>

0000000080001750 <wait>:
{
    80001750:	715d                	addi	sp,sp,-80
    80001752:	e486                	sd	ra,72(sp)
    80001754:	e0a2                	sd	s0,64(sp)
    80001756:	fc26                	sd	s1,56(sp)
    80001758:	f84a                	sd	s2,48(sp)
    8000175a:	f44e                	sd	s3,40(sp)
    8000175c:	f052                	sd	s4,32(sp)
    8000175e:	ec56                	sd	s5,24(sp)
    80001760:	e85a                	sd	s6,16(sp)
    80001762:	e45e                	sd	s7,8(sp)
    80001764:	e062                	sd	s8,0(sp)
    80001766:	0880                	addi	s0,sp,80
    80001768:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000176a:	fffff097          	auipc	ra,0xfffff
    8000176e:	758080e7          	jalr	1880(ra) # 80000ec2 <myproc>
    80001772:	892a                	mv	s2,a0
  acquire(&p->lock);
    80001774:	8c2a                	mv	s8,a0
    80001776:	00006097          	auipc	ra,0x6
    8000177a:	9e2080e7          	jalr	-1566(ra) # 80007158 <acquire>
    havekids = 0;
    8000177e:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001780:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80001782:	0000e997          	auipc	s3,0xe
    80001786:	70698993          	addi	s3,s3,1798 # 8000fe88 <tickslock>
        havekids = 1;
    8000178a:	4a85                	li	s5,1
    havekids = 0;
    8000178c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000178e:	00009497          	auipc	s1,0x9
    80001792:	cfa48493          	addi	s1,s1,-774 # 8000a488 <proc>
    80001796:	a08d                	j	800017f8 <wait+0xa8>
          pid = np->pid;
    80001798:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000179c:	000b0e63          	beqz	s6,800017b8 <wait+0x68>
    800017a0:	4691                	li	a3,4
    800017a2:	03448613          	addi	a2,s1,52
    800017a6:	85da                	mv	a1,s6
    800017a8:	05093503          	ld	a0,80(s2)
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	3ac080e7          	jalr	940(ra) # 80000b58 <copyout>
    800017b4:	02054263          	bltz	a0,800017d8 <wait+0x88>
          freeproc(np);
    800017b8:	8526                	mv	a0,s1
    800017ba:	00000097          	auipc	ra,0x0
    800017be:	8ba080e7          	jalr	-1862(ra) # 80001074 <freeproc>
          release(&np->lock);
    800017c2:	8526                	mv	a0,s1
    800017c4:	00006097          	auipc	ra,0x6
    800017c8:	a48080e7          	jalr	-1464(ra) # 8000720c <release>
          release(&p->lock);
    800017cc:	854a                	mv	a0,s2
    800017ce:	00006097          	auipc	ra,0x6
    800017d2:	a3e080e7          	jalr	-1474(ra) # 8000720c <release>
          return pid;
    800017d6:	a8a9                	j	80001830 <wait+0xe0>
            release(&np->lock);
    800017d8:	8526                	mv	a0,s1
    800017da:	00006097          	auipc	ra,0x6
    800017de:	a32080e7          	jalr	-1486(ra) # 8000720c <release>
            release(&p->lock);
    800017e2:	854a                	mv	a0,s2
    800017e4:	00006097          	auipc	ra,0x6
    800017e8:	a28080e7          	jalr	-1496(ra) # 8000720c <release>
            return -1;
    800017ec:	59fd                	li	s3,-1
    800017ee:	a089                	j	80001830 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    800017f0:	16848493          	addi	s1,s1,360
    800017f4:	03348463          	beq	s1,s3,8000181c <wait+0xcc>
      if(np->parent == p){
    800017f8:	709c                	ld	a5,32(s1)
    800017fa:	ff279be3          	bne	a5,s2,800017f0 <wait+0xa0>
        acquire(&np->lock);
    800017fe:	8526                	mv	a0,s1
    80001800:	00006097          	auipc	ra,0x6
    80001804:	958080e7          	jalr	-1704(ra) # 80007158 <acquire>
        if(np->state == ZOMBIE){
    80001808:	4c9c                	lw	a5,24(s1)
    8000180a:	f94787e3          	beq	a5,s4,80001798 <wait+0x48>
        release(&np->lock);
    8000180e:	8526                	mv	a0,s1
    80001810:	00006097          	auipc	ra,0x6
    80001814:	9fc080e7          	jalr	-1540(ra) # 8000720c <release>
        havekids = 1;
    80001818:	8756                	mv	a4,s5
    8000181a:	bfd9                	j	800017f0 <wait+0xa0>
    if(!havekids || p->killed){
    8000181c:	c701                	beqz	a4,80001824 <wait+0xd4>
    8000181e:	03092783          	lw	a5,48(s2)
    80001822:	c785                	beqz	a5,8000184a <wait+0xfa>
      release(&p->lock);
    80001824:	854a                	mv	a0,s2
    80001826:	00006097          	auipc	ra,0x6
    8000182a:	9e6080e7          	jalr	-1562(ra) # 8000720c <release>
      return -1;
    8000182e:	59fd                	li	s3,-1
}
    80001830:	854e                	mv	a0,s3
    80001832:	60a6                	ld	ra,72(sp)
    80001834:	6406                	ld	s0,64(sp)
    80001836:	74e2                	ld	s1,56(sp)
    80001838:	7942                	ld	s2,48(sp)
    8000183a:	79a2                	ld	s3,40(sp)
    8000183c:	7a02                	ld	s4,32(sp)
    8000183e:	6ae2                	ld	s5,24(sp)
    80001840:	6b42                	ld	s6,16(sp)
    80001842:	6ba2                	ld	s7,8(sp)
    80001844:	6c02                	ld	s8,0(sp)
    80001846:	6161                	addi	sp,sp,80
    80001848:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000184a:	85e2                	mv	a1,s8
    8000184c:	854a                	mv	a0,s2
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	e84080e7          	jalr	-380(ra) # 800016d2 <sleep>
    havekids = 0;
    80001856:	bf1d                	j	8000178c <wait+0x3c>

0000000080001858 <wakeup>:
{
    80001858:	7139                	addi	sp,sp,-64
    8000185a:	fc06                	sd	ra,56(sp)
    8000185c:	f822                	sd	s0,48(sp)
    8000185e:	f426                	sd	s1,40(sp)
    80001860:	f04a                	sd	s2,32(sp)
    80001862:	ec4e                	sd	s3,24(sp)
    80001864:	e852                	sd	s4,16(sp)
    80001866:	e456                	sd	s5,8(sp)
    80001868:	0080                	addi	s0,sp,64
    8000186a:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	00009497          	auipc	s1,0x9
    80001870:	c1c48493          	addi	s1,s1,-996 # 8000a488 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80001874:	4985                	li	s3,1
      p->state = RUNNABLE;
    80001876:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80001878:	0000e917          	auipc	s2,0xe
    8000187c:	61090913          	addi	s2,s2,1552 # 8000fe88 <tickslock>
    80001880:	a821                	j	80001898 <wakeup+0x40>
      p->state = RUNNABLE;
    80001882:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00006097          	auipc	ra,0x6
    8000188c:	984080e7          	jalr	-1660(ra) # 8000720c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001890:	16848493          	addi	s1,s1,360
    80001894:	01248e63          	beq	s1,s2,800018b0 <wakeup+0x58>
    acquire(&p->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00006097          	auipc	ra,0x6
    8000189e:	8be080e7          	jalr	-1858(ra) # 80007158 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800018a2:	4c9c                	lw	a5,24(s1)
    800018a4:	ff3791e3          	bne	a5,s3,80001886 <wakeup+0x2e>
    800018a8:	749c                	ld	a5,40(s1)
    800018aa:	fd479ee3          	bne	a5,s4,80001886 <wakeup+0x2e>
    800018ae:	bfd1                	j	80001882 <wakeup+0x2a>
}
    800018b0:	70e2                	ld	ra,56(sp)
    800018b2:	7442                	ld	s0,48(sp)
    800018b4:	74a2                	ld	s1,40(sp)
    800018b6:	7902                	ld	s2,32(sp)
    800018b8:	69e2                	ld	s3,24(sp)
    800018ba:	6a42                	ld	s4,16(sp)
    800018bc:	6aa2                	ld	s5,8(sp)
    800018be:	6121                	addi	sp,sp,64
    800018c0:	8082                	ret

00000000800018c2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018c2:	7179                	addi	sp,sp,-48
    800018c4:	f406                	sd	ra,40(sp)
    800018c6:	f022                	sd	s0,32(sp)
    800018c8:	ec26                	sd	s1,24(sp)
    800018ca:	e84a                	sd	s2,16(sp)
    800018cc:	e44e                	sd	s3,8(sp)
    800018ce:	1800                	addi	s0,sp,48
    800018d0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018d2:	00009497          	auipc	s1,0x9
    800018d6:	bb648493          	addi	s1,s1,-1098 # 8000a488 <proc>
    800018da:	0000e997          	auipc	s3,0xe
    800018de:	5ae98993          	addi	s3,s3,1454 # 8000fe88 <tickslock>
    acquire(&p->lock);
    800018e2:	8526                	mv	a0,s1
    800018e4:	00006097          	auipc	ra,0x6
    800018e8:	874080e7          	jalr	-1932(ra) # 80007158 <acquire>
    if(p->pid == pid){
    800018ec:	5c9c                	lw	a5,56(s1)
    800018ee:	01278d63          	beq	a5,s2,80001908 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	00006097          	auipc	ra,0x6
    800018f8:	918080e7          	jalr	-1768(ra) # 8000720c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018fc:	16848493          	addi	s1,s1,360
    80001900:	ff3491e3          	bne	s1,s3,800018e2 <kill+0x20>
  }
  return -1;
    80001904:	557d                	li	a0,-1
    80001906:	a829                	j	80001920 <kill+0x5e>
      p->killed = 1;
    80001908:	4785                	li	a5,1
    8000190a:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000190c:	4c98                	lw	a4,24(s1)
    8000190e:	4785                	li	a5,1
    80001910:	00f70f63          	beq	a4,a5,8000192e <kill+0x6c>
      release(&p->lock);
    80001914:	8526                	mv	a0,s1
    80001916:	00006097          	auipc	ra,0x6
    8000191a:	8f6080e7          	jalr	-1802(ra) # 8000720c <release>
      return 0;
    8000191e:	4501                	li	a0,0
}
    80001920:	70a2                	ld	ra,40(sp)
    80001922:	7402                	ld	s0,32(sp)
    80001924:	64e2                	ld	s1,24(sp)
    80001926:	6942                	ld	s2,16(sp)
    80001928:	69a2                	ld	s3,8(sp)
    8000192a:	6145                	addi	sp,sp,48
    8000192c:	8082                	ret
        p->state = RUNNABLE;
    8000192e:	4789                	li	a5,2
    80001930:	cc9c                	sw	a5,24(s1)
    80001932:	b7cd                	j	80001914 <kill+0x52>

0000000080001934 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001934:	7179                	addi	sp,sp,-48
    80001936:	f406                	sd	ra,40(sp)
    80001938:	f022                	sd	s0,32(sp)
    8000193a:	ec26                	sd	s1,24(sp)
    8000193c:	e84a                	sd	s2,16(sp)
    8000193e:	e44e                	sd	s3,8(sp)
    80001940:	e052                	sd	s4,0(sp)
    80001942:	1800                	addi	s0,sp,48
    80001944:	84aa                	mv	s1,a0
    80001946:	892e                	mv	s2,a1
    80001948:	89b2                	mv	s3,a2
    8000194a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	576080e7          	jalr	1398(ra) # 80000ec2 <myproc>
  if(user_dst){
    80001954:	c08d                	beqz	s1,80001976 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001956:	86d2                	mv	a3,s4
    80001958:	864e                	mv	a2,s3
    8000195a:	85ca                	mv	a1,s2
    8000195c:	6928                	ld	a0,80(a0)
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	1fa080e7          	jalr	506(ra) # 80000b58 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001966:	70a2                	ld	ra,40(sp)
    80001968:	7402                	ld	s0,32(sp)
    8000196a:	64e2                	ld	s1,24(sp)
    8000196c:	6942                	ld	s2,16(sp)
    8000196e:	69a2                	ld	s3,8(sp)
    80001970:	6a02                	ld	s4,0(sp)
    80001972:	6145                	addi	sp,sp,48
    80001974:	8082                	ret
    memmove((char *)dst, src, len);
    80001976:	000a061b          	sext.w	a2,s4
    8000197a:	85ce                	mv	a1,s3
    8000197c:	854a                	mv	a0,s2
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	85a080e7          	jalr	-1958(ra) # 800001d8 <memmove>
    return 0;
    80001986:	8526                	mv	a0,s1
    80001988:	bff9                	j	80001966 <either_copyout+0x32>

000000008000198a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000198a:	7179                	addi	sp,sp,-48
    8000198c:	f406                	sd	ra,40(sp)
    8000198e:	f022                	sd	s0,32(sp)
    80001990:	ec26                	sd	s1,24(sp)
    80001992:	e84a                	sd	s2,16(sp)
    80001994:	e44e                	sd	s3,8(sp)
    80001996:	e052                	sd	s4,0(sp)
    80001998:	1800                	addi	s0,sp,48
    8000199a:	892a                	mv	s2,a0
    8000199c:	84ae                	mv	s1,a1
    8000199e:	89b2                	mv	s3,a2
    800019a0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	520080e7          	jalr	1312(ra) # 80000ec2 <myproc>
  if(user_src){
    800019aa:	c08d                	beqz	s1,800019cc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019ac:	86d2                	mv	a3,s4
    800019ae:	864e                	mv	a2,s3
    800019b0:	85ca                	mv	a1,s2
    800019b2:	6928                	ld	a0,80(a0)
    800019b4:	fffff097          	auipc	ra,0xfffff
    800019b8:	230080e7          	jalr	560(ra) # 80000be4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019bc:	70a2                	ld	ra,40(sp)
    800019be:	7402                	ld	s0,32(sp)
    800019c0:	64e2                	ld	s1,24(sp)
    800019c2:	6942                	ld	s2,16(sp)
    800019c4:	69a2                	ld	s3,8(sp)
    800019c6:	6a02                	ld	s4,0(sp)
    800019c8:	6145                	addi	sp,sp,48
    800019ca:	8082                	ret
    memmove(dst, (char*)src, len);
    800019cc:	000a061b          	sext.w	a2,s4
    800019d0:	85ce                	mv	a1,s3
    800019d2:	854a                	mv	a0,s2
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	804080e7          	jalr	-2044(ra) # 800001d8 <memmove>
    return 0;
    800019dc:	8526                	mv	a0,s1
    800019de:	bff9                	j	800019bc <either_copyin+0x32>

00000000800019e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019e0:	715d                	addi	sp,sp,-80
    800019e2:	e486                	sd	ra,72(sp)
    800019e4:	e0a2                	sd	s0,64(sp)
    800019e6:	fc26                	sd	s1,56(sp)
    800019e8:	f84a                	sd	s2,48(sp)
    800019ea:	f44e                	sd	s3,40(sp)
    800019ec:	f052                	sd	s4,32(sp)
    800019ee:	ec56                	sd	s5,24(sp)
    800019f0:	e85a                	sd	s6,16(sp)
    800019f2:	e45e                	sd	s7,8(sp)
    800019f4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019f6:	00007517          	auipc	a0,0x7
    800019fa:	65250513          	addi	a0,a0,1618 # 80009048 <etext+0x48>
    800019fe:	00005097          	auipc	ra,0x5
    80001a02:	25a080e7          	jalr	602(ra) # 80006c58 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a06:	00009497          	auipc	s1,0x9
    80001a0a:	bda48493          	addi	s1,s1,-1062 # 8000a5e0 <proc+0x158>
    80001a0e:	0000e917          	auipc	s2,0xe
    80001a12:	5d290913          	addi	s2,s2,1490 # 8000ffe0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a16:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80001a18:	00007997          	auipc	s3,0x7
    80001a1c:	7d898993          	addi	s3,s3,2008 # 800091f0 <etext+0x1f0>
    printf("%d %s %s", p->pid, state, p->name);
    80001a20:	00007a97          	auipc	s5,0x7
    80001a24:	7d8a8a93          	addi	s5,s5,2008 # 800091f8 <etext+0x1f8>
    printf("\n");
    80001a28:	00007a17          	auipc	s4,0x7
    80001a2c:	620a0a13          	addi	s4,s4,1568 # 80009048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a30:	00008b97          	auipc	s7,0x8
    80001a34:	800b8b93          	addi	s7,s7,-2048 # 80009230 <states.1760>
    80001a38:	a00d                	j	80001a5a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a3a:	ee06a583          	lw	a1,-288(a3)
    80001a3e:	8556                	mv	a0,s5
    80001a40:	00005097          	auipc	ra,0x5
    80001a44:	218080e7          	jalr	536(ra) # 80006c58 <printf>
    printf("\n");
    80001a48:	8552                	mv	a0,s4
    80001a4a:	00005097          	auipc	ra,0x5
    80001a4e:	20e080e7          	jalr	526(ra) # 80006c58 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a52:	16848493          	addi	s1,s1,360
    80001a56:	03248163          	beq	s1,s2,80001a78 <procdump+0x98>
    if(p->state == UNUSED)
    80001a5a:	86a6                	mv	a3,s1
    80001a5c:	ec04a783          	lw	a5,-320(s1)
    80001a60:	dbed                	beqz	a5,80001a52 <procdump+0x72>
      state = "???";
    80001a62:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a64:	fcfb6be3          	bltu	s6,a5,80001a3a <procdump+0x5a>
    80001a68:	1782                	slli	a5,a5,0x20
    80001a6a:	9381                	srli	a5,a5,0x20
    80001a6c:	078e                	slli	a5,a5,0x3
    80001a6e:	97de                	add	a5,a5,s7
    80001a70:	6390                	ld	a2,0(a5)
    80001a72:	f661                	bnez	a2,80001a3a <procdump+0x5a>
      state = "???";
    80001a74:	864e                	mv	a2,s3
    80001a76:	b7d1                	j	80001a3a <procdump+0x5a>
  }
}
    80001a78:	60a6                	ld	ra,72(sp)
    80001a7a:	6406                	ld	s0,64(sp)
    80001a7c:	74e2                	ld	s1,56(sp)
    80001a7e:	7942                	ld	s2,48(sp)
    80001a80:	79a2                	ld	s3,40(sp)
    80001a82:	7a02                	ld	s4,32(sp)
    80001a84:	6ae2                	ld	s5,24(sp)
    80001a86:	6b42                	ld	s6,16(sp)
    80001a88:	6ba2                	ld	s7,8(sp)
    80001a8a:	6161                	addi	sp,sp,80
    80001a8c:	8082                	ret

0000000080001a8e <swtch>:
    80001a8e:	00153023          	sd	ra,0(a0)
    80001a92:	00253423          	sd	sp,8(a0)
    80001a96:	e900                	sd	s0,16(a0)
    80001a98:	ed04                	sd	s1,24(a0)
    80001a9a:	03253023          	sd	s2,32(a0)
    80001a9e:	03353423          	sd	s3,40(a0)
    80001aa2:	03453823          	sd	s4,48(a0)
    80001aa6:	03553c23          	sd	s5,56(a0)
    80001aaa:	05653023          	sd	s6,64(a0)
    80001aae:	05753423          	sd	s7,72(a0)
    80001ab2:	05853823          	sd	s8,80(a0)
    80001ab6:	05953c23          	sd	s9,88(a0)
    80001aba:	07a53023          	sd	s10,96(a0)
    80001abe:	07b53423          	sd	s11,104(a0)
    80001ac2:	0005b083          	ld	ra,0(a1)
    80001ac6:	0085b103          	ld	sp,8(a1)
    80001aca:	6980                	ld	s0,16(a1)
    80001acc:	6d84                	ld	s1,24(a1)
    80001ace:	0205b903          	ld	s2,32(a1)
    80001ad2:	0285b983          	ld	s3,40(a1)
    80001ad6:	0305ba03          	ld	s4,48(a1)
    80001ada:	0385ba83          	ld	s5,56(a1)
    80001ade:	0405bb03          	ld	s6,64(a1)
    80001ae2:	0485bb83          	ld	s7,72(a1)
    80001ae6:	0505bc03          	ld	s8,80(a1)
    80001aea:	0585bc83          	ld	s9,88(a1)
    80001aee:	0605bd03          	ld	s10,96(a1)
    80001af2:	0685bd83          	ld	s11,104(a1)
    80001af6:	8082                	ret

0000000080001af8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001af8:	1141                	addi	sp,sp,-16
    80001afa:	e406                	sd	ra,8(sp)
    80001afc:	e022                	sd	s0,0(sp)
    80001afe:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b00:	00007597          	auipc	a1,0x7
    80001b04:	75858593          	addi	a1,a1,1880 # 80009258 <states.1760+0x28>
    80001b08:	0000e517          	auipc	a0,0xe
    80001b0c:	38050513          	addi	a0,a0,896 # 8000fe88 <tickslock>
    80001b10:	00005097          	auipc	ra,0x5
    80001b14:	5b8080e7          	jalr	1464(ra) # 800070c8 <initlock>
}
    80001b18:	60a2                	ld	ra,8(sp)
    80001b1a:	6402                	ld	s0,0(sp)
    80001b1c:	0141                	addi	sp,sp,16
    80001b1e:	8082                	ret

0000000080001b20 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b20:	1141                	addi	sp,sp,-16
    80001b22:	e422                	sd	s0,8(sp)
    80001b24:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b26:	00003797          	auipc	a5,0x3
    80001b2a:	57a78793          	addi	a5,a5,1402 # 800050a0 <kernelvec>
    80001b2e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b32:	6422                	ld	s0,8(sp)
    80001b34:	0141                	addi	sp,sp,16
    80001b36:	8082                	ret

0000000080001b38 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b38:	1141                	addi	sp,sp,-16
    80001b3a:	e406                	sd	ra,8(sp)
    80001b3c:	e022                	sd	s0,0(sp)
    80001b3e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	382080e7          	jalr	898(ra) # 80000ec2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b4c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b4e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b52:	00006617          	auipc	a2,0x6
    80001b56:	4ae60613          	addi	a2,a2,1198 # 80008000 <_trampoline>
    80001b5a:	00006697          	auipc	a3,0x6
    80001b5e:	4a668693          	addi	a3,a3,1190 # 80008000 <_trampoline>
    80001b62:	8e91                	sub	a3,a3,a2
    80001b64:	040007b7          	lui	a5,0x4000
    80001b68:	17fd                	addi	a5,a5,-1
    80001b6a:	07b2                	slli	a5,a5,0xc
    80001b6c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b6e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b72:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b74:	180026f3          	csrr	a3,satp
    80001b78:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b7a:	6d38                	ld	a4,88(a0)
    80001b7c:	6134                	ld	a3,64(a0)
    80001b7e:	6585                	lui	a1,0x1
    80001b80:	96ae                	add	a3,a3,a1
    80001b82:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b84:	6d38                	ld	a4,88(a0)
    80001b86:	00000697          	auipc	a3,0x0
    80001b8a:	14a68693          	addi	a3,a3,330 # 80001cd0 <usertrap>
    80001b8e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b90:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b92:	8692                	mv	a3,tp
    80001b94:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b96:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b9a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b9e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ba6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ba8:	6f18                	ld	a4,24(a4)
    80001baa:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bae:	692c                	ld	a1,80(a0)
    80001bb0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bb2:	00006717          	auipc	a4,0x6
    80001bb6:	4de70713          	addi	a4,a4,1246 # 80008090 <userret>
    80001bba:	8f11                	sub	a4,a4,a2
    80001bbc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bbe:	577d                	li	a4,-1
    80001bc0:	177e                	slli	a4,a4,0x3f
    80001bc2:	8dd9                	or	a1,a1,a4
    80001bc4:	02000537          	lui	a0,0x2000
    80001bc8:	157d                	addi	a0,a0,-1
    80001bca:	0536                	slli	a0,a0,0xd
    80001bcc:	9782                	jalr	a5
}
    80001bce:	60a2                	ld	ra,8(sp)
    80001bd0:	6402                	ld	s0,0(sp)
    80001bd2:	0141                	addi	sp,sp,16
    80001bd4:	8082                	ret

0000000080001bd6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bd6:	1101                	addi	sp,sp,-32
    80001bd8:	ec06                	sd	ra,24(sp)
    80001bda:	e822                	sd	s0,16(sp)
    80001bdc:	e426                	sd	s1,8(sp)
    80001bde:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001be0:	0000e497          	auipc	s1,0xe
    80001be4:	2a848493          	addi	s1,s1,680 # 8000fe88 <tickslock>
    80001be8:	8526                	mv	a0,s1
    80001bea:	00005097          	auipc	ra,0x5
    80001bee:	56e080e7          	jalr	1390(ra) # 80007158 <acquire>
  ticks++;
    80001bf2:	00008517          	auipc	a0,0x8
    80001bf6:	42650513          	addi	a0,a0,1062 # 8000a018 <ticks>
    80001bfa:	411c                	lw	a5,0(a0)
    80001bfc:	2785                	addiw	a5,a5,1
    80001bfe:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c00:	00000097          	auipc	ra,0x0
    80001c04:	c58080e7          	jalr	-936(ra) # 80001858 <wakeup>
  release(&tickslock);
    80001c08:	8526                	mv	a0,s1
    80001c0a:	00005097          	auipc	ra,0x5
    80001c0e:	602080e7          	jalr	1538(ra) # 8000720c <release>
}
    80001c12:	60e2                	ld	ra,24(sp)
    80001c14:	6442                	ld	s0,16(sp)
    80001c16:	64a2                	ld	s1,8(sp)
    80001c18:	6105                	addi	sp,sp,32
    80001c1a:	8082                	ret

0000000080001c1c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c1c:	1101                	addi	sp,sp,-32
    80001c1e:	ec06                	sd	ra,24(sp)
    80001c20:	e822                	sd	s0,16(sp)
    80001c22:	e426                	sd	s1,8(sp)
    80001c24:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c26:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c2a:	00074d63          	bltz	a4,80001c44 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c2e:	57fd                	li	a5,-1
    80001c30:	17fe                	slli	a5,a5,0x3f
    80001c32:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c34:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c36:	06f70c63          	beq	a4,a5,80001cae <devintr+0x92>
  }
}
    80001c3a:	60e2                	ld	ra,24(sp)
    80001c3c:	6442                	ld	s0,16(sp)
    80001c3e:	64a2                	ld	s1,8(sp)
    80001c40:	6105                	addi	sp,sp,32
    80001c42:	8082                	ret
     (scause & 0xff) == 9){
    80001c44:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c48:	46a5                	li	a3,9
    80001c4a:	fed792e3          	bne	a5,a3,80001c2e <devintr+0x12>
    int irq = plic_claim();
    80001c4e:	00003097          	auipc	ra,0x3
    80001c52:	574080e7          	jalr	1396(ra) # 800051c2 <plic_claim>
    80001c56:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c58:	47a9                	li	a5,10
    80001c5a:	02f50563          	beq	a0,a5,80001c84 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80001c5e:	4785                	li	a5,1
    80001c60:	02f50d63          	beq	a0,a5,80001c9a <devintr+0x7e>
    else if(irq == E1000_IRQ){
    80001c64:	02100793          	li	a5,33
    80001c68:	02f50e63          	beq	a0,a5,80001ca4 <devintr+0x88>
    return 1;
    80001c6c:	4505                	li	a0,1
    else if(irq){
    80001c6e:	d4f1                	beqz	s1,80001c3a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c70:	85a6                	mv	a1,s1
    80001c72:	00007517          	auipc	a0,0x7
    80001c76:	5ee50513          	addi	a0,a0,1518 # 80009260 <states.1760+0x30>
    80001c7a:	00005097          	auipc	ra,0x5
    80001c7e:	fde080e7          	jalr	-34(ra) # 80006c58 <printf>
    80001c82:	a029                	j	80001c8c <devintr+0x70>
      uartintr();
    80001c84:	00005097          	auipc	ra,0x5
    80001c88:	3f4080e7          	jalr	1012(ra) # 80007078 <uartintr>
      plic_complete(irq);
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00003097          	auipc	ra,0x3
    80001c92:	558080e7          	jalr	1368(ra) # 800051e6 <plic_complete>
    return 1;
    80001c96:	4505                	li	a0,1
    80001c98:	b74d                	j	80001c3a <devintr+0x1e>
      virtio_disk_intr();
    80001c9a:	00004097          	auipc	ra,0x4
    80001c9e:	a2c080e7          	jalr	-1492(ra) # 800056c6 <virtio_disk_intr>
    80001ca2:	b7ed                	j	80001c8c <devintr+0x70>
      e1000_intr();
    80001ca4:	00004097          	auipc	ra,0x4
    80001ca8:	d64080e7          	jalr	-668(ra) # 80005a08 <e1000_intr>
    80001cac:	b7c5                	j	80001c8c <devintr+0x70>
    if(cpuid() == 0){
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	1e8080e7          	jalr	488(ra) # 80000e96 <cpuid>
    80001cb6:	c901                	beqz	a0,80001cc6 <devintr+0xaa>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cb8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cbc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cbe:	14479073          	csrw	sip,a5
    return 2;
    80001cc2:	4509                	li	a0,2
    80001cc4:	bf9d                	j	80001c3a <devintr+0x1e>
      clockintr();
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	f10080e7          	jalr	-240(ra) # 80001bd6 <clockintr>
    80001cce:	b7ed                	j	80001cb8 <devintr+0x9c>

0000000080001cd0 <usertrap>:
{
    80001cd0:	1101                	addi	sp,sp,-32
    80001cd2:	ec06                	sd	ra,24(sp)
    80001cd4:	e822                	sd	s0,16(sp)
    80001cd6:	e426                	sd	s1,8(sp)
    80001cd8:	e04a                	sd	s2,0(sp)
    80001cda:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cdc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ce0:	1007f793          	andi	a5,a5,256
    80001ce4:	e3b9                	bnez	a5,80001d2a <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ce6:	00003797          	auipc	a5,0x3
    80001cea:	3ba78793          	addi	a5,a5,954 # 800050a0 <kernelvec>
    80001cee:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cf2:	fffff097          	auipc	ra,0xfffff
    80001cf6:	1d0080e7          	jalr	464(ra) # 80000ec2 <myproc>
    80001cfa:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cfc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cfe:	14102773          	csrr	a4,sepc
    80001d02:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d04:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d08:	47a1                	li	a5,8
    80001d0a:	02f70863          	beq	a4,a5,80001d3a <usertrap+0x6a>
  } else if((which_dev = devintr()) != 0){
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	f0e080e7          	jalr	-242(ra) # 80001c1c <devintr>
    80001d16:	892a                	mv	s2,a0
    80001d18:	c551                	beqz	a0,80001da4 <usertrap+0xd4>
  if(lockfree_read4(&p->killed))
    80001d1a:	03048513          	addi	a0,s1,48
    80001d1e:	00005097          	auipc	ra,0x5
    80001d22:	54c080e7          	jalr	1356(ra) # 8000726a <lockfree_read4>
    80001d26:	cd21                	beqz	a0,80001d7e <usertrap+0xae>
    80001d28:	a0b1                	j	80001d74 <usertrap+0xa4>
    panic("usertrap: not from user mode");
    80001d2a:	00007517          	auipc	a0,0x7
    80001d2e:	55650513          	addi	a0,a0,1366 # 80009280 <states.1760+0x50>
    80001d32:	00005097          	auipc	ra,0x5
    80001d36:	edc080e7          	jalr	-292(ra) # 80006c0e <panic>
    if(lockfree_read4(&p->killed))
    80001d3a:	03050513          	addi	a0,a0,48
    80001d3e:	00005097          	auipc	ra,0x5
    80001d42:	52c080e7          	jalr	1324(ra) # 8000726a <lockfree_read4>
    80001d46:	e929                	bnez	a0,80001d98 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80001d48:	6cb8                	ld	a4,88(s1)
    80001d4a:	6f1c                	ld	a5,24(a4)
    80001d4c:	0791                	addi	a5,a5,4
    80001d4e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d58:	10079073          	csrw	sstatus,a5
    syscall();
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	2c8080e7          	jalr	712(ra) # 80002024 <syscall>
  if(lockfree_read4(&p->killed))
    80001d64:	03048513          	addi	a0,s1,48
    80001d68:	00005097          	auipc	ra,0x5
    80001d6c:	502080e7          	jalr	1282(ra) # 8000726a <lockfree_read4>
    80001d70:	c911                	beqz	a0,80001d84 <usertrap+0xb4>
    80001d72:	4901                	li	s2,0
    exit(-1);
    80001d74:	557d                	li	a0,-1
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	816080e7          	jalr	-2026(ra) # 8000158c <exit>
  if(which_dev == 2)
    80001d7e:	4789                	li	a5,2
    80001d80:	04f90c63          	beq	s2,a5,80001dd8 <usertrap+0x108>
  usertrapret();
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	db4080e7          	jalr	-588(ra) # 80001b38 <usertrapret>
}
    80001d8c:	60e2                	ld	ra,24(sp)
    80001d8e:	6442                	ld	s0,16(sp)
    80001d90:	64a2                	ld	s1,8(sp)
    80001d92:	6902                	ld	s2,0(sp)
    80001d94:	6105                	addi	sp,sp,32
    80001d96:	8082                	ret
      exit(-1);
    80001d98:	557d                	li	a0,-1
    80001d9a:	fffff097          	auipc	ra,0xfffff
    80001d9e:	7f2080e7          	jalr	2034(ra) # 8000158c <exit>
    80001da2:	b75d                	j	80001d48 <usertrap+0x78>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001da8:	5c90                	lw	a2,56(s1)
    80001daa:	00007517          	auipc	a0,0x7
    80001dae:	4f650513          	addi	a0,a0,1270 # 800092a0 <states.1760+0x70>
    80001db2:	00005097          	auipc	ra,0x5
    80001db6:	ea6080e7          	jalr	-346(ra) # 80006c58 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dbe:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dc2:	00007517          	auipc	a0,0x7
    80001dc6:	50e50513          	addi	a0,a0,1294 # 800092d0 <states.1760+0xa0>
    80001dca:	00005097          	auipc	ra,0x5
    80001dce:	e8e080e7          	jalr	-370(ra) # 80006c58 <printf>
    p->killed = 1;
    80001dd2:	4785                	li	a5,1
    80001dd4:	d89c                	sw	a5,48(s1)
    80001dd6:	b779                	j	80001d64 <usertrap+0x94>
    yield();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	8be080e7          	jalr	-1858(ra) # 80001696 <yield>
    80001de0:	b755                	j	80001d84 <usertrap+0xb4>

0000000080001de2 <kerneltrap>:
{
    80001de2:	7179                	addi	sp,sp,-48
    80001de4:	f406                	sd	ra,40(sp)
    80001de6:	f022                	sd	s0,32(sp)
    80001de8:	ec26                	sd	s1,24(sp)
    80001dea:	e84a                	sd	s2,16(sp)
    80001dec:	e44e                	sd	s3,8(sp)
    80001dee:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dfc:	1004f793          	andi	a5,s1,256
    80001e00:	cb85                	beqz	a5,80001e30 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e02:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e06:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e08:	ef85                	bnez	a5,80001e40 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	e12080e7          	jalr	-494(ra) # 80001c1c <devintr>
    80001e12:	cd1d                	beqz	a0,80001e50 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e14:	4789                	li	a5,2
    80001e16:	06f50a63          	beq	a0,a5,80001e8a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e1a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e1e:	10049073          	csrw	sstatus,s1
}
    80001e22:	70a2                	ld	ra,40(sp)
    80001e24:	7402                	ld	s0,32(sp)
    80001e26:	64e2                	ld	s1,24(sp)
    80001e28:	6942                	ld	s2,16(sp)
    80001e2a:	69a2                	ld	s3,8(sp)
    80001e2c:	6145                	addi	sp,sp,48
    80001e2e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e30:	00007517          	auipc	a0,0x7
    80001e34:	4c050513          	addi	a0,a0,1216 # 800092f0 <states.1760+0xc0>
    80001e38:	00005097          	auipc	ra,0x5
    80001e3c:	dd6080e7          	jalr	-554(ra) # 80006c0e <panic>
    panic("kerneltrap: interrupts enabled");
    80001e40:	00007517          	auipc	a0,0x7
    80001e44:	4d850513          	addi	a0,a0,1240 # 80009318 <states.1760+0xe8>
    80001e48:	00005097          	auipc	ra,0x5
    80001e4c:	dc6080e7          	jalr	-570(ra) # 80006c0e <panic>
    printf("scause %p\n", scause);
    80001e50:	85ce                	mv	a1,s3
    80001e52:	00007517          	auipc	a0,0x7
    80001e56:	4e650513          	addi	a0,a0,1254 # 80009338 <states.1760+0x108>
    80001e5a:	00005097          	auipc	ra,0x5
    80001e5e:	dfe080e7          	jalr	-514(ra) # 80006c58 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e62:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e66:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e6a:	00007517          	auipc	a0,0x7
    80001e6e:	4de50513          	addi	a0,a0,1246 # 80009348 <states.1760+0x118>
    80001e72:	00005097          	auipc	ra,0x5
    80001e76:	de6080e7          	jalr	-538(ra) # 80006c58 <printf>
    panic("kerneltrap");
    80001e7a:	00007517          	auipc	a0,0x7
    80001e7e:	4e650513          	addi	a0,a0,1254 # 80009360 <states.1760+0x130>
    80001e82:	00005097          	auipc	ra,0x5
    80001e86:	d8c080e7          	jalr	-628(ra) # 80006c0e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e8a:	fffff097          	auipc	ra,0xfffff
    80001e8e:	038080e7          	jalr	56(ra) # 80000ec2 <myproc>
    80001e92:	d541                	beqz	a0,80001e1a <kerneltrap+0x38>
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	02e080e7          	jalr	46(ra) # 80000ec2 <myproc>
    80001e9c:	4d18                	lw	a4,24(a0)
    80001e9e:	478d                	li	a5,3
    80001ea0:	f6f71de3          	bne	a4,a5,80001e1a <kerneltrap+0x38>
    yield();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	7f2080e7          	jalr	2034(ra) # 80001696 <yield>
    80001eac:	b7bd                	j	80001e1a <kerneltrap+0x38>

0000000080001eae <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eae:	1101                	addi	sp,sp,-32
    80001eb0:	ec06                	sd	ra,24(sp)
    80001eb2:	e822                	sd	s0,16(sp)
    80001eb4:	e426                	sd	s1,8(sp)
    80001eb6:	1000                	addi	s0,sp,32
    80001eb8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	008080e7          	jalr	8(ra) # 80000ec2 <myproc>
  switch (n) {
    80001ec2:	4795                	li	a5,5
    80001ec4:	0497e163          	bltu	a5,s1,80001f06 <argraw+0x58>
    80001ec8:	048a                	slli	s1,s1,0x2
    80001eca:	00007717          	auipc	a4,0x7
    80001ece:	4ce70713          	addi	a4,a4,1230 # 80009398 <states.1760+0x168>
    80001ed2:	94ba                	add	s1,s1,a4
    80001ed4:	409c                	lw	a5,0(s1)
    80001ed6:	97ba                	add	a5,a5,a4
    80001ed8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eda:	6d3c                	ld	a5,88(a0)
    80001edc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ede:	60e2                	ld	ra,24(sp)
    80001ee0:	6442                	ld	s0,16(sp)
    80001ee2:	64a2                	ld	s1,8(sp)
    80001ee4:	6105                	addi	sp,sp,32
    80001ee6:	8082                	ret
    return p->trapframe->a1;
    80001ee8:	6d3c                	ld	a5,88(a0)
    80001eea:	7fa8                	ld	a0,120(a5)
    80001eec:	bfcd                	j	80001ede <argraw+0x30>
    return p->trapframe->a2;
    80001eee:	6d3c                	ld	a5,88(a0)
    80001ef0:	63c8                	ld	a0,128(a5)
    80001ef2:	b7f5                	j	80001ede <argraw+0x30>
    return p->trapframe->a3;
    80001ef4:	6d3c                	ld	a5,88(a0)
    80001ef6:	67c8                	ld	a0,136(a5)
    80001ef8:	b7dd                	j	80001ede <argraw+0x30>
    return p->trapframe->a4;
    80001efa:	6d3c                	ld	a5,88(a0)
    80001efc:	6bc8                	ld	a0,144(a5)
    80001efe:	b7c5                	j	80001ede <argraw+0x30>
    return p->trapframe->a5;
    80001f00:	6d3c                	ld	a5,88(a0)
    80001f02:	6fc8                	ld	a0,152(a5)
    80001f04:	bfe9                	j	80001ede <argraw+0x30>
  panic("argraw");
    80001f06:	00007517          	auipc	a0,0x7
    80001f0a:	46a50513          	addi	a0,a0,1130 # 80009370 <states.1760+0x140>
    80001f0e:	00005097          	auipc	ra,0x5
    80001f12:	d00080e7          	jalr	-768(ra) # 80006c0e <panic>

0000000080001f16 <fetchaddr>:
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	e04a                	sd	s2,0(sp)
    80001f20:	1000                	addi	s0,sp,32
    80001f22:	84aa                	mv	s1,a0
    80001f24:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	f9c080e7          	jalr	-100(ra) # 80000ec2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f2e:	653c                	ld	a5,72(a0)
    80001f30:	02f4f863          	bgeu	s1,a5,80001f60 <fetchaddr+0x4a>
    80001f34:	00848713          	addi	a4,s1,8
    80001f38:	02e7e663          	bltu	a5,a4,80001f64 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f3c:	46a1                	li	a3,8
    80001f3e:	8626                	mv	a2,s1
    80001f40:	85ca                	mv	a1,s2
    80001f42:	6928                	ld	a0,80(a0)
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	ca0080e7          	jalr	-864(ra) # 80000be4 <copyin>
    80001f4c:	00a03533          	snez	a0,a0
    80001f50:	40a00533          	neg	a0,a0
}
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	64a2                	ld	s1,8(sp)
    80001f5a:	6902                	ld	s2,0(sp)
    80001f5c:	6105                	addi	sp,sp,32
    80001f5e:	8082                	ret
    return -1;
    80001f60:	557d                	li	a0,-1
    80001f62:	bfcd                	j	80001f54 <fetchaddr+0x3e>
    80001f64:	557d                	li	a0,-1
    80001f66:	b7fd                	j	80001f54 <fetchaddr+0x3e>

0000000080001f68 <fetchstr>:
{
    80001f68:	7179                	addi	sp,sp,-48
    80001f6a:	f406                	sd	ra,40(sp)
    80001f6c:	f022                	sd	s0,32(sp)
    80001f6e:	ec26                	sd	s1,24(sp)
    80001f70:	e84a                	sd	s2,16(sp)
    80001f72:	e44e                	sd	s3,8(sp)
    80001f74:	1800                	addi	s0,sp,48
    80001f76:	892a                	mv	s2,a0
    80001f78:	84ae                	mv	s1,a1
    80001f7a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	f46080e7          	jalr	-186(ra) # 80000ec2 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f84:	86ce                	mv	a3,s3
    80001f86:	864a                	mv	a2,s2
    80001f88:	85a6                	mv	a1,s1
    80001f8a:	6928                	ld	a0,80(a0)
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	ce4080e7          	jalr	-796(ra) # 80000c70 <copyinstr>
  if(err < 0)
    80001f94:	00054763          	bltz	a0,80001fa2 <fetchstr+0x3a>
  return strlen(buf);
    80001f98:	8526                	mv	a0,s1
    80001f9a:	ffffe097          	auipc	ra,0xffffe
    80001f9e:	366080e7          	jalr	870(ra) # 80000300 <strlen>
}
    80001fa2:	70a2                	ld	ra,40(sp)
    80001fa4:	7402                	ld	s0,32(sp)
    80001fa6:	64e2                	ld	s1,24(sp)
    80001fa8:	6942                	ld	s2,16(sp)
    80001faa:	69a2                	ld	s3,8(sp)
    80001fac:	6145                	addi	sp,sp,48
    80001fae:	8082                	ret

0000000080001fb0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	1000                	addi	s0,sp,32
    80001fba:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	ef2080e7          	jalr	-270(ra) # 80001eae <argraw>
    80001fc4:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fc6:	4501                	li	a0,0
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6105                	addi	sp,sp,32
    80001fd0:	8082                	ret

0000000080001fd2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fd2:	1101                	addi	sp,sp,-32
    80001fd4:	ec06                	sd	ra,24(sp)
    80001fd6:	e822                	sd	s0,16(sp)
    80001fd8:	e426                	sd	s1,8(sp)
    80001fda:	1000                	addi	s0,sp,32
    80001fdc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fde:	00000097          	auipc	ra,0x0
    80001fe2:	ed0080e7          	jalr	-304(ra) # 80001eae <argraw>
    80001fe6:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fe8:	4501                	li	a0,0
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6105                	addi	sp,sp,32
    80001ff2:	8082                	ret

0000000080001ff4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001ff4:	1101                	addi	sp,sp,-32
    80001ff6:	ec06                	sd	ra,24(sp)
    80001ff8:	e822                	sd	s0,16(sp)
    80001ffa:	e426                	sd	s1,8(sp)
    80001ffc:	e04a                	sd	s2,0(sp)
    80001ffe:	1000                	addi	s0,sp,32
    80002000:	84ae                	mv	s1,a1
    80002002:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002004:	00000097          	auipc	ra,0x0
    80002008:	eaa080e7          	jalr	-342(ra) # 80001eae <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000200c:	864a                	mv	a2,s2
    8000200e:	85a6                	mv	a1,s1
    80002010:	00000097          	auipc	ra,0x0
    80002014:	f58080e7          	jalr	-168(ra) # 80001f68 <fetchstr>
}
    80002018:	60e2                	ld	ra,24(sp)
    8000201a:	6442                	ld	s0,16(sp)
    8000201c:	64a2                	ld	s1,8(sp)
    8000201e:	6902                	ld	s2,0(sp)
    80002020:	6105                	addi	sp,sp,32
    80002022:	8082                	ret

0000000080002024 <syscall>:



void
syscall(void)
{
    80002024:	1101                	addi	sp,sp,-32
    80002026:	ec06                	sd	ra,24(sp)
    80002028:	e822                	sd	s0,16(sp)
    8000202a:	e426                	sd	s1,8(sp)
    8000202c:	e04a                	sd	s2,0(sp)
    8000202e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	e92080e7          	jalr	-366(ra) # 80000ec2 <myproc>
    80002038:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000203a:	05853903          	ld	s2,88(a0)
    8000203e:	0a893783          	ld	a5,168(s2)
    80002042:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002046:	37fd                	addiw	a5,a5,-1
    80002048:	4771                	li	a4,28
    8000204a:	00f76f63          	bltu	a4,a5,80002068 <syscall+0x44>
    8000204e:	00369713          	slli	a4,a3,0x3
    80002052:	00007797          	auipc	a5,0x7
    80002056:	35e78793          	addi	a5,a5,862 # 800093b0 <syscalls>
    8000205a:	97ba                	add	a5,a5,a4
    8000205c:	639c                	ld	a5,0(a5)
    8000205e:	c789                	beqz	a5,80002068 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002060:	9782                	jalr	a5
    80002062:	06a93823          	sd	a0,112(s2)
    80002066:	a839                	j	80002084 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002068:	15848613          	addi	a2,s1,344
    8000206c:	5c8c                	lw	a1,56(s1)
    8000206e:	00007517          	auipc	a0,0x7
    80002072:	30a50513          	addi	a0,a0,778 # 80009378 <states.1760+0x148>
    80002076:	00005097          	auipc	ra,0x5
    8000207a:	be2080e7          	jalr	-1054(ra) # 80006c58 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000207e:	6cbc                	ld	a5,88(s1)
    80002080:	577d                	li	a4,-1
    80002082:	fbb8                	sd	a4,112(a5)
  }
}
    80002084:	60e2                	ld	ra,24(sp)
    80002086:	6442                	ld	s0,16(sp)
    80002088:	64a2                	ld	s1,8(sp)
    8000208a:	6902                	ld	s2,0(sp)
    8000208c:	6105                	addi	sp,sp,32
    8000208e:	8082                	ret

0000000080002090 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002090:	1101                	addi	sp,sp,-32
    80002092:	ec06                	sd	ra,24(sp)
    80002094:	e822                	sd	s0,16(sp)
    80002096:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002098:	fec40593          	addi	a1,s0,-20
    8000209c:	4501                	li	a0,0
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	f12080e7          	jalr	-238(ra) # 80001fb0 <argint>
    return -1;
    800020a6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020a8:	00054963          	bltz	a0,800020ba <sys_exit+0x2a>
  exit(n);
    800020ac:	fec42503          	lw	a0,-20(s0)
    800020b0:	fffff097          	auipc	ra,0xfffff
    800020b4:	4dc080e7          	jalr	1244(ra) # 8000158c <exit>
  return 0;  // not reached
    800020b8:	4781                	li	a5,0
}
    800020ba:	853e                	mv	a0,a5
    800020bc:	60e2                	ld	ra,24(sp)
    800020be:	6442                	ld	s0,16(sp)
    800020c0:	6105                	addi	sp,sp,32
    800020c2:	8082                	ret

00000000800020c4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020c4:	1141                	addi	sp,sp,-16
    800020c6:	e406                	sd	ra,8(sp)
    800020c8:	e022                	sd	s0,0(sp)
    800020ca:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	df6080e7          	jalr	-522(ra) # 80000ec2 <myproc>
}
    800020d4:	5d08                	lw	a0,56(a0)
    800020d6:	60a2                	ld	ra,8(sp)
    800020d8:	6402                	ld	s0,0(sp)
    800020da:	0141                	addi	sp,sp,16
    800020dc:	8082                	ret

00000000800020de <sys_fork>:

uint64
sys_fork(void)
{
    800020de:	1141                	addi	sp,sp,-16
    800020e0:	e406                	sd	ra,8(sp)
    800020e2:	e022                	sd	s0,0(sp)
    800020e4:	0800                	addi	s0,sp,16
  return fork();
    800020e6:	fffff097          	auipc	ra,0xfffff
    800020ea:	19c080e7          	jalr	412(ra) # 80001282 <fork>
}
    800020ee:	60a2                	ld	ra,8(sp)
    800020f0:	6402                	ld	s0,0(sp)
    800020f2:	0141                	addi	sp,sp,16
    800020f4:	8082                	ret

00000000800020f6 <sys_wait>:

uint64
sys_wait(void)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020fe:	fe840593          	addi	a1,s0,-24
    80002102:	4501                	li	a0,0
    80002104:	00000097          	auipc	ra,0x0
    80002108:	ece080e7          	jalr	-306(ra) # 80001fd2 <argaddr>
    8000210c:	87aa                	mv	a5,a0
    return -1;
    8000210e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002110:	0007c863          	bltz	a5,80002120 <sys_wait+0x2a>
  return wait(p);
    80002114:	fe843503          	ld	a0,-24(s0)
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	638080e7          	jalr	1592(ra) # 80001750 <wait>
}
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	6105                	addi	sp,sp,32
    80002126:	8082                	ret

0000000080002128 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002128:	7179                	addi	sp,sp,-48
    8000212a:	f406                	sd	ra,40(sp)
    8000212c:	f022                	sd	s0,32(sp)
    8000212e:	ec26                	sd	s1,24(sp)
    80002130:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002132:	fdc40593          	addi	a1,s0,-36
    80002136:	4501                	li	a0,0
    80002138:	00000097          	auipc	ra,0x0
    8000213c:	e78080e7          	jalr	-392(ra) # 80001fb0 <argint>
    80002140:	87aa                	mv	a5,a0
    return -1;
    80002142:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002144:	0207c063          	bltz	a5,80002164 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	d7a080e7          	jalr	-646(ra) # 80000ec2 <myproc>
    80002150:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002152:	fdc42503          	lw	a0,-36(s0)
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	0b8080e7          	jalr	184(ra) # 8000120e <growproc>
    8000215e:	00054863          	bltz	a0,8000216e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002162:	8526                	mv	a0,s1
}
    80002164:	70a2                	ld	ra,40(sp)
    80002166:	7402                	ld	s0,32(sp)
    80002168:	64e2                	ld	s1,24(sp)
    8000216a:	6145                	addi	sp,sp,48
    8000216c:	8082                	ret
    return -1;
    8000216e:	557d                	li	a0,-1
    80002170:	bfd5                	j	80002164 <sys_sbrk+0x3c>

0000000080002172 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002172:	7139                	addi	sp,sp,-64
    80002174:	fc06                	sd	ra,56(sp)
    80002176:	f822                	sd	s0,48(sp)
    80002178:	f426                	sd	s1,40(sp)
    8000217a:	f04a                	sd	s2,32(sp)
    8000217c:	ec4e                	sd	s3,24(sp)
    8000217e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002180:	fcc40593          	addi	a1,s0,-52
    80002184:	4501                	li	a0,0
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	e2a080e7          	jalr	-470(ra) # 80001fb0 <argint>
    return -1;
    8000218e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002190:	06054563          	bltz	a0,800021fa <sys_sleep+0x88>
  acquire(&tickslock);
    80002194:	0000e517          	auipc	a0,0xe
    80002198:	cf450513          	addi	a0,a0,-780 # 8000fe88 <tickslock>
    8000219c:	00005097          	auipc	ra,0x5
    800021a0:	fbc080e7          	jalr	-68(ra) # 80007158 <acquire>
  ticks0 = ticks;
    800021a4:	00008917          	auipc	s2,0x8
    800021a8:	e7492903          	lw	s2,-396(s2) # 8000a018 <ticks>
  while(ticks - ticks0 < n){
    800021ac:	fcc42783          	lw	a5,-52(s0)
    800021b0:	cf85                	beqz	a5,800021e8 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b2:	0000e997          	auipc	s3,0xe
    800021b6:	cd698993          	addi	s3,s3,-810 # 8000fe88 <tickslock>
    800021ba:	00008497          	auipc	s1,0x8
    800021be:	e5e48493          	addi	s1,s1,-418 # 8000a018 <ticks>
    if(myproc()->killed){
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	d00080e7          	jalr	-768(ra) # 80000ec2 <myproc>
    800021ca:	591c                	lw	a5,48(a0)
    800021cc:	ef9d                	bnez	a5,8000220a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021ce:	85ce                	mv	a1,s3
    800021d0:	8526                	mv	a0,s1
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	500080e7          	jalr	1280(ra) # 800016d2 <sleep>
  while(ticks - ticks0 < n){
    800021da:	409c                	lw	a5,0(s1)
    800021dc:	412787bb          	subw	a5,a5,s2
    800021e0:	fcc42703          	lw	a4,-52(s0)
    800021e4:	fce7efe3          	bltu	a5,a4,800021c2 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021e8:	0000e517          	auipc	a0,0xe
    800021ec:	ca050513          	addi	a0,a0,-864 # 8000fe88 <tickslock>
    800021f0:	00005097          	auipc	ra,0x5
    800021f4:	01c080e7          	jalr	28(ra) # 8000720c <release>
  return 0;
    800021f8:	4781                	li	a5,0
}
    800021fa:	853e                	mv	a0,a5
    800021fc:	70e2                	ld	ra,56(sp)
    800021fe:	7442                	ld	s0,48(sp)
    80002200:	74a2                	ld	s1,40(sp)
    80002202:	7902                	ld	s2,32(sp)
    80002204:	69e2                	ld	s3,24(sp)
    80002206:	6121                	addi	sp,sp,64
    80002208:	8082                	ret
      release(&tickslock);
    8000220a:	0000e517          	auipc	a0,0xe
    8000220e:	c7e50513          	addi	a0,a0,-898 # 8000fe88 <tickslock>
    80002212:	00005097          	auipc	ra,0x5
    80002216:	ffa080e7          	jalr	-6(ra) # 8000720c <release>
      return -1;
    8000221a:	57fd                	li	a5,-1
    8000221c:	bff9                	j	800021fa <sys_sleep+0x88>

000000008000221e <sys_kill>:

uint64
sys_kill(void)
{
    8000221e:	1101                	addi	sp,sp,-32
    80002220:	ec06                	sd	ra,24(sp)
    80002222:	e822                	sd	s0,16(sp)
    80002224:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002226:	fec40593          	addi	a1,s0,-20
    8000222a:	4501                	li	a0,0
    8000222c:	00000097          	auipc	ra,0x0
    80002230:	d84080e7          	jalr	-636(ra) # 80001fb0 <argint>
    80002234:	87aa                	mv	a5,a0
    return -1;
    80002236:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002238:	0007c863          	bltz	a5,80002248 <sys_kill+0x2a>
  return kill(pid);
    8000223c:	fec42503          	lw	a0,-20(s0)
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	682080e7          	jalr	1666(ra) # 800018c2 <kill>
}
    80002248:	60e2                	ld	ra,24(sp)
    8000224a:	6442                	ld	s0,16(sp)
    8000224c:	6105                	addi	sp,sp,32
    8000224e:	8082                	ret

0000000080002250 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002250:	1101                	addi	sp,sp,-32
    80002252:	ec06                	sd	ra,24(sp)
    80002254:	e822                	sd	s0,16(sp)
    80002256:	e426                	sd	s1,8(sp)
    80002258:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000225a:	0000e517          	auipc	a0,0xe
    8000225e:	c2e50513          	addi	a0,a0,-978 # 8000fe88 <tickslock>
    80002262:	00005097          	auipc	ra,0x5
    80002266:	ef6080e7          	jalr	-266(ra) # 80007158 <acquire>
  xticks = ticks;
    8000226a:	00008497          	auipc	s1,0x8
    8000226e:	dae4a483          	lw	s1,-594(s1) # 8000a018 <ticks>
  release(&tickslock);
    80002272:	0000e517          	auipc	a0,0xe
    80002276:	c1650513          	addi	a0,a0,-1002 # 8000fe88 <tickslock>
    8000227a:	00005097          	auipc	ra,0x5
    8000227e:	f92080e7          	jalr	-110(ra) # 8000720c <release>
  return xticks;
}
    80002282:	02049513          	slli	a0,s1,0x20
    80002286:	9101                	srli	a0,a0,0x20
    80002288:	60e2                	ld	ra,24(sp)
    8000228a:	6442                	ld	s0,16(sp)
    8000228c:	64a2                	ld	s1,8(sp)
    8000228e:	6105                	addi	sp,sp,32
    80002290:	8082                	ret

0000000080002292 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002292:	7179                	addi	sp,sp,-48
    80002294:	f406                	sd	ra,40(sp)
    80002296:	f022                	sd	s0,32(sp)
    80002298:	ec26                	sd	s1,24(sp)
    8000229a:	e84a                	sd	s2,16(sp)
    8000229c:	e44e                	sd	s3,8(sp)
    8000229e:	e052                	sd	s4,0(sp)
    800022a0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022a2:	00007597          	auipc	a1,0x7
    800022a6:	1fe58593          	addi	a1,a1,510 # 800094a0 <syscalls+0xf0>
    800022aa:	0000e517          	auipc	a0,0xe
    800022ae:	bf650513          	addi	a0,a0,-1034 # 8000fea0 <bcache>
    800022b2:	00005097          	auipc	ra,0x5
    800022b6:	e16080e7          	jalr	-490(ra) # 800070c8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022ba:	00016797          	auipc	a5,0x16
    800022be:	be678793          	addi	a5,a5,-1050 # 80017ea0 <bcache+0x8000>
    800022c2:	00016717          	auipc	a4,0x16
    800022c6:	e4670713          	addi	a4,a4,-442 # 80018108 <bcache+0x8268>
    800022ca:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022ce:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022d2:	0000e497          	auipc	s1,0xe
    800022d6:	be648493          	addi	s1,s1,-1050 # 8000feb8 <bcache+0x18>
    b->next = bcache.head.next;
    800022da:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022dc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022de:	00007a17          	auipc	s4,0x7
    800022e2:	1caa0a13          	addi	s4,s4,458 # 800094a8 <syscalls+0xf8>
    b->next = bcache.head.next;
    800022e6:	2b893783          	ld	a5,696(s2)
    800022ea:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022ec:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022f0:	85d2                	mv	a1,s4
    800022f2:	01048513          	addi	a0,s1,16
    800022f6:	00001097          	auipc	ra,0x1
    800022fa:	4c4080e7          	jalr	1220(ra) # 800037ba <initsleeplock>
    bcache.head.next->prev = b;
    800022fe:	2b893783          	ld	a5,696(s2)
    80002302:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002304:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002308:	45848493          	addi	s1,s1,1112
    8000230c:	fd349de3          	bne	s1,s3,800022e6 <binit+0x54>
  }
}
    80002310:	70a2                	ld	ra,40(sp)
    80002312:	7402                	ld	s0,32(sp)
    80002314:	64e2                	ld	s1,24(sp)
    80002316:	6942                	ld	s2,16(sp)
    80002318:	69a2                	ld	s3,8(sp)
    8000231a:	6a02                	ld	s4,0(sp)
    8000231c:	6145                	addi	sp,sp,48
    8000231e:	8082                	ret

0000000080002320 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002320:	7179                	addi	sp,sp,-48
    80002322:	f406                	sd	ra,40(sp)
    80002324:	f022                	sd	s0,32(sp)
    80002326:	ec26                	sd	s1,24(sp)
    80002328:	e84a                	sd	s2,16(sp)
    8000232a:	e44e                	sd	s3,8(sp)
    8000232c:	1800                	addi	s0,sp,48
    8000232e:	89aa                	mv	s3,a0
    80002330:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002332:	0000e517          	auipc	a0,0xe
    80002336:	b6e50513          	addi	a0,a0,-1170 # 8000fea0 <bcache>
    8000233a:	00005097          	auipc	ra,0x5
    8000233e:	e1e080e7          	jalr	-482(ra) # 80007158 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002342:	00016497          	auipc	s1,0x16
    80002346:	e164b483          	ld	s1,-490(s1) # 80018158 <bcache+0x82b8>
    8000234a:	00016797          	auipc	a5,0x16
    8000234e:	dbe78793          	addi	a5,a5,-578 # 80018108 <bcache+0x8268>
    80002352:	02f48f63          	beq	s1,a5,80002390 <bread+0x70>
    80002356:	873e                	mv	a4,a5
    80002358:	a021                	j	80002360 <bread+0x40>
    8000235a:	68a4                	ld	s1,80(s1)
    8000235c:	02e48a63          	beq	s1,a4,80002390 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002360:	449c                	lw	a5,8(s1)
    80002362:	ff379ce3          	bne	a5,s3,8000235a <bread+0x3a>
    80002366:	44dc                	lw	a5,12(s1)
    80002368:	ff2799e3          	bne	a5,s2,8000235a <bread+0x3a>
      b->refcnt++;
    8000236c:	40bc                	lw	a5,64(s1)
    8000236e:	2785                	addiw	a5,a5,1
    80002370:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002372:	0000e517          	auipc	a0,0xe
    80002376:	b2e50513          	addi	a0,a0,-1234 # 8000fea0 <bcache>
    8000237a:	00005097          	auipc	ra,0x5
    8000237e:	e92080e7          	jalr	-366(ra) # 8000720c <release>
      acquiresleep(&b->lock);
    80002382:	01048513          	addi	a0,s1,16
    80002386:	00001097          	auipc	ra,0x1
    8000238a:	46e080e7          	jalr	1134(ra) # 800037f4 <acquiresleep>
      return b;
    8000238e:	a8b9                	j	800023ec <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002390:	00016497          	auipc	s1,0x16
    80002394:	dc04b483          	ld	s1,-576(s1) # 80018150 <bcache+0x82b0>
    80002398:	00016797          	auipc	a5,0x16
    8000239c:	d7078793          	addi	a5,a5,-656 # 80018108 <bcache+0x8268>
    800023a0:	00f48863          	beq	s1,a5,800023b0 <bread+0x90>
    800023a4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023a6:	40bc                	lw	a5,64(s1)
    800023a8:	cf81                	beqz	a5,800023c0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023aa:	64a4                	ld	s1,72(s1)
    800023ac:	fee49de3          	bne	s1,a4,800023a6 <bread+0x86>
  panic("bget: no buffers");
    800023b0:	00007517          	auipc	a0,0x7
    800023b4:	10050513          	addi	a0,a0,256 # 800094b0 <syscalls+0x100>
    800023b8:	00005097          	auipc	ra,0x5
    800023bc:	856080e7          	jalr	-1962(ra) # 80006c0e <panic>
      b->dev = dev;
    800023c0:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800023c4:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800023c8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023cc:	4785                	li	a5,1
    800023ce:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023d0:	0000e517          	auipc	a0,0xe
    800023d4:	ad050513          	addi	a0,a0,-1328 # 8000fea0 <bcache>
    800023d8:	00005097          	auipc	ra,0x5
    800023dc:	e34080e7          	jalr	-460(ra) # 8000720c <release>
      acquiresleep(&b->lock);
    800023e0:	01048513          	addi	a0,s1,16
    800023e4:	00001097          	auipc	ra,0x1
    800023e8:	410080e7          	jalr	1040(ra) # 800037f4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023ec:	409c                	lw	a5,0(s1)
    800023ee:	cb89                	beqz	a5,80002400 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023f0:	8526                	mv	a0,s1
    800023f2:	70a2                	ld	ra,40(sp)
    800023f4:	7402                	ld	s0,32(sp)
    800023f6:	64e2                	ld	s1,24(sp)
    800023f8:	6942                	ld	s2,16(sp)
    800023fa:	69a2                	ld	s3,8(sp)
    800023fc:	6145                	addi	sp,sp,48
    800023fe:	8082                	ret
    virtio_disk_rw(b, 0);
    80002400:	4581                	li	a1,0
    80002402:	8526                	mv	a0,s1
    80002404:	00003097          	auipc	ra,0x3
    80002408:	fec080e7          	jalr	-20(ra) # 800053f0 <virtio_disk_rw>
    b->valid = 1;
    8000240c:	4785                	li	a5,1
    8000240e:	c09c                	sw	a5,0(s1)
  return b;
    80002410:	b7c5                	j	800023f0 <bread+0xd0>

0000000080002412 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002412:	1101                	addi	sp,sp,-32
    80002414:	ec06                	sd	ra,24(sp)
    80002416:	e822                	sd	s0,16(sp)
    80002418:	e426                	sd	s1,8(sp)
    8000241a:	1000                	addi	s0,sp,32
    8000241c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000241e:	0541                	addi	a0,a0,16
    80002420:	00001097          	auipc	ra,0x1
    80002424:	46e080e7          	jalr	1134(ra) # 8000388e <holdingsleep>
    80002428:	cd01                	beqz	a0,80002440 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000242a:	4585                	li	a1,1
    8000242c:	8526                	mv	a0,s1
    8000242e:	00003097          	auipc	ra,0x3
    80002432:	fc2080e7          	jalr	-62(ra) # 800053f0 <virtio_disk_rw>
}
    80002436:	60e2                	ld	ra,24(sp)
    80002438:	6442                	ld	s0,16(sp)
    8000243a:	64a2                	ld	s1,8(sp)
    8000243c:	6105                	addi	sp,sp,32
    8000243e:	8082                	ret
    panic("bwrite");
    80002440:	00007517          	auipc	a0,0x7
    80002444:	08850513          	addi	a0,a0,136 # 800094c8 <syscalls+0x118>
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	7c6080e7          	jalr	1990(ra) # 80006c0e <panic>

0000000080002450 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002450:	1101                	addi	sp,sp,-32
    80002452:	ec06                	sd	ra,24(sp)
    80002454:	e822                	sd	s0,16(sp)
    80002456:	e426                	sd	s1,8(sp)
    80002458:	e04a                	sd	s2,0(sp)
    8000245a:	1000                	addi	s0,sp,32
    8000245c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000245e:	01050913          	addi	s2,a0,16
    80002462:	854a                	mv	a0,s2
    80002464:	00001097          	auipc	ra,0x1
    80002468:	42a080e7          	jalr	1066(ra) # 8000388e <holdingsleep>
    8000246c:	c92d                	beqz	a0,800024de <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000246e:	854a                	mv	a0,s2
    80002470:	00001097          	auipc	ra,0x1
    80002474:	3da080e7          	jalr	986(ra) # 8000384a <releasesleep>

  acquire(&bcache.lock);
    80002478:	0000e517          	auipc	a0,0xe
    8000247c:	a2850513          	addi	a0,a0,-1496 # 8000fea0 <bcache>
    80002480:	00005097          	auipc	ra,0x5
    80002484:	cd8080e7          	jalr	-808(ra) # 80007158 <acquire>
  b->refcnt--;
    80002488:	40bc                	lw	a5,64(s1)
    8000248a:	37fd                	addiw	a5,a5,-1
    8000248c:	0007871b          	sext.w	a4,a5
    80002490:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002492:	eb05                	bnez	a4,800024c2 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002494:	68bc                	ld	a5,80(s1)
    80002496:	64b8                	ld	a4,72(s1)
    80002498:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000249a:	64bc                	ld	a5,72(s1)
    8000249c:	68b8                	ld	a4,80(s1)
    8000249e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024a0:	00016797          	auipc	a5,0x16
    800024a4:	a0078793          	addi	a5,a5,-1536 # 80017ea0 <bcache+0x8000>
    800024a8:	2b87b703          	ld	a4,696(a5)
    800024ac:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024ae:	00016717          	auipc	a4,0x16
    800024b2:	c5a70713          	addi	a4,a4,-934 # 80018108 <bcache+0x8268>
    800024b6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024b8:	2b87b703          	ld	a4,696(a5)
    800024bc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024be:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024c2:	0000e517          	auipc	a0,0xe
    800024c6:	9de50513          	addi	a0,a0,-1570 # 8000fea0 <bcache>
    800024ca:	00005097          	auipc	ra,0x5
    800024ce:	d42080e7          	jalr	-702(ra) # 8000720c <release>
}
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	64a2                	ld	s1,8(sp)
    800024d8:	6902                	ld	s2,0(sp)
    800024da:	6105                	addi	sp,sp,32
    800024dc:	8082                	ret
    panic("brelse");
    800024de:	00007517          	auipc	a0,0x7
    800024e2:	ff250513          	addi	a0,a0,-14 # 800094d0 <syscalls+0x120>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	728080e7          	jalr	1832(ra) # 80006c0e <panic>

00000000800024ee <bpin>:

void
bpin(struct buf *b) {
    800024ee:	1101                	addi	sp,sp,-32
    800024f0:	ec06                	sd	ra,24(sp)
    800024f2:	e822                	sd	s0,16(sp)
    800024f4:	e426                	sd	s1,8(sp)
    800024f6:	1000                	addi	s0,sp,32
    800024f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024fa:	0000e517          	auipc	a0,0xe
    800024fe:	9a650513          	addi	a0,a0,-1626 # 8000fea0 <bcache>
    80002502:	00005097          	auipc	ra,0x5
    80002506:	c56080e7          	jalr	-938(ra) # 80007158 <acquire>
  b->refcnt++;
    8000250a:	40bc                	lw	a5,64(s1)
    8000250c:	2785                	addiw	a5,a5,1
    8000250e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002510:	0000e517          	auipc	a0,0xe
    80002514:	99050513          	addi	a0,a0,-1648 # 8000fea0 <bcache>
    80002518:	00005097          	auipc	ra,0x5
    8000251c:	cf4080e7          	jalr	-780(ra) # 8000720c <release>
}
    80002520:	60e2                	ld	ra,24(sp)
    80002522:	6442                	ld	s0,16(sp)
    80002524:	64a2                	ld	s1,8(sp)
    80002526:	6105                	addi	sp,sp,32
    80002528:	8082                	ret

000000008000252a <bunpin>:

void
bunpin(struct buf *b) {
    8000252a:	1101                	addi	sp,sp,-32
    8000252c:	ec06                	sd	ra,24(sp)
    8000252e:	e822                	sd	s0,16(sp)
    80002530:	e426                	sd	s1,8(sp)
    80002532:	1000                	addi	s0,sp,32
    80002534:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002536:	0000e517          	auipc	a0,0xe
    8000253a:	96a50513          	addi	a0,a0,-1686 # 8000fea0 <bcache>
    8000253e:	00005097          	auipc	ra,0x5
    80002542:	c1a080e7          	jalr	-998(ra) # 80007158 <acquire>
  b->refcnt--;
    80002546:	40bc                	lw	a5,64(s1)
    80002548:	37fd                	addiw	a5,a5,-1
    8000254a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000254c:	0000e517          	auipc	a0,0xe
    80002550:	95450513          	addi	a0,a0,-1708 # 8000fea0 <bcache>
    80002554:	00005097          	auipc	ra,0x5
    80002558:	cb8080e7          	jalr	-840(ra) # 8000720c <release>
}
    8000255c:	60e2                	ld	ra,24(sp)
    8000255e:	6442                	ld	s0,16(sp)
    80002560:	64a2                	ld	s1,8(sp)
    80002562:	6105                	addi	sp,sp,32
    80002564:	8082                	ret

0000000080002566 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002566:	1101                	addi	sp,sp,-32
    80002568:	ec06                	sd	ra,24(sp)
    8000256a:	e822                	sd	s0,16(sp)
    8000256c:	e426                	sd	s1,8(sp)
    8000256e:	e04a                	sd	s2,0(sp)
    80002570:	1000                	addi	s0,sp,32
    80002572:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002574:	00d5d59b          	srliw	a1,a1,0xd
    80002578:	00016797          	auipc	a5,0x16
    8000257c:	0047a783          	lw	a5,4(a5) # 8001857c <sb+0x1c>
    80002580:	9dbd                	addw	a1,a1,a5
    80002582:	00000097          	auipc	ra,0x0
    80002586:	d9e080e7          	jalr	-610(ra) # 80002320 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000258a:	0074f713          	andi	a4,s1,7
    8000258e:	4785                	li	a5,1
    80002590:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002594:	14ce                	slli	s1,s1,0x33
    80002596:	90d9                	srli	s1,s1,0x36
    80002598:	00950733          	add	a4,a0,s1
    8000259c:	05874703          	lbu	a4,88(a4)
    800025a0:	00e7f6b3          	and	a3,a5,a4
    800025a4:	c69d                	beqz	a3,800025d2 <bfree+0x6c>
    800025a6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025a8:	94aa                	add	s1,s1,a0
    800025aa:	fff7c793          	not	a5,a5
    800025ae:	8ff9                	and	a5,a5,a4
    800025b0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800025b4:	00001097          	auipc	ra,0x1
    800025b8:	118080e7          	jalr	280(ra) # 800036cc <log_write>
  brelse(bp);
    800025bc:	854a                	mv	a0,s2
    800025be:	00000097          	auipc	ra,0x0
    800025c2:	e92080e7          	jalr	-366(ra) # 80002450 <brelse>
}
    800025c6:	60e2                	ld	ra,24(sp)
    800025c8:	6442                	ld	s0,16(sp)
    800025ca:	64a2                	ld	s1,8(sp)
    800025cc:	6902                	ld	s2,0(sp)
    800025ce:	6105                	addi	sp,sp,32
    800025d0:	8082                	ret
    panic("freeing free block");
    800025d2:	00007517          	auipc	a0,0x7
    800025d6:	f0650513          	addi	a0,a0,-250 # 800094d8 <syscalls+0x128>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	634080e7          	jalr	1588(ra) # 80006c0e <panic>

00000000800025e2 <balloc>:
{
    800025e2:	711d                	addi	sp,sp,-96
    800025e4:	ec86                	sd	ra,88(sp)
    800025e6:	e8a2                	sd	s0,80(sp)
    800025e8:	e4a6                	sd	s1,72(sp)
    800025ea:	e0ca                	sd	s2,64(sp)
    800025ec:	fc4e                	sd	s3,56(sp)
    800025ee:	f852                	sd	s4,48(sp)
    800025f0:	f456                	sd	s5,40(sp)
    800025f2:	f05a                	sd	s6,32(sp)
    800025f4:	ec5e                	sd	s7,24(sp)
    800025f6:	e862                	sd	s8,16(sp)
    800025f8:	e466                	sd	s9,8(sp)
    800025fa:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025fc:	00016797          	auipc	a5,0x16
    80002600:	f687a783          	lw	a5,-152(a5) # 80018564 <sb+0x4>
    80002604:	cbd1                	beqz	a5,80002698 <balloc+0xb6>
    80002606:	8baa                	mv	s7,a0
    80002608:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000260a:	00016b17          	auipc	s6,0x16
    8000260e:	f56b0b13          	addi	s6,s6,-170 # 80018560 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002612:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002614:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002616:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002618:	6c89                	lui	s9,0x2
    8000261a:	a831                	j	80002636 <balloc+0x54>
    brelse(bp);
    8000261c:	854a                	mv	a0,s2
    8000261e:	00000097          	auipc	ra,0x0
    80002622:	e32080e7          	jalr	-462(ra) # 80002450 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002626:	015c87bb          	addw	a5,s9,s5
    8000262a:	00078a9b          	sext.w	s5,a5
    8000262e:	004b2703          	lw	a4,4(s6)
    80002632:	06eaf363          	bgeu	s5,a4,80002698 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002636:	41fad79b          	sraiw	a5,s5,0x1f
    8000263a:	0137d79b          	srliw	a5,a5,0x13
    8000263e:	015787bb          	addw	a5,a5,s5
    80002642:	40d7d79b          	sraiw	a5,a5,0xd
    80002646:	01cb2583          	lw	a1,28(s6)
    8000264a:	9dbd                	addw	a1,a1,a5
    8000264c:	855e                	mv	a0,s7
    8000264e:	00000097          	auipc	ra,0x0
    80002652:	cd2080e7          	jalr	-814(ra) # 80002320 <bread>
    80002656:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002658:	004b2503          	lw	a0,4(s6)
    8000265c:	000a849b          	sext.w	s1,s5
    80002660:	8662                	mv	a2,s8
    80002662:	faa4fde3          	bgeu	s1,a0,8000261c <balloc+0x3a>
      m = 1 << (bi % 8);
    80002666:	41f6579b          	sraiw	a5,a2,0x1f
    8000266a:	01d7d69b          	srliw	a3,a5,0x1d
    8000266e:	00c6873b          	addw	a4,a3,a2
    80002672:	00777793          	andi	a5,a4,7
    80002676:	9f95                	subw	a5,a5,a3
    80002678:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000267c:	4037571b          	sraiw	a4,a4,0x3
    80002680:	00e906b3          	add	a3,s2,a4
    80002684:	0586c683          	lbu	a3,88(a3)
    80002688:	00d7f5b3          	and	a1,a5,a3
    8000268c:	cd91                	beqz	a1,800026a8 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000268e:	2605                	addiw	a2,a2,1
    80002690:	2485                	addiw	s1,s1,1
    80002692:	fd4618e3          	bne	a2,s4,80002662 <balloc+0x80>
    80002696:	b759                	j	8000261c <balloc+0x3a>
  panic("balloc: out of blocks");
    80002698:	00007517          	auipc	a0,0x7
    8000269c:	e5850513          	addi	a0,a0,-424 # 800094f0 <syscalls+0x140>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	56e080e7          	jalr	1390(ra) # 80006c0e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026a8:	974a                	add	a4,a4,s2
    800026aa:	8fd5                	or	a5,a5,a3
    800026ac:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026b0:	854a                	mv	a0,s2
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	01a080e7          	jalr	26(ra) # 800036cc <log_write>
        brelse(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	d94080e7          	jalr	-620(ra) # 80002450 <brelse>
  bp = bread(dev, bno);
    800026c4:	85a6                	mv	a1,s1
    800026c6:	855e                	mv	a0,s7
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	c58080e7          	jalr	-936(ra) # 80002320 <bread>
    800026d0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026d2:	40000613          	li	a2,1024
    800026d6:	4581                	li	a1,0
    800026d8:	05850513          	addi	a0,a0,88
    800026dc:	ffffe097          	auipc	ra,0xffffe
    800026e0:	a9c080e7          	jalr	-1380(ra) # 80000178 <memset>
  log_write(bp);
    800026e4:	854a                	mv	a0,s2
    800026e6:	00001097          	auipc	ra,0x1
    800026ea:	fe6080e7          	jalr	-26(ra) # 800036cc <log_write>
  brelse(bp);
    800026ee:	854a                	mv	a0,s2
    800026f0:	00000097          	auipc	ra,0x0
    800026f4:	d60080e7          	jalr	-672(ra) # 80002450 <brelse>
}
    800026f8:	8526                	mv	a0,s1
    800026fa:	60e6                	ld	ra,88(sp)
    800026fc:	6446                	ld	s0,80(sp)
    800026fe:	64a6                	ld	s1,72(sp)
    80002700:	6906                	ld	s2,64(sp)
    80002702:	79e2                	ld	s3,56(sp)
    80002704:	7a42                	ld	s4,48(sp)
    80002706:	7aa2                	ld	s5,40(sp)
    80002708:	7b02                	ld	s6,32(sp)
    8000270a:	6be2                	ld	s7,24(sp)
    8000270c:	6c42                	ld	s8,16(sp)
    8000270e:	6ca2                	ld	s9,8(sp)
    80002710:	6125                	addi	sp,sp,96
    80002712:	8082                	ret

0000000080002714 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002714:	7179                	addi	sp,sp,-48
    80002716:	f406                	sd	ra,40(sp)
    80002718:	f022                	sd	s0,32(sp)
    8000271a:	ec26                	sd	s1,24(sp)
    8000271c:	e84a                	sd	s2,16(sp)
    8000271e:	e44e                	sd	s3,8(sp)
    80002720:	e052                	sd	s4,0(sp)
    80002722:	1800                	addi	s0,sp,48
    80002724:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002726:	47ad                	li	a5,11
    80002728:	04b7fe63          	bgeu	a5,a1,80002784 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000272c:	ff45849b          	addiw	s1,a1,-12
    80002730:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002734:	0ff00793          	li	a5,255
    80002738:	0ae7e363          	bltu	a5,a4,800027de <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000273c:	08052583          	lw	a1,128(a0)
    80002740:	c5ad                	beqz	a1,800027aa <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002742:	00092503          	lw	a0,0(s2)
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	bda080e7          	jalr	-1062(ra) # 80002320 <bread>
    8000274e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002750:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002754:	02049593          	slli	a1,s1,0x20
    80002758:	9181                	srli	a1,a1,0x20
    8000275a:	058a                	slli	a1,a1,0x2
    8000275c:	00b784b3          	add	s1,a5,a1
    80002760:	0004a983          	lw	s3,0(s1)
    80002764:	04098d63          	beqz	s3,800027be <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002768:	8552                	mv	a0,s4
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	ce6080e7          	jalr	-794(ra) # 80002450 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002772:	854e                	mv	a0,s3
    80002774:	70a2                	ld	ra,40(sp)
    80002776:	7402                	ld	s0,32(sp)
    80002778:	64e2                	ld	s1,24(sp)
    8000277a:	6942                	ld	s2,16(sp)
    8000277c:	69a2                	ld	s3,8(sp)
    8000277e:	6a02                	ld	s4,0(sp)
    80002780:	6145                	addi	sp,sp,48
    80002782:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002784:	02059493          	slli	s1,a1,0x20
    80002788:	9081                	srli	s1,s1,0x20
    8000278a:	048a                	slli	s1,s1,0x2
    8000278c:	94aa                	add	s1,s1,a0
    8000278e:	0504a983          	lw	s3,80(s1)
    80002792:	fe0990e3          	bnez	s3,80002772 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002796:	4108                	lw	a0,0(a0)
    80002798:	00000097          	auipc	ra,0x0
    8000279c:	e4a080e7          	jalr	-438(ra) # 800025e2 <balloc>
    800027a0:	0005099b          	sext.w	s3,a0
    800027a4:	0534a823          	sw	s3,80(s1)
    800027a8:	b7e9                	j	80002772 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027aa:	4108                	lw	a0,0(a0)
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	e36080e7          	jalr	-458(ra) # 800025e2 <balloc>
    800027b4:	0005059b          	sext.w	a1,a0
    800027b8:	08b92023          	sw	a1,128(s2)
    800027bc:	b759                	j	80002742 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800027be:	00092503          	lw	a0,0(s2)
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	e20080e7          	jalr	-480(ra) # 800025e2 <balloc>
    800027ca:	0005099b          	sext.w	s3,a0
    800027ce:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027d2:	8552                	mv	a0,s4
    800027d4:	00001097          	auipc	ra,0x1
    800027d8:	ef8080e7          	jalr	-264(ra) # 800036cc <log_write>
    800027dc:	b771                	j	80002768 <bmap+0x54>
  panic("bmap: out of range");
    800027de:	00007517          	auipc	a0,0x7
    800027e2:	d2a50513          	addi	a0,a0,-726 # 80009508 <syscalls+0x158>
    800027e6:	00004097          	auipc	ra,0x4
    800027ea:	428080e7          	jalr	1064(ra) # 80006c0e <panic>

00000000800027ee <iget>:
{
    800027ee:	7179                	addi	sp,sp,-48
    800027f0:	f406                	sd	ra,40(sp)
    800027f2:	f022                	sd	s0,32(sp)
    800027f4:	ec26                	sd	s1,24(sp)
    800027f6:	e84a                	sd	s2,16(sp)
    800027f8:	e44e                	sd	s3,8(sp)
    800027fa:	e052                	sd	s4,0(sp)
    800027fc:	1800                	addi	s0,sp,48
    800027fe:	89aa                	mv	s3,a0
    80002800:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80002802:	00016517          	auipc	a0,0x16
    80002806:	d7e50513          	addi	a0,a0,-642 # 80018580 <icache>
    8000280a:	00005097          	auipc	ra,0x5
    8000280e:	94e080e7          	jalr	-1714(ra) # 80007158 <acquire>
  empty = 0;
    80002812:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80002814:	00016497          	auipc	s1,0x16
    80002818:	d8448493          	addi	s1,s1,-636 # 80018598 <icache+0x18>
    8000281c:	00018697          	auipc	a3,0x18
    80002820:	80c68693          	addi	a3,a3,-2036 # 8001a028 <log>
    80002824:	a039                	j	80002832 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002826:	02090b63          	beqz	s2,8000285c <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000282a:	08848493          	addi	s1,s1,136
    8000282e:	02d48a63          	beq	s1,a3,80002862 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002832:	449c                	lw	a5,8(s1)
    80002834:	fef059e3          	blez	a5,80002826 <iget+0x38>
    80002838:	4098                	lw	a4,0(s1)
    8000283a:	ff3716e3          	bne	a4,s3,80002826 <iget+0x38>
    8000283e:	40d8                	lw	a4,4(s1)
    80002840:	ff4713e3          	bne	a4,s4,80002826 <iget+0x38>
      ip->ref++;
    80002844:	2785                	addiw	a5,a5,1
    80002846:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80002848:	00016517          	auipc	a0,0x16
    8000284c:	d3850513          	addi	a0,a0,-712 # 80018580 <icache>
    80002850:	00005097          	auipc	ra,0x5
    80002854:	9bc080e7          	jalr	-1604(ra) # 8000720c <release>
      return ip;
    80002858:	8926                	mv	s2,s1
    8000285a:	a03d                	j	80002888 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000285c:	f7f9                	bnez	a5,8000282a <iget+0x3c>
    8000285e:	8926                	mv	s2,s1
    80002860:	b7e9                	j	8000282a <iget+0x3c>
  if(empty == 0)
    80002862:	02090c63          	beqz	s2,8000289a <iget+0xac>
  ip->dev = dev;
    80002866:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000286a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000286e:	4785                	li	a5,1
    80002870:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002874:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80002878:	00016517          	auipc	a0,0x16
    8000287c:	d0850513          	addi	a0,a0,-760 # 80018580 <icache>
    80002880:	00005097          	auipc	ra,0x5
    80002884:	98c080e7          	jalr	-1652(ra) # 8000720c <release>
}
    80002888:	854a                	mv	a0,s2
    8000288a:	70a2                	ld	ra,40(sp)
    8000288c:	7402                	ld	s0,32(sp)
    8000288e:	64e2                	ld	s1,24(sp)
    80002890:	6942                	ld	s2,16(sp)
    80002892:	69a2                	ld	s3,8(sp)
    80002894:	6a02                	ld	s4,0(sp)
    80002896:	6145                	addi	sp,sp,48
    80002898:	8082                	ret
    panic("iget: no inodes");
    8000289a:	00007517          	auipc	a0,0x7
    8000289e:	c8650513          	addi	a0,a0,-890 # 80009520 <syscalls+0x170>
    800028a2:	00004097          	auipc	ra,0x4
    800028a6:	36c080e7          	jalr	876(ra) # 80006c0e <panic>

00000000800028aa <fsinit>:
fsinit(int dev) {
    800028aa:	7179                	addi	sp,sp,-48
    800028ac:	f406                	sd	ra,40(sp)
    800028ae:	f022                	sd	s0,32(sp)
    800028b0:	ec26                	sd	s1,24(sp)
    800028b2:	e84a                	sd	s2,16(sp)
    800028b4:	e44e                	sd	s3,8(sp)
    800028b6:	1800                	addi	s0,sp,48
    800028b8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028ba:	4585                	li	a1,1
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	a64080e7          	jalr	-1436(ra) # 80002320 <bread>
    800028c4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028c6:	00016997          	auipc	s3,0x16
    800028ca:	c9a98993          	addi	s3,s3,-870 # 80018560 <sb>
    800028ce:	02000613          	li	a2,32
    800028d2:	05850593          	addi	a1,a0,88
    800028d6:	854e                	mv	a0,s3
    800028d8:	ffffe097          	auipc	ra,0xffffe
    800028dc:	900080e7          	jalr	-1792(ra) # 800001d8 <memmove>
  brelse(bp);
    800028e0:	8526                	mv	a0,s1
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	b6e080e7          	jalr	-1170(ra) # 80002450 <brelse>
  if(sb.magic != FSMAGIC)
    800028ea:	0009a703          	lw	a4,0(s3)
    800028ee:	102037b7          	lui	a5,0x10203
    800028f2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028f6:	02f71263          	bne	a4,a5,8000291a <fsinit+0x70>
  initlog(dev, &sb);
    800028fa:	00016597          	auipc	a1,0x16
    800028fe:	c6658593          	addi	a1,a1,-922 # 80018560 <sb>
    80002902:	854a                	mv	a0,s2
    80002904:	00001097          	auipc	ra,0x1
    80002908:	b4c080e7          	jalr	-1204(ra) # 80003450 <initlog>
}
    8000290c:	70a2                	ld	ra,40(sp)
    8000290e:	7402                	ld	s0,32(sp)
    80002910:	64e2                	ld	s1,24(sp)
    80002912:	6942                	ld	s2,16(sp)
    80002914:	69a2                	ld	s3,8(sp)
    80002916:	6145                	addi	sp,sp,48
    80002918:	8082                	ret
    panic("invalid file system");
    8000291a:	00007517          	auipc	a0,0x7
    8000291e:	c1650513          	addi	a0,a0,-1002 # 80009530 <syscalls+0x180>
    80002922:	00004097          	auipc	ra,0x4
    80002926:	2ec080e7          	jalr	748(ra) # 80006c0e <panic>

000000008000292a <iinit>:
{
    8000292a:	7179                	addi	sp,sp,-48
    8000292c:	f406                	sd	ra,40(sp)
    8000292e:	f022                	sd	s0,32(sp)
    80002930:	ec26                	sd	s1,24(sp)
    80002932:	e84a                	sd	s2,16(sp)
    80002934:	e44e                	sd	s3,8(sp)
    80002936:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80002938:	00007597          	auipc	a1,0x7
    8000293c:	c1058593          	addi	a1,a1,-1008 # 80009548 <syscalls+0x198>
    80002940:	00016517          	auipc	a0,0x16
    80002944:	c4050513          	addi	a0,a0,-960 # 80018580 <icache>
    80002948:	00004097          	auipc	ra,0x4
    8000294c:	780080e7          	jalr	1920(ra) # 800070c8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002950:	00016497          	auipc	s1,0x16
    80002954:	c5848493          	addi	s1,s1,-936 # 800185a8 <icache+0x28>
    80002958:	00017997          	auipc	s3,0x17
    8000295c:	6e098993          	addi	s3,s3,1760 # 8001a038 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80002960:	00007917          	auipc	s2,0x7
    80002964:	bf090913          	addi	s2,s2,-1040 # 80009550 <syscalls+0x1a0>
    80002968:	85ca                	mv	a1,s2
    8000296a:	8526                	mv	a0,s1
    8000296c:	00001097          	auipc	ra,0x1
    80002970:	e4e080e7          	jalr	-434(ra) # 800037ba <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002974:	08848493          	addi	s1,s1,136
    80002978:	ff3498e3          	bne	s1,s3,80002968 <iinit+0x3e>
}
    8000297c:	70a2                	ld	ra,40(sp)
    8000297e:	7402                	ld	s0,32(sp)
    80002980:	64e2                	ld	s1,24(sp)
    80002982:	6942                	ld	s2,16(sp)
    80002984:	69a2                	ld	s3,8(sp)
    80002986:	6145                	addi	sp,sp,48
    80002988:	8082                	ret

000000008000298a <ialloc>:
{
    8000298a:	715d                	addi	sp,sp,-80
    8000298c:	e486                	sd	ra,72(sp)
    8000298e:	e0a2                	sd	s0,64(sp)
    80002990:	fc26                	sd	s1,56(sp)
    80002992:	f84a                	sd	s2,48(sp)
    80002994:	f44e                	sd	s3,40(sp)
    80002996:	f052                	sd	s4,32(sp)
    80002998:	ec56                	sd	s5,24(sp)
    8000299a:	e85a                	sd	s6,16(sp)
    8000299c:	e45e                	sd	s7,8(sp)
    8000299e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a0:	00016717          	auipc	a4,0x16
    800029a4:	bcc72703          	lw	a4,-1076(a4) # 8001856c <sb+0xc>
    800029a8:	4785                	li	a5,1
    800029aa:	04e7fa63          	bgeu	a5,a4,800029fe <ialloc+0x74>
    800029ae:	8aaa                	mv	s5,a0
    800029b0:	8bae                	mv	s7,a1
    800029b2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029b4:	00016a17          	auipc	s4,0x16
    800029b8:	baca0a13          	addi	s4,s4,-1108 # 80018560 <sb>
    800029bc:	00048b1b          	sext.w	s6,s1
    800029c0:	0044d593          	srli	a1,s1,0x4
    800029c4:	018a2783          	lw	a5,24(s4)
    800029c8:	9dbd                	addw	a1,a1,a5
    800029ca:	8556                	mv	a0,s5
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	954080e7          	jalr	-1708(ra) # 80002320 <bread>
    800029d4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029d6:	05850993          	addi	s3,a0,88
    800029da:	00f4f793          	andi	a5,s1,15
    800029de:	079a                	slli	a5,a5,0x6
    800029e0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029e2:	00099783          	lh	a5,0(s3)
    800029e6:	c785                	beqz	a5,80002a0e <ialloc+0x84>
    brelse(bp);
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	a68080e7          	jalr	-1432(ra) # 80002450 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029f0:	0485                	addi	s1,s1,1
    800029f2:	00ca2703          	lw	a4,12(s4)
    800029f6:	0004879b          	sext.w	a5,s1
    800029fa:	fce7e1e3          	bltu	a5,a4,800029bc <ialloc+0x32>
  panic("ialloc: no inodes");
    800029fe:	00007517          	auipc	a0,0x7
    80002a02:	b5a50513          	addi	a0,a0,-1190 # 80009558 <syscalls+0x1a8>
    80002a06:	00004097          	auipc	ra,0x4
    80002a0a:	208080e7          	jalr	520(ra) # 80006c0e <panic>
      memset(dip, 0, sizeof(*dip));
    80002a0e:	04000613          	li	a2,64
    80002a12:	4581                	li	a1,0
    80002a14:	854e                	mv	a0,s3
    80002a16:	ffffd097          	auipc	ra,0xffffd
    80002a1a:	762080e7          	jalr	1890(ra) # 80000178 <memset>
      dip->type = type;
    80002a1e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a22:	854a                	mv	a0,s2
    80002a24:	00001097          	auipc	ra,0x1
    80002a28:	ca8080e7          	jalr	-856(ra) # 800036cc <log_write>
      brelse(bp);
    80002a2c:	854a                	mv	a0,s2
    80002a2e:	00000097          	auipc	ra,0x0
    80002a32:	a22080e7          	jalr	-1502(ra) # 80002450 <brelse>
      return iget(dev, inum);
    80002a36:	85da                	mv	a1,s6
    80002a38:	8556                	mv	a0,s5
    80002a3a:	00000097          	auipc	ra,0x0
    80002a3e:	db4080e7          	jalr	-588(ra) # 800027ee <iget>
}
    80002a42:	60a6                	ld	ra,72(sp)
    80002a44:	6406                	ld	s0,64(sp)
    80002a46:	74e2                	ld	s1,56(sp)
    80002a48:	7942                	ld	s2,48(sp)
    80002a4a:	79a2                	ld	s3,40(sp)
    80002a4c:	7a02                	ld	s4,32(sp)
    80002a4e:	6ae2                	ld	s5,24(sp)
    80002a50:	6b42                	ld	s6,16(sp)
    80002a52:	6ba2                	ld	s7,8(sp)
    80002a54:	6161                	addi	sp,sp,80
    80002a56:	8082                	ret

0000000080002a58 <iupdate>:
{
    80002a58:	1101                	addi	sp,sp,-32
    80002a5a:	ec06                	sd	ra,24(sp)
    80002a5c:	e822                	sd	s0,16(sp)
    80002a5e:	e426                	sd	s1,8(sp)
    80002a60:	e04a                	sd	s2,0(sp)
    80002a62:	1000                	addi	s0,sp,32
    80002a64:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a66:	415c                	lw	a5,4(a0)
    80002a68:	0047d79b          	srliw	a5,a5,0x4
    80002a6c:	00016597          	auipc	a1,0x16
    80002a70:	b0c5a583          	lw	a1,-1268(a1) # 80018578 <sb+0x18>
    80002a74:	9dbd                	addw	a1,a1,a5
    80002a76:	4108                	lw	a0,0(a0)
    80002a78:	00000097          	auipc	ra,0x0
    80002a7c:	8a8080e7          	jalr	-1880(ra) # 80002320 <bread>
    80002a80:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a82:	05850793          	addi	a5,a0,88
    80002a86:	40c8                	lw	a0,4(s1)
    80002a88:	893d                	andi	a0,a0,15
    80002a8a:	051a                	slli	a0,a0,0x6
    80002a8c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a8e:	04449703          	lh	a4,68(s1)
    80002a92:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a96:	04649703          	lh	a4,70(s1)
    80002a9a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a9e:	04849703          	lh	a4,72(s1)
    80002aa2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002aa6:	04a49703          	lh	a4,74(s1)
    80002aaa:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002aae:	44f8                	lw	a4,76(s1)
    80002ab0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ab2:	03400613          	li	a2,52
    80002ab6:	05048593          	addi	a1,s1,80
    80002aba:	0531                	addi	a0,a0,12
    80002abc:	ffffd097          	auipc	ra,0xffffd
    80002ac0:	71c080e7          	jalr	1820(ra) # 800001d8 <memmove>
  log_write(bp);
    80002ac4:	854a                	mv	a0,s2
    80002ac6:	00001097          	auipc	ra,0x1
    80002aca:	c06080e7          	jalr	-1018(ra) # 800036cc <log_write>
  brelse(bp);
    80002ace:	854a                	mv	a0,s2
    80002ad0:	00000097          	auipc	ra,0x0
    80002ad4:	980080e7          	jalr	-1664(ra) # 80002450 <brelse>
}
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6902                	ld	s2,0(sp)
    80002ae0:	6105                	addi	sp,sp,32
    80002ae2:	8082                	ret

0000000080002ae4 <idup>:
{
    80002ae4:	1101                	addi	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	e426                	sd	s1,8(sp)
    80002aec:	1000                	addi	s0,sp,32
    80002aee:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80002af0:	00016517          	auipc	a0,0x16
    80002af4:	a9050513          	addi	a0,a0,-1392 # 80018580 <icache>
    80002af8:	00004097          	auipc	ra,0x4
    80002afc:	660080e7          	jalr	1632(ra) # 80007158 <acquire>
  ip->ref++;
    80002b00:	449c                	lw	a5,8(s1)
    80002b02:	2785                	addiw	a5,a5,1
    80002b04:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80002b06:	00016517          	auipc	a0,0x16
    80002b0a:	a7a50513          	addi	a0,a0,-1414 # 80018580 <icache>
    80002b0e:	00004097          	auipc	ra,0x4
    80002b12:	6fe080e7          	jalr	1790(ra) # 8000720c <release>
}
    80002b16:	8526                	mv	a0,s1
    80002b18:	60e2                	ld	ra,24(sp)
    80002b1a:	6442                	ld	s0,16(sp)
    80002b1c:	64a2                	ld	s1,8(sp)
    80002b1e:	6105                	addi	sp,sp,32
    80002b20:	8082                	ret

0000000080002b22 <ilock>:
{
    80002b22:	1101                	addi	sp,sp,-32
    80002b24:	ec06                	sd	ra,24(sp)
    80002b26:	e822                	sd	s0,16(sp)
    80002b28:	e426                	sd	s1,8(sp)
    80002b2a:	e04a                	sd	s2,0(sp)
    80002b2c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b2e:	c115                	beqz	a0,80002b52 <ilock+0x30>
    80002b30:	84aa                	mv	s1,a0
    80002b32:	451c                	lw	a5,8(a0)
    80002b34:	00f05f63          	blez	a5,80002b52 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b38:	0541                	addi	a0,a0,16
    80002b3a:	00001097          	auipc	ra,0x1
    80002b3e:	cba080e7          	jalr	-838(ra) # 800037f4 <acquiresleep>
  if(ip->valid == 0){
    80002b42:	40bc                	lw	a5,64(s1)
    80002b44:	cf99                	beqz	a5,80002b62 <ilock+0x40>
}
    80002b46:	60e2                	ld	ra,24(sp)
    80002b48:	6442                	ld	s0,16(sp)
    80002b4a:	64a2                	ld	s1,8(sp)
    80002b4c:	6902                	ld	s2,0(sp)
    80002b4e:	6105                	addi	sp,sp,32
    80002b50:	8082                	ret
    panic("ilock");
    80002b52:	00007517          	auipc	a0,0x7
    80002b56:	a1e50513          	addi	a0,a0,-1506 # 80009570 <syscalls+0x1c0>
    80002b5a:	00004097          	auipc	ra,0x4
    80002b5e:	0b4080e7          	jalr	180(ra) # 80006c0e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b62:	40dc                	lw	a5,4(s1)
    80002b64:	0047d79b          	srliw	a5,a5,0x4
    80002b68:	00016597          	auipc	a1,0x16
    80002b6c:	a105a583          	lw	a1,-1520(a1) # 80018578 <sb+0x18>
    80002b70:	9dbd                	addw	a1,a1,a5
    80002b72:	4088                	lw	a0,0(s1)
    80002b74:	fffff097          	auipc	ra,0xfffff
    80002b78:	7ac080e7          	jalr	1964(ra) # 80002320 <bread>
    80002b7c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b7e:	05850593          	addi	a1,a0,88
    80002b82:	40dc                	lw	a5,4(s1)
    80002b84:	8bbd                	andi	a5,a5,15
    80002b86:	079a                	slli	a5,a5,0x6
    80002b88:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b8a:	00059783          	lh	a5,0(a1)
    80002b8e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b92:	00259783          	lh	a5,2(a1)
    80002b96:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b9a:	00459783          	lh	a5,4(a1)
    80002b9e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ba2:	00659783          	lh	a5,6(a1)
    80002ba6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002baa:	459c                	lw	a5,8(a1)
    80002bac:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bae:	03400613          	li	a2,52
    80002bb2:	05b1                	addi	a1,a1,12
    80002bb4:	05048513          	addi	a0,s1,80
    80002bb8:	ffffd097          	auipc	ra,0xffffd
    80002bbc:	620080e7          	jalr	1568(ra) # 800001d8 <memmove>
    brelse(bp);
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	88e080e7          	jalr	-1906(ra) # 80002450 <brelse>
    ip->valid = 1;
    80002bca:	4785                	li	a5,1
    80002bcc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bce:	04449783          	lh	a5,68(s1)
    80002bd2:	fbb5                	bnez	a5,80002b46 <ilock+0x24>
      panic("ilock: no type");
    80002bd4:	00007517          	auipc	a0,0x7
    80002bd8:	9a450513          	addi	a0,a0,-1628 # 80009578 <syscalls+0x1c8>
    80002bdc:	00004097          	auipc	ra,0x4
    80002be0:	032080e7          	jalr	50(ra) # 80006c0e <panic>

0000000080002be4 <iunlock>:
{
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	e426                	sd	s1,8(sp)
    80002bec:	e04a                	sd	s2,0(sp)
    80002bee:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bf0:	c905                	beqz	a0,80002c20 <iunlock+0x3c>
    80002bf2:	84aa                	mv	s1,a0
    80002bf4:	01050913          	addi	s2,a0,16
    80002bf8:	854a                	mv	a0,s2
    80002bfa:	00001097          	auipc	ra,0x1
    80002bfe:	c94080e7          	jalr	-876(ra) # 8000388e <holdingsleep>
    80002c02:	cd19                	beqz	a0,80002c20 <iunlock+0x3c>
    80002c04:	449c                	lw	a5,8(s1)
    80002c06:	00f05d63          	blez	a5,80002c20 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	c3e080e7          	jalr	-962(ra) # 8000384a <releasesleep>
}
    80002c14:	60e2                	ld	ra,24(sp)
    80002c16:	6442                	ld	s0,16(sp)
    80002c18:	64a2                	ld	s1,8(sp)
    80002c1a:	6902                	ld	s2,0(sp)
    80002c1c:	6105                	addi	sp,sp,32
    80002c1e:	8082                	ret
    panic("iunlock");
    80002c20:	00007517          	auipc	a0,0x7
    80002c24:	96850513          	addi	a0,a0,-1688 # 80009588 <syscalls+0x1d8>
    80002c28:	00004097          	auipc	ra,0x4
    80002c2c:	fe6080e7          	jalr	-26(ra) # 80006c0e <panic>

0000000080002c30 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c30:	7179                	addi	sp,sp,-48
    80002c32:	f406                	sd	ra,40(sp)
    80002c34:	f022                	sd	s0,32(sp)
    80002c36:	ec26                	sd	s1,24(sp)
    80002c38:	e84a                	sd	s2,16(sp)
    80002c3a:	e44e                	sd	s3,8(sp)
    80002c3c:	e052                	sd	s4,0(sp)
    80002c3e:	1800                	addi	s0,sp,48
    80002c40:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c42:	05050493          	addi	s1,a0,80
    80002c46:	08050913          	addi	s2,a0,128
    80002c4a:	a021                	j	80002c52 <itrunc+0x22>
    80002c4c:	0491                	addi	s1,s1,4
    80002c4e:	01248d63          	beq	s1,s2,80002c68 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c52:	408c                	lw	a1,0(s1)
    80002c54:	dde5                	beqz	a1,80002c4c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c56:	0009a503          	lw	a0,0(s3)
    80002c5a:	00000097          	auipc	ra,0x0
    80002c5e:	90c080e7          	jalr	-1780(ra) # 80002566 <bfree>
      ip->addrs[i] = 0;
    80002c62:	0004a023          	sw	zero,0(s1)
    80002c66:	b7dd                	j	80002c4c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c68:	0809a583          	lw	a1,128(s3)
    80002c6c:	e185                	bnez	a1,80002c8c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c6e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c72:	854e                	mv	a0,s3
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	de4080e7          	jalr	-540(ra) # 80002a58 <iupdate>
}
    80002c7c:	70a2                	ld	ra,40(sp)
    80002c7e:	7402                	ld	s0,32(sp)
    80002c80:	64e2                	ld	s1,24(sp)
    80002c82:	6942                	ld	s2,16(sp)
    80002c84:	69a2                	ld	s3,8(sp)
    80002c86:	6a02                	ld	s4,0(sp)
    80002c88:	6145                	addi	sp,sp,48
    80002c8a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c8c:	0009a503          	lw	a0,0(s3)
    80002c90:	fffff097          	auipc	ra,0xfffff
    80002c94:	690080e7          	jalr	1680(ra) # 80002320 <bread>
    80002c98:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c9a:	05850493          	addi	s1,a0,88
    80002c9e:	45850913          	addi	s2,a0,1112
    80002ca2:	a811                	j	80002cb6 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ca4:	0009a503          	lw	a0,0(s3)
    80002ca8:	00000097          	auipc	ra,0x0
    80002cac:	8be080e7          	jalr	-1858(ra) # 80002566 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002cb0:	0491                	addi	s1,s1,4
    80002cb2:	01248563          	beq	s1,s2,80002cbc <itrunc+0x8c>
      if(a[j])
    80002cb6:	408c                	lw	a1,0(s1)
    80002cb8:	dde5                	beqz	a1,80002cb0 <itrunc+0x80>
    80002cba:	b7ed                	j	80002ca4 <itrunc+0x74>
    brelse(bp);
    80002cbc:	8552                	mv	a0,s4
    80002cbe:	fffff097          	auipc	ra,0xfffff
    80002cc2:	792080e7          	jalr	1938(ra) # 80002450 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cc6:	0809a583          	lw	a1,128(s3)
    80002cca:	0009a503          	lw	a0,0(s3)
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	898080e7          	jalr	-1896(ra) # 80002566 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cd6:	0809a023          	sw	zero,128(s3)
    80002cda:	bf51                	j	80002c6e <itrunc+0x3e>

0000000080002cdc <iput>:
{
    80002cdc:	1101                	addi	sp,sp,-32
    80002cde:	ec06                	sd	ra,24(sp)
    80002ce0:	e822                	sd	s0,16(sp)
    80002ce2:	e426                	sd	s1,8(sp)
    80002ce4:	e04a                	sd	s2,0(sp)
    80002ce6:	1000                	addi	s0,sp,32
    80002ce8:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80002cea:	00016517          	auipc	a0,0x16
    80002cee:	89650513          	addi	a0,a0,-1898 # 80018580 <icache>
    80002cf2:	00004097          	auipc	ra,0x4
    80002cf6:	466080e7          	jalr	1126(ra) # 80007158 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cfa:	4498                	lw	a4,8(s1)
    80002cfc:	4785                	li	a5,1
    80002cfe:	02f70363          	beq	a4,a5,80002d24 <iput+0x48>
  ip->ref--;
    80002d02:	449c                	lw	a5,8(s1)
    80002d04:	37fd                	addiw	a5,a5,-1
    80002d06:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80002d08:	00016517          	auipc	a0,0x16
    80002d0c:	87850513          	addi	a0,a0,-1928 # 80018580 <icache>
    80002d10:	00004097          	auipc	ra,0x4
    80002d14:	4fc080e7          	jalr	1276(ra) # 8000720c <release>
}
    80002d18:	60e2                	ld	ra,24(sp)
    80002d1a:	6442                	ld	s0,16(sp)
    80002d1c:	64a2                	ld	s1,8(sp)
    80002d1e:	6902                	ld	s2,0(sp)
    80002d20:	6105                	addi	sp,sp,32
    80002d22:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d24:	40bc                	lw	a5,64(s1)
    80002d26:	dff1                	beqz	a5,80002d02 <iput+0x26>
    80002d28:	04a49783          	lh	a5,74(s1)
    80002d2c:	fbf9                	bnez	a5,80002d02 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d2e:	01048913          	addi	s2,s1,16
    80002d32:	854a                	mv	a0,s2
    80002d34:	00001097          	auipc	ra,0x1
    80002d38:	ac0080e7          	jalr	-1344(ra) # 800037f4 <acquiresleep>
    release(&icache.lock);
    80002d3c:	00016517          	auipc	a0,0x16
    80002d40:	84450513          	addi	a0,a0,-1980 # 80018580 <icache>
    80002d44:	00004097          	auipc	ra,0x4
    80002d48:	4c8080e7          	jalr	1224(ra) # 8000720c <release>
    itrunc(ip);
    80002d4c:	8526                	mv	a0,s1
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	ee2080e7          	jalr	-286(ra) # 80002c30 <itrunc>
    ip->type = 0;
    80002d56:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d5a:	8526                	mv	a0,s1
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	cfc080e7          	jalr	-772(ra) # 80002a58 <iupdate>
    ip->valid = 0;
    80002d64:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d68:	854a                	mv	a0,s2
    80002d6a:	00001097          	auipc	ra,0x1
    80002d6e:	ae0080e7          	jalr	-1312(ra) # 8000384a <releasesleep>
    acquire(&icache.lock);
    80002d72:	00016517          	auipc	a0,0x16
    80002d76:	80e50513          	addi	a0,a0,-2034 # 80018580 <icache>
    80002d7a:	00004097          	auipc	ra,0x4
    80002d7e:	3de080e7          	jalr	990(ra) # 80007158 <acquire>
    80002d82:	b741                	j	80002d02 <iput+0x26>

0000000080002d84 <iunlockput>:
{
    80002d84:	1101                	addi	sp,sp,-32
    80002d86:	ec06                	sd	ra,24(sp)
    80002d88:	e822                	sd	s0,16(sp)
    80002d8a:	e426                	sd	s1,8(sp)
    80002d8c:	1000                	addi	s0,sp,32
    80002d8e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d90:	00000097          	auipc	ra,0x0
    80002d94:	e54080e7          	jalr	-428(ra) # 80002be4 <iunlock>
  iput(ip);
    80002d98:	8526                	mv	a0,s1
    80002d9a:	00000097          	auipc	ra,0x0
    80002d9e:	f42080e7          	jalr	-190(ra) # 80002cdc <iput>
}
    80002da2:	60e2                	ld	ra,24(sp)
    80002da4:	6442                	ld	s0,16(sp)
    80002da6:	64a2                	ld	s1,8(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret

0000000080002dac <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dac:	1141                	addi	sp,sp,-16
    80002dae:	e422                	sd	s0,8(sp)
    80002db0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002db2:	411c                	lw	a5,0(a0)
    80002db4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002db6:	415c                	lw	a5,4(a0)
    80002db8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dba:	04451783          	lh	a5,68(a0)
    80002dbe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dc2:	04a51783          	lh	a5,74(a0)
    80002dc6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002dca:	04c56783          	lwu	a5,76(a0)
    80002dce:	e99c                	sd	a5,16(a1)
}
    80002dd0:	6422                	ld	s0,8(sp)
    80002dd2:	0141                	addi	sp,sp,16
    80002dd4:	8082                	ret

0000000080002dd6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002dd6:	457c                	lw	a5,76(a0)
    80002dd8:	0ed7e963          	bltu	a5,a3,80002eca <readi+0xf4>
{
    80002ddc:	7159                	addi	sp,sp,-112
    80002dde:	f486                	sd	ra,104(sp)
    80002de0:	f0a2                	sd	s0,96(sp)
    80002de2:	eca6                	sd	s1,88(sp)
    80002de4:	e8ca                	sd	s2,80(sp)
    80002de6:	e4ce                	sd	s3,72(sp)
    80002de8:	e0d2                	sd	s4,64(sp)
    80002dea:	fc56                	sd	s5,56(sp)
    80002dec:	f85a                	sd	s6,48(sp)
    80002dee:	f45e                	sd	s7,40(sp)
    80002df0:	f062                	sd	s8,32(sp)
    80002df2:	ec66                	sd	s9,24(sp)
    80002df4:	e86a                	sd	s10,16(sp)
    80002df6:	e46e                	sd	s11,8(sp)
    80002df8:	1880                	addi	s0,sp,112
    80002dfa:	8baa                	mv	s7,a0
    80002dfc:	8c2e                	mv	s8,a1
    80002dfe:	8ab2                	mv	s5,a2
    80002e00:	84b6                	mv	s1,a3
    80002e02:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e04:	9f35                	addw	a4,a4,a3
    return 0;
    80002e06:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e08:	0ad76063          	bltu	a4,a3,80002ea8 <readi+0xd2>
  if(off + n > ip->size)
    80002e0c:	00e7f463          	bgeu	a5,a4,80002e14 <readi+0x3e>
    n = ip->size - off;
    80002e10:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e14:	0a0b0963          	beqz	s6,80002ec6 <readi+0xf0>
    80002e18:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e1a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e1e:	5cfd                	li	s9,-1
    80002e20:	a82d                	j	80002e5a <readi+0x84>
    80002e22:	020a1d93          	slli	s11,s4,0x20
    80002e26:	020ddd93          	srli	s11,s11,0x20
    80002e2a:	05890613          	addi	a2,s2,88
    80002e2e:	86ee                	mv	a3,s11
    80002e30:	963a                	add	a2,a2,a4
    80002e32:	85d6                	mv	a1,s5
    80002e34:	8562                	mv	a0,s8
    80002e36:	fffff097          	auipc	ra,0xfffff
    80002e3a:	afe080e7          	jalr	-1282(ra) # 80001934 <either_copyout>
    80002e3e:	05950d63          	beq	a0,s9,80002e98 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e42:	854a                	mv	a0,s2
    80002e44:	fffff097          	auipc	ra,0xfffff
    80002e48:	60c080e7          	jalr	1548(ra) # 80002450 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e4c:	013a09bb          	addw	s3,s4,s3
    80002e50:	009a04bb          	addw	s1,s4,s1
    80002e54:	9aee                	add	s5,s5,s11
    80002e56:	0569f763          	bgeu	s3,s6,80002ea4 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e5a:	000ba903          	lw	s2,0(s7)
    80002e5e:	00a4d59b          	srliw	a1,s1,0xa
    80002e62:	855e                	mv	a0,s7
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	8b0080e7          	jalr	-1872(ra) # 80002714 <bmap>
    80002e6c:	0005059b          	sext.w	a1,a0
    80002e70:	854a                	mv	a0,s2
    80002e72:	fffff097          	auipc	ra,0xfffff
    80002e76:	4ae080e7          	jalr	1198(ra) # 80002320 <bread>
    80002e7a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e7c:	3ff4f713          	andi	a4,s1,1023
    80002e80:	40ed07bb          	subw	a5,s10,a4
    80002e84:	413b06bb          	subw	a3,s6,s3
    80002e88:	8a3e                	mv	s4,a5
    80002e8a:	2781                	sext.w	a5,a5
    80002e8c:	0006861b          	sext.w	a2,a3
    80002e90:	f8f679e3          	bgeu	a2,a5,80002e22 <readi+0x4c>
    80002e94:	8a36                	mv	s4,a3
    80002e96:	b771                	j	80002e22 <readi+0x4c>
      brelse(bp);
    80002e98:	854a                	mv	a0,s2
    80002e9a:	fffff097          	auipc	ra,0xfffff
    80002e9e:	5b6080e7          	jalr	1462(ra) # 80002450 <brelse>
      tot = -1;
    80002ea2:	59fd                	li	s3,-1
  }
  return tot;
    80002ea4:	0009851b          	sext.w	a0,s3
}
    80002ea8:	70a6                	ld	ra,104(sp)
    80002eaa:	7406                	ld	s0,96(sp)
    80002eac:	64e6                	ld	s1,88(sp)
    80002eae:	6946                	ld	s2,80(sp)
    80002eb0:	69a6                	ld	s3,72(sp)
    80002eb2:	6a06                	ld	s4,64(sp)
    80002eb4:	7ae2                	ld	s5,56(sp)
    80002eb6:	7b42                	ld	s6,48(sp)
    80002eb8:	7ba2                	ld	s7,40(sp)
    80002eba:	7c02                	ld	s8,32(sp)
    80002ebc:	6ce2                	ld	s9,24(sp)
    80002ebe:	6d42                	ld	s10,16(sp)
    80002ec0:	6da2                	ld	s11,8(sp)
    80002ec2:	6165                	addi	sp,sp,112
    80002ec4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec6:	89da                	mv	s3,s6
    80002ec8:	bff1                	j	80002ea4 <readi+0xce>
    return 0;
    80002eca:	4501                	li	a0,0
}
    80002ecc:	8082                	ret

0000000080002ece <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ece:	457c                	lw	a5,76(a0)
    80002ed0:	10d7e863          	bltu	a5,a3,80002fe0 <writei+0x112>
{
    80002ed4:	7159                	addi	sp,sp,-112
    80002ed6:	f486                	sd	ra,104(sp)
    80002ed8:	f0a2                	sd	s0,96(sp)
    80002eda:	eca6                	sd	s1,88(sp)
    80002edc:	e8ca                	sd	s2,80(sp)
    80002ede:	e4ce                	sd	s3,72(sp)
    80002ee0:	e0d2                	sd	s4,64(sp)
    80002ee2:	fc56                	sd	s5,56(sp)
    80002ee4:	f85a                	sd	s6,48(sp)
    80002ee6:	f45e                	sd	s7,40(sp)
    80002ee8:	f062                	sd	s8,32(sp)
    80002eea:	ec66                	sd	s9,24(sp)
    80002eec:	e86a                	sd	s10,16(sp)
    80002eee:	e46e                	sd	s11,8(sp)
    80002ef0:	1880                	addi	s0,sp,112
    80002ef2:	8b2a                	mv	s6,a0
    80002ef4:	8c2e                	mv	s8,a1
    80002ef6:	8ab2                	mv	s5,a2
    80002ef8:	8936                	mv	s2,a3
    80002efa:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002efc:	00e687bb          	addw	a5,a3,a4
    80002f00:	0ed7e263          	bltu	a5,a3,80002fe4 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f04:	00043737          	lui	a4,0x43
    80002f08:	0ef76063          	bltu	a4,a5,80002fe8 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f0c:	0c0b8863          	beqz	s7,80002fdc <writei+0x10e>
    80002f10:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f12:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f16:	5cfd                	li	s9,-1
    80002f18:	a091                	j	80002f5c <writei+0x8e>
    80002f1a:	02099d93          	slli	s11,s3,0x20
    80002f1e:	020ddd93          	srli	s11,s11,0x20
    80002f22:	05848513          	addi	a0,s1,88
    80002f26:	86ee                	mv	a3,s11
    80002f28:	8656                	mv	a2,s5
    80002f2a:	85e2                	mv	a1,s8
    80002f2c:	953a                	add	a0,a0,a4
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	a5c080e7          	jalr	-1444(ra) # 8000198a <either_copyin>
    80002f36:	07950263          	beq	a0,s9,80002f9a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f3a:	8526                	mv	a0,s1
    80002f3c:	00000097          	auipc	ra,0x0
    80002f40:	790080e7          	jalr	1936(ra) # 800036cc <log_write>
    brelse(bp);
    80002f44:	8526                	mv	a0,s1
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	50a080e7          	jalr	1290(ra) # 80002450 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f4e:	01498a3b          	addw	s4,s3,s4
    80002f52:	0129893b          	addw	s2,s3,s2
    80002f56:	9aee                	add	s5,s5,s11
    80002f58:	057a7663          	bgeu	s4,s7,80002fa4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f5c:	000b2483          	lw	s1,0(s6)
    80002f60:	00a9559b          	srliw	a1,s2,0xa
    80002f64:	855a                	mv	a0,s6
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	7ae080e7          	jalr	1966(ra) # 80002714 <bmap>
    80002f6e:	0005059b          	sext.w	a1,a0
    80002f72:	8526                	mv	a0,s1
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	3ac080e7          	jalr	940(ra) # 80002320 <bread>
    80002f7c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7e:	3ff97713          	andi	a4,s2,1023
    80002f82:	40ed07bb          	subw	a5,s10,a4
    80002f86:	414b86bb          	subw	a3,s7,s4
    80002f8a:	89be                	mv	s3,a5
    80002f8c:	2781                	sext.w	a5,a5
    80002f8e:	0006861b          	sext.w	a2,a3
    80002f92:	f8f674e3          	bgeu	a2,a5,80002f1a <writei+0x4c>
    80002f96:	89b6                	mv	s3,a3
    80002f98:	b749                	j	80002f1a <writei+0x4c>
      brelse(bp);
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	4b4080e7          	jalr	1204(ra) # 80002450 <brelse>
  }

  if(off > ip->size)
    80002fa4:	04cb2783          	lw	a5,76(s6)
    80002fa8:	0127f463          	bgeu	a5,s2,80002fb0 <writei+0xe2>
    ip->size = off;
    80002fac:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fb0:	855a                	mv	a0,s6
    80002fb2:	00000097          	auipc	ra,0x0
    80002fb6:	aa6080e7          	jalr	-1370(ra) # 80002a58 <iupdate>

  return tot;
    80002fba:	000a051b          	sext.w	a0,s4
}
    80002fbe:	70a6                	ld	ra,104(sp)
    80002fc0:	7406                	ld	s0,96(sp)
    80002fc2:	64e6                	ld	s1,88(sp)
    80002fc4:	6946                	ld	s2,80(sp)
    80002fc6:	69a6                	ld	s3,72(sp)
    80002fc8:	6a06                	ld	s4,64(sp)
    80002fca:	7ae2                	ld	s5,56(sp)
    80002fcc:	7b42                	ld	s6,48(sp)
    80002fce:	7ba2                	ld	s7,40(sp)
    80002fd0:	7c02                	ld	s8,32(sp)
    80002fd2:	6ce2                	ld	s9,24(sp)
    80002fd4:	6d42                	ld	s10,16(sp)
    80002fd6:	6da2                	ld	s11,8(sp)
    80002fd8:	6165                	addi	sp,sp,112
    80002fda:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fdc:	8a5e                	mv	s4,s7
    80002fde:	bfc9                	j	80002fb0 <writei+0xe2>
    return -1;
    80002fe0:	557d                	li	a0,-1
}
    80002fe2:	8082                	ret
    return -1;
    80002fe4:	557d                	li	a0,-1
    80002fe6:	bfe1                	j	80002fbe <writei+0xf0>
    return -1;
    80002fe8:	557d                	li	a0,-1
    80002fea:	bfd1                	j	80002fbe <writei+0xf0>

0000000080002fec <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fec:	1141                	addi	sp,sp,-16
    80002fee:	e406                	sd	ra,8(sp)
    80002ff0:	e022                	sd	s0,0(sp)
    80002ff2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002ff4:	4639                	li	a2,14
    80002ff6:	ffffd097          	auipc	ra,0xffffd
    80002ffa:	25e080e7          	jalr	606(ra) # 80000254 <strncmp>
}
    80002ffe:	60a2                	ld	ra,8(sp)
    80003000:	6402                	ld	s0,0(sp)
    80003002:	0141                	addi	sp,sp,16
    80003004:	8082                	ret

0000000080003006 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003006:	7139                	addi	sp,sp,-64
    80003008:	fc06                	sd	ra,56(sp)
    8000300a:	f822                	sd	s0,48(sp)
    8000300c:	f426                	sd	s1,40(sp)
    8000300e:	f04a                	sd	s2,32(sp)
    80003010:	ec4e                	sd	s3,24(sp)
    80003012:	e852                	sd	s4,16(sp)
    80003014:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003016:	04451703          	lh	a4,68(a0)
    8000301a:	4785                	li	a5,1
    8000301c:	00f71a63          	bne	a4,a5,80003030 <dirlookup+0x2a>
    80003020:	892a                	mv	s2,a0
    80003022:	89ae                	mv	s3,a1
    80003024:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003026:	457c                	lw	a5,76(a0)
    80003028:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000302a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000302c:	e79d                	bnez	a5,8000305a <dirlookup+0x54>
    8000302e:	a8a5                	j	800030a6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003030:	00006517          	auipc	a0,0x6
    80003034:	56050513          	addi	a0,a0,1376 # 80009590 <syscalls+0x1e0>
    80003038:	00004097          	auipc	ra,0x4
    8000303c:	bd6080e7          	jalr	-1066(ra) # 80006c0e <panic>
      panic("dirlookup read");
    80003040:	00006517          	auipc	a0,0x6
    80003044:	56850513          	addi	a0,a0,1384 # 800095a8 <syscalls+0x1f8>
    80003048:	00004097          	auipc	ra,0x4
    8000304c:	bc6080e7          	jalr	-1082(ra) # 80006c0e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003050:	24c1                	addiw	s1,s1,16
    80003052:	04c92783          	lw	a5,76(s2)
    80003056:	04f4f763          	bgeu	s1,a5,800030a4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000305a:	4741                	li	a4,16
    8000305c:	86a6                	mv	a3,s1
    8000305e:	fc040613          	addi	a2,s0,-64
    80003062:	4581                	li	a1,0
    80003064:	854a                	mv	a0,s2
    80003066:	00000097          	auipc	ra,0x0
    8000306a:	d70080e7          	jalr	-656(ra) # 80002dd6 <readi>
    8000306e:	47c1                	li	a5,16
    80003070:	fcf518e3          	bne	a0,a5,80003040 <dirlookup+0x3a>
    if(de.inum == 0)
    80003074:	fc045783          	lhu	a5,-64(s0)
    80003078:	dfe1                	beqz	a5,80003050 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000307a:	fc240593          	addi	a1,s0,-62
    8000307e:	854e                	mv	a0,s3
    80003080:	00000097          	auipc	ra,0x0
    80003084:	f6c080e7          	jalr	-148(ra) # 80002fec <namecmp>
    80003088:	f561                	bnez	a0,80003050 <dirlookup+0x4a>
      if(poff)
    8000308a:	000a0463          	beqz	s4,80003092 <dirlookup+0x8c>
        *poff = off;
    8000308e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003092:	fc045583          	lhu	a1,-64(s0)
    80003096:	00092503          	lw	a0,0(s2)
    8000309a:	fffff097          	auipc	ra,0xfffff
    8000309e:	754080e7          	jalr	1876(ra) # 800027ee <iget>
    800030a2:	a011                	j	800030a6 <dirlookup+0xa0>
  return 0;
    800030a4:	4501                	li	a0,0
}
    800030a6:	70e2                	ld	ra,56(sp)
    800030a8:	7442                	ld	s0,48(sp)
    800030aa:	74a2                	ld	s1,40(sp)
    800030ac:	7902                	ld	s2,32(sp)
    800030ae:	69e2                	ld	s3,24(sp)
    800030b0:	6a42                	ld	s4,16(sp)
    800030b2:	6121                	addi	sp,sp,64
    800030b4:	8082                	ret

00000000800030b6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030b6:	711d                	addi	sp,sp,-96
    800030b8:	ec86                	sd	ra,88(sp)
    800030ba:	e8a2                	sd	s0,80(sp)
    800030bc:	e4a6                	sd	s1,72(sp)
    800030be:	e0ca                	sd	s2,64(sp)
    800030c0:	fc4e                	sd	s3,56(sp)
    800030c2:	f852                	sd	s4,48(sp)
    800030c4:	f456                	sd	s5,40(sp)
    800030c6:	f05a                	sd	s6,32(sp)
    800030c8:	ec5e                	sd	s7,24(sp)
    800030ca:	e862                	sd	s8,16(sp)
    800030cc:	e466                	sd	s9,8(sp)
    800030ce:	1080                	addi	s0,sp,96
    800030d0:	84aa                	mv	s1,a0
    800030d2:	8b2e                	mv	s6,a1
    800030d4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030d6:	00054703          	lbu	a4,0(a0)
    800030da:	02f00793          	li	a5,47
    800030de:	02f70363          	beq	a4,a5,80003104 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030e2:	ffffe097          	auipc	ra,0xffffe
    800030e6:	de0080e7          	jalr	-544(ra) # 80000ec2 <myproc>
    800030ea:	15053503          	ld	a0,336(a0)
    800030ee:	00000097          	auipc	ra,0x0
    800030f2:	9f6080e7          	jalr	-1546(ra) # 80002ae4 <idup>
    800030f6:	89aa                	mv	s3,a0
  while(*path == '/')
    800030f8:	02f00913          	li	s2,47
  len = path - s;
    800030fc:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800030fe:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003100:	4c05                	li	s8,1
    80003102:	a865                	j	800031ba <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003104:	4585                	li	a1,1
    80003106:	4505                	li	a0,1
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	6e6080e7          	jalr	1766(ra) # 800027ee <iget>
    80003110:	89aa                	mv	s3,a0
    80003112:	b7dd                	j	800030f8 <namex+0x42>
      iunlockput(ip);
    80003114:	854e                	mv	a0,s3
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	c6e080e7          	jalr	-914(ra) # 80002d84 <iunlockput>
      return 0;
    8000311e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003120:	854e                	mv	a0,s3
    80003122:	60e6                	ld	ra,88(sp)
    80003124:	6446                	ld	s0,80(sp)
    80003126:	64a6                	ld	s1,72(sp)
    80003128:	6906                	ld	s2,64(sp)
    8000312a:	79e2                	ld	s3,56(sp)
    8000312c:	7a42                	ld	s4,48(sp)
    8000312e:	7aa2                	ld	s5,40(sp)
    80003130:	7b02                	ld	s6,32(sp)
    80003132:	6be2                	ld	s7,24(sp)
    80003134:	6c42                	ld	s8,16(sp)
    80003136:	6ca2                	ld	s9,8(sp)
    80003138:	6125                	addi	sp,sp,96
    8000313a:	8082                	ret
      iunlock(ip);
    8000313c:	854e                	mv	a0,s3
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	aa6080e7          	jalr	-1370(ra) # 80002be4 <iunlock>
      return ip;
    80003146:	bfe9                	j	80003120 <namex+0x6a>
      iunlockput(ip);
    80003148:	854e                	mv	a0,s3
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	c3a080e7          	jalr	-966(ra) # 80002d84 <iunlockput>
      return 0;
    80003152:	89d2                	mv	s3,s4
    80003154:	b7f1                	j	80003120 <namex+0x6a>
  len = path - s;
    80003156:	40b48633          	sub	a2,s1,a1
    8000315a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000315e:	094cd463          	bge	s9,s4,800031e6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003162:	4639                	li	a2,14
    80003164:	8556                	mv	a0,s5
    80003166:	ffffd097          	auipc	ra,0xffffd
    8000316a:	072080e7          	jalr	114(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000316e:	0004c783          	lbu	a5,0(s1)
    80003172:	01279763          	bne	a5,s2,80003180 <namex+0xca>
    path++;
    80003176:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003178:	0004c783          	lbu	a5,0(s1)
    8000317c:	ff278de3          	beq	a5,s2,80003176 <namex+0xc0>
    ilock(ip);
    80003180:	854e                	mv	a0,s3
    80003182:	00000097          	auipc	ra,0x0
    80003186:	9a0080e7          	jalr	-1632(ra) # 80002b22 <ilock>
    if(ip->type != T_DIR){
    8000318a:	04499783          	lh	a5,68(s3)
    8000318e:	f98793e3          	bne	a5,s8,80003114 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003192:	000b0563          	beqz	s6,8000319c <namex+0xe6>
    80003196:	0004c783          	lbu	a5,0(s1)
    8000319a:	d3cd                	beqz	a5,8000313c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000319c:	865e                	mv	a2,s7
    8000319e:	85d6                	mv	a1,s5
    800031a0:	854e                	mv	a0,s3
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	e64080e7          	jalr	-412(ra) # 80003006 <dirlookup>
    800031aa:	8a2a                	mv	s4,a0
    800031ac:	dd51                	beqz	a0,80003148 <namex+0x92>
    iunlockput(ip);
    800031ae:	854e                	mv	a0,s3
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	bd4080e7          	jalr	-1068(ra) # 80002d84 <iunlockput>
    ip = next;
    800031b8:	89d2                	mv	s3,s4
  while(*path == '/')
    800031ba:	0004c783          	lbu	a5,0(s1)
    800031be:	05279763          	bne	a5,s2,8000320c <namex+0x156>
    path++;
    800031c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031c4:	0004c783          	lbu	a5,0(s1)
    800031c8:	ff278de3          	beq	a5,s2,800031c2 <namex+0x10c>
  if(*path == 0)
    800031cc:	c79d                	beqz	a5,800031fa <namex+0x144>
    path++;
    800031ce:	85a6                	mv	a1,s1
  len = path - s;
    800031d0:	8a5e                	mv	s4,s7
    800031d2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031d4:	01278963          	beq	a5,s2,800031e6 <namex+0x130>
    800031d8:	dfbd                	beqz	a5,80003156 <namex+0xa0>
    path++;
    800031da:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031dc:	0004c783          	lbu	a5,0(s1)
    800031e0:	ff279ce3          	bne	a5,s2,800031d8 <namex+0x122>
    800031e4:	bf8d                	j	80003156 <namex+0xa0>
    memmove(name, s, len);
    800031e6:	2601                	sext.w	a2,a2
    800031e8:	8556                	mv	a0,s5
    800031ea:	ffffd097          	auipc	ra,0xffffd
    800031ee:	fee080e7          	jalr	-18(ra) # 800001d8 <memmove>
    name[len] = 0;
    800031f2:	9a56                	add	s4,s4,s5
    800031f4:	000a0023          	sb	zero,0(s4)
    800031f8:	bf9d                	j	8000316e <namex+0xb8>
  if(nameiparent){
    800031fa:	f20b03e3          	beqz	s6,80003120 <namex+0x6a>
    iput(ip);
    800031fe:	854e                	mv	a0,s3
    80003200:	00000097          	auipc	ra,0x0
    80003204:	adc080e7          	jalr	-1316(ra) # 80002cdc <iput>
    return 0;
    80003208:	4981                	li	s3,0
    8000320a:	bf19                	j	80003120 <namex+0x6a>
  if(*path == 0)
    8000320c:	d7fd                	beqz	a5,800031fa <namex+0x144>
  while(*path != '/' && *path != 0)
    8000320e:	0004c783          	lbu	a5,0(s1)
    80003212:	85a6                	mv	a1,s1
    80003214:	b7d1                	j	800031d8 <namex+0x122>

0000000080003216 <dirlink>:
{
    80003216:	7139                	addi	sp,sp,-64
    80003218:	fc06                	sd	ra,56(sp)
    8000321a:	f822                	sd	s0,48(sp)
    8000321c:	f426                	sd	s1,40(sp)
    8000321e:	f04a                	sd	s2,32(sp)
    80003220:	ec4e                	sd	s3,24(sp)
    80003222:	e852                	sd	s4,16(sp)
    80003224:	0080                	addi	s0,sp,64
    80003226:	892a                	mv	s2,a0
    80003228:	8a2e                	mv	s4,a1
    8000322a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000322c:	4601                	li	a2,0
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	dd8080e7          	jalr	-552(ra) # 80003006 <dirlookup>
    80003236:	e93d                	bnez	a0,800032ac <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003238:	04c92483          	lw	s1,76(s2)
    8000323c:	c49d                	beqz	s1,8000326a <dirlink+0x54>
    8000323e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003240:	4741                	li	a4,16
    80003242:	86a6                	mv	a3,s1
    80003244:	fc040613          	addi	a2,s0,-64
    80003248:	4581                	li	a1,0
    8000324a:	854a                	mv	a0,s2
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	b8a080e7          	jalr	-1142(ra) # 80002dd6 <readi>
    80003254:	47c1                	li	a5,16
    80003256:	06f51163          	bne	a0,a5,800032b8 <dirlink+0xa2>
    if(de.inum == 0)
    8000325a:	fc045783          	lhu	a5,-64(s0)
    8000325e:	c791                	beqz	a5,8000326a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003260:	24c1                	addiw	s1,s1,16
    80003262:	04c92783          	lw	a5,76(s2)
    80003266:	fcf4ede3          	bltu	s1,a5,80003240 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000326a:	4639                	li	a2,14
    8000326c:	85d2                	mv	a1,s4
    8000326e:	fc240513          	addi	a0,s0,-62
    80003272:	ffffd097          	auipc	ra,0xffffd
    80003276:	01e080e7          	jalr	30(ra) # 80000290 <strncpy>
  de.inum = inum;
    8000327a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000327e:	4741                	li	a4,16
    80003280:	86a6                	mv	a3,s1
    80003282:	fc040613          	addi	a2,s0,-64
    80003286:	4581                	li	a1,0
    80003288:	854a                	mv	a0,s2
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	c44080e7          	jalr	-956(ra) # 80002ece <writei>
    80003292:	872a                	mv	a4,a0
    80003294:	47c1                	li	a5,16
  return 0;
    80003296:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003298:	02f71863          	bne	a4,a5,800032c8 <dirlink+0xb2>
}
    8000329c:	70e2                	ld	ra,56(sp)
    8000329e:	7442                	ld	s0,48(sp)
    800032a0:	74a2                	ld	s1,40(sp)
    800032a2:	7902                	ld	s2,32(sp)
    800032a4:	69e2                	ld	s3,24(sp)
    800032a6:	6a42                	ld	s4,16(sp)
    800032a8:	6121                	addi	sp,sp,64
    800032aa:	8082                	ret
    iput(ip);
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	a30080e7          	jalr	-1488(ra) # 80002cdc <iput>
    return -1;
    800032b4:	557d                	li	a0,-1
    800032b6:	b7dd                	j	8000329c <dirlink+0x86>
      panic("dirlink read");
    800032b8:	00006517          	auipc	a0,0x6
    800032bc:	30050513          	addi	a0,a0,768 # 800095b8 <syscalls+0x208>
    800032c0:	00004097          	auipc	ra,0x4
    800032c4:	94e080e7          	jalr	-1714(ra) # 80006c0e <panic>
    panic("dirlink");
    800032c8:	00006517          	auipc	a0,0x6
    800032cc:	40050513          	addi	a0,a0,1024 # 800096c8 <syscalls+0x318>
    800032d0:	00004097          	auipc	ra,0x4
    800032d4:	93e080e7          	jalr	-1730(ra) # 80006c0e <panic>

00000000800032d8 <namei>:

struct inode*
namei(char *path)
{
    800032d8:	1101                	addi	sp,sp,-32
    800032da:	ec06                	sd	ra,24(sp)
    800032dc:	e822                	sd	s0,16(sp)
    800032de:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032e0:	fe040613          	addi	a2,s0,-32
    800032e4:	4581                	li	a1,0
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	dd0080e7          	jalr	-560(ra) # 800030b6 <namex>
}
    800032ee:	60e2                	ld	ra,24(sp)
    800032f0:	6442                	ld	s0,16(sp)
    800032f2:	6105                	addi	sp,sp,32
    800032f4:	8082                	ret

00000000800032f6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032f6:	1141                	addi	sp,sp,-16
    800032f8:	e406                	sd	ra,8(sp)
    800032fa:	e022                	sd	s0,0(sp)
    800032fc:	0800                	addi	s0,sp,16
    800032fe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003300:	4585                	li	a1,1
    80003302:	00000097          	auipc	ra,0x0
    80003306:	db4080e7          	jalr	-588(ra) # 800030b6 <namex>
}
    8000330a:	60a2                	ld	ra,8(sp)
    8000330c:	6402                	ld	s0,0(sp)
    8000330e:	0141                	addi	sp,sp,16
    80003310:	8082                	ret

0000000080003312 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003312:	1101                	addi	sp,sp,-32
    80003314:	ec06                	sd	ra,24(sp)
    80003316:	e822                	sd	s0,16(sp)
    80003318:	e426                	sd	s1,8(sp)
    8000331a:	e04a                	sd	s2,0(sp)
    8000331c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000331e:	00017917          	auipc	s2,0x17
    80003322:	d0a90913          	addi	s2,s2,-758 # 8001a028 <log>
    80003326:	01892583          	lw	a1,24(s2)
    8000332a:	02892503          	lw	a0,40(s2)
    8000332e:	fffff097          	auipc	ra,0xfffff
    80003332:	ff2080e7          	jalr	-14(ra) # 80002320 <bread>
    80003336:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003338:	02c92683          	lw	a3,44(s2)
    8000333c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000333e:	02d05763          	blez	a3,8000336c <write_head+0x5a>
    80003342:	00017797          	auipc	a5,0x17
    80003346:	d1678793          	addi	a5,a5,-746 # 8001a058 <log+0x30>
    8000334a:	05c50713          	addi	a4,a0,92
    8000334e:	36fd                	addiw	a3,a3,-1
    80003350:	1682                	slli	a3,a3,0x20
    80003352:	9281                	srli	a3,a3,0x20
    80003354:	068a                	slli	a3,a3,0x2
    80003356:	00017617          	auipc	a2,0x17
    8000335a:	d0660613          	addi	a2,a2,-762 # 8001a05c <log+0x34>
    8000335e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003360:	4390                	lw	a2,0(a5)
    80003362:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003364:	0791                	addi	a5,a5,4
    80003366:	0711                	addi	a4,a4,4
    80003368:	fed79ce3          	bne	a5,a3,80003360 <write_head+0x4e>
  }
  bwrite(buf);
    8000336c:	8526                	mv	a0,s1
    8000336e:	fffff097          	auipc	ra,0xfffff
    80003372:	0a4080e7          	jalr	164(ra) # 80002412 <bwrite>
  brelse(buf);
    80003376:	8526                	mv	a0,s1
    80003378:	fffff097          	auipc	ra,0xfffff
    8000337c:	0d8080e7          	jalr	216(ra) # 80002450 <brelse>
}
    80003380:	60e2                	ld	ra,24(sp)
    80003382:	6442                	ld	s0,16(sp)
    80003384:	64a2                	ld	s1,8(sp)
    80003386:	6902                	ld	s2,0(sp)
    80003388:	6105                	addi	sp,sp,32
    8000338a:	8082                	ret

000000008000338c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000338c:	00017797          	auipc	a5,0x17
    80003390:	cc87a783          	lw	a5,-824(a5) # 8001a054 <log+0x2c>
    80003394:	0af05d63          	blez	a5,8000344e <install_trans+0xc2>
{
    80003398:	7139                	addi	sp,sp,-64
    8000339a:	fc06                	sd	ra,56(sp)
    8000339c:	f822                	sd	s0,48(sp)
    8000339e:	f426                	sd	s1,40(sp)
    800033a0:	f04a                	sd	s2,32(sp)
    800033a2:	ec4e                	sd	s3,24(sp)
    800033a4:	e852                	sd	s4,16(sp)
    800033a6:	e456                	sd	s5,8(sp)
    800033a8:	e05a                	sd	s6,0(sp)
    800033aa:	0080                	addi	s0,sp,64
    800033ac:	8b2a                	mv	s6,a0
    800033ae:	00017a97          	auipc	s5,0x17
    800033b2:	caaa8a93          	addi	s5,s5,-854 # 8001a058 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033b8:	00017997          	auipc	s3,0x17
    800033bc:	c7098993          	addi	s3,s3,-912 # 8001a028 <log>
    800033c0:	a035                	j	800033ec <install_trans+0x60>
      bunpin(dbuf);
    800033c2:	8526                	mv	a0,s1
    800033c4:	fffff097          	auipc	ra,0xfffff
    800033c8:	166080e7          	jalr	358(ra) # 8000252a <bunpin>
    brelse(lbuf);
    800033cc:	854a                	mv	a0,s2
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	082080e7          	jalr	130(ra) # 80002450 <brelse>
    brelse(dbuf);
    800033d6:	8526                	mv	a0,s1
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	078080e7          	jalr	120(ra) # 80002450 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e0:	2a05                	addiw	s4,s4,1
    800033e2:	0a91                	addi	s5,s5,4
    800033e4:	02c9a783          	lw	a5,44(s3)
    800033e8:	04fa5963          	bge	s4,a5,8000343a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033ec:	0189a583          	lw	a1,24(s3)
    800033f0:	014585bb          	addw	a1,a1,s4
    800033f4:	2585                	addiw	a1,a1,1
    800033f6:	0289a503          	lw	a0,40(s3)
    800033fa:	fffff097          	auipc	ra,0xfffff
    800033fe:	f26080e7          	jalr	-218(ra) # 80002320 <bread>
    80003402:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003404:	000aa583          	lw	a1,0(s5)
    80003408:	0289a503          	lw	a0,40(s3)
    8000340c:	fffff097          	auipc	ra,0xfffff
    80003410:	f14080e7          	jalr	-236(ra) # 80002320 <bread>
    80003414:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003416:	40000613          	li	a2,1024
    8000341a:	05890593          	addi	a1,s2,88
    8000341e:	05850513          	addi	a0,a0,88
    80003422:	ffffd097          	auipc	ra,0xffffd
    80003426:	db6080e7          	jalr	-586(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000342a:	8526                	mv	a0,s1
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	fe6080e7          	jalr	-26(ra) # 80002412 <bwrite>
    if(recovering == 0)
    80003434:	f80b1ce3          	bnez	s6,800033cc <install_trans+0x40>
    80003438:	b769                	j	800033c2 <install_trans+0x36>
}
    8000343a:	70e2                	ld	ra,56(sp)
    8000343c:	7442                	ld	s0,48(sp)
    8000343e:	74a2                	ld	s1,40(sp)
    80003440:	7902                	ld	s2,32(sp)
    80003442:	69e2                	ld	s3,24(sp)
    80003444:	6a42                	ld	s4,16(sp)
    80003446:	6aa2                	ld	s5,8(sp)
    80003448:	6b02                	ld	s6,0(sp)
    8000344a:	6121                	addi	sp,sp,64
    8000344c:	8082                	ret
    8000344e:	8082                	ret

0000000080003450 <initlog>:
{
    80003450:	7179                	addi	sp,sp,-48
    80003452:	f406                	sd	ra,40(sp)
    80003454:	f022                	sd	s0,32(sp)
    80003456:	ec26                	sd	s1,24(sp)
    80003458:	e84a                	sd	s2,16(sp)
    8000345a:	e44e                	sd	s3,8(sp)
    8000345c:	1800                	addi	s0,sp,48
    8000345e:	892a                	mv	s2,a0
    80003460:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003462:	00017497          	auipc	s1,0x17
    80003466:	bc648493          	addi	s1,s1,-1082 # 8001a028 <log>
    8000346a:	00006597          	auipc	a1,0x6
    8000346e:	15e58593          	addi	a1,a1,350 # 800095c8 <syscalls+0x218>
    80003472:	8526                	mv	a0,s1
    80003474:	00004097          	auipc	ra,0x4
    80003478:	c54080e7          	jalr	-940(ra) # 800070c8 <initlock>
  log.start = sb->logstart;
    8000347c:	0149a583          	lw	a1,20(s3)
    80003480:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003482:	0109a783          	lw	a5,16(s3)
    80003486:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003488:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000348c:	854a                	mv	a0,s2
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	e92080e7          	jalr	-366(ra) # 80002320 <bread>
  log.lh.n = lh->n;
    80003496:	4d3c                	lw	a5,88(a0)
    80003498:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000349a:	02f05563          	blez	a5,800034c4 <initlog+0x74>
    8000349e:	05c50713          	addi	a4,a0,92
    800034a2:	00017697          	auipc	a3,0x17
    800034a6:	bb668693          	addi	a3,a3,-1098 # 8001a058 <log+0x30>
    800034aa:	37fd                	addiw	a5,a5,-1
    800034ac:	1782                	slli	a5,a5,0x20
    800034ae:	9381                	srli	a5,a5,0x20
    800034b0:	078a                	slli	a5,a5,0x2
    800034b2:	06050613          	addi	a2,a0,96
    800034b6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800034b8:	4310                	lw	a2,0(a4)
    800034ba:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800034bc:	0711                	addi	a4,a4,4
    800034be:	0691                	addi	a3,a3,4
    800034c0:	fef71ce3          	bne	a4,a5,800034b8 <initlog+0x68>
  brelse(buf);
    800034c4:	fffff097          	auipc	ra,0xfffff
    800034c8:	f8c080e7          	jalr	-116(ra) # 80002450 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034cc:	4505                	li	a0,1
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	ebe080e7          	jalr	-322(ra) # 8000338c <install_trans>
  log.lh.n = 0;
    800034d6:	00017797          	auipc	a5,0x17
    800034da:	b607af23          	sw	zero,-1154(a5) # 8001a054 <log+0x2c>
  write_head(); // clear the log
    800034de:	00000097          	auipc	ra,0x0
    800034e2:	e34080e7          	jalr	-460(ra) # 80003312 <write_head>
}
    800034e6:	70a2                	ld	ra,40(sp)
    800034e8:	7402                	ld	s0,32(sp)
    800034ea:	64e2                	ld	s1,24(sp)
    800034ec:	6942                	ld	s2,16(sp)
    800034ee:	69a2                	ld	s3,8(sp)
    800034f0:	6145                	addi	sp,sp,48
    800034f2:	8082                	ret

00000000800034f4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034f4:	1101                	addi	sp,sp,-32
    800034f6:	ec06                	sd	ra,24(sp)
    800034f8:	e822                	sd	s0,16(sp)
    800034fa:	e426                	sd	s1,8(sp)
    800034fc:	e04a                	sd	s2,0(sp)
    800034fe:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003500:	00017517          	auipc	a0,0x17
    80003504:	b2850513          	addi	a0,a0,-1240 # 8001a028 <log>
    80003508:	00004097          	auipc	ra,0x4
    8000350c:	c50080e7          	jalr	-944(ra) # 80007158 <acquire>
  while(1){
    if(log.committing){
    80003510:	00017497          	auipc	s1,0x17
    80003514:	b1848493          	addi	s1,s1,-1256 # 8001a028 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003518:	4979                	li	s2,30
    8000351a:	a039                	j	80003528 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000351c:	85a6                	mv	a1,s1
    8000351e:	8526                	mv	a0,s1
    80003520:	ffffe097          	auipc	ra,0xffffe
    80003524:	1b2080e7          	jalr	434(ra) # 800016d2 <sleep>
    if(log.committing){
    80003528:	50dc                	lw	a5,36(s1)
    8000352a:	fbed                	bnez	a5,8000351c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000352c:	509c                	lw	a5,32(s1)
    8000352e:	0017871b          	addiw	a4,a5,1
    80003532:	0007069b          	sext.w	a3,a4
    80003536:	0027179b          	slliw	a5,a4,0x2
    8000353a:	9fb9                	addw	a5,a5,a4
    8000353c:	0017979b          	slliw	a5,a5,0x1
    80003540:	54d8                	lw	a4,44(s1)
    80003542:	9fb9                	addw	a5,a5,a4
    80003544:	00f95963          	bge	s2,a5,80003556 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003548:	85a6                	mv	a1,s1
    8000354a:	8526                	mv	a0,s1
    8000354c:	ffffe097          	auipc	ra,0xffffe
    80003550:	186080e7          	jalr	390(ra) # 800016d2 <sleep>
    80003554:	bfd1                	j	80003528 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003556:	00017517          	auipc	a0,0x17
    8000355a:	ad250513          	addi	a0,a0,-1326 # 8001a028 <log>
    8000355e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003560:	00004097          	auipc	ra,0x4
    80003564:	cac080e7          	jalr	-852(ra) # 8000720c <release>
      break;
    }
  }
}
    80003568:	60e2                	ld	ra,24(sp)
    8000356a:	6442                	ld	s0,16(sp)
    8000356c:	64a2                	ld	s1,8(sp)
    8000356e:	6902                	ld	s2,0(sp)
    80003570:	6105                	addi	sp,sp,32
    80003572:	8082                	ret

0000000080003574 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003574:	7139                	addi	sp,sp,-64
    80003576:	fc06                	sd	ra,56(sp)
    80003578:	f822                	sd	s0,48(sp)
    8000357a:	f426                	sd	s1,40(sp)
    8000357c:	f04a                	sd	s2,32(sp)
    8000357e:	ec4e                	sd	s3,24(sp)
    80003580:	e852                	sd	s4,16(sp)
    80003582:	e456                	sd	s5,8(sp)
    80003584:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003586:	00017497          	auipc	s1,0x17
    8000358a:	aa248493          	addi	s1,s1,-1374 # 8001a028 <log>
    8000358e:	8526                	mv	a0,s1
    80003590:	00004097          	auipc	ra,0x4
    80003594:	bc8080e7          	jalr	-1080(ra) # 80007158 <acquire>
  log.outstanding -= 1;
    80003598:	509c                	lw	a5,32(s1)
    8000359a:	37fd                	addiw	a5,a5,-1
    8000359c:	0007891b          	sext.w	s2,a5
    800035a0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035a2:	50dc                	lw	a5,36(s1)
    800035a4:	efb9                	bnez	a5,80003602 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035a6:	06091663          	bnez	s2,80003612 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800035aa:	00017497          	auipc	s1,0x17
    800035ae:	a7e48493          	addi	s1,s1,-1410 # 8001a028 <log>
    800035b2:	4785                	li	a5,1
    800035b4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035b6:	8526                	mv	a0,s1
    800035b8:	00004097          	auipc	ra,0x4
    800035bc:	c54080e7          	jalr	-940(ra) # 8000720c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035c0:	54dc                	lw	a5,44(s1)
    800035c2:	06f04763          	bgtz	a5,80003630 <end_op+0xbc>
    acquire(&log.lock);
    800035c6:	00017497          	auipc	s1,0x17
    800035ca:	a6248493          	addi	s1,s1,-1438 # 8001a028 <log>
    800035ce:	8526                	mv	a0,s1
    800035d0:	00004097          	auipc	ra,0x4
    800035d4:	b88080e7          	jalr	-1144(ra) # 80007158 <acquire>
    log.committing = 0;
    800035d8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035dc:	8526                	mv	a0,s1
    800035de:	ffffe097          	auipc	ra,0xffffe
    800035e2:	27a080e7          	jalr	634(ra) # 80001858 <wakeup>
    release(&log.lock);
    800035e6:	8526                	mv	a0,s1
    800035e8:	00004097          	auipc	ra,0x4
    800035ec:	c24080e7          	jalr	-988(ra) # 8000720c <release>
}
    800035f0:	70e2                	ld	ra,56(sp)
    800035f2:	7442                	ld	s0,48(sp)
    800035f4:	74a2                	ld	s1,40(sp)
    800035f6:	7902                	ld	s2,32(sp)
    800035f8:	69e2                	ld	s3,24(sp)
    800035fa:	6a42                	ld	s4,16(sp)
    800035fc:	6aa2                	ld	s5,8(sp)
    800035fe:	6121                	addi	sp,sp,64
    80003600:	8082                	ret
    panic("log.committing");
    80003602:	00006517          	auipc	a0,0x6
    80003606:	fce50513          	addi	a0,a0,-50 # 800095d0 <syscalls+0x220>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	604080e7          	jalr	1540(ra) # 80006c0e <panic>
    wakeup(&log);
    80003612:	00017497          	auipc	s1,0x17
    80003616:	a1648493          	addi	s1,s1,-1514 # 8001a028 <log>
    8000361a:	8526                	mv	a0,s1
    8000361c:	ffffe097          	auipc	ra,0xffffe
    80003620:	23c080e7          	jalr	572(ra) # 80001858 <wakeup>
  release(&log.lock);
    80003624:	8526                	mv	a0,s1
    80003626:	00004097          	auipc	ra,0x4
    8000362a:	be6080e7          	jalr	-1050(ra) # 8000720c <release>
  if(do_commit){
    8000362e:	b7c9                	j	800035f0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003630:	00017a97          	auipc	s5,0x17
    80003634:	a28a8a93          	addi	s5,s5,-1496 # 8001a058 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003638:	00017a17          	auipc	s4,0x17
    8000363c:	9f0a0a13          	addi	s4,s4,-1552 # 8001a028 <log>
    80003640:	018a2583          	lw	a1,24(s4)
    80003644:	012585bb          	addw	a1,a1,s2
    80003648:	2585                	addiw	a1,a1,1
    8000364a:	028a2503          	lw	a0,40(s4)
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	cd2080e7          	jalr	-814(ra) # 80002320 <bread>
    80003656:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003658:	000aa583          	lw	a1,0(s5)
    8000365c:	028a2503          	lw	a0,40(s4)
    80003660:	fffff097          	auipc	ra,0xfffff
    80003664:	cc0080e7          	jalr	-832(ra) # 80002320 <bread>
    80003668:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000366a:	40000613          	li	a2,1024
    8000366e:	05850593          	addi	a1,a0,88
    80003672:	05848513          	addi	a0,s1,88
    80003676:	ffffd097          	auipc	ra,0xffffd
    8000367a:	b62080e7          	jalr	-1182(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000367e:	8526                	mv	a0,s1
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	d92080e7          	jalr	-622(ra) # 80002412 <bwrite>
    brelse(from);
    80003688:	854e                	mv	a0,s3
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	dc6080e7          	jalr	-570(ra) # 80002450 <brelse>
    brelse(to);
    80003692:	8526                	mv	a0,s1
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	dbc080e7          	jalr	-580(ra) # 80002450 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000369c:	2905                	addiw	s2,s2,1
    8000369e:	0a91                	addi	s5,s5,4
    800036a0:	02ca2783          	lw	a5,44(s4)
    800036a4:	f8f94ee3          	blt	s2,a5,80003640 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036a8:	00000097          	auipc	ra,0x0
    800036ac:	c6a080e7          	jalr	-918(ra) # 80003312 <write_head>
    install_trans(0); // Now install writes to home locations
    800036b0:	4501                	li	a0,0
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	cda080e7          	jalr	-806(ra) # 8000338c <install_trans>
    log.lh.n = 0;
    800036ba:	00017797          	auipc	a5,0x17
    800036be:	9807ad23          	sw	zero,-1638(a5) # 8001a054 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036c2:	00000097          	auipc	ra,0x0
    800036c6:	c50080e7          	jalr	-944(ra) # 80003312 <write_head>
    800036ca:	bdf5                	j	800035c6 <end_op+0x52>

00000000800036cc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036cc:	1101                	addi	sp,sp,-32
    800036ce:	ec06                	sd	ra,24(sp)
    800036d0:	e822                	sd	s0,16(sp)
    800036d2:	e426                	sd	s1,8(sp)
    800036d4:	e04a                	sd	s2,0(sp)
    800036d6:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036d8:	00017717          	auipc	a4,0x17
    800036dc:	97c72703          	lw	a4,-1668(a4) # 8001a054 <log+0x2c>
    800036e0:	47f5                	li	a5,29
    800036e2:	08e7c063          	blt	a5,a4,80003762 <log_write+0x96>
    800036e6:	84aa                	mv	s1,a0
    800036e8:	00017797          	auipc	a5,0x17
    800036ec:	95c7a783          	lw	a5,-1700(a5) # 8001a044 <log+0x1c>
    800036f0:	37fd                	addiw	a5,a5,-1
    800036f2:	06f75863          	bge	a4,a5,80003762 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036f6:	00017797          	auipc	a5,0x17
    800036fa:	9527a783          	lw	a5,-1710(a5) # 8001a048 <log+0x20>
    800036fe:	06f05a63          	blez	a5,80003772 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80003702:	00017917          	auipc	s2,0x17
    80003706:	92690913          	addi	s2,s2,-1754 # 8001a028 <log>
    8000370a:	854a                	mv	a0,s2
    8000370c:	00004097          	auipc	ra,0x4
    80003710:	a4c080e7          	jalr	-1460(ra) # 80007158 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80003714:	02c92603          	lw	a2,44(s2)
    80003718:	06c05563          	blez	a2,80003782 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000371c:	44cc                	lw	a1,12(s1)
    8000371e:	00017717          	auipc	a4,0x17
    80003722:	93a70713          	addi	a4,a4,-1734 # 8001a058 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003726:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80003728:	4314                	lw	a3,0(a4)
    8000372a:	04b68d63          	beq	a3,a1,80003784 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    8000372e:	2785                	addiw	a5,a5,1
    80003730:	0711                	addi	a4,a4,4
    80003732:	fec79be3          	bne	a5,a2,80003728 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003736:	0621                	addi	a2,a2,8
    80003738:	060a                	slli	a2,a2,0x2
    8000373a:	00017797          	auipc	a5,0x17
    8000373e:	8ee78793          	addi	a5,a5,-1810 # 8001a028 <log>
    80003742:	963e                	add	a2,a2,a5
    80003744:	44dc                	lw	a5,12(s1)
    80003746:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003748:	8526                	mv	a0,s1
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	da4080e7          	jalr	-604(ra) # 800024ee <bpin>
    log.lh.n++;
    80003752:	00017717          	auipc	a4,0x17
    80003756:	8d670713          	addi	a4,a4,-1834 # 8001a028 <log>
    8000375a:	575c                	lw	a5,44(a4)
    8000375c:	2785                	addiw	a5,a5,1
    8000375e:	d75c                	sw	a5,44(a4)
    80003760:	a83d                	j	8000379e <log_write+0xd2>
    panic("too big a transaction");
    80003762:	00006517          	auipc	a0,0x6
    80003766:	e7e50513          	addi	a0,a0,-386 # 800095e0 <syscalls+0x230>
    8000376a:	00003097          	auipc	ra,0x3
    8000376e:	4a4080e7          	jalr	1188(ra) # 80006c0e <panic>
    panic("log_write outside of trans");
    80003772:	00006517          	auipc	a0,0x6
    80003776:	e8650513          	addi	a0,a0,-378 # 800095f8 <syscalls+0x248>
    8000377a:	00003097          	auipc	ra,0x3
    8000377e:	494080e7          	jalr	1172(ra) # 80006c0e <panic>
  for (i = 0; i < log.lh.n; i++) {
    80003782:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80003784:	00878713          	addi	a4,a5,8
    80003788:	00271693          	slli	a3,a4,0x2
    8000378c:	00017717          	auipc	a4,0x17
    80003790:	89c70713          	addi	a4,a4,-1892 # 8001a028 <log>
    80003794:	9736                	add	a4,a4,a3
    80003796:	44d4                	lw	a3,12(s1)
    80003798:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000379a:	faf607e3          	beq	a2,a5,80003748 <log_write+0x7c>
  }
  release(&log.lock);
    8000379e:	00017517          	auipc	a0,0x17
    800037a2:	88a50513          	addi	a0,a0,-1910 # 8001a028 <log>
    800037a6:	00004097          	auipc	ra,0x4
    800037aa:	a66080e7          	jalr	-1434(ra) # 8000720c <release>
}
    800037ae:	60e2                	ld	ra,24(sp)
    800037b0:	6442                	ld	s0,16(sp)
    800037b2:	64a2                	ld	s1,8(sp)
    800037b4:	6902                	ld	s2,0(sp)
    800037b6:	6105                	addi	sp,sp,32
    800037b8:	8082                	ret

00000000800037ba <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
    800037c8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037ca:	00006597          	auipc	a1,0x6
    800037ce:	e4e58593          	addi	a1,a1,-434 # 80009618 <syscalls+0x268>
    800037d2:	0521                	addi	a0,a0,8
    800037d4:	00004097          	auipc	ra,0x4
    800037d8:	8f4080e7          	jalr	-1804(ra) # 800070c8 <initlock>
  lk->name = name;
    800037dc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037e4:	0204a423          	sw	zero,40(s1)
}
    800037e8:	60e2                	ld	ra,24(sp)
    800037ea:	6442                	ld	s0,16(sp)
    800037ec:	64a2                	ld	s1,8(sp)
    800037ee:	6902                	ld	s2,0(sp)
    800037f0:	6105                	addi	sp,sp,32
    800037f2:	8082                	ret

00000000800037f4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037f4:	1101                	addi	sp,sp,-32
    800037f6:	ec06                	sd	ra,24(sp)
    800037f8:	e822                	sd	s0,16(sp)
    800037fa:	e426                	sd	s1,8(sp)
    800037fc:	e04a                	sd	s2,0(sp)
    800037fe:	1000                	addi	s0,sp,32
    80003800:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003802:	00850913          	addi	s2,a0,8
    80003806:	854a                	mv	a0,s2
    80003808:	00004097          	auipc	ra,0x4
    8000380c:	950080e7          	jalr	-1712(ra) # 80007158 <acquire>
  while (lk->locked) {
    80003810:	409c                	lw	a5,0(s1)
    80003812:	cb89                	beqz	a5,80003824 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003814:	85ca                	mv	a1,s2
    80003816:	8526                	mv	a0,s1
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	eba080e7          	jalr	-326(ra) # 800016d2 <sleep>
  while (lk->locked) {
    80003820:	409c                	lw	a5,0(s1)
    80003822:	fbed                	bnez	a5,80003814 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003824:	4785                	li	a5,1
    80003826:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003828:	ffffd097          	auipc	ra,0xffffd
    8000382c:	69a080e7          	jalr	1690(ra) # 80000ec2 <myproc>
    80003830:	5d1c                	lw	a5,56(a0)
    80003832:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003834:	854a                	mv	a0,s2
    80003836:	00004097          	auipc	ra,0x4
    8000383a:	9d6080e7          	jalr	-1578(ra) # 8000720c <release>
}
    8000383e:	60e2                	ld	ra,24(sp)
    80003840:	6442                	ld	s0,16(sp)
    80003842:	64a2                	ld	s1,8(sp)
    80003844:	6902                	ld	s2,0(sp)
    80003846:	6105                	addi	sp,sp,32
    80003848:	8082                	ret

000000008000384a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000384a:	1101                	addi	sp,sp,-32
    8000384c:	ec06                	sd	ra,24(sp)
    8000384e:	e822                	sd	s0,16(sp)
    80003850:	e426                	sd	s1,8(sp)
    80003852:	e04a                	sd	s2,0(sp)
    80003854:	1000                	addi	s0,sp,32
    80003856:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003858:	00850913          	addi	s2,a0,8
    8000385c:	854a                	mv	a0,s2
    8000385e:	00004097          	auipc	ra,0x4
    80003862:	8fa080e7          	jalr	-1798(ra) # 80007158 <acquire>
  lk->locked = 0;
    80003866:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000386a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000386e:	8526                	mv	a0,s1
    80003870:	ffffe097          	auipc	ra,0xffffe
    80003874:	fe8080e7          	jalr	-24(ra) # 80001858 <wakeup>
  release(&lk->lk);
    80003878:	854a                	mv	a0,s2
    8000387a:	00004097          	auipc	ra,0x4
    8000387e:	992080e7          	jalr	-1646(ra) # 8000720c <release>
}
    80003882:	60e2                	ld	ra,24(sp)
    80003884:	6442                	ld	s0,16(sp)
    80003886:	64a2                	ld	s1,8(sp)
    80003888:	6902                	ld	s2,0(sp)
    8000388a:	6105                	addi	sp,sp,32
    8000388c:	8082                	ret

000000008000388e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000388e:	7179                	addi	sp,sp,-48
    80003890:	f406                	sd	ra,40(sp)
    80003892:	f022                	sd	s0,32(sp)
    80003894:	ec26                	sd	s1,24(sp)
    80003896:	e84a                	sd	s2,16(sp)
    80003898:	e44e                	sd	s3,8(sp)
    8000389a:	1800                	addi	s0,sp,48
    8000389c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000389e:	00850913          	addi	s2,a0,8
    800038a2:	854a                	mv	a0,s2
    800038a4:	00004097          	auipc	ra,0x4
    800038a8:	8b4080e7          	jalr	-1868(ra) # 80007158 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038ac:	409c                	lw	a5,0(s1)
    800038ae:	ef99                	bnez	a5,800038cc <holdingsleep+0x3e>
    800038b0:	4481                	li	s1,0
  release(&lk->lk);
    800038b2:	854a                	mv	a0,s2
    800038b4:	00004097          	auipc	ra,0x4
    800038b8:	958080e7          	jalr	-1704(ra) # 8000720c <release>
  return r;
}
    800038bc:	8526                	mv	a0,s1
    800038be:	70a2                	ld	ra,40(sp)
    800038c0:	7402                	ld	s0,32(sp)
    800038c2:	64e2                	ld	s1,24(sp)
    800038c4:	6942                	ld	s2,16(sp)
    800038c6:	69a2                	ld	s3,8(sp)
    800038c8:	6145                	addi	sp,sp,48
    800038ca:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038cc:	0284a983          	lw	s3,40(s1)
    800038d0:	ffffd097          	auipc	ra,0xffffd
    800038d4:	5f2080e7          	jalr	1522(ra) # 80000ec2 <myproc>
    800038d8:	5d04                	lw	s1,56(a0)
    800038da:	413484b3          	sub	s1,s1,s3
    800038de:	0014b493          	seqz	s1,s1
    800038e2:	bfc1                	j	800038b2 <holdingsleep+0x24>

00000000800038e4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038e4:	1141                	addi	sp,sp,-16
    800038e6:	e406                	sd	ra,8(sp)
    800038e8:	e022                	sd	s0,0(sp)
    800038ea:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038ec:	00006597          	auipc	a1,0x6
    800038f0:	d3c58593          	addi	a1,a1,-708 # 80009628 <syscalls+0x278>
    800038f4:	00017517          	auipc	a0,0x17
    800038f8:	87c50513          	addi	a0,a0,-1924 # 8001a170 <ftable>
    800038fc:	00003097          	auipc	ra,0x3
    80003900:	7cc080e7          	jalr	1996(ra) # 800070c8 <initlock>
}
    80003904:	60a2                	ld	ra,8(sp)
    80003906:	6402                	ld	s0,0(sp)
    80003908:	0141                	addi	sp,sp,16
    8000390a:	8082                	ret

000000008000390c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000390c:	1101                	addi	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	e426                	sd	s1,8(sp)
    80003914:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003916:	00017517          	auipc	a0,0x17
    8000391a:	85a50513          	addi	a0,a0,-1958 # 8001a170 <ftable>
    8000391e:	00004097          	auipc	ra,0x4
    80003922:	83a080e7          	jalr	-1990(ra) # 80007158 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003926:	00017497          	auipc	s1,0x17
    8000392a:	86248493          	addi	s1,s1,-1950 # 8001a188 <ftable+0x18>
    8000392e:	00018717          	auipc	a4,0x18
    80003932:	b1a70713          	addi	a4,a4,-1254 # 8001b448 <ftable+0x12d8>
    if(f->ref == 0){
    80003936:	40dc                	lw	a5,4(s1)
    80003938:	cf99                	beqz	a5,80003956 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000393a:	03048493          	addi	s1,s1,48
    8000393e:	fee49ce3          	bne	s1,a4,80003936 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003942:	00017517          	auipc	a0,0x17
    80003946:	82e50513          	addi	a0,a0,-2002 # 8001a170 <ftable>
    8000394a:	00004097          	auipc	ra,0x4
    8000394e:	8c2080e7          	jalr	-1854(ra) # 8000720c <release>
  return 0;
    80003952:	4481                	li	s1,0
    80003954:	a819                	j	8000396a <filealloc+0x5e>
      f->ref = 1;
    80003956:	4785                	li	a5,1
    80003958:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000395a:	00017517          	auipc	a0,0x17
    8000395e:	81650513          	addi	a0,a0,-2026 # 8001a170 <ftable>
    80003962:	00004097          	auipc	ra,0x4
    80003966:	8aa080e7          	jalr	-1878(ra) # 8000720c <release>
}
    8000396a:	8526                	mv	a0,s1
    8000396c:	60e2                	ld	ra,24(sp)
    8000396e:	6442                	ld	s0,16(sp)
    80003970:	64a2                	ld	s1,8(sp)
    80003972:	6105                	addi	sp,sp,32
    80003974:	8082                	ret

0000000080003976 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003976:	1101                	addi	sp,sp,-32
    80003978:	ec06                	sd	ra,24(sp)
    8000397a:	e822                	sd	s0,16(sp)
    8000397c:	e426                	sd	s1,8(sp)
    8000397e:	1000                	addi	s0,sp,32
    80003980:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003982:	00016517          	auipc	a0,0x16
    80003986:	7ee50513          	addi	a0,a0,2030 # 8001a170 <ftable>
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	7ce080e7          	jalr	1998(ra) # 80007158 <acquire>
  if(f->ref < 1)
    80003992:	40dc                	lw	a5,4(s1)
    80003994:	02f05263          	blez	a5,800039b8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003998:	2785                	addiw	a5,a5,1
    8000399a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000399c:	00016517          	auipc	a0,0x16
    800039a0:	7d450513          	addi	a0,a0,2004 # 8001a170 <ftable>
    800039a4:	00004097          	auipc	ra,0x4
    800039a8:	868080e7          	jalr	-1944(ra) # 8000720c <release>
  return f;
}
    800039ac:	8526                	mv	a0,s1
    800039ae:	60e2                	ld	ra,24(sp)
    800039b0:	6442                	ld	s0,16(sp)
    800039b2:	64a2                	ld	s1,8(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret
    panic("filedup");
    800039b8:	00006517          	auipc	a0,0x6
    800039bc:	c7850513          	addi	a0,a0,-904 # 80009630 <syscalls+0x280>
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	24e080e7          	jalr	590(ra) # 80006c0e <panic>

00000000800039c8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039c8:	7139                	addi	sp,sp,-64
    800039ca:	fc06                	sd	ra,56(sp)
    800039cc:	f822                	sd	s0,48(sp)
    800039ce:	f426                	sd	s1,40(sp)
    800039d0:	f04a                	sd	s2,32(sp)
    800039d2:	ec4e                	sd	s3,24(sp)
    800039d4:	e852                	sd	s4,16(sp)
    800039d6:	e456                	sd	s5,8(sp)
    800039d8:	e05a                	sd	s6,0(sp)
    800039da:	0080                	addi	s0,sp,64
    800039dc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039de:	00016517          	auipc	a0,0x16
    800039e2:	79250513          	addi	a0,a0,1938 # 8001a170 <ftable>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	772080e7          	jalr	1906(ra) # 80007158 <acquire>
  if(f->ref < 1)
    800039ee:	40dc                	lw	a5,4(s1)
    800039f0:	04f05f63          	blez	a5,80003a4e <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    800039f4:	37fd                	addiw	a5,a5,-1
    800039f6:	0007871b          	sext.w	a4,a5
    800039fa:	c0dc                	sw	a5,4(s1)
    800039fc:	06e04163          	bgtz	a4,80003a5e <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a00:	0004a903          	lw	s2,0(s1)
    80003a04:	0094ca83          	lbu	s5,9(s1)
    80003a08:	0104ba03          	ld	s4,16(s1)
    80003a0c:	0184b983          	ld	s3,24(s1)
    80003a10:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    80003a14:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a18:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a1c:	00016517          	auipc	a0,0x16
    80003a20:	75450513          	addi	a0,a0,1876 # 8001a170 <ftable>
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	7e8080e7          	jalr	2024(ra) # 8000720c <release>

  if(ff.type == FD_PIPE){
    80003a2c:	4785                	li	a5,1
    80003a2e:	04f90a63          	beq	s2,a5,80003a82 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a32:	ffe9079b          	addiw	a5,s2,-2
    80003a36:	4705                	li	a4,1
    80003a38:	04f77c63          	bgeu	a4,a5,80003a90 <fileclose+0xc8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    80003a3c:	4791                	li	a5,4
    80003a3e:	02f91863          	bne	s2,a5,80003a6e <fileclose+0xa6>
    sockclose(ff.sock);
    80003a42:	855a                	mv	a0,s6
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	93a080e7          	jalr	-1734(ra) # 8000637e <sockclose>
    80003a4c:	a00d                	j	80003a6e <fileclose+0xa6>
    panic("fileclose");
    80003a4e:	00006517          	auipc	a0,0x6
    80003a52:	bea50513          	addi	a0,a0,-1046 # 80009638 <syscalls+0x288>
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	1b8080e7          	jalr	440(ra) # 80006c0e <panic>
    release(&ftable.lock);
    80003a5e:	00016517          	auipc	a0,0x16
    80003a62:	71250513          	addi	a0,a0,1810 # 8001a170 <ftable>
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	7a6080e7          	jalr	1958(ra) # 8000720c <release>
  }
#endif
}
    80003a6e:	70e2                	ld	ra,56(sp)
    80003a70:	7442                	ld	s0,48(sp)
    80003a72:	74a2                	ld	s1,40(sp)
    80003a74:	7902                	ld	s2,32(sp)
    80003a76:	69e2                	ld	s3,24(sp)
    80003a78:	6a42                	ld	s4,16(sp)
    80003a7a:	6aa2                	ld	s5,8(sp)
    80003a7c:	6b02                	ld	s6,0(sp)
    80003a7e:	6121                	addi	sp,sp,64
    80003a80:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a82:	85d6                	mv	a1,s5
    80003a84:	8552                	mv	a0,s4
    80003a86:	00000097          	auipc	ra,0x0
    80003a8a:	37c080e7          	jalr	892(ra) # 80003e02 <pipeclose>
    80003a8e:	b7c5                	j	80003a6e <fileclose+0xa6>
    begin_op();
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	a64080e7          	jalr	-1436(ra) # 800034f4 <begin_op>
    iput(ff.ip);
    80003a98:	854e                	mv	a0,s3
    80003a9a:	fffff097          	auipc	ra,0xfffff
    80003a9e:	242080e7          	jalr	578(ra) # 80002cdc <iput>
    end_op();
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	ad2080e7          	jalr	-1326(ra) # 80003574 <end_op>
    80003aaa:	b7d1                	j	80003a6e <fileclose+0xa6>

0000000080003aac <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003aac:	715d                	addi	sp,sp,-80
    80003aae:	e486                	sd	ra,72(sp)
    80003ab0:	e0a2                	sd	s0,64(sp)
    80003ab2:	fc26                	sd	s1,56(sp)
    80003ab4:	f84a                	sd	s2,48(sp)
    80003ab6:	f44e                	sd	s3,40(sp)
    80003ab8:	0880                	addi	s0,sp,80
    80003aba:	84aa                	mv	s1,a0
    80003abc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003abe:	ffffd097          	auipc	ra,0xffffd
    80003ac2:	404080e7          	jalr	1028(ra) # 80000ec2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ac6:	409c                	lw	a5,0(s1)
    80003ac8:	37f9                	addiw	a5,a5,-2
    80003aca:	4705                	li	a4,1
    80003acc:	04f76763          	bltu	a4,a5,80003b1a <filestat+0x6e>
    80003ad0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ad2:	6c88                	ld	a0,24(s1)
    80003ad4:	fffff097          	auipc	ra,0xfffff
    80003ad8:	04e080e7          	jalr	78(ra) # 80002b22 <ilock>
    stati(f->ip, &st);
    80003adc:	fb840593          	addi	a1,s0,-72
    80003ae0:	6c88                	ld	a0,24(s1)
    80003ae2:	fffff097          	auipc	ra,0xfffff
    80003ae6:	2ca080e7          	jalr	714(ra) # 80002dac <stati>
    iunlock(f->ip);
    80003aea:	6c88                	ld	a0,24(s1)
    80003aec:	fffff097          	auipc	ra,0xfffff
    80003af0:	0f8080e7          	jalr	248(ra) # 80002be4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003af4:	46e1                	li	a3,24
    80003af6:	fb840613          	addi	a2,s0,-72
    80003afa:	85ce                	mv	a1,s3
    80003afc:	05093503          	ld	a0,80(s2)
    80003b00:	ffffd097          	auipc	ra,0xffffd
    80003b04:	058080e7          	jalr	88(ra) # 80000b58 <copyout>
    80003b08:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b0c:	60a6                	ld	ra,72(sp)
    80003b0e:	6406                	ld	s0,64(sp)
    80003b10:	74e2                	ld	s1,56(sp)
    80003b12:	7942                	ld	s2,48(sp)
    80003b14:	79a2                	ld	s3,40(sp)
    80003b16:	6161                	addi	sp,sp,80
    80003b18:	8082                	ret
  return -1;
    80003b1a:	557d                	li	a0,-1
    80003b1c:	bfc5                	j	80003b0c <filestat+0x60>

0000000080003b1e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b1e:	7179                	addi	sp,sp,-48
    80003b20:	f406                	sd	ra,40(sp)
    80003b22:	f022                	sd	s0,32(sp)
    80003b24:	ec26                	sd	s1,24(sp)
    80003b26:	e84a                	sd	s2,16(sp)
    80003b28:	e44e                	sd	s3,8(sp)
    80003b2a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b2c:	00854783          	lbu	a5,8(a0)
    80003b30:	cfc5                	beqz	a5,80003be8 <fileread+0xca>
    80003b32:	84aa                	mv	s1,a0
    80003b34:	89ae                	mv	s3,a1
    80003b36:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b38:	411c                	lw	a5,0(a0)
    80003b3a:	4705                	li	a4,1
    80003b3c:	02e78963          	beq	a5,a4,80003b6e <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b40:	470d                	li	a4,3
    80003b42:	02e78d63          	beq	a5,a4,80003b7c <fileread+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b46:	4709                	li	a4,2
    80003b48:	04e78e63          	beq	a5,a4,80003ba4 <fileread+0x86>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b4c:	4711                	li	a4,4
    80003b4e:	08e79563          	bne	a5,a4,80003bd8 <fileread+0xba>
    r = sockread(f->sock, addr, n);
    80003b52:	7108                	ld	a0,32(a0)
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	8ba080e7          	jalr	-1862(ra) # 8000640e <sockread>
    80003b5c:	892a                	mv	s2,a0
  else {
    panic("fileread");
  }

  return r;
}
    80003b5e:	854a                	mv	a0,s2
    80003b60:	70a2                	ld	ra,40(sp)
    80003b62:	7402                	ld	s0,32(sp)
    80003b64:	64e2                	ld	s1,24(sp)
    80003b66:	6942                	ld	s2,16(sp)
    80003b68:	69a2                	ld	s3,8(sp)
    80003b6a:	6145                	addi	sp,sp,48
    80003b6c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b6e:	6908                	ld	a0,16(a0)
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	3fc080e7          	jalr	1020(ra) # 80003f6c <piperead>
    80003b78:	892a                	mv	s2,a0
    80003b7a:	b7d5                	j	80003b5e <fileread+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b7c:	02c51783          	lh	a5,44(a0)
    80003b80:	03079693          	slli	a3,a5,0x30
    80003b84:	92c1                	srli	a3,a3,0x30
    80003b86:	4725                	li	a4,9
    80003b88:	06d76263          	bltu	a4,a3,80003bec <fileread+0xce>
    80003b8c:	0792                	slli	a5,a5,0x4
    80003b8e:	00016717          	auipc	a4,0x16
    80003b92:	54270713          	addi	a4,a4,1346 # 8001a0d0 <devsw>
    80003b96:	97ba                	add	a5,a5,a4
    80003b98:	639c                	ld	a5,0(a5)
    80003b9a:	cbb9                	beqz	a5,80003bf0 <fileread+0xd2>
    r = devsw[f->major].read(1, addr, n);
    80003b9c:	4505                	li	a0,1
    80003b9e:	9782                	jalr	a5
    80003ba0:	892a                	mv	s2,a0
    80003ba2:	bf75                	j	80003b5e <fileread+0x40>
    ilock(f->ip);
    80003ba4:	6d08                	ld	a0,24(a0)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	f7c080e7          	jalr	-132(ra) # 80002b22 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bae:	874a                	mv	a4,s2
    80003bb0:	5494                	lw	a3,40(s1)
    80003bb2:	864e                	mv	a2,s3
    80003bb4:	4585                	li	a1,1
    80003bb6:	6c88                	ld	a0,24(s1)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	21e080e7          	jalr	542(ra) # 80002dd6 <readi>
    80003bc0:	892a                	mv	s2,a0
    80003bc2:	00a05563          	blez	a0,80003bcc <fileread+0xae>
      f->off += r;
    80003bc6:	549c                	lw	a5,40(s1)
    80003bc8:	9fa9                	addw	a5,a5,a0
    80003bca:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003bcc:	6c88                	ld	a0,24(s1)
    80003bce:	fffff097          	auipc	ra,0xfffff
    80003bd2:	016080e7          	jalr	22(ra) # 80002be4 <iunlock>
    80003bd6:	b761                	j	80003b5e <fileread+0x40>
    panic("fileread");
    80003bd8:	00006517          	auipc	a0,0x6
    80003bdc:	a7050513          	addi	a0,a0,-1424 # 80009648 <syscalls+0x298>
    80003be0:	00003097          	auipc	ra,0x3
    80003be4:	02e080e7          	jalr	46(ra) # 80006c0e <panic>
    return -1;
    80003be8:	597d                	li	s2,-1
    80003bea:	bf95                	j	80003b5e <fileread+0x40>
      return -1;
    80003bec:	597d                	li	s2,-1
    80003bee:	bf85                	j	80003b5e <fileread+0x40>
    80003bf0:	597d                	li	s2,-1
    80003bf2:	b7b5                	j	80003b5e <fileread+0x40>

0000000080003bf4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bf4:	00954783          	lbu	a5,9(a0)
    80003bf8:	12078263          	beqz	a5,80003d1c <filewrite+0x128>
{
    80003bfc:	715d                	addi	sp,sp,-80
    80003bfe:	e486                	sd	ra,72(sp)
    80003c00:	e0a2                	sd	s0,64(sp)
    80003c02:	fc26                	sd	s1,56(sp)
    80003c04:	f84a                	sd	s2,48(sp)
    80003c06:	f44e                	sd	s3,40(sp)
    80003c08:	f052                	sd	s4,32(sp)
    80003c0a:	ec56                	sd	s5,24(sp)
    80003c0c:	e85a                	sd	s6,16(sp)
    80003c0e:	e45e                	sd	s7,8(sp)
    80003c10:	e062                	sd	s8,0(sp)
    80003c12:	0880                	addi	s0,sp,80
    80003c14:	84aa                	mv	s1,a0
    80003c16:	8aae                	mv	s5,a1
    80003c18:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c1a:	411c                	lw	a5,0(a0)
    80003c1c:	4705                	li	a4,1
    80003c1e:	02e78c63          	beq	a5,a4,80003c56 <filewrite+0x62>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c22:	470d                	li	a4,3
    80003c24:	02e78f63          	beq	a5,a4,80003c62 <filewrite+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c28:	4709                	li	a4,2
    80003c2a:	04e78f63          	beq	a5,a4,80003c88 <filewrite+0x94>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003c2e:	4711                	li	a4,4
    80003c30:	0ce79e63          	bne	a5,a4,80003d0c <filewrite+0x118>
    ret = sockwrite(f->sock, addr, n);
    80003c34:	7108                	ld	a0,32(a0)
    80003c36:	00003097          	auipc	ra,0x3
    80003c3a:	8a8080e7          	jalr	-1880(ra) # 800064de <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003c3e:	60a6                	ld	ra,72(sp)
    80003c40:	6406                	ld	s0,64(sp)
    80003c42:	74e2                	ld	s1,56(sp)
    80003c44:	7942                	ld	s2,48(sp)
    80003c46:	79a2                	ld	s3,40(sp)
    80003c48:	7a02                	ld	s4,32(sp)
    80003c4a:	6ae2                	ld	s5,24(sp)
    80003c4c:	6b42                	ld	s6,16(sp)
    80003c4e:	6ba2                	ld	s7,8(sp)
    80003c50:	6c02                	ld	s8,0(sp)
    80003c52:	6161                	addi	sp,sp,80
    80003c54:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003c56:	6908                	ld	a0,16(a0)
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	21a080e7          	jalr	538(ra) # 80003e72 <pipewrite>
    80003c60:	bff9                	j	80003c3e <filewrite+0x4a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c62:	02c51783          	lh	a5,44(a0)
    80003c66:	03079693          	slli	a3,a5,0x30
    80003c6a:	92c1                	srli	a3,a3,0x30
    80003c6c:	4725                	li	a4,9
    80003c6e:	0ad76963          	bltu	a4,a3,80003d20 <filewrite+0x12c>
    80003c72:	0792                	slli	a5,a5,0x4
    80003c74:	00016717          	auipc	a4,0x16
    80003c78:	45c70713          	addi	a4,a4,1116 # 8001a0d0 <devsw>
    80003c7c:	97ba                	add	a5,a5,a4
    80003c7e:	679c                	ld	a5,8(a5)
    80003c80:	c3d5                	beqz	a5,80003d24 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c82:	4505                	li	a0,1
    80003c84:	9782                	jalr	a5
    80003c86:	bf65                	j	80003c3e <filewrite+0x4a>
    while(i < n){
    80003c88:	06c05c63          	blez	a2,80003d00 <filewrite+0x10c>
    int i = 0;
    80003c8c:	4981                	li	s3,0
    80003c8e:	6b05                	lui	s6,0x1
    80003c90:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c94:	6b85                	lui	s7,0x1
    80003c96:	c00b8b9b          	addiw	s7,s7,-1024
    80003c9a:	a899                	j	80003cf0 <filewrite+0xfc>
    80003c9c:	00090c1b          	sext.w	s8,s2
      begin_op();
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	854080e7          	jalr	-1964(ra) # 800034f4 <begin_op>
      ilock(f->ip);
    80003ca8:	6c88                	ld	a0,24(s1)
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	e78080e7          	jalr	-392(ra) # 80002b22 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cb2:	8762                	mv	a4,s8
    80003cb4:	5494                	lw	a3,40(s1)
    80003cb6:	01598633          	add	a2,s3,s5
    80003cba:	4585                	li	a1,1
    80003cbc:	6c88                	ld	a0,24(s1)
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	210080e7          	jalr	528(ra) # 80002ece <writei>
    80003cc6:	892a                	mv	s2,a0
    80003cc8:	00a05563          	blez	a0,80003cd2 <filewrite+0xde>
        f->off += r;
    80003ccc:	549c                	lw	a5,40(s1)
    80003cce:	9fa9                	addw	a5,a5,a0
    80003cd0:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003cd2:	6c88                	ld	a0,24(s1)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	f10080e7          	jalr	-240(ra) # 80002be4 <iunlock>
      end_op();
    80003cdc:	00000097          	auipc	ra,0x0
    80003ce0:	898080e7          	jalr	-1896(ra) # 80003574 <end_op>
      if(r != n1){
    80003ce4:	012c1f63          	bne	s8,s2,80003d02 <filewrite+0x10e>
      i += r;
    80003ce8:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80003cec:	0149db63          	bge	s3,s4,80003d02 <filewrite+0x10e>
      int n1 = n - i;
    80003cf0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cf4:	893e                	mv	s2,a5
    80003cf6:	2781                	sext.w	a5,a5
    80003cf8:	fafb52e3          	bge	s6,a5,80003c9c <filewrite+0xa8>
    80003cfc:	895e                	mv	s2,s7
    80003cfe:	bf79                	j	80003c9c <filewrite+0xa8>
    int i = 0;
    80003d00:	4981                	li	s3,0
    ret = (i == n ? n : -1);
    80003d02:	8552                	mv	a0,s4
    80003d04:	f33a0de3          	beq	s4,s3,80003c3e <filewrite+0x4a>
    80003d08:	557d                	li	a0,-1
    80003d0a:	bf15                	j	80003c3e <filewrite+0x4a>
    panic("filewrite");
    80003d0c:	00006517          	auipc	a0,0x6
    80003d10:	94c50513          	addi	a0,a0,-1716 # 80009658 <syscalls+0x2a8>
    80003d14:	00003097          	auipc	ra,0x3
    80003d18:	efa080e7          	jalr	-262(ra) # 80006c0e <panic>
    return -1;
    80003d1c:	557d                	li	a0,-1
}
    80003d1e:	8082                	ret
      return -1;
    80003d20:	557d                	li	a0,-1
    80003d22:	bf31                	j	80003c3e <filewrite+0x4a>
    80003d24:	557d                	li	a0,-1
    80003d26:	bf21                	j	80003c3e <filewrite+0x4a>

0000000080003d28 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d28:	7179                	addi	sp,sp,-48
    80003d2a:	f406                	sd	ra,40(sp)
    80003d2c:	f022                	sd	s0,32(sp)
    80003d2e:	ec26                	sd	s1,24(sp)
    80003d30:	e84a                	sd	s2,16(sp)
    80003d32:	e44e                	sd	s3,8(sp)
    80003d34:	e052                	sd	s4,0(sp)
    80003d36:	1800                	addi	s0,sp,48
    80003d38:	84aa                	mv	s1,a0
    80003d3a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d3c:	0005b023          	sd	zero,0(a1)
    80003d40:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	bc8080e7          	jalr	-1080(ra) # 8000390c <filealloc>
    80003d4c:	e088                	sd	a0,0(s1)
    80003d4e:	c551                	beqz	a0,80003dda <pipealloc+0xb2>
    80003d50:	00000097          	auipc	ra,0x0
    80003d54:	bbc080e7          	jalr	-1092(ra) # 8000390c <filealloc>
    80003d58:	00aa3023          	sd	a0,0(s4)
    80003d5c:	c92d                	beqz	a0,80003dce <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d5e:	ffffc097          	auipc	ra,0xffffc
    80003d62:	3ba080e7          	jalr	954(ra) # 80000118 <kalloc>
    80003d66:	892a                	mv	s2,a0
    80003d68:	c125                	beqz	a0,80003dc8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d6a:	4985                	li	s3,1
    80003d6c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d70:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d74:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d78:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d7c:	00006597          	auipc	a1,0x6
    80003d80:	8ec58593          	addi	a1,a1,-1812 # 80009668 <syscalls+0x2b8>
    80003d84:	00003097          	auipc	ra,0x3
    80003d88:	344080e7          	jalr	836(ra) # 800070c8 <initlock>
  (*f0)->type = FD_PIPE;
    80003d8c:	609c                	ld	a5,0(s1)
    80003d8e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d92:	609c                	ld	a5,0(s1)
    80003d94:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d98:	609c                	ld	a5,0(s1)
    80003d9a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d9e:	609c                	ld	a5,0(s1)
    80003da0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003da4:	000a3783          	ld	a5,0(s4)
    80003da8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dac:	000a3783          	ld	a5,0(s4)
    80003db0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003db4:	000a3783          	ld	a5,0(s4)
    80003db8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dbc:	000a3783          	ld	a5,0(s4)
    80003dc0:	0127b823          	sd	s2,16(a5)
  return 0;
    80003dc4:	4501                	li	a0,0
    80003dc6:	a025                	j	80003dee <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dc8:	6088                	ld	a0,0(s1)
    80003dca:	e501                	bnez	a0,80003dd2 <pipealloc+0xaa>
    80003dcc:	a039                	j	80003dda <pipealloc+0xb2>
    80003dce:	6088                	ld	a0,0(s1)
    80003dd0:	c51d                	beqz	a0,80003dfe <pipealloc+0xd6>
    fileclose(*f0);
    80003dd2:	00000097          	auipc	ra,0x0
    80003dd6:	bf6080e7          	jalr	-1034(ra) # 800039c8 <fileclose>
  if(*f1)
    80003dda:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dde:	557d                	li	a0,-1
  if(*f1)
    80003de0:	c799                	beqz	a5,80003dee <pipealloc+0xc6>
    fileclose(*f1);
    80003de2:	853e                	mv	a0,a5
    80003de4:	00000097          	auipc	ra,0x0
    80003de8:	be4080e7          	jalr	-1052(ra) # 800039c8 <fileclose>
  return -1;
    80003dec:	557d                	li	a0,-1
}
    80003dee:	70a2                	ld	ra,40(sp)
    80003df0:	7402                	ld	s0,32(sp)
    80003df2:	64e2                	ld	s1,24(sp)
    80003df4:	6942                	ld	s2,16(sp)
    80003df6:	69a2                	ld	s3,8(sp)
    80003df8:	6a02                	ld	s4,0(sp)
    80003dfa:	6145                	addi	sp,sp,48
    80003dfc:	8082                	ret
  return -1;
    80003dfe:	557d                	li	a0,-1
    80003e00:	b7fd                	j	80003dee <pipealloc+0xc6>

0000000080003e02 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e02:	1101                	addi	sp,sp,-32
    80003e04:	ec06                	sd	ra,24(sp)
    80003e06:	e822                	sd	s0,16(sp)
    80003e08:	e426                	sd	s1,8(sp)
    80003e0a:	e04a                	sd	s2,0(sp)
    80003e0c:	1000                	addi	s0,sp,32
    80003e0e:	84aa                	mv	s1,a0
    80003e10:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e12:	00003097          	auipc	ra,0x3
    80003e16:	346080e7          	jalr	838(ra) # 80007158 <acquire>
  if(writable){
    80003e1a:	02090d63          	beqz	s2,80003e54 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e1e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e22:	21848513          	addi	a0,s1,536
    80003e26:	ffffe097          	auipc	ra,0xffffe
    80003e2a:	a32080e7          	jalr	-1486(ra) # 80001858 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e2e:	2204b783          	ld	a5,544(s1)
    80003e32:	eb95                	bnez	a5,80003e66 <pipeclose+0x64>
    release(&pi->lock);
    80003e34:	8526                	mv	a0,s1
    80003e36:	00003097          	auipc	ra,0x3
    80003e3a:	3d6080e7          	jalr	982(ra) # 8000720c <release>
    kfree((char*)pi);
    80003e3e:	8526                	mv	a0,s1
    80003e40:	ffffc097          	auipc	ra,0xffffc
    80003e44:	1dc080e7          	jalr	476(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e48:	60e2                	ld	ra,24(sp)
    80003e4a:	6442                	ld	s0,16(sp)
    80003e4c:	64a2                	ld	s1,8(sp)
    80003e4e:	6902                	ld	s2,0(sp)
    80003e50:	6105                	addi	sp,sp,32
    80003e52:	8082                	ret
    pi->readopen = 0;
    80003e54:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e58:	21c48513          	addi	a0,s1,540
    80003e5c:	ffffe097          	auipc	ra,0xffffe
    80003e60:	9fc080e7          	jalr	-1540(ra) # 80001858 <wakeup>
    80003e64:	b7e9                	j	80003e2e <pipeclose+0x2c>
    release(&pi->lock);
    80003e66:	8526                	mv	a0,s1
    80003e68:	00003097          	auipc	ra,0x3
    80003e6c:	3a4080e7          	jalr	932(ra) # 8000720c <release>
}
    80003e70:	bfe1                	j	80003e48 <pipeclose+0x46>

0000000080003e72 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e72:	7159                	addi	sp,sp,-112
    80003e74:	f486                	sd	ra,104(sp)
    80003e76:	f0a2                	sd	s0,96(sp)
    80003e78:	eca6                	sd	s1,88(sp)
    80003e7a:	e8ca                	sd	s2,80(sp)
    80003e7c:	e4ce                	sd	s3,72(sp)
    80003e7e:	e0d2                	sd	s4,64(sp)
    80003e80:	fc56                	sd	s5,56(sp)
    80003e82:	f85a                	sd	s6,48(sp)
    80003e84:	f45e                	sd	s7,40(sp)
    80003e86:	f062                	sd	s8,32(sp)
    80003e88:	ec66                	sd	s9,24(sp)
    80003e8a:	1880                	addi	s0,sp,112
    80003e8c:	84aa                	mv	s1,a0
    80003e8e:	8aae                	mv	s5,a1
    80003e90:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	030080e7          	jalr	48(ra) # 80000ec2 <myproc>
    80003e9a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	00003097          	auipc	ra,0x3
    80003ea2:	2ba080e7          	jalr	698(ra) # 80007158 <acquire>
  while(i < n){
    80003ea6:	0d405163          	blez	s4,80003f68 <pipewrite+0xf6>
    80003eaa:	8ba6                	mv	s7,s1
  int i = 0;
    80003eac:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eae:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003eb0:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003eb4:	21c48c13          	addi	s8,s1,540
    80003eb8:	a08d                	j	80003f1a <pipewrite+0xa8>
      release(&pi->lock);
    80003eba:	8526                	mv	a0,s1
    80003ebc:	00003097          	auipc	ra,0x3
    80003ec0:	350080e7          	jalr	848(ra) # 8000720c <release>
      return -1;
    80003ec4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ec6:	854a                	mv	a0,s2
    80003ec8:	70a6                	ld	ra,104(sp)
    80003eca:	7406                	ld	s0,96(sp)
    80003ecc:	64e6                	ld	s1,88(sp)
    80003ece:	6946                	ld	s2,80(sp)
    80003ed0:	69a6                	ld	s3,72(sp)
    80003ed2:	6a06                	ld	s4,64(sp)
    80003ed4:	7ae2                	ld	s5,56(sp)
    80003ed6:	7b42                	ld	s6,48(sp)
    80003ed8:	7ba2                	ld	s7,40(sp)
    80003eda:	7c02                	ld	s8,32(sp)
    80003edc:	6ce2                	ld	s9,24(sp)
    80003ede:	6165                	addi	sp,sp,112
    80003ee0:	8082                	ret
      wakeup(&pi->nread);
    80003ee2:	8566                	mv	a0,s9
    80003ee4:	ffffe097          	auipc	ra,0xffffe
    80003ee8:	974080e7          	jalr	-1676(ra) # 80001858 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eec:	85de                	mv	a1,s7
    80003eee:	8562                	mv	a0,s8
    80003ef0:	ffffd097          	auipc	ra,0xffffd
    80003ef4:	7e2080e7          	jalr	2018(ra) # 800016d2 <sleep>
    80003ef8:	a839                	j	80003f16 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003efa:	21c4a783          	lw	a5,540(s1)
    80003efe:	0017871b          	addiw	a4,a5,1
    80003f02:	20e4ae23          	sw	a4,540(s1)
    80003f06:	1ff7f793          	andi	a5,a5,511
    80003f0a:	97a6                	add	a5,a5,s1
    80003f0c:	f9f44703          	lbu	a4,-97(s0)
    80003f10:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f14:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f16:	03495d63          	bge	s2,s4,80003f50 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f1a:	2204a783          	lw	a5,544(s1)
    80003f1e:	dfd1                	beqz	a5,80003eba <pipewrite+0x48>
    80003f20:	0309a783          	lw	a5,48(s3)
    80003f24:	fbd9                	bnez	a5,80003eba <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f26:	2184a783          	lw	a5,536(s1)
    80003f2a:	21c4a703          	lw	a4,540(s1)
    80003f2e:	2007879b          	addiw	a5,a5,512
    80003f32:	faf708e3          	beq	a4,a5,80003ee2 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f36:	4685                	li	a3,1
    80003f38:	01590633          	add	a2,s2,s5
    80003f3c:	f9f40593          	addi	a1,s0,-97
    80003f40:	0509b503          	ld	a0,80(s3)
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	ca0080e7          	jalr	-864(ra) # 80000be4 <copyin>
    80003f4c:	fb6517e3          	bne	a0,s6,80003efa <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f50:	21848513          	addi	a0,s1,536
    80003f54:	ffffe097          	auipc	ra,0xffffe
    80003f58:	904080e7          	jalr	-1788(ra) # 80001858 <wakeup>
  release(&pi->lock);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	00003097          	auipc	ra,0x3
    80003f62:	2ae080e7          	jalr	686(ra) # 8000720c <release>
  return i;
    80003f66:	b785                	j	80003ec6 <pipewrite+0x54>
  int i = 0;
    80003f68:	4901                	li	s2,0
    80003f6a:	b7dd                	j	80003f50 <pipewrite+0xde>

0000000080003f6c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f6c:	715d                	addi	sp,sp,-80
    80003f6e:	e486                	sd	ra,72(sp)
    80003f70:	e0a2                	sd	s0,64(sp)
    80003f72:	fc26                	sd	s1,56(sp)
    80003f74:	f84a                	sd	s2,48(sp)
    80003f76:	f44e                	sd	s3,40(sp)
    80003f78:	f052                	sd	s4,32(sp)
    80003f7a:	ec56                	sd	s5,24(sp)
    80003f7c:	e85a                	sd	s6,16(sp)
    80003f7e:	0880                	addi	s0,sp,80
    80003f80:	84aa                	mv	s1,a0
    80003f82:	892e                	mv	s2,a1
    80003f84:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	f3c080e7          	jalr	-196(ra) # 80000ec2 <myproc>
    80003f8e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f90:	8b26                	mv	s6,s1
    80003f92:	8526                	mv	a0,s1
    80003f94:	00003097          	auipc	ra,0x3
    80003f98:	1c4080e7          	jalr	452(ra) # 80007158 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f9c:	2184a703          	lw	a4,536(s1)
    80003fa0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fa4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fa8:	02f71463          	bne	a4,a5,80003fd0 <piperead+0x64>
    80003fac:	2244a783          	lw	a5,548(s1)
    80003fb0:	c385                	beqz	a5,80003fd0 <piperead+0x64>
    if(pr->killed){
    80003fb2:	030a2783          	lw	a5,48(s4)
    80003fb6:	ebc1                	bnez	a5,80004046 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fb8:	85da                	mv	a1,s6
    80003fba:	854e                	mv	a0,s3
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	716080e7          	jalr	1814(ra) # 800016d2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fc4:	2184a703          	lw	a4,536(s1)
    80003fc8:	21c4a783          	lw	a5,540(s1)
    80003fcc:	fef700e3          	beq	a4,a5,80003fac <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd0:	09505263          	blez	s5,80004054 <piperead+0xe8>
    80003fd4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fd6:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003fd8:	2184a783          	lw	a5,536(s1)
    80003fdc:	21c4a703          	lw	a4,540(s1)
    80003fe0:	02f70d63          	beq	a4,a5,8000401a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fe4:	0017871b          	addiw	a4,a5,1
    80003fe8:	20e4ac23          	sw	a4,536(s1)
    80003fec:	1ff7f793          	andi	a5,a5,511
    80003ff0:	97a6                	add	a5,a5,s1
    80003ff2:	0187c783          	lbu	a5,24(a5)
    80003ff6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ffa:	4685                	li	a3,1
    80003ffc:	fbf40613          	addi	a2,s0,-65
    80004000:	85ca                	mv	a1,s2
    80004002:	050a3503          	ld	a0,80(s4)
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	b52080e7          	jalr	-1198(ra) # 80000b58 <copyout>
    8000400e:	01650663          	beq	a0,s6,8000401a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004012:	2985                	addiw	s3,s3,1
    80004014:	0905                	addi	s2,s2,1
    80004016:	fd3a91e3          	bne	s5,s3,80003fd8 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000401a:	21c48513          	addi	a0,s1,540
    8000401e:	ffffe097          	auipc	ra,0xffffe
    80004022:	83a080e7          	jalr	-1990(ra) # 80001858 <wakeup>
  release(&pi->lock);
    80004026:	8526                	mv	a0,s1
    80004028:	00003097          	auipc	ra,0x3
    8000402c:	1e4080e7          	jalr	484(ra) # 8000720c <release>
  return i;
}
    80004030:	854e                	mv	a0,s3
    80004032:	60a6                	ld	ra,72(sp)
    80004034:	6406                	ld	s0,64(sp)
    80004036:	74e2                	ld	s1,56(sp)
    80004038:	7942                	ld	s2,48(sp)
    8000403a:	79a2                	ld	s3,40(sp)
    8000403c:	7a02                	ld	s4,32(sp)
    8000403e:	6ae2                	ld	s5,24(sp)
    80004040:	6b42                	ld	s6,16(sp)
    80004042:	6161                	addi	sp,sp,80
    80004044:	8082                	ret
      release(&pi->lock);
    80004046:	8526                	mv	a0,s1
    80004048:	00003097          	auipc	ra,0x3
    8000404c:	1c4080e7          	jalr	452(ra) # 8000720c <release>
      return -1;
    80004050:	59fd                	li	s3,-1
    80004052:	bff9                	j	80004030 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004054:	4981                	li	s3,0
    80004056:	b7d1                	j	8000401a <piperead+0xae>

0000000080004058 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004058:	df010113          	addi	sp,sp,-528
    8000405c:	20113423          	sd	ra,520(sp)
    80004060:	20813023          	sd	s0,512(sp)
    80004064:	ffa6                	sd	s1,504(sp)
    80004066:	fbca                	sd	s2,496(sp)
    80004068:	f7ce                	sd	s3,488(sp)
    8000406a:	f3d2                	sd	s4,480(sp)
    8000406c:	efd6                	sd	s5,472(sp)
    8000406e:	ebda                	sd	s6,464(sp)
    80004070:	e7de                	sd	s7,456(sp)
    80004072:	e3e2                	sd	s8,448(sp)
    80004074:	ff66                	sd	s9,440(sp)
    80004076:	fb6a                	sd	s10,432(sp)
    80004078:	f76e                	sd	s11,424(sp)
    8000407a:	0c00                	addi	s0,sp,528
    8000407c:	84aa                	mv	s1,a0
    8000407e:	dea43c23          	sd	a0,-520(s0)
    80004082:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004086:	ffffd097          	auipc	ra,0xffffd
    8000408a:	e3c080e7          	jalr	-452(ra) # 80000ec2 <myproc>
    8000408e:	892a                	mv	s2,a0

  begin_op();
    80004090:	fffff097          	auipc	ra,0xfffff
    80004094:	464080e7          	jalr	1124(ra) # 800034f4 <begin_op>

  if((ip = namei(path)) == 0){
    80004098:	8526                	mv	a0,s1
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	23e080e7          	jalr	574(ra) # 800032d8 <namei>
    800040a2:	c92d                	beqz	a0,80004114 <exec+0xbc>
    800040a4:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	a7c080e7          	jalr	-1412(ra) # 80002b22 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040ae:	04000713          	li	a4,64
    800040b2:	4681                	li	a3,0
    800040b4:	e4840613          	addi	a2,s0,-440
    800040b8:	4581                	li	a1,0
    800040ba:	8526                	mv	a0,s1
    800040bc:	fffff097          	auipc	ra,0xfffff
    800040c0:	d1a080e7          	jalr	-742(ra) # 80002dd6 <readi>
    800040c4:	04000793          	li	a5,64
    800040c8:	00f51a63          	bne	a0,a5,800040dc <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040cc:	e4842703          	lw	a4,-440(s0)
    800040d0:	464c47b7          	lui	a5,0x464c4
    800040d4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040d8:	04f70463          	beq	a4,a5,80004120 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040dc:	8526                	mv	a0,s1
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	ca6080e7          	jalr	-858(ra) # 80002d84 <iunlockput>
    end_op();
    800040e6:	fffff097          	auipc	ra,0xfffff
    800040ea:	48e080e7          	jalr	1166(ra) # 80003574 <end_op>
  }
  return -1;
    800040ee:	557d                	li	a0,-1
}
    800040f0:	20813083          	ld	ra,520(sp)
    800040f4:	20013403          	ld	s0,512(sp)
    800040f8:	74fe                	ld	s1,504(sp)
    800040fa:	795e                	ld	s2,496(sp)
    800040fc:	79be                	ld	s3,488(sp)
    800040fe:	7a1e                	ld	s4,480(sp)
    80004100:	6afe                	ld	s5,472(sp)
    80004102:	6b5e                	ld	s6,464(sp)
    80004104:	6bbe                	ld	s7,456(sp)
    80004106:	6c1e                	ld	s8,448(sp)
    80004108:	7cfa                	ld	s9,440(sp)
    8000410a:	7d5a                	ld	s10,432(sp)
    8000410c:	7dba                	ld	s11,424(sp)
    8000410e:	21010113          	addi	sp,sp,528
    80004112:	8082                	ret
    end_op();
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	460080e7          	jalr	1120(ra) # 80003574 <end_op>
    return -1;
    8000411c:	557d                	li	a0,-1
    8000411e:	bfc9                	j	800040f0 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004120:	854a                	mv	a0,s2
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	e64080e7          	jalr	-412(ra) # 80000f86 <proc_pagetable>
    8000412a:	8baa                	mv	s7,a0
    8000412c:	d945                	beqz	a0,800040dc <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000412e:	e6842983          	lw	s3,-408(s0)
    80004132:	e8045783          	lhu	a5,-384(s0)
    80004136:	c7ad                	beqz	a5,800041a0 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004138:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000413a:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000413c:	6c85                	lui	s9,0x1
    8000413e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004142:	def43823          	sd	a5,-528(s0)
    80004146:	a42d                	j	80004370 <exec+0x318>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004148:	00005517          	auipc	a0,0x5
    8000414c:	52850513          	addi	a0,a0,1320 # 80009670 <syscalls+0x2c0>
    80004150:	00003097          	auipc	ra,0x3
    80004154:	abe080e7          	jalr	-1346(ra) # 80006c0e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004158:	8756                	mv	a4,s5
    8000415a:	012d86bb          	addw	a3,s11,s2
    8000415e:	4581                	li	a1,0
    80004160:	8526                	mv	a0,s1
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	c74080e7          	jalr	-908(ra) # 80002dd6 <readi>
    8000416a:	2501                	sext.w	a0,a0
    8000416c:	1aaa9963          	bne	s5,a0,8000431e <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004170:	6785                	lui	a5,0x1
    80004172:	0127893b          	addw	s2,a5,s2
    80004176:	77fd                	lui	a5,0xfffff
    80004178:	01478a3b          	addw	s4,a5,s4
    8000417c:	1f897163          	bgeu	s2,s8,8000435e <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004180:	02091593          	slli	a1,s2,0x20
    80004184:	9181                	srli	a1,a1,0x20
    80004186:	95ea                	add	a1,a1,s10
    80004188:	855e                	mv	a0,s7
    8000418a:	ffffc097          	auipc	ra,0xffffc
    8000418e:	398080e7          	jalr	920(ra) # 80000522 <walkaddr>
    80004192:	862a                	mv	a2,a0
    if(pa == 0)
    80004194:	d955                	beqz	a0,80004148 <exec+0xf0>
      n = PGSIZE;
    80004196:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004198:	fd9a70e3          	bgeu	s4,s9,80004158 <exec+0x100>
      n = sz - i;
    8000419c:	8ad2                	mv	s5,s4
    8000419e:	bf6d                	j	80004158 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800041a0:	4901                	li	s2,0
  iunlockput(ip);
    800041a2:	8526                	mv	a0,s1
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	be0080e7          	jalr	-1056(ra) # 80002d84 <iunlockput>
  end_op();
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	3c8080e7          	jalr	968(ra) # 80003574 <end_op>
  p = myproc();
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	d0e080e7          	jalr	-754(ra) # 80000ec2 <myproc>
    800041bc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041be:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041c2:	6785                	lui	a5,0x1
    800041c4:	17fd                	addi	a5,a5,-1
    800041c6:	993e                	add	s2,s2,a5
    800041c8:	757d                	lui	a0,0xfffff
    800041ca:	00a977b3          	and	a5,s2,a0
    800041ce:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041d2:	6609                	lui	a2,0x2
    800041d4:	963e                	add	a2,a2,a5
    800041d6:	85be                	mv	a1,a5
    800041d8:	855e                	mv	a0,s7
    800041da:	ffffc097          	auipc	ra,0xffffc
    800041de:	72e080e7          	jalr	1838(ra) # 80000908 <uvmalloc>
    800041e2:	8b2a                	mv	s6,a0
  ip = 0;
    800041e4:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041e6:	12050c63          	beqz	a0,8000431e <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041ea:	75f9                	lui	a1,0xffffe
    800041ec:	95aa                	add	a1,a1,a0
    800041ee:	855e                	mv	a0,s7
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	936080e7          	jalr	-1738(ra) # 80000b26 <uvmclear>
  stackbase = sp - PGSIZE;
    800041f8:	7c7d                	lui	s8,0xfffff
    800041fa:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800041fc:	e0043783          	ld	a5,-512(s0)
    80004200:	6388                	ld	a0,0(a5)
    80004202:	c535                	beqz	a0,8000426e <exec+0x216>
    80004204:	e8840993          	addi	s3,s0,-376
    80004208:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    8000420c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000420e:	ffffc097          	auipc	ra,0xffffc
    80004212:	0f2080e7          	jalr	242(ra) # 80000300 <strlen>
    80004216:	2505                	addiw	a0,a0,1
    80004218:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000421c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004220:	13896363          	bltu	s2,s8,80004346 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004224:	e0043d83          	ld	s11,-512(s0)
    80004228:	000dba03          	ld	s4,0(s11)
    8000422c:	8552                	mv	a0,s4
    8000422e:	ffffc097          	auipc	ra,0xffffc
    80004232:	0d2080e7          	jalr	210(ra) # 80000300 <strlen>
    80004236:	0015069b          	addiw	a3,a0,1
    8000423a:	8652                	mv	a2,s4
    8000423c:	85ca                	mv	a1,s2
    8000423e:	855e                	mv	a0,s7
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	918080e7          	jalr	-1768(ra) # 80000b58 <copyout>
    80004248:	10054363          	bltz	a0,8000434e <exec+0x2f6>
    ustack[argc] = sp;
    8000424c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004250:	0485                	addi	s1,s1,1
    80004252:	008d8793          	addi	a5,s11,8
    80004256:	e0f43023          	sd	a5,-512(s0)
    8000425a:	008db503          	ld	a0,8(s11)
    8000425e:	c911                	beqz	a0,80004272 <exec+0x21a>
    if(argc >= MAXARG)
    80004260:	09a1                	addi	s3,s3,8
    80004262:	fb3c96e3          	bne	s9,s3,8000420e <exec+0x1b6>
  sz = sz1;
    80004266:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000426a:	4481                	li	s1,0
    8000426c:	a84d                	j	8000431e <exec+0x2c6>
  sp = sz;
    8000426e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004270:	4481                	li	s1,0
  ustack[argc] = 0;
    80004272:	00349793          	slli	a5,s1,0x3
    80004276:	f9040713          	addi	a4,s0,-112
    8000427a:	97ba                	add	a5,a5,a4
    8000427c:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80004280:	00148693          	addi	a3,s1,1
    80004284:	068e                	slli	a3,a3,0x3
    80004286:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000428a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000428e:	01897663          	bgeu	s2,s8,8000429a <exec+0x242>
  sz = sz1;
    80004292:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004296:	4481                	li	s1,0
    80004298:	a059                	j	8000431e <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000429a:	e8840613          	addi	a2,s0,-376
    8000429e:	85ca                	mv	a1,s2
    800042a0:	855e                	mv	a0,s7
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	8b6080e7          	jalr	-1866(ra) # 80000b58 <copyout>
    800042aa:	0a054663          	bltz	a0,80004356 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042ae:	058ab783          	ld	a5,88(s5)
    800042b2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042b6:	df843783          	ld	a5,-520(s0)
    800042ba:	0007c703          	lbu	a4,0(a5)
    800042be:	cf11                	beqz	a4,800042da <exec+0x282>
    800042c0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042c2:	02f00693          	li	a3,47
    800042c6:	a029                	j	800042d0 <exec+0x278>
  for(last=s=path; *s; s++)
    800042c8:	0785                	addi	a5,a5,1
    800042ca:	fff7c703          	lbu	a4,-1(a5)
    800042ce:	c711                	beqz	a4,800042da <exec+0x282>
    if(*s == '/')
    800042d0:	fed71ce3          	bne	a4,a3,800042c8 <exec+0x270>
      last = s+1;
    800042d4:	def43c23          	sd	a5,-520(s0)
    800042d8:	bfc5                	j	800042c8 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800042da:	4641                	li	a2,16
    800042dc:	df843583          	ld	a1,-520(s0)
    800042e0:	158a8513          	addi	a0,s5,344
    800042e4:	ffffc097          	auipc	ra,0xffffc
    800042e8:	fea080e7          	jalr	-22(ra) # 800002ce <safestrcpy>
  oldpagetable = p->pagetable;
    800042ec:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042f0:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800042f4:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042f8:	058ab783          	ld	a5,88(s5)
    800042fc:	e6043703          	ld	a4,-416(s0)
    80004300:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004302:	058ab783          	ld	a5,88(s5)
    80004306:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000430a:	85ea                	mv	a1,s10
    8000430c:	ffffd097          	auipc	ra,0xffffd
    80004310:	d16080e7          	jalr	-746(ra) # 80001022 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004314:	0004851b          	sext.w	a0,s1
    80004318:	bbe1                	j	800040f0 <exec+0x98>
    8000431a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000431e:	e0843583          	ld	a1,-504(s0)
    80004322:	855e                	mv	a0,s7
    80004324:	ffffd097          	auipc	ra,0xffffd
    80004328:	cfe080e7          	jalr	-770(ra) # 80001022 <proc_freepagetable>
  if(ip){
    8000432c:	da0498e3          	bnez	s1,800040dc <exec+0x84>
  return -1;
    80004330:	557d                	li	a0,-1
    80004332:	bb7d                	j	800040f0 <exec+0x98>
    80004334:	e1243423          	sd	s2,-504(s0)
    80004338:	b7dd                	j	8000431e <exec+0x2c6>
    8000433a:	e1243423          	sd	s2,-504(s0)
    8000433e:	b7c5                	j	8000431e <exec+0x2c6>
    80004340:	e1243423          	sd	s2,-504(s0)
    80004344:	bfe9                	j	8000431e <exec+0x2c6>
  sz = sz1;
    80004346:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000434a:	4481                	li	s1,0
    8000434c:	bfc9                	j	8000431e <exec+0x2c6>
  sz = sz1;
    8000434e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004352:	4481                	li	s1,0
    80004354:	b7e9                	j	8000431e <exec+0x2c6>
  sz = sz1;
    80004356:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000435a:	4481                	li	s1,0
    8000435c:	b7c9                	j	8000431e <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000435e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004362:	2b05                	addiw	s6,s6,1
    80004364:	0389899b          	addiw	s3,s3,56
    80004368:	e8045783          	lhu	a5,-384(s0)
    8000436c:	e2fb5be3          	bge	s6,a5,800041a2 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004370:	2981                	sext.w	s3,s3
    80004372:	03800713          	li	a4,56
    80004376:	86ce                	mv	a3,s3
    80004378:	e1040613          	addi	a2,s0,-496
    8000437c:	4581                	li	a1,0
    8000437e:	8526                	mv	a0,s1
    80004380:	fffff097          	auipc	ra,0xfffff
    80004384:	a56080e7          	jalr	-1450(ra) # 80002dd6 <readi>
    80004388:	03800793          	li	a5,56
    8000438c:	f8f517e3          	bne	a0,a5,8000431a <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004390:	e1042783          	lw	a5,-496(s0)
    80004394:	4705                	li	a4,1
    80004396:	fce796e3          	bne	a5,a4,80004362 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000439a:	e3843603          	ld	a2,-456(s0)
    8000439e:	e3043783          	ld	a5,-464(s0)
    800043a2:	f8f669e3          	bltu	a2,a5,80004334 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043a6:	e2043783          	ld	a5,-480(s0)
    800043aa:	963e                	add	a2,a2,a5
    800043ac:	f8f667e3          	bltu	a2,a5,8000433a <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043b0:	85ca                	mv	a1,s2
    800043b2:	855e                	mv	a0,s7
    800043b4:	ffffc097          	auipc	ra,0xffffc
    800043b8:	554080e7          	jalr	1364(ra) # 80000908 <uvmalloc>
    800043bc:	e0a43423          	sd	a0,-504(s0)
    800043c0:	d141                	beqz	a0,80004340 <exec+0x2e8>
    if(ph.vaddr % PGSIZE != 0)
    800043c2:	e2043d03          	ld	s10,-480(s0)
    800043c6:	df043783          	ld	a5,-528(s0)
    800043ca:	00fd77b3          	and	a5,s10,a5
    800043ce:	fba1                	bnez	a5,8000431e <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043d0:	e1842d83          	lw	s11,-488(s0)
    800043d4:	e3042c03          	lw	s8,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043d8:	f80c03e3          	beqz	s8,8000435e <exec+0x306>
    800043dc:	8a62                	mv	s4,s8
    800043de:	4901                	li	s2,0
    800043e0:	b345                	j	80004180 <exec+0x128>

00000000800043e2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043e2:	7179                	addi	sp,sp,-48
    800043e4:	f406                	sd	ra,40(sp)
    800043e6:	f022                	sd	s0,32(sp)
    800043e8:	ec26                	sd	s1,24(sp)
    800043ea:	e84a                	sd	s2,16(sp)
    800043ec:	1800                	addi	s0,sp,48
    800043ee:	892e                	mv	s2,a1
    800043f0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043f2:	fdc40593          	addi	a1,s0,-36
    800043f6:	ffffe097          	auipc	ra,0xffffe
    800043fa:	bba080e7          	jalr	-1094(ra) # 80001fb0 <argint>
    800043fe:	04054063          	bltz	a0,8000443e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004402:	fdc42703          	lw	a4,-36(s0)
    80004406:	47bd                	li	a5,15
    80004408:	02e7ed63          	bltu	a5,a4,80004442 <argfd+0x60>
    8000440c:	ffffd097          	auipc	ra,0xffffd
    80004410:	ab6080e7          	jalr	-1354(ra) # 80000ec2 <myproc>
    80004414:	fdc42703          	lw	a4,-36(s0)
    80004418:	01a70793          	addi	a5,a4,26
    8000441c:	078e                	slli	a5,a5,0x3
    8000441e:	953e                	add	a0,a0,a5
    80004420:	611c                	ld	a5,0(a0)
    80004422:	c395                	beqz	a5,80004446 <argfd+0x64>
    return -1;
  if(pfd)
    80004424:	00090463          	beqz	s2,8000442c <argfd+0x4a>
    *pfd = fd;
    80004428:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000442c:	4501                	li	a0,0
  if(pf)
    8000442e:	c091                	beqz	s1,80004432 <argfd+0x50>
    *pf = f;
    80004430:	e09c                	sd	a5,0(s1)
}
    80004432:	70a2                	ld	ra,40(sp)
    80004434:	7402                	ld	s0,32(sp)
    80004436:	64e2                	ld	s1,24(sp)
    80004438:	6942                	ld	s2,16(sp)
    8000443a:	6145                	addi	sp,sp,48
    8000443c:	8082                	ret
    return -1;
    8000443e:	557d                	li	a0,-1
    80004440:	bfcd                	j	80004432 <argfd+0x50>
    return -1;
    80004442:	557d                	li	a0,-1
    80004444:	b7fd                	j	80004432 <argfd+0x50>
    80004446:	557d                	li	a0,-1
    80004448:	b7ed                	j	80004432 <argfd+0x50>

000000008000444a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000444a:	1101                	addi	sp,sp,-32
    8000444c:	ec06                	sd	ra,24(sp)
    8000444e:	e822                	sd	s0,16(sp)
    80004450:	e426                	sd	s1,8(sp)
    80004452:	1000                	addi	s0,sp,32
    80004454:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004456:	ffffd097          	auipc	ra,0xffffd
    8000445a:	a6c080e7          	jalr	-1428(ra) # 80000ec2 <myproc>
    8000445e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004460:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd7b50>
    80004464:	4501                	li	a0,0
    80004466:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004468:	6398                	ld	a4,0(a5)
    8000446a:	cb19                	beqz	a4,80004480 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000446c:	2505                	addiw	a0,a0,1
    8000446e:	07a1                	addi	a5,a5,8
    80004470:	fed51ce3          	bne	a0,a3,80004468 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004474:	557d                	li	a0,-1
}
    80004476:	60e2                	ld	ra,24(sp)
    80004478:	6442                	ld	s0,16(sp)
    8000447a:	64a2                	ld	s1,8(sp)
    8000447c:	6105                	addi	sp,sp,32
    8000447e:	8082                	ret
      p->ofile[fd] = f;
    80004480:	01a50793          	addi	a5,a0,26
    80004484:	078e                	slli	a5,a5,0x3
    80004486:	963e                	add	a2,a2,a5
    80004488:	e204                	sd	s1,0(a2)
      return fd;
    8000448a:	b7f5                	j	80004476 <fdalloc+0x2c>

000000008000448c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000448c:	715d                	addi	sp,sp,-80
    8000448e:	e486                	sd	ra,72(sp)
    80004490:	e0a2                	sd	s0,64(sp)
    80004492:	fc26                	sd	s1,56(sp)
    80004494:	f84a                	sd	s2,48(sp)
    80004496:	f44e                	sd	s3,40(sp)
    80004498:	f052                	sd	s4,32(sp)
    8000449a:	ec56                	sd	s5,24(sp)
    8000449c:	0880                	addi	s0,sp,80
    8000449e:	89ae                	mv	s3,a1
    800044a0:	8ab2                	mv	s5,a2
    800044a2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044a4:	fb040593          	addi	a1,s0,-80
    800044a8:	fffff097          	auipc	ra,0xfffff
    800044ac:	e4e080e7          	jalr	-434(ra) # 800032f6 <nameiparent>
    800044b0:	892a                	mv	s2,a0
    800044b2:	12050f63          	beqz	a0,800045f0 <create+0x164>
    return 0;

  ilock(dp);
    800044b6:	ffffe097          	auipc	ra,0xffffe
    800044ba:	66c080e7          	jalr	1644(ra) # 80002b22 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044be:	4601                	li	a2,0
    800044c0:	fb040593          	addi	a1,s0,-80
    800044c4:	854a                	mv	a0,s2
    800044c6:	fffff097          	auipc	ra,0xfffff
    800044ca:	b40080e7          	jalr	-1216(ra) # 80003006 <dirlookup>
    800044ce:	84aa                	mv	s1,a0
    800044d0:	c921                	beqz	a0,80004520 <create+0x94>
    iunlockput(dp);
    800044d2:	854a                	mv	a0,s2
    800044d4:	fffff097          	auipc	ra,0xfffff
    800044d8:	8b0080e7          	jalr	-1872(ra) # 80002d84 <iunlockput>
    ilock(ip);
    800044dc:	8526                	mv	a0,s1
    800044de:	ffffe097          	auipc	ra,0xffffe
    800044e2:	644080e7          	jalr	1604(ra) # 80002b22 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044e6:	2981                	sext.w	s3,s3
    800044e8:	4789                	li	a5,2
    800044ea:	02f99463          	bne	s3,a5,80004512 <create+0x86>
    800044ee:	0444d783          	lhu	a5,68(s1)
    800044f2:	37f9                	addiw	a5,a5,-2
    800044f4:	17c2                	slli	a5,a5,0x30
    800044f6:	93c1                	srli	a5,a5,0x30
    800044f8:	4705                	li	a4,1
    800044fa:	00f76c63          	bltu	a4,a5,80004512 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044fe:	8526                	mv	a0,s1
    80004500:	60a6                	ld	ra,72(sp)
    80004502:	6406                	ld	s0,64(sp)
    80004504:	74e2                	ld	s1,56(sp)
    80004506:	7942                	ld	s2,48(sp)
    80004508:	79a2                	ld	s3,40(sp)
    8000450a:	7a02                	ld	s4,32(sp)
    8000450c:	6ae2                	ld	s5,24(sp)
    8000450e:	6161                	addi	sp,sp,80
    80004510:	8082                	ret
    iunlockput(ip);
    80004512:	8526                	mv	a0,s1
    80004514:	fffff097          	auipc	ra,0xfffff
    80004518:	870080e7          	jalr	-1936(ra) # 80002d84 <iunlockput>
    return 0;
    8000451c:	4481                	li	s1,0
    8000451e:	b7c5                	j	800044fe <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004520:	85ce                	mv	a1,s3
    80004522:	00092503          	lw	a0,0(s2)
    80004526:	ffffe097          	auipc	ra,0xffffe
    8000452a:	464080e7          	jalr	1124(ra) # 8000298a <ialloc>
    8000452e:	84aa                	mv	s1,a0
    80004530:	c529                	beqz	a0,8000457a <create+0xee>
  ilock(ip);
    80004532:	ffffe097          	auipc	ra,0xffffe
    80004536:	5f0080e7          	jalr	1520(ra) # 80002b22 <ilock>
  ip->major = major;
    8000453a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000453e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004542:	4785                	li	a5,1
    80004544:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004548:	8526                	mv	a0,s1
    8000454a:	ffffe097          	auipc	ra,0xffffe
    8000454e:	50e080e7          	jalr	1294(ra) # 80002a58 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004552:	2981                	sext.w	s3,s3
    80004554:	4785                	li	a5,1
    80004556:	02f98a63          	beq	s3,a5,8000458a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000455a:	40d0                	lw	a2,4(s1)
    8000455c:	fb040593          	addi	a1,s0,-80
    80004560:	854a                	mv	a0,s2
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	cb4080e7          	jalr	-844(ra) # 80003216 <dirlink>
    8000456a:	06054b63          	bltz	a0,800045e0 <create+0x154>
  iunlockput(dp);
    8000456e:	854a                	mv	a0,s2
    80004570:	fffff097          	auipc	ra,0xfffff
    80004574:	814080e7          	jalr	-2028(ra) # 80002d84 <iunlockput>
  return ip;
    80004578:	b759                	j	800044fe <create+0x72>
    panic("create: ialloc");
    8000457a:	00005517          	auipc	a0,0x5
    8000457e:	11650513          	addi	a0,a0,278 # 80009690 <syscalls+0x2e0>
    80004582:	00002097          	auipc	ra,0x2
    80004586:	68c080e7          	jalr	1676(ra) # 80006c0e <panic>
    dp->nlink++;  // for ".."
    8000458a:	04a95783          	lhu	a5,74(s2)
    8000458e:	2785                	addiw	a5,a5,1
    80004590:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004594:	854a                	mv	a0,s2
    80004596:	ffffe097          	auipc	ra,0xffffe
    8000459a:	4c2080e7          	jalr	1218(ra) # 80002a58 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000459e:	40d0                	lw	a2,4(s1)
    800045a0:	00005597          	auipc	a1,0x5
    800045a4:	10058593          	addi	a1,a1,256 # 800096a0 <syscalls+0x2f0>
    800045a8:	8526                	mv	a0,s1
    800045aa:	fffff097          	auipc	ra,0xfffff
    800045ae:	c6c080e7          	jalr	-916(ra) # 80003216 <dirlink>
    800045b2:	00054f63          	bltz	a0,800045d0 <create+0x144>
    800045b6:	00492603          	lw	a2,4(s2)
    800045ba:	00005597          	auipc	a1,0x5
    800045be:	0ee58593          	addi	a1,a1,238 # 800096a8 <syscalls+0x2f8>
    800045c2:	8526                	mv	a0,s1
    800045c4:	fffff097          	auipc	ra,0xfffff
    800045c8:	c52080e7          	jalr	-942(ra) # 80003216 <dirlink>
    800045cc:	f80557e3          	bgez	a0,8000455a <create+0xce>
      panic("create dots");
    800045d0:	00005517          	auipc	a0,0x5
    800045d4:	0e050513          	addi	a0,a0,224 # 800096b0 <syscalls+0x300>
    800045d8:	00002097          	auipc	ra,0x2
    800045dc:	636080e7          	jalr	1590(ra) # 80006c0e <panic>
    panic("create: dirlink");
    800045e0:	00005517          	auipc	a0,0x5
    800045e4:	0e050513          	addi	a0,a0,224 # 800096c0 <syscalls+0x310>
    800045e8:	00002097          	auipc	ra,0x2
    800045ec:	626080e7          	jalr	1574(ra) # 80006c0e <panic>
    return 0;
    800045f0:	84aa                	mv	s1,a0
    800045f2:	b731                	j	800044fe <create+0x72>

00000000800045f4 <sys_dup>:
{
    800045f4:	7179                	addi	sp,sp,-48
    800045f6:	f406                	sd	ra,40(sp)
    800045f8:	f022                	sd	s0,32(sp)
    800045fa:	ec26                	sd	s1,24(sp)
    800045fc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045fe:	fd840613          	addi	a2,s0,-40
    80004602:	4581                	li	a1,0
    80004604:	4501                	li	a0,0
    80004606:	00000097          	auipc	ra,0x0
    8000460a:	ddc080e7          	jalr	-548(ra) # 800043e2 <argfd>
    return -1;
    8000460e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004610:	02054363          	bltz	a0,80004636 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004614:	fd843503          	ld	a0,-40(s0)
    80004618:	00000097          	auipc	ra,0x0
    8000461c:	e32080e7          	jalr	-462(ra) # 8000444a <fdalloc>
    80004620:	84aa                	mv	s1,a0
    return -1;
    80004622:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004624:	00054963          	bltz	a0,80004636 <sys_dup+0x42>
  filedup(f);
    80004628:	fd843503          	ld	a0,-40(s0)
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	34a080e7          	jalr	842(ra) # 80003976 <filedup>
  return fd;
    80004634:	87a6                	mv	a5,s1
}
    80004636:	853e                	mv	a0,a5
    80004638:	70a2                	ld	ra,40(sp)
    8000463a:	7402                	ld	s0,32(sp)
    8000463c:	64e2                	ld	s1,24(sp)
    8000463e:	6145                	addi	sp,sp,48
    80004640:	8082                	ret

0000000080004642 <sys_read>:
{
    80004642:	7179                	addi	sp,sp,-48
    80004644:	f406                	sd	ra,40(sp)
    80004646:	f022                	sd	s0,32(sp)
    80004648:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000464a:	fe840613          	addi	a2,s0,-24
    8000464e:	4581                	li	a1,0
    80004650:	4501                	li	a0,0
    80004652:	00000097          	auipc	ra,0x0
    80004656:	d90080e7          	jalr	-624(ra) # 800043e2 <argfd>
    return -1;
    8000465a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000465c:	04054163          	bltz	a0,8000469e <sys_read+0x5c>
    80004660:	fe440593          	addi	a1,s0,-28
    80004664:	4509                	li	a0,2
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	94a080e7          	jalr	-1718(ra) # 80001fb0 <argint>
    return -1;
    8000466e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004670:	02054763          	bltz	a0,8000469e <sys_read+0x5c>
    80004674:	fd840593          	addi	a1,s0,-40
    80004678:	4505                	li	a0,1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	958080e7          	jalr	-1704(ra) # 80001fd2 <argaddr>
    return -1;
    80004682:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004684:	00054d63          	bltz	a0,8000469e <sys_read+0x5c>
  return fileread(f, p, n);
    80004688:	fe442603          	lw	a2,-28(s0)
    8000468c:	fd843583          	ld	a1,-40(s0)
    80004690:	fe843503          	ld	a0,-24(s0)
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	48a080e7          	jalr	1162(ra) # 80003b1e <fileread>
    8000469c:	87aa                	mv	a5,a0
}
    8000469e:	853e                	mv	a0,a5
    800046a0:	70a2                	ld	ra,40(sp)
    800046a2:	7402                	ld	s0,32(sp)
    800046a4:	6145                	addi	sp,sp,48
    800046a6:	8082                	ret

00000000800046a8 <sys_write>:
{
    800046a8:	7179                	addi	sp,sp,-48
    800046aa:	f406                	sd	ra,40(sp)
    800046ac:	f022                	sd	s0,32(sp)
    800046ae:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b0:	fe840613          	addi	a2,s0,-24
    800046b4:	4581                	li	a1,0
    800046b6:	4501                	li	a0,0
    800046b8:	00000097          	auipc	ra,0x0
    800046bc:	d2a080e7          	jalr	-726(ra) # 800043e2 <argfd>
    return -1;
    800046c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c2:	04054163          	bltz	a0,80004704 <sys_write+0x5c>
    800046c6:	fe440593          	addi	a1,s0,-28
    800046ca:	4509                	li	a0,2
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	8e4080e7          	jalr	-1820(ra) # 80001fb0 <argint>
    return -1;
    800046d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d6:	02054763          	bltz	a0,80004704 <sys_write+0x5c>
    800046da:	fd840593          	addi	a1,s0,-40
    800046de:	4505                	li	a0,1
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	8f2080e7          	jalr	-1806(ra) # 80001fd2 <argaddr>
    return -1;
    800046e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ea:	00054d63          	bltz	a0,80004704 <sys_write+0x5c>
  return filewrite(f, p, n);
    800046ee:	fe442603          	lw	a2,-28(s0)
    800046f2:	fd843583          	ld	a1,-40(s0)
    800046f6:	fe843503          	ld	a0,-24(s0)
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	4fa080e7          	jalr	1274(ra) # 80003bf4 <filewrite>
    80004702:	87aa                	mv	a5,a0
}
    80004704:	853e                	mv	a0,a5
    80004706:	70a2                	ld	ra,40(sp)
    80004708:	7402                	ld	s0,32(sp)
    8000470a:	6145                	addi	sp,sp,48
    8000470c:	8082                	ret

000000008000470e <sys_close>:
{
    8000470e:	1101                	addi	sp,sp,-32
    80004710:	ec06                	sd	ra,24(sp)
    80004712:	e822                	sd	s0,16(sp)
    80004714:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004716:	fe040613          	addi	a2,s0,-32
    8000471a:	fec40593          	addi	a1,s0,-20
    8000471e:	4501                	li	a0,0
    80004720:	00000097          	auipc	ra,0x0
    80004724:	cc2080e7          	jalr	-830(ra) # 800043e2 <argfd>
    return -1;
    80004728:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000472a:	02054463          	bltz	a0,80004752 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000472e:	ffffc097          	auipc	ra,0xffffc
    80004732:	794080e7          	jalr	1940(ra) # 80000ec2 <myproc>
    80004736:	fec42783          	lw	a5,-20(s0)
    8000473a:	07e9                	addi	a5,a5,26
    8000473c:	078e                	slli	a5,a5,0x3
    8000473e:	97aa                	add	a5,a5,a0
    80004740:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004744:	fe043503          	ld	a0,-32(s0)
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	280080e7          	jalr	640(ra) # 800039c8 <fileclose>
  return 0;
    80004750:	4781                	li	a5,0
}
    80004752:	853e                	mv	a0,a5
    80004754:	60e2                	ld	ra,24(sp)
    80004756:	6442                	ld	s0,16(sp)
    80004758:	6105                	addi	sp,sp,32
    8000475a:	8082                	ret

000000008000475c <sys_fstat>:
{
    8000475c:	1101                	addi	sp,sp,-32
    8000475e:	ec06                	sd	ra,24(sp)
    80004760:	e822                	sd	s0,16(sp)
    80004762:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004764:	fe840613          	addi	a2,s0,-24
    80004768:	4581                	li	a1,0
    8000476a:	4501                	li	a0,0
    8000476c:	00000097          	auipc	ra,0x0
    80004770:	c76080e7          	jalr	-906(ra) # 800043e2 <argfd>
    return -1;
    80004774:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004776:	02054563          	bltz	a0,800047a0 <sys_fstat+0x44>
    8000477a:	fe040593          	addi	a1,s0,-32
    8000477e:	4505                	li	a0,1
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	852080e7          	jalr	-1966(ra) # 80001fd2 <argaddr>
    return -1;
    80004788:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000478a:	00054b63          	bltz	a0,800047a0 <sys_fstat+0x44>
  return filestat(f, st);
    8000478e:	fe043583          	ld	a1,-32(s0)
    80004792:	fe843503          	ld	a0,-24(s0)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	316080e7          	jalr	790(ra) # 80003aac <filestat>
    8000479e:	87aa                	mv	a5,a0
}
    800047a0:	853e                	mv	a0,a5
    800047a2:	60e2                	ld	ra,24(sp)
    800047a4:	6442                	ld	s0,16(sp)
    800047a6:	6105                	addi	sp,sp,32
    800047a8:	8082                	ret

00000000800047aa <sys_link>:
{
    800047aa:	7169                	addi	sp,sp,-304
    800047ac:	f606                	sd	ra,296(sp)
    800047ae:	f222                	sd	s0,288(sp)
    800047b0:	ee26                	sd	s1,280(sp)
    800047b2:	ea4a                	sd	s2,272(sp)
    800047b4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047b6:	08000613          	li	a2,128
    800047ba:	ed040593          	addi	a1,s0,-304
    800047be:	4501                	li	a0,0
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	834080e7          	jalr	-1996(ra) # 80001ff4 <argstr>
    return -1;
    800047c8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ca:	10054e63          	bltz	a0,800048e6 <sys_link+0x13c>
    800047ce:	08000613          	li	a2,128
    800047d2:	f5040593          	addi	a1,s0,-176
    800047d6:	4505                	li	a0,1
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	81c080e7          	jalr	-2020(ra) # 80001ff4 <argstr>
    return -1;
    800047e0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047e2:	10054263          	bltz	a0,800048e6 <sys_link+0x13c>
  begin_op();
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	d0e080e7          	jalr	-754(ra) # 800034f4 <begin_op>
  if((ip = namei(old)) == 0){
    800047ee:	ed040513          	addi	a0,s0,-304
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	ae6080e7          	jalr	-1306(ra) # 800032d8 <namei>
    800047fa:	84aa                	mv	s1,a0
    800047fc:	c551                	beqz	a0,80004888 <sys_link+0xde>
  ilock(ip);
    800047fe:	ffffe097          	auipc	ra,0xffffe
    80004802:	324080e7          	jalr	804(ra) # 80002b22 <ilock>
  if(ip->type == T_DIR){
    80004806:	04449703          	lh	a4,68(s1)
    8000480a:	4785                	li	a5,1
    8000480c:	08f70463          	beq	a4,a5,80004894 <sys_link+0xea>
  ip->nlink++;
    80004810:	04a4d783          	lhu	a5,74(s1)
    80004814:	2785                	addiw	a5,a5,1
    80004816:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000481a:	8526                	mv	a0,s1
    8000481c:	ffffe097          	auipc	ra,0xffffe
    80004820:	23c080e7          	jalr	572(ra) # 80002a58 <iupdate>
  iunlock(ip);
    80004824:	8526                	mv	a0,s1
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	3be080e7          	jalr	958(ra) # 80002be4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000482e:	fd040593          	addi	a1,s0,-48
    80004832:	f5040513          	addi	a0,s0,-176
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	ac0080e7          	jalr	-1344(ra) # 800032f6 <nameiparent>
    8000483e:	892a                	mv	s2,a0
    80004840:	c935                	beqz	a0,800048b4 <sys_link+0x10a>
  ilock(dp);
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	2e0080e7          	jalr	736(ra) # 80002b22 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000484a:	00092703          	lw	a4,0(s2)
    8000484e:	409c                	lw	a5,0(s1)
    80004850:	04f71d63          	bne	a4,a5,800048aa <sys_link+0x100>
    80004854:	40d0                	lw	a2,4(s1)
    80004856:	fd040593          	addi	a1,s0,-48
    8000485a:	854a                	mv	a0,s2
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	9ba080e7          	jalr	-1606(ra) # 80003216 <dirlink>
    80004864:	04054363          	bltz	a0,800048aa <sys_link+0x100>
  iunlockput(dp);
    80004868:	854a                	mv	a0,s2
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	51a080e7          	jalr	1306(ra) # 80002d84 <iunlockput>
  iput(ip);
    80004872:	8526                	mv	a0,s1
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	468080e7          	jalr	1128(ra) # 80002cdc <iput>
  end_op();
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	cf8080e7          	jalr	-776(ra) # 80003574 <end_op>
  return 0;
    80004884:	4781                	li	a5,0
    80004886:	a085                	j	800048e6 <sys_link+0x13c>
    end_op();
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	cec080e7          	jalr	-788(ra) # 80003574 <end_op>
    return -1;
    80004890:	57fd                	li	a5,-1
    80004892:	a891                	j	800048e6 <sys_link+0x13c>
    iunlockput(ip);
    80004894:	8526                	mv	a0,s1
    80004896:	ffffe097          	auipc	ra,0xffffe
    8000489a:	4ee080e7          	jalr	1262(ra) # 80002d84 <iunlockput>
    end_op();
    8000489e:	fffff097          	auipc	ra,0xfffff
    800048a2:	cd6080e7          	jalr	-810(ra) # 80003574 <end_op>
    return -1;
    800048a6:	57fd                	li	a5,-1
    800048a8:	a83d                	j	800048e6 <sys_link+0x13c>
    iunlockput(dp);
    800048aa:	854a                	mv	a0,s2
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	4d8080e7          	jalr	1240(ra) # 80002d84 <iunlockput>
  ilock(ip);
    800048b4:	8526                	mv	a0,s1
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	26c080e7          	jalr	620(ra) # 80002b22 <ilock>
  ip->nlink--;
    800048be:	04a4d783          	lhu	a5,74(s1)
    800048c2:	37fd                	addiw	a5,a5,-1
    800048c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c8:	8526                	mv	a0,s1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	18e080e7          	jalr	398(ra) # 80002a58 <iupdate>
  iunlockput(ip);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	4b0080e7          	jalr	1200(ra) # 80002d84 <iunlockput>
  end_op();
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	c98080e7          	jalr	-872(ra) # 80003574 <end_op>
  return -1;
    800048e4:	57fd                	li	a5,-1
}
    800048e6:	853e                	mv	a0,a5
    800048e8:	70b2                	ld	ra,296(sp)
    800048ea:	7412                	ld	s0,288(sp)
    800048ec:	64f2                	ld	s1,280(sp)
    800048ee:	6952                	ld	s2,272(sp)
    800048f0:	6155                	addi	sp,sp,304
    800048f2:	8082                	ret

00000000800048f4 <sys_unlink>:
{
    800048f4:	7151                	addi	sp,sp,-240
    800048f6:	f586                	sd	ra,232(sp)
    800048f8:	f1a2                	sd	s0,224(sp)
    800048fa:	eda6                	sd	s1,216(sp)
    800048fc:	e9ca                	sd	s2,208(sp)
    800048fe:	e5ce                	sd	s3,200(sp)
    80004900:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004902:	08000613          	li	a2,128
    80004906:	f3040593          	addi	a1,s0,-208
    8000490a:	4501                	li	a0,0
    8000490c:	ffffd097          	auipc	ra,0xffffd
    80004910:	6e8080e7          	jalr	1768(ra) # 80001ff4 <argstr>
    80004914:	18054163          	bltz	a0,80004a96 <sys_unlink+0x1a2>
  begin_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	bdc080e7          	jalr	-1060(ra) # 800034f4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004920:	fb040593          	addi	a1,s0,-80
    80004924:	f3040513          	addi	a0,s0,-208
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	9ce080e7          	jalr	-1586(ra) # 800032f6 <nameiparent>
    80004930:	84aa                	mv	s1,a0
    80004932:	c979                	beqz	a0,80004a08 <sys_unlink+0x114>
  ilock(dp);
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	1ee080e7          	jalr	494(ra) # 80002b22 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000493c:	00005597          	auipc	a1,0x5
    80004940:	d6458593          	addi	a1,a1,-668 # 800096a0 <syscalls+0x2f0>
    80004944:	fb040513          	addi	a0,s0,-80
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	6a4080e7          	jalr	1700(ra) # 80002fec <namecmp>
    80004950:	14050a63          	beqz	a0,80004aa4 <sys_unlink+0x1b0>
    80004954:	00005597          	auipc	a1,0x5
    80004958:	d5458593          	addi	a1,a1,-684 # 800096a8 <syscalls+0x2f8>
    8000495c:	fb040513          	addi	a0,s0,-80
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	68c080e7          	jalr	1676(ra) # 80002fec <namecmp>
    80004968:	12050e63          	beqz	a0,80004aa4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000496c:	f2c40613          	addi	a2,s0,-212
    80004970:	fb040593          	addi	a1,s0,-80
    80004974:	8526                	mv	a0,s1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	690080e7          	jalr	1680(ra) # 80003006 <dirlookup>
    8000497e:	892a                	mv	s2,a0
    80004980:	12050263          	beqz	a0,80004aa4 <sys_unlink+0x1b0>
  ilock(ip);
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	19e080e7          	jalr	414(ra) # 80002b22 <ilock>
  if(ip->nlink < 1)
    8000498c:	04a91783          	lh	a5,74(s2)
    80004990:	08f05263          	blez	a5,80004a14 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004994:	04491703          	lh	a4,68(s2)
    80004998:	4785                	li	a5,1
    8000499a:	08f70563          	beq	a4,a5,80004a24 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000499e:	4641                	li	a2,16
    800049a0:	4581                	li	a1,0
    800049a2:	fc040513          	addi	a0,s0,-64
    800049a6:	ffffb097          	auipc	ra,0xffffb
    800049aa:	7d2080e7          	jalr	2002(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049ae:	4741                	li	a4,16
    800049b0:	f2c42683          	lw	a3,-212(s0)
    800049b4:	fc040613          	addi	a2,s0,-64
    800049b8:	4581                	li	a1,0
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	512080e7          	jalr	1298(ra) # 80002ece <writei>
    800049c4:	47c1                	li	a5,16
    800049c6:	0af51563          	bne	a0,a5,80004a70 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049ca:	04491703          	lh	a4,68(s2)
    800049ce:	4785                	li	a5,1
    800049d0:	0af70863          	beq	a4,a5,80004a80 <sys_unlink+0x18c>
  iunlockput(dp);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	3ae080e7          	jalr	942(ra) # 80002d84 <iunlockput>
  ip->nlink--;
    800049de:	04a95783          	lhu	a5,74(s2)
    800049e2:	37fd                	addiw	a5,a5,-1
    800049e4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049e8:	854a                	mv	a0,s2
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	06e080e7          	jalr	110(ra) # 80002a58 <iupdate>
  iunlockput(ip);
    800049f2:	854a                	mv	a0,s2
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	390080e7          	jalr	912(ra) # 80002d84 <iunlockput>
  end_op();
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	b78080e7          	jalr	-1160(ra) # 80003574 <end_op>
  return 0;
    80004a04:	4501                	li	a0,0
    80004a06:	a84d                	j	80004ab8 <sys_unlink+0x1c4>
    end_op();
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	b6c080e7          	jalr	-1172(ra) # 80003574 <end_op>
    return -1;
    80004a10:	557d                	li	a0,-1
    80004a12:	a05d                	j	80004ab8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a14:	00005517          	auipc	a0,0x5
    80004a18:	cbc50513          	addi	a0,a0,-836 # 800096d0 <syscalls+0x320>
    80004a1c:	00002097          	auipc	ra,0x2
    80004a20:	1f2080e7          	jalr	498(ra) # 80006c0e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a24:	04c92703          	lw	a4,76(s2)
    80004a28:	02000793          	li	a5,32
    80004a2c:	f6e7f9e3          	bgeu	a5,a4,8000499e <sys_unlink+0xaa>
    80004a30:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a34:	4741                	li	a4,16
    80004a36:	86ce                	mv	a3,s3
    80004a38:	f1840613          	addi	a2,s0,-232
    80004a3c:	4581                	li	a1,0
    80004a3e:	854a                	mv	a0,s2
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	396080e7          	jalr	918(ra) # 80002dd6 <readi>
    80004a48:	47c1                	li	a5,16
    80004a4a:	00f51b63          	bne	a0,a5,80004a60 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a4e:	f1845783          	lhu	a5,-232(s0)
    80004a52:	e7a1                	bnez	a5,80004a9a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a54:	29c1                	addiw	s3,s3,16
    80004a56:	04c92783          	lw	a5,76(s2)
    80004a5a:	fcf9ede3          	bltu	s3,a5,80004a34 <sys_unlink+0x140>
    80004a5e:	b781                	j	8000499e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a60:	00005517          	auipc	a0,0x5
    80004a64:	c8850513          	addi	a0,a0,-888 # 800096e8 <syscalls+0x338>
    80004a68:	00002097          	auipc	ra,0x2
    80004a6c:	1a6080e7          	jalr	422(ra) # 80006c0e <panic>
    panic("unlink: writei");
    80004a70:	00005517          	auipc	a0,0x5
    80004a74:	c9050513          	addi	a0,a0,-880 # 80009700 <syscalls+0x350>
    80004a78:	00002097          	auipc	ra,0x2
    80004a7c:	196080e7          	jalr	406(ra) # 80006c0e <panic>
    dp->nlink--;
    80004a80:	04a4d783          	lhu	a5,74(s1)
    80004a84:	37fd                	addiw	a5,a5,-1
    80004a86:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	fcc080e7          	jalr	-52(ra) # 80002a58 <iupdate>
    80004a94:	b781                	j	800049d4 <sys_unlink+0xe0>
    return -1;
    80004a96:	557d                	li	a0,-1
    80004a98:	a005                	j	80004ab8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a9a:	854a                	mv	a0,s2
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	2e8080e7          	jalr	744(ra) # 80002d84 <iunlockput>
  iunlockput(dp);
    80004aa4:	8526                	mv	a0,s1
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	2de080e7          	jalr	734(ra) # 80002d84 <iunlockput>
  end_op();
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	ac6080e7          	jalr	-1338(ra) # 80003574 <end_op>
  return -1;
    80004ab6:	557d                	li	a0,-1
}
    80004ab8:	70ae                	ld	ra,232(sp)
    80004aba:	740e                	ld	s0,224(sp)
    80004abc:	64ee                	ld	s1,216(sp)
    80004abe:	694e                	ld	s2,208(sp)
    80004ac0:	69ae                	ld	s3,200(sp)
    80004ac2:	616d                	addi	sp,sp,240
    80004ac4:	8082                	ret

0000000080004ac6 <sys_open>:

uint64
sys_open(void)
{
    80004ac6:	7131                	addi	sp,sp,-192
    80004ac8:	fd06                	sd	ra,184(sp)
    80004aca:	f922                	sd	s0,176(sp)
    80004acc:	f526                	sd	s1,168(sp)
    80004ace:	f14a                	sd	s2,160(sp)
    80004ad0:	ed4e                	sd	s3,152(sp)
    80004ad2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ad4:	08000613          	li	a2,128
    80004ad8:	f5040593          	addi	a1,s0,-176
    80004adc:	4501                	li	a0,0
    80004ade:	ffffd097          	auipc	ra,0xffffd
    80004ae2:	516080e7          	jalr	1302(ra) # 80001ff4 <argstr>
    return -1;
    80004ae6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ae8:	0c054163          	bltz	a0,80004baa <sys_open+0xe4>
    80004aec:	f4c40593          	addi	a1,s0,-180
    80004af0:	4505                	li	a0,1
    80004af2:	ffffd097          	auipc	ra,0xffffd
    80004af6:	4be080e7          	jalr	1214(ra) # 80001fb0 <argint>
    80004afa:	0a054863          	bltz	a0,80004baa <sys_open+0xe4>

  begin_op();
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	9f6080e7          	jalr	-1546(ra) # 800034f4 <begin_op>

  if(omode & O_CREATE){
    80004b06:	f4c42783          	lw	a5,-180(s0)
    80004b0a:	2007f793          	andi	a5,a5,512
    80004b0e:	cbdd                	beqz	a5,80004bc4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b10:	4681                	li	a3,0
    80004b12:	4601                	li	a2,0
    80004b14:	4589                	li	a1,2
    80004b16:	f5040513          	addi	a0,s0,-176
    80004b1a:	00000097          	auipc	ra,0x0
    80004b1e:	972080e7          	jalr	-1678(ra) # 8000448c <create>
    80004b22:	892a                	mv	s2,a0
    if(ip == 0){
    80004b24:	c959                	beqz	a0,80004bba <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b26:	04491703          	lh	a4,68(s2)
    80004b2a:	478d                	li	a5,3
    80004b2c:	00f71763          	bne	a4,a5,80004b3a <sys_open+0x74>
    80004b30:	04695703          	lhu	a4,70(s2)
    80004b34:	47a5                	li	a5,9
    80004b36:	0ce7ec63          	bltu	a5,a4,80004c0e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	dd2080e7          	jalr	-558(ra) # 8000390c <filealloc>
    80004b42:	89aa                	mv	s3,a0
    80004b44:	10050263          	beqz	a0,80004c48 <sys_open+0x182>
    80004b48:	00000097          	auipc	ra,0x0
    80004b4c:	902080e7          	jalr	-1790(ra) # 8000444a <fdalloc>
    80004b50:	84aa                	mv	s1,a0
    80004b52:	0e054663          	bltz	a0,80004c3e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b56:	04491703          	lh	a4,68(s2)
    80004b5a:	478d                	li	a5,3
    80004b5c:	0cf70463          	beq	a4,a5,80004c24 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b60:	4789                	li	a5,2
    80004b62:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b66:	0209a423          	sw	zero,40(s3)
  }
  f->ip = ip;
    80004b6a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b6e:	f4c42783          	lw	a5,-180(s0)
    80004b72:	0017c713          	xori	a4,a5,1
    80004b76:	8b05                	andi	a4,a4,1
    80004b78:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b7c:	0037f713          	andi	a4,a5,3
    80004b80:	00e03733          	snez	a4,a4
    80004b84:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b88:	4007f793          	andi	a5,a5,1024
    80004b8c:	c791                	beqz	a5,80004b98 <sys_open+0xd2>
    80004b8e:	04491703          	lh	a4,68(s2)
    80004b92:	4789                	li	a5,2
    80004b94:	08f70f63          	beq	a4,a5,80004c32 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b98:	854a                	mv	a0,s2
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	04a080e7          	jalr	74(ra) # 80002be4 <iunlock>
  end_op();
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	9d2080e7          	jalr	-1582(ra) # 80003574 <end_op>

  return fd;
}
    80004baa:	8526                	mv	a0,s1
    80004bac:	70ea                	ld	ra,184(sp)
    80004bae:	744a                	ld	s0,176(sp)
    80004bb0:	74aa                	ld	s1,168(sp)
    80004bb2:	790a                	ld	s2,160(sp)
    80004bb4:	69ea                	ld	s3,152(sp)
    80004bb6:	6129                	addi	sp,sp,192
    80004bb8:	8082                	ret
      end_op();
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	9ba080e7          	jalr	-1606(ra) # 80003574 <end_op>
      return -1;
    80004bc2:	b7e5                	j	80004baa <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bc4:	f5040513          	addi	a0,s0,-176
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	710080e7          	jalr	1808(ra) # 800032d8 <namei>
    80004bd0:	892a                	mv	s2,a0
    80004bd2:	c905                	beqz	a0,80004c02 <sys_open+0x13c>
    ilock(ip);
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	f4e080e7          	jalr	-178(ra) # 80002b22 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bdc:	04491703          	lh	a4,68(s2)
    80004be0:	4785                	li	a5,1
    80004be2:	f4f712e3          	bne	a4,a5,80004b26 <sys_open+0x60>
    80004be6:	f4c42783          	lw	a5,-180(s0)
    80004bea:	dba1                	beqz	a5,80004b3a <sys_open+0x74>
      iunlockput(ip);
    80004bec:	854a                	mv	a0,s2
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	196080e7          	jalr	406(ra) # 80002d84 <iunlockput>
      end_op();
    80004bf6:	fffff097          	auipc	ra,0xfffff
    80004bfa:	97e080e7          	jalr	-1666(ra) # 80003574 <end_op>
      return -1;
    80004bfe:	54fd                	li	s1,-1
    80004c00:	b76d                	j	80004baa <sys_open+0xe4>
      end_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	972080e7          	jalr	-1678(ra) # 80003574 <end_op>
      return -1;
    80004c0a:	54fd                	li	s1,-1
    80004c0c:	bf79                	j	80004baa <sys_open+0xe4>
    iunlockput(ip);
    80004c0e:	854a                	mv	a0,s2
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	174080e7          	jalr	372(ra) # 80002d84 <iunlockput>
    end_op();
    80004c18:	fffff097          	auipc	ra,0xfffff
    80004c1c:	95c080e7          	jalr	-1700(ra) # 80003574 <end_op>
    return -1;
    80004c20:	54fd                	li	s1,-1
    80004c22:	b761                	j	80004baa <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c24:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c28:	04691783          	lh	a5,70(s2)
    80004c2c:	02f99623          	sh	a5,44(s3)
    80004c30:	bf2d                	j	80004b6a <sys_open+0xa4>
    itrunc(ip);
    80004c32:	854a                	mv	a0,s2
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	ffc080e7          	jalr	-4(ra) # 80002c30 <itrunc>
    80004c3c:	bfb1                	j	80004b98 <sys_open+0xd2>
      fileclose(f);
    80004c3e:	854e                	mv	a0,s3
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	d88080e7          	jalr	-632(ra) # 800039c8 <fileclose>
    iunlockput(ip);
    80004c48:	854a                	mv	a0,s2
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	13a080e7          	jalr	314(ra) # 80002d84 <iunlockput>
    end_op();
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	922080e7          	jalr	-1758(ra) # 80003574 <end_op>
    return -1;
    80004c5a:	54fd                	li	s1,-1
    80004c5c:	b7b9                	j	80004baa <sys_open+0xe4>

0000000080004c5e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c5e:	7175                	addi	sp,sp,-144
    80004c60:	e506                	sd	ra,136(sp)
    80004c62:	e122                	sd	s0,128(sp)
    80004c64:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	88e080e7          	jalr	-1906(ra) # 800034f4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c6e:	08000613          	li	a2,128
    80004c72:	f7040593          	addi	a1,s0,-144
    80004c76:	4501                	li	a0,0
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	37c080e7          	jalr	892(ra) # 80001ff4 <argstr>
    80004c80:	02054963          	bltz	a0,80004cb2 <sys_mkdir+0x54>
    80004c84:	4681                	li	a3,0
    80004c86:	4601                	li	a2,0
    80004c88:	4585                	li	a1,1
    80004c8a:	f7040513          	addi	a0,s0,-144
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	7fe080e7          	jalr	2046(ra) # 8000448c <create>
    80004c96:	cd11                	beqz	a0,80004cb2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	0ec080e7          	jalr	236(ra) # 80002d84 <iunlockput>
  end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	8d4080e7          	jalr	-1836(ra) # 80003574 <end_op>
  return 0;
    80004ca8:	4501                	li	a0,0
}
    80004caa:	60aa                	ld	ra,136(sp)
    80004cac:	640a                	ld	s0,128(sp)
    80004cae:	6149                	addi	sp,sp,144
    80004cb0:	8082                	ret
    end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	8c2080e7          	jalr	-1854(ra) # 80003574 <end_op>
    return -1;
    80004cba:	557d                	li	a0,-1
    80004cbc:	b7fd                	j	80004caa <sys_mkdir+0x4c>

0000000080004cbe <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cbe:	7135                	addi	sp,sp,-160
    80004cc0:	ed06                	sd	ra,152(sp)
    80004cc2:	e922                	sd	s0,144(sp)
    80004cc4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	82e080e7          	jalr	-2002(ra) # 800034f4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cce:	08000613          	li	a2,128
    80004cd2:	f7040593          	addi	a1,s0,-144
    80004cd6:	4501                	li	a0,0
    80004cd8:	ffffd097          	auipc	ra,0xffffd
    80004cdc:	31c080e7          	jalr	796(ra) # 80001ff4 <argstr>
    80004ce0:	04054a63          	bltz	a0,80004d34 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ce4:	f6c40593          	addi	a1,s0,-148
    80004ce8:	4505                	li	a0,1
    80004cea:	ffffd097          	auipc	ra,0xffffd
    80004cee:	2c6080e7          	jalr	710(ra) # 80001fb0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cf2:	04054163          	bltz	a0,80004d34 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004cf6:	f6840593          	addi	a1,s0,-152
    80004cfa:	4509                	li	a0,2
    80004cfc:	ffffd097          	auipc	ra,0xffffd
    80004d00:	2b4080e7          	jalr	692(ra) # 80001fb0 <argint>
     argint(1, &major) < 0 ||
    80004d04:	02054863          	bltz	a0,80004d34 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d08:	f6841683          	lh	a3,-152(s0)
    80004d0c:	f6c41603          	lh	a2,-148(s0)
    80004d10:	458d                	li	a1,3
    80004d12:	f7040513          	addi	a0,s0,-144
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	776080e7          	jalr	1910(ra) # 8000448c <create>
     argint(2, &minor) < 0 ||
    80004d1e:	c919                	beqz	a0,80004d34 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	064080e7          	jalr	100(ra) # 80002d84 <iunlockput>
  end_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	84c080e7          	jalr	-1972(ra) # 80003574 <end_op>
  return 0;
    80004d30:	4501                	li	a0,0
    80004d32:	a031                	j	80004d3e <sys_mknod+0x80>
    end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	840080e7          	jalr	-1984(ra) # 80003574 <end_op>
    return -1;
    80004d3c:	557d                	li	a0,-1
}
    80004d3e:	60ea                	ld	ra,152(sp)
    80004d40:	644a                	ld	s0,144(sp)
    80004d42:	610d                	addi	sp,sp,160
    80004d44:	8082                	ret

0000000080004d46 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d46:	7135                	addi	sp,sp,-160
    80004d48:	ed06                	sd	ra,152(sp)
    80004d4a:	e922                	sd	s0,144(sp)
    80004d4c:	e526                	sd	s1,136(sp)
    80004d4e:	e14a                	sd	s2,128(sp)
    80004d50:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d52:	ffffc097          	auipc	ra,0xffffc
    80004d56:	170080e7          	jalr	368(ra) # 80000ec2 <myproc>
    80004d5a:	892a                	mv	s2,a0
  
  begin_op();
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	798080e7          	jalr	1944(ra) # 800034f4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d64:	08000613          	li	a2,128
    80004d68:	f6040593          	addi	a1,s0,-160
    80004d6c:	4501                	li	a0,0
    80004d6e:	ffffd097          	auipc	ra,0xffffd
    80004d72:	286080e7          	jalr	646(ra) # 80001ff4 <argstr>
    80004d76:	04054b63          	bltz	a0,80004dcc <sys_chdir+0x86>
    80004d7a:	f6040513          	addi	a0,s0,-160
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	55a080e7          	jalr	1370(ra) # 800032d8 <namei>
    80004d86:	84aa                	mv	s1,a0
    80004d88:	c131                	beqz	a0,80004dcc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	d98080e7          	jalr	-616(ra) # 80002b22 <ilock>
  if(ip->type != T_DIR){
    80004d92:	04449703          	lh	a4,68(s1)
    80004d96:	4785                	li	a5,1
    80004d98:	04f71063          	bne	a4,a5,80004dd8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d9c:	8526                	mv	a0,s1
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	e46080e7          	jalr	-442(ra) # 80002be4 <iunlock>
  iput(p->cwd);
    80004da6:	15093503          	ld	a0,336(s2)
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	f32080e7          	jalr	-206(ra) # 80002cdc <iput>
  end_op();
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	7c2080e7          	jalr	1986(ra) # 80003574 <end_op>
  p->cwd = ip;
    80004dba:	14993823          	sd	s1,336(s2)
  return 0;
    80004dbe:	4501                	li	a0,0
}
    80004dc0:	60ea                	ld	ra,152(sp)
    80004dc2:	644a                	ld	s0,144(sp)
    80004dc4:	64aa                	ld	s1,136(sp)
    80004dc6:	690a                	ld	s2,128(sp)
    80004dc8:	610d                	addi	sp,sp,160
    80004dca:	8082                	ret
    end_op();
    80004dcc:	ffffe097          	auipc	ra,0xffffe
    80004dd0:	7a8080e7          	jalr	1960(ra) # 80003574 <end_op>
    return -1;
    80004dd4:	557d                	li	a0,-1
    80004dd6:	b7ed                	j	80004dc0 <sys_chdir+0x7a>
    iunlockput(ip);
    80004dd8:	8526                	mv	a0,s1
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	faa080e7          	jalr	-86(ra) # 80002d84 <iunlockput>
    end_op();
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	792080e7          	jalr	1938(ra) # 80003574 <end_op>
    return -1;
    80004dea:	557d                	li	a0,-1
    80004dec:	bfd1                	j	80004dc0 <sys_chdir+0x7a>

0000000080004dee <sys_exec>:

uint64
sys_exec(void)
{
    80004dee:	7145                	addi	sp,sp,-464
    80004df0:	e786                	sd	ra,456(sp)
    80004df2:	e3a2                	sd	s0,448(sp)
    80004df4:	ff26                	sd	s1,440(sp)
    80004df6:	fb4a                	sd	s2,432(sp)
    80004df8:	f74e                	sd	s3,424(sp)
    80004dfa:	f352                	sd	s4,416(sp)
    80004dfc:	ef56                	sd	s5,408(sp)
    80004dfe:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e00:	08000613          	li	a2,128
    80004e04:	f4040593          	addi	a1,s0,-192
    80004e08:	4501                	li	a0,0
    80004e0a:	ffffd097          	auipc	ra,0xffffd
    80004e0e:	1ea080e7          	jalr	490(ra) # 80001ff4 <argstr>
    return -1;
    80004e12:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e14:	0c054a63          	bltz	a0,80004ee8 <sys_exec+0xfa>
    80004e18:	e3840593          	addi	a1,s0,-456
    80004e1c:	4505                	li	a0,1
    80004e1e:	ffffd097          	auipc	ra,0xffffd
    80004e22:	1b4080e7          	jalr	436(ra) # 80001fd2 <argaddr>
    80004e26:	0c054163          	bltz	a0,80004ee8 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e2a:	10000613          	li	a2,256
    80004e2e:	4581                	li	a1,0
    80004e30:	e4040513          	addi	a0,s0,-448
    80004e34:	ffffb097          	auipc	ra,0xffffb
    80004e38:	344080e7          	jalr	836(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e3c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e40:	89a6                	mv	s3,s1
    80004e42:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e44:	02000a13          	li	s4,32
    80004e48:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e4c:	00391513          	slli	a0,s2,0x3
    80004e50:	e3040593          	addi	a1,s0,-464
    80004e54:	e3843783          	ld	a5,-456(s0)
    80004e58:	953e                	add	a0,a0,a5
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	0bc080e7          	jalr	188(ra) # 80001f16 <fetchaddr>
    80004e62:	02054a63          	bltz	a0,80004e96 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e66:	e3043783          	ld	a5,-464(s0)
    80004e6a:	c3b9                	beqz	a5,80004eb0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e6c:	ffffb097          	auipc	ra,0xffffb
    80004e70:	2ac080e7          	jalr	684(ra) # 80000118 <kalloc>
    80004e74:	85aa                	mv	a1,a0
    80004e76:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e7a:	cd11                	beqz	a0,80004e96 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e7c:	6605                	lui	a2,0x1
    80004e7e:	e3043503          	ld	a0,-464(s0)
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	0e6080e7          	jalr	230(ra) # 80001f68 <fetchstr>
    80004e8a:	00054663          	bltz	a0,80004e96 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e8e:	0905                	addi	s2,s2,1
    80004e90:	09a1                	addi	s3,s3,8
    80004e92:	fb491be3          	bne	s2,s4,80004e48 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e96:	10048913          	addi	s2,s1,256
    80004e9a:	6088                	ld	a0,0(s1)
    80004e9c:	c529                	beqz	a0,80004ee6 <sys_exec+0xf8>
    kfree(argv[i]);
    80004e9e:	ffffb097          	auipc	ra,0xffffb
    80004ea2:	17e080e7          	jalr	382(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ea6:	04a1                	addi	s1,s1,8
    80004ea8:	ff2499e3          	bne	s1,s2,80004e9a <sys_exec+0xac>
  return -1;
    80004eac:	597d                	li	s2,-1
    80004eae:	a82d                	j	80004ee8 <sys_exec+0xfa>
      argv[i] = 0;
    80004eb0:	0a8e                	slli	s5,s5,0x3
    80004eb2:	fc040793          	addi	a5,s0,-64
    80004eb6:	9abe                	add	s5,s5,a5
    80004eb8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ebc:	e4040593          	addi	a1,s0,-448
    80004ec0:	f4040513          	addi	a0,s0,-192
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	194080e7          	jalr	404(ra) # 80004058 <exec>
    80004ecc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ece:	10048993          	addi	s3,s1,256
    80004ed2:	6088                	ld	a0,0(s1)
    80004ed4:	c911                	beqz	a0,80004ee8 <sys_exec+0xfa>
    kfree(argv[i]);
    80004ed6:	ffffb097          	auipc	ra,0xffffb
    80004eda:	146080e7          	jalr	326(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ede:	04a1                	addi	s1,s1,8
    80004ee0:	ff3499e3          	bne	s1,s3,80004ed2 <sys_exec+0xe4>
    80004ee4:	a011                	j	80004ee8 <sys_exec+0xfa>
  return -1;
    80004ee6:	597d                	li	s2,-1
}
    80004ee8:	854a                	mv	a0,s2
    80004eea:	60be                	ld	ra,456(sp)
    80004eec:	641e                	ld	s0,448(sp)
    80004eee:	74fa                	ld	s1,440(sp)
    80004ef0:	795a                	ld	s2,432(sp)
    80004ef2:	79ba                	ld	s3,424(sp)
    80004ef4:	7a1a                	ld	s4,416(sp)
    80004ef6:	6afa                	ld	s5,408(sp)
    80004ef8:	6179                	addi	sp,sp,464
    80004efa:	8082                	ret

0000000080004efc <sys_pipe>:

uint64
sys_pipe(void)
{
    80004efc:	7139                	addi	sp,sp,-64
    80004efe:	fc06                	sd	ra,56(sp)
    80004f00:	f822                	sd	s0,48(sp)
    80004f02:	f426                	sd	s1,40(sp)
    80004f04:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f06:	ffffc097          	auipc	ra,0xffffc
    80004f0a:	fbc080e7          	jalr	-68(ra) # 80000ec2 <myproc>
    80004f0e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f10:	fd840593          	addi	a1,s0,-40
    80004f14:	4501                	li	a0,0
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	0bc080e7          	jalr	188(ra) # 80001fd2 <argaddr>
    return -1;
    80004f1e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f20:	0e054063          	bltz	a0,80005000 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f24:	fc840593          	addi	a1,s0,-56
    80004f28:	fd040513          	addi	a0,s0,-48
    80004f2c:	fffff097          	auipc	ra,0xfffff
    80004f30:	dfc080e7          	jalr	-516(ra) # 80003d28 <pipealloc>
    return -1;
    80004f34:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f36:	0c054563          	bltz	a0,80005000 <sys_pipe+0x104>
  fd0 = -1;
    80004f3a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f3e:	fd043503          	ld	a0,-48(s0)
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	508080e7          	jalr	1288(ra) # 8000444a <fdalloc>
    80004f4a:	fca42223          	sw	a0,-60(s0)
    80004f4e:	08054c63          	bltz	a0,80004fe6 <sys_pipe+0xea>
    80004f52:	fc843503          	ld	a0,-56(s0)
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	4f4080e7          	jalr	1268(ra) # 8000444a <fdalloc>
    80004f5e:	fca42023          	sw	a0,-64(s0)
    80004f62:	06054863          	bltz	a0,80004fd2 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f66:	4691                	li	a3,4
    80004f68:	fc440613          	addi	a2,s0,-60
    80004f6c:	fd843583          	ld	a1,-40(s0)
    80004f70:	68a8                	ld	a0,80(s1)
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	be6080e7          	jalr	-1050(ra) # 80000b58 <copyout>
    80004f7a:	02054063          	bltz	a0,80004f9a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f7e:	4691                	li	a3,4
    80004f80:	fc040613          	addi	a2,s0,-64
    80004f84:	fd843583          	ld	a1,-40(s0)
    80004f88:	0591                	addi	a1,a1,4
    80004f8a:	68a8                	ld	a0,80(s1)
    80004f8c:	ffffc097          	auipc	ra,0xffffc
    80004f90:	bcc080e7          	jalr	-1076(ra) # 80000b58 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f94:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f96:	06055563          	bgez	a0,80005000 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f9a:	fc442783          	lw	a5,-60(s0)
    80004f9e:	07e9                	addi	a5,a5,26
    80004fa0:	078e                	slli	a5,a5,0x3
    80004fa2:	97a6                	add	a5,a5,s1
    80004fa4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fa8:	fc042503          	lw	a0,-64(s0)
    80004fac:	0569                	addi	a0,a0,26
    80004fae:	050e                	slli	a0,a0,0x3
    80004fb0:	9526                	add	a0,a0,s1
    80004fb2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fb6:	fd043503          	ld	a0,-48(s0)
    80004fba:	fffff097          	auipc	ra,0xfffff
    80004fbe:	a0e080e7          	jalr	-1522(ra) # 800039c8 <fileclose>
    fileclose(wf);
    80004fc2:	fc843503          	ld	a0,-56(s0)
    80004fc6:	fffff097          	auipc	ra,0xfffff
    80004fca:	a02080e7          	jalr	-1534(ra) # 800039c8 <fileclose>
    return -1;
    80004fce:	57fd                	li	a5,-1
    80004fd0:	a805                	j	80005000 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004fd2:	fc442783          	lw	a5,-60(s0)
    80004fd6:	0007c863          	bltz	a5,80004fe6 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004fda:	01a78513          	addi	a0,a5,26
    80004fde:	050e                	slli	a0,a0,0x3
    80004fe0:	9526                	add	a0,a0,s1
    80004fe2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fe6:	fd043503          	ld	a0,-48(s0)
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	9de080e7          	jalr	-1570(ra) # 800039c8 <fileclose>
    fileclose(wf);
    80004ff2:	fc843503          	ld	a0,-56(s0)
    80004ff6:	fffff097          	auipc	ra,0xfffff
    80004ffa:	9d2080e7          	jalr	-1582(ra) # 800039c8 <fileclose>
    return -1;
    80004ffe:	57fd                	li	a5,-1
}
    80005000:	853e                	mv	a0,a5
    80005002:	70e2                	ld	ra,56(sp)
    80005004:	7442                	ld	s0,48(sp)
    80005006:	74a2                	ld	s1,40(sp)
    80005008:	6121                	addi	sp,sp,64
    8000500a:	8082                	ret

000000008000500c <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    8000500c:	7179                	addi	sp,sp,-48
    8000500e:	f406                	sd	ra,40(sp)
    80005010:	f022                	sd	s0,32(sp)
    80005012:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  if (argint(0, (int*)&raddr) < 0 ||
    80005014:	fe440593          	addi	a1,s0,-28
    80005018:	4501                	li	a0,0
    8000501a:	ffffd097          	auipc	ra,0xffffd
    8000501e:	f96080e7          	jalr	-106(ra) # 80001fb0 <argint>
    80005022:	06054663          	bltz	a0,8000508e <sys_connect+0x82>
      argint(1, (int*)&lport) < 0 ||
    80005026:	fdc40593          	addi	a1,s0,-36
    8000502a:	4505                	li	a0,1
    8000502c:	ffffd097          	auipc	ra,0xffffd
    80005030:	f84080e7          	jalr	-124(ra) # 80001fb0 <argint>
  if (argint(0, (int*)&raddr) < 0 ||
    80005034:	04054f63          	bltz	a0,80005092 <sys_connect+0x86>
      argint(2, (int*)&rport) < 0) {
    80005038:	fe040593          	addi	a1,s0,-32
    8000503c:	4509                	li	a0,2
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	f72080e7          	jalr	-142(ra) # 80001fb0 <argint>
      argint(1, (int*)&lport) < 0 ||
    80005046:	04054863          	bltz	a0,80005096 <sys_connect+0x8a>
    return -1;
  }

  if(sockalloc(&f, raddr, lport, rport) < 0)
    8000504a:	fe045683          	lhu	a3,-32(s0)
    8000504e:	fdc45603          	lhu	a2,-36(s0)
    80005052:	fe442583          	lw	a1,-28(s0)
    80005056:	fe840513          	addi	a0,s0,-24
    8000505a:	00001097          	auipc	ra,0x1
    8000505e:	1fe080e7          	jalr	510(ra) # 80006258 <sockalloc>
    80005062:	02054c63          	bltz	a0,8000509a <sys_connect+0x8e>
    return -1;
  if((fd=fdalloc(f)) < 0){
    80005066:	fe843503          	ld	a0,-24(s0)
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	3e0080e7          	jalr	992(ra) # 8000444a <fdalloc>
    80005072:	00054663          	bltz	a0,8000507e <sys_connect+0x72>
    fileclose(f);
    return -1;
  }

  return fd;
}
    80005076:	70a2                	ld	ra,40(sp)
    80005078:	7402                	ld	s0,32(sp)
    8000507a:	6145                	addi	sp,sp,48
    8000507c:	8082                	ret
    fileclose(f);
    8000507e:	fe843503          	ld	a0,-24(s0)
    80005082:	fffff097          	auipc	ra,0xfffff
    80005086:	946080e7          	jalr	-1722(ra) # 800039c8 <fileclose>
    return -1;
    8000508a:	557d                	li	a0,-1
    8000508c:	b7ed                	j	80005076 <sys_connect+0x6a>
    return -1;
    8000508e:	557d                	li	a0,-1
    80005090:	b7dd                	j	80005076 <sys_connect+0x6a>
    80005092:	557d                	li	a0,-1
    80005094:	b7cd                	j	80005076 <sys_connect+0x6a>
    80005096:	557d                	li	a0,-1
    80005098:	bff9                	j	80005076 <sys_connect+0x6a>
    return -1;
    8000509a:	557d                	li	a0,-1
    8000509c:	bfe9                	j	80005076 <sys_connect+0x6a>
	...

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	d03fc0ef          	jal	ra,80001de2 <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
    8000516a:	0791                	addi	a5,a5,4
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    8000516c:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    8000516e:	0c000737          	lui	a4,0xc000
    80005172:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    80005176:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    80005178:	0791                	addi	a5,a5,4
    8000517a:	fee79ee3          	bne	a5,a4,80005176 <plicinit+0x1c>
  }
#endif  
}
    8000517e:	6422                	ld	s0,8(sp)
    80005180:	0141                	addi	sp,sp,16
    80005182:	8082                	ret

0000000080005184 <plicinithart>:

void
plicinithart(void)
{
    80005184:	1141                	addi	sp,sp,-16
    80005186:	e406                	sd	ra,8(sp)
    80005188:	e022                	sd	s0,0(sp)
    8000518a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000518c:	ffffc097          	auipc	ra,0xffffc
    80005190:	d0a080e7          	jalr	-758(ra) # 80000e96 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005194:	0085171b          	slliw	a4,a0,0x8
    80005198:	0c0027b7          	lui	a5,0xc002
    8000519c:	97ba                	add	a5,a5,a4
    8000519e:	40200713          	li	a4,1026
    800051a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    800051a6:	577d                	li	a4,-1
    800051a8:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051ac:	00d5151b          	slliw	a0,a0,0xd
    800051b0:	0c2017b7          	lui	a5,0xc201
    800051b4:	953e                	add	a0,a0,a5
    800051b6:	00052023          	sw	zero,0(a0)
}
    800051ba:	60a2                	ld	ra,8(sp)
    800051bc:	6402                	ld	s0,0(sp)
    800051be:	0141                	addi	sp,sp,16
    800051c0:	8082                	ret

00000000800051c2 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051c2:	1141                	addi	sp,sp,-16
    800051c4:	e406                	sd	ra,8(sp)
    800051c6:	e022                	sd	s0,0(sp)
    800051c8:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051ca:	ffffc097          	auipc	ra,0xffffc
    800051ce:	ccc080e7          	jalr	-820(ra) # 80000e96 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051d2:	00d5179b          	slliw	a5,a0,0xd
    800051d6:	0c201537          	lui	a0,0xc201
    800051da:	953e                	add	a0,a0,a5
  return irq;
}
    800051dc:	4148                	lw	a0,4(a0)
    800051de:	60a2                	ld	ra,8(sp)
    800051e0:	6402                	ld	s0,0(sp)
    800051e2:	0141                	addi	sp,sp,16
    800051e4:	8082                	ret

00000000800051e6 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051e6:	1101                	addi	sp,sp,-32
    800051e8:	ec06                	sd	ra,24(sp)
    800051ea:	e822                	sd	s0,16(sp)
    800051ec:	e426                	sd	s1,8(sp)
    800051ee:	1000                	addi	s0,sp,32
    800051f0:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051f2:	ffffc097          	auipc	ra,0xffffc
    800051f6:	ca4080e7          	jalr	-860(ra) # 80000e96 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051fa:	00d5151b          	slliw	a0,a0,0xd
    800051fe:	0c2017b7          	lui	a5,0xc201
    80005202:	97aa                	add	a5,a5,a0
    80005204:	c3c4                	sw	s1,4(a5)
}
    80005206:	60e2                	ld	ra,24(sp)
    80005208:	6442                	ld	s0,16(sp)
    8000520a:	64a2                	ld	s1,8(sp)
    8000520c:	6105                	addi	sp,sp,32
    8000520e:	8082                	ret

0000000080005210 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005210:	1141                	addi	sp,sp,-16
    80005212:	e406                	sd	ra,8(sp)
    80005214:	e022                	sd	s0,0(sp)
    80005216:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005218:	479d                	li	a5,7
    8000521a:	06a7c963          	blt	a5,a0,8000528c <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    8000521e:	00017797          	auipc	a5,0x17
    80005222:	de278793          	addi	a5,a5,-542 # 8001c000 <disk>
    80005226:	00a78733          	add	a4,a5,a0
    8000522a:	6789                	lui	a5,0x2
    8000522c:	97ba                	add	a5,a5,a4
    8000522e:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005232:	e7ad                	bnez	a5,8000529c <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005234:	00451793          	slli	a5,a0,0x4
    80005238:	00019717          	auipc	a4,0x19
    8000523c:	dc870713          	addi	a4,a4,-568 # 8001e000 <disk+0x2000>
    80005240:	6314                	ld	a3,0(a4)
    80005242:	96be                	add	a3,a3,a5
    80005244:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005248:	6314                	ld	a3,0(a4)
    8000524a:	96be                	add	a3,a3,a5
    8000524c:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005250:	6314                	ld	a3,0(a4)
    80005252:	96be                	add	a3,a3,a5
    80005254:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005258:	6318                	ld	a4,0(a4)
    8000525a:	97ba                	add	a5,a5,a4
    8000525c:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005260:	00017797          	auipc	a5,0x17
    80005264:	da078793          	addi	a5,a5,-608 # 8001c000 <disk>
    80005268:	97aa                	add	a5,a5,a0
    8000526a:	6509                	lui	a0,0x2
    8000526c:	953e                	add	a0,a0,a5
    8000526e:	4785                	li	a5,1
    80005270:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005274:	00019517          	auipc	a0,0x19
    80005278:	da450513          	addi	a0,a0,-604 # 8001e018 <disk+0x2018>
    8000527c:	ffffc097          	auipc	ra,0xffffc
    80005280:	5dc080e7          	jalr	1500(ra) # 80001858 <wakeup>
}
    80005284:	60a2                	ld	ra,8(sp)
    80005286:	6402                	ld	s0,0(sp)
    80005288:	0141                	addi	sp,sp,16
    8000528a:	8082                	ret
    panic("free_desc 1");
    8000528c:	00004517          	auipc	a0,0x4
    80005290:	48450513          	addi	a0,a0,1156 # 80009710 <syscalls+0x360>
    80005294:	00002097          	auipc	ra,0x2
    80005298:	97a080e7          	jalr	-1670(ra) # 80006c0e <panic>
    panic("free_desc 2");
    8000529c:	00004517          	auipc	a0,0x4
    800052a0:	48450513          	addi	a0,a0,1156 # 80009720 <syscalls+0x370>
    800052a4:	00002097          	auipc	ra,0x2
    800052a8:	96a080e7          	jalr	-1686(ra) # 80006c0e <panic>

00000000800052ac <virtio_disk_init>:
{
    800052ac:	1101                	addi	sp,sp,-32
    800052ae:	ec06                	sd	ra,24(sp)
    800052b0:	e822                	sd	s0,16(sp)
    800052b2:	e426                	sd	s1,8(sp)
    800052b4:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052b6:	00004597          	auipc	a1,0x4
    800052ba:	47a58593          	addi	a1,a1,1146 # 80009730 <syscalls+0x380>
    800052be:	00019517          	auipc	a0,0x19
    800052c2:	e6a50513          	addi	a0,a0,-406 # 8001e128 <disk+0x2128>
    800052c6:	00002097          	auipc	ra,0x2
    800052ca:	e02080e7          	jalr	-510(ra) # 800070c8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052ce:	100017b7          	lui	a5,0x10001
    800052d2:	4398                	lw	a4,0(a5)
    800052d4:	2701                	sext.w	a4,a4
    800052d6:	747277b7          	lui	a5,0x74727
    800052da:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052de:	0ef71163          	bne	a4,a5,800053c0 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052e2:	100017b7          	lui	a5,0x10001
    800052e6:	43dc                	lw	a5,4(a5)
    800052e8:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052ea:	4705                	li	a4,1
    800052ec:	0ce79a63          	bne	a5,a4,800053c0 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f0:	100017b7          	lui	a5,0x10001
    800052f4:	479c                	lw	a5,8(a5)
    800052f6:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052f8:	4709                	li	a4,2
    800052fa:	0ce79363          	bne	a5,a4,800053c0 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	47d8                	lw	a4,12(a5)
    80005304:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005306:	554d47b7          	lui	a5,0x554d4
    8000530a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000530e:	0af71963          	bne	a4,a5,800053c0 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005312:	100017b7          	lui	a5,0x10001
    80005316:	4705                	li	a4,1
    80005318:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531a:	470d                	li	a4,3
    8000531c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000531e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005320:	c7ffe737          	lui	a4,0xc7ffe
    80005324:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd71df>
    80005328:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000532a:	2701                	sext.w	a4,a4
    8000532c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000532e:	472d                	li	a4,11
    80005330:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005332:	473d                	li	a4,15
    80005334:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005336:	6705                	lui	a4,0x1
    80005338:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000533a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000533e:	5bdc                	lw	a5,52(a5)
    80005340:	2781                	sext.w	a5,a5
  if(max == 0)
    80005342:	c7d9                	beqz	a5,800053d0 <virtio_disk_init+0x124>
  if(max < NUM)
    80005344:	471d                	li	a4,7
    80005346:	08f77d63          	bgeu	a4,a5,800053e0 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000534a:	100014b7          	lui	s1,0x10001
    8000534e:	47a1                	li	a5,8
    80005350:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005352:	6609                	lui	a2,0x2
    80005354:	4581                	li	a1,0
    80005356:	00017517          	auipc	a0,0x17
    8000535a:	caa50513          	addi	a0,a0,-854 # 8001c000 <disk>
    8000535e:	ffffb097          	auipc	ra,0xffffb
    80005362:	e1a080e7          	jalr	-486(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005366:	00017717          	auipc	a4,0x17
    8000536a:	c9a70713          	addi	a4,a4,-870 # 8001c000 <disk>
    8000536e:	00c75793          	srli	a5,a4,0xc
    80005372:	2781                	sext.w	a5,a5
    80005374:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005376:	00019797          	auipc	a5,0x19
    8000537a:	c8a78793          	addi	a5,a5,-886 # 8001e000 <disk+0x2000>
    8000537e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005380:	00017717          	auipc	a4,0x17
    80005384:	d0070713          	addi	a4,a4,-768 # 8001c080 <disk+0x80>
    80005388:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000538a:	00018717          	auipc	a4,0x18
    8000538e:	c7670713          	addi	a4,a4,-906 # 8001d000 <disk+0x1000>
    80005392:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005394:	4705                	li	a4,1
    80005396:	00e78c23          	sb	a4,24(a5)
    8000539a:	00e78ca3          	sb	a4,25(a5)
    8000539e:	00e78d23          	sb	a4,26(a5)
    800053a2:	00e78da3          	sb	a4,27(a5)
    800053a6:	00e78e23          	sb	a4,28(a5)
    800053aa:	00e78ea3          	sb	a4,29(a5)
    800053ae:	00e78f23          	sb	a4,30(a5)
    800053b2:	00e78fa3          	sb	a4,31(a5)
}
    800053b6:	60e2                	ld	ra,24(sp)
    800053b8:	6442                	ld	s0,16(sp)
    800053ba:	64a2                	ld	s1,8(sp)
    800053bc:	6105                	addi	sp,sp,32
    800053be:	8082                	ret
    panic("could not find virtio disk");
    800053c0:	00004517          	auipc	a0,0x4
    800053c4:	38050513          	addi	a0,a0,896 # 80009740 <syscalls+0x390>
    800053c8:	00002097          	auipc	ra,0x2
    800053cc:	846080e7          	jalr	-1978(ra) # 80006c0e <panic>
    panic("virtio disk has no queue 0");
    800053d0:	00004517          	auipc	a0,0x4
    800053d4:	39050513          	addi	a0,a0,912 # 80009760 <syscalls+0x3b0>
    800053d8:	00002097          	auipc	ra,0x2
    800053dc:	836080e7          	jalr	-1994(ra) # 80006c0e <panic>
    panic("virtio disk max queue too short");
    800053e0:	00004517          	auipc	a0,0x4
    800053e4:	3a050513          	addi	a0,a0,928 # 80009780 <syscalls+0x3d0>
    800053e8:	00002097          	auipc	ra,0x2
    800053ec:	826080e7          	jalr	-2010(ra) # 80006c0e <panic>

00000000800053f0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053f0:	7159                	addi	sp,sp,-112
    800053f2:	f486                	sd	ra,104(sp)
    800053f4:	f0a2                	sd	s0,96(sp)
    800053f6:	eca6                	sd	s1,88(sp)
    800053f8:	e8ca                	sd	s2,80(sp)
    800053fa:	e4ce                	sd	s3,72(sp)
    800053fc:	e0d2                	sd	s4,64(sp)
    800053fe:	fc56                	sd	s5,56(sp)
    80005400:	f85a                	sd	s6,48(sp)
    80005402:	f45e                	sd	s7,40(sp)
    80005404:	f062                	sd	s8,32(sp)
    80005406:	ec66                	sd	s9,24(sp)
    80005408:	e86a                	sd	s10,16(sp)
    8000540a:	1880                	addi	s0,sp,112
    8000540c:	892a                	mv	s2,a0
    8000540e:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005410:	00c52c83          	lw	s9,12(a0)
    80005414:	001c9c9b          	slliw	s9,s9,0x1
    80005418:	1c82                	slli	s9,s9,0x20
    8000541a:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000541e:	00019517          	auipc	a0,0x19
    80005422:	d0a50513          	addi	a0,a0,-758 # 8001e128 <disk+0x2128>
    80005426:	00002097          	auipc	ra,0x2
    8000542a:	d32080e7          	jalr	-718(ra) # 80007158 <acquire>
  for(int i = 0; i < 3; i++){
    8000542e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005430:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005432:	00017b97          	auipc	s7,0x17
    80005436:	bceb8b93          	addi	s7,s7,-1074 # 8001c000 <disk>
    8000543a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000543c:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    8000543e:	8a4e                	mv	s4,s3
    80005440:	a051                	j	800054c4 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005442:	00fb86b3          	add	a3,s7,a5
    80005446:	96da                	add	a3,a3,s6
    80005448:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    8000544c:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000544e:	0207c563          	bltz	a5,80005478 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005452:	2485                	addiw	s1,s1,1
    80005454:	0711                	addi	a4,a4,4
    80005456:	25548063          	beq	s1,s5,80005696 <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    8000545a:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    8000545c:	00019697          	auipc	a3,0x19
    80005460:	bbc68693          	addi	a3,a3,-1092 # 8001e018 <disk+0x2018>
    80005464:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005466:	0006c583          	lbu	a1,0(a3)
    8000546a:	fde1                	bnez	a1,80005442 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000546c:	2785                	addiw	a5,a5,1
    8000546e:	0685                	addi	a3,a3,1
    80005470:	ff879be3          	bne	a5,s8,80005466 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005474:	57fd                	li	a5,-1
    80005476:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005478:	02905a63          	blez	s1,800054ac <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000547c:	f9042503          	lw	a0,-112(s0)
    80005480:	00000097          	auipc	ra,0x0
    80005484:	d90080e7          	jalr	-624(ra) # 80005210 <free_desc>
      for(int j = 0; j < i; j++)
    80005488:	4785                	li	a5,1
    8000548a:	0297d163          	bge	a5,s1,800054ac <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000548e:	f9442503          	lw	a0,-108(s0)
    80005492:	00000097          	auipc	ra,0x0
    80005496:	d7e080e7          	jalr	-642(ra) # 80005210 <free_desc>
      for(int j = 0; j < i; j++)
    8000549a:	4789                	li	a5,2
    8000549c:	0097d863          	bge	a5,s1,800054ac <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054a0:	f9842503          	lw	a0,-104(s0)
    800054a4:	00000097          	auipc	ra,0x0
    800054a8:	d6c080e7          	jalr	-660(ra) # 80005210 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054ac:	00019597          	auipc	a1,0x19
    800054b0:	c7c58593          	addi	a1,a1,-900 # 8001e128 <disk+0x2128>
    800054b4:	00019517          	auipc	a0,0x19
    800054b8:	b6450513          	addi	a0,a0,-1180 # 8001e018 <disk+0x2018>
    800054bc:	ffffc097          	auipc	ra,0xffffc
    800054c0:	216080e7          	jalr	534(ra) # 800016d2 <sleep>
  for(int i = 0; i < 3; i++){
    800054c4:	f9040713          	addi	a4,s0,-112
    800054c8:	84ce                	mv	s1,s3
    800054ca:	bf41                	j	8000545a <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054cc:	20058713          	addi	a4,a1,512
    800054d0:	00471693          	slli	a3,a4,0x4
    800054d4:	00017717          	auipc	a4,0x17
    800054d8:	b2c70713          	addi	a4,a4,-1236 # 8001c000 <disk>
    800054dc:	9736                	add	a4,a4,a3
    800054de:	4685                	li	a3,1
    800054e0:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054e4:	20058713          	addi	a4,a1,512
    800054e8:	00471693          	slli	a3,a4,0x4
    800054ec:	00017717          	auipc	a4,0x17
    800054f0:	b1470713          	addi	a4,a4,-1260 # 8001c000 <disk>
    800054f4:	9736                	add	a4,a4,a3
    800054f6:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054fa:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054fe:	7679                	lui	a2,0xffffe
    80005500:	963e                	add	a2,a2,a5
    80005502:	00019697          	auipc	a3,0x19
    80005506:	afe68693          	addi	a3,a3,-1282 # 8001e000 <disk+0x2000>
    8000550a:	6298                	ld	a4,0(a3)
    8000550c:	9732                	add	a4,a4,a2
    8000550e:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005510:	6298                	ld	a4,0(a3)
    80005512:	9732                	add	a4,a4,a2
    80005514:	4541                	li	a0,16
    80005516:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005518:	6298                	ld	a4,0(a3)
    8000551a:	9732                	add	a4,a4,a2
    8000551c:	4505                	li	a0,1
    8000551e:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005522:	f9442703          	lw	a4,-108(s0)
    80005526:	6288                	ld	a0,0(a3)
    80005528:	962a                	add	a2,a2,a0
    8000552a:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd6a8e>

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000552e:	0712                	slli	a4,a4,0x4
    80005530:	6290                	ld	a2,0(a3)
    80005532:	963a                	add	a2,a2,a4
    80005534:	05890513          	addi	a0,s2,88
    80005538:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000553a:	6294                	ld	a3,0(a3)
    8000553c:	96ba                	add	a3,a3,a4
    8000553e:	40000613          	li	a2,1024
    80005542:	c690                	sw	a2,8(a3)
  if(write)
    80005544:	140d0063          	beqz	s10,80005684 <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005548:	00019697          	auipc	a3,0x19
    8000554c:	ab86b683          	ld	a3,-1352(a3) # 8001e000 <disk+0x2000>
    80005550:	96ba                	add	a3,a3,a4
    80005552:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005556:	00017817          	auipc	a6,0x17
    8000555a:	aaa80813          	addi	a6,a6,-1366 # 8001c000 <disk>
    8000555e:	00019517          	auipc	a0,0x19
    80005562:	aa250513          	addi	a0,a0,-1374 # 8001e000 <disk+0x2000>
    80005566:	6114                	ld	a3,0(a0)
    80005568:	96ba                	add	a3,a3,a4
    8000556a:	00c6d603          	lhu	a2,12(a3)
    8000556e:	00166613          	ori	a2,a2,1
    80005572:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005576:	f9842683          	lw	a3,-104(s0)
    8000557a:	6110                	ld	a2,0(a0)
    8000557c:	9732                	add	a4,a4,a2
    8000557e:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005582:	20058613          	addi	a2,a1,512
    80005586:	0612                	slli	a2,a2,0x4
    80005588:	9642                	add	a2,a2,a6
    8000558a:	577d                	li	a4,-1
    8000558c:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005590:	00469713          	slli	a4,a3,0x4
    80005594:	6114                	ld	a3,0(a0)
    80005596:	96ba                	add	a3,a3,a4
    80005598:	03078793          	addi	a5,a5,48
    8000559c:	97c2                	add	a5,a5,a6
    8000559e:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800055a0:	611c                	ld	a5,0(a0)
    800055a2:	97ba                	add	a5,a5,a4
    800055a4:	4685                	li	a3,1
    800055a6:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055a8:	611c                	ld	a5,0(a0)
    800055aa:	97ba                	add	a5,a5,a4
    800055ac:	4809                	li	a6,2
    800055ae:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800055b2:	611c                	ld	a5,0(a0)
    800055b4:	973e                	add	a4,a4,a5
    800055b6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055ba:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800055be:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055c2:	6518                	ld	a4,8(a0)
    800055c4:	00275783          	lhu	a5,2(a4)
    800055c8:	8b9d                	andi	a5,a5,7
    800055ca:	0786                	slli	a5,a5,0x1
    800055cc:	97ba                	add	a5,a5,a4
    800055ce:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055d2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055d6:	6518                	ld	a4,8(a0)
    800055d8:	00275783          	lhu	a5,2(a4)
    800055dc:	2785                	addiw	a5,a5,1
    800055de:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055e2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055e6:	100017b7          	lui	a5,0x10001
    800055ea:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055ee:	00492703          	lw	a4,4(s2)
    800055f2:	4785                	li	a5,1
    800055f4:	02f71163          	bne	a4,a5,80005616 <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055f8:	00019997          	auipc	s3,0x19
    800055fc:	b3098993          	addi	s3,s3,-1232 # 8001e128 <disk+0x2128>
  while(b->disk == 1) {
    80005600:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005602:	85ce                	mv	a1,s3
    80005604:	854a                	mv	a0,s2
    80005606:	ffffc097          	auipc	ra,0xffffc
    8000560a:	0cc080e7          	jalr	204(ra) # 800016d2 <sleep>
  while(b->disk == 1) {
    8000560e:	00492783          	lw	a5,4(s2)
    80005612:	fe9788e3          	beq	a5,s1,80005602 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80005616:	f9042903          	lw	s2,-112(s0)
    8000561a:	20090793          	addi	a5,s2,512
    8000561e:	00479713          	slli	a4,a5,0x4
    80005622:	00017797          	auipc	a5,0x17
    80005626:	9de78793          	addi	a5,a5,-1570 # 8001c000 <disk>
    8000562a:	97ba                	add	a5,a5,a4
    8000562c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005630:	00019997          	auipc	s3,0x19
    80005634:	9d098993          	addi	s3,s3,-1584 # 8001e000 <disk+0x2000>
    80005638:	00491713          	slli	a4,s2,0x4
    8000563c:	0009b783          	ld	a5,0(s3)
    80005640:	97ba                	add	a5,a5,a4
    80005642:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005646:	854a                	mv	a0,s2
    80005648:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000564c:	00000097          	auipc	ra,0x0
    80005650:	bc4080e7          	jalr	-1084(ra) # 80005210 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005654:	8885                	andi	s1,s1,1
    80005656:	f0ed                	bnez	s1,80005638 <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005658:	00019517          	auipc	a0,0x19
    8000565c:	ad050513          	addi	a0,a0,-1328 # 8001e128 <disk+0x2128>
    80005660:	00002097          	auipc	ra,0x2
    80005664:	bac080e7          	jalr	-1108(ra) # 8000720c <release>
}
    80005668:	70a6                	ld	ra,104(sp)
    8000566a:	7406                	ld	s0,96(sp)
    8000566c:	64e6                	ld	s1,88(sp)
    8000566e:	6946                	ld	s2,80(sp)
    80005670:	69a6                	ld	s3,72(sp)
    80005672:	6a06                	ld	s4,64(sp)
    80005674:	7ae2                	ld	s5,56(sp)
    80005676:	7b42                	ld	s6,48(sp)
    80005678:	7ba2                	ld	s7,40(sp)
    8000567a:	7c02                	ld	s8,32(sp)
    8000567c:	6ce2                	ld	s9,24(sp)
    8000567e:	6d42                	ld	s10,16(sp)
    80005680:	6165                	addi	sp,sp,112
    80005682:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005684:	00019697          	auipc	a3,0x19
    80005688:	97c6b683          	ld	a3,-1668(a3) # 8001e000 <disk+0x2000>
    8000568c:	96ba                	add	a3,a3,a4
    8000568e:	4609                	li	a2,2
    80005690:	00c69623          	sh	a2,12(a3)
    80005694:	b5c9                	j	80005556 <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005696:	f9042583          	lw	a1,-112(s0)
    8000569a:	20058793          	addi	a5,a1,512
    8000569e:	0792                	slli	a5,a5,0x4
    800056a0:	00017517          	auipc	a0,0x17
    800056a4:	a0850513          	addi	a0,a0,-1528 # 8001c0a8 <disk+0xa8>
    800056a8:	953e                	add	a0,a0,a5
  if(write)
    800056aa:	e20d11e3          	bnez	s10,800054cc <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056ae:	20058713          	addi	a4,a1,512
    800056b2:	00471693          	slli	a3,a4,0x4
    800056b6:	00017717          	auipc	a4,0x17
    800056ba:	94a70713          	addi	a4,a4,-1718 # 8001c000 <disk>
    800056be:	9736                	add	a4,a4,a3
    800056c0:	0a072423          	sw	zero,168(a4)
    800056c4:	b505                	j	800054e4 <virtio_disk_rw+0xf4>

00000000800056c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056c6:	1101                	addi	sp,sp,-32
    800056c8:	ec06                	sd	ra,24(sp)
    800056ca:	e822                	sd	s0,16(sp)
    800056cc:	e426                	sd	s1,8(sp)
    800056ce:	e04a                	sd	s2,0(sp)
    800056d0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056d2:	00019517          	auipc	a0,0x19
    800056d6:	a5650513          	addi	a0,a0,-1450 # 8001e128 <disk+0x2128>
    800056da:	00002097          	auipc	ra,0x2
    800056de:	a7e080e7          	jalr	-1410(ra) # 80007158 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056e2:	10001737          	lui	a4,0x10001
    800056e6:	533c                	lw	a5,96(a4)
    800056e8:	8b8d                	andi	a5,a5,3
    800056ea:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056ec:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056f0:	00019797          	auipc	a5,0x19
    800056f4:	91078793          	addi	a5,a5,-1776 # 8001e000 <disk+0x2000>
    800056f8:	6b94                	ld	a3,16(a5)
    800056fa:	0207d703          	lhu	a4,32(a5)
    800056fe:	0026d783          	lhu	a5,2(a3)
    80005702:	06f70163          	beq	a4,a5,80005764 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005706:	00017917          	auipc	s2,0x17
    8000570a:	8fa90913          	addi	s2,s2,-1798 # 8001c000 <disk>
    8000570e:	00019497          	auipc	s1,0x19
    80005712:	8f248493          	addi	s1,s1,-1806 # 8001e000 <disk+0x2000>
    __sync_synchronize();
    80005716:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000571a:	6898                	ld	a4,16(s1)
    8000571c:	0204d783          	lhu	a5,32(s1)
    80005720:	8b9d                	andi	a5,a5,7
    80005722:	078e                	slli	a5,a5,0x3
    80005724:	97ba                	add	a5,a5,a4
    80005726:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005728:	20078713          	addi	a4,a5,512
    8000572c:	0712                	slli	a4,a4,0x4
    8000572e:	974a                	add	a4,a4,s2
    80005730:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005734:	e731                	bnez	a4,80005780 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005736:	20078793          	addi	a5,a5,512
    8000573a:	0792                	slli	a5,a5,0x4
    8000573c:	97ca                	add	a5,a5,s2
    8000573e:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005740:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005744:	ffffc097          	auipc	ra,0xffffc
    80005748:	114080e7          	jalr	276(ra) # 80001858 <wakeup>

    disk.used_idx += 1;
    8000574c:	0204d783          	lhu	a5,32(s1)
    80005750:	2785                	addiw	a5,a5,1
    80005752:	17c2                	slli	a5,a5,0x30
    80005754:	93c1                	srli	a5,a5,0x30
    80005756:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000575a:	6898                	ld	a4,16(s1)
    8000575c:	00275703          	lhu	a4,2(a4)
    80005760:	faf71be3          	bne	a4,a5,80005716 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005764:	00019517          	auipc	a0,0x19
    80005768:	9c450513          	addi	a0,a0,-1596 # 8001e128 <disk+0x2128>
    8000576c:	00002097          	auipc	ra,0x2
    80005770:	aa0080e7          	jalr	-1376(ra) # 8000720c <release>
}
    80005774:	60e2                	ld	ra,24(sp)
    80005776:	6442                	ld	s0,16(sp)
    80005778:	64a2                	ld	s1,8(sp)
    8000577a:	6902                	ld	s2,0(sp)
    8000577c:	6105                	addi	sp,sp,32
    8000577e:	8082                	ret
      panic("virtio_disk_intr status");
    80005780:	00004517          	auipc	a0,0x4
    80005784:	02050513          	addi	a0,a0,32 # 800097a0 <syscalls+0x3f0>
    80005788:	00001097          	auipc	ra,0x1
    8000578c:	486080e7          	jalr	1158(ra) # 80006c0e <panic>

0000000080005790 <e1000_init>:
// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
    80005790:	7179                	addi	sp,sp,-48
    80005792:	f406                	sd	ra,40(sp)
    80005794:	f022                	sd	s0,32(sp)
    80005796:	ec26                	sd	s1,24(sp)
    80005798:	e84a                	sd	s2,16(sp)
    8000579a:	e44e                	sd	s3,8(sp)
    8000579c:	1800                	addi	s0,sp,48
    8000579e:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    800057a0:	00004597          	auipc	a1,0x4
    800057a4:	01858593          	addi	a1,a1,24 # 800097b8 <syscalls+0x408>
    800057a8:	0001a517          	auipc	a0,0x1a
    800057ac:	85850513          	addi	a0,a0,-1960 # 8001f000 <e1000_lock>
    800057b0:	00002097          	auipc	ra,0x2
    800057b4:	918080e7          	jalr	-1768(ra) # 800070c8 <initlock>

  regs = xregs;
    800057b8:	00005797          	auipc	a5,0x5
    800057bc:	8697b423          	sd	s1,-1944(a5) # 8000a020 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    800057c0:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    800057c4:	409c                	lw	a5,0(s1)
    800057c6:	00400737          	lui	a4,0x400
    800057ca:	8fd9                	or	a5,a5,a4
    800057cc:	2781                	sext.w	a5,a5
    800057ce:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    800057d0:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    800057d4:	0ff0000f          	fence

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    800057d8:	10000613          	li	a2,256
    800057dc:	4581                	li	a1,0
    800057de:	0001a517          	auipc	a0,0x1a
    800057e2:	84250513          	addi	a0,a0,-1982 # 8001f020 <tx_ring>
    800057e6:	ffffb097          	auipc	ra,0xffffb
    800057ea:	992080e7          	jalr	-1646(ra) # 80000178 <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    800057ee:	0001a717          	auipc	a4,0x1a
    800057f2:	83e70713          	addi	a4,a4,-1986 # 8001f02c <tx_ring+0xc>
    800057f6:	0001a797          	auipc	a5,0x1a
    800057fa:	92a78793          	addi	a5,a5,-1750 # 8001f120 <tx_mbufs>
    800057fe:	0001a617          	auipc	a2,0x1a
    80005802:	9a260613          	addi	a2,a2,-1630 # 8001f1a0 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    80005806:	4685                	li	a3,1
    80005808:	00d70023          	sb	a3,0(a4)
    tx_mbufs[i] = 0;
    8000580c:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    80005810:	0741                	addi	a4,a4,16
    80005812:	07a1                	addi	a5,a5,8
    80005814:	fec79ae3          	bne	a5,a2,80005808 <e1000_init+0x78>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    80005818:	0001a717          	auipc	a4,0x1a
    8000581c:	80870713          	addi	a4,a4,-2040 # 8001f020 <tx_ring>
    80005820:	00005797          	auipc	a5,0x5
    80005824:	8007b783          	ld	a5,-2048(a5) # 8000a020 <regs>
    80005828:	6691                	lui	a3,0x4
    8000582a:	97b6                	add	a5,a5,a3
    8000582c:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    80005830:	10000713          	li	a4,256
    80005834:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80005838:	8007ac23          	sw	zero,-2024(a5)
    8000583c:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    80005840:	0001a917          	auipc	s2,0x1a
    80005844:	96090913          	addi	s2,s2,-1696 # 8001f1a0 <rx_ring>
    80005848:	10000613          	li	a2,256
    8000584c:	4581                	li	a1,0
    8000584e:	854a                	mv	a0,s2
    80005850:	ffffb097          	auipc	ra,0xffffb
    80005854:	928080e7          	jalr	-1752(ra) # 80000178 <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005858:	0001a497          	auipc	s1,0x1a
    8000585c:	a4848493          	addi	s1,s1,-1464 # 8001f2a0 <rx_mbufs>
    80005860:	0001a997          	auipc	s3,0x1a
    80005864:	ac098993          	addi	s3,s3,-1344 # 8001f320 <lock>
    rx_mbufs[i] = mbufalloc(0);
    80005868:	4501                	li	a0,0
    8000586a:	00000097          	auipc	ra,0x0
    8000586e:	408080e7          	jalr	1032(ra) # 80005c72 <mbufalloc>
    80005872:	e088                	sd	a0,0(s1)
    if (!rx_mbufs[i])
    80005874:	c945                	beqz	a0,80005924 <e1000_init+0x194>
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
    80005876:	651c                	ld	a5,8(a0)
    80005878:	00f93023          	sd	a5,0(s2)
  for (i = 0; i < RX_RING_SIZE; i++) {
    8000587c:	04a1                	addi	s1,s1,8
    8000587e:	0941                	addi	s2,s2,16
    80005880:	ff3494e3          	bne	s1,s3,80005868 <e1000_init+0xd8>
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80005884:	00004697          	auipc	a3,0x4
    80005888:	79c6b683          	ld	a3,1948(a3) # 8000a020 <regs>
    8000588c:	0001a717          	auipc	a4,0x1a
    80005890:	91470713          	addi	a4,a4,-1772 # 8001f1a0 <rx_ring>
    80005894:	678d                	lui	a5,0x3
    80005896:	97b6                	add	a5,a5,a3
    80005898:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    8000589c:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    800058a0:	473d                	li	a4,15
    800058a2:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    800058a6:	10000713          	li	a4,256
    800058aa:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    800058ae:	6715                	lui	a4,0x5
    800058b0:	00e68633          	add	a2,a3,a4
    800058b4:	120057b7          	lui	a5,0x12005
    800058b8:	4527879b          	addiw	a5,a5,1106
    800058bc:	40f62023          	sw	a5,1024(a2)
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    800058c0:	800057b7          	lui	a5,0x80005
    800058c4:	6347879b          	addiw	a5,a5,1588
    800058c8:	40f62223          	sw	a5,1028(a2)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    800058cc:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    800058d0:	97b6                	add	a5,a5,a3
    800058d2:	40070713          	addi	a4,a4,1024
    800058d6:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    800058d8:	0007a023          	sw	zero,0(a5) # ffffffff80005000 <end+0xfffffffefffdda80>
  for (int i = 0; i < 4096/32; i++)
    800058dc:	0791                	addi	a5,a5,4
    800058de:	fee79de3          	bne	a5,a4,800058d8 <e1000_init+0x148>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    800058e2:	000407b7          	lui	a5,0x40
    800058e6:	10a7879b          	addiw	a5,a5,266
    800058ea:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    800058ee:	006027b7          	lui	a5,0x602
    800058f2:	27a9                	addiw	a5,a5,10
    800058f4:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    800058f8:	040087b7          	lui	a5,0x4008
    800058fc:	2789                	addiw	a5,a5,2
    800058fe:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    80005902:	678d                	lui	a5,0x3
    80005904:	97b6                	add	a5,a5,a3
    80005906:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    8000590a:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    8000590e:	08000793          	li	a5,128
    80005912:	0cf6a823          	sw	a5,208(a3)
}
    80005916:	70a2                	ld	ra,40(sp)
    80005918:	7402                	ld	s0,32(sp)
    8000591a:	64e2                	ld	s1,24(sp)
    8000591c:	6942                	ld	s2,16(sp)
    8000591e:	69a2                	ld	s3,8(sp)
    80005920:	6145                	addi	sp,sp,48
    80005922:	8082                	ret
      panic("e1000");
    80005924:	00004517          	auipc	a0,0x4
    80005928:	e9450513          	addi	a0,a0,-364 # 800097b8 <syscalls+0x408>
    8000592c:	00001097          	auipc	ra,0x1
    80005930:	2e2080e7          	jalr	738(ra) # 80006c0e <panic>

0000000080005934 <e1000_transmit>:

int
e1000_transmit(struct mbuf *m)
{
    80005934:	7179                	addi	sp,sp,-48
    80005936:	f406                	sd	ra,40(sp)
    80005938:	f022                	sd	s0,32(sp)
    8000593a:	ec26                	sd	s1,24(sp)
    8000593c:	e84a                	sd	s2,16(sp)
    8000593e:	e44e                	sd	s3,8(sp)
    80005940:	1800                	addi	s0,sp,48
    80005942:	892a                	mv	s2,a0
  //
  // the mbuf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.
  //
  acquire(&e1000_lock);
    80005944:	00019997          	auipc	s3,0x19
    80005948:	6bc98993          	addi	s3,s3,1724 # 8001f000 <e1000_lock>
    8000594c:	854e                	mv	a0,s3
    8000594e:	00002097          	auipc	ra,0x2
    80005952:	80a080e7          	jalr	-2038(ra) # 80007158 <acquire>
  uint32 index = regs[E1000_TDT];
    80005956:	00004797          	auipc	a5,0x4
    8000595a:	6ca7b783          	ld	a5,1738(a5) # 8000a020 <regs>
    8000595e:	6711                	lui	a4,0x4
    80005960:	97ba                	add	a5,a5,a4
    80005962:	8187a783          	lw	a5,-2024(a5)
    80005966:	0007849b          	sext.w	s1,a5

  struct tx_desc *desc = &tx_ring[index];
  if((desc->status & E1000_TXD_STAT_DD) == 0) {
    8000596a:	1782                	slli	a5,a5,0x20
    8000596c:	9381                	srli	a5,a5,0x20
    8000596e:	0792                	slli	a5,a5,0x4
    80005970:	97ce                	add	a5,a5,s3
    80005972:	02c7c783          	lbu	a5,44(a5)
    80005976:	8b85                	andi	a5,a5,1
    80005978:	c3c9                	beqz	a5,800059fa <e1000_transmit+0xc6>
    release(&e1000_lock);
    return -1;
  }

  if(tx_mbufs[index])
    8000597a:	02049793          	slli	a5,s1,0x20
    8000597e:	9381                	srli	a5,a5,0x20
    80005980:	00379713          	slli	a4,a5,0x3
    80005984:	00019797          	auipc	a5,0x19
    80005988:	67c78793          	addi	a5,a5,1660 # 8001f000 <e1000_lock>
    8000598c:	97ba                	add	a5,a5,a4
    8000598e:	1207b503          	ld	a0,288(a5)
    80005992:	c509                	beqz	a0,8000599c <e1000_transmit+0x68>
    mbuffree(tx_mbufs[index]);
    80005994:	00000097          	auipc	ra,0x0
    80005998:	336080e7          	jalr	822(ra) # 80005cca <mbuffree>

  desc->length = m->len;
    8000599c:	00019517          	auipc	a0,0x19
    800059a0:	66450513          	addi	a0,a0,1636 # 8001f000 <e1000_lock>
    800059a4:	1482                	slli	s1,s1,0x20
    800059a6:	9081                	srli	s1,s1,0x20
    800059a8:	00449793          	slli	a5,s1,0x4
    800059ac:	97aa                	add	a5,a5,a0
    800059ae:	01092703          	lw	a4,16(s2)
    800059b2:	02e79423          	sh	a4,40(a5)
  desc->addr = (uint64) m->head;
    800059b6:	00893703          	ld	a4,8(s2)
    800059ba:	f398                	sd	a4,32(a5)
  desc->cmd = E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS;
    800059bc:	4725                	li	a4,9
    800059be:	02e785a3          	sb	a4,43(a5)
  tx_mbufs[index] = m;
    800059c2:	048e                	slli	s1,s1,0x3
    800059c4:	94aa                	add	s1,s1,a0
    800059c6:	1324b023          	sd	s2,288(s1)

  regs[E1000_TDT] = (regs[E1000_TDT] + 1) % TX_RING_SIZE;
    800059ca:	00004717          	auipc	a4,0x4
    800059ce:	65673703          	ld	a4,1622(a4) # 8000a020 <regs>
    800059d2:	6791                	lui	a5,0x4
    800059d4:	973e                	add	a4,a4,a5
    800059d6:	81872783          	lw	a5,-2024(a4)
    800059da:	2785                	addiw	a5,a5,1
    800059dc:	8bbd                	andi	a5,a5,15
    800059de:	80f72c23          	sw	a5,-2024(a4)
  release(&e1000_lock);
    800059e2:	00002097          	auipc	ra,0x2
    800059e6:	82a080e7          	jalr	-2006(ra) # 8000720c <release>

  return 0;
    800059ea:	4501                	li	a0,0
}
    800059ec:	70a2                	ld	ra,40(sp)
    800059ee:	7402                	ld	s0,32(sp)
    800059f0:	64e2                	ld	s1,24(sp)
    800059f2:	6942                	ld	s2,16(sp)
    800059f4:	69a2                	ld	s3,8(sp)
    800059f6:	6145                	addi	sp,sp,48
    800059f8:	8082                	ret
    release(&e1000_lock);
    800059fa:	854e                	mv	a0,s3
    800059fc:	00002097          	auipc	ra,0x2
    80005a00:	810080e7          	jalr	-2032(ra) # 8000720c <release>
    return -1;
    80005a04:	557d                	li	a0,-1
    80005a06:	b7dd                	j	800059ec <e1000_transmit+0xb8>

0000000080005a08 <e1000_intr>:
  //release(&e1000_lock);
}

void
e1000_intr(void)
{
    80005a08:	7179                	addi	sp,sp,-48
    80005a0a:	f406                	sd	ra,40(sp)
    80005a0c:	f022                	sd	s0,32(sp)
    80005a0e:	ec26                	sd	s1,24(sp)
    80005a10:	e84a                	sd	s2,16(sp)
    80005a12:	e44e                	sd	s3,8(sp)
    80005a14:	1800                	addi	s0,sp,48
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005a16:	00004797          	auipc	a5,0x4
    80005a1a:	60a7b783          	ld	a5,1546(a5) # 8000a020 <regs>
    80005a1e:	577d                	li	a4,-1
    80005a20:	0ce7a023          	sw	a4,192(a5)
  uint32 index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005a24:	670d                	lui	a4,0x3
    80005a26:	97ba                	add	a5,a5,a4
    80005a28:	8187a783          	lw	a5,-2024(a5)
    80005a2c:	2785                	addiw	a5,a5,1
    80005a2e:	00f7f493          	andi	s1,a5,15
  while(rx_ring[index].status & E1000_RXD_STAT_DD) {
    80005a32:	00449793          	slli	a5,s1,0x4
    80005a36:	00019717          	auipc	a4,0x19
    80005a3a:	5ca70713          	addi	a4,a4,1482 # 8001f000 <e1000_lock>
    80005a3e:	97ba                	add	a5,a5,a4
    80005a40:	1ac7c783          	lbu	a5,428(a5)
    80005a44:	8b85                	andi	a5,a5,1
    80005a46:	cfa1                	beqz	a5,80005a9e <e1000_intr+0x96>
    struct mbuf *buf = rx_mbufs[index];
    80005a48:	89ba                	mv	s3,a4
    80005a4a:	00349913          	slli	s2,s1,0x3
    80005a4e:	994e                	add	s2,s2,s3
    80005a50:	2a093503          	ld	a0,672(s2)
    buf->len = desc->length;
    80005a54:	00449793          	slli	a5,s1,0x4
    80005a58:	97ce                	add	a5,a5,s3
    80005a5a:	1a87d783          	lhu	a5,424(a5)
    80005a5e:	c91c                	sw	a5,16(a0)
    net_rx(buf);
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	3de080e7          	jalr	990(ra) # 80005e3e <net_rx>
    rx_mbufs[index] = mbufalloc(0);
    80005a68:	4501                	li	a0,0
    80005a6a:	00000097          	auipc	ra,0x0
    80005a6e:	208080e7          	jalr	520(ra) # 80005c72 <mbufalloc>
    80005a72:	2aa93023          	sd	a0,672(s2)
    if(!rx_mbufs[index])
    80005a76:	c521                	beqz	a0,80005abe <e1000_intr+0xb6>
    desc->addr = (uint64) rx_mbufs[index]->head;
    80005a78:	00449793          	slli	a5,s1,0x4
    80005a7c:	97ce                	add	a5,a5,s3
    80005a7e:	6518                	ld	a4,8(a0)
    80005a80:	1ae7b023          	sd	a4,416(a5)
    desc->status = 0;
    80005a84:	1a078623          	sb	zero,428(a5)
    index = (index + 1 + RX_RING_SIZE) % RX_RING_SIZE;
    80005a88:	0114879b          	addiw	a5,s1,17
    80005a8c:	00f7f493          	andi	s1,a5,15
  while(rx_ring[index].status & E1000_RXD_STAT_DD) {
    80005a90:	00449793          	slli	a5,s1,0x4
    80005a94:	97ce                	add	a5,a5,s3
    80005a96:	1ac7c783          	lbu	a5,428(a5)
    80005a9a:	8b85                	andi	a5,a5,1
    80005a9c:	f7dd                	bnez	a5,80005a4a <e1000_intr+0x42>
  regs[E1000_RDT] = index - 1;
    80005a9e:	34fd                	addiw	s1,s1,-1
    80005aa0:	00004797          	auipc	a5,0x4
    80005aa4:	5807b783          	ld	a5,1408(a5) # 8000a020 <regs>
    80005aa8:	670d                	lui	a4,0x3
    80005aaa:	97ba                	add	a5,a5,a4
    80005aac:	8097ac23          	sw	s1,-2024(a5)

  e1000_recv();
}
    80005ab0:	70a2                	ld	ra,40(sp)
    80005ab2:	7402                	ld	s0,32(sp)
    80005ab4:	64e2                	ld	s1,24(sp)
    80005ab6:	6942                	ld	s2,16(sp)
    80005ab8:	69a2                	ld	s3,8(sp)
    80005aba:	6145                	addi	sp,sp,48
    80005abc:	8082                	ret
      panic("e1000");
    80005abe:	00004517          	auipc	a0,0x4
    80005ac2:	cfa50513          	addi	a0,a0,-774 # 800097b8 <syscalls+0x408>
    80005ac6:	00001097          	auipc	ra,0x1
    80005aca:	148080e7          	jalr	328(ra) # 80006c0e <panic>

0000000080005ace <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    80005ace:	1101                	addi	sp,sp,-32
    80005ad0:	ec22                	sd	s0,24(sp)
    80005ad2:	1000                	addi	s0,sp,32
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;
    80005ad4:	fe041723          	sh	zero,-18(s0)
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005ad8:	4785                	li	a5,1
    80005ada:	04b7d963          	bge	a5,a1,80005b2c <in_cksum+0x5e>
    80005ade:	ffe5879b          	addiw	a5,a1,-2
    80005ae2:	0017d61b          	srliw	a2,a5,0x1
    80005ae6:	0017d71b          	srliw	a4,a5,0x1
    80005aea:	0705                	addi	a4,a4,1
    80005aec:	0706                	slli	a4,a4,0x1
    80005aee:	972a                	add	a4,a4,a0
  unsigned int sum = 0;
    80005af0:	4781                	li	a5,0
    sum += *w++;
    80005af2:	0509                	addi	a0,a0,2
    80005af4:	ffe55683          	lhu	a3,-2(a0)
    80005af8:	9fb5                	addw	a5,a5,a3
  while (nleft > 1)  {
    80005afa:	fee51ce3          	bne	a0,a4,80005af2 <in_cksum+0x24>
    80005afe:	35f9                	addiw	a1,a1,-2
    80005b00:	0016169b          	slliw	a3,a2,0x1
    80005b04:	9d95                	subw	a1,a1,a3
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005b06:	4685                	li	a3,1
    80005b08:	02d58563          	beq	a1,a3,80005b32 <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    80005b0c:	03079513          	slli	a0,a5,0x30
    80005b10:	9141                	srli	a0,a0,0x30
    80005b12:	0107d79b          	srliw	a5,a5,0x10
    80005b16:	9fa9                	addw	a5,a5,a0
  sum += (sum >> 16);
    80005b18:	0107d51b          	srliw	a0,a5,0x10
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005b1c:	9d3d                	addw	a0,a0,a5
    80005b1e:	fff54513          	not	a0,a0
  return answer;
}
    80005b22:	1542                	slli	a0,a0,0x30
    80005b24:	9141                	srli	a0,a0,0x30
    80005b26:	6462                	ld	s0,24(sp)
    80005b28:	6105                	addi	sp,sp,32
    80005b2a:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    80005b2c:	872a                	mv	a4,a0
  unsigned int sum = 0;
    80005b2e:	4781                	li	a5,0
    80005b30:	bfd9                	j	80005b06 <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005b32:	00074703          	lbu	a4,0(a4) # 3000 <_entry-0x7fffd000>
    80005b36:	fee40723          	sb	a4,-18(s0)
    sum += answer;
    80005b3a:	fee45703          	lhu	a4,-18(s0)
    80005b3e:	9fb9                	addw	a5,a5,a4
    80005b40:	b7f1                	j	80005b0c <in_cksum+0x3e>

0000000080005b42 <mbufpull>:
{
    80005b42:	1141                	addi	sp,sp,-16
    80005b44:	e422                	sd	s0,8(sp)
    80005b46:	0800                	addi	s0,sp,16
    80005b48:	87aa                	mv	a5,a0
  char *tmp = m->head;
    80005b4a:	6508                	ld	a0,8(a0)
  if (m->len < len)
    80005b4c:	4b98                	lw	a4,16(a5)
    80005b4e:	00b76b63          	bltu	a4,a1,80005b64 <mbufpull+0x22>
  m->len -= len;
    80005b52:	9f0d                	subw	a4,a4,a1
    80005b54:	cb98                	sw	a4,16(a5)
  m->head += len;
    80005b56:	1582                	slli	a1,a1,0x20
    80005b58:	9181                	srli	a1,a1,0x20
    80005b5a:	95aa                	add	a1,a1,a0
    80005b5c:	e78c                	sd	a1,8(a5)
}
    80005b5e:	6422                	ld	s0,8(sp)
    80005b60:	0141                	addi	sp,sp,16
    80005b62:	8082                	ret
    return 0;
    80005b64:	4501                	li	a0,0
    80005b66:	bfe5                	j	80005b5e <mbufpull+0x1c>

0000000080005b68 <mbufpush>:
{
    80005b68:	87aa                	mv	a5,a0
  m->head -= len;
    80005b6a:	02059713          	slli	a4,a1,0x20
    80005b6e:	9301                	srli	a4,a4,0x20
    80005b70:	6508                	ld	a0,8(a0)
    80005b72:	8d19                	sub	a0,a0,a4
    80005b74:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    80005b76:	01478713          	addi	a4,a5,20
    80005b7a:	00e56663          	bltu	a0,a4,80005b86 <mbufpush+0x1e>
  m->len += len;
    80005b7e:	4b98                	lw	a4,16(a5)
    80005b80:	9db9                	addw	a1,a1,a4
    80005b82:	cb8c                	sw	a1,16(a5)
}
    80005b84:	8082                	ret
{
    80005b86:	1141                	addi	sp,sp,-16
    80005b88:	e406                	sd	ra,8(sp)
    80005b8a:	e022                	sd	s0,0(sp)
    80005b8c:	0800                	addi	s0,sp,16
    panic("mbufpush");
    80005b8e:	00004517          	auipc	a0,0x4
    80005b92:	c3250513          	addi	a0,a0,-974 # 800097c0 <syscalls+0x410>
    80005b96:	00001097          	auipc	ra,0x1
    80005b9a:	078080e7          	jalr	120(ra) # 80006c0e <panic>

0000000080005b9e <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    80005b9e:	7179                	addi	sp,sp,-48
    80005ba0:	f406                	sd	ra,40(sp)
    80005ba2:	f022                	sd	s0,32(sp)
    80005ba4:	ec26                	sd	s1,24(sp)
    80005ba6:	e84a                	sd	s2,16(sp)
    80005ba8:	e44e                	sd	s3,8(sp)
    80005baa:	1800                	addi	s0,sp,48
    80005bac:	89aa                	mv	s3,a0
    80005bae:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005bb0:	45b9                	li	a1,14
    80005bb2:	00000097          	auipc	ra,0x0
    80005bb6:	fb6080e7          	jalr	-74(ra) # 80005b68 <mbufpush>
    80005bba:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005bbc:	4619                	li	a2,6
    80005bbe:	00004597          	auipc	a1,0x4
    80005bc2:	cd258593          	addi	a1,a1,-814 # 80009890 <local_mac>
    80005bc6:	0519                	addi	a0,a0,6
    80005bc8:	ffffa097          	auipc	ra,0xffffa
    80005bcc:	610080e7          	jalr	1552(ra) # 800001d8 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005bd0:	4619                	li	a2,6
    80005bd2:	00004597          	auipc	a1,0x4
    80005bd6:	cb658593          	addi	a1,a1,-842 # 80009888 <broadcast_mac>
    80005bda:	8526                	mv	a0,s1
    80005bdc:	ffffa097          	auipc	ra,0xffffa
    80005be0:	5fc080e7          	jalr	1532(ra) # 800001d8 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005be4:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005be8:	00f48623          	sb	a5,12(s1)
    80005bec:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005bf0:	854e                	mv	a0,s3
    80005bf2:	00000097          	auipc	ra,0x0
    80005bf6:	d42080e7          	jalr	-702(ra) # 80005934 <e1000_transmit>
    80005bfa:	e901                	bnez	a0,80005c0a <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005bfc:	70a2                	ld	ra,40(sp)
    80005bfe:	7402                	ld	s0,32(sp)
    80005c00:	64e2                	ld	s1,24(sp)
    80005c02:	6942                	ld	s2,16(sp)
    80005c04:	69a2                	ld	s3,8(sp)
    80005c06:	6145                	addi	sp,sp,48
    80005c08:	8082                	ret
  kfree(m);
    80005c0a:	854e                	mv	a0,s3
    80005c0c:	ffffa097          	auipc	ra,0xffffa
    80005c10:	410080e7          	jalr	1040(ra) # 8000001c <kfree>
}
    80005c14:	b7e5                	j	80005bfc <net_tx_eth+0x5e>

0000000080005c16 <mbufput>:
{
    80005c16:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005c18:	4918                	lw	a4,16(a0)
    80005c1a:	02071693          	slli	a3,a4,0x20
    80005c1e:	9281                	srli	a3,a3,0x20
    80005c20:	6508                	ld	a0,8(a0)
    80005c22:	9536                	add	a0,a0,a3
  m->len += len;
    80005c24:	9f2d                	addw	a4,a4,a1
    80005c26:	0007069b          	sext.w	a3,a4
    80005c2a:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005c2c:	6785                	lui	a5,0x1
    80005c2e:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005c32:	00d7e363          	bltu	a5,a3,80005c38 <mbufput+0x22>
}
    80005c36:	8082                	ret
{
    80005c38:	1141                	addi	sp,sp,-16
    80005c3a:	e406                	sd	ra,8(sp)
    80005c3c:	e022                	sd	s0,0(sp)
    80005c3e:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005c40:	00004517          	auipc	a0,0x4
    80005c44:	b9050513          	addi	a0,a0,-1136 # 800097d0 <syscalls+0x420>
    80005c48:	00001097          	auipc	ra,0x1
    80005c4c:	fc6080e7          	jalr	-58(ra) # 80006c0e <panic>

0000000080005c50 <mbuftrim>:
{
    80005c50:	1141                	addi	sp,sp,-16
    80005c52:	e422                	sd	s0,8(sp)
    80005c54:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005c56:	491c                	lw	a5,16(a0)
    80005c58:	00b7eb63          	bltu	a5,a1,80005c6e <mbuftrim+0x1e>
  m->len -= len;
    80005c5c:	9f8d                	subw	a5,a5,a1
    80005c5e:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005c60:	1782                	slli	a5,a5,0x20
    80005c62:	9381                	srli	a5,a5,0x20
    80005c64:	6508                	ld	a0,8(a0)
    80005c66:	953e                	add	a0,a0,a5
}
    80005c68:	6422                	ld	s0,8(sp)
    80005c6a:	0141                	addi	sp,sp,16
    80005c6c:	8082                	ret
    return 0;
    80005c6e:	4501                	li	a0,0
    80005c70:	bfe5                	j	80005c68 <mbuftrim+0x18>

0000000080005c72 <mbufalloc>:
{
    80005c72:	1101                	addi	sp,sp,-32
    80005c74:	ec06                	sd	ra,24(sp)
    80005c76:	e822                	sd	s0,16(sp)
    80005c78:	e426                	sd	s1,8(sp)
    80005c7a:	e04a                	sd	s2,0(sp)
    80005c7c:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005c7e:	6785                	lui	a5,0x1
    80005c80:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005c84:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005c86:	02a7eb63          	bltu	a5,a0,80005cbc <mbufalloc+0x4a>
    80005c8a:	84aa                	mv	s1,a0
  m = kalloc();
    80005c8c:	ffffa097          	auipc	ra,0xffffa
    80005c90:	48c080e7          	jalr	1164(ra) # 80000118 <kalloc>
    80005c94:	892a                	mv	s2,a0
  if (m == 0)
    80005c96:	c11d                	beqz	a0,80005cbc <mbufalloc+0x4a>
  m->next = 0;
    80005c98:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005c9c:	0551                	addi	a0,a0,20
    80005c9e:	1482                	slli	s1,s1,0x20
    80005ca0:	9081                	srli	s1,s1,0x20
    80005ca2:	94aa                	add	s1,s1,a0
    80005ca4:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005ca8:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005cac:	6605                	lui	a2,0x1
    80005cae:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005cb2:	4581                	li	a1,0
    80005cb4:	ffffa097          	auipc	ra,0xffffa
    80005cb8:	4c4080e7          	jalr	1220(ra) # 80000178 <memset>
}
    80005cbc:	854a                	mv	a0,s2
    80005cbe:	60e2                	ld	ra,24(sp)
    80005cc0:	6442                	ld	s0,16(sp)
    80005cc2:	64a2                	ld	s1,8(sp)
    80005cc4:	6902                	ld	s2,0(sp)
    80005cc6:	6105                	addi	sp,sp,32
    80005cc8:	8082                	ret

0000000080005cca <mbuffree>:
{
    80005cca:	1141                	addi	sp,sp,-16
    80005ccc:	e406                	sd	ra,8(sp)
    80005cce:	e022                	sd	s0,0(sp)
    80005cd0:	0800                	addi	s0,sp,16
  kfree(m);
    80005cd2:	ffffa097          	auipc	ra,0xffffa
    80005cd6:	34a080e7          	jalr	842(ra) # 8000001c <kfree>
}
    80005cda:	60a2                	ld	ra,8(sp)
    80005cdc:	6402                	ld	s0,0(sp)
    80005cde:	0141                	addi	sp,sp,16
    80005ce0:	8082                	ret

0000000080005ce2 <mbufq_pushtail>:
{
    80005ce2:	1141                	addi	sp,sp,-16
    80005ce4:	e422                	sd	s0,8(sp)
    80005ce6:	0800                	addi	s0,sp,16
  m->next = 0;
    80005ce8:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005cec:	611c                	ld	a5,0(a0)
    80005cee:	c799                	beqz	a5,80005cfc <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005cf0:	651c                	ld	a5,8(a0)
    80005cf2:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005cf4:	e50c                	sd	a1,8(a0)
}
    80005cf6:	6422                	ld	s0,8(sp)
    80005cf8:	0141                	addi	sp,sp,16
    80005cfa:	8082                	ret
    q->head = q->tail = m;
    80005cfc:	e50c                	sd	a1,8(a0)
    80005cfe:	e10c                	sd	a1,0(a0)
    return;
    80005d00:	bfdd                	j	80005cf6 <mbufq_pushtail+0x14>

0000000080005d02 <mbufq_pophead>:
{
    80005d02:	1141                	addi	sp,sp,-16
    80005d04:	e422                	sd	s0,8(sp)
    80005d06:	0800                	addi	s0,sp,16
    80005d08:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005d0a:	6108                	ld	a0,0(a0)
  if (!head)
    80005d0c:	c119                	beqz	a0,80005d12 <mbufq_pophead+0x10>
  q->head = head->next;
    80005d0e:	6118                	ld	a4,0(a0)
    80005d10:	e398                	sd	a4,0(a5)
}
    80005d12:	6422                	ld	s0,8(sp)
    80005d14:	0141                	addi	sp,sp,16
    80005d16:	8082                	ret

0000000080005d18 <mbufq_empty>:
{
    80005d18:	1141                	addi	sp,sp,-16
    80005d1a:	e422                	sd	s0,8(sp)
    80005d1c:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005d1e:	6108                	ld	a0,0(a0)
}
    80005d20:	00153513          	seqz	a0,a0
    80005d24:	6422                	ld	s0,8(sp)
    80005d26:	0141                	addi	sp,sp,16
    80005d28:	8082                	ret

0000000080005d2a <mbufq_init>:
{
    80005d2a:	1141                	addi	sp,sp,-16
    80005d2c:	e422                	sd	s0,8(sp)
    80005d2e:	0800                	addi	s0,sp,16
  q->head = 0;
    80005d30:	00053023          	sd	zero,0(a0)
}
    80005d34:	6422                	ld	s0,8(sp)
    80005d36:	0141                	addi	sp,sp,16
    80005d38:	8082                	ret

0000000080005d3a <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005d3a:	7179                	addi	sp,sp,-48
    80005d3c:	f406                	sd	ra,40(sp)
    80005d3e:	f022                	sd	s0,32(sp)
    80005d40:	ec26                	sd	s1,24(sp)
    80005d42:	e84a                	sd	s2,16(sp)
    80005d44:	e44e                	sd	s3,8(sp)
    80005d46:	e052                	sd	s4,0(sp)
    80005d48:	1800                	addi	s0,sp,48
    80005d4a:	8a2a                	mv	s4,a0
    80005d4c:	892e                	mv	s2,a1
    80005d4e:	89b2                	mv	s3,a2
    80005d50:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005d52:	45a1                	li	a1,8
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	e14080e7          	jalr	-492(ra) # 80005b68 <mbufpush>
    80005d5c:	0089d61b          	srliw	a2,s3,0x8
    80005d60:	0089999b          	slliw	s3,s3,0x8
    80005d64:	00c9e9b3          	or	s3,s3,a2
  udphdr->sport = htons(sport);
    80005d68:	01351023          	sh	s3,0(a0)
    80005d6c:	0084d69b          	srliw	a3,s1,0x8
    80005d70:	0084949b          	slliw	s1,s1,0x8
    80005d74:	8cd5                	or	s1,s1,a3
  udphdr->dport = htons(dport);
    80005d76:	00951123          	sh	s1,2(a0)
  udphdr->ulen = htons(m->len);
    80005d7a:	010a2783          	lw	a5,16(s4)
    80005d7e:	0087d713          	srli	a4,a5,0x8
    80005d82:	0087979b          	slliw	a5,a5,0x8
    80005d86:	0ff77713          	andi	a4,a4,255
    80005d8a:	8fd9                	or	a5,a5,a4
    80005d8c:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005d90:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005d94:	45d1                	li	a1,20
    80005d96:	8552                	mv	a0,s4
    80005d98:	00000097          	auipc	ra,0x0
    80005d9c:	dd0080e7          	jalr	-560(ra) # 80005b68 <mbufpush>
    80005da0:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005da2:	4651                	li	a2,20
    80005da4:	4581                	li	a1,0
    80005da6:	ffffa097          	auipc	ra,0xffffa
    80005daa:	3d2080e7          	jalr	978(ra) # 80000178 <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005dae:	04500793          	li	a5,69
    80005db2:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005db6:	47c5                	li	a5,17
    80005db8:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005dbc:	0f0207b7          	lui	a5,0xf020
    80005dc0:	27a9                	addiw	a5,a5,10
    80005dc2:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005dc4:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005dc8:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005dcc:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005dce:	0089171b          	slliw	a4,s2,0x8
    80005dd2:	00ff06b7          	lui	a3,0xff0
    80005dd6:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005dd8:	8fd9                	or	a5,a5,a4
    80005dda:	0089591b          	srliw	s2,s2,0x8
    80005dde:	65c1                	lui	a1,0x10
    80005de0:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80005de4:	00b97933          	and	s2,s2,a1
    80005de8:	0127e933          	or	s2,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005dec:	0124a823          	sw	s2,16(s1)
  iphdr->ip_len = htons(m->len);
    80005df0:	010a2783          	lw	a5,16(s4)
  return (((val & 0x00ffU) << 8) |
    80005df4:	0087d713          	srli	a4,a5,0x8
    80005df8:	0087979b          	slliw	a5,a5,0x8
    80005dfc:	0ff77713          	andi	a4,a4,255
    80005e00:	8fd9                	or	a5,a5,a4
    80005e02:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005e06:	06400793          	li	a5,100
    80005e0a:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005e0e:	45d1                	li	a1,20
    80005e10:	8526                	mv	a0,s1
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	cbc080e7          	jalr	-836(ra) # 80005ace <in_cksum>
    80005e1a:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005e1e:	6585                	lui	a1,0x1
    80005e20:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005e24:	8552                	mv	a0,s4
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	d78080e7          	jalr	-648(ra) # 80005b9e <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005e2e:	70a2                	ld	ra,40(sp)
    80005e30:	7402                	ld	s0,32(sp)
    80005e32:	64e2                	ld	s1,24(sp)
    80005e34:	6942                	ld	s2,16(sp)
    80005e36:	69a2                	ld	s3,8(sp)
    80005e38:	6a02                	ld	s4,0(sp)
    80005e3a:	6145                	addi	sp,sp,48
    80005e3c:	8082                	ret

0000000080005e3e <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005e3e:	715d                	addi	sp,sp,-80
    80005e40:	e486                	sd	ra,72(sp)
    80005e42:	e0a2                	sd	s0,64(sp)
    80005e44:	fc26                	sd	s1,56(sp)
    80005e46:	f84a                	sd	s2,48(sp)
    80005e48:	f44e                	sd	s3,40(sp)
    80005e4a:	f052                	sd	s4,32(sp)
    80005e4c:	ec56                	sd	s5,24(sp)
    80005e4e:	0880                	addi	s0,sp,80
    80005e50:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005e52:	45b9                	li	a1,14
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	cee080e7          	jalr	-786(ra) # 80005b42 <mbufpull>
  if (!ethhdr) {
    80005e5c:	c521                	beqz	a0,80005ea4 <net_rx+0x66>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005e5e:	00c54783          	lbu	a5,12(a0)
    80005e62:	00d54703          	lbu	a4,13(a0)
    80005e66:	0722                	slli	a4,a4,0x8
    80005e68:	8fd9                	or	a5,a5,a4
    80005e6a:	0087979b          	slliw	a5,a5,0x8
    80005e6e:	8321                	srli	a4,a4,0x8
    80005e70:	8fd9                	or	a5,a5,a4
    80005e72:	17c2                	slli	a5,a5,0x30
    80005e74:	93c1                	srli	a5,a5,0x30
  if (type == ETHTYPE_IP)
    80005e76:	8007871b          	addiw	a4,a5,-2048
    80005e7a:	cb1d                	beqz	a4,80005eb0 <net_rx+0x72>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005e7c:	2781                	sext.w	a5,a5
    80005e7e:	6705                	lui	a4,0x1
    80005e80:	80670713          	addi	a4,a4,-2042 # 806 <_entry-0x7ffff7fa>
    80005e84:	18e78e63          	beq	a5,a4,80006020 <net_rx+0x1e2>
  kfree(m);
    80005e88:	8526                	mv	a0,s1
    80005e8a:	ffffa097          	auipc	ra,0xffffa
    80005e8e:	192080e7          	jalr	402(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005e92:	60a6                	ld	ra,72(sp)
    80005e94:	6406                	ld	s0,64(sp)
    80005e96:	74e2                	ld	s1,56(sp)
    80005e98:	7942                	ld	s2,48(sp)
    80005e9a:	79a2                	ld	s3,40(sp)
    80005e9c:	7a02                	ld	s4,32(sp)
    80005e9e:	6ae2                	ld	s5,24(sp)
    80005ea0:	6161                	addi	sp,sp,80
    80005ea2:	8082                	ret
  kfree(m);
    80005ea4:	8526                	mv	a0,s1
    80005ea6:	ffffa097          	auipc	ra,0xffffa
    80005eaa:	176080e7          	jalr	374(ra) # 8000001c <kfree>
}
    80005eae:	b7d5                	j	80005e92 <net_rx+0x54>
  iphdr = mbufpullhdr(m, *iphdr);
    80005eb0:	45d1                	li	a1,20
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	c8e080e7          	jalr	-882(ra) # 80005b42 <mbufpull>
    80005ebc:	892a                	mv	s2,a0
  if (!iphdr)
    80005ebe:	c519                	beqz	a0,80005ecc <net_rx+0x8e>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005ec0:	00054703          	lbu	a4,0(a0)
    80005ec4:	04500793          	li	a5,69
    80005ec8:	00f70863          	beq	a4,a5,80005ed8 <net_rx+0x9a>
  kfree(m);
    80005ecc:	8526                	mv	a0,s1
    80005ece:	ffffa097          	auipc	ra,0xffffa
    80005ed2:	14e080e7          	jalr	334(ra) # 8000001c <kfree>
}
    80005ed6:	bf75                	j	80005e92 <net_rx+0x54>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005ed8:	45d1                	li	a1,20
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	bf4080e7          	jalr	-1036(ra) # 80005ace <in_cksum>
    80005ee2:	f56d                	bnez	a0,80005ecc <net_rx+0x8e>
    80005ee4:	00695783          	lhu	a5,6(s2)
    80005ee8:	0087d713          	srli	a4,a5,0x8
    80005eec:	0087979b          	slliw	a5,a5,0x8
    80005ef0:	0ff77713          	andi	a4,a4,255
    80005ef4:	8fd9                	or	a5,a5,a4
  if (htons(iphdr->ip_off) != 0)
    80005ef6:	17c2                	slli	a5,a5,0x30
    80005ef8:	93c1                	srli	a5,a5,0x30
    80005efa:	fbe9                	bnez	a5,80005ecc <net_rx+0x8e>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005efc:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005f00:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005f04:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005f08:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005f0a:	0087169b          	slliw	a3,a4,0x8
    80005f0e:	00ff0637          	lui	a2,0xff0
    80005f12:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005f14:	8fd5                	or	a5,a5,a3
    80005f16:	0087571b          	srliw	a4,a4,0x8
    80005f1a:	66c1                	lui	a3,0x10
    80005f1c:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005f20:	8f75                	and	a4,a4,a3
    80005f22:	8fd9                	or	a5,a5,a4
    80005f24:	2781                	sext.w	a5,a5
    80005f26:	0a000737          	lui	a4,0xa000
    80005f2a:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005f2e:	f8e79fe3          	bne	a5,a4,80005ecc <net_rx+0x8e>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005f32:	00994703          	lbu	a4,9(s2)
    80005f36:	47c5                	li	a5,17
    80005f38:	f8f71ae3          	bne	a4,a5,80005ecc <net_rx+0x8e>
  return (((val & 0x00ffU) << 8) |
    80005f3c:	00295783          	lhu	a5,2(s2)
    80005f40:	0087d713          	srli	a4,a5,0x8
    80005f44:	0087999b          	slliw	s3,a5,0x8
    80005f48:	0ff77793          	andi	a5,a4,255
    80005f4c:	00f9e9b3          	or	s3,s3,a5
    80005f50:	19c2                	slli	s3,s3,0x30
    80005f52:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005f56:	fec9879b          	addiw	a5,s3,-20
    80005f5a:	03079a13          	slli	s4,a5,0x30
    80005f5e:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80005f62:	45a1                	li	a1,8
    80005f64:	8526                	mv	a0,s1
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	bdc080e7          	jalr	-1060(ra) # 80005b42 <mbufpull>
    80005f6e:	8aaa                	mv	s5,a0
  if (!udphdr)
    80005f70:	c915                	beqz	a0,80005fa4 <net_rx+0x166>
    80005f72:	00455783          	lhu	a5,4(a0)
    80005f76:	0087d713          	srli	a4,a5,0x8
    80005f7a:	0087979b          	slliw	a5,a5,0x8
    80005f7e:	0ff77713          	andi	a4,a4,255
    80005f82:	8fd9                	or	a5,a5,a4
  if (ntohs(udphdr->ulen) != len)
    80005f84:	2a01                	sext.w	s4,s4
    80005f86:	17c2                	slli	a5,a5,0x30
    80005f88:	93c1                	srli	a5,a5,0x30
    80005f8a:	00fa1d63          	bne	s4,a5,80005fa4 <net_rx+0x166>
  len -= sizeof(*udphdr);
    80005f8e:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    80005f92:	0107979b          	slliw	a5,a5,0x10
    80005f96:	0107d79b          	srliw	a5,a5,0x10
    80005f9a:	0007871b          	sext.w	a4,a5
    80005f9e:	488c                	lw	a1,16(s1)
    80005fa0:	00e5f863          	bgeu	a1,a4,80005fb0 <net_rx+0x172>
  kfree(m);
    80005fa4:	8526                	mv	a0,s1
    80005fa6:	ffffa097          	auipc	ra,0xffffa
    80005faa:	076080e7          	jalr	118(ra) # 8000001c <kfree>
}
    80005fae:	b5d5                	j	80005e92 <net_rx+0x54>
  mbuftrim(m, m->len - len);
    80005fb0:	9d9d                	subw	a1,a1,a5
    80005fb2:	8526                	mv	a0,s1
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	c9c080e7          	jalr	-868(ra) # 80005c50 <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    80005fbc:	00c92783          	lw	a5,12(s2)
    80005fc0:	000ad703          	lhu	a4,0(s5)
    80005fc4:	00875693          	srli	a3,a4,0x8
    80005fc8:	0087171b          	slliw	a4,a4,0x8
    80005fcc:	0ff6f693          	andi	a3,a3,255
    80005fd0:	8ed9                	or	a3,a3,a4
    80005fd2:	002ad703          	lhu	a4,2(s5)
    80005fd6:	00875613          	srli	a2,a4,0x8
    80005fda:	0087171b          	slliw	a4,a4,0x8
    80005fde:	0ff67613          	andi	a2,a2,255
    80005fe2:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    80005fe4:	0187971b          	slliw	a4,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005fe8:	0187d59b          	srliw	a1,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005fec:	8f4d                	or	a4,a4,a1
          ((val & 0x0000ff00UL) << 8) |
    80005fee:	0087959b          	slliw	a1,a5,0x8
    80005ff2:	00ff0537          	lui	a0,0xff0
    80005ff6:	8de9                	and	a1,a1,a0
          ((val & 0x00ff0000UL) >> 8) |
    80005ff8:	8f4d                	or	a4,a4,a1
    80005ffa:	0087d79b          	srliw	a5,a5,0x8
    80005ffe:	65c1                	lui	a1,0x10
    80006000:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80006004:	8fed                	and	a5,a5,a1
    80006006:	8fd9                	or	a5,a5,a4
  sockrecvudp(m, sip, dport, sport);
    80006008:	16c2                	slli	a3,a3,0x30
    8000600a:	92c1                	srli	a3,a3,0x30
    8000600c:	1642                	slli	a2,a2,0x30
    8000600e:	9241                	srli	a2,a2,0x30
    80006010:	0007859b          	sext.w	a1,a5
    80006014:	8526                	mv	a0,s1
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	55c080e7          	jalr	1372(ra) # 80006572 <sockrecvudp>
  return;
    8000601e:	bd95                	j	80005e92 <net_rx+0x54>
  arphdr = mbufpullhdr(m, *arphdr);
    80006020:	45f1                	li	a1,28
    80006022:	8526                	mv	a0,s1
    80006024:	00000097          	auipc	ra,0x0
    80006028:	b1e080e7          	jalr	-1250(ra) # 80005b42 <mbufpull>
    8000602c:	892a                	mv	s2,a0
  if (!arphdr)
    8000602e:	c179                	beqz	a0,800060f4 <net_rx+0x2b6>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80006030:	00054783          	lbu	a5,0(a0) # ff0000 <_entry-0x7f010000>
    80006034:	00154703          	lbu	a4,1(a0)
    80006038:	0722                	slli	a4,a4,0x8
    8000603a:	8fd9                	or	a5,a5,a4
  return (((val & 0x00ffU) << 8) |
    8000603c:	0087979b          	slliw	a5,a5,0x8
    80006040:	8321                	srli	a4,a4,0x8
    80006042:	8fd9                	or	a5,a5,a4
    80006044:	17c2                	slli	a5,a5,0x30
    80006046:	93c1                	srli	a5,a5,0x30
    80006048:	4705                	li	a4,1
    8000604a:	0ae79563          	bne	a5,a4,800060f4 <net_rx+0x2b6>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    8000604e:	00254783          	lbu	a5,2(a0)
    80006052:	00354703          	lbu	a4,3(a0)
    80006056:	0722                	slli	a4,a4,0x8
    80006058:	8fd9                	or	a5,a5,a4
    8000605a:	0087979b          	slliw	a5,a5,0x8
    8000605e:	8321                	srli	a4,a4,0x8
    80006060:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80006062:	0107979b          	slliw	a5,a5,0x10
    80006066:	0107d79b          	srliw	a5,a5,0x10
    8000606a:	8007879b          	addiw	a5,a5,-2048
    8000606e:	e3d9                	bnez	a5,800060f4 <net_rx+0x2b6>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80006070:	00454703          	lbu	a4,4(a0)
    80006074:	4799                	li	a5,6
    80006076:	06f71f63          	bne	a4,a5,800060f4 <net_rx+0x2b6>
      arphdr->hln != ETHADDR_LEN ||
    8000607a:	00554703          	lbu	a4,5(a0)
    8000607e:	4791                	li	a5,4
    80006080:	06f71a63          	bne	a4,a5,800060f4 <net_rx+0x2b6>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80006084:	00654783          	lbu	a5,6(a0)
    80006088:	00754703          	lbu	a4,7(a0)
    8000608c:	0722                	slli	a4,a4,0x8
    8000608e:	8fd9                	or	a5,a5,a4
    80006090:	0087979b          	slliw	a5,a5,0x8
    80006094:	8321                	srli	a4,a4,0x8
    80006096:	8fd9                	or	a5,a5,a4
    80006098:	17c2                	slli	a5,a5,0x30
    8000609a:	93c1                	srli	a5,a5,0x30
    8000609c:	4705                	li	a4,1
    8000609e:	04e79b63          	bne	a5,a4,800060f4 <net_rx+0x2b6>
  tip = ntohl(arphdr->tip); // target IP address
    800060a2:	01854783          	lbu	a5,24(a0)
    800060a6:	01954703          	lbu	a4,25(a0)
    800060aa:	0722                	slli	a4,a4,0x8
    800060ac:	8f5d                	or	a4,a4,a5
    800060ae:	01a54783          	lbu	a5,26(a0)
    800060b2:	07c2                	slli	a5,a5,0x10
    800060b4:	8f5d                	or	a4,a4,a5
    800060b6:	01b54783          	lbu	a5,27(a0)
    800060ba:	07e2                	slli	a5,a5,0x18
    800060bc:	8fd9                	or	a5,a5,a4
    800060be:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    800060c2:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800060c6:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800060ca:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    800060cc:	0087169b          	slliw	a3,a4,0x8
    800060d0:	00ff0637          	lui	a2,0xff0
    800060d4:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    800060d6:	8fd5                	or	a5,a5,a3
    800060d8:	0087571b          	srliw	a4,a4,0x8
    800060dc:	66c1                	lui	a3,0x10
    800060de:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800060e2:	8f75                	and	a4,a4,a3
    800060e4:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    800060e6:	2781                	sext.w	a5,a5
    800060e8:	0a000737          	lui	a4,0xa000
    800060ec:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    800060f0:	00e78863          	beq	a5,a4,80006100 <net_rx+0x2c2>
  kfree(m);
    800060f4:	8526                	mv	a0,s1
    800060f6:	ffffa097          	auipc	ra,0xffffa
    800060fa:	f26080e7          	jalr	-218(ra) # 8000001c <kfree>
}
    800060fe:	bb51                	j	80005e92 <net_rx+0x54>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    80006100:	4619                	li	a2,6
    80006102:	00850593          	addi	a1,a0,8
    80006106:	fb840513          	addi	a0,s0,-72
    8000610a:	ffffa097          	auipc	ra,0xffffa
    8000610e:	0ce080e7          	jalr	206(ra) # 800001d8 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    80006112:	00e94783          	lbu	a5,14(s2)
    80006116:	00f94703          	lbu	a4,15(s2)
    8000611a:	0722                	slli	a4,a4,0x8
    8000611c:	8f5d                	or	a4,a4,a5
    8000611e:	01094783          	lbu	a5,16(s2)
    80006122:	07c2                	slli	a5,a5,0x10
    80006124:	8f5d                	or	a4,a4,a5
    80006126:	01194783          	lbu	a5,17(s2)
    8000612a:	07e2                	slli	a5,a5,0x18
    8000612c:	8fd9                	or	a5,a5,a4
    8000612e:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    80006132:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80006136:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    8000613a:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    8000613e:	0087179b          	slliw	a5,a4,0x8
    80006142:	00ff06b7          	lui	a3,0xff0
    80006146:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    80006148:	00f96933          	or	s2,s2,a5
    8000614c:	0087579b          	srliw	a5,a4,0x8
    80006150:	6741                	lui	a4,0x10
    80006152:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80006156:	8ff9                	and	a5,a5,a4
    80006158:	00f96933          	or	s2,s2,a5
    8000615c:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    8000615e:	08000513          	li	a0,128
    80006162:	00000097          	auipc	ra,0x0
    80006166:	b10080e7          	jalr	-1264(ra) # 80005c72 <mbufalloc>
    8000616a:	8a2a                	mv	s4,a0
  if (!m)
    8000616c:	d541                	beqz	a0,800060f4 <net_rx+0x2b6>
  arphdr = mbufputhdr(m, *arphdr);
    8000616e:	45f1                	li	a1,28
    80006170:	00000097          	auipc	ra,0x0
    80006174:	aa6080e7          	jalr	-1370(ra) # 80005c16 <mbufput>
    80006178:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    8000617a:	00050023          	sb	zero,0(a0)
    8000617e:	4785                	li	a5,1
    80006180:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    80006184:	47a1                	li	a5,8
    80006186:	00f50123          	sb	a5,2(a0)
    8000618a:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    8000618e:	4799                	li	a5,6
    80006190:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    80006194:	4791                	li	a5,4
    80006196:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    8000619a:	00050323          	sb	zero,6(a0)
    8000619e:	4a89                	li	s5,2
    800061a0:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    800061a4:	4619                	li	a2,6
    800061a6:	00003597          	auipc	a1,0x3
    800061aa:	6ea58593          	addi	a1,a1,1770 # 80009890 <local_mac>
    800061ae:	0521                	addi	a0,a0,8
    800061b0:	ffffa097          	auipc	ra,0xffffa
    800061b4:	028080e7          	jalr	40(ra) # 800001d8 <memmove>
  arphdr->sip = htonl(local_ip);
    800061b8:	47a9                	li	a5,10
    800061ba:	00f98723          	sb	a5,14(s3)
    800061be:	000987a3          	sb	zero,15(s3)
    800061c2:	01598823          	sb	s5,16(s3)
    800061c6:	47bd                	li	a5,15
    800061c8:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    800061cc:	4619                	li	a2,6
    800061ce:	fb840593          	addi	a1,s0,-72
    800061d2:	01298513          	addi	a0,s3,18
    800061d6:	ffffa097          	auipc	ra,0xffffa
    800061da:	002080e7          	jalr	2(ra) # 800001d8 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    800061de:	0189171b          	slliw	a4,s2,0x18
          ((val & 0xff000000UL) >> 24));
    800061e2:	0189579b          	srliw	a5,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800061e6:	8f5d                	or	a4,a4,a5
          ((val & 0x0000ff00UL) << 8) |
    800061e8:	0089179b          	slliw	a5,s2,0x8
    800061ec:	00ff06b7          	lui	a3,0xff0
    800061f0:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    800061f2:	8f5d                	or	a4,a4,a5
    800061f4:	0089579b          	srliw	a5,s2,0x8
    800061f8:	66c1                	lui	a3,0x10
    800061fa:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800061fe:	8ff5                	and	a5,a5,a3
    80006200:	8fd9                	or	a5,a5,a4
  arphdr->tip = htonl(dip);
    80006202:	00e98c23          	sb	a4,24(s3)
    80006206:	0087d71b          	srliw	a4,a5,0x8
    8000620a:	00e98ca3          	sb	a4,25(s3)
    8000620e:	0107d71b          	srliw	a4,a5,0x10
    80006212:	00e98d23          	sb	a4,26(s3)
    80006216:	0187d79b          	srliw	a5,a5,0x18
    8000621a:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    8000621e:	6585                	lui	a1,0x1
    80006220:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    80006224:	8552                	mv	a0,s4
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	978080e7          	jalr	-1672(ra) # 80005b9e <net_tx_eth>
  return 0;
    8000622e:	b5d9                	j	800060f4 <net_rx+0x2b6>

0000000080006230 <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    80006230:	1141                	addi	sp,sp,-16
    80006232:	e406                	sd	ra,8(sp)
    80006234:	e022                	sd	s0,0(sp)
    80006236:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    80006238:	00003597          	auipc	a1,0x3
    8000623c:	5a058593          	addi	a1,a1,1440 # 800097d8 <syscalls+0x428>
    80006240:	00019517          	auipc	a0,0x19
    80006244:	0e050513          	addi	a0,a0,224 # 8001f320 <lock>
    80006248:	00001097          	auipc	ra,0x1
    8000624c:	e80080e7          	jalr	-384(ra) # 800070c8 <initlock>
}
    80006250:	60a2                	ld	ra,8(sp)
    80006252:	6402                	ld	s0,0(sp)
    80006254:	0141                	addi	sp,sp,16
    80006256:	8082                	ret

0000000080006258 <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    80006258:	7139                	addi	sp,sp,-64
    8000625a:	fc06                	sd	ra,56(sp)
    8000625c:	f822                	sd	s0,48(sp)
    8000625e:	f426                	sd	s1,40(sp)
    80006260:	f04a                	sd	s2,32(sp)
    80006262:	ec4e                	sd	s3,24(sp)
    80006264:	e852                	sd	s4,16(sp)
    80006266:	e456                	sd	s5,8(sp)
    80006268:	0080                	addi	s0,sp,64
    8000626a:	892a                	mv	s2,a0
    8000626c:	84ae                	mv	s1,a1
    8000626e:	8a32                	mv	s4,a2
    80006270:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    80006272:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    80006276:	ffffd097          	auipc	ra,0xffffd
    8000627a:	696080e7          	jalr	1686(ra) # 8000390c <filealloc>
    8000627e:	00a93023          	sd	a0,0(s2)
    80006282:	c975                	beqz	a0,80006376 <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    80006284:	ffffa097          	auipc	ra,0xffffa
    80006288:	e94080e7          	jalr	-364(ra) # 80000118 <kalloc>
    8000628c:	8aaa                	mv	s5,a0
    8000628e:	c15d                	beqz	a0,80006334 <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    80006290:	c504                	sw	s1,8(a0)
  si->lport = lport;
    80006292:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    80006296:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    8000629a:	00003597          	auipc	a1,0x3
    8000629e:	54658593          	addi	a1,a1,1350 # 800097e0 <syscalls+0x430>
    800062a2:	0541                	addi	a0,a0,16
    800062a4:	00001097          	auipc	ra,0x1
    800062a8:	e24080e7          	jalr	-476(ra) # 800070c8 <initlock>
  mbufq_init(&si->rxq);
    800062ac:	028a8513          	addi	a0,s5,40
    800062b0:	00000097          	auipc	ra,0x0
    800062b4:	a7a080e7          	jalr	-1414(ra) # 80005d2a <mbufq_init>
  (*f)->type = FD_SOCK;
    800062b8:	00093783          	ld	a5,0(s2)
    800062bc:	4711                	li	a4,4
    800062be:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    800062c0:	00093703          	ld	a4,0(s2)
    800062c4:	4785                	li	a5,1
    800062c6:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    800062ca:	00093703          	ld	a4,0(s2)
    800062ce:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    800062d2:	00093783          	ld	a5,0(s2)
    800062d6:	0357b023          	sd	s5,32(a5) # f020020 <_entry-0x70fdffe0>

  // add to list of sockets
  acquire(&lock);
    800062da:	00019517          	auipc	a0,0x19
    800062de:	04650513          	addi	a0,a0,70 # 8001f320 <lock>
    800062e2:	00001097          	auipc	ra,0x1
    800062e6:	e76080e7          	jalr	-394(ra) # 80007158 <acquire>
  pos = sockets;
    800062ea:	00004597          	auipc	a1,0x4
    800062ee:	d3e5b583          	ld	a1,-706(a1) # 8000a028 <sockets>
  while (pos) {
    800062f2:	c9b1                	beqz	a1,80006346 <sockalloc+0xee>
  pos = sockets;
    800062f4:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    800062f6:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    800062fa:	0009869b          	sext.w	a3,s3
    800062fe:	a019                	j	80006304 <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    80006300:	639c                	ld	a5,0(a5)
  while (pos) {
    80006302:	c3b1                	beqz	a5,80006346 <sockalloc+0xee>
    if (pos->raddr == raddr &&
    80006304:	4798                	lw	a4,8(a5)
    80006306:	fe971de3          	bne	a4,s1,80006300 <sockalloc+0xa8>
    8000630a:	00c7d703          	lhu	a4,12(a5)
    8000630e:	fec719e3          	bne	a4,a2,80006300 <sockalloc+0xa8>
        pos->lport == lport &&
    80006312:	00e7d703          	lhu	a4,14(a5)
    80006316:	fed715e3          	bne	a4,a3,80006300 <sockalloc+0xa8>
      release(&lock);
    8000631a:	00019517          	auipc	a0,0x19
    8000631e:	00650513          	addi	a0,a0,6 # 8001f320 <lock>
    80006322:	00001097          	auipc	ra,0x1
    80006326:	eea080e7          	jalr	-278(ra) # 8000720c <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    8000632a:	8556                	mv	a0,s5
    8000632c:	ffffa097          	auipc	ra,0xffffa
    80006330:	cf0080e7          	jalr	-784(ra) # 8000001c <kfree>
  if (*f)
    80006334:	00093503          	ld	a0,0(s2)
    80006338:	c129                	beqz	a0,8000637a <sockalloc+0x122>
    fileclose(*f);
    8000633a:	ffffd097          	auipc	ra,0xffffd
    8000633e:	68e080e7          	jalr	1678(ra) # 800039c8 <fileclose>
  return -1;
    80006342:	557d                	li	a0,-1
    80006344:	a005                	j	80006364 <sockalloc+0x10c>
  si->next = sockets;
    80006346:	00bab023          	sd	a1,0(s5)
  sockets = si;
    8000634a:	00004797          	auipc	a5,0x4
    8000634e:	cd57bf23          	sd	s5,-802(a5) # 8000a028 <sockets>
  release(&lock);
    80006352:	00019517          	auipc	a0,0x19
    80006356:	fce50513          	addi	a0,a0,-50 # 8001f320 <lock>
    8000635a:	00001097          	auipc	ra,0x1
    8000635e:	eb2080e7          	jalr	-334(ra) # 8000720c <release>
  return 0;
    80006362:	4501                	li	a0,0
}
    80006364:	70e2                	ld	ra,56(sp)
    80006366:	7442                	ld	s0,48(sp)
    80006368:	74a2                	ld	s1,40(sp)
    8000636a:	7902                	ld	s2,32(sp)
    8000636c:	69e2                	ld	s3,24(sp)
    8000636e:	6a42                	ld	s4,16(sp)
    80006370:	6aa2                	ld	s5,8(sp)
    80006372:	6121                	addi	sp,sp,64
    80006374:	8082                	ret
  return -1;
    80006376:	557d                	li	a0,-1
    80006378:	b7f5                	j	80006364 <sockalloc+0x10c>
    8000637a:	557d                	li	a0,-1
    8000637c:	b7e5                	j	80006364 <sockalloc+0x10c>

000000008000637e <sockclose>:

void
sockclose(struct sock *si)
{
    8000637e:	1101                	addi	sp,sp,-32
    80006380:	ec06                	sd	ra,24(sp)
    80006382:	e822                	sd	s0,16(sp)
    80006384:	e426                	sd	s1,8(sp)
    80006386:	e04a                	sd	s2,0(sp)
    80006388:	1000                	addi	s0,sp,32
    8000638a:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    8000638c:	00019517          	auipc	a0,0x19
    80006390:	f9450513          	addi	a0,a0,-108 # 8001f320 <lock>
    80006394:	00001097          	auipc	ra,0x1
    80006398:	dc4080e7          	jalr	-572(ra) # 80007158 <acquire>
  pos = &sockets;
    8000639c:	00004797          	auipc	a5,0x4
    800063a0:	c8c7b783          	ld	a5,-884(a5) # 8000a028 <sockets>
  while (*pos) {
    800063a4:	cb99                	beqz	a5,800063ba <sockclose+0x3c>
    if (*pos == si){
    800063a6:	02f90563          	beq	s2,a5,800063d0 <sockclose+0x52>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    800063aa:	873e                	mv	a4,a5
    800063ac:	639c                	ld	a5,0(a5)
  while (*pos) {
    800063ae:	c791                	beqz	a5,800063ba <sockclose+0x3c>
    if (*pos == si){
    800063b0:	fef91de3          	bne	s2,a5,800063aa <sockclose+0x2c>
      *pos = si->next;
    800063b4:	00093783          	ld	a5,0(s2)
    800063b8:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    800063ba:	00019517          	auipc	a0,0x19
    800063be:	f6650513          	addi	a0,a0,-154 # 8001f320 <lock>
    800063c2:	00001097          	auipc	ra,0x1
    800063c6:	e4a080e7          	jalr	-438(ra) # 8000720c <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    800063ca:	02890493          	addi	s1,s2,40
    800063ce:	a839                	j	800063ec <sockclose+0x6e>
  pos = &sockets;
    800063d0:	00004717          	auipc	a4,0x4
    800063d4:	c5870713          	addi	a4,a4,-936 # 8000a028 <sockets>
    800063d8:	bff1                	j	800063b4 <sockclose+0x36>
    m = mbufq_pophead(&si->rxq);
    800063da:	8526                	mv	a0,s1
    800063dc:	00000097          	auipc	ra,0x0
    800063e0:	926080e7          	jalr	-1754(ra) # 80005d02 <mbufq_pophead>
    mbuffree(m);
    800063e4:	00000097          	auipc	ra,0x0
    800063e8:	8e6080e7          	jalr	-1818(ra) # 80005cca <mbuffree>
  while (!mbufq_empty(&si->rxq)) {
    800063ec:	8526                	mv	a0,s1
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	92a080e7          	jalr	-1750(ra) # 80005d18 <mbufq_empty>
    800063f6:	d175                	beqz	a0,800063da <sockclose+0x5c>
  }

  kfree((char*)si);
    800063f8:	854a                	mv	a0,s2
    800063fa:	ffffa097          	auipc	ra,0xffffa
    800063fe:	c22080e7          	jalr	-990(ra) # 8000001c <kfree>
}
    80006402:	60e2                	ld	ra,24(sp)
    80006404:	6442                	ld	s0,16(sp)
    80006406:	64a2                	ld	s1,8(sp)
    80006408:	6902                	ld	s2,0(sp)
    8000640a:	6105                	addi	sp,sp,32
    8000640c:	8082                	ret

000000008000640e <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    8000640e:	7139                	addi	sp,sp,-64
    80006410:	fc06                	sd	ra,56(sp)
    80006412:	f822                	sd	s0,48(sp)
    80006414:	f426                	sd	s1,40(sp)
    80006416:	f04a                	sd	s2,32(sp)
    80006418:	ec4e                	sd	s3,24(sp)
    8000641a:	e852                	sd	s4,16(sp)
    8000641c:	e456                	sd	s5,8(sp)
    8000641e:	0080                	addi	s0,sp,64
    80006420:	84aa                	mv	s1,a0
    80006422:	8a2e                	mv	s4,a1
    80006424:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    80006426:	ffffb097          	auipc	ra,0xffffb
    8000642a:	a9c080e7          	jalr	-1380(ra) # 80000ec2 <myproc>
    8000642e:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    80006430:	01048993          	addi	s3,s1,16
    80006434:	854e                	mv	a0,s3
    80006436:	00001097          	auipc	ra,0x1
    8000643a:	d22080e7          	jalr	-734(ra) # 80007158 <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    8000643e:	02848493          	addi	s1,s1,40
    80006442:	8526                	mv	a0,s1
    80006444:	00000097          	auipc	ra,0x0
    80006448:	8d4080e7          	jalr	-1836(ra) # 80005d18 <mbufq_empty>
    8000644c:	c919                	beqz	a0,80006462 <sockread+0x54>
    8000644e:	03092783          	lw	a5,48(s2)
    80006452:	eba5                	bnez	a5,800064c2 <sockread+0xb4>
    sleep(&si->rxq, &si->lock);
    80006454:	85ce                	mv	a1,s3
    80006456:	8526                	mv	a0,s1
    80006458:	ffffb097          	auipc	ra,0xffffb
    8000645c:	27a080e7          	jalr	634(ra) # 800016d2 <sleep>
    80006460:	b7cd                	j	80006442 <sockread+0x34>
  }
  if (pr->killed) {
    80006462:	03092783          	lw	a5,48(s2)
    80006466:	efb1                	bnez	a5,800064c2 <sockread+0xb4>
    release(&si->lock);
    return -1;
  }
  m = mbufq_pophead(&si->rxq);
    80006468:	8526                	mv	a0,s1
    8000646a:	00000097          	auipc	ra,0x0
    8000646e:	898080e7          	jalr	-1896(ra) # 80005d02 <mbufq_pophead>
    80006472:	84aa                	mv	s1,a0
  release(&si->lock);
    80006474:	854e                	mv	a0,s3
    80006476:	00001097          	auipc	ra,0x1
    8000647a:	d96080e7          	jalr	-618(ra) # 8000720c <release>

  len = m->len;
    8000647e:	489c                	lw	a5,16(s1)
  if (len > n)
    80006480:	89be                	mv	s3,a5
    80006482:	00fad363          	bge	s5,a5,80006488 <sockread+0x7a>
    80006486:	89d6                	mv	s3,s5
    80006488:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    8000648a:	86ce                	mv	a3,s3
    8000648c:	6490                	ld	a2,8(s1)
    8000648e:	85d2                	mv	a1,s4
    80006490:	05093503          	ld	a0,80(s2)
    80006494:	ffffa097          	auipc	ra,0xffffa
    80006498:	6c4080e7          	jalr	1732(ra) # 80000b58 <copyout>
    8000649c:	892a                	mv	s2,a0
    8000649e:	57fd                	li	a5,-1
    800064a0:	02f50863          	beq	a0,a5,800064d0 <sockread+0xc2>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    800064a4:	8526                	mv	a0,s1
    800064a6:	00000097          	auipc	ra,0x0
    800064aa:	824080e7          	jalr	-2012(ra) # 80005cca <mbuffree>
  return len;
}
    800064ae:	854e                	mv	a0,s3
    800064b0:	70e2                	ld	ra,56(sp)
    800064b2:	7442                	ld	s0,48(sp)
    800064b4:	74a2                	ld	s1,40(sp)
    800064b6:	7902                	ld	s2,32(sp)
    800064b8:	69e2                	ld	s3,24(sp)
    800064ba:	6a42                	ld	s4,16(sp)
    800064bc:	6aa2                	ld	s5,8(sp)
    800064be:	6121                	addi	sp,sp,64
    800064c0:	8082                	ret
    release(&si->lock);
    800064c2:	854e                	mv	a0,s3
    800064c4:	00001097          	auipc	ra,0x1
    800064c8:	d48080e7          	jalr	-696(ra) # 8000720c <release>
    return -1;
    800064cc:	59fd                	li	s3,-1
    800064ce:	b7c5                	j	800064ae <sockread+0xa0>
    mbuffree(m);
    800064d0:	8526                	mv	a0,s1
    800064d2:	fffff097          	auipc	ra,0xfffff
    800064d6:	7f8080e7          	jalr	2040(ra) # 80005cca <mbuffree>
    return -1;
    800064da:	89ca                	mv	s3,s2
    800064dc:	bfc9                	j	800064ae <sockread+0xa0>

00000000800064de <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    800064de:	7139                	addi	sp,sp,-64
    800064e0:	fc06                	sd	ra,56(sp)
    800064e2:	f822                	sd	s0,48(sp)
    800064e4:	f426                	sd	s1,40(sp)
    800064e6:	f04a                	sd	s2,32(sp)
    800064e8:	ec4e                	sd	s3,24(sp)
    800064ea:	e852                	sd	s4,16(sp)
    800064ec:	e456                	sd	s5,8(sp)
    800064ee:	0080                	addi	s0,sp,64
    800064f0:	8aaa                	mv	s5,a0
    800064f2:	89ae                	mv	s3,a1
    800064f4:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    800064f6:	ffffb097          	auipc	ra,0xffffb
    800064fa:	9cc080e7          	jalr	-1588(ra) # 80000ec2 <myproc>
    800064fe:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    80006500:	08000513          	li	a0,128
    80006504:	fffff097          	auipc	ra,0xfffff
    80006508:	76e080e7          	jalr	1902(ra) # 80005c72 <mbufalloc>
  if (!m)
    8000650c:	c12d                	beqz	a0,8000656e <sockwrite+0x90>
    8000650e:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    80006510:	050a3a03          	ld	s4,80(s4)
    80006514:	85ca                	mv	a1,s2
    80006516:	fffff097          	auipc	ra,0xfffff
    8000651a:	700080e7          	jalr	1792(ra) # 80005c16 <mbufput>
    8000651e:	85aa                	mv	a1,a0
    80006520:	86ca                	mv	a3,s2
    80006522:	864e                	mv	a2,s3
    80006524:	8552                	mv	a0,s4
    80006526:	ffffa097          	auipc	ra,0xffffa
    8000652a:	6be080e7          	jalr	1726(ra) # 80000be4 <copyin>
    8000652e:	89aa                	mv	s3,a0
    80006530:	57fd                	li	a5,-1
    80006532:	02f50863          	beq	a0,a5,80006562 <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    80006536:	00ead683          	lhu	a3,14(s5)
    8000653a:	00cad603          	lhu	a2,12(s5)
    8000653e:	008aa583          	lw	a1,8(s5)
    80006542:	8526                	mv	a0,s1
    80006544:	fffff097          	auipc	ra,0xfffff
    80006548:	7f6080e7          	jalr	2038(ra) # 80005d3a <net_tx_udp>
  return n;
    8000654c:	89ca                	mv	s3,s2
}
    8000654e:	854e                	mv	a0,s3
    80006550:	70e2                	ld	ra,56(sp)
    80006552:	7442                	ld	s0,48(sp)
    80006554:	74a2                	ld	s1,40(sp)
    80006556:	7902                	ld	s2,32(sp)
    80006558:	69e2                	ld	s3,24(sp)
    8000655a:	6a42                	ld	s4,16(sp)
    8000655c:	6aa2                	ld	s5,8(sp)
    8000655e:	6121                	addi	sp,sp,64
    80006560:	8082                	ret
    mbuffree(m);
    80006562:	8526                	mv	a0,s1
    80006564:	fffff097          	auipc	ra,0xfffff
    80006568:	766080e7          	jalr	1894(ra) # 80005cca <mbuffree>
    return -1;
    8000656c:	b7cd                	j	8000654e <sockwrite+0x70>
    return -1;
    8000656e:	59fd                	li	s3,-1
    80006570:	bff9                	j	8000654e <sockwrite+0x70>

0000000080006572 <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    80006572:	7139                	addi	sp,sp,-64
    80006574:	fc06                	sd	ra,56(sp)
    80006576:	f822                	sd	s0,48(sp)
    80006578:	f426                	sd	s1,40(sp)
    8000657a:	f04a                	sd	s2,32(sp)
    8000657c:	ec4e                	sd	s3,24(sp)
    8000657e:	e852                	sd	s4,16(sp)
    80006580:	e456                	sd	s5,8(sp)
    80006582:	0080                	addi	s0,sp,64
    80006584:	8a2a                	mv	s4,a0
    80006586:	892e                	mv	s2,a1
    80006588:	89b2                	mv	s3,a2
    8000658a:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    8000658c:	00019517          	auipc	a0,0x19
    80006590:	d9450513          	addi	a0,a0,-620 # 8001f320 <lock>
    80006594:	00001097          	auipc	ra,0x1
    80006598:	bc4080e7          	jalr	-1084(ra) # 80007158 <acquire>
  si = sockets;
    8000659c:	00004497          	auipc	s1,0x4
    800065a0:	a8c4b483          	ld	s1,-1396(s1) # 8000a028 <sockets>
  while (si) {
    800065a4:	c4ad                	beqz	s1,8000660e <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    800065a6:	0009871b          	sext.w	a4,s3
    800065aa:	000a869b          	sext.w	a3,s5
    800065ae:	a019                	j	800065b4 <sockrecvudp+0x42>
      goto found;
    si = si->next;
    800065b0:	6084                	ld	s1,0(s1)
  while (si) {
    800065b2:	ccb1                	beqz	s1,8000660e <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    800065b4:	449c                	lw	a5,8(s1)
    800065b6:	ff279de3          	bne	a5,s2,800065b0 <sockrecvudp+0x3e>
    800065ba:	00c4d783          	lhu	a5,12(s1)
    800065be:	fee799e3          	bne	a5,a4,800065b0 <sockrecvudp+0x3e>
    800065c2:	00e4d783          	lhu	a5,14(s1)
    800065c6:	fed795e3          	bne	a5,a3,800065b0 <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    800065ca:	01048913          	addi	s2,s1,16
    800065ce:	854a                	mv	a0,s2
    800065d0:	00001097          	auipc	ra,0x1
    800065d4:	b88080e7          	jalr	-1144(ra) # 80007158 <acquire>
  mbufq_pushtail(&si->rxq, m);
    800065d8:	02848493          	addi	s1,s1,40
    800065dc:	85d2                	mv	a1,s4
    800065de:	8526                	mv	a0,s1
    800065e0:	fffff097          	auipc	ra,0xfffff
    800065e4:	702080e7          	jalr	1794(ra) # 80005ce2 <mbufq_pushtail>
  wakeup(&si->rxq);
    800065e8:	8526                	mv	a0,s1
    800065ea:	ffffb097          	auipc	ra,0xffffb
    800065ee:	26e080e7          	jalr	622(ra) # 80001858 <wakeup>
  release(&si->lock);
    800065f2:	854a                	mv	a0,s2
    800065f4:	00001097          	auipc	ra,0x1
    800065f8:	c18080e7          	jalr	-1000(ra) # 8000720c <release>
  release(&lock);
    800065fc:	00019517          	auipc	a0,0x19
    80006600:	d2450513          	addi	a0,a0,-732 # 8001f320 <lock>
    80006604:	00001097          	auipc	ra,0x1
    80006608:	c08080e7          	jalr	-1016(ra) # 8000720c <release>
    8000660c:	a831                	j	80006628 <sockrecvudp+0xb6>
  release(&lock);
    8000660e:	00019517          	auipc	a0,0x19
    80006612:	d1250513          	addi	a0,a0,-750 # 8001f320 <lock>
    80006616:	00001097          	auipc	ra,0x1
    8000661a:	bf6080e7          	jalr	-1034(ra) # 8000720c <release>
  mbuffree(m);
    8000661e:	8552                	mv	a0,s4
    80006620:	fffff097          	auipc	ra,0xfffff
    80006624:	6aa080e7          	jalr	1706(ra) # 80005cca <mbuffree>
}
    80006628:	70e2                	ld	ra,56(sp)
    8000662a:	7442                	ld	s0,48(sp)
    8000662c:	74a2                	ld	s1,40(sp)
    8000662e:	7902                	ld	s2,32(sp)
    80006630:	69e2                	ld	s3,24(sp)
    80006632:	6a42                	ld	s4,16(sp)
    80006634:	6aa2                	ld	s5,8(sp)
    80006636:	6121                	addi	sp,sp,64
    80006638:	8082                	ret

000000008000663a <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    8000663a:	7159                	addi	sp,sp,-112
    8000663c:	f486                	sd	ra,104(sp)
    8000663e:	f0a2                	sd	s0,96(sp)
    80006640:	eca6                	sd	s1,88(sp)
    80006642:	e8ca                	sd	s2,80(sp)
    80006644:	e4ce                	sd	s3,72(sp)
    80006646:	e0d2                	sd	s4,64(sp)
    80006648:	fc56                	sd	s5,56(sp)
    8000664a:	f85a                	sd	s6,48(sp)
    8000664c:	f45e                	sd	s7,40(sp)
    8000664e:	f062                	sd	s8,32(sp)
    80006650:	ec66                	sd	s9,24(sp)
    80006652:	e86a                	sd	s10,16(sp)
    80006654:	e46e                	sd	s11,8(sp)
    80006656:	1880                	addi	s0,sp,112
    80006658:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    8000665c:	100e8a37          	lui	s4,0x100e8
    80006660:	086a0a13          	addi	s4,s4,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80006664:	4d9d                	li	s11,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80006666:	5d7d                	li	s10,-1
        __sync_synchronize();
	
	printf("sz : %x\n", ~(base[4 + i] & 0xffffff00) + 1);
    80006668:	00003c97          	auipc	s9,0x3
    8000666c:	180c8c93          	addi	s9,s9,384 # 800097e8 <syscalls+0x438>
    80006670:	6b89                	lui	s7,0x2
  for(int dev = 0; dev < 32; dev++){
    80006672:	30040b37          	lui	s6,0x30040
    80006676:	a831                	j	80006692 <pci_init+0x58>
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80006678:	400007b7          	lui	a5,0x40000
    8000667c:	00faa823          	sw	a5,16(s5)

      e1000_init((uint32*)e1000_regs);
    80006680:	40000537          	lui	a0,0x40000
    80006684:	fffff097          	auipc	ra,0xfffff
    80006688:	10c080e7          	jalr	268(ra) # 80005790 <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    8000668c:	94de                	add	s1,s1,s7
    8000668e:	05648763          	beq	s1,s6,800066dc <pci_init+0xa2>
    volatile uint32 *base = ecam + off;
    80006692:	8aa6                	mv	s5,s1
    uint32 id = base[0];
    80006694:	409c                	lw	a5,0(s1)
    80006696:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    80006698:	ff479ae3          	bne	a5,s4,8000668c <pci_init+0x52>
      base[1] = 7;
    8000669c:	01b4a223          	sw	s11,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    800066a0:	0ff0000f          	fence
      for(int i = 0; i < 6; i++){
    800066a4:	01048913          	addi	s2,s1,16
    800066a8:	02848c13          	addi	s8,s1,40
        uint32 old = base[4+i];
    800066ac:	00092983          	lw	s3,0(s2)
    800066b0:	2981                	sext.w	s3,s3
        base[4+i] = 0xffffffff;
    800066b2:	01a92023          	sw	s10,0(s2)
        __sync_synchronize();
    800066b6:	0ff0000f          	fence
	printf("sz : %x\n", ~(base[4 + i] & 0xffffff00) + 1);
    800066ba:	00092583          	lw	a1,0(s2)
    800066be:	f005f593          	andi	a1,a1,-256
    800066c2:	40b005bb          	negw	a1,a1
    800066c6:	8566                	mv	a0,s9
    800066c8:	00000097          	auipc	ra,0x0
    800066cc:	590080e7          	jalr	1424(ra) # 80006c58 <printf>
        base[4+i] = old;
    800066d0:	01392023          	sw	s3,0(s2)
      for(int i = 0; i < 6; i++){
    800066d4:	0911                	addi	s2,s2,4
    800066d6:	fd891be3          	bne	s2,s8,800066ac <pci_init+0x72>
    800066da:	bf79                	j	80006678 <pci_init+0x3e>
    }
  }
}
    800066dc:	70a6                	ld	ra,104(sp)
    800066de:	7406                	ld	s0,96(sp)
    800066e0:	64e6                	ld	s1,88(sp)
    800066e2:	6946                	ld	s2,80(sp)
    800066e4:	69a6                	ld	s3,72(sp)
    800066e6:	6a06                	ld	s4,64(sp)
    800066e8:	7ae2                	ld	s5,56(sp)
    800066ea:	7b42                	ld	s6,48(sp)
    800066ec:	7ba2                	ld	s7,40(sp)
    800066ee:	7c02                	ld	s8,32(sp)
    800066f0:	6ce2                	ld	s9,24(sp)
    800066f2:	6d42                	ld	s10,16(sp)
    800066f4:	6da2                	ld	s11,8(sp)
    800066f6:	6165                	addi	sp,sp,112
    800066f8:	8082                	ret

00000000800066fa <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800066fa:	1141                	addi	sp,sp,-16
    800066fc:	e422                	sd	s0,8(sp)
    800066fe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80006700:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80006704:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80006708:	0037979b          	slliw	a5,a5,0x3
    8000670c:	02004737          	lui	a4,0x2004
    80006710:	97ba                	add	a5,a5,a4
    80006712:	0200c737          	lui	a4,0x200c
    80006716:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000671a:	000f4637          	lui	a2,0xf4
    8000671e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006722:	95b2                	add	a1,a1,a2
    80006724:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80006726:	00269713          	slli	a4,a3,0x2
    8000672a:	9736                	add	a4,a4,a3
    8000672c:	00371693          	slli	a3,a4,0x3
    80006730:	00019717          	auipc	a4,0x19
    80006734:	c1070713          	addi	a4,a4,-1008 # 8001f340 <timer_scratch>
    80006738:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000673a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000673c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000673e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80006742:	fffff797          	auipc	a5,0xfffff
    80006746:	9ee78793          	addi	a5,a5,-1554 # 80005130 <timervec>
    8000674a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000674e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80006752:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80006756:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000675a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000675e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80006762:	30479073          	csrw	mie,a5
}
    80006766:	6422                	ld	s0,8(sp)
    80006768:	0141                	addi	sp,sp,16
    8000676a:	8082                	ret

000000008000676c <start>:
{
    8000676c:	1141                	addi	sp,sp,-16
    8000676e:	e406                	sd	ra,8(sp)
    80006770:	e022                	sd	s0,0(sp)
    80006772:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80006774:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80006778:	7779                	lui	a4,0xffffe
    8000677a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd727f>
    8000677e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80006780:	6705                	lui	a4,0x1
    80006782:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80006786:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80006788:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000678c:	ffffa797          	auipc	a5,0xffffa
    80006790:	b9e78793          	addi	a5,a5,-1122 # 8000032a <main>
    80006794:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80006798:	4781                	li	a5,0
    8000679a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000679e:	67c1                	lui	a5,0x10
    800067a0:	17fd                	addi	a5,a5,-1
    800067a2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800067a6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800067aa:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800067ae:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800067b2:	10479073          	csrw	sie,a5
  timerinit();
    800067b6:	00000097          	auipc	ra,0x0
    800067ba:	f44080e7          	jalr	-188(ra) # 800066fa <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800067be:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800067c2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800067c4:	823e                	mv	tp,a5
  asm volatile("mret");
    800067c6:	30200073          	mret
}
    800067ca:	60a2                	ld	ra,8(sp)
    800067cc:	6402                	ld	s0,0(sp)
    800067ce:	0141                	addi	sp,sp,16
    800067d0:	8082                	ret

00000000800067d2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800067d2:	715d                	addi	sp,sp,-80
    800067d4:	e486                	sd	ra,72(sp)
    800067d6:	e0a2                	sd	s0,64(sp)
    800067d8:	fc26                	sd	s1,56(sp)
    800067da:	f84a                	sd	s2,48(sp)
    800067dc:	f44e                	sd	s3,40(sp)
    800067de:	f052                	sd	s4,32(sp)
    800067e0:	ec56                	sd	s5,24(sp)
    800067e2:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800067e4:	04c05663          	blez	a2,80006830 <consolewrite+0x5e>
    800067e8:	8a2a                	mv	s4,a0
    800067ea:	84ae                	mv	s1,a1
    800067ec:	89b2                	mv	s3,a2
    800067ee:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800067f0:	5afd                	li	s5,-1
    800067f2:	4685                	li	a3,1
    800067f4:	8626                	mv	a2,s1
    800067f6:	85d2                	mv	a1,s4
    800067f8:	fbf40513          	addi	a0,s0,-65
    800067fc:	ffffb097          	auipc	ra,0xffffb
    80006800:	18e080e7          	jalr	398(ra) # 8000198a <either_copyin>
    80006804:	01550c63          	beq	a0,s5,8000681c <consolewrite+0x4a>
      break;
    uartputc(c);
    80006808:	fbf44503          	lbu	a0,-65(s0)
    8000680c:	00000097          	auipc	ra,0x0
    80006810:	78e080e7          	jalr	1934(ra) # 80006f9a <uartputc>
  for(i = 0; i < n; i++){
    80006814:	2905                	addiw	s2,s2,1
    80006816:	0485                	addi	s1,s1,1
    80006818:	fd299de3          	bne	s3,s2,800067f2 <consolewrite+0x20>
  }

  return i;
}
    8000681c:	854a                	mv	a0,s2
    8000681e:	60a6                	ld	ra,72(sp)
    80006820:	6406                	ld	s0,64(sp)
    80006822:	74e2                	ld	s1,56(sp)
    80006824:	7942                	ld	s2,48(sp)
    80006826:	79a2                	ld	s3,40(sp)
    80006828:	7a02                	ld	s4,32(sp)
    8000682a:	6ae2                	ld	s5,24(sp)
    8000682c:	6161                	addi	sp,sp,80
    8000682e:	8082                	ret
  for(i = 0; i < n; i++){
    80006830:	4901                	li	s2,0
    80006832:	b7ed                	j	8000681c <consolewrite+0x4a>

0000000080006834 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80006834:	7119                	addi	sp,sp,-128
    80006836:	fc86                	sd	ra,120(sp)
    80006838:	f8a2                	sd	s0,112(sp)
    8000683a:	f4a6                	sd	s1,104(sp)
    8000683c:	f0ca                	sd	s2,96(sp)
    8000683e:	ecce                	sd	s3,88(sp)
    80006840:	e8d2                	sd	s4,80(sp)
    80006842:	e4d6                	sd	s5,72(sp)
    80006844:	e0da                	sd	s6,64(sp)
    80006846:	fc5e                	sd	s7,56(sp)
    80006848:	f862                	sd	s8,48(sp)
    8000684a:	f466                	sd	s9,40(sp)
    8000684c:	f06a                	sd	s10,32(sp)
    8000684e:	ec6e                	sd	s11,24(sp)
    80006850:	0100                	addi	s0,sp,128
    80006852:	8b2a                	mv	s6,a0
    80006854:	8aae                	mv	s5,a1
    80006856:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80006858:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000685c:	00021517          	auipc	a0,0x21
    80006860:	c2450513          	addi	a0,a0,-988 # 80027480 <cons>
    80006864:	00001097          	auipc	ra,0x1
    80006868:	8f4080e7          	jalr	-1804(ra) # 80007158 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000686c:	00021497          	auipc	s1,0x21
    80006870:	c1448493          	addi	s1,s1,-1004 # 80027480 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80006874:	89a6                	mv	s3,s1
    80006876:	00021917          	auipc	s2,0x21
    8000687a:	ca290913          	addi	s2,s2,-862 # 80027518 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000687e:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80006880:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80006882:	4da9                	li	s11,10
  while(n > 0){
    80006884:	07405863          	blez	s4,800068f4 <consoleread+0xc0>
    while(cons.r == cons.w){
    80006888:	0984a783          	lw	a5,152(s1)
    8000688c:	09c4a703          	lw	a4,156(s1)
    80006890:	02f71463          	bne	a4,a5,800068b8 <consoleread+0x84>
      if(myproc()->killed){
    80006894:	ffffa097          	auipc	ra,0xffffa
    80006898:	62e080e7          	jalr	1582(ra) # 80000ec2 <myproc>
    8000689c:	591c                	lw	a5,48(a0)
    8000689e:	e7b5                	bnez	a5,8000690a <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800068a0:	85ce                	mv	a1,s3
    800068a2:	854a                	mv	a0,s2
    800068a4:	ffffb097          	auipc	ra,0xffffb
    800068a8:	e2e080e7          	jalr	-466(ra) # 800016d2 <sleep>
    while(cons.r == cons.w){
    800068ac:	0984a783          	lw	a5,152(s1)
    800068b0:	09c4a703          	lw	a4,156(s1)
    800068b4:	fef700e3          	beq	a4,a5,80006894 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800068b8:	0017871b          	addiw	a4,a5,1
    800068bc:	08e4ac23          	sw	a4,152(s1)
    800068c0:	07f7f713          	andi	a4,a5,127
    800068c4:	9726                	add	a4,a4,s1
    800068c6:	01874703          	lbu	a4,24(a4)
    800068ca:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800068ce:	079c0663          	beq	s8,s9,8000693a <consoleread+0x106>
    cbuf = c;
    800068d2:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800068d6:	4685                	li	a3,1
    800068d8:	f8f40613          	addi	a2,s0,-113
    800068dc:	85d6                	mv	a1,s5
    800068de:	855a                	mv	a0,s6
    800068e0:	ffffb097          	auipc	ra,0xffffb
    800068e4:	054080e7          	jalr	84(ra) # 80001934 <either_copyout>
    800068e8:	01a50663          	beq	a0,s10,800068f4 <consoleread+0xc0>
    dst++;
    800068ec:	0a85                	addi	s5,s5,1
    --n;
    800068ee:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800068f0:	f9bc1ae3          	bne	s8,s11,80006884 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800068f4:	00021517          	auipc	a0,0x21
    800068f8:	b8c50513          	addi	a0,a0,-1140 # 80027480 <cons>
    800068fc:	00001097          	auipc	ra,0x1
    80006900:	910080e7          	jalr	-1776(ra) # 8000720c <release>

  return target - n;
    80006904:	414b853b          	subw	a0,s7,s4
    80006908:	a811                	j	8000691c <consoleread+0xe8>
        release(&cons.lock);
    8000690a:	00021517          	auipc	a0,0x21
    8000690e:	b7650513          	addi	a0,a0,-1162 # 80027480 <cons>
    80006912:	00001097          	auipc	ra,0x1
    80006916:	8fa080e7          	jalr	-1798(ra) # 8000720c <release>
        return -1;
    8000691a:	557d                	li	a0,-1
}
    8000691c:	70e6                	ld	ra,120(sp)
    8000691e:	7446                	ld	s0,112(sp)
    80006920:	74a6                	ld	s1,104(sp)
    80006922:	7906                	ld	s2,96(sp)
    80006924:	69e6                	ld	s3,88(sp)
    80006926:	6a46                	ld	s4,80(sp)
    80006928:	6aa6                	ld	s5,72(sp)
    8000692a:	6b06                	ld	s6,64(sp)
    8000692c:	7be2                	ld	s7,56(sp)
    8000692e:	7c42                	ld	s8,48(sp)
    80006930:	7ca2                	ld	s9,40(sp)
    80006932:	7d02                	ld	s10,32(sp)
    80006934:	6de2                	ld	s11,24(sp)
    80006936:	6109                	addi	sp,sp,128
    80006938:	8082                	ret
      if(n < target){
    8000693a:	000a071b          	sext.w	a4,s4
    8000693e:	fb777be3          	bgeu	a4,s7,800068f4 <consoleread+0xc0>
        cons.r--;
    80006942:	00021717          	auipc	a4,0x21
    80006946:	bcf72b23          	sw	a5,-1066(a4) # 80027518 <cons+0x98>
    8000694a:	b76d                	j	800068f4 <consoleread+0xc0>

000000008000694c <consputc>:
{
    8000694c:	1141                	addi	sp,sp,-16
    8000694e:	e406                	sd	ra,8(sp)
    80006950:	e022                	sd	s0,0(sp)
    80006952:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80006954:	10000793          	li	a5,256
    80006958:	00f50a63          	beq	a0,a5,8000696c <consputc+0x20>
    uartputc_sync(c);
    8000695c:	00000097          	auipc	ra,0x0
    80006960:	564080e7          	jalr	1380(ra) # 80006ec0 <uartputc_sync>
}
    80006964:	60a2                	ld	ra,8(sp)
    80006966:	6402                	ld	s0,0(sp)
    80006968:	0141                	addi	sp,sp,16
    8000696a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000696c:	4521                	li	a0,8
    8000696e:	00000097          	auipc	ra,0x0
    80006972:	552080e7          	jalr	1362(ra) # 80006ec0 <uartputc_sync>
    80006976:	02000513          	li	a0,32
    8000697a:	00000097          	auipc	ra,0x0
    8000697e:	546080e7          	jalr	1350(ra) # 80006ec0 <uartputc_sync>
    80006982:	4521                	li	a0,8
    80006984:	00000097          	auipc	ra,0x0
    80006988:	53c080e7          	jalr	1340(ra) # 80006ec0 <uartputc_sync>
    8000698c:	bfe1                	j	80006964 <consputc+0x18>

000000008000698e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000698e:	1101                	addi	sp,sp,-32
    80006990:	ec06                	sd	ra,24(sp)
    80006992:	e822                	sd	s0,16(sp)
    80006994:	e426                	sd	s1,8(sp)
    80006996:	e04a                	sd	s2,0(sp)
    80006998:	1000                	addi	s0,sp,32
    8000699a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000699c:	00021517          	auipc	a0,0x21
    800069a0:	ae450513          	addi	a0,a0,-1308 # 80027480 <cons>
    800069a4:	00000097          	auipc	ra,0x0
    800069a8:	7b4080e7          	jalr	1972(ra) # 80007158 <acquire>

  switch(c){
    800069ac:	47d5                	li	a5,21
    800069ae:	0af48663          	beq	s1,a5,80006a5a <consoleintr+0xcc>
    800069b2:	0297ca63          	blt	a5,s1,800069e6 <consoleintr+0x58>
    800069b6:	47a1                	li	a5,8
    800069b8:	0ef48763          	beq	s1,a5,80006aa6 <consoleintr+0x118>
    800069bc:	47c1                	li	a5,16
    800069be:	10f49a63          	bne	s1,a5,80006ad2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800069c2:	ffffb097          	auipc	ra,0xffffb
    800069c6:	01e080e7          	jalr	30(ra) # 800019e0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800069ca:	00021517          	auipc	a0,0x21
    800069ce:	ab650513          	addi	a0,a0,-1354 # 80027480 <cons>
    800069d2:	00001097          	auipc	ra,0x1
    800069d6:	83a080e7          	jalr	-1990(ra) # 8000720c <release>
}
    800069da:	60e2                	ld	ra,24(sp)
    800069dc:	6442                	ld	s0,16(sp)
    800069de:	64a2                	ld	s1,8(sp)
    800069e0:	6902                	ld	s2,0(sp)
    800069e2:	6105                	addi	sp,sp,32
    800069e4:	8082                	ret
  switch(c){
    800069e6:	07f00793          	li	a5,127
    800069ea:	0af48e63          	beq	s1,a5,80006aa6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800069ee:	00021717          	auipc	a4,0x21
    800069f2:	a9270713          	addi	a4,a4,-1390 # 80027480 <cons>
    800069f6:	0a072783          	lw	a5,160(a4)
    800069fa:	09872703          	lw	a4,152(a4)
    800069fe:	9f99                	subw	a5,a5,a4
    80006a00:	07f00713          	li	a4,127
    80006a04:	fcf763e3          	bltu	a4,a5,800069ca <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80006a08:	47b5                	li	a5,13
    80006a0a:	0cf48763          	beq	s1,a5,80006ad8 <consoleintr+0x14a>
      consputc(c);
    80006a0e:	8526                	mv	a0,s1
    80006a10:	00000097          	auipc	ra,0x0
    80006a14:	f3c080e7          	jalr	-196(ra) # 8000694c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006a18:	00021797          	auipc	a5,0x21
    80006a1c:	a6878793          	addi	a5,a5,-1432 # 80027480 <cons>
    80006a20:	0a07a703          	lw	a4,160(a5)
    80006a24:	0017069b          	addiw	a3,a4,1
    80006a28:	0006861b          	sext.w	a2,a3
    80006a2c:	0ad7a023          	sw	a3,160(a5)
    80006a30:	07f77713          	andi	a4,a4,127
    80006a34:	97ba                	add	a5,a5,a4
    80006a36:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006a3a:	47a9                	li	a5,10
    80006a3c:	0cf48563          	beq	s1,a5,80006b06 <consoleintr+0x178>
    80006a40:	4791                	li	a5,4
    80006a42:	0cf48263          	beq	s1,a5,80006b06 <consoleintr+0x178>
    80006a46:	00021797          	auipc	a5,0x21
    80006a4a:	ad27a783          	lw	a5,-1326(a5) # 80027518 <cons+0x98>
    80006a4e:	0807879b          	addiw	a5,a5,128
    80006a52:	f6f61ce3          	bne	a2,a5,800069ca <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006a56:	863e                	mv	a2,a5
    80006a58:	a07d                	j	80006b06 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006a5a:	00021717          	auipc	a4,0x21
    80006a5e:	a2670713          	addi	a4,a4,-1498 # 80027480 <cons>
    80006a62:	0a072783          	lw	a5,160(a4)
    80006a66:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006a6a:	00021497          	auipc	s1,0x21
    80006a6e:	a1648493          	addi	s1,s1,-1514 # 80027480 <cons>
    while(cons.e != cons.w &&
    80006a72:	4929                	li	s2,10
    80006a74:	f4f70be3          	beq	a4,a5,800069ca <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006a78:	37fd                	addiw	a5,a5,-1
    80006a7a:	07f7f713          	andi	a4,a5,127
    80006a7e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006a80:	01874703          	lbu	a4,24(a4)
    80006a84:	f52703e3          	beq	a4,s2,800069ca <consoleintr+0x3c>
      cons.e--;
    80006a88:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006a8c:	10000513          	li	a0,256
    80006a90:	00000097          	auipc	ra,0x0
    80006a94:	ebc080e7          	jalr	-324(ra) # 8000694c <consputc>
    while(cons.e != cons.w &&
    80006a98:	0a04a783          	lw	a5,160(s1)
    80006a9c:	09c4a703          	lw	a4,156(s1)
    80006aa0:	fcf71ce3          	bne	a4,a5,80006a78 <consoleintr+0xea>
    80006aa4:	b71d                	j	800069ca <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006aa6:	00021717          	auipc	a4,0x21
    80006aaa:	9da70713          	addi	a4,a4,-1574 # 80027480 <cons>
    80006aae:	0a072783          	lw	a5,160(a4)
    80006ab2:	09c72703          	lw	a4,156(a4)
    80006ab6:	f0f70ae3          	beq	a4,a5,800069ca <consoleintr+0x3c>
      cons.e--;
    80006aba:	37fd                	addiw	a5,a5,-1
    80006abc:	00021717          	auipc	a4,0x21
    80006ac0:	a6f72223          	sw	a5,-1436(a4) # 80027520 <cons+0xa0>
      consputc(BACKSPACE);
    80006ac4:	10000513          	li	a0,256
    80006ac8:	00000097          	auipc	ra,0x0
    80006acc:	e84080e7          	jalr	-380(ra) # 8000694c <consputc>
    80006ad0:	bded                	j	800069ca <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006ad2:	ee048ce3          	beqz	s1,800069ca <consoleintr+0x3c>
    80006ad6:	bf21                	j	800069ee <consoleintr+0x60>
      consputc(c);
    80006ad8:	4529                	li	a0,10
    80006ada:	00000097          	auipc	ra,0x0
    80006ade:	e72080e7          	jalr	-398(ra) # 8000694c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006ae2:	00021797          	auipc	a5,0x21
    80006ae6:	99e78793          	addi	a5,a5,-1634 # 80027480 <cons>
    80006aea:	0a07a703          	lw	a4,160(a5)
    80006aee:	0017069b          	addiw	a3,a4,1
    80006af2:	0006861b          	sext.w	a2,a3
    80006af6:	0ad7a023          	sw	a3,160(a5)
    80006afa:	07f77713          	andi	a4,a4,127
    80006afe:	97ba                	add	a5,a5,a4
    80006b00:	4729                	li	a4,10
    80006b02:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006b06:	00021797          	auipc	a5,0x21
    80006b0a:	a0c7ab23          	sw	a2,-1514(a5) # 8002751c <cons+0x9c>
        wakeup(&cons.r);
    80006b0e:	00021517          	auipc	a0,0x21
    80006b12:	a0a50513          	addi	a0,a0,-1526 # 80027518 <cons+0x98>
    80006b16:	ffffb097          	auipc	ra,0xffffb
    80006b1a:	d42080e7          	jalr	-702(ra) # 80001858 <wakeup>
    80006b1e:	b575                	j	800069ca <consoleintr+0x3c>

0000000080006b20 <consoleinit>:

void
consoleinit(void)
{
    80006b20:	1141                	addi	sp,sp,-16
    80006b22:	e406                	sd	ra,8(sp)
    80006b24:	e022                	sd	s0,0(sp)
    80006b26:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006b28:	00003597          	auipc	a1,0x3
    80006b2c:	cd058593          	addi	a1,a1,-816 # 800097f8 <syscalls+0x448>
    80006b30:	00021517          	auipc	a0,0x21
    80006b34:	95050513          	addi	a0,a0,-1712 # 80027480 <cons>
    80006b38:	00000097          	auipc	ra,0x0
    80006b3c:	590080e7          	jalr	1424(ra) # 800070c8 <initlock>

  uartinit();
    80006b40:	00000097          	auipc	ra,0x0
    80006b44:	330080e7          	jalr	816(ra) # 80006e70 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006b48:	00013797          	auipc	a5,0x13
    80006b4c:	58878793          	addi	a5,a5,1416 # 8001a0d0 <devsw>
    80006b50:	00000717          	auipc	a4,0x0
    80006b54:	ce470713          	addi	a4,a4,-796 # 80006834 <consoleread>
    80006b58:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006b5a:	00000717          	auipc	a4,0x0
    80006b5e:	c7870713          	addi	a4,a4,-904 # 800067d2 <consolewrite>
    80006b62:	ef98                	sd	a4,24(a5)
}
    80006b64:	60a2                	ld	ra,8(sp)
    80006b66:	6402                	ld	s0,0(sp)
    80006b68:	0141                	addi	sp,sp,16
    80006b6a:	8082                	ret

0000000080006b6c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006b6c:	7179                	addi	sp,sp,-48
    80006b6e:	f406                	sd	ra,40(sp)
    80006b70:	f022                	sd	s0,32(sp)
    80006b72:	ec26                	sd	s1,24(sp)
    80006b74:	e84a                	sd	s2,16(sp)
    80006b76:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006b78:	c219                	beqz	a2,80006b7e <printint+0x12>
    80006b7a:	08054663          	bltz	a0,80006c06 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006b7e:	2501                	sext.w	a0,a0
    80006b80:	4881                	li	a7,0
    80006b82:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006b86:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006b88:	2581                	sext.w	a1,a1
    80006b8a:	00003617          	auipc	a2,0x3
    80006b8e:	c9e60613          	addi	a2,a2,-866 # 80009828 <digits>
    80006b92:	883a                	mv	a6,a4
    80006b94:	2705                	addiw	a4,a4,1
    80006b96:	02b577bb          	remuw	a5,a0,a1
    80006b9a:	1782                	slli	a5,a5,0x20
    80006b9c:	9381                	srli	a5,a5,0x20
    80006b9e:	97b2                	add	a5,a5,a2
    80006ba0:	0007c783          	lbu	a5,0(a5)
    80006ba4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006ba8:	0005079b          	sext.w	a5,a0
    80006bac:	02b5553b          	divuw	a0,a0,a1
    80006bb0:	0685                	addi	a3,a3,1
    80006bb2:	feb7f0e3          	bgeu	a5,a1,80006b92 <printint+0x26>

  if(sign)
    80006bb6:	00088b63          	beqz	a7,80006bcc <printint+0x60>
    buf[i++] = '-';
    80006bba:	fe040793          	addi	a5,s0,-32
    80006bbe:	973e                	add	a4,a4,a5
    80006bc0:	02d00793          	li	a5,45
    80006bc4:	fef70823          	sb	a5,-16(a4)
    80006bc8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006bcc:	02e05763          	blez	a4,80006bfa <printint+0x8e>
    80006bd0:	fd040793          	addi	a5,s0,-48
    80006bd4:	00e784b3          	add	s1,a5,a4
    80006bd8:	fff78913          	addi	s2,a5,-1
    80006bdc:	993a                	add	s2,s2,a4
    80006bde:	377d                	addiw	a4,a4,-1
    80006be0:	1702                	slli	a4,a4,0x20
    80006be2:	9301                	srli	a4,a4,0x20
    80006be4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006be8:	fff4c503          	lbu	a0,-1(s1)
    80006bec:	00000097          	auipc	ra,0x0
    80006bf0:	d60080e7          	jalr	-672(ra) # 8000694c <consputc>
  while(--i >= 0)
    80006bf4:	14fd                	addi	s1,s1,-1
    80006bf6:	ff2499e3          	bne	s1,s2,80006be8 <printint+0x7c>
}
    80006bfa:	70a2                	ld	ra,40(sp)
    80006bfc:	7402                	ld	s0,32(sp)
    80006bfe:	64e2                	ld	s1,24(sp)
    80006c00:	6942                	ld	s2,16(sp)
    80006c02:	6145                	addi	sp,sp,48
    80006c04:	8082                	ret
    x = -xx;
    80006c06:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006c0a:	4885                	li	a7,1
    x = -xx;
    80006c0c:	bf9d                	j	80006b82 <printint+0x16>

0000000080006c0e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006c0e:	1101                	addi	sp,sp,-32
    80006c10:	ec06                	sd	ra,24(sp)
    80006c12:	e822                	sd	s0,16(sp)
    80006c14:	e426                	sd	s1,8(sp)
    80006c16:	1000                	addi	s0,sp,32
    80006c18:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006c1a:	00021797          	auipc	a5,0x21
    80006c1e:	9207a323          	sw	zero,-1754(a5) # 80027540 <pr+0x18>
  printf("panic: ");
    80006c22:	00003517          	auipc	a0,0x3
    80006c26:	bde50513          	addi	a0,a0,-1058 # 80009800 <syscalls+0x450>
    80006c2a:	00000097          	auipc	ra,0x0
    80006c2e:	02e080e7          	jalr	46(ra) # 80006c58 <printf>
  printf(s);
    80006c32:	8526                	mv	a0,s1
    80006c34:	00000097          	auipc	ra,0x0
    80006c38:	024080e7          	jalr	36(ra) # 80006c58 <printf>
  printf("\n");
    80006c3c:	00002517          	auipc	a0,0x2
    80006c40:	40c50513          	addi	a0,a0,1036 # 80009048 <etext+0x48>
    80006c44:	00000097          	auipc	ra,0x0
    80006c48:	014080e7          	jalr	20(ra) # 80006c58 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006c4c:	4785                	li	a5,1
    80006c4e:	00003717          	auipc	a4,0x3
    80006c52:	3ef72123          	sw	a5,994(a4) # 8000a030 <panicked>
  for(;;)
    80006c56:	a001                	j	80006c56 <panic+0x48>

0000000080006c58 <printf>:
{
    80006c58:	7131                	addi	sp,sp,-192
    80006c5a:	fc86                	sd	ra,120(sp)
    80006c5c:	f8a2                	sd	s0,112(sp)
    80006c5e:	f4a6                	sd	s1,104(sp)
    80006c60:	f0ca                	sd	s2,96(sp)
    80006c62:	ecce                	sd	s3,88(sp)
    80006c64:	e8d2                	sd	s4,80(sp)
    80006c66:	e4d6                	sd	s5,72(sp)
    80006c68:	e0da                	sd	s6,64(sp)
    80006c6a:	fc5e                	sd	s7,56(sp)
    80006c6c:	f862                	sd	s8,48(sp)
    80006c6e:	f466                	sd	s9,40(sp)
    80006c70:	f06a                	sd	s10,32(sp)
    80006c72:	ec6e                	sd	s11,24(sp)
    80006c74:	0100                	addi	s0,sp,128
    80006c76:	8a2a                	mv	s4,a0
    80006c78:	e40c                	sd	a1,8(s0)
    80006c7a:	e810                	sd	a2,16(s0)
    80006c7c:	ec14                	sd	a3,24(s0)
    80006c7e:	f018                	sd	a4,32(s0)
    80006c80:	f41c                	sd	a5,40(s0)
    80006c82:	03043823          	sd	a6,48(s0)
    80006c86:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006c8a:	00021d97          	auipc	s11,0x21
    80006c8e:	8b6dad83          	lw	s11,-1866(s11) # 80027540 <pr+0x18>
  if(locking)
    80006c92:	020d9b63          	bnez	s11,80006cc8 <printf+0x70>
  if (fmt == 0)
    80006c96:	040a0263          	beqz	s4,80006cda <printf+0x82>
  va_start(ap, fmt);
    80006c9a:	00840793          	addi	a5,s0,8
    80006c9e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006ca2:	000a4503          	lbu	a0,0(s4)
    80006ca6:	16050263          	beqz	a0,80006e0a <printf+0x1b2>
    80006caa:	4481                	li	s1,0
    if(c != '%'){
    80006cac:	02500a93          	li	s5,37
    switch(c){
    80006cb0:	07000b13          	li	s6,112
  consputc('x');
    80006cb4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006cb6:	00003b97          	auipc	s7,0x3
    80006cba:	b72b8b93          	addi	s7,s7,-1166 # 80009828 <digits>
    switch(c){
    80006cbe:	07300c93          	li	s9,115
    80006cc2:	06400c13          	li	s8,100
    80006cc6:	a82d                	j	80006d00 <printf+0xa8>
    acquire(&pr.lock);
    80006cc8:	00021517          	auipc	a0,0x21
    80006ccc:	86050513          	addi	a0,a0,-1952 # 80027528 <pr>
    80006cd0:	00000097          	auipc	ra,0x0
    80006cd4:	488080e7          	jalr	1160(ra) # 80007158 <acquire>
    80006cd8:	bf7d                	j	80006c96 <printf+0x3e>
    panic("null fmt");
    80006cda:	00003517          	auipc	a0,0x3
    80006cde:	b3650513          	addi	a0,a0,-1226 # 80009810 <syscalls+0x460>
    80006ce2:	00000097          	auipc	ra,0x0
    80006ce6:	f2c080e7          	jalr	-212(ra) # 80006c0e <panic>
      consputc(c);
    80006cea:	00000097          	auipc	ra,0x0
    80006cee:	c62080e7          	jalr	-926(ra) # 8000694c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006cf2:	2485                	addiw	s1,s1,1
    80006cf4:	009a07b3          	add	a5,s4,s1
    80006cf8:	0007c503          	lbu	a0,0(a5)
    80006cfc:	10050763          	beqz	a0,80006e0a <printf+0x1b2>
    if(c != '%'){
    80006d00:	ff5515e3          	bne	a0,s5,80006cea <printf+0x92>
    c = fmt[++i] & 0xff;
    80006d04:	2485                	addiw	s1,s1,1
    80006d06:	009a07b3          	add	a5,s4,s1
    80006d0a:	0007c783          	lbu	a5,0(a5)
    80006d0e:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006d12:	cfe5                	beqz	a5,80006e0a <printf+0x1b2>
    switch(c){
    80006d14:	05678a63          	beq	a5,s6,80006d68 <printf+0x110>
    80006d18:	02fb7663          	bgeu	s6,a5,80006d44 <printf+0xec>
    80006d1c:	09978963          	beq	a5,s9,80006dae <printf+0x156>
    80006d20:	07800713          	li	a4,120
    80006d24:	0ce79863          	bne	a5,a4,80006df4 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006d28:	f8843783          	ld	a5,-120(s0)
    80006d2c:	00878713          	addi	a4,a5,8
    80006d30:	f8e43423          	sd	a4,-120(s0)
    80006d34:	4605                	li	a2,1
    80006d36:	85ea                	mv	a1,s10
    80006d38:	4388                	lw	a0,0(a5)
    80006d3a:	00000097          	auipc	ra,0x0
    80006d3e:	e32080e7          	jalr	-462(ra) # 80006b6c <printint>
      break;
    80006d42:	bf45                	j	80006cf2 <printf+0x9a>
    switch(c){
    80006d44:	0b578263          	beq	a5,s5,80006de8 <printf+0x190>
    80006d48:	0b879663          	bne	a5,s8,80006df4 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006d4c:	f8843783          	ld	a5,-120(s0)
    80006d50:	00878713          	addi	a4,a5,8
    80006d54:	f8e43423          	sd	a4,-120(s0)
    80006d58:	4605                	li	a2,1
    80006d5a:	45a9                	li	a1,10
    80006d5c:	4388                	lw	a0,0(a5)
    80006d5e:	00000097          	auipc	ra,0x0
    80006d62:	e0e080e7          	jalr	-498(ra) # 80006b6c <printint>
      break;
    80006d66:	b771                	j	80006cf2 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006d68:	f8843783          	ld	a5,-120(s0)
    80006d6c:	00878713          	addi	a4,a5,8
    80006d70:	f8e43423          	sd	a4,-120(s0)
    80006d74:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006d78:	03000513          	li	a0,48
    80006d7c:	00000097          	auipc	ra,0x0
    80006d80:	bd0080e7          	jalr	-1072(ra) # 8000694c <consputc>
  consputc('x');
    80006d84:	07800513          	li	a0,120
    80006d88:	00000097          	auipc	ra,0x0
    80006d8c:	bc4080e7          	jalr	-1084(ra) # 8000694c <consputc>
    80006d90:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006d92:	03c9d793          	srli	a5,s3,0x3c
    80006d96:	97de                	add	a5,a5,s7
    80006d98:	0007c503          	lbu	a0,0(a5)
    80006d9c:	00000097          	auipc	ra,0x0
    80006da0:	bb0080e7          	jalr	-1104(ra) # 8000694c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006da4:	0992                	slli	s3,s3,0x4
    80006da6:	397d                	addiw	s2,s2,-1
    80006da8:	fe0915e3          	bnez	s2,80006d92 <printf+0x13a>
    80006dac:	b799                	j	80006cf2 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006dae:	f8843783          	ld	a5,-120(s0)
    80006db2:	00878713          	addi	a4,a5,8
    80006db6:	f8e43423          	sd	a4,-120(s0)
    80006dba:	0007b903          	ld	s2,0(a5)
    80006dbe:	00090e63          	beqz	s2,80006dda <printf+0x182>
      for(; *s; s++)
    80006dc2:	00094503          	lbu	a0,0(s2)
    80006dc6:	d515                	beqz	a0,80006cf2 <printf+0x9a>
        consputc(*s);
    80006dc8:	00000097          	auipc	ra,0x0
    80006dcc:	b84080e7          	jalr	-1148(ra) # 8000694c <consputc>
      for(; *s; s++)
    80006dd0:	0905                	addi	s2,s2,1
    80006dd2:	00094503          	lbu	a0,0(s2)
    80006dd6:	f96d                	bnez	a0,80006dc8 <printf+0x170>
    80006dd8:	bf29                	j	80006cf2 <printf+0x9a>
        s = "(null)";
    80006dda:	00003917          	auipc	s2,0x3
    80006dde:	a2e90913          	addi	s2,s2,-1490 # 80009808 <syscalls+0x458>
      for(; *s; s++)
    80006de2:	02800513          	li	a0,40
    80006de6:	b7cd                	j	80006dc8 <printf+0x170>
      consputc('%');
    80006de8:	8556                	mv	a0,s5
    80006dea:	00000097          	auipc	ra,0x0
    80006dee:	b62080e7          	jalr	-1182(ra) # 8000694c <consputc>
      break;
    80006df2:	b701                	j	80006cf2 <printf+0x9a>
      consputc('%');
    80006df4:	8556                	mv	a0,s5
    80006df6:	00000097          	auipc	ra,0x0
    80006dfa:	b56080e7          	jalr	-1194(ra) # 8000694c <consputc>
      consputc(c);
    80006dfe:	854a                	mv	a0,s2
    80006e00:	00000097          	auipc	ra,0x0
    80006e04:	b4c080e7          	jalr	-1204(ra) # 8000694c <consputc>
      break;
    80006e08:	b5ed                	j	80006cf2 <printf+0x9a>
  if(locking)
    80006e0a:	020d9163          	bnez	s11,80006e2c <printf+0x1d4>
}
    80006e0e:	70e6                	ld	ra,120(sp)
    80006e10:	7446                	ld	s0,112(sp)
    80006e12:	74a6                	ld	s1,104(sp)
    80006e14:	7906                	ld	s2,96(sp)
    80006e16:	69e6                	ld	s3,88(sp)
    80006e18:	6a46                	ld	s4,80(sp)
    80006e1a:	6aa6                	ld	s5,72(sp)
    80006e1c:	6b06                	ld	s6,64(sp)
    80006e1e:	7be2                	ld	s7,56(sp)
    80006e20:	7c42                	ld	s8,48(sp)
    80006e22:	7ca2                	ld	s9,40(sp)
    80006e24:	7d02                	ld	s10,32(sp)
    80006e26:	6de2                	ld	s11,24(sp)
    80006e28:	6129                	addi	sp,sp,192
    80006e2a:	8082                	ret
    release(&pr.lock);
    80006e2c:	00020517          	auipc	a0,0x20
    80006e30:	6fc50513          	addi	a0,a0,1788 # 80027528 <pr>
    80006e34:	00000097          	auipc	ra,0x0
    80006e38:	3d8080e7          	jalr	984(ra) # 8000720c <release>
}
    80006e3c:	bfc9                	j	80006e0e <printf+0x1b6>

0000000080006e3e <printfinit>:
    ;
}

void
printfinit(void)
{
    80006e3e:	1101                	addi	sp,sp,-32
    80006e40:	ec06                	sd	ra,24(sp)
    80006e42:	e822                	sd	s0,16(sp)
    80006e44:	e426                	sd	s1,8(sp)
    80006e46:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006e48:	00020497          	auipc	s1,0x20
    80006e4c:	6e048493          	addi	s1,s1,1760 # 80027528 <pr>
    80006e50:	00003597          	auipc	a1,0x3
    80006e54:	9d058593          	addi	a1,a1,-1584 # 80009820 <syscalls+0x470>
    80006e58:	8526                	mv	a0,s1
    80006e5a:	00000097          	auipc	ra,0x0
    80006e5e:	26e080e7          	jalr	622(ra) # 800070c8 <initlock>
  pr.locking = 1;
    80006e62:	4785                	li	a5,1
    80006e64:	cc9c                	sw	a5,24(s1)
}
    80006e66:	60e2                	ld	ra,24(sp)
    80006e68:	6442                	ld	s0,16(sp)
    80006e6a:	64a2                	ld	s1,8(sp)
    80006e6c:	6105                	addi	sp,sp,32
    80006e6e:	8082                	ret

0000000080006e70 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006e70:	1141                	addi	sp,sp,-16
    80006e72:	e406                	sd	ra,8(sp)
    80006e74:	e022                	sd	s0,0(sp)
    80006e76:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006e78:	100007b7          	lui	a5,0x10000
    80006e7c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006e80:	f8000713          	li	a4,-128
    80006e84:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006e88:	470d                	li	a4,3
    80006e8a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006e8e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006e92:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006e96:	469d                	li	a3,7
    80006e98:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006e9c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006ea0:	00003597          	auipc	a1,0x3
    80006ea4:	9a058593          	addi	a1,a1,-1632 # 80009840 <digits+0x18>
    80006ea8:	00020517          	auipc	a0,0x20
    80006eac:	6a050513          	addi	a0,a0,1696 # 80027548 <uart_tx_lock>
    80006eb0:	00000097          	auipc	ra,0x0
    80006eb4:	218080e7          	jalr	536(ra) # 800070c8 <initlock>
}
    80006eb8:	60a2                	ld	ra,8(sp)
    80006eba:	6402                	ld	s0,0(sp)
    80006ebc:	0141                	addi	sp,sp,16
    80006ebe:	8082                	ret

0000000080006ec0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006ec0:	1101                	addi	sp,sp,-32
    80006ec2:	ec06                	sd	ra,24(sp)
    80006ec4:	e822                	sd	s0,16(sp)
    80006ec6:	e426                	sd	s1,8(sp)
    80006ec8:	1000                	addi	s0,sp,32
    80006eca:	84aa                	mv	s1,a0
  push_off();
    80006ecc:	00000097          	auipc	ra,0x0
    80006ed0:	240080e7          	jalr	576(ra) # 8000710c <push_off>

  if(panicked){
    80006ed4:	00003797          	auipc	a5,0x3
    80006ed8:	15c7a783          	lw	a5,348(a5) # 8000a030 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006edc:	10000737          	lui	a4,0x10000
  if(panicked){
    80006ee0:	c391                	beqz	a5,80006ee4 <uartputc_sync+0x24>
    for(;;)
    80006ee2:	a001                	j	80006ee2 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006ee4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006ee8:	0ff7f793          	andi	a5,a5,255
    80006eec:	0207f793          	andi	a5,a5,32
    80006ef0:	dbf5                	beqz	a5,80006ee4 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006ef2:	0ff4f793          	andi	a5,s1,255
    80006ef6:	10000737          	lui	a4,0x10000
    80006efa:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006efe:	00000097          	auipc	ra,0x0
    80006f02:	2ae080e7          	jalr	686(ra) # 800071ac <pop_off>
}
    80006f06:	60e2                	ld	ra,24(sp)
    80006f08:	6442                	ld	s0,16(sp)
    80006f0a:	64a2                	ld	s1,8(sp)
    80006f0c:	6105                	addi	sp,sp,32
    80006f0e:	8082                	ret

0000000080006f10 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006f10:	00003717          	auipc	a4,0x3
    80006f14:	12873703          	ld	a4,296(a4) # 8000a038 <uart_tx_r>
    80006f18:	00003797          	auipc	a5,0x3
    80006f1c:	1287b783          	ld	a5,296(a5) # 8000a040 <uart_tx_w>
    80006f20:	06e78c63          	beq	a5,a4,80006f98 <uartstart+0x88>
{
    80006f24:	7139                	addi	sp,sp,-64
    80006f26:	fc06                	sd	ra,56(sp)
    80006f28:	f822                	sd	s0,48(sp)
    80006f2a:	f426                	sd	s1,40(sp)
    80006f2c:	f04a                	sd	s2,32(sp)
    80006f2e:	ec4e                	sd	s3,24(sp)
    80006f30:	e852                	sd	s4,16(sp)
    80006f32:	e456                	sd	s5,8(sp)
    80006f34:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006f36:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006f3a:	00020a17          	auipc	s4,0x20
    80006f3e:	60ea0a13          	addi	s4,s4,1550 # 80027548 <uart_tx_lock>
    uart_tx_r += 1;
    80006f42:	00003497          	auipc	s1,0x3
    80006f46:	0f648493          	addi	s1,s1,246 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006f4a:	00003997          	auipc	s3,0x3
    80006f4e:	0f698993          	addi	s3,s3,246 # 8000a040 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006f52:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006f56:	0ff7f793          	andi	a5,a5,255
    80006f5a:	0207f793          	andi	a5,a5,32
    80006f5e:	c785                	beqz	a5,80006f86 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006f60:	01f77793          	andi	a5,a4,31
    80006f64:	97d2                	add	a5,a5,s4
    80006f66:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006f6a:	0705                	addi	a4,a4,1
    80006f6c:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006f6e:	8526                	mv	a0,s1
    80006f70:	ffffb097          	auipc	ra,0xffffb
    80006f74:	8e8080e7          	jalr	-1816(ra) # 80001858 <wakeup>
    
    WriteReg(THR, c);
    80006f78:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006f7c:	6098                	ld	a4,0(s1)
    80006f7e:	0009b783          	ld	a5,0(s3)
    80006f82:	fce798e3          	bne	a5,a4,80006f52 <uartstart+0x42>
  }
}
    80006f86:	70e2                	ld	ra,56(sp)
    80006f88:	7442                	ld	s0,48(sp)
    80006f8a:	74a2                	ld	s1,40(sp)
    80006f8c:	7902                	ld	s2,32(sp)
    80006f8e:	69e2                	ld	s3,24(sp)
    80006f90:	6a42                	ld	s4,16(sp)
    80006f92:	6aa2                	ld	s5,8(sp)
    80006f94:	6121                	addi	sp,sp,64
    80006f96:	8082                	ret
    80006f98:	8082                	ret

0000000080006f9a <uartputc>:
{
    80006f9a:	7179                	addi	sp,sp,-48
    80006f9c:	f406                	sd	ra,40(sp)
    80006f9e:	f022                	sd	s0,32(sp)
    80006fa0:	ec26                	sd	s1,24(sp)
    80006fa2:	e84a                	sd	s2,16(sp)
    80006fa4:	e44e                	sd	s3,8(sp)
    80006fa6:	e052                	sd	s4,0(sp)
    80006fa8:	1800                	addi	s0,sp,48
    80006faa:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006fac:	00020517          	auipc	a0,0x20
    80006fb0:	59c50513          	addi	a0,a0,1436 # 80027548 <uart_tx_lock>
    80006fb4:	00000097          	auipc	ra,0x0
    80006fb8:	1a4080e7          	jalr	420(ra) # 80007158 <acquire>
  if(panicked){
    80006fbc:	00003797          	auipc	a5,0x3
    80006fc0:	0747a783          	lw	a5,116(a5) # 8000a030 <panicked>
    80006fc4:	c391                	beqz	a5,80006fc8 <uartputc+0x2e>
    for(;;)
    80006fc6:	a001                	j	80006fc6 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006fc8:	00003797          	auipc	a5,0x3
    80006fcc:	0787b783          	ld	a5,120(a5) # 8000a040 <uart_tx_w>
    80006fd0:	00003717          	auipc	a4,0x3
    80006fd4:	06873703          	ld	a4,104(a4) # 8000a038 <uart_tx_r>
    80006fd8:	02070713          	addi	a4,a4,32
    80006fdc:	02f71b63          	bne	a4,a5,80007012 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006fe0:	00020a17          	auipc	s4,0x20
    80006fe4:	568a0a13          	addi	s4,s4,1384 # 80027548 <uart_tx_lock>
    80006fe8:	00003497          	auipc	s1,0x3
    80006fec:	05048493          	addi	s1,s1,80 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006ff0:	00003917          	auipc	s2,0x3
    80006ff4:	05090913          	addi	s2,s2,80 # 8000a040 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006ff8:	85d2                	mv	a1,s4
    80006ffa:	8526                	mv	a0,s1
    80006ffc:	ffffa097          	auipc	ra,0xffffa
    80007000:	6d6080e7          	jalr	1750(ra) # 800016d2 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80007004:	00093783          	ld	a5,0(s2)
    80007008:	6098                	ld	a4,0(s1)
    8000700a:	02070713          	addi	a4,a4,32
    8000700e:	fef705e3          	beq	a4,a5,80006ff8 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80007012:	00020497          	auipc	s1,0x20
    80007016:	53648493          	addi	s1,s1,1334 # 80027548 <uart_tx_lock>
    8000701a:	01f7f713          	andi	a4,a5,31
    8000701e:	9726                	add	a4,a4,s1
    80007020:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80007024:	0785                	addi	a5,a5,1
    80007026:	00003717          	auipc	a4,0x3
    8000702a:	00f73d23          	sd	a5,26(a4) # 8000a040 <uart_tx_w>
      uartstart();
    8000702e:	00000097          	auipc	ra,0x0
    80007032:	ee2080e7          	jalr	-286(ra) # 80006f10 <uartstart>
      release(&uart_tx_lock);
    80007036:	8526                	mv	a0,s1
    80007038:	00000097          	auipc	ra,0x0
    8000703c:	1d4080e7          	jalr	468(ra) # 8000720c <release>
}
    80007040:	70a2                	ld	ra,40(sp)
    80007042:	7402                	ld	s0,32(sp)
    80007044:	64e2                	ld	s1,24(sp)
    80007046:	6942                	ld	s2,16(sp)
    80007048:	69a2                	ld	s3,8(sp)
    8000704a:	6a02                	ld	s4,0(sp)
    8000704c:	6145                	addi	sp,sp,48
    8000704e:	8082                	ret

0000000080007050 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80007050:	1141                	addi	sp,sp,-16
    80007052:	e422                	sd	s0,8(sp)
    80007054:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80007056:	100007b7          	lui	a5,0x10000
    8000705a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000705e:	8b85                	andi	a5,a5,1
    80007060:	cb91                	beqz	a5,80007074 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80007062:	100007b7          	lui	a5,0x10000
    80007066:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000706a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000706e:	6422                	ld	s0,8(sp)
    80007070:	0141                	addi	sp,sp,16
    80007072:	8082                	ret
    return -1;
    80007074:	557d                	li	a0,-1
    80007076:	bfe5                	j	8000706e <uartgetc+0x1e>

0000000080007078 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80007078:	1101                	addi	sp,sp,-32
    8000707a:	ec06                	sd	ra,24(sp)
    8000707c:	e822                	sd	s0,16(sp)
    8000707e:	e426                	sd	s1,8(sp)
    80007080:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80007082:	54fd                	li	s1,-1
    int c = uartgetc();
    80007084:	00000097          	auipc	ra,0x0
    80007088:	fcc080e7          	jalr	-52(ra) # 80007050 <uartgetc>
    if(c == -1)
    8000708c:	00950763          	beq	a0,s1,8000709a <uartintr+0x22>
      break;
    consoleintr(c);
    80007090:	00000097          	auipc	ra,0x0
    80007094:	8fe080e7          	jalr	-1794(ra) # 8000698e <consoleintr>
  while(1){
    80007098:	b7f5                	j	80007084 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000709a:	00020497          	auipc	s1,0x20
    8000709e:	4ae48493          	addi	s1,s1,1198 # 80027548 <uart_tx_lock>
    800070a2:	8526                	mv	a0,s1
    800070a4:	00000097          	auipc	ra,0x0
    800070a8:	0b4080e7          	jalr	180(ra) # 80007158 <acquire>
  uartstart();
    800070ac:	00000097          	auipc	ra,0x0
    800070b0:	e64080e7          	jalr	-412(ra) # 80006f10 <uartstart>
  release(&uart_tx_lock);
    800070b4:	8526                	mv	a0,s1
    800070b6:	00000097          	auipc	ra,0x0
    800070ba:	156080e7          	jalr	342(ra) # 8000720c <release>
}
    800070be:	60e2                	ld	ra,24(sp)
    800070c0:	6442                	ld	s0,16(sp)
    800070c2:	64a2                	ld	s1,8(sp)
    800070c4:	6105                	addi	sp,sp,32
    800070c6:	8082                	ret

00000000800070c8 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    800070c8:	1141                	addi	sp,sp,-16
    800070ca:	e422                	sd	s0,8(sp)
    800070cc:	0800                	addi	s0,sp,16
  lk->name = name;
    800070ce:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800070d0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800070d4:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    800070d8:	6422                	ld	s0,8(sp)
    800070da:	0141                	addi	sp,sp,16
    800070dc:	8082                	ret

00000000800070de <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800070de:	411c                	lw	a5,0(a0)
    800070e0:	e399                	bnez	a5,800070e6 <holding+0x8>
    800070e2:	4501                	li	a0,0
  return r;
}
    800070e4:	8082                	ret
{
    800070e6:	1101                	addi	sp,sp,-32
    800070e8:	ec06                	sd	ra,24(sp)
    800070ea:	e822                	sd	s0,16(sp)
    800070ec:	e426                	sd	s1,8(sp)
    800070ee:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800070f0:	6904                	ld	s1,16(a0)
    800070f2:	ffffa097          	auipc	ra,0xffffa
    800070f6:	db4080e7          	jalr	-588(ra) # 80000ea6 <mycpu>
    800070fa:	40a48533          	sub	a0,s1,a0
    800070fe:	00153513          	seqz	a0,a0
}
    80007102:	60e2                	ld	ra,24(sp)
    80007104:	6442                	ld	s0,16(sp)
    80007106:	64a2                	ld	s1,8(sp)
    80007108:	6105                	addi	sp,sp,32
    8000710a:	8082                	ret

000000008000710c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000710c:	1101                	addi	sp,sp,-32
    8000710e:	ec06                	sd	ra,24(sp)
    80007110:	e822                	sd	s0,16(sp)
    80007112:	e426                	sd	s1,8(sp)
    80007114:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007116:	100024f3          	csrr	s1,sstatus
    8000711a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000711e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80007120:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80007124:	ffffa097          	auipc	ra,0xffffa
    80007128:	d82080e7          	jalr	-638(ra) # 80000ea6 <mycpu>
    8000712c:	5d3c                	lw	a5,120(a0)
    8000712e:	cf89                	beqz	a5,80007148 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80007130:	ffffa097          	auipc	ra,0xffffa
    80007134:	d76080e7          	jalr	-650(ra) # 80000ea6 <mycpu>
    80007138:	5d3c                	lw	a5,120(a0)
    8000713a:	2785                	addiw	a5,a5,1
    8000713c:	dd3c                	sw	a5,120(a0)
}
    8000713e:	60e2                	ld	ra,24(sp)
    80007140:	6442                	ld	s0,16(sp)
    80007142:	64a2                	ld	s1,8(sp)
    80007144:	6105                	addi	sp,sp,32
    80007146:	8082                	ret
    mycpu()->intena = old;
    80007148:	ffffa097          	auipc	ra,0xffffa
    8000714c:	d5e080e7          	jalr	-674(ra) # 80000ea6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80007150:	8085                	srli	s1,s1,0x1
    80007152:	8885                	andi	s1,s1,1
    80007154:	dd64                	sw	s1,124(a0)
    80007156:	bfe9                	j	80007130 <push_off+0x24>

0000000080007158 <acquire>:
{
    80007158:	1101                	addi	sp,sp,-32
    8000715a:	ec06                	sd	ra,24(sp)
    8000715c:	e822                	sd	s0,16(sp)
    8000715e:	e426                	sd	s1,8(sp)
    80007160:	1000                	addi	s0,sp,32
    80007162:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80007164:	00000097          	auipc	ra,0x0
    80007168:	fa8080e7          	jalr	-88(ra) # 8000710c <push_off>
  if(holding(lk))
    8000716c:	8526                	mv	a0,s1
    8000716e:	00000097          	auipc	ra,0x0
    80007172:	f70080e7          	jalr	-144(ra) # 800070de <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007176:	4705                	li	a4,1
  if(holding(lk))
    80007178:	e115                	bnez	a0,8000719c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000717a:	87ba                	mv	a5,a4
    8000717c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80007180:	2781                	sext.w	a5,a5
    80007182:	ffe5                	bnez	a5,8000717a <acquire+0x22>
  __sync_synchronize();
    80007184:	0ff0000f          	fence
  lk->cpu = mycpu();
    80007188:	ffffa097          	auipc	ra,0xffffa
    8000718c:	d1e080e7          	jalr	-738(ra) # 80000ea6 <mycpu>
    80007190:	e888                	sd	a0,16(s1)
}
    80007192:	60e2                	ld	ra,24(sp)
    80007194:	6442                	ld	s0,16(sp)
    80007196:	64a2                	ld	s1,8(sp)
    80007198:	6105                	addi	sp,sp,32
    8000719a:	8082                	ret
    panic("acquire");
    8000719c:	00002517          	auipc	a0,0x2
    800071a0:	6ac50513          	addi	a0,a0,1708 # 80009848 <digits+0x20>
    800071a4:	00000097          	auipc	ra,0x0
    800071a8:	a6a080e7          	jalr	-1430(ra) # 80006c0e <panic>

00000000800071ac <pop_off>:

void
pop_off(void)
{
    800071ac:	1141                	addi	sp,sp,-16
    800071ae:	e406                	sd	ra,8(sp)
    800071b0:	e022                	sd	s0,0(sp)
    800071b2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800071b4:	ffffa097          	auipc	ra,0xffffa
    800071b8:	cf2080e7          	jalr	-782(ra) # 80000ea6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800071bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800071c0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800071c2:	e78d                	bnez	a5,800071ec <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800071c4:	5d3c                	lw	a5,120(a0)
    800071c6:	02f05b63          	blez	a5,800071fc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800071ca:	37fd                	addiw	a5,a5,-1
    800071cc:	0007871b          	sext.w	a4,a5
    800071d0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800071d2:	eb09                	bnez	a4,800071e4 <pop_off+0x38>
    800071d4:	5d7c                	lw	a5,124(a0)
    800071d6:	c799                	beqz	a5,800071e4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800071d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800071dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800071e0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800071e4:	60a2                	ld	ra,8(sp)
    800071e6:	6402                	ld	s0,0(sp)
    800071e8:	0141                	addi	sp,sp,16
    800071ea:	8082                	ret
    panic("pop_off - interruptible");
    800071ec:	00002517          	auipc	a0,0x2
    800071f0:	66450513          	addi	a0,a0,1636 # 80009850 <digits+0x28>
    800071f4:	00000097          	auipc	ra,0x0
    800071f8:	a1a080e7          	jalr	-1510(ra) # 80006c0e <panic>
    panic("pop_off");
    800071fc:	00002517          	auipc	a0,0x2
    80007200:	66c50513          	addi	a0,a0,1644 # 80009868 <digits+0x40>
    80007204:	00000097          	auipc	ra,0x0
    80007208:	a0a080e7          	jalr	-1526(ra) # 80006c0e <panic>

000000008000720c <release>:
{
    8000720c:	1101                	addi	sp,sp,-32
    8000720e:	ec06                	sd	ra,24(sp)
    80007210:	e822                	sd	s0,16(sp)
    80007212:	e426                	sd	s1,8(sp)
    80007214:	1000                	addi	s0,sp,32
    80007216:	84aa                	mv	s1,a0
  if(!holding(lk))
    80007218:	00000097          	auipc	ra,0x0
    8000721c:	ec6080e7          	jalr	-314(ra) # 800070de <holding>
    80007220:	c115                	beqz	a0,80007244 <release+0x38>
  lk->cpu = 0;
    80007222:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80007226:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000722a:	0f50000f          	fence	iorw,ow
    8000722e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80007232:	00000097          	auipc	ra,0x0
    80007236:	f7a080e7          	jalr	-134(ra) # 800071ac <pop_off>
}
    8000723a:	60e2                	ld	ra,24(sp)
    8000723c:	6442                	ld	s0,16(sp)
    8000723e:	64a2                	ld	s1,8(sp)
    80007240:	6105                	addi	sp,sp,32
    80007242:	8082                	ret
    panic("release");
    80007244:	00002517          	auipc	a0,0x2
    80007248:	62c50513          	addi	a0,a0,1580 # 80009870 <digits+0x48>
    8000724c:	00000097          	auipc	ra,0x0
    80007250:	9c2080e7          	jalr	-1598(ra) # 80006c0e <panic>

0000000080007254 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    80007254:	1141                	addi	sp,sp,-16
    80007256:	e422                	sd	s0,8(sp)
    80007258:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000725a:	0ff0000f          	fence
    8000725e:	6108                	ld	a0,0(a0)
    80007260:	0ff0000f          	fence
  return val;
}
    80007264:	6422                	ld	s0,8(sp)
    80007266:	0141                	addi	sp,sp,16
    80007268:	8082                	ret

000000008000726a <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    8000726a:	1141                	addi	sp,sp,-16
    8000726c:	e422                	sd	s0,8(sp)
    8000726e:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80007270:	0ff0000f          	fence
    80007274:	4108                	lw	a0,0(a0)
    80007276:	0ff0000f          	fence
  return val;
}
    8000727a:	2501                	sext.w	a0,a0
    8000727c:	6422                	ld	s0,8(sp)
    8000727e:	0141                	addi	sp,sp,16
    80007280:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
