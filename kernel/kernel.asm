
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	13013103          	ld	sp,304(sp) # 8000b130 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1d9050ef          	jal	800059ee <start>

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
    80000030:	00029797          	auipc	a5,0x29
    80000034:	21078793          	addi	a5,a5,528 # 80029240 <end>
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
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000c917          	auipc	s2,0xc
    80000054:	fe090913          	addi	s2,s2,-32 # 8000c030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3dc080e7          	jalr	988(ra) # 80006436 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	47c080e7          	jalr	1148(ra) # 800064ea <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	e32080e7          	jalr	-462(ra) # 80005ebc <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000c517          	auipc	a0,0xc
    800000f2:	f4250513          	addi	a0,a0,-190 # 8000c030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	2b0080e7          	jalr	688(ra) # 800063a6 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00029517          	auipc	a0,0x29
    80000106:	13e50513          	addi	a0,a0,318 # 80029240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000c497          	auipc	s1,0xc
    80000128:	f0c48493          	addi	s1,s1,-244 # 8000c030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	308080e7          	jalr	776(ra) # 80006436 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000c517          	auipc	a0,0xc
    80000140:	ef450513          	addi	a0,a0,-268 # 8000c030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	3a4080e7          	jalr	932(ra) # 800064ea <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000c517          	auipc	a0,0xc
    8000016c:	ec850513          	addi	a0,a0,-312 # 8000c030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	37a080e7          	jalr	890(ra) # 800064ea <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd5dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	c14080e7          	jalr	-1004(ra) # 80000f34 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	0000c717          	auipc	a4,0xc
    8000032c:	cd870713          	addi	a4,a4,-808 # 8000c000 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	bf8080e7          	jalr	-1032(ra) # 80000f34 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	bb8080e7          	jalr	-1096(ra) # 80005f06 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	904080e7          	jalr	-1788(ra) # 80001c62 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	03e080e7          	jalr	62(ra) # 800053a4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	1b0080e7          	jalr	432(ra) # 8000151e <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	a56080e7          	jalr	-1450(ra) # 80005dcc <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	d90080e7          	jalr	-624(ra) # 8000610e <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	b78080e7          	jalr	-1160(ra) # 80005f06 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	b68080e7          	jalr	-1176(ra) # 80005f06 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	b58080e7          	jalr	-1192(ra) # 80005f06 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	322080e7          	jalr	802(ra) # 800006e0 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	aaa080e7          	jalr	-1366(ra) # 80000e78 <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	864080e7          	jalr	-1948(ra) # 80001c3a <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	884080e7          	jalr	-1916(ra) # 80001c62 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	fa4080e7          	jalr	-92(ra) # 8000538a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	fb6080e7          	jalr	-74(ra) # 800053a4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	0ba080e7          	jalr	186(ra) # 800024b0 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	746080e7          	jalr	1862(ra) # 80002b44 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	6ea080e7          	jalr	1770(ra) # 80003af0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	0b6080e7          	jalr	182(ra) # 800054c4 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	ecc080e7          	jalr	-308(ra) # 800012e2 <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000c717          	auipc	a4,0xc
    80000428:	bcf72e23          	sw	a5,-1060(a4) # 8000c000 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000434:	0000c797          	auipc	a5,0xc
    80000438:	bd47b783          	ld	a5,-1068(a5) # 8000c008 <kernel_pagetable>
    8000043c:	83b1                	srli	a5,a5,0xc
    8000043e:	577d                	li	a4,-1
    80000440:	177e                	slli	a4,a4,0x3f
    80000442:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000444:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000448:	12000073          	sfence.vma
  sfence_vma();
}
    8000044c:	6422                	ld	s0,8(sp)
    8000044e:	0141                	addi	sp,sp,16
    80000450:	8082                	ret

0000000080000452 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000452:	7139                	addi	sp,sp,-64
    80000454:	fc06                	sd	ra,56(sp)
    80000456:	f822                	sd	s0,48(sp)
    80000458:	f426                	sd	s1,40(sp)
    8000045a:	f04a                	sd	s2,32(sp)
    8000045c:	ec4e                	sd	s3,24(sp)
    8000045e:	e852                	sd	s4,16(sp)
    80000460:	e456                	sd	s5,8(sp)
    80000462:	e05a                	sd	s6,0(sp)
    80000464:	0080                	addi	s0,sp,64
    80000466:	84aa                	mv	s1,a0
    80000468:	89ae                	mv	s3,a1
    8000046a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srli	a5,a5,0x1a
    80000470:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000472:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000474:	04b7f263          	bgeu	a5,a1,800004b8 <walk+0x66>
    panic("walk");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	addi	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	00006097          	auipc	ra,0x6
    80000484:	a3c080e7          	jalr	-1476(ra) # 80005ebc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000488:	060a8663          	beqz	s5,800004f4 <walk+0xa2>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	c8e080e7          	jalr	-882(ra) # 8000011a <kalloc>
    80000494:	84aa                	mv	s1,a0
    80000496:	c529                	beqz	a0,800004e0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000498:	6605                	lui	a2,0x1
    8000049a:	4581                	li	a1,0
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	cde080e7          	jalr	-802(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a4:	00c4d793          	srli	a5,s1,0xc
    800004a8:	07aa                	slli	a5,a5,0xa
    800004aa:	0017e793          	ori	a5,a5,1
    800004ae:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd5db7>
    800004b4:	036a0063          	beq	s4,s6,800004d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004b8:	0149d933          	srl	s2,s3,s4
    800004bc:	1ff97913          	andi	s2,s2,511
    800004c0:	090e                	slli	s2,s2,0x3
    800004c2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c4:	00093483          	ld	s1,0(s2)
    800004c8:	0014f793          	andi	a5,s1,1
    800004cc:	dfd5                	beqz	a5,80000488 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ce:	80a9                	srli	s1,s1,0xa
    800004d0:	04b2                	slli	s1,s1,0xc
    800004d2:	b7c5                	j	800004b2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d4:	00c9d513          	srli	a0,s3,0xc
    800004d8:	1ff57513          	andi	a0,a0,511
    800004dc:	050e                	slli	a0,a0,0x3
    800004de:	9526                	add	a0,a0,s1
}
    800004e0:	70e2                	ld	ra,56(sp)
    800004e2:	7442                	ld	s0,48(sp)
    800004e4:	74a2                	ld	s1,40(sp)
    800004e6:	7902                	ld	s2,32(sp)
    800004e8:	69e2                	ld	s3,24(sp)
    800004ea:	6a42                	ld	s4,16(sp)
    800004ec:	6aa2                	ld	s5,8(sp)
    800004ee:	6b02                	ld	s6,0(sp)
    800004f0:	6121                	addi	sp,sp,64
    800004f2:	8082                	ret
        return 0;
    800004f4:	4501                	li	a0,0
    800004f6:	b7ed                	j	800004e0 <walk+0x8e>

00000000800004f8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004f8:	57fd                	li	a5,-1
    800004fa:	83e9                	srli	a5,a5,0x1a
    800004fc:	00b7f463          	bgeu	a5,a1,80000504 <walkaddr+0xc>
    return 0;
    80000500:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000502:	8082                	ret
{
    80000504:	1141                	addi	sp,sp,-16
    80000506:	e406                	sd	ra,8(sp)
    80000508:	e022                	sd	s0,0(sp)
    8000050a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000050c:	4601                	li	a2,0
    8000050e:	00000097          	auipc	ra,0x0
    80000512:	f44080e7          	jalr	-188(ra) # 80000452 <walk>
  if(pte == 0)
    80000516:	c105                	beqz	a0,80000536 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000518:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051a:	0117f693          	andi	a3,a5,17
    8000051e:	4745                	li	a4,17
    return 0;
    80000520:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000522:	00e68663          	beq	a3,a4,8000052e <walkaddr+0x36>
}
    80000526:	60a2                	ld	ra,8(sp)
    80000528:	6402                	ld	s0,0(sp)
    8000052a:	0141                	addi	sp,sp,16
    8000052c:	8082                	ret
  pa = PTE2PA(*pte);
    8000052e:	83a9                	srli	a5,a5,0xa
    80000530:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000534:	bfcd                	j	80000526 <walkaddr+0x2e>
    return 0;
    80000536:	4501                	li	a0,0
    80000538:	b7fd                	j	80000526 <walkaddr+0x2e>

000000008000053a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053a:	715d                	addi	sp,sp,-80
    8000053c:	e486                	sd	ra,72(sp)
    8000053e:	e0a2                	sd	s0,64(sp)
    80000540:	fc26                	sd	s1,56(sp)
    80000542:	f84a                	sd	s2,48(sp)
    80000544:	f44e                	sd	s3,40(sp)
    80000546:	f052                	sd	s4,32(sp)
    80000548:	ec56                	sd	s5,24(sp)
    8000054a:	e85a                	sd	s6,16(sp)
    8000054c:	e45e                	sd	s7,8(sp)
    8000054e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000550:	c639                	beqz	a2,8000059e <mappages+0x64>
    80000552:	8aaa                	mv	s5,a0
    80000554:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000556:	777d                	lui	a4,0xfffff
    80000558:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000055c:	fff58993          	addi	s3,a1,-1
    80000560:	99b2                	add	s3,s3,a2
    80000562:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000566:	893e                	mv	s2,a5
    80000568:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000056c:	6b85                	lui	s7,0x1
    8000056e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000572:	4605                	li	a2,1
    80000574:	85ca                	mv	a1,s2
    80000576:	8556                	mv	a0,s5
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	eda080e7          	jalr	-294(ra) # 80000452 <walk>
    80000580:	cd1d                	beqz	a0,800005be <mappages+0x84>
    if(*pte & PTE_V)
    80000582:	611c                	ld	a5,0(a0)
    80000584:	8b85                	andi	a5,a5,1
    80000586:	e785                	bnez	a5,800005ae <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000588:	80b1                	srli	s1,s1,0xc
    8000058a:	04aa                	slli	s1,s1,0xa
    8000058c:	0164e4b3          	or	s1,s1,s6
    80000590:	0014e493          	ori	s1,s1,1
    80000594:	e104                	sd	s1,0(a0)
    if(a == last)
    80000596:	05390063          	beq	s2,s3,800005d6 <mappages+0x9c>
    a += PGSIZE;
    8000059a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059c:	bfc9                	j	8000056e <mappages+0x34>
    panic("mappages: size");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	addi	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	916080e7          	jalr	-1770(ra) # 80005ebc <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	906080e7          	jalr	-1786(ra) # 80005ebc <panic>
      return -1;
    800005be:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c0:	60a6                	ld	ra,72(sp)
    800005c2:	6406                	ld	s0,64(sp)
    800005c4:	74e2                	ld	s1,56(sp)
    800005c6:	7942                	ld	s2,48(sp)
    800005c8:	79a2                	ld	s3,40(sp)
    800005ca:	7a02                	ld	s4,32(sp)
    800005cc:	6ae2                	ld	s5,24(sp)
    800005ce:	6b42                	ld	s6,16(sp)
    800005d0:	6ba2                	ld	s7,8(sp)
    800005d2:	6161                	addi	sp,sp,80
    800005d4:	8082                	ret
  return 0;
    800005d6:	4501                	li	a0,0
    800005d8:	b7e5                	j	800005c0 <mappages+0x86>

00000000800005da <kvmmap>:
{
    800005da:	1141                	addi	sp,sp,-16
    800005dc:	e406                	sd	ra,8(sp)
    800005de:	e022                	sd	s0,0(sp)
    800005e0:	0800                	addi	s0,sp,16
    800005e2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005e4:	86b2                	mv	a3,a2
    800005e6:	863e                	mv	a2,a5
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	f52080e7          	jalr	-174(ra) # 8000053a <mappages>
    800005f0:	e509                	bnez	a0,800005fa <kvmmap+0x20>
}
    800005f2:	60a2                	ld	ra,8(sp)
    800005f4:	6402                	ld	s0,0(sp)
    800005f6:	0141                	addi	sp,sp,16
    800005f8:	8082                	ret
    panic("kvmmap");
    800005fa:	00008517          	auipc	a0,0x8
    800005fe:	a7e50513          	addi	a0,a0,-1410 # 80008078 <etext+0x78>
    80000602:	00006097          	auipc	ra,0x6
    80000606:	8ba080e7          	jalr	-1862(ra) # 80005ebc <panic>

000000008000060a <kvmmake>:
{
    8000060a:	1101                	addi	sp,sp,-32
    8000060c:	ec06                	sd	ra,24(sp)
    8000060e:	e822                	sd	s0,16(sp)
    80000610:	e426                	sd	s1,8(sp)
    80000612:	e04a                	sd	s2,0(sp)
    80000614:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b04080e7          	jalr	-1276(ra) # 8000011a <kalloc>
    8000061e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000620:	6605                	lui	a2,0x1
    80000622:	4581                	li	a1,0
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b56080e7          	jalr	-1194(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000062c:	4719                	li	a4,6
    8000062e:	6685                	lui	a3,0x1
    80000630:	10000637          	lui	a2,0x10000
    80000634:	100005b7          	lui	a1,0x10000
    80000638:	8526                	mv	a0,s1
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	fa0080e7          	jalr	-96(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000642:	4719                	li	a4,6
    80000644:	6685                	lui	a3,0x1
    80000646:	10001637          	lui	a2,0x10001
    8000064a:	100015b7          	lui	a1,0x10001
    8000064e:	8526                	mv	a0,s1
    80000650:	00000097          	auipc	ra,0x0
    80000654:	f8a080e7          	jalr	-118(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	004006b7          	lui	a3,0x400
    8000065e:	0c000637          	lui	a2,0xc000
    80000662:	0c0005b7          	lui	a1,0xc000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f72080e7          	jalr	-142(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000670:	00008917          	auipc	s2,0x8
    80000674:	99090913          	addi	s2,s2,-1648 # 80008000 <etext>
    80000678:	4729                	li	a4,10
    8000067a:	80008697          	auipc	a3,0x80008
    8000067e:	98668693          	addi	a3,a3,-1658 # 8000 <_entry-0x7fff8000>
    80000682:	4605                	li	a2,1
    80000684:	067e                	slli	a2,a2,0x1f
    80000686:	85b2                	mv	a1,a2
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	f50080e7          	jalr	-176(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000692:	46c5                	li	a3,17
    80000694:	06ee                	slli	a3,a3,0x1b
    80000696:	4719                	li	a4,6
    80000698:	412686b3          	sub	a3,a3,s2
    8000069c:	864a                	mv	a2,s2
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f38080e7          	jalr	-200(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006aa:	4729                	li	a4,10
    800006ac:	6685                	lui	a3,0x1
    800006ae:	00007617          	auipc	a2,0x7
    800006b2:	95260613          	addi	a2,a2,-1710 # 80007000 <_trampoline>
    800006b6:	040005b7          	lui	a1,0x4000
    800006ba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006bc:	05b2                	slli	a1,a1,0xc
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f1a080e7          	jalr	-230(ra) # 800005da <kvmmap>
  proc_mapstacks(kpgtbl);
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	70c080e7          	jalr	1804(ra) # 80000dd6 <proc_mapstacks>
}
    800006d2:	8526                	mv	a0,s1
    800006d4:	60e2                	ld	ra,24(sp)
    800006d6:	6442                	ld	s0,16(sp)
    800006d8:	64a2                	ld	s1,8(sp)
    800006da:	6902                	ld	s2,0(sp)
    800006dc:	6105                	addi	sp,sp,32
    800006de:	8082                	ret

00000000800006e0 <kvminit>:
{
    800006e0:	1141                	addi	sp,sp,-16
    800006e2:	e406                	sd	ra,8(sp)
    800006e4:	e022                	sd	s0,0(sp)
    800006e6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f22080e7          	jalr	-222(ra) # 8000060a <kvmmake>
    800006f0:	0000c797          	auipc	a5,0xc
    800006f4:	90a7bc23          	sd	a0,-1768(a5) # 8000c008 <kernel_pagetable>
}
    800006f8:	60a2                	ld	ra,8(sp)
    800006fa:	6402                	ld	s0,0(sp)
    800006fc:	0141                	addi	sp,sp,16
    800006fe:	8082                	ret

0000000080000700 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000700:	715d                	addi	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000708:	03459793          	slli	a5,a1,0x34
    8000070c:	e39d                	bnez	a5,80000732 <uvmunmap+0x32>
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	8a2a                	mv	s4,a0
    8000071c:	892e                	mv	s2,a1
    8000071e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	slli	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	6b05                	lui	s6,0x1
    8000072a:	0935fb63          	bgeu	a1,s3,800007c0 <uvmunmap+0xc0>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a8a9                	j	8000078a <uvmunmap+0x8a>
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000740:	00008517          	auipc	a0,0x8
    80000744:	94050513          	addi	a0,a0,-1728 # 80008080 <etext+0x80>
    80000748:	00005097          	auipc	ra,0x5
    8000074c:	774080e7          	jalr	1908(ra) # 80005ebc <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	764080e7          	jalr	1892(ra) # 80005ebc <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	754080e7          	jalr	1876(ra) # 80005ebc <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	744080e7          	jalr	1860(ra) # 80005ebc <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	995a                	add	s2,s2,s6
    80000786:	03397c63          	bgeu	s2,s3,800007be <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	cc2080e7          	jalr	-830(ra) # 80000452 <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d95d                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000079c:	6108                	ld	a0,0(a0)
    8000079e:	00157793          	andi	a5,a0,1
    800007a2:	dfdd                	beqz	a5,80000760 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff57793          	andi	a5,a0,1023
    800007a8:	fd7784e3          	beq	a5,s7,80000770 <uvmunmap+0x70>
    if(do_free){
    800007ac:	fc0a8ae3          	beqz	s5,80000780 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007b0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007b2:	0532                	slli	a0,a0,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7d1                	j	80000780 <uvmunmap+0x80>
    800007be:	74e2                	ld	s1,56(sp)
    800007c0:	7942                	ld	s2,48(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	7a02                	ld	s4,32(sp)
    800007c6:	6ae2                	ld	s5,24(sp)
    800007c8:	6b42                	ld	s6,16(sp)
    800007ca:	6ba2                	ld	s7,8(sp)
  }
}
    800007cc:	60a6                	ld	ra,72(sp)
    800007ce:	6406                	ld	s0,64(sp)
    800007d0:	6161                	addi	sp,sp,80
    800007d2:	8082                	ret

00000000800007d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d4:	1101                	addi	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	93c080e7          	jalr	-1732(ra) # 8000011a <kalloc>
    800007e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e8:	c519                	beqz	a0,800007f6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ea:	6605                	lui	a2,0x1
    800007ec:	4581                	li	a1,0
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	98c080e7          	jalr	-1652(ra) # 8000017a <memset>
  return pagetable;
}
    800007f6:	8526                	mv	a0,s1
    800007f8:	60e2                	ld	ra,24(sp)
    800007fa:	6442                	ld	s0,16(sp)
    800007fc:	64a2                	ld	s1,8(sp)
    800007fe:	6105                	addi	sp,sp,32
    80000800:	8082                	ret

0000000080000802 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000802:	7179                	addi	sp,sp,-48
    80000804:	f406                	sd	ra,40(sp)
    80000806:	f022                	sd	s0,32(sp)
    80000808:	ec26                	sd	s1,24(sp)
    8000080a:	e84a                	sd	s2,16(sp)
    8000080c:	e44e                	sd	s3,8(sp)
    8000080e:	e052                	sd	s4,0(sp)
    80000810:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000812:	6785                	lui	a5,0x1
    80000814:	04f67863          	bgeu	a2,a5,80000864 <uvminit+0x62>
    80000818:	8a2a                	mv	s4,a0
    8000081a:	89ae                	mv	s3,a1
    8000081c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fc080e7          	jalr	-1796(ra) # 8000011a <kalloc>
    80000826:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	94e080e7          	jalr	-1714(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000834:	4779                	li	a4,30
    80000836:	86ca                	mv	a3,s2
    80000838:	6605                	lui	a2,0x1
    8000083a:	4581                	li	a1,0
    8000083c:	8552                	mv	a0,s4
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	cfc080e7          	jalr	-772(ra) # 8000053a <mappages>
  memmove(mem, src, sz);
    80000846:	8626                	mv	a2,s1
    80000848:	85ce                	mv	a1,s3
    8000084a:	854a                	mv	a0,s2
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	98a080e7          	jalr	-1654(ra) # 800001d6 <memmove>
}
    80000854:	70a2                	ld	ra,40(sp)
    80000856:	7402                	ld	s0,32(sp)
    80000858:	64e2                	ld	s1,24(sp)
    8000085a:	6942                	ld	s2,16(sp)
    8000085c:	69a2                	ld	s3,8(sp)
    8000085e:	6a02                	ld	s4,0(sp)
    80000860:	6145                	addi	sp,sp,48
    80000862:	8082                	ret
    panic("inituvm: more than a page");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	87450513          	addi	a0,a0,-1932 # 800080d8 <etext+0xd8>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	650080e7          	jalr	1616(ra) # 80005ebc <panic>

0000000080000874 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000874:	1101                	addi	sp,sp,-32
    80000876:	ec06                	sd	ra,24(sp)
    80000878:	e822                	sd	s0,16(sp)
    8000087a:	e426                	sd	s1,8(sp)
    8000087c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000880:	00b67d63          	bgeu	a2,a1,8000089a <uvmdealloc+0x26>
    80000884:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	00f60733          	add	a4,a2,a5
    8000088e:	76fd                	lui	a3,0xfffff
    80000890:	8f75                	and	a4,a4,a3
    80000892:	97ae                	add	a5,a5,a1
    80000894:	8ff5                	and	a5,a5,a3
    80000896:	00f76863          	bltu	a4,a5,800008a6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089a:	8526                	mv	a0,s1
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a6:	8f99                	sub	a5,a5,a4
    800008a8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008aa:	4685                	li	a3,1
    800008ac:	0007861b          	sext.w	a2,a5
    800008b0:	85ba                	mv	a1,a4
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	e4e080e7          	jalr	-434(ra) # 80000700 <uvmunmap>
    800008ba:	b7c5                	j	8000089a <uvmdealloc+0x26>

00000000800008bc <uvmalloc>:
  if(newsz < oldsz)
    800008bc:	0ab66563          	bltu	a2,a1,80000966 <uvmalloc+0xaa>
{
    800008c0:	7139                	addi	sp,sp,-64
    800008c2:	fc06                	sd	ra,56(sp)
    800008c4:	f822                	sd	s0,48(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f663          	bgeu	s3,a2,8000096a <uvmalloc+0xae>
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	894e                	mv	s2,s3
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c90d                	beqz	a0,80000924 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000900:	4779                	li	a4,30
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c30080e7          	jalr	-976(ra) # 8000053a <mappages>
    80000912:	e915                	bnez	a0,80000946 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x2c>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	a819                	j	80000938 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000924:	864e                	mv	a2,s3
    80000926:	85ca                	mv	a1,s2
    80000928:	8556                	mv	a0,s5
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	f4a080e7          	jalr	-182(ra) # 80000874 <uvmdealloc>
      return 0;
    80000932:	4501                	li	a0,0
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	69e2                	ld	s3,24(sp)
    8000093e:	6a42                	ld	s4,16(sp)
    80000940:	6aa2                	ld	s5,8(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1e080e7          	jalr	-226(ra) # 80000874 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	bfd1                	j	80000938 <uvmalloc+0x7c>
    return oldsz;
    80000966:	852e                	mv	a0,a1
}
    80000968:	8082                	ret
  return newsz;
    8000096a:	8532                	mv	a0,a2
    8000096c:	b7f1                	j	80000938 <uvmalloc+0x7c>

000000008000096e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096e:	7179                	addi	sp,sp,-48
    80000970:	f406                	sd	ra,40(sp)
    80000972:	f022                	sd	s0,32(sp)
    80000974:	ec26                	sd	s1,24(sp)
    80000976:	e84a                	sd	s2,16(sp)
    80000978:	e44e                	sd	s3,8(sp)
    8000097a:	e052                	sd	s4,0(sp)
    8000097c:	1800                	addi	s0,sp,48
    8000097e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000980:	84aa                	mv	s1,a0
    80000982:	6905                	lui	s2,0x1
    80000984:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	4985                	li	s3,1
    80000988:	a829                	j	800009a2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000098c:	00c79513          	slli	a0,a5,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fde080e7          	jalr	-34(ra) # 8000096e <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009a2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f7f713          	andi	a4,a5,15
    800009a8:	ff3701e3          	beq	a4,s3,8000098a <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8b85                	andi	a5,a5,1
    800009ae:	d7fd                	beqz	a5,8000099c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	504080e7          	jalr	1284(ra) # 80005ebc <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f84080e7          	jalr	-124(ra) # 8000096e <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6785                	lui	a5,0x1
    800009fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a00:	95be                	add	a1,a1,a5
    80000a02:	4685                	li	a3,1
    80000a04:	00c5d613          	srli	a2,a1,0xc
    80000a08:	4581                	li	a1,0
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	cf6080e7          	jalr	-778(ra) # 80000700 <uvmunmap>
    80000a12:	bfd9                	j	800009e8 <uvmfree+0xe>

0000000080000a14 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a14:	c679                	beqz	a2,80000ae2 <uvmcopy+0xce>
{
    80000a16:	715d                	addi	sp,sp,-80
    80000a18:	e486                	sd	ra,72(sp)
    80000a1a:	e0a2                	sd	s0,64(sp)
    80000a1c:	fc26                	sd	s1,56(sp)
    80000a1e:	f84a                	sd	s2,48(sp)
    80000a20:	f44e                	sd	s3,40(sp)
    80000a22:	f052                	sd	s4,32(sp)
    80000a24:	ec56                	sd	s5,24(sp)
    80000a26:	e85a                	sd	s6,16(sp)
    80000a28:	e45e                	sd	s7,8(sp)
    80000a2a:	0880                	addi	s0,sp,80
    80000a2c:	8b2a                	mv	s6,a0
    80000a2e:	8aae                	mv	s5,a1
    80000a30:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a34:	4601                	li	a2,0
    80000a36:	85ce                	mv	a1,s3
    80000a38:	855a                	mv	a0,s6
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	a18080e7          	jalr	-1512(ra) # 80000452 <walk>
    80000a42:	c531                	beqz	a0,80000a8e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a44:	6118                	ld	a4,0(a0)
    80000a46:	00177793          	andi	a5,a4,1
    80000a4a:	cbb1                	beqz	a5,80000a9e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4c:	00a75593          	srli	a1,a4,0xa
    80000a50:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a54:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	6c2080e7          	jalr	1730(ra) # 8000011a <kalloc>
    80000a60:	892a                	mv	s2,a0
    80000a62:	c939                	beqz	a0,80000ab8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85de                	mv	a1,s7
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a70:	8726                	mv	a4,s1
    80000a72:	86ca                	mv	a3,s2
    80000a74:	6605                	lui	a2,0x1
    80000a76:	85ce                	mv	a1,s3
    80000a78:	8556                	mv	a0,s5
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ac0080e7          	jalr	-1344(ra) # 8000053a <mappages>
    80000a82:	e515                	bnez	a0,80000aae <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a84:	6785                	lui	a5,0x1
    80000a86:	99be                	add	s3,s3,a5
    80000a88:	fb49e6e3          	bltu	s3,s4,80000a34 <uvmcopy+0x20>
    80000a8c:	a081                	j	80000acc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	67a50513          	addi	a0,a0,1658 # 80008108 <etext+0x108>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	426080e7          	jalr	1062(ra) # 80005ebc <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	416080e7          	jalr	1046(ra) # 80005ebc <panic>
      kfree(mem);
    80000aae:	854a                	mv	a0,s2
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	56c080e7          	jalr	1388(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab8:	4685                	li	a3,1
    80000aba:	00c9d613          	srli	a2,s3,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	c3e080e7          	jalr	-962(ra) # 80000700 <uvmunmap>
  return -1;
    80000aca:	557d                	li	a0,-1
}
    80000acc:	60a6                	ld	ra,72(sp)
    80000ace:	6406                	ld	s0,64(sp)
    80000ad0:	74e2                	ld	s1,56(sp)
    80000ad2:	7942                	ld	s2,48(sp)
    80000ad4:	79a2                	ld	s3,40(sp)
    80000ad6:	7a02                	ld	s4,32(sp)
    80000ad8:	6ae2                	ld	s5,24(sp)
    80000ada:	6b42                	ld	s6,16(sp)
    80000adc:	6ba2                	ld	s7,8(sp)
    80000ade:	6161                	addi	sp,sp,80
    80000ae0:	8082                	ret
  return 0;
    80000ae2:	4501                	li	a0,0
}
    80000ae4:	8082                	ret

0000000080000ae6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae6:	1141                	addi	sp,sp,-16
    80000ae8:	e406                	sd	ra,8(sp)
    80000aea:	e022                	sd	s0,0(sp)
    80000aec:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aee:	4601                	li	a2,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	962080e7          	jalr	-1694(ra) # 80000452 <walk>
  if(pte == 0)
    80000af8:	c901                	beqz	a0,80000b08 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000afa:	611c                	ld	a5,0(a0)
    80000afc:	9bbd                	andi	a5,a5,-17
    80000afe:	e11c                	sd	a5,0(a0)
}
    80000b00:	60a2                	ld	ra,8(sp)
    80000b02:	6402                	ld	s0,0(sp)
    80000b04:	0141                	addi	sp,sp,16
    80000b06:	8082                	ret
    panic("uvmclear");
    80000b08:	00007517          	auipc	a0,0x7
    80000b0c:	64050513          	addi	a0,a0,1600 # 80008148 <etext+0x148>
    80000b10:	00005097          	auipc	ra,0x5
    80000b14:	3ac080e7          	jalr	940(ra) # 80005ebc <panic>

0000000080000b18 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b18:	c6bd                	beqz	a3,80000b86 <copyout+0x6e>
{
    80000b1a:	715d                	addi	sp,sp,-80
    80000b1c:	e486                	sd	ra,72(sp)
    80000b1e:	e0a2                	sd	s0,64(sp)
    80000b20:	fc26                	sd	s1,56(sp)
    80000b22:	f84a                	sd	s2,48(sp)
    80000b24:	f44e                	sd	s3,40(sp)
    80000b26:	f052                	sd	s4,32(sp)
    80000b28:	ec56                	sd	s5,24(sp)
    80000b2a:	e85a                	sd	s6,16(sp)
    80000b2c:	e45e                	sd	s7,8(sp)
    80000b2e:	e062                	sd	s8,0(sp)
    80000b30:	0880                	addi	s0,sp,80
    80000b32:	8b2a                	mv	s6,a0
    80000b34:	8c2e                	mv	s8,a1
    80000b36:	8a32                	mv	s4,a2
    80000b38:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3c:	6a85                	lui	s5,0x1
    80000b3e:	a015                	j	80000b62 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b40:	9562                	add	a0,a0,s8
    80000b42:	0004861b          	sext.w	a2,s1
    80000b46:	85d2                	mv	a1,s4
    80000b48:	41250533          	sub	a0,a0,s2
    80000b4c:	fffff097          	auipc	ra,0xfffff
    80000b50:	68a080e7          	jalr	1674(ra) # 800001d6 <memmove>

    len -= n;
    80000b54:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b58:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b5a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5e:	02098263          	beqz	s3,80000b82 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b62:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b66:	85ca                	mv	a1,s2
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	98e080e7          	jalr	-1650(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b72:	cd01                	beqz	a0,80000b8a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b74:	418904b3          	sub	s1,s2,s8
    80000b78:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b7a:	fc99f3e3          	bgeu	s3,s1,80000b40 <copyout+0x28>
    80000b7e:	84ce                	mv	s1,s3
    80000b80:	b7c1                	j	80000b40 <copyout+0x28>
  }
  return 0;
    80000b82:	4501                	li	a0,0
    80000b84:	a021                	j	80000b8c <copyout+0x74>
    80000b86:	4501                	li	a0,0
}
    80000b88:	8082                	ret
      return -1;
    80000b8a:	557d                	li	a0,-1
}
    80000b8c:	60a6                	ld	ra,72(sp)
    80000b8e:	6406                	ld	s0,64(sp)
    80000b90:	74e2                	ld	s1,56(sp)
    80000b92:	7942                	ld	s2,48(sp)
    80000b94:	79a2                	ld	s3,40(sp)
    80000b96:	7a02                	ld	s4,32(sp)
    80000b98:	6ae2                	ld	s5,24(sp)
    80000b9a:	6b42                	ld	s6,16(sp)
    80000b9c:	6ba2                	ld	s7,8(sp)
    80000b9e:	6c02                	ld	s8,0(sp)
    80000ba0:	6161                	addi	sp,sp,80
    80000ba2:	8082                	ret

0000000080000ba4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba4:	caa5                	beqz	a3,80000c14 <copyin+0x70>
{
    80000ba6:	715d                	addi	sp,sp,-80
    80000ba8:	e486                	sd	ra,72(sp)
    80000baa:	e0a2                	sd	s0,64(sp)
    80000bac:	fc26                	sd	s1,56(sp)
    80000bae:	f84a                	sd	s2,48(sp)
    80000bb0:	f44e                	sd	s3,40(sp)
    80000bb2:	f052                	sd	s4,32(sp)
    80000bb4:	ec56                	sd	s5,24(sp)
    80000bb6:	e85a                	sd	s6,16(sp)
    80000bb8:	e45e                	sd	s7,8(sp)
    80000bba:	e062                	sd	s8,0(sp)
    80000bbc:	0880                	addi	s0,sp,80
    80000bbe:	8b2a                	mv	s6,a0
    80000bc0:	8a2e                	mv	s4,a1
    80000bc2:	8c32                	mv	s8,a2
    80000bc4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a01d                	j	80000bf0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bcc:	018505b3          	add	a1,a0,s8
    80000bd0:	0004861b          	sext.w	a2,s1
    80000bd4:	412585b3          	sub	a1,a1,s2
    80000bd8:	8552                	mv	a0,s4
    80000bda:	fffff097          	auipc	ra,0xfffff
    80000bde:	5fc080e7          	jalr	1532(ra) # 800001d6 <memmove>

    len -= n;
    80000be2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bec:	02098263          	beqz	s3,80000c10 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bf0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ca                	mv	a1,s2
    80000bf6:	855a                	mv	a0,s6
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	900080e7          	jalr	-1792(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c00:	cd01                	beqz	a0,80000c18 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c02:	418904b3          	sub	s1,s2,s8
    80000c06:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c08:	fc99f2e3          	bgeu	s3,s1,80000bcc <copyin+0x28>
    80000c0c:	84ce                	mv	s1,s3
    80000c0e:	bf7d                	j	80000bcc <copyin+0x28>
  }
  return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	a021                	j	80000c1a <copyin+0x76>
    80000c14:	4501                	li	a0,0
}
    80000c16:	8082                	ret
      return -1;
    80000c18:	557d                	li	a0,-1
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6c02                	ld	s8,0(sp)
    80000c2e:	6161                	addi	sp,sp,80
    80000c30:	8082                	ret

0000000080000c32 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c32:	cacd                	beqz	a3,80000ce4 <copyinstr+0xb2>
{
    80000c34:	715d                	addi	sp,sp,-80
    80000c36:	e486                	sd	ra,72(sp)
    80000c38:	e0a2                	sd	s0,64(sp)
    80000c3a:	fc26                	sd	s1,56(sp)
    80000c3c:	f84a                	sd	s2,48(sp)
    80000c3e:	f44e                	sd	s3,40(sp)
    80000c40:	f052                	sd	s4,32(sp)
    80000c42:	ec56                	sd	s5,24(sp)
    80000c44:	e85a                	sd	s6,16(sp)
    80000c46:	e45e                	sd	s7,8(sp)
    80000c48:	0880                	addi	s0,sp,80
    80000c4a:	8a2a                	mv	s4,a0
    80000c4c:	8b2e                	mv	s6,a1
    80000c4e:	8bb2                	mv	s7,a2
    80000c50:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c52:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c54:	6985                	lui	s3,0x1
    80000c56:	a825                	j	80000c8e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c58:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c5c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5e:	37fd                	addiw	a5,a5,-1
    80000c60:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c64:	60a6                	ld	ra,72(sp)
    80000c66:	6406                	ld	s0,64(sp)
    80000c68:	74e2                	ld	s1,56(sp)
    80000c6a:	7942                	ld	s2,48(sp)
    80000c6c:	79a2                	ld	s3,40(sp)
    80000c6e:	7a02                	ld	s4,32(sp)
    80000c70:	6ae2                	ld	s5,24(sp)
    80000c72:	6b42                	ld	s6,16(sp)
    80000c74:	6ba2                	ld	s7,8(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret
    80000c7a:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c7e:	9742                	add	a4,a4,a6
      --max;
    80000c80:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c84:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c88:	04e58663          	beq	a1,a4,80000cd4 <copyinstr+0xa2>
{
    80000c8c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c8e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c92:	85a6                	mv	a1,s1
    80000c94:	8552                	mv	a0,s4
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	862080e7          	jalr	-1950(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c9e:	cd0d                	beqz	a0,80000cd8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000ca0:	417486b3          	sub	a3,s1,s7
    80000ca4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ca6:	00d97363          	bgeu	s2,a3,80000cac <copyinstr+0x7a>
    80000caa:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cac:	955e                	add	a0,a0,s7
    80000cae:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cb0:	c695                	beqz	a3,80000cdc <copyinstr+0xaa>
    80000cb2:	87da                	mv	a5,s6
    80000cb4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cb6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000cba:	96da                	add	a3,a3,s6
    80000cbc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cbe:	00f60733          	add	a4,a2,a5
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd5dc0>
    80000cc6:	db49                	beqz	a4,80000c58 <copyinstr+0x26>
        *dst = *p;
    80000cc8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ccc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cce:	fed797e3          	bne	a5,a3,80000cbc <copyinstr+0x8a>
    80000cd2:	b765                	j	80000c7a <copyinstr+0x48>
    80000cd4:	4781                	li	a5,0
    80000cd6:	b761                	j	80000c5e <copyinstr+0x2c>
      return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	b769                	j	80000c64 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cdc:	6b85                	lui	s7,0x1
    80000cde:	9ba6                	add	s7,s7,s1
    80000ce0:	87da                	mv	a5,s6
    80000ce2:	b76d                	j	80000c8c <copyinstr+0x5a>
  int got_null = 0;
    80000ce4:	4781                	li	a5,0
  if(got_null){
    80000ce6:	37fd                	addiw	a5,a5,-1
    80000ce8:	0007851b          	sext.w	a0,a5
}
    80000cec:	8082                	ret

0000000080000cee <vmprint>:
void vmprint(pagetable_t pagetable,int depth)
{
    80000cee:	7159                	addi	sp,sp,-112
    80000cf0:	f486                	sd	ra,104(sp)
    80000cf2:	f0a2                	sd	s0,96(sp)
    80000cf4:	eca6                	sd	s1,88(sp)
    80000cf6:	e8ca                	sd	s2,80(sp)
    80000cf8:	e4ce                	sd	s3,72(sp)
    80000cfa:	e0d2                	sd	s4,64(sp)
    80000cfc:	fc56                	sd	s5,56(sp)
    80000cfe:	f85a                	sd	s6,48(sp)
    80000d00:	f45e                	sd	s7,40(sp)
    80000d02:	f062                	sd	s8,32(sp)
    80000d04:	ec66                	sd	s9,24(sp)
    80000d06:	e86a                	sd	s10,16(sp)
    80000d08:	e46e                	sd	s11,8(sp)
    80000d0a:	1880                	addi	s0,sp,112
    80000d0c:	8a2a                	mv	s4,a0
    80000d0e:	8aae                	mv	s5,a1
  if(depth==1)
    80000d10:	4785                	li	a5,1
    80000d12:	02f58563          	beq	a1,a5,80000d3c <vmprint+0x4e>
{
    80000d16:	4981                	li	s3,0
        printf("..");
        if(j!=depth-1)
        printf(" ");
      }
      uint64 child = PTE2PA(pte);
      printf("%d: pte %p pa %p\n",i,pte,child);
    80000d18:	00007d17          	auipc	s10,0x7
    80000d1c:	460d0d13          	addi	s10,s10,1120 # 80008178 <etext+0x178>
      for(int j=0;j<depth;j++)
    80000d20:	4d81                	li	s11,0
        printf("..");
    80000d22:	00007b97          	auipc	s7,0x7
    80000d26:	446b8b93          	addi	s7,s7,1094 # 80008168 <etext+0x168>
        if(j!=depth-1)
    80000d2a:	fffa8b1b          	addiw	s6,s5,-1 # ffffffffffffefff <end+0xffffffff7ffd5dbf>
        printf(" ");
    80000d2e:	00007c17          	auipc	s8,0x7
    80000d32:	442c0c13          	addi	s8,s8,1090 # 80008170 <etext+0x170>
  for(int i = 0; i < 512; i++){
    80000d36:	20000c93          	li	s9,512
    80000d3a:	a8b1                	j	80000d96 <vmprint+0xa8>
    printf("page table %p\n",pagetable);
    80000d3c:	85aa                	mv	a1,a0
    80000d3e:	00007517          	auipc	a0,0x7
    80000d42:	41a50513          	addi	a0,a0,1050 # 80008158 <etext+0x158>
    80000d46:	00005097          	auipc	ra,0x5
    80000d4a:	1c0080e7          	jalr	448(ra) # 80005f06 <printf>
    80000d4e:	b7e1                	j	80000d16 <vmprint+0x28>
        printf(" ");
    80000d50:	8562                	mv	a0,s8
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	1b4080e7          	jalr	436(ra) # 80005f06 <printf>
      for(int j=0;j<depth;j++)
    80000d5a:	2485                	addiw	s1,s1,1
    80000d5c:	009a8a63          	beq	s5,s1,80000d70 <vmprint+0x82>
        printf("..");
    80000d60:	855e                	mv	a0,s7
    80000d62:	00005097          	auipc	ra,0x5
    80000d66:	1a4080e7          	jalr	420(ra) # 80005f06 <printf>
        if(j!=depth-1)
    80000d6a:	fe9b13e3          	bne	s6,s1,80000d50 <vmprint+0x62>
    80000d6e:	b7f5                	j	80000d5a <vmprint+0x6c>
      uint64 child = PTE2PA(pte);
    80000d70:	00a95493          	srli	s1,s2,0xa
    80000d74:	04b2                	slli	s1,s1,0xc
      printf("%d: pte %p pa %p\n",i,pte,child);
    80000d76:	86a6                	mv	a3,s1
    80000d78:	864a                	mv	a2,s2
    80000d7a:	85ce                	mv	a1,s3
    80000d7c:	856a                	mv	a0,s10
    80000d7e:	00005097          	auipc	ra,0x5
    80000d82:	188080e7          	jalr	392(ra) # 80005f06 <printf>
      if((pte & (PTE_R|PTE_W|PTE_X))==0)
    80000d86:	00e97913          	andi	s2,s2,14
    80000d8a:	00090f63          	beqz	s2,80000da8 <vmprint+0xba>
  for(int i = 0; i < 512; i++){
    80000d8e:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000d90:	0a21                	addi	s4,s4,8
    80000d92:	03998363          	beq	s3,s9,80000db8 <vmprint+0xca>
    pte_t pte = pagetable[i];
    80000d96:	000a3903          	ld	s2,0(s4)
    if(pte & PTE_V){
    80000d9a:	00197793          	andi	a5,s2,1
    80000d9e:	dbe5                	beqz	a5,80000d8e <vmprint+0xa0>
      for(int j=0;j<depth;j++)
    80000da0:	fd5058e3          	blez	s5,80000d70 <vmprint+0x82>
    80000da4:	84ee                	mv	s1,s11
    80000da6:	bf6d                	j	80000d60 <vmprint+0x72>
        vmprint((pagetable_t)child,depth+1);
    80000da8:	001a859b          	addiw	a1,s5,1
    80000dac:	8526                	mv	a0,s1
    80000dae:	00000097          	auipc	ra,0x0
    80000db2:	f40080e7          	jalr	-192(ra) # 80000cee <vmprint>
    80000db6:	bfe1                	j	80000d8e <vmprint+0xa0>
    }
  }
}
    80000db8:	70a6                	ld	ra,104(sp)
    80000dba:	7406                	ld	s0,96(sp)
    80000dbc:	64e6                	ld	s1,88(sp)
    80000dbe:	6946                	ld	s2,80(sp)
    80000dc0:	69a6                	ld	s3,72(sp)
    80000dc2:	6a06                	ld	s4,64(sp)
    80000dc4:	7ae2                	ld	s5,56(sp)
    80000dc6:	7b42                	ld	s6,48(sp)
    80000dc8:	7ba2                	ld	s7,40(sp)
    80000dca:	7c02                	ld	s8,32(sp)
    80000dcc:	6ce2                	ld	s9,24(sp)
    80000dce:	6d42                	ld	s10,16(sp)
    80000dd0:	6da2                	ld	s11,8(sp)
    80000dd2:	6165                	addi	sp,sp,112
    80000dd4:	8082                	ret

0000000080000dd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dd6:	7139                	addi	sp,sp,-64
    80000dd8:	fc06                	sd	ra,56(sp)
    80000dda:	f822                	sd	s0,48(sp)
    80000ddc:	f426                	sd	s1,40(sp)
    80000dde:	f04a                	sd	s2,32(sp)
    80000de0:	ec4e                	sd	s3,24(sp)
    80000de2:	e852                	sd	s4,16(sp)
    80000de4:	e456                	sd	s5,8(sp)
    80000de6:	e05a                	sd	s6,0(sp)
    80000de8:	0080                	addi	s0,sp,64
    80000dea:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dec:	0000b497          	auipc	s1,0xb
    80000df0:	69448493          	addi	s1,s1,1684 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000df4:	8b26                	mv	s6,s1
    80000df6:	ff4df937          	lui	s2,0xff4df
    80000dfa:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b577d>
    80000dfe:	0936                	slli	s2,s2,0xd
    80000e00:	6f590913          	addi	s2,s2,1781
    80000e04:	0936                	slli	s2,s2,0xd
    80000e06:	bd390913          	addi	s2,s2,-1069
    80000e0a:	0932                	slli	s2,s2,0xc
    80000e0c:	7a790913          	addi	s2,s2,1959
    80000e10:	010009b7          	lui	s3,0x1000
    80000e14:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000e16:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e18:	00011a97          	auipc	s5,0x11
    80000e1c:	268a8a93          	addi	s5,s5,616 # 80012080 <tickslock>
    char *pa = kalloc();
    80000e20:	fffff097          	auipc	ra,0xfffff
    80000e24:	2fa080e7          	jalr	762(ra) # 8000011a <kalloc>
    80000e28:	862a                	mv	a2,a0
    if(pa == 0)
    80000e2a:	cd1d                	beqz	a0,80000e68 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000e2c:	416485b3          	sub	a1,s1,s6
    80000e30:	8591                	srai	a1,a1,0x4
    80000e32:	032585b3          	mul	a1,a1,s2
    80000e36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e3a:	4719                	li	a4,6
    80000e3c:	6685                	lui	a3,0x1
    80000e3e:	40b985b3          	sub	a1,s3,a1
    80000e42:	8552                	mv	a0,s4
    80000e44:	fffff097          	auipc	ra,0xfffff
    80000e48:	796080e7          	jalr	1942(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4c:	17048493          	addi	s1,s1,368
    80000e50:	fd5498e3          	bne	s1,s5,80000e20 <proc_mapstacks+0x4a>
  }
}
    80000e54:	70e2                	ld	ra,56(sp)
    80000e56:	7442                	ld	s0,48(sp)
    80000e58:	74a2                	ld	s1,40(sp)
    80000e5a:	7902                	ld	s2,32(sp)
    80000e5c:	69e2                	ld	s3,24(sp)
    80000e5e:	6a42                	ld	s4,16(sp)
    80000e60:	6aa2                	ld	s5,8(sp)
    80000e62:	6b02                	ld	s6,0(sp)
    80000e64:	6121                	addi	sp,sp,64
    80000e66:	8082                	ret
      panic("kalloc");
    80000e68:	00007517          	auipc	a0,0x7
    80000e6c:	32850513          	addi	a0,a0,808 # 80008190 <etext+0x190>
    80000e70:	00005097          	auipc	ra,0x5
    80000e74:	04c080e7          	jalr	76(ra) # 80005ebc <panic>

0000000080000e78 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e78:	7139                	addi	sp,sp,-64
    80000e7a:	fc06                	sd	ra,56(sp)
    80000e7c:	f822                	sd	s0,48(sp)
    80000e7e:	f426                	sd	s1,40(sp)
    80000e80:	f04a                	sd	s2,32(sp)
    80000e82:	ec4e                	sd	s3,24(sp)
    80000e84:	e852                	sd	s4,16(sp)
    80000e86:	e456                	sd	s5,8(sp)
    80000e88:	e05a                	sd	s6,0(sp)
    80000e8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e8c:	00007597          	auipc	a1,0x7
    80000e90:	30c58593          	addi	a1,a1,780 # 80008198 <etext+0x198>
    80000e94:	0000b517          	auipc	a0,0xb
    80000e98:	1bc50513          	addi	a0,a0,444 # 8000c050 <pid_lock>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	50a080e7          	jalr	1290(ra) # 800063a6 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ea4:	00007597          	auipc	a1,0x7
    80000ea8:	2fc58593          	addi	a1,a1,764 # 800081a0 <etext+0x1a0>
    80000eac:	0000b517          	auipc	a0,0xb
    80000eb0:	1bc50513          	addi	a0,a0,444 # 8000c068 <wait_lock>
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	4f2080e7          	jalr	1266(ra) # 800063a6 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebc:	0000b497          	auipc	s1,0xb
    80000ec0:	5c448493          	addi	s1,s1,1476 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000ec4:	00007b17          	auipc	s6,0x7
    80000ec8:	2ecb0b13          	addi	s6,s6,748 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    80000ecc:	8aa6                	mv	s5,s1
    80000ece:	ff4df937          	lui	s2,0xff4df
    80000ed2:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b577d>
    80000ed6:	0936                	slli	s2,s2,0xd
    80000ed8:	6f590913          	addi	s2,s2,1781
    80000edc:	0936                	slli	s2,s2,0xd
    80000ede:	bd390913          	addi	s2,s2,-1069
    80000ee2:	0932                	slli	s2,s2,0xc
    80000ee4:	7a790913          	addi	s2,s2,1959
    80000ee8:	010009b7          	lui	s3,0x1000
    80000eec:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000eee:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef0:	00011a17          	auipc	s4,0x11
    80000ef4:	190a0a13          	addi	s4,s4,400 # 80012080 <tickslock>
      initlock(&p->lock, "proc");
    80000ef8:	85da                	mv	a1,s6
    80000efa:	8526                	mv	a0,s1
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	4aa080e7          	jalr	1194(ra) # 800063a6 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f04:	415487b3          	sub	a5,s1,s5
    80000f08:	8791                	srai	a5,a5,0x4
    80000f0a:	032787b3          	mul	a5,a5,s2
    80000f0e:	00d7979b          	slliw	a5,a5,0xd
    80000f12:	40f987b3          	sub	a5,s3,a5
    80000f16:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f18:	17048493          	addi	s1,s1,368
    80000f1c:	fd449ee3          	bne	s1,s4,80000ef8 <procinit+0x80>
  }
}
    80000f20:	70e2                	ld	ra,56(sp)
    80000f22:	7442                	ld	s0,48(sp)
    80000f24:	74a2                	ld	s1,40(sp)
    80000f26:	7902                	ld	s2,32(sp)
    80000f28:	69e2                	ld	s3,24(sp)
    80000f2a:	6a42                	ld	s4,16(sp)
    80000f2c:	6aa2                	ld	s5,8(sp)
    80000f2e:	6b02                	ld	s6,0(sp)
    80000f30:	6121                	addi	sp,sp,64
    80000f32:	8082                	ret

0000000080000f34 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f34:	1141                	addi	sp,sp,-16
    80000f36:	e422                	sd	s0,8(sp)
    80000f38:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f3a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f3c:	2501                	sext.w	a0,a0
    80000f3e:	6422                	ld	s0,8(sp)
    80000f40:	0141                	addi	sp,sp,16
    80000f42:	8082                	ret

0000000080000f44 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f44:	1141                	addi	sp,sp,-16
    80000f46:	e422                	sd	s0,8(sp)
    80000f48:	0800                	addi	s0,sp,16
    80000f4a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f4c:	2781                	sext.w	a5,a5
    80000f4e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f50:	0000b517          	auipc	a0,0xb
    80000f54:	13050513          	addi	a0,a0,304 # 8000c080 <cpus>
    80000f58:	953e                	add	a0,a0,a5
    80000f5a:	6422                	ld	s0,8(sp)
    80000f5c:	0141                	addi	sp,sp,16
    80000f5e:	8082                	ret

0000000080000f60 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f60:	1101                	addi	sp,sp,-32
    80000f62:	ec06                	sd	ra,24(sp)
    80000f64:	e822                	sd	s0,16(sp)
    80000f66:	e426                	sd	s1,8(sp)
    80000f68:	1000                	addi	s0,sp,32
  push_off();
    80000f6a:	00005097          	auipc	ra,0x5
    80000f6e:	480080e7          	jalr	1152(ra) # 800063ea <push_off>
    80000f72:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f74:	2781                	sext.w	a5,a5
    80000f76:	079e                	slli	a5,a5,0x7
    80000f78:	0000b717          	auipc	a4,0xb
    80000f7c:	0d870713          	addi	a4,a4,216 # 8000c050 <pid_lock>
    80000f80:	97ba                	add	a5,a5,a4
    80000f82:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f84:	00005097          	auipc	ra,0x5
    80000f88:	506080e7          	jalr	1286(ra) # 8000648a <pop_off>
  return p;
}
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	60e2                	ld	ra,24(sp)
    80000f90:	6442                	ld	s0,16(sp)
    80000f92:	64a2                	ld	s1,8(sp)
    80000f94:	6105                	addi	sp,sp,32
    80000f96:	8082                	ret

0000000080000f98 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f98:	1141                	addi	sp,sp,-16
    80000f9a:	e406                	sd	ra,8(sp)
    80000f9c:	e022                	sd	s0,0(sp)
    80000f9e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fa0:	00000097          	auipc	ra,0x0
    80000fa4:	fc0080e7          	jalr	-64(ra) # 80000f60 <myproc>
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	542080e7          	jalr	1346(ra) # 800064ea <release>

  if (first) {
    80000fb0:	0000a797          	auipc	a5,0xa
    80000fb4:	1307a783          	lw	a5,304(a5) # 8000b0e0 <first.1>
    80000fb8:	eb89                	bnez	a5,80000fca <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fba:	00001097          	auipc	ra,0x1
    80000fbe:	cc0080e7          	jalr	-832(ra) # 80001c7a <usertrapret>
}
    80000fc2:	60a2                	ld	ra,8(sp)
    80000fc4:	6402                	ld	s0,0(sp)
    80000fc6:	0141                	addi	sp,sp,16
    80000fc8:	8082                	ret
    first = 0;
    80000fca:	0000a797          	auipc	a5,0xa
    80000fce:	1007ab23          	sw	zero,278(a5) # 8000b0e0 <first.1>
    fsinit(ROOTDEV);
    80000fd2:	4505                	li	a0,1
    80000fd4:	00002097          	auipc	ra,0x2
    80000fd8:	af0080e7          	jalr	-1296(ra) # 80002ac4 <fsinit>
    80000fdc:	bff9                	j	80000fba <forkret+0x22>

0000000080000fde <allocpid>:
allocpid() {
    80000fde:	1101                	addi	sp,sp,-32
    80000fe0:	ec06                	sd	ra,24(sp)
    80000fe2:	e822                	sd	s0,16(sp)
    80000fe4:	e426                	sd	s1,8(sp)
    80000fe6:	e04a                	sd	s2,0(sp)
    80000fe8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fea:	0000b917          	auipc	s2,0xb
    80000fee:	06690913          	addi	s2,s2,102 # 8000c050 <pid_lock>
    80000ff2:	854a                	mv	a0,s2
    80000ff4:	00005097          	auipc	ra,0x5
    80000ff8:	442080e7          	jalr	1090(ra) # 80006436 <acquire>
  pid = nextpid;
    80000ffc:	0000a797          	auipc	a5,0xa
    80001000:	0e878793          	addi	a5,a5,232 # 8000b0e4 <nextpid>
    80001004:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001006:	0014871b          	addiw	a4,s1,1
    8000100a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000100c:	854a                	mv	a0,s2
    8000100e:	00005097          	auipc	ra,0x5
    80001012:	4dc080e7          	jalr	1244(ra) # 800064ea <release>
}
    80001016:	8526                	mv	a0,s1
    80001018:	60e2                	ld	ra,24(sp)
    8000101a:	6442                	ld	s0,16(sp)
    8000101c:	64a2                	ld	s1,8(sp)
    8000101e:	6902                	ld	s2,0(sp)
    80001020:	6105                	addi	sp,sp,32
    80001022:	8082                	ret

0000000080001024 <proc_pagetable>:
{
    80001024:	1101                	addi	sp,sp,-32
    80001026:	ec06                	sd	ra,24(sp)
    80001028:	e822                	sd	s0,16(sp)
    8000102a:	e426                	sd	s1,8(sp)
    8000102c:	e04a                	sd	s2,0(sp)
    8000102e:	1000                	addi	s0,sp,32
    80001030:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	7a2080e7          	jalr	1954(ra) # 800007d4 <uvmcreate>
    8000103a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000103c:	cd39                	beqz	a0,8000109a <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000103e:	4729                	li	a4,10
    80001040:	00006697          	auipc	a3,0x6
    80001044:	fc068693          	addi	a3,a3,-64 # 80007000 <_trampoline>
    80001048:	6605                	lui	a2,0x1
    8000104a:	040005b7          	lui	a1,0x4000
    8000104e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001050:	05b2                	slli	a1,a1,0xc
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	4e8080e7          	jalr	1256(ra) # 8000053a <mappages>
    8000105a:	04054763          	bltz	a0,800010a8 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000105e:	4719                	li	a4,6
    80001060:	05893683          	ld	a3,88(s2)
    80001064:	6605                	lui	a2,0x1
    80001066:	020005b7          	lui	a1,0x2000
    8000106a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000106c:	05b6                	slli	a1,a1,0xd
    8000106e:	8526                	mv	a0,s1
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	4ca080e7          	jalr	1226(ra) # 8000053a <mappages>
    80001078:	04054063          	bltz	a0,800010b8 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    8000107c:	4749                	li	a4,18
    8000107e:	06093683          	ld	a3,96(s2)
    80001082:	6605                	lui	a2,0x1
    80001084:	040005b7          	lui	a1,0x4000
    80001088:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000108a:	05b2                	slli	a1,a1,0xc
    8000108c:	8526                	mv	a0,s1
    8000108e:	fffff097          	auipc	ra,0xfffff
    80001092:	4ac080e7          	jalr	1196(ra) # 8000053a <mappages>
    80001096:	04054463          	bltz	a0,800010de <proc_pagetable+0xba>
}
    8000109a:	8526                	mv	a0,s1
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6902                	ld	s2,0(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret
    uvmfree(pagetable, 0);
    800010a8:	4581                	li	a1,0
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	92e080e7          	jalr	-1746(ra) # 800009da <uvmfree>
    return 0;
    800010b4:	4481                	li	s1,0
    800010b6:	b7d5                	j	8000109a <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b8:	4681                	li	a3,0
    800010ba:	4605                	li	a2,1
    800010bc:	040005b7          	lui	a1,0x4000
    800010c0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c2:	05b2                	slli	a1,a1,0xc
    800010c4:	8526                	mv	a0,s1
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	63a080e7          	jalr	1594(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    800010ce:	4581                	li	a1,0
    800010d0:	8526                	mv	a0,s1
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	908080e7          	jalr	-1784(ra) # 800009da <uvmfree>
    return 0;
    800010da:	4481                	li	s1,0
    800010dc:	bf7d                	j	8000109a <proc_pagetable+0x76>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	040005b7          	lui	a1,0x4000
    800010e6:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800010e8:	05b2                	slli	a1,a1,0xc
    800010ea:	8526                	mv	a0,s1
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	614080e7          	jalr	1556(ra) # 80000700 <uvmunmap>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f4:	4681                	li	a3,0
    800010f6:	4605                	li	a2,1
    800010f8:	040005b7          	lui	a1,0x4000
    800010fc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010fe:	05b2                	slli	a1,a1,0xc
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	5fe080e7          	jalr	1534(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    8000110a:	4581                	li	a1,0
    8000110c:	8526                	mv	a0,s1
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	8cc080e7          	jalr	-1844(ra) # 800009da <uvmfree>
    return 0;
    80001116:	4481                	li	s1,0
    80001118:	b749                	j	8000109a <proc_pagetable+0x76>

000000008000111a <proc_freepagetable>:
{
    8000111a:	1101                	addi	sp,sp,-32
    8000111c:	ec06                	sd	ra,24(sp)
    8000111e:	e822                	sd	s0,16(sp)
    80001120:	e426                	sd	s1,8(sp)
    80001122:	e04a                	sd	s2,0(sp)
    80001124:	1000                	addi	s0,sp,32
    80001126:	84aa                	mv	s1,a0
    80001128:	892e                	mv	s2,a1
  uvmunmap(pagetable,USYSCALL,1,0);
    8000112a:	4681                	li	a3,0
    8000112c:	4605                	li	a2,1
    8000112e:	040005b7          	lui	a1,0x4000
    80001132:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001134:	05b2                	slli	a1,a1,0xc
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	5ca080e7          	jalr	1482(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000113e:	4681                	li	a3,0
    80001140:	4605                	li	a2,1
    80001142:	040005b7          	lui	a1,0x4000
    80001146:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001148:	05b2                	slli	a1,a1,0xc
    8000114a:	8526                	mv	a0,s1
    8000114c:	fffff097          	auipc	ra,0xfffff
    80001150:	5b4080e7          	jalr	1460(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001154:	4681                	li	a3,0
    80001156:	4605                	li	a2,1
    80001158:	020005b7          	lui	a1,0x2000
    8000115c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000115e:	05b6                	slli	a1,a1,0xd
    80001160:	8526                	mv	a0,s1
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	59e080e7          	jalr	1438(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    8000116a:	85ca                	mv	a1,s2
    8000116c:	8526                	mv	a0,s1
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	86c080e7          	jalr	-1940(ra) # 800009da <uvmfree>
}
    80001176:	60e2                	ld	ra,24(sp)
    80001178:	6442                	ld	s0,16(sp)
    8000117a:	64a2                	ld	s1,8(sp)
    8000117c:	6902                	ld	s2,0(sp)
    8000117e:	6105                	addi	sp,sp,32
    80001180:	8082                	ret

0000000080001182 <freeproc>:
{
    80001182:	1101                	addi	sp,sp,-32
    80001184:	ec06                	sd	ra,24(sp)
    80001186:	e822                	sd	s0,16(sp)
    80001188:	e426                	sd	s1,8(sp)
    8000118a:	1000                	addi	s0,sp,32
    8000118c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000118e:	6d28                	ld	a0,88(a0)
    80001190:	c509                	beqz	a0,8000119a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001192:	fffff097          	auipc	ra,0xfffff
    80001196:	e8a080e7          	jalr	-374(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000119a:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    8000119e:	70a8                	ld	a0,96(s1)
    800011a0:	c509                	beqz	a0,800011aa <freeproc+0x28>
    kfree((void*)p->usyscall);
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	e7a080e7          	jalr	-390(ra) # 8000001c <kfree>
  p->usyscall = 0;
    800011aa:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011ae:	68a8                	ld	a0,80(s1)
    800011b0:	c511                	beqz	a0,800011bc <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    800011b2:	64ac                	ld	a1,72(s1)
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f66080e7          	jalr	-154(ra) # 8000111a <proc_freepagetable>
  p->pagetable = 0;
    800011bc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011c0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011c4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011c8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011cc:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011d0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011d4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011d8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011dc:	0004ac23          	sw	zero,24(s1)
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6105                	addi	sp,sp,32
    800011e8:	8082                	ret

00000000800011ea <allocproc>:
{
    800011ea:	1101                	addi	sp,sp,-32
    800011ec:	ec06                	sd	ra,24(sp)
    800011ee:	e822                	sd	s0,16(sp)
    800011f0:	e426                	sd	s1,8(sp)
    800011f2:	e04a                	sd	s2,0(sp)
    800011f4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f6:	0000b497          	auipc	s1,0xb
    800011fa:	28a48493          	addi	s1,s1,650 # 8000c480 <proc>
    800011fe:	00011917          	auipc	s2,0x11
    80001202:	e8290913          	addi	s2,s2,-382 # 80012080 <tickslock>
    acquire(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	22e080e7          	jalr	558(ra) # 80006436 <acquire>
    if(p->state == UNUSED) {
    80001210:	4c9c                	lw	a5,24(s1)
    80001212:	cf81                	beqz	a5,8000122a <allocproc+0x40>
      release(&p->lock);
    80001214:	8526                	mv	a0,s1
    80001216:	00005097          	auipc	ra,0x5
    8000121a:	2d4080e7          	jalr	724(ra) # 800064ea <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000121e:	17048493          	addi	s1,s1,368
    80001222:	ff2492e3          	bne	s1,s2,80001206 <allocproc+0x1c>
  return 0;
    80001226:	4481                	li	s1,0
    80001228:	a095                	j	8000128c <allocproc+0xa2>
  p->pid = allocpid();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	db4080e7          	jalr	-588(ra) # 80000fde <allocpid>
    80001232:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001234:	4785                	li	a5,1
    80001236:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	ee2080e7          	jalr	-286(ra) # 8000011a <kalloc>
    80001240:	892a                	mv	s2,a0
    80001242:	eca8                	sd	a0,88(s1)
    80001244:	c939                	beqz	a0,8000129a <allocproc+0xb0>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	ed4080e7          	jalr	-300(ra) # 8000011a <kalloc>
    8000124e:	892a                	mv	s2,a0
    80001250:	f0a8                	sd	a0,96(s1)
    80001252:	c125                	beqz	a0,800012b2 <allocproc+0xc8>
  p->usyscall->pid = p->pid;
    80001254:	589c                	lw	a5,48(s1)
    80001256:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001258:	8526                	mv	a0,s1
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	dca080e7          	jalr	-566(ra) # 80001024 <proc_pagetable>
    80001262:	892a                	mv	s2,a0
    80001264:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001266:	c135                	beqz	a0,800012ca <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001268:	07000613          	li	a2,112
    8000126c:	4581                	li	a1,0
    8000126e:	06848513          	addi	a0,s1,104
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	f08080e7          	jalr	-248(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000127a:	00000797          	auipc	a5,0x0
    8000127e:	d1e78793          	addi	a5,a5,-738 # 80000f98 <forkret>
    80001282:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001284:	60bc                	ld	a5,64(s1)
    80001286:	6705                	lui	a4,0x1
    80001288:	97ba                	add	a5,a5,a4
    8000128a:	f8bc                	sd	a5,112(s1)
}
    8000128c:	8526                	mv	a0,s1
    8000128e:	60e2                	ld	ra,24(sp)
    80001290:	6442                	ld	s0,16(sp)
    80001292:	64a2                	ld	s1,8(sp)
    80001294:	6902                	ld	s2,0(sp)
    80001296:	6105                	addi	sp,sp,32
    80001298:	8082                	ret
    freeproc(p);
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	ee6080e7          	jalr	-282(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00005097          	auipc	ra,0x5
    800012aa:	244080e7          	jalr	580(ra) # 800064ea <release>
    return 0;
    800012ae:	84ca                	mv	s1,s2
    800012b0:	bff1                	j	8000128c <allocproc+0xa2>
    freeproc(p);
    800012b2:	8526                	mv	a0,s1
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	ece080e7          	jalr	-306(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012bc:	8526                	mv	a0,s1
    800012be:	00005097          	auipc	ra,0x5
    800012c2:	22c080e7          	jalr	556(ra) # 800064ea <release>
    return 0;
    800012c6:	84ca                	mv	s1,s2
    800012c8:	b7d1                	j	8000128c <allocproc+0xa2>
    freeproc(p);
    800012ca:	8526                	mv	a0,s1
    800012cc:	00000097          	auipc	ra,0x0
    800012d0:	eb6080e7          	jalr	-330(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012d4:	8526                	mv	a0,s1
    800012d6:	00005097          	auipc	ra,0x5
    800012da:	214080e7          	jalr	532(ra) # 800064ea <release>
    return 0;
    800012de:	84ca                	mv	s1,s2
    800012e0:	b775                	j	8000128c <allocproc+0xa2>

00000000800012e2 <userinit>:
{
    800012e2:	1101                	addi	sp,sp,-32
    800012e4:	ec06                	sd	ra,24(sp)
    800012e6:	e822                	sd	s0,16(sp)
    800012e8:	e426                	sd	s1,8(sp)
    800012ea:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	efe080e7          	jalr	-258(ra) # 800011ea <allocproc>
    800012f4:	84aa                	mv	s1,a0
  initproc = p;
    800012f6:	0000b797          	auipc	a5,0xb
    800012fa:	d0a7bd23          	sd	a0,-742(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012fe:	03400613          	li	a2,52
    80001302:	0000a597          	auipc	a1,0xa
    80001306:	dee58593          	addi	a1,a1,-530 # 8000b0f0 <initcode>
    8000130a:	6928                	ld	a0,80(a0)
    8000130c:	fffff097          	auipc	ra,0xfffff
    80001310:	4f6080e7          	jalr	1270(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001314:	6785                	lui	a5,0x1
    80001316:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001318:	6cb8                	ld	a4,88(s1)
    8000131a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000131e:	6cb8                	ld	a4,88(s1)
    80001320:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001322:	4641                	li	a2,16
    80001324:	00007597          	auipc	a1,0x7
    80001328:	e9458593          	addi	a1,a1,-364 # 800081b8 <etext+0x1b8>
    8000132c:	16048513          	addi	a0,s1,352
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	f8c080e7          	jalr	-116(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001338:	00007517          	auipc	a0,0x7
    8000133c:	e9050513          	addi	a0,a0,-368 # 800081c8 <etext+0x1c8>
    80001340:	00002097          	auipc	ra,0x2
    80001344:	1ca080e7          	jalr	458(ra) # 8000350a <namei>
    80001348:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000134c:	478d                	li	a5,3
    8000134e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001350:	8526                	mv	a0,s1
    80001352:	00005097          	auipc	ra,0x5
    80001356:	198080e7          	jalr	408(ra) # 800064ea <release>
}
    8000135a:	60e2                	ld	ra,24(sp)
    8000135c:	6442                	ld	s0,16(sp)
    8000135e:	64a2                	ld	s1,8(sp)
    80001360:	6105                	addi	sp,sp,32
    80001362:	8082                	ret

0000000080001364 <growproc>:
{
    80001364:	1101                	addi	sp,sp,-32
    80001366:	ec06                	sd	ra,24(sp)
    80001368:	e822                	sd	s0,16(sp)
    8000136a:	e426                	sd	s1,8(sp)
    8000136c:	e04a                	sd	s2,0(sp)
    8000136e:	1000                	addi	s0,sp,32
    80001370:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001372:	00000097          	auipc	ra,0x0
    80001376:	bee080e7          	jalr	-1042(ra) # 80000f60 <myproc>
    8000137a:	892a                	mv	s2,a0
  sz = p->sz;
    8000137c:	652c                	ld	a1,72(a0)
    8000137e:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001382:	00904f63          	bgtz	s1,800013a0 <growproc+0x3c>
  } else if(n < 0){
    80001386:	0204cd63          	bltz	s1,800013c0 <growproc+0x5c>
  p->sz = sz;
    8000138a:	1782                	slli	a5,a5,0x20
    8000138c:	9381                	srli	a5,a5,0x20
    8000138e:	04f93423          	sd	a5,72(s2)
  return 0;
    80001392:	4501                	li	a0,0
}
    80001394:	60e2                	ld	ra,24(sp)
    80001396:	6442                	ld	s0,16(sp)
    80001398:	64a2                	ld	s1,8(sp)
    8000139a:	6902                	ld	s2,0(sp)
    8000139c:	6105                	addi	sp,sp,32
    8000139e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013a0:	00f4863b          	addw	a2,s1,a5
    800013a4:	1602                	slli	a2,a2,0x20
    800013a6:	9201                	srli	a2,a2,0x20
    800013a8:	1582                	slli	a1,a1,0x20
    800013aa:	9181                	srli	a1,a1,0x20
    800013ac:	6928                	ld	a0,80(a0)
    800013ae:	fffff097          	auipc	ra,0xfffff
    800013b2:	50e080e7          	jalr	1294(ra) # 800008bc <uvmalloc>
    800013b6:	0005079b          	sext.w	a5,a0
    800013ba:	fbe1                	bnez	a5,8000138a <growproc+0x26>
      return -1;
    800013bc:	557d                	li	a0,-1
    800013be:	bfd9                	j	80001394 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013c0:	00f4863b          	addw	a2,s1,a5
    800013c4:	1602                	slli	a2,a2,0x20
    800013c6:	9201                	srli	a2,a2,0x20
    800013c8:	1582                	slli	a1,a1,0x20
    800013ca:	9181                	srli	a1,a1,0x20
    800013cc:	6928                	ld	a0,80(a0)
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	4a6080e7          	jalr	1190(ra) # 80000874 <uvmdealloc>
    800013d6:	0005079b          	sext.w	a5,a0
    800013da:	bf45                	j	8000138a <growproc+0x26>

00000000800013dc <fork>:
{
    800013dc:	7139                	addi	sp,sp,-64
    800013de:	fc06                	sd	ra,56(sp)
    800013e0:	f822                	sd	s0,48(sp)
    800013e2:	f04a                	sd	s2,32(sp)
    800013e4:	e456                	sd	s5,8(sp)
    800013e6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	b78080e7          	jalr	-1160(ra) # 80000f60 <myproc>
    800013f0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	df8080e7          	jalr	-520(ra) # 800011ea <allocproc>
    800013fa:	12050063          	beqz	a0,8000151a <fork+0x13e>
    800013fe:	e852                	sd	s4,16(sp)
    80001400:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001402:	048ab603          	ld	a2,72(s5)
    80001406:	692c                	ld	a1,80(a0)
    80001408:	050ab503          	ld	a0,80(s5)
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	608080e7          	jalr	1544(ra) # 80000a14 <uvmcopy>
    80001414:	04054a63          	bltz	a0,80001468 <fork+0x8c>
    80001418:	f426                	sd	s1,40(sp)
    8000141a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000141c:	048ab783          	ld	a5,72(s5)
    80001420:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001424:	058ab683          	ld	a3,88(s5)
    80001428:	87b6                	mv	a5,a3
    8000142a:	058a3703          	ld	a4,88(s4)
    8000142e:	12068693          	addi	a3,a3,288
    80001432:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001436:	6788                	ld	a0,8(a5)
    80001438:	6b8c                	ld	a1,16(a5)
    8000143a:	6f90                	ld	a2,24(a5)
    8000143c:	01073023          	sd	a6,0(a4)
    80001440:	e708                	sd	a0,8(a4)
    80001442:	eb0c                	sd	a1,16(a4)
    80001444:	ef10                	sd	a2,24(a4)
    80001446:	02078793          	addi	a5,a5,32
    8000144a:	02070713          	addi	a4,a4,32
    8000144e:	fed792e3          	bne	a5,a3,80001432 <fork+0x56>
  np->trapframe->a0 = 0;
    80001452:	058a3783          	ld	a5,88(s4)
    80001456:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000145a:	0d8a8493          	addi	s1,s5,216
    8000145e:	0d8a0913          	addi	s2,s4,216
    80001462:	158a8993          	addi	s3,s5,344
    80001466:	a015                	j	8000148a <fork+0xae>
    freeproc(np);
    80001468:	8552                	mv	a0,s4
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	d18080e7          	jalr	-744(ra) # 80001182 <freeproc>
    release(&np->lock);
    80001472:	8552                	mv	a0,s4
    80001474:	00005097          	auipc	ra,0x5
    80001478:	076080e7          	jalr	118(ra) # 800064ea <release>
    return -1;
    8000147c:	597d                	li	s2,-1
    8000147e:	6a42                	ld	s4,16(sp)
    80001480:	a071                	j	8000150c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001482:	04a1                	addi	s1,s1,8
    80001484:	0921                	addi	s2,s2,8
    80001486:	01348b63          	beq	s1,s3,8000149c <fork+0xc0>
    if(p->ofile[i])
    8000148a:	6088                	ld	a0,0(s1)
    8000148c:	d97d                	beqz	a0,80001482 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000148e:	00002097          	auipc	ra,0x2
    80001492:	6f4080e7          	jalr	1780(ra) # 80003b82 <filedup>
    80001496:	00a93023          	sd	a0,0(s2)
    8000149a:	b7e5                	j	80001482 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000149c:	158ab503          	ld	a0,344(s5)
    800014a0:	00002097          	auipc	ra,0x2
    800014a4:	85a080e7          	jalr	-1958(ra) # 80002cfa <idup>
    800014a8:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014ac:	4641                	li	a2,16
    800014ae:	160a8593          	addi	a1,s5,352
    800014b2:	160a0513          	addi	a0,s4,352
    800014b6:	fffff097          	auipc	ra,0xfffff
    800014ba:	e06080e7          	jalr	-506(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    800014be:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014c2:	8552                	mv	a0,s4
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	026080e7          	jalr	38(ra) # 800064ea <release>
  acquire(&wait_lock);
    800014cc:	0000b497          	auipc	s1,0xb
    800014d0:	b9c48493          	addi	s1,s1,-1124 # 8000c068 <wait_lock>
    800014d4:	8526                	mv	a0,s1
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	f60080e7          	jalr	-160(ra) # 80006436 <acquire>
  np->parent = p;
    800014de:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014e2:	8526                	mv	a0,s1
    800014e4:	00005097          	auipc	ra,0x5
    800014e8:	006080e7          	jalr	6(ra) # 800064ea <release>
  acquire(&np->lock);
    800014ec:	8552                	mv	a0,s4
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	f48080e7          	jalr	-184(ra) # 80006436 <acquire>
  np->state = RUNNABLE;
    800014f6:	478d                	li	a5,3
    800014f8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014fc:	8552                	mv	a0,s4
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	fec080e7          	jalr	-20(ra) # 800064ea <release>
  return pid;
    80001506:	74a2                	ld	s1,40(sp)
    80001508:	69e2                	ld	s3,24(sp)
    8000150a:	6a42                	ld	s4,16(sp)
}
    8000150c:	854a                	mv	a0,s2
    8000150e:	70e2                	ld	ra,56(sp)
    80001510:	7442                	ld	s0,48(sp)
    80001512:	7902                	ld	s2,32(sp)
    80001514:	6aa2                	ld	s5,8(sp)
    80001516:	6121                	addi	sp,sp,64
    80001518:	8082                	ret
    return -1;
    8000151a:	597d                	li	s2,-1
    8000151c:	bfc5                	j	8000150c <fork+0x130>

000000008000151e <scheduler>:
{
    8000151e:	7139                	addi	sp,sp,-64
    80001520:	fc06                	sd	ra,56(sp)
    80001522:	f822                	sd	s0,48(sp)
    80001524:	f426                	sd	s1,40(sp)
    80001526:	f04a                	sd	s2,32(sp)
    80001528:	ec4e                	sd	s3,24(sp)
    8000152a:	e852                	sd	s4,16(sp)
    8000152c:	e456                	sd	s5,8(sp)
    8000152e:	e05a                	sd	s6,0(sp)
    80001530:	0080                	addi	s0,sp,64
    80001532:	8792                	mv	a5,tp
  int id = r_tp();
    80001534:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001536:	00779a93          	slli	s5,a5,0x7
    8000153a:	0000b717          	auipc	a4,0xb
    8000153e:	b1670713          	addi	a4,a4,-1258 # 8000c050 <pid_lock>
    80001542:	9756                	add	a4,a4,s5
    80001544:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001548:	0000b717          	auipc	a4,0xb
    8000154c:	b4070713          	addi	a4,a4,-1216 # 8000c088 <cpus+0x8>
    80001550:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001552:	498d                	li	s3,3
        p->state = RUNNING;
    80001554:	4b11                	li	s6,4
        c->proc = p;
    80001556:	079e                	slli	a5,a5,0x7
    80001558:	0000ba17          	auipc	s4,0xb
    8000155c:	af8a0a13          	addi	s4,s4,-1288 # 8000c050 <pid_lock>
    80001560:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001562:	00011917          	auipc	s2,0x11
    80001566:	b1e90913          	addi	s2,s2,-1250 # 80012080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000156a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000156e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001572:	10079073          	csrw	sstatus,a5
    80001576:	0000b497          	auipc	s1,0xb
    8000157a:	f0a48493          	addi	s1,s1,-246 # 8000c480 <proc>
    8000157e:	a811                	j	80001592 <scheduler+0x74>
      release(&p->lock);
    80001580:	8526                	mv	a0,s1
    80001582:	00005097          	auipc	ra,0x5
    80001586:	f68080e7          	jalr	-152(ra) # 800064ea <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000158a:	17048493          	addi	s1,s1,368
    8000158e:	fd248ee3          	beq	s1,s2,8000156a <scheduler+0x4c>
      acquire(&p->lock);
    80001592:	8526                	mv	a0,s1
    80001594:	00005097          	auipc	ra,0x5
    80001598:	ea2080e7          	jalr	-350(ra) # 80006436 <acquire>
      if(p->state == RUNNABLE) {
    8000159c:	4c9c                	lw	a5,24(s1)
    8000159e:	ff3791e3          	bne	a5,s3,80001580 <scheduler+0x62>
        p->state = RUNNING;
    800015a2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015a6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015aa:	06848593          	addi	a1,s1,104
    800015ae:	8556                	mv	a0,s5
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	620080e7          	jalr	1568(ra) # 80001bd0 <swtch>
        c->proc = 0;
    800015b8:	020a3823          	sd	zero,48(s4)
    800015bc:	b7d1                	j	80001580 <scheduler+0x62>

00000000800015be <sched>:
{
    800015be:	7179                	addi	sp,sp,-48
    800015c0:	f406                	sd	ra,40(sp)
    800015c2:	f022                	sd	s0,32(sp)
    800015c4:	ec26                	sd	s1,24(sp)
    800015c6:	e84a                	sd	s2,16(sp)
    800015c8:	e44e                	sd	s3,8(sp)
    800015ca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	994080e7          	jalr	-1644(ra) # 80000f60 <myproc>
    800015d4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	de6080e7          	jalr	-538(ra) # 800063bc <holding>
    800015de:	c93d                	beqz	a0,80001654 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015e2:	2781                	sext.w	a5,a5
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	0000b717          	auipc	a4,0xb
    800015ea:	a6a70713          	addi	a4,a4,-1430 # 8000c050 <pid_lock>
    800015ee:	97ba                	add	a5,a5,a4
    800015f0:	0a87a703          	lw	a4,168(a5)
    800015f4:	4785                	li	a5,1
    800015f6:	06f71763          	bne	a4,a5,80001664 <sched+0xa6>
  if(p->state == RUNNING)
    800015fa:	4c98                	lw	a4,24(s1)
    800015fc:	4791                	li	a5,4
    800015fe:	06f70b63          	beq	a4,a5,80001674 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001602:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001606:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001608:	efb5                	bnez	a5,80001684 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000160a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000160c:	0000b917          	auipc	s2,0xb
    80001610:	a4490913          	addi	s2,s2,-1468 # 8000c050 <pid_lock>
    80001614:	2781                	sext.w	a5,a5
    80001616:	079e                	slli	a5,a5,0x7
    80001618:	97ca                	add	a5,a5,s2
    8000161a:	0ac7a983          	lw	s3,172(a5)
    8000161e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001620:	2781                	sext.w	a5,a5
    80001622:	079e                	slli	a5,a5,0x7
    80001624:	0000b597          	auipc	a1,0xb
    80001628:	a6458593          	addi	a1,a1,-1436 # 8000c088 <cpus+0x8>
    8000162c:	95be                	add	a1,a1,a5
    8000162e:	06848513          	addi	a0,s1,104
    80001632:	00000097          	auipc	ra,0x0
    80001636:	59e080e7          	jalr	1438(ra) # 80001bd0 <swtch>
    8000163a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000163c:	2781                	sext.w	a5,a5
    8000163e:	079e                	slli	a5,a5,0x7
    80001640:	993e                	add	s2,s2,a5
    80001642:	0b392623          	sw	s3,172(s2)
}
    80001646:	70a2                	ld	ra,40(sp)
    80001648:	7402                	ld	s0,32(sp)
    8000164a:	64e2                	ld	s1,24(sp)
    8000164c:	6942                	ld	s2,16(sp)
    8000164e:	69a2                	ld	s3,8(sp)
    80001650:	6145                	addi	sp,sp,48
    80001652:	8082                	ret
    panic("sched p->lock");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	b7c50513          	addi	a0,a0,-1156 # 800081d0 <etext+0x1d0>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	860080e7          	jalr	-1952(ra) # 80005ebc <panic>
    panic("sched locks");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	b7c50513          	addi	a0,a0,-1156 # 800081e0 <etext+0x1e0>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	850080e7          	jalr	-1968(ra) # 80005ebc <panic>
    panic("sched running");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	b7c50513          	addi	a0,a0,-1156 # 800081f0 <etext+0x1f0>
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	840080e7          	jalr	-1984(ra) # 80005ebc <panic>
    panic("sched interruptible");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	b7c50513          	addi	a0,a0,-1156 # 80008200 <etext+0x200>
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	830080e7          	jalr	-2000(ra) # 80005ebc <panic>

0000000080001694 <yield>:
{
    80001694:	1101                	addi	sp,sp,-32
    80001696:	ec06                	sd	ra,24(sp)
    80001698:	e822                	sd	s0,16(sp)
    8000169a:	e426                	sd	s1,8(sp)
    8000169c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	8c2080e7          	jalr	-1854(ra) # 80000f60 <myproc>
    800016a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	d8e080e7          	jalr	-626(ra) # 80006436 <acquire>
  p->state = RUNNABLE;
    800016b0:	478d                	li	a5,3
    800016b2:	cc9c                	sw	a5,24(s1)
  sched();
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	f0a080e7          	jalr	-246(ra) # 800015be <sched>
  release(&p->lock);
    800016bc:	8526                	mv	a0,s1
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	e2c080e7          	jalr	-468(ra) # 800064ea <release>
}
    800016c6:	60e2                	ld	ra,24(sp)
    800016c8:	6442                	ld	s0,16(sp)
    800016ca:	64a2                	ld	s1,8(sp)
    800016cc:	6105                	addi	sp,sp,32
    800016ce:	8082                	ret

00000000800016d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016d0:	7179                	addi	sp,sp,-48
    800016d2:	f406                	sd	ra,40(sp)
    800016d4:	f022                	sd	s0,32(sp)
    800016d6:	ec26                	sd	s1,24(sp)
    800016d8:	e84a                	sd	s2,16(sp)
    800016da:	e44e                	sd	s3,8(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	89aa                	mv	s3,a0
    800016e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	87e080e7          	jalr	-1922(ra) # 80000f60 <myproc>
    800016ea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	d4a080e7          	jalr	-694(ra) # 80006436 <acquire>
  release(lk);
    800016f4:	854a                	mv	a0,s2
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	df4080e7          	jalr	-524(ra) # 800064ea <release>

  // Go to sleep.
  p->chan = chan;
    800016fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001702:	4789                	li	a5,2
    80001704:	cc9c                	sw	a5,24(s1)

  sched();
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	eb8080e7          	jalr	-328(ra) # 800015be <sched>

  // Tidy up.
  p->chan = 0;
    8000170e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	dd6080e7          	jalr	-554(ra) # 800064ea <release>
  acquire(lk);
    8000171c:	854a                	mv	a0,s2
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	d18080e7          	jalr	-744(ra) # 80006436 <acquire>
}
    80001726:	70a2                	ld	ra,40(sp)
    80001728:	7402                	ld	s0,32(sp)
    8000172a:	64e2                	ld	s1,24(sp)
    8000172c:	6942                	ld	s2,16(sp)
    8000172e:	69a2                	ld	s3,8(sp)
    80001730:	6145                	addi	sp,sp,48
    80001732:	8082                	ret

0000000080001734 <wait>:
{
    80001734:	715d                	addi	sp,sp,-80
    80001736:	e486                	sd	ra,72(sp)
    80001738:	e0a2                	sd	s0,64(sp)
    8000173a:	fc26                	sd	s1,56(sp)
    8000173c:	f84a                	sd	s2,48(sp)
    8000173e:	f44e                	sd	s3,40(sp)
    80001740:	f052                	sd	s4,32(sp)
    80001742:	ec56                	sd	s5,24(sp)
    80001744:	e85a                	sd	s6,16(sp)
    80001746:	e45e                	sd	s7,8(sp)
    80001748:	e062                	sd	s8,0(sp)
    8000174a:	0880                	addi	s0,sp,80
    8000174c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000174e:	00000097          	auipc	ra,0x0
    80001752:	812080e7          	jalr	-2030(ra) # 80000f60 <myproc>
    80001756:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001758:	0000b517          	auipc	a0,0xb
    8000175c:	91050513          	addi	a0,a0,-1776 # 8000c068 <wait_lock>
    80001760:	00005097          	auipc	ra,0x5
    80001764:	cd6080e7          	jalr	-810(ra) # 80006436 <acquire>
    havekids = 0;
    80001768:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000176a:	4a15                	li	s4,5
        havekids = 1;
    8000176c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000176e:	00011997          	auipc	s3,0x11
    80001772:	91298993          	addi	s3,s3,-1774 # 80012080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001776:	0000bc17          	auipc	s8,0xb
    8000177a:	8f2c0c13          	addi	s8,s8,-1806 # 8000c068 <wait_lock>
    8000177e:	a87d                	j	8000183c <wait+0x108>
          pid = np->pid;
    80001780:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001784:	000b0e63          	beqz	s6,800017a0 <wait+0x6c>
    80001788:	4691                	li	a3,4
    8000178a:	02c48613          	addi	a2,s1,44
    8000178e:	85da                	mv	a1,s6
    80001790:	05093503          	ld	a0,80(s2)
    80001794:	fffff097          	auipc	ra,0xfffff
    80001798:	384080e7          	jalr	900(ra) # 80000b18 <copyout>
    8000179c:	04054163          	bltz	a0,800017de <wait+0xaa>
          freeproc(np);
    800017a0:	8526                	mv	a0,s1
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	9e0080e7          	jalr	-1568(ra) # 80001182 <freeproc>
          release(&np->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	d3e080e7          	jalr	-706(ra) # 800064ea <release>
          release(&wait_lock);
    800017b4:	0000b517          	auipc	a0,0xb
    800017b8:	8b450513          	addi	a0,a0,-1868 # 8000c068 <wait_lock>
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	d2e080e7          	jalr	-722(ra) # 800064ea <release>
}
    800017c4:	854e                	mv	a0,s3
    800017c6:	60a6                	ld	ra,72(sp)
    800017c8:	6406                	ld	s0,64(sp)
    800017ca:	74e2                	ld	s1,56(sp)
    800017cc:	7942                	ld	s2,48(sp)
    800017ce:	79a2                	ld	s3,40(sp)
    800017d0:	7a02                	ld	s4,32(sp)
    800017d2:	6ae2                	ld	s5,24(sp)
    800017d4:	6b42                	ld	s6,16(sp)
    800017d6:	6ba2                	ld	s7,8(sp)
    800017d8:	6c02                	ld	s8,0(sp)
    800017da:	6161                	addi	sp,sp,80
    800017dc:	8082                	ret
            release(&np->lock);
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	d0a080e7          	jalr	-758(ra) # 800064ea <release>
            release(&wait_lock);
    800017e8:	0000b517          	auipc	a0,0xb
    800017ec:	88050513          	addi	a0,a0,-1920 # 8000c068 <wait_lock>
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	cfa080e7          	jalr	-774(ra) # 800064ea <release>
            return -1;
    800017f8:	59fd                	li	s3,-1
    800017fa:	b7e9                	j	800017c4 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800017fc:	17048493          	addi	s1,s1,368
    80001800:	03348463          	beq	s1,s3,80001828 <wait+0xf4>
      if(np->parent == p){
    80001804:	7c9c                	ld	a5,56(s1)
    80001806:	ff279be3          	bne	a5,s2,800017fc <wait+0xc8>
        acquire(&np->lock);
    8000180a:	8526                	mv	a0,s1
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	c2a080e7          	jalr	-982(ra) # 80006436 <acquire>
        if(np->state == ZOMBIE){
    80001814:	4c9c                	lw	a5,24(s1)
    80001816:	f74785e3          	beq	a5,s4,80001780 <wait+0x4c>
        release(&np->lock);
    8000181a:	8526                	mv	a0,s1
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	cce080e7          	jalr	-818(ra) # 800064ea <release>
        havekids = 1;
    80001824:	8756                	mv	a4,s5
    80001826:	bfd9                	j	800017fc <wait+0xc8>
    if(!havekids || p->killed){
    80001828:	c305                	beqz	a4,80001848 <wait+0x114>
    8000182a:	02892783          	lw	a5,40(s2)
    8000182e:	ef89                	bnez	a5,80001848 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001830:	85e2                	mv	a1,s8
    80001832:	854a                	mv	a0,s2
    80001834:	00000097          	auipc	ra,0x0
    80001838:	e9c080e7          	jalr	-356(ra) # 800016d0 <sleep>
    havekids = 0;
    8000183c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000183e:	0000b497          	auipc	s1,0xb
    80001842:	c4248493          	addi	s1,s1,-958 # 8000c480 <proc>
    80001846:	bf7d                	j	80001804 <wait+0xd0>
      release(&wait_lock);
    80001848:	0000b517          	auipc	a0,0xb
    8000184c:	82050513          	addi	a0,a0,-2016 # 8000c068 <wait_lock>
    80001850:	00005097          	auipc	ra,0x5
    80001854:	c9a080e7          	jalr	-870(ra) # 800064ea <release>
      return -1;
    80001858:	59fd                	li	s3,-1
    8000185a:	b7ad                	j	800017c4 <wait+0x90>

000000008000185c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000185c:	7139                	addi	sp,sp,-64
    8000185e:	fc06                	sd	ra,56(sp)
    80001860:	f822                	sd	s0,48(sp)
    80001862:	f426                	sd	s1,40(sp)
    80001864:	f04a                	sd	s2,32(sp)
    80001866:	ec4e                	sd	s3,24(sp)
    80001868:	e852                	sd	s4,16(sp)
    8000186a:	e456                	sd	s5,8(sp)
    8000186c:	0080                	addi	s0,sp,64
    8000186e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001870:	0000b497          	auipc	s1,0xb
    80001874:	c1048493          	addi	s1,s1,-1008 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001878:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000187a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187c:	00011917          	auipc	s2,0x11
    80001880:	80490913          	addi	s2,s2,-2044 # 80012080 <tickslock>
    80001884:	a811                	j	80001898 <wakeup+0x3c>
      }
      release(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	c62080e7          	jalr	-926(ra) # 800064ea <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001890:	17048493          	addi	s1,s1,368
    80001894:	03248663          	beq	s1,s2,800018c0 <wakeup+0x64>
    if(p != myproc()){
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	6c8080e7          	jalr	1736(ra) # 80000f60 <myproc>
    800018a0:	fea488e3          	beq	s1,a0,80001890 <wakeup+0x34>
      acquire(&p->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	b90080e7          	jalr	-1136(ra) # 80006436 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018ae:	4c9c                	lw	a5,24(s1)
    800018b0:	fd379be3          	bne	a5,s3,80001886 <wakeup+0x2a>
    800018b4:	709c                	ld	a5,32(s1)
    800018b6:	fd4798e3          	bne	a5,s4,80001886 <wakeup+0x2a>
        p->state = RUNNABLE;
    800018ba:	0154ac23          	sw	s5,24(s1)
    800018be:	b7e1                	j	80001886 <wakeup+0x2a>
    }
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6121                	addi	sp,sp,64
    800018d0:	8082                	ret

00000000800018d2 <reparent>:
{
    800018d2:	7179                	addi	sp,sp,-48
    800018d4:	f406                	sd	ra,40(sp)
    800018d6:	f022                	sd	s0,32(sp)
    800018d8:	ec26                	sd	s1,24(sp)
    800018da:	e84a                	sd	s2,16(sp)
    800018dc:	e44e                	sd	s3,8(sp)
    800018de:	e052                	sd	s4,0(sp)
    800018e0:	1800                	addi	s0,sp,48
    800018e2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	0000b497          	auipc	s1,0xb
    800018e8:	b9c48493          	addi	s1,s1,-1124 # 8000c480 <proc>
      pp->parent = initproc;
    800018ec:	0000aa17          	auipc	s4,0xa
    800018f0:	724a0a13          	addi	s4,s4,1828 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f4:	00010997          	auipc	s3,0x10
    800018f8:	78c98993          	addi	s3,s3,1932 # 80012080 <tickslock>
    800018fc:	a029                	j	80001906 <reparent+0x34>
    800018fe:	17048493          	addi	s1,s1,368
    80001902:	01348d63          	beq	s1,s3,8000191c <reparent+0x4a>
    if(pp->parent == p){
    80001906:	7c9c                	ld	a5,56(s1)
    80001908:	ff279be3          	bne	a5,s2,800018fe <reparent+0x2c>
      pp->parent = initproc;
    8000190c:	000a3503          	ld	a0,0(s4)
    80001910:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001912:	00000097          	auipc	ra,0x0
    80001916:	f4a080e7          	jalr	-182(ra) # 8000185c <wakeup>
    8000191a:	b7d5                	j	800018fe <reparent+0x2c>
}
    8000191c:	70a2                	ld	ra,40(sp)
    8000191e:	7402                	ld	s0,32(sp)
    80001920:	64e2                	ld	s1,24(sp)
    80001922:	6942                	ld	s2,16(sp)
    80001924:	69a2                	ld	s3,8(sp)
    80001926:	6a02                	ld	s4,0(sp)
    80001928:	6145                	addi	sp,sp,48
    8000192a:	8082                	ret

000000008000192c <exit>:
{
    8000192c:	7179                	addi	sp,sp,-48
    8000192e:	f406                	sd	ra,40(sp)
    80001930:	f022                	sd	s0,32(sp)
    80001932:	ec26                	sd	s1,24(sp)
    80001934:	e84a                	sd	s2,16(sp)
    80001936:	e44e                	sd	s3,8(sp)
    80001938:	e052                	sd	s4,0(sp)
    8000193a:	1800                	addi	s0,sp,48
    8000193c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	622080e7          	jalr	1570(ra) # 80000f60 <myproc>
    80001946:	89aa                	mv	s3,a0
  if(p == initproc)
    80001948:	0000a797          	auipc	a5,0xa
    8000194c:	6c87b783          	ld	a5,1736(a5) # 8000c010 <initproc>
    80001950:	0d850493          	addi	s1,a0,216
    80001954:	15850913          	addi	s2,a0,344
    80001958:	02a79363          	bne	a5,a0,8000197e <exit+0x52>
    panic("init exiting");
    8000195c:	00007517          	auipc	a0,0x7
    80001960:	8bc50513          	addi	a0,a0,-1860 # 80008218 <etext+0x218>
    80001964:	00004097          	auipc	ra,0x4
    80001968:	558080e7          	jalr	1368(ra) # 80005ebc <panic>
      fileclose(f);
    8000196c:	00002097          	auipc	ra,0x2
    80001970:	268080e7          	jalr	616(ra) # 80003bd4 <fileclose>
      p->ofile[fd] = 0;
    80001974:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001978:	04a1                	addi	s1,s1,8
    8000197a:	01248563          	beq	s1,s2,80001984 <exit+0x58>
    if(p->ofile[fd]){
    8000197e:	6088                	ld	a0,0(s1)
    80001980:	f575                	bnez	a0,8000196c <exit+0x40>
    80001982:	bfdd                	j	80001978 <exit+0x4c>
  begin_op();
    80001984:	00002097          	auipc	ra,0x2
    80001988:	d86080e7          	jalr	-634(ra) # 8000370a <begin_op>
  iput(p->cwd);
    8000198c:	1589b503          	ld	a0,344(s3)
    80001990:	00001097          	auipc	ra,0x1
    80001994:	566080e7          	jalr	1382(ra) # 80002ef6 <iput>
  end_op();
    80001998:	00002097          	auipc	ra,0x2
    8000199c:	dec080e7          	jalr	-532(ra) # 80003784 <end_op>
  p->cwd = 0;
    800019a0:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019a4:	0000a497          	auipc	s1,0xa
    800019a8:	6c448493          	addi	s1,s1,1732 # 8000c068 <wait_lock>
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	a88080e7          	jalr	-1400(ra) # 80006436 <acquire>
  reparent(p);
    800019b6:	854e                	mv	a0,s3
    800019b8:	00000097          	auipc	ra,0x0
    800019bc:	f1a080e7          	jalr	-230(ra) # 800018d2 <reparent>
  wakeup(p->parent);
    800019c0:	0389b503          	ld	a0,56(s3)
    800019c4:	00000097          	auipc	ra,0x0
    800019c8:	e98080e7          	jalr	-360(ra) # 8000185c <wakeup>
  acquire(&p->lock);
    800019cc:	854e                	mv	a0,s3
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	a68080e7          	jalr	-1432(ra) # 80006436 <acquire>
  p->xstate = status;
    800019d6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019da:	4795                	li	a5,5
    800019dc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	b08080e7          	jalr	-1272(ra) # 800064ea <release>
  sched();
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	bd4080e7          	jalr	-1068(ra) # 800015be <sched>
  panic("zombie exit");
    800019f2:	00007517          	auipc	a0,0x7
    800019f6:	83650513          	addi	a0,a0,-1994 # 80008228 <etext+0x228>
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	4c2080e7          	jalr	1218(ra) # 80005ebc <panic>

0000000080001a02 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a02:	7179                	addi	sp,sp,-48
    80001a04:	f406                	sd	ra,40(sp)
    80001a06:	f022                	sd	s0,32(sp)
    80001a08:	ec26                	sd	s1,24(sp)
    80001a0a:	e84a                	sd	s2,16(sp)
    80001a0c:	e44e                	sd	s3,8(sp)
    80001a0e:	1800                	addi	s0,sp,48
    80001a10:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a12:	0000b497          	auipc	s1,0xb
    80001a16:	a6e48493          	addi	s1,s1,-1426 # 8000c480 <proc>
    80001a1a:	00010997          	auipc	s3,0x10
    80001a1e:	66698993          	addi	s3,s3,1638 # 80012080 <tickslock>
    acquire(&p->lock);
    80001a22:	8526                	mv	a0,s1
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	a12080e7          	jalr	-1518(ra) # 80006436 <acquire>
    if(p->pid == pid){
    80001a2c:	589c                	lw	a5,48(s1)
    80001a2e:	01278d63          	beq	a5,s2,80001a48 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a32:	8526                	mv	a0,s1
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	ab6080e7          	jalr	-1354(ra) # 800064ea <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a3c:	17048493          	addi	s1,s1,368
    80001a40:	ff3491e3          	bne	s1,s3,80001a22 <kill+0x20>
  }
  return -1;
    80001a44:	557d                	li	a0,-1
    80001a46:	a829                	j	80001a60 <kill+0x5e>
      p->killed = 1;
    80001a48:	4785                	li	a5,1
    80001a4a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a4c:	4c98                	lw	a4,24(s1)
    80001a4e:	4789                	li	a5,2
    80001a50:	00f70f63          	beq	a4,a5,80001a6e <kill+0x6c>
      release(&p->lock);
    80001a54:	8526                	mv	a0,s1
    80001a56:	00005097          	auipc	ra,0x5
    80001a5a:	a94080e7          	jalr	-1388(ra) # 800064ea <release>
      return 0;
    80001a5e:	4501                	li	a0,0
}
    80001a60:	70a2                	ld	ra,40(sp)
    80001a62:	7402                	ld	s0,32(sp)
    80001a64:	64e2                	ld	s1,24(sp)
    80001a66:	6942                	ld	s2,16(sp)
    80001a68:	69a2                	ld	s3,8(sp)
    80001a6a:	6145                	addi	sp,sp,48
    80001a6c:	8082                	ret
        p->state = RUNNABLE;
    80001a6e:	478d                	li	a5,3
    80001a70:	cc9c                	sw	a5,24(s1)
    80001a72:	b7cd                	j	80001a54 <kill+0x52>

0000000080001a74 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a74:	7179                	addi	sp,sp,-48
    80001a76:	f406                	sd	ra,40(sp)
    80001a78:	f022                	sd	s0,32(sp)
    80001a7a:	ec26                	sd	s1,24(sp)
    80001a7c:	e84a                	sd	s2,16(sp)
    80001a7e:	e44e                	sd	s3,8(sp)
    80001a80:	e052                	sd	s4,0(sp)
    80001a82:	1800                	addi	s0,sp,48
    80001a84:	84aa                	mv	s1,a0
    80001a86:	892e                	mv	s2,a1
    80001a88:	89b2                	mv	s3,a2
    80001a8a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	4d4080e7          	jalr	1236(ra) # 80000f60 <myproc>
  if(user_dst){
    80001a94:	c08d                	beqz	s1,80001ab6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a96:	86d2                	mv	a3,s4
    80001a98:	864e                	mv	a2,s3
    80001a9a:	85ca                	mv	a1,s2
    80001a9c:	6928                	ld	a0,80(a0)
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	07a080e7          	jalr	122(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aa6:	70a2                	ld	ra,40(sp)
    80001aa8:	7402                	ld	s0,32(sp)
    80001aaa:	64e2                	ld	s1,24(sp)
    80001aac:	6942                	ld	s2,16(sp)
    80001aae:	69a2                	ld	s3,8(sp)
    80001ab0:	6a02                	ld	s4,0(sp)
    80001ab2:	6145                	addi	sp,sp,48
    80001ab4:	8082                	ret
    memmove((char *)dst, src, len);
    80001ab6:	000a061b          	sext.w	a2,s4
    80001aba:	85ce                	mv	a1,s3
    80001abc:	854a                	mv	a0,s2
    80001abe:	ffffe097          	auipc	ra,0xffffe
    80001ac2:	718080e7          	jalr	1816(ra) # 800001d6 <memmove>
    return 0;
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	bff9                	j	80001aa6 <either_copyout+0x32>

0000000080001aca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aca:	7179                	addi	sp,sp,-48
    80001acc:	f406                	sd	ra,40(sp)
    80001ace:	f022                	sd	s0,32(sp)
    80001ad0:	ec26                	sd	s1,24(sp)
    80001ad2:	e84a                	sd	s2,16(sp)
    80001ad4:	e44e                	sd	s3,8(sp)
    80001ad6:	e052                	sd	s4,0(sp)
    80001ad8:	1800                	addi	s0,sp,48
    80001ada:	892a                	mv	s2,a0
    80001adc:	84ae                	mv	s1,a1
    80001ade:	89b2                	mv	s3,a2
    80001ae0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	47e080e7          	jalr	1150(ra) # 80000f60 <myproc>
  if(user_src){
    80001aea:	c08d                	beqz	s1,80001b0c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aec:	86d2                	mv	a3,s4
    80001aee:	864e                	mv	a2,s3
    80001af0:	85ca                	mv	a1,s2
    80001af2:	6928                	ld	a0,80(a0)
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	0b0080e7          	jalr	176(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001afc:	70a2                	ld	ra,40(sp)
    80001afe:	7402                	ld	s0,32(sp)
    80001b00:	64e2                	ld	s1,24(sp)
    80001b02:	6942                	ld	s2,16(sp)
    80001b04:	69a2                	ld	s3,8(sp)
    80001b06:	6a02                	ld	s4,0(sp)
    80001b08:	6145                	addi	sp,sp,48
    80001b0a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b0c:	000a061b          	sext.w	a2,s4
    80001b10:	85ce                	mv	a1,s3
    80001b12:	854a                	mv	a0,s2
    80001b14:	ffffe097          	auipc	ra,0xffffe
    80001b18:	6c2080e7          	jalr	1730(ra) # 800001d6 <memmove>
    return 0;
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	bff9                	j	80001afc <either_copyin+0x32>

0000000080001b20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b20:	715d                	addi	sp,sp,-80
    80001b22:	e486                	sd	ra,72(sp)
    80001b24:	e0a2                	sd	s0,64(sp)
    80001b26:	fc26                	sd	s1,56(sp)
    80001b28:	f84a                	sd	s2,48(sp)
    80001b2a:	f44e                	sd	s3,40(sp)
    80001b2c:	f052                	sd	s4,32(sp)
    80001b2e:	ec56                	sd	s5,24(sp)
    80001b30:	e85a                	sd	s6,16(sp)
    80001b32:	e45e                	sd	s7,8(sp)
    80001b34:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b36:	00006517          	auipc	a0,0x6
    80001b3a:	4e250513          	addi	a0,a0,1250 # 80008018 <etext+0x18>
    80001b3e:	00004097          	auipc	ra,0x4
    80001b42:	3c8080e7          	jalr	968(ra) # 80005f06 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b46:	0000b497          	auipc	s1,0xb
    80001b4a:	a9a48493          	addi	s1,s1,-1382 # 8000c5e0 <proc+0x160>
    80001b4e:	00010917          	auipc	s2,0x10
    80001b52:	69290913          	addi	s2,s2,1682 # 800121e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b56:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b58:	00006997          	auipc	s3,0x6
    80001b5c:	6e098993          	addi	s3,s3,1760 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001b60:	00006a97          	auipc	s5,0x6
    80001b64:	6e0a8a93          	addi	s5,s5,1760 # 80008240 <etext+0x240>
    printf("\n");
    80001b68:	00006a17          	auipc	s4,0x6
    80001b6c:	4b0a0a13          	addi	s4,s4,1200 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b70:	00007b97          	auipc	s7,0x7
    80001b74:	bc0b8b93          	addi	s7,s7,-1088 # 80008730 <states.0>
    80001b78:	a00d                	j	80001b9a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b7a:	ed06a583          	lw	a1,-304(a3)
    80001b7e:	8556                	mv	a0,s5
    80001b80:	00004097          	auipc	ra,0x4
    80001b84:	386080e7          	jalr	902(ra) # 80005f06 <printf>
    printf("\n");
    80001b88:	8552                	mv	a0,s4
    80001b8a:	00004097          	auipc	ra,0x4
    80001b8e:	37c080e7          	jalr	892(ra) # 80005f06 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b92:	17048493          	addi	s1,s1,368
    80001b96:	03248263          	beq	s1,s2,80001bba <procdump+0x9a>
    if(p->state == UNUSED)
    80001b9a:	86a6                	mv	a3,s1
    80001b9c:	eb84a783          	lw	a5,-328(s1)
    80001ba0:	dbed                	beqz	a5,80001b92 <procdump+0x72>
      state = "???";
    80001ba2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba4:	fcfb6be3          	bltu	s6,a5,80001b7a <procdump+0x5a>
    80001ba8:	02079713          	slli	a4,a5,0x20
    80001bac:	01d75793          	srli	a5,a4,0x1d
    80001bb0:	97de                	add	a5,a5,s7
    80001bb2:	6390                	ld	a2,0(a5)
    80001bb4:	f279                	bnez	a2,80001b7a <procdump+0x5a>
      state = "???";
    80001bb6:	864e                	mv	a2,s3
    80001bb8:	b7c9                	j	80001b7a <procdump+0x5a>
  }
}
    80001bba:	60a6                	ld	ra,72(sp)
    80001bbc:	6406                	ld	s0,64(sp)
    80001bbe:	74e2                	ld	s1,56(sp)
    80001bc0:	7942                	ld	s2,48(sp)
    80001bc2:	79a2                	ld	s3,40(sp)
    80001bc4:	7a02                	ld	s4,32(sp)
    80001bc6:	6ae2                	ld	s5,24(sp)
    80001bc8:	6b42                	ld	s6,16(sp)
    80001bca:	6ba2                	ld	s7,8(sp)
    80001bcc:	6161                	addi	sp,sp,80
    80001bce:	8082                	ret

0000000080001bd0 <swtch>:
    80001bd0:	00153023          	sd	ra,0(a0)
    80001bd4:	00253423          	sd	sp,8(a0)
    80001bd8:	e900                	sd	s0,16(a0)
    80001bda:	ed04                	sd	s1,24(a0)
    80001bdc:	03253023          	sd	s2,32(a0)
    80001be0:	03353423          	sd	s3,40(a0)
    80001be4:	03453823          	sd	s4,48(a0)
    80001be8:	03553c23          	sd	s5,56(a0)
    80001bec:	05653023          	sd	s6,64(a0)
    80001bf0:	05753423          	sd	s7,72(a0)
    80001bf4:	05853823          	sd	s8,80(a0)
    80001bf8:	05953c23          	sd	s9,88(a0)
    80001bfc:	07a53023          	sd	s10,96(a0)
    80001c00:	07b53423          	sd	s11,104(a0)
    80001c04:	0005b083          	ld	ra,0(a1)
    80001c08:	0085b103          	ld	sp,8(a1)
    80001c0c:	6980                	ld	s0,16(a1)
    80001c0e:	6d84                	ld	s1,24(a1)
    80001c10:	0205b903          	ld	s2,32(a1)
    80001c14:	0285b983          	ld	s3,40(a1)
    80001c18:	0305ba03          	ld	s4,48(a1)
    80001c1c:	0385ba83          	ld	s5,56(a1)
    80001c20:	0405bb03          	ld	s6,64(a1)
    80001c24:	0485bb83          	ld	s7,72(a1)
    80001c28:	0505bc03          	ld	s8,80(a1)
    80001c2c:	0585bc83          	ld	s9,88(a1)
    80001c30:	0605bd03          	ld	s10,96(a1)
    80001c34:	0685bd83          	ld	s11,104(a1)
    80001c38:	8082                	ret

0000000080001c3a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c3a:	1141                	addi	sp,sp,-16
    80001c3c:	e406                	sd	ra,8(sp)
    80001c3e:	e022                	sd	s0,0(sp)
    80001c40:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c42:	00006597          	auipc	a1,0x6
    80001c46:	63658593          	addi	a1,a1,1590 # 80008278 <etext+0x278>
    80001c4a:	00010517          	auipc	a0,0x10
    80001c4e:	43650513          	addi	a0,a0,1078 # 80012080 <tickslock>
    80001c52:	00004097          	auipc	ra,0x4
    80001c56:	754080e7          	jalr	1876(ra) # 800063a6 <initlock>
}
    80001c5a:	60a2                	ld	ra,8(sp)
    80001c5c:	6402                	ld	s0,0(sp)
    80001c5e:	0141                	addi	sp,sp,16
    80001c60:	8082                	ret

0000000080001c62 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c62:	1141                	addi	sp,sp,-16
    80001c64:	e422                	sd	s0,8(sp)
    80001c66:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c68:	00003797          	auipc	a5,0x3
    80001c6c:	66878793          	addi	a5,a5,1640 # 800052d0 <kernelvec>
    80001c70:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c74:	6422                	ld	s0,8(sp)
    80001c76:	0141                	addi	sp,sp,16
    80001c78:	8082                	ret

0000000080001c7a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c7a:	1141                	addi	sp,sp,-16
    80001c7c:	e406                	sd	ra,8(sp)
    80001c7e:	e022                	sd	s0,0(sp)
    80001c80:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	2de080e7          	jalr	734(ra) # 80000f60 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c90:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c94:	00005697          	auipc	a3,0x5
    80001c98:	36c68693          	addi	a3,a3,876 # 80007000 <_trampoline>
    80001c9c:	00005717          	auipc	a4,0x5
    80001ca0:	36470713          	addi	a4,a4,868 # 80007000 <_trampoline>
    80001ca4:	8f15                	sub	a4,a4,a3
    80001ca6:	040007b7          	lui	a5,0x4000
    80001caa:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cac:	07b2                	slli	a5,a5,0xc
    80001cae:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cb4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cb6:	18002673          	csrr	a2,satp
    80001cba:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cbc:	6d30                	ld	a2,88(a0)
    80001cbe:	6138                	ld	a4,64(a0)
    80001cc0:	6585                	lui	a1,0x1
    80001cc2:	972e                	add	a4,a4,a1
    80001cc4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cc6:	6d38                	ld	a4,88(a0)
    80001cc8:	00000617          	auipc	a2,0x0
    80001ccc:	14060613          	addi	a2,a2,320 # 80001e08 <usertrap>
    80001cd0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cd2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cd4:	8612                	mv	a2,tp
    80001cd6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cdc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ce0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ce8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cea:	6f18                	ld	a4,24(a4)
    80001cec:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cf0:	692c                	ld	a1,80(a0)
    80001cf2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cf4:	00005717          	auipc	a4,0x5
    80001cf8:	39c70713          	addi	a4,a4,924 # 80007090 <userret>
    80001cfc:	8f15                	sub	a4,a4,a3
    80001cfe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d00:	577d                	li	a4,-1
    80001d02:	177e                	slli	a4,a4,0x3f
    80001d04:	8dd9                	or	a1,a1,a4
    80001d06:	02000537          	lui	a0,0x2000
    80001d0a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d0c:	0536                	slli	a0,a0,0xd
    80001d0e:	9782                	jalr	a5
}
    80001d10:	60a2                	ld	ra,8(sp)
    80001d12:	6402                	ld	s0,0(sp)
    80001d14:	0141                	addi	sp,sp,16
    80001d16:	8082                	ret

0000000080001d18 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d18:	1101                	addi	sp,sp,-32
    80001d1a:	ec06                	sd	ra,24(sp)
    80001d1c:	e822                	sd	s0,16(sp)
    80001d1e:	e426                	sd	s1,8(sp)
    80001d20:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d22:	00010497          	auipc	s1,0x10
    80001d26:	35e48493          	addi	s1,s1,862 # 80012080 <tickslock>
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	00004097          	auipc	ra,0x4
    80001d30:	70a080e7          	jalr	1802(ra) # 80006436 <acquire>
  ticks++;
    80001d34:	0000a517          	auipc	a0,0xa
    80001d38:	2e450513          	addi	a0,a0,740 # 8000c018 <ticks>
    80001d3c:	411c                	lw	a5,0(a0)
    80001d3e:	2785                	addiw	a5,a5,1
    80001d40:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	b1a080e7          	jalr	-1254(ra) # 8000185c <wakeup>
  release(&tickslock);
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	00004097          	auipc	ra,0x4
    80001d50:	79e080e7          	jalr	1950(ra) # 800064ea <release>
}
    80001d54:	60e2                	ld	ra,24(sp)
    80001d56:	6442                	ld	s0,16(sp)
    80001d58:	64a2                	ld	s1,8(sp)
    80001d5a:	6105                	addi	sp,sp,32
    80001d5c:	8082                	ret

0000000080001d5e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d62:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001d64:	0a07d163          	bgez	a5,80001e06 <devintr+0xa8>
{
    80001d68:	1101                	addi	sp,sp,-32
    80001d6a:	ec06                	sd	ra,24(sp)
    80001d6c:	e822                	sd	s0,16(sp)
    80001d6e:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001d70:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001d74:	46a5                	li	a3,9
    80001d76:	00d70c63          	beq	a4,a3,80001d8e <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001d7a:	577d                	li	a4,-1
    80001d7c:	177e                	slli	a4,a4,0x3f
    80001d7e:	0705                	addi	a4,a4,1
    return 0;
    80001d80:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d82:	06e78163          	beq	a5,a4,80001de4 <devintr+0x86>
  }
}
    80001d86:	60e2                	ld	ra,24(sp)
    80001d88:	6442                	ld	s0,16(sp)
    80001d8a:	6105                	addi	sp,sp,32
    80001d8c:	8082                	ret
    80001d8e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d90:	00003097          	auipc	ra,0x3
    80001d94:	64c080e7          	jalr	1612(ra) # 800053dc <plic_claim>
    80001d98:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d9a:	47a9                	li	a5,10
    80001d9c:	00f50963          	beq	a0,a5,80001dae <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001da0:	4785                	li	a5,1
    80001da2:	00f50b63          	beq	a0,a5,80001db8 <devintr+0x5a>
    return 1;
    80001da6:	4505                	li	a0,1
    } else if(irq){
    80001da8:	ec89                	bnez	s1,80001dc2 <devintr+0x64>
    80001daa:	64a2                	ld	s1,8(sp)
    80001dac:	bfe9                	j	80001d86 <devintr+0x28>
      uartintr();
    80001dae:	00004097          	auipc	ra,0x4
    80001db2:	5a8080e7          	jalr	1448(ra) # 80006356 <uartintr>
    if(irq)
    80001db6:	a839                	j	80001dd4 <devintr+0x76>
      virtio_disk_intr();
    80001db8:	00004097          	auipc	ra,0x4
    80001dbc:	af8080e7          	jalr	-1288(ra) # 800058b0 <virtio_disk_intr>
    if(irq)
    80001dc0:	a811                	j	80001dd4 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dc2:	85a6                	mv	a1,s1
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	4bc50513          	addi	a0,a0,1212 # 80008280 <etext+0x280>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	13a080e7          	jalr	314(ra) # 80005f06 <printf>
      plic_complete(irq);
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	00003097          	auipc	ra,0x3
    80001dda:	62a080e7          	jalr	1578(ra) # 80005400 <plic_complete>
    return 1;
    80001dde:	4505                	li	a0,1
    80001de0:	64a2                	ld	s1,8(sp)
    80001de2:	b755                	j	80001d86 <devintr+0x28>
    if(cpuid() == 0){
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	150080e7          	jalr	336(ra) # 80000f34 <cpuid>
    80001dec:	c901                	beqz	a0,80001dfc <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dee:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001df2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001df4:	14479073          	csrw	sip,a5
    return 2;
    80001df8:	4509                	li	a0,2
    80001dfa:	b771                	j	80001d86 <devintr+0x28>
      clockintr();
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	f1c080e7          	jalr	-228(ra) # 80001d18 <clockintr>
    80001e04:	b7ed                	j	80001dee <devintr+0x90>
}
    80001e06:	8082                	ret

0000000080001e08 <usertrap>:
{
    80001e08:	1101                	addi	sp,sp,-32
    80001e0a:	ec06                	sd	ra,24(sp)
    80001e0c:	e822                	sd	s0,16(sp)
    80001e0e:	e426                	sd	s1,8(sp)
    80001e10:	e04a                	sd	s2,0(sp)
    80001e12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e14:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e18:	1007f793          	andi	a5,a5,256
    80001e1c:	e3ad                	bnez	a5,80001e7e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e1e:	00003797          	auipc	a5,0x3
    80001e22:	4b278793          	addi	a5,a5,1202 # 800052d0 <kernelvec>
    80001e26:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	136080e7          	jalr	310(ra) # 80000f60 <myproc>
    80001e32:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e34:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e36:	14102773          	csrr	a4,sepc
    80001e3a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e3c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e40:	47a1                	li	a5,8
    80001e42:	04f71c63          	bne	a4,a5,80001e9a <usertrap+0x92>
    if(p->killed)
    80001e46:	551c                	lw	a5,40(a0)
    80001e48:	e3b9                	bnez	a5,80001e8e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e4a:	6cb8                	ld	a4,88(s1)
    80001e4c:	6f1c                	ld	a5,24(a4)
    80001e4e:	0791                	addi	a5,a5,4
    80001e50:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e5a:	10079073          	csrw	sstatus,a5
    syscall();
    80001e5e:	00000097          	auipc	ra,0x0
    80001e62:	2e0080e7          	jalr	736(ra) # 8000213e <syscall>
  if(p->killed)
    80001e66:	549c                	lw	a5,40(s1)
    80001e68:	ebc1                	bnez	a5,80001ef8 <usertrap+0xf0>
  usertrapret();
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	e10080e7          	jalr	-496(ra) # 80001c7a <usertrapret>
}
    80001e72:	60e2                	ld	ra,24(sp)
    80001e74:	6442                	ld	s0,16(sp)
    80001e76:	64a2                	ld	s1,8(sp)
    80001e78:	6902                	ld	s2,0(sp)
    80001e7a:	6105                	addi	sp,sp,32
    80001e7c:	8082                	ret
    panic("usertrap: not from user mode");
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	42250513          	addi	a0,a0,1058 # 800082a0 <etext+0x2a0>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	036080e7          	jalr	54(ra) # 80005ebc <panic>
      exit(-1);
    80001e8e:	557d                	li	a0,-1
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	a9c080e7          	jalr	-1380(ra) # 8000192c <exit>
    80001e98:	bf4d                	j	80001e4a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	ec4080e7          	jalr	-316(ra) # 80001d5e <devintr>
    80001ea2:	892a                	mv	s2,a0
    80001ea4:	c501                	beqz	a0,80001eac <usertrap+0xa4>
  if(p->killed)
    80001ea6:	549c                	lw	a5,40(s1)
    80001ea8:	c3a1                	beqz	a5,80001ee8 <usertrap+0xe0>
    80001eaa:	a815                	j	80001ede <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eac:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001eb0:	5890                	lw	a2,48(s1)
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	40e50513          	addi	a0,a0,1038 # 800082c0 <etext+0x2c0>
    80001eba:	00004097          	auipc	ra,0x4
    80001ebe:	04c080e7          	jalr	76(ra) # 80005f06 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eca:	00006517          	auipc	a0,0x6
    80001ece:	42650513          	addi	a0,a0,1062 # 800082f0 <etext+0x2f0>
    80001ed2:	00004097          	auipc	ra,0x4
    80001ed6:	034080e7          	jalr	52(ra) # 80005f06 <printf>
    p->killed = 1;
    80001eda:	4785                	li	a5,1
    80001edc:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ede:	557d                	li	a0,-1
    80001ee0:	00000097          	auipc	ra,0x0
    80001ee4:	a4c080e7          	jalr	-1460(ra) # 8000192c <exit>
  if(which_dev == 2)
    80001ee8:	4789                	li	a5,2
    80001eea:	f8f910e3          	bne	s2,a5,80001e6a <usertrap+0x62>
    yield();
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	7a6080e7          	jalr	1958(ra) # 80001694 <yield>
    80001ef6:	bf95                	j	80001e6a <usertrap+0x62>
  int which_dev = 0;
    80001ef8:	4901                	li	s2,0
    80001efa:	b7d5                	j	80001ede <usertrap+0xd6>

0000000080001efc <kerneltrap>:
{
    80001efc:	7179                	addi	sp,sp,-48
    80001efe:	f406                	sd	ra,40(sp)
    80001f00:	f022                	sd	s0,32(sp)
    80001f02:	ec26                	sd	s1,24(sp)
    80001f04:	e84a                	sd	s2,16(sp)
    80001f06:	e44e                	sd	s3,8(sp)
    80001f08:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f0e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f12:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f16:	1004f793          	andi	a5,s1,256
    80001f1a:	cb85                	beqz	a5,80001f4a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f20:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f22:	ef85                	bnez	a5,80001f5a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f24:	00000097          	auipc	ra,0x0
    80001f28:	e3a080e7          	jalr	-454(ra) # 80001d5e <devintr>
    80001f2c:	cd1d                	beqz	a0,80001f6a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f2e:	4789                	li	a5,2
    80001f30:	06f50a63          	beq	a0,a5,80001fa4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f34:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f38:	10049073          	csrw	sstatus,s1
}
    80001f3c:	70a2                	ld	ra,40(sp)
    80001f3e:	7402                	ld	s0,32(sp)
    80001f40:	64e2                	ld	s1,24(sp)
    80001f42:	6942                	ld	s2,16(sp)
    80001f44:	69a2                	ld	s3,8(sp)
    80001f46:	6145                	addi	sp,sp,48
    80001f48:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f4a:	00006517          	auipc	a0,0x6
    80001f4e:	3c650513          	addi	a0,a0,966 # 80008310 <etext+0x310>
    80001f52:	00004097          	auipc	ra,0x4
    80001f56:	f6a080e7          	jalr	-150(ra) # 80005ebc <panic>
    panic("kerneltrap: interrupts enabled");
    80001f5a:	00006517          	auipc	a0,0x6
    80001f5e:	3de50513          	addi	a0,a0,990 # 80008338 <etext+0x338>
    80001f62:	00004097          	auipc	ra,0x4
    80001f66:	f5a080e7          	jalr	-166(ra) # 80005ebc <panic>
    printf("scause %p\n", scause);
    80001f6a:	85ce                	mv	a1,s3
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	3ec50513          	addi	a0,a0,1004 # 80008358 <etext+0x358>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	f92080e7          	jalr	-110(ra) # 80005f06 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f80:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f84:	00006517          	auipc	a0,0x6
    80001f88:	3e450513          	addi	a0,a0,996 # 80008368 <etext+0x368>
    80001f8c:	00004097          	auipc	ra,0x4
    80001f90:	f7a080e7          	jalr	-134(ra) # 80005f06 <printf>
    panic("kerneltrap");
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	3ec50513          	addi	a0,a0,1004 # 80008380 <etext+0x380>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	f20080e7          	jalr	-224(ra) # 80005ebc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	fbc080e7          	jalr	-68(ra) # 80000f60 <myproc>
    80001fac:	d541                	beqz	a0,80001f34 <kerneltrap+0x38>
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	fb2080e7          	jalr	-78(ra) # 80000f60 <myproc>
    80001fb6:	4d18                	lw	a4,24(a0)
    80001fb8:	4791                	li	a5,4
    80001fba:	f6f71de3          	bne	a4,a5,80001f34 <kerneltrap+0x38>
    yield();
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	6d6080e7          	jalr	1750(ra) # 80001694 <yield>
    80001fc6:	b7bd                	j	80001f34 <kerneltrap+0x38>

0000000080001fc8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	1000                	addi	s0,sp,32
    80001fd2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	f8c080e7          	jalr	-116(ra) # 80000f60 <myproc>
  switch (n) {
    80001fdc:	4795                	li	a5,5
    80001fde:	0497e163          	bltu	a5,s1,80002020 <argraw+0x58>
    80001fe2:	048a                	slli	s1,s1,0x2
    80001fe4:	00006717          	auipc	a4,0x6
    80001fe8:	77c70713          	addi	a4,a4,1916 # 80008760 <states.0+0x30>
    80001fec:	94ba                	add	s1,s1,a4
    80001fee:	409c                	lw	a5,0(s1)
    80001ff0:	97ba                	add	a5,a5,a4
    80001ff2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ff8:	60e2                	ld	ra,24(sp)
    80001ffa:	6442                	ld	s0,16(sp)
    80001ffc:	64a2                	ld	s1,8(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret
    return p->trapframe->a1;
    80002002:	6d3c                	ld	a5,88(a0)
    80002004:	7fa8                	ld	a0,120(a5)
    80002006:	bfcd                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a2;
    80002008:	6d3c                	ld	a5,88(a0)
    8000200a:	63c8                	ld	a0,128(a5)
    8000200c:	b7f5                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a3;
    8000200e:	6d3c                	ld	a5,88(a0)
    80002010:	67c8                	ld	a0,136(a5)
    80002012:	b7dd                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a4;
    80002014:	6d3c                	ld	a5,88(a0)
    80002016:	6bc8                	ld	a0,144(a5)
    80002018:	b7c5                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a5;
    8000201a:	6d3c                	ld	a5,88(a0)
    8000201c:	6fc8                	ld	a0,152(a5)
    8000201e:	bfe9                	j	80001ff8 <argraw+0x30>
  panic("argraw");
    80002020:	00006517          	auipc	a0,0x6
    80002024:	37050513          	addi	a0,a0,880 # 80008390 <etext+0x390>
    80002028:	00004097          	auipc	ra,0x4
    8000202c:	e94080e7          	jalr	-364(ra) # 80005ebc <panic>

0000000080002030 <fetchaddr>:
{
    80002030:	1101                	addi	sp,sp,-32
    80002032:	ec06                	sd	ra,24(sp)
    80002034:	e822                	sd	s0,16(sp)
    80002036:	e426                	sd	s1,8(sp)
    80002038:	e04a                	sd	s2,0(sp)
    8000203a:	1000                	addi	s0,sp,32
    8000203c:	84aa                	mv	s1,a0
    8000203e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	f20080e7          	jalr	-224(ra) # 80000f60 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002048:	653c                	ld	a5,72(a0)
    8000204a:	02f4f863          	bgeu	s1,a5,8000207a <fetchaddr+0x4a>
    8000204e:	00848713          	addi	a4,s1,8
    80002052:	02e7e663          	bltu	a5,a4,8000207e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002056:	46a1                	li	a3,8
    80002058:	8626                	mv	a2,s1
    8000205a:	85ca                	mv	a1,s2
    8000205c:	6928                	ld	a0,80(a0)
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	b46080e7          	jalr	-1210(ra) # 80000ba4 <copyin>
    80002066:	00a03533          	snez	a0,a0
    8000206a:	40a00533          	neg	a0,a0
}
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	64a2                	ld	s1,8(sp)
    80002074:	6902                	ld	s2,0(sp)
    80002076:	6105                	addi	sp,sp,32
    80002078:	8082                	ret
    return -1;
    8000207a:	557d                	li	a0,-1
    8000207c:	bfcd                	j	8000206e <fetchaddr+0x3e>
    8000207e:	557d                	li	a0,-1
    80002080:	b7fd                	j	8000206e <fetchaddr+0x3e>

0000000080002082 <fetchstr>:
{
    80002082:	7179                	addi	sp,sp,-48
    80002084:	f406                	sd	ra,40(sp)
    80002086:	f022                	sd	s0,32(sp)
    80002088:	ec26                	sd	s1,24(sp)
    8000208a:	e84a                	sd	s2,16(sp)
    8000208c:	e44e                	sd	s3,8(sp)
    8000208e:	1800                	addi	s0,sp,48
    80002090:	892a                	mv	s2,a0
    80002092:	84ae                	mv	s1,a1
    80002094:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	eca080e7          	jalr	-310(ra) # 80000f60 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000209e:	86ce                	mv	a3,s3
    800020a0:	864a                	mv	a2,s2
    800020a2:	85a6                	mv	a1,s1
    800020a4:	6928                	ld	a0,80(a0)
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	b8c080e7          	jalr	-1140(ra) # 80000c32 <copyinstr>
  if(err < 0)
    800020ae:	00054763          	bltz	a0,800020bc <fetchstr+0x3a>
  return strlen(buf);
    800020b2:	8526                	mv	a0,s1
    800020b4:	ffffe097          	auipc	ra,0xffffe
    800020b8:	23a080e7          	jalr	570(ra) # 800002ee <strlen>
}
    800020bc:	70a2                	ld	ra,40(sp)
    800020be:	7402                	ld	s0,32(sp)
    800020c0:	64e2                	ld	s1,24(sp)
    800020c2:	6942                	ld	s2,16(sp)
    800020c4:	69a2                	ld	s3,8(sp)
    800020c6:	6145                	addi	sp,sp,48
    800020c8:	8082                	ret

00000000800020ca <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020ca:	1101                	addi	sp,sp,-32
    800020cc:	ec06                	sd	ra,24(sp)
    800020ce:	e822                	sd	s0,16(sp)
    800020d0:	e426                	sd	s1,8(sp)
    800020d2:	1000                	addi	s0,sp,32
    800020d4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020d6:	00000097          	auipc	ra,0x0
    800020da:	ef2080e7          	jalr	-270(ra) # 80001fc8 <argraw>
    800020de:	c088                	sw	a0,0(s1)
  return 0;
}
    800020e0:	4501                	li	a0,0
    800020e2:	60e2                	ld	ra,24(sp)
    800020e4:	6442                	ld	s0,16(sp)
    800020e6:	64a2                	ld	s1,8(sp)
    800020e8:	6105                	addi	sp,sp,32
    800020ea:	8082                	ret

00000000800020ec <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020ec:	1101                	addi	sp,sp,-32
    800020ee:	ec06                	sd	ra,24(sp)
    800020f0:	e822                	sd	s0,16(sp)
    800020f2:	e426                	sd	s1,8(sp)
    800020f4:	1000                	addi	s0,sp,32
    800020f6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020f8:	00000097          	auipc	ra,0x0
    800020fc:	ed0080e7          	jalr	-304(ra) # 80001fc8 <argraw>
    80002100:	e088                	sd	a0,0(s1)
  return 0;
}
    80002102:	4501                	li	a0,0
    80002104:	60e2                	ld	ra,24(sp)
    80002106:	6442                	ld	s0,16(sp)
    80002108:	64a2                	ld	s1,8(sp)
    8000210a:	6105                	addi	sp,sp,32
    8000210c:	8082                	ret

000000008000210e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	e04a                	sd	s2,0(sp)
    80002118:	1000                	addi	s0,sp,32
    8000211a:	84ae                	mv	s1,a1
    8000211c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	eaa080e7          	jalr	-342(ra) # 80001fc8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002126:	864a                	mv	a2,s2
    80002128:	85a6                	mv	a1,s1
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	f58080e7          	jalr	-168(ra) # 80002082 <fetchstr>
}
    80002132:	60e2                	ld	ra,24(sp)
    80002134:	6442                	ld	s0,16(sp)
    80002136:	64a2                	ld	s1,8(sp)
    80002138:	6902                	ld	s2,0(sp)
    8000213a:	6105                	addi	sp,sp,32
    8000213c:	8082                	ret

000000008000213e <syscall>:



void
syscall(void)
{
    8000213e:	1101                	addi	sp,sp,-32
    80002140:	ec06                	sd	ra,24(sp)
    80002142:	e822                	sd	s0,16(sp)
    80002144:	e426                	sd	s1,8(sp)
    80002146:	e04a                	sd	s2,0(sp)
    80002148:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	e16080e7          	jalr	-490(ra) # 80000f60 <myproc>
    80002152:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002154:	05853903          	ld	s2,88(a0)
    80002158:	0a893783          	ld	a5,168(s2)
    8000215c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002160:	37fd                	addiw	a5,a5,-1
    80002162:	4775                	li	a4,29
    80002164:	00f76f63          	bltu	a4,a5,80002182 <syscall+0x44>
    80002168:	00369713          	slli	a4,a3,0x3
    8000216c:	00006797          	auipc	a5,0x6
    80002170:	60c78793          	addi	a5,a5,1548 # 80008778 <syscalls>
    80002174:	97ba                	add	a5,a5,a4
    80002176:	639c                	ld	a5,0(a5)
    80002178:	c789                	beqz	a5,80002182 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000217a:	9782                	jalr	a5
    8000217c:	06a93823          	sd	a0,112(s2)
    80002180:	a839                	j	8000219e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002182:	16048613          	addi	a2,s1,352
    80002186:	588c                	lw	a1,48(s1)
    80002188:	00006517          	auipc	a0,0x6
    8000218c:	21050513          	addi	a0,a0,528 # 80008398 <etext+0x398>
    80002190:	00004097          	auipc	ra,0x4
    80002194:	d76080e7          	jalr	-650(ra) # 80005f06 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002198:	6cbc                	ld	a5,88(s1)
    8000219a:	577d                	li	a4,-1
    8000219c:	fbb8                	sd	a4,112(a5)
  }
}
    8000219e:	60e2                	ld	ra,24(sp)
    800021a0:	6442                	ld	s0,16(sp)
    800021a2:	64a2                	ld	s1,8(sp)
    800021a4:	6902                	ld	s2,0(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021aa:	1101                	addi	sp,sp,-32
    800021ac:	ec06                	sd	ra,24(sp)
    800021ae:	e822                	sd	s0,16(sp)
    800021b0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021b2:	fec40593          	addi	a1,s0,-20
    800021b6:	4501                	li	a0,0
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	f12080e7          	jalr	-238(ra) # 800020ca <argint>
    return -1;
    800021c0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021c2:	00054963          	bltz	a0,800021d4 <sys_exit+0x2a>
  exit(n);
    800021c6:	fec42503          	lw	a0,-20(s0)
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	762080e7          	jalr	1890(ra) # 8000192c <exit>
  return 0;  // not reached
    800021d2:	4781                	li	a5,0
}
    800021d4:	853e                	mv	a0,a5
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret

00000000800021de <sys_getpid>:

uint64
sys_getpid(void)
{
    800021de:	1141                	addi	sp,sp,-16
    800021e0:	e406                	sd	ra,8(sp)
    800021e2:	e022                	sd	s0,0(sp)
    800021e4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	d7a080e7          	jalr	-646(ra) # 80000f60 <myproc>
}
    800021ee:	5908                	lw	a0,48(a0)
    800021f0:	60a2                	ld	ra,8(sp)
    800021f2:	6402                	ld	s0,0(sp)
    800021f4:	0141                	addi	sp,sp,16
    800021f6:	8082                	ret

00000000800021f8 <sys_fork>:

uint64
sys_fork(void)
{
    800021f8:	1141                	addi	sp,sp,-16
    800021fa:	e406                	sd	ra,8(sp)
    800021fc:	e022                	sd	s0,0(sp)
    800021fe:	0800                	addi	s0,sp,16
  return fork();
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	1dc080e7          	jalr	476(ra) # 800013dc <fork>
}
    80002208:	60a2                	ld	ra,8(sp)
    8000220a:	6402                	ld	s0,0(sp)
    8000220c:	0141                	addi	sp,sp,16
    8000220e:	8082                	ret

0000000080002210 <sys_wait>:

uint64
sys_wait(void)
{
    80002210:	1101                	addi	sp,sp,-32
    80002212:	ec06                	sd	ra,24(sp)
    80002214:	e822                	sd	s0,16(sp)
    80002216:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002218:	fe840593          	addi	a1,s0,-24
    8000221c:	4501                	li	a0,0
    8000221e:	00000097          	auipc	ra,0x0
    80002222:	ece080e7          	jalr	-306(ra) # 800020ec <argaddr>
    80002226:	87aa                	mv	a5,a0
    return -1;
    80002228:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000222a:	0007c863          	bltz	a5,8000223a <sys_wait+0x2a>
  return wait(p);
    8000222e:	fe843503          	ld	a0,-24(s0)
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	502080e7          	jalr	1282(ra) # 80001734 <wait>
}
    8000223a:	60e2                	ld	ra,24(sp)
    8000223c:	6442                	ld	s0,16(sp)
    8000223e:	6105                	addi	sp,sp,32
    80002240:	8082                	ret

0000000080002242 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002242:	7179                	addi	sp,sp,-48
    80002244:	f406                	sd	ra,40(sp)
    80002246:	f022                	sd	s0,32(sp)
    80002248:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000224a:	fdc40593          	addi	a1,s0,-36
    8000224e:	4501                	li	a0,0
    80002250:	00000097          	auipc	ra,0x0
    80002254:	e7a080e7          	jalr	-390(ra) # 800020ca <argint>
    80002258:	87aa                	mv	a5,a0
    return -1;
    8000225a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000225c:	0207c263          	bltz	a5,80002280 <sys_sbrk+0x3e>
    80002260:	ec26                	sd	s1,24(sp)
  
  addr = myproc()->sz;
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	cfe080e7          	jalr	-770(ra) # 80000f60 <myproc>
    8000226a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000226c:	fdc42503          	lw	a0,-36(s0)
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	0f4080e7          	jalr	244(ra) # 80001364 <growproc>
    80002278:	00054863          	bltz	a0,80002288 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000227c:	8526                	mv	a0,s1
    8000227e:	64e2                	ld	s1,24(sp)
}
    80002280:	70a2                	ld	ra,40(sp)
    80002282:	7402                	ld	s0,32(sp)
    80002284:	6145                	addi	sp,sp,48
    80002286:	8082                	ret
    return -1;
    80002288:	557d                	li	a0,-1
    8000228a:	64e2                	ld	s1,24(sp)
    8000228c:	bfd5                	j	80002280 <sys_sbrk+0x3e>

000000008000228e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000228e:	7139                	addi	sp,sp,-64
    80002290:	fc06                	sd	ra,56(sp)
    80002292:	f822                	sd	s0,48(sp)
    80002294:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002296:	fcc40593          	addi	a1,s0,-52
    8000229a:	4501                	li	a0,0
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	e2e080e7          	jalr	-466(ra) # 800020ca <argint>
    return -1;
    800022a4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022a6:	06054b63          	bltz	a0,8000231c <sys_sleep+0x8e>
    800022aa:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800022ac:	00010517          	auipc	a0,0x10
    800022b0:	dd450513          	addi	a0,a0,-556 # 80012080 <tickslock>
    800022b4:	00004097          	auipc	ra,0x4
    800022b8:	182080e7          	jalr	386(ra) # 80006436 <acquire>
  ticks0 = ticks;
    800022bc:	0000a917          	auipc	s2,0xa
    800022c0:	d5c92903          	lw	s2,-676(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    800022c4:	fcc42783          	lw	a5,-52(s0)
    800022c8:	c3a1                	beqz	a5,80002308 <sys_sleep+0x7a>
    800022ca:	f426                	sd	s1,40(sp)
    800022cc:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022ce:	00010997          	auipc	s3,0x10
    800022d2:	db298993          	addi	s3,s3,-590 # 80012080 <tickslock>
    800022d6:	0000a497          	auipc	s1,0xa
    800022da:	d4248493          	addi	s1,s1,-702 # 8000c018 <ticks>
    if(myproc()->killed){
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	c82080e7          	jalr	-894(ra) # 80000f60 <myproc>
    800022e6:	551c                	lw	a5,40(a0)
    800022e8:	ef9d                	bnez	a5,80002326 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022ea:	85ce                	mv	a1,s3
    800022ec:	8526                	mv	a0,s1
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	3e2080e7          	jalr	994(ra) # 800016d0 <sleep>
  while(ticks - ticks0 < n){
    800022f6:	409c                	lw	a5,0(s1)
    800022f8:	412787bb          	subw	a5,a5,s2
    800022fc:	fcc42703          	lw	a4,-52(s0)
    80002300:	fce7efe3          	bltu	a5,a4,800022de <sys_sleep+0x50>
    80002304:	74a2                	ld	s1,40(sp)
    80002306:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002308:	00010517          	auipc	a0,0x10
    8000230c:	d7850513          	addi	a0,a0,-648 # 80012080 <tickslock>
    80002310:	00004097          	auipc	ra,0x4
    80002314:	1da080e7          	jalr	474(ra) # 800064ea <release>
  return 0;
    80002318:	4781                	li	a5,0
    8000231a:	7902                	ld	s2,32(sp)
}
    8000231c:	853e                	mv	a0,a5
    8000231e:	70e2                	ld	ra,56(sp)
    80002320:	7442                	ld	s0,48(sp)
    80002322:	6121                	addi	sp,sp,64
    80002324:	8082                	ret
      release(&tickslock);
    80002326:	00010517          	auipc	a0,0x10
    8000232a:	d5a50513          	addi	a0,a0,-678 # 80012080 <tickslock>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	1bc080e7          	jalr	444(ra) # 800064ea <release>
      return -1;
    80002336:	57fd                	li	a5,-1
    80002338:	74a2                	ld	s1,40(sp)
    8000233a:	7902                	ld	s2,32(sp)
    8000233c:	69e2                	ld	s3,24(sp)
    8000233e:	bff9                	j	8000231c <sys_sleep+0x8e>

0000000080002340 <sys_pgaccess>:

extern pte_t *walk(pagetable_t,uint64,int);

int
sys_pgaccess(void)
{
    80002340:	715d                	addi	sp,sp,-80
    80002342:	e486                	sd	ra,72(sp)
    80002344:	e0a2                	sd	s0,64(sp)
    80002346:	0880                	addi	s0,sp,80
  uint64 va;
  uint64 bitmask_va;

  int len;

  if(argint(1, &len) < 0)   //read the len
    80002348:	fbc40593          	addi	a1,s0,-68
    8000234c:	4505                	li	a0,1
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	d7c080e7          	jalr	-644(ra) # 800020ca <argint>
    80002356:	0c054563          	bltz	a0,80002420 <sys_pgaccess+0xe0>
  return -1;

  if(len >32)
    8000235a:	fbc42703          	lw	a4,-68(s0)
    8000235e:	02000793          	li	a5,32
    80002362:	0ce7c163          	blt	a5,a4,80002424 <sys_pgaccess+0xe4>
  return -1;

  if(argaddr(0,&va)<0)
    80002366:	fc840593          	addi	a1,s0,-56
    8000236a:	4501                	li	a0,0
    8000236c:	00000097          	auipc	ra,0x0
    80002370:	d80080e7          	jalr	-640(ra) # 800020ec <argaddr>
    80002374:	0a054a63          	bltz	a0,80002428 <sys_pgaccess+0xe8>
  return -1;
  if(argaddr(2,&bitmask_va)<0)
    80002378:	fc040593          	addi	a1,s0,-64
    8000237c:	4509                	li	a0,2
    8000237e:	00000097          	auipc	ra,0x0
    80002382:	d6e080e7          	jalr	-658(ra) # 800020ec <argaddr>
    80002386:	0a054363          	bltz	a0,8000242c <sys_pgaccess+0xec>
    8000238a:	f84a                	sd	s2,48(sp)
  return -1;

  pte_t *pte;
  struct proc *p = myproc();
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	bd4080e7          	jalr	-1068(ra) # 80000f60 <myproc>
    80002394:	892a                	mv	s2,a0
  uint64 result=0;
    80002396:	fa043823          	sd	zero,-80(s0)
  for(int i=0;i<len;i++,va+=PGSIZE)
    8000239a:	fbc42783          	lw	a5,-68(s0)
    8000239e:	06f05063          	blez	a5,800023fe <sys_pgaccess+0xbe>
    800023a2:	fc26                	sd	s1,56(sp)
    800023a4:	f44e                	sd	s3,40(sp)
    800023a6:	f052                	sd	s4,32(sp)
    800023a8:	4481                	li	s1,0
  {
    if((pte = walk(p->pagetable,va,0))==0)
      return -1;
    if(*pte & PTE_A)
    {
      result |=1<<i;
    800023aa:	4a05                	li	s4,1
  for(int i=0;i<len;i++,va+=PGSIZE)
    800023ac:	6985                	lui	s3,0x1
    800023ae:	a819                	j	800023c4 <sys_pgaccess+0x84>
    800023b0:	2485                	addiw	s1,s1,1
    800023b2:	fc843783          	ld	a5,-56(s0)
    800023b6:	97ce                	add	a5,a5,s3
    800023b8:	fcf43423          	sd	a5,-56(s0)
    800023bc:	fbc42783          	lw	a5,-68(s0)
    800023c0:	02f4dc63          	bge	s1,a5,800023f8 <sys_pgaccess+0xb8>
    if((pte = walk(p->pagetable,va,0))==0)
    800023c4:	4601                	li	a2,0
    800023c6:	fc843583          	ld	a1,-56(s0)
    800023ca:	05093503          	ld	a0,80(s2)
    800023ce:	ffffe097          	auipc	ra,0xffffe
    800023d2:	084080e7          	jalr	132(ra) # 80000452 <walk>
    800023d6:	cd29                	beqz	a0,80002430 <sys_pgaccess+0xf0>
    if(*pte & PTE_A)
    800023d8:	611c                	ld	a5,0(a0)
    800023da:	0407f793          	andi	a5,a5,64
    800023de:	dbe9                	beqz	a5,800023b0 <sys_pgaccess+0x70>
      result |=1<<i;
    800023e0:	009a173b          	sllw	a4,s4,s1
    800023e4:	fb043783          	ld	a5,-80(s0)
    800023e8:	8fd9                	or	a5,a5,a4
    800023ea:	faf43823          	sd	a5,-80(s0)
      *pte &= ~PTE_A;    //reset PTE_A
    800023ee:	611c                	ld	a5,0(a0)
    800023f0:	fbf7f793          	andi	a5,a5,-65
    800023f4:	e11c                	sd	a5,0(a0)
    800023f6:	bf6d                	j	800023b0 <sys_pgaccess+0x70>
    800023f8:	74e2                	ld	s1,56(sp)
    800023fa:	79a2                	ld	s3,40(sp)
    800023fc:	7a02                	ld	s4,32(sp)
    }
  }
  copyout(p->pagetable,bitmask_va,(char*)&result,sizeof(result));
    800023fe:	46a1                	li	a3,8
    80002400:	fb040613          	addi	a2,s0,-80
    80002404:	fc043583          	ld	a1,-64(s0)
    80002408:	05093503          	ld	a0,80(s2)
    8000240c:	ffffe097          	auipc	ra,0xffffe
    80002410:	70c080e7          	jalr	1804(ra) # 80000b18 <copyout>
  return 0;
    80002414:	4501                	li	a0,0
    80002416:	7942                	ld	s2,48(sp)
}
    80002418:	60a6                	ld	ra,72(sp)
    8000241a:	6406                	ld	s0,64(sp)
    8000241c:	6161                	addi	sp,sp,80
    8000241e:	8082                	ret
  return -1;
    80002420:	557d                	li	a0,-1
    80002422:	bfdd                	j	80002418 <sys_pgaccess+0xd8>
  return -1;
    80002424:	557d                	li	a0,-1
    80002426:	bfcd                	j	80002418 <sys_pgaccess+0xd8>
  return -1;
    80002428:	557d                	li	a0,-1
    8000242a:	b7fd                	j	80002418 <sys_pgaccess+0xd8>
  return -1;
    8000242c:	557d                	li	a0,-1
    8000242e:	b7ed                	j	80002418 <sys_pgaccess+0xd8>
      return -1;
    80002430:	557d                	li	a0,-1
    80002432:	74e2                	ld	s1,56(sp)
    80002434:	7942                	ld	s2,48(sp)
    80002436:	79a2                	ld	s3,40(sp)
    80002438:	7a02                	ld	s4,32(sp)
    8000243a:	bff9                	j	80002418 <sys_pgaccess+0xd8>

000000008000243c <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000243c:	1101                	addi	sp,sp,-32
    8000243e:	ec06                	sd	ra,24(sp)
    80002440:	e822                	sd	s0,16(sp)
    80002442:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002444:	fec40593          	addi	a1,s0,-20
    80002448:	4501                	li	a0,0
    8000244a:	00000097          	auipc	ra,0x0
    8000244e:	c80080e7          	jalr	-896(ra) # 800020ca <argint>
    80002452:	87aa                	mv	a5,a0
    return -1;
    80002454:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002456:	0007c863          	bltz	a5,80002466 <sys_kill+0x2a>
  return kill(pid);
    8000245a:	fec42503          	lw	a0,-20(s0)
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	5a4080e7          	jalr	1444(ra) # 80001a02 <kill>
}
    80002466:	60e2                	ld	ra,24(sp)
    80002468:	6442                	ld	s0,16(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000246e:	1101                	addi	sp,sp,-32
    80002470:	ec06                	sd	ra,24(sp)
    80002472:	e822                	sd	s0,16(sp)
    80002474:	e426                	sd	s1,8(sp)
    80002476:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002478:	00010517          	auipc	a0,0x10
    8000247c:	c0850513          	addi	a0,a0,-1016 # 80012080 <tickslock>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	fb6080e7          	jalr	-74(ra) # 80006436 <acquire>
  xticks = ticks;
    80002488:	0000a497          	auipc	s1,0xa
    8000248c:	b904a483          	lw	s1,-1136(s1) # 8000c018 <ticks>
  release(&tickslock);
    80002490:	00010517          	auipc	a0,0x10
    80002494:	bf050513          	addi	a0,a0,-1040 # 80012080 <tickslock>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	052080e7          	jalr	82(ra) # 800064ea <release>
  return xticks;
}
    800024a0:	02049513          	slli	a0,s1,0x20
    800024a4:	9101                	srli	a0,a0,0x20
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret

00000000800024b0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024b0:	7179                	addi	sp,sp,-48
    800024b2:	f406                	sd	ra,40(sp)
    800024b4:	f022                	sd	s0,32(sp)
    800024b6:	ec26                	sd	s1,24(sp)
    800024b8:	e84a                	sd	s2,16(sp)
    800024ba:	e44e                	sd	s3,8(sp)
    800024bc:	e052                	sd	s4,0(sp)
    800024be:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024c0:	00006597          	auipc	a1,0x6
    800024c4:	ef858593          	addi	a1,a1,-264 # 800083b8 <etext+0x3b8>
    800024c8:	00010517          	auipc	a0,0x10
    800024cc:	bd050513          	addi	a0,a0,-1072 # 80012098 <bcache>
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	ed6080e7          	jalr	-298(ra) # 800063a6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024d8:	00018797          	auipc	a5,0x18
    800024dc:	bc078793          	addi	a5,a5,-1088 # 8001a098 <bcache+0x8000>
    800024e0:	00018717          	auipc	a4,0x18
    800024e4:	e2070713          	addi	a4,a4,-480 # 8001a300 <bcache+0x8268>
    800024e8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024ec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f0:	00010497          	auipc	s1,0x10
    800024f4:	bc048493          	addi	s1,s1,-1088 # 800120b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024f8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024fa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024fc:	00006a17          	auipc	s4,0x6
    80002500:	ec4a0a13          	addi	s4,s4,-316 # 800083c0 <etext+0x3c0>
    b->next = bcache.head.next;
    80002504:	2b893783          	ld	a5,696(s2)
    80002508:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000250a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000250e:	85d2                	mv	a1,s4
    80002510:	01048513          	addi	a0,s1,16
    80002514:	00001097          	auipc	ra,0x1
    80002518:	4b2080e7          	jalr	1202(ra) # 800039c6 <initsleeplock>
    bcache.head.next->prev = b;
    8000251c:	2b893783          	ld	a5,696(s2)
    80002520:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002522:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002526:	45848493          	addi	s1,s1,1112
    8000252a:	fd349de3          	bne	s1,s3,80002504 <binit+0x54>
  }
}
    8000252e:	70a2                	ld	ra,40(sp)
    80002530:	7402                	ld	s0,32(sp)
    80002532:	64e2                	ld	s1,24(sp)
    80002534:	6942                	ld	s2,16(sp)
    80002536:	69a2                	ld	s3,8(sp)
    80002538:	6a02                	ld	s4,0(sp)
    8000253a:	6145                	addi	sp,sp,48
    8000253c:	8082                	ret

000000008000253e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000253e:	7179                	addi	sp,sp,-48
    80002540:	f406                	sd	ra,40(sp)
    80002542:	f022                	sd	s0,32(sp)
    80002544:	ec26                	sd	s1,24(sp)
    80002546:	e84a                	sd	s2,16(sp)
    80002548:	e44e                	sd	s3,8(sp)
    8000254a:	1800                	addi	s0,sp,48
    8000254c:	892a                	mv	s2,a0
    8000254e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002550:	00010517          	auipc	a0,0x10
    80002554:	b4850513          	addi	a0,a0,-1208 # 80012098 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	ede080e7          	jalr	-290(ra) # 80006436 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002560:	00018497          	auipc	s1,0x18
    80002564:	df04b483          	ld	s1,-528(s1) # 8001a350 <bcache+0x82b8>
    80002568:	00018797          	auipc	a5,0x18
    8000256c:	d9878793          	addi	a5,a5,-616 # 8001a300 <bcache+0x8268>
    80002570:	02f48f63          	beq	s1,a5,800025ae <bread+0x70>
    80002574:	873e                	mv	a4,a5
    80002576:	a021                	j	8000257e <bread+0x40>
    80002578:	68a4                	ld	s1,80(s1)
    8000257a:	02e48a63          	beq	s1,a4,800025ae <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000257e:	449c                	lw	a5,8(s1)
    80002580:	ff279ce3          	bne	a5,s2,80002578 <bread+0x3a>
    80002584:	44dc                	lw	a5,12(s1)
    80002586:	ff3799e3          	bne	a5,s3,80002578 <bread+0x3a>
      b->refcnt++;
    8000258a:	40bc                	lw	a5,64(s1)
    8000258c:	2785                	addiw	a5,a5,1
    8000258e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002590:	00010517          	auipc	a0,0x10
    80002594:	b0850513          	addi	a0,a0,-1272 # 80012098 <bcache>
    80002598:	00004097          	auipc	ra,0x4
    8000259c:	f52080e7          	jalr	-174(ra) # 800064ea <release>
      acquiresleep(&b->lock);
    800025a0:	01048513          	addi	a0,s1,16
    800025a4:	00001097          	auipc	ra,0x1
    800025a8:	45c080e7          	jalr	1116(ra) # 80003a00 <acquiresleep>
      return b;
    800025ac:	a8b9                	j	8000260a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025ae:	00018497          	auipc	s1,0x18
    800025b2:	d9a4b483          	ld	s1,-614(s1) # 8001a348 <bcache+0x82b0>
    800025b6:	00018797          	auipc	a5,0x18
    800025ba:	d4a78793          	addi	a5,a5,-694 # 8001a300 <bcache+0x8268>
    800025be:	00f48863          	beq	s1,a5,800025ce <bread+0x90>
    800025c2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	cf81                	beqz	a5,800025de <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025c8:	64a4                	ld	s1,72(s1)
    800025ca:	fee49de3          	bne	s1,a4,800025c4 <bread+0x86>
  panic("bget: no buffers");
    800025ce:	00006517          	auipc	a0,0x6
    800025d2:	dfa50513          	addi	a0,a0,-518 # 800083c8 <etext+0x3c8>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	8e6080e7          	jalr	-1818(ra) # 80005ebc <panic>
      b->dev = dev;
    800025de:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025e2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025e6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025ea:	4785                	li	a5,1
    800025ec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ee:	00010517          	auipc	a0,0x10
    800025f2:	aaa50513          	addi	a0,a0,-1366 # 80012098 <bcache>
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	ef4080e7          	jalr	-268(ra) # 800064ea <release>
      acquiresleep(&b->lock);
    800025fe:	01048513          	addi	a0,s1,16
    80002602:	00001097          	auipc	ra,0x1
    80002606:	3fe080e7          	jalr	1022(ra) # 80003a00 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000260a:	409c                	lw	a5,0(s1)
    8000260c:	cb89                	beqz	a5,8000261e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000260e:	8526                	mv	a0,s1
    80002610:	70a2                	ld	ra,40(sp)
    80002612:	7402                	ld	s0,32(sp)
    80002614:	64e2                	ld	s1,24(sp)
    80002616:	6942                	ld	s2,16(sp)
    80002618:	69a2                	ld	s3,8(sp)
    8000261a:	6145                	addi	sp,sp,48
    8000261c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000261e:	4581                	li	a1,0
    80002620:	8526                	mv	a0,s1
    80002622:	00003097          	auipc	ra,0x3
    80002626:	000080e7          	jalr	ra # 80005622 <virtio_disk_rw>
    b->valid = 1;
    8000262a:	4785                	li	a5,1
    8000262c:	c09c                	sw	a5,0(s1)
  return b;
    8000262e:	b7c5                	j	8000260e <bread+0xd0>

0000000080002630 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002630:	1101                	addi	sp,sp,-32
    80002632:	ec06                	sd	ra,24(sp)
    80002634:	e822                	sd	s0,16(sp)
    80002636:	e426                	sd	s1,8(sp)
    80002638:	1000                	addi	s0,sp,32
    8000263a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000263c:	0541                	addi	a0,a0,16
    8000263e:	00001097          	auipc	ra,0x1
    80002642:	45c080e7          	jalr	1116(ra) # 80003a9a <holdingsleep>
    80002646:	cd01                	beqz	a0,8000265e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002648:	4585                	li	a1,1
    8000264a:	8526                	mv	a0,s1
    8000264c:	00003097          	auipc	ra,0x3
    80002650:	fd6080e7          	jalr	-42(ra) # 80005622 <virtio_disk_rw>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6105                	addi	sp,sp,32
    8000265c:	8082                	ret
    panic("bwrite");
    8000265e:	00006517          	auipc	a0,0x6
    80002662:	d8250513          	addi	a0,a0,-638 # 800083e0 <etext+0x3e0>
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	856080e7          	jalr	-1962(ra) # 80005ebc <panic>

000000008000266e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000266e:	1101                	addi	sp,sp,-32
    80002670:	ec06                	sd	ra,24(sp)
    80002672:	e822                	sd	s0,16(sp)
    80002674:	e426                	sd	s1,8(sp)
    80002676:	e04a                	sd	s2,0(sp)
    80002678:	1000                	addi	s0,sp,32
    8000267a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000267c:	01050913          	addi	s2,a0,16
    80002680:	854a                	mv	a0,s2
    80002682:	00001097          	auipc	ra,0x1
    80002686:	418080e7          	jalr	1048(ra) # 80003a9a <holdingsleep>
    8000268a:	c925                	beqz	a0,800026fa <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000268c:	854a                	mv	a0,s2
    8000268e:	00001097          	auipc	ra,0x1
    80002692:	3c8080e7          	jalr	968(ra) # 80003a56 <releasesleep>

  acquire(&bcache.lock);
    80002696:	00010517          	auipc	a0,0x10
    8000269a:	a0250513          	addi	a0,a0,-1534 # 80012098 <bcache>
    8000269e:	00004097          	auipc	ra,0x4
    800026a2:	d98080e7          	jalr	-616(ra) # 80006436 <acquire>
  b->refcnt--;
    800026a6:	40bc                	lw	a5,64(s1)
    800026a8:	37fd                	addiw	a5,a5,-1
    800026aa:	0007871b          	sext.w	a4,a5
    800026ae:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026b0:	e71d                	bnez	a4,800026de <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026b2:	68b8                	ld	a4,80(s1)
    800026b4:	64bc                	ld	a5,72(s1)
    800026b6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800026b8:	68b8                	ld	a4,80(s1)
    800026ba:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026bc:	00018797          	auipc	a5,0x18
    800026c0:	9dc78793          	addi	a5,a5,-1572 # 8001a098 <bcache+0x8000>
    800026c4:	2b87b703          	ld	a4,696(a5)
    800026c8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026ca:	00018717          	auipc	a4,0x18
    800026ce:	c3670713          	addi	a4,a4,-970 # 8001a300 <bcache+0x8268>
    800026d2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026d4:	2b87b703          	ld	a4,696(a5)
    800026d8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026da:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026de:	00010517          	auipc	a0,0x10
    800026e2:	9ba50513          	addi	a0,a0,-1606 # 80012098 <bcache>
    800026e6:	00004097          	auipc	ra,0x4
    800026ea:	e04080e7          	jalr	-508(ra) # 800064ea <release>
}
    800026ee:	60e2                	ld	ra,24(sp)
    800026f0:	6442                	ld	s0,16(sp)
    800026f2:	64a2                	ld	s1,8(sp)
    800026f4:	6902                	ld	s2,0(sp)
    800026f6:	6105                	addi	sp,sp,32
    800026f8:	8082                	ret
    panic("brelse");
    800026fa:	00006517          	auipc	a0,0x6
    800026fe:	cee50513          	addi	a0,a0,-786 # 800083e8 <etext+0x3e8>
    80002702:	00003097          	auipc	ra,0x3
    80002706:	7ba080e7          	jalr	1978(ra) # 80005ebc <panic>

000000008000270a <bpin>:

void
bpin(struct buf *b) {
    8000270a:	1101                	addi	sp,sp,-32
    8000270c:	ec06                	sd	ra,24(sp)
    8000270e:	e822                	sd	s0,16(sp)
    80002710:	e426                	sd	s1,8(sp)
    80002712:	1000                	addi	s0,sp,32
    80002714:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002716:	00010517          	auipc	a0,0x10
    8000271a:	98250513          	addi	a0,a0,-1662 # 80012098 <bcache>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	d18080e7          	jalr	-744(ra) # 80006436 <acquire>
  b->refcnt++;
    80002726:	40bc                	lw	a5,64(s1)
    80002728:	2785                	addiw	a5,a5,1
    8000272a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000272c:	00010517          	auipc	a0,0x10
    80002730:	96c50513          	addi	a0,a0,-1684 # 80012098 <bcache>
    80002734:	00004097          	auipc	ra,0x4
    80002738:	db6080e7          	jalr	-586(ra) # 800064ea <release>
}
    8000273c:	60e2                	ld	ra,24(sp)
    8000273e:	6442                	ld	s0,16(sp)
    80002740:	64a2                	ld	s1,8(sp)
    80002742:	6105                	addi	sp,sp,32
    80002744:	8082                	ret

0000000080002746 <bunpin>:

void
bunpin(struct buf *b) {
    80002746:	1101                	addi	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	e426                	sd	s1,8(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002752:	00010517          	auipc	a0,0x10
    80002756:	94650513          	addi	a0,a0,-1722 # 80012098 <bcache>
    8000275a:	00004097          	auipc	ra,0x4
    8000275e:	cdc080e7          	jalr	-804(ra) # 80006436 <acquire>
  b->refcnt--;
    80002762:	40bc                	lw	a5,64(s1)
    80002764:	37fd                	addiw	a5,a5,-1
    80002766:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002768:	00010517          	auipc	a0,0x10
    8000276c:	93050513          	addi	a0,a0,-1744 # 80012098 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	d7a080e7          	jalr	-646(ra) # 800064ea <release>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002782:	1101                	addi	sp,sp,-32
    80002784:	ec06                	sd	ra,24(sp)
    80002786:	e822                	sd	s0,16(sp)
    80002788:	e426                	sd	s1,8(sp)
    8000278a:	e04a                	sd	s2,0(sp)
    8000278c:	1000                	addi	s0,sp,32
    8000278e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002790:	00d5d59b          	srliw	a1,a1,0xd
    80002794:	00018797          	auipc	a5,0x18
    80002798:	fe07a783          	lw	a5,-32(a5) # 8001a774 <sb+0x1c>
    8000279c:	9dbd                	addw	a1,a1,a5
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	da0080e7          	jalr	-608(ra) # 8000253e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027a6:	0074f713          	andi	a4,s1,7
    800027aa:	4785                	li	a5,1
    800027ac:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027b0:	14ce                	slli	s1,s1,0x33
    800027b2:	90d9                	srli	s1,s1,0x36
    800027b4:	00950733          	add	a4,a0,s1
    800027b8:	05874703          	lbu	a4,88(a4)
    800027bc:	00e7f6b3          	and	a3,a5,a4
    800027c0:	c69d                	beqz	a3,800027ee <bfree+0x6c>
    800027c2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027c4:	94aa                	add	s1,s1,a0
    800027c6:	fff7c793          	not	a5,a5
    800027ca:	8f7d                	and	a4,a4,a5
    800027cc:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027d0:	00001097          	auipc	ra,0x1
    800027d4:	112080e7          	jalr	274(ra) # 800038e2 <log_write>
  brelse(bp);
    800027d8:	854a                	mv	a0,s2
    800027da:	00000097          	auipc	ra,0x0
    800027de:	e94080e7          	jalr	-364(ra) # 8000266e <brelse>
}
    800027e2:	60e2                	ld	ra,24(sp)
    800027e4:	6442                	ld	s0,16(sp)
    800027e6:	64a2                	ld	s1,8(sp)
    800027e8:	6902                	ld	s2,0(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret
    panic("freeing free block");
    800027ee:	00006517          	auipc	a0,0x6
    800027f2:	c0250513          	addi	a0,a0,-1022 # 800083f0 <etext+0x3f0>
    800027f6:	00003097          	auipc	ra,0x3
    800027fa:	6c6080e7          	jalr	1734(ra) # 80005ebc <panic>

00000000800027fe <balloc>:
{
    800027fe:	711d                	addi	sp,sp,-96
    80002800:	ec86                	sd	ra,88(sp)
    80002802:	e8a2                	sd	s0,80(sp)
    80002804:	e4a6                	sd	s1,72(sp)
    80002806:	e0ca                	sd	s2,64(sp)
    80002808:	fc4e                	sd	s3,56(sp)
    8000280a:	f852                	sd	s4,48(sp)
    8000280c:	f456                	sd	s5,40(sp)
    8000280e:	f05a                	sd	s6,32(sp)
    80002810:	ec5e                	sd	s7,24(sp)
    80002812:	e862                	sd	s8,16(sp)
    80002814:	e466                	sd	s9,8(sp)
    80002816:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002818:	00018797          	auipc	a5,0x18
    8000281c:	f447a783          	lw	a5,-188(a5) # 8001a75c <sb+0x4>
    80002820:	cbc1                	beqz	a5,800028b0 <balloc+0xb2>
    80002822:	8baa                	mv	s7,a0
    80002824:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002826:	00018b17          	auipc	s6,0x18
    8000282a:	f32b0b13          	addi	s6,s6,-206 # 8001a758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000282e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002830:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002832:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002834:	6c89                	lui	s9,0x2
    80002836:	a831                	j	80002852 <balloc+0x54>
    brelse(bp);
    80002838:	854a                	mv	a0,s2
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	e34080e7          	jalr	-460(ra) # 8000266e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002842:	015c87bb          	addw	a5,s9,s5
    80002846:	00078a9b          	sext.w	s5,a5
    8000284a:	004b2703          	lw	a4,4(s6)
    8000284e:	06eaf163          	bgeu	s5,a4,800028b0 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002852:	41fad79b          	sraiw	a5,s5,0x1f
    80002856:	0137d79b          	srliw	a5,a5,0x13
    8000285a:	015787bb          	addw	a5,a5,s5
    8000285e:	40d7d79b          	sraiw	a5,a5,0xd
    80002862:	01cb2583          	lw	a1,28(s6)
    80002866:	9dbd                	addw	a1,a1,a5
    80002868:	855e                	mv	a0,s7
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	cd4080e7          	jalr	-812(ra) # 8000253e <bread>
    80002872:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002874:	004b2503          	lw	a0,4(s6)
    80002878:	000a849b          	sext.w	s1,s5
    8000287c:	8762                	mv	a4,s8
    8000287e:	faa4fde3          	bgeu	s1,a0,80002838 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002882:	00777693          	andi	a3,a4,7
    80002886:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000288a:	41f7579b          	sraiw	a5,a4,0x1f
    8000288e:	01d7d79b          	srliw	a5,a5,0x1d
    80002892:	9fb9                	addw	a5,a5,a4
    80002894:	4037d79b          	sraiw	a5,a5,0x3
    80002898:	00f90633          	add	a2,s2,a5
    8000289c:	05864603          	lbu	a2,88(a2)
    800028a0:	00c6f5b3          	and	a1,a3,a2
    800028a4:	cd91                	beqz	a1,800028c0 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a6:	2705                	addiw	a4,a4,1
    800028a8:	2485                	addiw	s1,s1,1
    800028aa:	fd471ae3          	bne	a4,s4,8000287e <balloc+0x80>
    800028ae:	b769                	j	80002838 <balloc+0x3a>
  panic("balloc: out of blocks");
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	b5850513          	addi	a0,a0,-1192 # 80008408 <etext+0x408>
    800028b8:	00003097          	auipc	ra,0x3
    800028bc:	604080e7          	jalr	1540(ra) # 80005ebc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028c0:	97ca                	add	a5,a5,s2
    800028c2:	8e55                	or	a2,a2,a3
    800028c4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028c8:	854a                	mv	a0,s2
    800028ca:	00001097          	auipc	ra,0x1
    800028ce:	018080e7          	jalr	24(ra) # 800038e2 <log_write>
        brelse(bp);
    800028d2:	854a                	mv	a0,s2
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	d9a080e7          	jalr	-614(ra) # 8000266e <brelse>
  bp = bread(dev, bno);
    800028dc:	85a6                	mv	a1,s1
    800028de:	855e                	mv	a0,s7
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	c5e080e7          	jalr	-930(ra) # 8000253e <bread>
    800028e8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028ea:	40000613          	li	a2,1024
    800028ee:	4581                	li	a1,0
    800028f0:	05850513          	addi	a0,a0,88
    800028f4:	ffffe097          	auipc	ra,0xffffe
    800028f8:	886080e7          	jalr	-1914(ra) # 8000017a <memset>
  log_write(bp);
    800028fc:	854a                	mv	a0,s2
    800028fe:	00001097          	auipc	ra,0x1
    80002902:	fe4080e7          	jalr	-28(ra) # 800038e2 <log_write>
  brelse(bp);
    80002906:	854a                	mv	a0,s2
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	d66080e7          	jalr	-666(ra) # 8000266e <brelse>
}
    80002910:	8526                	mv	a0,s1
    80002912:	60e6                	ld	ra,88(sp)
    80002914:	6446                	ld	s0,80(sp)
    80002916:	64a6                	ld	s1,72(sp)
    80002918:	6906                	ld	s2,64(sp)
    8000291a:	79e2                	ld	s3,56(sp)
    8000291c:	7a42                	ld	s4,48(sp)
    8000291e:	7aa2                	ld	s5,40(sp)
    80002920:	7b02                	ld	s6,32(sp)
    80002922:	6be2                	ld	s7,24(sp)
    80002924:	6c42                	ld	s8,16(sp)
    80002926:	6ca2                	ld	s9,8(sp)
    80002928:	6125                	addi	sp,sp,96
    8000292a:	8082                	ret

000000008000292c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000292c:	7179                	addi	sp,sp,-48
    8000292e:	f406                	sd	ra,40(sp)
    80002930:	f022                	sd	s0,32(sp)
    80002932:	ec26                	sd	s1,24(sp)
    80002934:	e84a                	sd	s2,16(sp)
    80002936:	e44e                	sd	s3,8(sp)
    80002938:	1800                	addi	s0,sp,48
    8000293a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000293c:	47ad                	li	a5,11
    8000293e:	04b7ff63          	bgeu	a5,a1,8000299c <bmap+0x70>
    80002942:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002944:	ff45849b          	addiw	s1,a1,-12
    80002948:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000294c:	0ff00793          	li	a5,255
    80002950:	0ae7e463          	bltu	a5,a4,800029f8 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002954:	08052583          	lw	a1,128(a0)
    80002958:	c5b5                	beqz	a1,800029c4 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000295a:	00092503          	lw	a0,0(s2)
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	be0080e7          	jalr	-1056(ra) # 8000253e <bread>
    80002966:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002968:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000296c:	02049713          	slli	a4,s1,0x20
    80002970:	01e75593          	srli	a1,a4,0x1e
    80002974:	00b784b3          	add	s1,a5,a1
    80002978:	0004a983          	lw	s3,0(s1)
    8000297c:	04098e63          	beqz	s3,800029d8 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002980:	8552                	mv	a0,s4
    80002982:	00000097          	auipc	ra,0x0
    80002986:	cec080e7          	jalr	-788(ra) # 8000266e <brelse>
    return addr;
    8000298a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000298c:	854e                	mv	a0,s3
    8000298e:	70a2                	ld	ra,40(sp)
    80002990:	7402                	ld	s0,32(sp)
    80002992:	64e2                	ld	s1,24(sp)
    80002994:	6942                	ld	s2,16(sp)
    80002996:	69a2                	ld	s3,8(sp)
    80002998:	6145                	addi	sp,sp,48
    8000299a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000299c:	02059793          	slli	a5,a1,0x20
    800029a0:	01e7d593          	srli	a1,a5,0x1e
    800029a4:	00b504b3          	add	s1,a0,a1
    800029a8:	0504a983          	lw	s3,80(s1)
    800029ac:	fe0990e3          	bnez	s3,8000298c <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029b0:	4108                	lw	a0,0(a0)
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	e4c080e7          	jalr	-436(ra) # 800027fe <balloc>
    800029ba:	0005099b          	sext.w	s3,a0
    800029be:	0534a823          	sw	s3,80(s1)
    800029c2:	b7e9                	j	8000298c <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029c4:	4108                	lw	a0,0(a0)
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	e38080e7          	jalr	-456(ra) # 800027fe <balloc>
    800029ce:	0005059b          	sext.w	a1,a0
    800029d2:	08b92023          	sw	a1,128(s2)
    800029d6:	b751                	j	8000295a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029d8:	00092503          	lw	a0,0(s2)
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	e22080e7          	jalr	-478(ra) # 800027fe <balloc>
    800029e4:	0005099b          	sext.w	s3,a0
    800029e8:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029ec:	8552                	mv	a0,s4
    800029ee:	00001097          	auipc	ra,0x1
    800029f2:	ef4080e7          	jalr	-268(ra) # 800038e2 <log_write>
    800029f6:	b769                	j	80002980 <bmap+0x54>
  panic("bmap: out of range");
    800029f8:	00006517          	auipc	a0,0x6
    800029fc:	a2850513          	addi	a0,a0,-1496 # 80008420 <etext+0x420>
    80002a00:	00003097          	auipc	ra,0x3
    80002a04:	4bc080e7          	jalr	1212(ra) # 80005ebc <panic>

0000000080002a08 <iget>:
{
    80002a08:	7179                	addi	sp,sp,-48
    80002a0a:	f406                	sd	ra,40(sp)
    80002a0c:	f022                	sd	s0,32(sp)
    80002a0e:	ec26                	sd	s1,24(sp)
    80002a10:	e84a                	sd	s2,16(sp)
    80002a12:	e44e                	sd	s3,8(sp)
    80002a14:	e052                	sd	s4,0(sp)
    80002a16:	1800                	addi	s0,sp,48
    80002a18:	89aa                	mv	s3,a0
    80002a1a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a1c:	00018517          	auipc	a0,0x18
    80002a20:	d5c50513          	addi	a0,a0,-676 # 8001a778 <itable>
    80002a24:	00004097          	auipc	ra,0x4
    80002a28:	a12080e7          	jalr	-1518(ra) # 80006436 <acquire>
  empty = 0;
    80002a2c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a2e:	00018497          	auipc	s1,0x18
    80002a32:	d6248493          	addi	s1,s1,-670 # 8001a790 <itable+0x18>
    80002a36:	00019697          	auipc	a3,0x19
    80002a3a:	7ea68693          	addi	a3,a3,2026 # 8001c220 <log>
    80002a3e:	a039                	j	80002a4c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a40:	02090b63          	beqz	s2,80002a76 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a44:	08848493          	addi	s1,s1,136
    80002a48:	02d48a63          	beq	s1,a3,80002a7c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a4c:	449c                	lw	a5,8(s1)
    80002a4e:	fef059e3          	blez	a5,80002a40 <iget+0x38>
    80002a52:	4098                	lw	a4,0(s1)
    80002a54:	ff3716e3          	bne	a4,s3,80002a40 <iget+0x38>
    80002a58:	40d8                	lw	a4,4(s1)
    80002a5a:	ff4713e3          	bne	a4,s4,80002a40 <iget+0x38>
      ip->ref++;
    80002a5e:	2785                	addiw	a5,a5,1
    80002a60:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a62:	00018517          	auipc	a0,0x18
    80002a66:	d1650513          	addi	a0,a0,-746 # 8001a778 <itable>
    80002a6a:	00004097          	auipc	ra,0x4
    80002a6e:	a80080e7          	jalr	-1408(ra) # 800064ea <release>
      return ip;
    80002a72:	8926                	mv	s2,s1
    80002a74:	a03d                	j	80002aa2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a76:	f7f9                	bnez	a5,80002a44 <iget+0x3c>
      empty = ip;
    80002a78:	8926                	mv	s2,s1
    80002a7a:	b7e9                	j	80002a44 <iget+0x3c>
  if(empty == 0)
    80002a7c:	02090c63          	beqz	s2,80002ab4 <iget+0xac>
  ip->dev = dev;
    80002a80:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a84:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a88:	4785                	li	a5,1
    80002a8a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a8e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a92:	00018517          	auipc	a0,0x18
    80002a96:	ce650513          	addi	a0,a0,-794 # 8001a778 <itable>
    80002a9a:	00004097          	auipc	ra,0x4
    80002a9e:	a50080e7          	jalr	-1456(ra) # 800064ea <release>
}
    80002aa2:	854a                	mv	a0,s2
    80002aa4:	70a2                	ld	ra,40(sp)
    80002aa6:	7402                	ld	s0,32(sp)
    80002aa8:	64e2                	ld	s1,24(sp)
    80002aaa:	6942                	ld	s2,16(sp)
    80002aac:	69a2                	ld	s3,8(sp)
    80002aae:	6a02                	ld	s4,0(sp)
    80002ab0:	6145                	addi	sp,sp,48
    80002ab2:	8082                	ret
    panic("iget: no inodes");
    80002ab4:	00006517          	auipc	a0,0x6
    80002ab8:	98450513          	addi	a0,a0,-1660 # 80008438 <etext+0x438>
    80002abc:	00003097          	auipc	ra,0x3
    80002ac0:	400080e7          	jalr	1024(ra) # 80005ebc <panic>

0000000080002ac4 <fsinit>:
fsinit(int dev) {
    80002ac4:	7179                	addi	sp,sp,-48
    80002ac6:	f406                	sd	ra,40(sp)
    80002ac8:	f022                	sd	s0,32(sp)
    80002aca:	ec26                	sd	s1,24(sp)
    80002acc:	e84a                	sd	s2,16(sp)
    80002ace:	e44e                	sd	s3,8(sp)
    80002ad0:	1800                	addi	s0,sp,48
    80002ad2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ad4:	4585                	li	a1,1
    80002ad6:	00000097          	auipc	ra,0x0
    80002ada:	a68080e7          	jalr	-1432(ra) # 8000253e <bread>
    80002ade:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ae0:	00018997          	auipc	s3,0x18
    80002ae4:	c7898993          	addi	s3,s3,-904 # 8001a758 <sb>
    80002ae8:	02000613          	li	a2,32
    80002aec:	05850593          	addi	a1,a0,88
    80002af0:	854e                	mv	a0,s3
    80002af2:	ffffd097          	auipc	ra,0xffffd
    80002af6:	6e4080e7          	jalr	1764(ra) # 800001d6 <memmove>
  brelse(bp);
    80002afa:	8526                	mv	a0,s1
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	b72080e7          	jalr	-1166(ra) # 8000266e <brelse>
  if(sb.magic != FSMAGIC)
    80002b04:	0009a703          	lw	a4,0(s3)
    80002b08:	102037b7          	lui	a5,0x10203
    80002b0c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b10:	02f71263          	bne	a4,a5,80002b34 <fsinit+0x70>
  initlog(dev, &sb);
    80002b14:	00018597          	auipc	a1,0x18
    80002b18:	c4458593          	addi	a1,a1,-956 # 8001a758 <sb>
    80002b1c:	854a                	mv	a0,s2
    80002b1e:	00001097          	auipc	ra,0x1
    80002b22:	b54080e7          	jalr	-1196(ra) # 80003672 <initlog>
}
    80002b26:	70a2                	ld	ra,40(sp)
    80002b28:	7402                	ld	s0,32(sp)
    80002b2a:	64e2                	ld	s1,24(sp)
    80002b2c:	6942                	ld	s2,16(sp)
    80002b2e:	69a2                	ld	s3,8(sp)
    80002b30:	6145                	addi	sp,sp,48
    80002b32:	8082                	ret
    panic("invalid file system");
    80002b34:	00006517          	auipc	a0,0x6
    80002b38:	91450513          	addi	a0,a0,-1772 # 80008448 <etext+0x448>
    80002b3c:	00003097          	auipc	ra,0x3
    80002b40:	380080e7          	jalr	896(ra) # 80005ebc <panic>

0000000080002b44 <iinit>:
{
    80002b44:	7179                	addi	sp,sp,-48
    80002b46:	f406                	sd	ra,40(sp)
    80002b48:	f022                	sd	s0,32(sp)
    80002b4a:	ec26                	sd	s1,24(sp)
    80002b4c:	e84a                	sd	s2,16(sp)
    80002b4e:	e44e                	sd	s3,8(sp)
    80002b50:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b52:	00006597          	auipc	a1,0x6
    80002b56:	90e58593          	addi	a1,a1,-1778 # 80008460 <etext+0x460>
    80002b5a:	00018517          	auipc	a0,0x18
    80002b5e:	c1e50513          	addi	a0,a0,-994 # 8001a778 <itable>
    80002b62:	00004097          	auipc	ra,0x4
    80002b66:	844080e7          	jalr	-1980(ra) # 800063a6 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b6a:	00018497          	auipc	s1,0x18
    80002b6e:	c3648493          	addi	s1,s1,-970 # 8001a7a0 <itable+0x28>
    80002b72:	00019997          	auipc	s3,0x19
    80002b76:	6be98993          	addi	s3,s3,1726 # 8001c230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b7a:	00006917          	auipc	s2,0x6
    80002b7e:	8ee90913          	addi	s2,s2,-1810 # 80008468 <etext+0x468>
    80002b82:	85ca                	mv	a1,s2
    80002b84:	8526                	mv	a0,s1
    80002b86:	00001097          	auipc	ra,0x1
    80002b8a:	e40080e7          	jalr	-448(ra) # 800039c6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b8e:	08848493          	addi	s1,s1,136
    80002b92:	ff3498e3          	bne	s1,s3,80002b82 <iinit+0x3e>
}
    80002b96:	70a2                	ld	ra,40(sp)
    80002b98:	7402                	ld	s0,32(sp)
    80002b9a:	64e2                	ld	s1,24(sp)
    80002b9c:	6942                	ld	s2,16(sp)
    80002b9e:	69a2                	ld	s3,8(sp)
    80002ba0:	6145                	addi	sp,sp,48
    80002ba2:	8082                	ret

0000000080002ba4 <ialloc>:
{
    80002ba4:	7139                	addi	sp,sp,-64
    80002ba6:	fc06                	sd	ra,56(sp)
    80002ba8:	f822                	sd	s0,48(sp)
    80002baa:	f426                	sd	s1,40(sp)
    80002bac:	f04a                	sd	s2,32(sp)
    80002bae:	ec4e                	sd	s3,24(sp)
    80002bb0:	e852                	sd	s4,16(sp)
    80002bb2:	e456                	sd	s5,8(sp)
    80002bb4:	e05a                	sd	s6,0(sp)
    80002bb6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bb8:	00018717          	auipc	a4,0x18
    80002bbc:	bac72703          	lw	a4,-1108(a4) # 8001a764 <sb+0xc>
    80002bc0:	4785                	li	a5,1
    80002bc2:	04e7f863          	bgeu	a5,a4,80002c12 <ialloc+0x6e>
    80002bc6:	8aaa                	mv	s5,a0
    80002bc8:	8b2e                	mv	s6,a1
    80002bca:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bcc:	00018a17          	auipc	s4,0x18
    80002bd0:	b8ca0a13          	addi	s4,s4,-1140 # 8001a758 <sb>
    80002bd4:	00495593          	srli	a1,s2,0x4
    80002bd8:	018a2783          	lw	a5,24(s4)
    80002bdc:	9dbd                	addw	a1,a1,a5
    80002bde:	8556                	mv	a0,s5
    80002be0:	00000097          	auipc	ra,0x0
    80002be4:	95e080e7          	jalr	-1698(ra) # 8000253e <bread>
    80002be8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bea:	05850993          	addi	s3,a0,88
    80002bee:	00f97793          	andi	a5,s2,15
    80002bf2:	079a                	slli	a5,a5,0x6
    80002bf4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bf6:	00099783          	lh	a5,0(s3)
    80002bfa:	c785                	beqz	a5,80002c22 <ialloc+0x7e>
    brelse(bp);
    80002bfc:	00000097          	auipc	ra,0x0
    80002c00:	a72080e7          	jalr	-1422(ra) # 8000266e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c04:	0905                	addi	s2,s2,1
    80002c06:	00ca2703          	lw	a4,12(s4)
    80002c0a:	0009079b          	sext.w	a5,s2
    80002c0e:	fce7e3e3          	bltu	a5,a4,80002bd4 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002c12:	00006517          	auipc	a0,0x6
    80002c16:	85e50513          	addi	a0,a0,-1954 # 80008470 <etext+0x470>
    80002c1a:	00003097          	auipc	ra,0x3
    80002c1e:	2a2080e7          	jalr	674(ra) # 80005ebc <panic>
      memset(dip, 0, sizeof(*dip));
    80002c22:	04000613          	li	a2,64
    80002c26:	4581                	li	a1,0
    80002c28:	854e                	mv	a0,s3
    80002c2a:	ffffd097          	auipc	ra,0xffffd
    80002c2e:	550080e7          	jalr	1360(ra) # 8000017a <memset>
      dip->type = type;
    80002c32:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c36:	8526                	mv	a0,s1
    80002c38:	00001097          	auipc	ra,0x1
    80002c3c:	caa080e7          	jalr	-854(ra) # 800038e2 <log_write>
      brelse(bp);
    80002c40:	8526                	mv	a0,s1
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	a2c080e7          	jalr	-1492(ra) # 8000266e <brelse>
      return iget(dev, inum);
    80002c4a:	0009059b          	sext.w	a1,s2
    80002c4e:	8556                	mv	a0,s5
    80002c50:	00000097          	auipc	ra,0x0
    80002c54:	db8080e7          	jalr	-584(ra) # 80002a08 <iget>
}
    80002c58:	70e2                	ld	ra,56(sp)
    80002c5a:	7442                	ld	s0,48(sp)
    80002c5c:	74a2                	ld	s1,40(sp)
    80002c5e:	7902                	ld	s2,32(sp)
    80002c60:	69e2                	ld	s3,24(sp)
    80002c62:	6a42                	ld	s4,16(sp)
    80002c64:	6aa2                	ld	s5,8(sp)
    80002c66:	6b02                	ld	s6,0(sp)
    80002c68:	6121                	addi	sp,sp,64
    80002c6a:	8082                	ret

0000000080002c6c <iupdate>:
{
    80002c6c:	1101                	addi	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	e04a                	sd	s2,0(sp)
    80002c76:	1000                	addi	s0,sp,32
    80002c78:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c7a:	415c                	lw	a5,4(a0)
    80002c7c:	0047d79b          	srliw	a5,a5,0x4
    80002c80:	00018597          	auipc	a1,0x18
    80002c84:	af05a583          	lw	a1,-1296(a1) # 8001a770 <sb+0x18>
    80002c88:	9dbd                	addw	a1,a1,a5
    80002c8a:	4108                	lw	a0,0(a0)
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	8b2080e7          	jalr	-1870(ra) # 8000253e <bread>
    80002c94:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c96:	05850793          	addi	a5,a0,88
    80002c9a:	40d8                	lw	a4,4(s1)
    80002c9c:	8b3d                	andi	a4,a4,15
    80002c9e:	071a                	slli	a4,a4,0x6
    80002ca0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ca2:	04449703          	lh	a4,68(s1)
    80002ca6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002caa:	04649703          	lh	a4,70(s1)
    80002cae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002cb2:	04849703          	lh	a4,72(s1)
    80002cb6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cba:	04a49703          	lh	a4,74(s1)
    80002cbe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cc2:	44f8                	lw	a4,76(s1)
    80002cc4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cc6:	03400613          	li	a2,52
    80002cca:	05048593          	addi	a1,s1,80
    80002cce:	00c78513          	addi	a0,a5,12
    80002cd2:	ffffd097          	auipc	ra,0xffffd
    80002cd6:	504080e7          	jalr	1284(ra) # 800001d6 <memmove>
  log_write(bp);
    80002cda:	854a                	mv	a0,s2
    80002cdc:	00001097          	auipc	ra,0x1
    80002ce0:	c06080e7          	jalr	-1018(ra) # 800038e2 <log_write>
  brelse(bp);
    80002ce4:	854a                	mv	a0,s2
    80002ce6:	00000097          	auipc	ra,0x0
    80002cea:	988080e7          	jalr	-1656(ra) # 8000266e <brelse>
}
    80002cee:	60e2                	ld	ra,24(sp)
    80002cf0:	6442                	ld	s0,16(sp)
    80002cf2:	64a2                	ld	s1,8(sp)
    80002cf4:	6902                	ld	s2,0(sp)
    80002cf6:	6105                	addi	sp,sp,32
    80002cf8:	8082                	ret

0000000080002cfa <idup>:
{
    80002cfa:	1101                	addi	sp,sp,-32
    80002cfc:	ec06                	sd	ra,24(sp)
    80002cfe:	e822                	sd	s0,16(sp)
    80002d00:	e426                	sd	s1,8(sp)
    80002d02:	1000                	addi	s0,sp,32
    80002d04:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d06:	00018517          	auipc	a0,0x18
    80002d0a:	a7250513          	addi	a0,a0,-1422 # 8001a778 <itable>
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	728080e7          	jalr	1832(ra) # 80006436 <acquire>
  ip->ref++;
    80002d16:	449c                	lw	a5,8(s1)
    80002d18:	2785                	addiw	a5,a5,1
    80002d1a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d1c:	00018517          	auipc	a0,0x18
    80002d20:	a5c50513          	addi	a0,a0,-1444 # 8001a778 <itable>
    80002d24:	00003097          	auipc	ra,0x3
    80002d28:	7c6080e7          	jalr	1990(ra) # 800064ea <release>
}
    80002d2c:	8526                	mv	a0,s1
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6105                	addi	sp,sp,32
    80002d36:	8082                	ret

0000000080002d38 <ilock>:
{
    80002d38:	1101                	addi	sp,sp,-32
    80002d3a:	ec06                	sd	ra,24(sp)
    80002d3c:	e822                	sd	s0,16(sp)
    80002d3e:	e426                	sd	s1,8(sp)
    80002d40:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d42:	c10d                	beqz	a0,80002d64 <ilock+0x2c>
    80002d44:	84aa                	mv	s1,a0
    80002d46:	451c                	lw	a5,8(a0)
    80002d48:	00f05e63          	blez	a5,80002d64 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d4c:	0541                	addi	a0,a0,16
    80002d4e:	00001097          	auipc	ra,0x1
    80002d52:	cb2080e7          	jalr	-846(ra) # 80003a00 <acquiresleep>
  if(ip->valid == 0){
    80002d56:	40bc                	lw	a5,64(s1)
    80002d58:	cf99                	beqz	a5,80002d76 <ilock+0x3e>
}
    80002d5a:	60e2                	ld	ra,24(sp)
    80002d5c:	6442                	ld	s0,16(sp)
    80002d5e:	64a2                	ld	s1,8(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret
    80002d64:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d66:	00005517          	auipc	a0,0x5
    80002d6a:	72250513          	addi	a0,a0,1826 # 80008488 <etext+0x488>
    80002d6e:	00003097          	auipc	ra,0x3
    80002d72:	14e080e7          	jalr	334(ra) # 80005ebc <panic>
    80002d76:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d78:	40dc                	lw	a5,4(s1)
    80002d7a:	0047d79b          	srliw	a5,a5,0x4
    80002d7e:	00018597          	auipc	a1,0x18
    80002d82:	9f25a583          	lw	a1,-1550(a1) # 8001a770 <sb+0x18>
    80002d86:	9dbd                	addw	a1,a1,a5
    80002d88:	4088                	lw	a0,0(s1)
    80002d8a:	fffff097          	auipc	ra,0xfffff
    80002d8e:	7b4080e7          	jalr	1972(ra) # 8000253e <bread>
    80002d92:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d94:	05850593          	addi	a1,a0,88
    80002d98:	40dc                	lw	a5,4(s1)
    80002d9a:	8bbd                	andi	a5,a5,15
    80002d9c:	079a                	slli	a5,a5,0x6
    80002d9e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002da0:	00059783          	lh	a5,0(a1)
    80002da4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002da8:	00259783          	lh	a5,2(a1)
    80002dac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002db0:	00459783          	lh	a5,4(a1)
    80002db4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002db8:	00659783          	lh	a5,6(a1)
    80002dbc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002dc0:	459c                	lw	a5,8(a1)
    80002dc2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002dc4:	03400613          	li	a2,52
    80002dc8:	05b1                	addi	a1,a1,12
    80002dca:	05048513          	addi	a0,s1,80
    80002dce:	ffffd097          	auipc	ra,0xffffd
    80002dd2:	408080e7          	jalr	1032(ra) # 800001d6 <memmove>
    brelse(bp);
    80002dd6:	854a                	mv	a0,s2
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	896080e7          	jalr	-1898(ra) # 8000266e <brelse>
    ip->valid = 1;
    80002de0:	4785                	li	a5,1
    80002de2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002de4:	04449783          	lh	a5,68(s1)
    80002de8:	c399                	beqz	a5,80002dee <ilock+0xb6>
    80002dea:	6902                	ld	s2,0(sp)
    80002dec:	b7bd                	j	80002d5a <ilock+0x22>
      panic("ilock: no type");
    80002dee:	00005517          	auipc	a0,0x5
    80002df2:	6a250513          	addi	a0,a0,1698 # 80008490 <etext+0x490>
    80002df6:	00003097          	auipc	ra,0x3
    80002dfa:	0c6080e7          	jalr	198(ra) # 80005ebc <panic>

0000000080002dfe <iunlock>:
{
    80002dfe:	1101                	addi	sp,sp,-32
    80002e00:	ec06                	sd	ra,24(sp)
    80002e02:	e822                	sd	s0,16(sp)
    80002e04:	e426                	sd	s1,8(sp)
    80002e06:	e04a                	sd	s2,0(sp)
    80002e08:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e0a:	c905                	beqz	a0,80002e3a <iunlock+0x3c>
    80002e0c:	84aa                	mv	s1,a0
    80002e0e:	01050913          	addi	s2,a0,16
    80002e12:	854a                	mv	a0,s2
    80002e14:	00001097          	auipc	ra,0x1
    80002e18:	c86080e7          	jalr	-890(ra) # 80003a9a <holdingsleep>
    80002e1c:	cd19                	beqz	a0,80002e3a <iunlock+0x3c>
    80002e1e:	449c                	lw	a5,8(s1)
    80002e20:	00f05d63          	blez	a5,80002e3a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e24:	854a                	mv	a0,s2
    80002e26:	00001097          	auipc	ra,0x1
    80002e2a:	c30080e7          	jalr	-976(ra) # 80003a56 <releasesleep>
}
    80002e2e:	60e2                	ld	ra,24(sp)
    80002e30:	6442                	ld	s0,16(sp)
    80002e32:	64a2                	ld	s1,8(sp)
    80002e34:	6902                	ld	s2,0(sp)
    80002e36:	6105                	addi	sp,sp,32
    80002e38:	8082                	ret
    panic("iunlock");
    80002e3a:	00005517          	auipc	a0,0x5
    80002e3e:	66650513          	addi	a0,a0,1638 # 800084a0 <etext+0x4a0>
    80002e42:	00003097          	auipc	ra,0x3
    80002e46:	07a080e7          	jalr	122(ra) # 80005ebc <panic>

0000000080002e4a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e4a:	7179                	addi	sp,sp,-48
    80002e4c:	f406                	sd	ra,40(sp)
    80002e4e:	f022                	sd	s0,32(sp)
    80002e50:	ec26                	sd	s1,24(sp)
    80002e52:	e84a                	sd	s2,16(sp)
    80002e54:	e44e                	sd	s3,8(sp)
    80002e56:	1800                	addi	s0,sp,48
    80002e58:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e5a:	05050493          	addi	s1,a0,80
    80002e5e:	08050913          	addi	s2,a0,128
    80002e62:	a021                	j	80002e6a <itrunc+0x20>
    80002e64:	0491                	addi	s1,s1,4
    80002e66:	01248d63          	beq	s1,s2,80002e80 <itrunc+0x36>
    if(ip->addrs[i]){
    80002e6a:	408c                	lw	a1,0(s1)
    80002e6c:	dde5                	beqz	a1,80002e64 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e6e:	0009a503          	lw	a0,0(s3)
    80002e72:	00000097          	auipc	ra,0x0
    80002e76:	910080e7          	jalr	-1776(ra) # 80002782 <bfree>
      ip->addrs[i] = 0;
    80002e7a:	0004a023          	sw	zero,0(s1)
    80002e7e:	b7dd                	j	80002e64 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e80:	0809a583          	lw	a1,128(s3)
    80002e84:	ed99                	bnez	a1,80002ea2 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e86:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e8a:	854e                	mv	a0,s3
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	de0080e7          	jalr	-544(ra) # 80002c6c <iupdate>
}
    80002e94:	70a2                	ld	ra,40(sp)
    80002e96:	7402                	ld	s0,32(sp)
    80002e98:	64e2                	ld	s1,24(sp)
    80002e9a:	6942                	ld	s2,16(sp)
    80002e9c:	69a2                	ld	s3,8(sp)
    80002e9e:	6145                	addi	sp,sp,48
    80002ea0:	8082                	ret
    80002ea2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ea4:	0009a503          	lw	a0,0(s3)
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	696080e7          	jalr	1686(ra) # 8000253e <bread>
    80002eb0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002eb2:	05850493          	addi	s1,a0,88
    80002eb6:	45850913          	addi	s2,a0,1112
    80002eba:	a021                	j	80002ec2 <itrunc+0x78>
    80002ebc:	0491                	addi	s1,s1,4
    80002ebe:	01248b63          	beq	s1,s2,80002ed4 <itrunc+0x8a>
      if(a[j])
    80002ec2:	408c                	lw	a1,0(s1)
    80002ec4:	dde5                	beqz	a1,80002ebc <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002ec6:	0009a503          	lw	a0,0(s3)
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	8b8080e7          	jalr	-1864(ra) # 80002782 <bfree>
    80002ed2:	b7ed                	j	80002ebc <itrunc+0x72>
    brelse(bp);
    80002ed4:	8552                	mv	a0,s4
    80002ed6:	fffff097          	auipc	ra,0xfffff
    80002eda:	798080e7          	jalr	1944(ra) # 8000266e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ede:	0809a583          	lw	a1,128(s3)
    80002ee2:	0009a503          	lw	a0,0(s3)
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	89c080e7          	jalr	-1892(ra) # 80002782 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002eee:	0809a023          	sw	zero,128(s3)
    80002ef2:	6a02                	ld	s4,0(sp)
    80002ef4:	bf49                	j	80002e86 <itrunc+0x3c>

0000000080002ef6 <iput>:
{
    80002ef6:	1101                	addi	sp,sp,-32
    80002ef8:	ec06                	sd	ra,24(sp)
    80002efa:	e822                	sd	s0,16(sp)
    80002efc:	e426                	sd	s1,8(sp)
    80002efe:	1000                	addi	s0,sp,32
    80002f00:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f02:	00018517          	auipc	a0,0x18
    80002f06:	87650513          	addi	a0,a0,-1930 # 8001a778 <itable>
    80002f0a:	00003097          	auipc	ra,0x3
    80002f0e:	52c080e7          	jalr	1324(ra) # 80006436 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f12:	4498                	lw	a4,8(s1)
    80002f14:	4785                	li	a5,1
    80002f16:	02f70263          	beq	a4,a5,80002f3a <iput+0x44>
  ip->ref--;
    80002f1a:	449c                	lw	a5,8(s1)
    80002f1c:	37fd                	addiw	a5,a5,-1
    80002f1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f20:	00018517          	auipc	a0,0x18
    80002f24:	85850513          	addi	a0,a0,-1960 # 8001a778 <itable>
    80002f28:	00003097          	auipc	ra,0x3
    80002f2c:	5c2080e7          	jalr	1474(ra) # 800064ea <release>
}
    80002f30:	60e2                	ld	ra,24(sp)
    80002f32:	6442                	ld	s0,16(sp)
    80002f34:	64a2                	ld	s1,8(sp)
    80002f36:	6105                	addi	sp,sp,32
    80002f38:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f3a:	40bc                	lw	a5,64(s1)
    80002f3c:	dff9                	beqz	a5,80002f1a <iput+0x24>
    80002f3e:	04a49783          	lh	a5,74(s1)
    80002f42:	ffe1                	bnez	a5,80002f1a <iput+0x24>
    80002f44:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f46:	01048913          	addi	s2,s1,16
    80002f4a:	854a                	mv	a0,s2
    80002f4c:	00001097          	auipc	ra,0x1
    80002f50:	ab4080e7          	jalr	-1356(ra) # 80003a00 <acquiresleep>
    release(&itable.lock);
    80002f54:	00018517          	auipc	a0,0x18
    80002f58:	82450513          	addi	a0,a0,-2012 # 8001a778 <itable>
    80002f5c:	00003097          	auipc	ra,0x3
    80002f60:	58e080e7          	jalr	1422(ra) # 800064ea <release>
    itrunc(ip);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	ee4080e7          	jalr	-284(ra) # 80002e4a <itrunc>
    ip->type = 0;
    80002f6e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f72:	8526                	mv	a0,s1
    80002f74:	00000097          	auipc	ra,0x0
    80002f78:	cf8080e7          	jalr	-776(ra) # 80002c6c <iupdate>
    ip->valid = 0;
    80002f7c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f80:	854a                	mv	a0,s2
    80002f82:	00001097          	auipc	ra,0x1
    80002f86:	ad4080e7          	jalr	-1324(ra) # 80003a56 <releasesleep>
    acquire(&itable.lock);
    80002f8a:	00017517          	auipc	a0,0x17
    80002f8e:	7ee50513          	addi	a0,a0,2030 # 8001a778 <itable>
    80002f92:	00003097          	auipc	ra,0x3
    80002f96:	4a4080e7          	jalr	1188(ra) # 80006436 <acquire>
    80002f9a:	6902                	ld	s2,0(sp)
    80002f9c:	bfbd                	j	80002f1a <iput+0x24>

0000000080002f9e <iunlockput>:
{
    80002f9e:	1101                	addi	sp,sp,-32
    80002fa0:	ec06                	sd	ra,24(sp)
    80002fa2:	e822                	sd	s0,16(sp)
    80002fa4:	e426                	sd	s1,8(sp)
    80002fa6:	1000                	addi	s0,sp,32
    80002fa8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002faa:	00000097          	auipc	ra,0x0
    80002fae:	e54080e7          	jalr	-428(ra) # 80002dfe <iunlock>
  iput(ip);
    80002fb2:	8526                	mv	a0,s1
    80002fb4:	00000097          	auipc	ra,0x0
    80002fb8:	f42080e7          	jalr	-190(ra) # 80002ef6 <iput>
}
    80002fbc:	60e2                	ld	ra,24(sp)
    80002fbe:	6442                	ld	s0,16(sp)
    80002fc0:	64a2                	ld	s1,8(sp)
    80002fc2:	6105                	addi	sp,sp,32
    80002fc4:	8082                	ret

0000000080002fc6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fc6:	1141                	addi	sp,sp,-16
    80002fc8:	e422                	sd	s0,8(sp)
    80002fca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fcc:	411c                	lw	a5,0(a0)
    80002fce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fd0:	415c                	lw	a5,4(a0)
    80002fd2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fd4:	04451783          	lh	a5,68(a0)
    80002fd8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fdc:	04a51783          	lh	a5,74(a0)
    80002fe0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fe4:	04c56783          	lwu	a5,76(a0)
    80002fe8:	e99c                	sd	a5,16(a1)
}
    80002fea:	6422                	ld	s0,8(sp)
    80002fec:	0141                	addi	sp,sp,16
    80002fee:	8082                	ret

0000000080002ff0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ff0:	457c                	lw	a5,76(a0)
    80002ff2:	0ed7ef63          	bltu	a5,a3,800030f0 <readi+0x100>
{
    80002ff6:	7159                	addi	sp,sp,-112
    80002ff8:	f486                	sd	ra,104(sp)
    80002ffa:	f0a2                	sd	s0,96(sp)
    80002ffc:	eca6                	sd	s1,88(sp)
    80002ffe:	fc56                	sd	s5,56(sp)
    80003000:	f85a                	sd	s6,48(sp)
    80003002:	f45e                	sd	s7,40(sp)
    80003004:	f062                	sd	s8,32(sp)
    80003006:	1880                	addi	s0,sp,112
    80003008:	8baa                	mv	s7,a0
    8000300a:	8c2e                	mv	s8,a1
    8000300c:	8ab2                	mv	s5,a2
    8000300e:	84b6                	mv	s1,a3
    80003010:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003012:	9f35                	addw	a4,a4,a3
    return 0;
    80003014:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003016:	0ad76c63          	bltu	a4,a3,800030ce <readi+0xde>
    8000301a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000301c:	00e7f463          	bgeu	a5,a4,80003024 <readi+0x34>
    n = ip->size - off;
    80003020:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003024:	0c0b0463          	beqz	s6,800030ec <readi+0xfc>
    80003028:	e8ca                	sd	s2,80(sp)
    8000302a:	e0d2                	sd	s4,64(sp)
    8000302c:	ec66                	sd	s9,24(sp)
    8000302e:	e86a                	sd	s10,16(sp)
    80003030:	e46e                	sd	s11,8(sp)
    80003032:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003034:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003038:	5cfd                	li	s9,-1
    8000303a:	a82d                	j	80003074 <readi+0x84>
    8000303c:	020a1d93          	slli	s11,s4,0x20
    80003040:	020ddd93          	srli	s11,s11,0x20
    80003044:	05890613          	addi	a2,s2,88
    80003048:	86ee                	mv	a3,s11
    8000304a:	963a                	add	a2,a2,a4
    8000304c:	85d6                	mv	a1,s5
    8000304e:	8562                	mv	a0,s8
    80003050:	fffff097          	auipc	ra,0xfffff
    80003054:	a24080e7          	jalr	-1500(ra) # 80001a74 <either_copyout>
    80003058:	05950d63          	beq	a0,s9,800030b2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000305c:	854a                	mv	a0,s2
    8000305e:	fffff097          	auipc	ra,0xfffff
    80003062:	610080e7          	jalr	1552(ra) # 8000266e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003066:	013a09bb          	addw	s3,s4,s3
    8000306a:	009a04bb          	addw	s1,s4,s1
    8000306e:	9aee                	add	s5,s5,s11
    80003070:	0769f863          	bgeu	s3,s6,800030e0 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003074:	000ba903          	lw	s2,0(s7)
    80003078:	00a4d59b          	srliw	a1,s1,0xa
    8000307c:	855e                	mv	a0,s7
    8000307e:	00000097          	auipc	ra,0x0
    80003082:	8ae080e7          	jalr	-1874(ra) # 8000292c <bmap>
    80003086:	0005059b          	sext.w	a1,a0
    8000308a:	854a                	mv	a0,s2
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	4b2080e7          	jalr	1202(ra) # 8000253e <bread>
    80003094:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003096:	3ff4f713          	andi	a4,s1,1023
    8000309a:	40ed07bb          	subw	a5,s10,a4
    8000309e:	413b06bb          	subw	a3,s6,s3
    800030a2:	8a3e                	mv	s4,a5
    800030a4:	2781                	sext.w	a5,a5
    800030a6:	0006861b          	sext.w	a2,a3
    800030aa:	f8f679e3          	bgeu	a2,a5,8000303c <readi+0x4c>
    800030ae:	8a36                	mv	s4,a3
    800030b0:	b771                	j	8000303c <readi+0x4c>
      brelse(bp);
    800030b2:	854a                	mv	a0,s2
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	5ba080e7          	jalr	1466(ra) # 8000266e <brelse>
      tot = -1;
    800030bc:	59fd                	li	s3,-1
      break;
    800030be:	6946                	ld	s2,80(sp)
    800030c0:	6a06                	ld	s4,64(sp)
    800030c2:	6ce2                	ld	s9,24(sp)
    800030c4:	6d42                	ld	s10,16(sp)
    800030c6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030c8:	0009851b          	sext.w	a0,s3
    800030cc:	69a6                	ld	s3,72(sp)
}
    800030ce:	70a6                	ld	ra,104(sp)
    800030d0:	7406                	ld	s0,96(sp)
    800030d2:	64e6                	ld	s1,88(sp)
    800030d4:	7ae2                	ld	s5,56(sp)
    800030d6:	7b42                	ld	s6,48(sp)
    800030d8:	7ba2                	ld	s7,40(sp)
    800030da:	7c02                	ld	s8,32(sp)
    800030dc:	6165                	addi	sp,sp,112
    800030de:	8082                	ret
    800030e0:	6946                	ld	s2,80(sp)
    800030e2:	6a06                	ld	s4,64(sp)
    800030e4:	6ce2                	ld	s9,24(sp)
    800030e6:	6d42                	ld	s10,16(sp)
    800030e8:	6da2                	ld	s11,8(sp)
    800030ea:	bff9                	j	800030c8 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ec:	89da                	mv	s3,s6
    800030ee:	bfe9                	j	800030c8 <readi+0xd8>
    return 0;
    800030f0:	4501                	li	a0,0
}
    800030f2:	8082                	ret

00000000800030f4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030f4:	457c                	lw	a5,76(a0)
    800030f6:	10d7ee63          	bltu	a5,a3,80003212 <writei+0x11e>
{
    800030fa:	7159                	addi	sp,sp,-112
    800030fc:	f486                	sd	ra,104(sp)
    800030fe:	f0a2                	sd	s0,96(sp)
    80003100:	e8ca                	sd	s2,80(sp)
    80003102:	fc56                	sd	s5,56(sp)
    80003104:	f85a                	sd	s6,48(sp)
    80003106:	f45e                	sd	s7,40(sp)
    80003108:	f062                	sd	s8,32(sp)
    8000310a:	1880                	addi	s0,sp,112
    8000310c:	8b2a                	mv	s6,a0
    8000310e:	8c2e                	mv	s8,a1
    80003110:	8ab2                	mv	s5,a2
    80003112:	8936                	mv	s2,a3
    80003114:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003116:	00e687bb          	addw	a5,a3,a4
    8000311a:	0ed7ee63          	bltu	a5,a3,80003216 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000311e:	00043737          	lui	a4,0x43
    80003122:	0ef76c63          	bltu	a4,a5,8000321a <writei+0x126>
    80003126:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003128:	0c0b8d63          	beqz	s7,80003202 <writei+0x10e>
    8000312c:	eca6                	sd	s1,88(sp)
    8000312e:	e4ce                	sd	s3,72(sp)
    80003130:	ec66                	sd	s9,24(sp)
    80003132:	e86a                	sd	s10,16(sp)
    80003134:	e46e                	sd	s11,8(sp)
    80003136:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003138:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000313c:	5cfd                	li	s9,-1
    8000313e:	a091                	j	80003182 <writei+0x8e>
    80003140:	02099d93          	slli	s11,s3,0x20
    80003144:	020ddd93          	srli	s11,s11,0x20
    80003148:	05848513          	addi	a0,s1,88
    8000314c:	86ee                	mv	a3,s11
    8000314e:	8656                	mv	a2,s5
    80003150:	85e2                	mv	a1,s8
    80003152:	953a                	add	a0,a0,a4
    80003154:	fffff097          	auipc	ra,0xfffff
    80003158:	976080e7          	jalr	-1674(ra) # 80001aca <either_copyin>
    8000315c:	07950263          	beq	a0,s9,800031c0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003160:	8526                	mv	a0,s1
    80003162:	00000097          	auipc	ra,0x0
    80003166:	780080e7          	jalr	1920(ra) # 800038e2 <log_write>
    brelse(bp);
    8000316a:	8526                	mv	a0,s1
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	502080e7          	jalr	1282(ra) # 8000266e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003174:	01498a3b          	addw	s4,s3,s4
    80003178:	0129893b          	addw	s2,s3,s2
    8000317c:	9aee                	add	s5,s5,s11
    8000317e:	057a7663          	bgeu	s4,s7,800031ca <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003182:	000b2483          	lw	s1,0(s6)
    80003186:	00a9559b          	srliw	a1,s2,0xa
    8000318a:	855a                	mv	a0,s6
    8000318c:	fffff097          	auipc	ra,0xfffff
    80003190:	7a0080e7          	jalr	1952(ra) # 8000292c <bmap>
    80003194:	0005059b          	sext.w	a1,a0
    80003198:	8526                	mv	a0,s1
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	3a4080e7          	jalr	932(ra) # 8000253e <bread>
    800031a2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031a4:	3ff97713          	andi	a4,s2,1023
    800031a8:	40ed07bb          	subw	a5,s10,a4
    800031ac:	414b86bb          	subw	a3,s7,s4
    800031b0:	89be                	mv	s3,a5
    800031b2:	2781                	sext.w	a5,a5
    800031b4:	0006861b          	sext.w	a2,a3
    800031b8:	f8f674e3          	bgeu	a2,a5,80003140 <writei+0x4c>
    800031bc:	89b6                	mv	s3,a3
    800031be:	b749                	j	80003140 <writei+0x4c>
      brelse(bp);
    800031c0:	8526                	mv	a0,s1
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	4ac080e7          	jalr	1196(ra) # 8000266e <brelse>
  }

  if(off > ip->size)
    800031ca:	04cb2783          	lw	a5,76(s6)
    800031ce:	0327fc63          	bgeu	a5,s2,80003206 <writei+0x112>
    ip->size = off;
    800031d2:	052b2623          	sw	s2,76(s6)
    800031d6:	64e6                	ld	s1,88(sp)
    800031d8:	69a6                	ld	s3,72(sp)
    800031da:	6ce2                	ld	s9,24(sp)
    800031dc:	6d42                	ld	s10,16(sp)
    800031de:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031e0:	855a                	mv	a0,s6
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	a8a080e7          	jalr	-1398(ra) # 80002c6c <iupdate>

  return tot;
    800031ea:	000a051b          	sext.w	a0,s4
    800031ee:	6a06                	ld	s4,64(sp)
}
    800031f0:	70a6                	ld	ra,104(sp)
    800031f2:	7406                	ld	s0,96(sp)
    800031f4:	6946                	ld	s2,80(sp)
    800031f6:	7ae2                	ld	s5,56(sp)
    800031f8:	7b42                	ld	s6,48(sp)
    800031fa:	7ba2                	ld	s7,40(sp)
    800031fc:	7c02                	ld	s8,32(sp)
    800031fe:	6165                	addi	sp,sp,112
    80003200:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003202:	8a5e                	mv	s4,s7
    80003204:	bff1                	j	800031e0 <writei+0xec>
    80003206:	64e6                	ld	s1,88(sp)
    80003208:	69a6                	ld	s3,72(sp)
    8000320a:	6ce2                	ld	s9,24(sp)
    8000320c:	6d42                	ld	s10,16(sp)
    8000320e:	6da2                	ld	s11,8(sp)
    80003210:	bfc1                	j	800031e0 <writei+0xec>
    return -1;
    80003212:	557d                	li	a0,-1
}
    80003214:	8082                	ret
    return -1;
    80003216:	557d                	li	a0,-1
    80003218:	bfe1                	j	800031f0 <writei+0xfc>
    return -1;
    8000321a:	557d                	li	a0,-1
    8000321c:	bfd1                	j	800031f0 <writei+0xfc>

000000008000321e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000321e:	1141                	addi	sp,sp,-16
    80003220:	e406                	sd	ra,8(sp)
    80003222:	e022                	sd	s0,0(sp)
    80003224:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003226:	4639                	li	a2,14
    80003228:	ffffd097          	auipc	ra,0xffffd
    8000322c:	022080e7          	jalr	34(ra) # 8000024a <strncmp>
}
    80003230:	60a2                	ld	ra,8(sp)
    80003232:	6402                	ld	s0,0(sp)
    80003234:	0141                	addi	sp,sp,16
    80003236:	8082                	ret

0000000080003238 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003238:	7139                	addi	sp,sp,-64
    8000323a:	fc06                	sd	ra,56(sp)
    8000323c:	f822                	sd	s0,48(sp)
    8000323e:	f426                	sd	s1,40(sp)
    80003240:	f04a                	sd	s2,32(sp)
    80003242:	ec4e                	sd	s3,24(sp)
    80003244:	e852                	sd	s4,16(sp)
    80003246:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003248:	04451703          	lh	a4,68(a0)
    8000324c:	4785                	li	a5,1
    8000324e:	00f71a63          	bne	a4,a5,80003262 <dirlookup+0x2a>
    80003252:	892a                	mv	s2,a0
    80003254:	89ae                	mv	s3,a1
    80003256:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003258:	457c                	lw	a5,76(a0)
    8000325a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000325c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325e:	e79d                	bnez	a5,8000328c <dirlookup+0x54>
    80003260:	a8a5                	j	800032d8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003262:	00005517          	auipc	a0,0x5
    80003266:	24650513          	addi	a0,a0,582 # 800084a8 <etext+0x4a8>
    8000326a:	00003097          	auipc	ra,0x3
    8000326e:	c52080e7          	jalr	-942(ra) # 80005ebc <panic>
      panic("dirlookup read");
    80003272:	00005517          	auipc	a0,0x5
    80003276:	24e50513          	addi	a0,a0,590 # 800084c0 <etext+0x4c0>
    8000327a:	00003097          	auipc	ra,0x3
    8000327e:	c42080e7          	jalr	-958(ra) # 80005ebc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003282:	24c1                	addiw	s1,s1,16
    80003284:	04c92783          	lw	a5,76(s2)
    80003288:	04f4f763          	bgeu	s1,a5,800032d6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000328c:	4741                	li	a4,16
    8000328e:	86a6                	mv	a3,s1
    80003290:	fc040613          	addi	a2,s0,-64
    80003294:	4581                	li	a1,0
    80003296:	854a                	mv	a0,s2
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	d58080e7          	jalr	-680(ra) # 80002ff0 <readi>
    800032a0:	47c1                	li	a5,16
    800032a2:	fcf518e3          	bne	a0,a5,80003272 <dirlookup+0x3a>
    if(de.inum == 0)
    800032a6:	fc045783          	lhu	a5,-64(s0)
    800032aa:	dfe1                	beqz	a5,80003282 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032ac:	fc240593          	addi	a1,s0,-62
    800032b0:	854e                	mv	a0,s3
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	f6c080e7          	jalr	-148(ra) # 8000321e <namecmp>
    800032ba:	f561                	bnez	a0,80003282 <dirlookup+0x4a>
      if(poff)
    800032bc:	000a0463          	beqz	s4,800032c4 <dirlookup+0x8c>
        *poff = off;
    800032c0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032c4:	fc045583          	lhu	a1,-64(s0)
    800032c8:	00092503          	lw	a0,0(s2)
    800032cc:	fffff097          	auipc	ra,0xfffff
    800032d0:	73c080e7          	jalr	1852(ra) # 80002a08 <iget>
    800032d4:	a011                	j	800032d8 <dirlookup+0xa0>
  return 0;
    800032d6:	4501                	li	a0,0
}
    800032d8:	70e2                	ld	ra,56(sp)
    800032da:	7442                	ld	s0,48(sp)
    800032dc:	74a2                	ld	s1,40(sp)
    800032de:	7902                	ld	s2,32(sp)
    800032e0:	69e2                	ld	s3,24(sp)
    800032e2:	6a42                	ld	s4,16(sp)
    800032e4:	6121                	addi	sp,sp,64
    800032e6:	8082                	ret

00000000800032e8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032e8:	711d                	addi	sp,sp,-96
    800032ea:	ec86                	sd	ra,88(sp)
    800032ec:	e8a2                	sd	s0,80(sp)
    800032ee:	e4a6                	sd	s1,72(sp)
    800032f0:	e0ca                	sd	s2,64(sp)
    800032f2:	fc4e                	sd	s3,56(sp)
    800032f4:	f852                	sd	s4,48(sp)
    800032f6:	f456                	sd	s5,40(sp)
    800032f8:	f05a                	sd	s6,32(sp)
    800032fa:	ec5e                	sd	s7,24(sp)
    800032fc:	e862                	sd	s8,16(sp)
    800032fe:	e466                	sd	s9,8(sp)
    80003300:	1080                	addi	s0,sp,96
    80003302:	84aa                	mv	s1,a0
    80003304:	8b2e                	mv	s6,a1
    80003306:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003308:	00054703          	lbu	a4,0(a0)
    8000330c:	02f00793          	li	a5,47
    80003310:	02f70263          	beq	a4,a5,80003334 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003314:	ffffe097          	auipc	ra,0xffffe
    80003318:	c4c080e7          	jalr	-948(ra) # 80000f60 <myproc>
    8000331c:	15853503          	ld	a0,344(a0)
    80003320:	00000097          	auipc	ra,0x0
    80003324:	9da080e7          	jalr	-1574(ra) # 80002cfa <idup>
    80003328:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000332a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000332e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003330:	4b85                	li	s7,1
    80003332:	a875                	j	800033ee <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003334:	4585                	li	a1,1
    80003336:	4505                	li	a0,1
    80003338:	fffff097          	auipc	ra,0xfffff
    8000333c:	6d0080e7          	jalr	1744(ra) # 80002a08 <iget>
    80003340:	8a2a                	mv	s4,a0
    80003342:	b7e5                	j	8000332a <namex+0x42>
      iunlockput(ip);
    80003344:	8552                	mv	a0,s4
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	c58080e7          	jalr	-936(ra) # 80002f9e <iunlockput>
      return 0;
    8000334e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003350:	8552                	mv	a0,s4
    80003352:	60e6                	ld	ra,88(sp)
    80003354:	6446                	ld	s0,80(sp)
    80003356:	64a6                	ld	s1,72(sp)
    80003358:	6906                	ld	s2,64(sp)
    8000335a:	79e2                	ld	s3,56(sp)
    8000335c:	7a42                	ld	s4,48(sp)
    8000335e:	7aa2                	ld	s5,40(sp)
    80003360:	7b02                	ld	s6,32(sp)
    80003362:	6be2                	ld	s7,24(sp)
    80003364:	6c42                	ld	s8,16(sp)
    80003366:	6ca2                	ld	s9,8(sp)
    80003368:	6125                	addi	sp,sp,96
    8000336a:	8082                	ret
      iunlock(ip);
    8000336c:	8552                	mv	a0,s4
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	a90080e7          	jalr	-1392(ra) # 80002dfe <iunlock>
      return ip;
    80003376:	bfe9                	j	80003350 <namex+0x68>
      iunlockput(ip);
    80003378:	8552                	mv	a0,s4
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	c24080e7          	jalr	-988(ra) # 80002f9e <iunlockput>
      return 0;
    80003382:	8a4e                	mv	s4,s3
    80003384:	b7f1                	j	80003350 <namex+0x68>
  len = path - s;
    80003386:	40998633          	sub	a2,s3,s1
    8000338a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000338e:	099c5863          	bge	s8,s9,8000341e <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003392:	4639                	li	a2,14
    80003394:	85a6                	mv	a1,s1
    80003396:	8556                	mv	a0,s5
    80003398:	ffffd097          	auipc	ra,0xffffd
    8000339c:	e3e080e7          	jalr	-450(ra) # 800001d6 <memmove>
    800033a0:	84ce                	mv	s1,s3
  while(*path == '/')
    800033a2:	0004c783          	lbu	a5,0(s1)
    800033a6:	01279763          	bne	a5,s2,800033b4 <namex+0xcc>
    path++;
    800033aa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	ff278de3          	beq	a5,s2,800033aa <namex+0xc2>
    ilock(ip);
    800033b4:	8552                	mv	a0,s4
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	982080e7          	jalr	-1662(ra) # 80002d38 <ilock>
    if(ip->type != T_DIR){
    800033be:	044a1783          	lh	a5,68(s4)
    800033c2:	f97791e3          	bne	a5,s7,80003344 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800033c6:	000b0563          	beqz	s6,800033d0 <namex+0xe8>
    800033ca:	0004c783          	lbu	a5,0(s1)
    800033ce:	dfd9                	beqz	a5,8000336c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033d0:	4601                	li	a2,0
    800033d2:	85d6                	mv	a1,s5
    800033d4:	8552                	mv	a0,s4
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	e62080e7          	jalr	-414(ra) # 80003238 <dirlookup>
    800033de:	89aa                	mv	s3,a0
    800033e0:	dd41                	beqz	a0,80003378 <namex+0x90>
    iunlockput(ip);
    800033e2:	8552                	mv	a0,s4
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	bba080e7          	jalr	-1094(ra) # 80002f9e <iunlockput>
    ip = next;
    800033ec:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033ee:	0004c783          	lbu	a5,0(s1)
    800033f2:	01279763          	bne	a5,s2,80003400 <namex+0x118>
    path++;
    800033f6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033f8:	0004c783          	lbu	a5,0(s1)
    800033fc:	ff278de3          	beq	a5,s2,800033f6 <namex+0x10e>
  if(*path == 0)
    80003400:	cb9d                	beqz	a5,80003436 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003402:	0004c783          	lbu	a5,0(s1)
    80003406:	89a6                	mv	s3,s1
  len = path - s;
    80003408:	4c81                	li	s9,0
    8000340a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000340c:	01278963          	beq	a5,s2,8000341e <namex+0x136>
    80003410:	dbbd                	beqz	a5,80003386 <namex+0x9e>
    path++;
    80003412:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003414:	0009c783          	lbu	a5,0(s3)
    80003418:	ff279ce3          	bne	a5,s2,80003410 <namex+0x128>
    8000341c:	b7ad                	j	80003386 <namex+0x9e>
    memmove(name, s, len);
    8000341e:	2601                	sext.w	a2,a2
    80003420:	85a6                	mv	a1,s1
    80003422:	8556                	mv	a0,s5
    80003424:	ffffd097          	auipc	ra,0xffffd
    80003428:	db2080e7          	jalr	-590(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000342c:	9cd6                	add	s9,s9,s5
    8000342e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003432:	84ce                	mv	s1,s3
    80003434:	b7bd                	j	800033a2 <namex+0xba>
  if(nameiparent){
    80003436:	f00b0de3          	beqz	s6,80003350 <namex+0x68>
    iput(ip);
    8000343a:	8552                	mv	a0,s4
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	aba080e7          	jalr	-1350(ra) # 80002ef6 <iput>
    return 0;
    80003444:	4a01                	li	s4,0
    80003446:	b729                	j	80003350 <namex+0x68>

0000000080003448 <dirlink>:
{
    80003448:	7139                	addi	sp,sp,-64
    8000344a:	fc06                	sd	ra,56(sp)
    8000344c:	f822                	sd	s0,48(sp)
    8000344e:	f04a                	sd	s2,32(sp)
    80003450:	ec4e                	sd	s3,24(sp)
    80003452:	e852                	sd	s4,16(sp)
    80003454:	0080                	addi	s0,sp,64
    80003456:	892a                	mv	s2,a0
    80003458:	8a2e                	mv	s4,a1
    8000345a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000345c:	4601                	li	a2,0
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	dda080e7          	jalr	-550(ra) # 80003238 <dirlookup>
    80003466:	ed25                	bnez	a0,800034de <dirlink+0x96>
    80003468:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000346a:	04c92483          	lw	s1,76(s2)
    8000346e:	c49d                	beqz	s1,8000349c <dirlink+0x54>
    80003470:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003472:	4741                	li	a4,16
    80003474:	86a6                	mv	a3,s1
    80003476:	fc040613          	addi	a2,s0,-64
    8000347a:	4581                	li	a1,0
    8000347c:	854a                	mv	a0,s2
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	b72080e7          	jalr	-1166(ra) # 80002ff0 <readi>
    80003486:	47c1                	li	a5,16
    80003488:	06f51163          	bne	a0,a5,800034ea <dirlink+0xa2>
    if(de.inum == 0)
    8000348c:	fc045783          	lhu	a5,-64(s0)
    80003490:	c791                	beqz	a5,8000349c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003492:	24c1                	addiw	s1,s1,16
    80003494:	04c92783          	lw	a5,76(s2)
    80003498:	fcf4ede3          	bltu	s1,a5,80003472 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000349c:	4639                	li	a2,14
    8000349e:	85d2                	mv	a1,s4
    800034a0:	fc240513          	addi	a0,s0,-62
    800034a4:	ffffd097          	auipc	ra,0xffffd
    800034a8:	ddc080e7          	jalr	-548(ra) # 80000280 <strncpy>
  de.inum = inum;
    800034ac:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034b0:	4741                	li	a4,16
    800034b2:	86a6                	mv	a3,s1
    800034b4:	fc040613          	addi	a2,s0,-64
    800034b8:	4581                	li	a1,0
    800034ba:	854a                	mv	a0,s2
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	c38080e7          	jalr	-968(ra) # 800030f4 <writei>
    800034c4:	872a                	mv	a4,a0
    800034c6:	47c1                	li	a5,16
  return 0;
    800034c8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034ca:	02f71863          	bne	a4,a5,800034fa <dirlink+0xb2>
    800034ce:	74a2                	ld	s1,40(sp)
}
    800034d0:	70e2                	ld	ra,56(sp)
    800034d2:	7442                	ld	s0,48(sp)
    800034d4:	7902                	ld	s2,32(sp)
    800034d6:	69e2                	ld	s3,24(sp)
    800034d8:	6a42                	ld	s4,16(sp)
    800034da:	6121                	addi	sp,sp,64
    800034dc:	8082                	ret
    iput(ip);
    800034de:	00000097          	auipc	ra,0x0
    800034e2:	a18080e7          	jalr	-1512(ra) # 80002ef6 <iput>
    return -1;
    800034e6:	557d                	li	a0,-1
    800034e8:	b7e5                	j	800034d0 <dirlink+0x88>
      panic("dirlink read");
    800034ea:	00005517          	auipc	a0,0x5
    800034ee:	fe650513          	addi	a0,a0,-26 # 800084d0 <etext+0x4d0>
    800034f2:	00003097          	auipc	ra,0x3
    800034f6:	9ca080e7          	jalr	-1590(ra) # 80005ebc <panic>
    panic("dirlink");
    800034fa:	00005517          	auipc	a0,0x5
    800034fe:	0de50513          	addi	a0,a0,222 # 800085d8 <etext+0x5d8>
    80003502:	00003097          	auipc	ra,0x3
    80003506:	9ba080e7          	jalr	-1606(ra) # 80005ebc <panic>

000000008000350a <namei>:

struct inode*
namei(char *path)
{
    8000350a:	1101                	addi	sp,sp,-32
    8000350c:	ec06                	sd	ra,24(sp)
    8000350e:	e822                	sd	s0,16(sp)
    80003510:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003512:	fe040613          	addi	a2,s0,-32
    80003516:	4581                	li	a1,0
    80003518:	00000097          	auipc	ra,0x0
    8000351c:	dd0080e7          	jalr	-560(ra) # 800032e8 <namex>
}
    80003520:	60e2                	ld	ra,24(sp)
    80003522:	6442                	ld	s0,16(sp)
    80003524:	6105                	addi	sp,sp,32
    80003526:	8082                	ret

0000000080003528 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003528:	1141                	addi	sp,sp,-16
    8000352a:	e406                	sd	ra,8(sp)
    8000352c:	e022                	sd	s0,0(sp)
    8000352e:	0800                	addi	s0,sp,16
    80003530:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003532:	4585                	li	a1,1
    80003534:	00000097          	auipc	ra,0x0
    80003538:	db4080e7          	jalr	-588(ra) # 800032e8 <namex>
}
    8000353c:	60a2                	ld	ra,8(sp)
    8000353e:	6402                	ld	s0,0(sp)
    80003540:	0141                	addi	sp,sp,16
    80003542:	8082                	ret

0000000080003544 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003544:	1101                	addi	sp,sp,-32
    80003546:	ec06                	sd	ra,24(sp)
    80003548:	e822                	sd	s0,16(sp)
    8000354a:	e426                	sd	s1,8(sp)
    8000354c:	e04a                	sd	s2,0(sp)
    8000354e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003550:	00019917          	auipc	s2,0x19
    80003554:	cd090913          	addi	s2,s2,-816 # 8001c220 <log>
    80003558:	01892583          	lw	a1,24(s2)
    8000355c:	02892503          	lw	a0,40(s2)
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	fde080e7          	jalr	-34(ra) # 8000253e <bread>
    80003568:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000356a:	02c92603          	lw	a2,44(s2)
    8000356e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003570:	00c05f63          	blez	a2,8000358e <write_head+0x4a>
    80003574:	00019717          	auipc	a4,0x19
    80003578:	cdc70713          	addi	a4,a4,-804 # 8001c250 <log+0x30>
    8000357c:	87aa                	mv	a5,a0
    8000357e:	060a                	slli	a2,a2,0x2
    80003580:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003582:	4314                	lw	a3,0(a4)
    80003584:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003586:	0711                	addi	a4,a4,4
    80003588:	0791                	addi	a5,a5,4
    8000358a:	fec79ce3          	bne	a5,a2,80003582 <write_head+0x3e>
  }
  bwrite(buf);
    8000358e:	8526                	mv	a0,s1
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	0a0080e7          	jalr	160(ra) # 80002630 <bwrite>
  brelse(buf);
    80003598:	8526                	mv	a0,s1
    8000359a:	fffff097          	auipc	ra,0xfffff
    8000359e:	0d4080e7          	jalr	212(ra) # 8000266e <brelse>
}
    800035a2:	60e2                	ld	ra,24(sp)
    800035a4:	6442                	ld	s0,16(sp)
    800035a6:	64a2                	ld	s1,8(sp)
    800035a8:	6902                	ld	s2,0(sp)
    800035aa:	6105                	addi	sp,sp,32
    800035ac:	8082                	ret

00000000800035ae <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ae:	00019797          	auipc	a5,0x19
    800035b2:	c9e7a783          	lw	a5,-866(a5) # 8001c24c <log+0x2c>
    800035b6:	0af05d63          	blez	a5,80003670 <install_trans+0xc2>
{
    800035ba:	7139                	addi	sp,sp,-64
    800035bc:	fc06                	sd	ra,56(sp)
    800035be:	f822                	sd	s0,48(sp)
    800035c0:	f426                	sd	s1,40(sp)
    800035c2:	f04a                	sd	s2,32(sp)
    800035c4:	ec4e                	sd	s3,24(sp)
    800035c6:	e852                	sd	s4,16(sp)
    800035c8:	e456                	sd	s5,8(sp)
    800035ca:	e05a                	sd	s6,0(sp)
    800035cc:	0080                	addi	s0,sp,64
    800035ce:	8b2a                	mv	s6,a0
    800035d0:	00019a97          	auipc	s5,0x19
    800035d4:	c80a8a93          	addi	s5,s5,-896 # 8001c250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035d8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035da:	00019997          	auipc	s3,0x19
    800035de:	c4698993          	addi	s3,s3,-954 # 8001c220 <log>
    800035e2:	a00d                	j	80003604 <install_trans+0x56>
    brelse(lbuf);
    800035e4:	854a                	mv	a0,s2
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	088080e7          	jalr	136(ra) # 8000266e <brelse>
    brelse(dbuf);
    800035ee:	8526                	mv	a0,s1
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	07e080e7          	jalr	126(ra) # 8000266e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f8:	2a05                	addiw	s4,s4,1
    800035fa:	0a91                	addi	s5,s5,4
    800035fc:	02c9a783          	lw	a5,44(s3)
    80003600:	04fa5e63          	bge	s4,a5,8000365c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003604:	0189a583          	lw	a1,24(s3)
    80003608:	014585bb          	addw	a1,a1,s4
    8000360c:	2585                	addiw	a1,a1,1
    8000360e:	0289a503          	lw	a0,40(s3)
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	f2c080e7          	jalr	-212(ra) # 8000253e <bread>
    8000361a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000361c:	000aa583          	lw	a1,0(s5)
    80003620:	0289a503          	lw	a0,40(s3)
    80003624:	fffff097          	auipc	ra,0xfffff
    80003628:	f1a080e7          	jalr	-230(ra) # 8000253e <bread>
    8000362c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000362e:	40000613          	li	a2,1024
    80003632:	05890593          	addi	a1,s2,88
    80003636:	05850513          	addi	a0,a0,88
    8000363a:	ffffd097          	auipc	ra,0xffffd
    8000363e:	b9c080e7          	jalr	-1124(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003642:	8526                	mv	a0,s1
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	fec080e7          	jalr	-20(ra) # 80002630 <bwrite>
    if(recovering == 0)
    8000364c:	f80b1ce3          	bnez	s6,800035e4 <install_trans+0x36>
      bunpin(dbuf);
    80003650:	8526                	mv	a0,s1
    80003652:	fffff097          	auipc	ra,0xfffff
    80003656:	0f4080e7          	jalr	244(ra) # 80002746 <bunpin>
    8000365a:	b769                	j	800035e4 <install_trans+0x36>
}
    8000365c:	70e2                	ld	ra,56(sp)
    8000365e:	7442                	ld	s0,48(sp)
    80003660:	74a2                	ld	s1,40(sp)
    80003662:	7902                	ld	s2,32(sp)
    80003664:	69e2                	ld	s3,24(sp)
    80003666:	6a42                	ld	s4,16(sp)
    80003668:	6aa2                	ld	s5,8(sp)
    8000366a:	6b02                	ld	s6,0(sp)
    8000366c:	6121                	addi	sp,sp,64
    8000366e:	8082                	ret
    80003670:	8082                	ret

0000000080003672 <initlog>:
{
    80003672:	7179                	addi	sp,sp,-48
    80003674:	f406                	sd	ra,40(sp)
    80003676:	f022                	sd	s0,32(sp)
    80003678:	ec26                	sd	s1,24(sp)
    8000367a:	e84a                	sd	s2,16(sp)
    8000367c:	e44e                	sd	s3,8(sp)
    8000367e:	1800                	addi	s0,sp,48
    80003680:	892a                	mv	s2,a0
    80003682:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003684:	00019497          	auipc	s1,0x19
    80003688:	b9c48493          	addi	s1,s1,-1124 # 8001c220 <log>
    8000368c:	00005597          	auipc	a1,0x5
    80003690:	e5458593          	addi	a1,a1,-428 # 800084e0 <etext+0x4e0>
    80003694:	8526                	mv	a0,s1
    80003696:	00003097          	auipc	ra,0x3
    8000369a:	d10080e7          	jalr	-752(ra) # 800063a6 <initlock>
  log.start = sb->logstart;
    8000369e:	0149a583          	lw	a1,20(s3)
    800036a2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036a4:	0109a783          	lw	a5,16(s3)
    800036a8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036aa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036ae:	854a                	mv	a0,s2
    800036b0:	fffff097          	auipc	ra,0xfffff
    800036b4:	e8e080e7          	jalr	-370(ra) # 8000253e <bread>
  log.lh.n = lh->n;
    800036b8:	4d30                	lw	a2,88(a0)
    800036ba:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036bc:	00c05f63          	blez	a2,800036da <initlog+0x68>
    800036c0:	87aa                	mv	a5,a0
    800036c2:	00019717          	auipc	a4,0x19
    800036c6:	b8e70713          	addi	a4,a4,-1138 # 8001c250 <log+0x30>
    800036ca:	060a                	slli	a2,a2,0x2
    800036cc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800036ce:	4ff4                	lw	a3,92(a5)
    800036d0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036d2:	0791                	addi	a5,a5,4
    800036d4:	0711                	addi	a4,a4,4
    800036d6:	fec79ce3          	bne	a5,a2,800036ce <initlog+0x5c>
  brelse(buf);
    800036da:	fffff097          	auipc	ra,0xfffff
    800036de:	f94080e7          	jalr	-108(ra) # 8000266e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036e2:	4505                	li	a0,1
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	eca080e7          	jalr	-310(ra) # 800035ae <install_trans>
  log.lh.n = 0;
    800036ec:	00019797          	auipc	a5,0x19
    800036f0:	b607a023          	sw	zero,-1184(a5) # 8001c24c <log+0x2c>
  write_head(); // clear the log
    800036f4:	00000097          	auipc	ra,0x0
    800036f8:	e50080e7          	jalr	-432(ra) # 80003544 <write_head>
}
    800036fc:	70a2                	ld	ra,40(sp)
    800036fe:	7402                	ld	s0,32(sp)
    80003700:	64e2                	ld	s1,24(sp)
    80003702:	6942                	ld	s2,16(sp)
    80003704:	69a2                	ld	s3,8(sp)
    80003706:	6145                	addi	sp,sp,48
    80003708:	8082                	ret

000000008000370a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000370a:	1101                	addi	sp,sp,-32
    8000370c:	ec06                	sd	ra,24(sp)
    8000370e:	e822                	sd	s0,16(sp)
    80003710:	e426                	sd	s1,8(sp)
    80003712:	e04a                	sd	s2,0(sp)
    80003714:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003716:	00019517          	auipc	a0,0x19
    8000371a:	b0a50513          	addi	a0,a0,-1270 # 8001c220 <log>
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	d18080e7          	jalr	-744(ra) # 80006436 <acquire>
  while(1){
    if(log.committing){
    80003726:	00019497          	auipc	s1,0x19
    8000372a:	afa48493          	addi	s1,s1,-1286 # 8001c220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000372e:	4979                	li	s2,30
    80003730:	a039                	j	8000373e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003732:	85a6                	mv	a1,s1
    80003734:	8526                	mv	a0,s1
    80003736:	ffffe097          	auipc	ra,0xffffe
    8000373a:	f9a080e7          	jalr	-102(ra) # 800016d0 <sleep>
    if(log.committing){
    8000373e:	50dc                	lw	a5,36(s1)
    80003740:	fbed                	bnez	a5,80003732 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003742:	5098                	lw	a4,32(s1)
    80003744:	2705                	addiw	a4,a4,1
    80003746:	0027179b          	slliw	a5,a4,0x2
    8000374a:	9fb9                	addw	a5,a5,a4
    8000374c:	0017979b          	slliw	a5,a5,0x1
    80003750:	54d4                	lw	a3,44(s1)
    80003752:	9fb5                	addw	a5,a5,a3
    80003754:	00f95963          	bge	s2,a5,80003766 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003758:	85a6                	mv	a1,s1
    8000375a:	8526                	mv	a0,s1
    8000375c:	ffffe097          	auipc	ra,0xffffe
    80003760:	f74080e7          	jalr	-140(ra) # 800016d0 <sleep>
    80003764:	bfe9                	j	8000373e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003766:	00019517          	auipc	a0,0x19
    8000376a:	aba50513          	addi	a0,a0,-1350 # 8001c220 <log>
    8000376e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003770:	00003097          	auipc	ra,0x3
    80003774:	d7a080e7          	jalr	-646(ra) # 800064ea <release>
      break;
    }
  }
}
    80003778:	60e2                	ld	ra,24(sp)
    8000377a:	6442                	ld	s0,16(sp)
    8000377c:	64a2                	ld	s1,8(sp)
    8000377e:	6902                	ld	s2,0(sp)
    80003780:	6105                	addi	sp,sp,32
    80003782:	8082                	ret

0000000080003784 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003784:	7139                	addi	sp,sp,-64
    80003786:	fc06                	sd	ra,56(sp)
    80003788:	f822                	sd	s0,48(sp)
    8000378a:	f426                	sd	s1,40(sp)
    8000378c:	f04a                	sd	s2,32(sp)
    8000378e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003790:	00019497          	auipc	s1,0x19
    80003794:	a9048493          	addi	s1,s1,-1392 # 8001c220 <log>
    80003798:	8526                	mv	a0,s1
    8000379a:	00003097          	auipc	ra,0x3
    8000379e:	c9c080e7          	jalr	-868(ra) # 80006436 <acquire>
  log.outstanding -= 1;
    800037a2:	509c                	lw	a5,32(s1)
    800037a4:	37fd                	addiw	a5,a5,-1
    800037a6:	0007891b          	sext.w	s2,a5
    800037aa:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037ac:	50dc                	lw	a5,36(s1)
    800037ae:	e7b9                	bnez	a5,800037fc <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800037b0:	06091163          	bnez	s2,80003812 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037b4:	00019497          	auipc	s1,0x19
    800037b8:	a6c48493          	addi	s1,s1,-1428 # 8001c220 <log>
    800037bc:	4785                	li	a5,1
    800037be:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037c0:	8526                	mv	a0,s1
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	d28080e7          	jalr	-728(ra) # 800064ea <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037ca:	54dc                	lw	a5,44(s1)
    800037cc:	06f04763          	bgtz	a5,8000383a <end_op+0xb6>
    acquire(&log.lock);
    800037d0:	00019497          	auipc	s1,0x19
    800037d4:	a5048493          	addi	s1,s1,-1456 # 8001c220 <log>
    800037d8:	8526                	mv	a0,s1
    800037da:	00003097          	auipc	ra,0x3
    800037de:	c5c080e7          	jalr	-932(ra) # 80006436 <acquire>
    log.committing = 0;
    800037e2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037e6:	8526                	mv	a0,s1
    800037e8:	ffffe097          	auipc	ra,0xffffe
    800037ec:	074080e7          	jalr	116(ra) # 8000185c <wakeup>
    release(&log.lock);
    800037f0:	8526                	mv	a0,s1
    800037f2:	00003097          	auipc	ra,0x3
    800037f6:	cf8080e7          	jalr	-776(ra) # 800064ea <release>
}
    800037fa:	a815                	j	8000382e <end_op+0xaa>
    800037fc:	ec4e                	sd	s3,24(sp)
    800037fe:	e852                	sd	s4,16(sp)
    80003800:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003802:	00005517          	auipc	a0,0x5
    80003806:	ce650513          	addi	a0,a0,-794 # 800084e8 <etext+0x4e8>
    8000380a:	00002097          	auipc	ra,0x2
    8000380e:	6b2080e7          	jalr	1714(ra) # 80005ebc <panic>
    wakeup(&log);
    80003812:	00019497          	auipc	s1,0x19
    80003816:	a0e48493          	addi	s1,s1,-1522 # 8001c220 <log>
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	040080e7          	jalr	64(ra) # 8000185c <wakeup>
  release(&log.lock);
    80003824:	8526                	mv	a0,s1
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	cc4080e7          	jalr	-828(ra) # 800064ea <release>
}
    8000382e:	70e2                	ld	ra,56(sp)
    80003830:	7442                	ld	s0,48(sp)
    80003832:	74a2                	ld	s1,40(sp)
    80003834:	7902                	ld	s2,32(sp)
    80003836:	6121                	addi	sp,sp,64
    80003838:	8082                	ret
    8000383a:	ec4e                	sd	s3,24(sp)
    8000383c:	e852                	sd	s4,16(sp)
    8000383e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003840:	00019a97          	auipc	s5,0x19
    80003844:	a10a8a93          	addi	s5,s5,-1520 # 8001c250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003848:	00019a17          	auipc	s4,0x19
    8000384c:	9d8a0a13          	addi	s4,s4,-1576 # 8001c220 <log>
    80003850:	018a2583          	lw	a1,24(s4)
    80003854:	012585bb          	addw	a1,a1,s2
    80003858:	2585                	addiw	a1,a1,1
    8000385a:	028a2503          	lw	a0,40(s4)
    8000385e:	fffff097          	auipc	ra,0xfffff
    80003862:	ce0080e7          	jalr	-800(ra) # 8000253e <bread>
    80003866:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003868:	000aa583          	lw	a1,0(s5)
    8000386c:	028a2503          	lw	a0,40(s4)
    80003870:	fffff097          	auipc	ra,0xfffff
    80003874:	cce080e7          	jalr	-818(ra) # 8000253e <bread>
    80003878:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000387a:	40000613          	li	a2,1024
    8000387e:	05850593          	addi	a1,a0,88
    80003882:	05848513          	addi	a0,s1,88
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	950080e7          	jalr	-1712(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000388e:	8526                	mv	a0,s1
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	da0080e7          	jalr	-608(ra) # 80002630 <bwrite>
    brelse(from);
    80003898:	854e                	mv	a0,s3
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	dd4080e7          	jalr	-556(ra) # 8000266e <brelse>
    brelse(to);
    800038a2:	8526                	mv	a0,s1
    800038a4:	fffff097          	auipc	ra,0xfffff
    800038a8:	dca080e7          	jalr	-566(ra) # 8000266e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038ac:	2905                	addiw	s2,s2,1
    800038ae:	0a91                	addi	s5,s5,4
    800038b0:	02ca2783          	lw	a5,44(s4)
    800038b4:	f8f94ee3          	blt	s2,a5,80003850 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038b8:	00000097          	auipc	ra,0x0
    800038bc:	c8c080e7          	jalr	-884(ra) # 80003544 <write_head>
    install_trans(0); // Now install writes to home locations
    800038c0:	4501                	li	a0,0
    800038c2:	00000097          	auipc	ra,0x0
    800038c6:	cec080e7          	jalr	-788(ra) # 800035ae <install_trans>
    log.lh.n = 0;
    800038ca:	00019797          	auipc	a5,0x19
    800038ce:	9807a123          	sw	zero,-1662(a5) # 8001c24c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038d2:	00000097          	auipc	ra,0x0
    800038d6:	c72080e7          	jalr	-910(ra) # 80003544 <write_head>
    800038da:	69e2                	ld	s3,24(sp)
    800038dc:	6a42                	ld	s4,16(sp)
    800038de:	6aa2                	ld	s5,8(sp)
    800038e0:	bdc5                	j	800037d0 <end_op+0x4c>

00000000800038e2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	e04a                	sd	s2,0(sp)
    800038ec:	1000                	addi	s0,sp,32
    800038ee:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038f0:	00019917          	auipc	s2,0x19
    800038f4:	93090913          	addi	s2,s2,-1744 # 8001c220 <log>
    800038f8:	854a                	mv	a0,s2
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	b3c080e7          	jalr	-1220(ra) # 80006436 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003902:	02c92603          	lw	a2,44(s2)
    80003906:	47f5                	li	a5,29
    80003908:	06c7c563          	blt	a5,a2,80003972 <log_write+0x90>
    8000390c:	00019797          	auipc	a5,0x19
    80003910:	9307a783          	lw	a5,-1744(a5) # 8001c23c <log+0x1c>
    80003914:	37fd                	addiw	a5,a5,-1
    80003916:	04f65e63          	bge	a2,a5,80003972 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000391a:	00019797          	auipc	a5,0x19
    8000391e:	9267a783          	lw	a5,-1754(a5) # 8001c240 <log+0x20>
    80003922:	06f05063          	blez	a5,80003982 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003926:	4781                	li	a5,0
    80003928:	06c05563          	blez	a2,80003992 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000392c:	44cc                	lw	a1,12(s1)
    8000392e:	00019717          	auipc	a4,0x19
    80003932:	92270713          	addi	a4,a4,-1758 # 8001c250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003936:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003938:	4314                	lw	a3,0(a4)
    8000393a:	04b68c63          	beq	a3,a1,80003992 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000393e:	2785                	addiw	a5,a5,1
    80003940:	0711                	addi	a4,a4,4
    80003942:	fef61be3          	bne	a2,a5,80003938 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003946:	0621                	addi	a2,a2,8
    80003948:	060a                	slli	a2,a2,0x2
    8000394a:	00019797          	auipc	a5,0x19
    8000394e:	8d678793          	addi	a5,a5,-1834 # 8001c220 <log>
    80003952:	97b2                	add	a5,a5,a2
    80003954:	44d8                	lw	a4,12(s1)
    80003956:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003958:	8526                	mv	a0,s1
    8000395a:	fffff097          	auipc	ra,0xfffff
    8000395e:	db0080e7          	jalr	-592(ra) # 8000270a <bpin>
    log.lh.n++;
    80003962:	00019717          	auipc	a4,0x19
    80003966:	8be70713          	addi	a4,a4,-1858 # 8001c220 <log>
    8000396a:	575c                	lw	a5,44(a4)
    8000396c:	2785                	addiw	a5,a5,1
    8000396e:	d75c                	sw	a5,44(a4)
    80003970:	a82d                	j	800039aa <log_write+0xc8>
    panic("too big a transaction");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	b8650513          	addi	a0,a0,-1146 # 800084f8 <etext+0x4f8>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	542080e7          	jalr	1346(ra) # 80005ebc <panic>
    panic("log_write outside of trans");
    80003982:	00005517          	auipc	a0,0x5
    80003986:	b8e50513          	addi	a0,a0,-1138 # 80008510 <etext+0x510>
    8000398a:	00002097          	auipc	ra,0x2
    8000398e:	532080e7          	jalr	1330(ra) # 80005ebc <panic>
  log.lh.block[i] = b->blockno;
    80003992:	00878693          	addi	a3,a5,8
    80003996:	068a                	slli	a3,a3,0x2
    80003998:	00019717          	auipc	a4,0x19
    8000399c:	88870713          	addi	a4,a4,-1912 # 8001c220 <log>
    800039a0:	9736                	add	a4,a4,a3
    800039a2:	44d4                	lw	a3,12(s1)
    800039a4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039a6:	faf609e3          	beq	a2,a5,80003958 <log_write+0x76>
  }
  release(&log.lock);
    800039aa:	00019517          	auipc	a0,0x19
    800039ae:	87650513          	addi	a0,a0,-1930 # 8001c220 <log>
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	b38080e7          	jalr	-1224(ra) # 800064ea <release>
}
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6902                	ld	s2,0(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret

00000000800039c6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039c6:	1101                	addi	sp,sp,-32
    800039c8:	ec06                	sd	ra,24(sp)
    800039ca:	e822                	sd	s0,16(sp)
    800039cc:	e426                	sd	s1,8(sp)
    800039ce:	e04a                	sd	s2,0(sp)
    800039d0:	1000                	addi	s0,sp,32
    800039d2:	84aa                	mv	s1,a0
    800039d4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039d6:	00005597          	auipc	a1,0x5
    800039da:	b5a58593          	addi	a1,a1,-1190 # 80008530 <etext+0x530>
    800039de:	0521                	addi	a0,a0,8
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	9c6080e7          	jalr	-1594(ra) # 800063a6 <initlock>
  lk->name = name;
    800039e8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039ec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039f0:	0204a423          	sw	zero,40(s1)
}
    800039f4:	60e2                	ld	ra,24(sp)
    800039f6:	6442                	ld	s0,16(sp)
    800039f8:	64a2                	ld	s1,8(sp)
    800039fa:	6902                	ld	s2,0(sp)
    800039fc:	6105                	addi	sp,sp,32
    800039fe:	8082                	ret

0000000080003a00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a00:	1101                	addi	sp,sp,-32
    80003a02:	ec06                	sd	ra,24(sp)
    80003a04:	e822                	sd	s0,16(sp)
    80003a06:	e426                	sd	s1,8(sp)
    80003a08:	e04a                	sd	s2,0(sp)
    80003a0a:	1000                	addi	s0,sp,32
    80003a0c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a0e:	00850913          	addi	s2,a0,8
    80003a12:	854a                	mv	a0,s2
    80003a14:	00003097          	auipc	ra,0x3
    80003a18:	a22080e7          	jalr	-1502(ra) # 80006436 <acquire>
  while (lk->locked) {
    80003a1c:	409c                	lw	a5,0(s1)
    80003a1e:	cb89                	beqz	a5,80003a30 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a20:	85ca                	mv	a1,s2
    80003a22:	8526                	mv	a0,s1
    80003a24:	ffffe097          	auipc	ra,0xffffe
    80003a28:	cac080e7          	jalr	-852(ra) # 800016d0 <sleep>
  while (lk->locked) {
    80003a2c:	409c                	lw	a5,0(s1)
    80003a2e:	fbed                	bnez	a5,80003a20 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a30:	4785                	li	a5,1
    80003a32:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a34:	ffffd097          	auipc	ra,0xffffd
    80003a38:	52c080e7          	jalr	1324(ra) # 80000f60 <myproc>
    80003a3c:	591c                	lw	a5,48(a0)
    80003a3e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a40:	854a                	mv	a0,s2
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	aa8080e7          	jalr	-1368(ra) # 800064ea <release>
}
    80003a4a:	60e2                	ld	ra,24(sp)
    80003a4c:	6442                	ld	s0,16(sp)
    80003a4e:	64a2                	ld	s1,8(sp)
    80003a50:	6902                	ld	s2,0(sp)
    80003a52:	6105                	addi	sp,sp,32
    80003a54:	8082                	ret

0000000080003a56 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a56:	1101                	addi	sp,sp,-32
    80003a58:	ec06                	sd	ra,24(sp)
    80003a5a:	e822                	sd	s0,16(sp)
    80003a5c:	e426                	sd	s1,8(sp)
    80003a5e:	e04a                	sd	s2,0(sp)
    80003a60:	1000                	addi	s0,sp,32
    80003a62:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a64:	00850913          	addi	s2,a0,8
    80003a68:	854a                	mv	a0,s2
    80003a6a:	00003097          	auipc	ra,0x3
    80003a6e:	9cc080e7          	jalr	-1588(ra) # 80006436 <acquire>
  lk->locked = 0;
    80003a72:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a76:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a7a:	8526                	mv	a0,s1
    80003a7c:	ffffe097          	auipc	ra,0xffffe
    80003a80:	de0080e7          	jalr	-544(ra) # 8000185c <wakeup>
  release(&lk->lk);
    80003a84:	854a                	mv	a0,s2
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	a64080e7          	jalr	-1436(ra) # 800064ea <release>
}
    80003a8e:	60e2                	ld	ra,24(sp)
    80003a90:	6442                	ld	s0,16(sp)
    80003a92:	64a2                	ld	s1,8(sp)
    80003a94:	6902                	ld	s2,0(sp)
    80003a96:	6105                	addi	sp,sp,32
    80003a98:	8082                	ret

0000000080003a9a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a9a:	7179                	addi	sp,sp,-48
    80003a9c:	f406                	sd	ra,40(sp)
    80003a9e:	f022                	sd	s0,32(sp)
    80003aa0:	ec26                	sd	s1,24(sp)
    80003aa2:	e84a                	sd	s2,16(sp)
    80003aa4:	1800                	addi	s0,sp,48
    80003aa6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aa8:	00850913          	addi	s2,a0,8
    80003aac:	854a                	mv	a0,s2
    80003aae:	00003097          	auipc	ra,0x3
    80003ab2:	988080e7          	jalr	-1656(ra) # 80006436 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab6:	409c                	lw	a5,0(s1)
    80003ab8:	ef91                	bnez	a5,80003ad4 <holdingsleep+0x3a>
    80003aba:	4481                	li	s1,0
  release(&lk->lk);
    80003abc:	854a                	mv	a0,s2
    80003abe:	00003097          	auipc	ra,0x3
    80003ac2:	a2c080e7          	jalr	-1492(ra) # 800064ea <release>
  return r;
}
    80003ac6:	8526                	mv	a0,s1
    80003ac8:	70a2                	ld	ra,40(sp)
    80003aca:	7402                	ld	s0,32(sp)
    80003acc:	64e2                	ld	s1,24(sp)
    80003ace:	6942                	ld	s2,16(sp)
    80003ad0:	6145                	addi	sp,sp,48
    80003ad2:	8082                	ret
    80003ad4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ad6:	0284a983          	lw	s3,40(s1)
    80003ada:	ffffd097          	auipc	ra,0xffffd
    80003ade:	486080e7          	jalr	1158(ra) # 80000f60 <myproc>
    80003ae2:	5904                	lw	s1,48(a0)
    80003ae4:	413484b3          	sub	s1,s1,s3
    80003ae8:	0014b493          	seqz	s1,s1
    80003aec:	69a2                	ld	s3,8(sp)
    80003aee:	b7f9                	j	80003abc <holdingsleep+0x22>

0000000080003af0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003af0:	1141                	addi	sp,sp,-16
    80003af2:	e406                	sd	ra,8(sp)
    80003af4:	e022                	sd	s0,0(sp)
    80003af6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003af8:	00005597          	auipc	a1,0x5
    80003afc:	a4858593          	addi	a1,a1,-1464 # 80008540 <etext+0x540>
    80003b00:	00019517          	auipc	a0,0x19
    80003b04:	86850513          	addi	a0,a0,-1944 # 8001c368 <ftable>
    80003b08:	00003097          	auipc	ra,0x3
    80003b0c:	89e080e7          	jalr	-1890(ra) # 800063a6 <initlock>
}
    80003b10:	60a2                	ld	ra,8(sp)
    80003b12:	6402                	ld	s0,0(sp)
    80003b14:	0141                	addi	sp,sp,16
    80003b16:	8082                	ret

0000000080003b18 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b18:	1101                	addi	sp,sp,-32
    80003b1a:	ec06                	sd	ra,24(sp)
    80003b1c:	e822                	sd	s0,16(sp)
    80003b1e:	e426                	sd	s1,8(sp)
    80003b20:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b22:	00019517          	auipc	a0,0x19
    80003b26:	84650513          	addi	a0,a0,-1978 # 8001c368 <ftable>
    80003b2a:	00003097          	auipc	ra,0x3
    80003b2e:	90c080e7          	jalr	-1780(ra) # 80006436 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b32:	00019497          	auipc	s1,0x19
    80003b36:	84e48493          	addi	s1,s1,-1970 # 8001c380 <ftable+0x18>
    80003b3a:	00019717          	auipc	a4,0x19
    80003b3e:	7e670713          	addi	a4,a4,2022 # 8001d320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b42:	40dc                	lw	a5,4(s1)
    80003b44:	cf99                	beqz	a5,80003b62 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b46:	02848493          	addi	s1,s1,40
    80003b4a:	fee49ce3          	bne	s1,a4,80003b42 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b4e:	00019517          	auipc	a0,0x19
    80003b52:	81a50513          	addi	a0,a0,-2022 # 8001c368 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	994080e7          	jalr	-1644(ra) # 800064ea <release>
  return 0;
    80003b5e:	4481                	li	s1,0
    80003b60:	a819                	j	80003b76 <filealloc+0x5e>
      f->ref = 1;
    80003b62:	4785                	li	a5,1
    80003b64:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b66:	00019517          	auipc	a0,0x19
    80003b6a:	80250513          	addi	a0,a0,-2046 # 8001c368 <ftable>
    80003b6e:	00003097          	auipc	ra,0x3
    80003b72:	97c080e7          	jalr	-1668(ra) # 800064ea <release>
}
    80003b76:	8526                	mv	a0,s1
    80003b78:	60e2                	ld	ra,24(sp)
    80003b7a:	6442                	ld	s0,16(sp)
    80003b7c:	64a2                	ld	s1,8(sp)
    80003b7e:	6105                	addi	sp,sp,32
    80003b80:	8082                	ret

0000000080003b82 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b82:	1101                	addi	sp,sp,-32
    80003b84:	ec06                	sd	ra,24(sp)
    80003b86:	e822                	sd	s0,16(sp)
    80003b88:	e426                	sd	s1,8(sp)
    80003b8a:	1000                	addi	s0,sp,32
    80003b8c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b8e:	00018517          	auipc	a0,0x18
    80003b92:	7da50513          	addi	a0,a0,2010 # 8001c368 <ftable>
    80003b96:	00003097          	auipc	ra,0x3
    80003b9a:	8a0080e7          	jalr	-1888(ra) # 80006436 <acquire>
  if(f->ref < 1)
    80003b9e:	40dc                	lw	a5,4(s1)
    80003ba0:	02f05263          	blez	a5,80003bc4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ba4:	2785                	addiw	a5,a5,1
    80003ba6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ba8:	00018517          	auipc	a0,0x18
    80003bac:	7c050513          	addi	a0,a0,1984 # 8001c368 <ftable>
    80003bb0:	00003097          	auipc	ra,0x3
    80003bb4:	93a080e7          	jalr	-1734(ra) # 800064ea <release>
  return f;
}
    80003bb8:	8526                	mv	a0,s1
    80003bba:	60e2                	ld	ra,24(sp)
    80003bbc:	6442                	ld	s0,16(sp)
    80003bbe:	64a2                	ld	s1,8(sp)
    80003bc0:	6105                	addi	sp,sp,32
    80003bc2:	8082                	ret
    panic("filedup");
    80003bc4:	00005517          	auipc	a0,0x5
    80003bc8:	98450513          	addi	a0,a0,-1660 # 80008548 <etext+0x548>
    80003bcc:	00002097          	auipc	ra,0x2
    80003bd0:	2f0080e7          	jalr	752(ra) # 80005ebc <panic>

0000000080003bd4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bd4:	7139                	addi	sp,sp,-64
    80003bd6:	fc06                	sd	ra,56(sp)
    80003bd8:	f822                	sd	s0,48(sp)
    80003bda:	f426                	sd	s1,40(sp)
    80003bdc:	0080                	addi	s0,sp,64
    80003bde:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003be0:	00018517          	auipc	a0,0x18
    80003be4:	78850513          	addi	a0,a0,1928 # 8001c368 <ftable>
    80003be8:	00003097          	auipc	ra,0x3
    80003bec:	84e080e7          	jalr	-1970(ra) # 80006436 <acquire>
  if(f->ref < 1)
    80003bf0:	40dc                	lw	a5,4(s1)
    80003bf2:	04f05c63          	blez	a5,80003c4a <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003bf6:	37fd                	addiw	a5,a5,-1
    80003bf8:	0007871b          	sext.w	a4,a5
    80003bfc:	c0dc                	sw	a5,4(s1)
    80003bfe:	06e04263          	bgtz	a4,80003c62 <fileclose+0x8e>
    80003c02:	f04a                	sd	s2,32(sp)
    80003c04:	ec4e                	sd	s3,24(sp)
    80003c06:	e852                	sd	s4,16(sp)
    80003c08:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c0a:	0004a903          	lw	s2,0(s1)
    80003c0e:	0094ca83          	lbu	s5,9(s1)
    80003c12:	0104ba03          	ld	s4,16(s1)
    80003c16:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c1a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c1e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c22:	00018517          	auipc	a0,0x18
    80003c26:	74650513          	addi	a0,a0,1862 # 8001c368 <ftable>
    80003c2a:	00003097          	auipc	ra,0x3
    80003c2e:	8c0080e7          	jalr	-1856(ra) # 800064ea <release>

  if(ff.type == FD_PIPE){
    80003c32:	4785                	li	a5,1
    80003c34:	04f90463          	beq	s2,a5,80003c7c <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c38:	3979                	addiw	s2,s2,-2
    80003c3a:	4785                	li	a5,1
    80003c3c:	0527fb63          	bgeu	a5,s2,80003c92 <fileclose+0xbe>
    80003c40:	7902                	ld	s2,32(sp)
    80003c42:	69e2                	ld	s3,24(sp)
    80003c44:	6a42                	ld	s4,16(sp)
    80003c46:	6aa2                	ld	s5,8(sp)
    80003c48:	a02d                	j	80003c72 <fileclose+0x9e>
    80003c4a:	f04a                	sd	s2,32(sp)
    80003c4c:	ec4e                	sd	s3,24(sp)
    80003c4e:	e852                	sd	s4,16(sp)
    80003c50:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c52:	00005517          	auipc	a0,0x5
    80003c56:	8fe50513          	addi	a0,a0,-1794 # 80008550 <etext+0x550>
    80003c5a:	00002097          	auipc	ra,0x2
    80003c5e:	262080e7          	jalr	610(ra) # 80005ebc <panic>
    release(&ftable.lock);
    80003c62:	00018517          	auipc	a0,0x18
    80003c66:	70650513          	addi	a0,a0,1798 # 8001c368 <ftable>
    80003c6a:	00003097          	auipc	ra,0x3
    80003c6e:	880080e7          	jalr	-1920(ra) # 800064ea <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c72:	70e2                	ld	ra,56(sp)
    80003c74:	7442                	ld	s0,48(sp)
    80003c76:	74a2                	ld	s1,40(sp)
    80003c78:	6121                	addi	sp,sp,64
    80003c7a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c7c:	85d6                	mv	a1,s5
    80003c7e:	8552                	mv	a0,s4
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	3a2080e7          	jalr	930(ra) # 80004022 <pipeclose>
    80003c88:	7902                	ld	s2,32(sp)
    80003c8a:	69e2                	ld	s3,24(sp)
    80003c8c:	6a42                	ld	s4,16(sp)
    80003c8e:	6aa2                	ld	s5,8(sp)
    80003c90:	b7cd                	j	80003c72 <fileclose+0x9e>
    begin_op();
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	a78080e7          	jalr	-1416(ra) # 8000370a <begin_op>
    iput(ff.ip);
    80003c9a:	854e                	mv	a0,s3
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	25a080e7          	jalr	602(ra) # 80002ef6 <iput>
    end_op();
    80003ca4:	00000097          	auipc	ra,0x0
    80003ca8:	ae0080e7          	jalr	-1312(ra) # 80003784 <end_op>
    80003cac:	7902                	ld	s2,32(sp)
    80003cae:	69e2                	ld	s3,24(sp)
    80003cb0:	6a42                	ld	s4,16(sp)
    80003cb2:	6aa2                	ld	s5,8(sp)
    80003cb4:	bf7d                	j	80003c72 <fileclose+0x9e>

0000000080003cb6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cb6:	715d                	addi	sp,sp,-80
    80003cb8:	e486                	sd	ra,72(sp)
    80003cba:	e0a2                	sd	s0,64(sp)
    80003cbc:	fc26                	sd	s1,56(sp)
    80003cbe:	f44e                	sd	s3,40(sp)
    80003cc0:	0880                	addi	s0,sp,80
    80003cc2:	84aa                	mv	s1,a0
    80003cc4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cc6:	ffffd097          	auipc	ra,0xffffd
    80003cca:	29a080e7          	jalr	666(ra) # 80000f60 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cce:	409c                	lw	a5,0(s1)
    80003cd0:	37f9                	addiw	a5,a5,-2
    80003cd2:	4705                	li	a4,1
    80003cd4:	04f76863          	bltu	a4,a5,80003d24 <filestat+0x6e>
    80003cd8:	f84a                	sd	s2,48(sp)
    80003cda:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cdc:	6c88                	ld	a0,24(s1)
    80003cde:	fffff097          	auipc	ra,0xfffff
    80003ce2:	05a080e7          	jalr	90(ra) # 80002d38 <ilock>
    stati(f->ip, &st);
    80003ce6:	fb840593          	addi	a1,s0,-72
    80003cea:	6c88                	ld	a0,24(s1)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	2da080e7          	jalr	730(ra) # 80002fc6 <stati>
    iunlock(f->ip);
    80003cf4:	6c88                	ld	a0,24(s1)
    80003cf6:	fffff097          	auipc	ra,0xfffff
    80003cfa:	108080e7          	jalr	264(ra) # 80002dfe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cfe:	46e1                	li	a3,24
    80003d00:	fb840613          	addi	a2,s0,-72
    80003d04:	85ce                	mv	a1,s3
    80003d06:	05093503          	ld	a0,80(s2)
    80003d0a:	ffffd097          	auipc	ra,0xffffd
    80003d0e:	e0e080e7          	jalr	-498(ra) # 80000b18 <copyout>
    80003d12:	41f5551b          	sraiw	a0,a0,0x1f
    80003d16:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003d18:	60a6                	ld	ra,72(sp)
    80003d1a:	6406                	ld	s0,64(sp)
    80003d1c:	74e2                	ld	s1,56(sp)
    80003d1e:	79a2                	ld	s3,40(sp)
    80003d20:	6161                	addi	sp,sp,80
    80003d22:	8082                	ret
  return -1;
    80003d24:	557d                	li	a0,-1
    80003d26:	bfcd                	j	80003d18 <filestat+0x62>

0000000080003d28 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d28:	7179                	addi	sp,sp,-48
    80003d2a:	f406                	sd	ra,40(sp)
    80003d2c:	f022                	sd	s0,32(sp)
    80003d2e:	e84a                	sd	s2,16(sp)
    80003d30:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d32:	00854783          	lbu	a5,8(a0)
    80003d36:	cbc5                	beqz	a5,80003de6 <fileread+0xbe>
    80003d38:	ec26                	sd	s1,24(sp)
    80003d3a:	e44e                	sd	s3,8(sp)
    80003d3c:	84aa                	mv	s1,a0
    80003d3e:	89ae                	mv	s3,a1
    80003d40:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d42:	411c                	lw	a5,0(a0)
    80003d44:	4705                	li	a4,1
    80003d46:	04e78963          	beq	a5,a4,80003d98 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d4a:	470d                	li	a4,3
    80003d4c:	04e78f63          	beq	a5,a4,80003daa <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d50:	4709                	li	a4,2
    80003d52:	08e79263          	bne	a5,a4,80003dd6 <fileread+0xae>
    ilock(f->ip);
    80003d56:	6d08                	ld	a0,24(a0)
    80003d58:	fffff097          	auipc	ra,0xfffff
    80003d5c:	fe0080e7          	jalr	-32(ra) # 80002d38 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d60:	874a                	mv	a4,s2
    80003d62:	5094                	lw	a3,32(s1)
    80003d64:	864e                	mv	a2,s3
    80003d66:	4585                	li	a1,1
    80003d68:	6c88                	ld	a0,24(s1)
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	286080e7          	jalr	646(ra) # 80002ff0 <readi>
    80003d72:	892a                	mv	s2,a0
    80003d74:	00a05563          	blez	a0,80003d7e <fileread+0x56>
      f->off += r;
    80003d78:	509c                	lw	a5,32(s1)
    80003d7a:	9fa9                	addw	a5,a5,a0
    80003d7c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d7e:	6c88                	ld	a0,24(s1)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	07e080e7          	jalr	126(ra) # 80002dfe <iunlock>
    80003d88:	64e2                	ld	s1,24(sp)
    80003d8a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d8c:	854a                	mv	a0,s2
    80003d8e:	70a2                	ld	ra,40(sp)
    80003d90:	7402                	ld	s0,32(sp)
    80003d92:	6942                	ld	s2,16(sp)
    80003d94:	6145                	addi	sp,sp,48
    80003d96:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d98:	6908                	ld	a0,16(a0)
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	3fa080e7          	jalr	1018(ra) # 80004194 <piperead>
    80003da2:	892a                	mv	s2,a0
    80003da4:	64e2                	ld	s1,24(sp)
    80003da6:	69a2                	ld	s3,8(sp)
    80003da8:	b7d5                	j	80003d8c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003daa:	02451783          	lh	a5,36(a0)
    80003dae:	03079693          	slli	a3,a5,0x30
    80003db2:	92c1                	srli	a3,a3,0x30
    80003db4:	4725                	li	a4,9
    80003db6:	02d76a63          	bltu	a4,a3,80003dea <fileread+0xc2>
    80003dba:	0792                	slli	a5,a5,0x4
    80003dbc:	00018717          	auipc	a4,0x18
    80003dc0:	50c70713          	addi	a4,a4,1292 # 8001c2c8 <devsw>
    80003dc4:	97ba                	add	a5,a5,a4
    80003dc6:	639c                	ld	a5,0(a5)
    80003dc8:	c78d                	beqz	a5,80003df2 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003dca:	4505                	li	a0,1
    80003dcc:	9782                	jalr	a5
    80003dce:	892a                	mv	s2,a0
    80003dd0:	64e2                	ld	s1,24(sp)
    80003dd2:	69a2                	ld	s3,8(sp)
    80003dd4:	bf65                	j	80003d8c <fileread+0x64>
    panic("fileread");
    80003dd6:	00004517          	auipc	a0,0x4
    80003dda:	78a50513          	addi	a0,a0,1930 # 80008560 <etext+0x560>
    80003dde:	00002097          	auipc	ra,0x2
    80003de2:	0de080e7          	jalr	222(ra) # 80005ebc <panic>
    return -1;
    80003de6:	597d                	li	s2,-1
    80003de8:	b755                	j	80003d8c <fileread+0x64>
      return -1;
    80003dea:	597d                	li	s2,-1
    80003dec:	64e2                	ld	s1,24(sp)
    80003dee:	69a2                	ld	s3,8(sp)
    80003df0:	bf71                	j	80003d8c <fileread+0x64>
    80003df2:	597d                	li	s2,-1
    80003df4:	64e2                	ld	s1,24(sp)
    80003df6:	69a2                	ld	s3,8(sp)
    80003df8:	bf51                	j	80003d8c <fileread+0x64>

0000000080003dfa <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003dfa:	00954783          	lbu	a5,9(a0)
    80003dfe:	12078963          	beqz	a5,80003f30 <filewrite+0x136>
{
    80003e02:	715d                	addi	sp,sp,-80
    80003e04:	e486                	sd	ra,72(sp)
    80003e06:	e0a2                	sd	s0,64(sp)
    80003e08:	f84a                	sd	s2,48(sp)
    80003e0a:	f052                	sd	s4,32(sp)
    80003e0c:	e85a                	sd	s6,16(sp)
    80003e0e:	0880                	addi	s0,sp,80
    80003e10:	892a                	mv	s2,a0
    80003e12:	8b2e                	mv	s6,a1
    80003e14:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e16:	411c                	lw	a5,0(a0)
    80003e18:	4705                	li	a4,1
    80003e1a:	02e78763          	beq	a5,a4,80003e48 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e1e:	470d                	li	a4,3
    80003e20:	02e78a63          	beq	a5,a4,80003e54 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e24:	4709                	li	a4,2
    80003e26:	0ee79863          	bne	a5,a4,80003f16 <filewrite+0x11c>
    80003e2a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e2c:	0cc05463          	blez	a2,80003ef4 <filewrite+0xfa>
    80003e30:	fc26                	sd	s1,56(sp)
    80003e32:	ec56                	sd	s5,24(sp)
    80003e34:	e45e                	sd	s7,8(sp)
    80003e36:	e062                	sd	s8,0(sp)
    int i = 0;
    80003e38:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e3a:	6b85                	lui	s7,0x1
    80003e3c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e40:	6c05                	lui	s8,0x1
    80003e42:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e46:	a851                	j	80003eda <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e48:	6908                	ld	a0,16(a0)
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	248080e7          	jalr	584(ra) # 80004092 <pipewrite>
    80003e52:	a85d                	j	80003f08 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e54:	02451783          	lh	a5,36(a0)
    80003e58:	03079693          	slli	a3,a5,0x30
    80003e5c:	92c1                	srli	a3,a3,0x30
    80003e5e:	4725                	li	a4,9
    80003e60:	0cd76a63          	bltu	a4,a3,80003f34 <filewrite+0x13a>
    80003e64:	0792                	slli	a5,a5,0x4
    80003e66:	00018717          	auipc	a4,0x18
    80003e6a:	46270713          	addi	a4,a4,1122 # 8001c2c8 <devsw>
    80003e6e:	97ba                	add	a5,a5,a4
    80003e70:	679c                	ld	a5,8(a5)
    80003e72:	c3f9                	beqz	a5,80003f38 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003e74:	4505                	li	a0,1
    80003e76:	9782                	jalr	a5
    80003e78:	a841                	j	80003f08 <filewrite+0x10e>
      if(n1 > max)
    80003e7a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	88c080e7          	jalr	-1908(ra) # 8000370a <begin_op>
      ilock(f->ip);
    80003e86:	01893503          	ld	a0,24(s2)
    80003e8a:	fffff097          	auipc	ra,0xfffff
    80003e8e:	eae080e7          	jalr	-338(ra) # 80002d38 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e92:	8756                	mv	a4,s5
    80003e94:	02092683          	lw	a3,32(s2)
    80003e98:	01698633          	add	a2,s3,s6
    80003e9c:	4585                	li	a1,1
    80003e9e:	01893503          	ld	a0,24(s2)
    80003ea2:	fffff097          	auipc	ra,0xfffff
    80003ea6:	252080e7          	jalr	594(ra) # 800030f4 <writei>
    80003eaa:	84aa                	mv	s1,a0
    80003eac:	00a05763          	blez	a0,80003eba <filewrite+0xc0>
        f->off += r;
    80003eb0:	02092783          	lw	a5,32(s2)
    80003eb4:	9fa9                	addw	a5,a5,a0
    80003eb6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003eba:	01893503          	ld	a0,24(s2)
    80003ebe:	fffff097          	auipc	ra,0xfffff
    80003ec2:	f40080e7          	jalr	-192(ra) # 80002dfe <iunlock>
      end_op();
    80003ec6:	00000097          	auipc	ra,0x0
    80003eca:	8be080e7          	jalr	-1858(ra) # 80003784 <end_op>

      if(r != n1){
    80003ece:	029a9563          	bne	s5,s1,80003ef8 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003ed2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ed6:	0149da63          	bge	s3,s4,80003eea <filewrite+0xf0>
      int n1 = n - i;
    80003eda:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003ede:	0004879b          	sext.w	a5,s1
    80003ee2:	f8fbdce3          	bge	s7,a5,80003e7a <filewrite+0x80>
    80003ee6:	84e2                	mv	s1,s8
    80003ee8:	bf49                	j	80003e7a <filewrite+0x80>
    80003eea:	74e2                	ld	s1,56(sp)
    80003eec:	6ae2                	ld	s5,24(sp)
    80003eee:	6ba2                	ld	s7,8(sp)
    80003ef0:	6c02                	ld	s8,0(sp)
    80003ef2:	a039                	j	80003f00 <filewrite+0x106>
    int i = 0;
    80003ef4:	4981                	li	s3,0
    80003ef6:	a029                	j	80003f00 <filewrite+0x106>
    80003ef8:	74e2                	ld	s1,56(sp)
    80003efa:	6ae2                	ld	s5,24(sp)
    80003efc:	6ba2                	ld	s7,8(sp)
    80003efe:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003f00:	033a1e63          	bne	s4,s3,80003f3c <filewrite+0x142>
    80003f04:	8552                	mv	a0,s4
    80003f06:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f08:	60a6                	ld	ra,72(sp)
    80003f0a:	6406                	ld	s0,64(sp)
    80003f0c:	7942                	ld	s2,48(sp)
    80003f0e:	7a02                	ld	s4,32(sp)
    80003f10:	6b42                	ld	s6,16(sp)
    80003f12:	6161                	addi	sp,sp,80
    80003f14:	8082                	ret
    80003f16:	fc26                	sd	s1,56(sp)
    80003f18:	f44e                	sd	s3,40(sp)
    80003f1a:	ec56                	sd	s5,24(sp)
    80003f1c:	e45e                	sd	s7,8(sp)
    80003f1e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003f20:	00004517          	auipc	a0,0x4
    80003f24:	65050513          	addi	a0,a0,1616 # 80008570 <etext+0x570>
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	f94080e7          	jalr	-108(ra) # 80005ebc <panic>
    return -1;
    80003f30:	557d                	li	a0,-1
}
    80003f32:	8082                	ret
      return -1;
    80003f34:	557d                	li	a0,-1
    80003f36:	bfc9                	j	80003f08 <filewrite+0x10e>
    80003f38:	557d                	li	a0,-1
    80003f3a:	b7f9                	j	80003f08 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003f3c:	557d                	li	a0,-1
    80003f3e:	79a2                	ld	s3,40(sp)
    80003f40:	b7e1                	j	80003f08 <filewrite+0x10e>

0000000080003f42 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f42:	7179                	addi	sp,sp,-48
    80003f44:	f406                	sd	ra,40(sp)
    80003f46:	f022                	sd	s0,32(sp)
    80003f48:	ec26                	sd	s1,24(sp)
    80003f4a:	e052                	sd	s4,0(sp)
    80003f4c:	1800                	addi	s0,sp,48
    80003f4e:	84aa                	mv	s1,a0
    80003f50:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f52:	0005b023          	sd	zero,0(a1)
    80003f56:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f5a:	00000097          	auipc	ra,0x0
    80003f5e:	bbe080e7          	jalr	-1090(ra) # 80003b18 <filealloc>
    80003f62:	e088                	sd	a0,0(s1)
    80003f64:	cd49                	beqz	a0,80003ffe <pipealloc+0xbc>
    80003f66:	00000097          	auipc	ra,0x0
    80003f6a:	bb2080e7          	jalr	-1102(ra) # 80003b18 <filealloc>
    80003f6e:	00aa3023          	sd	a0,0(s4)
    80003f72:	c141                	beqz	a0,80003ff2 <pipealloc+0xb0>
    80003f74:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f76:	ffffc097          	auipc	ra,0xffffc
    80003f7a:	1a4080e7          	jalr	420(ra) # 8000011a <kalloc>
    80003f7e:	892a                	mv	s2,a0
    80003f80:	c13d                	beqz	a0,80003fe6 <pipealloc+0xa4>
    80003f82:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f84:	4985                	li	s3,1
    80003f86:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f8a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f8e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f92:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f96:	00004597          	auipc	a1,0x4
    80003f9a:	5ea58593          	addi	a1,a1,1514 # 80008580 <etext+0x580>
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	408080e7          	jalr	1032(ra) # 800063a6 <initlock>
  (*f0)->type = FD_PIPE;
    80003fa6:	609c                	ld	a5,0(s1)
    80003fa8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fac:	609c                	ld	a5,0(s1)
    80003fae:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fb2:	609c                	ld	a5,0(s1)
    80003fb4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fb8:	609c                	ld	a5,0(s1)
    80003fba:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fbe:	000a3783          	ld	a5,0(s4)
    80003fc2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fc6:	000a3783          	ld	a5,0(s4)
    80003fca:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fce:	000a3783          	ld	a5,0(s4)
    80003fd2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fd6:	000a3783          	ld	a5,0(s4)
    80003fda:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fde:	4501                	li	a0,0
    80003fe0:	6942                	ld	s2,16(sp)
    80003fe2:	69a2                	ld	s3,8(sp)
    80003fe4:	a03d                	j	80004012 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fe6:	6088                	ld	a0,0(s1)
    80003fe8:	c119                	beqz	a0,80003fee <pipealloc+0xac>
    80003fea:	6942                	ld	s2,16(sp)
    80003fec:	a029                	j	80003ff6 <pipealloc+0xb4>
    80003fee:	6942                	ld	s2,16(sp)
    80003ff0:	a039                	j	80003ffe <pipealloc+0xbc>
    80003ff2:	6088                	ld	a0,0(s1)
    80003ff4:	c50d                	beqz	a0,8000401e <pipealloc+0xdc>
    fileclose(*f0);
    80003ff6:	00000097          	auipc	ra,0x0
    80003ffa:	bde080e7          	jalr	-1058(ra) # 80003bd4 <fileclose>
  if(*f1)
    80003ffe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004002:	557d                	li	a0,-1
  if(*f1)
    80004004:	c799                	beqz	a5,80004012 <pipealloc+0xd0>
    fileclose(*f1);
    80004006:	853e                	mv	a0,a5
    80004008:	00000097          	auipc	ra,0x0
    8000400c:	bcc080e7          	jalr	-1076(ra) # 80003bd4 <fileclose>
  return -1;
    80004010:	557d                	li	a0,-1
}
    80004012:	70a2                	ld	ra,40(sp)
    80004014:	7402                	ld	s0,32(sp)
    80004016:	64e2                	ld	s1,24(sp)
    80004018:	6a02                	ld	s4,0(sp)
    8000401a:	6145                	addi	sp,sp,48
    8000401c:	8082                	ret
  return -1;
    8000401e:	557d                	li	a0,-1
    80004020:	bfcd                	j	80004012 <pipealloc+0xd0>

0000000080004022 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004022:	1101                	addi	sp,sp,-32
    80004024:	ec06                	sd	ra,24(sp)
    80004026:	e822                	sd	s0,16(sp)
    80004028:	e426                	sd	s1,8(sp)
    8000402a:	e04a                	sd	s2,0(sp)
    8000402c:	1000                	addi	s0,sp,32
    8000402e:	84aa                	mv	s1,a0
    80004030:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004032:	00002097          	auipc	ra,0x2
    80004036:	404080e7          	jalr	1028(ra) # 80006436 <acquire>
  if(writable){
    8000403a:	02090d63          	beqz	s2,80004074 <pipeclose+0x52>
    pi->writeopen = 0;
    8000403e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004042:	21848513          	addi	a0,s1,536
    80004046:	ffffe097          	auipc	ra,0xffffe
    8000404a:	816080e7          	jalr	-2026(ra) # 8000185c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000404e:	2204b783          	ld	a5,544(s1)
    80004052:	eb95                	bnez	a5,80004086 <pipeclose+0x64>
    release(&pi->lock);
    80004054:	8526                	mv	a0,s1
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	494080e7          	jalr	1172(ra) # 800064ea <release>
    kfree((char*)pi);
    8000405e:	8526                	mv	a0,s1
    80004060:	ffffc097          	auipc	ra,0xffffc
    80004064:	fbc080e7          	jalr	-68(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004068:	60e2                	ld	ra,24(sp)
    8000406a:	6442                	ld	s0,16(sp)
    8000406c:	64a2                	ld	s1,8(sp)
    8000406e:	6902                	ld	s2,0(sp)
    80004070:	6105                	addi	sp,sp,32
    80004072:	8082                	ret
    pi->readopen = 0;
    80004074:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004078:	21c48513          	addi	a0,s1,540
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	7e0080e7          	jalr	2016(ra) # 8000185c <wakeup>
    80004084:	b7e9                	j	8000404e <pipeclose+0x2c>
    release(&pi->lock);
    80004086:	8526                	mv	a0,s1
    80004088:	00002097          	auipc	ra,0x2
    8000408c:	462080e7          	jalr	1122(ra) # 800064ea <release>
}
    80004090:	bfe1                	j	80004068 <pipeclose+0x46>

0000000080004092 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004092:	711d                	addi	sp,sp,-96
    80004094:	ec86                	sd	ra,88(sp)
    80004096:	e8a2                	sd	s0,80(sp)
    80004098:	e4a6                	sd	s1,72(sp)
    8000409a:	e0ca                	sd	s2,64(sp)
    8000409c:	fc4e                	sd	s3,56(sp)
    8000409e:	f852                	sd	s4,48(sp)
    800040a0:	f456                	sd	s5,40(sp)
    800040a2:	1080                	addi	s0,sp,96
    800040a4:	84aa                	mv	s1,a0
    800040a6:	8aae                	mv	s5,a1
    800040a8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	eb6080e7          	jalr	-330(ra) # 80000f60 <myproc>
    800040b2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040b4:	8526                	mv	a0,s1
    800040b6:	00002097          	auipc	ra,0x2
    800040ba:	380080e7          	jalr	896(ra) # 80006436 <acquire>
  while(i < n){
    800040be:	0d405563          	blez	s4,80004188 <pipewrite+0xf6>
    800040c2:	f05a                	sd	s6,32(sp)
    800040c4:	ec5e                	sd	s7,24(sp)
    800040c6:	e862                	sd	s8,16(sp)
  int i = 0;
    800040c8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ca:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040cc:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040d0:	21c48b93          	addi	s7,s1,540
    800040d4:	a089                	j	80004116 <pipewrite+0x84>
      release(&pi->lock);
    800040d6:	8526                	mv	a0,s1
    800040d8:	00002097          	auipc	ra,0x2
    800040dc:	412080e7          	jalr	1042(ra) # 800064ea <release>
      return -1;
    800040e0:	597d                	li	s2,-1
    800040e2:	7b02                	ld	s6,32(sp)
    800040e4:	6be2                	ld	s7,24(sp)
    800040e6:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040e8:	854a                	mv	a0,s2
    800040ea:	60e6                	ld	ra,88(sp)
    800040ec:	6446                	ld	s0,80(sp)
    800040ee:	64a6                	ld	s1,72(sp)
    800040f0:	6906                	ld	s2,64(sp)
    800040f2:	79e2                	ld	s3,56(sp)
    800040f4:	7a42                	ld	s4,48(sp)
    800040f6:	7aa2                	ld	s5,40(sp)
    800040f8:	6125                	addi	sp,sp,96
    800040fa:	8082                	ret
      wakeup(&pi->nread);
    800040fc:	8562                	mv	a0,s8
    800040fe:	ffffd097          	auipc	ra,0xffffd
    80004102:	75e080e7          	jalr	1886(ra) # 8000185c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004106:	85a6                	mv	a1,s1
    80004108:	855e                	mv	a0,s7
    8000410a:	ffffd097          	auipc	ra,0xffffd
    8000410e:	5c6080e7          	jalr	1478(ra) # 800016d0 <sleep>
  while(i < n){
    80004112:	05495c63          	bge	s2,s4,8000416a <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004116:	2204a783          	lw	a5,544(s1)
    8000411a:	dfd5                	beqz	a5,800040d6 <pipewrite+0x44>
    8000411c:	0289a783          	lw	a5,40(s3)
    80004120:	fbdd                	bnez	a5,800040d6 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004122:	2184a783          	lw	a5,536(s1)
    80004126:	21c4a703          	lw	a4,540(s1)
    8000412a:	2007879b          	addiw	a5,a5,512
    8000412e:	fcf707e3          	beq	a4,a5,800040fc <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004132:	4685                	li	a3,1
    80004134:	01590633          	add	a2,s2,s5
    80004138:	faf40593          	addi	a1,s0,-81
    8000413c:	0509b503          	ld	a0,80(s3)
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	a64080e7          	jalr	-1436(ra) # 80000ba4 <copyin>
    80004148:	05650263          	beq	a0,s6,8000418c <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000414c:	21c4a783          	lw	a5,540(s1)
    80004150:	0017871b          	addiw	a4,a5,1
    80004154:	20e4ae23          	sw	a4,540(s1)
    80004158:	1ff7f793          	andi	a5,a5,511
    8000415c:	97a6                	add	a5,a5,s1
    8000415e:	faf44703          	lbu	a4,-81(s0)
    80004162:	00e78c23          	sb	a4,24(a5)
      i++;
    80004166:	2905                	addiw	s2,s2,1
    80004168:	b76d                	j	80004112 <pipewrite+0x80>
    8000416a:	7b02                	ld	s6,32(sp)
    8000416c:	6be2                	ld	s7,24(sp)
    8000416e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004170:	21848513          	addi	a0,s1,536
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	6e8080e7          	jalr	1768(ra) # 8000185c <wakeup>
  release(&pi->lock);
    8000417c:	8526                	mv	a0,s1
    8000417e:	00002097          	auipc	ra,0x2
    80004182:	36c080e7          	jalr	876(ra) # 800064ea <release>
  return i;
    80004186:	b78d                	j	800040e8 <pipewrite+0x56>
  int i = 0;
    80004188:	4901                	li	s2,0
    8000418a:	b7dd                	j	80004170 <pipewrite+0xde>
    8000418c:	7b02                	ld	s6,32(sp)
    8000418e:	6be2                	ld	s7,24(sp)
    80004190:	6c42                	ld	s8,16(sp)
    80004192:	bff9                	j	80004170 <pipewrite+0xde>

0000000080004194 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004194:	715d                	addi	sp,sp,-80
    80004196:	e486                	sd	ra,72(sp)
    80004198:	e0a2                	sd	s0,64(sp)
    8000419a:	fc26                	sd	s1,56(sp)
    8000419c:	f84a                	sd	s2,48(sp)
    8000419e:	f44e                	sd	s3,40(sp)
    800041a0:	f052                	sd	s4,32(sp)
    800041a2:	ec56                	sd	s5,24(sp)
    800041a4:	0880                	addi	s0,sp,80
    800041a6:	84aa                	mv	s1,a0
    800041a8:	892e                	mv	s2,a1
    800041aa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	db4080e7          	jalr	-588(ra) # 80000f60 <myproc>
    800041b4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041b6:	8526                	mv	a0,s1
    800041b8:	00002097          	auipc	ra,0x2
    800041bc:	27e080e7          	jalr	638(ra) # 80006436 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041c0:	2184a703          	lw	a4,536(s1)
    800041c4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041c8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041cc:	02f71663          	bne	a4,a5,800041f8 <piperead+0x64>
    800041d0:	2244a783          	lw	a5,548(s1)
    800041d4:	cb9d                	beqz	a5,8000420a <piperead+0x76>
    if(pr->killed){
    800041d6:	028a2783          	lw	a5,40(s4)
    800041da:	e38d                	bnez	a5,800041fc <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041dc:	85a6                	mv	a1,s1
    800041de:	854e                	mv	a0,s3
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	4f0080e7          	jalr	1264(ra) # 800016d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041e8:	2184a703          	lw	a4,536(s1)
    800041ec:	21c4a783          	lw	a5,540(s1)
    800041f0:	fef700e3          	beq	a4,a5,800041d0 <piperead+0x3c>
    800041f4:	e85a                	sd	s6,16(sp)
    800041f6:	a819                	j	8000420c <piperead+0x78>
    800041f8:	e85a                	sd	s6,16(sp)
    800041fa:	a809                	j	8000420c <piperead+0x78>
      release(&pi->lock);
    800041fc:	8526                	mv	a0,s1
    800041fe:	00002097          	auipc	ra,0x2
    80004202:	2ec080e7          	jalr	748(ra) # 800064ea <release>
      return -1;
    80004206:	59fd                	li	s3,-1
    80004208:	a0a5                	j	80004270 <piperead+0xdc>
    8000420a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000420c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000420e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004210:	05505463          	blez	s5,80004258 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004214:	2184a783          	lw	a5,536(s1)
    80004218:	21c4a703          	lw	a4,540(s1)
    8000421c:	02f70e63          	beq	a4,a5,80004258 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004220:	0017871b          	addiw	a4,a5,1
    80004224:	20e4ac23          	sw	a4,536(s1)
    80004228:	1ff7f793          	andi	a5,a5,511
    8000422c:	97a6                	add	a5,a5,s1
    8000422e:	0187c783          	lbu	a5,24(a5)
    80004232:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004236:	4685                	li	a3,1
    80004238:	fbf40613          	addi	a2,s0,-65
    8000423c:	85ca                	mv	a1,s2
    8000423e:	050a3503          	ld	a0,80(s4)
    80004242:	ffffd097          	auipc	ra,0xffffd
    80004246:	8d6080e7          	jalr	-1834(ra) # 80000b18 <copyout>
    8000424a:	01650763          	beq	a0,s6,80004258 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424e:	2985                	addiw	s3,s3,1
    80004250:	0905                	addi	s2,s2,1
    80004252:	fd3a91e3          	bne	s5,s3,80004214 <piperead+0x80>
    80004256:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004258:	21c48513          	addi	a0,s1,540
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	600080e7          	jalr	1536(ra) # 8000185c <wakeup>
  release(&pi->lock);
    80004264:	8526                	mv	a0,s1
    80004266:	00002097          	auipc	ra,0x2
    8000426a:	284080e7          	jalr	644(ra) # 800064ea <release>
    8000426e:	6b42                	ld	s6,16(sp)
  return i;
}
    80004270:	854e                	mv	a0,s3
    80004272:	60a6                	ld	ra,72(sp)
    80004274:	6406                	ld	s0,64(sp)
    80004276:	74e2                	ld	s1,56(sp)
    80004278:	7942                	ld	s2,48(sp)
    8000427a:	79a2                	ld	s3,40(sp)
    8000427c:	7a02                	ld	s4,32(sp)
    8000427e:	6ae2                	ld	s5,24(sp)
    80004280:	6161                	addi	sp,sp,80
    80004282:	8082                	ret

0000000080004284 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);
void vmprint(pagetable_t pagetable,int depth);
int
exec(char *path, char **argv)
{
    80004284:	df010113          	addi	sp,sp,-528
    80004288:	20113423          	sd	ra,520(sp)
    8000428c:	20813023          	sd	s0,512(sp)
    80004290:	ffa6                	sd	s1,504(sp)
    80004292:	fbca                	sd	s2,496(sp)
    80004294:	0c00                	addi	s0,sp,528
    80004296:	892a                	mv	s2,a0
    80004298:	dea43c23          	sd	a0,-520(s0)
    8000429c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	cc0080e7          	jalr	-832(ra) # 80000f60 <myproc>
    800042a8:	84aa                	mv	s1,a0

  begin_op();
    800042aa:	fffff097          	auipc	ra,0xfffff
    800042ae:	460080e7          	jalr	1120(ra) # 8000370a <begin_op>

  if((ip = namei(path)) == 0){
    800042b2:	854a                	mv	a0,s2
    800042b4:	fffff097          	auipc	ra,0xfffff
    800042b8:	256080e7          	jalr	598(ra) # 8000350a <namei>
    800042bc:	c135                	beqz	a0,80004320 <exec+0x9c>
    800042be:	f3d2                	sd	s4,480(sp)
    800042c0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042c2:	fffff097          	auipc	ra,0xfffff
    800042c6:	a76080e7          	jalr	-1418(ra) # 80002d38 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042ca:	04000713          	li	a4,64
    800042ce:	4681                	li	a3,0
    800042d0:	e5040613          	addi	a2,s0,-432
    800042d4:	4581                	li	a1,0
    800042d6:	8552                	mv	a0,s4
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	d18080e7          	jalr	-744(ra) # 80002ff0 <readi>
    800042e0:	04000793          	li	a5,64
    800042e4:	00f51a63          	bne	a0,a5,800042f8 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042e8:	e5042703          	lw	a4,-432(s0)
    800042ec:	464c47b7          	lui	a5,0x464c4
    800042f0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042f4:	02f70c63          	beq	a4,a5,8000432c <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042f8:	8552                	mv	a0,s4
    800042fa:	fffff097          	auipc	ra,0xfffff
    800042fe:	ca4080e7          	jalr	-860(ra) # 80002f9e <iunlockput>
    end_op();
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	482080e7          	jalr	1154(ra) # 80003784 <end_op>
  }
  return -1;
    8000430a:	557d                	li	a0,-1
    8000430c:	7a1e                	ld	s4,480(sp)
}
    8000430e:	20813083          	ld	ra,520(sp)
    80004312:	20013403          	ld	s0,512(sp)
    80004316:	74fe                	ld	s1,504(sp)
    80004318:	795e                	ld	s2,496(sp)
    8000431a:	21010113          	addi	sp,sp,528
    8000431e:	8082                	ret
    end_op();
    80004320:	fffff097          	auipc	ra,0xfffff
    80004324:	464080e7          	jalr	1124(ra) # 80003784 <end_op>
    return -1;
    80004328:	557d                	li	a0,-1
    8000432a:	b7d5                	j	8000430e <exec+0x8a>
    8000432c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000432e:	8526                	mv	a0,s1
    80004330:	ffffd097          	auipc	ra,0xffffd
    80004334:	cf4080e7          	jalr	-780(ra) # 80001024 <proc_pagetable>
    80004338:	8b2a                	mv	s6,a0
    8000433a:	32050263          	beqz	a0,8000465e <exec+0x3da>
    8000433e:	f7ce                	sd	s3,488(sp)
    80004340:	efd6                	sd	s5,472(sp)
    80004342:	e7de                	sd	s7,456(sp)
    80004344:	e3e2                	sd	s8,448(sp)
    80004346:	ff66                	sd	s9,440(sp)
    80004348:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000434a:	e7042d03          	lw	s10,-400(s0)
    8000434e:	e8845783          	lhu	a5,-376(s0)
    80004352:	14078563          	beqz	a5,8000449c <exec+0x218>
    80004356:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004358:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000435a:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    8000435c:	6c85                	lui	s9,0x1
    8000435e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004362:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004366:	6a85                	lui	s5,0x1
    80004368:	a0b5                	j	800043d4 <exec+0x150>
      panic("loadseg: address should exist");
    8000436a:	00004517          	auipc	a0,0x4
    8000436e:	21e50513          	addi	a0,a0,542 # 80008588 <etext+0x588>
    80004372:	00002097          	auipc	ra,0x2
    80004376:	b4a080e7          	jalr	-1206(ra) # 80005ebc <panic>
    if(sz - i < PGSIZE)
    8000437a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000437c:	8726                	mv	a4,s1
    8000437e:	012c06bb          	addw	a3,s8,s2
    80004382:	4581                	li	a1,0
    80004384:	8552                	mv	a0,s4
    80004386:	fffff097          	auipc	ra,0xfffff
    8000438a:	c6a080e7          	jalr	-918(ra) # 80002ff0 <readi>
    8000438e:	2501                	sext.w	a0,a0
    80004390:	28a49b63          	bne	s1,a0,80004626 <exec+0x3a2>
  for(i = 0; i < sz; i += PGSIZE){
    80004394:	012a893b          	addw	s2,s5,s2
    80004398:	03397563          	bgeu	s2,s3,800043c2 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000439c:	02091593          	slli	a1,s2,0x20
    800043a0:	9181                	srli	a1,a1,0x20
    800043a2:	95de                	add	a1,a1,s7
    800043a4:	855a                	mv	a0,s6
    800043a6:	ffffc097          	auipc	ra,0xffffc
    800043aa:	152080e7          	jalr	338(ra) # 800004f8 <walkaddr>
    800043ae:	862a                	mv	a2,a0
    if(pa == 0)
    800043b0:	dd4d                	beqz	a0,8000436a <exec+0xe6>
    if(sz - i < PGSIZE)
    800043b2:	412984bb          	subw	s1,s3,s2
    800043b6:	0004879b          	sext.w	a5,s1
    800043ba:	fcfcf0e3          	bgeu	s9,a5,8000437a <exec+0xf6>
    800043be:	84d6                	mv	s1,s5
    800043c0:	bf6d                	j	8000437a <exec+0xf6>
    sz = sz1;
    800043c2:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043c6:	2d85                	addiw	s11,s11,1
    800043c8:	038d0d1b          	addiw	s10,s10,56
    800043cc:	e8845783          	lhu	a5,-376(s0)
    800043d0:	06fddf63          	bge	s11,a5,8000444e <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043d4:	2d01                	sext.w	s10,s10
    800043d6:	03800713          	li	a4,56
    800043da:	86ea                	mv	a3,s10
    800043dc:	e1840613          	addi	a2,s0,-488
    800043e0:	4581                	li	a1,0
    800043e2:	8552                	mv	a0,s4
    800043e4:	fffff097          	auipc	ra,0xfffff
    800043e8:	c0c080e7          	jalr	-1012(ra) # 80002ff0 <readi>
    800043ec:	03800793          	li	a5,56
    800043f0:	20f51563          	bne	a0,a5,800045fa <exec+0x376>
    if(ph.type != ELF_PROG_LOAD)
    800043f4:	e1842783          	lw	a5,-488(s0)
    800043f8:	4705                	li	a4,1
    800043fa:	fce796e3          	bne	a5,a4,800043c6 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800043fe:	e4043603          	ld	a2,-448(s0)
    80004402:	e3843783          	ld	a5,-456(s0)
    80004406:	1ef66e63          	bltu	a2,a5,80004602 <exec+0x37e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000440a:	e2843783          	ld	a5,-472(s0)
    8000440e:	963e                	add	a2,a2,a5
    80004410:	1ef66d63          	bltu	a2,a5,8000460a <exec+0x386>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004414:	85a6                	mv	a1,s1
    80004416:	855a                	mv	a0,s6
    80004418:	ffffc097          	auipc	ra,0xffffc
    8000441c:	4a4080e7          	jalr	1188(ra) # 800008bc <uvmalloc>
    80004420:	e0a43423          	sd	a0,-504(s0)
    80004424:	1e050763          	beqz	a0,80004612 <exec+0x38e>
    if((ph.vaddr % PGSIZE) != 0)
    80004428:	e2843b83          	ld	s7,-472(s0)
    8000442c:	df043783          	ld	a5,-528(s0)
    80004430:	00fbf7b3          	and	a5,s7,a5
    80004434:	1e079763          	bnez	a5,80004622 <exec+0x39e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004438:	e2042c03          	lw	s8,-480(s0)
    8000443c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004440:	00098463          	beqz	s3,80004448 <exec+0x1c4>
    80004444:	4901                	li	s2,0
    80004446:	bf99                	j	8000439c <exec+0x118>
    sz = sz1;
    80004448:	e0843483          	ld	s1,-504(s0)
    8000444c:	bfad                	j	800043c6 <exec+0x142>
    8000444e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004450:	8552                	mv	a0,s4
    80004452:	fffff097          	auipc	ra,0xfffff
    80004456:	b4c080e7          	jalr	-1204(ra) # 80002f9e <iunlockput>
  end_op();
    8000445a:	fffff097          	auipc	ra,0xfffff
    8000445e:	32a080e7          	jalr	810(ra) # 80003784 <end_op>
  p = myproc();
    80004462:	ffffd097          	auipc	ra,0xffffd
    80004466:	afe080e7          	jalr	-1282(ra) # 80000f60 <myproc>
    8000446a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000446c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004470:	6985                	lui	s3,0x1
    80004472:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004474:	99a6                	add	s3,s3,s1
    80004476:	77fd                	lui	a5,0xfffff
    80004478:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000447c:	6609                	lui	a2,0x2
    8000447e:	964e                	add	a2,a2,s3
    80004480:	85ce                	mv	a1,s3
    80004482:	855a                	mv	a0,s6
    80004484:	ffffc097          	auipc	ra,0xffffc
    80004488:	438080e7          	jalr	1080(ra) # 800008bc <uvmalloc>
    8000448c:	892a                	mv	s2,a0
    8000448e:	e0a43423          	sd	a0,-504(s0)
    80004492:	e519                	bnez	a0,800044a0 <exec+0x21c>
  if(pagetable)
    80004494:	e1343423          	sd	s3,-504(s0)
    80004498:	4a01                	li	s4,0
    8000449a:	a279                	j	80004628 <exec+0x3a4>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000449c:	4481                	li	s1,0
    8000449e:	bf4d                	j	80004450 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044a0:	75f9                	lui	a1,0xffffe
    800044a2:	95aa                	add	a1,a1,a0
    800044a4:	855a                	mv	a0,s6
    800044a6:	ffffc097          	auipc	ra,0xffffc
    800044aa:	640080e7          	jalr	1600(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    800044ae:	7bfd                	lui	s7,0xfffff
    800044b0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800044b2:	e0043783          	ld	a5,-512(s0)
    800044b6:	6388                	ld	a0,0(a5)
    800044b8:	c52d                	beqz	a0,80004522 <exec+0x29e>
    800044ba:	e9040993          	addi	s3,s0,-368
    800044be:	f9040c13          	addi	s8,s0,-112
    800044c2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	e2a080e7          	jalr	-470(ra) # 800002ee <strlen>
    800044cc:	0015079b          	addiw	a5,a0,1
    800044d0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044d4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044d8:	15796163          	bltu	s2,s7,8000461a <exec+0x396>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044dc:	e0043d03          	ld	s10,-512(s0)
    800044e0:	000d3a03          	ld	s4,0(s10)
    800044e4:	8552                	mv	a0,s4
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	e08080e7          	jalr	-504(ra) # 800002ee <strlen>
    800044ee:	0015069b          	addiw	a3,a0,1
    800044f2:	8652                	mv	a2,s4
    800044f4:	85ca                	mv	a1,s2
    800044f6:	855a                	mv	a0,s6
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	620080e7          	jalr	1568(ra) # 80000b18 <copyout>
    80004500:	10054f63          	bltz	a0,8000461e <exec+0x39a>
    ustack[argc] = sp;
    80004504:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004508:	0485                	addi	s1,s1,1
    8000450a:	008d0793          	addi	a5,s10,8
    8000450e:	e0f43023          	sd	a5,-512(s0)
    80004512:	008d3503          	ld	a0,8(s10)
    80004516:	c909                	beqz	a0,80004528 <exec+0x2a4>
    if(argc >= MAXARG)
    80004518:	09a1                	addi	s3,s3,8
    8000451a:	fb8995e3          	bne	s3,s8,800044c4 <exec+0x240>
  ip = 0;
    8000451e:	4a01                	li	s4,0
    80004520:	a221                	j	80004628 <exec+0x3a4>
  sp = sz;
    80004522:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004526:	4481                	li	s1,0
  ustack[argc] = 0;
    80004528:	00349793          	slli	a5,s1,0x3
    8000452c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5d50>
    80004530:	97a2                	add	a5,a5,s0
    80004532:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004536:	00148693          	addi	a3,s1,1
    8000453a:	068e                	slli	a3,a3,0x3
    8000453c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004540:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004544:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004548:	f57966e3          	bltu	s2,s7,80004494 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000454c:	e9040613          	addi	a2,s0,-368
    80004550:	85ca                	mv	a1,s2
    80004552:	855a                	mv	a0,s6
    80004554:	ffffc097          	auipc	ra,0xffffc
    80004558:	5c4080e7          	jalr	1476(ra) # 80000b18 <copyout>
    8000455c:	10054363          	bltz	a0,80004662 <exec+0x3de>
  p->trapframe->a1 = sp;
    80004560:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004564:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004568:	df843783          	ld	a5,-520(s0)
    8000456c:	0007c703          	lbu	a4,0(a5)
    80004570:	cf11                	beqz	a4,8000458c <exec+0x308>
    80004572:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004574:	02f00693          	li	a3,47
    80004578:	a039                	j	80004586 <exec+0x302>
      last = s+1;
    8000457a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000457e:	0785                	addi	a5,a5,1
    80004580:	fff7c703          	lbu	a4,-1(a5)
    80004584:	c701                	beqz	a4,8000458c <exec+0x308>
    if(*s == '/')
    80004586:	fed71ce3          	bne	a4,a3,8000457e <exec+0x2fa>
    8000458a:	bfc5                	j	8000457a <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    8000458c:	4641                	li	a2,16
    8000458e:	df843583          	ld	a1,-520(s0)
    80004592:	160a8513          	addi	a0,s5,352
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	d26080e7          	jalr	-730(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000459e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800045a2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800045a6:	e0843783          	ld	a5,-504(s0)
    800045aa:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045ae:	058ab783          	ld	a5,88(s5)
    800045b2:	e6843703          	ld	a4,-408(s0)
    800045b6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045b8:	058ab783          	ld	a5,88(s5)
    800045bc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045c0:	85e6                	mv	a1,s9
    800045c2:	ffffd097          	auipc	ra,0xffffd
    800045c6:	b58080e7          	jalr	-1192(ra) # 8000111a <proc_freepagetable>
  if(p->pid==1) 
    800045ca:	030aa703          	lw	a4,48(s5)
    800045ce:	4785                	li	a5,1
    800045d0:	00f70d63          	beq	a4,a5,800045ea <exec+0x366>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045d4:	0004851b          	sext.w	a0,s1
    800045d8:	79be                	ld	s3,488(sp)
    800045da:	7a1e                	ld	s4,480(sp)
    800045dc:	6afe                	ld	s5,472(sp)
    800045de:	6b5e                	ld	s6,464(sp)
    800045e0:	6bbe                	ld	s7,456(sp)
    800045e2:	6c1e                	ld	s8,448(sp)
    800045e4:	7cfa                	ld	s9,440(sp)
    800045e6:	7d5a                	ld	s10,432(sp)
    800045e8:	b31d                	j	8000430e <exec+0x8a>
  vmprint(p->pagetable,1);
    800045ea:	4585                	li	a1,1
    800045ec:	050ab503          	ld	a0,80(s5)
    800045f0:	ffffc097          	auipc	ra,0xffffc
    800045f4:	6fe080e7          	jalr	1790(ra) # 80000cee <vmprint>
    800045f8:	bff1                	j	800045d4 <exec+0x350>
    800045fa:	e0943423          	sd	s1,-504(s0)
    800045fe:	7dba                	ld	s11,424(sp)
    80004600:	a025                	j	80004628 <exec+0x3a4>
    80004602:	e0943423          	sd	s1,-504(s0)
    80004606:	7dba                	ld	s11,424(sp)
    80004608:	a005                	j	80004628 <exec+0x3a4>
    8000460a:	e0943423          	sd	s1,-504(s0)
    8000460e:	7dba                	ld	s11,424(sp)
    80004610:	a821                	j	80004628 <exec+0x3a4>
    80004612:	e0943423          	sd	s1,-504(s0)
    80004616:	7dba                	ld	s11,424(sp)
    80004618:	a801                	j	80004628 <exec+0x3a4>
  ip = 0;
    8000461a:	4a01                	li	s4,0
    8000461c:	a031                	j	80004628 <exec+0x3a4>
    8000461e:	4a01                	li	s4,0
  if(pagetable)
    80004620:	a021                	j	80004628 <exec+0x3a4>
    80004622:	7dba                	ld	s11,424(sp)
    80004624:	a011                	j	80004628 <exec+0x3a4>
    80004626:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004628:	e0843583          	ld	a1,-504(s0)
    8000462c:	855a                	mv	a0,s6
    8000462e:	ffffd097          	auipc	ra,0xffffd
    80004632:	aec080e7          	jalr	-1300(ra) # 8000111a <proc_freepagetable>
  return -1;
    80004636:	557d                	li	a0,-1
  if(ip){
    80004638:	000a1b63          	bnez	s4,8000464e <exec+0x3ca>
    8000463c:	79be                	ld	s3,488(sp)
    8000463e:	7a1e                	ld	s4,480(sp)
    80004640:	6afe                	ld	s5,472(sp)
    80004642:	6b5e                	ld	s6,464(sp)
    80004644:	6bbe                	ld	s7,456(sp)
    80004646:	6c1e                	ld	s8,448(sp)
    80004648:	7cfa                	ld	s9,440(sp)
    8000464a:	7d5a                	ld	s10,432(sp)
    8000464c:	b1c9                	j	8000430e <exec+0x8a>
    8000464e:	79be                	ld	s3,488(sp)
    80004650:	6afe                	ld	s5,472(sp)
    80004652:	6b5e                	ld	s6,464(sp)
    80004654:	6bbe                	ld	s7,456(sp)
    80004656:	6c1e                	ld	s8,448(sp)
    80004658:	7cfa                	ld	s9,440(sp)
    8000465a:	7d5a                	ld	s10,432(sp)
    8000465c:	b971                	j	800042f8 <exec+0x74>
    8000465e:	6b5e                	ld	s6,464(sp)
    80004660:	b961                	j	800042f8 <exec+0x74>
  sz = sz1;
    80004662:	e0843983          	ld	s3,-504(s0)
    80004666:	b53d                	j	80004494 <exec+0x210>

0000000080004668 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004668:	7179                	addi	sp,sp,-48
    8000466a:	f406                	sd	ra,40(sp)
    8000466c:	f022                	sd	s0,32(sp)
    8000466e:	ec26                	sd	s1,24(sp)
    80004670:	e84a                	sd	s2,16(sp)
    80004672:	1800                	addi	s0,sp,48
    80004674:	892e                	mv	s2,a1
    80004676:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004678:	fdc40593          	addi	a1,s0,-36
    8000467c:	ffffe097          	auipc	ra,0xffffe
    80004680:	a4e080e7          	jalr	-1458(ra) # 800020ca <argint>
    80004684:	04054063          	bltz	a0,800046c4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004688:	fdc42703          	lw	a4,-36(s0)
    8000468c:	47bd                	li	a5,15
    8000468e:	02e7ed63          	bltu	a5,a4,800046c8 <argfd+0x60>
    80004692:	ffffd097          	auipc	ra,0xffffd
    80004696:	8ce080e7          	jalr	-1842(ra) # 80000f60 <myproc>
    8000469a:	fdc42703          	lw	a4,-36(s0)
    8000469e:	01a70793          	addi	a5,a4,26
    800046a2:	078e                	slli	a5,a5,0x3
    800046a4:	953e                	add	a0,a0,a5
    800046a6:	651c                	ld	a5,8(a0)
    800046a8:	c395                	beqz	a5,800046cc <argfd+0x64>
    return -1;
  if(pfd)
    800046aa:	00090463          	beqz	s2,800046b2 <argfd+0x4a>
    *pfd = fd;
    800046ae:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046b2:	4501                	li	a0,0
  if(pf)
    800046b4:	c091                	beqz	s1,800046b8 <argfd+0x50>
    *pf = f;
    800046b6:	e09c                	sd	a5,0(s1)
}
    800046b8:	70a2                	ld	ra,40(sp)
    800046ba:	7402                	ld	s0,32(sp)
    800046bc:	64e2                	ld	s1,24(sp)
    800046be:	6942                	ld	s2,16(sp)
    800046c0:	6145                	addi	sp,sp,48
    800046c2:	8082                	ret
    return -1;
    800046c4:	557d                	li	a0,-1
    800046c6:	bfcd                	j	800046b8 <argfd+0x50>
    return -1;
    800046c8:	557d                	li	a0,-1
    800046ca:	b7fd                	j	800046b8 <argfd+0x50>
    800046cc:	557d                	li	a0,-1
    800046ce:	b7ed                	j	800046b8 <argfd+0x50>

00000000800046d0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046d0:	1101                	addi	sp,sp,-32
    800046d2:	ec06                	sd	ra,24(sp)
    800046d4:	e822                	sd	s0,16(sp)
    800046d6:	e426                	sd	s1,8(sp)
    800046d8:	1000                	addi	s0,sp,32
    800046da:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046dc:	ffffd097          	auipc	ra,0xffffd
    800046e0:	884080e7          	jalr	-1916(ra) # 80000f60 <myproc>
    800046e4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046e6:	0d850793          	addi	a5,a0,216
    800046ea:	4501                	li	a0,0
    800046ec:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046ee:	6398                	ld	a4,0(a5)
    800046f0:	cb19                	beqz	a4,80004706 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046f2:	2505                	addiw	a0,a0,1
    800046f4:	07a1                	addi	a5,a5,8
    800046f6:	fed51ce3          	bne	a0,a3,800046ee <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046fa:	557d                	li	a0,-1
}
    800046fc:	60e2                	ld	ra,24(sp)
    800046fe:	6442                	ld	s0,16(sp)
    80004700:	64a2                	ld	s1,8(sp)
    80004702:	6105                	addi	sp,sp,32
    80004704:	8082                	ret
      p->ofile[fd] = f;
    80004706:	01a50793          	addi	a5,a0,26
    8000470a:	078e                	slli	a5,a5,0x3
    8000470c:	963e                	add	a2,a2,a5
    8000470e:	e604                	sd	s1,8(a2)
      return fd;
    80004710:	b7f5                	j	800046fc <fdalloc+0x2c>

0000000080004712 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004712:	715d                	addi	sp,sp,-80
    80004714:	e486                	sd	ra,72(sp)
    80004716:	e0a2                	sd	s0,64(sp)
    80004718:	fc26                	sd	s1,56(sp)
    8000471a:	f84a                	sd	s2,48(sp)
    8000471c:	f44e                	sd	s3,40(sp)
    8000471e:	f052                	sd	s4,32(sp)
    80004720:	ec56                	sd	s5,24(sp)
    80004722:	0880                	addi	s0,sp,80
    80004724:	8aae                	mv	s5,a1
    80004726:	8a32                	mv	s4,a2
    80004728:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000472a:	fb040593          	addi	a1,s0,-80
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	dfa080e7          	jalr	-518(ra) # 80003528 <nameiparent>
    80004736:	892a                	mv	s2,a0
    80004738:	12050c63          	beqz	a0,80004870 <create+0x15e>
    return 0;

  ilock(dp);
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	5fc080e7          	jalr	1532(ra) # 80002d38 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004744:	4601                	li	a2,0
    80004746:	fb040593          	addi	a1,s0,-80
    8000474a:	854a                	mv	a0,s2
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	aec080e7          	jalr	-1300(ra) # 80003238 <dirlookup>
    80004754:	84aa                	mv	s1,a0
    80004756:	c539                	beqz	a0,800047a4 <create+0x92>
    iunlockput(dp);
    80004758:	854a                	mv	a0,s2
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	844080e7          	jalr	-1980(ra) # 80002f9e <iunlockput>
    ilock(ip);
    80004762:	8526                	mv	a0,s1
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	5d4080e7          	jalr	1492(ra) # 80002d38 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000476c:	4789                	li	a5,2
    8000476e:	02fa9463          	bne	s5,a5,80004796 <create+0x84>
    80004772:	0444d783          	lhu	a5,68(s1)
    80004776:	37f9                	addiw	a5,a5,-2
    80004778:	17c2                	slli	a5,a5,0x30
    8000477a:	93c1                	srli	a5,a5,0x30
    8000477c:	4705                	li	a4,1
    8000477e:	00f76c63          	bltu	a4,a5,80004796 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004782:	8526                	mv	a0,s1
    80004784:	60a6                	ld	ra,72(sp)
    80004786:	6406                	ld	s0,64(sp)
    80004788:	74e2                	ld	s1,56(sp)
    8000478a:	7942                	ld	s2,48(sp)
    8000478c:	79a2                	ld	s3,40(sp)
    8000478e:	7a02                	ld	s4,32(sp)
    80004790:	6ae2                	ld	s5,24(sp)
    80004792:	6161                	addi	sp,sp,80
    80004794:	8082                	ret
    iunlockput(ip);
    80004796:	8526                	mv	a0,s1
    80004798:	fffff097          	auipc	ra,0xfffff
    8000479c:	806080e7          	jalr	-2042(ra) # 80002f9e <iunlockput>
    return 0;
    800047a0:	4481                	li	s1,0
    800047a2:	b7c5                	j	80004782 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047a4:	85d6                	mv	a1,s5
    800047a6:	00092503          	lw	a0,0(s2)
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	3fa080e7          	jalr	1018(ra) # 80002ba4 <ialloc>
    800047b2:	84aa                	mv	s1,a0
    800047b4:	c139                	beqz	a0,800047fa <create+0xe8>
  ilock(ip);
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	582080e7          	jalr	1410(ra) # 80002d38 <ilock>
  ip->major = major;
    800047be:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800047c2:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800047c6:	4985                	li	s3,1
    800047c8:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800047cc:	8526                	mv	a0,s1
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	49e080e7          	jalr	1182(ra) # 80002c6c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047d6:	033a8a63          	beq	s5,s3,8000480a <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800047da:	40d0                	lw	a2,4(s1)
    800047dc:	fb040593          	addi	a1,s0,-80
    800047e0:	854a                	mv	a0,s2
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	c66080e7          	jalr	-922(ra) # 80003448 <dirlink>
    800047ea:	06054b63          	bltz	a0,80004860 <create+0x14e>
  iunlockput(dp);
    800047ee:	854a                	mv	a0,s2
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	7ae080e7          	jalr	1966(ra) # 80002f9e <iunlockput>
  return ip;
    800047f8:	b769                	j	80004782 <create+0x70>
    panic("create: ialloc");
    800047fa:	00004517          	auipc	a0,0x4
    800047fe:	dae50513          	addi	a0,a0,-594 # 800085a8 <etext+0x5a8>
    80004802:	00001097          	auipc	ra,0x1
    80004806:	6ba080e7          	jalr	1722(ra) # 80005ebc <panic>
    dp->nlink++;  // for ".."
    8000480a:	04a95783          	lhu	a5,74(s2)
    8000480e:	2785                	addiw	a5,a5,1
    80004810:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004814:	854a                	mv	a0,s2
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	456080e7          	jalr	1110(ra) # 80002c6c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000481e:	40d0                	lw	a2,4(s1)
    80004820:	00004597          	auipc	a1,0x4
    80004824:	d9858593          	addi	a1,a1,-616 # 800085b8 <etext+0x5b8>
    80004828:	8526                	mv	a0,s1
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	c1e080e7          	jalr	-994(ra) # 80003448 <dirlink>
    80004832:	00054f63          	bltz	a0,80004850 <create+0x13e>
    80004836:	00492603          	lw	a2,4(s2)
    8000483a:	00004597          	auipc	a1,0x4
    8000483e:	92e58593          	addi	a1,a1,-1746 # 80008168 <etext+0x168>
    80004842:	8526                	mv	a0,s1
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	c04080e7          	jalr	-1020(ra) # 80003448 <dirlink>
    8000484c:	f80557e3          	bgez	a0,800047da <create+0xc8>
      panic("create dots");
    80004850:	00004517          	auipc	a0,0x4
    80004854:	d7050513          	addi	a0,a0,-656 # 800085c0 <etext+0x5c0>
    80004858:	00001097          	auipc	ra,0x1
    8000485c:	664080e7          	jalr	1636(ra) # 80005ebc <panic>
    panic("create: dirlink");
    80004860:	00004517          	auipc	a0,0x4
    80004864:	d7050513          	addi	a0,a0,-656 # 800085d0 <etext+0x5d0>
    80004868:	00001097          	auipc	ra,0x1
    8000486c:	654080e7          	jalr	1620(ra) # 80005ebc <panic>
    return 0;
    80004870:	84aa                	mv	s1,a0
    80004872:	bf01                	j	80004782 <create+0x70>

0000000080004874 <sys_dup>:
{
    80004874:	7179                	addi	sp,sp,-48
    80004876:	f406                	sd	ra,40(sp)
    80004878:	f022                	sd	s0,32(sp)
    8000487a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000487c:	fd840613          	addi	a2,s0,-40
    80004880:	4581                	li	a1,0
    80004882:	4501                	li	a0,0
    80004884:	00000097          	auipc	ra,0x0
    80004888:	de4080e7          	jalr	-540(ra) # 80004668 <argfd>
    return -1;
    8000488c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000488e:	02054763          	bltz	a0,800048bc <sys_dup+0x48>
    80004892:	ec26                	sd	s1,24(sp)
    80004894:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004896:	fd843903          	ld	s2,-40(s0)
    8000489a:	854a                	mv	a0,s2
    8000489c:	00000097          	auipc	ra,0x0
    800048a0:	e34080e7          	jalr	-460(ra) # 800046d0 <fdalloc>
    800048a4:	84aa                	mv	s1,a0
    return -1;
    800048a6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048a8:	00054f63          	bltz	a0,800048c6 <sys_dup+0x52>
  filedup(f);
    800048ac:	854a                	mv	a0,s2
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	2d4080e7          	jalr	724(ra) # 80003b82 <filedup>
  return fd;
    800048b6:	87a6                	mv	a5,s1
    800048b8:	64e2                	ld	s1,24(sp)
    800048ba:	6942                	ld	s2,16(sp)
}
    800048bc:	853e                	mv	a0,a5
    800048be:	70a2                	ld	ra,40(sp)
    800048c0:	7402                	ld	s0,32(sp)
    800048c2:	6145                	addi	sp,sp,48
    800048c4:	8082                	ret
    800048c6:	64e2                	ld	s1,24(sp)
    800048c8:	6942                	ld	s2,16(sp)
    800048ca:	bfcd                	j	800048bc <sys_dup+0x48>

00000000800048cc <sys_read>:
{
    800048cc:	7179                	addi	sp,sp,-48
    800048ce:	f406                	sd	ra,40(sp)
    800048d0:	f022                	sd	s0,32(sp)
    800048d2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d4:	fe840613          	addi	a2,s0,-24
    800048d8:	4581                	li	a1,0
    800048da:	4501                	li	a0,0
    800048dc:	00000097          	auipc	ra,0x0
    800048e0:	d8c080e7          	jalr	-628(ra) # 80004668 <argfd>
    return -1;
    800048e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e6:	04054163          	bltz	a0,80004928 <sys_read+0x5c>
    800048ea:	fe440593          	addi	a1,s0,-28
    800048ee:	4509                	li	a0,2
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	7da080e7          	jalr	2010(ra) # 800020ca <argint>
    return -1;
    800048f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048fa:	02054763          	bltz	a0,80004928 <sys_read+0x5c>
    800048fe:	fd840593          	addi	a1,s0,-40
    80004902:	4505                	li	a0,1
    80004904:	ffffd097          	auipc	ra,0xffffd
    80004908:	7e8080e7          	jalr	2024(ra) # 800020ec <argaddr>
    return -1;
    8000490c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000490e:	00054d63          	bltz	a0,80004928 <sys_read+0x5c>
  return fileread(f, p, n);
    80004912:	fe442603          	lw	a2,-28(s0)
    80004916:	fd843583          	ld	a1,-40(s0)
    8000491a:	fe843503          	ld	a0,-24(s0)
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	40a080e7          	jalr	1034(ra) # 80003d28 <fileread>
    80004926:	87aa                	mv	a5,a0
}
    80004928:	853e                	mv	a0,a5
    8000492a:	70a2                	ld	ra,40(sp)
    8000492c:	7402                	ld	s0,32(sp)
    8000492e:	6145                	addi	sp,sp,48
    80004930:	8082                	ret

0000000080004932 <sys_write>:
{
    80004932:	7179                	addi	sp,sp,-48
    80004934:	f406                	sd	ra,40(sp)
    80004936:	f022                	sd	s0,32(sp)
    80004938:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493a:	fe840613          	addi	a2,s0,-24
    8000493e:	4581                	li	a1,0
    80004940:	4501                	li	a0,0
    80004942:	00000097          	auipc	ra,0x0
    80004946:	d26080e7          	jalr	-730(ra) # 80004668 <argfd>
    return -1;
    8000494a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000494c:	04054163          	bltz	a0,8000498e <sys_write+0x5c>
    80004950:	fe440593          	addi	a1,s0,-28
    80004954:	4509                	li	a0,2
    80004956:	ffffd097          	auipc	ra,0xffffd
    8000495a:	774080e7          	jalr	1908(ra) # 800020ca <argint>
    return -1;
    8000495e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004960:	02054763          	bltz	a0,8000498e <sys_write+0x5c>
    80004964:	fd840593          	addi	a1,s0,-40
    80004968:	4505                	li	a0,1
    8000496a:	ffffd097          	auipc	ra,0xffffd
    8000496e:	782080e7          	jalr	1922(ra) # 800020ec <argaddr>
    return -1;
    80004972:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004974:	00054d63          	bltz	a0,8000498e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004978:	fe442603          	lw	a2,-28(s0)
    8000497c:	fd843583          	ld	a1,-40(s0)
    80004980:	fe843503          	ld	a0,-24(s0)
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	476080e7          	jalr	1142(ra) # 80003dfa <filewrite>
    8000498c:	87aa                	mv	a5,a0
}
    8000498e:	853e                	mv	a0,a5
    80004990:	70a2                	ld	ra,40(sp)
    80004992:	7402                	ld	s0,32(sp)
    80004994:	6145                	addi	sp,sp,48
    80004996:	8082                	ret

0000000080004998 <sys_close>:
{
    80004998:	1101                	addi	sp,sp,-32
    8000499a:	ec06                	sd	ra,24(sp)
    8000499c:	e822                	sd	s0,16(sp)
    8000499e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049a0:	fe040613          	addi	a2,s0,-32
    800049a4:	fec40593          	addi	a1,s0,-20
    800049a8:	4501                	li	a0,0
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	cbe080e7          	jalr	-834(ra) # 80004668 <argfd>
    return -1;
    800049b2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049b4:	02054463          	bltz	a0,800049dc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049b8:	ffffc097          	auipc	ra,0xffffc
    800049bc:	5a8080e7          	jalr	1448(ra) # 80000f60 <myproc>
    800049c0:	fec42783          	lw	a5,-20(s0)
    800049c4:	07e9                	addi	a5,a5,26
    800049c6:	078e                	slli	a5,a5,0x3
    800049c8:	953e                	add	a0,a0,a5
    800049ca:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800049ce:	fe043503          	ld	a0,-32(s0)
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	202080e7          	jalr	514(ra) # 80003bd4 <fileclose>
  return 0;
    800049da:	4781                	li	a5,0
}
    800049dc:	853e                	mv	a0,a5
    800049de:	60e2                	ld	ra,24(sp)
    800049e0:	6442                	ld	s0,16(sp)
    800049e2:	6105                	addi	sp,sp,32
    800049e4:	8082                	ret

00000000800049e6 <sys_fstat>:
{
    800049e6:	1101                	addi	sp,sp,-32
    800049e8:	ec06                	sd	ra,24(sp)
    800049ea:	e822                	sd	s0,16(sp)
    800049ec:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049ee:	fe840613          	addi	a2,s0,-24
    800049f2:	4581                	li	a1,0
    800049f4:	4501                	li	a0,0
    800049f6:	00000097          	auipc	ra,0x0
    800049fa:	c72080e7          	jalr	-910(ra) # 80004668 <argfd>
    return -1;
    800049fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a00:	02054563          	bltz	a0,80004a2a <sys_fstat+0x44>
    80004a04:	fe040593          	addi	a1,s0,-32
    80004a08:	4505                	li	a0,1
    80004a0a:	ffffd097          	auipc	ra,0xffffd
    80004a0e:	6e2080e7          	jalr	1762(ra) # 800020ec <argaddr>
    return -1;
    80004a12:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a14:	00054b63          	bltz	a0,80004a2a <sys_fstat+0x44>
  return filestat(f, st);
    80004a18:	fe043583          	ld	a1,-32(s0)
    80004a1c:	fe843503          	ld	a0,-24(s0)
    80004a20:	fffff097          	auipc	ra,0xfffff
    80004a24:	296080e7          	jalr	662(ra) # 80003cb6 <filestat>
    80004a28:	87aa                	mv	a5,a0
}
    80004a2a:	853e                	mv	a0,a5
    80004a2c:	60e2                	ld	ra,24(sp)
    80004a2e:	6442                	ld	s0,16(sp)
    80004a30:	6105                	addi	sp,sp,32
    80004a32:	8082                	ret

0000000080004a34 <sys_link>:
{
    80004a34:	7169                	addi	sp,sp,-304
    80004a36:	f606                	sd	ra,296(sp)
    80004a38:	f222                	sd	s0,288(sp)
    80004a3a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a3c:	08000613          	li	a2,128
    80004a40:	ed040593          	addi	a1,s0,-304
    80004a44:	4501                	li	a0,0
    80004a46:	ffffd097          	auipc	ra,0xffffd
    80004a4a:	6c8080e7          	jalr	1736(ra) # 8000210e <argstr>
    return -1;
    80004a4e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a50:	12054663          	bltz	a0,80004b7c <sys_link+0x148>
    80004a54:	08000613          	li	a2,128
    80004a58:	f5040593          	addi	a1,s0,-176
    80004a5c:	4505                	li	a0,1
    80004a5e:	ffffd097          	auipc	ra,0xffffd
    80004a62:	6b0080e7          	jalr	1712(ra) # 8000210e <argstr>
    return -1;
    80004a66:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a68:	10054a63          	bltz	a0,80004b7c <sys_link+0x148>
    80004a6c:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	c9c080e7          	jalr	-868(ra) # 8000370a <begin_op>
  if((ip = namei(old)) == 0){
    80004a76:	ed040513          	addi	a0,s0,-304
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	a90080e7          	jalr	-1392(ra) # 8000350a <namei>
    80004a82:	84aa                	mv	s1,a0
    80004a84:	c949                	beqz	a0,80004b16 <sys_link+0xe2>
  ilock(ip);
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	2b2080e7          	jalr	690(ra) # 80002d38 <ilock>
  if(ip->type == T_DIR){
    80004a8e:	04449703          	lh	a4,68(s1)
    80004a92:	4785                	li	a5,1
    80004a94:	08f70863          	beq	a4,a5,80004b24 <sys_link+0xf0>
    80004a98:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a9a:	04a4d783          	lhu	a5,74(s1)
    80004a9e:	2785                	addiw	a5,a5,1
    80004aa0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aa4:	8526                	mv	a0,s1
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	1c6080e7          	jalr	454(ra) # 80002c6c <iupdate>
  iunlock(ip);
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	34e080e7          	jalr	846(ra) # 80002dfe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ab8:	fd040593          	addi	a1,s0,-48
    80004abc:	f5040513          	addi	a0,s0,-176
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	a68080e7          	jalr	-1432(ra) # 80003528 <nameiparent>
    80004ac8:	892a                	mv	s2,a0
    80004aca:	cd35                	beqz	a0,80004b46 <sys_link+0x112>
  ilock(dp);
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	26c080e7          	jalr	620(ra) # 80002d38 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ad4:	00092703          	lw	a4,0(s2)
    80004ad8:	409c                	lw	a5,0(s1)
    80004ada:	06f71163          	bne	a4,a5,80004b3c <sys_link+0x108>
    80004ade:	40d0                	lw	a2,4(s1)
    80004ae0:	fd040593          	addi	a1,s0,-48
    80004ae4:	854a                	mv	a0,s2
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	962080e7          	jalr	-1694(ra) # 80003448 <dirlink>
    80004aee:	04054763          	bltz	a0,80004b3c <sys_link+0x108>
  iunlockput(dp);
    80004af2:	854a                	mv	a0,s2
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	4aa080e7          	jalr	1194(ra) # 80002f9e <iunlockput>
  iput(ip);
    80004afc:	8526                	mv	a0,s1
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	3f8080e7          	jalr	1016(ra) # 80002ef6 <iput>
  end_op();
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	c7e080e7          	jalr	-898(ra) # 80003784 <end_op>
  return 0;
    80004b0e:	4781                	li	a5,0
    80004b10:	64f2                	ld	s1,280(sp)
    80004b12:	6952                	ld	s2,272(sp)
    80004b14:	a0a5                	j	80004b7c <sys_link+0x148>
    end_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	c6e080e7          	jalr	-914(ra) # 80003784 <end_op>
    return -1;
    80004b1e:	57fd                	li	a5,-1
    80004b20:	64f2                	ld	s1,280(sp)
    80004b22:	a8a9                	j	80004b7c <sys_link+0x148>
    iunlockput(ip);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	478080e7          	jalr	1144(ra) # 80002f9e <iunlockput>
    end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	c56080e7          	jalr	-938(ra) # 80003784 <end_op>
    return -1;
    80004b36:	57fd                	li	a5,-1
    80004b38:	64f2                	ld	s1,280(sp)
    80004b3a:	a089                	j	80004b7c <sys_link+0x148>
    iunlockput(dp);
    80004b3c:	854a                	mv	a0,s2
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	460080e7          	jalr	1120(ra) # 80002f9e <iunlockput>
  ilock(ip);
    80004b46:	8526                	mv	a0,s1
    80004b48:	ffffe097          	auipc	ra,0xffffe
    80004b4c:	1f0080e7          	jalr	496(ra) # 80002d38 <ilock>
  ip->nlink--;
    80004b50:	04a4d783          	lhu	a5,74(s1)
    80004b54:	37fd                	addiw	a5,a5,-1
    80004b56:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b5a:	8526                	mv	a0,s1
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	110080e7          	jalr	272(ra) # 80002c6c <iupdate>
  iunlockput(ip);
    80004b64:	8526                	mv	a0,s1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	438080e7          	jalr	1080(ra) # 80002f9e <iunlockput>
  end_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	c16080e7          	jalr	-1002(ra) # 80003784 <end_op>
  return -1;
    80004b76:	57fd                	li	a5,-1
    80004b78:	64f2                	ld	s1,280(sp)
    80004b7a:	6952                	ld	s2,272(sp)
}
    80004b7c:	853e                	mv	a0,a5
    80004b7e:	70b2                	ld	ra,296(sp)
    80004b80:	7412                	ld	s0,288(sp)
    80004b82:	6155                	addi	sp,sp,304
    80004b84:	8082                	ret

0000000080004b86 <sys_unlink>:
{
    80004b86:	7151                	addi	sp,sp,-240
    80004b88:	f586                	sd	ra,232(sp)
    80004b8a:	f1a2                	sd	s0,224(sp)
    80004b8c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b8e:	08000613          	li	a2,128
    80004b92:	f3040593          	addi	a1,s0,-208
    80004b96:	4501                	li	a0,0
    80004b98:	ffffd097          	auipc	ra,0xffffd
    80004b9c:	576080e7          	jalr	1398(ra) # 8000210e <argstr>
    80004ba0:	1a054a63          	bltz	a0,80004d54 <sys_unlink+0x1ce>
    80004ba4:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	b64080e7          	jalr	-1180(ra) # 8000370a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bae:	fb040593          	addi	a1,s0,-80
    80004bb2:	f3040513          	addi	a0,s0,-208
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	972080e7          	jalr	-1678(ra) # 80003528 <nameiparent>
    80004bbe:	84aa                	mv	s1,a0
    80004bc0:	cd71                	beqz	a0,80004c9c <sys_unlink+0x116>
  ilock(dp);
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	176080e7          	jalr	374(ra) # 80002d38 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bca:	00004597          	auipc	a1,0x4
    80004bce:	9ee58593          	addi	a1,a1,-1554 # 800085b8 <etext+0x5b8>
    80004bd2:	fb040513          	addi	a0,s0,-80
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	648080e7          	jalr	1608(ra) # 8000321e <namecmp>
    80004bde:	14050c63          	beqz	a0,80004d36 <sys_unlink+0x1b0>
    80004be2:	00003597          	auipc	a1,0x3
    80004be6:	58658593          	addi	a1,a1,1414 # 80008168 <etext+0x168>
    80004bea:	fb040513          	addi	a0,s0,-80
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	630080e7          	jalr	1584(ra) # 8000321e <namecmp>
    80004bf6:	14050063          	beqz	a0,80004d36 <sys_unlink+0x1b0>
    80004bfa:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bfc:	f2c40613          	addi	a2,s0,-212
    80004c00:	fb040593          	addi	a1,s0,-80
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	632080e7          	jalr	1586(ra) # 80003238 <dirlookup>
    80004c0e:	892a                	mv	s2,a0
    80004c10:	12050263          	beqz	a0,80004d34 <sys_unlink+0x1ae>
  ilock(ip);
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	124080e7          	jalr	292(ra) # 80002d38 <ilock>
  if(ip->nlink < 1)
    80004c1c:	04a91783          	lh	a5,74(s2)
    80004c20:	08f05563          	blez	a5,80004caa <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c24:	04491703          	lh	a4,68(s2)
    80004c28:	4785                	li	a5,1
    80004c2a:	08f70963          	beq	a4,a5,80004cbc <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004c2e:	4641                	li	a2,16
    80004c30:	4581                	li	a1,0
    80004c32:	fc040513          	addi	a0,s0,-64
    80004c36:	ffffb097          	auipc	ra,0xffffb
    80004c3a:	544080e7          	jalr	1348(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c3e:	4741                	li	a4,16
    80004c40:	f2c42683          	lw	a3,-212(s0)
    80004c44:	fc040613          	addi	a2,s0,-64
    80004c48:	4581                	li	a1,0
    80004c4a:	8526                	mv	a0,s1
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	4a8080e7          	jalr	1192(ra) # 800030f4 <writei>
    80004c54:	47c1                	li	a5,16
    80004c56:	0af51b63          	bne	a0,a5,80004d0c <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004c5a:	04491703          	lh	a4,68(s2)
    80004c5e:	4785                	li	a5,1
    80004c60:	0af70f63          	beq	a4,a5,80004d1e <sys_unlink+0x198>
  iunlockput(dp);
    80004c64:	8526                	mv	a0,s1
    80004c66:	ffffe097          	auipc	ra,0xffffe
    80004c6a:	338080e7          	jalr	824(ra) # 80002f9e <iunlockput>
  ip->nlink--;
    80004c6e:	04a95783          	lhu	a5,74(s2)
    80004c72:	37fd                	addiw	a5,a5,-1
    80004c74:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	ff2080e7          	jalr	-14(ra) # 80002c6c <iupdate>
  iunlockput(ip);
    80004c82:	854a                	mv	a0,s2
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	31a080e7          	jalr	794(ra) # 80002f9e <iunlockput>
  end_op();
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	af8080e7          	jalr	-1288(ra) # 80003784 <end_op>
  return 0;
    80004c94:	4501                	li	a0,0
    80004c96:	64ee                	ld	s1,216(sp)
    80004c98:	694e                	ld	s2,208(sp)
    80004c9a:	a84d                	j	80004d4c <sys_unlink+0x1c6>
    end_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	ae8080e7          	jalr	-1304(ra) # 80003784 <end_op>
    return -1;
    80004ca4:	557d                	li	a0,-1
    80004ca6:	64ee                	ld	s1,216(sp)
    80004ca8:	a055                	j	80004d4c <sys_unlink+0x1c6>
    80004caa:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004cac:	00004517          	auipc	a0,0x4
    80004cb0:	93450513          	addi	a0,a0,-1740 # 800085e0 <etext+0x5e0>
    80004cb4:	00001097          	auipc	ra,0x1
    80004cb8:	208080e7          	jalr	520(ra) # 80005ebc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cbc:	04c92703          	lw	a4,76(s2)
    80004cc0:	02000793          	li	a5,32
    80004cc4:	f6e7f5e3          	bgeu	a5,a4,80004c2e <sys_unlink+0xa8>
    80004cc8:	e5ce                	sd	s3,200(sp)
    80004cca:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cce:	4741                	li	a4,16
    80004cd0:	86ce                	mv	a3,s3
    80004cd2:	f1840613          	addi	a2,s0,-232
    80004cd6:	4581                	li	a1,0
    80004cd8:	854a                	mv	a0,s2
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	316080e7          	jalr	790(ra) # 80002ff0 <readi>
    80004ce2:	47c1                	li	a5,16
    80004ce4:	00f51c63          	bne	a0,a5,80004cfc <sys_unlink+0x176>
    if(de.inum != 0)
    80004ce8:	f1845783          	lhu	a5,-232(s0)
    80004cec:	e7b5                	bnez	a5,80004d58 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cee:	29c1                	addiw	s3,s3,16
    80004cf0:	04c92783          	lw	a5,76(s2)
    80004cf4:	fcf9ede3          	bltu	s3,a5,80004cce <sys_unlink+0x148>
    80004cf8:	69ae                	ld	s3,200(sp)
    80004cfa:	bf15                	j	80004c2e <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004cfc:	00004517          	auipc	a0,0x4
    80004d00:	8fc50513          	addi	a0,a0,-1796 # 800085f8 <etext+0x5f8>
    80004d04:	00001097          	auipc	ra,0x1
    80004d08:	1b8080e7          	jalr	440(ra) # 80005ebc <panic>
    80004d0c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d0e:	00004517          	auipc	a0,0x4
    80004d12:	90250513          	addi	a0,a0,-1790 # 80008610 <etext+0x610>
    80004d16:	00001097          	auipc	ra,0x1
    80004d1a:	1a6080e7          	jalr	422(ra) # 80005ebc <panic>
    dp->nlink--;
    80004d1e:	04a4d783          	lhu	a5,74(s1)
    80004d22:	37fd                	addiw	a5,a5,-1
    80004d24:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d28:	8526                	mv	a0,s1
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	f42080e7          	jalr	-190(ra) # 80002c6c <iupdate>
    80004d32:	bf0d                	j	80004c64 <sys_unlink+0xde>
    80004d34:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d36:	8526                	mv	a0,s1
    80004d38:	ffffe097          	auipc	ra,0xffffe
    80004d3c:	266080e7          	jalr	614(ra) # 80002f9e <iunlockput>
  end_op();
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	a44080e7          	jalr	-1468(ra) # 80003784 <end_op>
  return -1;
    80004d48:	557d                	li	a0,-1
    80004d4a:	64ee                	ld	s1,216(sp)
}
    80004d4c:	70ae                	ld	ra,232(sp)
    80004d4e:	740e                	ld	s0,224(sp)
    80004d50:	616d                	addi	sp,sp,240
    80004d52:	8082                	ret
    return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	bfdd                	j	80004d4c <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d58:	854a                	mv	a0,s2
    80004d5a:	ffffe097          	auipc	ra,0xffffe
    80004d5e:	244080e7          	jalr	580(ra) # 80002f9e <iunlockput>
    goto bad;
    80004d62:	694e                	ld	s2,208(sp)
    80004d64:	69ae                	ld	s3,200(sp)
    80004d66:	bfc1                	j	80004d36 <sys_unlink+0x1b0>

0000000080004d68 <sys_open>:

uint64
sys_open(void)
{
    80004d68:	7131                	addi	sp,sp,-192
    80004d6a:	fd06                	sd	ra,184(sp)
    80004d6c:	f922                	sd	s0,176(sp)
    80004d6e:	f526                	sd	s1,168(sp)
    80004d70:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d72:	08000613          	li	a2,128
    80004d76:	f5040593          	addi	a1,s0,-176
    80004d7a:	4501                	li	a0,0
    80004d7c:	ffffd097          	auipc	ra,0xffffd
    80004d80:	392080e7          	jalr	914(ra) # 8000210e <argstr>
    return -1;
    80004d84:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d86:	0c054463          	bltz	a0,80004e4e <sys_open+0xe6>
    80004d8a:	f4c40593          	addi	a1,s0,-180
    80004d8e:	4505                	li	a0,1
    80004d90:	ffffd097          	auipc	ra,0xffffd
    80004d94:	33a080e7          	jalr	826(ra) # 800020ca <argint>
    80004d98:	0a054b63          	bltz	a0,80004e4e <sys_open+0xe6>
    80004d9c:	f14a                	sd	s2,160(sp)

  begin_op();
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	96c080e7          	jalr	-1684(ra) # 8000370a <begin_op>

  if(omode & O_CREATE){
    80004da6:	f4c42783          	lw	a5,-180(s0)
    80004daa:	2007f793          	andi	a5,a5,512
    80004dae:	cfc5                	beqz	a5,80004e66 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004db0:	4681                	li	a3,0
    80004db2:	4601                	li	a2,0
    80004db4:	4589                	li	a1,2
    80004db6:	f5040513          	addi	a0,s0,-176
    80004dba:	00000097          	auipc	ra,0x0
    80004dbe:	958080e7          	jalr	-1704(ra) # 80004712 <create>
    80004dc2:	892a                	mv	s2,a0
    if(ip == 0){
    80004dc4:	c959                	beqz	a0,80004e5a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004dc6:	04491703          	lh	a4,68(s2)
    80004dca:	478d                	li	a5,3
    80004dcc:	00f71763          	bne	a4,a5,80004dda <sys_open+0x72>
    80004dd0:	04695703          	lhu	a4,70(s2)
    80004dd4:	47a5                	li	a5,9
    80004dd6:	0ce7ef63          	bltu	a5,a4,80004eb4 <sys_open+0x14c>
    80004dda:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	d3c080e7          	jalr	-708(ra) # 80003b18 <filealloc>
    80004de4:	89aa                	mv	s3,a0
    80004de6:	c965                	beqz	a0,80004ed6 <sys_open+0x16e>
    80004de8:	00000097          	auipc	ra,0x0
    80004dec:	8e8080e7          	jalr	-1816(ra) # 800046d0 <fdalloc>
    80004df0:	84aa                	mv	s1,a0
    80004df2:	0c054d63          	bltz	a0,80004ecc <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004df6:	04491703          	lh	a4,68(s2)
    80004dfa:	478d                	li	a5,3
    80004dfc:	0ef70a63          	beq	a4,a5,80004ef0 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e00:	4789                	li	a5,2
    80004e02:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e06:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e0a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e0e:	f4c42783          	lw	a5,-180(s0)
    80004e12:	0017c713          	xori	a4,a5,1
    80004e16:	8b05                	andi	a4,a4,1
    80004e18:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e1c:	0037f713          	andi	a4,a5,3
    80004e20:	00e03733          	snez	a4,a4
    80004e24:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e28:	4007f793          	andi	a5,a5,1024
    80004e2c:	c791                	beqz	a5,80004e38 <sys_open+0xd0>
    80004e2e:	04491703          	lh	a4,68(s2)
    80004e32:	4789                	li	a5,2
    80004e34:	0cf70563          	beq	a4,a5,80004efe <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004e38:	854a                	mv	a0,s2
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	fc4080e7          	jalr	-60(ra) # 80002dfe <iunlock>
  end_op();
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	942080e7          	jalr	-1726(ra) # 80003784 <end_op>
    80004e4a:	790a                	ld	s2,160(sp)
    80004e4c:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e4e:	8526                	mv	a0,s1
    80004e50:	70ea                	ld	ra,184(sp)
    80004e52:	744a                	ld	s0,176(sp)
    80004e54:	74aa                	ld	s1,168(sp)
    80004e56:	6129                	addi	sp,sp,192
    80004e58:	8082                	ret
      end_op();
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	92a080e7          	jalr	-1750(ra) # 80003784 <end_op>
      return -1;
    80004e62:	790a                	ld	s2,160(sp)
    80004e64:	b7ed                	j	80004e4e <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004e66:	f5040513          	addi	a0,s0,-176
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	6a0080e7          	jalr	1696(ra) # 8000350a <namei>
    80004e72:	892a                	mv	s2,a0
    80004e74:	c90d                	beqz	a0,80004ea6 <sys_open+0x13e>
    ilock(ip);
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	ec2080e7          	jalr	-318(ra) # 80002d38 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e7e:	04491703          	lh	a4,68(s2)
    80004e82:	4785                	li	a5,1
    80004e84:	f4f711e3          	bne	a4,a5,80004dc6 <sys_open+0x5e>
    80004e88:	f4c42783          	lw	a5,-180(s0)
    80004e8c:	d7b9                	beqz	a5,80004dda <sys_open+0x72>
      iunlockput(ip);
    80004e8e:	854a                	mv	a0,s2
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	10e080e7          	jalr	270(ra) # 80002f9e <iunlockput>
      end_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	8ec080e7          	jalr	-1812(ra) # 80003784 <end_op>
      return -1;
    80004ea0:	54fd                	li	s1,-1
    80004ea2:	790a                	ld	s2,160(sp)
    80004ea4:	b76d                	j	80004e4e <sys_open+0xe6>
      end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	8de080e7          	jalr	-1826(ra) # 80003784 <end_op>
      return -1;
    80004eae:	54fd                	li	s1,-1
    80004eb0:	790a                	ld	s2,160(sp)
    80004eb2:	bf71                	j	80004e4e <sys_open+0xe6>
    iunlockput(ip);
    80004eb4:	854a                	mv	a0,s2
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	0e8080e7          	jalr	232(ra) # 80002f9e <iunlockput>
    end_op();
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	8c6080e7          	jalr	-1850(ra) # 80003784 <end_op>
    return -1;
    80004ec6:	54fd                	li	s1,-1
    80004ec8:	790a                	ld	s2,160(sp)
    80004eca:	b751                	j	80004e4e <sys_open+0xe6>
      fileclose(f);
    80004ecc:	854e                	mv	a0,s3
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	d06080e7          	jalr	-762(ra) # 80003bd4 <fileclose>
    iunlockput(ip);
    80004ed6:	854a                	mv	a0,s2
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	0c6080e7          	jalr	198(ra) # 80002f9e <iunlockput>
    end_op();
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	8a4080e7          	jalr	-1884(ra) # 80003784 <end_op>
    return -1;
    80004ee8:	54fd                	li	s1,-1
    80004eea:	790a                	ld	s2,160(sp)
    80004eec:	69ea                	ld	s3,152(sp)
    80004eee:	b785                	j	80004e4e <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004ef0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ef4:	04691783          	lh	a5,70(s2)
    80004ef8:	02f99223          	sh	a5,36(s3)
    80004efc:	b739                	j	80004e0a <sys_open+0xa2>
    itrunc(ip);
    80004efe:	854a                	mv	a0,s2
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	f4a080e7          	jalr	-182(ra) # 80002e4a <itrunc>
    80004f08:	bf05                	j	80004e38 <sys_open+0xd0>

0000000080004f0a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f0a:	7175                	addi	sp,sp,-144
    80004f0c:	e506                	sd	ra,136(sp)
    80004f0e:	e122                	sd	s0,128(sp)
    80004f10:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	7f8080e7          	jalr	2040(ra) # 8000370a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f1a:	08000613          	li	a2,128
    80004f1e:	f7040593          	addi	a1,s0,-144
    80004f22:	4501                	li	a0,0
    80004f24:	ffffd097          	auipc	ra,0xffffd
    80004f28:	1ea080e7          	jalr	490(ra) # 8000210e <argstr>
    80004f2c:	02054963          	bltz	a0,80004f5e <sys_mkdir+0x54>
    80004f30:	4681                	li	a3,0
    80004f32:	4601                	li	a2,0
    80004f34:	4585                	li	a1,1
    80004f36:	f7040513          	addi	a0,s0,-144
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	7d8080e7          	jalr	2008(ra) # 80004712 <create>
    80004f42:	cd11                	beqz	a0,80004f5e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	05a080e7          	jalr	90(ra) # 80002f9e <iunlockput>
  end_op();
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	838080e7          	jalr	-1992(ra) # 80003784 <end_op>
  return 0;
    80004f54:	4501                	li	a0,0
}
    80004f56:	60aa                	ld	ra,136(sp)
    80004f58:	640a                	ld	s0,128(sp)
    80004f5a:	6149                	addi	sp,sp,144
    80004f5c:	8082                	ret
    end_op();
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	826080e7          	jalr	-2010(ra) # 80003784 <end_op>
    return -1;
    80004f66:	557d                	li	a0,-1
    80004f68:	b7fd                	j	80004f56 <sys_mkdir+0x4c>

0000000080004f6a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f6a:	7135                	addi	sp,sp,-160
    80004f6c:	ed06                	sd	ra,152(sp)
    80004f6e:	e922                	sd	s0,144(sp)
    80004f70:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f72:	ffffe097          	auipc	ra,0xffffe
    80004f76:	798080e7          	jalr	1944(ra) # 8000370a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f7a:	08000613          	li	a2,128
    80004f7e:	f7040593          	addi	a1,s0,-144
    80004f82:	4501                	li	a0,0
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	18a080e7          	jalr	394(ra) # 8000210e <argstr>
    80004f8c:	04054a63          	bltz	a0,80004fe0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f90:	f6c40593          	addi	a1,s0,-148
    80004f94:	4505                	li	a0,1
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	134080e7          	jalr	308(ra) # 800020ca <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f9e:	04054163          	bltz	a0,80004fe0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004fa2:	f6840593          	addi	a1,s0,-152
    80004fa6:	4509                	li	a0,2
    80004fa8:	ffffd097          	auipc	ra,0xffffd
    80004fac:	122080e7          	jalr	290(ra) # 800020ca <argint>
     argint(1, &major) < 0 ||
    80004fb0:	02054863          	bltz	a0,80004fe0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fb4:	f6841683          	lh	a3,-152(s0)
    80004fb8:	f6c41603          	lh	a2,-148(s0)
    80004fbc:	458d                	li	a1,3
    80004fbe:	f7040513          	addi	a0,s0,-144
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	750080e7          	jalr	1872(ra) # 80004712 <create>
     argint(2, &minor) < 0 ||
    80004fca:	c919                	beqz	a0,80004fe0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fcc:	ffffe097          	auipc	ra,0xffffe
    80004fd0:	fd2080e7          	jalr	-46(ra) # 80002f9e <iunlockput>
  end_op();
    80004fd4:	ffffe097          	auipc	ra,0xffffe
    80004fd8:	7b0080e7          	jalr	1968(ra) # 80003784 <end_op>
  return 0;
    80004fdc:	4501                	li	a0,0
    80004fde:	a031                	j	80004fea <sys_mknod+0x80>
    end_op();
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	7a4080e7          	jalr	1956(ra) # 80003784 <end_op>
    return -1;
    80004fe8:	557d                	li	a0,-1
}
    80004fea:	60ea                	ld	ra,152(sp)
    80004fec:	644a                	ld	s0,144(sp)
    80004fee:	610d                	addi	sp,sp,160
    80004ff0:	8082                	ret

0000000080004ff2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ff2:	7135                	addi	sp,sp,-160
    80004ff4:	ed06                	sd	ra,152(sp)
    80004ff6:	e922                	sd	s0,144(sp)
    80004ff8:	e14a                	sd	s2,128(sp)
    80004ffa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ffc:	ffffc097          	auipc	ra,0xffffc
    80005000:	f64080e7          	jalr	-156(ra) # 80000f60 <myproc>
    80005004:	892a                	mv	s2,a0
  
  begin_op();
    80005006:	ffffe097          	auipc	ra,0xffffe
    8000500a:	704080e7          	jalr	1796(ra) # 8000370a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000500e:	08000613          	li	a2,128
    80005012:	f6040593          	addi	a1,s0,-160
    80005016:	4501                	li	a0,0
    80005018:	ffffd097          	auipc	ra,0xffffd
    8000501c:	0f6080e7          	jalr	246(ra) # 8000210e <argstr>
    80005020:	04054d63          	bltz	a0,8000507a <sys_chdir+0x88>
    80005024:	e526                	sd	s1,136(sp)
    80005026:	f6040513          	addi	a0,s0,-160
    8000502a:	ffffe097          	auipc	ra,0xffffe
    8000502e:	4e0080e7          	jalr	1248(ra) # 8000350a <namei>
    80005032:	84aa                	mv	s1,a0
    80005034:	c131                	beqz	a0,80005078 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005036:	ffffe097          	auipc	ra,0xffffe
    8000503a:	d02080e7          	jalr	-766(ra) # 80002d38 <ilock>
  if(ip->type != T_DIR){
    8000503e:	04449703          	lh	a4,68(s1)
    80005042:	4785                	li	a5,1
    80005044:	04f71163          	bne	a4,a5,80005086 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005048:	8526                	mv	a0,s1
    8000504a:	ffffe097          	auipc	ra,0xffffe
    8000504e:	db4080e7          	jalr	-588(ra) # 80002dfe <iunlock>
  iput(p->cwd);
    80005052:	15893503          	ld	a0,344(s2)
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	ea0080e7          	jalr	-352(ra) # 80002ef6 <iput>
  end_op();
    8000505e:	ffffe097          	auipc	ra,0xffffe
    80005062:	726080e7          	jalr	1830(ra) # 80003784 <end_op>
  p->cwd = ip;
    80005066:	14993c23          	sd	s1,344(s2)
  return 0;
    8000506a:	4501                	li	a0,0
    8000506c:	64aa                	ld	s1,136(sp)
}
    8000506e:	60ea                	ld	ra,152(sp)
    80005070:	644a                	ld	s0,144(sp)
    80005072:	690a                	ld	s2,128(sp)
    80005074:	610d                	addi	sp,sp,160
    80005076:	8082                	ret
    80005078:	64aa                	ld	s1,136(sp)
    end_op();
    8000507a:	ffffe097          	auipc	ra,0xffffe
    8000507e:	70a080e7          	jalr	1802(ra) # 80003784 <end_op>
    return -1;
    80005082:	557d                	li	a0,-1
    80005084:	b7ed                	j	8000506e <sys_chdir+0x7c>
    iunlockput(ip);
    80005086:	8526                	mv	a0,s1
    80005088:	ffffe097          	auipc	ra,0xffffe
    8000508c:	f16080e7          	jalr	-234(ra) # 80002f9e <iunlockput>
    end_op();
    80005090:	ffffe097          	auipc	ra,0xffffe
    80005094:	6f4080e7          	jalr	1780(ra) # 80003784 <end_op>
    return -1;
    80005098:	557d                	li	a0,-1
    8000509a:	64aa                	ld	s1,136(sp)
    8000509c:	bfc9                	j	8000506e <sys_chdir+0x7c>

000000008000509e <sys_exec>:

uint64
sys_exec(void)
{
    8000509e:	7121                	addi	sp,sp,-448
    800050a0:	ff06                	sd	ra,440(sp)
    800050a2:	fb22                	sd	s0,432(sp)
    800050a4:	f34a                	sd	s2,416(sp)
    800050a6:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050a8:	08000613          	li	a2,128
    800050ac:	f5040593          	addi	a1,s0,-176
    800050b0:	4501                	li	a0,0
    800050b2:	ffffd097          	auipc	ra,0xffffd
    800050b6:	05c080e7          	jalr	92(ra) # 8000210e <argstr>
    return -1;
    800050ba:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050bc:	0e054a63          	bltz	a0,800051b0 <sys_exec+0x112>
    800050c0:	e4840593          	addi	a1,s0,-440
    800050c4:	4505                	li	a0,1
    800050c6:	ffffd097          	auipc	ra,0xffffd
    800050ca:	026080e7          	jalr	38(ra) # 800020ec <argaddr>
    800050ce:	0e054163          	bltz	a0,800051b0 <sys_exec+0x112>
    800050d2:	f726                	sd	s1,424(sp)
    800050d4:	ef4e                	sd	s3,408(sp)
    800050d6:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050d8:	10000613          	li	a2,256
    800050dc:	4581                	li	a1,0
    800050de:	e5040513          	addi	a0,s0,-432
    800050e2:	ffffb097          	auipc	ra,0xffffb
    800050e6:	098080e7          	jalr	152(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050ea:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050ee:	89a6                	mv	s3,s1
    800050f0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050f2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050f6:	00391513          	slli	a0,s2,0x3
    800050fa:	e4040593          	addi	a1,s0,-448
    800050fe:	e4843783          	ld	a5,-440(s0)
    80005102:	953e                	add	a0,a0,a5
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	f2c080e7          	jalr	-212(ra) # 80002030 <fetchaddr>
    8000510c:	02054a63          	bltz	a0,80005140 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005110:	e4043783          	ld	a5,-448(s0)
    80005114:	c7b1                	beqz	a5,80005160 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005116:	ffffb097          	auipc	ra,0xffffb
    8000511a:	004080e7          	jalr	4(ra) # 8000011a <kalloc>
    8000511e:	85aa                	mv	a1,a0
    80005120:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005124:	cd11                	beqz	a0,80005140 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005126:	6605                	lui	a2,0x1
    80005128:	e4043503          	ld	a0,-448(s0)
    8000512c:	ffffd097          	auipc	ra,0xffffd
    80005130:	f56080e7          	jalr	-170(ra) # 80002082 <fetchstr>
    80005134:	00054663          	bltz	a0,80005140 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005138:	0905                	addi	s2,s2,1
    8000513a:	09a1                	addi	s3,s3,8
    8000513c:	fb491de3          	bne	s2,s4,800050f6 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005140:	f5040913          	addi	s2,s0,-176
    80005144:	6088                	ld	a0,0(s1)
    80005146:	c12d                	beqz	a0,800051a8 <sys_exec+0x10a>
    kfree(argv[i]);
    80005148:	ffffb097          	auipc	ra,0xffffb
    8000514c:	ed4080e7          	jalr	-300(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005150:	04a1                	addi	s1,s1,8
    80005152:	ff2499e3          	bne	s1,s2,80005144 <sys_exec+0xa6>
  return -1;
    80005156:	597d                	li	s2,-1
    80005158:	74ba                	ld	s1,424(sp)
    8000515a:	69fa                	ld	s3,408(sp)
    8000515c:	6a5a                	ld	s4,400(sp)
    8000515e:	a889                	j	800051b0 <sys_exec+0x112>
      argv[i] = 0;
    80005160:	0009079b          	sext.w	a5,s2
    80005164:	078e                	slli	a5,a5,0x3
    80005166:	fd078793          	addi	a5,a5,-48
    8000516a:	97a2                	add	a5,a5,s0
    8000516c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005170:	e5040593          	addi	a1,s0,-432
    80005174:	f5040513          	addi	a0,s0,-176
    80005178:	fffff097          	auipc	ra,0xfffff
    8000517c:	10c080e7          	jalr	268(ra) # 80004284 <exec>
    80005180:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005182:	f5040993          	addi	s3,s0,-176
    80005186:	6088                	ld	a0,0(s1)
    80005188:	cd01                	beqz	a0,800051a0 <sys_exec+0x102>
    kfree(argv[i]);
    8000518a:	ffffb097          	auipc	ra,0xffffb
    8000518e:	e92080e7          	jalr	-366(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005192:	04a1                	addi	s1,s1,8
    80005194:	ff3499e3          	bne	s1,s3,80005186 <sys_exec+0xe8>
    80005198:	74ba                	ld	s1,424(sp)
    8000519a:	69fa                	ld	s3,408(sp)
    8000519c:	6a5a                	ld	s4,400(sp)
    8000519e:	a809                	j	800051b0 <sys_exec+0x112>
  return ret;
    800051a0:	74ba                	ld	s1,424(sp)
    800051a2:	69fa                	ld	s3,408(sp)
    800051a4:	6a5a                	ld	s4,400(sp)
    800051a6:	a029                	j	800051b0 <sys_exec+0x112>
  return -1;
    800051a8:	597d                	li	s2,-1
    800051aa:	74ba                	ld	s1,424(sp)
    800051ac:	69fa                	ld	s3,408(sp)
    800051ae:	6a5a                	ld	s4,400(sp)
}
    800051b0:	854a                	mv	a0,s2
    800051b2:	70fa                	ld	ra,440(sp)
    800051b4:	745a                	ld	s0,432(sp)
    800051b6:	791a                	ld	s2,416(sp)
    800051b8:	6139                	addi	sp,sp,448
    800051ba:	8082                	ret

00000000800051bc <sys_pipe>:

uint64
sys_pipe(void)
{
    800051bc:	7139                	addi	sp,sp,-64
    800051be:	fc06                	sd	ra,56(sp)
    800051c0:	f822                	sd	s0,48(sp)
    800051c2:	f426                	sd	s1,40(sp)
    800051c4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051c6:	ffffc097          	auipc	ra,0xffffc
    800051ca:	d9a080e7          	jalr	-614(ra) # 80000f60 <myproc>
    800051ce:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051d0:	fd840593          	addi	a1,s0,-40
    800051d4:	4501                	li	a0,0
    800051d6:	ffffd097          	auipc	ra,0xffffd
    800051da:	f16080e7          	jalr	-234(ra) # 800020ec <argaddr>
    return -1;
    800051de:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051e0:	0e054063          	bltz	a0,800052c0 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051e4:	fc840593          	addi	a1,s0,-56
    800051e8:	fd040513          	addi	a0,s0,-48
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	d56080e7          	jalr	-682(ra) # 80003f42 <pipealloc>
    return -1;
    800051f4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051f6:	0c054563          	bltz	a0,800052c0 <sys_pipe+0x104>
  fd0 = -1;
    800051fa:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051fe:	fd043503          	ld	a0,-48(s0)
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	4ce080e7          	jalr	1230(ra) # 800046d0 <fdalloc>
    8000520a:	fca42223          	sw	a0,-60(s0)
    8000520e:	08054c63          	bltz	a0,800052a6 <sys_pipe+0xea>
    80005212:	fc843503          	ld	a0,-56(s0)
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	4ba080e7          	jalr	1210(ra) # 800046d0 <fdalloc>
    8000521e:	fca42023          	sw	a0,-64(s0)
    80005222:	06054963          	bltz	a0,80005294 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005226:	4691                	li	a3,4
    80005228:	fc440613          	addi	a2,s0,-60
    8000522c:	fd843583          	ld	a1,-40(s0)
    80005230:	68a8                	ld	a0,80(s1)
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	8e6080e7          	jalr	-1818(ra) # 80000b18 <copyout>
    8000523a:	02054063          	bltz	a0,8000525a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000523e:	4691                	li	a3,4
    80005240:	fc040613          	addi	a2,s0,-64
    80005244:	fd843583          	ld	a1,-40(s0)
    80005248:	0591                	addi	a1,a1,4
    8000524a:	68a8                	ld	a0,80(s1)
    8000524c:	ffffc097          	auipc	ra,0xffffc
    80005250:	8cc080e7          	jalr	-1844(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005254:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005256:	06055563          	bgez	a0,800052c0 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000525a:	fc442783          	lw	a5,-60(s0)
    8000525e:	07e9                	addi	a5,a5,26
    80005260:	078e                	slli	a5,a5,0x3
    80005262:	97a6                	add	a5,a5,s1
    80005264:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005268:	fc042783          	lw	a5,-64(s0)
    8000526c:	07e9                	addi	a5,a5,26
    8000526e:	078e                	slli	a5,a5,0x3
    80005270:	00f48533          	add	a0,s1,a5
    80005274:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005278:	fd043503          	ld	a0,-48(s0)
    8000527c:	fffff097          	auipc	ra,0xfffff
    80005280:	958080e7          	jalr	-1704(ra) # 80003bd4 <fileclose>
    fileclose(wf);
    80005284:	fc843503          	ld	a0,-56(s0)
    80005288:	fffff097          	auipc	ra,0xfffff
    8000528c:	94c080e7          	jalr	-1716(ra) # 80003bd4 <fileclose>
    return -1;
    80005290:	57fd                	li	a5,-1
    80005292:	a03d                	j	800052c0 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005294:	fc442783          	lw	a5,-60(s0)
    80005298:	0007c763          	bltz	a5,800052a6 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000529c:	07e9                	addi	a5,a5,26
    8000529e:	078e                	slli	a5,a5,0x3
    800052a0:	97a6                	add	a5,a5,s1
    800052a2:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800052a6:	fd043503          	ld	a0,-48(s0)
    800052aa:	fffff097          	auipc	ra,0xfffff
    800052ae:	92a080e7          	jalr	-1750(ra) # 80003bd4 <fileclose>
    fileclose(wf);
    800052b2:	fc843503          	ld	a0,-56(s0)
    800052b6:	fffff097          	auipc	ra,0xfffff
    800052ba:	91e080e7          	jalr	-1762(ra) # 80003bd4 <fileclose>
    return -1;
    800052be:	57fd                	li	a5,-1
}
    800052c0:	853e                	mv	a0,a5
    800052c2:	70e2                	ld	ra,56(sp)
    800052c4:	7442                	ld	s0,48(sp)
    800052c6:	74a2                	ld	s1,40(sp)
    800052c8:	6121                	addi	sp,sp,64
    800052ca:	8082                	ret
    800052cc:	0000                	unimp
	...

00000000800052d0 <kernelvec>:
    800052d0:	7111                	addi	sp,sp,-256
    800052d2:	e006                	sd	ra,0(sp)
    800052d4:	e40a                	sd	sp,8(sp)
    800052d6:	e80e                	sd	gp,16(sp)
    800052d8:	ec12                	sd	tp,24(sp)
    800052da:	f016                	sd	t0,32(sp)
    800052dc:	f41a                	sd	t1,40(sp)
    800052de:	f81e                	sd	t2,48(sp)
    800052e0:	fc22                	sd	s0,56(sp)
    800052e2:	e0a6                	sd	s1,64(sp)
    800052e4:	e4aa                	sd	a0,72(sp)
    800052e6:	e8ae                	sd	a1,80(sp)
    800052e8:	ecb2                	sd	a2,88(sp)
    800052ea:	f0b6                	sd	a3,96(sp)
    800052ec:	f4ba                	sd	a4,104(sp)
    800052ee:	f8be                	sd	a5,112(sp)
    800052f0:	fcc2                	sd	a6,120(sp)
    800052f2:	e146                	sd	a7,128(sp)
    800052f4:	e54a                	sd	s2,136(sp)
    800052f6:	e94e                	sd	s3,144(sp)
    800052f8:	ed52                	sd	s4,152(sp)
    800052fa:	f156                	sd	s5,160(sp)
    800052fc:	f55a                	sd	s6,168(sp)
    800052fe:	f95e                	sd	s7,176(sp)
    80005300:	fd62                	sd	s8,184(sp)
    80005302:	e1e6                	sd	s9,192(sp)
    80005304:	e5ea                	sd	s10,200(sp)
    80005306:	e9ee                	sd	s11,208(sp)
    80005308:	edf2                	sd	t3,216(sp)
    8000530a:	f1f6                	sd	t4,224(sp)
    8000530c:	f5fa                	sd	t5,232(sp)
    8000530e:	f9fe                	sd	t6,240(sp)
    80005310:	bedfc0ef          	jal	80001efc <kerneltrap>
    80005314:	6082                	ld	ra,0(sp)
    80005316:	6122                	ld	sp,8(sp)
    80005318:	61c2                	ld	gp,16(sp)
    8000531a:	7282                	ld	t0,32(sp)
    8000531c:	7322                	ld	t1,40(sp)
    8000531e:	73c2                	ld	t2,48(sp)
    80005320:	7462                	ld	s0,56(sp)
    80005322:	6486                	ld	s1,64(sp)
    80005324:	6526                	ld	a0,72(sp)
    80005326:	65c6                	ld	a1,80(sp)
    80005328:	6666                	ld	a2,88(sp)
    8000532a:	7686                	ld	a3,96(sp)
    8000532c:	7726                	ld	a4,104(sp)
    8000532e:	77c6                	ld	a5,112(sp)
    80005330:	7866                	ld	a6,120(sp)
    80005332:	688a                	ld	a7,128(sp)
    80005334:	692a                	ld	s2,136(sp)
    80005336:	69ca                	ld	s3,144(sp)
    80005338:	6a6a                	ld	s4,152(sp)
    8000533a:	7a8a                	ld	s5,160(sp)
    8000533c:	7b2a                	ld	s6,168(sp)
    8000533e:	7bca                	ld	s7,176(sp)
    80005340:	7c6a                	ld	s8,184(sp)
    80005342:	6c8e                	ld	s9,192(sp)
    80005344:	6d2e                	ld	s10,200(sp)
    80005346:	6dce                	ld	s11,208(sp)
    80005348:	6e6e                	ld	t3,216(sp)
    8000534a:	7e8e                	ld	t4,224(sp)
    8000534c:	7f2e                	ld	t5,232(sp)
    8000534e:	7fce                	ld	t6,240(sp)
    80005350:	6111                	addi	sp,sp,256
    80005352:	10200073          	sret
    80005356:	00000013          	nop
    8000535a:	00000013          	nop
    8000535e:	0001                	nop

0000000080005360 <timervec>:
    80005360:	34051573          	csrrw	a0,mscratch,a0
    80005364:	e10c                	sd	a1,0(a0)
    80005366:	e510                	sd	a2,8(a0)
    80005368:	e914                	sd	a3,16(a0)
    8000536a:	6d0c                	ld	a1,24(a0)
    8000536c:	7110                	ld	a2,32(a0)
    8000536e:	6194                	ld	a3,0(a1)
    80005370:	96b2                	add	a3,a3,a2
    80005372:	e194                	sd	a3,0(a1)
    80005374:	4589                	li	a1,2
    80005376:	14459073          	csrw	sip,a1
    8000537a:	6914                	ld	a3,16(a0)
    8000537c:	6510                	ld	a2,8(a0)
    8000537e:	610c                	ld	a1,0(a0)
    80005380:	34051573          	csrrw	a0,mscratch,a0
    80005384:	30200073          	mret
	...

000000008000538a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000538a:	1141                	addi	sp,sp,-16
    8000538c:	e422                	sd	s0,8(sp)
    8000538e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005390:	0c0007b7          	lui	a5,0xc000
    80005394:	4705                	li	a4,1
    80005396:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005398:	0c0007b7          	lui	a5,0xc000
    8000539c:	c3d8                	sw	a4,4(a5)
}
    8000539e:	6422                	ld	s0,8(sp)
    800053a0:	0141                	addi	sp,sp,16
    800053a2:	8082                	ret

00000000800053a4 <plicinithart>:

void
plicinithart(void)
{
    800053a4:	1141                	addi	sp,sp,-16
    800053a6:	e406                	sd	ra,8(sp)
    800053a8:	e022                	sd	s0,0(sp)
    800053aa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053ac:	ffffc097          	auipc	ra,0xffffc
    800053b0:	b88080e7          	jalr	-1144(ra) # 80000f34 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053b4:	0085171b          	slliw	a4,a0,0x8
    800053b8:	0c0027b7          	lui	a5,0xc002
    800053bc:	97ba                	add	a5,a5,a4
    800053be:	40200713          	li	a4,1026
    800053c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053c6:	00d5151b          	slliw	a0,a0,0xd
    800053ca:	0c2017b7          	lui	a5,0xc201
    800053ce:	97aa                	add	a5,a5,a0
    800053d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053d4:	60a2                	ld	ra,8(sp)
    800053d6:	6402                	ld	s0,0(sp)
    800053d8:	0141                	addi	sp,sp,16
    800053da:	8082                	ret

00000000800053dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053dc:	1141                	addi	sp,sp,-16
    800053de:	e406                	sd	ra,8(sp)
    800053e0:	e022                	sd	s0,0(sp)
    800053e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053e4:	ffffc097          	auipc	ra,0xffffc
    800053e8:	b50080e7          	jalr	-1200(ra) # 80000f34 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053ec:	00d5151b          	slliw	a0,a0,0xd
    800053f0:	0c2017b7          	lui	a5,0xc201
    800053f4:	97aa                	add	a5,a5,a0
  return irq;
}
    800053f6:	43c8                	lw	a0,4(a5)
    800053f8:	60a2                	ld	ra,8(sp)
    800053fa:	6402                	ld	s0,0(sp)
    800053fc:	0141                	addi	sp,sp,16
    800053fe:	8082                	ret

0000000080005400 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005400:	1101                	addi	sp,sp,-32
    80005402:	ec06                	sd	ra,24(sp)
    80005404:	e822                	sd	s0,16(sp)
    80005406:	e426                	sd	s1,8(sp)
    80005408:	1000                	addi	s0,sp,32
    8000540a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000540c:	ffffc097          	auipc	ra,0xffffc
    80005410:	b28080e7          	jalr	-1240(ra) # 80000f34 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005414:	00d5151b          	slliw	a0,a0,0xd
    80005418:	0c2017b7          	lui	a5,0xc201
    8000541c:	97aa                	add	a5,a5,a0
    8000541e:	c3c4                	sw	s1,4(a5)
}
    80005420:	60e2                	ld	ra,24(sp)
    80005422:	6442                	ld	s0,16(sp)
    80005424:	64a2                	ld	s1,8(sp)
    80005426:	6105                	addi	sp,sp,32
    80005428:	8082                	ret

000000008000542a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000542a:	1141                	addi	sp,sp,-16
    8000542c:	e406                	sd	ra,8(sp)
    8000542e:	e022                	sd	s0,0(sp)
    80005430:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005432:	479d                	li	a5,7
    80005434:	06a7c863          	blt	a5,a0,800054a4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005438:	00019717          	auipc	a4,0x19
    8000543c:	bc870713          	addi	a4,a4,-1080 # 8001e000 <disk>
    80005440:	972a                	add	a4,a4,a0
    80005442:	6789                	lui	a5,0x2
    80005444:	97ba                	add	a5,a5,a4
    80005446:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000544a:	e7ad                	bnez	a5,800054b4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000544c:	00451793          	slli	a5,a0,0x4
    80005450:	0001b717          	auipc	a4,0x1b
    80005454:	bb070713          	addi	a4,a4,-1104 # 80020000 <disk+0x2000>
    80005458:	6314                	ld	a3,0(a4)
    8000545a:	96be                	add	a3,a3,a5
    8000545c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005460:	6314                	ld	a3,0(a4)
    80005462:	96be                	add	a3,a3,a5
    80005464:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005468:	6314                	ld	a3,0(a4)
    8000546a:	96be                	add	a3,a3,a5
    8000546c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005470:	6318                	ld	a4,0(a4)
    80005472:	97ba                	add	a5,a5,a4
    80005474:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005478:	00019717          	auipc	a4,0x19
    8000547c:	b8870713          	addi	a4,a4,-1144 # 8001e000 <disk>
    80005480:	972a                	add	a4,a4,a0
    80005482:	6789                	lui	a5,0x2
    80005484:	97ba                	add	a5,a5,a4
    80005486:	4705                	li	a4,1
    80005488:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000548c:	0001b517          	auipc	a0,0x1b
    80005490:	b8c50513          	addi	a0,a0,-1140 # 80020018 <disk+0x2018>
    80005494:	ffffc097          	auipc	ra,0xffffc
    80005498:	3c8080e7          	jalr	968(ra) # 8000185c <wakeup>
}
    8000549c:	60a2                	ld	ra,8(sp)
    8000549e:	6402                	ld	s0,0(sp)
    800054a0:	0141                	addi	sp,sp,16
    800054a2:	8082                	ret
    panic("free_desc 1");
    800054a4:	00003517          	auipc	a0,0x3
    800054a8:	17c50513          	addi	a0,a0,380 # 80008620 <etext+0x620>
    800054ac:	00001097          	auipc	ra,0x1
    800054b0:	a10080e7          	jalr	-1520(ra) # 80005ebc <panic>
    panic("free_desc 2");
    800054b4:	00003517          	auipc	a0,0x3
    800054b8:	17c50513          	addi	a0,a0,380 # 80008630 <etext+0x630>
    800054bc:	00001097          	auipc	ra,0x1
    800054c0:	a00080e7          	jalr	-1536(ra) # 80005ebc <panic>

00000000800054c4 <virtio_disk_init>:
{
    800054c4:	1141                	addi	sp,sp,-16
    800054c6:	e406                	sd	ra,8(sp)
    800054c8:	e022                	sd	s0,0(sp)
    800054ca:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054cc:	00003597          	auipc	a1,0x3
    800054d0:	17458593          	addi	a1,a1,372 # 80008640 <etext+0x640>
    800054d4:	0001b517          	auipc	a0,0x1b
    800054d8:	c5450513          	addi	a0,a0,-940 # 80020128 <disk+0x2128>
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	eca080e7          	jalr	-310(ra) # 800063a6 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054e4:	100017b7          	lui	a5,0x10001
    800054e8:	4398                	lw	a4,0(a5)
    800054ea:	2701                	sext.w	a4,a4
    800054ec:	747277b7          	lui	a5,0x74727
    800054f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054f4:	0ef71f63          	bne	a4,a5,800055f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054f8:	100017b7          	lui	a5,0x10001
    800054fc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800054fe:	439c                	lw	a5,0(a5)
    80005500:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005502:	4705                	li	a4,1
    80005504:	0ee79763          	bne	a5,a4,800055f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005508:	100017b7          	lui	a5,0x10001
    8000550c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000550e:	439c                	lw	a5,0(a5)
    80005510:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005512:	4709                	li	a4,2
    80005514:	0ce79f63          	bne	a5,a4,800055f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005518:	100017b7          	lui	a5,0x10001
    8000551c:	47d8                	lw	a4,12(a5)
    8000551e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005520:	554d47b7          	lui	a5,0x554d4
    80005524:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005528:	0cf71563          	bne	a4,a5,800055f2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000552c:	100017b7          	lui	a5,0x10001
    80005530:	4705                	li	a4,1
    80005532:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005534:	470d                	li	a4,3
    80005536:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005538:	10001737          	lui	a4,0x10001
    8000553c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000553e:	c7ffe737          	lui	a4,0xc7ffe
    80005542:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005546:	8ef9                	and	a3,a3,a4
    80005548:	10001737          	lui	a4,0x10001
    8000554c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000554e:	472d                	li	a4,11
    80005550:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005552:	473d                	li	a4,15
    80005554:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	6705                	lui	a4,0x1
    8000555c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000555e:	100017b7          	lui	a5,0x10001
    80005562:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005566:	100017b7          	lui	a5,0x10001
    8000556a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000556e:	439c                	lw	a5,0(a5)
    80005570:	2781                	sext.w	a5,a5
  if(max == 0)
    80005572:	cbc1                	beqz	a5,80005602 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005574:	471d                	li	a4,7
    80005576:	08f77e63          	bgeu	a4,a5,80005612 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000557a:	100017b7          	lui	a5,0x10001
    8000557e:	4721                	li	a4,8
    80005580:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005582:	6609                	lui	a2,0x2
    80005584:	4581                	li	a1,0
    80005586:	00019517          	auipc	a0,0x19
    8000558a:	a7a50513          	addi	a0,a0,-1414 # 8001e000 <disk>
    8000558e:	ffffb097          	auipc	ra,0xffffb
    80005592:	bec080e7          	jalr	-1044(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005596:	00019697          	auipc	a3,0x19
    8000559a:	a6a68693          	addi	a3,a3,-1430 # 8001e000 <disk>
    8000559e:	00c6d713          	srli	a4,a3,0xc
    800055a2:	2701                	sext.w	a4,a4
    800055a4:	100017b7          	lui	a5,0x10001
    800055a8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055aa:	0001b797          	auipc	a5,0x1b
    800055ae:	a5678793          	addi	a5,a5,-1450 # 80020000 <disk+0x2000>
    800055b2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055b4:	00019717          	auipc	a4,0x19
    800055b8:	acc70713          	addi	a4,a4,-1332 # 8001e080 <disk+0x80>
    800055bc:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055be:	0001a717          	auipc	a4,0x1a
    800055c2:	a4270713          	addi	a4,a4,-1470 # 8001f000 <disk+0x1000>
    800055c6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800055c8:	4705                	li	a4,1
    800055ca:	00e78c23          	sb	a4,24(a5)
    800055ce:	00e78ca3          	sb	a4,25(a5)
    800055d2:	00e78d23          	sb	a4,26(a5)
    800055d6:	00e78da3          	sb	a4,27(a5)
    800055da:	00e78e23          	sb	a4,28(a5)
    800055de:	00e78ea3          	sb	a4,29(a5)
    800055e2:	00e78f23          	sb	a4,30(a5)
    800055e6:	00e78fa3          	sb	a4,31(a5)
}
    800055ea:	60a2                	ld	ra,8(sp)
    800055ec:	6402                	ld	s0,0(sp)
    800055ee:	0141                	addi	sp,sp,16
    800055f0:	8082                	ret
    panic("could not find virtio disk");
    800055f2:	00003517          	auipc	a0,0x3
    800055f6:	05e50513          	addi	a0,a0,94 # 80008650 <etext+0x650>
    800055fa:	00001097          	auipc	ra,0x1
    800055fe:	8c2080e7          	jalr	-1854(ra) # 80005ebc <panic>
    panic("virtio disk has no queue 0");
    80005602:	00003517          	auipc	a0,0x3
    80005606:	06e50513          	addi	a0,a0,110 # 80008670 <etext+0x670>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	8b2080e7          	jalr	-1870(ra) # 80005ebc <panic>
    panic("virtio disk max queue too short");
    80005612:	00003517          	auipc	a0,0x3
    80005616:	07e50513          	addi	a0,a0,126 # 80008690 <etext+0x690>
    8000561a:	00001097          	auipc	ra,0x1
    8000561e:	8a2080e7          	jalr	-1886(ra) # 80005ebc <panic>

0000000080005622 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005622:	7159                	addi	sp,sp,-112
    80005624:	f486                	sd	ra,104(sp)
    80005626:	f0a2                	sd	s0,96(sp)
    80005628:	eca6                	sd	s1,88(sp)
    8000562a:	e8ca                	sd	s2,80(sp)
    8000562c:	e4ce                	sd	s3,72(sp)
    8000562e:	e0d2                	sd	s4,64(sp)
    80005630:	fc56                	sd	s5,56(sp)
    80005632:	f85a                	sd	s6,48(sp)
    80005634:	f45e                	sd	s7,40(sp)
    80005636:	f062                	sd	s8,32(sp)
    80005638:	ec66                	sd	s9,24(sp)
    8000563a:	1880                	addi	s0,sp,112
    8000563c:	8a2a                	mv	s4,a0
    8000563e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005640:	00c52c03          	lw	s8,12(a0)
    80005644:	001c1c1b          	slliw	s8,s8,0x1
    80005648:	1c02                	slli	s8,s8,0x20
    8000564a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000564e:	0001b517          	auipc	a0,0x1b
    80005652:	ada50513          	addi	a0,a0,-1318 # 80020128 <disk+0x2128>
    80005656:	00001097          	auipc	ra,0x1
    8000565a:	de0080e7          	jalr	-544(ra) # 80006436 <acquire>
  for(int i = 0; i < 3; i++){
    8000565e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005660:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005662:	00019b97          	auipc	s7,0x19
    80005666:	99eb8b93          	addi	s7,s7,-1634 # 8001e000 <disk>
    8000566a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000566c:	4a8d                	li	s5,3
    8000566e:	a88d                	j	800056e0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005670:	00fb8733          	add	a4,s7,a5
    80005674:	975a                	add	a4,a4,s6
    80005676:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000567a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000567c:	0207c563          	bltz	a5,800056a6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005680:	2905                	addiw	s2,s2,1
    80005682:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005684:	1b590163          	beq	s2,s5,80005826 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005688:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000568a:	0001b717          	auipc	a4,0x1b
    8000568e:	98e70713          	addi	a4,a4,-1650 # 80020018 <disk+0x2018>
    80005692:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005694:	00074683          	lbu	a3,0(a4)
    80005698:	fee1                	bnez	a3,80005670 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000569a:	2785                	addiw	a5,a5,1
    8000569c:	0705                	addi	a4,a4,1
    8000569e:	fe979be3          	bne	a5,s1,80005694 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800056a2:	57fd                	li	a5,-1
    800056a4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056a6:	03205163          	blez	s2,800056c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056aa:	f9042503          	lw	a0,-112(s0)
    800056ae:	00000097          	auipc	ra,0x0
    800056b2:	d7c080e7          	jalr	-644(ra) # 8000542a <free_desc>
      for(int j = 0; j < i; j++)
    800056b6:	4785                	li	a5,1
    800056b8:	0127d863          	bge	a5,s2,800056c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056bc:	f9442503          	lw	a0,-108(s0)
    800056c0:	00000097          	auipc	ra,0x0
    800056c4:	d6a080e7          	jalr	-662(ra) # 8000542a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056c8:	0001b597          	auipc	a1,0x1b
    800056cc:	a6058593          	addi	a1,a1,-1440 # 80020128 <disk+0x2128>
    800056d0:	0001b517          	auipc	a0,0x1b
    800056d4:	94850513          	addi	a0,a0,-1720 # 80020018 <disk+0x2018>
    800056d8:	ffffc097          	auipc	ra,0xffffc
    800056dc:	ff8080e7          	jalr	-8(ra) # 800016d0 <sleep>
  for(int i = 0; i < 3; i++){
    800056e0:	f9040613          	addi	a2,s0,-112
    800056e4:	894e                	mv	s2,s3
    800056e6:	b74d                	j	80005688 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056e8:	0001b717          	auipc	a4,0x1b
    800056ec:	91873703          	ld	a4,-1768(a4) # 80020000 <disk+0x2000>
    800056f0:	973e                	add	a4,a4,a5
    800056f2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056f6:	00019897          	auipc	a7,0x19
    800056fa:	90a88893          	addi	a7,a7,-1782 # 8001e000 <disk>
    800056fe:	0001b717          	auipc	a4,0x1b
    80005702:	90270713          	addi	a4,a4,-1790 # 80020000 <disk+0x2000>
    80005706:	6314                	ld	a3,0(a4)
    80005708:	96be                	add	a3,a3,a5
    8000570a:	00c6d583          	lhu	a1,12(a3)
    8000570e:	0015e593          	ori	a1,a1,1
    80005712:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005716:	f9842683          	lw	a3,-104(s0)
    8000571a:	630c                	ld	a1,0(a4)
    8000571c:	97ae                	add	a5,a5,a1
    8000571e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005722:	20050593          	addi	a1,a0,512
    80005726:	0592                	slli	a1,a1,0x4
    80005728:	95c6                	add	a1,a1,a7
    8000572a:	57fd                	li	a5,-1
    8000572c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005730:	00469793          	slli	a5,a3,0x4
    80005734:	00073803          	ld	a6,0(a4)
    80005738:	983e                	add	a6,a6,a5
    8000573a:	6689                	lui	a3,0x2
    8000573c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005740:	96b2                	add	a3,a3,a2
    80005742:	96c6                	add	a3,a3,a7
    80005744:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005748:	6314                	ld	a3,0(a4)
    8000574a:	96be                	add	a3,a3,a5
    8000574c:	4605                	li	a2,1
    8000574e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005750:	6314                	ld	a3,0(a4)
    80005752:	96be                	add	a3,a3,a5
    80005754:	4809                	li	a6,2
    80005756:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000575a:	6314                	ld	a3,0(a4)
    8000575c:	97b6                	add	a5,a5,a3
    8000575e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005762:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005766:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000576a:	6714                	ld	a3,8(a4)
    8000576c:	0026d783          	lhu	a5,2(a3)
    80005770:	8b9d                	andi	a5,a5,7
    80005772:	0786                	slli	a5,a5,0x1
    80005774:	96be                	add	a3,a3,a5
    80005776:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000577a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000577e:	6718                	ld	a4,8(a4)
    80005780:	00275783          	lhu	a5,2(a4)
    80005784:	2785                	addiw	a5,a5,1
    80005786:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000578a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000578e:	100017b7          	lui	a5,0x10001
    80005792:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005796:	004a2783          	lw	a5,4(s4)
    8000579a:	02c79163          	bne	a5,a2,800057bc <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000579e:	0001b917          	auipc	s2,0x1b
    800057a2:	98a90913          	addi	s2,s2,-1654 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800057a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057a8:	85ca                	mv	a1,s2
    800057aa:	8552                	mv	a0,s4
    800057ac:	ffffc097          	auipc	ra,0xffffc
    800057b0:	f24080e7          	jalr	-220(ra) # 800016d0 <sleep>
  while(b->disk == 1) {
    800057b4:	004a2783          	lw	a5,4(s4)
    800057b8:	fe9788e3          	beq	a5,s1,800057a8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800057bc:	f9042903          	lw	s2,-112(s0)
    800057c0:	20090713          	addi	a4,s2,512
    800057c4:	0712                	slli	a4,a4,0x4
    800057c6:	00019797          	auipc	a5,0x19
    800057ca:	83a78793          	addi	a5,a5,-1990 # 8001e000 <disk>
    800057ce:	97ba                	add	a5,a5,a4
    800057d0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057d4:	0001b997          	auipc	s3,0x1b
    800057d8:	82c98993          	addi	s3,s3,-2004 # 80020000 <disk+0x2000>
    800057dc:	00491713          	slli	a4,s2,0x4
    800057e0:	0009b783          	ld	a5,0(s3)
    800057e4:	97ba                	add	a5,a5,a4
    800057e6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057ea:	854a                	mv	a0,s2
    800057ec:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057f0:	00000097          	auipc	ra,0x0
    800057f4:	c3a080e7          	jalr	-966(ra) # 8000542a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057f8:	8885                	andi	s1,s1,1
    800057fa:	f0ed                	bnez	s1,800057dc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057fc:	0001b517          	auipc	a0,0x1b
    80005800:	92c50513          	addi	a0,a0,-1748 # 80020128 <disk+0x2128>
    80005804:	00001097          	auipc	ra,0x1
    80005808:	ce6080e7          	jalr	-794(ra) # 800064ea <release>
}
    8000580c:	70a6                	ld	ra,104(sp)
    8000580e:	7406                	ld	s0,96(sp)
    80005810:	64e6                	ld	s1,88(sp)
    80005812:	6946                	ld	s2,80(sp)
    80005814:	69a6                	ld	s3,72(sp)
    80005816:	6a06                	ld	s4,64(sp)
    80005818:	7ae2                	ld	s5,56(sp)
    8000581a:	7b42                	ld	s6,48(sp)
    8000581c:	7ba2                	ld	s7,40(sp)
    8000581e:	7c02                	ld	s8,32(sp)
    80005820:	6ce2                	ld	s9,24(sp)
    80005822:	6165                	addi	sp,sp,112
    80005824:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005826:	f9042503          	lw	a0,-112(s0)
    8000582a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000582e:	00018597          	auipc	a1,0x18
    80005832:	7d258593          	addi	a1,a1,2002 # 8001e000 <disk>
    80005836:	20050793          	addi	a5,a0,512
    8000583a:	0792                	slli	a5,a5,0x4
    8000583c:	97ae                	add	a5,a5,a1
    8000583e:	01903733          	snez	a4,s9
    80005842:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005846:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000584a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000584e:	0001a717          	auipc	a4,0x1a
    80005852:	7b270713          	addi	a4,a4,1970 # 80020000 <disk+0x2000>
    80005856:	6314                	ld	a3,0(a4)
    80005858:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000585a:	6789                	lui	a5,0x2
    8000585c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005860:	97b2                	add	a5,a5,a2
    80005862:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005864:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005866:	631c                	ld	a5,0(a4)
    80005868:	97b2                	add	a5,a5,a2
    8000586a:	46c1                	li	a3,16
    8000586c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000586e:	631c                	ld	a5,0(a4)
    80005870:	97b2                	add	a5,a5,a2
    80005872:	4685                	li	a3,1
    80005874:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005878:	f9442783          	lw	a5,-108(s0)
    8000587c:	6314                	ld	a3,0(a4)
    8000587e:	96b2                	add	a3,a3,a2
    80005880:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005884:	0792                	slli	a5,a5,0x4
    80005886:	6314                	ld	a3,0(a4)
    80005888:	96be                	add	a3,a3,a5
    8000588a:	058a0593          	addi	a1,s4,88
    8000588e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005890:	6318                	ld	a4,0(a4)
    80005892:	973e                	add	a4,a4,a5
    80005894:	40000693          	li	a3,1024
    80005898:	c714                	sw	a3,8(a4)
  if(write)
    8000589a:	e40c97e3          	bnez	s9,800056e8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000589e:	0001a717          	auipc	a4,0x1a
    800058a2:	76273703          	ld	a4,1890(a4) # 80020000 <disk+0x2000>
    800058a6:	973e                	add	a4,a4,a5
    800058a8:	4689                	li	a3,2
    800058aa:	00d71623          	sh	a3,12(a4)
    800058ae:	b5a1                	j	800056f6 <virtio_disk_rw+0xd4>

00000000800058b0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058b0:	1101                	addi	sp,sp,-32
    800058b2:	ec06                	sd	ra,24(sp)
    800058b4:	e822                	sd	s0,16(sp)
    800058b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058b8:	0001b517          	auipc	a0,0x1b
    800058bc:	87050513          	addi	a0,a0,-1936 # 80020128 <disk+0x2128>
    800058c0:	00001097          	auipc	ra,0x1
    800058c4:	b76080e7          	jalr	-1162(ra) # 80006436 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058c8:	100017b7          	lui	a5,0x10001
    800058cc:	53b8                	lw	a4,96(a5)
    800058ce:	8b0d                	andi	a4,a4,3
    800058d0:	100017b7          	lui	a5,0x10001
    800058d4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800058d6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058da:	0001a797          	auipc	a5,0x1a
    800058de:	72678793          	addi	a5,a5,1830 # 80020000 <disk+0x2000>
    800058e2:	6b94                	ld	a3,16(a5)
    800058e4:	0207d703          	lhu	a4,32(a5)
    800058e8:	0026d783          	lhu	a5,2(a3)
    800058ec:	06f70563          	beq	a4,a5,80005956 <virtio_disk_intr+0xa6>
    800058f0:	e426                	sd	s1,8(sp)
    800058f2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058f4:	00018917          	auipc	s2,0x18
    800058f8:	70c90913          	addi	s2,s2,1804 # 8001e000 <disk>
    800058fc:	0001a497          	auipc	s1,0x1a
    80005900:	70448493          	addi	s1,s1,1796 # 80020000 <disk+0x2000>
    __sync_synchronize();
    80005904:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005908:	6898                	ld	a4,16(s1)
    8000590a:	0204d783          	lhu	a5,32(s1)
    8000590e:	8b9d                	andi	a5,a5,7
    80005910:	078e                	slli	a5,a5,0x3
    80005912:	97ba                	add	a5,a5,a4
    80005914:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005916:	20078713          	addi	a4,a5,512
    8000591a:	0712                	slli	a4,a4,0x4
    8000591c:	974a                	add	a4,a4,s2
    8000591e:	03074703          	lbu	a4,48(a4)
    80005922:	e731                	bnez	a4,8000596e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005924:	20078793          	addi	a5,a5,512
    80005928:	0792                	slli	a5,a5,0x4
    8000592a:	97ca                	add	a5,a5,s2
    8000592c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000592e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	f2a080e7          	jalr	-214(ra) # 8000185c <wakeup>

    disk.used_idx += 1;
    8000593a:	0204d783          	lhu	a5,32(s1)
    8000593e:	2785                	addiw	a5,a5,1
    80005940:	17c2                	slli	a5,a5,0x30
    80005942:	93c1                	srli	a5,a5,0x30
    80005944:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005948:	6898                	ld	a4,16(s1)
    8000594a:	00275703          	lhu	a4,2(a4)
    8000594e:	faf71be3          	bne	a4,a5,80005904 <virtio_disk_intr+0x54>
    80005952:	64a2                	ld	s1,8(sp)
    80005954:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005956:	0001a517          	auipc	a0,0x1a
    8000595a:	7d250513          	addi	a0,a0,2002 # 80020128 <disk+0x2128>
    8000595e:	00001097          	auipc	ra,0x1
    80005962:	b8c080e7          	jalr	-1140(ra) # 800064ea <release>
}
    80005966:	60e2                	ld	ra,24(sp)
    80005968:	6442                	ld	s0,16(sp)
    8000596a:	6105                	addi	sp,sp,32
    8000596c:	8082                	ret
      panic("virtio_disk_intr status");
    8000596e:	00003517          	auipc	a0,0x3
    80005972:	d4250513          	addi	a0,a0,-702 # 800086b0 <etext+0x6b0>
    80005976:	00000097          	auipc	ra,0x0
    8000597a:	546080e7          	jalr	1350(ra) # 80005ebc <panic>

000000008000597e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000597e:	1141                	addi	sp,sp,-16
    80005980:	e422                	sd	s0,8(sp)
    80005982:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005984:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005988:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000598c:	0037979b          	slliw	a5,a5,0x3
    80005990:	02004737          	lui	a4,0x2004
    80005994:	97ba                	add	a5,a5,a4
    80005996:	0200c737          	lui	a4,0x200c
    8000599a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000599c:	6318                	ld	a4,0(a4)
    8000599e:	000f4637          	lui	a2,0xf4
    800059a2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059a6:	9732                	add	a4,a4,a2
    800059a8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059aa:	00259693          	slli	a3,a1,0x2
    800059ae:	96ae                	add	a3,a3,a1
    800059b0:	068e                	slli	a3,a3,0x3
    800059b2:	0001b717          	auipc	a4,0x1b
    800059b6:	64e70713          	addi	a4,a4,1614 # 80021000 <timer_scratch>
    800059ba:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059bc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059be:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059c0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059c4:	00000797          	auipc	a5,0x0
    800059c8:	99c78793          	addi	a5,a5,-1636 # 80005360 <timervec>
    800059cc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059d0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059d4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059d8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059dc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059e0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059e4:	30479073          	csrw	mie,a5
}
    800059e8:	6422                	ld	s0,8(sp)
    800059ea:	0141                	addi	sp,sp,16
    800059ec:	8082                	ret

00000000800059ee <start>:
{
    800059ee:	1141                	addi	sp,sp,-16
    800059f0:	e406                	sd	ra,8(sp)
    800059f2:	e022                	sd	s0,0(sp)
    800059f4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059f6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059fa:	7779                	lui	a4,0xffffe
    800059fc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd55bf>
    80005a00:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a02:	6705                	lui	a4,0x1
    80005a04:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a08:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a0a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a0e:	ffffb797          	auipc	a5,0xffffb
    80005a12:	90a78793          	addi	a5,a5,-1782 # 80000318 <main>
    80005a16:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a1a:	4781                	li	a5,0
    80005a1c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a20:	67c1                	lui	a5,0x10
    80005a22:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a24:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a28:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a2c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a30:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a34:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a38:	57fd                	li	a5,-1
    80005a3a:	83a9                	srli	a5,a5,0xa
    80005a3c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a40:	47bd                	li	a5,15
    80005a42:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a46:	00000097          	auipc	ra,0x0
    80005a4a:	f38080e7          	jalr	-200(ra) # 8000597e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a4e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a52:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a54:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a56:	30200073          	mret
}
    80005a5a:	60a2                	ld	ra,8(sp)
    80005a5c:	6402                	ld	s0,0(sp)
    80005a5e:	0141                	addi	sp,sp,16
    80005a60:	8082                	ret

0000000080005a62 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a62:	715d                	addi	sp,sp,-80
    80005a64:	e486                	sd	ra,72(sp)
    80005a66:	e0a2                	sd	s0,64(sp)
    80005a68:	f84a                	sd	s2,48(sp)
    80005a6a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a6c:	04c05663          	blez	a2,80005ab8 <consolewrite+0x56>
    80005a70:	fc26                	sd	s1,56(sp)
    80005a72:	f44e                	sd	s3,40(sp)
    80005a74:	f052                	sd	s4,32(sp)
    80005a76:	ec56                	sd	s5,24(sp)
    80005a78:	8a2a                	mv	s4,a0
    80005a7a:	84ae                	mv	s1,a1
    80005a7c:	89b2                	mv	s3,a2
    80005a7e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a80:	5afd                	li	s5,-1
    80005a82:	4685                	li	a3,1
    80005a84:	8626                	mv	a2,s1
    80005a86:	85d2                	mv	a1,s4
    80005a88:	fbf40513          	addi	a0,s0,-65
    80005a8c:	ffffc097          	auipc	ra,0xffffc
    80005a90:	03e080e7          	jalr	62(ra) # 80001aca <either_copyin>
    80005a94:	03550463          	beq	a0,s5,80005abc <consolewrite+0x5a>
      break;
    uartputc(c);
    80005a98:	fbf44503          	lbu	a0,-65(s0)
    80005a9c:	00000097          	auipc	ra,0x0
    80005aa0:	7de080e7          	jalr	2014(ra) # 8000627a <uartputc>
  for(i = 0; i < n; i++){
    80005aa4:	2905                	addiw	s2,s2,1
    80005aa6:	0485                	addi	s1,s1,1
    80005aa8:	fd299de3          	bne	s3,s2,80005a82 <consolewrite+0x20>
    80005aac:	894e                	mv	s2,s3
    80005aae:	74e2                	ld	s1,56(sp)
    80005ab0:	79a2                	ld	s3,40(sp)
    80005ab2:	7a02                	ld	s4,32(sp)
    80005ab4:	6ae2                	ld	s5,24(sp)
    80005ab6:	a039                	j	80005ac4 <consolewrite+0x62>
    80005ab8:	4901                	li	s2,0
    80005aba:	a029                	j	80005ac4 <consolewrite+0x62>
    80005abc:	74e2                	ld	s1,56(sp)
    80005abe:	79a2                	ld	s3,40(sp)
    80005ac0:	7a02                	ld	s4,32(sp)
    80005ac2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005ac4:	854a                	mv	a0,s2
    80005ac6:	60a6                	ld	ra,72(sp)
    80005ac8:	6406                	ld	s0,64(sp)
    80005aca:	7942                	ld	s2,48(sp)
    80005acc:	6161                	addi	sp,sp,80
    80005ace:	8082                	ret

0000000080005ad0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005ad0:	711d                	addi	sp,sp,-96
    80005ad2:	ec86                	sd	ra,88(sp)
    80005ad4:	e8a2                	sd	s0,80(sp)
    80005ad6:	e4a6                	sd	s1,72(sp)
    80005ad8:	e0ca                	sd	s2,64(sp)
    80005ada:	fc4e                	sd	s3,56(sp)
    80005adc:	f852                	sd	s4,48(sp)
    80005ade:	f456                	sd	s5,40(sp)
    80005ae0:	f05a                	sd	s6,32(sp)
    80005ae2:	1080                	addi	s0,sp,96
    80005ae4:	8aaa                	mv	s5,a0
    80005ae6:	8a2e                	mv	s4,a1
    80005ae8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005aea:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005aee:	00023517          	auipc	a0,0x23
    80005af2:	65250513          	addi	a0,a0,1618 # 80029140 <cons>
    80005af6:	00001097          	auipc	ra,0x1
    80005afa:	940080e7          	jalr	-1728(ra) # 80006436 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005afe:	00023497          	auipc	s1,0x23
    80005b02:	64248493          	addi	s1,s1,1602 # 80029140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b06:	00023917          	auipc	s2,0x23
    80005b0a:	6d290913          	addi	s2,s2,1746 # 800291d8 <cons+0x98>
  while(n > 0){
    80005b0e:	0d305463          	blez	s3,80005bd6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005b12:	0984a783          	lw	a5,152(s1)
    80005b16:	09c4a703          	lw	a4,156(s1)
    80005b1a:	0af71963          	bne	a4,a5,80005bcc <consoleread+0xfc>
      if(myproc()->killed){
    80005b1e:	ffffb097          	auipc	ra,0xffffb
    80005b22:	442080e7          	jalr	1090(ra) # 80000f60 <myproc>
    80005b26:	551c                	lw	a5,40(a0)
    80005b28:	e7ad                	bnez	a5,80005b92 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005b2a:	85a6                	mv	a1,s1
    80005b2c:	854a                	mv	a0,s2
    80005b2e:	ffffc097          	auipc	ra,0xffffc
    80005b32:	ba2080e7          	jalr	-1118(ra) # 800016d0 <sleep>
    while(cons.r == cons.w){
    80005b36:	0984a783          	lw	a5,152(s1)
    80005b3a:	09c4a703          	lw	a4,156(s1)
    80005b3e:	fef700e3          	beq	a4,a5,80005b1e <consoleread+0x4e>
    80005b42:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b44:	00023717          	auipc	a4,0x23
    80005b48:	5fc70713          	addi	a4,a4,1532 # 80029140 <cons>
    80005b4c:	0017869b          	addiw	a3,a5,1
    80005b50:	08d72c23          	sw	a3,152(a4)
    80005b54:	07f7f693          	andi	a3,a5,127
    80005b58:	9736                	add	a4,a4,a3
    80005b5a:	01874703          	lbu	a4,24(a4)
    80005b5e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b62:	4691                	li	a3,4
    80005b64:	04db8a63          	beq	s7,a3,80005bb8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b68:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b6c:	4685                	li	a3,1
    80005b6e:	faf40613          	addi	a2,s0,-81
    80005b72:	85d2                	mv	a1,s4
    80005b74:	8556                	mv	a0,s5
    80005b76:	ffffc097          	auipc	ra,0xffffc
    80005b7a:	efe080e7          	jalr	-258(ra) # 80001a74 <either_copyout>
    80005b7e:	57fd                	li	a5,-1
    80005b80:	04f50a63          	beq	a0,a5,80005bd4 <consoleread+0x104>
      break;

    dst++;
    80005b84:	0a05                	addi	s4,s4,1
    --n;
    80005b86:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005b88:	47a9                	li	a5,10
    80005b8a:	06fb8163          	beq	s7,a5,80005bec <consoleread+0x11c>
    80005b8e:	6be2                	ld	s7,24(sp)
    80005b90:	bfbd                	j	80005b0e <consoleread+0x3e>
        release(&cons.lock);
    80005b92:	00023517          	auipc	a0,0x23
    80005b96:	5ae50513          	addi	a0,a0,1454 # 80029140 <cons>
    80005b9a:	00001097          	auipc	ra,0x1
    80005b9e:	950080e7          	jalr	-1712(ra) # 800064ea <release>
        return -1;
    80005ba2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005ba4:	60e6                	ld	ra,88(sp)
    80005ba6:	6446                	ld	s0,80(sp)
    80005ba8:	64a6                	ld	s1,72(sp)
    80005baa:	6906                	ld	s2,64(sp)
    80005bac:	79e2                	ld	s3,56(sp)
    80005bae:	7a42                	ld	s4,48(sp)
    80005bb0:	7aa2                	ld	s5,40(sp)
    80005bb2:	7b02                	ld	s6,32(sp)
    80005bb4:	6125                	addi	sp,sp,96
    80005bb6:	8082                	ret
      if(n < target){
    80005bb8:	0009871b          	sext.w	a4,s3
    80005bbc:	01677a63          	bgeu	a4,s6,80005bd0 <consoleread+0x100>
        cons.r--;
    80005bc0:	00023717          	auipc	a4,0x23
    80005bc4:	60f72c23          	sw	a5,1560(a4) # 800291d8 <cons+0x98>
    80005bc8:	6be2                	ld	s7,24(sp)
    80005bca:	a031                	j	80005bd6 <consoleread+0x106>
    80005bcc:	ec5e                	sd	s7,24(sp)
    80005bce:	bf9d                	j	80005b44 <consoleread+0x74>
    80005bd0:	6be2                	ld	s7,24(sp)
    80005bd2:	a011                	j	80005bd6 <consoleread+0x106>
    80005bd4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005bd6:	00023517          	auipc	a0,0x23
    80005bda:	56a50513          	addi	a0,a0,1386 # 80029140 <cons>
    80005bde:	00001097          	auipc	ra,0x1
    80005be2:	90c080e7          	jalr	-1780(ra) # 800064ea <release>
  return target - n;
    80005be6:	413b053b          	subw	a0,s6,s3
    80005bea:	bf6d                	j	80005ba4 <consoleread+0xd4>
    80005bec:	6be2                	ld	s7,24(sp)
    80005bee:	b7e5                	j	80005bd6 <consoleread+0x106>

0000000080005bf0 <consputc>:
{
    80005bf0:	1141                	addi	sp,sp,-16
    80005bf2:	e406                	sd	ra,8(sp)
    80005bf4:	e022                	sd	s0,0(sp)
    80005bf6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bf8:	10000793          	li	a5,256
    80005bfc:	00f50a63          	beq	a0,a5,80005c10 <consputc+0x20>
    uartputc_sync(c);
    80005c00:	00000097          	auipc	ra,0x0
    80005c04:	59c080e7          	jalr	1436(ra) # 8000619c <uartputc_sync>
}
    80005c08:	60a2                	ld	ra,8(sp)
    80005c0a:	6402                	ld	s0,0(sp)
    80005c0c:	0141                	addi	sp,sp,16
    80005c0e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c10:	4521                	li	a0,8
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	58a080e7          	jalr	1418(ra) # 8000619c <uartputc_sync>
    80005c1a:	02000513          	li	a0,32
    80005c1e:	00000097          	auipc	ra,0x0
    80005c22:	57e080e7          	jalr	1406(ra) # 8000619c <uartputc_sync>
    80005c26:	4521                	li	a0,8
    80005c28:	00000097          	auipc	ra,0x0
    80005c2c:	574080e7          	jalr	1396(ra) # 8000619c <uartputc_sync>
    80005c30:	bfe1                	j	80005c08 <consputc+0x18>

0000000080005c32 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c32:	1101                	addi	sp,sp,-32
    80005c34:	ec06                	sd	ra,24(sp)
    80005c36:	e822                	sd	s0,16(sp)
    80005c38:	e426                	sd	s1,8(sp)
    80005c3a:	1000                	addi	s0,sp,32
    80005c3c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c3e:	00023517          	auipc	a0,0x23
    80005c42:	50250513          	addi	a0,a0,1282 # 80029140 <cons>
    80005c46:	00000097          	auipc	ra,0x0
    80005c4a:	7f0080e7          	jalr	2032(ra) # 80006436 <acquire>

  switch(c){
    80005c4e:	47d5                	li	a5,21
    80005c50:	0af48563          	beq	s1,a5,80005cfa <consoleintr+0xc8>
    80005c54:	0297c963          	blt	a5,s1,80005c86 <consoleintr+0x54>
    80005c58:	47a1                	li	a5,8
    80005c5a:	0ef48c63          	beq	s1,a5,80005d52 <consoleintr+0x120>
    80005c5e:	47c1                	li	a5,16
    80005c60:	10f49f63          	bne	s1,a5,80005d7e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005c64:	ffffc097          	auipc	ra,0xffffc
    80005c68:	ebc080e7          	jalr	-324(ra) # 80001b20 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c6c:	00023517          	auipc	a0,0x23
    80005c70:	4d450513          	addi	a0,a0,1236 # 80029140 <cons>
    80005c74:	00001097          	auipc	ra,0x1
    80005c78:	876080e7          	jalr	-1930(ra) # 800064ea <release>
}
    80005c7c:	60e2                	ld	ra,24(sp)
    80005c7e:	6442                	ld	s0,16(sp)
    80005c80:	64a2                	ld	s1,8(sp)
    80005c82:	6105                	addi	sp,sp,32
    80005c84:	8082                	ret
  switch(c){
    80005c86:	07f00793          	li	a5,127
    80005c8a:	0cf48463          	beq	s1,a5,80005d52 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c8e:	00023717          	auipc	a4,0x23
    80005c92:	4b270713          	addi	a4,a4,1202 # 80029140 <cons>
    80005c96:	0a072783          	lw	a5,160(a4)
    80005c9a:	09872703          	lw	a4,152(a4)
    80005c9e:	9f99                	subw	a5,a5,a4
    80005ca0:	07f00713          	li	a4,127
    80005ca4:	fcf764e3          	bltu	a4,a5,80005c6c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005ca8:	47b5                	li	a5,13
    80005caa:	0cf48d63          	beq	s1,a5,80005d84 <consoleintr+0x152>
      consputc(c);
    80005cae:	8526                	mv	a0,s1
    80005cb0:	00000097          	auipc	ra,0x0
    80005cb4:	f40080e7          	jalr	-192(ra) # 80005bf0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005cb8:	00023797          	auipc	a5,0x23
    80005cbc:	48878793          	addi	a5,a5,1160 # 80029140 <cons>
    80005cc0:	0a07a703          	lw	a4,160(a5)
    80005cc4:	0017069b          	addiw	a3,a4,1
    80005cc8:	0006861b          	sext.w	a2,a3
    80005ccc:	0ad7a023          	sw	a3,160(a5)
    80005cd0:	07f77713          	andi	a4,a4,127
    80005cd4:	97ba                	add	a5,a5,a4
    80005cd6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005cda:	47a9                	li	a5,10
    80005cdc:	0cf48b63          	beq	s1,a5,80005db2 <consoleintr+0x180>
    80005ce0:	4791                	li	a5,4
    80005ce2:	0cf48863          	beq	s1,a5,80005db2 <consoleintr+0x180>
    80005ce6:	00023797          	auipc	a5,0x23
    80005cea:	4f27a783          	lw	a5,1266(a5) # 800291d8 <cons+0x98>
    80005cee:	0807879b          	addiw	a5,a5,128
    80005cf2:	f6f61de3          	bne	a2,a5,80005c6c <consoleintr+0x3a>
    80005cf6:	863e                	mv	a2,a5
    80005cf8:	a86d                	j	80005db2 <consoleintr+0x180>
    80005cfa:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005cfc:	00023717          	auipc	a4,0x23
    80005d00:	44470713          	addi	a4,a4,1092 # 80029140 <cons>
    80005d04:	0a072783          	lw	a5,160(a4)
    80005d08:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d0c:	00023497          	auipc	s1,0x23
    80005d10:	43448493          	addi	s1,s1,1076 # 80029140 <cons>
    while(cons.e != cons.w &&
    80005d14:	4929                	li	s2,10
    80005d16:	02f70a63          	beq	a4,a5,80005d4a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d1a:	37fd                	addiw	a5,a5,-1
    80005d1c:	07f7f713          	andi	a4,a5,127
    80005d20:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d22:	01874703          	lbu	a4,24(a4)
    80005d26:	03270463          	beq	a4,s2,80005d4e <consoleintr+0x11c>
      cons.e--;
    80005d2a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d2e:	10000513          	li	a0,256
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	ebe080e7          	jalr	-322(ra) # 80005bf0 <consputc>
    while(cons.e != cons.w &&
    80005d3a:	0a04a783          	lw	a5,160(s1)
    80005d3e:	09c4a703          	lw	a4,156(s1)
    80005d42:	fcf71ce3          	bne	a4,a5,80005d1a <consoleintr+0xe8>
    80005d46:	6902                	ld	s2,0(sp)
    80005d48:	b715                	j	80005c6c <consoleintr+0x3a>
    80005d4a:	6902                	ld	s2,0(sp)
    80005d4c:	b705                	j	80005c6c <consoleintr+0x3a>
    80005d4e:	6902                	ld	s2,0(sp)
    80005d50:	bf31                	j	80005c6c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005d52:	00023717          	auipc	a4,0x23
    80005d56:	3ee70713          	addi	a4,a4,1006 # 80029140 <cons>
    80005d5a:	0a072783          	lw	a5,160(a4)
    80005d5e:	09c72703          	lw	a4,156(a4)
    80005d62:	f0f705e3          	beq	a4,a5,80005c6c <consoleintr+0x3a>
      cons.e--;
    80005d66:	37fd                	addiw	a5,a5,-1
    80005d68:	00023717          	auipc	a4,0x23
    80005d6c:	46f72c23          	sw	a5,1144(a4) # 800291e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d70:	10000513          	li	a0,256
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	e7c080e7          	jalr	-388(ra) # 80005bf0 <consputc>
    80005d7c:	bdc5                	j	80005c6c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d7e:	ee0487e3          	beqz	s1,80005c6c <consoleintr+0x3a>
    80005d82:	b731                	j	80005c8e <consoleintr+0x5c>
      consputc(c);
    80005d84:	4529                	li	a0,10
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	e6a080e7          	jalr	-406(ra) # 80005bf0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d8e:	00023797          	auipc	a5,0x23
    80005d92:	3b278793          	addi	a5,a5,946 # 80029140 <cons>
    80005d96:	0a07a703          	lw	a4,160(a5)
    80005d9a:	0017069b          	addiw	a3,a4,1
    80005d9e:	0006861b          	sext.w	a2,a3
    80005da2:	0ad7a023          	sw	a3,160(a5)
    80005da6:	07f77713          	andi	a4,a4,127
    80005daa:	97ba                	add	a5,a5,a4
    80005dac:	4729                	li	a4,10
    80005dae:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005db2:	00023797          	auipc	a5,0x23
    80005db6:	42c7a523          	sw	a2,1066(a5) # 800291dc <cons+0x9c>
        wakeup(&cons.r);
    80005dba:	00023517          	auipc	a0,0x23
    80005dbe:	41e50513          	addi	a0,a0,1054 # 800291d8 <cons+0x98>
    80005dc2:	ffffc097          	auipc	ra,0xffffc
    80005dc6:	a9a080e7          	jalr	-1382(ra) # 8000185c <wakeup>
    80005dca:	b54d                	j	80005c6c <consoleintr+0x3a>

0000000080005dcc <consoleinit>:

void
consoleinit(void)
{
    80005dcc:	1141                	addi	sp,sp,-16
    80005dce:	e406                	sd	ra,8(sp)
    80005dd0:	e022                	sd	s0,0(sp)
    80005dd2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dd4:	00003597          	auipc	a1,0x3
    80005dd8:	8f458593          	addi	a1,a1,-1804 # 800086c8 <etext+0x6c8>
    80005ddc:	00023517          	auipc	a0,0x23
    80005de0:	36450513          	addi	a0,a0,868 # 80029140 <cons>
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	5c2080e7          	jalr	1474(ra) # 800063a6 <initlock>

  uartinit();
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	354080e7          	jalr	852(ra) # 80006140 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005df4:	00016797          	auipc	a5,0x16
    80005df8:	4d478793          	addi	a5,a5,1236 # 8001c2c8 <devsw>
    80005dfc:	00000717          	auipc	a4,0x0
    80005e00:	cd470713          	addi	a4,a4,-812 # 80005ad0 <consoleread>
    80005e04:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e06:	00000717          	auipc	a4,0x0
    80005e0a:	c5c70713          	addi	a4,a4,-932 # 80005a62 <consolewrite>
    80005e0e:	ef98                	sd	a4,24(a5)
}
    80005e10:	60a2                	ld	ra,8(sp)
    80005e12:	6402                	ld	s0,0(sp)
    80005e14:	0141                	addi	sp,sp,16
    80005e16:	8082                	ret

0000000080005e18 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e18:	7179                	addi	sp,sp,-48
    80005e1a:	f406                	sd	ra,40(sp)
    80005e1c:	f022                	sd	s0,32(sp)
    80005e1e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e20:	c219                	beqz	a2,80005e26 <printint+0xe>
    80005e22:	08054963          	bltz	a0,80005eb4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e26:	2501                	sext.w	a0,a0
    80005e28:	4881                	li	a7,0
    80005e2a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e2e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e30:	2581                	sext.w	a1,a1
    80005e32:	00003617          	auipc	a2,0x3
    80005e36:	a3e60613          	addi	a2,a2,-1474 # 80008870 <digits>
    80005e3a:	883a                	mv	a6,a4
    80005e3c:	2705                	addiw	a4,a4,1
    80005e3e:	02b577bb          	remuw	a5,a0,a1
    80005e42:	1782                	slli	a5,a5,0x20
    80005e44:	9381                	srli	a5,a5,0x20
    80005e46:	97b2                	add	a5,a5,a2
    80005e48:	0007c783          	lbu	a5,0(a5)
    80005e4c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e50:	0005079b          	sext.w	a5,a0
    80005e54:	02b5553b          	divuw	a0,a0,a1
    80005e58:	0685                	addi	a3,a3,1
    80005e5a:	feb7f0e3          	bgeu	a5,a1,80005e3a <printint+0x22>

  if(sign)
    80005e5e:	00088c63          	beqz	a7,80005e76 <printint+0x5e>
    buf[i++] = '-';
    80005e62:	fe070793          	addi	a5,a4,-32
    80005e66:	00878733          	add	a4,a5,s0
    80005e6a:	02d00793          	li	a5,45
    80005e6e:	fef70823          	sb	a5,-16(a4)
    80005e72:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e76:	02e05b63          	blez	a4,80005eac <printint+0x94>
    80005e7a:	ec26                	sd	s1,24(sp)
    80005e7c:	e84a                	sd	s2,16(sp)
    80005e7e:	fd040793          	addi	a5,s0,-48
    80005e82:	00e784b3          	add	s1,a5,a4
    80005e86:	fff78913          	addi	s2,a5,-1
    80005e8a:	993a                	add	s2,s2,a4
    80005e8c:	377d                	addiw	a4,a4,-1
    80005e8e:	1702                	slli	a4,a4,0x20
    80005e90:	9301                	srli	a4,a4,0x20
    80005e92:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e96:	fff4c503          	lbu	a0,-1(s1)
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	d56080e7          	jalr	-682(ra) # 80005bf0 <consputc>
  while(--i >= 0)
    80005ea2:	14fd                	addi	s1,s1,-1
    80005ea4:	ff2499e3          	bne	s1,s2,80005e96 <printint+0x7e>
    80005ea8:	64e2                	ld	s1,24(sp)
    80005eaa:	6942                	ld	s2,16(sp)
}
    80005eac:	70a2                	ld	ra,40(sp)
    80005eae:	7402                	ld	s0,32(sp)
    80005eb0:	6145                	addi	sp,sp,48
    80005eb2:	8082                	ret
    x = -xx;
    80005eb4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005eb8:	4885                	li	a7,1
    x = -xx;
    80005eba:	bf85                	j	80005e2a <printint+0x12>

0000000080005ebc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ebc:	1101                	addi	sp,sp,-32
    80005ebe:	ec06                	sd	ra,24(sp)
    80005ec0:	e822                	sd	s0,16(sp)
    80005ec2:	e426                	sd	s1,8(sp)
    80005ec4:	1000                	addi	s0,sp,32
    80005ec6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ec8:	00023797          	auipc	a5,0x23
    80005ecc:	3207ac23          	sw	zero,824(a5) # 80029200 <pr+0x18>
  printf("panic: ");
    80005ed0:	00003517          	auipc	a0,0x3
    80005ed4:	80050513          	addi	a0,a0,-2048 # 800086d0 <etext+0x6d0>
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	02e080e7          	jalr	46(ra) # 80005f06 <printf>
  printf(s);
    80005ee0:	8526                	mv	a0,s1
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	024080e7          	jalr	36(ra) # 80005f06 <printf>
  printf("\n");
    80005eea:	00002517          	auipc	a0,0x2
    80005eee:	12e50513          	addi	a0,a0,302 # 80008018 <etext+0x18>
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	014080e7          	jalr	20(ra) # 80005f06 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005efa:	4785                	li	a5,1
    80005efc:	00006717          	auipc	a4,0x6
    80005f00:	12f72023          	sw	a5,288(a4) # 8000c01c <panicked>
  for(;;)
    80005f04:	a001                	j	80005f04 <panic+0x48>

0000000080005f06 <printf>:
{
    80005f06:	7131                	addi	sp,sp,-192
    80005f08:	fc86                	sd	ra,120(sp)
    80005f0a:	f8a2                	sd	s0,112(sp)
    80005f0c:	e8d2                	sd	s4,80(sp)
    80005f0e:	f06a                	sd	s10,32(sp)
    80005f10:	0100                	addi	s0,sp,128
    80005f12:	8a2a                	mv	s4,a0
    80005f14:	e40c                	sd	a1,8(s0)
    80005f16:	e810                	sd	a2,16(s0)
    80005f18:	ec14                	sd	a3,24(s0)
    80005f1a:	f018                	sd	a4,32(s0)
    80005f1c:	f41c                	sd	a5,40(s0)
    80005f1e:	03043823          	sd	a6,48(s0)
    80005f22:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f26:	00023d17          	auipc	s10,0x23
    80005f2a:	2dad2d03          	lw	s10,730(s10) # 80029200 <pr+0x18>
  if(locking)
    80005f2e:	040d1463          	bnez	s10,80005f76 <printf+0x70>
  if (fmt == 0)
    80005f32:	040a0b63          	beqz	s4,80005f88 <printf+0x82>
  va_start(ap, fmt);
    80005f36:	00840793          	addi	a5,s0,8
    80005f3a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f3e:	000a4503          	lbu	a0,0(s4)
    80005f42:	18050b63          	beqz	a0,800060d8 <printf+0x1d2>
    80005f46:	f4a6                	sd	s1,104(sp)
    80005f48:	f0ca                	sd	s2,96(sp)
    80005f4a:	ecce                	sd	s3,88(sp)
    80005f4c:	e4d6                	sd	s5,72(sp)
    80005f4e:	e0da                	sd	s6,64(sp)
    80005f50:	fc5e                	sd	s7,56(sp)
    80005f52:	f862                	sd	s8,48(sp)
    80005f54:	f466                	sd	s9,40(sp)
    80005f56:	ec6e                	sd	s11,24(sp)
    80005f58:	4981                	li	s3,0
    if(c != '%'){
    80005f5a:	02500b13          	li	s6,37
    switch(c){
    80005f5e:	07000b93          	li	s7,112
  consputc('x');
    80005f62:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f64:	00003a97          	auipc	s5,0x3
    80005f68:	90ca8a93          	addi	s5,s5,-1780 # 80008870 <digits>
    switch(c){
    80005f6c:	07300c13          	li	s8,115
    80005f70:	06400d93          	li	s11,100
    80005f74:	a0b1                	j	80005fc0 <printf+0xba>
    acquire(&pr.lock);
    80005f76:	00023517          	auipc	a0,0x23
    80005f7a:	27250513          	addi	a0,a0,626 # 800291e8 <pr>
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	4b8080e7          	jalr	1208(ra) # 80006436 <acquire>
    80005f86:	b775                	j	80005f32 <printf+0x2c>
    80005f88:	f4a6                	sd	s1,104(sp)
    80005f8a:	f0ca                	sd	s2,96(sp)
    80005f8c:	ecce                	sd	s3,88(sp)
    80005f8e:	e4d6                	sd	s5,72(sp)
    80005f90:	e0da                	sd	s6,64(sp)
    80005f92:	fc5e                	sd	s7,56(sp)
    80005f94:	f862                	sd	s8,48(sp)
    80005f96:	f466                	sd	s9,40(sp)
    80005f98:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005f9a:	00002517          	auipc	a0,0x2
    80005f9e:	74650513          	addi	a0,a0,1862 # 800086e0 <etext+0x6e0>
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	f1a080e7          	jalr	-230(ra) # 80005ebc <panic>
      consputc(c);
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	c46080e7          	jalr	-954(ra) # 80005bf0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fb2:	2985                	addiw	s3,s3,1
    80005fb4:	013a07b3          	add	a5,s4,s3
    80005fb8:	0007c503          	lbu	a0,0(a5)
    80005fbc:	10050563          	beqz	a0,800060c6 <printf+0x1c0>
    if(c != '%'){
    80005fc0:	ff6515e3          	bne	a0,s6,80005faa <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005fc4:	2985                	addiw	s3,s3,1
    80005fc6:	013a07b3          	add	a5,s4,s3
    80005fca:	0007c783          	lbu	a5,0(a5)
    80005fce:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005fd2:	10078b63          	beqz	a5,800060e8 <printf+0x1e2>
    switch(c){
    80005fd6:	05778a63          	beq	a5,s7,8000602a <printf+0x124>
    80005fda:	02fbf663          	bgeu	s7,a5,80006006 <printf+0x100>
    80005fde:	09878863          	beq	a5,s8,8000606e <printf+0x168>
    80005fe2:	07800713          	li	a4,120
    80005fe6:	0ce79563          	bne	a5,a4,800060b0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005fea:	f8843783          	ld	a5,-120(s0)
    80005fee:	00878713          	addi	a4,a5,8
    80005ff2:	f8e43423          	sd	a4,-120(s0)
    80005ff6:	4605                	li	a2,1
    80005ff8:	85e6                	mv	a1,s9
    80005ffa:	4388                	lw	a0,0(a5)
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	e1c080e7          	jalr	-484(ra) # 80005e18 <printint>
      break;
    80006004:	b77d                	j	80005fb2 <printf+0xac>
    switch(c){
    80006006:	09678f63          	beq	a5,s6,800060a4 <printf+0x19e>
    8000600a:	0bb79363          	bne	a5,s11,800060b0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000600e:	f8843783          	ld	a5,-120(s0)
    80006012:	00878713          	addi	a4,a5,8
    80006016:	f8e43423          	sd	a4,-120(s0)
    8000601a:	4605                	li	a2,1
    8000601c:	45a9                	li	a1,10
    8000601e:	4388                	lw	a0,0(a5)
    80006020:	00000097          	auipc	ra,0x0
    80006024:	df8080e7          	jalr	-520(ra) # 80005e18 <printint>
      break;
    80006028:	b769                	j	80005fb2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000602a:	f8843783          	ld	a5,-120(s0)
    8000602e:	00878713          	addi	a4,a5,8
    80006032:	f8e43423          	sd	a4,-120(s0)
    80006036:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000603a:	03000513          	li	a0,48
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	bb2080e7          	jalr	-1102(ra) # 80005bf0 <consputc>
  consputc('x');
    80006046:	07800513          	li	a0,120
    8000604a:	00000097          	auipc	ra,0x0
    8000604e:	ba6080e7          	jalr	-1114(ra) # 80005bf0 <consputc>
    80006052:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006054:	03c95793          	srli	a5,s2,0x3c
    80006058:	97d6                	add	a5,a5,s5
    8000605a:	0007c503          	lbu	a0,0(a5)
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	b92080e7          	jalr	-1134(ra) # 80005bf0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006066:	0912                	slli	s2,s2,0x4
    80006068:	34fd                	addiw	s1,s1,-1
    8000606a:	f4ed                	bnez	s1,80006054 <printf+0x14e>
    8000606c:	b799                	j	80005fb2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000606e:	f8843783          	ld	a5,-120(s0)
    80006072:	00878713          	addi	a4,a5,8
    80006076:	f8e43423          	sd	a4,-120(s0)
    8000607a:	6384                	ld	s1,0(a5)
    8000607c:	cc89                	beqz	s1,80006096 <printf+0x190>
      for(; *s; s++)
    8000607e:	0004c503          	lbu	a0,0(s1)
    80006082:	d905                	beqz	a0,80005fb2 <printf+0xac>
        consputc(*s);
    80006084:	00000097          	auipc	ra,0x0
    80006088:	b6c080e7          	jalr	-1172(ra) # 80005bf0 <consputc>
      for(; *s; s++)
    8000608c:	0485                	addi	s1,s1,1
    8000608e:	0004c503          	lbu	a0,0(s1)
    80006092:	f96d                	bnez	a0,80006084 <printf+0x17e>
    80006094:	bf39                	j	80005fb2 <printf+0xac>
        s = "(null)";
    80006096:	00002497          	auipc	s1,0x2
    8000609a:	64248493          	addi	s1,s1,1602 # 800086d8 <etext+0x6d8>
      for(; *s; s++)
    8000609e:	02800513          	li	a0,40
    800060a2:	b7cd                	j	80006084 <printf+0x17e>
      consputc('%');
    800060a4:	855a                	mv	a0,s6
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	b4a080e7          	jalr	-1206(ra) # 80005bf0 <consputc>
      break;
    800060ae:	b711                	j	80005fb2 <printf+0xac>
      consputc('%');
    800060b0:	855a                	mv	a0,s6
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	b3e080e7          	jalr	-1218(ra) # 80005bf0 <consputc>
      consputc(c);
    800060ba:	8526                	mv	a0,s1
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	b34080e7          	jalr	-1228(ra) # 80005bf0 <consputc>
      break;
    800060c4:	b5fd                	j	80005fb2 <printf+0xac>
    800060c6:	74a6                	ld	s1,104(sp)
    800060c8:	7906                	ld	s2,96(sp)
    800060ca:	69e6                	ld	s3,88(sp)
    800060cc:	6aa6                	ld	s5,72(sp)
    800060ce:	6b06                	ld	s6,64(sp)
    800060d0:	7be2                	ld	s7,56(sp)
    800060d2:	7c42                	ld	s8,48(sp)
    800060d4:	7ca2                	ld	s9,40(sp)
    800060d6:	6de2                	ld	s11,24(sp)
  if(locking)
    800060d8:	020d1263          	bnez	s10,800060fc <printf+0x1f6>
}
    800060dc:	70e6                	ld	ra,120(sp)
    800060de:	7446                	ld	s0,112(sp)
    800060e0:	6a46                	ld	s4,80(sp)
    800060e2:	7d02                	ld	s10,32(sp)
    800060e4:	6129                	addi	sp,sp,192
    800060e6:	8082                	ret
    800060e8:	74a6                	ld	s1,104(sp)
    800060ea:	7906                	ld	s2,96(sp)
    800060ec:	69e6                	ld	s3,88(sp)
    800060ee:	6aa6                	ld	s5,72(sp)
    800060f0:	6b06                	ld	s6,64(sp)
    800060f2:	7be2                	ld	s7,56(sp)
    800060f4:	7c42                	ld	s8,48(sp)
    800060f6:	7ca2                	ld	s9,40(sp)
    800060f8:	6de2                	ld	s11,24(sp)
    800060fa:	bff9                	j	800060d8 <printf+0x1d2>
    release(&pr.lock);
    800060fc:	00023517          	auipc	a0,0x23
    80006100:	0ec50513          	addi	a0,a0,236 # 800291e8 <pr>
    80006104:	00000097          	auipc	ra,0x0
    80006108:	3e6080e7          	jalr	998(ra) # 800064ea <release>
}
    8000610c:	bfc1                	j	800060dc <printf+0x1d6>

000000008000610e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000610e:	1101                	addi	sp,sp,-32
    80006110:	ec06                	sd	ra,24(sp)
    80006112:	e822                	sd	s0,16(sp)
    80006114:	e426                	sd	s1,8(sp)
    80006116:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006118:	00023497          	auipc	s1,0x23
    8000611c:	0d048493          	addi	s1,s1,208 # 800291e8 <pr>
    80006120:	00002597          	auipc	a1,0x2
    80006124:	5d058593          	addi	a1,a1,1488 # 800086f0 <etext+0x6f0>
    80006128:	8526                	mv	a0,s1
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	27c080e7          	jalr	636(ra) # 800063a6 <initlock>
  pr.locking = 1;
    80006132:	4785                	li	a5,1
    80006134:	cc9c                	sw	a5,24(s1)
}
    80006136:	60e2                	ld	ra,24(sp)
    80006138:	6442                	ld	s0,16(sp)
    8000613a:	64a2                	ld	s1,8(sp)
    8000613c:	6105                	addi	sp,sp,32
    8000613e:	8082                	ret

0000000080006140 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006140:	1141                	addi	sp,sp,-16
    80006142:	e406                	sd	ra,8(sp)
    80006144:	e022                	sd	s0,0(sp)
    80006146:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006148:	100007b7          	lui	a5,0x10000
    8000614c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006150:	10000737          	lui	a4,0x10000
    80006154:	f8000693          	li	a3,-128
    80006158:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000615c:	468d                	li	a3,3
    8000615e:	10000637          	lui	a2,0x10000
    80006162:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006166:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000616a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000616e:	10000737          	lui	a4,0x10000
    80006172:	461d                	li	a2,7
    80006174:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006178:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000617c:	00002597          	auipc	a1,0x2
    80006180:	57c58593          	addi	a1,a1,1404 # 800086f8 <etext+0x6f8>
    80006184:	00023517          	auipc	a0,0x23
    80006188:	08450513          	addi	a0,a0,132 # 80029208 <uart_tx_lock>
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	21a080e7          	jalr	538(ra) # 800063a6 <initlock>
}
    80006194:	60a2                	ld	ra,8(sp)
    80006196:	6402                	ld	s0,0(sp)
    80006198:	0141                	addi	sp,sp,16
    8000619a:	8082                	ret

000000008000619c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000619c:	1101                	addi	sp,sp,-32
    8000619e:	ec06                	sd	ra,24(sp)
    800061a0:	e822                	sd	s0,16(sp)
    800061a2:	e426                	sd	s1,8(sp)
    800061a4:	1000                	addi	s0,sp,32
    800061a6:	84aa                	mv	s1,a0
  push_off();
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	242080e7          	jalr	578(ra) # 800063ea <push_off>

  if(panicked){
    800061b0:	00006797          	auipc	a5,0x6
    800061b4:	e6c7a783          	lw	a5,-404(a5) # 8000c01c <panicked>
    800061b8:	eb85                	bnez	a5,800061e8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061ba:	10000737          	lui	a4,0x10000
    800061be:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800061c0:	00074783          	lbu	a5,0(a4)
    800061c4:	0207f793          	andi	a5,a5,32
    800061c8:	dfe5                	beqz	a5,800061c0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061ca:	0ff4f513          	zext.b	a0,s1
    800061ce:	100007b7          	lui	a5,0x10000
    800061d2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061d6:	00000097          	auipc	ra,0x0
    800061da:	2b4080e7          	jalr	692(ra) # 8000648a <pop_off>
}
    800061de:	60e2                	ld	ra,24(sp)
    800061e0:	6442                	ld	s0,16(sp)
    800061e2:	64a2                	ld	s1,8(sp)
    800061e4:	6105                	addi	sp,sp,32
    800061e6:	8082                	ret
    for(;;)
    800061e8:	a001                	j	800061e8 <uartputc_sync+0x4c>

00000000800061ea <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061ea:	00006797          	auipc	a5,0x6
    800061ee:	e367b783          	ld	a5,-458(a5) # 8000c020 <uart_tx_r>
    800061f2:	00006717          	auipc	a4,0x6
    800061f6:	e3673703          	ld	a4,-458(a4) # 8000c028 <uart_tx_w>
    800061fa:	06f70f63          	beq	a4,a5,80006278 <uartstart+0x8e>
{
    800061fe:	7139                	addi	sp,sp,-64
    80006200:	fc06                	sd	ra,56(sp)
    80006202:	f822                	sd	s0,48(sp)
    80006204:	f426                	sd	s1,40(sp)
    80006206:	f04a                	sd	s2,32(sp)
    80006208:	ec4e                	sd	s3,24(sp)
    8000620a:	e852                	sd	s4,16(sp)
    8000620c:	e456                	sd	s5,8(sp)
    8000620e:	e05a                	sd	s6,0(sp)
    80006210:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006212:	10000937          	lui	s2,0x10000
    80006216:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006218:	00023a97          	auipc	s5,0x23
    8000621c:	ff0a8a93          	addi	s5,s5,-16 # 80029208 <uart_tx_lock>
    uart_tx_r += 1;
    80006220:	00006497          	auipc	s1,0x6
    80006224:	e0048493          	addi	s1,s1,-512 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006228:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000622c:	00006997          	auipc	s3,0x6
    80006230:	dfc98993          	addi	s3,s3,-516 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006234:	00094703          	lbu	a4,0(s2)
    80006238:	02077713          	andi	a4,a4,32
    8000623c:	c705                	beqz	a4,80006264 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000623e:	01f7f713          	andi	a4,a5,31
    80006242:	9756                	add	a4,a4,s5
    80006244:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006248:	0785                	addi	a5,a5,1
    8000624a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000624c:	8526                	mv	a0,s1
    8000624e:	ffffb097          	auipc	ra,0xffffb
    80006252:	60e080e7          	jalr	1550(ra) # 8000185c <wakeup>
    WriteReg(THR, c);
    80006256:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000625a:	609c                	ld	a5,0(s1)
    8000625c:	0009b703          	ld	a4,0(s3)
    80006260:	fcf71ae3          	bne	a4,a5,80006234 <uartstart+0x4a>
  }
}
    80006264:	70e2                	ld	ra,56(sp)
    80006266:	7442                	ld	s0,48(sp)
    80006268:	74a2                	ld	s1,40(sp)
    8000626a:	7902                	ld	s2,32(sp)
    8000626c:	69e2                	ld	s3,24(sp)
    8000626e:	6a42                	ld	s4,16(sp)
    80006270:	6aa2                	ld	s5,8(sp)
    80006272:	6b02                	ld	s6,0(sp)
    80006274:	6121                	addi	sp,sp,64
    80006276:	8082                	ret
    80006278:	8082                	ret

000000008000627a <uartputc>:
{
    8000627a:	7179                	addi	sp,sp,-48
    8000627c:	f406                	sd	ra,40(sp)
    8000627e:	f022                	sd	s0,32(sp)
    80006280:	e052                	sd	s4,0(sp)
    80006282:	1800                	addi	s0,sp,48
    80006284:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006286:	00023517          	auipc	a0,0x23
    8000628a:	f8250513          	addi	a0,a0,-126 # 80029208 <uart_tx_lock>
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	1a8080e7          	jalr	424(ra) # 80006436 <acquire>
  if(panicked){
    80006296:	00006797          	auipc	a5,0x6
    8000629a:	d867a783          	lw	a5,-634(a5) # 8000c01c <panicked>
    8000629e:	c391                	beqz	a5,800062a2 <uartputc+0x28>
    for(;;)
    800062a0:	a001                	j	800062a0 <uartputc+0x26>
    800062a2:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062a4:	00006717          	auipc	a4,0x6
    800062a8:	d8473703          	ld	a4,-636(a4) # 8000c028 <uart_tx_w>
    800062ac:	00006797          	auipc	a5,0x6
    800062b0:	d747b783          	ld	a5,-652(a5) # 8000c020 <uart_tx_r>
    800062b4:	02078793          	addi	a5,a5,32
    800062b8:	02e79f63          	bne	a5,a4,800062f6 <uartputc+0x7c>
    800062bc:	e84a                	sd	s2,16(sp)
    800062be:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800062c0:	00023997          	auipc	s3,0x23
    800062c4:	f4898993          	addi	s3,s3,-184 # 80029208 <uart_tx_lock>
    800062c8:	00006497          	auipc	s1,0x6
    800062cc:	d5848493          	addi	s1,s1,-680 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062d0:	00006917          	auipc	s2,0x6
    800062d4:	d5890913          	addi	s2,s2,-680 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800062d8:	85ce                	mv	a1,s3
    800062da:	8526                	mv	a0,s1
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	3f4080e7          	jalr	1012(ra) # 800016d0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062e4:	00093703          	ld	a4,0(s2)
    800062e8:	609c                	ld	a5,0(s1)
    800062ea:	02078793          	addi	a5,a5,32
    800062ee:	fee785e3          	beq	a5,a4,800062d8 <uartputc+0x5e>
    800062f2:	6942                	ld	s2,16(sp)
    800062f4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062f6:	00023497          	auipc	s1,0x23
    800062fa:	f1248493          	addi	s1,s1,-238 # 80029208 <uart_tx_lock>
    800062fe:	01f77793          	andi	a5,a4,31
    80006302:	97a6                	add	a5,a5,s1
    80006304:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006308:	0705                	addi	a4,a4,1
    8000630a:	00006797          	auipc	a5,0x6
    8000630e:	d0e7bf23          	sd	a4,-738(a5) # 8000c028 <uart_tx_w>
      uartstart();
    80006312:	00000097          	auipc	ra,0x0
    80006316:	ed8080e7          	jalr	-296(ra) # 800061ea <uartstart>
      release(&uart_tx_lock);
    8000631a:	8526                	mv	a0,s1
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	1ce080e7          	jalr	462(ra) # 800064ea <release>
    80006324:	64e2                	ld	s1,24(sp)
}
    80006326:	70a2                	ld	ra,40(sp)
    80006328:	7402                	ld	s0,32(sp)
    8000632a:	6a02                	ld	s4,0(sp)
    8000632c:	6145                	addi	sp,sp,48
    8000632e:	8082                	ret

0000000080006330 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006330:	1141                	addi	sp,sp,-16
    80006332:	e422                	sd	s0,8(sp)
    80006334:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006336:	100007b7          	lui	a5,0x10000
    8000633a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000633c:	0007c783          	lbu	a5,0(a5)
    80006340:	8b85                	andi	a5,a5,1
    80006342:	cb81                	beqz	a5,80006352 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006344:	100007b7          	lui	a5,0x10000
    80006348:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000634c:	6422                	ld	s0,8(sp)
    8000634e:	0141                	addi	sp,sp,16
    80006350:	8082                	ret
    return -1;
    80006352:	557d                	li	a0,-1
    80006354:	bfe5                	j	8000634c <uartgetc+0x1c>

0000000080006356 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006356:	1101                	addi	sp,sp,-32
    80006358:	ec06                	sd	ra,24(sp)
    8000635a:	e822                	sd	s0,16(sp)
    8000635c:	e426                	sd	s1,8(sp)
    8000635e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006360:	54fd                	li	s1,-1
    80006362:	a029                	j	8000636c <uartintr+0x16>
      break;
    consoleintr(c);
    80006364:	00000097          	auipc	ra,0x0
    80006368:	8ce080e7          	jalr	-1842(ra) # 80005c32 <consoleintr>
    int c = uartgetc();
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	fc4080e7          	jalr	-60(ra) # 80006330 <uartgetc>
    if(c == -1)
    80006374:	fe9518e3          	bne	a0,s1,80006364 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006378:	00023497          	auipc	s1,0x23
    8000637c:	e9048493          	addi	s1,s1,-368 # 80029208 <uart_tx_lock>
    80006380:	8526                	mv	a0,s1
    80006382:	00000097          	auipc	ra,0x0
    80006386:	0b4080e7          	jalr	180(ra) # 80006436 <acquire>
  uartstart();
    8000638a:	00000097          	auipc	ra,0x0
    8000638e:	e60080e7          	jalr	-416(ra) # 800061ea <uartstart>
  release(&uart_tx_lock);
    80006392:	8526                	mv	a0,s1
    80006394:	00000097          	auipc	ra,0x0
    80006398:	156080e7          	jalr	342(ra) # 800064ea <release>
}
    8000639c:	60e2                	ld	ra,24(sp)
    8000639e:	6442                	ld	s0,16(sp)
    800063a0:	64a2                	ld	s1,8(sp)
    800063a2:	6105                	addi	sp,sp,32
    800063a4:	8082                	ret

00000000800063a6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063a6:	1141                	addi	sp,sp,-16
    800063a8:	e422                	sd	s0,8(sp)
    800063aa:	0800                	addi	s0,sp,16
  lk->name = name;
    800063ac:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063ae:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063b2:	00053823          	sd	zero,16(a0)
}
    800063b6:	6422                	ld	s0,8(sp)
    800063b8:	0141                	addi	sp,sp,16
    800063ba:	8082                	ret

00000000800063bc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063bc:	411c                	lw	a5,0(a0)
    800063be:	e399                	bnez	a5,800063c4 <holding+0x8>
    800063c0:	4501                	li	a0,0
  return r;
}
    800063c2:	8082                	ret
{
    800063c4:	1101                	addi	sp,sp,-32
    800063c6:	ec06                	sd	ra,24(sp)
    800063c8:	e822                	sd	s0,16(sp)
    800063ca:	e426                	sd	s1,8(sp)
    800063cc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063ce:	6904                	ld	s1,16(a0)
    800063d0:	ffffb097          	auipc	ra,0xffffb
    800063d4:	b74080e7          	jalr	-1164(ra) # 80000f44 <mycpu>
    800063d8:	40a48533          	sub	a0,s1,a0
    800063dc:	00153513          	seqz	a0,a0
}
    800063e0:	60e2                	ld	ra,24(sp)
    800063e2:	6442                	ld	s0,16(sp)
    800063e4:	64a2                	ld	s1,8(sp)
    800063e6:	6105                	addi	sp,sp,32
    800063e8:	8082                	ret

00000000800063ea <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063ea:	1101                	addi	sp,sp,-32
    800063ec:	ec06                	sd	ra,24(sp)
    800063ee:	e822                	sd	s0,16(sp)
    800063f0:	e426                	sd	s1,8(sp)
    800063f2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f4:	100024f3          	csrr	s1,sstatus
    800063f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063fc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063fe:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006402:	ffffb097          	auipc	ra,0xffffb
    80006406:	b42080e7          	jalr	-1214(ra) # 80000f44 <mycpu>
    8000640a:	5d3c                	lw	a5,120(a0)
    8000640c:	cf89                	beqz	a5,80006426 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000640e:	ffffb097          	auipc	ra,0xffffb
    80006412:	b36080e7          	jalr	-1226(ra) # 80000f44 <mycpu>
    80006416:	5d3c                	lw	a5,120(a0)
    80006418:	2785                	addiw	a5,a5,1
    8000641a:	dd3c                	sw	a5,120(a0)
}
    8000641c:	60e2                	ld	ra,24(sp)
    8000641e:	6442                	ld	s0,16(sp)
    80006420:	64a2                	ld	s1,8(sp)
    80006422:	6105                	addi	sp,sp,32
    80006424:	8082                	ret
    mycpu()->intena = old;
    80006426:	ffffb097          	auipc	ra,0xffffb
    8000642a:	b1e080e7          	jalr	-1250(ra) # 80000f44 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000642e:	8085                	srli	s1,s1,0x1
    80006430:	8885                	andi	s1,s1,1
    80006432:	dd64                	sw	s1,124(a0)
    80006434:	bfe9                	j	8000640e <push_off+0x24>

0000000080006436 <acquire>:
{
    80006436:	1101                	addi	sp,sp,-32
    80006438:	ec06                	sd	ra,24(sp)
    8000643a:	e822                	sd	s0,16(sp)
    8000643c:	e426                	sd	s1,8(sp)
    8000643e:	1000                	addi	s0,sp,32
    80006440:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006442:	00000097          	auipc	ra,0x0
    80006446:	fa8080e7          	jalr	-88(ra) # 800063ea <push_off>
  if(holding(lk))
    8000644a:	8526                	mv	a0,s1
    8000644c:	00000097          	auipc	ra,0x0
    80006450:	f70080e7          	jalr	-144(ra) # 800063bc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006454:	4705                	li	a4,1
  if(holding(lk))
    80006456:	e115                	bnez	a0,8000647a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006458:	87ba                	mv	a5,a4
    8000645a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000645e:	2781                	sext.w	a5,a5
    80006460:	ffe5                	bnez	a5,80006458 <acquire+0x22>
  __sync_synchronize();
    80006462:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006466:	ffffb097          	auipc	ra,0xffffb
    8000646a:	ade080e7          	jalr	-1314(ra) # 80000f44 <mycpu>
    8000646e:	e888                	sd	a0,16(s1)
}
    80006470:	60e2                	ld	ra,24(sp)
    80006472:	6442                	ld	s0,16(sp)
    80006474:	64a2                	ld	s1,8(sp)
    80006476:	6105                	addi	sp,sp,32
    80006478:	8082                	ret
    panic("acquire");
    8000647a:	00002517          	auipc	a0,0x2
    8000647e:	28650513          	addi	a0,a0,646 # 80008700 <etext+0x700>
    80006482:	00000097          	auipc	ra,0x0
    80006486:	a3a080e7          	jalr	-1478(ra) # 80005ebc <panic>

000000008000648a <pop_off>:

void
pop_off(void)
{
    8000648a:	1141                	addi	sp,sp,-16
    8000648c:	e406                	sd	ra,8(sp)
    8000648e:	e022                	sd	s0,0(sp)
    80006490:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006492:	ffffb097          	auipc	ra,0xffffb
    80006496:	ab2080e7          	jalr	-1358(ra) # 80000f44 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000649a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000649e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064a0:	e78d                	bnez	a5,800064ca <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064a2:	5d3c                	lw	a5,120(a0)
    800064a4:	02f05b63          	blez	a5,800064da <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800064a8:	37fd                	addiw	a5,a5,-1
    800064aa:	0007871b          	sext.w	a4,a5
    800064ae:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800064b0:	eb09                	bnez	a4,800064c2 <pop_off+0x38>
    800064b2:	5d7c                	lw	a5,124(a0)
    800064b4:	c799                	beqz	a5,800064c2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800064ba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064be:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800064c2:	60a2                	ld	ra,8(sp)
    800064c4:	6402                	ld	s0,0(sp)
    800064c6:	0141                	addi	sp,sp,16
    800064c8:	8082                	ret
    panic("pop_off - interruptible");
    800064ca:	00002517          	auipc	a0,0x2
    800064ce:	23e50513          	addi	a0,a0,574 # 80008708 <etext+0x708>
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	9ea080e7          	jalr	-1558(ra) # 80005ebc <panic>
    panic("pop_off");
    800064da:	00002517          	auipc	a0,0x2
    800064de:	24650513          	addi	a0,a0,582 # 80008720 <etext+0x720>
    800064e2:	00000097          	auipc	ra,0x0
    800064e6:	9da080e7          	jalr	-1574(ra) # 80005ebc <panic>

00000000800064ea <release>:
{
    800064ea:	1101                	addi	sp,sp,-32
    800064ec:	ec06                	sd	ra,24(sp)
    800064ee:	e822                	sd	s0,16(sp)
    800064f0:	e426                	sd	s1,8(sp)
    800064f2:	1000                	addi	s0,sp,32
    800064f4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064f6:	00000097          	auipc	ra,0x0
    800064fa:	ec6080e7          	jalr	-314(ra) # 800063bc <holding>
    800064fe:	c115                	beqz	a0,80006522 <release+0x38>
  lk->cpu = 0;
    80006500:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006504:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006508:	0310000f          	fence	rw,w
    8000650c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006510:	00000097          	auipc	ra,0x0
    80006514:	f7a080e7          	jalr	-134(ra) # 8000648a <pop_off>
}
    80006518:	60e2                	ld	ra,24(sp)
    8000651a:	6442                	ld	s0,16(sp)
    8000651c:	64a2                	ld	s1,8(sp)
    8000651e:	6105                	addi	sp,sp,32
    80006520:	8082                	ret
    panic("release");
    80006522:	00002517          	auipc	a0,0x2
    80006526:	20650513          	addi	a0,a0,518 # 80008728 <etext+0x728>
    8000652a:	00000097          	auipc	ra,0x0
    8000652e:	992080e7          	jalr	-1646(ra) # 80005ebc <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
