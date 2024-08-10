
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	0d013103          	ld	sp,208(sp) # 8000b0d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	079050ef          	jal	8000588e <start>

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
    8000005e:	2e8080e7          	jalr	744(ra) # 80006342 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	388080e7          	jalr	904(ra) # 800063f6 <release>
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
    8000008e:	d68080e7          	jalr	-664(ra) # 80005df2 <panic>

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
    800000fa:	1bc080e7          	jalr	444(ra) # 800062b2 <initlock>
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
    80000132:	214080e7          	jalr	532(ra) # 80006342 <acquire>
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
    8000014a:	2b0080e7          	jalr	688(ra) # 800063f6 <release>

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
    80000174:	286080e7          	jalr	646(ra) # 800063f6 <release>
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
    80000324:	b30080e7          	jalr	-1232(ra) # 80000e50 <cpuid>
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
    80000340:	b14080e7          	jalr	-1260(ra) # 80000e50 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	af6080e7          	jalr	-1290(ra) # 80005e44 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	7c0080e7          	jalr	1984(ra) # 80001b1e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	ede080e7          	jalr	-290(ra) # 80005244 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	06c080e7          	jalr	108(ra) # 800013da <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	8f6080e7          	jalr	-1802(ra) # 80005c6c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	9de080e7          	jalr	-1570(ra) # 80005d5c <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	ab6080e7          	jalr	-1354(ra) # 80005e44 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	aa6080e7          	jalr	-1370(ra) # 80005e44 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	a96080e7          	jalr	-1386(ra) # 80005e44 <printf>
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
    800003d2:	9c4080e7          	jalr	-1596(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	720080e7          	jalr	1824(ra) # 80001af6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	740080e7          	jalr	1856(ra) # 80001b1e <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	e44080e7          	jalr	-444(ra) # 8000522a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e56080e7          	jalr	-426(ra) # 80005244 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	f76080e7          	jalr	-138(ra) # 8000236c <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	602080e7          	jalr	1538(ra) # 80002a00 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	5a6080e7          	jalr	1446(ra) # 800039ac <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	f56080e7          	jalr	-170(ra) # 80005364 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d88080e7          	jalr	-632(ra) # 8000119e <userinit>
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
    80000484:	972080e7          	jalr	-1678(ra) # 80005df2 <panic>
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
    800005aa:	84c080e7          	jalr	-1972(ra) # 80005df2 <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	83c080e7          	jalr	-1988(ra) # 80005df2 <panic>
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
    80000602:	00005097          	auipc	ra,0x5
    80000606:	7f0080e7          	jalr	2032(ra) # 80005df2 <panic>

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
    800006ce:	624080e7          	jalr	1572(ra) # 80000cee <proc_mapstacks>
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
    8000074c:	6aa080e7          	jalr	1706(ra) # 80005df2 <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	69a080e7          	jalr	1690(ra) # 80005df2 <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	68a080e7          	jalr	1674(ra) # 80005df2 <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	67a080e7          	jalr	1658(ra) # 80005df2 <panic>
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
    80000870:	586080e7          	jalr	1414(ra) # 80005df2 <panic>

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
    800009bc:	43a080e7          	jalr	1082(ra) # 80005df2 <panic>
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
    80000a9a:	35c080e7          	jalr	860(ra) # 80005df2 <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	34c080e7          	jalr	844(ra) # 80005df2 <panic>
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
    80000b14:	2e2080e7          	jalr	738(ra) # 80005df2 <panic>

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

0000000080000cee <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cee:	7139                	addi	sp,sp,-64
    80000cf0:	fc06                	sd	ra,56(sp)
    80000cf2:	f822                	sd	s0,48(sp)
    80000cf4:	f426                	sd	s1,40(sp)
    80000cf6:	f04a                	sd	s2,32(sp)
    80000cf8:	ec4e                	sd	s3,24(sp)
    80000cfa:	e852                	sd	s4,16(sp)
    80000cfc:	e456                	sd	s5,8(sp)
    80000cfe:	e05a                	sd	s6,0(sp)
    80000d00:	0080                	addi	s0,sp,64
    80000d02:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d04:	0000b497          	auipc	s1,0xb
    80000d08:	77c48493          	addi	s1,s1,1916 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d0c:	8b26                	mv	s6,s1
    80000d0e:	03eb2937          	lui	s2,0x3eb2
    80000d12:	a1f90913          	addi	s2,s2,-1505 # 3eb1a1f <_entry-0x7c14e5e1>
    80000d16:	0932                	slli	s2,s2,0xc
    80000d18:	58d90913          	addi	s2,s2,1421
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	0fb90913          	addi	s2,s2,251
    80000d22:	0936                	slli	s2,s2,0xd
    80000d24:	8d190913          	addi	s2,s2,-1839
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	00012a97          	auipc	s5,0x12
    80000d34:	950a8a93          	addi	s5,s5,-1712 # 80012680 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if(pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	858d                	srai	a1,a1,0x3
    80000d4a:	032585b3          	mul	a1,a1,s2
    80000d4e:	2585                	addiw	a1,a1,1
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b985b3          	sub	a1,s3,a1
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	87c080e7          	jalr	-1924(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	18848493          	addi	s1,s1,392
    80000d6a:	fd5497e3          	bne	s1,s5,80000d38 <proc_mapstacks+0x4a>
  }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
      panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	addi	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	068080e7          	jalr	104(ra) # 80005df2 <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	addi	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	0000b517          	auipc	a0,0xb
    80000db2:	2a250513          	addi	a0,a0,674 # 8000c050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	4fc080e7          	jalr	1276(ra) # 800062b2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	0000b517          	auipc	a0,0xb
    80000dca:	2a250513          	addi	a0,a0,674 # 8000c068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	4e4080e7          	jalr	1252(ra) # 800062b2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	0000b497          	auipc	s1,0xb
    80000dda:	6aa48493          	addi	s1,s1,1706 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	03eb2937          	lui	s2,0x3eb2
    80000dec:	a1f90913          	addi	s2,s2,-1505 # 3eb1a1f <_entry-0x7c14e5e1>
    80000df0:	0932                	slli	s2,s2,0xc
    80000df2:	58d90913          	addi	s2,s2,1421
    80000df6:	0932                	slli	s2,s2,0xc
    80000df8:	0fb90913          	addi	s2,s2,251
    80000dfc:	0936                	slli	s2,s2,0xd
    80000dfe:	8d190913          	addi	s2,s2,-1839
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	00012a17          	auipc	s4,0x12
    80000e0e:	876a0a13          	addi	s4,s4,-1930 # 80012680 <tickslock>
      initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	49c080e7          	jalr	1180(ra) # 800062b2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	878d                	srai	a5,a5,0x3
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	18848493          	addi	s1,s1,392
    80000e38:	fd449de3          	bne	s1,s4,80000e12 <procinit+0x80>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
    80000e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6c:	0000b517          	auipc	a0,0xb
    80000e70:	21450513          	addi	a0,a0,532 # 8000c080 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	addi	s0,sp,32
  push_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	470080e7          	jalr	1136(ra) # 800062f6 <push_off>
    80000e8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
    80000e94:	0000b717          	auipc	a4,0xb
    80000e98:	1bc70713          	addi	a4,a4,444 # 8000c050 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	4f6080e7          	jalr	1270(ra) # 80006396 <pop_off>
  return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	532080e7          	jalr	1330(ra) # 800063f6 <release>

  if (first) {
    80000ecc:	0000a797          	auipc	a5,0xa
    80000ed0:	1b47a783          	lw	a5,436(a5) # 8000b080 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c60080e7          	jalr	-928(ra) # 80001b36 <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	0000a797          	auipc	a5,0xa
    80000eea:	1807ad23          	sw	zero,410(a5) # 8000b080 <first.1>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	a90080e7          	jalr	-1392(ra) # 80002980 <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
allocpid() {
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f06:	0000b917          	auipc	s2,0xb
    80000f0a:	14a90913          	addi	s2,s2,330 # 8000c050 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	432080e7          	jalr	1074(ra) # 80006342 <acquire>
  pid = nextpid;
    80000f18:	0000a797          	auipc	a5,0xa
    80000f1c:	16c78793          	addi	a5,a5,364 # 8000b084 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	4cc080e7          	jalr	1228(ra) # 800063f6 <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	addi	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	886080e7          	jalr	-1914(ra) # 800007d4 <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6c:	05b2                	slli	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	5cc080e7          	jalr	1484(ra) # 8000053a <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f88:	05b6                	slli	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5ae080e7          	jalr	1454(ra) # 8000053a <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a30080e7          	jalr	-1488(ra) # 800009da <uvmfree>
    return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	73c080e7          	jalr	1852(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a0a080e7          	jalr	-1526(ra) # 800009da <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	addi	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	708080e7          	jalr	1800(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000100a:	05b6                	slli	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	6f2080e7          	jalr	1778(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	9c0080e7          	jalr	-1600(ra) # 800009da <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  if(p->tick_trapframe)
    8000104a:	1784b503          	ld	a0,376(s1)
    8000104e:	c509                	beqz	a0,80001058 <freeproc+0x2a>
    kfree((void*)p->tick_trapframe);
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
  p->tick_trapframe = 0;
    80001058:	1604bc23          	sd	zero,376(s1)
  if(p->pagetable)
    8000105c:	68a8                	ld	a0,80(s1)
    8000105e:	c511                	beqz	a0,8000106a <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    80001060:	64ac                	ld	a1,72(s1)
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f7a080e7          	jalr	-134(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    8000106a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000106e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001072:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001076:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000107e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001082:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001086:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108a:	0004ac23          	sw	zero,24(s1)
}
    8000108e:	60e2                	ld	ra,24(sp)
    80001090:	6442                	ld	s0,16(sp)
    80001092:	64a2                	ld	s1,8(sp)
    80001094:	6105                	addi	sp,sp,32
    80001096:	8082                	ret

0000000080001098 <allocproc>:
{
    80001098:	1101                	addi	sp,sp,-32
    8000109a:	ec06                	sd	ra,24(sp)
    8000109c:	e822                	sd	s0,16(sp)
    8000109e:	e426                	sd	s1,8(sp)
    800010a0:	e04a                	sd	s2,0(sp)
    800010a2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a4:	0000b497          	auipc	s1,0xb
    800010a8:	3dc48493          	addi	s1,s1,988 # 8000c480 <proc>
    800010ac:	00011917          	auipc	s2,0x11
    800010b0:	5d490913          	addi	s2,s2,1492 # 80012680 <tickslock>
    acquire(&p->lock);
    800010b4:	8526                	mv	a0,s1
    800010b6:	00005097          	auipc	ra,0x5
    800010ba:	28c080e7          	jalr	652(ra) # 80006342 <acquire>
    if(p->state == UNUSED) {
    800010be:	4c9c                	lw	a5,24(s1)
    800010c0:	cf81                	beqz	a5,800010d8 <allocproc+0x40>
      release(&p->lock);
    800010c2:	8526                	mv	a0,s1
    800010c4:	00005097          	auipc	ra,0x5
    800010c8:	332080e7          	jalr	818(ra) # 800063f6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010cc:	18848493          	addi	s1,s1,392
    800010d0:	ff2492e3          	bne	s1,s2,800010b4 <allocproc+0x1c>
  return 0;
    800010d4:	4481                	li	s1,0
    800010d6:	a88d                	j	80001148 <allocproc+0xb0>
  p->pid = allocpid();
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	e22080e7          	jalr	-478(ra) # 80000efa <allocpid>
    800010e0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e2:	4785                	li	a5,1
    800010e4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	034080e7          	jalr	52(ra) # 8000011a <kalloc>
    800010ee:	892a                	mv	s2,a0
    800010f0:	eca8                	sd	a0,88(s1)
    800010f2:	c135                	beqz	a0,80001156 <allocproc+0xbe>
  if((p->tick_trapframe = (struct trapframe *)kalloc()) == 0){
    800010f4:	fffff097          	auipc	ra,0xfffff
    800010f8:	026080e7          	jalr	38(ra) # 8000011a <kalloc>
    800010fc:	892a                	mv	s2,a0
    800010fe:	16a4bc23          	sd	a0,376(s1)
    80001102:	c535                	beqz	a0,8000116e <allocproc+0xd6>
  p->pagetable = proc_pagetable(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	e3a080e7          	jalr	-454(ra) # 80000f40 <proc_pagetable>
    8000110e:	892a                	mv	s2,a0
    80001110:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001112:	c935                	beqz	a0,80001186 <allocproc+0xee>
  memset(&p->context, 0, sizeof(p->context));
    80001114:	07000613          	li	a2,112
    80001118:	4581                	li	a1,0
    8000111a:	06048513          	addi	a0,s1,96
    8000111e:	fffff097          	auipc	ra,0xfffff
    80001122:	05c080e7          	jalr	92(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001126:	00000797          	auipc	a5,0x0
    8000112a:	d8e78793          	addi	a5,a5,-626 # 80000eb4 <forkret>
    8000112e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001130:	60bc                	ld	a5,64(s1)
    80001132:	6705                	lui	a4,0x1
    80001134:	97ba                	add	a5,a5,a4
    80001136:	f4bc                	sd	a5,104(s1)
  p->count=0;
    80001138:	1604a623          	sw	zero,364(s1)
  p->handler=0;
    8000113c:	1604b823          	sd	zero,368(s1)
  p->handler_exec=0;
    80001140:	1804a023          	sw	zero,384(s1)
  p->ticks=0;
    80001144:	1604a423          	sw	zero,360(s1)
}
    80001148:	8526                	mv	a0,s1
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6902                	ld	s2,0(sp)
    80001152:	6105                	addi	sp,sp,32
    80001154:	8082                	ret
    freeproc(p);
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	ed6080e7          	jalr	-298(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001160:	8526                	mv	a0,s1
    80001162:	00005097          	auipc	ra,0x5
    80001166:	294080e7          	jalr	660(ra) # 800063f6 <release>
    return 0;
    8000116a:	84ca                	mv	s1,s2
    8000116c:	bff1                	j	80001148 <allocproc+0xb0>
    freeproc(p);
    8000116e:	8526                	mv	a0,s1
    80001170:	00000097          	auipc	ra,0x0
    80001174:	ebe080e7          	jalr	-322(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001178:	8526                	mv	a0,s1
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	27c080e7          	jalr	636(ra) # 800063f6 <release>
    return 0;
    80001182:	84ca                	mv	s1,s2
    80001184:	b7d1                	j	80001148 <allocproc+0xb0>
    freeproc(p);
    80001186:	8526                	mv	a0,s1
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	ea6080e7          	jalr	-346(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001190:	8526                	mv	a0,s1
    80001192:	00005097          	auipc	ra,0x5
    80001196:	264080e7          	jalr	612(ra) # 800063f6 <release>
    return 0;
    8000119a:	84ca                	mv	s1,s2
    8000119c:	b775                	j	80001148 <allocproc+0xb0>

000000008000119e <userinit>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	1000                	addi	s0,sp,32
  p = allocproc();
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	ef0080e7          	jalr	-272(ra) # 80001098 <allocproc>
    800011b0:	84aa                	mv	s1,a0
  initproc = p;
    800011b2:	0000b797          	auipc	a5,0xb
    800011b6:	e4a7bf23          	sd	a0,-418(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011ba:	03400613          	li	a2,52
    800011be:	0000a597          	auipc	a1,0xa
    800011c2:	ed258593          	addi	a1,a1,-302 # 8000b090 <initcode>
    800011c6:	6928                	ld	a0,80(a0)
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	63a080e7          	jalr	1594(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    800011d0:	6785                	lui	a5,0x1
    800011d2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011d4:	6cb8                	ld	a4,88(s1)
    800011d6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011da:	6cb8                	ld	a4,88(s1)
    800011dc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011de:	4641                	li	a2,16
    800011e0:	00007597          	auipc	a1,0x7
    800011e4:	fa058593          	addi	a1,a1,-96 # 80008180 <etext+0x180>
    800011e8:	15848513          	addi	a0,s1,344
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	0d0080e7          	jalr	208(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800011f4:	00007517          	auipc	a0,0x7
    800011f8:	f9c50513          	addi	a0,a0,-100 # 80008190 <etext+0x190>
    800011fc:	00002097          	auipc	ra,0x2
    80001200:	1ca080e7          	jalr	458(ra) # 800033c6 <namei>
    80001204:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001208:	478d                	li	a5,3
    8000120a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000120c:	8526                	mv	a0,s1
    8000120e:	00005097          	auipc	ra,0x5
    80001212:	1e8080e7          	jalr	488(ra) # 800063f6 <release>
}
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6105                	addi	sp,sp,32
    8000121e:	8082                	ret

0000000080001220 <growproc>:
{
    80001220:	1101                	addi	sp,sp,-32
    80001222:	ec06                	sd	ra,24(sp)
    80001224:	e822                	sd	s0,16(sp)
    80001226:	e426                	sd	s1,8(sp)
    80001228:	e04a                	sd	s2,0(sp)
    8000122a:	1000                	addi	s0,sp,32
    8000122c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	c4e080e7          	jalr	-946(ra) # 80000e7c <myproc>
    80001236:	892a                	mv	s2,a0
  sz = p->sz;
    80001238:	652c                	ld	a1,72(a0)
    8000123a:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000123e:	00904f63          	bgtz	s1,8000125c <growproc+0x3c>
  } else if(n < 0){
    80001242:	0204cd63          	bltz	s1,8000127c <growproc+0x5c>
  p->sz = sz;
    80001246:	1782                	slli	a5,a5,0x20
    80001248:	9381                	srli	a5,a5,0x20
    8000124a:	04f93423          	sd	a5,72(s2)
  return 0;
    8000124e:	4501                	li	a0,0
}
    80001250:	60e2                	ld	ra,24(sp)
    80001252:	6442                	ld	s0,16(sp)
    80001254:	64a2                	ld	s1,8(sp)
    80001256:	6902                	ld	s2,0(sp)
    80001258:	6105                	addi	sp,sp,32
    8000125a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000125c:	00f4863b          	addw	a2,s1,a5
    80001260:	1602                	slli	a2,a2,0x20
    80001262:	9201                	srli	a2,a2,0x20
    80001264:	1582                	slli	a1,a1,0x20
    80001266:	9181                	srli	a1,a1,0x20
    80001268:	6928                	ld	a0,80(a0)
    8000126a:	fffff097          	auipc	ra,0xfffff
    8000126e:	652080e7          	jalr	1618(ra) # 800008bc <uvmalloc>
    80001272:	0005079b          	sext.w	a5,a0
    80001276:	fbe1                	bnez	a5,80001246 <growproc+0x26>
      return -1;
    80001278:	557d                	li	a0,-1
    8000127a:	bfd9                	j	80001250 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000127c:	00f4863b          	addw	a2,s1,a5
    80001280:	1602                	slli	a2,a2,0x20
    80001282:	9201                	srli	a2,a2,0x20
    80001284:	1582                	slli	a1,a1,0x20
    80001286:	9181                	srli	a1,a1,0x20
    80001288:	6928                	ld	a0,80(a0)
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	5ea080e7          	jalr	1514(ra) # 80000874 <uvmdealloc>
    80001292:	0005079b          	sext.w	a5,a0
    80001296:	bf45                	j	80001246 <growproc+0x26>

0000000080001298 <fork>:
{
    80001298:	7139                	addi	sp,sp,-64
    8000129a:	fc06                	sd	ra,56(sp)
    8000129c:	f822                	sd	s0,48(sp)
    8000129e:	f04a                	sd	s2,32(sp)
    800012a0:	e456                	sd	s5,8(sp)
    800012a2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	bd8080e7          	jalr	-1064(ra) # 80000e7c <myproc>
    800012ac:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	dea080e7          	jalr	-534(ra) # 80001098 <allocproc>
    800012b6:	12050063          	beqz	a0,800013d6 <fork+0x13e>
    800012ba:	e852                	sd	s4,16(sp)
    800012bc:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012be:	048ab603          	ld	a2,72(s5)
    800012c2:	692c                	ld	a1,80(a0)
    800012c4:	050ab503          	ld	a0,80(s5)
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	74c080e7          	jalr	1868(ra) # 80000a14 <uvmcopy>
    800012d0:	04054a63          	bltz	a0,80001324 <fork+0x8c>
    800012d4:	f426                	sd	s1,40(sp)
    800012d6:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800012d8:	048ab783          	ld	a5,72(s5)
    800012dc:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012e0:	058ab683          	ld	a3,88(s5)
    800012e4:	87b6                	mv	a5,a3
    800012e6:	058a3703          	ld	a4,88(s4)
    800012ea:	12068693          	addi	a3,a3,288
    800012ee:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012f2:	6788                	ld	a0,8(a5)
    800012f4:	6b8c                	ld	a1,16(a5)
    800012f6:	6f90                	ld	a2,24(a5)
    800012f8:	01073023          	sd	a6,0(a4)
    800012fc:	e708                	sd	a0,8(a4)
    800012fe:	eb0c                	sd	a1,16(a4)
    80001300:	ef10                	sd	a2,24(a4)
    80001302:	02078793          	addi	a5,a5,32
    80001306:	02070713          	addi	a4,a4,32
    8000130a:	fed792e3          	bne	a5,a3,800012ee <fork+0x56>
  np->trapframe->a0 = 0;
    8000130e:	058a3783          	ld	a5,88(s4)
    80001312:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001316:	0d0a8493          	addi	s1,s5,208
    8000131a:	0d0a0913          	addi	s2,s4,208
    8000131e:	150a8993          	addi	s3,s5,336
    80001322:	a015                	j	80001346 <fork+0xae>
    freeproc(np);
    80001324:	8552                	mv	a0,s4
    80001326:	00000097          	auipc	ra,0x0
    8000132a:	d08080e7          	jalr	-760(ra) # 8000102e <freeproc>
    release(&np->lock);
    8000132e:	8552                	mv	a0,s4
    80001330:	00005097          	auipc	ra,0x5
    80001334:	0c6080e7          	jalr	198(ra) # 800063f6 <release>
    return -1;
    80001338:	597d                	li	s2,-1
    8000133a:	6a42                	ld	s4,16(sp)
    8000133c:	a071                	j	800013c8 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000133e:	04a1                	addi	s1,s1,8
    80001340:	0921                	addi	s2,s2,8
    80001342:	01348b63          	beq	s1,s3,80001358 <fork+0xc0>
    if(p->ofile[i])
    80001346:	6088                	ld	a0,0(s1)
    80001348:	d97d                	beqz	a0,8000133e <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000134a:	00002097          	auipc	ra,0x2
    8000134e:	6f4080e7          	jalr	1780(ra) # 80003a3e <filedup>
    80001352:	00a93023          	sd	a0,0(s2)
    80001356:	b7e5                	j	8000133e <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001358:	150ab503          	ld	a0,336(s5)
    8000135c:	00002097          	auipc	ra,0x2
    80001360:	85a080e7          	jalr	-1958(ra) # 80002bb6 <idup>
    80001364:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001368:	4641                	li	a2,16
    8000136a:	158a8593          	addi	a1,s5,344
    8000136e:	158a0513          	addi	a0,s4,344
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	f4a080e7          	jalr	-182(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    8000137a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000137e:	8552                	mv	a0,s4
    80001380:	00005097          	auipc	ra,0x5
    80001384:	076080e7          	jalr	118(ra) # 800063f6 <release>
  acquire(&wait_lock);
    80001388:	0000b497          	auipc	s1,0xb
    8000138c:	ce048493          	addi	s1,s1,-800 # 8000c068 <wait_lock>
    80001390:	8526                	mv	a0,s1
    80001392:	00005097          	auipc	ra,0x5
    80001396:	fb0080e7          	jalr	-80(ra) # 80006342 <acquire>
  np->parent = p;
    8000139a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000139e:	8526                	mv	a0,s1
    800013a0:	00005097          	auipc	ra,0x5
    800013a4:	056080e7          	jalr	86(ra) # 800063f6 <release>
  acquire(&np->lock);
    800013a8:	8552                	mv	a0,s4
    800013aa:	00005097          	auipc	ra,0x5
    800013ae:	f98080e7          	jalr	-104(ra) # 80006342 <acquire>
  np->state = RUNNABLE;
    800013b2:	478d                	li	a5,3
    800013b4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013b8:	8552                	mv	a0,s4
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	03c080e7          	jalr	60(ra) # 800063f6 <release>
  return pid;
    800013c2:	74a2                	ld	s1,40(sp)
    800013c4:	69e2                	ld	s3,24(sp)
    800013c6:	6a42                	ld	s4,16(sp)
}
    800013c8:	854a                	mv	a0,s2
    800013ca:	70e2                	ld	ra,56(sp)
    800013cc:	7442                	ld	s0,48(sp)
    800013ce:	7902                	ld	s2,32(sp)
    800013d0:	6aa2                	ld	s5,8(sp)
    800013d2:	6121                	addi	sp,sp,64
    800013d4:	8082                	ret
    return -1;
    800013d6:	597d                	li	s2,-1
    800013d8:	bfc5                	j	800013c8 <fork+0x130>

00000000800013da <scheduler>:
{
    800013da:	7139                	addi	sp,sp,-64
    800013dc:	fc06                	sd	ra,56(sp)
    800013de:	f822                	sd	s0,48(sp)
    800013e0:	f426                	sd	s1,40(sp)
    800013e2:	f04a                	sd	s2,32(sp)
    800013e4:	ec4e                	sd	s3,24(sp)
    800013e6:	e852                	sd	s4,16(sp)
    800013e8:	e456                	sd	s5,8(sp)
    800013ea:	e05a                	sd	s6,0(sp)
    800013ec:	0080                	addi	s0,sp,64
    800013ee:	8792                	mv	a5,tp
  int id = r_tp();
    800013f0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013f2:	00779a93          	slli	s5,a5,0x7
    800013f6:	0000b717          	auipc	a4,0xb
    800013fa:	c5a70713          	addi	a4,a4,-934 # 8000c050 <pid_lock>
    800013fe:	9756                	add	a4,a4,s5
    80001400:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001404:	0000b717          	auipc	a4,0xb
    80001408:	c8470713          	addi	a4,a4,-892 # 8000c088 <cpus+0x8>
    8000140c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000140e:	498d                	li	s3,3
        p->state = RUNNING;
    80001410:	4b11                	li	s6,4
        c->proc = p;
    80001412:	079e                	slli	a5,a5,0x7
    80001414:	0000ba17          	auipc	s4,0xb
    80001418:	c3ca0a13          	addi	s4,s4,-964 # 8000c050 <pid_lock>
    8000141c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000141e:	00011917          	auipc	s2,0x11
    80001422:	26290913          	addi	s2,s2,610 # 80012680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001426:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000142a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000142e:	10079073          	csrw	sstatus,a5
    80001432:	0000b497          	auipc	s1,0xb
    80001436:	04e48493          	addi	s1,s1,78 # 8000c480 <proc>
    8000143a:	a811                	j	8000144e <scheduler+0x74>
      release(&p->lock);
    8000143c:	8526                	mv	a0,s1
    8000143e:	00005097          	auipc	ra,0x5
    80001442:	fb8080e7          	jalr	-72(ra) # 800063f6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001446:	18848493          	addi	s1,s1,392
    8000144a:	fd248ee3          	beq	s1,s2,80001426 <scheduler+0x4c>
      acquire(&p->lock);
    8000144e:	8526                	mv	a0,s1
    80001450:	00005097          	auipc	ra,0x5
    80001454:	ef2080e7          	jalr	-270(ra) # 80006342 <acquire>
      if(p->state == RUNNABLE) {
    80001458:	4c9c                	lw	a5,24(s1)
    8000145a:	ff3791e3          	bne	a5,s3,8000143c <scheduler+0x62>
        p->state = RUNNING;
    8000145e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001462:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001466:	06048593          	addi	a1,s1,96
    8000146a:	8556                	mv	a0,s5
    8000146c:	00000097          	auipc	ra,0x0
    80001470:	620080e7          	jalr	1568(ra) # 80001a8c <swtch>
        c->proc = 0;
    80001474:	020a3823          	sd	zero,48(s4)
    80001478:	b7d1                	j	8000143c <scheduler+0x62>

000000008000147a <sched>:
{
    8000147a:	7179                	addi	sp,sp,-48
    8000147c:	f406                	sd	ra,40(sp)
    8000147e:	f022                	sd	s0,32(sp)
    80001480:	ec26                	sd	s1,24(sp)
    80001482:	e84a                	sd	s2,16(sp)
    80001484:	e44e                	sd	s3,8(sp)
    80001486:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001488:	00000097          	auipc	ra,0x0
    8000148c:	9f4080e7          	jalr	-1548(ra) # 80000e7c <myproc>
    80001490:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001492:	00005097          	auipc	ra,0x5
    80001496:	e36080e7          	jalr	-458(ra) # 800062c8 <holding>
    8000149a:	c93d                	beqz	a0,80001510 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000149c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000149e:	2781                	sext.w	a5,a5
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	0000b717          	auipc	a4,0xb
    800014a6:	bae70713          	addi	a4,a4,-1106 # 8000c050 <pid_lock>
    800014aa:	97ba                	add	a5,a5,a4
    800014ac:	0a87a703          	lw	a4,168(a5)
    800014b0:	4785                	li	a5,1
    800014b2:	06f71763          	bne	a4,a5,80001520 <sched+0xa6>
  if(p->state == RUNNING)
    800014b6:	4c98                	lw	a4,24(s1)
    800014b8:	4791                	li	a5,4
    800014ba:	06f70b63          	beq	a4,a5,80001530 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014be:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014c2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014c4:	efb5                	bnez	a5,80001540 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014c6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c8:	0000b917          	auipc	s2,0xb
    800014cc:	b8890913          	addi	s2,s2,-1144 # 8000c050 <pid_lock>
    800014d0:	2781                	sext.w	a5,a5
    800014d2:	079e                	slli	a5,a5,0x7
    800014d4:	97ca                	add	a5,a5,s2
    800014d6:	0ac7a983          	lw	s3,172(a5)
    800014da:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014dc:	2781                	sext.w	a5,a5
    800014de:	079e                	slli	a5,a5,0x7
    800014e0:	0000b597          	auipc	a1,0xb
    800014e4:	ba858593          	addi	a1,a1,-1112 # 8000c088 <cpus+0x8>
    800014e8:	95be                	add	a1,a1,a5
    800014ea:	06048513          	addi	a0,s1,96
    800014ee:	00000097          	auipc	ra,0x0
    800014f2:	59e080e7          	jalr	1438(ra) # 80001a8c <swtch>
    800014f6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f8:	2781                	sext.w	a5,a5
    800014fa:	079e                	slli	a5,a5,0x7
    800014fc:	993e                	add	s2,s2,a5
    800014fe:	0b392623          	sw	s3,172(s2)
}
    80001502:	70a2                	ld	ra,40(sp)
    80001504:	7402                	ld	s0,32(sp)
    80001506:	64e2                	ld	s1,24(sp)
    80001508:	6942                	ld	s2,16(sp)
    8000150a:	69a2                	ld	s3,8(sp)
    8000150c:	6145                	addi	sp,sp,48
    8000150e:	8082                	ret
    panic("sched p->lock");
    80001510:	00007517          	auipc	a0,0x7
    80001514:	c8850513          	addi	a0,a0,-888 # 80008198 <etext+0x198>
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	8da080e7          	jalr	-1830(ra) # 80005df2 <panic>
    panic("sched locks");
    80001520:	00007517          	auipc	a0,0x7
    80001524:	c8850513          	addi	a0,a0,-888 # 800081a8 <etext+0x1a8>
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	8ca080e7          	jalr	-1846(ra) # 80005df2 <panic>
    panic("sched running");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	c8850513          	addi	a0,a0,-888 # 800081b8 <etext+0x1b8>
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	8ba080e7          	jalr	-1862(ra) # 80005df2 <panic>
    panic("sched interruptible");
    80001540:	00007517          	auipc	a0,0x7
    80001544:	c8850513          	addi	a0,a0,-888 # 800081c8 <etext+0x1c8>
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	8aa080e7          	jalr	-1878(ra) # 80005df2 <panic>

0000000080001550 <yield>:
{
    80001550:	1101                	addi	sp,sp,-32
    80001552:	ec06                	sd	ra,24(sp)
    80001554:	e822                	sd	s0,16(sp)
    80001556:	e426                	sd	s1,8(sp)
    80001558:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	922080e7          	jalr	-1758(ra) # 80000e7c <myproc>
    80001562:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001564:	00005097          	auipc	ra,0x5
    80001568:	dde080e7          	jalr	-546(ra) # 80006342 <acquire>
  p->state = RUNNABLE;
    8000156c:	478d                	li	a5,3
    8000156e:	cc9c                	sw	a5,24(s1)
  sched();
    80001570:	00000097          	auipc	ra,0x0
    80001574:	f0a080e7          	jalr	-246(ra) # 8000147a <sched>
  release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	e7c080e7          	jalr	-388(ra) # 800063f6 <release>
}
    80001582:	60e2                	ld	ra,24(sp)
    80001584:	6442                	ld	s0,16(sp)
    80001586:	64a2                	ld	s1,8(sp)
    80001588:	6105                	addi	sp,sp,32
    8000158a:	8082                	ret

000000008000158c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000158c:	7179                	addi	sp,sp,-48
    8000158e:	f406                	sd	ra,40(sp)
    80001590:	f022                	sd	s0,32(sp)
    80001592:	ec26                	sd	s1,24(sp)
    80001594:	e84a                	sd	s2,16(sp)
    80001596:	e44e                	sd	s3,8(sp)
    80001598:	1800                	addi	s0,sp,48
    8000159a:	89aa                	mv	s3,a0
    8000159c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	8de080e7          	jalr	-1826(ra) # 80000e7c <myproc>
    800015a6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	d9a080e7          	jalr	-614(ra) # 80006342 <acquire>
  release(lk);
    800015b0:	854a                	mv	a0,s2
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	e44080e7          	jalr	-444(ra) # 800063f6 <release>

  // Go to sleep.
  p->chan = chan;
    800015ba:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015be:	4789                	li	a5,2
    800015c0:	cc9c                	sw	a5,24(s1)

  sched();
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	eb8080e7          	jalr	-328(ra) # 8000147a <sched>

  // Tidy up.
  p->chan = 0;
    800015ca:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015ce:	8526                	mv	a0,s1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	e26080e7          	jalr	-474(ra) # 800063f6 <release>
  acquire(lk);
    800015d8:	854a                	mv	a0,s2
    800015da:	00005097          	auipc	ra,0x5
    800015de:	d68080e7          	jalr	-664(ra) # 80006342 <acquire>
}
    800015e2:	70a2                	ld	ra,40(sp)
    800015e4:	7402                	ld	s0,32(sp)
    800015e6:	64e2                	ld	s1,24(sp)
    800015e8:	6942                	ld	s2,16(sp)
    800015ea:	69a2                	ld	s3,8(sp)
    800015ec:	6145                	addi	sp,sp,48
    800015ee:	8082                	ret

00000000800015f0 <wait>:
{
    800015f0:	715d                	addi	sp,sp,-80
    800015f2:	e486                	sd	ra,72(sp)
    800015f4:	e0a2                	sd	s0,64(sp)
    800015f6:	fc26                	sd	s1,56(sp)
    800015f8:	f84a                	sd	s2,48(sp)
    800015fa:	f44e                	sd	s3,40(sp)
    800015fc:	f052                	sd	s4,32(sp)
    800015fe:	ec56                	sd	s5,24(sp)
    80001600:	e85a                	sd	s6,16(sp)
    80001602:	e45e                	sd	s7,8(sp)
    80001604:	e062                	sd	s8,0(sp)
    80001606:	0880                	addi	s0,sp,80
    80001608:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000160a:	00000097          	auipc	ra,0x0
    8000160e:	872080e7          	jalr	-1934(ra) # 80000e7c <myproc>
    80001612:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001614:	0000b517          	auipc	a0,0xb
    80001618:	a5450513          	addi	a0,a0,-1452 # 8000c068 <wait_lock>
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	d26080e7          	jalr	-730(ra) # 80006342 <acquire>
    havekids = 0;
    80001624:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001626:	4a15                	li	s4,5
        havekids = 1;
    80001628:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000162a:	00011997          	auipc	s3,0x11
    8000162e:	05698993          	addi	s3,s3,86 # 80012680 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001632:	0000bc17          	auipc	s8,0xb
    80001636:	a36c0c13          	addi	s8,s8,-1482 # 8000c068 <wait_lock>
    8000163a:	a87d                	j	800016f8 <wait+0x108>
          pid = np->pid;
    8000163c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001640:	000b0e63          	beqz	s6,8000165c <wait+0x6c>
    80001644:	4691                	li	a3,4
    80001646:	02c48613          	addi	a2,s1,44
    8000164a:	85da                	mv	a1,s6
    8000164c:	05093503          	ld	a0,80(s2)
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	4c8080e7          	jalr	1224(ra) # 80000b18 <copyout>
    80001658:	04054163          	bltz	a0,8000169a <wait+0xaa>
          freeproc(np);
    8000165c:	8526                	mv	a0,s1
    8000165e:	00000097          	auipc	ra,0x0
    80001662:	9d0080e7          	jalr	-1584(ra) # 8000102e <freeproc>
          release(&np->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	d8e080e7          	jalr	-626(ra) # 800063f6 <release>
          release(&wait_lock);
    80001670:	0000b517          	auipc	a0,0xb
    80001674:	9f850513          	addi	a0,a0,-1544 # 8000c068 <wait_lock>
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	d7e080e7          	jalr	-642(ra) # 800063f6 <release>
}
    80001680:	854e                	mv	a0,s3
    80001682:	60a6                	ld	ra,72(sp)
    80001684:	6406                	ld	s0,64(sp)
    80001686:	74e2                	ld	s1,56(sp)
    80001688:	7942                	ld	s2,48(sp)
    8000168a:	79a2                	ld	s3,40(sp)
    8000168c:	7a02                	ld	s4,32(sp)
    8000168e:	6ae2                	ld	s5,24(sp)
    80001690:	6b42                	ld	s6,16(sp)
    80001692:	6ba2                	ld	s7,8(sp)
    80001694:	6c02                	ld	s8,0(sp)
    80001696:	6161                	addi	sp,sp,80
    80001698:	8082                	ret
            release(&np->lock);
    8000169a:	8526                	mv	a0,s1
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	d5a080e7          	jalr	-678(ra) # 800063f6 <release>
            release(&wait_lock);
    800016a4:	0000b517          	auipc	a0,0xb
    800016a8:	9c450513          	addi	a0,a0,-1596 # 8000c068 <wait_lock>
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	d4a080e7          	jalr	-694(ra) # 800063f6 <release>
            return -1;
    800016b4:	59fd                	li	s3,-1
    800016b6:	b7e9                	j	80001680 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800016b8:	18848493          	addi	s1,s1,392
    800016bc:	03348463          	beq	s1,s3,800016e4 <wait+0xf4>
      if(np->parent == p){
    800016c0:	7c9c                	ld	a5,56(s1)
    800016c2:	ff279be3          	bne	a5,s2,800016b8 <wait+0xc8>
        acquire(&np->lock);
    800016c6:	8526                	mv	a0,s1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	c7a080e7          	jalr	-902(ra) # 80006342 <acquire>
        if(np->state == ZOMBIE){
    800016d0:	4c9c                	lw	a5,24(s1)
    800016d2:	f74785e3          	beq	a5,s4,8000163c <wait+0x4c>
        release(&np->lock);
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	d1e080e7          	jalr	-738(ra) # 800063f6 <release>
        havekids = 1;
    800016e0:	8756                	mv	a4,s5
    800016e2:	bfd9                	j	800016b8 <wait+0xc8>
    if(!havekids || p->killed){
    800016e4:	c305                	beqz	a4,80001704 <wait+0x114>
    800016e6:	02892783          	lw	a5,40(s2)
    800016ea:	ef89                	bnez	a5,80001704 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ec:	85e2                	mv	a1,s8
    800016ee:	854a                	mv	a0,s2
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	e9c080e7          	jalr	-356(ra) # 8000158c <sleep>
    havekids = 0;
    800016f8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016fa:	0000b497          	auipc	s1,0xb
    800016fe:	d8648493          	addi	s1,s1,-634 # 8000c480 <proc>
    80001702:	bf7d                	j	800016c0 <wait+0xd0>
      release(&wait_lock);
    80001704:	0000b517          	auipc	a0,0xb
    80001708:	96450513          	addi	a0,a0,-1692 # 8000c068 <wait_lock>
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	cea080e7          	jalr	-790(ra) # 800063f6 <release>
      return -1;
    80001714:	59fd                	li	s3,-1
    80001716:	b7ad                	j	80001680 <wait+0x90>

0000000080001718 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001718:	7139                	addi	sp,sp,-64
    8000171a:	fc06                	sd	ra,56(sp)
    8000171c:	f822                	sd	s0,48(sp)
    8000171e:	f426                	sd	s1,40(sp)
    80001720:	f04a                	sd	s2,32(sp)
    80001722:	ec4e                	sd	s3,24(sp)
    80001724:	e852                	sd	s4,16(sp)
    80001726:	e456                	sd	s5,8(sp)
    80001728:	0080                	addi	s0,sp,64
    8000172a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000172c:	0000b497          	auipc	s1,0xb
    80001730:	d5448493          	addi	s1,s1,-684 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001734:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001736:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001738:	00011917          	auipc	s2,0x11
    8000173c:	f4890913          	addi	s2,s2,-184 # 80012680 <tickslock>
    80001740:	a811                	j	80001754 <wakeup+0x3c>
      }
      release(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	cb2080e7          	jalr	-846(ra) # 800063f6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000174c:	18848493          	addi	s1,s1,392
    80001750:	03248663          	beq	s1,s2,8000177c <wakeup+0x64>
    if(p != myproc()){
    80001754:	fffff097          	auipc	ra,0xfffff
    80001758:	728080e7          	jalr	1832(ra) # 80000e7c <myproc>
    8000175c:	fea488e3          	beq	s1,a0,8000174c <wakeup+0x34>
      acquire(&p->lock);
    80001760:	8526                	mv	a0,s1
    80001762:	00005097          	auipc	ra,0x5
    80001766:	be0080e7          	jalr	-1056(ra) # 80006342 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000176a:	4c9c                	lw	a5,24(s1)
    8000176c:	fd379be3          	bne	a5,s3,80001742 <wakeup+0x2a>
    80001770:	709c                	ld	a5,32(s1)
    80001772:	fd4798e3          	bne	a5,s4,80001742 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001776:	0154ac23          	sw	s5,24(s1)
    8000177a:	b7e1                	j	80001742 <wakeup+0x2a>
    }
  }
}
    8000177c:	70e2                	ld	ra,56(sp)
    8000177e:	7442                	ld	s0,48(sp)
    80001780:	74a2                	ld	s1,40(sp)
    80001782:	7902                	ld	s2,32(sp)
    80001784:	69e2                	ld	s3,24(sp)
    80001786:	6a42                	ld	s4,16(sp)
    80001788:	6aa2                	ld	s5,8(sp)
    8000178a:	6121                	addi	sp,sp,64
    8000178c:	8082                	ret

000000008000178e <reparent>:
{
    8000178e:	7179                	addi	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	e052                	sd	s4,0(sp)
    8000179c:	1800                	addi	s0,sp,48
    8000179e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017a0:	0000b497          	auipc	s1,0xb
    800017a4:	ce048493          	addi	s1,s1,-800 # 8000c480 <proc>
      pp->parent = initproc;
    800017a8:	0000ba17          	auipc	s4,0xb
    800017ac:	868a0a13          	addi	s4,s4,-1944 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017b0:	00011997          	auipc	s3,0x11
    800017b4:	ed098993          	addi	s3,s3,-304 # 80012680 <tickslock>
    800017b8:	a029                	j	800017c2 <reparent+0x34>
    800017ba:	18848493          	addi	s1,s1,392
    800017be:	01348d63          	beq	s1,s3,800017d8 <reparent+0x4a>
    if(pp->parent == p){
    800017c2:	7c9c                	ld	a5,56(s1)
    800017c4:	ff279be3          	bne	a5,s2,800017ba <reparent+0x2c>
      pp->parent = initproc;
    800017c8:	000a3503          	ld	a0,0(s4)
    800017cc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017ce:	00000097          	auipc	ra,0x0
    800017d2:	f4a080e7          	jalr	-182(ra) # 80001718 <wakeup>
    800017d6:	b7d5                	j	800017ba <reparent+0x2c>
}
    800017d8:	70a2                	ld	ra,40(sp)
    800017da:	7402                	ld	s0,32(sp)
    800017dc:	64e2                	ld	s1,24(sp)
    800017de:	6942                	ld	s2,16(sp)
    800017e0:	69a2                	ld	s3,8(sp)
    800017e2:	6a02                	ld	s4,0(sp)
    800017e4:	6145                	addi	sp,sp,48
    800017e6:	8082                	ret

00000000800017e8 <exit>:
{
    800017e8:	7179                	addi	sp,sp,-48
    800017ea:	f406                	sd	ra,40(sp)
    800017ec:	f022                	sd	s0,32(sp)
    800017ee:	ec26                	sd	s1,24(sp)
    800017f0:	e84a                	sd	s2,16(sp)
    800017f2:	e44e                	sd	s3,8(sp)
    800017f4:	e052                	sd	s4,0(sp)
    800017f6:	1800                	addi	s0,sp,48
    800017f8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	682080e7          	jalr	1666(ra) # 80000e7c <myproc>
    80001802:	89aa                	mv	s3,a0
  if(p == initproc)
    80001804:	0000b797          	auipc	a5,0xb
    80001808:	80c7b783          	ld	a5,-2036(a5) # 8000c010 <initproc>
    8000180c:	0d050493          	addi	s1,a0,208
    80001810:	15050913          	addi	s2,a0,336
    80001814:	02a79363          	bne	a5,a0,8000183a <exit+0x52>
    panic("init exiting");
    80001818:	00007517          	auipc	a0,0x7
    8000181c:	9c850513          	addi	a0,a0,-1592 # 800081e0 <etext+0x1e0>
    80001820:	00004097          	auipc	ra,0x4
    80001824:	5d2080e7          	jalr	1490(ra) # 80005df2 <panic>
      fileclose(f);
    80001828:	00002097          	auipc	ra,0x2
    8000182c:	268080e7          	jalr	616(ra) # 80003a90 <fileclose>
      p->ofile[fd] = 0;
    80001830:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001834:	04a1                	addi	s1,s1,8
    80001836:	01248563          	beq	s1,s2,80001840 <exit+0x58>
    if(p->ofile[fd]){
    8000183a:	6088                	ld	a0,0(s1)
    8000183c:	f575                	bnez	a0,80001828 <exit+0x40>
    8000183e:	bfdd                	j	80001834 <exit+0x4c>
  begin_op();
    80001840:	00002097          	auipc	ra,0x2
    80001844:	d86080e7          	jalr	-634(ra) # 800035c6 <begin_op>
  iput(p->cwd);
    80001848:	1509b503          	ld	a0,336(s3)
    8000184c:	00001097          	auipc	ra,0x1
    80001850:	566080e7          	jalr	1382(ra) # 80002db2 <iput>
  end_op();
    80001854:	00002097          	auipc	ra,0x2
    80001858:	dec080e7          	jalr	-532(ra) # 80003640 <end_op>
  p->cwd = 0;
    8000185c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001860:	0000b497          	auipc	s1,0xb
    80001864:	80848493          	addi	s1,s1,-2040 # 8000c068 <wait_lock>
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	ad8080e7          	jalr	-1320(ra) # 80006342 <acquire>
  reparent(p);
    80001872:	854e                	mv	a0,s3
    80001874:	00000097          	auipc	ra,0x0
    80001878:	f1a080e7          	jalr	-230(ra) # 8000178e <reparent>
  wakeup(p->parent);
    8000187c:	0389b503          	ld	a0,56(s3)
    80001880:	00000097          	auipc	ra,0x0
    80001884:	e98080e7          	jalr	-360(ra) # 80001718 <wakeup>
  acquire(&p->lock);
    80001888:	854e                	mv	a0,s3
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	ab8080e7          	jalr	-1352(ra) # 80006342 <acquire>
  p->xstate = status;
    80001892:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001896:	4795                	li	a5,5
    80001898:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	b58080e7          	jalr	-1192(ra) # 800063f6 <release>
  sched();
    800018a6:	00000097          	auipc	ra,0x0
    800018aa:	bd4080e7          	jalr	-1068(ra) # 8000147a <sched>
  panic("zombie exit");
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	94250513          	addi	a0,a0,-1726 # 800081f0 <etext+0x1f0>
    800018b6:	00004097          	auipc	ra,0x4
    800018ba:	53c080e7          	jalr	1340(ra) # 80005df2 <panic>

00000000800018be <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018be:	7179                	addi	sp,sp,-48
    800018c0:	f406                	sd	ra,40(sp)
    800018c2:	f022                	sd	s0,32(sp)
    800018c4:	ec26                	sd	s1,24(sp)
    800018c6:	e84a                	sd	s2,16(sp)
    800018c8:	e44e                	sd	s3,8(sp)
    800018ca:	1800                	addi	s0,sp,48
    800018cc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018ce:	0000b497          	auipc	s1,0xb
    800018d2:	bb248493          	addi	s1,s1,-1102 # 8000c480 <proc>
    800018d6:	00011997          	auipc	s3,0x11
    800018da:	daa98993          	addi	s3,s3,-598 # 80012680 <tickslock>
    acquire(&p->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	a62080e7          	jalr	-1438(ra) # 80006342 <acquire>
    if(p->pid == pid){
    800018e8:	589c                	lw	a5,48(s1)
    800018ea:	01278d63          	beq	a5,s2,80001904 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	b06080e7          	jalr	-1274(ra) # 800063f6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018f8:	18848493          	addi	s1,s1,392
    800018fc:	ff3491e3          	bne	s1,s3,800018de <kill+0x20>
  }
  return -1;
    80001900:	557d                	li	a0,-1
    80001902:	a829                	j	8000191c <kill+0x5e>
      p->killed = 1;
    80001904:	4785                	li	a5,1
    80001906:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001908:	4c98                	lw	a4,24(s1)
    8000190a:	4789                	li	a5,2
    8000190c:	00f70f63          	beq	a4,a5,8000192a <kill+0x6c>
      release(&p->lock);
    80001910:	8526                	mv	a0,s1
    80001912:	00005097          	auipc	ra,0x5
    80001916:	ae4080e7          	jalr	-1308(ra) # 800063f6 <release>
      return 0;
    8000191a:	4501                	li	a0,0
}
    8000191c:	70a2                	ld	ra,40(sp)
    8000191e:	7402                	ld	s0,32(sp)
    80001920:	64e2                	ld	s1,24(sp)
    80001922:	6942                	ld	s2,16(sp)
    80001924:	69a2                	ld	s3,8(sp)
    80001926:	6145                	addi	sp,sp,48
    80001928:	8082                	ret
        p->state = RUNNABLE;
    8000192a:	478d                	li	a5,3
    8000192c:	cc9c                	sw	a5,24(s1)
    8000192e:	b7cd                	j	80001910 <kill+0x52>

0000000080001930 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001930:	7179                	addi	sp,sp,-48
    80001932:	f406                	sd	ra,40(sp)
    80001934:	f022                	sd	s0,32(sp)
    80001936:	ec26                	sd	s1,24(sp)
    80001938:	e84a                	sd	s2,16(sp)
    8000193a:	e44e                	sd	s3,8(sp)
    8000193c:	e052                	sd	s4,0(sp)
    8000193e:	1800                	addi	s0,sp,48
    80001940:	84aa                	mv	s1,a0
    80001942:	892e                	mv	s2,a1
    80001944:	89b2                	mv	s3,a2
    80001946:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	534080e7          	jalr	1332(ra) # 80000e7c <myproc>
  if(user_dst){
    80001950:	c08d                	beqz	s1,80001972 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001952:	86d2                	mv	a3,s4
    80001954:	864e                	mv	a2,s3
    80001956:	85ca                	mv	a1,s2
    80001958:	6928                	ld	a0,80(a0)
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	1be080e7          	jalr	446(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001962:	70a2                	ld	ra,40(sp)
    80001964:	7402                	ld	s0,32(sp)
    80001966:	64e2                	ld	s1,24(sp)
    80001968:	6942                	ld	s2,16(sp)
    8000196a:	69a2                	ld	s3,8(sp)
    8000196c:	6a02                	ld	s4,0(sp)
    8000196e:	6145                	addi	sp,sp,48
    80001970:	8082                	ret
    memmove((char *)dst, src, len);
    80001972:	000a061b          	sext.w	a2,s4
    80001976:	85ce                	mv	a1,s3
    80001978:	854a                	mv	a0,s2
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	85c080e7          	jalr	-1956(ra) # 800001d6 <memmove>
    return 0;
    80001982:	8526                	mv	a0,s1
    80001984:	bff9                	j	80001962 <either_copyout+0x32>

0000000080001986 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001986:	7179                	addi	sp,sp,-48
    80001988:	f406                	sd	ra,40(sp)
    8000198a:	f022                	sd	s0,32(sp)
    8000198c:	ec26                	sd	s1,24(sp)
    8000198e:	e84a                	sd	s2,16(sp)
    80001990:	e44e                	sd	s3,8(sp)
    80001992:	e052                	sd	s4,0(sp)
    80001994:	1800                	addi	s0,sp,48
    80001996:	892a                	mv	s2,a0
    80001998:	84ae                	mv	s1,a1
    8000199a:	89b2                	mv	s3,a2
    8000199c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	4de080e7          	jalr	1246(ra) # 80000e7c <myproc>
  if(user_src){
    800019a6:	c08d                	beqz	s1,800019c8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019a8:	86d2                	mv	a3,s4
    800019aa:	864e                	mv	a2,s3
    800019ac:	85ca                	mv	a1,s2
    800019ae:	6928                	ld	a0,80(a0)
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	1f4080e7          	jalr	500(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019b8:	70a2                	ld	ra,40(sp)
    800019ba:	7402                	ld	s0,32(sp)
    800019bc:	64e2                	ld	s1,24(sp)
    800019be:	6942                	ld	s2,16(sp)
    800019c0:	69a2                	ld	s3,8(sp)
    800019c2:	6a02                	ld	s4,0(sp)
    800019c4:	6145                	addi	sp,sp,48
    800019c6:	8082                	ret
    memmove(dst, (char*)src, len);
    800019c8:	000a061b          	sext.w	a2,s4
    800019cc:	85ce                	mv	a1,s3
    800019ce:	854a                	mv	a0,s2
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	806080e7          	jalr	-2042(ra) # 800001d6 <memmove>
    return 0;
    800019d8:	8526                	mv	a0,s1
    800019da:	bff9                	j	800019b8 <either_copyin+0x32>

00000000800019dc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019dc:	715d                	addi	sp,sp,-80
    800019de:	e486                	sd	ra,72(sp)
    800019e0:	e0a2                	sd	s0,64(sp)
    800019e2:	fc26                	sd	s1,56(sp)
    800019e4:	f84a                	sd	s2,48(sp)
    800019e6:	f44e                	sd	s3,40(sp)
    800019e8:	f052                	sd	s4,32(sp)
    800019ea:	ec56                	sd	s5,24(sp)
    800019ec:	e85a                	sd	s6,16(sp)
    800019ee:	e45e                	sd	s7,8(sp)
    800019f0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019f2:	00006517          	auipc	a0,0x6
    800019f6:	62650513          	addi	a0,a0,1574 # 80008018 <etext+0x18>
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	44a080e7          	jalr	1098(ra) # 80005e44 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a02:	0000b497          	auipc	s1,0xb
    80001a06:	bd648493          	addi	s1,s1,-1066 # 8000c5d8 <proc+0x158>
    80001a0a:	00011917          	auipc	s2,0x11
    80001a0e:	dce90913          	addi	s2,s2,-562 # 800127d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a12:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a14:	00006997          	auipc	s3,0x6
    80001a18:	7ec98993          	addi	s3,s3,2028 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a1c:	00006a97          	auipc	s5,0x6
    80001a20:	7eca8a93          	addi	s5,s5,2028 # 80008208 <etext+0x208>
    printf("\n");
    80001a24:	00006a17          	auipc	s4,0x6
    80001a28:	5f4a0a13          	addi	s4,s4,1524 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	00007b97          	auipc	s7,0x7
    80001a30:	cecb8b93          	addi	s7,s7,-788 # 80008718 <states.0>
    80001a34:	a00d                	j	80001a56 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a36:	ed86a583          	lw	a1,-296(a3)
    80001a3a:	8556                	mv	a0,s5
    80001a3c:	00004097          	auipc	ra,0x4
    80001a40:	408080e7          	jalr	1032(ra) # 80005e44 <printf>
    printf("\n");
    80001a44:	8552                	mv	a0,s4
    80001a46:	00004097          	auipc	ra,0x4
    80001a4a:	3fe080e7          	jalr	1022(ra) # 80005e44 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a4e:	18848493          	addi	s1,s1,392
    80001a52:	03248263          	beq	s1,s2,80001a76 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a56:	86a6                	mv	a3,s1
    80001a58:	ec04a783          	lw	a5,-320(s1)
    80001a5c:	dbed                	beqz	a5,80001a4e <procdump+0x72>
      state = "???";
    80001a5e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a60:	fcfb6be3          	bltu	s6,a5,80001a36 <procdump+0x5a>
    80001a64:	02079713          	slli	a4,a5,0x20
    80001a68:	01d75793          	srli	a5,a4,0x1d
    80001a6c:	97de                	add	a5,a5,s7
    80001a6e:	6390                	ld	a2,0(a5)
    80001a70:	f279                	bnez	a2,80001a36 <procdump+0x5a>
      state = "???";
    80001a72:	864e                	mv	a2,s3
    80001a74:	b7c9                	j	80001a36 <procdump+0x5a>
  }
}
    80001a76:	60a6                	ld	ra,72(sp)
    80001a78:	6406                	ld	s0,64(sp)
    80001a7a:	74e2                	ld	s1,56(sp)
    80001a7c:	7942                	ld	s2,48(sp)
    80001a7e:	79a2                	ld	s3,40(sp)
    80001a80:	7a02                	ld	s4,32(sp)
    80001a82:	6ae2                	ld	s5,24(sp)
    80001a84:	6b42                	ld	s6,16(sp)
    80001a86:	6ba2                	ld	s7,8(sp)
    80001a88:	6161                	addi	sp,sp,80
    80001a8a:	8082                	ret

0000000080001a8c <swtch>:
    80001a8c:	00153023          	sd	ra,0(a0)
    80001a90:	00253423          	sd	sp,8(a0)
    80001a94:	e900                	sd	s0,16(a0)
    80001a96:	ed04                	sd	s1,24(a0)
    80001a98:	03253023          	sd	s2,32(a0)
    80001a9c:	03353423          	sd	s3,40(a0)
    80001aa0:	03453823          	sd	s4,48(a0)
    80001aa4:	03553c23          	sd	s5,56(a0)
    80001aa8:	05653023          	sd	s6,64(a0)
    80001aac:	05753423          	sd	s7,72(a0)
    80001ab0:	05853823          	sd	s8,80(a0)
    80001ab4:	05953c23          	sd	s9,88(a0)
    80001ab8:	07a53023          	sd	s10,96(a0)
    80001abc:	07b53423          	sd	s11,104(a0)
    80001ac0:	0005b083          	ld	ra,0(a1)
    80001ac4:	0085b103          	ld	sp,8(a1)
    80001ac8:	6980                	ld	s0,16(a1)
    80001aca:	6d84                	ld	s1,24(a1)
    80001acc:	0205b903          	ld	s2,32(a1)
    80001ad0:	0285b983          	ld	s3,40(a1)
    80001ad4:	0305ba03          	ld	s4,48(a1)
    80001ad8:	0385ba83          	ld	s5,56(a1)
    80001adc:	0405bb03          	ld	s6,64(a1)
    80001ae0:	0485bb83          	ld	s7,72(a1)
    80001ae4:	0505bc03          	ld	s8,80(a1)
    80001ae8:	0585bc83          	ld	s9,88(a1)
    80001aec:	0605bd03          	ld	s10,96(a1)
    80001af0:	0685bd83          	ld	s11,104(a1)
    80001af4:	8082                	ret

0000000080001af6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001af6:	1141                	addi	sp,sp,-16
    80001af8:	e406                	sd	ra,8(sp)
    80001afa:	e022                	sd	s0,0(sp)
    80001afc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001afe:	00006597          	auipc	a1,0x6
    80001b02:	74258593          	addi	a1,a1,1858 # 80008240 <etext+0x240>
    80001b06:	00011517          	auipc	a0,0x11
    80001b0a:	b7a50513          	addi	a0,a0,-1158 # 80012680 <tickslock>
    80001b0e:	00004097          	auipc	ra,0x4
    80001b12:	7a4080e7          	jalr	1956(ra) # 800062b2 <initlock>
}
    80001b16:	60a2                	ld	ra,8(sp)
    80001b18:	6402                	ld	s0,0(sp)
    80001b1a:	0141                	addi	sp,sp,16
    80001b1c:	8082                	ret

0000000080001b1e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b1e:	1141                	addi	sp,sp,-16
    80001b20:	e422                	sd	s0,8(sp)
    80001b22:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b24:	00003797          	auipc	a5,0x3
    80001b28:	64c78793          	addi	a5,a5,1612 # 80005170 <kernelvec>
    80001b2c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b30:	6422                	ld	s0,8(sp)
    80001b32:	0141                	addi	sp,sp,16
    80001b34:	8082                	ret

0000000080001b36 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b36:	1141                	addi	sp,sp,-16
    80001b38:	e406                	sd	ra,8(sp)
    80001b3a:	e022                	sd	s0,0(sp)
    80001b3c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	33e080e7          	jalr	830(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b46:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b4a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b4c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b50:	00005697          	auipc	a3,0x5
    80001b54:	4b068693          	addi	a3,a3,1200 # 80007000 <_trampoline>
    80001b58:	00005717          	auipc	a4,0x5
    80001b5c:	4a870713          	addi	a4,a4,1192 # 80007000 <_trampoline>
    80001b60:	8f15                	sub	a4,a4,a3
    80001b62:	040007b7          	lui	a5,0x4000
    80001b66:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b68:	07b2                	slli	a5,a5,0xc
    80001b6a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b6c:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b70:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b72:	18002673          	csrr	a2,satp
    80001b76:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b78:	6d30                	ld	a2,88(a0)
    80001b7a:	6138                	ld	a4,64(a0)
    80001b7c:	6585                	lui	a1,0x1
    80001b7e:	972e                	add	a4,a4,a1
    80001b80:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b82:	6d38                	ld	a4,88(a0)
    80001b84:	00000617          	auipc	a2,0x0
    80001b88:	14060613          	addi	a2,a2,320 # 80001cc4 <usertrap>
    80001b8c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b8e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b90:	8612                	mv	a2,tp
    80001b92:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b94:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b98:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b9c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ba4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ba6:	6f18                	ld	a4,24(a4)
    80001ba8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bac:	692c                	ld	a1,80(a0)
    80001bae:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bb0:	00005717          	auipc	a4,0x5
    80001bb4:	4e070713          	addi	a4,a4,1248 # 80007090 <userret>
    80001bb8:	8f15                	sub	a4,a4,a3
    80001bba:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bbc:	577d                	li	a4,-1
    80001bbe:	177e                	slli	a4,a4,0x3f
    80001bc0:	8dd9                	or	a1,a1,a4
    80001bc2:	02000537          	lui	a0,0x2000
    80001bc6:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bc8:	0536                	slli	a0,a0,0xd
    80001bca:	9782                	jalr	a5
}
    80001bcc:	60a2                	ld	ra,8(sp)
    80001bce:	6402                	ld	s0,0(sp)
    80001bd0:	0141                	addi	sp,sp,16
    80001bd2:	8082                	ret

0000000080001bd4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	e426                	sd	s1,8(sp)
    80001bdc:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bde:	00011497          	auipc	s1,0x11
    80001be2:	aa248493          	addi	s1,s1,-1374 # 80012680 <tickslock>
    80001be6:	8526                	mv	a0,s1
    80001be8:	00004097          	auipc	ra,0x4
    80001bec:	75a080e7          	jalr	1882(ra) # 80006342 <acquire>
  ticks++;
    80001bf0:	0000a517          	auipc	a0,0xa
    80001bf4:	42850513          	addi	a0,a0,1064 # 8000c018 <ticks>
    80001bf8:	411c                	lw	a5,0(a0)
    80001bfa:	2785                	addiw	a5,a5,1
    80001bfc:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bfe:	00000097          	auipc	ra,0x0
    80001c02:	b1a080e7          	jalr	-1254(ra) # 80001718 <wakeup>
  release(&tickslock);
    80001c06:	8526                	mv	a0,s1
    80001c08:	00004097          	auipc	ra,0x4
    80001c0c:	7ee080e7          	jalr	2030(ra) # 800063f6 <release>
}
    80001c10:	60e2                	ld	ra,24(sp)
    80001c12:	6442                	ld	s0,16(sp)
    80001c14:	64a2                	ld	s1,8(sp)
    80001c16:	6105                	addi	sp,sp,32
    80001c18:	8082                	ret

0000000080001c1a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c1a:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c1e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c20:	0a07d163          	bgez	a5,80001cc2 <devintr+0xa8>
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c2c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c30:	46a5                	li	a3,9
    80001c32:	00d70c63          	beq	a4,a3,80001c4a <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c36:	577d                	li	a4,-1
    80001c38:	177e                	slli	a4,a4,0x3f
    80001c3a:	0705                	addi	a4,a4,1
    return 0;
    80001c3c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c3e:	06e78163          	beq	a5,a4,80001ca0 <devintr+0x86>
  }
}
    80001c42:	60e2                	ld	ra,24(sp)
    80001c44:	6442                	ld	s0,16(sp)
    80001c46:	6105                	addi	sp,sp,32
    80001c48:	8082                	ret
    80001c4a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c4c:	00003097          	auipc	ra,0x3
    80001c50:	630080e7          	jalr	1584(ra) # 8000527c <plic_claim>
    80001c54:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c56:	47a9                	li	a5,10
    80001c58:	00f50963          	beq	a0,a5,80001c6a <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c5c:	4785                	li	a5,1
    80001c5e:	00f50b63          	beq	a0,a5,80001c74 <devintr+0x5a>
    return 1;
    80001c62:	4505                	li	a0,1
    } else if(irq){
    80001c64:	ec89                	bnez	s1,80001c7e <devintr+0x64>
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	bfe9                	j	80001c42 <devintr+0x28>
      uartintr();
    80001c6a:	00004097          	auipc	ra,0x4
    80001c6e:	5f8080e7          	jalr	1528(ra) # 80006262 <uartintr>
    if(irq)
    80001c72:	a839                	j	80001c90 <devintr+0x76>
      virtio_disk_intr();
    80001c74:	00004097          	auipc	ra,0x4
    80001c78:	adc080e7          	jalr	-1316(ra) # 80005750 <virtio_disk_intr>
    if(irq)
    80001c7c:	a811                	j	80001c90 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c7e:	85a6                	mv	a1,s1
    80001c80:	00006517          	auipc	a0,0x6
    80001c84:	5c850513          	addi	a0,a0,1480 # 80008248 <etext+0x248>
    80001c88:	00004097          	auipc	ra,0x4
    80001c8c:	1bc080e7          	jalr	444(ra) # 80005e44 <printf>
      plic_complete(irq);
    80001c90:	8526                	mv	a0,s1
    80001c92:	00003097          	auipc	ra,0x3
    80001c96:	60e080e7          	jalr	1550(ra) # 800052a0 <plic_complete>
    return 1;
    80001c9a:	4505                	li	a0,1
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	b755                	j	80001c42 <devintr+0x28>
    if(cpuid() == 0){
    80001ca0:	fffff097          	auipc	ra,0xfffff
    80001ca4:	1b0080e7          	jalr	432(ra) # 80000e50 <cpuid>
    80001ca8:	c901                	beqz	a0,80001cb8 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001caa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cb0:	14479073          	csrw	sip,a5
    return 2;
    80001cb4:	4509                	li	a0,2
    80001cb6:	b771                	j	80001c42 <devintr+0x28>
      clockintr();
    80001cb8:	00000097          	auipc	ra,0x0
    80001cbc:	f1c080e7          	jalr	-228(ra) # 80001bd4 <clockintr>
    80001cc0:	b7ed                	j	80001caa <devintr+0x90>
}
    80001cc2:	8082                	ret

0000000080001cc4 <usertrap>:
{
    80001cc4:	1101                	addi	sp,sp,-32
    80001cc6:	ec06                	sd	ra,24(sp)
    80001cc8:	e822                	sd	s0,16(sp)
    80001cca:	e426                	sd	s1,8(sp)
    80001ccc:	e04a                	sd	s2,0(sp)
    80001cce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cd4:	1007f793          	andi	a5,a5,256
    80001cd8:	e3ad                	bnez	a5,80001d3a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cda:	00003797          	auipc	a5,0x3
    80001cde:	49678793          	addi	a5,a5,1174 # 80005170 <kernelvec>
    80001ce2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ce6:	fffff097          	auipc	ra,0xfffff
    80001cea:	196080e7          	jalr	406(ra) # 80000e7c <myproc>
    80001cee:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cf0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cf2:	14102773          	csrr	a4,sepc
    80001cf6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cf8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cfc:	47a1                	li	a5,8
    80001cfe:	04f71c63          	bne	a4,a5,80001d56 <usertrap+0x92>
    if(p->killed)
    80001d02:	551c                	lw	a5,40(a0)
    80001d04:	e3b9                	bnez	a5,80001d4a <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d06:	6cb8                	ld	a4,88(s1)
    80001d08:	6f1c                	ld	a5,24(a4)
    80001d0a:	0791                	addi	a5,a5,4
    80001d0c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d12:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d16:	10079073          	csrw	sstatus,a5
    syscall();
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	326080e7          	jalr	806(ra) # 80002040 <syscall>
  if(p->killed)
    80001d22:	549c                	lw	a5,40(s1)
    80001d24:	ebc5                	bnez	a5,80001dd4 <usertrap+0x110>
  usertrapret();
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	e10080e7          	jalr	-496(ra) # 80001b36 <usertrapret>
}
    80001d2e:	60e2                	ld	ra,24(sp)
    80001d30:	6442                	ld	s0,16(sp)
    80001d32:	64a2                	ld	s1,8(sp)
    80001d34:	6902                	ld	s2,0(sp)
    80001d36:	6105                	addi	sp,sp,32
    80001d38:	8082                	ret
    panic("usertrap: not from user mode");
    80001d3a:	00006517          	auipc	a0,0x6
    80001d3e:	52e50513          	addi	a0,a0,1326 # 80008268 <etext+0x268>
    80001d42:	00004097          	auipc	ra,0x4
    80001d46:	0b0080e7          	jalr	176(ra) # 80005df2 <panic>
      exit(-1);
    80001d4a:	557d                	li	a0,-1
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	a9c080e7          	jalr	-1380(ra) # 800017e8 <exit>
    80001d54:	bf4d                	j	80001d06 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	ec4080e7          	jalr	-316(ra) # 80001c1a <devintr>
    80001d5e:	892a                	mv	s2,a0
    80001d60:	c501                	beqz	a0,80001d68 <usertrap+0xa4>
  if(p->killed)
    80001d62:	549c                	lw	a5,40(s1)
    80001d64:	c3a1                	beqz	a5,80001da4 <usertrap+0xe0>
    80001d66:	a815                	j	80001d9a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d68:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d6c:	5890                	lw	a2,48(s1)
    80001d6e:	00006517          	auipc	a0,0x6
    80001d72:	51a50513          	addi	a0,a0,1306 # 80008288 <etext+0x288>
    80001d76:	00004097          	auipc	ra,0x4
    80001d7a:	0ce080e7          	jalr	206(ra) # 80005e44 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d82:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d86:	00006517          	auipc	a0,0x6
    80001d8a:	53250513          	addi	a0,a0,1330 # 800082b8 <etext+0x2b8>
    80001d8e:	00004097          	auipc	ra,0x4
    80001d92:	0b6080e7          	jalr	182(ra) # 80005e44 <printf>
    p->killed = 1;
    80001d96:	4785                	li	a5,1
    80001d98:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d9a:	557d                	li	a0,-1
    80001d9c:	00000097          	auipc	ra,0x0
    80001da0:	a4c080e7          	jalr	-1460(ra) # 800017e8 <exit>
  if(which_dev == 2)
    80001da4:	4789                	li	a5,2
    80001da6:	f8f910e3          	bne	s2,a5,80001d26 <usertrap+0x62>
    if(p->ticks>0)
    80001daa:	1684a703          	lw	a4,360(s1)
    80001dae:	00e05e63          	blez	a4,80001dca <usertrap+0x106>
      p->count++;
    80001db2:	16c4a783          	lw	a5,364(s1)
    80001db6:	2785                	addiw	a5,a5,1
    80001db8:	0007869b          	sext.w	a3,a5
    80001dbc:	16f4a623          	sw	a5,364(s1)
      if(p->count>p->ticks && p->handler_exec == 0)
    80001dc0:	00d75563          	bge	a4,a3,80001dca <usertrap+0x106>
    80001dc4:	1804a783          	lw	a5,384(s1)
    80001dc8:	cb81                	beqz	a5,80001dd8 <usertrap+0x114>
    yield();
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	786080e7          	jalr	1926(ra) # 80001550 <yield>
    80001dd2:	bf91                	j	80001d26 <usertrap+0x62>
  int which_dev = 0;
    80001dd4:	4901                	li	s2,0
    80001dd6:	b7d1                	j	80001d9a <usertrap+0xd6>
        p->count = 0;
    80001dd8:	1604a623          	sw	zero,364(s1)
        memmove(p->tick_trapframe, p->trapframe, sizeof(struct trapframe)); 
    80001ddc:	12000613          	li	a2,288
    80001de0:	6cac                	ld	a1,88(s1)
    80001de2:	1784b503          	ld	a0,376(s1)
    80001de6:	ffffe097          	auipc	ra,0xffffe
    80001dea:	3f0080e7          	jalr	1008(ra) # 800001d6 <memmove>
        p->trapframe->epc=p->handler;
    80001dee:	6cbc                	ld	a5,88(s1)
    80001df0:	1704b703          	ld	a4,368(s1)
    80001df4:	ef98                	sd	a4,24(a5)
        p->handler_exec = 1;
    80001df6:	4785                	li	a5,1
    80001df8:	18f4a023          	sw	a5,384(s1)
    80001dfc:	b7f9                	j	80001dca <usertrap+0x106>

0000000080001dfe <kerneltrap>:
{
    80001dfe:	7179                	addi	sp,sp,-48
    80001e00:	f406                	sd	ra,40(sp)
    80001e02:	f022                	sd	s0,32(sp)
    80001e04:	ec26                	sd	s1,24(sp)
    80001e06:	e84a                	sd	s2,16(sp)
    80001e08:	e44e                	sd	s3,8(sp)
    80001e0a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e10:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e14:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e18:	1004f793          	andi	a5,s1,256
    80001e1c:	cb85                	beqz	a5,80001e4c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e22:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e24:	ef85                	bnez	a5,80001e5c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e26:	00000097          	auipc	ra,0x0
    80001e2a:	df4080e7          	jalr	-524(ra) # 80001c1a <devintr>
    80001e2e:	cd1d                	beqz	a0,80001e6c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e30:	4789                	li	a5,2
    80001e32:	06f50a63          	beq	a0,a5,80001ea6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e36:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e3a:	10049073          	csrw	sstatus,s1
}
    80001e3e:	70a2                	ld	ra,40(sp)
    80001e40:	7402                	ld	s0,32(sp)
    80001e42:	64e2                	ld	s1,24(sp)
    80001e44:	6942                	ld	s2,16(sp)
    80001e46:	69a2                	ld	s3,8(sp)
    80001e48:	6145                	addi	sp,sp,48
    80001e4a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	48c50513          	addi	a0,a0,1164 # 800082d8 <etext+0x2d8>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	f9e080e7          	jalr	-98(ra) # 80005df2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e5c:	00006517          	auipc	a0,0x6
    80001e60:	4a450513          	addi	a0,a0,1188 # 80008300 <etext+0x300>
    80001e64:	00004097          	auipc	ra,0x4
    80001e68:	f8e080e7          	jalr	-114(ra) # 80005df2 <panic>
    printf("scause %p\n", scause);
    80001e6c:	85ce                	mv	a1,s3
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	4b250513          	addi	a0,a0,1202 # 80008320 <etext+0x320>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	fce080e7          	jalr	-50(ra) # 80005e44 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e7e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e82:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e86:	00006517          	auipc	a0,0x6
    80001e8a:	4aa50513          	addi	a0,a0,1194 # 80008330 <etext+0x330>
    80001e8e:	00004097          	auipc	ra,0x4
    80001e92:	fb6080e7          	jalr	-74(ra) # 80005e44 <printf>
    panic("kerneltrap");
    80001e96:	00006517          	auipc	a0,0x6
    80001e9a:	4b250513          	addi	a0,a0,1202 # 80008348 <etext+0x348>
    80001e9e:	00004097          	auipc	ra,0x4
    80001ea2:	f54080e7          	jalr	-172(ra) # 80005df2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ea6:	fffff097          	auipc	ra,0xfffff
    80001eaa:	fd6080e7          	jalr	-42(ra) # 80000e7c <myproc>
    80001eae:	d541                	beqz	a0,80001e36 <kerneltrap+0x38>
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	fcc080e7          	jalr	-52(ra) # 80000e7c <myproc>
    80001eb8:	4d18                	lw	a4,24(a0)
    80001eba:	4791                	li	a5,4
    80001ebc:	f6f71de3          	bne	a4,a5,80001e36 <kerneltrap+0x38>
    yield();
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	690080e7          	jalr	1680(ra) # 80001550 <yield>
    80001ec8:	b7bd                	j	80001e36 <kerneltrap+0x38>

0000000080001eca <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eca:	1101                	addi	sp,sp,-32
    80001ecc:	ec06                	sd	ra,24(sp)
    80001ece:	e822                	sd	s0,16(sp)
    80001ed0:	e426                	sd	s1,8(sp)
    80001ed2:	1000                	addi	s0,sp,32
    80001ed4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	fa6080e7          	jalr	-90(ra) # 80000e7c <myproc>
  switch (n) {
    80001ede:	4795                	li	a5,5
    80001ee0:	0497e163          	bltu	a5,s1,80001f22 <argraw+0x58>
    80001ee4:	048a                	slli	s1,s1,0x2
    80001ee6:	00007717          	auipc	a4,0x7
    80001eea:	86270713          	addi	a4,a4,-1950 # 80008748 <states.0+0x30>
    80001eee:	94ba                	add	s1,s1,a4
    80001ef0:	409c                	lw	a5,0(s1)
    80001ef2:	97ba                	add	a5,a5,a4
    80001ef4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ef6:	6d3c                	ld	a5,88(a0)
    80001ef8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001efa:	60e2                	ld	ra,24(sp)
    80001efc:	6442                	ld	s0,16(sp)
    80001efe:	64a2                	ld	s1,8(sp)
    80001f00:	6105                	addi	sp,sp,32
    80001f02:	8082                	ret
    return p->trapframe->a1;
    80001f04:	6d3c                	ld	a5,88(a0)
    80001f06:	7fa8                	ld	a0,120(a5)
    80001f08:	bfcd                	j	80001efa <argraw+0x30>
    return p->trapframe->a2;
    80001f0a:	6d3c                	ld	a5,88(a0)
    80001f0c:	63c8                	ld	a0,128(a5)
    80001f0e:	b7f5                	j	80001efa <argraw+0x30>
    return p->trapframe->a3;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	67c8                	ld	a0,136(a5)
    80001f14:	b7dd                	j	80001efa <argraw+0x30>
    return p->trapframe->a4;
    80001f16:	6d3c                	ld	a5,88(a0)
    80001f18:	6bc8                	ld	a0,144(a5)
    80001f1a:	b7c5                	j	80001efa <argraw+0x30>
    return p->trapframe->a5;
    80001f1c:	6d3c                	ld	a5,88(a0)
    80001f1e:	6fc8                	ld	a0,152(a5)
    80001f20:	bfe9                	j	80001efa <argraw+0x30>
  panic("argraw");
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	43650513          	addi	a0,a0,1078 # 80008358 <etext+0x358>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	ec8080e7          	jalr	-312(ra) # 80005df2 <panic>

0000000080001f32 <fetchaddr>:
{
    80001f32:	1101                	addi	sp,sp,-32
    80001f34:	ec06                	sd	ra,24(sp)
    80001f36:	e822                	sd	s0,16(sp)
    80001f38:	e426                	sd	s1,8(sp)
    80001f3a:	e04a                	sd	s2,0(sp)
    80001f3c:	1000                	addi	s0,sp,32
    80001f3e:	84aa                	mv	s1,a0
    80001f40:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	f3a080e7          	jalr	-198(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f4a:	653c                	ld	a5,72(a0)
    80001f4c:	02f4f863          	bgeu	s1,a5,80001f7c <fetchaddr+0x4a>
    80001f50:	00848713          	addi	a4,s1,8
    80001f54:	02e7e663          	bltu	a5,a4,80001f80 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f58:	46a1                	li	a3,8
    80001f5a:	8626                	mv	a2,s1
    80001f5c:	85ca                	mv	a1,s2
    80001f5e:	6928                	ld	a0,80(a0)
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	c44080e7          	jalr	-956(ra) # 80000ba4 <copyin>
    80001f68:	00a03533          	snez	a0,a0
    80001f6c:	40a00533          	neg	a0,a0
}
    80001f70:	60e2                	ld	ra,24(sp)
    80001f72:	6442                	ld	s0,16(sp)
    80001f74:	64a2                	ld	s1,8(sp)
    80001f76:	6902                	ld	s2,0(sp)
    80001f78:	6105                	addi	sp,sp,32
    80001f7a:	8082                	ret
    return -1;
    80001f7c:	557d                	li	a0,-1
    80001f7e:	bfcd                	j	80001f70 <fetchaddr+0x3e>
    80001f80:	557d                	li	a0,-1
    80001f82:	b7fd                	j	80001f70 <fetchaddr+0x3e>

0000000080001f84 <fetchstr>:
{
    80001f84:	7179                	addi	sp,sp,-48
    80001f86:	f406                	sd	ra,40(sp)
    80001f88:	f022                	sd	s0,32(sp)
    80001f8a:	ec26                	sd	s1,24(sp)
    80001f8c:	e84a                	sd	s2,16(sp)
    80001f8e:	e44e                	sd	s3,8(sp)
    80001f90:	1800                	addi	s0,sp,48
    80001f92:	892a                	mv	s2,a0
    80001f94:	84ae                	mv	s1,a1
    80001f96:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	ee4080e7          	jalr	-284(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fa0:	86ce                	mv	a3,s3
    80001fa2:	864a                	mv	a2,s2
    80001fa4:	85a6                	mv	a1,s1
    80001fa6:	6928                	ld	a0,80(a0)
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	c8a080e7          	jalr	-886(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001fb0:	00054763          	bltz	a0,80001fbe <fetchstr+0x3a>
  return strlen(buf);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	ffffe097          	auipc	ra,0xffffe
    80001fba:	338080e7          	jalr	824(ra) # 800002ee <strlen>
}
    80001fbe:	70a2                	ld	ra,40(sp)
    80001fc0:	7402                	ld	s0,32(sp)
    80001fc2:	64e2                	ld	s1,24(sp)
    80001fc4:	6942                	ld	s2,16(sp)
    80001fc6:	69a2                	ld	s3,8(sp)
    80001fc8:	6145                	addi	sp,sp,48
    80001fca:	8082                	ret

0000000080001fcc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fcc:	1101                	addi	sp,sp,-32
    80001fce:	ec06                	sd	ra,24(sp)
    80001fd0:	e822                	sd	s0,16(sp)
    80001fd2:	e426                	sd	s1,8(sp)
    80001fd4:	1000                	addi	s0,sp,32
    80001fd6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	ef2080e7          	jalr	-270(ra) # 80001eca <argraw>
    80001fe0:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fe2:	4501                	li	a0,0
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret

0000000080001fee <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fee:	1101                	addi	sp,sp,-32
    80001ff0:	ec06                	sd	ra,24(sp)
    80001ff2:	e822                	sd	s0,16(sp)
    80001ff4:	e426                	sd	s1,8(sp)
    80001ff6:	1000                	addi	s0,sp,32
    80001ff8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	ed0080e7          	jalr	-304(ra) # 80001eca <argraw>
    80002002:	e088                	sd	a0,0(s1)
  return 0;
}
    80002004:	4501                	li	a0,0
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	64a2                	ld	s1,8(sp)
    8000200c:	6105                	addi	sp,sp,32
    8000200e:	8082                	ret

0000000080002010 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	e04a                	sd	s2,0(sp)
    8000201a:	1000                	addi	s0,sp,32
    8000201c:	84ae                	mv	s1,a1
    8000201e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002020:	00000097          	auipc	ra,0x0
    80002024:	eaa080e7          	jalr	-342(ra) # 80001eca <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002028:	864a                	mv	a2,s2
    8000202a:	85a6                	mv	a1,s1
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	f58080e7          	jalr	-168(ra) # 80001f84 <fetchstr>
}
    80002034:	60e2                	ld	ra,24(sp)
    80002036:	6442                	ld	s0,16(sp)
    80002038:	64a2                	ld	s1,8(sp)
    8000203a:	6902                	ld	s2,0(sp)
    8000203c:	6105                	addi	sp,sp,32
    8000203e:	8082                	ret

0000000080002040 <syscall>:
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	e426                	sd	s1,8(sp)
    80002048:	e04a                	sd	s2,0(sp)
    8000204a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	e30080e7          	jalr	-464(ra) # 80000e7c <myproc>
    80002054:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002056:	05853903          	ld	s2,88(a0)
    8000205a:	0a893783          	ld	a5,168(s2)
    8000205e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002062:	37fd                	addiw	a5,a5,-1
    80002064:	4759                	li	a4,22
    80002066:	00f76f63          	bltu	a4,a5,80002084 <syscall+0x44>
    8000206a:	00369713          	slli	a4,a3,0x3
    8000206e:	00006797          	auipc	a5,0x6
    80002072:	6f278793          	addi	a5,a5,1778 # 80008760 <syscalls>
    80002076:	97ba                	add	a5,a5,a4
    80002078:	639c                	ld	a5,0(a5)
    8000207a:	c789                	beqz	a5,80002084 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000207c:	9782                	jalr	a5
    8000207e:	06a93823          	sd	a0,112(s2)
    80002082:	a839                	j	800020a0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002084:	15848613          	addi	a2,s1,344
    80002088:	588c                	lw	a1,48(s1)
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	2d650513          	addi	a0,a0,726 # 80008360 <etext+0x360>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	db2080e7          	jalr	-590(ra) # 80005e44 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000209a:	6cbc                	ld	a5,88(s1)
    8000209c:	577d                	li	a4,-1
    8000209e:	fbb8                	sd	a4,112(a5)
  }
}
    800020a0:	60e2                	ld	ra,24(sp)
    800020a2:	6442                	ld	s0,16(sp)
    800020a4:	64a2                	ld	s1,8(sp)
    800020a6:	6902                	ld	s2,0(sp)
    800020a8:	6105                	addi	sp,sp,32
    800020aa:	8082                	ret

00000000800020ac <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020ac:	1101                	addi	sp,sp,-32
    800020ae:	ec06                	sd	ra,24(sp)
    800020b0:	e822                	sd	s0,16(sp)
    800020b2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020b4:	fec40593          	addi	a1,s0,-20
    800020b8:	4501                	li	a0,0
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	f12080e7          	jalr	-238(ra) # 80001fcc <argint>
    return -1;
    800020c2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020c4:	00054963          	bltz	a0,800020d6 <sys_exit+0x2a>
  exit(n);
    800020c8:	fec42503          	lw	a0,-20(s0)
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	71c080e7          	jalr	1820(ra) # 800017e8 <exit>
  return 0;  // not reached
    800020d4:	4781                	li	a5,0
}
    800020d6:	853e                	mv	a0,a5
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret

00000000800020e0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e0:	1141                	addi	sp,sp,-16
    800020e2:	e406                	sd	ra,8(sp)
    800020e4:	e022                	sd	s0,0(sp)
    800020e6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	d94080e7          	jalr	-620(ra) # 80000e7c <myproc>
}
    800020f0:	5908                	lw	a0,48(a0)
    800020f2:	60a2                	ld	ra,8(sp)
    800020f4:	6402                	ld	s0,0(sp)
    800020f6:	0141                	addi	sp,sp,16
    800020f8:	8082                	ret

00000000800020fa <sys_fork>:

uint64
sys_fork(void)
{
    800020fa:	1141                	addi	sp,sp,-16
    800020fc:	e406                	sd	ra,8(sp)
    800020fe:	e022                	sd	s0,0(sp)
    80002100:	0800                	addi	s0,sp,16
  return fork();
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	196080e7          	jalr	406(ra) # 80001298 <fork>
}
    8000210a:	60a2                	ld	ra,8(sp)
    8000210c:	6402                	ld	s0,0(sp)
    8000210e:	0141                	addi	sp,sp,16
    80002110:	8082                	ret

0000000080002112 <sys_wait>:

uint64
sys_wait(void)
{
    80002112:	1101                	addi	sp,sp,-32
    80002114:	ec06                	sd	ra,24(sp)
    80002116:	e822                	sd	s0,16(sp)
    80002118:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000211a:	fe840593          	addi	a1,s0,-24
    8000211e:	4501                	li	a0,0
    80002120:	00000097          	auipc	ra,0x0
    80002124:	ece080e7          	jalr	-306(ra) # 80001fee <argaddr>
    80002128:	87aa                	mv	a5,a0
    return -1;
    8000212a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000212c:	0007c863          	bltz	a5,8000213c <sys_wait+0x2a>
  return wait(p);
    80002130:	fe843503          	ld	a0,-24(s0)
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	4bc080e7          	jalr	1212(ra) # 800015f0 <wait>
}
    8000213c:	60e2                	ld	ra,24(sp)
    8000213e:	6442                	ld	s0,16(sp)
    80002140:	6105                	addi	sp,sp,32
    80002142:	8082                	ret

0000000080002144 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002144:	7179                	addi	sp,sp,-48
    80002146:	f406                	sd	ra,40(sp)
    80002148:	f022                	sd	s0,32(sp)
    8000214a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000214c:	fdc40593          	addi	a1,s0,-36
    80002150:	4501                	li	a0,0
    80002152:	00000097          	auipc	ra,0x0
    80002156:	e7a080e7          	jalr	-390(ra) # 80001fcc <argint>
    8000215a:	87aa                	mv	a5,a0
    return -1;
    8000215c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000215e:	0207c263          	bltz	a5,80002182 <sys_sbrk+0x3e>
    80002162:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	d18080e7          	jalr	-744(ra) # 80000e7c <myproc>
    8000216c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000216e:	fdc42503          	lw	a0,-36(s0)
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	0ae080e7          	jalr	174(ra) # 80001220 <growproc>
    8000217a:	00054863          	bltz	a0,8000218a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000217e:	8526                	mv	a0,s1
    80002180:	64e2                	ld	s1,24(sp)
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	6145                	addi	sp,sp,48
    80002188:	8082                	ret
    return -1;
    8000218a:	557d                	li	a0,-1
    8000218c:	64e2                	ld	s1,24(sp)
    8000218e:	bfd5                	j	80002182 <sys_sbrk+0x3e>

0000000080002190 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002190:	7139                	addi	sp,sp,-64
    80002192:	fc06                	sd	ra,56(sp)
    80002194:	f822                	sd	s0,48(sp)
    80002196:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002198:	fcc40593          	addi	a1,s0,-52
    8000219c:	4501                	li	a0,0
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e2e080e7          	jalr	-466(ra) # 80001fcc <argint>
    return -1;
    800021a6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021a8:	06054f63          	bltz	a0,80002226 <sys_sleep+0x96>
    800021ac:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800021ae:	00010517          	auipc	a0,0x10
    800021b2:	4d250513          	addi	a0,a0,1234 # 80012680 <tickslock>
    800021b6:	00004097          	auipc	ra,0x4
    800021ba:	18c080e7          	jalr	396(ra) # 80006342 <acquire>
  ticks0 = ticks;
    800021be:	0000a917          	auipc	s2,0xa
    800021c2:	e5a92903          	lw	s2,-422(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    800021c6:	fcc42783          	lw	a5,-52(s0)
    800021ca:	c3a1                	beqz	a5,8000220a <sys_sleep+0x7a>
    800021cc:	f426                	sd	s1,40(sp)
    800021ce:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d0:	00010997          	auipc	s3,0x10
    800021d4:	4b098993          	addi	s3,s3,1200 # 80012680 <tickslock>
    800021d8:	0000a497          	auipc	s1,0xa
    800021dc:	e4048493          	addi	s1,s1,-448 # 8000c018 <ticks>
    if(myproc()->killed){
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	c9c080e7          	jalr	-868(ra) # 80000e7c <myproc>
    800021e8:	551c                	lw	a5,40(a0)
    800021ea:	e3b9                	bnez	a5,80002230 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    800021ec:	85ce                	mv	a1,s3
    800021ee:	8526                	mv	a0,s1
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	39c080e7          	jalr	924(ra) # 8000158c <sleep>
  while(ticks - ticks0 < n){
    800021f8:	409c                	lw	a5,0(s1)
    800021fa:	412787bb          	subw	a5,a5,s2
    800021fe:	fcc42703          	lw	a4,-52(s0)
    80002202:	fce7efe3          	bltu	a5,a4,800021e0 <sys_sleep+0x50>
    80002206:	74a2                	ld	s1,40(sp)
    80002208:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000220a:	00010517          	auipc	a0,0x10
    8000220e:	47650513          	addi	a0,a0,1142 # 80012680 <tickslock>
    80002212:	00004097          	auipc	ra,0x4
    80002216:	1e4080e7          	jalr	484(ra) # 800063f6 <release>
  backtrace();
    8000221a:	00004097          	auipc	ra,0x4
    8000221e:	b74080e7          	jalr	-1164(ra) # 80005d8e <backtrace>
  return 0;
    80002222:	4781                	li	a5,0
    80002224:	7902                	ld	s2,32(sp)
}
    80002226:	853e                	mv	a0,a5
    80002228:	70e2                	ld	ra,56(sp)
    8000222a:	7442                	ld	s0,48(sp)
    8000222c:	6121                	addi	sp,sp,64
    8000222e:	8082                	ret
      release(&tickslock);
    80002230:	00010517          	auipc	a0,0x10
    80002234:	45050513          	addi	a0,a0,1104 # 80012680 <tickslock>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	1be080e7          	jalr	446(ra) # 800063f6 <release>
      return -1;
    80002240:	57fd                	li	a5,-1
    80002242:	74a2                	ld	s1,40(sp)
    80002244:	7902                	ld	s2,32(sp)
    80002246:	69e2                	ld	s3,24(sp)
    80002248:	bff9                	j	80002226 <sys_sleep+0x96>

000000008000224a <sys_kill>:

uint64
sys_kill(void)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002252:	fec40593          	addi	a1,s0,-20
    80002256:	4501                	li	a0,0
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	d74080e7          	jalr	-652(ra) # 80001fcc <argint>
    80002260:	87aa                	mv	a5,a0
    return -1;
    80002262:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002264:	0007c863          	bltz	a5,80002274 <sys_kill+0x2a>
  return kill(pid);
    80002268:	fec42503          	lw	a0,-20(s0)
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	652080e7          	jalr	1618(ra) # 800018be <kill>
}
    80002274:	60e2                	ld	ra,24(sp)
    80002276:	6442                	ld	s0,16(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret

000000008000227c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	e426                	sd	s1,8(sp)
    80002284:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002286:	00010517          	auipc	a0,0x10
    8000228a:	3fa50513          	addi	a0,a0,1018 # 80012680 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	0b4080e7          	jalr	180(ra) # 80006342 <acquire>
  xticks = ticks;
    80002296:	0000a497          	auipc	s1,0xa
    8000229a:	d824a483          	lw	s1,-638(s1) # 8000c018 <ticks>
  release(&tickslock);
    8000229e:	00010517          	auipc	a0,0x10
    800022a2:	3e250513          	addi	a0,a0,994 # 80012680 <tickslock>
    800022a6:	00004097          	auipc	ra,0x4
    800022aa:	150080e7          	jalr	336(ra) # 800063f6 <release>
  return xticks;
}
    800022ae:	02049513          	slli	a0,s1,0x20
    800022b2:	9101                	srli	a0,a0,0x20
    800022b4:	60e2                	ld	ra,24(sp)
    800022b6:	6442                	ld	s0,16(sp)
    800022b8:	64a2                	ld	s1,8(sp)
    800022ba:	6105                	addi	sp,sp,32
    800022bc:	8082                	ret

00000000800022be <sys_sigreturn>:
uint64 sys_sigreturn(void)
{
    800022be:	1101                	addi	sp,sp,-32
    800022c0:	ec06                	sd	ra,24(sp)
    800022c2:	e822                	sd	s0,16(sp)
    800022c4:	e426                	sd	s1,8(sp)
    800022c6:	1000                	addi	s0,sp,32
  memmove(myproc()->trapframe, myproc()->tick_trapframe, sizeof(struct trapframe)); 
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	bb4080e7          	jalr	-1100(ra) # 80000e7c <myproc>
    800022d0:	6d24                	ld	s1,88(a0)
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	baa080e7          	jalr	-1110(ra) # 80000e7c <myproc>
    800022da:	12000613          	li	a2,288
    800022de:	17853583          	ld	a1,376(a0)
    800022e2:	8526                	mv	a0,s1
    800022e4:	ffffe097          	auipc	ra,0xffffe
    800022e8:	ef2080e7          	jalr	-270(ra) # 800001d6 <memmove>
  myproc()->handler_exec = 0;
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	b90080e7          	jalr	-1136(ra) # 80000e7c <myproc>
    800022f4:	18052023          	sw	zero,384(a0)
  // p->trapframe->epc = p->tick_epc;
  // p->trapframe = p->tick_trapframe;
  // p->handler_exec = 0;
  return 0;

}
    800022f8:	4501                	li	a0,0
    800022fa:	60e2                	ld	ra,24(sp)
    800022fc:	6442                	ld	s0,16(sp)
    800022fe:	64a2                	ld	s1,8(sp)
    80002300:	6105                	addi	sp,sp,32
    80002302:	8082                	ret

0000000080002304 <sys_sigalarm>:
uint64 sys_sigalarm(void)
{
    80002304:	1101                	addi	sp,sp,-32
    80002306:	ec06                	sd	ra,24(sp)
    80002308:	e822                	sd	s0,16(sp)
    8000230a:	1000                	addi	s0,sp,32
  int ticks;
  uint64 handler;

  if(argint(0,&ticks)<0)
    8000230c:	fec40593          	addi	a1,s0,-20
    80002310:	4501                	li	a0,0
    80002312:	00000097          	auipc	ra,0x0
    80002316:	cba080e7          	jalr	-838(ra) # 80001fcc <argint>
  return -1;
    8000231a:	57fd                	li	a5,-1
  if(argint(0,&ticks)<0)
    8000231c:	04054363          	bltz	a0,80002362 <sys_sigalarm+0x5e>

  if(argaddr(1,&handler)<0)
    80002320:	fe040593          	addi	a1,s0,-32
    80002324:	4505                	li	a0,1
    80002326:	00000097          	auipc	ra,0x0
    8000232a:	cc8080e7          	jalr	-824(ra) # 80001fee <argaddr>

  return -1;
    8000232e:	57fd                	li	a5,-1
  if(argaddr(1,&handler)<0)
    80002330:	02054963          	bltz	a0,80002362 <sys_sigalarm+0x5e>

  myproc()->ticks=ticks;
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	b48080e7          	jalr	-1208(ra) # 80000e7c <myproc>
    8000233c:	fec42783          	lw	a5,-20(s0)
    80002340:	16f52423          	sw	a5,360(a0)
  myproc()->handler=handler;
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	b38080e7          	jalr	-1224(ra) # 80000e7c <myproc>
    8000234c:	fe043783          	ld	a5,-32(s0)
    80002350:	16f53823          	sd	a5,368(a0)
  myproc()->count =0;
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	b28080e7          	jalr	-1240(ra) # 80000e7c <myproc>
    8000235c:	16052623          	sw	zero,364(a0)
  return 0;
    80002360:	4781                	li	a5,0
  // p->ticks=ticks;
  // p->handler=handler;
  // p->count = 0;
  // return 0;

}
    80002362:	853e                	mv	a0,a5
    80002364:	60e2                	ld	ra,24(sp)
    80002366:	6442                	ld	s0,16(sp)
    80002368:	6105                	addi	sp,sp,32
    8000236a:	8082                	ret

000000008000236c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000236c:	7179                	addi	sp,sp,-48
    8000236e:	f406                	sd	ra,40(sp)
    80002370:	f022                	sd	s0,32(sp)
    80002372:	ec26                	sd	s1,24(sp)
    80002374:	e84a                	sd	s2,16(sp)
    80002376:	e44e                	sd	s3,8(sp)
    80002378:	e052                	sd	s4,0(sp)
    8000237a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000237c:	00006597          	auipc	a1,0x6
    80002380:	00458593          	addi	a1,a1,4 # 80008380 <etext+0x380>
    80002384:	00010517          	auipc	a0,0x10
    80002388:	31450513          	addi	a0,a0,788 # 80012698 <bcache>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	f26080e7          	jalr	-218(ra) # 800062b2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002394:	00018797          	auipc	a5,0x18
    80002398:	30478793          	addi	a5,a5,772 # 8001a698 <bcache+0x8000>
    8000239c:	00018717          	auipc	a4,0x18
    800023a0:	56470713          	addi	a4,a4,1380 # 8001a900 <bcache+0x8268>
    800023a4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023a8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ac:	00010497          	auipc	s1,0x10
    800023b0:	30448493          	addi	s1,s1,772 # 800126b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023b4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023b6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023b8:	00006a17          	auipc	s4,0x6
    800023bc:	fd0a0a13          	addi	s4,s4,-48 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    800023c0:	2b893783          	ld	a5,696(s2)
    800023c4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023c6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ca:	85d2                	mv	a1,s4
    800023cc:	01048513          	addi	a0,s1,16
    800023d0:	00001097          	auipc	ra,0x1
    800023d4:	4b2080e7          	jalr	1202(ra) # 80003882 <initsleeplock>
    bcache.head.next->prev = b;
    800023d8:	2b893783          	ld	a5,696(s2)
    800023dc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023de:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e2:	45848493          	addi	s1,s1,1112
    800023e6:	fd349de3          	bne	s1,s3,800023c0 <binit+0x54>
  }
}
    800023ea:	70a2                	ld	ra,40(sp)
    800023ec:	7402                	ld	s0,32(sp)
    800023ee:	64e2                	ld	s1,24(sp)
    800023f0:	6942                	ld	s2,16(sp)
    800023f2:	69a2                	ld	s3,8(sp)
    800023f4:	6a02                	ld	s4,0(sp)
    800023f6:	6145                	addi	sp,sp,48
    800023f8:	8082                	ret

00000000800023fa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023fa:	7179                	addi	sp,sp,-48
    800023fc:	f406                	sd	ra,40(sp)
    800023fe:	f022                	sd	s0,32(sp)
    80002400:	ec26                	sd	s1,24(sp)
    80002402:	e84a                	sd	s2,16(sp)
    80002404:	e44e                	sd	s3,8(sp)
    80002406:	1800                	addi	s0,sp,48
    80002408:	892a                	mv	s2,a0
    8000240a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000240c:	00010517          	auipc	a0,0x10
    80002410:	28c50513          	addi	a0,a0,652 # 80012698 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	f2e080e7          	jalr	-210(ra) # 80006342 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000241c:	00018497          	auipc	s1,0x18
    80002420:	5344b483          	ld	s1,1332(s1) # 8001a950 <bcache+0x82b8>
    80002424:	00018797          	auipc	a5,0x18
    80002428:	4dc78793          	addi	a5,a5,1244 # 8001a900 <bcache+0x8268>
    8000242c:	02f48f63          	beq	s1,a5,8000246a <bread+0x70>
    80002430:	873e                	mv	a4,a5
    80002432:	a021                	j	8000243a <bread+0x40>
    80002434:	68a4                	ld	s1,80(s1)
    80002436:	02e48a63          	beq	s1,a4,8000246a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000243a:	449c                	lw	a5,8(s1)
    8000243c:	ff279ce3          	bne	a5,s2,80002434 <bread+0x3a>
    80002440:	44dc                	lw	a5,12(s1)
    80002442:	ff3799e3          	bne	a5,s3,80002434 <bread+0x3a>
      b->refcnt++;
    80002446:	40bc                	lw	a5,64(s1)
    80002448:	2785                	addiw	a5,a5,1
    8000244a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000244c:	00010517          	auipc	a0,0x10
    80002450:	24c50513          	addi	a0,a0,588 # 80012698 <bcache>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	fa2080e7          	jalr	-94(ra) # 800063f6 <release>
      acquiresleep(&b->lock);
    8000245c:	01048513          	addi	a0,s1,16
    80002460:	00001097          	auipc	ra,0x1
    80002464:	45c080e7          	jalr	1116(ra) # 800038bc <acquiresleep>
      return b;
    80002468:	a8b9                	j	800024c6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246a:	00018497          	auipc	s1,0x18
    8000246e:	4de4b483          	ld	s1,1246(s1) # 8001a948 <bcache+0x82b0>
    80002472:	00018797          	auipc	a5,0x18
    80002476:	48e78793          	addi	a5,a5,1166 # 8001a900 <bcache+0x8268>
    8000247a:	00f48863          	beq	s1,a5,8000248a <bread+0x90>
    8000247e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002480:	40bc                	lw	a5,64(s1)
    80002482:	cf81                	beqz	a5,8000249a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002484:	64a4                	ld	s1,72(s1)
    80002486:	fee49de3          	bne	s1,a4,80002480 <bread+0x86>
  panic("bget: no buffers");
    8000248a:	00006517          	auipc	a0,0x6
    8000248e:	f0650513          	addi	a0,a0,-250 # 80008390 <etext+0x390>
    80002492:	00004097          	auipc	ra,0x4
    80002496:	960080e7          	jalr	-1696(ra) # 80005df2 <panic>
      b->dev = dev;
    8000249a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000249e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024a2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024a6:	4785                	li	a5,1
    800024a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024aa:	00010517          	auipc	a0,0x10
    800024ae:	1ee50513          	addi	a0,a0,494 # 80012698 <bcache>
    800024b2:	00004097          	auipc	ra,0x4
    800024b6:	f44080e7          	jalr	-188(ra) # 800063f6 <release>
      acquiresleep(&b->lock);
    800024ba:	01048513          	addi	a0,s1,16
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	3fe080e7          	jalr	1022(ra) # 800038bc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024c6:	409c                	lw	a5,0(s1)
    800024c8:	cb89                	beqz	a5,800024da <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ca:	8526                	mv	a0,s1
    800024cc:	70a2                	ld	ra,40(sp)
    800024ce:	7402                	ld	s0,32(sp)
    800024d0:	64e2                	ld	s1,24(sp)
    800024d2:	6942                	ld	s2,16(sp)
    800024d4:	69a2                	ld	s3,8(sp)
    800024d6:	6145                	addi	sp,sp,48
    800024d8:	8082                	ret
    virtio_disk_rw(b, 0);
    800024da:	4581                	li	a1,0
    800024dc:	8526                	mv	a0,s1
    800024de:	00003097          	auipc	ra,0x3
    800024e2:	fe4080e7          	jalr	-28(ra) # 800054c2 <virtio_disk_rw>
    b->valid = 1;
    800024e6:	4785                	li	a5,1
    800024e8:	c09c                	sw	a5,0(s1)
  return b;
    800024ea:	b7c5                	j	800024ca <bread+0xd0>

00000000800024ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ec:	1101                	addi	sp,sp,-32
    800024ee:	ec06                	sd	ra,24(sp)
    800024f0:	e822                	sd	s0,16(sp)
    800024f2:	e426                	sd	s1,8(sp)
    800024f4:	1000                	addi	s0,sp,32
    800024f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f8:	0541                	addi	a0,a0,16
    800024fa:	00001097          	auipc	ra,0x1
    800024fe:	45c080e7          	jalr	1116(ra) # 80003956 <holdingsleep>
    80002502:	cd01                	beqz	a0,8000251a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002504:	4585                	li	a1,1
    80002506:	8526                	mv	a0,s1
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	fba080e7          	jalr	-70(ra) # 800054c2 <virtio_disk_rw>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret
    panic("bwrite");
    8000251a:	00006517          	auipc	a0,0x6
    8000251e:	e8e50513          	addi	a0,a0,-370 # 800083a8 <etext+0x3a8>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	8d0080e7          	jalr	-1840(ra) # 80005df2 <panic>

000000008000252a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000252a:	1101                	addi	sp,sp,-32
    8000252c:	ec06                	sd	ra,24(sp)
    8000252e:	e822                	sd	s0,16(sp)
    80002530:	e426                	sd	s1,8(sp)
    80002532:	e04a                	sd	s2,0(sp)
    80002534:	1000                	addi	s0,sp,32
    80002536:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002538:	01050913          	addi	s2,a0,16
    8000253c:	854a                	mv	a0,s2
    8000253e:	00001097          	auipc	ra,0x1
    80002542:	418080e7          	jalr	1048(ra) # 80003956 <holdingsleep>
    80002546:	c925                	beqz	a0,800025b6 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002548:	854a                	mv	a0,s2
    8000254a:	00001097          	auipc	ra,0x1
    8000254e:	3c8080e7          	jalr	968(ra) # 80003912 <releasesleep>

  acquire(&bcache.lock);
    80002552:	00010517          	auipc	a0,0x10
    80002556:	14650513          	addi	a0,a0,326 # 80012698 <bcache>
    8000255a:	00004097          	auipc	ra,0x4
    8000255e:	de8080e7          	jalr	-536(ra) # 80006342 <acquire>
  b->refcnt--;
    80002562:	40bc                	lw	a5,64(s1)
    80002564:	37fd                	addiw	a5,a5,-1
    80002566:	0007871b          	sext.w	a4,a5
    8000256a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000256c:	e71d                	bnez	a4,8000259a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000256e:	68b8                	ld	a4,80(s1)
    80002570:	64bc                	ld	a5,72(s1)
    80002572:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002574:	68b8                	ld	a4,80(s1)
    80002576:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002578:	00018797          	auipc	a5,0x18
    8000257c:	12078793          	addi	a5,a5,288 # 8001a698 <bcache+0x8000>
    80002580:	2b87b703          	ld	a4,696(a5)
    80002584:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002586:	00018717          	auipc	a4,0x18
    8000258a:	37a70713          	addi	a4,a4,890 # 8001a900 <bcache+0x8268>
    8000258e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002590:	2b87b703          	ld	a4,696(a5)
    80002594:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002596:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000259a:	00010517          	auipc	a0,0x10
    8000259e:	0fe50513          	addi	a0,a0,254 # 80012698 <bcache>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	e54080e7          	jalr	-428(ra) # 800063f6 <release>
}
    800025aa:	60e2                	ld	ra,24(sp)
    800025ac:	6442                	ld	s0,16(sp)
    800025ae:	64a2                	ld	s1,8(sp)
    800025b0:	6902                	ld	s2,0(sp)
    800025b2:	6105                	addi	sp,sp,32
    800025b4:	8082                	ret
    panic("brelse");
    800025b6:	00006517          	auipc	a0,0x6
    800025ba:	dfa50513          	addi	a0,a0,-518 # 800083b0 <etext+0x3b0>
    800025be:	00004097          	auipc	ra,0x4
    800025c2:	834080e7          	jalr	-1996(ra) # 80005df2 <panic>

00000000800025c6 <bpin>:

void
bpin(struct buf *b) {
    800025c6:	1101                	addi	sp,sp,-32
    800025c8:	ec06                	sd	ra,24(sp)
    800025ca:	e822                	sd	s0,16(sp)
    800025cc:	e426                	sd	s1,8(sp)
    800025ce:	1000                	addi	s0,sp,32
    800025d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d2:	00010517          	auipc	a0,0x10
    800025d6:	0c650513          	addi	a0,a0,198 # 80012698 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	d68080e7          	jalr	-664(ra) # 80006342 <acquire>
  b->refcnt++;
    800025e2:	40bc                	lw	a5,64(s1)
    800025e4:	2785                	addiw	a5,a5,1
    800025e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e8:	00010517          	auipc	a0,0x10
    800025ec:	0b050513          	addi	a0,a0,176 # 80012698 <bcache>
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	e06080e7          	jalr	-506(ra) # 800063f6 <release>
}
    800025f8:	60e2                	ld	ra,24(sp)
    800025fa:	6442                	ld	s0,16(sp)
    800025fc:	64a2                	ld	s1,8(sp)
    800025fe:	6105                	addi	sp,sp,32
    80002600:	8082                	ret

0000000080002602 <bunpin>:

void
bunpin(struct buf *b) {
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000260e:	00010517          	auipc	a0,0x10
    80002612:	08a50513          	addi	a0,a0,138 # 80012698 <bcache>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	d2c080e7          	jalr	-724(ra) # 80006342 <acquire>
  b->refcnt--;
    8000261e:	40bc                	lw	a5,64(s1)
    80002620:	37fd                	addiw	a5,a5,-1
    80002622:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002624:	00010517          	auipc	a0,0x10
    80002628:	07450513          	addi	a0,a0,116 # 80012698 <bcache>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	dca080e7          	jalr	-566(ra) # 800063f6 <release>
}
    80002634:	60e2                	ld	ra,24(sp)
    80002636:	6442                	ld	s0,16(sp)
    80002638:	64a2                	ld	s1,8(sp)
    8000263a:	6105                	addi	sp,sp,32
    8000263c:	8082                	ret

000000008000263e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000263e:	1101                	addi	sp,sp,-32
    80002640:	ec06                	sd	ra,24(sp)
    80002642:	e822                	sd	s0,16(sp)
    80002644:	e426                	sd	s1,8(sp)
    80002646:	e04a                	sd	s2,0(sp)
    80002648:	1000                	addi	s0,sp,32
    8000264a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000264c:	00d5d59b          	srliw	a1,a1,0xd
    80002650:	00018797          	auipc	a5,0x18
    80002654:	7247a783          	lw	a5,1828(a5) # 8001ad74 <sb+0x1c>
    80002658:	9dbd                	addw	a1,a1,a5
    8000265a:	00000097          	auipc	ra,0x0
    8000265e:	da0080e7          	jalr	-608(ra) # 800023fa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002662:	0074f713          	andi	a4,s1,7
    80002666:	4785                	li	a5,1
    80002668:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000266c:	14ce                	slli	s1,s1,0x33
    8000266e:	90d9                	srli	s1,s1,0x36
    80002670:	00950733          	add	a4,a0,s1
    80002674:	05874703          	lbu	a4,88(a4)
    80002678:	00e7f6b3          	and	a3,a5,a4
    8000267c:	c69d                	beqz	a3,800026aa <bfree+0x6c>
    8000267e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002680:	94aa                	add	s1,s1,a0
    80002682:	fff7c793          	not	a5,a5
    80002686:	8f7d                	and	a4,a4,a5
    80002688:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000268c:	00001097          	auipc	ra,0x1
    80002690:	112080e7          	jalr	274(ra) # 8000379e <log_write>
  brelse(bp);
    80002694:	854a                	mv	a0,s2
    80002696:	00000097          	auipc	ra,0x0
    8000269a:	e94080e7          	jalr	-364(ra) # 8000252a <brelse>
}
    8000269e:	60e2                	ld	ra,24(sp)
    800026a0:	6442                	ld	s0,16(sp)
    800026a2:	64a2                	ld	s1,8(sp)
    800026a4:	6902                	ld	s2,0(sp)
    800026a6:	6105                	addi	sp,sp,32
    800026a8:	8082                	ret
    panic("freeing free block");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	d0e50513          	addi	a0,a0,-754 # 800083b8 <etext+0x3b8>
    800026b2:	00003097          	auipc	ra,0x3
    800026b6:	740080e7          	jalr	1856(ra) # 80005df2 <panic>

00000000800026ba <balloc>:
{
    800026ba:	711d                	addi	sp,sp,-96
    800026bc:	ec86                	sd	ra,88(sp)
    800026be:	e8a2                	sd	s0,80(sp)
    800026c0:	e4a6                	sd	s1,72(sp)
    800026c2:	e0ca                	sd	s2,64(sp)
    800026c4:	fc4e                	sd	s3,56(sp)
    800026c6:	f852                	sd	s4,48(sp)
    800026c8:	f456                	sd	s5,40(sp)
    800026ca:	f05a                	sd	s6,32(sp)
    800026cc:	ec5e                	sd	s7,24(sp)
    800026ce:	e862                	sd	s8,16(sp)
    800026d0:	e466                	sd	s9,8(sp)
    800026d2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026d4:	00018797          	auipc	a5,0x18
    800026d8:	6887a783          	lw	a5,1672(a5) # 8001ad5c <sb+0x4>
    800026dc:	cbc1                	beqz	a5,8000276c <balloc+0xb2>
    800026de:	8baa                	mv	s7,a0
    800026e0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026e2:	00018b17          	auipc	s6,0x18
    800026e6:	676b0b13          	addi	s6,s6,1654 # 8001ad58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ea:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026ec:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ee:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026f0:	6c89                	lui	s9,0x2
    800026f2:	a831                	j	8000270e <balloc+0x54>
    brelse(bp);
    800026f4:	854a                	mv	a0,s2
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	e34080e7          	jalr	-460(ra) # 8000252a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026fe:	015c87bb          	addw	a5,s9,s5
    80002702:	00078a9b          	sext.w	s5,a5
    80002706:	004b2703          	lw	a4,4(s6)
    8000270a:	06eaf163          	bgeu	s5,a4,8000276c <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000270e:	41fad79b          	sraiw	a5,s5,0x1f
    80002712:	0137d79b          	srliw	a5,a5,0x13
    80002716:	015787bb          	addw	a5,a5,s5
    8000271a:	40d7d79b          	sraiw	a5,a5,0xd
    8000271e:	01cb2583          	lw	a1,28(s6)
    80002722:	9dbd                	addw	a1,a1,a5
    80002724:	855e                	mv	a0,s7
    80002726:	00000097          	auipc	ra,0x0
    8000272a:	cd4080e7          	jalr	-812(ra) # 800023fa <bread>
    8000272e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002730:	004b2503          	lw	a0,4(s6)
    80002734:	000a849b          	sext.w	s1,s5
    80002738:	8762                	mv	a4,s8
    8000273a:	faa4fde3          	bgeu	s1,a0,800026f4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000273e:	00777693          	andi	a3,a4,7
    80002742:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002746:	41f7579b          	sraiw	a5,a4,0x1f
    8000274a:	01d7d79b          	srliw	a5,a5,0x1d
    8000274e:	9fb9                	addw	a5,a5,a4
    80002750:	4037d79b          	sraiw	a5,a5,0x3
    80002754:	00f90633          	add	a2,s2,a5
    80002758:	05864603          	lbu	a2,88(a2)
    8000275c:	00c6f5b3          	and	a1,a3,a2
    80002760:	cd91                	beqz	a1,8000277c <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002762:	2705                	addiw	a4,a4,1
    80002764:	2485                	addiw	s1,s1,1
    80002766:	fd471ae3          	bne	a4,s4,8000273a <balloc+0x80>
    8000276a:	b769                	j	800026f4 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000276c:	00006517          	auipc	a0,0x6
    80002770:	c6450513          	addi	a0,a0,-924 # 800083d0 <etext+0x3d0>
    80002774:	00003097          	auipc	ra,0x3
    80002778:	67e080e7          	jalr	1662(ra) # 80005df2 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000277c:	97ca                	add	a5,a5,s2
    8000277e:	8e55                	or	a2,a2,a3
    80002780:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002784:	854a                	mv	a0,s2
    80002786:	00001097          	auipc	ra,0x1
    8000278a:	018080e7          	jalr	24(ra) # 8000379e <log_write>
        brelse(bp);
    8000278e:	854a                	mv	a0,s2
    80002790:	00000097          	auipc	ra,0x0
    80002794:	d9a080e7          	jalr	-614(ra) # 8000252a <brelse>
  bp = bread(dev, bno);
    80002798:	85a6                	mv	a1,s1
    8000279a:	855e                	mv	a0,s7
    8000279c:	00000097          	auipc	ra,0x0
    800027a0:	c5e080e7          	jalr	-930(ra) # 800023fa <bread>
    800027a4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027a6:	40000613          	li	a2,1024
    800027aa:	4581                	li	a1,0
    800027ac:	05850513          	addi	a0,a0,88
    800027b0:	ffffe097          	auipc	ra,0xffffe
    800027b4:	9ca080e7          	jalr	-1590(ra) # 8000017a <memset>
  log_write(bp);
    800027b8:	854a                	mv	a0,s2
    800027ba:	00001097          	auipc	ra,0x1
    800027be:	fe4080e7          	jalr	-28(ra) # 8000379e <log_write>
  brelse(bp);
    800027c2:	854a                	mv	a0,s2
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	d66080e7          	jalr	-666(ra) # 8000252a <brelse>
}
    800027cc:	8526                	mv	a0,s1
    800027ce:	60e6                	ld	ra,88(sp)
    800027d0:	6446                	ld	s0,80(sp)
    800027d2:	64a6                	ld	s1,72(sp)
    800027d4:	6906                	ld	s2,64(sp)
    800027d6:	79e2                	ld	s3,56(sp)
    800027d8:	7a42                	ld	s4,48(sp)
    800027da:	7aa2                	ld	s5,40(sp)
    800027dc:	7b02                	ld	s6,32(sp)
    800027de:	6be2                	ld	s7,24(sp)
    800027e0:	6c42                	ld	s8,16(sp)
    800027e2:	6ca2                	ld	s9,8(sp)
    800027e4:	6125                	addi	sp,sp,96
    800027e6:	8082                	ret

00000000800027e8 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027e8:	7179                	addi	sp,sp,-48
    800027ea:	f406                	sd	ra,40(sp)
    800027ec:	f022                	sd	s0,32(sp)
    800027ee:	ec26                	sd	s1,24(sp)
    800027f0:	e84a                	sd	s2,16(sp)
    800027f2:	e44e                	sd	s3,8(sp)
    800027f4:	1800                	addi	s0,sp,48
    800027f6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027f8:	47ad                	li	a5,11
    800027fa:	04b7ff63          	bgeu	a5,a1,80002858 <bmap+0x70>
    800027fe:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002800:	ff45849b          	addiw	s1,a1,-12
    80002804:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002808:	0ff00793          	li	a5,255
    8000280c:	0ae7e463          	bltu	a5,a4,800028b4 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002810:	08052583          	lw	a1,128(a0)
    80002814:	c5b5                	beqz	a1,80002880 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002816:	00092503          	lw	a0,0(s2)
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	be0080e7          	jalr	-1056(ra) # 800023fa <bread>
    80002822:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002824:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002828:	02049713          	slli	a4,s1,0x20
    8000282c:	01e75593          	srli	a1,a4,0x1e
    80002830:	00b784b3          	add	s1,a5,a1
    80002834:	0004a983          	lw	s3,0(s1)
    80002838:	04098e63          	beqz	s3,80002894 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000283c:	8552                	mv	a0,s4
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	cec080e7          	jalr	-788(ra) # 8000252a <brelse>
    return addr;
    80002846:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002848:	854e                	mv	a0,s3
    8000284a:	70a2                	ld	ra,40(sp)
    8000284c:	7402                	ld	s0,32(sp)
    8000284e:	64e2                	ld	s1,24(sp)
    80002850:	6942                	ld	s2,16(sp)
    80002852:	69a2                	ld	s3,8(sp)
    80002854:	6145                	addi	sp,sp,48
    80002856:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002858:	02059793          	slli	a5,a1,0x20
    8000285c:	01e7d593          	srli	a1,a5,0x1e
    80002860:	00b504b3          	add	s1,a0,a1
    80002864:	0504a983          	lw	s3,80(s1)
    80002868:	fe0990e3          	bnez	s3,80002848 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000286c:	4108                	lw	a0,0(a0)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	e4c080e7          	jalr	-436(ra) # 800026ba <balloc>
    80002876:	0005099b          	sext.w	s3,a0
    8000287a:	0534a823          	sw	s3,80(s1)
    8000287e:	b7e9                	j	80002848 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002880:	4108                	lw	a0,0(a0)
    80002882:	00000097          	auipc	ra,0x0
    80002886:	e38080e7          	jalr	-456(ra) # 800026ba <balloc>
    8000288a:	0005059b          	sext.w	a1,a0
    8000288e:	08b92023          	sw	a1,128(s2)
    80002892:	b751                	j	80002816 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002894:	00092503          	lw	a0,0(s2)
    80002898:	00000097          	auipc	ra,0x0
    8000289c:	e22080e7          	jalr	-478(ra) # 800026ba <balloc>
    800028a0:	0005099b          	sext.w	s3,a0
    800028a4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028a8:	8552                	mv	a0,s4
    800028aa:	00001097          	auipc	ra,0x1
    800028ae:	ef4080e7          	jalr	-268(ra) # 8000379e <log_write>
    800028b2:	b769                	j	8000283c <bmap+0x54>
  panic("bmap: out of range");
    800028b4:	00006517          	auipc	a0,0x6
    800028b8:	b3450513          	addi	a0,a0,-1228 # 800083e8 <etext+0x3e8>
    800028bc:	00003097          	auipc	ra,0x3
    800028c0:	536080e7          	jalr	1334(ra) # 80005df2 <panic>

00000000800028c4 <iget>:
{
    800028c4:	7179                	addi	sp,sp,-48
    800028c6:	f406                	sd	ra,40(sp)
    800028c8:	f022                	sd	s0,32(sp)
    800028ca:	ec26                	sd	s1,24(sp)
    800028cc:	e84a                	sd	s2,16(sp)
    800028ce:	e44e                	sd	s3,8(sp)
    800028d0:	e052                	sd	s4,0(sp)
    800028d2:	1800                	addi	s0,sp,48
    800028d4:	89aa                	mv	s3,a0
    800028d6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028d8:	00018517          	auipc	a0,0x18
    800028dc:	4a050513          	addi	a0,a0,1184 # 8001ad78 <itable>
    800028e0:	00004097          	auipc	ra,0x4
    800028e4:	a62080e7          	jalr	-1438(ra) # 80006342 <acquire>
  empty = 0;
    800028e8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ea:	00018497          	auipc	s1,0x18
    800028ee:	4a648493          	addi	s1,s1,1190 # 8001ad90 <itable+0x18>
    800028f2:	0001a697          	auipc	a3,0x1a
    800028f6:	f2e68693          	addi	a3,a3,-210 # 8001c820 <log>
    800028fa:	a039                	j	80002908 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fc:	02090b63          	beqz	s2,80002932 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002900:	08848493          	addi	s1,s1,136
    80002904:	02d48a63          	beq	s1,a3,80002938 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002908:	449c                	lw	a5,8(s1)
    8000290a:	fef059e3          	blez	a5,800028fc <iget+0x38>
    8000290e:	4098                	lw	a4,0(s1)
    80002910:	ff3716e3          	bne	a4,s3,800028fc <iget+0x38>
    80002914:	40d8                	lw	a4,4(s1)
    80002916:	ff4713e3          	bne	a4,s4,800028fc <iget+0x38>
      ip->ref++;
    8000291a:	2785                	addiw	a5,a5,1
    8000291c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000291e:	00018517          	auipc	a0,0x18
    80002922:	45a50513          	addi	a0,a0,1114 # 8001ad78 <itable>
    80002926:	00004097          	auipc	ra,0x4
    8000292a:	ad0080e7          	jalr	-1328(ra) # 800063f6 <release>
      return ip;
    8000292e:	8926                	mv	s2,s1
    80002930:	a03d                	j	8000295e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002932:	f7f9                	bnez	a5,80002900 <iget+0x3c>
      empty = ip;
    80002934:	8926                	mv	s2,s1
    80002936:	b7e9                	j	80002900 <iget+0x3c>
  if(empty == 0)
    80002938:	02090c63          	beqz	s2,80002970 <iget+0xac>
  ip->dev = dev;
    8000293c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002940:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002944:	4785                	li	a5,1
    80002946:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000294a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000294e:	00018517          	auipc	a0,0x18
    80002952:	42a50513          	addi	a0,a0,1066 # 8001ad78 <itable>
    80002956:	00004097          	auipc	ra,0x4
    8000295a:	aa0080e7          	jalr	-1376(ra) # 800063f6 <release>
}
    8000295e:	854a                	mv	a0,s2
    80002960:	70a2                	ld	ra,40(sp)
    80002962:	7402                	ld	s0,32(sp)
    80002964:	64e2                	ld	s1,24(sp)
    80002966:	6942                	ld	s2,16(sp)
    80002968:	69a2                	ld	s3,8(sp)
    8000296a:	6a02                	ld	s4,0(sp)
    8000296c:	6145                	addi	sp,sp,48
    8000296e:	8082                	ret
    panic("iget: no inodes");
    80002970:	00006517          	auipc	a0,0x6
    80002974:	a9050513          	addi	a0,a0,-1392 # 80008400 <etext+0x400>
    80002978:	00003097          	auipc	ra,0x3
    8000297c:	47a080e7          	jalr	1146(ra) # 80005df2 <panic>

0000000080002980 <fsinit>:
fsinit(int dev) {
    80002980:	7179                	addi	sp,sp,-48
    80002982:	f406                	sd	ra,40(sp)
    80002984:	f022                	sd	s0,32(sp)
    80002986:	ec26                	sd	s1,24(sp)
    80002988:	e84a                	sd	s2,16(sp)
    8000298a:	e44e                	sd	s3,8(sp)
    8000298c:	1800                	addi	s0,sp,48
    8000298e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002990:	4585                	li	a1,1
    80002992:	00000097          	auipc	ra,0x0
    80002996:	a68080e7          	jalr	-1432(ra) # 800023fa <bread>
    8000299a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000299c:	00018997          	auipc	s3,0x18
    800029a0:	3bc98993          	addi	s3,s3,956 # 8001ad58 <sb>
    800029a4:	02000613          	li	a2,32
    800029a8:	05850593          	addi	a1,a0,88
    800029ac:	854e                	mv	a0,s3
    800029ae:	ffffe097          	auipc	ra,0xffffe
    800029b2:	828080e7          	jalr	-2008(ra) # 800001d6 <memmove>
  brelse(bp);
    800029b6:	8526                	mv	a0,s1
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	b72080e7          	jalr	-1166(ra) # 8000252a <brelse>
  if(sb.magic != FSMAGIC)
    800029c0:	0009a703          	lw	a4,0(s3)
    800029c4:	102037b7          	lui	a5,0x10203
    800029c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029cc:	02f71263          	bne	a4,a5,800029f0 <fsinit+0x70>
  initlog(dev, &sb);
    800029d0:	00018597          	auipc	a1,0x18
    800029d4:	38858593          	addi	a1,a1,904 # 8001ad58 <sb>
    800029d8:	854a                	mv	a0,s2
    800029da:	00001097          	auipc	ra,0x1
    800029de:	b54080e7          	jalr	-1196(ra) # 8000352e <initlog>
}
    800029e2:	70a2                	ld	ra,40(sp)
    800029e4:	7402                	ld	s0,32(sp)
    800029e6:	64e2                	ld	s1,24(sp)
    800029e8:	6942                	ld	s2,16(sp)
    800029ea:	69a2                	ld	s3,8(sp)
    800029ec:	6145                	addi	sp,sp,48
    800029ee:	8082                	ret
    panic("invalid file system");
    800029f0:	00006517          	auipc	a0,0x6
    800029f4:	a2050513          	addi	a0,a0,-1504 # 80008410 <etext+0x410>
    800029f8:	00003097          	auipc	ra,0x3
    800029fc:	3fa080e7          	jalr	1018(ra) # 80005df2 <panic>

0000000080002a00 <iinit>:
{
    80002a00:	7179                	addi	sp,sp,-48
    80002a02:	f406                	sd	ra,40(sp)
    80002a04:	f022                	sd	s0,32(sp)
    80002a06:	ec26                	sd	s1,24(sp)
    80002a08:	e84a                	sd	s2,16(sp)
    80002a0a:	e44e                	sd	s3,8(sp)
    80002a0c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a0e:	00006597          	auipc	a1,0x6
    80002a12:	a1a58593          	addi	a1,a1,-1510 # 80008428 <etext+0x428>
    80002a16:	00018517          	auipc	a0,0x18
    80002a1a:	36250513          	addi	a0,a0,866 # 8001ad78 <itable>
    80002a1e:	00004097          	auipc	ra,0x4
    80002a22:	894080e7          	jalr	-1900(ra) # 800062b2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a26:	00018497          	auipc	s1,0x18
    80002a2a:	37a48493          	addi	s1,s1,890 # 8001ada0 <itable+0x28>
    80002a2e:	0001a997          	auipc	s3,0x1a
    80002a32:	e0298993          	addi	s3,s3,-510 # 8001c830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a36:	00006917          	auipc	s2,0x6
    80002a3a:	9fa90913          	addi	s2,s2,-1542 # 80008430 <etext+0x430>
    80002a3e:	85ca                	mv	a1,s2
    80002a40:	8526                	mv	a0,s1
    80002a42:	00001097          	auipc	ra,0x1
    80002a46:	e40080e7          	jalr	-448(ra) # 80003882 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a4a:	08848493          	addi	s1,s1,136
    80002a4e:	ff3498e3          	bne	s1,s3,80002a3e <iinit+0x3e>
}
    80002a52:	70a2                	ld	ra,40(sp)
    80002a54:	7402                	ld	s0,32(sp)
    80002a56:	64e2                	ld	s1,24(sp)
    80002a58:	6942                	ld	s2,16(sp)
    80002a5a:	69a2                	ld	s3,8(sp)
    80002a5c:	6145                	addi	sp,sp,48
    80002a5e:	8082                	ret

0000000080002a60 <ialloc>:
{
    80002a60:	7139                	addi	sp,sp,-64
    80002a62:	fc06                	sd	ra,56(sp)
    80002a64:	f822                	sd	s0,48(sp)
    80002a66:	f426                	sd	s1,40(sp)
    80002a68:	f04a                	sd	s2,32(sp)
    80002a6a:	ec4e                	sd	s3,24(sp)
    80002a6c:	e852                	sd	s4,16(sp)
    80002a6e:	e456                	sd	s5,8(sp)
    80002a70:	e05a                	sd	s6,0(sp)
    80002a72:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a74:	00018717          	auipc	a4,0x18
    80002a78:	2f072703          	lw	a4,752(a4) # 8001ad64 <sb+0xc>
    80002a7c:	4785                	li	a5,1
    80002a7e:	04e7f863          	bgeu	a5,a4,80002ace <ialloc+0x6e>
    80002a82:	8aaa                	mv	s5,a0
    80002a84:	8b2e                	mv	s6,a1
    80002a86:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a88:	00018a17          	auipc	s4,0x18
    80002a8c:	2d0a0a13          	addi	s4,s4,720 # 8001ad58 <sb>
    80002a90:	00495593          	srli	a1,s2,0x4
    80002a94:	018a2783          	lw	a5,24(s4)
    80002a98:	9dbd                	addw	a1,a1,a5
    80002a9a:	8556                	mv	a0,s5
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	95e080e7          	jalr	-1698(ra) # 800023fa <bread>
    80002aa4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aa6:	05850993          	addi	s3,a0,88
    80002aaa:	00f97793          	andi	a5,s2,15
    80002aae:	079a                	slli	a5,a5,0x6
    80002ab0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ab2:	00099783          	lh	a5,0(s3)
    80002ab6:	c785                	beqz	a5,80002ade <ialloc+0x7e>
    brelse(bp);
    80002ab8:	00000097          	auipc	ra,0x0
    80002abc:	a72080e7          	jalr	-1422(ra) # 8000252a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ac0:	0905                	addi	s2,s2,1
    80002ac2:	00ca2703          	lw	a4,12(s4)
    80002ac6:	0009079b          	sext.w	a5,s2
    80002aca:	fce7e3e3          	bltu	a5,a4,80002a90 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002ace:	00006517          	auipc	a0,0x6
    80002ad2:	96a50513          	addi	a0,a0,-1686 # 80008438 <etext+0x438>
    80002ad6:	00003097          	auipc	ra,0x3
    80002ada:	31c080e7          	jalr	796(ra) # 80005df2 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ade:	04000613          	li	a2,64
    80002ae2:	4581                	li	a1,0
    80002ae4:	854e                	mv	a0,s3
    80002ae6:	ffffd097          	auipc	ra,0xffffd
    80002aea:	694080e7          	jalr	1684(ra) # 8000017a <memset>
      dip->type = type;
    80002aee:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002af2:	8526                	mv	a0,s1
    80002af4:	00001097          	auipc	ra,0x1
    80002af8:	caa080e7          	jalr	-854(ra) # 8000379e <log_write>
      brelse(bp);
    80002afc:	8526                	mv	a0,s1
    80002afe:	00000097          	auipc	ra,0x0
    80002b02:	a2c080e7          	jalr	-1492(ra) # 8000252a <brelse>
      return iget(dev, inum);
    80002b06:	0009059b          	sext.w	a1,s2
    80002b0a:	8556                	mv	a0,s5
    80002b0c:	00000097          	auipc	ra,0x0
    80002b10:	db8080e7          	jalr	-584(ra) # 800028c4 <iget>
}
    80002b14:	70e2                	ld	ra,56(sp)
    80002b16:	7442                	ld	s0,48(sp)
    80002b18:	74a2                	ld	s1,40(sp)
    80002b1a:	7902                	ld	s2,32(sp)
    80002b1c:	69e2                	ld	s3,24(sp)
    80002b1e:	6a42                	ld	s4,16(sp)
    80002b20:	6aa2                	ld	s5,8(sp)
    80002b22:	6b02                	ld	s6,0(sp)
    80002b24:	6121                	addi	sp,sp,64
    80002b26:	8082                	ret

0000000080002b28 <iupdate>:
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	e04a                	sd	s2,0(sp)
    80002b32:	1000                	addi	s0,sp,32
    80002b34:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b36:	415c                	lw	a5,4(a0)
    80002b38:	0047d79b          	srliw	a5,a5,0x4
    80002b3c:	00018597          	auipc	a1,0x18
    80002b40:	2345a583          	lw	a1,564(a1) # 8001ad70 <sb+0x18>
    80002b44:	9dbd                	addw	a1,a1,a5
    80002b46:	4108                	lw	a0,0(a0)
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	8b2080e7          	jalr	-1870(ra) # 800023fa <bread>
    80002b50:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b52:	05850793          	addi	a5,a0,88
    80002b56:	40d8                	lw	a4,4(s1)
    80002b58:	8b3d                	andi	a4,a4,15
    80002b5a:	071a                	slli	a4,a4,0x6
    80002b5c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b5e:	04449703          	lh	a4,68(s1)
    80002b62:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b66:	04649703          	lh	a4,70(s1)
    80002b6a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b6e:	04849703          	lh	a4,72(s1)
    80002b72:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b76:	04a49703          	lh	a4,74(s1)
    80002b7a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b7e:	44f8                	lw	a4,76(s1)
    80002b80:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b82:	03400613          	li	a2,52
    80002b86:	05048593          	addi	a1,s1,80
    80002b8a:	00c78513          	addi	a0,a5,12
    80002b8e:	ffffd097          	auipc	ra,0xffffd
    80002b92:	648080e7          	jalr	1608(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b96:	854a                	mv	a0,s2
    80002b98:	00001097          	auipc	ra,0x1
    80002b9c:	c06080e7          	jalr	-1018(ra) # 8000379e <log_write>
  brelse(bp);
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	00000097          	auipc	ra,0x0
    80002ba6:	988080e7          	jalr	-1656(ra) # 8000252a <brelse>
}
    80002baa:	60e2                	ld	ra,24(sp)
    80002bac:	6442                	ld	s0,16(sp)
    80002bae:	64a2                	ld	s1,8(sp)
    80002bb0:	6902                	ld	s2,0(sp)
    80002bb2:	6105                	addi	sp,sp,32
    80002bb4:	8082                	ret

0000000080002bb6 <idup>:
{
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	e426                	sd	s1,8(sp)
    80002bbe:	1000                	addi	s0,sp,32
    80002bc0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bc2:	00018517          	auipc	a0,0x18
    80002bc6:	1b650513          	addi	a0,a0,438 # 8001ad78 <itable>
    80002bca:	00003097          	auipc	ra,0x3
    80002bce:	778080e7          	jalr	1912(ra) # 80006342 <acquire>
  ip->ref++;
    80002bd2:	449c                	lw	a5,8(s1)
    80002bd4:	2785                	addiw	a5,a5,1
    80002bd6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bd8:	00018517          	auipc	a0,0x18
    80002bdc:	1a050513          	addi	a0,a0,416 # 8001ad78 <itable>
    80002be0:	00004097          	auipc	ra,0x4
    80002be4:	816080e7          	jalr	-2026(ra) # 800063f6 <release>
}
    80002be8:	8526                	mv	a0,s1
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6105                	addi	sp,sp,32
    80002bf2:	8082                	ret

0000000080002bf4 <ilock>:
{
    80002bf4:	1101                	addi	sp,sp,-32
    80002bf6:	ec06                	sd	ra,24(sp)
    80002bf8:	e822                	sd	s0,16(sp)
    80002bfa:	e426                	sd	s1,8(sp)
    80002bfc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bfe:	c10d                	beqz	a0,80002c20 <ilock+0x2c>
    80002c00:	84aa                	mv	s1,a0
    80002c02:	451c                	lw	a5,8(a0)
    80002c04:	00f05e63          	blez	a5,80002c20 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c08:	0541                	addi	a0,a0,16
    80002c0a:	00001097          	auipc	ra,0x1
    80002c0e:	cb2080e7          	jalr	-846(ra) # 800038bc <acquiresleep>
  if(ip->valid == 0){
    80002c12:	40bc                	lw	a5,64(s1)
    80002c14:	cf99                	beqz	a5,80002c32 <ilock+0x3e>
}
    80002c16:	60e2                	ld	ra,24(sp)
    80002c18:	6442                	ld	s0,16(sp)
    80002c1a:	64a2                	ld	s1,8(sp)
    80002c1c:	6105                	addi	sp,sp,32
    80002c1e:	8082                	ret
    80002c20:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c22:	00006517          	auipc	a0,0x6
    80002c26:	82e50513          	addi	a0,a0,-2002 # 80008450 <etext+0x450>
    80002c2a:	00003097          	auipc	ra,0x3
    80002c2e:	1c8080e7          	jalr	456(ra) # 80005df2 <panic>
    80002c32:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c34:	40dc                	lw	a5,4(s1)
    80002c36:	0047d79b          	srliw	a5,a5,0x4
    80002c3a:	00018597          	auipc	a1,0x18
    80002c3e:	1365a583          	lw	a1,310(a1) # 8001ad70 <sb+0x18>
    80002c42:	9dbd                	addw	a1,a1,a5
    80002c44:	4088                	lw	a0,0(s1)
    80002c46:	fffff097          	auipc	ra,0xfffff
    80002c4a:	7b4080e7          	jalr	1972(ra) # 800023fa <bread>
    80002c4e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c50:	05850593          	addi	a1,a0,88
    80002c54:	40dc                	lw	a5,4(s1)
    80002c56:	8bbd                	andi	a5,a5,15
    80002c58:	079a                	slli	a5,a5,0x6
    80002c5a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c5c:	00059783          	lh	a5,0(a1)
    80002c60:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c64:	00259783          	lh	a5,2(a1)
    80002c68:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c6c:	00459783          	lh	a5,4(a1)
    80002c70:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c74:	00659783          	lh	a5,6(a1)
    80002c78:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c7c:	459c                	lw	a5,8(a1)
    80002c7e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c80:	03400613          	li	a2,52
    80002c84:	05b1                	addi	a1,a1,12
    80002c86:	05048513          	addi	a0,s1,80
    80002c8a:	ffffd097          	auipc	ra,0xffffd
    80002c8e:	54c080e7          	jalr	1356(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c92:	854a                	mv	a0,s2
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	896080e7          	jalr	-1898(ra) # 8000252a <brelse>
    ip->valid = 1;
    80002c9c:	4785                	li	a5,1
    80002c9e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ca0:	04449783          	lh	a5,68(s1)
    80002ca4:	c399                	beqz	a5,80002caa <ilock+0xb6>
    80002ca6:	6902                	ld	s2,0(sp)
    80002ca8:	b7bd                	j	80002c16 <ilock+0x22>
      panic("ilock: no type");
    80002caa:	00005517          	auipc	a0,0x5
    80002cae:	7ae50513          	addi	a0,a0,1966 # 80008458 <etext+0x458>
    80002cb2:	00003097          	auipc	ra,0x3
    80002cb6:	140080e7          	jalr	320(ra) # 80005df2 <panic>

0000000080002cba <iunlock>:
{
    80002cba:	1101                	addi	sp,sp,-32
    80002cbc:	ec06                	sd	ra,24(sp)
    80002cbe:	e822                	sd	s0,16(sp)
    80002cc0:	e426                	sd	s1,8(sp)
    80002cc2:	e04a                	sd	s2,0(sp)
    80002cc4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cc6:	c905                	beqz	a0,80002cf6 <iunlock+0x3c>
    80002cc8:	84aa                	mv	s1,a0
    80002cca:	01050913          	addi	s2,a0,16
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	c86080e7          	jalr	-890(ra) # 80003956 <holdingsleep>
    80002cd8:	cd19                	beqz	a0,80002cf6 <iunlock+0x3c>
    80002cda:	449c                	lw	a5,8(s1)
    80002cdc:	00f05d63          	blez	a5,80002cf6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ce0:	854a                	mv	a0,s2
    80002ce2:	00001097          	auipc	ra,0x1
    80002ce6:	c30080e7          	jalr	-976(ra) # 80003912 <releasesleep>
}
    80002cea:	60e2                	ld	ra,24(sp)
    80002cec:	6442                	ld	s0,16(sp)
    80002cee:	64a2                	ld	s1,8(sp)
    80002cf0:	6902                	ld	s2,0(sp)
    80002cf2:	6105                	addi	sp,sp,32
    80002cf4:	8082                	ret
    panic("iunlock");
    80002cf6:	00005517          	auipc	a0,0x5
    80002cfa:	77250513          	addi	a0,a0,1906 # 80008468 <etext+0x468>
    80002cfe:	00003097          	auipc	ra,0x3
    80002d02:	0f4080e7          	jalr	244(ra) # 80005df2 <panic>

0000000080002d06 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d06:	7179                	addi	sp,sp,-48
    80002d08:	f406                	sd	ra,40(sp)
    80002d0a:	f022                	sd	s0,32(sp)
    80002d0c:	ec26                	sd	s1,24(sp)
    80002d0e:	e84a                	sd	s2,16(sp)
    80002d10:	e44e                	sd	s3,8(sp)
    80002d12:	1800                	addi	s0,sp,48
    80002d14:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d16:	05050493          	addi	s1,a0,80
    80002d1a:	08050913          	addi	s2,a0,128
    80002d1e:	a021                	j	80002d26 <itrunc+0x20>
    80002d20:	0491                	addi	s1,s1,4
    80002d22:	01248d63          	beq	s1,s2,80002d3c <itrunc+0x36>
    if(ip->addrs[i]){
    80002d26:	408c                	lw	a1,0(s1)
    80002d28:	dde5                	beqz	a1,80002d20 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d2a:	0009a503          	lw	a0,0(s3)
    80002d2e:	00000097          	auipc	ra,0x0
    80002d32:	910080e7          	jalr	-1776(ra) # 8000263e <bfree>
      ip->addrs[i] = 0;
    80002d36:	0004a023          	sw	zero,0(s1)
    80002d3a:	b7dd                	j	80002d20 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d3c:	0809a583          	lw	a1,128(s3)
    80002d40:	ed99                	bnez	a1,80002d5e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d42:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d46:	854e                	mv	a0,s3
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	de0080e7          	jalr	-544(ra) # 80002b28 <iupdate>
}
    80002d50:	70a2                	ld	ra,40(sp)
    80002d52:	7402                	ld	s0,32(sp)
    80002d54:	64e2                	ld	s1,24(sp)
    80002d56:	6942                	ld	s2,16(sp)
    80002d58:	69a2                	ld	s3,8(sp)
    80002d5a:	6145                	addi	sp,sp,48
    80002d5c:	8082                	ret
    80002d5e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d60:	0009a503          	lw	a0,0(s3)
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	696080e7          	jalr	1686(ra) # 800023fa <bread>
    80002d6c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d6e:	05850493          	addi	s1,a0,88
    80002d72:	45850913          	addi	s2,a0,1112
    80002d76:	a021                	j	80002d7e <itrunc+0x78>
    80002d78:	0491                	addi	s1,s1,4
    80002d7a:	01248b63          	beq	s1,s2,80002d90 <itrunc+0x8a>
      if(a[j])
    80002d7e:	408c                	lw	a1,0(s1)
    80002d80:	dde5                	beqz	a1,80002d78 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002d82:	0009a503          	lw	a0,0(s3)
    80002d86:	00000097          	auipc	ra,0x0
    80002d8a:	8b8080e7          	jalr	-1864(ra) # 8000263e <bfree>
    80002d8e:	b7ed                	j	80002d78 <itrunc+0x72>
    brelse(bp);
    80002d90:	8552                	mv	a0,s4
    80002d92:	fffff097          	auipc	ra,0xfffff
    80002d96:	798080e7          	jalr	1944(ra) # 8000252a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d9a:	0809a583          	lw	a1,128(s3)
    80002d9e:	0009a503          	lw	a0,0(s3)
    80002da2:	00000097          	auipc	ra,0x0
    80002da6:	89c080e7          	jalr	-1892(ra) # 8000263e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002daa:	0809a023          	sw	zero,128(s3)
    80002dae:	6a02                	ld	s4,0(sp)
    80002db0:	bf49                	j	80002d42 <itrunc+0x3c>

0000000080002db2 <iput>:
{
    80002db2:	1101                	addi	sp,sp,-32
    80002db4:	ec06                	sd	ra,24(sp)
    80002db6:	e822                	sd	s0,16(sp)
    80002db8:	e426                	sd	s1,8(sp)
    80002dba:	1000                	addi	s0,sp,32
    80002dbc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dbe:	00018517          	auipc	a0,0x18
    80002dc2:	fba50513          	addi	a0,a0,-70 # 8001ad78 <itable>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	57c080e7          	jalr	1404(ra) # 80006342 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dce:	4498                	lw	a4,8(s1)
    80002dd0:	4785                	li	a5,1
    80002dd2:	02f70263          	beq	a4,a5,80002df6 <iput+0x44>
  ip->ref--;
    80002dd6:	449c                	lw	a5,8(s1)
    80002dd8:	37fd                	addiw	a5,a5,-1
    80002dda:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ddc:	00018517          	auipc	a0,0x18
    80002de0:	f9c50513          	addi	a0,a0,-100 # 8001ad78 <itable>
    80002de4:	00003097          	auipc	ra,0x3
    80002de8:	612080e7          	jalr	1554(ra) # 800063f6 <release>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	64a2                	ld	s1,8(sp)
    80002df2:	6105                	addi	sp,sp,32
    80002df4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002df6:	40bc                	lw	a5,64(s1)
    80002df8:	dff9                	beqz	a5,80002dd6 <iput+0x24>
    80002dfa:	04a49783          	lh	a5,74(s1)
    80002dfe:	ffe1                	bnez	a5,80002dd6 <iput+0x24>
    80002e00:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e02:	01048913          	addi	s2,s1,16
    80002e06:	854a                	mv	a0,s2
    80002e08:	00001097          	auipc	ra,0x1
    80002e0c:	ab4080e7          	jalr	-1356(ra) # 800038bc <acquiresleep>
    release(&itable.lock);
    80002e10:	00018517          	auipc	a0,0x18
    80002e14:	f6850513          	addi	a0,a0,-152 # 8001ad78 <itable>
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	5de080e7          	jalr	1502(ra) # 800063f6 <release>
    itrunc(ip);
    80002e20:	8526                	mv	a0,s1
    80002e22:	00000097          	auipc	ra,0x0
    80002e26:	ee4080e7          	jalr	-284(ra) # 80002d06 <itrunc>
    ip->type = 0;
    80002e2a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e2e:	8526                	mv	a0,s1
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	cf8080e7          	jalr	-776(ra) # 80002b28 <iupdate>
    ip->valid = 0;
    80002e38:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	00001097          	auipc	ra,0x1
    80002e42:	ad4080e7          	jalr	-1324(ra) # 80003912 <releasesleep>
    acquire(&itable.lock);
    80002e46:	00018517          	auipc	a0,0x18
    80002e4a:	f3250513          	addi	a0,a0,-206 # 8001ad78 <itable>
    80002e4e:	00003097          	auipc	ra,0x3
    80002e52:	4f4080e7          	jalr	1268(ra) # 80006342 <acquire>
    80002e56:	6902                	ld	s2,0(sp)
    80002e58:	bfbd                	j	80002dd6 <iput+0x24>

0000000080002e5a <iunlockput>:
{
    80002e5a:	1101                	addi	sp,sp,-32
    80002e5c:	ec06                	sd	ra,24(sp)
    80002e5e:	e822                	sd	s0,16(sp)
    80002e60:	e426                	sd	s1,8(sp)
    80002e62:	1000                	addi	s0,sp,32
    80002e64:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	e54080e7          	jalr	-428(ra) # 80002cba <iunlock>
  iput(ip);
    80002e6e:	8526                	mv	a0,s1
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	f42080e7          	jalr	-190(ra) # 80002db2 <iput>
}
    80002e78:	60e2                	ld	ra,24(sp)
    80002e7a:	6442                	ld	s0,16(sp)
    80002e7c:	64a2                	ld	s1,8(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret

0000000080002e82 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e82:	1141                	addi	sp,sp,-16
    80002e84:	e422                	sd	s0,8(sp)
    80002e86:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e88:	411c                	lw	a5,0(a0)
    80002e8a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e8c:	415c                	lw	a5,4(a0)
    80002e8e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e90:	04451783          	lh	a5,68(a0)
    80002e94:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e98:	04a51783          	lh	a5,74(a0)
    80002e9c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ea0:	04c56783          	lwu	a5,76(a0)
    80002ea4:	e99c                	sd	a5,16(a1)
}
    80002ea6:	6422                	ld	s0,8(sp)
    80002ea8:	0141                	addi	sp,sp,16
    80002eaa:	8082                	ret

0000000080002eac <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eac:	457c                	lw	a5,76(a0)
    80002eae:	0ed7ef63          	bltu	a5,a3,80002fac <readi+0x100>
{
    80002eb2:	7159                	addi	sp,sp,-112
    80002eb4:	f486                	sd	ra,104(sp)
    80002eb6:	f0a2                	sd	s0,96(sp)
    80002eb8:	eca6                	sd	s1,88(sp)
    80002eba:	fc56                	sd	s5,56(sp)
    80002ebc:	f85a                	sd	s6,48(sp)
    80002ebe:	f45e                	sd	s7,40(sp)
    80002ec0:	f062                	sd	s8,32(sp)
    80002ec2:	1880                	addi	s0,sp,112
    80002ec4:	8baa                	mv	s7,a0
    80002ec6:	8c2e                	mv	s8,a1
    80002ec8:	8ab2                	mv	s5,a2
    80002eca:	84b6                	mv	s1,a3
    80002ecc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ece:	9f35                	addw	a4,a4,a3
    return 0;
    80002ed0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ed2:	0ad76c63          	bltu	a4,a3,80002f8a <readi+0xde>
    80002ed6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002ed8:	00e7f463          	bgeu	a5,a4,80002ee0 <readi+0x34>
    n = ip->size - off;
    80002edc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee0:	0c0b0463          	beqz	s6,80002fa8 <readi+0xfc>
    80002ee4:	e8ca                	sd	s2,80(sp)
    80002ee6:	e0d2                	sd	s4,64(sp)
    80002ee8:	ec66                	sd	s9,24(sp)
    80002eea:	e86a                	sd	s10,16(sp)
    80002eec:	e46e                	sd	s11,8(sp)
    80002eee:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef0:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ef4:	5cfd                	li	s9,-1
    80002ef6:	a82d                	j	80002f30 <readi+0x84>
    80002ef8:	020a1d93          	slli	s11,s4,0x20
    80002efc:	020ddd93          	srli	s11,s11,0x20
    80002f00:	05890613          	addi	a2,s2,88
    80002f04:	86ee                	mv	a3,s11
    80002f06:	963a                	add	a2,a2,a4
    80002f08:	85d6                	mv	a1,s5
    80002f0a:	8562                	mv	a0,s8
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	a24080e7          	jalr	-1500(ra) # 80001930 <either_copyout>
    80002f14:	05950d63          	beq	a0,s9,80002f6e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f18:	854a                	mv	a0,s2
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	610080e7          	jalr	1552(ra) # 8000252a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f22:	013a09bb          	addw	s3,s4,s3
    80002f26:	009a04bb          	addw	s1,s4,s1
    80002f2a:	9aee                	add	s5,s5,s11
    80002f2c:	0769f863          	bgeu	s3,s6,80002f9c <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f30:	000ba903          	lw	s2,0(s7)
    80002f34:	00a4d59b          	srliw	a1,s1,0xa
    80002f38:	855e                	mv	a0,s7
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	8ae080e7          	jalr	-1874(ra) # 800027e8 <bmap>
    80002f42:	0005059b          	sext.w	a1,a0
    80002f46:	854a                	mv	a0,s2
    80002f48:	fffff097          	auipc	ra,0xfffff
    80002f4c:	4b2080e7          	jalr	1202(ra) # 800023fa <bread>
    80002f50:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f52:	3ff4f713          	andi	a4,s1,1023
    80002f56:	40ed07bb          	subw	a5,s10,a4
    80002f5a:	413b06bb          	subw	a3,s6,s3
    80002f5e:	8a3e                	mv	s4,a5
    80002f60:	2781                	sext.w	a5,a5
    80002f62:	0006861b          	sext.w	a2,a3
    80002f66:	f8f679e3          	bgeu	a2,a5,80002ef8 <readi+0x4c>
    80002f6a:	8a36                	mv	s4,a3
    80002f6c:	b771                	j	80002ef8 <readi+0x4c>
      brelse(bp);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	5ba080e7          	jalr	1466(ra) # 8000252a <brelse>
      tot = -1;
    80002f78:	59fd                	li	s3,-1
      break;
    80002f7a:	6946                	ld	s2,80(sp)
    80002f7c:	6a06                	ld	s4,64(sp)
    80002f7e:	6ce2                	ld	s9,24(sp)
    80002f80:	6d42                	ld	s10,16(sp)
    80002f82:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002f84:	0009851b          	sext.w	a0,s3
    80002f88:	69a6                	ld	s3,72(sp)
}
    80002f8a:	70a6                	ld	ra,104(sp)
    80002f8c:	7406                	ld	s0,96(sp)
    80002f8e:	64e6                	ld	s1,88(sp)
    80002f90:	7ae2                	ld	s5,56(sp)
    80002f92:	7b42                	ld	s6,48(sp)
    80002f94:	7ba2                	ld	s7,40(sp)
    80002f96:	7c02                	ld	s8,32(sp)
    80002f98:	6165                	addi	sp,sp,112
    80002f9a:	8082                	ret
    80002f9c:	6946                	ld	s2,80(sp)
    80002f9e:	6a06                	ld	s4,64(sp)
    80002fa0:	6ce2                	ld	s9,24(sp)
    80002fa2:	6d42                	ld	s10,16(sp)
    80002fa4:	6da2                	ld	s11,8(sp)
    80002fa6:	bff9                	j	80002f84 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fa8:	89da                	mv	s3,s6
    80002faa:	bfe9                	j	80002f84 <readi+0xd8>
    return 0;
    80002fac:	4501                	li	a0,0
}
    80002fae:	8082                	ret

0000000080002fb0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fb0:	457c                	lw	a5,76(a0)
    80002fb2:	10d7ee63          	bltu	a5,a3,800030ce <writei+0x11e>
{
    80002fb6:	7159                	addi	sp,sp,-112
    80002fb8:	f486                	sd	ra,104(sp)
    80002fba:	f0a2                	sd	s0,96(sp)
    80002fbc:	e8ca                	sd	s2,80(sp)
    80002fbe:	fc56                	sd	s5,56(sp)
    80002fc0:	f85a                	sd	s6,48(sp)
    80002fc2:	f45e                	sd	s7,40(sp)
    80002fc4:	f062                	sd	s8,32(sp)
    80002fc6:	1880                	addi	s0,sp,112
    80002fc8:	8b2a                	mv	s6,a0
    80002fca:	8c2e                	mv	s8,a1
    80002fcc:	8ab2                	mv	s5,a2
    80002fce:	8936                	mv	s2,a3
    80002fd0:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fd2:	00e687bb          	addw	a5,a3,a4
    80002fd6:	0ed7ee63          	bltu	a5,a3,800030d2 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fda:	00043737          	lui	a4,0x43
    80002fde:	0ef76c63          	bltu	a4,a5,800030d6 <writei+0x126>
    80002fe2:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe4:	0c0b8d63          	beqz	s7,800030be <writei+0x10e>
    80002fe8:	eca6                	sd	s1,88(sp)
    80002fea:	e4ce                	sd	s3,72(sp)
    80002fec:	ec66                	sd	s9,24(sp)
    80002fee:	e86a                	sd	s10,16(sp)
    80002ff0:	e46e                	sd	s11,8(sp)
    80002ff2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ff8:	5cfd                	li	s9,-1
    80002ffa:	a091                	j	8000303e <writei+0x8e>
    80002ffc:	02099d93          	slli	s11,s3,0x20
    80003000:	020ddd93          	srli	s11,s11,0x20
    80003004:	05848513          	addi	a0,s1,88
    80003008:	86ee                	mv	a3,s11
    8000300a:	8656                	mv	a2,s5
    8000300c:	85e2                	mv	a1,s8
    8000300e:	953a                	add	a0,a0,a4
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	976080e7          	jalr	-1674(ra) # 80001986 <either_copyin>
    80003018:	07950263          	beq	a0,s9,8000307c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000301c:	8526                	mv	a0,s1
    8000301e:	00000097          	auipc	ra,0x0
    80003022:	780080e7          	jalr	1920(ra) # 8000379e <log_write>
    brelse(bp);
    80003026:	8526                	mv	a0,s1
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	502080e7          	jalr	1282(ra) # 8000252a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003030:	01498a3b          	addw	s4,s3,s4
    80003034:	0129893b          	addw	s2,s3,s2
    80003038:	9aee                	add	s5,s5,s11
    8000303a:	057a7663          	bgeu	s4,s7,80003086 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000303e:	000b2483          	lw	s1,0(s6)
    80003042:	00a9559b          	srliw	a1,s2,0xa
    80003046:	855a                	mv	a0,s6
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	7a0080e7          	jalr	1952(ra) # 800027e8 <bmap>
    80003050:	0005059b          	sext.w	a1,a0
    80003054:	8526                	mv	a0,s1
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	3a4080e7          	jalr	932(ra) # 800023fa <bread>
    8000305e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003060:	3ff97713          	andi	a4,s2,1023
    80003064:	40ed07bb          	subw	a5,s10,a4
    80003068:	414b86bb          	subw	a3,s7,s4
    8000306c:	89be                	mv	s3,a5
    8000306e:	2781                	sext.w	a5,a5
    80003070:	0006861b          	sext.w	a2,a3
    80003074:	f8f674e3          	bgeu	a2,a5,80002ffc <writei+0x4c>
    80003078:	89b6                	mv	s3,a3
    8000307a:	b749                	j	80002ffc <writei+0x4c>
      brelse(bp);
    8000307c:	8526                	mv	a0,s1
    8000307e:	fffff097          	auipc	ra,0xfffff
    80003082:	4ac080e7          	jalr	1196(ra) # 8000252a <brelse>
  }

  if(off > ip->size)
    80003086:	04cb2783          	lw	a5,76(s6)
    8000308a:	0327fc63          	bgeu	a5,s2,800030c2 <writei+0x112>
    ip->size = off;
    8000308e:	052b2623          	sw	s2,76(s6)
    80003092:	64e6                	ld	s1,88(sp)
    80003094:	69a6                	ld	s3,72(sp)
    80003096:	6ce2                	ld	s9,24(sp)
    80003098:	6d42                	ld	s10,16(sp)
    8000309a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000309c:	855a                	mv	a0,s6
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	a8a080e7          	jalr	-1398(ra) # 80002b28 <iupdate>

  return tot;
    800030a6:	000a051b          	sext.w	a0,s4
    800030aa:	6a06                	ld	s4,64(sp)
}
    800030ac:	70a6                	ld	ra,104(sp)
    800030ae:	7406                	ld	s0,96(sp)
    800030b0:	6946                	ld	s2,80(sp)
    800030b2:	7ae2                	ld	s5,56(sp)
    800030b4:	7b42                	ld	s6,48(sp)
    800030b6:	7ba2                	ld	s7,40(sp)
    800030b8:	7c02                	ld	s8,32(sp)
    800030ba:	6165                	addi	sp,sp,112
    800030bc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030be:	8a5e                	mv	s4,s7
    800030c0:	bff1                	j	8000309c <writei+0xec>
    800030c2:	64e6                	ld	s1,88(sp)
    800030c4:	69a6                	ld	s3,72(sp)
    800030c6:	6ce2                	ld	s9,24(sp)
    800030c8:	6d42                	ld	s10,16(sp)
    800030ca:	6da2                	ld	s11,8(sp)
    800030cc:	bfc1                	j	8000309c <writei+0xec>
    return -1;
    800030ce:	557d                	li	a0,-1
}
    800030d0:	8082                	ret
    return -1;
    800030d2:	557d                	li	a0,-1
    800030d4:	bfe1                	j	800030ac <writei+0xfc>
    return -1;
    800030d6:	557d                	li	a0,-1
    800030d8:	bfd1                	j	800030ac <writei+0xfc>

00000000800030da <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030da:	1141                	addi	sp,sp,-16
    800030dc:	e406                	sd	ra,8(sp)
    800030de:	e022                	sd	s0,0(sp)
    800030e0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030e2:	4639                	li	a2,14
    800030e4:	ffffd097          	auipc	ra,0xffffd
    800030e8:	166080e7          	jalr	358(ra) # 8000024a <strncmp>
}
    800030ec:	60a2                	ld	ra,8(sp)
    800030ee:	6402                	ld	s0,0(sp)
    800030f0:	0141                	addi	sp,sp,16
    800030f2:	8082                	ret

00000000800030f4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030f4:	7139                	addi	sp,sp,-64
    800030f6:	fc06                	sd	ra,56(sp)
    800030f8:	f822                	sd	s0,48(sp)
    800030fa:	f426                	sd	s1,40(sp)
    800030fc:	f04a                	sd	s2,32(sp)
    800030fe:	ec4e                	sd	s3,24(sp)
    80003100:	e852                	sd	s4,16(sp)
    80003102:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003104:	04451703          	lh	a4,68(a0)
    80003108:	4785                	li	a5,1
    8000310a:	00f71a63          	bne	a4,a5,8000311e <dirlookup+0x2a>
    8000310e:	892a                	mv	s2,a0
    80003110:	89ae                	mv	s3,a1
    80003112:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003114:	457c                	lw	a5,76(a0)
    80003116:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003118:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000311a:	e79d                	bnez	a5,80003148 <dirlookup+0x54>
    8000311c:	a8a5                	j	80003194 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000311e:	00005517          	auipc	a0,0x5
    80003122:	35250513          	addi	a0,a0,850 # 80008470 <etext+0x470>
    80003126:	00003097          	auipc	ra,0x3
    8000312a:	ccc080e7          	jalr	-820(ra) # 80005df2 <panic>
      panic("dirlookup read");
    8000312e:	00005517          	auipc	a0,0x5
    80003132:	35a50513          	addi	a0,a0,858 # 80008488 <etext+0x488>
    80003136:	00003097          	auipc	ra,0x3
    8000313a:	cbc080e7          	jalr	-836(ra) # 80005df2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000313e:	24c1                	addiw	s1,s1,16
    80003140:	04c92783          	lw	a5,76(s2)
    80003144:	04f4f763          	bgeu	s1,a5,80003192 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003148:	4741                	li	a4,16
    8000314a:	86a6                	mv	a3,s1
    8000314c:	fc040613          	addi	a2,s0,-64
    80003150:	4581                	li	a1,0
    80003152:	854a                	mv	a0,s2
    80003154:	00000097          	auipc	ra,0x0
    80003158:	d58080e7          	jalr	-680(ra) # 80002eac <readi>
    8000315c:	47c1                	li	a5,16
    8000315e:	fcf518e3          	bne	a0,a5,8000312e <dirlookup+0x3a>
    if(de.inum == 0)
    80003162:	fc045783          	lhu	a5,-64(s0)
    80003166:	dfe1                	beqz	a5,8000313e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003168:	fc240593          	addi	a1,s0,-62
    8000316c:	854e                	mv	a0,s3
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	f6c080e7          	jalr	-148(ra) # 800030da <namecmp>
    80003176:	f561                	bnez	a0,8000313e <dirlookup+0x4a>
      if(poff)
    80003178:	000a0463          	beqz	s4,80003180 <dirlookup+0x8c>
        *poff = off;
    8000317c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003180:	fc045583          	lhu	a1,-64(s0)
    80003184:	00092503          	lw	a0,0(s2)
    80003188:	fffff097          	auipc	ra,0xfffff
    8000318c:	73c080e7          	jalr	1852(ra) # 800028c4 <iget>
    80003190:	a011                	j	80003194 <dirlookup+0xa0>
  return 0;
    80003192:	4501                	li	a0,0
}
    80003194:	70e2                	ld	ra,56(sp)
    80003196:	7442                	ld	s0,48(sp)
    80003198:	74a2                	ld	s1,40(sp)
    8000319a:	7902                	ld	s2,32(sp)
    8000319c:	69e2                	ld	s3,24(sp)
    8000319e:	6a42                	ld	s4,16(sp)
    800031a0:	6121                	addi	sp,sp,64
    800031a2:	8082                	ret

00000000800031a4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031a4:	711d                	addi	sp,sp,-96
    800031a6:	ec86                	sd	ra,88(sp)
    800031a8:	e8a2                	sd	s0,80(sp)
    800031aa:	e4a6                	sd	s1,72(sp)
    800031ac:	e0ca                	sd	s2,64(sp)
    800031ae:	fc4e                	sd	s3,56(sp)
    800031b0:	f852                	sd	s4,48(sp)
    800031b2:	f456                	sd	s5,40(sp)
    800031b4:	f05a                	sd	s6,32(sp)
    800031b6:	ec5e                	sd	s7,24(sp)
    800031b8:	e862                	sd	s8,16(sp)
    800031ba:	e466                	sd	s9,8(sp)
    800031bc:	1080                	addi	s0,sp,96
    800031be:	84aa                	mv	s1,a0
    800031c0:	8b2e                	mv	s6,a1
    800031c2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031c4:	00054703          	lbu	a4,0(a0)
    800031c8:	02f00793          	li	a5,47
    800031cc:	02f70263          	beq	a4,a5,800031f0 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031d0:	ffffe097          	auipc	ra,0xffffe
    800031d4:	cac080e7          	jalr	-852(ra) # 80000e7c <myproc>
    800031d8:	15053503          	ld	a0,336(a0)
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	9da080e7          	jalr	-1574(ra) # 80002bb6 <idup>
    800031e4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031e6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031ea:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031ec:	4b85                	li	s7,1
    800031ee:	a875                	j	800032aa <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031f0:	4585                	li	a1,1
    800031f2:	4505                	li	a0,1
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	6d0080e7          	jalr	1744(ra) # 800028c4 <iget>
    800031fc:	8a2a                	mv	s4,a0
    800031fe:	b7e5                	j	800031e6 <namex+0x42>
      iunlockput(ip);
    80003200:	8552                	mv	a0,s4
    80003202:	00000097          	auipc	ra,0x0
    80003206:	c58080e7          	jalr	-936(ra) # 80002e5a <iunlockput>
      return 0;
    8000320a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000320c:	8552                	mv	a0,s4
    8000320e:	60e6                	ld	ra,88(sp)
    80003210:	6446                	ld	s0,80(sp)
    80003212:	64a6                	ld	s1,72(sp)
    80003214:	6906                	ld	s2,64(sp)
    80003216:	79e2                	ld	s3,56(sp)
    80003218:	7a42                	ld	s4,48(sp)
    8000321a:	7aa2                	ld	s5,40(sp)
    8000321c:	7b02                	ld	s6,32(sp)
    8000321e:	6be2                	ld	s7,24(sp)
    80003220:	6c42                	ld	s8,16(sp)
    80003222:	6ca2                	ld	s9,8(sp)
    80003224:	6125                	addi	sp,sp,96
    80003226:	8082                	ret
      iunlock(ip);
    80003228:	8552                	mv	a0,s4
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	a90080e7          	jalr	-1392(ra) # 80002cba <iunlock>
      return ip;
    80003232:	bfe9                	j	8000320c <namex+0x68>
      iunlockput(ip);
    80003234:	8552                	mv	a0,s4
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	c24080e7          	jalr	-988(ra) # 80002e5a <iunlockput>
      return 0;
    8000323e:	8a4e                	mv	s4,s3
    80003240:	b7f1                	j	8000320c <namex+0x68>
  len = path - s;
    80003242:	40998633          	sub	a2,s3,s1
    80003246:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000324a:	099c5863          	bge	s8,s9,800032da <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000324e:	4639                	li	a2,14
    80003250:	85a6                	mv	a1,s1
    80003252:	8556                	mv	a0,s5
    80003254:	ffffd097          	auipc	ra,0xffffd
    80003258:	f82080e7          	jalr	-126(ra) # 800001d6 <memmove>
    8000325c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	01279763          	bne	a5,s2,80003270 <namex+0xcc>
    path++;
    80003266:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	ff278de3          	beq	a5,s2,80003266 <namex+0xc2>
    ilock(ip);
    80003270:	8552                	mv	a0,s4
    80003272:	00000097          	auipc	ra,0x0
    80003276:	982080e7          	jalr	-1662(ra) # 80002bf4 <ilock>
    if(ip->type != T_DIR){
    8000327a:	044a1783          	lh	a5,68(s4)
    8000327e:	f97791e3          	bne	a5,s7,80003200 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003282:	000b0563          	beqz	s6,8000328c <namex+0xe8>
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	dfd9                	beqz	a5,80003228 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000328c:	4601                	li	a2,0
    8000328e:	85d6                	mv	a1,s5
    80003290:	8552                	mv	a0,s4
    80003292:	00000097          	auipc	ra,0x0
    80003296:	e62080e7          	jalr	-414(ra) # 800030f4 <dirlookup>
    8000329a:	89aa                	mv	s3,a0
    8000329c:	dd41                	beqz	a0,80003234 <namex+0x90>
    iunlockput(ip);
    8000329e:	8552                	mv	a0,s4
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	bba080e7          	jalr	-1094(ra) # 80002e5a <iunlockput>
    ip = next;
    800032a8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032aa:	0004c783          	lbu	a5,0(s1)
    800032ae:	01279763          	bne	a5,s2,800032bc <namex+0x118>
    path++;
    800032b2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	ff278de3          	beq	a5,s2,800032b2 <namex+0x10e>
  if(*path == 0)
    800032bc:	cb9d                	beqz	a5,800032f2 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032be:	0004c783          	lbu	a5,0(s1)
    800032c2:	89a6                	mv	s3,s1
  len = path - s;
    800032c4:	4c81                	li	s9,0
    800032c6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032c8:	01278963          	beq	a5,s2,800032da <namex+0x136>
    800032cc:	dbbd                	beqz	a5,80003242 <namex+0x9e>
    path++;
    800032ce:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032d0:	0009c783          	lbu	a5,0(s3)
    800032d4:	ff279ce3          	bne	a5,s2,800032cc <namex+0x128>
    800032d8:	b7ad                	j	80003242 <namex+0x9e>
    memmove(name, s, len);
    800032da:	2601                	sext.w	a2,a2
    800032dc:	85a6                	mv	a1,s1
    800032de:	8556                	mv	a0,s5
    800032e0:	ffffd097          	auipc	ra,0xffffd
    800032e4:	ef6080e7          	jalr	-266(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032e8:	9cd6                	add	s9,s9,s5
    800032ea:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032ee:	84ce                	mv	s1,s3
    800032f0:	b7bd                	j	8000325e <namex+0xba>
  if(nameiparent){
    800032f2:	f00b0de3          	beqz	s6,8000320c <namex+0x68>
    iput(ip);
    800032f6:	8552                	mv	a0,s4
    800032f8:	00000097          	auipc	ra,0x0
    800032fc:	aba080e7          	jalr	-1350(ra) # 80002db2 <iput>
    return 0;
    80003300:	4a01                	li	s4,0
    80003302:	b729                	j	8000320c <namex+0x68>

0000000080003304 <dirlink>:
{
    80003304:	7139                	addi	sp,sp,-64
    80003306:	fc06                	sd	ra,56(sp)
    80003308:	f822                	sd	s0,48(sp)
    8000330a:	f04a                	sd	s2,32(sp)
    8000330c:	ec4e                	sd	s3,24(sp)
    8000330e:	e852                	sd	s4,16(sp)
    80003310:	0080                	addi	s0,sp,64
    80003312:	892a                	mv	s2,a0
    80003314:	8a2e                	mv	s4,a1
    80003316:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003318:	4601                	li	a2,0
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	dda080e7          	jalr	-550(ra) # 800030f4 <dirlookup>
    80003322:	ed25                	bnez	a0,8000339a <dirlink+0x96>
    80003324:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003326:	04c92483          	lw	s1,76(s2)
    8000332a:	c49d                	beqz	s1,80003358 <dirlink+0x54>
    8000332c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000332e:	4741                	li	a4,16
    80003330:	86a6                	mv	a3,s1
    80003332:	fc040613          	addi	a2,s0,-64
    80003336:	4581                	li	a1,0
    80003338:	854a                	mv	a0,s2
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	b72080e7          	jalr	-1166(ra) # 80002eac <readi>
    80003342:	47c1                	li	a5,16
    80003344:	06f51163          	bne	a0,a5,800033a6 <dirlink+0xa2>
    if(de.inum == 0)
    80003348:	fc045783          	lhu	a5,-64(s0)
    8000334c:	c791                	beqz	a5,80003358 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000334e:	24c1                	addiw	s1,s1,16
    80003350:	04c92783          	lw	a5,76(s2)
    80003354:	fcf4ede3          	bltu	s1,a5,8000332e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003358:	4639                	li	a2,14
    8000335a:	85d2                	mv	a1,s4
    8000335c:	fc240513          	addi	a0,s0,-62
    80003360:	ffffd097          	auipc	ra,0xffffd
    80003364:	f20080e7          	jalr	-224(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003368:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000336c:	4741                	li	a4,16
    8000336e:	86a6                	mv	a3,s1
    80003370:	fc040613          	addi	a2,s0,-64
    80003374:	4581                	li	a1,0
    80003376:	854a                	mv	a0,s2
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	c38080e7          	jalr	-968(ra) # 80002fb0 <writei>
    80003380:	872a                	mv	a4,a0
    80003382:	47c1                	li	a5,16
  return 0;
    80003384:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003386:	02f71863          	bne	a4,a5,800033b6 <dirlink+0xb2>
    8000338a:	74a2                	ld	s1,40(sp)
}
    8000338c:	70e2                	ld	ra,56(sp)
    8000338e:	7442                	ld	s0,48(sp)
    80003390:	7902                	ld	s2,32(sp)
    80003392:	69e2                	ld	s3,24(sp)
    80003394:	6a42                	ld	s4,16(sp)
    80003396:	6121                	addi	sp,sp,64
    80003398:	8082                	ret
    iput(ip);
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	a18080e7          	jalr	-1512(ra) # 80002db2 <iput>
    return -1;
    800033a2:	557d                	li	a0,-1
    800033a4:	b7e5                	j	8000338c <dirlink+0x88>
      panic("dirlink read");
    800033a6:	00005517          	auipc	a0,0x5
    800033aa:	0f250513          	addi	a0,a0,242 # 80008498 <etext+0x498>
    800033ae:	00003097          	auipc	ra,0x3
    800033b2:	a44080e7          	jalr	-1468(ra) # 80005df2 <panic>
    panic("dirlink");
    800033b6:	00005517          	auipc	a0,0x5
    800033ba:	1f250513          	addi	a0,a0,498 # 800085a8 <etext+0x5a8>
    800033be:	00003097          	auipc	ra,0x3
    800033c2:	a34080e7          	jalr	-1484(ra) # 80005df2 <panic>

00000000800033c6 <namei>:

struct inode*
namei(char *path)
{
    800033c6:	1101                	addi	sp,sp,-32
    800033c8:	ec06                	sd	ra,24(sp)
    800033ca:	e822                	sd	s0,16(sp)
    800033cc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ce:	fe040613          	addi	a2,s0,-32
    800033d2:	4581                	li	a1,0
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	dd0080e7          	jalr	-560(ra) # 800031a4 <namex>
}
    800033dc:	60e2                	ld	ra,24(sp)
    800033de:	6442                	ld	s0,16(sp)
    800033e0:	6105                	addi	sp,sp,32
    800033e2:	8082                	ret

00000000800033e4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033e4:	1141                	addi	sp,sp,-16
    800033e6:	e406                	sd	ra,8(sp)
    800033e8:	e022                	sd	s0,0(sp)
    800033ea:	0800                	addi	s0,sp,16
    800033ec:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033ee:	4585                	li	a1,1
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	db4080e7          	jalr	-588(ra) # 800031a4 <namex>
}
    800033f8:	60a2                	ld	ra,8(sp)
    800033fa:	6402                	ld	s0,0(sp)
    800033fc:	0141                	addi	sp,sp,16
    800033fe:	8082                	ret

0000000080003400 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	e426                	sd	s1,8(sp)
    80003408:	e04a                	sd	s2,0(sp)
    8000340a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000340c:	00019917          	auipc	s2,0x19
    80003410:	41490913          	addi	s2,s2,1044 # 8001c820 <log>
    80003414:	01892583          	lw	a1,24(s2)
    80003418:	02892503          	lw	a0,40(s2)
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	fde080e7          	jalr	-34(ra) # 800023fa <bread>
    80003424:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003426:	02c92603          	lw	a2,44(s2)
    8000342a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000342c:	00c05f63          	blez	a2,8000344a <write_head+0x4a>
    80003430:	00019717          	auipc	a4,0x19
    80003434:	42070713          	addi	a4,a4,1056 # 8001c850 <log+0x30>
    80003438:	87aa                	mv	a5,a0
    8000343a:	060a                	slli	a2,a2,0x2
    8000343c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000343e:	4314                	lw	a3,0(a4)
    80003440:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003442:	0711                	addi	a4,a4,4
    80003444:	0791                	addi	a5,a5,4
    80003446:	fec79ce3          	bne	a5,a2,8000343e <write_head+0x3e>
  }
  bwrite(buf);
    8000344a:	8526                	mv	a0,s1
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	0a0080e7          	jalr	160(ra) # 800024ec <bwrite>
  brelse(buf);
    80003454:	8526                	mv	a0,s1
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	0d4080e7          	jalr	212(ra) # 8000252a <brelse>
}
    8000345e:	60e2                	ld	ra,24(sp)
    80003460:	6442                	ld	s0,16(sp)
    80003462:	64a2                	ld	s1,8(sp)
    80003464:	6902                	ld	s2,0(sp)
    80003466:	6105                	addi	sp,sp,32
    80003468:	8082                	ret

000000008000346a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000346a:	00019797          	auipc	a5,0x19
    8000346e:	3e27a783          	lw	a5,994(a5) # 8001c84c <log+0x2c>
    80003472:	0af05d63          	blez	a5,8000352c <install_trans+0xc2>
{
    80003476:	7139                	addi	sp,sp,-64
    80003478:	fc06                	sd	ra,56(sp)
    8000347a:	f822                	sd	s0,48(sp)
    8000347c:	f426                	sd	s1,40(sp)
    8000347e:	f04a                	sd	s2,32(sp)
    80003480:	ec4e                	sd	s3,24(sp)
    80003482:	e852                	sd	s4,16(sp)
    80003484:	e456                	sd	s5,8(sp)
    80003486:	e05a                	sd	s6,0(sp)
    80003488:	0080                	addi	s0,sp,64
    8000348a:	8b2a                	mv	s6,a0
    8000348c:	00019a97          	auipc	s5,0x19
    80003490:	3c4a8a93          	addi	s5,s5,964 # 8001c850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003494:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003496:	00019997          	auipc	s3,0x19
    8000349a:	38a98993          	addi	s3,s3,906 # 8001c820 <log>
    8000349e:	a00d                	j	800034c0 <install_trans+0x56>
    brelse(lbuf);
    800034a0:	854a                	mv	a0,s2
    800034a2:	fffff097          	auipc	ra,0xfffff
    800034a6:	088080e7          	jalr	136(ra) # 8000252a <brelse>
    brelse(dbuf);
    800034aa:	8526                	mv	a0,s1
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	07e080e7          	jalr	126(ra) # 8000252a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b4:	2a05                	addiw	s4,s4,1
    800034b6:	0a91                	addi	s5,s5,4
    800034b8:	02c9a783          	lw	a5,44(s3)
    800034bc:	04fa5e63          	bge	s4,a5,80003518 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c0:	0189a583          	lw	a1,24(s3)
    800034c4:	014585bb          	addw	a1,a1,s4
    800034c8:	2585                	addiw	a1,a1,1
    800034ca:	0289a503          	lw	a0,40(s3)
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	f2c080e7          	jalr	-212(ra) # 800023fa <bread>
    800034d6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034d8:	000aa583          	lw	a1,0(s5)
    800034dc:	0289a503          	lw	a0,40(s3)
    800034e0:	fffff097          	auipc	ra,0xfffff
    800034e4:	f1a080e7          	jalr	-230(ra) # 800023fa <bread>
    800034e8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ea:	40000613          	li	a2,1024
    800034ee:	05890593          	addi	a1,s2,88
    800034f2:	05850513          	addi	a0,a0,88
    800034f6:	ffffd097          	auipc	ra,0xffffd
    800034fa:	ce0080e7          	jalr	-800(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034fe:	8526                	mv	a0,s1
    80003500:	fffff097          	auipc	ra,0xfffff
    80003504:	fec080e7          	jalr	-20(ra) # 800024ec <bwrite>
    if(recovering == 0)
    80003508:	f80b1ce3          	bnez	s6,800034a0 <install_trans+0x36>
      bunpin(dbuf);
    8000350c:	8526                	mv	a0,s1
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	0f4080e7          	jalr	244(ra) # 80002602 <bunpin>
    80003516:	b769                	j	800034a0 <install_trans+0x36>
}
    80003518:	70e2                	ld	ra,56(sp)
    8000351a:	7442                	ld	s0,48(sp)
    8000351c:	74a2                	ld	s1,40(sp)
    8000351e:	7902                	ld	s2,32(sp)
    80003520:	69e2                	ld	s3,24(sp)
    80003522:	6a42                	ld	s4,16(sp)
    80003524:	6aa2                	ld	s5,8(sp)
    80003526:	6b02                	ld	s6,0(sp)
    80003528:	6121                	addi	sp,sp,64
    8000352a:	8082                	ret
    8000352c:	8082                	ret

000000008000352e <initlog>:
{
    8000352e:	7179                	addi	sp,sp,-48
    80003530:	f406                	sd	ra,40(sp)
    80003532:	f022                	sd	s0,32(sp)
    80003534:	ec26                	sd	s1,24(sp)
    80003536:	e84a                	sd	s2,16(sp)
    80003538:	e44e                	sd	s3,8(sp)
    8000353a:	1800                	addi	s0,sp,48
    8000353c:	892a                	mv	s2,a0
    8000353e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003540:	00019497          	auipc	s1,0x19
    80003544:	2e048493          	addi	s1,s1,736 # 8001c820 <log>
    80003548:	00005597          	auipc	a1,0x5
    8000354c:	f6058593          	addi	a1,a1,-160 # 800084a8 <etext+0x4a8>
    80003550:	8526                	mv	a0,s1
    80003552:	00003097          	auipc	ra,0x3
    80003556:	d60080e7          	jalr	-672(ra) # 800062b2 <initlock>
  log.start = sb->logstart;
    8000355a:	0149a583          	lw	a1,20(s3)
    8000355e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003560:	0109a783          	lw	a5,16(s3)
    80003564:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003566:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000356a:	854a                	mv	a0,s2
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	e8e080e7          	jalr	-370(ra) # 800023fa <bread>
  log.lh.n = lh->n;
    80003574:	4d30                	lw	a2,88(a0)
    80003576:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003578:	00c05f63          	blez	a2,80003596 <initlog+0x68>
    8000357c:	87aa                	mv	a5,a0
    8000357e:	00019717          	auipc	a4,0x19
    80003582:	2d270713          	addi	a4,a4,722 # 8001c850 <log+0x30>
    80003586:	060a                	slli	a2,a2,0x2
    80003588:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000358a:	4ff4                	lw	a3,92(a5)
    8000358c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000358e:	0791                	addi	a5,a5,4
    80003590:	0711                	addi	a4,a4,4
    80003592:	fec79ce3          	bne	a5,a2,8000358a <initlog+0x5c>
  brelse(buf);
    80003596:	fffff097          	auipc	ra,0xfffff
    8000359a:	f94080e7          	jalr	-108(ra) # 8000252a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000359e:	4505                	li	a0,1
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	eca080e7          	jalr	-310(ra) # 8000346a <install_trans>
  log.lh.n = 0;
    800035a8:	00019797          	auipc	a5,0x19
    800035ac:	2a07a223          	sw	zero,676(a5) # 8001c84c <log+0x2c>
  write_head(); // clear the log
    800035b0:	00000097          	auipc	ra,0x0
    800035b4:	e50080e7          	jalr	-432(ra) # 80003400 <write_head>
}
    800035b8:	70a2                	ld	ra,40(sp)
    800035ba:	7402                	ld	s0,32(sp)
    800035bc:	64e2                	ld	s1,24(sp)
    800035be:	6942                	ld	s2,16(sp)
    800035c0:	69a2                	ld	s3,8(sp)
    800035c2:	6145                	addi	sp,sp,48
    800035c4:	8082                	ret

00000000800035c6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035c6:	1101                	addi	sp,sp,-32
    800035c8:	ec06                	sd	ra,24(sp)
    800035ca:	e822                	sd	s0,16(sp)
    800035cc:	e426                	sd	s1,8(sp)
    800035ce:	e04a                	sd	s2,0(sp)
    800035d0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035d2:	00019517          	auipc	a0,0x19
    800035d6:	24e50513          	addi	a0,a0,590 # 8001c820 <log>
    800035da:	00003097          	auipc	ra,0x3
    800035de:	d68080e7          	jalr	-664(ra) # 80006342 <acquire>
  while(1){
    if(log.committing){
    800035e2:	00019497          	auipc	s1,0x19
    800035e6:	23e48493          	addi	s1,s1,574 # 8001c820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ea:	4979                	li	s2,30
    800035ec:	a039                	j	800035fa <begin_op+0x34>
      sleep(&log, &log.lock);
    800035ee:	85a6                	mv	a1,s1
    800035f0:	8526                	mv	a0,s1
    800035f2:	ffffe097          	auipc	ra,0xffffe
    800035f6:	f9a080e7          	jalr	-102(ra) # 8000158c <sleep>
    if(log.committing){
    800035fa:	50dc                	lw	a5,36(s1)
    800035fc:	fbed                	bnez	a5,800035ee <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035fe:	5098                	lw	a4,32(s1)
    80003600:	2705                	addiw	a4,a4,1
    80003602:	0027179b          	slliw	a5,a4,0x2
    80003606:	9fb9                	addw	a5,a5,a4
    80003608:	0017979b          	slliw	a5,a5,0x1
    8000360c:	54d4                	lw	a3,44(s1)
    8000360e:	9fb5                	addw	a5,a5,a3
    80003610:	00f95963          	bge	s2,a5,80003622 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003614:	85a6                	mv	a1,s1
    80003616:	8526                	mv	a0,s1
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	f74080e7          	jalr	-140(ra) # 8000158c <sleep>
    80003620:	bfe9                	j	800035fa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003622:	00019517          	auipc	a0,0x19
    80003626:	1fe50513          	addi	a0,a0,510 # 8001c820 <log>
    8000362a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	dca080e7          	jalr	-566(ra) # 800063f6 <release>
      break;
    }
  }
}
    80003634:	60e2                	ld	ra,24(sp)
    80003636:	6442                	ld	s0,16(sp)
    80003638:	64a2                	ld	s1,8(sp)
    8000363a:	6902                	ld	s2,0(sp)
    8000363c:	6105                	addi	sp,sp,32
    8000363e:	8082                	ret

0000000080003640 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003640:	7139                	addi	sp,sp,-64
    80003642:	fc06                	sd	ra,56(sp)
    80003644:	f822                	sd	s0,48(sp)
    80003646:	f426                	sd	s1,40(sp)
    80003648:	f04a                	sd	s2,32(sp)
    8000364a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000364c:	00019497          	auipc	s1,0x19
    80003650:	1d448493          	addi	s1,s1,468 # 8001c820 <log>
    80003654:	8526                	mv	a0,s1
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	cec080e7          	jalr	-788(ra) # 80006342 <acquire>
  log.outstanding -= 1;
    8000365e:	509c                	lw	a5,32(s1)
    80003660:	37fd                	addiw	a5,a5,-1
    80003662:	0007891b          	sext.w	s2,a5
    80003666:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003668:	50dc                	lw	a5,36(s1)
    8000366a:	e7b9                	bnez	a5,800036b8 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000366c:	06091163          	bnez	s2,800036ce <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003670:	00019497          	auipc	s1,0x19
    80003674:	1b048493          	addi	s1,s1,432 # 8001c820 <log>
    80003678:	4785                	li	a5,1
    8000367a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000367c:	8526                	mv	a0,s1
    8000367e:	00003097          	auipc	ra,0x3
    80003682:	d78080e7          	jalr	-648(ra) # 800063f6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003686:	54dc                	lw	a5,44(s1)
    80003688:	06f04763          	bgtz	a5,800036f6 <end_op+0xb6>
    acquire(&log.lock);
    8000368c:	00019497          	auipc	s1,0x19
    80003690:	19448493          	addi	s1,s1,404 # 8001c820 <log>
    80003694:	8526                	mv	a0,s1
    80003696:	00003097          	auipc	ra,0x3
    8000369a:	cac080e7          	jalr	-852(ra) # 80006342 <acquire>
    log.committing = 0;
    8000369e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036a2:	8526                	mv	a0,s1
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	074080e7          	jalr	116(ra) # 80001718 <wakeup>
    release(&log.lock);
    800036ac:	8526                	mv	a0,s1
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	d48080e7          	jalr	-696(ra) # 800063f6 <release>
}
    800036b6:	a815                	j	800036ea <end_op+0xaa>
    800036b8:	ec4e                	sd	s3,24(sp)
    800036ba:	e852                	sd	s4,16(sp)
    800036bc:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036be:	00005517          	auipc	a0,0x5
    800036c2:	df250513          	addi	a0,a0,-526 # 800084b0 <etext+0x4b0>
    800036c6:	00002097          	auipc	ra,0x2
    800036ca:	72c080e7          	jalr	1836(ra) # 80005df2 <panic>
    wakeup(&log);
    800036ce:	00019497          	auipc	s1,0x19
    800036d2:	15248493          	addi	s1,s1,338 # 8001c820 <log>
    800036d6:	8526                	mv	a0,s1
    800036d8:	ffffe097          	auipc	ra,0xffffe
    800036dc:	040080e7          	jalr	64(ra) # 80001718 <wakeup>
  release(&log.lock);
    800036e0:	8526                	mv	a0,s1
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	d14080e7          	jalr	-748(ra) # 800063f6 <release>
}
    800036ea:	70e2                	ld	ra,56(sp)
    800036ec:	7442                	ld	s0,48(sp)
    800036ee:	74a2                	ld	s1,40(sp)
    800036f0:	7902                	ld	s2,32(sp)
    800036f2:	6121                	addi	sp,sp,64
    800036f4:	8082                	ret
    800036f6:	ec4e                	sd	s3,24(sp)
    800036f8:	e852                	sd	s4,16(sp)
    800036fa:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800036fc:	00019a97          	auipc	s5,0x19
    80003700:	154a8a93          	addi	s5,s5,340 # 8001c850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003704:	00019a17          	auipc	s4,0x19
    80003708:	11ca0a13          	addi	s4,s4,284 # 8001c820 <log>
    8000370c:	018a2583          	lw	a1,24(s4)
    80003710:	012585bb          	addw	a1,a1,s2
    80003714:	2585                	addiw	a1,a1,1
    80003716:	028a2503          	lw	a0,40(s4)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	ce0080e7          	jalr	-800(ra) # 800023fa <bread>
    80003722:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	028a2503          	lw	a0,40(s4)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	cce080e7          	jalr	-818(ra) # 800023fa <bread>
    80003734:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003736:	40000613          	li	a2,1024
    8000373a:	05850593          	addi	a1,a0,88
    8000373e:	05848513          	addi	a0,s1,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	a94080e7          	jalr	-1388(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	da0080e7          	jalr	-608(ra) # 800024ec <bwrite>
    brelse(from);
    80003754:	854e                	mv	a0,s3
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	dd4080e7          	jalr	-556(ra) # 8000252a <brelse>
    brelse(to);
    8000375e:	8526                	mv	a0,s1
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	dca080e7          	jalr	-566(ra) # 8000252a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003768:	2905                	addiw	s2,s2,1
    8000376a:	0a91                	addi	s5,s5,4
    8000376c:	02ca2783          	lw	a5,44(s4)
    80003770:	f8f94ee3          	blt	s2,a5,8000370c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c8c080e7          	jalr	-884(ra) # 80003400 <write_head>
    install_trans(0); // Now install writes to home locations
    8000377c:	4501                	li	a0,0
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	cec080e7          	jalr	-788(ra) # 8000346a <install_trans>
    log.lh.n = 0;
    80003786:	00019797          	auipc	a5,0x19
    8000378a:	0c07a323          	sw	zero,198(a5) # 8001c84c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	c72080e7          	jalr	-910(ra) # 80003400 <write_head>
    80003796:	69e2                	ld	s3,24(sp)
    80003798:	6a42                	ld	s4,16(sp)
    8000379a:	6aa2                	ld	s5,8(sp)
    8000379c:	bdc5                	j	8000368c <end_op+0x4c>

000000008000379e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000379e:	1101                	addi	sp,sp,-32
    800037a0:	ec06                	sd	ra,24(sp)
    800037a2:	e822                	sd	s0,16(sp)
    800037a4:	e426                	sd	s1,8(sp)
    800037a6:	e04a                	sd	s2,0(sp)
    800037a8:	1000                	addi	s0,sp,32
    800037aa:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037ac:	00019917          	auipc	s2,0x19
    800037b0:	07490913          	addi	s2,s2,116 # 8001c820 <log>
    800037b4:	854a                	mv	a0,s2
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	b8c080e7          	jalr	-1140(ra) # 80006342 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037be:	02c92603          	lw	a2,44(s2)
    800037c2:	47f5                	li	a5,29
    800037c4:	06c7c563          	blt	a5,a2,8000382e <log_write+0x90>
    800037c8:	00019797          	auipc	a5,0x19
    800037cc:	0747a783          	lw	a5,116(a5) # 8001c83c <log+0x1c>
    800037d0:	37fd                	addiw	a5,a5,-1
    800037d2:	04f65e63          	bge	a2,a5,8000382e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037d6:	00019797          	auipc	a5,0x19
    800037da:	06a7a783          	lw	a5,106(a5) # 8001c840 <log+0x20>
    800037de:	06f05063          	blez	a5,8000383e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037e2:	4781                	li	a5,0
    800037e4:	06c05563          	blez	a2,8000384e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e8:	44cc                	lw	a1,12(s1)
    800037ea:	00019717          	auipc	a4,0x19
    800037ee:	06670713          	addi	a4,a4,102 # 8001c850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037f2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f4:	4314                	lw	a3,0(a4)
    800037f6:	04b68c63          	beq	a3,a1,8000384e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037fa:	2785                	addiw	a5,a5,1
    800037fc:	0711                	addi	a4,a4,4
    800037fe:	fef61be3          	bne	a2,a5,800037f4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003802:	0621                	addi	a2,a2,8
    80003804:	060a                	slli	a2,a2,0x2
    80003806:	00019797          	auipc	a5,0x19
    8000380a:	01a78793          	addi	a5,a5,26 # 8001c820 <log>
    8000380e:	97b2                	add	a5,a5,a2
    80003810:	44d8                	lw	a4,12(s1)
    80003812:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003814:	8526                	mv	a0,s1
    80003816:	fffff097          	auipc	ra,0xfffff
    8000381a:	db0080e7          	jalr	-592(ra) # 800025c6 <bpin>
    log.lh.n++;
    8000381e:	00019717          	auipc	a4,0x19
    80003822:	00270713          	addi	a4,a4,2 # 8001c820 <log>
    80003826:	575c                	lw	a5,44(a4)
    80003828:	2785                	addiw	a5,a5,1
    8000382a:	d75c                	sw	a5,44(a4)
    8000382c:	a82d                	j	80003866 <log_write+0xc8>
    panic("too big a transaction");
    8000382e:	00005517          	auipc	a0,0x5
    80003832:	c9250513          	addi	a0,a0,-878 # 800084c0 <etext+0x4c0>
    80003836:	00002097          	auipc	ra,0x2
    8000383a:	5bc080e7          	jalr	1468(ra) # 80005df2 <panic>
    panic("log_write outside of trans");
    8000383e:	00005517          	auipc	a0,0x5
    80003842:	c9a50513          	addi	a0,a0,-870 # 800084d8 <etext+0x4d8>
    80003846:	00002097          	auipc	ra,0x2
    8000384a:	5ac080e7          	jalr	1452(ra) # 80005df2 <panic>
  log.lh.block[i] = b->blockno;
    8000384e:	00878693          	addi	a3,a5,8
    80003852:	068a                	slli	a3,a3,0x2
    80003854:	00019717          	auipc	a4,0x19
    80003858:	fcc70713          	addi	a4,a4,-52 # 8001c820 <log>
    8000385c:	9736                	add	a4,a4,a3
    8000385e:	44d4                	lw	a3,12(s1)
    80003860:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003862:	faf609e3          	beq	a2,a5,80003814 <log_write+0x76>
  }
  release(&log.lock);
    80003866:	00019517          	auipc	a0,0x19
    8000386a:	fba50513          	addi	a0,a0,-70 # 8001c820 <log>
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	b88080e7          	jalr	-1144(ra) # 800063f6 <release>
}
    80003876:	60e2                	ld	ra,24(sp)
    80003878:	6442                	ld	s0,16(sp)
    8000387a:	64a2                	ld	s1,8(sp)
    8000387c:	6902                	ld	s2,0(sp)
    8000387e:	6105                	addi	sp,sp,32
    80003880:	8082                	ret

0000000080003882 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003882:	1101                	addi	sp,sp,-32
    80003884:	ec06                	sd	ra,24(sp)
    80003886:	e822                	sd	s0,16(sp)
    80003888:	e426                	sd	s1,8(sp)
    8000388a:	e04a                	sd	s2,0(sp)
    8000388c:	1000                	addi	s0,sp,32
    8000388e:	84aa                	mv	s1,a0
    80003890:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003892:	00005597          	auipc	a1,0x5
    80003896:	c6658593          	addi	a1,a1,-922 # 800084f8 <etext+0x4f8>
    8000389a:	0521                	addi	a0,a0,8
    8000389c:	00003097          	auipc	ra,0x3
    800038a0:	a16080e7          	jalr	-1514(ra) # 800062b2 <initlock>
  lk->name = name;
    800038a4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038a8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038ac:	0204a423          	sw	zero,40(s1)
}
    800038b0:	60e2                	ld	ra,24(sp)
    800038b2:	6442                	ld	s0,16(sp)
    800038b4:	64a2                	ld	s1,8(sp)
    800038b6:	6902                	ld	s2,0(sp)
    800038b8:	6105                	addi	sp,sp,32
    800038ba:	8082                	ret

00000000800038bc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038bc:	1101                	addi	sp,sp,-32
    800038be:	ec06                	sd	ra,24(sp)
    800038c0:	e822                	sd	s0,16(sp)
    800038c2:	e426                	sd	s1,8(sp)
    800038c4:	e04a                	sd	s2,0(sp)
    800038c6:	1000                	addi	s0,sp,32
    800038c8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ca:	00850913          	addi	s2,a0,8
    800038ce:	854a                	mv	a0,s2
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	a72080e7          	jalr	-1422(ra) # 80006342 <acquire>
  while (lk->locked) {
    800038d8:	409c                	lw	a5,0(s1)
    800038da:	cb89                	beqz	a5,800038ec <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038dc:	85ca                	mv	a1,s2
    800038de:	8526                	mv	a0,s1
    800038e0:	ffffe097          	auipc	ra,0xffffe
    800038e4:	cac080e7          	jalr	-852(ra) # 8000158c <sleep>
  while (lk->locked) {
    800038e8:	409c                	lw	a5,0(s1)
    800038ea:	fbed                	bnez	a5,800038dc <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038ec:	4785                	li	a5,1
    800038ee:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038f0:	ffffd097          	auipc	ra,0xffffd
    800038f4:	58c080e7          	jalr	1420(ra) # 80000e7c <myproc>
    800038f8:	591c                	lw	a5,48(a0)
    800038fa:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038fc:	854a                	mv	a0,s2
    800038fe:	00003097          	auipc	ra,0x3
    80003902:	af8080e7          	jalr	-1288(ra) # 800063f6 <release>
}
    80003906:	60e2                	ld	ra,24(sp)
    80003908:	6442                	ld	s0,16(sp)
    8000390a:	64a2                	ld	s1,8(sp)
    8000390c:	6902                	ld	s2,0(sp)
    8000390e:	6105                	addi	sp,sp,32
    80003910:	8082                	ret

0000000080003912 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003912:	1101                	addi	sp,sp,-32
    80003914:	ec06                	sd	ra,24(sp)
    80003916:	e822                	sd	s0,16(sp)
    80003918:	e426                	sd	s1,8(sp)
    8000391a:	e04a                	sd	s2,0(sp)
    8000391c:	1000                	addi	s0,sp,32
    8000391e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003920:	00850913          	addi	s2,a0,8
    80003924:	854a                	mv	a0,s2
    80003926:	00003097          	auipc	ra,0x3
    8000392a:	a1c080e7          	jalr	-1508(ra) # 80006342 <acquire>
  lk->locked = 0;
    8000392e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003932:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003936:	8526                	mv	a0,s1
    80003938:	ffffe097          	auipc	ra,0xffffe
    8000393c:	de0080e7          	jalr	-544(ra) # 80001718 <wakeup>
  release(&lk->lk);
    80003940:	854a                	mv	a0,s2
    80003942:	00003097          	auipc	ra,0x3
    80003946:	ab4080e7          	jalr	-1356(ra) # 800063f6 <release>
}
    8000394a:	60e2                	ld	ra,24(sp)
    8000394c:	6442                	ld	s0,16(sp)
    8000394e:	64a2                	ld	s1,8(sp)
    80003950:	6902                	ld	s2,0(sp)
    80003952:	6105                	addi	sp,sp,32
    80003954:	8082                	ret

0000000080003956 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003956:	7179                	addi	sp,sp,-48
    80003958:	f406                	sd	ra,40(sp)
    8000395a:	f022                	sd	s0,32(sp)
    8000395c:	ec26                	sd	s1,24(sp)
    8000395e:	e84a                	sd	s2,16(sp)
    80003960:	1800                	addi	s0,sp,48
    80003962:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003964:	00850913          	addi	s2,a0,8
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	9d8080e7          	jalr	-1576(ra) # 80006342 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003972:	409c                	lw	a5,0(s1)
    80003974:	ef91                	bnez	a5,80003990 <holdingsleep+0x3a>
    80003976:	4481                	li	s1,0
  release(&lk->lk);
    80003978:	854a                	mv	a0,s2
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	a7c080e7          	jalr	-1412(ra) # 800063f6 <release>
  return r;
}
    80003982:	8526                	mv	a0,s1
    80003984:	70a2                	ld	ra,40(sp)
    80003986:	7402                	ld	s0,32(sp)
    80003988:	64e2                	ld	s1,24(sp)
    8000398a:	6942                	ld	s2,16(sp)
    8000398c:	6145                	addi	sp,sp,48
    8000398e:	8082                	ret
    80003990:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003992:	0284a983          	lw	s3,40(s1)
    80003996:	ffffd097          	auipc	ra,0xffffd
    8000399a:	4e6080e7          	jalr	1254(ra) # 80000e7c <myproc>
    8000399e:	5904                	lw	s1,48(a0)
    800039a0:	413484b3          	sub	s1,s1,s3
    800039a4:	0014b493          	seqz	s1,s1
    800039a8:	69a2                	ld	s3,8(sp)
    800039aa:	b7f9                	j	80003978 <holdingsleep+0x22>

00000000800039ac <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039ac:	1141                	addi	sp,sp,-16
    800039ae:	e406                	sd	ra,8(sp)
    800039b0:	e022                	sd	s0,0(sp)
    800039b2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039b4:	00005597          	auipc	a1,0x5
    800039b8:	b5458593          	addi	a1,a1,-1196 # 80008508 <etext+0x508>
    800039bc:	00019517          	auipc	a0,0x19
    800039c0:	fac50513          	addi	a0,a0,-84 # 8001c968 <ftable>
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	8ee080e7          	jalr	-1810(ra) # 800062b2 <initlock>
}
    800039cc:	60a2                	ld	ra,8(sp)
    800039ce:	6402                	ld	s0,0(sp)
    800039d0:	0141                	addi	sp,sp,16
    800039d2:	8082                	ret

00000000800039d4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039d4:	1101                	addi	sp,sp,-32
    800039d6:	ec06                	sd	ra,24(sp)
    800039d8:	e822                	sd	s0,16(sp)
    800039da:	e426                	sd	s1,8(sp)
    800039dc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039de:	00019517          	auipc	a0,0x19
    800039e2:	f8a50513          	addi	a0,a0,-118 # 8001c968 <ftable>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	95c080e7          	jalr	-1700(ra) # 80006342 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039ee:	00019497          	auipc	s1,0x19
    800039f2:	f9248493          	addi	s1,s1,-110 # 8001c980 <ftable+0x18>
    800039f6:	0001a717          	auipc	a4,0x1a
    800039fa:	f2a70713          	addi	a4,a4,-214 # 8001d920 <ftable+0xfb8>
    if(f->ref == 0){
    800039fe:	40dc                	lw	a5,4(s1)
    80003a00:	cf99                	beqz	a5,80003a1e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a02:	02848493          	addi	s1,s1,40
    80003a06:	fee49ce3          	bne	s1,a4,800039fe <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a0a:	00019517          	auipc	a0,0x19
    80003a0e:	f5e50513          	addi	a0,a0,-162 # 8001c968 <ftable>
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	9e4080e7          	jalr	-1564(ra) # 800063f6 <release>
  return 0;
    80003a1a:	4481                	li	s1,0
    80003a1c:	a819                	j	80003a32 <filealloc+0x5e>
      f->ref = 1;
    80003a1e:	4785                	li	a5,1
    80003a20:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a22:	00019517          	auipc	a0,0x19
    80003a26:	f4650513          	addi	a0,a0,-186 # 8001c968 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	9cc080e7          	jalr	-1588(ra) # 800063f6 <release>
}
    80003a32:	8526                	mv	a0,s1
    80003a34:	60e2                	ld	ra,24(sp)
    80003a36:	6442                	ld	s0,16(sp)
    80003a38:	64a2                	ld	s1,8(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret

0000000080003a3e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	e426                	sd	s1,8(sp)
    80003a46:	1000                	addi	s0,sp,32
    80003a48:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a4a:	00019517          	auipc	a0,0x19
    80003a4e:	f1e50513          	addi	a0,a0,-226 # 8001c968 <ftable>
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	8f0080e7          	jalr	-1808(ra) # 80006342 <acquire>
  if(f->ref < 1)
    80003a5a:	40dc                	lw	a5,4(s1)
    80003a5c:	02f05263          	blez	a5,80003a80 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a60:	2785                	addiw	a5,a5,1
    80003a62:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a64:	00019517          	auipc	a0,0x19
    80003a68:	f0450513          	addi	a0,a0,-252 # 8001c968 <ftable>
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	98a080e7          	jalr	-1654(ra) # 800063f6 <release>
  return f;
}
    80003a74:	8526                	mv	a0,s1
    80003a76:	60e2                	ld	ra,24(sp)
    80003a78:	6442                	ld	s0,16(sp)
    80003a7a:	64a2                	ld	s1,8(sp)
    80003a7c:	6105                	addi	sp,sp,32
    80003a7e:	8082                	ret
    panic("filedup");
    80003a80:	00005517          	auipc	a0,0x5
    80003a84:	a9050513          	addi	a0,a0,-1392 # 80008510 <etext+0x510>
    80003a88:	00002097          	auipc	ra,0x2
    80003a8c:	36a080e7          	jalr	874(ra) # 80005df2 <panic>

0000000080003a90 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a90:	7139                	addi	sp,sp,-64
    80003a92:	fc06                	sd	ra,56(sp)
    80003a94:	f822                	sd	s0,48(sp)
    80003a96:	f426                	sd	s1,40(sp)
    80003a98:	0080                	addi	s0,sp,64
    80003a9a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a9c:	00019517          	auipc	a0,0x19
    80003aa0:	ecc50513          	addi	a0,a0,-308 # 8001c968 <ftable>
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	89e080e7          	jalr	-1890(ra) # 80006342 <acquire>
  if(f->ref < 1)
    80003aac:	40dc                	lw	a5,4(s1)
    80003aae:	04f05c63          	blez	a5,80003b06 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003ab2:	37fd                	addiw	a5,a5,-1
    80003ab4:	0007871b          	sext.w	a4,a5
    80003ab8:	c0dc                	sw	a5,4(s1)
    80003aba:	06e04263          	bgtz	a4,80003b1e <fileclose+0x8e>
    80003abe:	f04a                	sd	s2,32(sp)
    80003ac0:	ec4e                	sd	s3,24(sp)
    80003ac2:	e852                	sd	s4,16(sp)
    80003ac4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ac6:	0004a903          	lw	s2,0(s1)
    80003aca:	0094ca83          	lbu	s5,9(s1)
    80003ace:	0104ba03          	ld	s4,16(s1)
    80003ad2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ad6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ada:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ade:	00019517          	auipc	a0,0x19
    80003ae2:	e8a50513          	addi	a0,a0,-374 # 8001c968 <ftable>
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	910080e7          	jalr	-1776(ra) # 800063f6 <release>

  if(ff.type == FD_PIPE){
    80003aee:	4785                	li	a5,1
    80003af0:	04f90463          	beq	s2,a5,80003b38 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003af4:	3979                	addiw	s2,s2,-2
    80003af6:	4785                	li	a5,1
    80003af8:	0527fb63          	bgeu	a5,s2,80003b4e <fileclose+0xbe>
    80003afc:	7902                	ld	s2,32(sp)
    80003afe:	69e2                	ld	s3,24(sp)
    80003b00:	6a42                	ld	s4,16(sp)
    80003b02:	6aa2                	ld	s5,8(sp)
    80003b04:	a02d                	j	80003b2e <fileclose+0x9e>
    80003b06:	f04a                	sd	s2,32(sp)
    80003b08:	ec4e                	sd	s3,24(sp)
    80003b0a:	e852                	sd	s4,16(sp)
    80003b0c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b0e:	00005517          	auipc	a0,0x5
    80003b12:	a0a50513          	addi	a0,a0,-1526 # 80008518 <etext+0x518>
    80003b16:	00002097          	auipc	ra,0x2
    80003b1a:	2dc080e7          	jalr	732(ra) # 80005df2 <panic>
    release(&ftable.lock);
    80003b1e:	00019517          	auipc	a0,0x19
    80003b22:	e4a50513          	addi	a0,a0,-438 # 8001c968 <ftable>
    80003b26:	00003097          	auipc	ra,0x3
    80003b2a:	8d0080e7          	jalr	-1840(ra) # 800063f6 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b2e:	70e2                	ld	ra,56(sp)
    80003b30:	7442                	ld	s0,48(sp)
    80003b32:	74a2                	ld	s1,40(sp)
    80003b34:	6121                	addi	sp,sp,64
    80003b36:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b38:	85d6                	mv	a1,s5
    80003b3a:	8552                	mv	a0,s4
    80003b3c:	00000097          	auipc	ra,0x0
    80003b40:	3a2080e7          	jalr	930(ra) # 80003ede <pipeclose>
    80003b44:	7902                	ld	s2,32(sp)
    80003b46:	69e2                	ld	s3,24(sp)
    80003b48:	6a42                	ld	s4,16(sp)
    80003b4a:	6aa2                	ld	s5,8(sp)
    80003b4c:	b7cd                	j	80003b2e <fileclose+0x9e>
    begin_op();
    80003b4e:	00000097          	auipc	ra,0x0
    80003b52:	a78080e7          	jalr	-1416(ra) # 800035c6 <begin_op>
    iput(ff.ip);
    80003b56:	854e                	mv	a0,s3
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	25a080e7          	jalr	602(ra) # 80002db2 <iput>
    end_op();
    80003b60:	00000097          	auipc	ra,0x0
    80003b64:	ae0080e7          	jalr	-1312(ra) # 80003640 <end_op>
    80003b68:	7902                	ld	s2,32(sp)
    80003b6a:	69e2                	ld	s3,24(sp)
    80003b6c:	6a42                	ld	s4,16(sp)
    80003b6e:	6aa2                	ld	s5,8(sp)
    80003b70:	bf7d                	j	80003b2e <fileclose+0x9e>

0000000080003b72 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b72:	715d                	addi	sp,sp,-80
    80003b74:	e486                	sd	ra,72(sp)
    80003b76:	e0a2                	sd	s0,64(sp)
    80003b78:	fc26                	sd	s1,56(sp)
    80003b7a:	f44e                	sd	s3,40(sp)
    80003b7c:	0880                	addi	s0,sp,80
    80003b7e:	84aa                	mv	s1,a0
    80003b80:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b82:	ffffd097          	auipc	ra,0xffffd
    80003b86:	2fa080e7          	jalr	762(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b8a:	409c                	lw	a5,0(s1)
    80003b8c:	37f9                	addiw	a5,a5,-2
    80003b8e:	4705                	li	a4,1
    80003b90:	04f76863          	bltu	a4,a5,80003be0 <filestat+0x6e>
    80003b94:	f84a                	sd	s2,48(sp)
    80003b96:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b98:	6c88                	ld	a0,24(s1)
    80003b9a:	fffff097          	auipc	ra,0xfffff
    80003b9e:	05a080e7          	jalr	90(ra) # 80002bf4 <ilock>
    stati(f->ip, &st);
    80003ba2:	fb840593          	addi	a1,s0,-72
    80003ba6:	6c88                	ld	a0,24(s1)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	2da080e7          	jalr	730(ra) # 80002e82 <stati>
    iunlock(f->ip);
    80003bb0:	6c88                	ld	a0,24(s1)
    80003bb2:	fffff097          	auipc	ra,0xfffff
    80003bb6:	108080e7          	jalr	264(ra) # 80002cba <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bba:	46e1                	li	a3,24
    80003bbc:	fb840613          	addi	a2,s0,-72
    80003bc0:	85ce                	mv	a1,s3
    80003bc2:	05093503          	ld	a0,80(s2)
    80003bc6:	ffffd097          	auipc	ra,0xffffd
    80003bca:	f52080e7          	jalr	-174(ra) # 80000b18 <copyout>
    80003bce:	41f5551b          	sraiw	a0,a0,0x1f
    80003bd2:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003bd4:	60a6                	ld	ra,72(sp)
    80003bd6:	6406                	ld	s0,64(sp)
    80003bd8:	74e2                	ld	s1,56(sp)
    80003bda:	79a2                	ld	s3,40(sp)
    80003bdc:	6161                	addi	sp,sp,80
    80003bde:	8082                	ret
  return -1;
    80003be0:	557d                	li	a0,-1
    80003be2:	bfcd                	j	80003bd4 <filestat+0x62>

0000000080003be4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003be4:	7179                	addi	sp,sp,-48
    80003be6:	f406                	sd	ra,40(sp)
    80003be8:	f022                	sd	s0,32(sp)
    80003bea:	e84a                	sd	s2,16(sp)
    80003bec:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bee:	00854783          	lbu	a5,8(a0)
    80003bf2:	cbc5                	beqz	a5,80003ca2 <fileread+0xbe>
    80003bf4:	ec26                	sd	s1,24(sp)
    80003bf6:	e44e                	sd	s3,8(sp)
    80003bf8:	84aa                	mv	s1,a0
    80003bfa:	89ae                	mv	s3,a1
    80003bfc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bfe:	411c                	lw	a5,0(a0)
    80003c00:	4705                	li	a4,1
    80003c02:	04e78963          	beq	a5,a4,80003c54 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c06:	470d                	li	a4,3
    80003c08:	04e78f63          	beq	a5,a4,80003c66 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c0c:	4709                	li	a4,2
    80003c0e:	08e79263          	bne	a5,a4,80003c92 <fileread+0xae>
    ilock(f->ip);
    80003c12:	6d08                	ld	a0,24(a0)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	fe0080e7          	jalr	-32(ra) # 80002bf4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c1c:	874a                	mv	a4,s2
    80003c1e:	5094                	lw	a3,32(s1)
    80003c20:	864e                	mv	a2,s3
    80003c22:	4585                	li	a1,1
    80003c24:	6c88                	ld	a0,24(s1)
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	286080e7          	jalr	646(ra) # 80002eac <readi>
    80003c2e:	892a                	mv	s2,a0
    80003c30:	00a05563          	blez	a0,80003c3a <fileread+0x56>
      f->off += r;
    80003c34:	509c                	lw	a5,32(s1)
    80003c36:	9fa9                	addw	a5,a5,a0
    80003c38:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c3a:	6c88                	ld	a0,24(s1)
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	07e080e7          	jalr	126(ra) # 80002cba <iunlock>
    80003c44:	64e2                	ld	s1,24(sp)
    80003c46:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c48:	854a                	mv	a0,s2
    80003c4a:	70a2                	ld	ra,40(sp)
    80003c4c:	7402                	ld	s0,32(sp)
    80003c4e:	6942                	ld	s2,16(sp)
    80003c50:	6145                	addi	sp,sp,48
    80003c52:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c54:	6908                	ld	a0,16(a0)
    80003c56:	00000097          	auipc	ra,0x0
    80003c5a:	3fa080e7          	jalr	1018(ra) # 80004050 <piperead>
    80003c5e:	892a                	mv	s2,a0
    80003c60:	64e2                	ld	s1,24(sp)
    80003c62:	69a2                	ld	s3,8(sp)
    80003c64:	b7d5                	j	80003c48 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c66:	02451783          	lh	a5,36(a0)
    80003c6a:	03079693          	slli	a3,a5,0x30
    80003c6e:	92c1                	srli	a3,a3,0x30
    80003c70:	4725                	li	a4,9
    80003c72:	02d76a63          	bltu	a4,a3,80003ca6 <fileread+0xc2>
    80003c76:	0792                	slli	a5,a5,0x4
    80003c78:	00019717          	auipc	a4,0x19
    80003c7c:	c5070713          	addi	a4,a4,-944 # 8001c8c8 <devsw>
    80003c80:	97ba                	add	a5,a5,a4
    80003c82:	639c                	ld	a5,0(a5)
    80003c84:	c78d                	beqz	a5,80003cae <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003c86:	4505                	li	a0,1
    80003c88:	9782                	jalr	a5
    80003c8a:	892a                	mv	s2,a0
    80003c8c:	64e2                	ld	s1,24(sp)
    80003c8e:	69a2                	ld	s3,8(sp)
    80003c90:	bf65                	j	80003c48 <fileread+0x64>
    panic("fileread");
    80003c92:	00005517          	auipc	a0,0x5
    80003c96:	89650513          	addi	a0,a0,-1898 # 80008528 <etext+0x528>
    80003c9a:	00002097          	auipc	ra,0x2
    80003c9e:	158080e7          	jalr	344(ra) # 80005df2 <panic>
    return -1;
    80003ca2:	597d                	li	s2,-1
    80003ca4:	b755                	j	80003c48 <fileread+0x64>
      return -1;
    80003ca6:	597d                	li	s2,-1
    80003ca8:	64e2                	ld	s1,24(sp)
    80003caa:	69a2                	ld	s3,8(sp)
    80003cac:	bf71                	j	80003c48 <fileread+0x64>
    80003cae:	597d                	li	s2,-1
    80003cb0:	64e2                	ld	s1,24(sp)
    80003cb2:	69a2                	ld	s3,8(sp)
    80003cb4:	bf51                	j	80003c48 <fileread+0x64>

0000000080003cb6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cb6:	00954783          	lbu	a5,9(a0)
    80003cba:	12078963          	beqz	a5,80003dec <filewrite+0x136>
{
    80003cbe:	715d                	addi	sp,sp,-80
    80003cc0:	e486                	sd	ra,72(sp)
    80003cc2:	e0a2                	sd	s0,64(sp)
    80003cc4:	f84a                	sd	s2,48(sp)
    80003cc6:	f052                	sd	s4,32(sp)
    80003cc8:	e85a                	sd	s6,16(sp)
    80003cca:	0880                	addi	s0,sp,80
    80003ccc:	892a                	mv	s2,a0
    80003cce:	8b2e                	mv	s6,a1
    80003cd0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cd2:	411c                	lw	a5,0(a0)
    80003cd4:	4705                	li	a4,1
    80003cd6:	02e78763          	beq	a5,a4,80003d04 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cda:	470d                	li	a4,3
    80003cdc:	02e78a63          	beq	a5,a4,80003d10 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ce0:	4709                	li	a4,2
    80003ce2:	0ee79863          	bne	a5,a4,80003dd2 <filewrite+0x11c>
    80003ce6:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ce8:	0cc05463          	blez	a2,80003db0 <filewrite+0xfa>
    80003cec:	fc26                	sd	s1,56(sp)
    80003cee:	ec56                	sd	s5,24(sp)
    80003cf0:	e45e                	sd	s7,8(sp)
    80003cf2:	e062                	sd	s8,0(sp)
    int i = 0;
    80003cf4:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003cf6:	6b85                	lui	s7,0x1
    80003cf8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cfc:	6c05                	lui	s8,0x1
    80003cfe:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d02:	a851                	j	80003d96 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d04:	6908                	ld	a0,16(a0)
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	248080e7          	jalr	584(ra) # 80003f4e <pipewrite>
    80003d0e:	a85d                	j	80003dc4 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d10:	02451783          	lh	a5,36(a0)
    80003d14:	03079693          	slli	a3,a5,0x30
    80003d18:	92c1                	srli	a3,a3,0x30
    80003d1a:	4725                	li	a4,9
    80003d1c:	0cd76a63          	bltu	a4,a3,80003df0 <filewrite+0x13a>
    80003d20:	0792                	slli	a5,a5,0x4
    80003d22:	00019717          	auipc	a4,0x19
    80003d26:	ba670713          	addi	a4,a4,-1114 # 8001c8c8 <devsw>
    80003d2a:	97ba                	add	a5,a5,a4
    80003d2c:	679c                	ld	a5,8(a5)
    80003d2e:	c3f9                	beqz	a5,80003df4 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d30:	4505                	li	a0,1
    80003d32:	9782                	jalr	a5
    80003d34:	a841                	j	80003dc4 <filewrite+0x10e>
      if(n1 > max)
    80003d36:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	88c080e7          	jalr	-1908(ra) # 800035c6 <begin_op>
      ilock(f->ip);
    80003d42:	01893503          	ld	a0,24(s2)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	eae080e7          	jalr	-338(ra) # 80002bf4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d4e:	8756                	mv	a4,s5
    80003d50:	02092683          	lw	a3,32(s2)
    80003d54:	01698633          	add	a2,s3,s6
    80003d58:	4585                	li	a1,1
    80003d5a:	01893503          	ld	a0,24(s2)
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	252080e7          	jalr	594(ra) # 80002fb0 <writei>
    80003d66:	84aa                	mv	s1,a0
    80003d68:	00a05763          	blez	a0,80003d76 <filewrite+0xc0>
        f->off += r;
    80003d6c:	02092783          	lw	a5,32(s2)
    80003d70:	9fa9                	addw	a5,a5,a0
    80003d72:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d76:	01893503          	ld	a0,24(s2)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	f40080e7          	jalr	-192(ra) # 80002cba <iunlock>
      end_op();
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	8be080e7          	jalr	-1858(ra) # 80003640 <end_op>

      if(r != n1){
    80003d8a:	029a9563          	bne	s5,s1,80003db4 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003d8e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d92:	0149da63          	bge	s3,s4,80003da6 <filewrite+0xf0>
      int n1 = n - i;
    80003d96:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d9a:	0004879b          	sext.w	a5,s1
    80003d9e:	f8fbdce3          	bge	s7,a5,80003d36 <filewrite+0x80>
    80003da2:	84e2                	mv	s1,s8
    80003da4:	bf49                	j	80003d36 <filewrite+0x80>
    80003da6:	74e2                	ld	s1,56(sp)
    80003da8:	6ae2                	ld	s5,24(sp)
    80003daa:	6ba2                	ld	s7,8(sp)
    80003dac:	6c02                	ld	s8,0(sp)
    80003dae:	a039                	j	80003dbc <filewrite+0x106>
    int i = 0;
    80003db0:	4981                	li	s3,0
    80003db2:	a029                	j	80003dbc <filewrite+0x106>
    80003db4:	74e2                	ld	s1,56(sp)
    80003db6:	6ae2                	ld	s5,24(sp)
    80003db8:	6ba2                	ld	s7,8(sp)
    80003dba:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dbc:	033a1e63          	bne	s4,s3,80003df8 <filewrite+0x142>
    80003dc0:	8552                	mv	a0,s4
    80003dc2:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dc4:	60a6                	ld	ra,72(sp)
    80003dc6:	6406                	ld	s0,64(sp)
    80003dc8:	7942                	ld	s2,48(sp)
    80003dca:	7a02                	ld	s4,32(sp)
    80003dcc:	6b42                	ld	s6,16(sp)
    80003dce:	6161                	addi	sp,sp,80
    80003dd0:	8082                	ret
    80003dd2:	fc26                	sd	s1,56(sp)
    80003dd4:	f44e                	sd	s3,40(sp)
    80003dd6:	ec56                	sd	s5,24(sp)
    80003dd8:	e45e                	sd	s7,8(sp)
    80003dda:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003ddc:	00004517          	auipc	a0,0x4
    80003de0:	75c50513          	addi	a0,a0,1884 # 80008538 <etext+0x538>
    80003de4:	00002097          	auipc	ra,0x2
    80003de8:	00e080e7          	jalr	14(ra) # 80005df2 <panic>
    return -1;
    80003dec:	557d                	li	a0,-1
}
    80003dee:	8082                	ret
      return -1;
    80003df0:	557d                	li	a0,-1
    80003df2:	bfc9                	j	80003dc4 <filewrite+0x10e>
    80003df4:	557d                	li	a0,-1
    80003df6:	b7f9                	j	80003dc4 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003df8:	557d                	li	a0,-1
    80003dfa:	79a2                	ld	s3,40(sp)
    80003dfc:	b7e1                	j	80003dc4 <filewrite+0x10e>

0000000080003dfe <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dfe:	7179                	addi	sp,sp,-48
    80003e00:	f406                	sd	ra,40(sp)
    80003e02:	f022                	sd	s0,32(sp)
    80003e04:	ec26                	sd	s1,24(sp)
    80003e06:	e052                	sd	s4,0(sp)
    80003e08:	1800                	addi	s0,sp,48
    80003e0a:	84aa                	mv	s1,a0
    80003e0c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e0e:	0005b023          	sd	zero,0(a1)
    80003e12:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	bbe080e7          	jalr	-1090(ra) # 800039d4 <filealloc>
    80003e1e:	e088                	sd	a0,0(s1)
    80003e20:	cd49                	beqz	a0,80003eba <pipealloc+0xbc>
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	bb2080e7          	jalr	-1102(ra) # 800039d4 <filealloc>
    80003e2a:	00aa3023          	sd	a0,0(s4)
    80003e2e:	c141                	beqz	a0,80003eae <pipealloc+0xb0>
    80003e30:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e32:	ffffc097          	auipc	ra,0xffffc
    80003e36:	2e8080e7          	jalr	744(ra) # 8000011a <kalloc>
    80003e3a:	892a                	mv	s2,a0
    80003e3c:	c13d                	beqz	a0,80003ea2 <pipealloc+0xa4>
    80003e3e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e40:	4985                	li	s3,1
    80003e42:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e46:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e4a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e4e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e52:	00004597          	auipc	a1,0x4
    80003e56:	6f658593          	addi	a1,a1,1782 # 80008548 <etext+0x548>
    80003e5a:	00002097          	auipc	ra,0x2
    80003e5e:	458080e7          	jalr	1112(ra) # 800062b2 <initlock>
  (*f0)->type = FD_PIPE;
    80003e62:	609c                	ld	a5,0(s1)
    80003e64:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e68:	609c                	ld	a5,0(s1)
    80003e6a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e6e:	609c                	ld	a5,0(s1)
    80003e70:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e74:	609c                	ld	a5,0(s1)
    80003e76:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e7a:	000a3783          	ld	a5,0(s4)
    80003e7e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e82:	000a3783          	ld	a5,0(s4)
    80003e86:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e8a:	000a3783          	ld	a5,0(s4)
    80003e8e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e92:	000a3783          	ld	a5,0(s4)
    80003e96:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e9a:	4501                	li	a0,0
    80003e9c:	6942                	ld	s2,16(sp)
    80003e9e:	69a2                	ld	s3,8(sp)
    80003ea0:	a03d                	j	80003ece <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ea2:	6088                	ld	a0,0(s1)
    80003ea4:	c119                	beqz	a0,80003eaa <pipealloc+0xac>
    80003ea6:	6942                	ld	s2,16(sp)
    80003ea8:	a029                	j	80003eb2 <pipealloc+0xb4>
    80003eaa:	6942                	ld	s2,16(sp)
    80003eac:	a039                	j	80003eba <pipealloc+0xbc>
    80003eae:	6088                	ld	a0,0(s1)
    80003eb0:	c50d                	beqz	a0,80003eda <pipealloc+0xdc>
    fileclose(*f0);
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	bde080e7          	jalr	-1058(ra) # 80003a90 <fileclose>
  if(*f1)
    80003eba:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ebe:	557d                	li	a0,-1
  if(*f1)
    80003ec0:	c799                	beqz	a5,80003ece <pipealloc+0xd0>
    fileclose(*f1);
    80003ec2:	853e                	mv	a0,a5
    80003ec4:	00000097          	auipc	ra,0x0
    80003ec8:	bcc080e7          	jalr	-1076(ra) # 80003a90 <fileclose>
  return -1;
    80003ecc:	557d                	li	a0,-1
}
    80003ece:	70a2                	ld	ra,40(sp)
    80003ed0:	7402                	ld	s0,32(sp)
    80003ed2:	64e2                	ld	s1,24(sp)
    80003ed4:	6a02                	ld	s4,0(sp)
    80003ed6:	6145                	addi	sp,sp,48
    80003ed8:	8082                	ret
  return -1;
    80003eda:	557d                	li	a0,-1
    80003edc:	bfcd                	j	80003ece <pipealloc+0xd0>

0000000080003ede <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ede:	1101                	addi	sp,sp,-32
    80003ee0:	ec06                	sd	ra,24(sp)
    80003ee2:	e822                	sd	s0,16(sp)
    80003ee4:	e426                	sd	s1,8(sp)
    80003ee6:	e04a                	sd	s2,0(sp)
    80003ee8:	1000                	addi	s0,sp,32
    80003eea:	84aa                	mv	s1,a0
    80003eec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eee:	00002097          	auipc	ra,0x2
    80003ef2:	454080e7          	jalr	1108(ra) # 80006342 <acquire>
  if(writable){
    80003ef6:	02090d63          	beqz	s2,80003f30 <pipeclose+0x52>
    pi->writeopen = 0;
    80003efa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003efe:	21848513          	addi	a0,s1,536
    80003f02:	ffffe097          	auipc	ra,0xffffe
    80003f06:	816080e7          	jalr	-2026(ra) # 80001718 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f0a:	2204b783          	ld	a5,544(s1)
    80003f0e:	eb95                	bnez	a5,80003f42 <pipeclose+0x64>
    release(&pi->lock);
    80003f10:	8526                	mv	a0,s1
    80003f12:	00002097          	auipc	ra,0x2
    80003f16:	4e4080e7          	jalr	1252(ra) # 800063f6 <release>
    kfree((char*)pi);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	ffffc097          	auipc	ra,0xffffc
    80003f20:	100080e7          	jalr	256(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f24:	60e2                	ld	ra,24(sp)
    80003f26:	6442                	ld	s0,16(sp)
    80003f28:	64a2                	ld	s1,8(sp)
    80003f2a:	6902                	ld	s2,0(sp)
    80003f2c:	6105                	addi	sp,sp,32
    80003f2e:	8082                	ret
    pi->readopen = 0;
    80003f30:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f34:	21c48513          	addi	a0,s1,540
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	7e0080e7          	jalr	2016(ra) # 80001718 <wakeup>
    80003f40:	b7e9                	j	80003f0a <pipeclose+0x2c>
    release(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	4b2080e7          	jalr	1202(ra) # 800063f6 <release>
}
    80003f4c:	bfe1                	j	80003f24 <pipeclose+0x46>

0000000080003f4e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f4e:	711d                	addi	sp,sp,-96
    80003f50:	ec86                	sd	ra,88(sp)
    80003f52:	e8a2                	sd	s0,80(sp)
    80003f54:	e4a6                	sd	s1,72(sp)
    80003f56:	e0ca                	sd	s2,64(sp)
    80003f58:	fc4e                	sd	s3,56(sp)
    80003f5a:	f852                	sd	s4,48(sp)
    80003f5c:	f456                	sd	s5,40(sp)
    80003f5e:	1080                	addi	s0,sp,96
    80003f60:	84aa                	mv	s1,a0
    80003f62:	8aae                	mv	s5,a1
    80003f64:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f66:	ffffd097          	auipc	ra,0xffffd
    80003f6a:	f16080e7          	jalr	-234(ra) # 80000e7c <myproc>
    80003f6e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f70:	8526                	mv	a0,s1
    80003f72:	00002097          	auipc	ra,0x2
    80003f76:	3d0080e7          	jalr	976(ra) # 80006342 <acquire>
  while(i < n){
    80003f7a:	0d405563          	blez	s4,80004044 <pipewrite+0xf6>
    80003f7e:	f05a                	sd	s6,32(sp)
    80003f80:	ec5e                	sd	s7,24(sp)
    80003f82:	e862                	sd	s8,16(sp)
  int i = 0;
    80003f84:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f86:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f88:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f8c:	21c48b93          	addi	s7,s1,540
    80003f90:	a089                	j	80003fd2 <pipewrite+0x84>
      release(&pi->lock);
    80003f92:	8526                	mv	a0,s1
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	462080e7          	jalr	1122(ra) # 800063f6 <release>
      return -1;
    80003f9c:	597d                	li	s2,-1
    80003f9e:	7b02                	ld	s6,32(sp)
    80003fa0:	6be2                	ld	s7,24(sp)
    80003fa2:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fa4:	854a                	mv	a0,s2
    80003fa6:	60e6                	ld	ra,88(sp)
    80003fa8:	6446                	ld	s0,80(sp)
    80003faa:	64a6                	ld	s1,72(sp)
    80003fac:	6906                	ld	s2,64(sp)
    80003fae:	79e2                	ld	s3,56(sp)
    80003fb0:	7a42                	ld	s4,48(sp)
    80003fb2:	7aa2                	ld	s5,40(sp)
    80003fb4:	6125                	addi	sp,sp,96
    80003fb6:	8082                	ret
      wakeup(&pi->nread);
    80003fb8:	8562                	mv	a0,s8
    80003fba:	ffffd097          	auipc	ra,0xffffd
    80003fbe:	75e080e7          	jalr	1886(ra) # 80001718 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fc2:	85a6                	mv	a1,s1
    80003fc4:	855e                	mv	a0,s7
    80003fc6:	ffffd097          	auipc	ra,0xffffd
    80003fca:	5c6080e7          	jalr	1478(ra) # 8000158c <sleep>
  while(i < n){
    80003fce:	05495c63          	bge	s2,s4,80004026 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003fd2:	2204a783          	lw	a5,544(s1)
    80003fd6:	dfd5                	beqz	a5,80003f92 <pipewrite+0x44>
    80003fd8:	0289a783          	lw	a5,40(s3)
    80003fdc:	fbdd                	bnez	a5,80003f92 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fde:	2184a783          	lw	a5,536(s1)
    80003fe2:	21c4a703          	lw	a4,540(s1)
    80003fe6:	2007879b          	addiw	a5,a5,512
    80003fea:	fcf707e3          	beq	a4,a5,80003fb8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fee:	4685                	li	a3,1
    80003ff0:	01590633          	add	a2,s2,s5
    80003ff4:	faf40593          	addi	a1,s0,-81
    80003ff8:	0509b503          	ld	a0,80(s3)
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	ba8080e7          	jalr	-1112(ra) # 80000ba4 <copyin>
    80004004:	05650263          	beq	a0,s6,80004048 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004008:	21c4a783          	lw	a5,540(s1)
    8000400c:	0017871b          	addiw	a4,a5,1
    80004010:	20e4ae23          	sw	a4,540(s1)
    80004014:	1ff7f793          	andi	a5,a5,511
    80004018:	97a6                	add	a5,a5,s1
    8000401a:	faf44703          	lbu	a4,-81(s0)
    8000401e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004022:	2905                	addiw	s2,s2,1
    80004024:	b76d                	j	80003fce <pipewrite+0x80>
    80004026:	7b02                	ld	s6,32(sp)
    80004028:	6be2                	ld	s7,24(sp)
    8000402a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000402c:	21848513          	addi	a0,s1,536
    80004030:	ffffd097          	auipc	ra,0xffffd
    80004034:	6e8080e7          	jalr	1768(ra) # 80001718 <wakeup>
  release(&pi->lock);
    80004038:	8526                	mv	a0,s1
    8000403a:	00002097          	auipc	ra,0x2
    8000403e:	3bc080e7          	jalr	956(ra) # 800063f6 <release>
  return i;
    80004042:	b78d                	j	80003fa4 <pipewrite+0x56>
  int i = 0;
    80004044:	4901                	li	s2,0
    80004046:	b7dd                	j	8000402c <pipewrite+0xde>
    80004048:	7b02                	ld	s6,32(sp)
    8000404a:	6be2                	ld	s7,24(sp)
    8000404c:	6c42                	ld	s8,16(sp)
    8000404e:	bff9                	j	8000402c <pipewrite+0xde>

0000000080004050 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004050:	715d                	addi	sp,sp,-80
    80004052:	e486                	sd	ra,72(sp)
    80004054:	e0a2                	sd	s0,64(sp)
    80004056:	fc26                	sd	s1,56(sp)
    80004058:	f84a                	sd	s2,48(sp)
    8000405a:	f44e                	sd	s3,40(sp)
    8000405c:	f052                	sd	s4,32(sp)
    8000405e:	ec56                	sd	s5,24(sp)
    80004060:	0880                	addi	s0,sp,80
    80004062:	84aa                	mv	s1,a0
    80004064:	892e                	mv	s2,a1
    80004066:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	e14080e7          	jalr	-492(ra) # 80000e7c <myproc>
    80004070:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	2ce080e7          	jalr	718(ra) # 80006342 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000407c:	2184a703          	lw	a4,536(s1)
    80004080:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004084:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004088:	02f71663          	bne	a4,a5,800040b4 <piperead+0x64>
    8000408c:	2244a783          	lw	a5,548(s1)
    80004090:	cb9d                	beqz	a5,800040c6 <piperead+0x76>
    if(pr->killed){
    80004092:	028a2783          	lw	a5,40(s4)
    80004096:	e38d                	bnez	a5,800040b8 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004098:	85a6                	mv	a1,s1
    8000409a:	854e                	mv	a0,s3
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	4f0080e7          	jalr	1264(ra) # 8000158c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040a4:	2184a703          	lw	a4,536(s1)
    800040a8:	21c4a783          	lw	a5,540(s1)
    800040ac:	fef700e3          	beq	a4,a5,8000408c <piperead+0x3c>
    800040b0:	e85a                	sd	s6,16(sp)
    800040b2:	a819                	j	800040c8 <piperead+0x78>
    800040b4:	e85a                	sd	s6,16(sp)
    800040b6:	a809                	j	800040c8 <piperead+0x78>
      release(&pi->lock);
    800040b8:	8526                	mv	a0,s1
    800040ba:	00002097          	auipc	ra,0x2
    800040be:	33c080e7          	jalr	828(ra) # 800063f6 <release>
      return -1;
    800040c2:	59fd                	li	s3,-1
    800040c4:	a0a5                	j	8000412c <piperead+0xdc>
    800040c6:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040c8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ca:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040cc:	05505463          	blez	s5,80004114 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800040d0:	2184a783          	lw	a5,536(s1)
    800040d4:	21c4a703          	lw	a4,540(s1)
    800040d8:	02f70e63          	beq	a4,a5,80004114 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040dc:	0017871b          	addiw	a4,a5,1
    800040e0:	20e4ac23          	sw	a4,536(s1)
    800040e4:	1ff7f793          	andi	a5,a5,511
    800040e8:	97a6                	add	a5,a5,s1
    800040ea:	0187c783          	lbu	a5,24(a5)
    800040ee:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f2:	4685                	li	a3,1
    800040f4:	fbf40613          	addi	a2,s0,-65
    800040f8:	85ca                	mv	a1,s2
    800040fa:	050a3503          	ld	a0,80(s4)
    800040fe:	ffffd097          	auipc	ra,0xffffd
    80004102:	a1a080e7          	jalr	-1510(ra) # 80000b18 <copyout>
    80004106:	01650763          	beq	a0,s6,80004114 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000410a:	2985                	addiw	s3,s3,1
    8000410c:	0905                	addi	s2,s2,1
    8000410e:	fd3a91e3          	bne	s5,s3,800040d0 <piperead+0x80>
    80004112:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004114:	21c48513          	addi	a0,s1,540
    80004118:	ffffd097          	auipc	ra,0xffffd
    8000411c:	600080e7          	jalr	1536(ra) # 80001718 <wakeup>
  release(&pi->lock);
    80004120:	8526                	mv	a0,s1
    80004122:	00002097          	auipc	ra,0x2
    80004126:	2d4080e7          	jalr	724(ra) # 800063f6 <release>
    8000412a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000412c:	854e                	mv	a0,s3
    8000412e:	60a6                	ld	ra,72(sp)
    80004130:	6406                	ld	s0,64(sp)
    80004132:	74e2                	ld	s1,56(sp)
    80004134:	7942                	ld	s2,48(sp)
    80004136:	79a2                	ld	s3,40(sp)
    80004138:	7a02                	ld	s4,32(sp)
    8000413a:	6ae2                	ld	s5,24(sp)
    8000413c:	6161                	addi	sp,sp,80
    8000413e:	8082                	ret

0000000080004140 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004140:	df010113          	addi	sp,sp,-528
    80004144:	20113423          	sd	ra,520(sp)
    80004148:	20813023          	sd	s0,512(sp)
    8000414c:	ffa6                	sd	s1,504(sp)
    8000414e:	fbca                	sd	s2,496(sp)
    80004150:	0c00                	addi	s0,sp,528
    80004152:	892a                	mv	s2,a0
    80004154:	dea43c23          	sd	a0,-520(s0)
    80004158:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	d20080e7          	jalr	-736(ra) # 80000e7c <myproc>
    80004164:	84aa                	mv	s1,a0

  begin_op();
    80004166:	fffff097          	auipc	ra,0xfffff
    8000416a:	460080e7          	jalr	1120(ra) # 800035c6 <begin_op>

  if((ip = namei(path)) == 0){
    8000416e:	854a                	mv	a0,s2
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	256080e7          	jalr	598(ra) # 800033c6 <namei>
    80004178:	c135                	beqz	a0,800041dc <exec+0x9c>
    8000417a:	f3d2                	sd	s4,480(sp)
    8000417c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	a76080e7          	jalr	-1418(ra) # 80002bf4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004186:	04000713          	li	a4,64
    8000418a:	4681                	li	a3,0
    8000418c:	e5040613          	addi	a2,s0,-432
    80004190:	4581                	li	a1,0
    80004192:	8552                	mv	a0,s4
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	d18080e7          	jalr	-744(ra) # 80002eac <readi>
    8000419c:	04000793          	li	a5,64
    800041a0:	00f51a63          	bne	a0,a5,800041b4 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041a4:	e5042703          	lw	a4,-432(s0)
    800041a8:	464c47b7          	lui	a5,0x464c4
    800041ac:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041b0:	02f70c63          	beq	a4,a5,800041e8 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041b4:	8552                	mv	a0,s4
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	ca4080e7          	jalr	-860(ra) # 80002e5a <iunlockput>
    end_op();
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	482080e7          	jalr	1154(ra) # 80003640 <end_op>
  }
  return -1;
    800041c6:	557d                	li	a0,-1
    800041c8:	7a1e                	ld	s4,480(sp)
}
    800041ca:	20813083          	ld	ra,520(sp)
    800041ce:	20013403          	ld	s0,512(sp)
    800041d2:	74fe                	ld	s1,504(sp)
    800041d4:	795e                	ld	s2,496(sp)
    800041d6:	21010113          	addi	sp,sp,528
    800041da:	8082                	ret
    end_op();
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	464080e7          	jalr	1124(ra) # 80003640 <end_op>
    return -1;
    800041e4:	557d                	li	a0,-1
    800041e6:	b7d5                	j	800041ca <exec+0x8a>
    800041e8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800041ea:	8526                	mv	a0,s1
    800041ec:	ffffd097          	auipc	ra,0xffffd
    800041f0:	d54080e7          	jalr	-684(ra) # 80000f40 <proc_pagetable>
    800041f4:	8b2a                	mv	s6,a0
    800041f6:	30050563          	beqz	a0,80004500 <exec+0x3c0>
    800041fa:	f7ce                	sd	s3,488(sp)
    800041fc:	efd6                	sd	s5,472(sp)
    800041fe:	e7de                	sd	s7,456(sp)
    80004200:	e3e2                	sd	s8,448(sp)
    80004202:	ff66                	sd	s9,440(sp)
    80004204:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004206:	e7042d03          	lw	s10,-400(s0)
    8000420a:	e8845783          	lhu	a5,-376(s0)
    8000420e:	14078563          	beqz	a5,80004358 <exec+0x218>
    80004212:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004214:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004216:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004218:	6c85                	lui	s9,0x1
    8000421a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000421e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004222:	6a85                	lui	s5,0x1
    80004224:	a0b5                	j	80004290 <exec+0x150>
      panic("loadseg: address should exist");
    80004226:	00004517          	auipc	a0,0x4
    8000422a:	32a50513          	addi	a0,a0,810 # 80008550 <etext+0x550>
    8000422e:	00002097          	auipc	ra,0x2
    80004232:	bc4080e7          	jalr	-1084(ra) # 80005df2 <panic>
    if(sz - i < PGSIZE)
    80004236:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004238:	8726                	mv	a4,s1
    8000423a:	012c06bb          	addw	a3,s8,s2
    8000423e:	4581                	li	a1,0
    80004240:	8552                	mv	a0,s4
    80004242:	fffff097          	auipc	ra,0xfffff
    80004246:	c6a080e7          	jalr	-918(ra) # 80002eac <readi>
    8000424a:	2501                	sext.w	a0,a0
    8000424c:	26a49e63          	bne	s1,a0,800044c8 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80004250:	012a893b          	addw	s2,s5,s2
    80004254:	03397563          	bgeu	s2,s3,8000427e <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004258:	02091593          	slli	a1,s2,0x20
    8000425c:	9181                	srli	a1,a1,0x20
    8000425e:	95de                	add	a1,a1,s7
    80004260:	855a                	mv	a0,s6
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	296080e7          	jalr	662(ra) # 800004f8 <walkaddr>
    8000426a:	862a                	mv	a2,a0
    if(pa == 0)
    8000426c:	dd4d                	beqz	a0,80004226 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000426e:	412984bb          	subw	s1,s3,s2
    80004272:	0004879b          	sext.w	a5,s1
    80004276:	fcfcf0e3          	bgeu	s9,a5,80004236 <exec+0xf6>
    8000427a:	84d6                	mv	s1,s5
    8000427c:	bf6d                	j	80004236 <exec+0xf6>
    sz = sz1;
    8000427e:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004282:	2d85                	addiw	s11,s11,1
    80004284:	038d0d1b          	addiw	s10,s10,56
    80004288:	e8845783          	lhu	a5,-376(s0)
    8000428c:	06fddf63          	bge	s11,a5,8000430a <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004290:	2d01                	sext.w	s10,s10
    80004292:	03800713          	li	a4,56
    80004296:	86ea                	mv	a3,s10
    80004298:	e1840613          	addi	a2,s0,-488
    8000429c:	4581                	li	a1,0
    8000429e:	8552                	mv	a0,s4
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	c0c080e7          	jalr	-1012(ra) # 80002eac <readi>
    800042a8:	03800793          	li	a5,56
    800042ac:	1ef51863          	bne	a0,a5,8000449c <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042b0:	e1842783          	lw	a5,-488(s0)
    800042b4:	4705                	li	a4,1
    800042b6:	fce796e3          	bne	a5,a4,80004282 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042ba:	e4043603          	ld	a2,-448(s0)
    800042be:	e3843783          	ld	a5,-456(s0)
    800042c2:	1ef66163          	bltu	a2,a5,800044a4 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042c6:	e2843783          	ld	a5,-472(s0)
    800042ca:	963e                	add	a2,a2,a5
    800042cc:	1ef66063          	bltu	a2,a5,800044ac <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042d0:	85a6                	mv	a1,s1
    800042d2:	855a                	mv	a0,s6
    800042d4:	ffffc097          	auipc	ra,0xffffc
    800042d8:	5e8080e7          	jalr	1512(ra) # 800008bc <uvmalloc>
    800042dc:	e0a43423          	sd	a0,-504(s0)
    800042e0:	1c050a63          	beqz	a0,800044b4 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    800042e4:	e2843b83          	ld	s7,-472(s0)
    800042e8:	df043783          	ld	a5,-528(s0)
    800042ec:	00fbf7b3          	and	a5,s7,a5
    800042f0:	1c079a63          	bnez	a5,800044c4 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042f4:	e2042c03          	lw	s8,-480(s0)
    800042f8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042fc:	00098463          	beqz	s3,80004304 <exec+0x1c4>
    80004300:	4901                	li	s2,0
    80004302:	bf99                	j	80004258 <exec+0x118>
    sz = sz1;
    80004304:	e0843483          	ld	s1,-504(s0)
    80004308:	bfad                	j	80004282 <exec+0x142>
    8000430a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000430c:	8552                	mv	a0,s4
    8000430e:	fffff097          	auipc	ra,0xfffff
    80004312:	b4c080e7          	jalr	-1204(ra) # 80002e5a <iunlockput>
  end_op();
    80004316:	fffff097          	auipc	ra,0xfffff
    8000431a:	32a080e7          	jalr	810(ra) # 80003640 <end_op>
  p = myproc();
    8000431e:	ffffd097          	auipc	ra,0xffffd
    80004322:	b5e080e7          	jalr	-1186(ra) # 80000e7c <myproc>
    80004326:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004328:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000432c:	6985                	lui	s3,0x1
    8000432e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004330:	99a6                	add	s3,s3,s1
    80004332:	77fd                	lui	a5,0xfffff
    80004334:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004338:	6609                	lui	a2,0x2
    8000433a:	964e                	add	a2,a2,s3
    8000433c:	85ce                	mv	a1,s3
    8000433e:	855a                	mv	a0,s6
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	57c080e7          	jalr	1404(ra) # 800008bc <uvmalloc>
    80004348:	892a                	mv	s2,a0
    8000434a:	e0a43423          	sd	a0,-504(s0)
    8000434e:	e519                	bnez	a0,8000435c <exec+0x21c>
  if(pagetable)
    80004350:	e1343423          	sd	s3,-504(s0)
    80004354:	4a01                	li	s4,0
    80004356:	aa95                	j	800044ca <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004358:	4481                	li	s1,0
    8000435a:	bf4d                	j	8000430c <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000435c:	75f9                	lui	a1,0xffffe
    8000435e:	95aa                	add	a1,a1,a0
    80004360:	855a                	mv	a0,s6
    80004362:	ffffc097          	auipc	ra,0xffffc
    80004366:	784080e7          	jalr	1924(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000436a:	7bfd                	lui	s7,0xfffff
    8000436c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000436e:	e0043783          	ld	a5,-512(s0)
    80004372:	6388                	ld	a0,0(a5)
    80004374:	c52d                	beqz	a0,800043de <exec+0x29e>
    80004376:	e9040993          	addi	s3,s0,-368
    8000437a:	f9040c13          	addi	s8,s0,-112
    8000437e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	f6e080e7          	jalr	-146(ra) # 800002ee <strlen>
    80004388:	0015079b          	addiw	a5,a0,1
    8000438c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004390:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004394:	13796463          	bltu	s2,s7,800044bc <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004398:	e0043d03          	ld	s10,-512(s0)
    8000439c:	000d3a03          	ld	s4,0(s10)
    800043a0:	8552                	mv	a0,s4
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	f4c080e7          	jalr	-180(ra) # 800002ee <strlen>
    800043aa:	0015069b          	addiw	a3,a0,1
    800043ae:	8652                	mv	a2,s4
    800043b0:	85ca                	mv	a1,s2
    800043b2:	855a                	mv	a0,s6
    800043b4:	ffffc097          	auipc	ra,0xffffc
    800043b8:	764080e7          	jalr	1892(ra) # 80000b18 <copyout>
    800043bc:	10054263          	bltz	a0,800044c0 <exec+0x380>
    ustack[argc] = sp;
    800043c0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043c4:	0485                	addi	s1,s1,1
    800043c6:	008d0793          	addi	a5,s10,8
    800043ca:	e0f43023          	sd	a5,-512(s0)
    800043ce:	008d3503          	ld	a0,8(s10)
    800043d2:	c909                	beqz	a0,800043e4 <exec+0x2a4>
    if(argc >= MAXARG)
    800043d4:	09a1                	addi	s3,s3,8
    800043d6:	fb8995e3          	bne	s3,s8,80004380 <exec+0x240>
  ip = 0;
    800043da:	4a01                	li	s4,0
    800043dc:	a0fd                	j	800044ca <exec+0x38a>
  sp = sz;
    800043de:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043e2:	4481                	li	s1,0
  ustack[argc] = 0;
    800043e4:	00349793          	slli	a5,s1,0x3
    800043e8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5d50>
    800043ec:	97a2                	add	a5,a5,s0
    800043ee:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043f2:	00148693          	addi	a3,s1,1
    800043f6:	068e                	slli	a3,a3,0x3
    800043f8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043fc:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004400:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004404:	f57966e3          	bltu	s2,s7,80004350 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004408:	e9040613          	addi	a2,s0,-368
    8000440c:	85ca                	mv	a1,s2
    8000440e:	855a                	mv	a0,s6
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	708080e7          	jalr	1800(ra) # 80000b18 <copyout>
    80004418:	0e054663          	bltz	a0,80004504 <exec+0x3c4>
  p->trapframe->a1 = sp;
    8000441c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004420:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004424:	df843783          	ld	a5,-520(s0)
    80004428:	0007c703          	lbu	a4,0(a5)
    8000442c:	cf11                	beqz	a4,80004448 <exec+0x308>
    8000442e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004430:	02f00693          	li	a3,47
    80004434:	a039                	j	80004442 <exec+0x302>
      last = s+1;
    80004436:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000443a:	0785                	addi	a5,a5,1
    8000443c:	fff7c703          	lbu	a4,-1(a5)
    80004440:	c701                	beqz	a4,80004448 <exec+0x308>
    if(*s == '/')
    80004442:	fed71ce3          	bne	a4,a3,8000443a <exec+0x2fa>
    80004446:	bfc5                	j	80004436 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004448:	4641                	li	a2,16
    8000444a:	df843583          	ld	a1,-520(s0)
    8000444e:	158a8513          	addi	a0,s5,344
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	e6a080e7          	jalr	-406(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000445a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000445e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004462:	e0843783          	ld	a5,-504(s0)
    80004466:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000446a:	058ab783          	ld	a5,88(s5)
    8000446e:	e6843703          	ld	a4,-408(s0)
    80004472:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004474:	058ab783          	ld	a5,88(s5)
    80004478:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000447c:	85e6                	mv	a1,s9
    8000447e:	ffffd097          	auipc	ra,0xffffd
    80004482:	b5e080e7          	jalr	-1186(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004486:	0004851b          	sext.w	a0,s1
    8000448a:	79be                	ld	s3,488(sp)
    8000448c:	7a1e                	ld	s4,480(sp)
    8000448e:	6afe                	ld	s5,472(sp)
    80004490:	6b5e                	ld	s6,464(sp)
    80004492:	6bbe                	ld	s7,456(sp)
    80004494:	6c1e                	ld	s8,448(sp)
    80004496:	7cfa                	ld	s9,440(sp)
    80004498:	7d5a                	ld	s10,432(sp)
    8000449a:	bb05                	j	800041ca <exec+0x8a>
    8000449c:	e0943423          	sd	s1,-504(s0)
    800044a0:	7dba                	ld	s11,424(sp)
    800044a2:	a025                	j	800044ca <exec+0x38a>
    800044a4:	e0943423          	sd	s1,-504(s0)
    800044a8:	7dba                	ld	s11,424(sp)
    800044aa:	a005                	j	800044ca <exec+0x38a>
    800044ac:	e0943423          	sd	s1,-504(s0)
    800044b0:	7dba                	ld	s11,424(sp)
    800044b2:	a821                	j	800044ca <exec+0x38a>
    800044b4:	e0943423          	sd	s1,-504(s0)
    800044b8:	7dba                	ld	s11,424(sp)
    800044ba:	a801                	j	800044ca <exec+0x38a>
  ip = 0;
    800044bc:	4a01                	li	s4,0
    800044be:	a031                	j	800044ca <exec+0x38a>
    800044c0:	4a01                	li	s4,0
  if(pagetable)
    800044c2:	a021                	j	800044ca <exec+0x38a>
    800044c4:	7dba                	ld	s11,424(sp)
    800044c6:	a011                	j	800044ca <exec+0x38a>
    800044c8:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044ca:	e0843583          	ld	a1,-504(s0)
    800044ce:	855a                	mv	a0,s6
    800044d0:	ffffd097          	auipc	ra,0xffffd
    800044d4:	b0c080e7          	jalr	-1268(ra) # 80000fdc <proc_freepagetable>
  return -1;
    800044d8:	557d                	li	a0,-1
  if(ip){
    800044da:	000a1b63          	bnez	s4,800044f0 <exec+0x3b0>
    800044de:	79be                	ld	s3,488(sp)
    800044e0:	7a1e                	ld	s4,480(sp)
    800044e2:	6afe                	ld	s5,472(sp)
    800044e4:	6b5e                	ld	s6,464(sp)
    800044e6:	6bbe                	ld	s7,456(sp)
    800044e8:	6c1e                	ld	s8,448(sp)
    800044ea:	7cfa                	ld	s9,440(sp)
    800044ec:	7d5a                	ld	s10,432(sp)
    800044ee:	b9f1                	j	800041ca <exec+0x8a>
    800044f0:	79be                	ld	s3,488(sp)
    800044f2:	6afe                	ld	s5,472(sp)
    800044f4:	6b5e                	ld	s6,464(sp)
    800044f6:	6bbe                	ld	s7,456(sp)
    800044f8:	6c1e                	ld	s8,448(sp)
    800044fa:	7cfa                	ld	s9,440(sp)
    800044fc:	7d5a                	ld	s10,432(sp)
    800044fe:	b95d                	j	800041b4 <exec+0x74>
    80004500:	6b5e                	ld	s6,464(sp)
    80004502:	b94d                	j	800041b4 <exec+0x74>
  sz = sz1;
    80004504:	e0843983          	ld	s3,-504(s0)
    80004508:	b5a1                	j	80004350 <exec+0x210>

000000008000450a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000450a:	7179                	addi	sp,sp,-48
    8000450c:	f406                	sd	ra,40(sp)
    8000450e:	f022                	sd	s0,32(sp)
    80004510:	ec26                	sd	s1,24(sp)
    80004512:	e84a                	sd	s2,16(sp)
    80004514:	1800                	addi	s0,sp,48
    80004516:	892e                	mv	s2,a1
    80004518:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000451a:	fdc40593          	addi	a1,s0,-36
    8000451e:	ffffe097          	auipc	ra,0xffffe
    80004522:	aae080e7          	jalr	-1362(ra) # 80001fcc <argint>
    80004526:	04054063          	bltz	a0,80004566 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000452a:	fdc42703          	lw	a4,-36(s0)
    8000452e:	47bd                	li	a5,15
    80004530:	02e7ed63          	bltu	a5,a4,8000456a <argfd+0x60>
    80004534:	ffffd097          	auipc	ra,0xffffd
    80004538:	948080e7          	jalr	-1720(ra) # 80000e7c <myproc>
    8000453c:	fdc42703          	lw	a4,-36(s0)
    80004540:	01a70793          	addi	a5,a4,26
    80004544:	078e                	slli	a5,a5,0x3
    80004546:	953e                	add	a0,a0,a5
    80004548:	611c                	ld	a5,0(a0)
    8000454a:	c395                	beqz	a5,8000456e <argfd+0x64>
    return -1;
  if(pfd)
    8000454c:	00090463          	beqz	s2,80004554 <argfd+0x4a>
    *pfd = fd;
    80004550:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004554:	4501                	li	a0,0
  if(pf)
    80004556:	c091                	beqz	s1,8000455a <argfd+0x50>
    *pf = f;
    80004558:	e09c                	sd	a5,0(s1)
}
    8000455a:	70a2                	ld	ra,40(sp)
    8000455c:	7402                	ld	s0,32(sp)
    8000455e:	64e2                	ld	s1,24(sp)
    80004560:	6942                	ld	s2,16(sp)
    80004562:	6145                	addi	sp,sp,48
    80004564:	8082                	ret
    return -1;
    80004566:	557d                	li	a0,-1
    80004568:	bfcd                	j	8000455a <argfd+0x50>
    return -1;
    8000456a:	557d                	li	a0,-1
    8000456c:	b7fd                	j	8000455a <argfd+0x50>
    8000456e:	557d                	li	a0,-1
    80004570:	b7ed                	j	8000455a <argfd+0x50>

0000000080004572 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004572:	1101                	addi	sp,sp,-32
    80004574:	ec06                	sd	ra,24(sp)
    80004576:	e822                	sd	s0,16(sp)
    80004578:	e426                	sd	s1,8(sp)
    8000457a:	1000                	addi	s0,sp,32
    8000457c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000457e:	ffffd097          	auipc	ra,0xffffd
    80004582:	8fe080e7          	jalr	-1794(ra) # 80000e7c <myproc>
    80004586:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004588:	0d050793          	addi	a5,a0,208
    8000458c:	4501                	li	a0,0
    8000458e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004590:	6398                	ld	a4,0(a5)
    80004592:	cb19                	beqz	a4,800045a8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004594:	2505                	addiw	a0,a0,1
    80004596:	07a1                	addi	a5,a5,8
    80004598:	fed51ce3          	bne	a0,a3,80004590 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000459c:	557d                	li	a0,-1
}
    8000459e:	60e2                	ld	ra,24(sp)
    800045a0:	6442                	ld	s0,16(sp)
    800045a2:	64a2                	ld	s1,8(sp)
    800045a4:	6105                	addi	sp,sp,32
    800045a6:	8082                	ret
      p->ofile[fd] = f;
    800045a8:	01a50793          	addi	a5,a0,26
    800045ac:	078e                	slli	a5,a5,0x3
    800045ae:	963e                	add	a2,a2,a5
    800045b0:	e204                	sd	s1,0(a2)
      return fd;
    800045b2:	b7f5                	j	8000459e <fdalloc+0x2c>

00000000800045b4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045b4:	715d                	addi	sp,sp,-80
    800045b6:	e486                	sd	ra,72(sp)
    800045b8:	e0a2                	sd	s0,64(sp)
    800045ba:	fc26                	sd	s1,56(sp)
    800045bc:	f84a                	sd	s2,48(sp)
    800045be:	f44e                	sd	s3,40(sp)
    800045c0:	f052                	sd	s4,32(sp)
    800045c2:	ec56                	sd	s5,24(sp)
    800045c4:	0880                	addi	s0,sp,80
    800045c6:	8aae                	mv	s5,a1
    800045c8:	8a32                	mv	s4,a2
    800045ca:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045cc:	fb040593          	addi	a1,s0,-80
    800045d0:	fffff097          	auipc	ra,0xfffff
    800045d4:	e14080e7          	jalr	-492(ra) # 800033e4 <nameiparent>
    800045d8:	892a                	mv	s2,a0
    800045da:	12050c63          	beqz	a0,80004712 <create+0x15e>
    return 0;

  ilock(dp);
    800045de:	ffffe097          	auipc	ra,0xffffe
    800045e2:	616080e7          	jalr	1558(ra) # 80002bf4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045e6:	4601                	li	a2,0
    800045e8:	fb040593          	addi	a1,s0,-80
    800045ec:	854a                	mv	a0,s2
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	b06080e7          	jalr	-1274(ra) # 800030f4 <dirlookup>
    800045f6:	84aa                	mv	s1,a0
    800045f8:	c539                	beqz	a0,80004646 <create+0x92>
    iunlockput(dp);
    800045fa:	854a                	mv	a0,s2
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	85e080e7          	jalr	-1954(ra) # 80002e5a <iunlockput>
    ilock(ip);
    80004604:	8526                	mv	a0,s1
    80004606:	ffffe097          	auipc	ra,0xffffe
    8000460a:	5ee080e7          	jalr	1518(ra) # 80002bf4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000460e:	4789                	li	a5,2
    80004610:	02fa9463          	bne	s5,a5,80004638 <create+0x84>
    80004614:	0444d783          	lhu	a5,68(s1)
    80004618:	37f9                	addiw	a5,a5,-2
    8000461a:	17c2                	slli	a5,a5,0x30
    8000461c:	93c1                	srli	a5,a5,0x30
    8000461e:	4705                	li	a4,1
    80004620:	00f76c63          	bltu	a4,a5,80004638 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004624:	8526                	mv	a0,s1
    80004626:	60a6                	ld	ra,72(sp)
    80004628:	6406                	ld	s0,64(sp)
    8000462a:	74e2                	ld	s1,56(sp)
    8000462c:	7942                	ld	s2,48(sp)
    8000462e:	79a2                	ld	s3,40(sp)
    80004630:	7a02                	ld	s4,32(sp)
    80004632:	6ae2                	ld	s5,24(sp)
    80004634:	6161                	addi	sp,sp,80
    80004636:	8082                	ret
    iunlockput(ip);
    80004638:	8526                	mv	a0,s1
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	820080e7          	jalr	-2016(ra) # 80002e5a <iunlockput>
    return 0;
    80004642:	4481                	li	s1,0
    80004644:	b7c5                	j	80004624 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004646:	85d6                	mv	a1,s5
    80004648:	00092503          	lw	a0,0(s2)
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	414080e7          	jalr	1044(ra) # 80002a60 <ialloc>
    80004654:	84aa                	mv	s1,a0
    80004656:	c139                	beqz	a0,8000469c <create+0xe8>
  ilock(ip);
    80004658:	ffffe097          	auipc	ra,0xffffe
    8000465c:	59c080e7          	jalr	1436(ra) # 80002bf4 <ilock>
  ip->major = major;
    80004660:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004664:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004668:	4985                	li	s3,1
    8000466a:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000466e:	8526                	mv	a0,s1
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	4b8080e7          	jalr	1208(ra) # 80002b28 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004678:	033a8a63          	beq	s5,s3,800046ac <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000467c:	40d0                	lw	a2,4(s1)
    8000467e:	fb040593          	addi	a1,s0,-80
    80004682:	854a                	mv	a0,s2
    80004684:	fffff097          	auipc	ra,0xfffff
    80004688:	c80080e7          	jalr	-896(ra) # 80003304 <dirlink>
    8000468c:	06054b63          	bltz	a0,80004702 <create+0x14e>
  iunlockput(dp);
    80004690:	854a                	mv	a0,s2
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	7c8080e7          	jalr	1992(ra) # 80002e5a <iunlockput>
  return ip;
    8000469a:	b769                	j	80004624 <create+0x70>
    panic("create: ialloc");
    8000469c:	00004517          	auipc	a0,0x4
    800046a0:	ed450513          	addi	a0,a0,-300 # 80008570 <etext+0x570>
    800046a4:	00001097          	auipc	ra,0x1
    800046a8:	74e080e7          	jalr	1870(ra) # 80005df2 <panic>
    dp->nlink++;  // for ".."
    800046ac:	04a95783          	lhu	a5,74(s2)
    800046b0:	2785                	addiw	a5,a5,1
    800046b2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046b6:	854a                	mv	a0,s2
    800046b8:	ffffe097          	auipc	ra,0xffffe
    800046bc:	470080e7          	jalr	1136(ra) # 80002b28 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046c0:	40d0                	lw	a2,4(s1)
    800046c2:	00004597          	auipc	a1,0x4
    800046c6:	ebe58593          	addi	a1,a1,-322 # 80008580 <etext+0x580>
    800046ca:	8526                	mv	a0,s1
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	c38080e7          	jalr	-968(ra) # 80003304 <dirlink>
    800046d4:	00054f63          	bltz	a0,800046f2 <create+0x13e>
    800046d8:	00492603          	lw	a2,4(s2)
    800046dc:	00004597          	auipc	a1,0x4
    800046e0:	eac58593          	addi	a1,a1,-340 # 80008588 <etext+0x588>
    800046e4:	8526                	mv	a0,s1
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	c1e080e7          	jalr	-994(ra) # 80003304 <dirlink>
    800046ee:	f80557e3          	bgez	a0,8000467c <create+0xc8>
      panic("create dots");
    800046f2:	00004517          	auipc	a0,0x4
    800046f6:	e9e50513          	addi	a0,a0,-354 # 80008590 <etext+0x590>
    800046fa:	00001097          	auipc	ra,0x1
    800046fe:	6f8080e7          	jalr	1784(ra) # 80005df2 <panic>
    panic("create: dirlink");
    80004702:	00004517          	auipc	a0,0x4
    80004706:	e9e50513          	addi	a0,a0,-354 # 800085a0 <etext+0x5a0>
    8000470a:	00001097          	auipc	ra,0x1
    8000470e:	6e8080e7          	jalr	1768(ra) # 80005df2 <panic>
    return 0;
    80004712:	84aa                	mv	s1,a0
    80004714:	bf01                	j	80004624 <create+0x70>

0000000080004716 <sys_dup>:
{
    80004716:	7179                	addi	sp,sp,-48
    80004718:	f406                	sd	ra,40(sp)
    8000471a:	f022                	sd	s0,32(sp)
    8000471c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000471e:	fd840613          	addi	a2,s0,-40
    80004722:	4581                	li	a1,0
    80004724:	4501                	li	a0,0
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	de4080e7          	jalr	-540(ra) # 8000450a <argfd>
    return -1;
    8000472e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004730:	02054763          	bltz	a0,8000475e <sys_dup+0x48>
    80004734:	ec26                	sd	s1,24(sp)
    80004736:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004738:	fd843903          	ld	s2,-40(s0)
    8000473c:	854a                	mv	a0,s2
    8000473e:	00000097          	auipc	ra,0x0
    80004742:	e34080e7          	jalr	-460(ra) # 80004572 <fdalloc>
    80004746:	84aa                	mv	s1,a0
    return -1;
    80004748:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000474a:	00054f63          	bltz	a0,80004768 <sys_dup+0x52>
  filedup(f);
    8000474e:	854a                	mv	a0,s2
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	2ee080e7          	jalr	750(ra) # 80003a3e <filedup>
  return fd;
    80004758:	87a6                	mv	a5,s1
    8000475a:	64e2                	ld	s1,24(sp)
    8000475c:	6942                	ld	s2,16(sp)
}
    8000475e:	853e                	mv	a0,a5
    80004760:	70a2                	ld	ra,40(sp)
    80004762:	7402                	ld	s0,32(sp)
    80004764:	6145                	addi	sp,sp,48
    80004766:	8082                	ret
    80004768:	64e2                	ld	s1,24(sp)
    8000476a:	6942                	ld	s2,16(sp)
    8000476c:	bfcd                	j	8000475e <sys_dup+0x48>

000000008000476e <sys_read>:
{
    8000476e:	7179                	addi	sp,sp,-48
    80004770:	f406                	sd	ra,40(sp)
    80004772:	f022                	sd	s0,32(sp)
    80004774:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004776:	fe840613          	addi	a2,s0,-24
    8000477a:	4581                	li	a1,0
    8000477c:	4501                	li	a0,0
    8000477e:	00000097          	auipc	ra,0x0
    80004782:	d8c080e7          	jalr	-628(ra) # 8000450a <argfd>
    return -1;
    80004786:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004788:	04054163          	bltz	a0,800047ca <sys_read+0x5c>
    8000478c:	fe440593          	addi	a1,s0,-28
    80004790:	4509                	li	a0,2
    80004792:	ffffe097          	auipc	ra,0xffffe
    80004796:	83a080e7          	jalr	-1990(ra) # 80001fcc <argint>
    return -1;
    8000479a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000479c:	02054763          	bltz	a0,800047ca <sys_read+0x5c>
    800047a0:	fd840593          	addi	a1,s0,-40
    800047a4:	4505                	li	a0,1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	848080e7          	jalr	-1976(ra) # 80001fee <argaddr>
    return -1;
    800047ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b0:	00054d63          	bltz	a0,800047ca <sys_read+0x5c>
  return fileread(f, p, n);
    800047b4:	fe442603          	lw	a2,-28(s0)
    800047b8:	fd843583          	ld	a1,-40(s0)
    800047bc:	fe843503          	ld	a0,-24(s0)
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	424080e7          	jalr	1060(ra) # 80003be4 <fileread>
    800047c8:	87aa                	mv	a5,a0
}
    800047ca:	853e                	mv	a0,a5
    800047cc:	70a2                	ld	ra,40(sp)
    800047ce:	7402                	ld	s0,32(sp)
    800047d0:	6145                	addi	sp,sp,48
    800047d2:	8082                	ret

00000000800047d4 <sys_write>:
{
    800047d4:	7179                	addi	sp,sp,-48
    800047d6:	f406                	sd	ra,40(sp)
    800047d8:	f022                	sd	s0,32(sp)
    800047da:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047dc:	fe840613          	addi	a2,s0,-24
    800047e0:	4581                	li	a1,0
    800047e2:	4501                	li	a0,0
    800047e4:	00000097          	auipc	ra,0x0
    800047e8:	d26080e7          	jalr	-730(ra) # 8000450a <argfd>
    return -1;
    800047ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ee:	04054163          	bltz	a0,80004830 <sys_write+0x5c>
    800047f2:	fe440593          	addi	a1,s0,-28
    800047f6:	4509                	li	a0,2
    800047f8:	ffffd097          	auipc	ra,0xffffd
    800047fc:	7d4080e7          	jalr	2004(ra) # 80001fcc <argint>
    return -1;
    80004800:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004802:	02054763          	bltz	a0,80004830 <sys_write+0x5c>
    80004806:	fd840593          	addi	a1,s0,-40
    8000480a:	4505                	li	a0,1
    8000480c:	ffffd097          	auipc	ra,0xffffd
    80004810:	7e2080e7          	jalr	2018(ra) # 80001fee <argaddr>
    return -1;
    80004814:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004816:	00054d63          	bltz	a0,80004830 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000481a:	fe442603          	lw	a2,-28(s0)
    8000481e:	fd843583          	ld	a1,-40(s0)
    80004822:	fe843503          	ld	a0,-24(s0)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	490080e7          	jalr	1168(ra) # 80003cb6 <filewrite>
    8000482e:	87aa                	mv	a5,a0
}
    80004830:	853e                	mv	a0,a5
    80004832:	70a2                	ld	ra,40(sp)
    80004834:	7402                	ld	s0,32(sp)
    80004836:	6145                	addi	sp,sp,48
    80004838:	8082                	ret

000000008000483a <sys_close>:
{
    8000483a:	1101                	addi	sp,sp,-32
    8000483c:	ec06                	sd	ra,24(sp)
    8000483e:	e822                	sd	s0,16(sp)
    80004840:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004842:	fe040613          	addi	a2,s0,-32
    80004846:	fec40593          	addi	a1,s0,-20
    8000484a:	4501                	li	a0,0
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	cbe080e7          	jalr	-834(ra) # 8000450a <argfd>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004856:	02054463          	bltz	a0,8000487e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000485a:	ffffc097          	auipc	ra,0xffffc
    8000485e:	622080e7          	jalr	1570(ra) # 80000e7c <myproc>
    80004862:	fec42783          	lw	a5,-20(s0)
    80004866:	07e9                	addi	a5,a5,26
    80004868:	078e                	slli	a5,a5,0x3
    8000486a:	953e                	add	a0,a0,a5
    8000486c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004870:	fe043503          	ld	a0,-32(s0)
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	21c080e7          	jalr	540(ra) # 80003a90 <fileclose>
  return 0;
    8000487c:	4781                	li	a5,0
}
    8000487e:	853e                	mv	a0,a5
    80004880:	60e2                	ld	ra,24(sp)
    80004882:	6442                	ld	s0,16(sp)
    80004884:	6105                	addi	sp,sp,32
    80004886:	8082                	ret

0000000080004888 <sys_fstat>:
{
    80004888:	1101                	addi	sp,sp,-32
    8000488a:	ec06                	sd	ra,24(sp)
    8000488c:	e822                	sd	s0,16(sp)
    8000488e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004890:	fe840613          	addi	a2,s0,-24
    80004894:	4581                	li	a1,0
    80004896:	4501                	li	a0,0
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	c72080e7          	jalr	-910(ra) # 8000450a <argfd>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048a2:	02054563          	bltz	a0,800048cc <sys_fstat+0x44>
    800048a6:	fe040593          	addi	a1,s0,-32
    800048aa:	4505                	li	a0,1
    800048ac:	ffffd097          	auipc	ra,0xffffd
    800048b0:	742080e7          	jalr	1858(ra) # 80001fee <argaddr>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048b6:	00054b63          	bltz	a0,800048cc <sys_fstat+0x44>
  return filestat(f, st);
    800048ba:	fe043583          	ld	a1,-32(s0)
    800048be:	fe843503          	ld	a0,-24(s0)
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	2b0080e7          	jalr	688(ra) # 80003b72 <filestat>
    800048ca:	87aa                	mv	a5,a0
}
    800048cc:	853e                	mv	a0,a5
    800048ce:	60e2                	ld	ra,24(sp)
    800048d0:	6442                	ld	s0,16(sp)
    800048d2:	6105                	addi	sp,sp,32
    800048d4:	8082                	ret

00000000800048d6 <sys_link>:
{
    800048d6:	7169                	addi	sp,sp,-304
    800048d8:	f606                	sd	ra,296(sp)
    800048da:	f222                	sd	s0,288(sp)
    800048dc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048de:	08000613          	li	a2,128
    800048e2:	ed040593          	addi	a1,s0,-304
    800048e6:	4501                	li	a0,0
    800048e8:	ffffd097          	auipc	ra,0xffffd
    800048ec:	728080e7          	jalr	1832(ra) # 80002010 <argstr>
    return -1;
    800048f0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f2:	12054663          	bltz	a0,80004a1e <sys_link+0x148>
    800048f6:	08000613          	li	a2,128
    800048fa:	f5040593          	addi	a1,s0,-176
    800048fe:	4505                	li	a0,1
    80004900:	ffffd097          	auipc	ra,0xffffd
    80004904:	710080e7          	jalr	1808(ra) # 80002010 <argstr>
    return -1;
    80004908:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490a:	10054a63          	bltz	a0,80004a1e <sys_link+0x148>
    8000490e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	cb6080e7          	jalr	-842(ra) # 800035c6 <begin_op>
  if((ip = namei(old)) == 0){
    80004918:	ed040513          	addi	a0,s0,-304
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	aaa080e7          	jalr	-1366(ra) # 800033c6 <namei>
    80004924:	84aa                	mv	s1,a0
    80004926:	c949                	beqz	a0,800049b8 <sys_link+0xe2>
  ilock(ip);
    80004928:	ffffe097          	auipc	ra,0xffffe
    8000492c:	2cc080e7          	jalr	716(ra) # 80002bf4 <ilock>
  if(ip->type == T_DIR){
    80004930:	04449703          	lh	a4,68(s1)
    80004934:	4785                	li	a5,1
    80004936:	08f70863          	beq	a4,a5,800049c6 <sys_link+0xf0>
    8000493a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000493c:	04a4d783          	lhu	a5,74(s1)
    80004940:	2785                	addiw	a5,a5,1
    80004942:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	1e0080e7          	jalr	480(ra) # 80002b28 <iupdate>
  iunlock(ip);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	368080e7          	jalr	872(ra) # 80002cba <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000495a:	fd040593          	addi	a1,s0,-48
    8000495e:	f5040513          	addi	a0,s0,-176
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	a82080e7          	jalr	-1406(ra) # 800033e4 <nameiparent>
    8000496a:	892a                	mv	s2,a0
    8000496c:	cd35                	beqz	a0,800049e8 <sys_link+0x112>
  ilock(dp);
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	286080e7          	jalr	646(ra) # 80002bf4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004976:	00092703          	lw	a4,0(s2)
    8000497a:	409c                	lw	a5,0(s1)
    8000497c:	06f71163          	bne	a4,a5,800049de <sys_link+0x108>
    80004980:	40d0                	lw	a2,4(s1)
    80004982:	fd040593          	addi	a1,s0,-48
    80004986:	854a                	mv	a0,s2
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	97c080e7          	jalr	-1668(ra) # 80003304 <dirlink>
    80004990:	04054763          	bltz	a0,800049de <sys_link+0x108>
  iunlockput(dp);
    80004994:	854a                	mv	a0,s2
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	4c4080e7          	jalr	1220(ra) # 80002e5a <iunlockput>
  iput(ip);
    8000499e:	8526                	mv	a0,s1
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	412080e7          	jalr	1042(ra) # 80002db2 <iput>
  end_op();
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	c98080e7          	jalr	-872(ra) # 80003640 <end_op>
  return 0;
    800049b0:	4781                	li	a5,0
    800049b2:	64f2                	ld	s1,280(sp)
    800049b4:	6952                	ld	s2,272(sp)
    800049b6:	a0a5                	j	80004a1e <sys_link+0x148>
    end_op();
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	c88080e7          	jalr	-888(ra) # 80003640 <end_op>
    return -1;
    800049c0:	57fd                	li	a5,-1
    800049c2:	64f2                	ld	s1,280(sp)
    800049c4:	a8a9                	j	80004a1e <sys_link+0x148>
    iunlockput(ip);
    800049c6:	8526                	mv	a0,s1
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	492080e7          	jalr	1170(ra) # 80002e5a <iunlockput>
    end_op();
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	c70080e7          	jalr	-912(ra) # 80003640 <end_op>
    return -1;
    800049d8:	57fd                	li	a5,-1
    800049da:	64f2                	ld	s1,280(sp)
    800049dc:	a089                	j	80004a1e <sys_link+0x148>
    iunlockput(dp);
    800049de:	854a                	mv	a0,s2
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	47a080e7          	jalr	1146(ra) # 80002e5a <iunlockput>
  ilock(ip);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	20a080e7          	jalr	522(ra) # 80002bf4 <ilock>
  ip->nlink--;
    800049f2:	04a4d783          	lhu	a5,74(s1)
    800049f6:	37fd                	addiw	a5,a5,-1
    800049f8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	12a080e7          	jalr	298(ra) # 80002b28 <iupdate>
  iunlockput(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	452080e7          	jalr	1106(ra) # 80002e5a <iunlockput>
  end_op();
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	c30080e7          	jalr	-976(ra) # 80003640 <end_op>
  return -1;
    80004a18:	57fd                	li	a5,-1
    80004a1a:	64f2                	ld	s1,280(sp)
    80004a1c:	6952                	ld	s2,272(sp)
}
    80004a1e:	853e                	mv	a0,a5
    80004a20:	70b2                	ld	ra,296(sp)
    80004a22:	7412                	ld	s0,288(sp)
    80004a24:	6155                	addi	sp,sp,304
    80004a26:	8082                	ret

0000000080004a28 <sys_unlink>:
{
    80004a28:	7151                	addi	sp,sp,-240
    80004a2a:	f586                	sd	ra,232(sp)
    80004a2c:	f1a2                	sd	s0,224(sp)
    80004a2e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a30:	08000613          	li	a2,128
    80004a34:	f3040593          	addi	a1,s0,-208
    80004a38:	4501                	li	a0,0
    80004a3a:	ffffd097          	auipc	ra,0xffffd
    80004a3e:	5d6080e7          	jalr	1494(ra) # 80002010 <argstr>
    80004a42:	1a054a63          	bltz	a0,80004bf6 <sys_unlink+0x1ce>
    80004a46:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	b7e080e7          	jalr	-1154(ra) # 800035c6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a50:	fb040593          	addi	a1,s0,-80
    80004a54:	f3040513          	addi	a0,s0,-208
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	98c080e7          	jalr	-1652(ra) # 800033e4 <nameiparent>
    80004a60:	84aa                	mv	s1,a0
    80004a62:	cd71                	beqz	a0,80004b3e <sys_unlink+0x116>
  ilock(dp);
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	190080e7          	jalr	400(ra) # 80002bf4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a6c:	00004597          	auipc	a1,0x4
    80004a70:	b1458593          	addi	a1,a1,-1260 # 80008580 <etext+0x580>
    80004a74:	fb040513          	addi	a0,s0,-80
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	662080e7          	jalr	1634(ra) # 800030da <namecmp>
    80004a80:	14050c63          	beqz	a0,80004bd8 <sys_unlink+0x1b0>
    80004a84:	00004597          	auipc	a1,0x4
    80004a88:	b0458593          	addi	a1,a1,-1276 # 80008588 <etext+0x588>
    80004a8c:	fb040513          	addi	a0,s0,-80
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	64a080e7          	jalr	1610(ra) # 800030da <namecmp>
    80004a98:	14050063          	beqz	a0,80004bd8 <sys_unlink+0x1b0>
    80004a9c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a9e:	f2c40613          	addi	a2,s0,-212
    80004aa2:	fb040593          	addi	a1,s0,-80
    80004aa6:	8526                	mv	a0,s1
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	64c080e7          	jalr	1612(ra) # 800030f4 <dirlookup>
    80004ab0:	892a                	mv	s2,a0
    80004ab2:	12050263          	beqz	a0,80004bd6 <sys_unlink+0x1ae>
  ilock(ip);
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	13e080e7          	jalr	318(ra) # 80002bf4 <ilock>
  if(ip->nlink < 1)
    80004abe:	04a91783          	lh	a5,74(s2)
    80004ac2:	08f05563          	blez	a5,80004b4c <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ac6:	04491703          	lh	a4,68(s2)
    80004aca:	4785                	li	a5,1
    80004acc:	08f70963          	beq	a4,a5,80004b5e <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004ad0:	4641                	li	a2,16
    80004ad2:	4581                	li	a1,0
    80004ad4:	fc040513          	addi	a0,s0,-64
    80004ad8:	ffffb097          	auipc	ra,0xffffb
    80004adc:	6a2080e7          	jalr	1698(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ae0:	4741                	li	a4,16
    80004ae2:	f2c42683          	lw	a3,-212(s0)
    80004ae6:	fc040613          	addi	a2,s0,-64
    80004aea:	4581                	li	a1,0
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	4c2080e7          	jalr	1218(ra) # 80002fb0 <writei>
    80004af6:	47c1                	li	a5,16
    80004af8:	0af51b63          	bne	a0,a5,80004bae <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004afc:	04491703          	lh	a4,68(s2)
    80004b00:	4785                	li	a5,1
    80004b02:	0af70f63          	beq	a4,a5,80004bc0 <sys_unlink+0x198>
  iunlockput(dp);
    80004b06:	8526                	mv	a0,s1
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	352080e7          	jalr	850(ra) # 80002e5a <iunlockput>
  ip->nlink--;
    80004b10:	04a95783          	lhu	a5,74(s2)
    80004b14:	37fd                	addiw	a5,a5,-1
    80004b16:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b1a:	854a                	mv	a0,s2
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	00c080e7          	jalr	12(ra) # 80002b28 <iupdate>
  iunlockput(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	334080e7          	jalr	820(ra) # 80002e5a <iunlockput>
  end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	b12080e7          	jalr	-1262(ra) # 80003640 <end_op>
  return 0;
    80004b36:	4501                	li	a0,0
    80004b38:	64ee                	ld	s1,216(sp)
    80004b3a:	694e                	ld	s2,208(sp)
    80004b3c:	a84d                	j	80004bee <sys_unlink+0x1c6>
    end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	b02080e7          	jalr	-1278(ra) # 80003640 <end_op>
    return -1;
    80004b46:	557d                	li	a0,-1
    80004b48:	64ee                	ld	s1,216(sp)
    80004b4a:	a055                	j	80004bee <sys_unlink+0x1c6>
    80004b4c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b4e:	00004517          	auipc	a0,0x4
    80004b52:	a6250513          	addi	a0,a0,-1438 # 800085b0 <etext+0x5b0>
    80004b56:	00001097          	auipc	ra,0x1
    80004b5a:	29c080e7          	jalr	668(ra) # 80005df2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b5e:	04c92703          	lw	a4,76(s2)
    80004b62:	02000793          	li	a5,32
    80004b66:	f6e7f5e3          	bgeu	a5,a4,80004ad0 <sys_unlink+0xa8>
    80004b6a:	e5ce                	sd	s3,200(sp)
    80004b6c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b70:	4741                	li	a4,16
    80004b72:	86ce                	mv	a3,s3
    80004b74:	f1840613          	addi	a2,s0,-232
    80004b78:	4581                	li	a1,0
    80004b7a:	854a                	mv	a0,s2
    80004b7c:	ffffe097          	auipc	ra,0xffffe
    80004b80:	330080e7          	jalr	816(ra) # 80002eac <readi>
    80004b84:	47c1                	li	a5,16
    80004b86:	00f51c63          	bne	a0,a5,80004b9e <sys_unlink+0x176>
    if(de.inum != 0)
    80004b8a:	f1845783          	lhu	a5,-232(s0)
    80004b8e:	e7b5                	bnez	a5,80004bfa <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b90:	29c1                	addiw	s3,s3,16
    80004b92:	04c92783          	lw	a5,76(s2)
    80004b96:	fcf9ede3          	bltu	s3,a5,80004b70 <sys_unlink+0x148>
    80004b9a:	69ae                	ld	s3,200(sp)
    80004b9c:	bf15                	j	80004ad0 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004b9e:	00004517          	auipc	a0,0x4
    80004ba2:	a2a50513          	addi	a0,a0,-1494 # 800085c8 <etext+0x5c8>
    80004ba6:	00001097          	auipc	ra,0x1
    80004baa:	24c080e7          	jalr	588(ra) # 80005df2 <panic>
    80004bae:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bb0:	00004517          	auipc	a0,0x4
    80004bb4:	a3050513          	addi	a0,a0,-1488 # 800085e0 <etext+0x5e0>
    80004bb8:	00001097          	auipc	ra,0x1
    80004bbc:	23a080e7          	jalr	570(ra) # 80005df2 <panic>
    dp->nlink--;
    80004bc0:	04a4d783          	lhu	a5,74(s1)
    80004bc4:	37fd                	addiw	a5,a5,-1
    80004bc6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	f5c080e7          	jalr	-164(ra) # 80002b28 <iupdate>
    80004bd4:	bf0d                	j	80004b06 <sys_unlink+0xde>
    80004bd6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	280080e7          	jalr	640(ra) # 80002e5a <iunlockput>
  end_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	a5e080e7          	jalr	-1442(ra) # 80003640 <end_op>
  return -1;
    80004bea:	557d                	li	a0,-1
    80004bec:	64ee                	ld	s1,216(sp)
}
    80004bee:	70ae                	ld	ra,232(sp)
    80004bf0:	740e                	ld	s0,224(sp)
    80004bf2:	616d                	addi	sp,sp,240
    80004bf4:	8082                	ret
    return -1;
    80004bf6:	557d                	li	a0,-1
    80004bf8:	bfdd                	j	80004bee <sys_unlink+0x1c6>
    iunlockput(ip);
    80004bfa:	854a                	mv	a0,s2
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	25e080e7          	jalr	606(ra) # 80002e5a <iunlockput>
    goto bad;
    80004c04:	694e                	ld	s2,208(sp)
    80004c06:	69ae                	ld	s3,200(sp)
    80004c08:	bfc1                	j	80004bd8 <sys_unlink+0x1b0>

0000000080004c0a <sys_open>:

uint64
sys_open(void)
{
    80004c0a:	7131                	addi	sp,sp,-192
    80004c0c:	fd06                	sd	ra,184(sp)
    80004c0e:	f922                	sd	s0,176(sp)
    80004c10:	f526                	sd	s1,168(sp)
    80004c12:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c14:	08000613          	li	a2,128
    80004c18:	f5040593          	addi	a1,s0,-176
    80004c1c:	4501                	li	a0,0
    80004c1e:	ffffd097          	auipc	ra,0xffffd
    80004c22:	3f2080e7          	jalr	1010(ra) # 80002010 <argstr>
    return -1;
    80004c26:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c28:	0c054463          	bltz	a0,80004cf0 <sys_open+0xe6>
    80004c2c:	f4c40593          	addi	a1,s0,-180
    80004c30:	4505                	li	a0,1
    80004c32:	ffffd097          	auipc	ra,0xffffd
    80004c36:	39a080e7          	jalr	922(ra) # 80001fcc <argint>
    80004c3a:	0a054b63          	bltz	a0,80004cf0 <sys_open+0xe6>
    80004c3e:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	986080e7          	jalr	-1658(ra) # 800035c6 <begin_op>

  if(omode & O_CREATE){
    80004c48:	f4c42783          	lw	a5,-180(s0)
    80004c4c:	2007f793          	andi	a5,a5,512
    80004c50:	cfc5                	beqz	a5,80004d08 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c52:	4681                	li	a3,0
    80004c54:	4601                	li	a2,0
    80004c56:	4589                	li	a1,2
    80004c58:	f5040513          	addi	a0,s0,-176
    80004c5c:	00000097          	auipc	ra,0x0
    80004c60:	958080e7          	jalr	-1704(ra) # 800045b4 <create>
    80004c64:	892a                	mv	s2,a0
    if(ip == 0){
    80004c66:	c959                	beqz	a0,80004cfc <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c68:	04491703          	lh	a4,68(s2)
    80004c6c:	478d                	li	a5,3
    80004c6e:	00f71763          	bne	a4,a5,80004c7c <sys_open+0x72>
    80004c72:	04695703          	lhu	a4,70(s2)
    80004c76:	47a5                	li	a5,9
    80004c78:	0ce7ef63          	bltu	a5,a4,80004d56 <sys_open+0x14c>
    80004c7c:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	d56080e7          	jalr	-682(ra) # 800039d4 <filealloc>
    80004c86:	89aa                	mv	s3,a0
    80004c88:	c965                	beqz	a0,80004d78 <sys_open+0x16e>
    80004c8a:	00000097          	auipc	ra,0x0
    80004c8e:	8e8080e7          	jalr	-1816(ra) # 80004572 <fdalloc>
    80004c92:	84aa                	mv	s1,a0
    80004c94:	0c054d63          	bltz	a0,80004d6e <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c98:	04491703          	lh	a4,68(s2)
    80004c9c:	478d                	li	a5,3
    80004c9e:	0ef70a63          	beq	a4,a5,80004d92 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ca2:	4789                	li	a5,2
    80004ca4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ca8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cac:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cb0:	f4c42783          	lw	a5,-180(s0)
    80004cb4:	0017c713          	xori	a4,a5,1
    80004cb8:	8b05                	andi	a4,a4,1
    80004cba:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cbe:	0037f713          	andi	a4,a5,3
    80004cc2:	00e03733          	snez	a4,a4
    80004cc6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cca:	4007f793          	andi	a5,a5,1024
    80004cce:	c791                	beqz	a5,80004cda <sys_open+0xd0>
    80004cd0:	04491703          	lh	a4,68(s2)
    80004cd4:	4789                	li	a5,2
    80004cd6:	0cf70563          	beq	a4,a5,80004da0 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004cda:	854a                	mv	a0,s2
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	fde080e7          	jalr	-34(ra) # 80002cba <iunlock>
  end_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	95c080e7          	jalr	-1700(ra) # 80003640 <end_op>
    80004cec:	790a                	ld	s2,160(sp)
    80004cee:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004cf0:	8526                	mv	a0,s1
    80004cf2:	70ea                	ld	ra,184(sp)
    80004cf4:	744a                	ld	s0,176(sp)
    80004cf6:	74aa                	ld	s1,168(sp)
    80004cf8:	6129                	addi	sp,sp,192
    80004cfa:	8082                	ret
      end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	944080e7          	jalr	-1724(ra) # 80003640 <end_op>
      return -1;
    80004d04:	790a                	ld	s2,160(sp)
    80004d06:	b7ed                	j	80004cf0 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d08:	f5040513          	addi	a0,s0,-176
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	6ba080e7          	jalr	1722(ra) # 800033c6 <namei>
    80004d14:	892a                	mv	s2,a0
    80004d16:	c90d                	beqz	a0,80004d48 <sys_open+0x13e>
    ilock(ip);
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	edc080e7          	jalr	-292(ra) # 80002bf4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d20:	04491703          	lh	a4,68(s2)
    80004d24:	4785                	li	a5,1
    80004d26:	f4f711e3          	bne	a4,a5,80004c68 <sys_open+0x5e>
    80004d2a:	f4c42783          	lw	a5,-180(s0)
    80004d2e:	d7b9                	beqz	a5,80004c7c <sys_open+0x72>
      iunlockput(ip);
    80004d30:	854a                	mv	a0,s2
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	128080e7          	jalr	296(ra) # 80002e5a <iunlockput>
      end_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	906080e7          	jalr	-1786(ra) # 80003640 <end_op>
      return -1;
    80004d42:	54fd                	li	s1,-1
    80004d44:	790a                	ld	s2,160(sp)
    80004d46:	b76d                	j	80004cf0 <sys_open+0xe6>
      end_op();
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	8f8080e7          	jalr	-1800(ra) # 80003640 <end_op>
      return -1;
    80004d50:	54fd                	li	s1,-1
    80004d52:	790a                	ld	s2,160(sp)
    80004d54:	bf71                	j	80004cf0 <sys_open+0xe6>
    iunlockput(ip);
    80004d56:	854a                	mv	a0,s2
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	102080e7          	jalr	258(ra) # 80002e5a <iunlockput>
    end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	8e0080e7          	jalr	-1824(ra) # 80003640 <end_op>
    return -1;
    80004d68:	54fd                	li	s1,-1
    80004d6a:	790a                	ld	s2,160(sp)
    80004d6c:	b751                	j	80004cf0 <sys_open+0xe6>
      fileclose(f);
    80004d6e:	854e                	mv	a0,s3
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	d20080e7          	jalr	-736(ra) # 80003a90 <fileclose>
    iunlockput(ip);
    80004d78:	854a                	mv	a0,s2
    80004d7a:	ffffe097          	auipc	ra,0xffffe
    80004d7e:	0e0080e7          	jalr	224(ra) # 80002e5a <iunlockput>
    end_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	8be080e7          	jalr	-1858(ra) # 80003640 <end_op>
    return -1;
    80004d8a:	54fd                	li	s1,-1
    80004d8c:	790a                	ld	s2,160(sp)
    80004d8e:	69ea                	ld	s3,152(sp)
    80004d90:	b785                	j	80004cf0 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004d92:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d96:	04691783          	lh	a5,70(s2)
    80004d9a:	02f99223          	sh	a5,36(s3)
    80004d9e:	b739                	j	80004cac <sys_open+0xa2>
    itrunc(ip);
    80004da0:	854a                	mv	a0,s2
    80004da2:	ffffe097          	auipc	ra,0xffffe
    80004da6:	f64080e7          	jalr	-156(ra) # 80002d06 <itrunc>
    80004daa:	bf05                	j	80004cda <sys_open+0xd0>

0000000080004dac <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dac:	7175                	addi	sp,sp,-144
    80004dae:	e506                	sd	ra,136(sp)
    80004db0:	e122                	sd	s0,128(sp)
    80004db2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	812080e7          	jalr	-2030(ra) # 800035c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dbc:	08000613          	li	a2,128
    80004dc0:	f7040593          	addi	a1,s0,-144
    80004dc4:	4501                	li	a0,0
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	24a080e7          	jalr	586(ra) # 80002010 <argstr>
    80004dce:	02054963          	bltz	a0,80004e00 <sys_mkdir+0x54>
    80004dd2:	4681                	li	a3,0
    80004dd4:	4601                	li	a2,0
    80004dd6:	4585                	li	a1,1
    80004dd8:	f7040513          	addi	a0,s0,-144
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	7d8080e7          	jalr	2008(ra) # 800045b4 <create>
    80004de4:	cd11                	beqz	a0,80004e00 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	074080e7          	jalr	116(ra) # 80002e5a <iunlockput>
  end_op();
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	852080e7          	jalr	-1966(ra) # 80003640 <end_op>
  return 0;
    80004df6:	4501                	li	a0,0
}
    80004df8:	60aa                	ld	ra,136(sp)
    80004dfa:	640a                	ld	s0,128(sp)
    80004dfc:	6149                	addi	sp,sp,144
    80004dfe:	8082                	ret
    end_op();
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	840080e7          	jalr	-1984(ra) # 80003640 <end_op>
    return -1;
    80004e08:	557d                	li	a0,-1
    80004e0a:	b7fd                	j	80004df8 <sys_mkdir+0x4c>

0000000080004e0c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e0c:	7135                	addi	sp,sp,-160
    80004e0e:	ed06                	sd	ra,152(sp)
    80004e10:	e922                	sd	s0,144(sp)
    80004e12:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	7b2080e7          	jalr	1970(ra) # 800035c6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e1c:	08000613          	li	a2,128
    80004e20:	f7040593          	addi	a1,s0,-144
    80004e24:	4501                	li	a0,0
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	1ea080e7          	jalr	490(ra) # 80002010 <argstr>
    80004e2e:	04054a63          	bltz	a0,80004e82 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e32:	f6c40593          	addi	a1,s0,-148
    80004e36:	4505                	li	a0,1
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	194080e7          	jalr	404(ra) # 80001fcc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e40:	04054163          	bltz	a0,80004e82 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e44:	f6840593          	addi	a1,s0,-152
    80004e48:	4509                	li	a0,2
    80004e4a:	ffffd097          	auipc	ra,0xffffd
    80004e4e:	182080e7          	jalr	386(ra) # 80001fcc <argint>
     argint(1, &major) < 0 ||
    80004e52:	02054863          	bltz	a0,80004e82 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e56:	f6841683          	lh	a3,-152(s0)
    80004e5a:	f6c41603          	lh	a2,-148(s0)
    80004e5e:	458d                	li	a1,3
    80004e60:	f7040513          	addi	a0,s0,-144
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	750080e7          	jalr	1872(ra) # 800045b4 <create>
     argint(2, &minor) < 0 ||
    80004e6c:	c919                	beqz	a0,80004e82 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	fec080e7          	jalr	-20(ra) # 80002e5a <iunlockput>
  end_op();
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	7ca080e7          	jalr	1994(ra) # 80003640 <end_op>
  return 0;
    80004e7e:	4501                	li	a0,0
    80004e80:	a031                	j	80004e8c <sys_mknod+0x80>
    end_op();
    80004e82:	ffffe097          	auipc	ra,0xffffe
    80004e86:	7be080e7          	jalr	1982(ra) # 80003640 <end_op>
    return -1;
    80004e8a:	557d                	li	a0,-1
}
    80004e8c:	60ea                	ld	ra,152(sp)
    80004e8e:	644a                	ld	s0,144(sp)
    80004e90:	610d                	addi	sp,sp,160
    80004e92:	8082                	ret

0000000080004e94 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e94:	7135                	addi	sp,sp,-160
    80004e96:	ed06                	sd	ra,152(sp)
    80004e98:	e922                	sd	s0,144(sp)
    80004e9a:	e14a                	sd	s2,128(sp)
    80004e9c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e9e:	ffffc097          	auipc	ra,0xffffc
    80004ea2:	fde080e7          	jalr	-34(ra) # 80000e7c <myproc>
    80004ea6:	892a                	mv	s2,a0
  
  begin_op();
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	71e080e7          	jalr	1822(ra) # 800035c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eb0:	08000613          	li	a2,128
    80004eb4:	f6040593          	addi	a1,s0,-160
    80004eb8:	4501                	li	a0,0
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	156080e7          	jalr	342(ra) # 80002010 <argstr>
    80004ec2:	04054d63          	bltz	a0,80004f1c <sys_chdir+0x88>
    80004ec6:	e526                	sd	s1,136(sp)
    80004ec8:	f6040513          	addi	a0,s0,-160
    80004ecc:	ffffe097          	auipc	ra,0xffffe
    80004ed0:	4fa080e7          	jalr	1274(ra) # 800033c6 <namei>
    80004ed4:	84aa                	mv	s1,a0
    80004ed6:	c131                	beqz	a0,80004f1a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	d1c080e7          	jalr	-740(ra) # 80002bf4 <ilock>
  if(ip->type != T_DIR){
    80004ee0:	04449703          	lh	a4,68(s1)
    80004ee4:	4785                	li	a5,1
    80004ee6:	04f71163          	bne	a4,a5,80004f28 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eea:	8526                	mv	a0,s1
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	dce080e7          	jalr	-562(ra) # 80002cba <iunlock>
  iput(p->cwd);
    80004ef4:	15093503          	ld	a0,336(s2)
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	eba080e7          	jalr	-326(ra) # 80002db2 <iput>
  end_op();
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	740080e7          	jalr	1856(ra) # 80003640 <end_op>
  p->cwd = ip;
    80004f08:	14993823          	sd	s1,336(s2)
  return 0;
    80004f0c:	4501                	li	a0,0
    80004f0e:	64aa                	ld	s1,136(sp)
}
    80004f10:	60ea                	ld	ra,152(sp)
    80004f12:	644a                	ld	s0,144(sp)
    80004f14:	690a                	ld	s2,128(sp)
    80004f16:	610d                	addi	sp,sp,160
    80004f18:	8082                	ret
    80004f1a:	64aa                	ld	s1,136(sp)
    end_op();
    80004f1c:	ffffe097          	auipc	ra,0xffffe
    80004f20:	724080e7          	jalr	1828(ra) # 80003640 <end_op>
    return -1;
    80004f24:	557d                	li	a0,-1
    80004f26:	b7ed                	j	80004f10 <sys_chdir+0x7c>
    iunlockput(ip);
    80004f28:	8526                	mv	a0,s1
    80004f2a:	ffffe097          	auipc	ra,0xffffe
    80004f2e:	f30080e7          	jalr	-208(ra) # 80002e5a <iunlockput>
    end_op();
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	70e080e7          	jalr	1806(ra) # 80003640 <end_op>
    return -1;
    80004f3a:	557d                	li	a0,-1
    80004f3c:	64aa                	ld	s1,136(sp)
    80004f3e:	bfc9                	j	80004f10 <sys_chdir+0x7c>

0000000080004f40 <sys_exec>:

uint64
sys_exec(void)
{
    80004f40:	7121                	addi	sp,sp,-448
    80004f42:	ff06                	sd	ra,440(sp)
    80004f44:	fb22                	sd	s0,432(sp)
    80004f46:	f34a                	sd	s2,416(sp)
    80004f48:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f4a:	08000613          	li	a2,128
    80004f4e:	f5040593          	addi	a1,s0,-176
    80004f52:	4501                	li	a0,0
    80004f54:	ffffd097          	auipc	ra,0xffffd
    80004f58:	0bc080e7          	jalr	188(ra) # 80002010 <argstr>
    return -1;
    80004f5c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f5e:	0e054a63          	bltz	a0,80005052 <sys_exec+0x112>
    80004f62:	e4840593          	addi	a1,s0,-440
    80004f66:	4505                	li	a0,1
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	086080e7          	jalr	134(ra) # 80001fee <argaddr>
    80004f70:	0e054163          	bltz	a0,80005052 <sys_exec+0x112>
    80004f74:	f726                	sd	s1,424(sp)
    80004f76:	ef4e                	sd	s3,408(sp)
    80004f78:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f7a:	10000613          	li	a2,256
    80004f7e:	4581                	li	a1,0
    80004f80:	e5040513          	addi	a0,s0,-432
    80004f84:	ffffb097          	auipc	ra,0xffffb
    80004f88:	1f6080e7          	jalr	502(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f8c:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f90:	89a6                	mv	s3,s1
    80004f92:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f94:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f98:	00391513          	slli	a0,s2,0x3
    80004f9c:	e4040593          	addi	a1,s0,-448
    80004fa0:	e4843783          	ld	a5,-440(s0)
    80004fa4:	953e                	add	a0,a0,a5
    80004fa6:	ffffd097          	auipc	ra,0xffffd
    80004faa:	f8c080e7          	jalr	-116(ra) # 80001f32 <fetchaddr>
    80004fae:	02054a63          	bltz	a0,80004fe2 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004fb2:	e4043783          	ld	a5,-448(s0)
    80004fb6:	c7b1                	beqz	a5,80005002 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fb8:	ffffb097          	auipc	ra,0xffffb
    80004fbc:	162080e7          	jalr	354(ra) # 8000011a <kalloc>
    80004fc0:	85aa                	mv	a1,a0
    80004fc2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fc6:	cd11                	beqz	a0,80004fe2 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fc8:	6605                	lui	a2,0x1
    80004fca:	e4043503          	ld	a0,-448(s0)
    80004fce:	ffffd097          	auipc	ra,0xffffd
    80004fd2:	fb6080e7          	jalr	-74(ra) # 80001f84 <fetchstr>
    80004fd6:	00054663          	bltz	a0,80004fe2 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004fda:	0905                	addi	s2,s2,1
    80004fdc:	09a1                	addi	s3,s3,8
    80004fde:	fb491de3          	bne	s2,s4,80004f98 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe2:	f5040913          	addi	s2,s0,-176
    80004fe6:	6088                	ld	a0,0(s1)
    80004fe8:	c12d                	beqz	a0,8000504a <sys_exec+0x10a>
    kfree(argv[i]);
    80004fea:	ffffb097          	auipc	ra,0xffffb
    80004fee:	032080e7          	jalr	50(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff2:	04a1                	addi	s1,s1,8
    80004ff4:	ff2499e3          	bne	s1,s2,80004fe6 <sys_exec+0xa6>
  return -1;
    80004ff8:	597d                	li	s2,-1
    80004ffa:	74ba                	ld	s1,424(sp)
    80004ffc:	69fa                	ld	s3,408(sp)
    80004ffe:	6a5a                	ld	s4,400(sp)
    80005000:	a889                	j	80005052 <sys_exec+0x112>
      argv[i] = 0;
    80005002:	0009079b          	sext.w	a5,s2
    80005006:	078e                	slli	a5,a5,0x3
    80005008:	fd078793          	addi	a5,a5,-48
    8000500c:	97a2                	add	a5,a5,s0
    8000500e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005012:	e5040593          	addi	a1,s0,-432
    80005016:	f5040513          	addi	a0,s0,-176
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	126080e7          	jalr	294(ra) # 80004140 <exec>
    80005022:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005024:	f5040993          	addi	s3,s0,-176
    80005028:	6088                	ld	a0,0(s1)
    8000502a:	cd01                	beqz	a0,80005042 <sys_exec+0x102>
    kfree(argv[i]);
    8000502c:	ffffb097          	auipc	ra,0xffffb
    80005030:	ff0080e7          	jalr	-16(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005034:	04a1                	addi	s1,s1,8
    80005036:	ff3499e3          	bne	s1,s3,80005028 <sys_exec+0xe8>
    8000503a:	74ba                	ld	s1,424(sp)
    8000503c:	69fa                	ld	s3,408(sp)
    8000503e:	6a5a                	ld	s4,400(sp)
    80005040:	a809                	j	80005052 <sys_exec+0x112>
  return ret;
    80005042:	74ba                	ld	s1,424(sp)
    80005044:	69fa                	ld	s3,408(sp)
    80005046:	6a5a                	ld	s4,400(sp)
    80005048:	a029                	j	80005052 <sys_exec+0x112>
  return -1;
    8000504a:	597d                	li	s2,-1
    8000504c:	74ba                	ld	s1,424(sp)
    8000504e:	69fa                	ld	s3,408(sp)
    80005050:	6a5a                	ld	s4,400(sp)
}
    80005052:	854a                	mv	a0,s2
    80005054:	70fa                	ld	ra,440(sp)
    80005056:	745a                	ld	s0,432(sp)
    80005058:	791a                	ld	s2,416(sp)
    8000505a:	6139                	addi	sp,sp,448
    8000505c:	8082                	ret

000000008000505e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000505e:	7139                	addi	sp,sp,-64
    80005060:	fc06                	sd	ra,56(sp)
    80005062:	f822                	sd	s0,48(sp)
    80005064:	f426                	sd	s1,40(sp)
    80005066:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	e14080e7          	jalr	-492(ra) # 80000e7c <myproc>
    80005070:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005072:	fd840593          	addi	a1,s0,-40
    80005076:	4501                	li	a0,0
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	f76080e7          	jalr	-138(ra) # 80001fee <argaddr>
    return -1;
    80005080:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005082:	0e054063          	bltz	a0,80005162 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005086:	fc840593          	addi	a1,s0,-56
    8000508a:	fd040513          	addi	a0,s0,-48
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	d70080e7          	jalr	-656(ra) # 80003dfe <pipealloc>
    return -1;
    80005096:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005098:	0c054563          	bltz	a0,80005162 <sys_pipe+0x104>
  fd0 = -1;
    8000509c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050a0:	fd043503          	ld	a0,-48(s0)
    800050a4:	fffff097          	auipc	ra,0xfffff
    800050a8:	4ce080e7          	jalr	1230(ra) # 80004572 <fdalloc>
    800050ac:	fca42223          	sw	a0,-60(s0)
    800050b0:	08054c63          	bltz	a0,80005148 <sys_pipe+0xea>
    800050b4:	fc843503          	ld	a0,-56(s0)
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	4ba080e7          	jalr	1210(ra) # 80004572 <fdalloc>
    800050c0:	fca42023          	sw	a0,-64(s0)
    800050c4:	06054963          	bltz	a0,80005136 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050c8:	4691                	li	a3,4
    800050ca:	fc440613          	addi	a2,s0,-60
    800050ce:	fd843583          	ld	a1,-40(s0)
    800050d2:	68a8                	ld	a0,80(s1)
    800050d4:	ffffc097          	auipc	ra,0xffffc
    800050d8:	a44080e7          	jalr	-1468(ra) # 80000b18 <copyout>
    800050dc:	02054063          	bltz	a0,800050fc <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050e0:	4691                	li	a3,4
    800050e2:	fc040613          	addi	a2,s0,-64
    800050e6:	fd843583          	ld	a1,-40(s0)
    800050ea:	0591                	addi	a1,a1,4
    800050ec:	68a8                	ld	a0,80(s1)
    800050ee:	ffffc097          	auipc	ra,0xffffc
    800050f2:	a2a080e7          	jalr	-1494(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050f6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050f8:	06055563          	bgez	a0,80005162 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050fc:	fc442783          	lw	a5,-60(s0)
    80005100:	07e9                	addi	a5,a5,26
    80005102:	078e                	slli	a5,a5,0x3
    80005104:	97a6                	add	a5,a5,s1
    80005106:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000510a:	fc042783          	lw	a5,-64(s0)
    8000510e:	07e9                	addi	a5,a5,26
    80005110:	078e                	slli	a5,a5,0x3
    80005112:	00f48533          	add	a0,s1,a5
    80005116:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000511a:	fd043503          	ld	a0,-48(s0)
    8000511e:	fffff097          	auipc	ra,0xfffff
    80005122:	972080e7          	jalr	-1678(ra) # 80003a90 <fileclose>
    fileclose(wf);
    80005126:	fc843503          	ld	a0,-56(s0)
    8000512a:	fffff097          	auipc	ra,0xfffff
    8000512e:	966080e7          	jalr	-1690(ra) # 80003a90 <fileclose>
    return -1;
    80005132:	57fd                	li	a5,-1
    80005134:	a03d                	j	80005162 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005136:	fc442783          	lw	a5,-60(s0)
    8000513a:	0007c763          	bltz	a5,80005148 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000513e:	07e9                	addi	a5,a5,26
    80005140:	078e                	slli	a5,a5,0x3
    80005142:	97a6                	add	a5,a5,s1
    80005144:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005148:	fd043503          	ld	a0,-48(s0)
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	944080e7          	jalr	-1724(ra) # 80003a90 <fileclose>
    fileclose(wf);
    80005154:	fc843503          	ld	a0,-56(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	938080e7          	jalr	-1736(ra) # 80003a90 <fileclose>
    return -1;
    80005160:	57fd                	li	a5,-1
}
    80005162:	853e                	mv	a0,a5
    80005164:	70e2                	ld	ra,56(sp)
    80005166:	7442                	ld	s0,48(sp)
    80005168:	74a2                	ld	s1,40(sp)
    8000516a:	6121                	addi	sp,sp,64
    8000516c:	8082                	ret
	...

0000000080005170 <kernelvec>:
    80005170:	7111                	addi	sp,sp,-256
    80005172:	e006                	sd	ra,0(sp)
    80005174:	e40a                	sd	sp,8(sp)
    80005176:	e80e                	sd	gp,16(sp)
    80005178:	ec12                	sd	tp,24(sp)
    8000517a:	f016                	sd	t0,32(sp)
    8000517c:	f41a                	sd	t1,40(sp)
    8000517e:	f81e                	sd	t2,48(sp)
    80005180:	fc22                	sd	s0,56(sp)
    80005182:	e0a6                	sd	s1,64(sp)
    80005184:	e4aa                	sd	a0,72(sp)
    80005186:	e8ae                	sd	a1,80(sp)
    80005188:	ecb2                	sd	a2,88(sp)
    8000518a:	f0b6                	sd	a3,96(sp)
    8000518c:	f4ba                	sd	a4,104(sp)
    8000518e:	f8be                	sd	a5,112(sp)
    80005190:	fcc2                	sd	a6,120(sp)
    80005192:	e146                	sd	a7,128(sp)
    80005194:	e54a                	sd	s2,136(sp)
    80005196:	e94e                	sd	s3,144(sp)
    80005198:	ed52                	sd	s4,152(sp)
    8000519a:	f156                	sd	s5,160(sp)
    8000519c:	f55a                	sd	s6,168(sp)
    8000519e:	f95e                	sd	s7,176(sp)
    800051a0:	fd62                	sd	s8,184(sp)
    800051a2:	e1e6                	sd	s9,192(sp)
    800051a4:	e5ea                	sd	s10,200(sp)
    800051a6:	e9ee                	sd	s11,208(sp)
    800051a8:	edf2                	sd	t3,216(sp)
    800051aa:	f1f6                	sd	t4,224(sp)
    800051ac:	f5fa                	sd	t5,232(sp)
    800051ae:	f9fe                	sd	t6,240(sp)
    800051b0:	c4ffc0ef          	jal	80001dfe <kerneltrap>
    800051b4:	6082                	ld	ra,0(sp)
    800051b6:	6122                	ld	sp,8(sp)
    800051b8:	61c2                	ld	gp,16(sp)
    800051ba:	7282                	ld	t0,32(sp)
    800051bc:	7322                	ld	t1,40(sp)
    800051be:	73c2                	ld	t2,48(sp)
    800051c0:	7462                	ld	s0,56(sp)
    800051c2:	6486                	ld	s1,64(sp)
    800051c4:	6526                	ld	a0,72(sp)
    800051c6:	65c6                	ld	a1,80(sp)
    800051c8:	6666                	ld	a2,88(sp)
    800051ca:	7686                	ld	a3,96(sp)
    800051cc:	7726                	ld	a4,104(sp)
    800051ce:	77c6                	ld	a5,112(sp)
    800051d0:	7866                	ld	a6,120(sp)
    800051d2:	688a                	ld	a7,128(sp)
    800051d4:	692a                	ld	s2,136(sp)
    800051d6:	69ca                	ld	s3,144(sp)
    800051d8:	6a6a                	ld	s4,152(sp)
    800051da:	7a8a                	ld	s5,160(sp)
    800051dc:	7b2a                	ld	s6,168(sp)
    800051de:	7bca                	ld	s7,176(sp)
    800051e0:	7c6a                	ld	s8,184(sp)
    800051e2:	6c8e                	ld	s9,192(sp)
    800051e4:	6d2e                	ld	s10,200(sp)
    800051e6:	6dce                	ld	s11,208(sp)
    800051e8:	6e6e                	ld	t3,216(sp)
    800051ea:	7e8e                	ld	t4,224(sp)
    800051ec:	7f2e                	ld	t5,232(sp)
    800051ee:	7fce                	ld	t6,240(sp)
    800051f0:	6111                	addi	sp,sp,256
    800051f2:	10200073          	sret
    800051f6:	00000013          	nop
    800051fa:	00000013          	nop
    800051fe:	0001                	nop

0000000080005200 <timervec>:
    80005200:	34051573          	csrrw	a0,mscratch,a0
    80005204:	e10c                	sd	a1,0(a0)
    80005206:	e510                	sd	a2,8(a0)
    80005208:	e914                	sd	a3,16(a0)
    8000520a:	6d0c                	ld	a1,24(a0)
    8000520c:	7110                	ld	a2,32(a0)
    8000520e:	6194                	ld	a3,0(a1)
    80005210:	96b2                	add	a3,a3,a2
    80005212:	e194                	sd	a3,0(a1)
    80005214:	4589                	li	a1,2
    80005216:	14459073          	csrw	sip,a1
    8000521a:	6914                	ld	a3,16(a0)
    8000521c:	6510                	ld	a2,8(a0)
    8000521e:	610c                	ld	a1,0(a0)
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	30200073          	mret
	...

000000008000522a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000522a:	1141                	addi	sp,sp,-16
    8000522c:	e422                	sd	s0,8(sp)
    8000522e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005230:	0c0007b7          	lui	a5,0xc000
    80005234:	4705                	li	a4,1
    80005236:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005238:	0c0007b7          	lui	a5,0xc000
    8000523c:	c3d8                	sw	a4,4(a5)
}
    8000523e:	6422                	ld	s0,8(sp)
    80005240:	0141                	addi	sp,sp,16
    80005242:	8082                	ret

0000000080005244 <plicinithart>:

void
plicinithart(void)
{
    80005244:	1141                	addi	sp,sp,-16
    80005246:	e406                	sd	ra,8(sp)
    80005248:	e022                	sd	s0,0(sp)
    8000524a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000524c:	ffffc097          	auipc	ra,0xffffc
    80005250:	c04080e7          	jalr	-1020(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005254:	0085171b          	slliw	a4,a0,0x8
    80005258:	0c0027b7          	lui	a5,0xc002
    8000525c:	97ba                	add	a5,a5,a4
    8000525e:	40200713          	li	a4,1026
    80005262:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005266:	00d5151b          	slliw	a0,a0,0xd
    8000526a:	0c2017b7          	lui	a5,0xc201
    8000526e:	97aa                	add	a5,a5,a0
    80005270:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005274:	60a2                	ld	ra,8(sp)
    80005276:	6402                	ld	s0,0(sp)
    80005278:	0141                	addi	sp,sp,16
    8000527a:	8082                	ret

000000008000527c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000527c:	1141                	addi	sp,sp,-16
    8000527e:	e406                	sd	ra,8(sp)
    80005280:	e022                	sd	s0,0(sp)
    80005282:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005284:	ffffc097          	auipc	ra,0xffffc
    80005288:	bcc080e7          	jalr	-1076(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000528c:	00d5151b          	slliw	a0,a0,0xd
    80005290:	0c2017b7          	lui	a5,0xc201
    80005294:	97aa                	add	a5,a5,a0
  return irq;
}
    80005296:	43c8                	lw	a0,4(a5)
    80005298:	60a2                	ld	ra,8(sp)
    8000529a:	6402                	ld	s0,0(sp)
    8000529c:	0141                	addi	sp,sp,16
    8000529e:	8082                	ret

00000000800052a0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052a0:	1101                	addi	sp,sp,-32
    800052a2:	ec06                	sd	ra,24(sp)
    800052a4:	e822                	sd	s0,16(sp)
    800052a6:	e426                	sd	s1,8(sp)
    800052a8:	1000                	addi	s0,sp,32
    800052aa:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052ac:	ffffc097          	auipc	ra,0xffffc
    800052b0:	ba4080e7          	jalr	-1116(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052b4:	00d5151b          	slliw	a0,a0,0xd
    800052b8:	0c2017b7          	lui	a5,0xc201
    800052bc:	97aa                	add	a5,a5,a0
    800052be:	c3c4                	sw	s1,4(a5)
}
    800052c0:	60e2                	ld	ra,24(sp)
    800052c2:	6442                	ld	s0,16(sp)
    800052c4:	64a2                	ld	s1,8(sp)
    800052c6:	6105                	addi	sp,sp,32
    800052c8:	8082                	ret

00000000800052ca <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052ca:	1141                	addi	sp,sp,-16
    800052cc:	e406                	sd	ra,8(sp)
    800052ce:	e022                	sd	s0,0(sp)
    800052d0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052d2:	479d                	li	a5,7
    800052d4:	06a7c863          	blt	a5,a0,80005344 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800052d8:	00019717          	auipc	a4,0x19
    800052dc:	d2870713          	addi	a4,a4,-728 # 8001e000 <disk>
    800052e0:	972a                	add	a4,a4,a0
    800052e2:	6789                	lui	a5,0x2
    800052e4:	97ba                	add	a5,a5,a4
    800052e6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052ea:	e7ad                	bnez	a5,80005354 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052ec:	00451793          	slli	a5,a0,0x4
    800052f0:	0001b717          	auipc	a4,0x1b
    800052f4:	d1070713          	addi	a4,a4,-752 # 80020000 <disk+0x2000>
    800052f8:	6314                	ld	a3,0(a4)
    800052fa:	96be                	add	a3,a3,a5
    800052fc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005300:	6314                	ld	a3,0(a4)
    80005302:	96be                	add	a3,a3,a5
    80005304:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005308:	6314                	ld	a3,0(a4)
    8000530a:	96be                	add	a3,a3,a5
    8000530c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005310:	6318                	ld	a4,0(a4)
    80005312:	97ba                	add	a5,a5,a4
    80005314:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005318:	00019717          	auipc	a4,0x19
    8000531c:	ce870713          	addi	a4,a4,-792 # 8001e000 <disk>
    80005320:	972a                	add	a4,a4,a0
    80005322:	6789                	lui	a5,0x2
    80005324:	97ba                	add	a5,a5,a4
    80005326:	4705                	li	a4,1
    80005328:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000532c:	0001b517          	auipc	a0,0x1b
    80005330:	cec50513          	addi	a0,a0,-788 # 80020018 <disk+0x2018>
    80005334:	ffffc097          	auipc	ra,0xffffc
    80005338:	3e4080e7          	jalr	996(ra) # 80001718 <wakeup>
}
    8000533c:	60a2                	ld	ra,8(sp)
    8000533e:	6402                	ld	s0,0(sp)
    80005340:	0141                	addi	sp,sp,16
    80005342:	8082                	ret
    panic("free_desc 1");
    80005344:	00003517          	auipc	a0,0x3
    80005348:	2ac50513          	addi	a0,a0,684 # 800085f0 <etext+0x5f0>
    8000534c:	00001097          	auipc	ra,0x1
    80005350:	aa6080e7          	jalr	-1370(ra) # 80005df2 <panic>
    panic("free_desc 2");
    80005354:	00003517          	auipc	a0,0x3
    80005358:	2ac50513          	addi	a0,a0,684 # 80008600 <etext+0x600>
    8000535c:	00001097          	auipc	ra,0x1
    80005360:	a96080e7          	jalr	-1386(ra) # 80005df2 <panic>

0000000080005364 <virtio_disk_init>:
{
    80005364:	1141                	addi	sp,sp,-16
    80005366:	e406                	sd	ra,8(sp)
    80005368:	e022                	sd	s0,0(sp)
    8000536a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000536c:	00003597          	auipc	a1,0x3
    80005370:	2a458593          	addi	a1,a1,676 # 80008610 <etext+0x610>
    80005374:	0001b517          	auipc	a0,0x1b
    80005378:	db450513          	addi	a0,a0,-588 # 80020128 <disk+0x2128>
    8000537c:	00001097          	auipc	ra,0x1
    80005380:	f36080e7          	jalr	-202(ra) # 800062b2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005384:	100017b7          	lui	a5,0x10001
    80005388:	4398                	lw	a4,0(a5)
    8000538a:	2701                	sext.w	a4,a4
    8000538c:	747277b7          	lui	a5,0x74727
    80005390:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005394:	0ef71f63          	bne	a4,a5,80005492 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005398:	100017b7          	lui	a5,0x10001
    8000539c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000539e:	439c                	lw	a5,0(a5)
    800053a0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a2:	4705                	li	a4,1
    800053a4:	0ee79763          	bne	a5,a4,80005492 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053a8:	100017b7          	lui	a5,0x10001
    800053ac:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053ae:	439c                	lw	a5,0(a5)
    800053b0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053b2:	4709                	li	a4,2
    800053b4:	0ce79f63          	bne	a5,a4,80005492 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	47d8                	lw	a4,12(a5)
    800053be:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053c0:	554d47b7          	lui	a5,0x554d4
    800053c4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053c8:	0cf71563          	bne	a4,a5,80005492 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053cc:	100017b7          	lui	a5,0x10001
    800053d0:	4705                	li	a4,1
    800053d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d4:	470d                	li	a4,3
    800053d6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053d8:	10001737          	lui	a4,0x10001
    800053dc:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053de:	c7ffe737          	lui	a4,0xc7ffe
    800053e2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053e6:	8ef9                	and	a3,a3,a4
    800053e8:	10001737          	lui	a4,0x10001
    800053ec:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ee:	472d                	li	a4,11
    800053f0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f2:	473d                	li	a4,15
    800053f4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053f6:	100017b7          	lui	a5,0x10001
    800053fa:	6705                	lui	a4,0x1
    800053fc:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053fe:	100017b7          	lui	a5,0x10001
    80005402:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000540e:	439c                	lw	a5,0(a5)
    80005410:	2781                	sext.w	a5,a5
  if(max == 0)
    80005412:	cbc1                	beqz	a5,800054a2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005414:	471d                	li	a4,7
    80005416:	08f77e63          	bgeu	a4,a5,800054b2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000541a:	100017b7          	lui	a5,0x10001
    8000541e:	4721                	li	a4,8
    80005420:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005422:	6609                	lui	a2,0x2
    80005424:	4581                	li	a1,0
    80005426:	00019517          	auipc	a0,0x19
    8000542a:	bda50513          	addi	a0,a0,-1062 # 8001e000 <disk>
    8000542e:	ffffb097          	auipc	ra,0xffffb
    80005432:	d4c080e7          	jalr	-692(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005436:	00019697          	auipc	a3,0x19
    8000543a:	bca68693          	addi	a3,a3,-1078 # 8001e000 <disk>
    8000543e:	00c6d713          	srli	a4,a3,0xc
    80005442:	2701                	sext.w	a4,a4
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000544a:	0001b797          	auipc	a5,0x1b
    8000544e:	bb678793          	addi	a5,a5,-1098 # 80020000 <disk+0x2000>
    80005452:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005454:	00019717          	auipc	a4,0x19
    80005458:	c2c70713          	addi	a4,a4,-980 # 8001e080 <disk+0x80>
    8000545c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000545e:	0001a717          	auipc	a4,0x1a
    80005462:	ba270713          	addi	a4,a4,-1118 # 8001f000 <disk+0x1000>
    80005466:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005468:	4705                	li	a4,1
    8000546a:	00e78c23          	sb	a4,24(a5)
    8000546e:	00e78ca3          	sb	a4,25(a5)
    80005472:	00e78d23          	sb	a4,26(a5)
    80005476:	00e78da3          	sb	a4,27(a5)
    8000547a:	00e78e23          	sb	a4,28(a5)
    8000547e:	00e78ea3          	sb	a4,29(a5)
    80005482:	00e78f23          	sb	a4,30(a5)
    80005486:	00e78fa3          	sb	a4,31(a5)
}
    8000548a:	60a2                	ld	ra,8(sp)
    8000548c:	6402                	ld	s0,0(sp)
    8000548e:	0141                	addi	sp,sp,16
    80005490:	8082                	ret
    panic("could not find virtio disk");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	18e50513          	addi	a0,a0,398 # 80008620 <etext+0x620>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	958080e7          	jalr	-1704(ra) # 80005df2 <panic>
    panic("virtio disk has no queue 0");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	19e50513          	addi	a0,a0,414 # 80008640 <etext+0x640>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	948080e7          	jalr	-1720(ra) # 80005df2 <panic>
    panic("virtio disk max queue too short");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	1ae50513          	addi	a0,a0,430 # 80008660 <etext+0x660>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	938080e7          	jalr	-1736(ra) # 80005df2 <panic>

00000000800054c2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054c2:	7159                	addi	sp,sp,-112
    800054c4:	f486                	sd	ra,104(sp)
    800054c6:	f0a2                	sd	s0,96(sp)
    800054c8:	eca6                	sd	s1,88(sp)
    800054ca:	e8ca                	sd	s2,80(sp)
    800054cc:	e4ce                	sd	s3,72(sp)
    800054ce:	e0d2                	sd	s4,64(sp)
    800054d0:	fc56                	sd	s5,56(sp)
    800054d2:	f85a                	sd	s6,48(sp)
    800054d4:	f45e                	sd	s7,40(sp)
    800054d6:	f062                	sd	s8,32(sp)
    800054d8:	ec66                	sd	s9,24(sp)
    800054da:	1880                	addi	s0,sp,112
    800054dc:	8a2a                	mv	s4,a0
    800054de:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054e0:	00c52c03          	lw	s8,12(a0)
    800054e4:	001c1c1b          	slliw	s8,s8,0x1
    800054e8:	1c02                	slli	s8,s8,0x20
    800054ea:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800054ee:	0001b517          	auipc	a0,0x1b
    800054f2:	c3a50513          	addi	a0,a0,-966 # 80020128 <disk+0x2128>
    800054f6:	00001097          	auipc	ra,0x1
    800054fa:	e4c080e7          	jalr	-436(ra) # 80006342 <acquire>
  for(int i = 0; i < 3; i++){
    800054fe:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005500:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005502:	00019b97          	auipc	s7,0x19
    80005506:	afeb8b93          	addi	s7,s7,-1282 # 8001e000 <disk>
    8000550a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000550c:	4a8d                	li	s5,3
    8000550e:	a88d                	j	80005580 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005510:	00fb8733          	add	a4,s7,a5
    80005514:	975a                	add	a4,a4,s6
    80005516:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000551a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000551c:	0207c563          	bltz	a5,80005546 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005520:	2905                	addiw	s2,s2,1
    80005522:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005524:	1b590163          	beq	s2,s5,800056c6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005528:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000552a:	0001b717          	auipc	a4,0x1b
    8000552e:	aee70713          	addi	a4,a4,-1298 # 80020018 <disk+0x2018>
    80005532:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005534:	00074683          	lbu	a3,0(a4)
    80005538:	fee1                	bnez	a3,80005510 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000553a:	2785                	addiw	a5,a5,1
    8000553c:	0705                	addi	a4,a4,1
    8000553e:	fe979be3          	bne	a5,s1,80005534 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005542:	57fd                	li	a5,-1
    80005544:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005546:	03205163          	blez	s2,80005568 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000554a:	f9042503          	lw	a0,-112(s0)
    8000554e:	00000097          	auipc	ra,0x0
    80005552:	d7c080e7          	jalr	-644(ra) # 800052ca <free_desc>
      for(int j = 0; j < i; j++)
    80005556:	4785                	li	a5,1
    80005558:	0127d863          	bge	a5,s2,80005568 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000555c:	f9442503          	lw	a0,-108(s0)
    80005560:	00000097          	auipc	ra,0x0
    80005564:	d6a080e7          	jalr	-662(ra) # 800052ca <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005568:	0001b597          	auipc	a1,0x1b
    8000556c:	bc058593          	addi	a1,a1,-1088 # 80020128 <disk+0x2128>
    80005570:	0001b517          	auipc	a0,0x1b
    80005574:	aa850513          	addi	a0,a0,-1368 # 80020018 <disk+0x2018>
    80005578:	ffffc097          	auipc	ra,0xffffc
    8000557c:	014080e7          	jalr	20(ra) # 8000158c <sleep>
  for(int i = 0; i < 3; i++){
    80005580:	f9040613          	addi	a2,s0,-112
    80005584:	894e                	mv	s2,s3
    80005586:	b74d                	j	80005528 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005588:	0001b717          	auipc	a4,0x1b
    8000558c:	a7873703          	ld	a4,-1416(a4) # 80020000 <disk+0x2000>
    80005590:	973e                	add	a4,a4,a5
    80005592:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005596:	00019897          	auipc	a7,0x19
    8000559a:	a6a88893          	addi	a7,a7,-1430 # 8001e000 <disk>
    8000559e:	0001b717          	auipc	a4,0x1b
    800055a2:	a6270713          	addi	a4,a4,-1438 # 80020000 <disk+0x2000>
    800055a6:	6314                	ld	a3,0(a4)
    800055a8:	96be                	add	a3,a3,a5
    800055aa:	00c6d583          	lhu	a1,12(a3)
    800055ae:	0015e593          	ori	a1,a1,1
    800055b2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055b6:	f9842683          	lw	a3,-104(s0)
    800055ba:	630c                	ld	a1,0(a4)
    800055bc:	97ae                	add	a5,a5,a1
    800055be:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055c2:	20050593          	addi	a1,a0,512
    800055c6:	0592                	slli	a1,a1,0x4
    800055c8:	95c6                	add	a1,a1,a7
    800055ca:	57fd                	li	a5,-1
    800055cc:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055d0:	00469793          	slli	a5,a3,0x4
    800055d4:	00073803          	ld	a6,0(a4)
    800055d8:	983e                	add	a6,a6,a5
    800055da:	6689                	lui	a3,0x2
    800055dc:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800055e0:	96b2                	add	a3,a3,a2
    800055e2:	96c6                	add	a3,a3,a7
    800055e4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800055e8:	6314                	ld	a3,0(a4)
    800055ea:	96be                	add	a3,a3,a5
    800055ec:	4605                	li	a2,1
    800055ee:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055f0:	6314                	ld	a3,0(a4)
    800055f2:	96be                	add	a3,a3,a5
    800055f4:	4809                	li	a6,2
    800055f6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800055fa:	6314                	ld	a3,0(a4)
    800055fc:	97b6                	add	a5,a5,a3
    800055fe:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005602:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005606:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000560a:	6714                	ld	a3,8(a4)
    8000560c:	0026d783          	lhu	a5,2(a3)
    80005610:	8b9d                	andi	a5,a5,7
    80005612:	0786                	slli	a5,a5,0x1
    80005614:	96be                	add	a3,a3,a5
    80005616:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000561a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000561e:	6718                	ld	a4,8(a4)
    80005620:	00275783          	lhu	a5,2(a4)
    80005624:	2785                	addiw	a5,a5,1
    80005626:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000562a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000562e:	100017b7          	lui	a5,0x10001
    80005632:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005636:	004a2783          	lw	a5,4(s4)
    8000563a:	02c79163          	bne	a5,a2,8000565c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000563e:	0001b917          	auipc	s2,0x1b
    80005642:	aea90913          	addi	s2,s2,-1302 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005646:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005648:	85ca                	mv	a1,s2
    8000564a:	8552                	mv	a0,s4
    8000564c:	ffffc097          	auipc	ra,0xffffc
    80005650:	f40080e7          	jalr	-192(ra) # 8000158c <sleep>
  while(b->disk == 1) {
    80005654:	004a2783          	lw	a5,4(s4)
    80005658:	fe9788e3          	beq	a5,s1,80005648 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000565c:	f9042903          	lw	s2,-112(s0)
    80005660:	20090713          	addi	a4,s2,512
    80005664:	0712                	slli	a4,a4,0x4
    80005666:	00019797          	auipc	a5,0x19
    8000566a:	99a78793          	addi	a5,a5,-1638 # 8001e000 <disk>
    8000566e:	97ba                	add	a5,a5,a4
    80005670:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005674:	0001b997          	auipc	s3,0x1b
    80005678:	98c98993          	addi	s3,s3,-1652 # 80020000 <disk+0x2000>
    8000567c:	00491713          	slli	a4,s2,0x4
    80005680:	0009b783          	ld	a5,0(s3)
    80005684:	97ba                	add	a5,a5,a4
    80005686:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000568a:	854a                	mv	a0,s2
    8000568c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005690:	00000097          	auipc	ra,0x0
    80005694:	c3a080e7          	jalr	-966(ra) # 800052ca <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005698:	8885                	andi	s1,s1,1
    8000569a:	f0ed                	bnez	s1,8000567c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000569c:	0001b517          	auipc	a0,0x1b
    800056a0:	a8c50513          	addi	a0,a0,-1396 # 80020128 <disk+0x2128>
    800056a4:	00001097          	auipc	ra,0x1
    800056a8:	d52080e7          	jalr	-686(ra) # 800063f6 <release>
}
    800056ac:	70a6                	ld	ra,104(sp)
    800056ae:	7406                	ld	s0,96(sp)
    800056b0:	64e6                	ld	s1,88(sp)
    800056b2:	6946                	ld	s2,80(sp)
    800056b4:	69a6                	ld	s3,72(sp)
    800056b6:	6a06                	ld	s4,64(sp)
    800056b8:	7ae2                	ld	s5,56(sp)
    800056ba:	7b42                	ld	s6,48(sp)
    800056bc:	7ba2                	ld	s7,40(sp)
    800056be:	7c02                	ld	s8,32(sp)
    800056c0:	6ce2                	ld	s9,24(sp)
    800056c2:	6165                	addi	sp,sp,112
    800056c4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056c6:	f9042503          	lw	a0,-112(s0)
    800056ca:	00451613          	slli	a2,a0,0x4
  if(write)
    800056ce:	00019597          	auipc	a1,0x19
    800056d2:	93258593          	addi	a1,a1,-1742 # 8001e000 <disk>
    800056d6:	20050793          	addi	a5,a0,512
    800056da:	0792                	slli	a5,a5,0x4
    800056dc:	97ae                	add	a5,a5,a1
    800056de:	01903733          	snez	a4,s9
    800056e2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800056e6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800056ea:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056ee:	0001b717          	auipc	a4,0x1b
    800056f2:	91270713          	addi	a4,a4,-1774 # 80020000 <disk+0x2000>
    800056f6:	6314                	ld	a3,0(a4)
    800056f8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056fa:	6789                	lui	a5,0x2
    800056fc:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005700:	97b2                	add	a5,a5,a2
    80005702:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005704:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005706:	631c                	ld	a5,0(a4)
    80005708:	97b2                	add	a5,a5,a2
    8000570a:	46c1                	li	a3,16
    8000570c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000570e:	631c                	ld	a5,0(a4)
    80005710:	97b2                	add	a5,a5,a2
    80005712:	4685                	li	a3,1
    80005714:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005718:	f9442783          	lw	a5,-108(s0)
    8000571c:	6314                	ld	a3,0(a4)
    8000571e:	96b2                	add	a3,a3,a2
    80005720:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005724:	0792                	slli	a5,a5,0x4
    80005726:	6314                	ld	a3,0(a4)
    80005728:	96be                	add	a3,a3,a5
    8000572a:	058a0593          	addi	a1,s4,88
    8000572e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005730:	6318                	ld	a4,0(a4)
    80005732:	973e                	add	a4,a4,a5
    80005734:	40000693          	li	a3,1024
    80005738:	c714                	sw	a3,8(a4)
  if(write)
    8000573a:	e40c97e3          	bnez	s9,80005588 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000573e:	0001b717          	auipc	a4,0x1b
    80005742:	8c273703          	ld	a4,-1854(a4) # 80020000 <disk+0x2000>
    80005746:	973e                	add	a4,a4,a5
    80005748:	4689                	li	a3,2
    8000574a:	00d71623          	sh	a3,12(a4)
    8000574e:	b5a1                	j	80005596 <virtio_disk_rw+0xd4>

0000000080005750 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005750:	1101                	addi	sp,sp,-32
    80005752:	ec06                	sd	ra,24(sp)
    80005754:	e822                	sd	s0,16(sp)
    80005756:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005758:	0001b517          	auipc	a0,0x1b
    8000575c:	9d050513          	addi	a0,a0,-1584 # 80020128 <disk+0x2128>
    80005760:	00001097          	auipc	ra,0x1
    80005764:	be2080e7          	jalr	-1054(ra) # 80006342 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005768:	100017b7          	lui	a5,0x10001
    8000576c:	53b8                	lw	a4,96(a5)
    8000576e:	8b0d                	andi	a4,a4,3
    80005770:	100017b7          	lui	a5,0x10001
    80005774:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005776:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000577a:	0001b797          	auipc	a5,0x1b
    8000577e:	88678793          	addi	a5,a5,-1914 # 80020000 <disk+0x2000>
    80005782:	6b94                	ld	a3,16(a5)
    80005784:	0207d703          	lhu	a4,32(a5)
    80005788:	0026d783          	lhu	a5,2(a3)
    8000578c:	06f70563          	beq	a4,a5,800057f6 <virtio_disk_intr+0xa6>
    80005790:	e426                	sd	s1,8(sp)
    80005792:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005794:	00019917          	auipc	s2,0x19
    80005798:	86c90913          	addi	s2,s2,-1940 # 8001e000 <disk>
    8000579c:	0001b497          	auipc	s1,0x1b
    800057a0:	86448493          	addi	s1,s1,-1948 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800057a4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057a8:	6898                	ld	a4,16(s1)
    800057aa:	0204d783          	lhu	a5,32(s1)
    800057ae:	8b9d                	andi	a5,a5,7
    800057b0:	078e                	slli	a5,a5,0x3
    800057b2:	97ba                	add	a5,a5,a4
    800057b4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057b6:	20078713          	addi	a4,a5,512
    800057ba:	0712                	slli	a4,a4,0x4
    800057bc:	974a                	add	a4,a4,s2
    800057be:	03074703          	lbu	a4,48(a4)
    800057c2:	e731                	bnez	a4,8000580e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057c4:	20078793          	addi	a5,a5,512
    800057c8:	0792                	slli	a5,a5,0x4
    800057ca:	97ca                	add	a5,a5,s2
    800057cc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057ce:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057d2:	ffffc097          	auipc	ra,0xffffc
    800057d6:	f46080e7          	jalr	-186(ra) # 80001718 <wakeup>

    disk.used_idx += 1;
    800057da:	0204d783          	lhu	a5,32(s1)
    800057de:	2785                	addiw	a5,a5,1
    800057e0:	17c2                	slli	a5,a5,0x30
    800057e2:	93c1                	srli	a5,a5,0x30
    800057e4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057e8:	6898                	ld	a4,16(s1)
    800057ea:	00275703          	lhu	a4,2(a4)
    800057ee:	faf71be3          	bne	a4,a5,800057a4 <virtio_disk_intr+0x54>
    800057f2:	64a2                	ld	s1,8(sp)
    800057f4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800057f6:	0001b517          	auipc	a0,0x1b
    800057fa:	93250513          	addi	a0,a0,-1742 # 80020128 <disk+0x2128>
    800057fe:	00001097          	auipc	ra,0x1
    80005802:	bf8080e7          	jalr	-1032(ra) # 800063f6 <release>
}
    80005806:	60e2                	ld	ra,24(sp)
    80005808:	6442                	ld	s0,16(sp)
    8000580a:	6105                	addi	sp,sp,32
    8000580c:	8082                	ret
      panic("virtio_disk_intr status");
    8000580e:	00003517          	auipc	a0,0x3
    80005812:	e7250513          	addi	a0,a0,-398 # 80008680 <etext+0x680>
    80005816:	00000097          	auipc	ra,0x0
    8000581a:	5dc080e7          	jalr	1500(ra) # 80005df2 <panic>

000000008000581e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000581e:	1141                	addi	sp,sp,-16
    80005820:	e422                	sd	s0,8(sp)
    80005822:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005824:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005828:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000582c:	0037979b          	slliw	a5,a5,0x3
    80005830:	02004737          	lui	a4,0x2004
    80005834:	97ba                	add	a5,a5,a4
    80005836:	0200c737          	lui	a4,0x200c
    8000583a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000583c:	6318                	ld	a4,0(a4)
    8000583e:	000f4637          	lui	a2,0xf4
    80005842:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005846:	9732                	add	a4,a4,a2
    80005848:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000584a:	00259693          	slli	a3,a1,0x2
    8000584e:	96ae                	add	a3,a3,a1
    80005850:	068e                	slli	a3,a3,0x3
    80005852:	0001b717          	auipc	a4,0x1b
    80005856:	7ae70713          	addi	a4,a4,1966 # 80021000 <timer_scratch>
    8000585a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000585c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000585e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005860:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005864:	00000797          	auipc	a5,0x0
    80005868:	99c78793          	addi	a5,a5,-1636 # 80005200 <timervec>
    8000586c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005870:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005874:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005878:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000587c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005880:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005884:	30479073          	csrw	mie,a5
}
    80005888:	6422                	ld	s0,8(sp)
    8000588a:	0141                	addi	sp,sp,16
    8000588c:	8082                	ret

000000008000588e <start>:
{
    8000588e:	1141                	addi	sp,sp,-16
    80005890:	e406                	sd	ra,8(sp)
    80005892:	e022                	sd	s0,0(sp)
    80005894:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005896:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000589a:	7779                	lui	a4,0xffffe
    8000589c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd55bf>
    800058a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058a2:	6705                	lui	a4,0x1
    800058a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058ae:	ffffb797          	auipc	a5,0xffffb
    800058b2:	a6a78793          	addi	a5,a5,-1430 # 80000318 <main>
    800058b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058ba:	4781                	li	a5,0
    800058bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058c0:	67c1                	lui	a5,0x10
    800058c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058d8:	57fd                	li	a5,-1
    800058da:	83a9                	srli	a5,a5,0xa
    800058dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058e0:	47bd                	li	a5,15
    800058e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058e6:	00000097          	auipc	ra,0x0
    800058ea:	f38080e7          	jalr	-200(ra) # 8000581e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058f2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800058f6:	30200073          	mret
}
    800058fa:	60a2                	ld	ra,8(sp)
    800058fc:	6402                	ld	s0,0(sp)
    800058fe:	0141                	addi	sp,sp,16
    80005900:	8082                	ret

0000000080005902 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005902:	715d                	addi	sp,sp,-80
    80005904:	e486                	sd	ra,72(sp)
    80005906:	e0a2                	sd	s0,64(sp)
    80005908:	f84a                	sd	s2,48(sp)
    8000590a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000590c:	04c05663          	blez	a2,80005958 <consolewrite+0x56>
    80005910:	fc26                	sd	s1,56(sp)
    80005912:	f44e                	sd	s3,40(sp)
    80005914:	f052                	sd	s4,32(sp)
    80005916:	ec56                	sd	s5,24(sp)
    80005918:	8a2a                	mv	s4,a0
    8000591a:	84ae                	mv	s1,a1
    8000591c:	89b2                	mv	s3,a2
    8000591e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005920:	5afd                	li	s5,-1
    80005922:	4685                	li	a3,1
    80005924:	8626                	mv	a2,s1
    80005926:	85d2                	mv	a1,s4
    80005928:	fbf40513          	addi	a0,s0,-65
    8000592c:	ffffc097          	auipc	ra,0xffffc
    80005930:	05a080e7          	jalr	90(ra) # 80001986 <either_copyin>
    80005934:	03550463          	beq	a0,s5,8000595c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005938:	fbf44503          	lbu	a0,-65(s0)
    8000593c:	00001097          	auipc	ra,0x1
    80005940:	84a080e7          	jalr	-1974(ra) # 80006186 <uartputc>
  for(i = 0; i < n; i++){
    80005944:	2905                	addiw	s2,s2,1
    80005946:	0485                	addi	s1,s1,1
    80005948:	fd299de3          	bne	s3,s2,80005922 <consolewrite+0x20>
    8000594c:	894e                	mv	s2,s3
    8000594e:	74e2                	ld	s1,56(sp)
    80005950:	79a2                	ld	s3,40(sp)
    80005952:	7a02                	ld	s4,32(sp)
    80005954:	6ae2                	ld	s5,24(sp)
    80005956:	a039                	j	80005964 <consolewrite+0x62>
    80005958:	4901                	li	s2,0
    8000595a:	a029                	j	80005964 <consolewrite+0x62>
    8000595c:	74e2                	ld	s1,56(sp)
    8000595e:	79a2                	ld	s3,40(sp)
    80005960:	7a02                	ld	s4,32(sp)
    80005962:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005964:	854a                	mv	a0,s2
    80005966:	60a6                	ld	ra,72(sp)
    80005968:	6406                	ld	s0,64(sp)
    8000596a:	7942                	ld	s2,48(sp)
    8000596c:	6161                	addi	sp,sp,80
    8000596e:	8082                	ret

0000000080005970 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005970:	711d                	addi	sp,sp,-96
    80005972:	ec86                	sd	ra,88(sp)
    80005974:	e8a2                	sd	s0,80(sp)
    80005976:	e4a6                	sd	s1,72(sp)
    80005978:	e0ca                	sd	s2,64(sp)
    8000597a:	fc4e                	sd	s3,56(sp)
    8000597c:	f852                	sd	s4,48(sp)
    8000597e:	f456                	sd	s5,40(sp)
    80005980:	f05a                	sd	s6,32(sp)
    80005982:	1080                	addi	s0,sp,96
    80005984:	8aaa                	mv	s5,a0
    80005986:	8a2e                	mv	s4,a1
    80005988:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000598a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000598e:	00023517          	auipc	a0,0x23
    80005992:	7b250513          	addi	a0,a0,1970 # 80029140 <cons>
    80005996:	00001097          	auipc	ra,0x1
    8000599a:	9ac080e7          	jalr	-1620(ra) # 80006342 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000599e:	00023497          	auipc	s1,0x23
    800059a2:	7a248493          	addi	s1,s1,1954 # 80029140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059a6:	00024917          	auipc	s2,0x24
    800059aa:	83290913          	addi	s2,s2,-1998 # 800291d8 <cons+0x98>
  while(n > 0){
    800059ae:	0d305463          	blez	s3,80005a76 <consoleread+0x106>
    while(cons.r == cons.w){
    800059b2:	0984a783          	lw	a5,152(s1)
    800059b6:	09c4a703          	lw	a4,156(s1)
    800059ba:	0af71963          	bne	a4,a5,80005a6c <consoleread+0xfc>
      if(myproc()->killed){
    800059be:	ffffb097          	auipc	ra,0xffffb
    800059c2:	4be080e7          	jalr	1214(ra) # 80000e7c <myproc>
    800059c6:	551c                	lw	a5,40(a0)
    800059c8:	e7ad                	bnez	a5,80005a32 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800059ca:	85a6                	mv	a1,s1
    800059cc:	854a                	mv	a0,s2
    800059ce:	ffffc097          	auipc	ra,0xffffc
    800059d2:	bbe080e7          	jalr	-1090(ra) # 8000158c <sleep>
    while(cons.r == cons.w){
    800059d6:	0984a783          	lw	a5,152(s1)
    800059da:	09c4a703          	lw	a4,156(s1)
    800059de:	fef700e3          	beq	a4,a5,800059be <consoleread+0x4e>
    800059e2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800059e4:	00023717          	auipc	a4,0x23
    800059e8:	75c70713          	addi	a4,a4,1884 # 80029140 <cons>
    800059ec:	0017869b          	addiw	a3,a5,1
    800059f0:	08d72c23          	sw	a3,152(a4)
    800059f4:	07f7f693          	andi	a3,a5,127
    800059f8:	9736                	add	a4,a4,a3
    800059fa:	01874703          	lbu	a4,24(a4)
    800059fe:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a02:	4691                	li	a3,4
    80005a04:	04db8a63          	beq	s7,a3,80005a58 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a08:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a0c:	4685                	li	a3,1
    80005a0e:	faf40613          	addi	a2,s0,-81
    80005a12:	85d2                	mv	a1,s4
    80005a14:	8556                	mv	a0,s5
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	f1a080e7          	jalr	-230(ra) # 80001930 <either_copyout>
    80005a1e:	57fd                	li	a5,-1
    80005a20:	04f50a63          	beq	a0,a5,80005a74 <consoleread+0x104>
      break;

    dst++;
    80005a24:	0a05                	addi	s4,s4,1
    --n;
    80005a26:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a28:	47a9                	li	a5,10
    80005a2a:	06fb8163          	beq	s7,a5,80005a8c <consoleread+0x11c>
    80005a2e:	6be2                	ld	s7,24(sp)
    80005a30:	bfbd                	j	800059ae <consoleread+0x3e>
        release(&cons.lock);
    80005a32:	00023517          	auipc	a0,0x23
    80005a36:	70e50513          	addi	a0,a0,1806 # 80029140 <cons>
    80005a3a:	00001097          	auipc	ra,0x1
    80005a3e:	9bc080e7          	jalr	-1604(ra) # 800063f6 <release>
        return -1;
    80005a42:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a44:	60e6                	ld	ra,88(sp)
    80005a46:	6446                	ld	s0,80(sp)
    80005a48:	64a6                	ld	s1,72(sp)
    80005a4a:	6906                	ld	s2,64(sp)
    80005a4c:	79e2                	ld	s3,56(sp)
    80005a4e:	7a42                	ld	s4,48(sp)
    80005a50:	7aa2                	ld	s5,40(sp)
    80005a52:	7b02                	ld	s6,32(sp)
    80005a54:	6125                	addi	sp,sp,96
    80005a56:	8082                	ret
      if(n < target){
    80005a58:	0009871b          	sext.w	a4,s3
    80005a5c:	01677a63          	bgeu	a4,s6,80005a70 <consoleread+0x100>
        cons.r--;
    80005a60:	00023717          	auipc	a4,0x23
    80005a64:	76f72c23          	sw	a5,1912(a4) # 800291d8 <cons+0x98>
    80005a68:	6be2                	ld	s7,24(sp)
    80005a6a:	a031                	j	80005a76 <consoleread+0x106>
    80005a6c:	ec5e                	sd	s7,24(sp)
    80005a6e:	bf9d                	j	800059e4 <consoleread+0x74>
    80005a70:	6be2                	ld	s7,24(sp)
    80005a72:	a011                	j	80005a76 <consoleread+0x106>
    80005a74:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005a76:	00023517          	auipc	a0,0x23
    80005a7a:	6ca50513          	addi	a0,a0,1738 # 80029140 <cons>
    80005a7e:	00001097          	auipc	ra,0x1
    80005a82:	978080e7          	jalr	-1672(ra) # 800063f6 <release>
  return target - n;
    80005a86:	413b053b          	subw	a0,s6,s3
    80005a8a:	bf6d                	j	80005a44 <consoleread+0xd4>
    80005a8c:	6be2                	ld	s7,24(sp)
    80005a8e:	b7e5                	j	80005a76 <consoleread+0x106>

0000000080005a90 <consputc>:
{
    80005a90:	1141                	addi	sp,sp,-16
    80005a92:	e406                	sd	ra,8(sp)
    80005a94:	e022                	sd	s0,0(sp)
    80005a96:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a98:	10000793          	li	a5,256
    80005a9c:	00f50a63          	beq	a0,a5,80005ab0 <consputc+0x20>
    uartputc_sync(c);
    80005aa0:	00000097          	auipc	ra,0x0
    80005aa4:	608080e7          	jalr	1544(ra) # 800060a8 <uartputc_sync>
}
    80005aa8:	60a2                	ld	ra,8(sp)
    80005aaa:	6402                	ld	s0,0(sp)
    80005aac:	0141                	addi	sp,sp,16
    80005aae:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ab0:	4521                	li	a0,8
    80005ab2:	00000097          	auipc	ra,0x0
    80005ab6:	5f6080e7          	jalr	1526(ra) # 800060a8 <uartputc_sync>
    80005aba:	02000513          	li	a0,32
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	5ea080e7          	jalr	1514(ra) # 800060a8 <uartputc_sync>
    80005ac6:	4521                	li	a0,8
    80005ac8:	00000097          	auipc	ra,0x0
    80005acc:	5e0080e7          	jalr	1504(ra) # 800060a8 <uartputc_sync>
    80005ad0:	bfe1                	j	80005aa8 <consputc+0x18>

0000000080005ad2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ad2:	1101                	addi	sp,sp,-32
    80005ad4:	ec06                	sd	ra,24(sp)
    80005ad6:	e822                	sd	s0,16(sp)
    80005ad8:	e426                	sd	s1,8(sp)
    80005ada:	1000                	addi	s0,sp,32
    80005adc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ade:	00023517          	auipc	a0,0x23
    80005ae2:	66250513          	addi	a0,a0,1634 # 80029140 <cons>
    80005ae6:	00001097          	auipc	ra,0x1
    80005aea:	85c080e7          	jalr	-1956(ra) # 80006342 <acquire>

  switch(c){
    80005aee:	47d5                	li	a5,21
    80005af0:	0af48563          	beq	s1,a5,80005b9a <consoleintr+0xc8>
    80005af4:	0297c963          	blt	a5,s1,80005b26 <consoleintr+0x54>
    80005af8:	47a1                	li	a5,8
    80005afa:	0ef48c63          	beq	s1,a5,80005bf2 <consoleintr+0x120>
    80005afe:	47c1                	li	a5,16
    80005b00:	10f49f63          	bne	s1,a5,80005c1e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b04:	ffffc097          	auipc	ra,0xffffc
    80005b08:	ed8080e7          	jalr	-296(ra) # 800019dc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b0c:	00023517          	auipc	a0,0x23
    80005b10:	63450513          	addi	a0,a0,1588 # 80029140 <cons>
    80005b14:	00001097          	auipc	ra,0x1
    80005b18:	8e2080e7          	jalr	-1822(ra) # 800063f6 <release>
}
    80005b1c:	60e2                	ld	ra,24(sp)
    80005b1e:	6442                	ld	s0,16(sp)
    80005b20:	64a2                	ld	s1,8(sp)
    80005b22:	6105                	addi	sp,sp,32
    80005b24:	8082                	ret
  switch(c){
    80005b26:	07f00793          	li	a5,127
    80005b2a:	0cf48463          	beq	s1,a5,80005bf2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b2e:	00023717          	auipc	a4,0x23
    80005b32:	61270713          	addi	a4,a4,1554 # 80029140 <cons>
    80005b36:	0a072783          	lw	a5,160(a4)
    80005b3a:	09872703          	lw	a4,152(a4)
    80005b3e:	9f99                	subw	a5,a5,a4
    80005b40:	07f00713          	li	a4,127
    80005b44:	fcf764e3          	bltu	a4,a5,80005b0c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b48:	47b5                	li	a5,13
    80005b4a:	0cf48d63          	beq	s1,a5,80005c24 <consoleintr+0x152>
      consputc(c);
    80005b4e:	8526                	mv	a0,s1
    80005b50:	00000097          	auipc	ra,0x0
    80005b54:	f40080e7          	jalr	-192(ra) # 80005a90 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b58:	00023797          	auipc	a5,0x23
    80005b5c:	5e878793          	addi	a5,a5,1512 # 80029140 <cons>
    80005b60:	0a07a703          	lw	a4,160(a5)
    80005b64:	0017069b          	addiw	a3,a4,1
    80005b68:	0006861b          	sext.w	a2,a3
    80005b6c:	0ad7a023          	sw	a3,160(a5)
    80005b70:	07f77713          	andi	a4,a4,127
    80005b74:	97ba                	add	a5,a5,a4
    80005b76:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b7a:	47a9                	li	a5,10
    80005b7c:	0cf48b63          	beq	s1,a5,80005c52 <consoleintr+0x180>
    80005b80:	4791                	li	a5,4
    80005b82:	0cf48863          	beq	s1,a5,80005c52 <consoleintr+0x180>
    80005b86:	00023797          	auipc	a5,0x23
    80005b8a:	6527a783          	lw	a5,1618(a5) # 800291d8 <cons+0x98>
    80005b8e:	0807879b          	addiw	a5,a5,128
    80005b92:	f6f61de3          	bne	a2,a5,80005b0c <consoleintr+0x3a>
    80005b96:	863e                	mv	a2,a5
    80005b98:	a86d                	j	80005c52 <consoleintr+0x180>
    80005b9a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005b9c:	00023717          	auipc	a4,0x23
    80005ba0:	5a470713          	addi	a4,a4,1444 # 80029140 <cons>
    80005ba4:	0a072783          	lw	a5,160(a4)
    80005ba8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bac:	00023497          	auipc	s1,0x23
    80005bb0:	59448493          	addi	s1,s1,1428 # 80029140 <cons>
    while(cons.e != cons.w &&
    80005bb4:	4929                	li	s2,10
    80005bb6:	02f70a63          	beq	a4,a5,80005bea <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bba:	37fd                	addiw	a5,a5,-1
    80005bbc:	07f7f713          	andi	a4,a5,127
    80005bc0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bc2:	01874703          	lbu	a4,24(a4)
    80005bc6:	03270463          	beq	a4,s2,80005bee <consoleintr+0x11c>
      cons.e--;
    80005bca:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bce:	10000513          	li	a0,256
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	ebe080e7          	jalr	-322(ra) # 80005a90 <consputc>
    while(cons.e != cons.w &&
    80005bda:	0a04a783          	lw	a5,160(s1)
    80005bde:	09c4a703          	lw	a4,156(s1)
    80005be2:	fcf71ce3          	bne	a4,a5,80005bba <consoleintr+0xe8>
    80005be6:	6902                	ld	s2,0(sp)
    80005be8:	b715                	j	80005b0c <consoleintr+0x3a>
    80005bea:	6902                	ld	s2,0(sp)
    80005bec:	b705                	j	80005b0c <consoleintr+0x3a>
    80005bee:	6902                	ld	s2,0(sp)
    80005bf0:	bf31                	j	80005b0c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005bf2:	00023717          	auipc	a4,0x23
    80005bf6:	54e70713          	addi	a4,a4,1358 # 80029140 <cons>
    80005bfa:	0a072783          	lw	a5,160(a4)
    80005bfe:	09c72703          	lw	a4,156(a4)
    80005c02:	f0f705e3          	beq	a4,a5,80005b0c <consoleintr+0x3a>
      cons.e--;
    80005c06:	37fd                	addiw	a5,a5,-1
    80005c08:	00023717          	auipc	a4,0x23
    80005c0c:	5cf72c23          	sw	a5,1496(a4) # 800291e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c10:	10000513          	li	a0,256
    80005c14:	00000097          	auipc	ra,0x0
    80005c18:	e7c080e7          	jalr	-388(ra) # 80005a90 <consputc>
    80005c1c:	bdc5                	j	80005b0c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c1e:	ee0487e3          	beqz	s1,80005b0c <consoleintr+0x3a>
    80005c22:	b731                	j	80005b2e <consoleintr+0x5c>
      consputc(c);
    80005c24:	4529                	li	a0,10
    80005c26:	00000097          	auipc	ra,0x0
    80005c2a:	e6a080e7          	jalr	-406(ra) # 80005a90 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c2e:	00023797          	auipc	a5,0x23
    80005c32:	51278793          	addi	a5,a5,1298 # 80029140 <cons>
    80005c36:	0a07a703          	lw	a4,160(a5)
    80005c3a:	0017069b          	addiw	a3,a4,1
    80005c3e:	0006861b          	sext.w	a2,a3
    80005c42:	0ad7a023          	sw	a3,160(a5)
    80005c46:	07f77713          	andi	a4,a4,127
    80005c4a:	97ba                	add	a5,a5,a4
    80005c4c:	4729                	li	a4,10
    80005c4e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c52:	00023797          	auipc	a5,0x23
    80005c56:	58c7a523          	sw	a2,1418(a5) # 800291dc <cons+0x9c>
        wakeup(&cons.r);
    80005c5a:	00023517          	auipc	a0,0x23
    80005c5e:	57e50513          	addi	a0,a0,1406 # 800291d8 <cons+0x98>
    80005c62:	ffffc097          	auipc	ra,0xffffc
    80005c66:	ab6080e7          	jalr	-1354(ra) # 80001718 <wakeup>
    80005c6a:	b54d                	j	80005b0c <consoleintr+0x3a>

0000000080005c6c <consoleinit>:

void
consoleinit(void)
{
    80005c6c:	1141                	addi	sp,sp,-16
    80005c6e:	e406                	sd	ra,8(sp)
    80005c70:	e022                	sd	s0,0(sp)
    80005c72:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c74:	00003597          	auipc	a1,0x3
    80005c78:	a2458593          	addi	a1,a1,-1500 # 80008698 <etext+0x698>
    80005c7c:	00023517          	auipc	a0,0x23
    80005c80:	4c450513          	addi	a0,a0,1220 # 80029140 <cons>
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	62e080e7          	jalr	1582(ra) # 800062b2 <initlock>

  uartinit();
    80005c8c:	00000097          	auipc	ra,0x0
    80005c90:	3c0080e7          	jalr	960(ra) # 8000604c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c94:	00017797          	auipc	a5,0x17
    80005c98:	c3478793          	addi	a5,a5,-972 # 8001c8c8 <devsw>
    80005c9c:	00000717          	auipc	a4,0x0
    80005ca0:	cd470713          	addi	a4,a4,-812 # 80005970 <consoleread>
    80005ca4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ca6:	00000717          	auipc	a4,0x0
    80005caa:	c5c70713          	addi	a4,a4,-932 # 80005902 <consolewrite>
    80005cae:	ef98                	sd	a4,24(a5)
}
    80005cb0:	60a2                	ld	ra,8(sp)
    80005cb2:	6402                	ld	s0,0(sp)
    80005cb4:	0141                	addi	sp,sp,16
    80005cb6:	8082                	ret

0000000080005cb8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cb8:	7179                	addi	sp,sp,-48
    80005cba:	f406                	sd	ra,40(sp)
    80005cbc:	f022                	sd	s0,32(sp)
    80005cbe:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cc0:	c219                	beqz	a2,80005cc6 <printint+0xe>
    80005cc2:	08054963          	bltz	a0,80005d54 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cc6:	2501                	sext.w	a0,a0
    80005cc8:	4881                	li	a7,0
    80005cca:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cce:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cd0:	2581                	sext.w	a1,a1
    80005cd2:	00003617          	auipc	a2,0x3
    80005cd6:	b4e60613          	addi	a2,a2,-1202 # 80008820 <digits>
    80005cda:	883a                	mv	a6,a4
    80005cdc:	2705                	addiw	a4,a4,1
    80005cde:	02b577bb          	remuw	a5,a0,a1
    80005ce2:	1782                	slli	a5,a5,0x20
    80005ce4:	9381                	srli	a5,a5,0x20
    80005ce6:	97b2                	add	a5,a5,a2
    80005ce8:	0007c783          	lbu	a5,0(a5)
    80005cec:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cf0:	0005079b          	sext.w	a5,a0
    80005cf4:	02b5553b          	divuw	a0,a0,a1
    80005cf8:	0685                	addi	a3,a3,1
    80005cfa:	feb7f0e3          	bgeu	a5,a1,80005cda <printint+0x22>

  if(sign)
    80005cfe:	00088c63          	beqz	a7,80005d16 <printint+0x5e>
    buf[i++] = '-';
    80005d02:	fe070793          	addi	a5,a4,-32
    80005d06:	00878733          	add	a4,a5,s0
    80005d0a:	02d00793          	li	a5,45
    80005d0e:	fef70823          	sb	a5,-16(a4)
    80005d12:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d16:	02e05b63          	blez	a4,80005d4c <printint+0x94>
    80005d1a:	ec26                	sd	s1,24(sp)
    80005d1c:	e84a                	sd	s2,16(sp)
    80005d1e:	fd040793          	addi	a5,s0,-48
    80005d22:	00e784b3          	add	s1,a5,a4
    80005d26:	fff78913          	addi	s2,a5,-1
    80005d2a:	993a                	add	s2,s2,a4
    80005d2c:	377d                	addiw	a4,a4,-1
    80005d2e:	1702                	slli	a4,a4,0x20
    80005d30:	9301                	srli	a4,a4,0x20
    80005d32:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d36:	fff4c503          	lbu	a0,-1(s1)
    80005d3a:	00000097          	auipc	ra,0x0
    80005d3e:	d56080e7          	jalr	-682(ra) # 80005a90 <consputc>
  while(--i >= 0)
    80005d42:	14fd                	addi	s1,s1,-1
    80005d44:	ff2499e3          	bne	s1,s2,80005d36 <printint+0x7e>
    80005d48:	64e2                	ld	s1,24(sp)
    80005d4a:	6942                	ld	s2,16(sp)
}
    80005d4c:	70a2                	ld	ra,40(sp)
    80005d4e:	7402                	ld	s0,32(sp)
    80005d50:	6145                	addi	sp,sp,48
    80005d52:	8082                	ret
    x = -xx;
    80005d54:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d58:	4885                	li	a7,1
    x = -xx;
    80005d5a:	bf85                	j	80005cca <printint+0x12>

0000000080005d5c <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d5c:	1101                	addi	sp,sp,-32
    80005d5e:	ec06                	sd	ra,24(sp)
    80005d60:	e822                	sd	s0,16(sp)
    80005d62:	e426                	sd	s1,8(sp)
    80005d64:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d66:	00023497          	auipc	s1,0x23
    80005d6a:	48248493          	addi	s1,s1,1154 # 800291e8 <pr>
    80005d6e:	00003597          	auipc	a1,0x3
    80005d72:	93258593          	addi	a1,a1,-1742 # 800086a0 <etext+0x6a0>
    80005d76:	8526                	mv	a0,s1
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	53a080e7          	jalr	1338(ra) # 800062b2 <initlock>
  pr.locking = 1;
    80005d80:	4785                	li	a5,1
    80005d82:	cc9c                	sw	a5,24(s1)
}
    80005d84:	60e2                	ld	ra,24(sp)
    80005d86:	6442                	ld	s0,16(sp)
    80005d88:	64a2                	ld	s1,8(sp)
    80005d8a:	6105                	addi	sp,sp,32
    80005d8c:	8082                	ret

0000000080005d8e <backtrace>:
void backtrace()
{
    80005d8e:	7179                	addi	sp,sp,-48
    80005d90:	f406                	sd	ra,40(sp)
    80005d92:	f022                	sd	s0,32(sp)
    80005d94:	ec26                	sd	s1,24(sp)
    80005d96:	e84a                	sd	s2,16(sp)
    80005d98:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    80005d9a:	00003517          	auipc	a0,0x3
    80005d9e:	90e50513          	addi	a0,a0,-1778 # 800086a8 <etext+0x6a8>
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	0a2080e7          	jalr	162(ra) # 80005e44 <printf>

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005daa:	87a2                	mv	a5,s0
  uint64 fp = r_fp();    //read the register
  uint64 *frame = (uint64*) fp;
    80005dac:	84be                	mv	s1,a5

  uint64 up = PGROUNDUP(fp);
    80005dae:	6905                	lui	s2,0x1
    80005db0:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005db2:	993e                	add	s2,s2,a5
    80005db4:	777d                	lui	a4,0xfffff
    80005db6:	00e97933          	and	s2,s2,a4
  uint64 down = PGROUNDDOWN(fp);
    80005dba:	8ff9                	and	a5,a5,a4

  while(fp < up && up > down)
    80005dbc:	0324f563          	bgeu	s1,s2,80005de6 <backtrace+0x58>
    80005dc0:	0327f363          	bgeu	a5,s2,80005de6 <backtrace+0x58>
    80005dc4:	e44e                	sd	s3,8(sp)
  {
    printf("%p\n",frame[-1]);
    80005dc6:	00003997          	auipc	s3,0x3
    80005dca:	8f298993          	addi	s3,s3,-1806 # 800086b8 <etext+0x6b8>
    80005dce:	ff84b583          	ld	a1,-8(s1)
    80005dd2:	854e                	mv	a0,s3
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	070080e7          	jalr	112(ra) # 80005e44 <printf>
    fp = frame[-2];  // to next
    80005ddc:	ff04b483          	ld	s1,-16(s1)
  while(fp < up && up > down)
    80005de0:	ff24e7e3          	bltu	s1,s2,80005dce <backtrace+0x40>
    80005de4:	69a2                	ld	s3,8(sp)
    frame = (uint64*)fp;
  }
    80005de6:	70a2                	ld	ra,40(sp)
    80005de8:	7402                	ld	s0,32(sp)
    80005dea:	64e2                	ld	s1,24(sp)
    80005dec:	6942                	ld	s2,16(sp)
    80005dee:	6145                	addi	sp,sp,48
    80005df0:	8082                	ret

0000000080005df2 <panic>:
{
    80005df2:	1101                	addi	sp,sp,-32
    80005df4:	ec06                	sd	ra,24(sp)
    80005df6:	e822                	sd	s0,16(sp)
    80005df8:	e426                	sd	s1,8(sp)
    80005dfa:	1000                	addi	s0,sp,32
    80005dfc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dfe:	00023797          	auipc	a5,0x23
    80005e02:	4007a123          	sw	zero,1026(a5) # 80029200 <pr+0x18>
  printf("panic: ");
    80005e06:	00003517          	auipc	a0,0x3
    80005e0a:	8ba50513          	addi	a0,a0,-1862 # 800086c0 <etext+0x6c0>
    80005e0e:	00000097          	auipc	ra,0x0
    80005e12:	036080e7          	jalr	54(ra) # 80005e44 <printf>
  printf(s);
    80005e16:	8526                	mv	a0,s1
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	02c080e7          	jalr	44(ra) # 80005e44 <printf>
  printf("\n");
    80005e20:	00002517          	auipc	a0,0x2
    80005e24:	1f850513          	addi	a0,a0,504 # 80008018 <etext+0x18>
    80005e28:	00000097          	auipc	ra,0x0
    80005e2c:	01c080e7          	jalr	28(ra) # 80005e44 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e30:	4785                	li	a5,1
    80005e32:	00006717          	auipc	a4,0x6
    80005e36:	1ef72523          	sw	a5,490(a4) # 8000c01c <panicked>
  backtrace();
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	f54080e7          	jalr	-172(ra) # 80005d8e <backtrace>
  for(;;)
    80005e42:	a001                	j	80005e42 <panic+0x50>

0000000080005e44 <printf>:
{
    80005e44:	7131                	addi	sp,sp,-192
    80005e46:	fc86                	sd	ra,120(sp)
    80005e48:	f8a2                	sd	s0,112(sp)
    80005e4a:	e8d2                	sd	s4,80(sp)
    80005e4c:	f06a                	sd	s10,32(sp)
    80005e4e:	0100                	addi	s0,sp,128
    80005e50:	8a2a                	mv	s4,a0
    80005e52:	e40c                	sd	a1,8(s0)
    80005e54:	e810                	sd	a2,16(s0)
    80005e56:	ec14                	sd	a3,24(s0)
    80005e58:	f018                	sd	a4,32(s0)
    80005e5a:	f41c                	sd	a5,40(s0)
    80005e5c:	03043823          	sd	a6,48(s0)
    80005e60:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e64:	00023d17          	auipc	s10,0x23
    80005e68:	39cd2d03          	lw	s10,924(s10) # 80029200 <pr+0x18>
  if(locking)
    80005e6c:	040d1463          	bnez	s10,80005eb4 <printf+0x70>
  if (fmt == 0)
    80005e70:	040a0b63          	beqz	s4,80005ec6 <printf+0x82>
  va_start(ap, fmt);
    80005e74:	00840793          	addi	a5,s0,8
    80005e78:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e7c:	000a4503          	lbu	a0,0(s4)
    80005e80:	18050b63          	beqz	a0,80006016 <printf+0x1d2>
    80005e84:	f4a6                	sd	s1,104(sp)
    80005e86:	f0ca                	sd	s2,96(sp)
    80005e88:	ecce                	sd	s3,88(sp)
    80005e8a:	e4d6                	sd	s5,72(sp)
    80005e8c:	e0da                	sd	s6,64(sp)
    80005e8e:	fc5e                	sd	s7,56(sp)
    80005e90:	f862                	sd	s8,48(sp)
    80005e92:	f466                	sd	s9,40(sp)
    80005e94:	ec6e                	sd	s11,24(sp)
    80005e96:	4981                	li	s3,0
    if(c != '%'){
    80005e98:	02500b13          	li	s6,37
    switch(c){
    80005e9c:	07000b93          	li	s7,112
  consputc('x');
    80005ea0:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ea2:	00003a97          	auipc	s5,0x3
    80005ea6:	97ea8a93          	addi	s5,s5,-1666 # 80008820 <digits>
    switch(c){
    80005eaa:	07300c13          	li	s8,115
    80005eae:	06400d93          	li	s11,100
    80005eb2:	a0b1                	j	80005efe <printf+0xba>
    acquire(&pr.lock);
    80005eb4:	00023517          	auipc	a0,0x23
    80005eb8:	33450513          	addi	a0,a0,820 # 800291e8 <pr>
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	486080e7          	jalr	1158(ra) # 80006342 <acquire>
    80005ec4:	b775                	j	80005e70 <printf+0x2c>
    80005ec6:	f4a6                	sd	s1,104(sp)
    80005ec8:	f0ca                	sd	s2,96(sp)
    80005eca:	ecce                	sd	s3,88(sp)
    80005ecc:	e4d6                	sd	s5,72(sp)
    80005ece:	e0da                	sd	s6,64(sp)
    80005ed0:	fc5e                	sd	s7,56(sp)
    80005ed2:	f862                	sd	s8,48(sp)
    80005ed4:	f466                	sd	s9,40(sp)
    80005ed6:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005ed8:	00002517          	auipc	a0,0x2
    80005edc:	7f850513          	addi	a0,a0,2040 # 800086d0 <etext+0x6d0>
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	f12080e7          	jalr	-238(ra) # 80005df2 <panic>
      consputc(c);
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	ba8080e7          	jalr	-1112(ra) # 80005a90 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ef0:	2985                	addiw	s3,s3,1
    80005ef2:	013a07b3          	add	a5,s4,s3
    80005ef6:	0007c503          	lbu	a0,0(a5)
    80005efa:	10050563          	beqz	a0,80006004 <printf+0x1c0>
    if(c != '%'){
    80005efe:	ff6515e3          	bne	a0,s6,80005ee8 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005f02:	2985                	addiw	s3,s3,1
    80005f04:	013a07b3          	add	a5,s4,s3
    80005f08:	0007c783          	lbu	a5,0(a5)
    80005f0c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f10:	10078b63          	beqz	a5,80006026 <printf+0x1e2>
    switch(c){
    80005f14:	05778a63          	beq	a5,s7,80005f68 <printf+0x124>
    80005f18:	02fbf663          	bgeu	s7,a5,80005f44 <printf+0x100>
    80005f1c:	09878863          	beq	a5,s8,80005fac <printf+0x168>
    80005f20:	07800713          	li	a4,120
    80005f24:	0ce79563          	bne	a5,a4,80005fee <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005f28:	f8843783          	ld	a5,-120(s0)
    80005f2c:	00878713          	addi	a4,a5,8
    80005f30:	f8e43423          	sd	a4,-120(s0)
    80005f34:	4605                	li	a2,1
    80005f36:	85e6                	mv	a1,s9
    80005f38:	4388                	lw	a0,0(a5)
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	d7e080e7          	jalr	-642(ra) # 80005cb8 <printint>
      break;
    80005f42:	b77d                	j	80005ef0 <printf+0xac>
    switch(c){
    80005f44:	09678f63          	beq	a5,s6,80005fe2 <printf+0x19e>
    80005f48:	0bb79363          	bne	a5,s11,80005fee <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005f4c:	f8843783          	ld	a5,-120(s0)
    80005f50:	00878713          	addi	a4,a5,8
    80005f54:	f8e43423          	sd	a4,-120(s0)
    80005f58:	4605                	li	a2,1
    80005f5a:	45a9                	li	a1,10
    80005f5c:	4388                	lw	a0,0(a5)
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	d5a080e7          	jalr	-678(ra) # 80005cb8 <printint>
      break;
    80005f66:	b769                	j	80005ef0 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005f68:	f8843783          	ld	a5,-120(s0)
    80005f6c:	00878713          	addi	a4,a5,8
    80005f70:	f8e43423          	sd	a4,-120(s0)
    80005f74:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f78:	03000513          	li	a0,48
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	b14080e7          	jalr	-1260(ra) # 80005a90 <consputc>
  consputc('x');
    80005f84:	07800513          	li	a0,120
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	b08080e7          	jalr	-1272(ra) # 80005a90 <consputc>
    80005f90:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f92:	03c95793          	srli	a5,s2,0x3c
    80005f96:	97d6                	add	a5,a5,s5
    80005f98:	0007c503          	lbu	a0,0(a5)
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	af4080e7          	jalr	-1292(ra) # 80005a90 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fa4:	0912                	slli	s2,s2,0x4
    80005fa6:	34fd                	addiw	s1,s1,-1
    80005fa8:	f4ed                	bnez	s1,80005f92 <printf+0x14e>
    80005faa:	b799                	j	80005ef0 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005fac:	f8843783          	ld	a5,-120(s0)
    80005fb0:	00878713          	addi	a4,a5,8
    80005fb4:	f8e43423          	sd	a4,-120(s0)
    80005fb8:	6384                	ld	s1,0(a5)
    80005fba:	cc89                	beqz	s1,80005fd4 <printf+0x190>
      for(; *s; s++)
    80005fbc:	0004c503          	lbu	a0,0(s1)
    80005fc0:	d905                	beqz	a0,80005ef0 <printf+0xac>
        consputc(*s);
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	ace080e7          	jalr	-1330(ra) # 80005a90 <consputc>
      for(; *s; s++)
    80005fca:	0485                	addi	s1,s1,1
    80005fcc:	0004c503          	lbu	a0,0(s1)
    80005fd0:	f96d                	bnez	a0,80005fc2 <printf+0x17e>
    80005fd2:	bf39                	j	80005ef0 <printf+0xac>
        s = "(null)";
    80005fd4:	00002497          	auipc	s1,0x2
    80005fd8:	6f448493          	addi	s1,s1,1780 # 800086c8 <etext+0x6c8>
      for(; *s; s++)
    80005fdc:	02800513          	li	a0,40
    80005fe0:	b7cd                	j	80005fc2 <printf+0x17e>
      consputc('%');
    80005fe2:	855a                	mv	a0,s6
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	aac080e7          	jalr	-1364(ra) # 80005a90 <consputc>
      break;
    80005fec:	b711                	j	80005ef0 <printf+0xac>
      consputc('%');
    80005fee:	855a                	mv	a0,s6
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	aa0080e7          	jalr	-1376(ra) # 80005a90 <consputc>
      consputc(c);
    80005ff8:	8526                	mv	a0,s1
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	a96080e7          	jalr	-1386(ra) # 80005a90 <consputc>
      break;
    80006002:	b5fd                	j	80005ef0 <printf+0xac>
    80006004:	74a6                	ld	s1,104(sp)
    80006006:	7906                	ld	s2,96(sp)
    80006008:	69e6                	ld	s3,88(sp)
    8000600a:	6aa6                	ld	s5,72(sp)
    8000600c:	6b06                	ld	s6,64(sp)
    8000600e:	7be2                	ld	s7,56(sp)
    80006010:	7c42                	ld	s8,48(sp)
    80006012:	7ca2                	ld	s9,40(sp)
    80006014:	6de2                	ld	s11,24(sp)
  if(locking)
    80006016:	020d1263          	bnez	s10,8000603a <printf+0x1f6>
}
    8000601a:	70e6                	ld	ra,120(sp)
    8000601c:	7446                	ld	s0,112(sp)
    8000601e:	6a46                	ld	s4,80(sp)
    80006020:	7d02                	ld	s10,32(sp)
    80006022:	6129                	addi	sp,sp,192
    80006024:	8082                	ret
    80006026:	74a6                	ld	s1,104(sp)
    80006028:	7906                	ld	s2,96(sp)
    8000602a:	69e6                	ld	s3,88(sp)
    8000602c:	6aa6                	ld	s5,72(sp)
    8000602e:	6b06                	ld	s6,64(sp)
    80006030:	7be2                	ld	s7,56(sp)
    80006032:	7c42                	ld	s8,48(sp)
    80006034:	7ca2                	ld	s9,40(sp)
    80006036:	6de2                	ld	s11,24(sp)
    80006038:	bff9                	j	80006016 <printf+0x1d2>
    release(&pr.lock);
    8000603a:	00023517          	auipc	a0,0x23
    8000603e:	1ae50513          	addi	a0,a0,430 # 800291e8 <pr>
    80006042:	00000097          	auipc	ra,0x0
    80006046:	3b4080e7          	jalr	948(ra) # 800063f6 <release>
}
    8000604a:	bfc1                	j	8000601a <printf+0x1d6>

000000008000604c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000604c:	1141                	addi	sp,sp,-16
    8000604e:	e406                	sd	ra,8(sp)
    80006050:	e022                	sd	s0,0(sp)
    80006052:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006054:	100007b7          	lui	a5,0x10000
    80006058:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000605c:	10000737          	lui	a4,0x10000
    80006060:	f8000693          	li	a3,-128
    80006064:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006068:	468d                	li	a3,3
    8000606a:	10000637          	lui	a2,0x10000
    8000606e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006072:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006076:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000607a:	10000737          	lui	a4,0x10000
    8000607e:	461d                	li	a2,7
    80006080:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006084:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006088:	00002597          	auipc	a1,0x2
    8000608c:	65858593          	addi	a1,a1,1624 # 800086e0 <etext+0x6e0>
    80006090:	00023517          	auipc	a0,0x23
    80006094:	17850513          	addi	a0,a0,376 # 80029208 <uart_tx_lock>
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	21a080e7          	jalr	538(ra) # 800062b2 <initlock>
}
    800060a0:	60a2                	ld	ra,8(sp)
    800060a2:	6402                	ld	s0,0(sp)
    800060a4:	0141                	addi	sp,sp,16
    800060a6:	8082                	ret

00000000800060a8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060a8:	1101                	addi	sp,sp,-32
    800060aa:	ec06                	sd	ra,24(sp)
    800060ac:	e822                	sd	s0,16(sp)
    800060ae:	e426                	sd	s1,8(sp)
    800060b0:	1000                	addi	s0,sp,32
    800060b2:	84aa                	mv	s1,a0
  push_off();
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	242080e7          	jalr	578(ra) # 800062f6 <push_off>

  if(panicked){
    800060bc:	00006797          	auipc	a5,0x6
    800060c0:	f607a783          	lw	a5,-160(a5) # 8000c01c <panicked>
    800060c4:	eb85                	bnez	a5,800060f4 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060c6:	10000737          	lui	a4,0x10000
    800060ca:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800060cc:	00074783          	lbu	a5,0(a4)
    800060d0:	0207f793          	andi	a5,a5,32
    800060d4:	dfe5                	beqz	a5,800060cc <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060d6:	0ff4f513          	zext.b	a0,s1
    800060da:	100007b7          	lui	a5,0x10000
    800060de:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	2b4080e7          	jalr	692(ra) # 80006396 <pop_off>
}
    800060ea:	60e2                	ld	ra,24(sp)
    800060ec:	6442                	ld	s0,16(sp)
    800060ee:	64a2                	ld	s1,8(sp)
    800060f0:	6105                	addi	sp,sp,32
    800060f2:	8082                	ret
    for(;;)
    800060f4:	a001                	j	800060f4 <uartputc_sync+0x4c>

00000000800060f6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060f6:	00006797          	auipc	a5,0x6
    800060fa:	f2a7b783          	ld	a5,-214(a5) # 8000c020 <uart_tx_r>
    800060fe:	00006717          	auipc	a4,0x6
    80006102:	f2a73703          	ld	a4,-214(a4) # 8000c028 <uart_tx_w>
    80006106:	06f70f63          	beq	a4,a5,80006184 <uartstart+0x8e>
{
    8000610a:	7139                	addi	sp,sp,-64
    8000610c:	fc06                	sd	ra,56(sp)
    8000610e:	f822                	sd	s0,48(sp)
    80006110:	f426                	sd	s1,40(sp)
    80006112:	f04a                	sd	s2,32(sp)
    80006114:	ec4e                	sd	s3,24(sp)
    80006116:	e852                	sd	s4,16(sp)
    80006118:	e456                	sd	s5,8(sp)
    8000611a:	e05a                	sd	s6,0(sp)
    8000611c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000611e:	10000937          	lui	s2,0x10000
    80006122:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006124:	00023a97          	auipc	s5,0x23
    80006128:	0e4a8a93          	addi	s5,s5,228 # 80029208 <uart_tx_lock>
    uart_tx_r += 1;
    8000612c:	00006497          	auipc	s1,0x6
    80006130:	ef448493          	addi	s1,s1,-268 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006134:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006138:	00006997          	auipc	s3,0x6
    8000613c:	ef098993          	addi	s3,s3,-272 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006140:	00094703          	lbu	a4,0(s2)
    80006144:	02077713          	andi	a4,a4,32
    80006148:	c705                	beqz	a4,80006170 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000614a:	01f7f713          	andi	a4,a5,31
    8000614e:	9756                	add	a4,a4,s5
    80006150:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006154:	0785                	addi	a5,a5,1
    80006156:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006158:	8526                	mv	a0,s1
    8000615a:	ffffb097          	auipc	ra,0xffffb
    8000615e:	5be080e7          	jalr	1470(ra) # 80001718 <wakeup>
    WriteReg(THR, c);
    80006162:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006166:	609c                	ld	a5,0(s1)
    80006168:	0009b703          	ld	a4,0(s3)
    8000616c:	fcf71ae3          	bne	a4,a5,80006140 <uartstart+0x4a>
  }
}
    80006170:	70e2                	ld	ra,56(sp)
    80006172:	7442                	ld	s0,48(sp)
    80006174:	74a2                	ld	s1,40(sp)
    80006176:	7902                	ld	s2,32(sp)
    80006178:	69e2                	ld	s3,24(sp)
    8000617a:	6a42                	ld	s4,16(sp)
    8000617c:	6aa2                	ld	s5,8(sp)
    8000617e:	6b02                	ld	s6,0(sp)
    80006180:	6121                	addi	sp,sp,64
    80006182:	8082                	ret
    80006184:	8082                	ret

0000000080006186 <uartputc>:
{
    80006186:	7179                	addi	sp,sp,-48
    80006188:	f406                	sd	ra,40(sp)
    8000618a:	f022                	sd	s0,32(sp)
    8000618c:	e052                	sd	s4,0(sp)
    8000618e:	1800                	addi	s0,sp,48
    80006190:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006192:	00023517          	auipc	a0,0x23
    80006196:	07650513          	addi	a0,a0,118 # 80029208 <uart_tx_lock>
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	1a8080e7          	jalr	424(ra) # 80006342 <acquire>
  if(panicked){
    800061a2:	00006797          	auipc	a5,0x6
    800061a6:	e7a7a783          	lw	a5,-390(a5) # 8000c01c <panicked>
    800061aa:	c391                	beqz	a5,800061ae <uartputc+0x28>
    for(;;)
    800061ac:	a001                	j	800061ac <uartputc+0x26>
    800061ae:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061b0:	00006717          	auipc	a4,0x6
    800061b4:	e7873703          	ld	a4,-392(a4) # 8000c028 <uart_tx_w>
    800061b8:	00006797          	auipc	a5,0x6
    800061bc:	e687b783          	ld	a5,-408(a5) # 8000c020 <uart_tx_r>
    800061c0:	02078793          	addi	a5,a5,32
    800061c4:	02e79f63          	bne	a5,a4,80006202 <uartputc+0x7c>
    800061c8:	e84a                	sd	s2,16(sp)
    800061ca:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800061cc:	00023997          	auipc	s3,0x23
    800061d0:	03c98993          	addi	s3,s3,60 # 80029208 <uart_tx_lock>
    800061d4:	00006497          	auipc	s1,0x6
    800061d8:	e4c48493          	addi	s1,s1,-436 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061dc:	00006917          	auipc	s2,0x6
    800061e0:	e4c90913          	addi	s2,s2,-436 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061e4:	85ce                	mv	a1,s3
    800061e6:	8526                	mv	a0,s1
    800061e8:	ffffb097          	auipc	ra,0xffffb
    800061ec:	3a4080e7          	jalr	932(ra) # 8000158c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061f0:	00093703          	ld	a4,0(s2)
    800061f4:	609c                	ld	a5,0(s1)
    800061f6:	02078793          	addi	a5,a5,32
    800061fa:	fee785e3          	beq	a5,a4,800061e4 <uartputc+0x5e>
    800061fe:	6942                	ld	s2,16(sp)
    80006200:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006202:	00023497          	auipc	s1,0x23
    80006206:	00648493          	addi	s1,s1,6 # 80029208 <uart_tx_lock>
    8000620a:	01f77793          	andi	a5,a4,31
    8000620e:	97a6                	add	a5,a5,s1
    80006210:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006214:	0705                	addi	a4,a4,1
    80006216:	00006797          	auipc	a5,0x6
    8000621a:	e0e7b923          	sd	a4,-494(a5) # 8000c028 <uart_tx_w>
      uartstart();
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	ed8080e7          	jalr	-296(ra) # 800060f6 <uartstart>
      release(&uart_tx_lock);
    80006226:	8526                	mv	a0,s1
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	1ce080e7          	jalr	462(ra) # 800063f6 <release>
    80006230:	64e2                	ld	s1,24(sp)
}
    80006232:	70a2                	ld	ra,40(sp)
    80006234:	7402                	ld	s0,32(sp)
    80006236:	6a02                	ld	s4,0(sp)
    80006238:	6145                	addi	sp,sp,48
    8000623a:	8082                	ret

000000008000623c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000623c:	1141                	addi	sp,sp,-16
    8000623e:	e422                	sd	s0,8(sp)
    80006240:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006242:	100007b7          	lui	a5,0x10000
    80006246:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006248:	0007c783          	lbu	a5,0(a5)
    8000624c:	8b85                	andi	a5,a5,1
    8000624e:	cb81                	beqz	a5,8000625e <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006250:	100007b7          	lui	a5,0x10000
    80006254:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006258:	6422                	ld	s0,8(sp)
    8000625a:	0141                	addi	sp,sp,16
    8000625c:	8082                	ret
    return -1;
    8000625e:	557d                	li	a0,-1
    80006260:	bfe5                	j	80006258 <uartgetc+0x1c>

0000000080006262 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000626c:	54fd                	li	s1,-1
    8000626e:	a029                	j	80006278 <uartintr+0x16>
      break;
    consoleintr(c);
    80006270:	00000097          	auipc	ra,0x0
    80006274:	862080e7          	jalr	-1950(ra) # 80005ad2 <consoleintr>
    int c = uartgetc();
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	fc4080e7          	jalr	-60(ra) # 8000623c <uartgetc>
    if(c == -1)
    80006280:	fe9518e3          	bne	a0,s1,80006270 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006284:	00023497          	auipc	s1,0x23
    80006288:	f8448493          	addi	s1,s1,-124 # 80029208 <uart_tx_lock>
    8000628c:	8526                	mv	a0,s1
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	0b4080e7          	jalr	180(ra) # 80006342 <acquire>
  uartstart();
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	e60080e7          	jalr	-416(ra) # 800060f6 <uartstart>
  release(&uart_tx_lock);
    8000629e:	8526                	mv	a0,s1
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	156080e7          	jalr	342(ra) # 800063f6 <release>
}
    800062a8:	60e2                	ld	ra,24(sp)
    800062aa:	6442                	ld	s0,16(sp)
    800062ac:	64a2                	ld	s1,8(sp)
    800062ae:	6105                	addi	sp,sp,32
    800062b0:	8082                	ret

00000000800062b2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062b2:	1141                	addi	sp,sp,-16
    800062b4:	e422                	sd	s0,8(sp)
    800062b6:	0800                	addi	s0,sp,16
  lk->name = name;
    800062b8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062ba:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062be:	00053823          	sd	zero,16(a0)
}
    800062c2:	6422                	ld	s0,8(sp)
    800062c4:	0141                	addi	sp,sp,16
    800062c6:	8082                	ret

00000000800062c8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062c8:	411c                	lw	a5,0(a0)
    800062ca:	e399                	bnez	a5,800062d0 <holding+0x8>
    800062cc:	4501                	li	a0,0
  return r;
}
    800062ce:	8082                	ret
{
    800062d0:	1101                	addi	sp,sp,-32
    800062d2:	ec06                	sd	ra,24(sp)
    800062d4:	e822                	sd	s0,16(sp)
    800062d6:	e426                	sd	s1,8(sp)
    800062d8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062da:	6904                	ld	s1,16(a0)
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	b84080e7          	jalr	-1148(ra) # 80000e60 <mycpu>
    800062e4:	40a48533          	sub	a0,s1,a0
    800062e8:	00153513          	seqz	a0,a0
}
    800062ec:	60e2                	ld	ra,24(sp)
    800062ee:	6442                	ld	s0,16(sp)
    800062f0:	64a2                	ld	s1,8(sp)
    800062f2:	6105                	addi	sp,sp,32
    800062f4:	8082                	ret

00000000800062f6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062f6:	1101                	addi	sp,sp,-32
    800062f8:	ec06                	sd	ra,24(sp)
    800062fa:	e822                	sd	s0,16(sp)
    800062fc:	e426                	sd	s1,8(sp)
    800062fe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006300:	100024f3          	csrr	s1,sstatus
    80006304:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006308:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000630a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000630e:	ffffb097          	auipc	ra,0xffffb
    80006312:	b52080e7          	jalr	-1198(ra) # 80000e60 <mycpu>
    80006316:	5d3c                	lw	a5,120(a0)
    80006318:	cf89                	beqz	a5,80006332 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000631a:	ffffb097          	auipc	ra,0xffffb
    8000631e:	b46080e7          	jalr	-1210(ra) # 80000e60 <mycpu>
    80006322:	5d3c                	lw	a5,120(a0)
    80006324:	2785                	addiw	a5,a5,1
    80006326:	dd3c                	sw	a5,120(a0)
}
    80006328:	60e2                	ld	ra,24(sp)
    8000632a:	6442                	ld	s0,16(sp)
    8000632c:	64a2                	ld	s1,8(sp)
    8000632e:	6105                	addi	sp,sp,32
    80006330:	8082                	ret
    mycpu()->intena = old;
    80006332:	ffffb097          	auipc	ra,0xffffb
    80006336:	b2e080e7          	jalr	-1234(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000633a:	8085                	srli	s1,s1,0x1
    8000633c:	8885                	andi	s1,s1,1
    8000633e:	dd64                	sw	s1,124(a0)
    80006340:	bfe9                	j	8000631a <push_off+0x24>

0000000080006342 <acquire>:
{
    80006342:	1101                	addi	sp,sp,-32
    80006344:	ec06                	sd	ra,24(sp)
    80006346:	e822                	sd	s0,16(sp)
    80006348:	e426                	sd	s1,8(sp)
    8000634a:	1000                	addi	s0,sp,32
    8000634c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	fa8080e7          	jalr	-88(ra) # 800062f6 <push_off>
  if(holding(lk))
    80006356:	8526                	mv	a0,s1
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	f70080e7          	jalr	-144(ra) # 800062c8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006360:	4705                	li	a4,1
  if(holding(lk))
    80006362:	e115                	bnez	a0,80006386 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006364:	87ba                	mv	a5,a4
    80006366:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000636a:	2781                	sext.w	a5,a5
    8000636c:	ffe5                	bnez	a5,80006364 <acquire+0x22>
  __sync_synchronize();
    8000636e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006372:	ffffb097          	auipc	ra,0xffffb
    80006376:	aee080e7          	jalr	-1298(ra) # 80000e60 <mycpu>
    8000637a:	e888                	sd	a0,16(s1)
}
    8000637c:	60e2                	ld	ra,24(sp)
    8000637e:	6442                	ld	s0,16(sp)
    80006380:	64a2                	ld	s1,8(sp)
    80006382:	6105                	addi	sp,sp,32
    80006384:	8082                	ret
    panic("acquire");
    80006386:	00002517          	auipc	a0,0x2
    8000638a:	36250513          	addi	a0,a0,866 # 800086e8 <etext+0x6e8>
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	a64080e7          	jalr	-1436(ra) # 80005df2 <panic>

0000000080006396 <pop_off>:

void
pop_off(void)
{
    80006396:	1141                	addi	sp,sp,-16
    80006398:	e406                	sd	ra,8(sp)
    8000639a:	e022                	sd	s0,0(sp)
    8000639c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000639e:	ffffb097          	auipc	ra,0xffffb
    800063a2:	ac2080e7          	jalr	-1342(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063aa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063ac:	e78d                	bnez	a5,800063d6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063ae:	5d3c                	lw	a5,120(a0)
    800063b0:	02f05b63          	blez	a5,800063e6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063b4:	37fd                	addiw	a5,a5,-1
    800063b6:	0007871b          	sext.w	a4,a5
    800063ba:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063bc:	eb09                	bnez	a4,800063ce <pop_off+0x38>
    800063be:	5d7c                	lw	a5,124(a0)
    800063c0:	c799                	beqz	a5,800063ce <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063ca:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063ce:	60a2                	ld	ra,8(sp)
    800063d0:	6402                	ld	s0,0(sp)
    800063d2:	0141                	addi	sp,sp,16
    800063d4:	8082                	ret
    panic("pop_off - interruptible");
    800063d6:	00002517          	auipc	a0,0x2
    800063da:	31a50513          	addi	a0,a0,794 # 800086f0 <etext+0x6f0>
    800063de:	00000097          	auipc	ra,0x0
    800063e2:	a14080e7          	jalr	-1516(ra) # 80005df2 <panic>
    panic("pop_off");
    800063e6:	00002517          	auipc	a0,0x2
    800063ea:	32250513          	addi	a0,a0,802 # 80008708 <etext+0x708>
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	a04080e7          	jalr	-1532(ra) # 80005df2 <panic>

00000000800063f6 <release>:
{
    800063f6:	1101                	addi	sp,sp,-32
    800063f8:	ec06                	sd	ra,24(sp)
    800063fa:	e822                	sd	s0,16(sp)
    800063fc:	e426                	sd	s1,8(sp)
    800063fe:	1000                	addi	s0,sp,32
    80006400:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006402:	00000097          	auipc	ra,0x0
    80006406:	ec6080e7          	jalr	-314(ra) # 800062c8 <holding>
    8000640a:	c115                	beqz	a0,8000642e <release+0x38>
  lk->cpu = 0;
    8000640c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006410:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006414:	0310000f          	fence	rw,w
    80006418:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000641c:	00000097          	auipc	ra,0x0
    80006420:	f7a080e7          	jalr	-134(ra) # 80006396 <pop_off>
}
    80006424:	60e2                	ld	ra,24(sp)
    80006426:	6442                	ld	s0,16(sp)
    80006428:	64a2                	ld	s1,8(sp)
    8000642a:	6105                	addi	sp,sp,32
    8000642c:	8082                	ret
    panic("release");
    8000642e:	00002517          	auipc	a0,0x2
    80006432:	2e250513          	addi	a0,a0,738 # 80008710 <etext+0x710>
    80006436:	00000097          	auipc	ra,0x0
    8000643a:	9bc080e7          	jalr	-1604(ra) # 80005df2 <panic>
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
