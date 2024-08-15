
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	12013103          	ld	sp,288(sp) # 8000b120 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	389050ef          	jal	80005b9e <start>

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
    80000030:	00033797          	auipc	a5,0x33
    80000034:	21078793          	addi	a5,a5,528 # 80033240 <end>
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
    8000005e:	58c080e7          	jalr	1420(ra) # 800065e6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	62c080e7          	jalr	1580(ra) # 8000669a <release>
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
    8000008e:	fe2080e7          	jalr	-30(ra) # 8000606c <panic>

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
    800000fa:	460080e7          	jalr	1120(ra) # 80006556 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00033517          	auipc	a0,0x33
    80000106:	13e50513          	addi	a0,a0,318 # 80033240 <end>
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
    80000132:	4b8080e7          	jalr	1208(ra) # 800065e6 <acquire>
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
    8000014a:	554080e7          	jalr	1364(ra) # 8000669a <release>

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
    80000174:	52a080e7          	jalr	1322(ra) # 8000669a <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffcbdc1>
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
    80000324:	b0e080e7          	jalr	-1266(ra) # 80000e2e <cpuid>
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
    80000340:	af2080e7          	jalr	-1294(ra) # 80000e2e <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	d68080e7          	jalr	-664(ra) # 800060b6 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	7f6080e7          	jalr	2038(ra) # 80001b54 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	1ee080e7          	jalr	494(ra) # 80005554 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	03a080e7          	jalr	58(ra) # 800013a8 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	c06080e7          	jalr	-1018(ra) # 80005f7c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	f40080e7          	jalr	-192(ra) # 800062be <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	d28080e7          	jalr	-728(ra) # 800060b6 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	d18080e7          	jalr	-744(ra) # 800060b6 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	d08080e7          	jalr	-760(ra) # 800060b6 <printf>
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
    800003d2:	9a6080e7          	jalr	-1626(ra) # 80000d74 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	756080e7          	jalr	1878(ra) # 80001b2c <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	776080e7          	jalr	1910(ra) # 80001b54 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	154080e7          	jalr	340(ra) # 8000553a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	166080e7          	jalr	358(ra) # 80005554 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	006080e7          	jalr	6(ra) # 800023fc <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	692080e7          	jalr	1682(ra) # 80002a90 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	636080e7          	jalr	1590(ra) # 80003a3c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	266080e7          	jalr	614(ra) # 80005674 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d1c080e7          	jalr	-740(ra) # 80001132 <userinit>
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
    80000484:	bec080e7          	jalr	-1044(ra) # 8000606c <panic>
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
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffcbdb7>
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
    800005aa:	ac6080e7          	jalr	-1338(ra) # 8000606c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	ab6080e7          	jalr	-1354(ra) # 8000606c <panic>
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
    80000606:	a6a080e7          	jalr	-1430(ra) # 8000606c <panic>

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
    800006ce:	60a080e7          	jalr	1546(ra) # 80000cd4 <proc_mapstacks>
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
    8000071e:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	slli	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	6a85                	lui	s5,0x1
    8000072a:	0935f463          	bgeu	a1,s3,800007b2 <uvmunmap+0xb2>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a0a9                	j	8000077a <uvmunmap+0x7a>
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
    80000748:	00006097          	auipc	ra,0x6
    8000074c:	924080e7          	jalr	-1756(ra) # 8000606c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00006097          	auipc	ra,0x6
    8000075c:	914080e7          	jalr	-1772(ra) # 8000606c <panic>
      panic("uvmunmap: not a leaf");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00006097          	auipc	ra,0x6
    8000076c:	904080e7          	jalr	-1788(ra) # 8000606c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000770:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000774:	9956                	add	s2,s2,s5
    80000776:	03397d63          	bgeu	s2,s3,800007b0 <uvmunmap+0xb0>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000077a:	4601                	li	a2,0
    8000077c:	85ca                	mv	a1,s2
    8000077e:	8552                	mv	a0,s4
    80000780:	00000097          	auipc	ra,0x0
    80000784:	cd2080e7          	jalr	-814(ra) # 80000452 <walk>
    80000788:	84aa                	mv	s1,a0
    8000078a:	d179                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000078c:	611c                	ld	a5,0(a0)
    8000078e:	0017f713          	andi	a4,a5,1
    80000792:	d36d                	beqz	a4,80000774 <uvmunmap+0x74>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000794:	3ff7f713          	andi	a4,a5,1023
    80000798:	fd7704e3          	beq	a4,s7,80000760 <uvmunmap+0x60>
    if(do_free){
    8000079c:	fc0b0ae3          	beqz	s6,80000770 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800007a0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007a2:	00c79513          	slli	a0,a5,0xc
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	876080e7          	jalr	-1930(ra) # 8000001c <kfree>
    800007ae:	b7c9                	j	80000770 <uvmunmap+0x70>
    800007b0:	74e2                	ld	s1,56(sp)
    800007b2:	7942                	ld	s2,48(sp)
    800007b4:	79a2                	ld	s3,40(sp)
    800007b6:	7a02                	ld	s4,32(sp)
    800007b8:	6ae2                	ld	s5,24(sp)
    800007ba:	6b42                	ld	s6,16(sp)
    800007bc:	6ba2                	ld	s7,8(sp)
  }
}
    800007be:	60a6                	ld	ra,72(sp)
    800007c0:	6406                	ld	s0,64(sp)
    800007c2:	6161                	addi	sp,sp,80
    800007c4:	8082                	ret

00000000800007c6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c6:	1101                	addi	sp,sp,-32
    800007c8:	ec06                	sd	ra,24(sp)
    800007ca:	e822                	sd	s0,16(sp)
    800007cc:	e426                	sd	s1,8(sp)
    800007ce:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	94a080e7          	jalr	-1718(ra) # 8000011a <kalloc>
    800007d8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007da:	c519                	beqz	a0,800007e8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007dc:	6605                	lui	a2,0x1
    800007de:	4581                	li	a1,0
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	99a080e7          	jalr	-1638(ra) # 8000017a <memset>
  return pagetable;
}
    800007e8:	8526                	mv	a0,s1
    800007ea:	60e2                	ld	ra,24(sp)
    800007ec:	6442                	ld	s0,16(sp)
    800007ee:	64a2                	ld	s1,8(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret

00000000800007f4 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f4:	7179                	addi	sp,sp,-48
    800007f6:	f406                	sd	ra,40(sp)
    800007f8:	f022                	sd	s0,32(sp)
    800007fa:	ec26                	sd	s1,24(sp)
    800007fc:	e84a                	sd	s2,16(sp)
    800007fe:	e44e                	sd	s3,8(sp)
    80000800:	e052                	sd	s4,0(sp)
    80000802:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000804:	6785                	lui	a5,0x1
    80000806:	04f67863          	bgeu	a2,a5,80000856 <uvminit+0x62>
    8000080a:	8a2a                	mv	s4,a0
    8000080c:	89ae                	mv	s3,a1
    8000080e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	90a080e7          	jalr	-1782(ra) # 8000011a <kalloc>
    80000818:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081a:	6605                	lui	a2,0x1
    8000081c:	4581                	li	a1,0
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	95c080e7          	jalr	-1700(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000826:	4779                	li	a4,30
    80000828:	86ca                	mv	a3,s2
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	8552                	mv	a0,s4
    80000830:	00000097          	auipc	ra,0x0
    80000834:	d0a080e7          	jalr	-758(ra) # 8000053a <mappages>
  memmove(mem, src, sz);
    80000838:	8626                	mv	a2,s1
    8000083a:	85ce                	mv	a1,s3
    8000083c:	854a                	mv	a0,s2
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	998080e7          	jalr	-1640(ra) # 800001d6 <memmove>
}
    80000846:	70a2                	ld	ra,40(sp)
    80000848:	7402                	ld	s0,32(sp)
    8000084a:	64e2                	ld	s1,24(sp)
    8000084c:	6942                	ld	s2,16(sp)
    8000084e:	69a2                	ld	s3,8(sp)
    80000850:	6a02                	ld	s4,0(sp)
    80000852:	6145                	addi	sp,sp,48
    80000854:	8082                	ret
    panic("inituvm: more than a page");
    80000856:	00008517          	auipc	a0,0x8
    8000085a:	86a50513          	addi	a0,a0,-1942 # 800080c0 <etext+0xc0>
    8000085e:	00006097          	auipc	ra,0x6
    80000862:	80e080e7          	jalr	-2034(ra) # 8000606c <panic>

0000000080000866 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000866:	1101                	addi	sp,sp,-32
    80000868:	ec06                	sd	ra,24(sp)
    8000086a:	e822                	sd	s0,16(sp)
    8000086c:	e426                	sd	s1,8(sp)
    8000086e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000870:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000872:	00b67d63          	bgeu	a2,a1,8000088c <uvmdealloc+0x26>
    80000876:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000878:	6785                	lui	a5,0x1
    8000087a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000087c:	00f60733          	add	a4,a2,a5
    80000880:	76fd                	lui	a3,0xfffff
    80000882:	8f75                	and	a4,a4,a3
    80000884:	97ae                	add	a5,a5,a1
    80000886:	8ff5                	and	a5,a5,a3
    80000888:	00f76863          	bltu	a4,a5,80000898 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000088c:	8526                	mv	a0,s1
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000898:	8f99                	sub	a5,a5,a4
    8000089a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000089c:	4685                	li	a3,1
    8000089e:	0007861b          	sext.w	a2,a5
    800008a2:	85ba                	mv	a1,a4
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	e5c080e7          	jalr	-420(ra) # 80000700 <uvmunmap>
    800008ac:	b7c5                	j	8000088c <uvmdealloc+0x26>

00000000800008ae <uvmalloc>:
  if(newsz < oldsz)
    800008ae:	0ab66563          	bltu	a2,a1,80000958 <uvmalloc+0xaa>
{
    800008b2:	7139                	addi	sp,sp,-64
    800008b4:	fc06                	sd	ra,56(sp)
    800008b6:	f822                	sd	s0,48(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	0080                	addi	s0,sp,64
    800008c0:	8aaa                	mv	s5,a0
    800008c2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c4:	6785                	lui	a5,0x1
    800008c6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008c8:	95be                	add	a1,a1,a5
    800008ca:	77fd                	lui	a5,0xfffff
    800008cc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d0:	08c9f663          	bgeu	s3,a2,8000095c <uvmalloc+0xae>
    800008d4:	f426                	sd	s1,40(sp)
    800008d6:	f04a                	sd	s2,32(sp)
    800008d8:	894e                	mv	s2,s3
    mem = kalloc();
    800008da:	00000097          	auipc	ra,0x0
    800008de:	840080e7          	jalr	-1984(ra) # 8000011a <kalloc>
    800008e2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e4:	c90d                	beqz	a0,80000916 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008e6:	6605                	lui	a2,0x1
    800008e8:	4581                	li	a1,0
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	890080e7          	jalr	-1904(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f2:	4779                	li	a4,30
    800008f4:	86a6                	mv	a3,s1
    800008f6:	6605                	lui	a2,0x1
    800008f8:	85ca                	mv	a1,s2
    800008fa:	8556                	mv	a0,s5
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	c3e080e7          	jalr	-962(ra) # 8000053a <mappages>
    80000904:	e915                	bnez	a0,80000938 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	6785                	lui	a5,0x1
    80000908:	993e                	add	s2,s2,a5
    8000090a:	fd4968e3          	bltu	s2,s4,800008da <uvmalloc+0x2c>
  return newsz;
    8000090e:	8552                	mv	a0,s4
    80000910:	74a2                	ld	s1,40(sp)
    80000912:	7902                	ld	s2,32(sp)
    80000914:	a819                	j	8000092a <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000916:	864e                	mv	a2,s3
    80000918:	85ca                	mv	a1,s2
    8000091a:	8556                	mv	a0,s5
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	f4a080e7          	jalr	-182(ra) # 80000866 <uvmdealloc>
      return 0;
    80000924:	4501                	li	a0,0
    80000926:	74a2                	ld	s1,40(sp)
    80000928:	7902                	ld	s2,32(sp)
}
    8000092a:	70e2                	ld	ra,56(sp)
    8000092c:	7442                	ld	s0,48(sp)
    8000092e:	69e2                	ld	s3,24(sp)
    80000930:	6a42                	ld	s4,16(sp)
    80000932:	6aa2                	ld	s5,8(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f1e080e7          	jalr	-226(ra) # 80000866 <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	74a2                	ld	s1,40(sp)
    80000954:	7902                	ld	s2,32(sp)
    80000956:	bfd1                	j	8000092a <uvmalloc+0x7c>
    return oldsz;
    80000958:	852e                	mv	a0,a1
}
    8000095a:	8082                	ret
  return newsz;
    8000095c:	8532                	mv	a0,a2
    8000095e:	b7f1                	j	8000092a <uvmalloc+0x7c>

0000000080000960 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000960:	7179                	addi	sp,sp,-48
    80000962:	f406                	sd	ra,40(sp)
    80000964:	f022                	sd	s0,32(sp)
    80000966:	ec26                	sd	s1,24(sp)
    80000968:	e84a                	sd	s2,16(sp)
    8000096a:	e44e                	sd	s3,8(sp)
    8000096c:	e052                	sd	s4,0(sp)
    8000096e:	1800                	addi	s0,sp,48
    80000970:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000972:	84aa                	mv	s1,a0
    80000974:	6905                	lui	s2,0x1
    80000976:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000978:	4985                	li	s3,1
    8000097a:	a829                	j	80000994 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097e:	00c79513          	slli	a0,a5,0xc
    80000982:	00000097          	auipc	ra,0x0
    80000986:	fde080e7          	jalr	-34(ra) # 80000960 <freewalk>
      pagetable[i] = 0;
    8000098a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098e:	04a1                	addi	s1,s1,8
    80000990:	03248163          	beq	s1,s2,800009b2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000994:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000996:	00f7f713          	andi	a4,a5,15
    8000099a:	ff3701e3          	beq	a4,s3,8000097c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099e:	8b85                	andi	a5,a5,1
    800009a0:	d7fd                	beqz	a5,8000098e <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a2:	00007517          	auipc	a0,0x7
    800009a6:	73e50513          	addi	a0,a0,1854 # 800080e0 <etext+0xe0>
    800009aa:	00005097          	auipc	ra,0x5
    800009ae:	6c2080e7          	jalr	1730(ra) # 8000606c <panic>
    }
  }
  kfree((void*)pagetable);
    800009b2:	8552                	mv	a0,s4
    800009b4:	fffff097          	auipc	ra,0xfffff
    800009b8:	668080e7          	jalr	1640(ra) # 8000001c <kfree>
}
    800009bc:	70a2                	ld	ra,40(sp)
    800009be:	7402                	ld	s0,32(sp)
    800009c0:	64e2                	ld	s1,24(sp)
    800009c2:	6942                	ld	s2,16(sp)
    800009c4:	69a2                	ld	s3,8(sp)
    800009c6:	6a02                	ld	s4,0(sp)
    800009c8:	6145                	addi	sp,sp,48
    800009ca:	8082                	ret

00000000800009cc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009cc:	1101                	addi	sp,sp,-32
    800009ce:	ec06                	sd	ra,24(sp)
    800009d0:	e822                	sd	s0,16(sp)
    800009d2:	e426                	sd	s1,8(sp)
    800009d4:	1000                	addi	s0,sp,32
    800009d6:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d8:	e999                	bnez	a1,800009ee <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009da:	8526                	mv	a0,s1
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	f84080e7          	jalr	-124(ra) # 80000960 <freewalk>
}
    800009e4:	60e2                	ld	ra,24(sp)
    800009e6:	6442                	ld	s0,16(sp)
    800009e8:	64a2                	ld	s1,8(sp)
    800009ea:	6105                	addi	sp,sp,32
    800009ec:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ee:	6785                	lui	a5,0x1
    800009f0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f2:	95be                	add	a1,a1,a5
    800009f4:	4685                	li	a3,1
    800009f6:	00c5d613          	srli	a2,a1,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d04080e7          	jalr	-764(ra) # 80000700 <uvmunmap>
    80000a04:	bfd9                	j	800009da <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c269                	beqz	a2,80000ac8 <uvmcopy+0xc2>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8aaa                	mv	s5,a0
    80000a20:	8b2e                	mv	s6,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4481                	li	s1,0
    80000a26:	a829                	j	80000a40 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a28:	00007517          	auipc	a0,0x7
    80000a2c:	6c850513          	addi	a0,a0,1736 # 800080f0 <etext+0xf0>
    80000a30:	00005097          	auipc	ra,0x5
    80000a34:	63c080e7          	jalr	1596(ra) # 8000606c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a38:	6785                	lui	a5,0x1
    80000a3a:	94be                	add	s1,s1,a5
    80000a3c:	0944f463          	bgeu	s1,s4,80000ac4 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a40:	4601                	li	a2,0
    80000a42:	85a6                	mv	a1,s1
    80000a44:	8556                	mv	a0,s5
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	a0c080e7          	jalr	-1524(ra) # 80000452 <walk>
    80000a4e:	dd69                	beqz	a0,80000a28 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    80000a50:	6118                	ld	a4,0(a0)
    80000a52:	00177793          	andi	a5,a4,1
    80000a56:	d3ed                	beqz	a5,80000a38 <uvmcopy+0x32>
      continue;
    pa = PTE2PA(*pte);
    80000a58:	00a75593          	srli	a1,a4,0xa
    80000a5c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a60:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	6b6080e7          	jalr	1718(ra) # 8000011a <kalloc>
    80000a6c:	89aa                	mv	s3,a0
    80000a6e:	c515                	beqz	a0,80000a9a <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85de                	mv	a1,s7
    80000a74:	fffff097          	auipc	ra,0xfffff
    80000a78:	762080e7          	jalr	1890(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a7c:	874a                	mv	a4,s2
    80000a7e:	86ce                	mv	a3,s3
    80000a80:	6605                	lui	a2,0x1
    80000a82:	85a6                	mv	a1,s1
    80000a84:	855a                	mv	a0,s6
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	ab4080e7          	jalr	-1356(ra) # 8000053a <mappages>
    80000a8e:	d54d                	beqz	a0,80000a38 <uvmcopy+0x32>
      kfree(mem);
    80000a90:	854e                	mv	a0,s3
    80000a92:	fffff097          	auipc	ra,0xfffff
    80000a96:	58a080e7          	jalr	1418(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a9a:	4685                	li	a3,1
    80000a9c:	00c4d613          	srli	a2,s1,0xc
    80000aa0:	4581                	li	a1,0
    80000aa2:	855a                	mv	a0,s6
    80000aa4:	00000097          	auipc	ra,0x0
    80000aa8:	c5c080e7          	jalr	-932(ra) # 80000700 <uvmunmap>
  return -1;
    80000aac:	557d                	li	a0,-1
}
    80000aae:	60a6                	ld	ra,72(sp)
    80000ab0:	6406                	ld	s0,64(sp)
    80000ab2:	74e2                	ld	s1,56(sp)
    80000ab4:	7942                	ld	s2,48(sp)
    80000ab6:	79a2                	ld	s3,40(sp)
    80000ab8:	7a02                	ld	s4,32(sp)
    80000aba:	6ae2                	ld	s5,24(sp)
    80000abc:	6b42                	ld	s6,16(sp)
    80000abe:	6ba2                	ld	s7,8(sp)
    80000ac0:	6161                	addi	sp,sp,80
    80000ac2:	8082                	ret
  return 0;
    80000ac4:	4501                	li	a0,0
    80000ac6:	b7e5                	j	80000aae <uvmcopy+0xa8>
    80000ac8:	4501                	li	a0,0
}
    80000aca:	8082                	ret

0000000080000acc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000acc:	1141                	addi	sp,sp,-16
    80000ace:	e406                	sd	ra,8(sp)
    80000ad0:	e022                	sd	s0,0(sp)
    80000ad2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad4:	4601                	li	a2,0
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	97c080e7          	jalr	-1668(ra) # 80000452 <walk>
  if(pte == 0)
    80000ade:	c901                	beqz	a0,80000aee <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae0:	611c                	ld	a5,0(a0)
    80000ae2:	9bbd                	andi	a5,a5,-17
    80000ae4:	e11c                	sd	a5,0(a0)
}
    80000ae6:	60a2                	ld	ra,8(sp)
    80000ae8:	6402                	ld	s0,0(sp)
    80000aea:	0141                	addi	sp,sp,16
    80000aec:	8082                	ret
    panic("uvmclear");
    80000aee:	00007517          	auipc	a0,0x7
    80000af2:	62250513          	addi	a0,a0,1570 # 80008110 <etext+0x110>
    80000af6:	00005097          	auipc	ra,0x5
    80000afa:	576080e7          	jalr	1398(ra) # 8000606c <panic>

0000000080000afe <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000afe:	c6bd                	beqz	a3,80000b6c <copyout+0x6e>
{
    80000b00:	715d                	addi	sp,sp,-80
    80000b02:	e486                	sd	ra,72(sp)
    80000b04:	e0a2                	sd	s0,64(sp)
    80000b06:	fc26                	sd	s1,56(sp)
    80000b08:	f84a                	sd	s2,48(sp)
    80000b0a:	f44e                	sd	s3,40(sp)
    80000b0c:	f052                	sd	s4,32(sp)
    80000b0e:	ec56                	sd	s5,24(sp)
    80000b10:	e85a                	sd	s6,16(sp)
    80000b12:	e45e                	sd	s7,8(sp)
    80000b14:	e062                	sd	s8,0(sp)
    80000b16:	0880                	addi	s0,sp,80
    80000b18:	8b2a                	mv	s6,a0
    80000b1a:	8c2e                	mv	s8,a1
    80000b1c:	8a32                	mv	s4,a2
    80000b1e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b20:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b22:	6a85                	lui	s5,0x1
    80000b24:	a015                	j	80000b48 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b26:	9562                	add	a0,a0,s8
    80000b28:	0004861b          	sext.w	a2,s1
    80000b2c:	85d2                	mv	a1,s4
    80000b2e:	41250533          	sub	a0,a0,s2
    80000b32:	fffff097          	auipc	ra,0xfffff
    80000b36:	6a4080e7          	jalr	1700(ra) # 800001d6 <memmove>

    len -= n;
    80000b3a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b3e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b40:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b44:	02098263          	beqz	s3,80000b68 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b48:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b4c:	85ca                	mv	a1,s2
    80000b4e:	855a                	mv	a0,s6
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	9a8080e7          	jalr	-1624(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b58:	cd01                	beqz	a0,80000b70 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b5a:	418904b3          	sub	s1,s2,s8
    80000b5e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b60:	fc99f3e3          	bgeu	s3,s1,80000b26 <copyout+0x28>
    80000b64:	84ce                	mv	s1,s3
    80000b66:	b7c1                	j	80000b26 <copyout+0x28>
  }
  return 0;
    80000b68:	4501                	li	a0,0
    80000b6a:	a021                	j	80000b72 <copyout+0x74>
    80000b6c:	4501                	li	a0,0
}
    80000b6e:	8082                	ret
      return -1;
    80000b70:	557d                	li	a0,-1
}
    80000b72:	60a6                	ld	ra,72(sp)
    80000b74:	6406                	ld	s0,64(sp)
    80000b76:	74e2                	ld	s1,56(sp)
    80000b78:	7942                	ld	s2,48(sp)
    80000b7a:	79a2                	ld	s3,40(sp)
    80000b7c:	7a02                	ld	s4,32(sp)
    80000b7e:	6ae2                	ld	s5,24(sp)
    80000b80:	6b42                	ld	s6,16(sp)
    80000b82:	6ba2                	ld	s7,8(sp)
    80000b84:	6c02                	ld	s8,0(sp)
    80000b86:	6161                	addi	sp,sp,80
    80000b88:	8082                	ret

0000000080000b8a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b8a:	caa5                	beqz	a3,80000bfa <copyin+0x70>
{
    80000b8c:	715d                	addi	sp,sp,-80
    80000b8e:	e486                	sd	ra,72(sp)
    80000b90:	e0a2                	sd	s0,64(sp)
    80000b92:	fc26                	sd	s1,56(sp)
    80000b94:	f84a                	sd	s2,48(sp)
    80000b96:	f44e                	sd	s3,40(sp)
    80000b98:	f052                	sd	s4,32(sp)
    80000b9a:	ec56                	sd	s5,24(sp)
    80000b9c:	e85a                	sd	s6,16(sp)
    80000b9e:	e45e                	sd	s7,8(sp)
    80000ba0:	e062                	sd	s8,0(sp)
    80000ba2:	0880                	addi	s0,sp,80
    80000ba4:	8b2a                	mv	s6,a0
    80000ba6:	8a2e                	mv	s4,a1
    80000ba8:	8c32                	mv	s8,a2
    80000baa:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bac:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bae:	6a85                	lui	s5,0x1
    80000bb0:	a01d                	j	80000bd6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb2:	018505b3          	add	a1,a0,s8
    80000bb6:	0004861b          	sext.w	a2,s1
    80000bba:	412585b3          	sub	a1,a1,s2
    80000bbe:	8552                	mv	a0,s4
    80000bc0:	fffff097          	auipc	ra,0xfffff
    80000bc4:	616080e7          	jalr	1558(ra) # 800001d6 <memmove>

    len -= n;
    80000bc8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bcc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bce:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bd2:	02098263          	beqz	s3,80000bf6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bd6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bda:	85ca                	mv	a1,s2
    80000bdc:	855a                	mv	a0,s6
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	91a080e7          	jalr	-1766(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000be6:	cd01                	beqz	a0,80000bfe <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000be8:	418904b3          	sub	s1,s2,s8
    80000bec:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bee:	fc99f2e3          	bgeu	s3,s1,80000bb2 <copyin+0x28>
    80000bf2:	84ce                	mv	s1,s3
    80000bf4:	bf7d                	j	80000bb2 <copyin+0x28>
  }
  return 0;
    80000bf6:	4501                	li	a0,0
    80000bf8:	a021                	j	80000c00 <copyin+0x76>
    80000bfa:	4501                	li	a0,0
}
    80000bfc:	8082                	ret
      return -1;
    80000bfe:	557d                	li	a0,-1
}
    80000c00:	60a6                	ld	ra,72(sp)
    80000c02:	6406                	ld	s0,64(sp)
    80000c04:	74e2                	ld	s1,56(sp)
    80000c06:	7942                	ld	s2,48(sp)
    80000c08:	79a2                	ld	s3,40(sp)
    80000c0a:	7a02                	ld	s4,32(sp)
    80000c0c:	6ae2                	ld	s5,24(sp)
    80000c0e:	6b42                	ld	s6,16(sp)
    80000c10:	6ba2                	ld	s7,8(sp)
    80000c12:	6c02                	ld	s8,0(sp)
    80000c14:	6161                	addi	sp,sp,80
    80000c16:	8082                	ret

0000000080000c18 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c18:	cacd                	beqz	a3,80000cca <copyinstr+0xb2>
{
    80000c1a:	715d                	addi	sp,sp,-80
    80000c1c:	e486                	sd	ra,72(sp)
    80000c1e:	e0a2                	sd	s0,64(sp)
    80000c20:	fc26                	sd	s1,56(sp)
    80000c22:	f84a                	sd	s2,48(sp)
    80000c24:	f44e                	sd	s3,40(sp)
    80000c26:	f052                	sd	s4,32(sp)
    80000c28:	ec56                	sd	s5,24(sp)
    80000c2a:	e85a                	sd	s6,16(sp)
    80000c2c:	e45e                	sd	s7,8(sp)
    80000c2e:	0880                	addi	s0,sp,80
    80000c30:	8a2a                	mv	s4,a0
    80000c32:	8b2e                	mv	s6,a1
    80000c34:	8bb2                	mv	s7,a2
    80000c36:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c38:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3a:	6985                	lui	s3,0x1
    80000c3c:	a825                	j	80000c74 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c3e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c42:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c44:	37fd                	addiw	a5,a5,-1
    80000c46:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c4a:	60a6                	ld	ra,72(sp)
    80000c4c:	6406                	ld	s0,64(sp)
    80000c4e:	74e2                	ld	s1,56(sp)
    80000c50:	7942                	ld	s2,48(sp)
    80000c52:	79a2                	ld	s3,40(sp)
    80000c54:	7a02                	ld	s4,32(sp)
    80000c56:	6ae2                	ld	s5,24(sp)
    80000c58:	6b42                	ld	s6,16(sp)
    80000c5a:	6ba2                	ld	s7,8(sp)
    80000c5c:	6161                	addi	sp,sp,80
    80000c5e:	8082                	ret
    80000c60:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c64:	9742                	add	a4,a4,a6
      --max;
    80000c66:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c6a:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c6e:	04e58663          	beq	a1,a4,80000cba <copyinstr+0xa2>
{
    80000c72:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c74:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c78:	85a6                	mv	a1,s1
    80000c7a:	8552                	mv	a0,s4
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	87c080e7          	jalr	-1924(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c84:	cd0d                	beqz	a0,80000cbe <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000c86:	417486b3          	sub	a3,s1,s7
    80000c8a:	96ce                	add	a3,a3,s3
    if(n > max)
    80000c8c:	00d97363          	bgeu	s2,a3,80000c92 <copyinstr+0x7a>
    80000c90:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000c92:	955e                	add	a0,a0,s7
    80000c94:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000c96:	c695                	beqz	a3,80000cc2 <copyinstr+0xaa>
    80000c98:	87da                	mv	a5,s6
    80000c9a:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000c9c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca0:	96da                	add	a3,a3,s6
    80000ca2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffcbdc0>
    80000cac:	db49                	beqz	a4,80000c3e <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cb2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb4:	fed797e3          	bne	a5,a3,80000ca2 <copyinstr+0x8a>
    80000cb8:	b765                	j	80000c60 <copyinstr+0x48>
    80000cba:	4781                	li	a5,0
    80000cbc:	b761                	j	80000c44 <copyinstr+0x2c>
      return -1;
    80000cbe:	557d                	li	a0,-1
    80000cc0:	b769                	j	80000c4a <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cc2:	6b85                	lui	s7,0x1
    80000cc4:	9ba6                	add	s7,s7,s1
    80000cc6:	87da                	mv	a5,s6
    80000cc8:	b76d                	j	80000c72 <copyinstr+0x5a>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	37fd                	addiw	a5,a5,-1
    80000cce:	0007851b          	sext.w	a0,a5
}
    80000cd2:	8082                	ret

0000000080000cd4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd4:	7139                	addi	sp,sp,-64
    80000cd6:	fc06                	sd	ra,56(sp)
    80000cd8:	f822                	sd	s0,48(sp)
    80000cda:	f426                	sd	s1,40(sp)
    80000cdc:	f04a                	sd	s2,32(sp)
    80000cde:	ec4e                	sd	s3,24(sp)
    80000ce0:	e852                	sd	s4,16(sp)
    80000ce2:	e456                	sd	s5,8(sp)
    80000ce4:	e05a                	sd	s6,0(sp)
    80000ce6:	0080                	addi	s0,sp,64
    80000ce8:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cea:	0000b497          	auipc	s1,0xb
    80000cee:	79648493          	addi	s1,s1,1942 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf2:	8b26                	mv	s6,s1
    80000cf4:	39581937          	lui	s2,0x39581
    80000cf8:	0912                	slli	s2,s2,0x4
    80000cfa:	62590913          	addi	s2,s2,1573 # 39581625 <_entry-0x46a7e9db>
    80000cfe:	0932                	slli	s2,s2,0xc
    80000d00:	dd390913          	addi	s2,s2,-557
    80000d04:	093e                	slli	s2,s2,0xf
    80000d06:	8d590913          	addi	s2,s2,-1835
    80000d0a:	040009b7          	lui	s3,0x4000
    80000d0e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d10:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0001ba97          	auipc	s5,0x1b
    80000d16:	16ea8a93          	addi	s5,s5,366 # 8001be80 <tickslock>
    char *pa = kalloc();
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	400080e7          	jalr	1024(ra) # 8000011a <kalloc>
    80000d22:	862a                	mv	a2,a0
    if(pa == 0)
    80000d24:	c121                	beqz	a0,80000d64 <proc_mapstacks+0x90>
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	416485b3          	sub	a1,s1,s6
    80000d2a:	858d                	srai	a1,a1,0x3
    80000d2c:	032585b3          	mul	a1,a1,s2
    80000d30:	2585                	addiw	a1,a1,1
    80000d32:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d36:	4719                	li	a4,6
    80000d38:	6685                	lui	a3,0x1
    80000d3a:	40b985b3          	sub	a1,s3,a1
    80000d3e:	8552                	mv	a0,s4
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	89a080e7          	jalr	-1894(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d48:	3e848493          	addi	s1,s1,1000
    80000d4c:	fd5497e3          	bne	s1,s5,80000d1a <proc_mapstacks+0x46>
  }
}
    80000d50:	70e2                	ld	ra,56(sp)
    80000d52:	7442                	ld	s0,48(sp)
    80000d54:	74a2                	ld	s1,40(sp)
    80000d56:	7902                	ld	s2,32(sp)
    80000d58:	69e2                	ld	s3,24(sp)
    80000d5a:	6a42                	ld	s4,16(sp)
    80000d5c:	6aa2                	ld	s5,8(sp)
    80000d5e:	6b02                	ld	s6,0(sp)
    80000d60:	6121                	addi	sp,sp,64
    80000d62:	8082                	ret
      panic("kalloc");
    80000d64:	00007517          	auipc	a0,0x7
    80000d68:	3bc50513          	addi	a0,a0,956 # 80008120 <etext+0x120>
    80000d6c:	00005097          	auipc	ra,0x5
    80000d70:	300080e7          	jalr	768(ra) # 8000606c <panic>

0000000080000d74 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d74:	7139                	addi	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d88:	00007597          	auipc	a1,0x7
    80000d8c:	3a058593          	addi	a1,a1,928 # 80008128 <etext+0x128>
    80000d90:	0000b517          	auipc	a0,0xb
    80000d94:	2c050513          	addi	a0,a0,704 # 8000c050 <pid_lock>
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	7be080e7          	jalr	1982(ra) # 80006556 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	39058593          	addi	a1,a1,912 # 80008130 <etext+0x130>
    80000da8:	0000b517          	auipc	a0,0xb
    80000dac:	2c050513          	addi	a0,a0,704 # 8000c068 <wait_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	7a6080e7          	jalr	1958(ra) # 80006556 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db8:	0000b497          	auipc	s1,0xb
    80000dbc:	6c848493          	addi	s1,s1,1736 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000dc0:	00007b17          	auipc	s6,0x7
    80000dc4:	380b0b13          	addi	s6,s6,896 # 80008140 <etext+0x140>
      p->kstack = KSTACK((int) (p - proc));
    80000dc8:	8aa6                	mv	s5,s1
    80000dca:	39581937          	lui	s2,0x39581
    80000dce:	0912                	slli	s2,s2,0x4
    80000dd0:	62590913          	addi	s2,s2,1573 # 39581625 <_entry-0x46a7e9db>
    80000dd4:	0932                	slli	s2,s2,0xc
    80000dd6:	dd390913          	addi	s2,s2,-557
    80000dda:	093e                	slli	s2,s2,0xf
    80000ddc:	8d590913          	addi	s2,s2,-1835
    80000de0:	040009b7          	lui	s3,0x4000
    80000de4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000de6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de8:	0001ba17          	auipc	s4,0x1b
    80000dec:	098a0a13          	addi	s4,s4,152 # 8001be80 <tickslock>
      initlock(&p->lock, "proc");
    80000df0:	85da                	mv	a1,s6
    80000df2:	8526                	mv	a0,s1
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	762080e7          	jalr	1890(ra) # 80006556 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000dfc:	415487b3          	sub	a5,s1,s5
    80000e00:	878d                	srai	a5,a5,0x3
    80000e02:	032787b3          	mul	a5,a5,s2
    80000e06:	2785                	addiw	a5,a5,1
    80000e08:	00d7979b          	slliw	a5,a5,0xd
    80000e0c:	40f987b3          	sub	a5,s3,a5
    80000e10:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e12:	3e848493          	addi	s1,s1,1000
    80000e16:	fd449de3          	bne	s1,s4,80000df0 <procinit+0x7c>
  }
}
    80000e1a:	70e2                	ld	ra,56(sp)
    80000e1c:	7442                	ld	s0,48(sp)
    80000e1e:	74a2                	ld	s1,40(sp)
    80000e20:	7902                	ld	s2,32(sp)
    80000e22:	69e2                	ld	s3,24(sp)
    80000e24:	6a42                	ld	s4,16(sp)
    80000e26:	6aa2                	ld	s5,8(sp)
    80000e28:	6b02                	ld	s6,0(sp)
    80000e2a:	6121                	addi	sp,sp,64
    80000e2c:	8082                	ret

0000000080000e2e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e2e:	1141                	addi	sp,sp,-16
    80000e30:	e422                	sd	s0,8(sp)
    80000e32:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e34:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e36:	2501                	sext.w	a0,a0
    80000e38:	6422                	ld	s0,8(sp)
    80000e3a:	0141                	addi	sp,sp,16
    80000e3c:	8082                	ret

0000000080000e3e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e3e:	1141                	addi	sp,sp,-16
    80000e40:	e422                	sd	s0,8(sp)
    80000e42:	0800                	addi	s0,sp,16
    80000e44:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e46:	2781                	sext.w	a5,a5
    80000e48:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e4a:	0000b517          	auipc	a0,0xb
    80000e4e:	23650513          	addi	a0,a0,566 # 8000c080 <cpus>
    80000e52:	953e                	add	a0,a0,a5
    80000e54:	6422                	ld	s0,8(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret

0000000080000e5a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e5a:	1101                	addi	sp,sp,-32
    80000e5c:	ec06                	sd	ra,24(sp)
    80000e5e:	e822                	sd	s0,16(sp)
    80000e60:	e426                	sd	s1,8(sp)
    80000e62:	1000                	addi	s0,sp,32
  push_off();
    80000e64:	00005097          	auipc	ra,0x5
    80000e68:	736080e7          	jalr	1846(ra) # 8000659a <push_off>
    80000e6c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e6e:	2781                	sext.w	a5,a5
    80000e70:	079e                	slli	a5,a5,0x7
    80000e72:	0000b717          	auipc	a4,0xb
    80000e76:	1de70713          	addi	a4,a4,478 # 8000c050 <pid_lock>
    80000e7a:	97ba                	add	a5,a5,a4
    80000e7c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e7e:	00005097          	auipc	ra,0x5
    80000e82:	7bc080e7          	jalr	1980(ra) # 8000663a <pop_off>
  return p;
}
    80000e86:	8526                	mv	a0,s1
    80000e88:	60e2                	ld	ra,24(sp)
    80000e8a:	6442                	ld	s0,16(sp)
    80000e8c:	64a2                	ld	s1,8(sp)
    80000e8e:	6105                	addi	sp,sp,32
    80000e90:	8082                	ret

0000000080000e92 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e92:	1141                	addi	sp,sp,-16
    80000e94:	e406                	sd	ra,8(sp)
    80000e96:	e022                	sd	s0,0(sp)
    80000e98:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e9a:	00000097          	auipc	ra,0x0
    80000e9e:	fc0080e7          	jalr	-64(ra) # 80000e5a <myproc>
    80000ea2:	00005097          	auipc	ra,0x5
    80000ea6:	7f8080e7          	jalr	2040(ra) # 8000669a <release>

  if (first) {
    80000eaa:	0000a797          	auipc	a5,0xa
    80000eae:	2267a783          	lw	a5,550(a5) # 8000b0d0 <first.1>
    80000eb2:	eb89                	bnez	a5,80000ec4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eb4:	00001097          	auipc	ra,0x1
    80000eb8:	cb8080e7          	jalr	-840(ra) # 80001b6c <usertrapret>
}
    80000ebc:	60a2                	ld	ra,8(sp)
    80000ebe:	6402                	ld	s0,0(sp)
    80000ec0:	0141                	addi	sp,sp,16
    80000ec2:	8082                	ret
    first = 0;
    80000ec4:	0000a797          	auipc	a5,0xa
    80000ec8:	2007a623          	sw	zero,524(a5) # 8000b0d0 <first.1>
    fsinit(ROOTDEV);
    80000ecc:	4505                	li	a0,1
    80000ece:	00002097          	auipc	ra,0x2
    80000ed2:	b42080e7          	jalr	-1214(ra) # 80002a10 <fsinit>
    80000ed6:	bff9                	j	80000eb4 <forkret+0x22>

0000000080000ed8 <allocpid>:
allocpid() {
    80000ed8:	1101                	addi	sp,sp,-32
    80000eda:	ec06                	sd	ra,24(sp)
    80000edc:	e822                	sd	s0,16(sp)
    80000ede:	e426                	sd	s1,8(sp)
    80000ee0:	e04a                	sd	s2,0(sp)
    80000ee2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ee4:	0000b917          	auipc	s2,0xb
    80000ee8:	16c90913          	addi	s2,s2,364 # 8000c050 <pid_lock>
    80000eec:	854a                	mv	a0,s2
    80000eee:	00005097          	auipc	ra,0x5
    80000ef2:	6f8080e7          	jalr	1784(ra) # 800065e6 <acquire>
  pid = nextpid;
    80000ef6:	0000a797          	auipc	a5,0xa
    80000efa:	1de78793          	addi	a5,a5,478 # 8000b0d4 <nextpid>
    80000efe:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f00:	0014871b          	addiw	a4,s1,1
    80000f04:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f06:	854a                	mv	a0,s2
    80000f08:	00005097          	auipc	ra,0x5
    80000f0c:	792080e7          	jalr	1938(ra) # 8000669a <release>
}
    80000f10:	8526                	mv	a0,s1
    80000f12:	60e2                	ld	ra,24(sp)
    80000f14:	6442                	ld	s0,16(sp)
    80000f16:	64a2                	ld	s1,8(sp)
    80000f18:	6902                	ld	s2,0(sp)
    80000f1a:	6105                	addi	sp,sp,32
    80000f1c:	8082                	ret

0000000080000f1e <proc_pagetable>:
{
    80000f1e:	1101                	addi	sp,sp,-32
    80000f20:	ec06                	sd	ra,24(sp)
    80000f22:	e822                	sd	s0,16(sp)
    80000f24:	e426                	sd	s1,8(sp)
    80000f26:	e04a                	sd	s2,0(sp)
    80000f28:	1000                	addi	s0,sp,32
    80000f2a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f2c:	00000097          	auipc	ra,0x0
    80000f30:	89a080e7          	jalr	-1894(ra) # 800007c6 <uvmcreate>
    80000f34:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f36:	c121                	beqz	a0,80000f76 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f38:	4729                	li	a4,10
    80000f3a:	00006697          	auipc	a3,0x6
    80000f3e:	0c668693          	addi	a3,a3,198 # 80007000 <_trampoline>
    80000f42:	6605                	lui	a2,0x1
    80000f44:	040005b7          	lui	a1,0x4000
    80000f48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f4a:	05b2                	slli	a1,a1,0xc
    80000f4c:	fffff097          	auipc	ra,0xfffff
    80000f50:	5ee080e7          	jalr	1518(ra) # 8000053a <mappages>
    80000f54:	02054863          	bltz	a0,80000f84 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f58:	4719                	li	a4,6
    80000f5a:	05893683          	ld	a3,88(s2)
    80000f5e:	6605                	lui	a2,0x1
    80000f60:	020005b7          	lui	a1,0x2000
    80000f64:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f66:	05b6                	slli	a1,a1,0xd
    80000f68:	8526                	mv	a0,s1
    80000f6a:	fffff097          	auipc	ra,0xfffff
    80000f6e:	5d0080e7          	jalr	1488(ra) # 8000053a <mappages>
    80000f72:	02054163          	bltz	a0,80000f94 <proc_pagetable+0x76>
}
    80000f76:	8526                	mv	a0,s1
    80000f78:	60e2                	ld	ra,24(sp)
    80000f7a:	6442                	ld	s0,16(sp)
    80000f7c:	64a2                	ld	s1,8(sp)
    80000f7e:	6902                	ld	s2,0(sp)
    80000f80:	6105                	addi	sp,sp,32
    80000f82:	8082                	ret
    uvmfree(pagetable, 0);
    80000f84:	4581                	li	a1,0
    80000f86:	8526                	mv	a0,s1
    80000f88:	00000097          	auipc	ra,0x0
    80000f8c:	a44080e7          	jalr	-1468(ra) # 800009cc <uvmfree>
    return 0;
    80000f90:	4481                	li	s1,0
    80000f92:	b7d5                	j	80000f76 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f94:	4681                	li	a3,0
    80000f96:	4605                	li	a2,1
    80000f98:	040005b7          	lui	a1,0x4000
    80000f9c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f9e:	05b2                	slli	a1,a1,0xc
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	75e080e7          	jalr	1886(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80000faa:	4581                	li	a1,0
    80000fac:	8526                	mv	a0,s1
    80000fae:	00000097          	auipc	ra,0x0
    80000fb2:	a1e080e7          	jalr	-1506(ra) # 800009cc <uvmfree>
    return 0;
    80000fb6:	4481                	li	s1,0
    80000fb8:	bf7d                	j	80000f76 <proc_pagetable+0x58>

0000000080000fba <proc_freepagetable>:
{
    80000fba:	1101                	addi	sp,sp,-32
    80000fbc:	ec06                	sd	ra,24(sp)
    80000fbe:	e822                	sd	s0,16(sp)
    80000fc0:	e426                	sd	s1,8(sp)
    80000fc2:	e04a                	sd	s2,0(sp)
    80000fc4:	1000                	addi	s0,sp,32
    80000fc6:	84aa                	mv	s1,a0
    80000fc8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fca:	4681                	li	a3,0
    80000fcc:	4605                	li	a2,1
    80000fce:	040005b7          	lui	a1,0x4000
    80000fd2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fd4:	05b2                	slli	a1,a1,0xc
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	72a080e7          	jalr	1834(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fde:	4681                	li	a3,0
    80000fe0:	4605                	li	a2,1
    80000fe2:	020005b7          	lui	a1,0x2000
    80000fe6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe8:	05b6                	slli	a1,a1,0xd
    80000fea:	8526                	mv	a0,s1
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	714080e7          	jalr	1812(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ff4:	85ca                	mv	a1,s2
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	00000097          	auipc	ra,0x0
    80000ffc:	9d4080e7          	jalr	-1580(ra) # 800009cc <uvmfree>
}
    80001000:	60e2                	ld	ra,24(sp)
    80001002:	6442                	ld	s0,16(sp)
    80001004:	64a2                	ld	s1,8(sp)
    80001006:	6902                	ld	s2,0(sp)
    80001008:	6105                	addi	sp,sp,32
    8000100a:	8082                	ret

000000008000100c <freeproc>:
{
    8000100c:	1101                	addi	sp,sp,-32
    8000100e:	ec06                	sd	ra,24(sp)
    80001010:	e822                	sd	s0,16(sp)
    80001012:	e426                	sd	s1,8(sp)
    80001014:	1000                	addi	s0,sp,32
    80001016:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001018:	6d28                	ld	a0,88(a0)
    8000101a:	c509                	beqz	a0,80001024 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	000080e7          	jalr	ra # 8000001c <kfree>
  p->trapframe = 0;
    80001024:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001028:	68a8                	ld	a0,80(s1)
    8000102a:	c511                	beqz	a0,80001036 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000102c:	64ac                	ld	a1,72(s1)
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	f8c080e7          	jalr	-116(ra) # 80000fba <proc_freepagetable>
  p->pagetable = 0;
    80001036:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000103a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000103e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001042:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001046:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000104a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000104e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001052:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001056:	0004ac23          	sw	zero,24(s1)
}
    8000105a:	60e2                	ld	ra,24(sp)
    8000105c:	6442                	ld	s0,16(sp)
    8000105e:	64a2                	ld	s1,8(sp)
    80001060:	6105                	addi	sp,sp,32
    80001062:	8082                	ret

0000000080001064 <allocproc>:
{
    80001064:	1101                	addi	sp,sp,-32
    80001066:	ec06                	sd	ra,24(sp)
    80001068:	e822                	sd	s0,16(sp)
    8000106a:	e426                	sd	s1,8(sp)
    8000106c:	e04a                	sd	s2,0(sp)
    8000106e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001070:	0000b497          	auipc	s1,0xb
    80001074:	41048493          	addi	s1,s1,1040 # 8000c480 <proc>
    80001078:	0001b917          	auipc	s2,0x1b
    8000107c:	e0890913          	addi	s2,s2,-504 # 8001be80 <tickslock>
    acquire(&p->lock);
    80001080:	8526                	mv	a0,s1
    80001082:	00005097          	auipc	ra,0x5
    80001086:	564080e7          	jalr	1380(ra) # 800065e6 <acquire>
    if(p->state == UNUSED) {
    8000108a:	4c9c                	lw	a5,24(s1)
    8000108c:	cf81                	beqz	a5,800010a4 <allocproc+0x40>
      release(&p->lock);
    8000108e:	8526                	mv	a0,s1
    80001090:	00005097          	auipc	ra,0x5
    80001094:	60a080e7          	jalr	1546(ra) # 8000669a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001098:	3e848493          	addi	s1,s1,1000
    8000109c:	ff2492e3          	bne	s1,s2,80001080 <allocproc+0x1c>
  return 0;
    800010a0:	4481                	li	s1,0
    800010a2:	a889                	j	800010f4 <allocproc+0x90>
  p->pid = allocpid();
    800010a4:	00000097          	auipc	ra,0x0
    800010a8:	e34080e7          	jalr	-460(ra) # 80000ed8 <allocpid>
    800010ac:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ae:	4785                	li	a5,1
    800010b0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b2:	fffff097          	auipc	ra,0xfffff
    800010b6:	068080e7          	jalr	104(ra) # 8000011a <kalloc>
    800010ba:	892a                	mv	s2,a0
    800010bc:	eca8                	sd	a0,88(s1)
    800010be:	c131                	beqz	a0,80001102 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010c0:	8526                	mv	a0,s1
    800010c2:	00000097          	auipc	ra,0x0
    800010c6:	e5c080e7          	jalr	-420(ra) # 80000f1e <proc_pagetable>
    800010ca:	892a                	mv	s2,a0
    800010cc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010ce:	c531                	beqz	a0,8000111a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010d0:	07000613          	li	a2,112
    800010d4:	4581                	li	a1,0
    800010d6:	06048513          	addi	a0,s1,96
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	0a0080e7          	jalr	160(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010e2:	00000797          	auipc	a5,0x0
    800010e6:	db078793          	addi	a5,a5,-592 # 80000e92 <forkret>
    800010ea:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ec:	60bc                	ld	a5,64(s1)
    800010ee:	6705                	lui	a4,0x1
    800010f0:	97ba                	add	a5,a5,a4
    800010f2:	f4bc                	sd	a5,104(s1)
}
    800010f4:	8526                	mv	a0,s1
    800010f6:	60e2                	ld	ra,24(sp)
    800010f8:	6442                	ld	s0,16(sp)
    800010fa:	64a2                	ld	s1,8(sp)
    800010fc:	6902                	ld	s2,0(sp)
    800010fe:	6105                	addi	sp,sp,32
    80001100:	8082                	ret
    freeproc(p);
    80001102:	8526                	mv	a0,s1
    80001104:	00000097          	auipc	ra,0x0
    80001108:	f08080e7          	jalr	-248(ra) # 8000100c <freeproc>
    release(&p->lock);
    8000110c:	8526                	mv	a0,s1
    8000110e:	00005097          	auipc	ra,0x5
    80001112:	58c080e7          	jalr	1420(ra) # 8000669a <release>
    return 0;
    80001116:	84ca                	mv	s1,s2
    80001118:	bff1                	j	800010f4 <allocproc+0x90>
    freeproc(p);
    8000111a:	8526                	mv	a0,s1
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	ef0080e7          	jalr	-272(ra) # 8000100c <freeproc>
    release(&p->lock);
    80001124:	8526                	mv	a0,s1
    80001126:	00005097          	auipc	ra,0x5
    8000112a:	574080e7          	jalr	1396(ra) # 8000669a <release>
    return 0;
    8000112e:	84ca                	mv	s1,s2
    80001130:	b7d1                	j	800010f4 <allocproc+0x90>

0000000080001132 <userinit>:
{
    80001132:	1101                	addi	sp,sp,-32
    80001134:	ec06                	sd	ra,24(sp)
    80001136:	e822                	sd	s0,16(sp)
    80001138:	e426                	sd	s1,8(sp)
    8000113a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f28080e7          	jalr	-216(ra) # 80001064 <allocproc>
    80001144:	84aa                	mv	s1,a0
  initproc = p;
    80001146:	0000b797          	auipc	a5,0xb
    8000114a:	eca7b523          	sd	a0,-310(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000114e:	03400613          	li	a2,52
    80001152:	0000a597          	auipc	a1,0xa
    80001156:	f8e58593          	addi	a1,a1,-114 # 8000b0e0 <initcode>
    8000115a:	6928                	ld	a0,80(a0)
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	698080e7          	jalr	1688(ra) # 800007f4 <uvminit>
  p->sz = PGSIZE;
    80001164:	6785                	lui	a5,0x1
    80001166:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001168:	6cb8                	ld	a4,88(s1)
    8000116a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000116e:	6cb8                	ld	a4,88(s1)
    80001170:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001172:	4641                	li	a2,16
    80001174:	00007597          	auipc	a1,0x7
    80001178:	fd458593          	addi	a1,a1,-44 # 80008148 <etext+0x148>
    8000117c:	15848513          	addi	a0,s1,344
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	13c080e7          	jalr	316(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001188:	00007517          	auipc	a0,0x7
    8000118c:	fd050513          	addi	a0,a0,-48 # 80008158 <etext+0x158>
    80001190:	00002097          	auipc	ra,0x2
    80001194:	2c6080e7          	jalr	710(ra) # 80003456 <namei>
    80001198:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000119c:	478d                	li	a5,3
    8000119e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011a0:	8526                	mv	a0,s1
    800011a2:	00005097          	auipc	ra,0x5
    800011a6:	4f8080e7          	jalr	1272(ra) # 8000669a <release>
}
    800011aa:	60e2                	ld	ra,24(sp)
    800011ac:	6442                	ld	s0,16(sp)
    800011ae:	64a2                	ld	s1,8(sp)
    800011b0:	6105                	addi	sp,sp,32
    800011b2:	8082                	ret

00000000800011b4 <growproc>:
{
    800011b4:	1101                	addi	sp,sp,-32
    800011b6:	ec06                	sd	ra,24(sp)
    800011b8:	e822                	sd	s0,16(sp)
    800011ba:	e426                	sd	s1,8(sp)
    800011bc:	e04a                	sd	s2,0(sp)
    800011be:	1000                	addi	s0,sp,32
    800011c0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011c2:	00000097          	auipc	ra,0x0
    800011c6:	c98080e7          	jalr	-872(ra) # 80000e5a <myproc>
    800011ca:	892a                	mv	s2,a0
  sz = p->sz;
    800011cc:	652c                	ld	a1,72(a0)
    800011ce:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011d2:	00904f63          	bgtz	s1,800011f0 <growproc+0x3c>
  } else if(n < 0){
    800011d6:	0204cd63          	bltz	s1,80001210 <growproc+0x5c>
  p->sz = sz;
    800011da:	1782                	slli	a5,a5,0x20
    800011dc:	9381                	srli	a5,a5,0x20
    800011de:	04f93423          	sd	a5,72(s2)
  return 0;
    800011e2:	4501                	li	a0,0
}
    800011e4:	60e2                	ld	ra,24(sp)
    800011e6:	6442                	ld	s0,16(sp)
    800011e8:	64a2                	ld	s1,8(sp)
    800011ea:	6902                	ld	s2,0(sp)
    800011ec:	6105                	addi	sp,sp,32
    800011ee:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011f0:	00f4863b          	addw	a2,s1,a5
    800011f4:	1602                	slli	a2,a2,0x20
    800011f6:	9201                	srli	a2,a2,0x20
    800011f8:	1582                	slli	a1,a1,0x20
    800011fa:	9181                	srli	a1,a1,0x20
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	6b0080e7          	jalr	1712(ra) # 800008ae <uvmalloc>
    80001206:	0005079b          	sext.w	a5,a0
    8000120a:	fbe1                	bnez	a5,800011da <growproc+0x26>
      return -1;
    8000120c:	557d                	li	a0,-1
    8000120e:	bfd9                	j	800011e4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001210:	00f4863b          	addw	a2,s1,a5
    80001214:	1602                	slli	a2,a2,0x20
    80001216:	9201                	srli	a2,a2,0x20
    80001218:	1582                	slli	a1,a1,0x20
    8000121a:	9181                	srli	a1,a1,0x20
    8000121c:	6928                	ld	a0,80(a0)
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	648080e7          	jalr	1608(ra) # 80000866 <uvmdealloc>
    80001226:	0005079b          	sext.w	a5,a0
    8000122a:	bf45                	j	800011da <growproc+0x26>

000000008000122c <fork>:
{
    8000122c:	7139                	addi	sp,sp,-64
    8000122e:	fc06                	sd	ra,56(sp)
    80001230:	f822                	sd	s0,48(sp)
    80001232:	ec4e                	sd	s3,24(sp)
    80001234:	e456                	sd	s5,8(sp)
    80001236:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	c22080e7          	jalr	-990(ra) # 80000e5a <myproc>
    80001240:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    80001242:	00000097          	auipc	ra,0x0
    80001246:	e22080e7          	jalr	-478(ra) # 80001064 <allocproc>
    8000124a:	14050d63          	beqz	a0,800013a4 <fork+0x178>
    8000124e:	e852                	sd	s4,16(sp)
    80001250:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001252:	0489b603          	ld	a2,72(s3)
    80001256:	692c                	ld	a1,80(a0)
    80001258:	0509b503          	ld	a0,80(s3)
    8000125c:	fffff097          	auipc	ra,0xfffff
    80001260:	7aa080e7          	jalr	1962(ra) # 80000a06 <uvmcopy>
    80001264:	04054a63          	bltz	a0,800012b8 <fork+0x8c>
    80001268:	f426                	sd	s1,40(sp)
    8000126a:	f04a                	sd	s2,32(sp)
  np->sz = p->sz;
    8000126c:	0489b783          	ld	a5,72(s3)
    80001270:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001274:	0589b683          	ld	a3,88(s3)
    80001278:	87b6                	mv	a5,a3
    8000127a:	058a3703          	ld	a4,88(s4)
    8000127e:	12068693          	addi	a3,a3,288
    80001282:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001286:	6788                	ld	a0,8(a5)
    80001288:	6b8c                	ld	a1,16(a5)
    8000128a:	6f90                	ld	a2,24(a5)
    8000128c:	01073023          	sd	a6,0(a4)
    80001290:	e708                	sd	a0,8(a4)
    80001292:	eb0c                	sd	a1,16(a4)
    80001294:	ef10                	sd	a2,24(a4)
    80001296:	02078793          	addi	a5,a5,32
    8000129a:	02070713          	addi	a4,a4,32
    8000129e:	fed792e3          	bne	a5,a3,80001282 <fork+0x56>
  np->trapframe->a0 = 0;
    800012a2:	058a3783          	ld	a5,88(s4)
    800012a6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012aa:	0d098493          	addi	s1,s3,208
    800012ae:	0d0a0913          	addi	s2,s4,208
    800012b2:	15098a93          	addi	s5,s3,336
    800012b6:	a015                	j	800012da <fork+0xae>
    freeproc(np);
    800012b8:	8552                	mv	a0,s4
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	d52080e7          	jalr	-686(ra) # 8000100c <freeproc>
    release(&np->lock);
    800012c2:	8552                	mv	a0,s4
    800012c4:	00005097          	auipc	ra,0x5
    800012c8:	3d6080e7          	jalr	982(ra) # 8000669a <release>
    return -1;
    800012cc:	5afd                	li	s5,-1
    800012ce:	6a42                	ld	s4,16(sp)
    800012d0:	a0d9                	j	80001396 <fork+0x16a>
  for(i = 0; i < NOFILE; i++)
    800012d2:	04a1                	addi	s1,s1,8
    800012d4:	0921                	addi	s2,s2,8
    800012d6:	01548b63          	beq	s1,s5,800012ec <fork+0xc0>
    if(p->ofile[i])
    800012da:	6088                	ld	a0,0(s1)
    800012dc:	d97d                	beqz	a0,800012d2 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800012de:	00002097          	auipc	ra,0x2
    800012e2:	7f0080e7          	jalr	2032(ra) # 80003ace <filedup>
    800012e6:	00a93023          	sd	a0,0(s2)
    800012ea:	b7e5                	j	800012d2 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800012ec:	1509b503          	ld	a0,336(s3)
    800012f0:	00002097          	auipc	ra,0x2
    800012f4:	956080e7          	jalr	-1706(ra) # 80002c46 <idup>
    800012f8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012fc:	4641                	li	a2,16
    800012fe:	15898593          	addi	a1,s3,344
    80001302:	158a0513          	addi	a0,s4,344
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	fb6080e7          	jalr	-74(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    8000130e:	030a2a83          	lw	s5,48(s4)
  release(&np->lock);
    80001312:	8552                	mv	a0,s4
    80001314:	00005097          	auipc	ra,0x5
    80001318:	386080e7          	jalr	902(ra) # 8000669a <release>
  acquire(&wait_lock);
    8000131c:	0000b497          	auipc	s1,0xb
    80001320:	d4c48493          	addi	s1,s1,-692 # 8000c068 <wait_lock>
    80001324:	8526                	mv	a0,s1
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	2c0080e7          	jalr	704(ra) # 800065e6 <acquire>
  np->parent = p;
    8000132e:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    80001332:	8526                	mv	a0,s1
    80001334:	00005097          	auipc	ra,0x5
    80001338:	366080e7          	jalr	870(ra) # 8000669a <release>
  acquire(&np->lock);
    8000133c:	8552                	mv	a0,s4
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	2a8080e7          	jalr	680(ra) # 800065e6 <acquire>
  np->state = RUNNABLE;
    80001346:	478d                	li	a5,3
    80001348:	00fa2c23          	sw	a5,24(s4)
  for(int i = 0; i < VMASIZE; i++) 
    8000134c:	16898493          	addi	s1,s3,360
    80001350:	168a0913          	addi	s2,s4,360
    80001354:	3e898993          	addi	s3,s3,1000
    80001358:	a039                	j	80001366 <fork+0x13a>
    8000135a:	02848493          	addi	s1,s1,40
    8000135e:	02890913          	addi	s2,s2,40
    80001362:	03348263          	beq	s1,s3,80001386 <fork+0x15a>
    if(p->vma[i].used)
    80001366:	44dc                	lw	a5,12(s1)
    80001368:	dbed                	beqz	a5,8000135a <fork+0x12e>
      memmove(&(np->vma[i]), &(p->vma[i]), sizeof(p->vma[i]));
    8000136a:	02800613          	li	a2,40
    8000136e:	85a6                	mv	a1,s1
    80001370:	854a                	mv	a0,s2
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	e64080e7          	jalr	-412(ra) # 800001d6 <memmove>
      filedup(p->vma[i].file);
    8000137a:	6088                	ld	a0,0(s1)
    8000137c:	00002097          	auipc	ra,0x2
    80001380:	752080e7          	jalr	1874(ra) # 80003ace <filedup>
    80001384:	bfd9                	j	8000135a <fork+0x12e>
  release(&np->lock);
    80001386:	8552                	mv	a0,s4
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	312080e7          	jalr	786(ra) # 8000669a <release>
  return pid;
    80001390:	74a2                	ld	s1,40(sp)
    80001392:	7902                	ld	s2,32(sp)
    80001394:	6a42                	ld	s4,16(sp)
}
    80001396:	8556                	mv	a0,s5
    80001398:	70e2                	ld	ra,56(sp)
    8000139a:	7442                	ld	s0,48(sp)
    8000139c:	69e2                	ld	s3,24(sp)
    8000139e:	6aa2                	ld	s5,8(sp)
    800013a0:	6121                	addi	sp,sp,64
    800013a2:	8082                	ret
    return -1;
    800013a4:	5afd                	li	s5,-1
    800013a6:	bfc5                	j	80001396 <fork+0x16a>

00000000800013a8 <scheduler>:
{
    800013a8:	7139                	addi	sp,sp,-64
    800013aa:	fc06                	sd	ra,56(sp)
    800013ac:	f822                	sd	s0,48(sp)
    800013ae:	f426                	sd	s1,40(sp)
    800013b0:	f04a                	sd	s2,32(sp)
    800013b2:	ec4e                	sd	s3,24(sp)
    800013b4:	e852                	sd	s4,16(sp)
    800013b6:	e456                	sd	s5,8(sp)
    800013b8:	e05a                	sd	s6,0(sp)
    800013ba:	0080                	addi	s0,sp,64
    800013bc:	8792                	mv	a5,tp
  int id = r_tp();
    800013be:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c0:	00779a93          	slli	s5,a5,0x7
    800013c4:	0000b717          	auipc	a4,0xb
    800013c8:	c8c70713          	addi	a4,a4,-884 # 8000c050 <pid_lock>
    800013cc:	9756                	add	a4,a4,s5
    800013ce:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d2:	0000b717          	auipc	a4,0xb
    800013d6:	cb670713          	addi	a4,a4,-842 # 8000c088 <cpus+0x8>
    800013da:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013dc:	498d                	li	s3,3
        p->state = RUNNING;
    800013de:	4b11                	li	s6,4
        c->proc = p;
    800013e0:	079e                	slli	a5,a5,0x7
    800013e2:	0000ba17          	auipc	s4,0xb
    800013e6:	c6ea0a13          	addi	s4,s4,-914 # 8000c050 <pid_lock>
    800013ea:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ec:	0001b917          	auipc	s2,0x1b
    800013f0:	a9490913          	addi	s2,s2,-1388 # 8001be80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fc:	10079073          	csrw	sstatus,a5
    80001400:	0000b497          	auipc	s1,0xb
    80001404:	08048493          	addi	s1,s1,128 # 8000c480 <proc>
    80001408:	a811                	j	8000141c <scheduler+0x74>
      release(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	28e080e7          	jalr	654(ra) # 8000669a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001414:	3e848493          	addi	s1,s1,1000
    80001418:	fd248ee3          	beq	s1,s2,800013f4 <scheduler+0x4c>
      acquire(&p->lock);
    8000141c:	8526                	mv	a0,s1
    8000141e:	00005097          	auipc	ra,0x5
    80001422:	1c8080e7          	jalr	456(ra) # 800065e6 <acquire>
      if(p->state == RUNNABLE) {
    80001426:	4c9c                	lw	a5,24(s1)
    80001428:	ff3791e3          	bne	a5,s3,8000140a <scheduler+0x62>
        p->state = RUNNING;
    8000142c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001430:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001434:	06048593          	addi	a1,s1,96
    80001438:	8556                	mv	a0,s5
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	688080e7          	jalr	1672(ra) # 80001ac2 <swtch>
        c->proc = 0;
    80001442:	020a3823          	sd	zero,48(s4)
    80001446:	b7d1                	j	8000140a <scheduler+0x62>

0000000080001448 <sched>:
{
    80001448:	7179                	addi	sp,sp,-48
    8000144a:	f406                	sd	ra,40(sp)
    8000144c:	f022                	sd	s0,32(sp)
    8000144e:	ec26                	sd	s1,24(sp)
    80001450:	e84a                	sd	s2,16(sp)
    80001452:	e44e                	sd	s3,8(sp)
    80001454:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	a04080e7          	jalr	-1532(ra) # 80000e5a <myproc>
    8000145e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001460:	00005097          	auipc	ra,0x5
    80001464:	10c080e7          	jalr	268(ra) # 8000656c <holding>
    80001468:	c93d                	beqz	a0,800014de <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	0000b717          	auipc	a4,0xb
    80001474:	be070713          	addi	a4,a4,-1056 # 8000c050 <pid_lock>
    80001478:	97ba                	add	a5,a5,a4
    8000147a:	0a87a703          	lw	a4,168(a5)
    8000147e:	4785                	li	a5,1
    80001480:	06f71763          	bne	a4,a5,800014ee <sched+0xa6>
  if(p->state == RUNNING)
    80001484:	4c98                	lw	a4,24(s1)
    80001486:	4791                	li	a5,4
    80001488:	06f70b63          	beq	a4,a5,800014fe <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001490:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001492:	efb5                	bnez	a5,8000150e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001496:	0000b917          	auipc	s2,0xb
    8000149a:	bba90913          	addi	s2,s2,-1094 # 8000c050 <pid_lock>
    8000149e:	2781                	sext.w	a5,a5
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	97ca                	add	a5,a5,s2
    800014a4:	0ac7a983          	lw	s3,172(a5)
    800014a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	0000b597          	auipc	a1,0xb
    800014b2:	bda58593          	addi	a1,a1,-1062 # 8000c088 <cpus+0x8>
    800014b6:	95be                	add	a1,a1,a5
    800014b8:	06048513          	addi	a0,s1,96
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	606080e7          	jalr	1542(ra) # 80001ac2 <swtch>
    800014c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c6:	2781                	sext.w	a5,a5
    800014c8:	079e                	slli	a5,a5,0x7
    800014ca:	993e                	add	s2,s2,a5
    800014cc:	0b392623          	sw	s3,172(s2)
}
    800014d0:	70a2                	ld	ra,40(sp)
    800014d2:	7402                	ld	s0,32(sp)
    800014d4:	64e2                	ld	s1,24(sp)
    800014d6:	6942                	ld	s2,16(sp)
    800014d8:	69a2                	ld	s3,8(sp)
    800014da:	6145                	addi	sp,sp,48
    800014dc:	8082                	ret
    panic("sched p->lock");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	c8250513          	addi	a0,a0,-894 # 80008160 <etext+0x160>
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	b86080e7          	jalr	-1146(ra) # 8000606c <panic>
    panic("sched locks");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	c8250513          	addi	a0,a0,-894 # 80008170 <etext+0x170>
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	b76080e7          	jalr	-1162(ra) # 8000606c <panic>
    panic("sched running");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	c8250513          	addi	a0,a0,-894 # 80008180 <etext+0x180>
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	b66080e7          	jalr	-1178(ra) # 8000606c <panic>
    panic("sched interruptible");
    8000150e:	00007517          	auipc	a0,0x7
    80001512:	c8250513          	addi	a0,a0,-894 # 80008190 <etext+0x190>
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	b56080e7          	jalr	-1194(ra) # 8000606c <panic>

000000008000151e <yield>:
{
    8000151e:	1101                	addi	sp,sp,-32
    80001520:	ec06                	sd	ra,24(sp)
    80001522:	e822                	sd	s0,16(sp)
    80001524:	e426                	sd	s1,8(sp)
    80001526:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	932080e7          	jalr	-1742(ra) # 80000e5a <myproc>
    80001530:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001532:	00005097          	auipc	ra,0x5
    80001536:	0b4080e7          	jalr	180(ra) # 800065e6 <acquire>
  p->state = RUNNABLE;
    8000153a:	478d                	li	a5,3
    8000153c:	cc9c                	sw	a5,24(s1)
  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f0a080e7          	jalr	-246(ra) # 80001448 <sched>
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	152080e7          	jalr	338(ra) # 8000669a <release>
}
    80001550:	60e2                	ld	ra,24(sp)
    80001552:	6442                	ld	s0,16(sp)
    80001554:	64a2                	ld	s1,8(sp)
    80001556:	6105                	addi	sp,sp,32
    80001558:	8082                	ret

000000008000155a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155a:	7179                	addi	sp,sp,-48
    8000155c:	f406                	sd	ra,40(sp)
    8000155e:	f022                	sd	s0,32(sp)
    80001560:	ec26                	sd	s1,24(sp)
    80001562:	e84a                	sd	s2,16(sp)
    80001564:	e44e                	sd	s3,8(sp)
    80001566:	1800                	addi	s0,sp,48
    80001568:	89aa                	mv	s3,a0
    8000156a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	8ee080e7          	jalr	-1810(ra) # 80000e5a <myproc>
    80001574:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	070080e7          	jalr	112(ra) # 800065e6 <acquire>
  release(lk);
    8000157e:	854a                	mv	a0,s2
    80001580:	00005097          	auipc	ra,0x5
    80001584:	11a080e7          	jalr	282(ra) # 8000669a <release>

  // Go to sleep.
  p->chan = chan;
    80001588:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158c:	4789                	li	a5,2
    8000158e:	cc9c                	sw	a5,24(s1)

  sched();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	eb8080e7          	jalr	-328(ra) # 80001448 <sched>

  // Tidy up.
  p->chan = 0;
    80001598:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159c:	8526                	mv	a0,s1
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	0fc080e7          	jalr	252(ra) # 8000669a <release>
  acquire(lk);
    800015a6:	854a                	mv	a0,s2
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	03e080e7          	jalr	62(ra) # 800065e6 <acquire>
}
    800015b0:	70a2                	ld	ra,40(sp)
    800015b2:	7402                	ld	s0,32(sp)
    800015b4:	64e2                	ld	s1,24(sp)
    800015b6:	6942                	ld	s2,16(sp)
    800015b8:	69a2                	ld	s3,8(sp)
    800015ba:	6145                	addi	sp,sp,48
    800015bc:	8082                	ret

00000000800015be <wait>:
{
    800015be:	715d                	addi	sp,sp,-80
    800015c0:	e486                	sd	ra,72(sp)
    800015c2:	e0a2                	sd	s0,64(sp)
    800015c4:	fc26                	sd	s1,56(sp)
    800015c6:	f84a                	sd	s2,48(sp)
    800015c8:	f44e                	sd	s3,40(sp)
    800015ca:	f052                	sd	s4,32(sp)
    800015cc:	ec56                	sd	s5,24(sp)
    800015ce:	e85a                	sd	s6,16(sp)
    800015d0:	e45e                	sd	s7,8(sp)
    800015d2:	e062                	sd	s8,0(sp)
    800015d4:	0880                	addi	s0,sp,80
    800015d6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	882080e7          	jalr	-1918(ra) # 80000e5a <myproc>
    800015e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e2:	0000b517          	auipc	a0,0xb
    800015e6:	a8650513          	addi	a0,a0,-1402 # 8000c068 <wait_lock>
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	ffc080e7          	jalr	-4(ra) # 800065e6 <acquire>
    havekids = 0;
    800015f2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f4:	4a15                	li	s4,5
        havekids = 1;
    800015f6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f8:	0001b997          	auipc	s3,0x1b
    800015fc:	88898993          	addi	s3,s3,-1912 # 8001be80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001600:	0000bc17          	auipc	s8,0xb
    80001604:	a68c0c13          	addi	s8,s8,-1432 # 8000c068 <wait_lock>
    80001608:	a87d                	j	800016c6 <wait+0x108>
          pid = np->pid;
    8000160a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000160e:	000b0e63          	beqz	s6,8000162a <wait+0x6c>
    80001612:	4691                	li	a3,4
    80001614:	02c48613          	addi	a2,s1,44
    80001618:	85da                	mv	a1,s6
    8000161a:	05093503          	ld	a0,80(s2)
    8000161e:	fffff097          	auipc	ra,0xfffff
    80001622:	4e0080e7          	jalr	1248(ra) # 80000afe <copyout>
    80001626:	04054163          	bltz	a0,80001668 <wait+0xaa>
          freeproc(np);
    8000162a:	8526                	mv	a0,s1
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	9e0080e7          	jalr	-1568(ra) # 8000100c <freeproc>
          release(&np->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	064080e7          	jalr	100(ra) # 8000669a <release>
          release(&wait_lock);
    8000163e:	0000b517          	auipc	a0,0xb
    80001642:	a2a50513          	addi	a0,a0,-1494 # 8000c068 <wait_lock>
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	054080e7          	jalr	84(ra) # 8000669a <release>
}
    8000164e:	854e                	mv	a0,s3
    80001650:	60a6                	ld	ra,72(sp)
    80001652:	6406                	ld	s0,64(sp)
    80001654:	74e2                	ld	s1,56(sp)
    80001656:	7942                	ld	s2,48(sp)
    80001658:	79a2                	ld	s3,40(sp)
    8000165a:	7a02                	ld	s4,32(sp)
    8000165c:	6ae2                	ld	s5,24(sp)
    8000165e:	6b42                	ld	s6,16(sp)
    80001660:	6ba2                	ld	s7,8(sp)
    80001662:	6c02                	ld	s8,0(sp)
    80001664:	6161                	addi	sp,sp,80
    80001666:	8082                	ret
            release(&np->lock);
    80001668:	8526                	mv	a0,s1
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	030080e7          	jalr	48(ra) # 8000669a <release>
            release(&wait_lock);
    80001672:	0000b517          	auipc	a0,0xb
    80001676:	9f650513          	addi	a0,a0,-1546 # 8000c068 <wait_lock>
    8000167a:	00005097          	auipc	ra,0x5
    8000167e:	020080e7          	jalr	32(ra) # 8000669a <release>
            return -1;
    80001682:	59fd                	li	s3,-1
    80001684:	b7e9                	j	8000164e <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001686:	3e848493          	addi	s1,s1,1000
    8000168a:	03348463          	beq	s1,s3,800016b2 <wait+0xf4>
      if(np->parent == p){
    8000168e:	7c9c                	ld	a5,56(s1)
    80001690:	ff279be3          	bne	a5,s2,80001686 <wait+0xc8>
        acquire(&np->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	f50080e7          	jalr	-176(ra) # 800065e6 <acquire>
        if(np->state == ZOMBIE){
    8000169e:	4c9c                	lw	a5,24(s1)
    800016a0:	f74785e3          	beq	a5,s4,8000160a <wait+0x4c>
        release(&np->lock);
    800016a4:	8526                	mv	a0,s1
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	ff4080e7          	jalr	-12(ra) # 8000669a <release>
        havekids = 1;
    800016ae:	8756                	mv	a4,s5
    800016b0:	bfd9                	j	80001686 <wait+0xc8>
    if(!havekids || p->killed){
    800016b2:	c305                	beqz	a4,800016d2 <wait+0x114>
    800016b4:	02892783          	lw	a5,40(s2)
    800016b8:	ef89                	bnez	a5,800016d2 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ba:	85e2                	mv	a1,s8
    800016bc:	854a                	mv	a0,s2
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	e9c080e7          	jalr	-356(ra) # 8000155a <sleep>
    havekids = 0;
    800016c6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016c8:	0000b497          	auipc	s1,0xb
    800016cc:	db848493          	addi	s1,s1,-584 # 8000c480 <proc>
    800016d0:	bf7d                	j	8000168e <wait+0xd0>
      release(&wait_lock);
    800016d2:	0000b517          	auipc	a0,0xb
    800016d6:	99650513          	addi	a0,a0,-1642 # 8000c068 <wait_lock>
    800016da:	00005097          	auipc	ra,0x5
    800016de:	fc0080e7          	jalr	-64(ra) # 8000669a <release>
      return -1;
    800016e2:	59fd                	li	s3,-1
    800016e4:	b7ad                	j	8000164e <wait+0x90>

00000000800016e6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e6:	7139                	addi	sp,sp,-64
    800016e8:	fc06                	sd	ra,56(sp)
    800016ea:	f822                	sd	s0,48(sp)
    800016ec:	f426                	sd	s1,40(sp)
    800016ee:	f04a                	sd	s2,32(sp)
    800016f0:	ec4e                	sd	s3,24(sp)
    800016f2:	e852                	sd	s4,16(sp)
    800016f4:	e456                	sd	s5,8(sp)
    800016f6:	0080                	addi	s0,sp,64
    800016f8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fa:	0000b497          	auipc	s1,0xb
    800016fe:	d8648493          	addi	s1,s1,-634 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001702:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001704:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001706:	0001a917          	auipc	s2,0x1a
    8000170a:	77a90913          	addi	s2,s2,1914 # 8001be80 <tickslock>
    8000170e:	a811                	j	80001722 <wakeup+0x3c>
      }
      release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	f88080e7          	jalr	-120(ra) # 8000669a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	3e848493          	addi	s1,s1,1000
    8000171e:	03248663          	beq	s1,s2,8000174a <wakeup+0x64>
    if(p != myproc()){
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	738080e7          	jalr	1848(ra) # 80000e5a <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x34>
      acquire(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	eb6080e7          	jalr	-330(ra) # 800065e6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2a>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001744:	0154ac23          	sw	s5,24(s1)
    80001748:	b7e1                	j	80001710 <wakeup+0x2a>
    }
  }
}
    8000174a:	70e2                	ld	ra,56(sp)
    8000174c:	7442                	ld	s0,48(sp)
    8000174e:	74a2                	ld	s1,40(sp)
    80001750:	7902                	ld	s2,32(sp)
    80001752:	69e2                	ld	s3,24(sp)
    80001754:	6a42                	ld	s4,16(sp)
    80001756:	6aa2                	ld	s5,8(sp)
    80001758:	6121                	addi	sp,sp,64
    8000175a:	8082                	ret

000000008000175c <reparent>:
{
    8000175c:	7179                	addi	sp,sp,-48
    8000175e:	f406                	sd	ra,40(sp)
    80001760:	f022                	sd	s0,32(sp)
    80001762:	ec26                	sd	s1,24(sp)
    80001764:	e84a                	sd	s2,16(sp)
    80001766:	e44e                	sd	s3,8(sp)
    80001768:	e052                	sd	s4,0(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176e:	0000b497          	auipc	s1,0xb
    80001772:	d1248493          	addi	s1,s1,-750 # 8000c480 <proc>
      pp->parent = initproc;
    80001776:	0000ba17          	auipc	s4,0xb
    8000177a:	89aa0a13          	addi	s4,s4,-1894 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177e:	0001a997          	auipc	s3,0x1a
    80001782:	70298993          	addi	s3,s3,1794 # 8001be80 <tickslock>
    80001786:	a029                	j	80001790 <reparent+0x34>
    80001788:	3e848493          	addi	s1,s1,1000
    8000178c:	01348d63          	beq	s1,s3,800017a6 <reparent+0x4a>
    if(pp->parent == p){
    80001790:	7c9c                	ld	a5,56(s1)
    80001792:	ff279be3          	bne	a5,s2,80001788 <reparent+0x2c>
      pp->parent = initproc;
    80001796:	000a3503          	ld	a0,0(s4)
    8000179a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	f4a080e7          	jalr	-182(ra) # 800016e6 <wakeup>
    800017a4:	b7d5                	j	80001788 <reparent+0x2c>
}
    800017a6:	70a2                	ld	ra,40(sp)
    800017a8:	7402                	ld	s0,32(sp)
    800017aa:	64e2                	ld	s1,24(sp)
    800017ac:	6942                	ld	s2,16(sp)
    800017ae:	69a2                	ld	s3,8(sp)
    800017b0:	6a02                	ld	s4,0(sp)
    800017b2:	6145                	addi	sp,sp,48
    800017b4:	8082                	ret

00000000800017b6 <exit>:
{
    800017b6:	7139                	addi	sp,sp,-64
    800017b8:	fc06                	sd	ra,56(sp)
    800017ba:	f822                	sd	s0,48(sp)
    800017bc:	f426                	sd	s1,40(sp)
    800017be:	f04a                	sd	s2,32(sp)
    800017c0:	ec4e                	sd	s3,24(sp)
    800017c2:	e852                	sd	s4,16(sp)
    800017c4:	0080                	addi	s0,sp,64
    800017c6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c8:	fffff097          	auipc	ra,0xfffff
    800017cc:	692080e7          	jalr	1682(ra) # 80000e5a <myproc>
    800017d0:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d2:	0000b797          	auipc	a5,0xb
    800017d6:	83e7b783          	ld	a5,-1986(a5) # 8000c010 <initproc>
    800017da:	0d050493          	addi	s1,a0,208
    800017de:	15050913          	addi	s2,a0,336
    800017e2:	00a78463          	beq	a5,a0,800017ea <exit+0x34>
    800017e6:	e456                	sd	s5,8(sp)
    800017e8:	a01d                	j	8000180e <exit+0x58>
    800017ea:	e456                	sd	s5,8(sp)
    panic("init exiting");
    800017ec:	00007517          	auipc	a0,0x7
    800017f0:	9bc50513          	addi	a0,a0,-1604 # 800081a8 <etext+0x1a8>
    800017f4:	00005097          	auipc	ra,0x5
    800017f8:	878080e7          	jalr	-1928(ra) # 8000606c <panic>
      fileclose(f);
    800017fc:	00002097          	auipc	ra,0x2
    80001800:	324080e7          	jalr	804(ra) # 80003b20 <fileclose>
      p->ofile[fd] = 0;
    80001804:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001808:	04a1                	addi	s1,s1,8
    8000180a:	01248563          	beq	s1,s2,80001814 <exit+0x5e>
    if(p->ofile[fd]){
    8000180e:	6088                	ld	a0,0(s1)
    80001810:	f575                	bnez	a0,800017fc <exit+0x46>
    80001812:	bfdd                	j	80001808 <exit+0x52>
    80001814:	16898493          	addi	s1,s3,360
    80001818:	3e898a93          	addi	s5,s3,1000
    8000181c:	a83d                	j	8000185a <exit+0xa4>
      fileclose(p->vma[i].file);
    8000181e:	00093503          	ld	a0,0(s2)
    80001822:	00002097          	auipc	ra,0x2
    80001826:	2fe080e7          	jalr	766(ra) # 80003b20 <fileclose>
      uvmunmap(p->pagetable, p->vma[i].addr, p->vma[i].length/PGSIZE, 1);
    8000182a:	01892783          	lw	a5,24(s2)
    8000182e:	41f7d61b          	sraiw	a2,a5,0x1f
    80001832:	0146561b          	srliw	a2,a2,0x14
    80001836:	9e3d                	addw	a2,a2,a5
    80001838:	4685                	li	a3,1
    8000183a:	40c6561b          	sraiw	a2,a2,0xc
    8000183e:	01093583          	ld	a1,16(s2)
    80001842:	0509b503          	ld	a0,80(s3)
    80001846:	fffff097          	auipc	ra,0xfffff
    8000184a:	eba080e7          	jalr	-326(ra) # 80000700 <uvmunmap>
      p->vma[i].used = 0;
    8000184e:	00092623          	sw	zero,12(s2)
  for(int i = 0; i < VMASIZE; i++) 
    80001852:	02848493          	addi	s1,s1,40
    80001856:	03548063          	beq	s1,s5,80001876 <exit+0xc0>
    if(p->vma[i].used) 
    8000185a:	8926                	mv	s2,s1
    8000185c:	44dc                	lw	a5,12(s1)
    8000185e:	dbf5                	beqz	a5,80001852 <exit+0x9c>
      if(p->vma[i].flags & MAP_SHARED)
    80001860:	509c                	lw	a5,32(s1)
    80001862:	8b85                	andi	a5,a5,1
    80001864:	dfcd                	beqz	a5,8000181e <exit+0x68>
       filewrite(p->vma[i].file, p->vma[i].addr, p->vma[i].length);
    80001866:	4c90                	lw	a2,24(s1)
    80001868:	688c                	ld	a1,16(s1)
    8000186a:	6088                	ld	a0,0(s1)
    8000186c:	00002097          	auipc	ra,0x2
    80001870:	4da080e7          	jalr	1242(ra) # 80003d46 <filewrite>
    80001874:	b76d                	j	8000181e <exit+0x68>
  begin_op();
    80001876:	00002097          	auipc	ra,0x2
    8000187a:	de0080e7          	jalr	-544(ra) # 80003656 <begin_op>
  iput(p->cwd);
    8000187e:	1509b503          	ld	a0,336(s3)
    80001882:	00001097          	auipc	ra,0x1
    80001886:	5c0080e7          	jalr	1472(ra) # 80002e42 <iput>
  end_op();
    8000188a:	00002097          	auipc	ra,0x2
    8000188e:	e46080e7          	jalr	-442(ra) # 800036d0 <end_op>
  p->cwd = 0;
    80001892:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001896:	0000a497          	auipc	s1,0xa
    8000189a:	7d248493          	addi	s1,s1,2002 # 8000c068 <wait_lock>
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	d46080e7          	jalr	-698(ra) # 800065e6 <acquire>
  reparent(p);
    800018a8:	854e                	mv	a0,s3
    800018aa:	00000097          	auipc	ra,0x0
    800018ae:	eb2080e7          	jalr	-334(ra) # 8000175c <reparent>
  wakeup(p->parent);
    800018b2:	0389b503          	ld	a0,56(s3)
    800018b6:	00000097          	auipc	ra,0x0
    800018ba:	e30080e7          	jalr	-464(ra) # 800016e6 <wakeup>
  acquire(&p->lock);
    800018be:	854e                	mv	a0,s3
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	d26080e7          	jalr	-730(ra) # 800065e6 <acquire>
  p->xstate = status;
    800018c8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018cc:	4795                	li	a5,5
    800018ce:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018d2:	8526                	mv	a0,s1
    800018d4:	00005097          	auipc	ra,0x5
    800018d8:	dc6080e7          	jalr	-570(ra) # 8000669a <release>
  sched();
    800018dc:	00000097          	auipc	ra,0x0
    800018e0:	b6c080e7          	jalr	-1172(ra) # 80001448 <sched>
  panic("zombie exit");
    800018e4:	00007517          	auipc	a0,0x7
    800018e8:	8d450513          	addi	a0,a0,-1836 # 800081b8 <etext+0x1b8>
    800018ec:	00004097          	auipc	ra,0x4
    800018f0:	780080e7          	jalr	1920(ra) # 8000606c <panic>

00000000800018f4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018f4:	7179                	addi	sp,sp,-48
    800018f6:	f406                	sd	ra,40(sp)
    800018f8:	f022                	sd	s0,32(sp)
    800018fa:	ec26                	sd	s1,24(sp)
    800018fc:	e84a                	sd	s2,16(sp)
    800018fe:	e44e                	sd	s3,8(sp)
    80001900:	1800                	addi	s0,sp,48
    80001902:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001904:	0000b497          	auipc	s1,0xb
    80001908:	b7c48493          	addi	s1,s1,-1156 # 8000c480 <proc>
    8000190c:	0001a997          	auipc	s3,0x1a
    80001910:	57498993          	addi	s3,s3,1396 # 8001be80 <tickslock>
    acquire(&p->lock);
    80001914:	8526                	mv	a0,s1
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	cd0080e7          	jalr	-816(ra) # 800065e6 <acquire>
    if(p->pid == pid){
    8000191e:	589c                	lw	a5,48(s1)
    80001920:	01278d63          	beq	a5,s2,8000193a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001924:	8526                	mv	a0,s1
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	d74080e7          	jalr	-652(ra) # 8000669a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000192e:	3e848493          	addi	s1,s1,1000
    80001932:	ff3491e3          	bne	s1,s3,80001914 <kill+0x20>
  }
  return -1;
    80001936:	557d                	li	a0,-1
    80001938:	a829                	j	80001952 <kill+0x5e>
      p->killed = 1;
    8000193a:	4785                	li	a5,1
    8000193c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000193e:	4c98                	lw	a4,24(s1)
    80001940:	4789                	li	a5,2
    80001942:	00f70f63          	beq	a4,a5,80001960 <kill+0x6c>
      release(&p->lock);
    80001946:	8526                	mv	a0,s1
    80001948:	00005097          	auipc	ra,0x5
    8000194c:	d52080e7          	jalr	-686(ra) # 8000669a <release>
      return 0;
    80001950:	4501                	li	a0,0
}
    80001952:	70a2                	ld	ra,40(sp)
    80001954:	7402                	ld	s0,32(sp)
    80001956:	64e2                	ld	s1,24(sp)
    80001958:	6942                	ld	s2,16(sp)
    8000195a:	69a2                	ld	s3,8(sp)
    8000195c:	6145                	addi	sp,sp,48
    8000195e:	8082                	ret
        p->state = RUNNABLE;
    80001960:	478d                	li	a5,3
    80001962:	cc9c                	sw	a5,24(s1)
    80001964:	b7cd                	j	80001946 <kill+0x52>

0000000080001966 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001966:	7179                	addi	sp,sp,-48
    80001968:	f406                	sd	ra,40(sp)
    8000196a:	f022                	sd	s0,32(sp)
    8000196c:	ec26                	sd	s1,24(sp)
    8000196e:	e84a                	sd	s2,16(sp)
    80001970:	e44e                	sd	s3,8(sp)
    80001972:	e052                	sd	s4,0(sp)
    80001974:	1800                	addi	s0,sp,48
    80001976:	84aa                	mv	s1,a0
    80001978:	892e                	mv	s2,a1
    8000197a:	89b2                	mv	s3,a2
    8000197c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	4dc080e7          	jalr	1244(ra) # 80000e5a <myproc>
  if(user_dst){
    80001986:	c08d                	beqz	s1,800019a8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001988:	86d2                	mv	a3,s4
    8000198a:	864e                	mv	a2,s3
    8000198c:	85ca                	mv	a1,s2
    8000198e:	6928                	ld	a0,80(a0)
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	16e080e7          	jalr	366(ra) # 80000afe <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001998:	70a2                	ld	ra,40(sp)
    8000199a:	7402                	ld	s0,32(sp)
    8000199c:	64e2                	ld	s1,24(sp)
    8000199e:	6942                	ld	s2,16(sp)
    800019a0:	69a2                	ld	s3,8(sp)
    800019a2:	6a02                	ld	s4,0(sp)
    800019a4:	6145                	addi	sp,sp,48
    800019a6:	8082                	ret
    memmove((char *)dst, src, len);
    800019a8:	000a061b          	sext.w	a2,s4
    800019ac:	85ce                	mv	a1,s3
    800019ae:	854a                	mv	a0,s2
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	826080e7          	jalr	-2010(ra) # 800001d6 <memmove>
    return 0;
    800019b8:	8526                	mv	a0,s1
    800019ba:	bff9                	j	80001998 <either_copyout+0x32>

00000000800019bc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019bc:	7179                	addi	sp,sp,-48
    800019be:	f406                	sd	ra,40(sp)
    800019c0:	f022                	sd	s0,32(sp)
    800019c2:	ec26                	sd	s1,24(sp)
    800019c4:	e84a                	sd	s2,16(sp)
    800019c6:	e44e                	sd	s3,8(sp)
    800019c8:	e052                	sd	s4,0(sp)
    800019ca:	1800                	addi	s0,sp,48
    800019cc:	892a                	mv	s2,a0
    800019ce:	84ae                	mv	s1,a1
    800019d0:	89b2                	mv	s3,a2
    800019d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	486080e7          	jalr	1158(ra) # 80000e5a <myproc>
  if(user_src){
    800019dc:	c08d                	beqz	s1,800019fe <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019de:	86d2                	mv	a3,s4
    800019e0:	864e                	mv	a2,s3
    800019e2:	85ca                	mv	a1,s2
    800019e4:	6928                	ld	a0,80(a0)
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	1a4080e7          	jalr	420(ra) # 80000b8a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019ee:	70a2                	ld	ra,40(sp)
    800019f0:	7402                	ld	s0,32(sp)
    800019f2:	64e2                	ld	s1,24(sp)
    800019f4:	6942                	ld	s2,16(sp)
    800019f6:	69a2                	ld	s3,8(sp)
    800019f8:	6a02                	ld	s4,0(sp)
    800019fa:	6145                	addi	sp,sp,48
    800019fc:	8082                	ret
    memmove(dst, (char*)src, len);
    800019fe:	000a061b          	sext.w	a2,s4
    80001a02:	85ce                	mv	a1,s3
    80001a04:	854a                	mv	a0,s2
    80001a06:	ffffe097          	auipc	ra,0xffffe
    80001a0a:	7d0080e7          	jalr	2000(ra) # 800001d6 <memmove>
    return 0;
    80001a0e:	8526                	mv	a0,s1
    80001a10:	bff9                	j	800019ee <either_copyin+0x32>

0000000080001a12 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a12:	715d                	addi	sp,sp,-80
    80001a14:	e486                	sd	ra,72(sp)
    80001a16:	e0a2                	sd	s0,64(sp)
    80001a18:	fc26                	sd	s1,56(sp)
    80001a1a:	f84a                	sd	s2,48(sp)
    80001a1c:	f44e                	sd	s3,40(sp)
    80001a1e:	f052                	sd	s4,32(sp)
    80001a20:	ec56                	sd	s5,24(sp)
    80001a22:	e85a                	sd	s6,16(sp)
    80001a24:	e45e                	sd	s7,8(sp)
    80001a26:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a28:	00006517          	auipc	a0,0x6
    80001a2c:	5f050513          	addi	a0,a0,1520 # 80008018 <etext+0x18>
    80001a30:	00004097          	auipc	ra,0x4
    80001a34:	686080e7          	jalr	1670(ra) # 800060b6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a38:	0000b497          	auipc	s1,0xb
    80001a3c:	ba048493          	addi	s1,s1,-1120 # 8000c5d8 <proc+0x158>
    80001a40:	0001a917          	auipc	s2,0x1a
    80001a44:	59890913          	addi	s2,s2,1432 # 8001bfd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a48:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a4a:	00006997          	auipc	s3,0x6
    80001a4e:	77e98993          	addi	s3,s3,1918 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    80001a52:	00006a97          	auipc	s5,0x6
    80001a56:	77ea8a93          	addi	s5,s5,1918 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001a5a:	00006a17          	auipc	s4,0x6
    80001a5e:	5bea0a13          	addi	s4,s4,1470 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a62:	00007b97          	auipc	s7,0x7
    80001a66:	c66b8b93          	addi	s7,s7,-922 # 800086c8 <states.0>
    80001a6a:	a00d                	j	80001a8c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a6c:	ed86a583          	lw	a1,-296(a3)
    80001a70:	8556                	mv	a0,s5
    80001a72:	00004097          	auipc	ra,0x4
    80001a76:	644080e7          	jalr	1604(ra) # 800060b6 <printf>
    printf("\n");
    80001a7a:	8552                	mv	a0,s4
    80001a7c:	00004097          	auipc	ra,0x4
    80001a80:	63a080e7          	jalr	1594(ra) # 800060b6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a84:	3e848493          	addi	s1,s1,1000
    80001a88:	03248263          	beq	s1,s2,80001aac <procdump+0x9a>
    if(p->state == UNUSED)
    80001a8c:	86a6                	mv	a3,s1
    80001a8e:	ec04a783          	lw	a5,-320(s1)
    80001a92:	dbed                	beqz	a5,80001a84 <procdump+0x72>
      state = "???";
    80001a94:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a96:	fcfb6be3          	bltu	s6,a5,80001a6c <procdump+0x5a>
    80001a9a:	02079713          	slli	a4,a5,0x20
    80001a9e:	01d75793          	srli	a5,a4,0x1d
    80001aa2:	97de                	add	a5,a5,s7
    80001aa4:	6390                	ld	a2,0(a5)
    80001aa6:	f279                	bnez	a2,80001a6c <procdump+0x5a>
      state = "???";
    80001aa8:	864e                	mv	a2,s3
    80001aaa:	b7c9                	j	80001a6c <procdump+0x5a>
  }
}
    80001aac:	60a6                	ld	ra,72(sp)
    80001aae:	6406                	ld	s0,64(sp)
    80001ab0:	74e2                	ld	s1,56(sp)
    80001ab2:	7942                	ld	s2,48(sp)
    80001ab4:	79a2                	ld	s3,40(sp)
    80001ab6:	7a02                	ld	s4,32(sp)
    80001ab8:	6ae2                	ld	s5,24(sp)
    80001aba:	6b42                	ld	s6,16(sp)
    80001abc:	6ba2                	ld	s7,8(sp)
    80001abe:	6161                	addi	sp,sp,80
    80001ac0:	8082                	ret

0000000080001ac2 <swtch>:
    80001ac2:	00153023          	sd	ra,0(a0)
    80001ac6:	00253423          	sd	sp,8(a0)
    80001aca:	e900                	sd	s0,16(a0)
    80001acc:	ed04                	sd	s1,24(a0)
    80001ace:	03253023          	sd	s2,32(a0)
    80001ad2:	03353423          	sd	s3,40(a0)
    80001ad6:	03453823          	sd	s4,48(a0)
    80001ada:	03553c23          	sd	s5,56(a0)
    80001ade:	05653023          	sd	s6,64(a0)
    80001ae2:	05753423          	sd	s7,72(a0)
    80001ae6:	05853823          	sd	s8,80(a0)
    80001aea:	05953c23          	sd	s9,88(a0)
    80001aee:	07a53023          	sd	s10,96(a0)
    80001af2:	07b53423          	sd	s11,104(a0)
    80001af6:	0005b083          	ld	ra,0(a1)
    80001afa:	0085b103          	ld	sp,8(a1)
    80001afe:	6980                	ld	s0,16(a1)
    80001b00:	6d84                	ld	s1,24(a1)
    80001b02:	0205b903          	ld	s2,32(a1)
    80001b06:	0285b983          	ld	s3,40(a1)
    80001b0a:	0305ba03          	ld	s4,48(a1)
    80001b0e:	0385ba83          	ld	s5,56(a1)
    80001b12:	0405bb03          	ld	s6,64(a1)
    80001b16:	0485bb83          	ld	s7,72(a1)
    80001b1a:	0505bc03          	ld	s8,80(a1)
    80001b1e:	0585bc83          	ld	s9,88(a1)
    80001b22:	0605bd03          	ld	s10,96(a1)
    80001b26:	0685bd83          	ld	s11,104(a1)
    80001b2a:	8082                	ret

0000000080001b2c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b2c:	1141                	addi	sp,sp,-16
    80001b2e:	e406                	sd	ra,8(sp)
    80001b30:	e022                	sd	s0,0(sp)
    80001b32:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b34:	00006597          	auipc	a1,0x6
    80001b38:	6d458593          	addi	a1,a1,1748 # 80008208 <etext+0x208>
    80001b3c:	0001a517          	auipc	a0,0x1a
    80001b40:	34450513          	addi	a0,a0,836 # 8001be80 <tickslock>
    80001b44:	00005097          	auipc	ra,0x5
    80001b48:	a12080e7          	jalr	-1518(ra) # 80006556 <initlock>
}
    80001b4c:	60a2                	ld	ra,8(sp)
    80001b4e:	6402                	ld	s0,0(sp)
    80001b50:	0141                	addi	sp,sp,16
    80001b52:	8082                	ret

0000000080001b54 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b54:	1141                	addi	sp,sp,-16
    80001b56:	e422                	sd	s0,8(sp)
    80001b58:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b5a:	00004797          	auipc	a5,0x4
    80001b5e:	92678793          	addi	a5,a5,-1754 # 80005480 <kernelvec>
    80001b62:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b66:	6422                	ld	s0,8(sp)
    80001b68:	0141                	addi	sp,sp,16
    80001b6a:	8082                	ret

0000000080001b6c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b6c:	1141                	addi	sp,sp,-16
    80001b6e:	e406                	sd	ra,8(sp)
    80001b70:	e022                	sd	s0,0(sp)
    80001b72:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b74:	fffff097          	auipc	ra,0xfffff
    80001b78:	2e6080e7          	jalr	742(ra) # 80000e5a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b80:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b82:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b86:	00005697          	auipc	a3,0x5
    80001b8a:	47a68693          	addi	a3,a3,1146 # 80007000 <_trampoline>
    80001b8e:	00005717          	auipc	a4,0x5
    80001b92:	47270713          	addi	a4,a4,1138 # 80007000 <_trampoline>
    80001b96:	8f15                	sub	a4,a4,a3
    80001b98:	040007b7          	lui	a5,0x4000
    80001b9c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b9e:	07b2                	slli	a5,a5,0xc
    80001ba0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ba2:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ba6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ba8:	18002673          	csrr	a2,satp
    80001bac:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bae:	6d30                	ld	a2,88(a0)
    80001bb0:	6138                	ld	a4,64(a0)
    80001bb2:	6585                	lui	a1,0x1
    80001bb4:	972e                	add	a4,a4,a1
    80001bb6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bb8:	6d38                	ld	a4,88(a0)
    80001bba:	00000617          	auipc	a2,0x0
    80001bbe:	14060613          	addi	a2,a2,320 # 80001cfa <usertrap>
    80001bc2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bc4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bc6:	8612                	mv	a2,tp
    80001bc8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bca:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bce:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bd2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bda:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bdc:	6f18                	ld	a4,24(a4)
    80001bde:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001be2:	692c                	ld	a1,80(a0)
    80001be4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001be6:	00005717          	auipc	a4,0x5
    80001bea:	4aa70713          	addi	a4,a4,1194 # 80007090 <userret>
    80001bee:	8f15                	sub	a4,a4,a3
    80001bf0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bf2:	577d                	li	a4,-1
    80001bf4:	177e                	slli	a4,a4,0x3f
    80001bf6:	8dd9                	or	a1,a1,a4
    80001bf8:	02000537          	lui	a0,0x2000
    80001bfc:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bfe:	0536                	slli	a0,a0,0xd
    80001c00:	9782                	jalr	a5
}
    80001c02:	60a2                	ld	ra,8(sp)
    80001c04:	6402                	ld	s0,0(sp)
    80001c06:	0141                	addi	sp,sp,16
    80001c08:	8082                	ret

0000000080001c0a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c0a:	1101                	addi	sp,sp,-32
    80001c0c:	ec06                	sd	ra,24(sp)
    80001c0e:	e822                	sd	s0,16(sp)
    80001c10:	e426                	sd	s1,8(sp)
    80001c12:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c14:	0001a497          	auipc	s1,0x1a
    80001c18:	26c48493          	addi	s1,s1,620 # 8001be80 <tickslock>
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	00005097          	auipc	ra,0x5
    80001c22:	9c8080e7          	jalr	-1592(ra) # 800065e6 <acquire>
  ticks++;
    80001c26:	0000a517          	auipc	a0,0xa
    80001c2a:	3f250513          	addi	a0,a0,1010 # 8000c018 <ticks>
    80001c2e:	411c                	lw	a5,0(a0)
    80001c30:	2785                	addiw	a5,a5,1
    80001c32:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c34:	00000097          	auipc	ra,0x0
    80001c38:	ab2080e7          	jalr	-1358(ra) # 800016e6 <wakeup>
  release(&tickslock);
    80001c3c:	8526                	mv	a0,s1
    80001c3e:	00005097          	auipc	ra,0x5
    80001c42:	a5c080e7          	jalr	-1444(ra) # 8000669a <release>
}
    80001c46:	60e2                	ld	ra,24(sp)
    80001c48:	6442                	ld	s0,16(sp)
    80001c4a:	64a2                	ld	s1,8(sp)
    80001c4c:	6105                	addi	sp,sp,32
    80001c4e:	8082                	ret

0000000080001c50 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c50:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c54:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c56:	0a07d163          	bgez	a5,80001cf8 <devintr+0xa8>
{
    80001c5a:	1101                	addi	sp,sp,-32
    80001c5c:	ec06                	sd	ra,24(sp)
    80001c5e:	e822                	sd	s0,16(sp)
    80001c60:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c62:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c66:	46a5                	li	a3,9
    80001c68:	00d70c63          	beq	a4,a3,80001c80 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c6c:	577d                	li	a4,-1
    80001c6e:	177e                	slli	a4,a4,0x3f
    80001c70:	0705                	addi	a4,a4,1
    return 0;
    80001c72:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c74:	06e78163          	beq	a5,a4,80001cd6 <devintr+0x86>
  }
}
    80001c78:	60e2                	ld	ra,24(sp)
    80001c7a:	6442                	ld	s0,16(sp)
    80001c7c:	6105                	addi	sp,sp,32
    80001c7e:	8082                	ret
    80001c80:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c82:	00004097          	auipc	ra,0x4
    80001c86:	90a080e7          	jalr	-1782(ra) # 8000558c <plic_claim>
    80001c8a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c8c:	47a9                	li	a5,10
    80001c8e:	00f50963          	beq	a0,a5,80001ca0 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c92:	4785                	li	a5,1
    80001c94:	00f50b63          	beq	a0,a5,80001caa <devintr+0x5a>
    return 1;
    80001c98:	4505                	li	a0,1
    } else if(irq){
    80001c9a:	ec89                	bnez	s1,80001cb4 <devintr+0x64>
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	bfe9                	j	80001c78 <devintr+0x28>
      uartintr();
    80001ca0:	00005097          	auipc	ra,0x5
    80001ca4:	866080e7          	jalr	-1946(ra) # 80006506 <uartintr>
    if(irq)
    80001ca8:	a839                	j	80001cc6 <devintr+0x76>
      virtio_disk_intr();
    80001caa:	00004097          	auipc	ra,0x4
    80001cae:	db6080e7          	jalr	-586(ra) # 80005a60 <virtio_disk_intr>
    if(irq)
    80001cb2:	a811                	j	80001cc6 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb4:	85a6                	mv	a1,s1
    80001cb6:	00006517          	auipc	a0,0x6
    80001cba:	55a50513          	addi	a0,a0,1370 # 80008210 <etext+0x210>
    80001cbe:	00004097          	auipc	ra,0x4
    80001cc2:	3f8080e7          	jalr	1016(ra) # 800060b6 <printf>
      plic_complete(irq);
    80001cc6:	8526                	mv	a0,s1
    80001cc8:	00004097          	auipc	ra,0x4
    80001ccc:	8e8080e7          	jalr	-1816(ra) # 800055b0 <plic_complete>
    return 1;
    80001cd0:	4505                	li	a0,1
    80001cd2:	64a2                	ld	s1,8(sp)
    80001cd4:	b755                	j	80001c78 <devintr+0x28>
    if(cpuid() == 0){
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	158080e7          	jalr	344(ra) # 80000e2e <cpuid>
    80001cde:	c901                	beqz	a0,80001cee <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ce0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ce4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ce6:	14479073          	csrw	sip,a5
    return 2;
    80001cea:	4509                	li	a0,2
    80001cec:	b771                	j	80001c78 <devintr+0x28>
      clockintr();
    80001cee:	00000097          	auipc	ra,0x0
    80001cf2:	f1c080e7          	jalr	-228(ra) # 80001c0a <clockintr>
    80001cf6:	b7ed                	j	80001ce0 <devintr+0x90>
}
    80001cf8:	8082                	ret

0000000080001cfa <usertrap>:
{
    80001cfa:	7139                	addi	sp,sp,-64
    80001cfc:	fc06                	sd	ra,56(sp)
    80001cfe:	f822                	sd	s0,48(sp)
    80001d00:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d02:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d06:	1007f793          	andi	a5,a5,256
    80001d0a:	e7a5                	bnez	a5,80001d72 <usertrap+0x78>
    80001d0c:	f426                	sd	s1,40(sp)
    80001d0e:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d10:	00003797          	auipc	a5,0x3
    80001d14:	77078793          	addi	a5,a5,1904 # 80005480 <kernelvec>
    80001d18:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d1c:	fffff097          	auipc	ra,0xfffff
    80001d20:	13e080e7          	jalr	318(ra) # 80000e5a <myproc>
    80001d24:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d26:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d28:	14102773          	csrr	a4,sepc
    80001d2c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d2e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d32:	47a1                	li	a5,8
    80001d34:	06f71363          	bne	a4,a5,80001d9a <usertrap+0xa0>
    if(p->killed)
    80001d38:	551c                	lw	a5,40(a0)
    80001d3a:	ebb1                	bnez	a5,80001d8e <usertrap+0x94>
    p->trapframe->epc += 4;
    80001d3c:	6cb8                	ld	a4,88(s1)
    80001d3e:	6f1c                	ld	a5,24(a4)
    80001d40:	0791                	addi	a5,a5,4
    80001d42:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d44:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d48:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d4c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d50:	00000097          	auipc	ra,0x0
    80001d54:	436080e7          	jalr	1078(ra) # 80002186 <syscall>
  if(p->killed)
    80001d58:	549c                	lw	a5,40(s1)
    80001d5a:	1a079a63          	bnez	a5,80001f0e <usertrap+0x214>
  usertrapret();
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	e0e080e7          	jalr	-498(ra) # 80001b6c <usertrapret>
    80001d66:	74a2                	ld	s1,40(sp)
    80001d68:	7902                	ld	s2,32(sp)
}
    80001d6a:	70e2                	ld	ra,56(sp)
    80001d6c:	7442                	ld	s0,48(sp)
    80001d6e:	6121                	addi	sp,sp,64
    80001d70:	8082                	ret
    80001d72:	f426                	sd	s1,40(sp)
    80001d74:	f04a                	sd	s2,32(sp)
    80001d76:	ec4e                	sd	s3,24(sp)
    80001d78:	e852                	sd	s4,16(sp)
    80001d7a:	e456                	sd	s5,8(sp)
    80001d7c:	e05a                	sd	s6,0(sp)
    panic("usertrap: not from user mode");
    80001d7e:	00006517          	auipc	a0,0x6
    80001d82:	4b250513          	addi	a0,a0,1202 # 80008230 <etext+0x230>
    80001d86:	00004097          	auipc	ra,0x4
    80001d8a:	2e6080e7          	jalr	742(ra) # 8000606c <panic>
      exit(-1);
    80001d8e:	557d                	li	a0,-1
    80001d90:	00000097          	auipc	ra,0x0
    80001d94:	a26080e7          	jalr	-1498(ra) # 800017b6 <exit>
    80001d98:	b755                	j	80001d3c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	eb6080e7          	jalr	-330(ra) # 80001c50 <devintr>
    80001da2:	892a                	mv	s2,a0
    80001da4:	16051263          	bnez	a0,80001f08 <usertrap+0x20e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da8:	14202773          	csrr	a4,scause
  }else if (r_scause() == 13 || r_scause() == 15) 
    80001dac:	47b5                	li	a5,13
    80001dae:	00f70763          	beq	a4,a5,80001dbc <usertrap+0xc2>
    80001db2:	14202773          	csrr	a4,scause
    80001db6:	47bd                	li	a5,15
    80001db8:	12f71063          	bne	a4,a5,80001ed8 <usertrap+0x1de>
    80001dbc:	ec4e                	sd	s3,24(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dbe:	143029f3          	csrr	s3,stval
    if(va >= p->sz || va > MAXVA || PGROUNDUP(va) == PGROUNDDOWN(p->trapframe->sp))
    80001dc2:	64bc                	ld	a5,72(s1)
    80001dc4:	14f9f763          	bgeu	s3,a5,80001f12 <usertrap+0x218>
    80001dc8:	4785                	li	a5,1
    80001dca:	179a                	slli	a5,a5,0x26
    80001dcc:	1737e363          	bltu	a5,s3,80001f32 <usertrap+0x238>
    80001dd0:	6cb4                	ld	a3,88(s1)
    80001dd2:	6705                	lui	a4,0x1
    80001dd4:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80001dd8:	97ce                	add	a5,a5,s3
    80001dda:	7a94                	ld	a3,48(a3)
    80001ddc:	8fb5                	xor	a5,a5,a3
    80001dde:	14e7ec63          	bltu	a5,a4,80001f36 <usertrap+0x23c>
    80001de2:	17448793          	addi	a5,s1,372
      for (int i = 0; i < VMASIZE; i++) 
    80001de6:	874a                	mv	a4,s2
        if (p->vma[i].used == 1 && va >= p->vma[i].addr && 
    80001de8:	4585                	li	a1,1
      for (int i = 0; i < VMASIZE; i++) 
    80001dea:	4541                	li	a0,16
    80001dec:	a809                	j	80001dfe <usertrap+0x104>
    80001dee:	69e2                	ld	s3,24(sp)
    80001df0:	6a42                	ld	s4,16(sp)
    80001df2:	b79d                	j	80001d58 <usertrap+0x5e>
    80001df4:	2705                	addiw	a4,a4,1
    80001df6:	02878793          	addi	a5,a5,40
    80001dfa:	0ca70363          	beq	a4,a0,80001ec0 <usertrap+0x1c6>
        if (p->vma[i].used == 1 && va >= p->vma[i].addr && 
    80001dfe:	4394                	lw	a3,0(a5)
    80001e00:	feb69ae3          	bne	a3,a1,80001df4 <usertrap+0xfa>
    80001e04:	0047b683          	ld	a3,4(a5)
    80001e08:	fed9e6e3          	bltu	s3,a3,80001df4 <usertrap+0xfa>
            va < p->vma[i].addr + p->vma[i].length) {
    80001e0c:	47d0                	lw	a2,12(a5)
    80001e0e:	96b2                	add	a3,a3,a2
        if (p->vma[i].used == 1 && va >= p->vma[i].addr && 
    80001e10:	fed9f2e3          	bgeu	s3,a3,80001df4 <usertrap+0xfa>
    80001e14:	e852                	sd	s4,16(sp)
          vma = &p->vma[i];
    80001e16:	00271a13          	slli	s4,a4,0x2
    80001e1a:	9a3a                	add	s4,s4,a4
    80001e1c:	0a0e                	slli	s4,s4,0x3
    80001e1e:	168a0a13          	addi	s4,s4,360
    80001e22:	9a26                	add	s4,s4,s1
      if(vma) 
    80001e24:	fc0a05e3          	beqz	s4,80001dee <usertrap+0xf4>
    80001e28:	e456                	sd	s5,8(sp)
    80001e2a:	e05a                	sd	s6,0(sp)
        uint64 offset = va - vma->addr;
    80001e2c:	010a3b03          	ld	s6,16(s4)
        uint64 mem = (uint64)kalloc();
    80001e30:	ffffe097          	auipc	ra,0xffffe
    80001e34:	2ea080e7          	jalr	746(ra) # 8000011a <kalloc>
    80001e38:	8aaa                	mv	s5,a0
        if(mem == 0) 
    80001e3a:	10050063          	beqz	a0,80001f3a <usertrap+0x240>
        va = PGROUNDDOWN(va);
    80001e3e:	77fd                	lui	a5,0xfffff
    80001e40:	00f9f9b3          	and	s3,s3,a5
          memset((void*)mem, 0, PGSIZE);
    80001e44:	6605                	lui	a2,0x1
    80001e46:	4581                	li	a1,0
    80001e48:	ffffe097          	auipc	ra,0xffffe
    80001e4c:	332080e7          	jalr	818(ra) # 8000017a <memset>
		      ilock(vma->file->ip);
    80001e50:	000a3783          	ld	a5,0(s4)
    80001e54:	6f88                	ld	a0,24(a5)
    80001e56:	00001097          	auipc	ra,0x1
    80001e5a:	e2e080e7          	jalr	-466(ra) # 80002c84 <ilock>
          readi(vma->file->ip, 0, mem, offset, PGSIZE);
    80001e5e:	000a3783          	ld	a5,0(s4)
    80001e62:	6705                	lui	a4,0x1
    80001e64:	416986bb          	subw	a3,s3,s6
    80001e68:	8656                	mv	a2,s5
    80001e6a:	4581                	li	a1,0
    80001e6c:	6f88                	ld	a0,24(a5)
    80001e6e:	00001097          	auipc	ra,0x1
    80001e72:	0ce080e7          	jalr	206(ra) # 80002f3c <readi>
          iunlock(vma->file->ip);
    80001e76:	000a3783          	ld	a5,0(s4)
    80001e7a:	6f88                	ld	a0,24(a5)
    80001e7c:	00001097          	auipc	ra,0x1
    80001e80:	ece080e7          	jalr	-306(ra) # 80002d4a <iunlock>
          if(vma->prot & PROT_READ) flag |= PTE_R;
    80001e84:	01ca2783          	lw	a5,28(s4)
    80001e88:	0017f693          	andi	a3,a5,1
    80001e8c:	4749                	li	a4,18
    80001e8e:	e291                	bnez	a3,80001e92 <usertrap+0x198>
          int flag = PTE_U;
    80001e90:	4741                	li	a4,16
          if(vma->prot & PROT_WRITE) flag |= PTE_W;
    80001e92:	0027f693          	andi	a3,a5,2
    80001e96:	c299                	beqz	a3,80001e9c <usertrap+0x1a2>
    80001e98:	00476713          	ori	a4,a4,4
          if(vma->prot & PROT_EXEC) flag |= PTE_X;
    80001e9c:	8b91                	andi	a5,a5,4
    80001e9e:	c399                	beqz	a5,80001ea4 <usertrap+0x1aa>
    80001ea0:	00876713          	ori	a4,a4,8
          if(mappages(p->pagetable, va, PGSIZE, mem, flag) != 0) {
    80001ea4:	86d6                	mv	a3,s5
    80001ea6:	6605                	lui	a2,0x1
    80001ea8:	85ce                	mv	a1,s3
    80001eaa:	68a8                	ld	a0,80(s1)
    80001eac:	ffffe097          	auipc	ra,0xffffe
    80001eb0:	68e080e7          	jalr	1678(ra) # 8000053a <mappages>
    80001eb4:	e901                	bnez	a0,80001ec4 <usertrap+0x1ca>
    80001eb6:	69e2                	ld	s3,24(sp)
    80001eb8:	6a42                	ld	s4,16(sp)
    80001eba:	6aa2                	ld	s5,8(sp)
    80001ebc:	6b02                	ld	s6,0(sp)
    80001ebe:	bd69                	j	80001d58 <usertrap+0x5e>
    80001ec0:	69e2                	ld	s3,24(sp)
    80001ec2:	bd59                	j	80001d58 <usertrap+0x5e>
            kfree((void*)mem);
    80001ec4:	8556                	mv	a0,s5
    80001ec6:	ffffe097          	auipc	ra,0xffffe
    80001eca:	156080e7          	jalr	342(ra) # 8000001c <kfree>
            p->killed = 1;
    80001ece:	69e2                	ld	s3,24(sp)
    80001ed0:	6a42                	ld	s4,16(sp)
    80001ed2:	6aa2                	ld	s5,8(sp)
    80001ed4:	6b02                	ld	s6,0(sp)
    80001ed6:	a83d                	j	80001f14 <usertrap+0x21a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001edc:	5890                	lw	a2,48(s1)
    80001ede:	00006517          	auipc	a0,0x6
    80001ee2:	37250513          	addi	a0,a0,882 # 80008250 <etext+0x250>
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	1d0080e7          	jalr	464(ra) # 800060b6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ef2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ef6:	00006517          	auipc	a0,0x6
    80001efa:	38a50513          	addi	a0,a0,906 # 80008280 <etext+0x280>
    80001efe:	00004097          	auipc	ra,0x4
    80001f02:	1b8080e7          	jalr	440(ra) # 800060b6 <printf>
    p->killed = 1;
    80001f06:	a039                	j	80001f14 <usertrap+0x21a>
  if(p->killed)
    80001f08:	549c                	lw	a5,40(s1)
    80001f0a:	cf81                	beqz	a5,80001f22 <usertrap+0x228>
    80001f0c:	a031                	j	80001f18 <usertrap+0x21e>
    80001f0e:	4901                	li	s2,0
    80001f10:	a021                	j	80001f18 <usertrap+0x21e>
    80001f12:	69e2                	ld	s3,24(sp)
          p->killed = 1;
    80001f14:	4785                	li	a5,1
    80001f16:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f18:	557d                	li	a0,-1
    80001f1a:	00000097          	auipc	ra,0x0
    80001f1e:	89c080e7          	jalr	-1892(ra) # 800017b6 <exit>
  if(which_dev == 2)
    80001f22:	4789                	li	a5,2
    80001f24:	e2f91de3          	bne	s2,a5,80001d5e <usertrap+0x64>
    yield();
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	5f6080e7          	jalr	1526(ra) # 8000151e <yield>
    80001f30:	b53d                	j	80001d5e <usertrap+0x64>
    80001f32:	69e2                	ld	s3,24(sp)
    80001f34:	b7c5                	j	80001f14 <usertrap+0x21a>
    80001f36:	69e2                	ld	s3,24(sp)
    80001f38:	bff1                	j	80001f14 <usertrap+0x21a>
    80001f3a:	69e2                	ld	s3,24(sp)
    80001f3c:	6a42                	ld	s4,16(sp)
    80001f3e:	6aa2                	ld	s5,8(sp)
    80001f40:	6b02                	ld	s6,0(sp)
    80001f42:	bfc9                	j	80001f14 <usertrap+0x21a>

0000000080001f44 <kerneltrap>:
{
    80001f44:	7179                	addi	sp,sp,-48
    80001f46:	f406                	sd	ra,40(sp)
    80001f48:	f022                	sd	s0,32(sp)
    80001f4a:	ec26                	sd	s1,24(sp)
    80001f4c:	e84a                	sd	s2,16(sp)
    80001f4e:	e44e                	sd	s3,8(sp)
    80001f50:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f52:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f56:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f5a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f5e:	1004f793          	andi	a5,s1,256
    80001f62:	cb85                	beqz	a5,80001f92 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f64:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f68:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f6a:	ef85                	bnez	a5,80001fa2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f6c:	00000097          	auipc	ra,0x0
    80001f70:	ce4080e7          	jalr	-796(ra) # 80001c50 <devintr>
    80001f74:	cd1d                	beqz	a0,80001fb2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f76:	4789                	li	a5,2
    80001f78:	06f50a63          	beq	a0,a5,80001fec <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f7c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f80:	10049073          	csrw	sstatus,s1
}
    80001f84:	70a2                	ld	ra,40(sp)
    80001f86:	7402                	ld	s0,32(sp)
    80001f88:	64e2                	ld	s1,24(sp)
    80001f8a:	6942                	ld	s2,16(sp)
    80001f8c:	69a2                	ld	s3,8(sp)
    80001f8e:	6145                	addi	sp,sp,48
    80001f90:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f92:	00006517          	auipc	a0,0x6
    80001f96:	30e50513          	addi	a0,a0,782 # 800082a0 <etext+0x2a0>
    80001f9a:	00004097          	auipc	ra,0x4
    80001f9e:	0d2080e7          	jalr	210(ra) # 8000606c <panic>
    panic("kerneltrap: interrupts enabled");
    80001fa2:	00006517          	auipc	a0,0x6
    80001fa6:	32650513          	addi	a0,a0,806 # 800082c8 <etext+0x2c8>
    80001faa:	00004097          	auipc	ra,0x4
    80001fae:	0c2080e7          	jalr	194(ra) # 8000606c <panic>
    printf("scause %p\n", scause);
    80001fb2:	85ce                	mv	a1,s3
    80001fb4:	00006517          	auipc	a0,0x6
    80001fb8:	33450513          	addi	a0,a0,820 # 800082e8 <etext+0x2e8>
    80001fbc:	00004097          	auipc	ra,0x4
    80001fc0:	0fa080e7          	jalr	250(ra) # 800060b6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fc4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fc8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fcc:	00006517          	auipc	a0,0x6
    80001fd0:	32c50513          	addi	a0,a0,812 # 800082f8 <etext+0x2f8>
    80001fd4:	00004097          	auipc	ra,0x4
    80001fd8:	0e2080e7          	jalr	226(ra) # 800060b6 <printf>
    panic("kerneltrap");
    80001fdc:	00006517          	auipc	a0,0x6
    80001fe0:	33450513          	addi	a0,a0,820 # 80008310 <etext+0x310>
    80001fe4:	00004097          	auipc	ra,0x4
    80001fe8:	088080e7          	jalr	136(ra) # 8000606c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fec:	fffff097          	auipc	ra,0xfffff
    80001ff0:	e6e080e7          	jalr	-402(ra) # 80000e5a <myproc>
    80001ff4:	d541                	beqz	a0,80001f7c <kerneltrap+0x38>
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	e64080e7          	jalr	-412(ra) # 80000e5a <myproc>
    80001ffe:	4d18                	lw	a4,24(a0)
    80002000:	4791                	li	a5,4
    80002002:	f6f71de3          	bne	a4,a5,80001f7c <kerneltrap+0x38>
    yield();
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	518080e7          	jalr	1304(ra) # 8000151e <yield>
    8000200e:	b7bd                	j	80001f7c <kerneltrap+0x38>

0000000080002010 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	1000                	addi	s0,sp,32
    8000201a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	e3e080e7          	jalr	-450(ra) # 80000e5a <myproc>
  switch (n) {
    80002024:	4795                	li	a5,5
    80002026:	0497e163          	bltu	a5,s1,80002068 <argraw+0x58>
    8000202a:	048a                	slli	s1,s1,0x2
    8000202c:	00006717          	auipc	a4,0x6
    80002030:	6cc70713          	addi	a4,a4,1740 # 800086f8 <states.0+0x30>
    80002034:	94ba                	add	s1,s1,a4
    80002036:	409c                	lw	a5,0(s1)
    80002038:	97ba                	add	a5,a5,a4
    8000203a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000203c:	6d3c                	ld	a5,88(a0)
    8000203e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret
    return p->trapframe->a1;
    8000204a:	6d3c                	ld	a5,88(a0)
    8000204c:	7fa8                	ld	a0,120(a5)
    8000204e:	bfcd                	j	80002040 <argraw+0x30>
    return p->trapframe->a2;
    80002050:	6d3c                	ld	a5,88(a0)
    80002052:	63c8                	ld	a0,128(a5)
    80002054:	b7f5                	j	80002040 <argraw+0x30>
    return p->trapframe->a3;
    80002056:	6d3c                	ld	a5,88(a0)
    80002058:	67c8                	ld	a0,136(a5)
    8000205a:	b7dd                	j	80002040 <argraw+0x30>
    return p->trapframe->a4;
    8000205c:	6d3c                	ld	a5,88(a0)
    8000205e:	6bc8                	ld	a0,144(a5)
    80002060:	b7c5                	j	80002040 <argraw+0x30>
    return p->trapframe->a5;
    80002062:	6d3c                	ld	a5,88(a0)
    80002064:	6fc8                	ld	a0,152(a5)
    80002066:	bfe9                	j	80002040 <argraw+0x30>
  panic("argraw");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	2b850513          	addi	a0,a0,696 # 80008320 <etext+0x320>
    80002070:	00004097          	auipc	ra,0x4
    80002074:	ffc080e7          	jalr	-4(ra) # 8000606c <panic>

0000000080002078 <fetchaddr>:
{
    80002078:	1101                	addi	sp,sp,-32
    8000207a:	ec06                	sd	ra,24(sp)
    8000207c:	e822                	sd	s0,16(sp)
    8000207e:	e426                	sd	s1,8(sp)
    80002080:	e04a                	sd	s2,0(sp)
    80002082:	1000                	addi	s0,sp,32
    80002084:	84aa                	mv	s1,a0
    80002086:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	dd2080e7          	jalr	-558(ra) # 80000e5a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002090:	653c                	ld	a5,72(a0)
    80002092:	02f4f863          	bgeu	s1,a5,800020c2 <fetchaddr+0x4a>
    80002096:	00848713          	addi	a4,s1,8
    8000209a:	02e7e663          	bltu	a5,a4,800020c6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000209e:	46a1                	li	a3,8
    800020a0:	8626                	mv	a2,s1
    800020a2:	85ca                	mv	a1,s2
    800020a4:	6928                	ld	a0,80(a0)
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	ae4080e7          	jalr	-1308(ra) # 80000b8a <copyin>
    800020ae:	00a03533          	snez	a0,a0
    800020b2:	40a00533          	neg	a0,a0
}
    800020b6:	60e2                	ld	ra,24(sp)
    800020b8:	6442                	ld	s0,16(sp)
    800020ba:	64a2                	ld	s1,8(sp)
    800020bc:	6902                	ld	s2,0(sp)
    800020be:	6105                	addi	sp,sp,32
    800020c0:	8082                	ret
    return -1;
    800020c2:	557d                	li	a0,-1
    800020c4:	bfcd                	j	800020b6 <fetchaddr+0x3e>
    800020c6:	557d                	li	a0,-1
    800020c8:	b7fd                	j	800020b6 <fetchaddr+0x3e>

00000000800020ca <fetchstr>:
{
    800020ca:	7179                	addi	sp,sp,-48
    800020cc:	f406                	sd	ra,40(sp)
    800020ce:	f022                	sd	s0,32(sp)
    800020d0:	ec26                	sd	s1,24(sp)
    800020d2:	e84a                	sd	s2,16(sp)
    800020d4:	e44e                	sd	s3,8(sp)
    800020d6:	1800                	addi	s0,sp,48
    800020d8:	892a                	mv	s2,a0
    800020da:	84ae                	mv	s1,a1
    800020dc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	d7c080e7          	jalr	-644(ra) # 80000e5a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020e6:	86ce                	mv	a3,s3
    800020e8:	864a                	mv	a2,s2
    800020ea:	85a6                	mv	a1,s1
    800020ec:	6928                	ld	a0,80(a0)
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	b2a080e7          	jalr	-1238(ra) # 80000c18 <copyinstr>
  if(err < 0)
    800020f6:	00054763          	bltz	a0,80002104 <fetchstr+0x3a>
  return strlen(buf);
    800020fa:	8526                	mv	a0,s1
    800020fc:	ffffe097          	auipc	ra,0xffffe
    80002100:	1f2080e7          	jalr	498(ra) # 800002ee <strlen>
}
    80002104:	70a2                	ld	ra,40(sp)
    80002106:	7402                	ld	s0,32(sp)
    80002108:	64e2                	ld	s1,24(sp)
    8000210a:	6942                	ld	s2,16(sp)
    8000210c:	69a2                	ld	s3,8(sp)
    8000210e:	6145                	addi	sp,sp,48
    80002110:	8082                	ret

0000000080002112 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002112:	1101                	addi	sp,sp,-32
    80002114:	ec06                	sd	ra,24(sp)
    80002116:	e822                	sd	s0,16(sp)
    80002118:	e426                	sd	s1,8(sp)
    8000211a:	1000                	addi	s0,sp,32
    8000211c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	ef2080e7          	jalr	-270(ra) # 80002010 <argraw>
    80002126:	c088                	sw	a0,0(s1)
  return 0;
}
    80002128:	4501                	li	a0,0
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	64a2                	ld	s1,8(sp)
    80002130:	6105                	addi	sp,sp,32
    80002132:	8082                	ret

0000000080002134 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002134:	1101                	addi	sp,sp,-32
    80002136:	ec06                	sd	ra,24(sp)
    80002138:	e822                	sd	s0,16(sp)
    8000213a:	e426                	sd	s1,8(sp)
    8000213c:	1000                	addi	s0,sp,32
    8000213e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002140:	00000097          	auipc	ra,0x0
    80002144:	ed0080e7          	jalr	-304(ra) # 80002010 <argraw>
    80002148:	e088                	sd	a0,0(s1)
  return 0;
}
    8000214a:	4501                	li	a0,0
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	64a2                	ld	s1,8(sp)
    80002152:	6105                	addi	sp,sp,32
    80002154:	8082                	ret

0000000080002156 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002156:	1101                	addi	sp,sp,-32
    80002158:	ec06                	sd	ra,24(sp)
    8000215a:	e822                	sd	s0,16(sp)
    8000215c:	e426                	sd	s1,8(sp)
    8000215e:	e04a                	sd	s2,0(sp)
    80002160:	1000                	addi	s0,sp,32
    80002162:	84ae                	mv	s1,a1
    80002164:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	eaa080e7          	jalr	-342(ra) # 80002010 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000216e:	864a                	mv	a2,s2
    80002170:	85a6                	mv	a1,s1
    80002172:	00000097          	auipc	ra,0x0
    80002176:	f58080e7          	jalr	-168(ra) # 800020ca <fetchstr>
}
    8000217a:	60e2                	ld	ra,24(sp)
    8000217c:	6442                	ld	s0,16(sp)
    8000217e:	64a2                	ld	s1,8(sp)
    80002180:	6902                	ld	s2,0(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret

0000000080002186 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80002186:	1101                	addi	sp,sp,-32
    80002188:	ec06                	sd	ra,24(sp)
    8000218a:	e822                	sd	s0,16(sp)
    8000218c:	e426                	sd	s1,8(sp)
    8000218e:	e04a                	sd	s2,0(sp)
    80002190:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	cc8080e7          	jalr	-824(ra) # 80000e5a <myproc>
    8000219a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000219c:	05853903          	ld	s2,88(a0)
    800021a0:	0a893783          	ld	a5,168(s2)
    800021a4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021a8:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffcbdbf>
    800021aa:	4759                	li	a4,22
    800021ac:	00f76f63          	bltu	a4,a5,800021ca <syscall+0x44>
    800021b0:	00369713          	slli	a4,a3,0x3
    800021b4:	00006797          	auipc	a5,0x6
    800021b8:	55c78793          	addi	a5,a5,1372 # 80008710 <syscalls>
    800021bc:	97ba                	add	a5,a5,a4
    800021be:	639c                	ld	a5,0(a5)
    800021c0:	c789                	beqz	a5,800021ca <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021c2:	9782                	jalr	a5
    800021c4:	06a93823          	sd	a0,112(s2)
    800021c8:	a839                	j	800021e6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021ca:	15848613          	addi	a2,s1,344
    800021ce:	588c                	lw	a1,48(s1)
    800021d0:	00006517          	auipc	a0,0x6
    800021d4:	15850513          	addi	a0,a0,344 # 80008328 <etext+0x328>
    800021d8:	00004097          	auipc	ra,0x4
    800021dc:	ede080e7          	jalr	-290(ra) # 800060b6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021e0:	6cbc                	ld	a5,88(s1)
    800021e2:	577d                	li	a4,-1
    800021e4:	fbb8                	sd	a4,112(a5)
  }
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6902                	ld	s2,0(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret

00000000800021f2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021fa:	fec40593          	addi	a1,s0,-20
    800021fe:	4501                	li	a0,0
    80002200:	00000097          	auipc	ra,0x0
    80002204:	f12080e7          	jalr	-238(ra) # 80002112 <argint>
    return -1;
    80002208:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000220a:	00054963          	bltz	a0,8000221c <sys_exit+0x2a>
  exit(n);
    8000220e:	fec42503          	lw	a0,-20(s0)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	5a4080e7          	jalr	1444(ra) # 800017b6 <exit>
  return 0;  // not reached
    8000221a:	4781                	li	a5,0
}
    8000221c:	853e                	mv	a0,a5
    8000221e:	60e2                	ld	ra,24(sp)
    80002220:	6442                	ld	s0,16(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002226:	1141                	addi	sp,sp,-16
    80002228:	e406                	sd	ra,8(sp)
    8000222a:	e022                	sd	s0,0(sp)
    8000222c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	c2c080e7          	jalr	-980(ra) # 80000e5a <myproc>
}
    80002236:	5908                	lw	a0,48(a0)
    80002238:	60a2                	ld	ra,8(sp)
    8000223a:	6402                	ld	s0,0(sp)
    8000223c:	0141                	addi	sp,sp,16
    8000223e:	8082                	ret

0000000080002240 <sys_fork>:

uint64
sys_fork(void)
{
    80002240:	1141                	addi	sp,sp,-16
    80002242:	e406                	sd	ra,8(sp)
    80002244:	e022                	sd	s0,0(sp)
    80002246:	0800                	addi	s0,sp,16
  return fork();
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	fe4080e7          	jalr	-28(ra) # 8000122c <fork>
}
    80002250:	60a2                	ld	ra,8(sp)
    80002252:	6402                	ld	s0,0(sp)
    80002254:	0141                	addi	sp,sp,16
    80002256:	8082                	ret

0000000080002258 <sys_wait>:

uint64
sys_wait(void)
{
    80002258:	1101                	addi	sp,sp,-32
    8000225a:	ec06                	sd	ra,24(sp)
    8000225c:	e822                	sd	s0,16(sp)
    8000225e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002260:	fe840593          	addi	a1,s0,-24
    80002264:	4501                	li	a0,0
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	ece080e7          	jalr	-306(ra) # 80002134 <argaddr>
    8000226e:	87aa                	mv	a5,a0
    return -1;
    80002270:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002272:	0007c863          	bltz	a5,80002282 <sys_wait+0x2a>
  return wait(p);
    80002276:	fe843503          	ld	a0,-24(s0)
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	344080e7          	jalr	836(ra) # 800015be <wait>
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret

000000008000228a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000228a:	7179                	addi	sp,sp,-48
    8000228c:	f406                	sd	ra,40(sp)
    8000228e:	f022                	sd	s0,32(sp)
    80002290:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002292:	fdc40593          	addi	a1,s0,-36
    80002296:	4501                	li	a0,0
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	e7a080e7          	jalr	-390(ra) # 80002112 <argint>
    800022a0:	87aa                	mv	a5,a0
    return -1;
    800022a2:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022a4:	0207c263          	bltz	a5,800022c8 <sys_sbrk+0x3e>
    800022a8:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	bb0080e7          	jalr	-1104(ra) # 80000e5a <myproc>
    800022b2:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022b4:	fdc42503          	lw	a0,-36(s0)
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	efc080e7          	jalr	-260(ra) # 800011b4 <growproc>
    800022c0:	00054863          	bltz	a0,800022d0 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022c4:	8526                	mv	a0,s1
    800022c6:	64e2                	ld	s1,24(sp)
}
    800022c8:	70a2                	ld	ra,40(sp)
    800022ca:	7402                	ld	s0,32(sp)
    800022cc:	6145                	addi	sp,sp,48
    800022ce:	8082                	ret
    return -1;
    800022d0:	557d                	li	a0,-1
    800022d2:	64e2                	ld	s1,24(sp)
    800022d4:	bfd5                	j	800022c8 <sys_sbrk+0x3e>

00000000800022d6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022d6:	7139                	addi	sp,sp,-64
    800022d8:	fc06                	sd	ra,56(sp)
    800022da:	f822                	sd	s0,48(sp)
    800022dc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022de:	fcc40593          	addi	a1,s0,-52
    800022e2:	4501                	li	a0,0
    800022e4:	00000097          	auipc	ra,0x0
    800022e8:	e2e080e7          	jalr	-466(ra) # 80002112 <argint>
    return -1;
    800022ec:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022ee:	06054b63          	bltz	a0,80002364 <sys_sleep+0x8e>
    800022f2:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800022f4:	0001a517          	auipc	a0,0x1a
    800022f8:	b8c50513          	addi	a0,a0,-1140 # 8001be80 <tickslock>
    800022fc:	00004097          	auipc	ra,0x4
    80002300:	2ea080e7          	jalr	746(ra) # 800065e6 <acquire>
  ticks0 = ticks;
    80002304:	0000a917          	auipc	s2,0xa
    80002308:	d1492903          	lw	s2,-748(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    8000230c:	fcc42783          	lw	a5,-52(s0)
    80002310:	c3a1                	beqz	a5,80002350 <sys_sleep+0x7a>
    80002312:	f426                	sd	s1,40(sp)
    80002314:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002316:	0001a997          	auipc	s3,0x1a
    8000231a:	b6a98993          	addi	s3,s3,-1174 # 8001be80 <tickslock>
    8000231e:	0000a497          	auipc	s1,0xa
    80002322:	cfa48493          	addi	s1,s1,-774 # 8000c018 <ticks>
    if(myproc()->killed){
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	b34080e7          	jalr	-1228(ra) # 80000e5a <myproc>
    8000232e:	551c                	lw	a5,40(a0)
    80002330:	ef9d                	bnez	a5,8000236e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002332:	85ce                	mv	a1,s3
    80002334:	8526                	mv	a0,s1
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	224080e7          	jalr	548(ra) # 8000155a <sleep>
  while(ticks - ticks0 < n){
    8000233e:	409c                	lw	a5,0(s1)
    80002340:	412787bb          	subw	a5,a5,s2
    80002344:	fcc42703          	lw	a4,-52(s0)
    80002348:	fce7efe3          	bltu	a5,a4,80002326 <sys_sleep+0x50>
    8000234c:	74a2                	ld	s1,40(sp)
    8000234e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002350:	0001a517          	auipc	a0,0x1a
    80002354:	b3050513          	addi	a0,a0,-1232 # 8001be80 <tickslock>
    80002358:	00004097          	auipc	ra,0x4
    8000235c:	342080e7          	jalr	834(ra) # 8000669a <release>
  return 0;
    80002360:	4781                	li	a5,0
    80002362:	7902                	ld	s2,32(sp)
}
    80002364:	853e                	mv	a0,a5
    80002366:	70e2                	ld	ra,56(sp)
    80002368:	7442                	ld	s0,48(sp)
    8000236a:	6121                	addi	sp,sp,64
    8000236c:	8082                	ret
      release(&tickslock);
    8000236e:	0001a517          	auipc	a0,0x1a
    80002372:	b1250513          	addi	a0,a0,-1262 # 8001be80 <tickslock>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	324080e7          	jalr	804(ra) # 8000669a <release>
      return -1;
    8000237e:	57fd                	li	a5,-1
    80002380:	74a2                	ld	s1,40(sp)
    80002382:	7902                	ld	s2,32(sp)
    80002384:	69e2                	ld	s3,24(sp)
    80002386:	bff9                	j	80002364 <sys_sleep+0x8e>

0000000080002388 <sys_kill>:

uint64
sys_kill(void)
{
    80002388:	1101                	addi	sp,sp,-32
    8000238a:	ec06                	sd	ra,24(sp)
    8000238c:	e822                	sd	s0,16(sp)
    8000238e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002390:	fec40593          	addi	a1,s0,-20
    80002394:	4501                	li	a0,0
    80002396:	00000097          	auipc	ra,0x0
    8000239a:	d7c080e7          	jalr	-644(ra) # 80002112 <argint>
    8000239e:	87aa                	mv	a5,a0
    return -1;
    800023a0:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023a2:	0007c863          	bltz	a5,800023b2 <sys_kill+0x2a>
  return kill(pid);
    800023a6:	fec42503          	lw	a0,-20(s0)
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	54a080e7          	jalr	1354(ra) # 800018f4 <kill>
}
    800023b2:	60e2                	ld	ra,24(sp)
    800023b4:	6442                	ld	s0,16(sp)
    800023b6:	6105                	addi	sp,sp,32
    800023b8:	8082                	ret

00000000800023ba <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023ba:	1101                	addi	sp,sp,-32
    800023bc:	ec06                	sd	ra,24(sp)
    800023be:	e822                	sd	s0,16(sp)
    800023c0:	e426                	sd	s1,8(sp)
    800023c2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023c4:	0001a517          	auipc	a0,0x1a
    800023c8:	abc50513          	addi	a0,a0,-1348 # 8001be80 <tickslock>
    800023cc:	00004097          	auipc	ra,0x4
    800023d0:	21a080e7          	jalr	538(ra) # 800065e6 <acquire>
  xticks = ticks;
    800023d4:	0000a497          	auipc	s1,0xa
    800023d8:	c444a483          	lw	s1,-956(s1) # 8000c018 <ticks>
  release(&tickslock);
    800023dc:	0001a517          	auipc	a0,0x1a
    800023e0:	aa450513          	addi	a0,a0,-1372 # 8001be80 <tickslock>
    800023e4:	00004097          	auipc	ra,0x4
    800023e8:	2b6080e7          	jalr	694(ra) # 8000669a <release>
  return xticks;
}
    800023ec:	02049513          	slli	a0,s1,0x20
    800023f0:	9101                	srli	a0,a0,0x20
    800023f2:	60e2                	ld	ra,24(sp)
    800023f4:	6442                	ld	s0,16(sp)
    800023f6:	64a2                	ld	s1,8(sp)
    800023f8:	6105                	addi	sp,sp,32
    800023fa:	8082                	ret

00000000800023fc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023fc:	7179                	addi	sp,sp,-48
    800023fe:	f406                	sd	ra,40(sp)
    80002400:	f022                	sd	s0,32(sp)
    80002402:	ec26                	sd	s1,24(sp)
    80002404:	e84a                	sd	s2,16(sp)
    80002406:	e44e                	sd	s3,8(sp)
    80002408:	e052                	sd	s4,0(sp)
    8000240a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000240c:	00006597          	auipc	a1,0x6
    80002410:	f3c58593          	addi	a1,a1,-196 # 80008348 <etext+0x348>
    80002414:	0001a517          	auipc	a0,0x1a
    80002418:	a8450513          	addi	a0,a0,-1404 # 8001be98 <bcache>
    8000241c:	00004097          	auipc	ra,0x4
    80002420:	13a080e7          	jalr	314(ra) # 80006556 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002424:	00022797          	auipc	a5,0x22
    80002428:	a7478793          	addi	a5,a5,-1420 # 80023e98 <bcache+0x8000>
    8000242c:	00022717          	auipc	a4,0x22
    80002430:	cd470713          	addi	a4,a4,-812 # 80024100 <bcache+0x8268>
    80002434:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002438:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000243c:	0001a497          	auipc	s1,0x1a
    80002440:	a7448493          	addi	s1,s1,-1420 # 8001beb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002444:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002446:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002448:	00006a17          	auipc	s4,0x6
    8000244c:	f08a0a13          	addi	s4,s4,-248 # 80008350 <etext+0x350>
    b->next = bcache.head.next;
    80002450:	2b893783          	ld	a5,696(s2)
    80002454:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002456:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000245a:	85d2                	mv	a1,s4
    8000245c:	01048513          	addi	a0,s1,16
    80002460:	00001097          	auipc	ra,0x1
    80002464:	4b2080e7          	jalr	1202(ra) # 80003912 <initsleeplock>
    bcache.head.next->prev = b;
    80002468:	2b893783          	ld	a5,696(s2)
    8000246c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000246e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002472:	45848493          	addi	s1,s1,1112
    80002476:	fd349de3          	bne	s1,s3,80002450 <binit+0x54>
  }
}
    8000247a:	70a2                	ld	ra,40(sp)
    8000247c:	7402                	ld	s0,32(sp)
    8000247e:	64e2                	ld	s1,24(sp)
    80002480:	6942                	ld	s2,16(sp)
    80002482:	69a2                	ld	s3,8(sp)
    80002484:	6a02                	ld	s4,0(sp)
    80002486:	6145                	addi	sp,sp,48
    80002488:	8082                	ret

000000008000248a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000248a:	7179                	addi	sp,sp,-48
    8000248c:	f406                	sd	ra,40(sp)
    8000248e:	f022                	sd	s0,32(sp)
    80002490:	ec26                	sd	s1,24(sp)
    80002492:	e84a                	sd	s2,16(sp)
    80002494:	e44e                	sd	s3,8(sp)
    80002496:	1800                	addi	s0,sp,48
    80002498:	892a                	mv	s2,a0
    8000249a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000249c:	0001a517          	auipc	a0,0x1a
    800024a0:	9fc50513          	addi	a0,a0,-1540 # 8001be98 <bcache>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	142080e7          	jalr	322(ra) # 800065e6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024ac:	00022497          	auipc	s1,0x22
    800024b0:	ca44b483          	ld	s1,-860(s1) # 80024150 <bcache+0x82b8>
    800024b4:	00022797          	auipc	a5,0x22
    800024b8:	c4c78793          	addi	a5,a5,-948 # 80024100 <bcache+0x8268>
    800024bc:	02f48f63          	beq	s1,a5,800024fa <bread+0x70>
    800024c0:	873e                	mv	a4,a5
    800024c2:	a021                	j	800024ca <bread+0x40>
    800024c4:	68a4                	ld	s1,80(s1)
    800024c6:	02e48a63          	beq	s1,a4,800024fa <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024ca:	449c                	lw	a5,8(s1)
    800024cc:	ff279ce3          	bne	a5,s2,800024c4 <bread+0x3a>
    800024d0:	44dc                	lw	a5,12(s1)
    800024d2:	ff3799e3          	bne	a5,s3,800024c4 <bread+0x3a>
      b->refcnt++;
    800024d6:	40bc                	lw	a5,64(s1)
    800024d8:	2785                	addiw	a5,a5,1
    800024da:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024dc:	0001a517          	auipc	a0,0x1a
    800024e0:	9bc50513          	addi	a0,a0,-1604 # 8001be98 <bcache>
    800024e4:	00004097          	auipc	ra,0x4
    800024e8:	1b6080e7          	jalr	438(ra) # 8000669a <release>
      acquiresleep(&b->lock);
    800024ec:	01048513          	addi	a0,s1,16
    800024f0:	00001097          	auipc	ra,0x1
    800024f4:	45c080e7          	jalr	1116(ra) # 8000394c <acquiresleep>
      return b;
    800024f8:	a8b9                	j	80002556 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024fa:	00022497          	auipc	s1,0x22
    800024fe:	c4e4b483          	ld	s1,-946(s1) # 80024148 <bcache+0x82b0>
    80002502:	00022797          	auipc	a5,0x22
    80002506:	bfe78793          	addi	a5,a5,-1026 # 80024100 <bcache+0x8268>
    8000250a:	00f48863          	beq	s1,a5,8000251a <bread+0x90>
    8000250e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002510:	40bc                	lw	a5,64(s1)
    80002512:	cf81                	beqz	a5,8000252a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002514:	64a4                	ld	s1,72(s1)
    80002516:	fee49de3          	bne	s1,a4,80002510 <bread+0x86>
  panic("bget: no buffers");
    8000251a:	00006517          	auipc	a0,0x6
    8000251e:	e3e50513          	addi	a0,a0,-450 # 80008358 <etext+0x358>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	b4a080e7          	jalr	-1206(ra) # 8000606c <panic>
      b->dev = dev;
    8000252a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000252e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002532:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002536:	4785                	li	a5,1
    80002538:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000253a:	0001a517          	auipc	a0,0x1a
    8000253e:	95e50513          	addi	a0,a0,-1698 # 8001be98 <bcache>
    80002542:	00004097          	auipc	ra,0x4
    80002546:	158080e7          	jalr	344(ra) # 8000669a <release>
      acquiresleep(&b->lock);
    8000254a:	01048513          	addi	a0,s1,16
    8000254e:	00001097          	auipc	ra,0x1
    80002552:	3fe080e7          	jalr	1022(ra) # 8000394c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002556:	409c                	lw	a5,0(s1)
    80002558:	cb89                	beqz	a5,8000256a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000255a:	8526                	mv	a0,s1
    8000255c:	70a2                	ld	ra,40(sp)
    8000255e:	7402                	ld	s0,32(sp)
    80002560:	64e2                	ld	s1,24(sp)
    80002562:	6942                	ld	s2,16(sp)
    80002564:	69a2                	ld	s3,8(sp)
    80002566:	6145                	addi	sp,sp,48
    80002568:	8082                	ret
    virtio_disk_rw(b, 0);
    8000256a:	4581                	li	a1,0
    8000256c:	8526                	mv	a0,s1
    8000256e:	00003097          	auipc	ra,0x3
    80002572:	264080e7          	jalr	612(ra) # 800057d2 <virtio_disk_rw>
    b->valid = 1;
    80002576:	4785                	li	a5,1
    80002578:	c09c                	sw	a5,0(s1)
  return b;
    8000257a:	b7c5                	j	8000255a <bread+0xd0>

000000008000257c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000257c:	1101                	addi	sp,sp,-32
    8000257e:	ec06                	sd	ra,24(sp)
    80002580:	e822                	sd	s0,16(sp)
    80002582:	e426                	sd	s1,8(sp)
    80002584:	1000                	addi	s0,sp,32
    80002586:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002588:	0541                	addi	a0,a0,16
    8000258a:	00001097          	auipc	ra,0x1
    8000258e:	45c080e7          	jalr	1116(ra) # 800039e6 <holdingsleep>
    80002592:	cd01                	beqz	a0,800025aa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002594:	4585                	li	a1,1
    80002596:	8526                	mv	a0,s1
    80002598:	00003097          	auipc	ra,0x3
    8000259c:	23a080e7          	jalr	570(ra) # 800057d2 <virtio_disk_rw>
}
    800025a0:	60e2                	ld	ra,24(sp)
    800025a2:	6442                	ld	s0,16(sp)
    800025a4:	64a2                	ld	s1,8(sp)
    800025a6:	6105                	addi	sp,sp,32
    800025a8:	8082                	ret
    panic("bwrite");
    800025aa:	00006517          	auipc	a0,0x6
    800025ae:	dc650513          	addi	a0,a0,-570 # 80008370 <etext+0x370>
    800025b2:	00004097          	auipc	ra,0x4
    800025b6:	aba080e7          	jalr	-1350(ra) # 8000606c <panic>

00000000800025ba <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025ba:	1101                	addi	sp,sp,-32
    800025bc:	ec06                	sd	ra,24(sp)
    800025be:	e822                	sd	s0,16(sp)
    800025c0:	e426                	sd	s1,8(sp)
    800025c2:	e04a                	sd	s2,0(sp)
    800025c4:	1000                	addi	s0,sp,32
    800025c6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025c8:	01050913          	addi	s2,a0,16
    800025cc:	854a                	mv	a0,s2
    800025ce:	00001097          	auipc	ra,0x1
    800025d2:	418080e7          	jalr	1048(ra) # 800039e6 <holdingsleep>
    800025d6:	c925                	beqz	a0,80002646 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800025d8:	854a                	mv	a0,s2
    800025da:	00001097          	auipc	ra,0x1
    800025de:	3c8080e7          	jalr	968(ra) # 800039a2 <releasesleep>

  acquire(&bcache.lock);
    800025e2:	0001a517          	auipc	a0,0x1a
    800025e6:	8b650513          	addi	a0,a0,-1866 # 8001be98 <bcache>
    800025ea:	00004097          	auipc	ra,0x4
    800025ee:	ffc080e7          	jalr	-4(ra) # 800065e6 <acquire>
  b->refcnt--;
    800025f2:	40bc                	lw	a5,64(s1)
    800025f4:	37fd                	addiw	a5,a5,-1
    800025f6:	0007871b          	sext.w	a4,a5
    800025fa:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025fc:	e71d                	bnez	a4,8000262a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025fe:	68b8                	ld	a4,80(s1)
    80002600:	64bc                	ld	a5,72(s1)
    80002602:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002604:	68b8                	ld	a4,80(s1)
    80002606:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002608:	00022797          	auipc	a5,0x22
    8000260c:	89078793          	addi	a5,a5,-1904 # 80023e98 <bcache+0x8000>
    80002610:	2b87b703          	ld	a4,696(a5)
    80002614:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002616:	00022717          	auipc	a4,0x22
    8000261a:	aea70713          	addi	a4,a4,-1302 # 80024100 <bcache+0x8268>
    8000261e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002620:	2b87b703          	ld	a4,696(a5)
    80002624:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002626:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000262a:	0001a517          	auipc	a0,0x1a
    8000262e:	86e50513          	addi	a0,a0,-1938 # 8001be98 <bcache>
    80002632:	00004097          	auipc	ra,0x4
    80002636:	068080e7          	jalr	104(ra) # 8000669a <release>
}
    8000263a:	60e2                	ld	ra,24(sp)
    8000263c:	6442                	ld	s0,16(sp)
    8000263e:	64a2                	ld	s1,8(sp)
    80002640:	6902                	ld	s2,0(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret
    panic("brelse");
    80002646:	00006517          	auipc	a0,0x6
    8000264a:	d3250513          	addi	a0,a0,-718 # 80008378 <etext+0x378>
    8000264e:	00004097          	auipc	ra,0x4
    80002652:	a1e080e7          	jalr	-1506(ra) # 8000606c <panic>

0000000080002656 <bpin>:

void
bpin(struct buf *b) {
    80002656:	1101                	addi	sp,sp,-32
    80002658:	ec06                	sd	ra,24(sp)
    8000265a:	e822                	sd	s0,16(sp)
    8000265c:	e426                	sd	s1,8(sp)
    8000265e:	1000                	addi	s0,sp,32
    80002660:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002662:	0001a517          	auipc	a0,0x1a
    80002666:	83650513          	addi	a0,a0,-1994 # 8001be98 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	f7c080e7          	jalr	-132(ra) # 800065e6 <acquire>
  b->refcnt++;
    80002672:	40bc                	lw	a5,64(s1)
    80002674:	2785                	addiw	a5,a5,1
    80002676:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002678:	0001a517          	auipc	a0,0x1a
    8000267c:	82050513          	addi	a0,a0,-2016 # 8001be98 <bcache>
    80002680:	00004097          	auipc	ra,0x4
    80002684:	01a080e7          	jalr	26(ra) # 8000669a <release>
}
    80002688:	60e2                	ld	ra,24(sp)
    8000268a:	6442                	ld	s0,16(sp)
    8000268c:	64a2                	ld	s1,8(sp)
    8000268e:	6105                	addi	sp,sp,32
    80002690:	8082                	ret

0000000080002692 <bunpin>:

void
bunpin(struct buf *b) {
    80002692:	1101                	addi	sp,sp,-32
    80002694:	ec06                	sd	ra,24(sp)
    80002696:	e822                	sd	s0,16(sp)
    80002698:	e426                	sd	s1,8(sp)
    8000269a:	1000                	addi	s0,sp,32
    8000269c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000269e:	00019517          	auipc	a0,0x19
    800026a2:	7fa50513          	addi	a0,a0,2042 # 8001be98 <bcache>
    800026a6:	00004097          	auipc	ra,0x4
    800026aa:	f40080e7          	jalr	-192(ra) # 800065e6 <acquire>
  b->refcnt--;
    800026ae:	40bc                	lw	a5,64(s1)
    800026b0:	37fd                	addiw	a5,a5,-1
    800026b2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026b4:	00019517          	auipc	a0,0x19
    800026b8:	7e450513          	addi	a0,a0,2020 # 8001be98 <bcache>
    800026bc:	00004097          	auipc	ra,0x4
    800026c0:	fde080e7          	jalr	-34(ra) # 8000669a <release>
}
    800026c4:	60e2                	ld	ra,24(sp)
    800026c6:	6442                	ld	s0,16(sp)
    800026c8:	64a2                	ld	s1,8(sp)
    800026ca:	6105                	addi	sp,sp,32
    800026cc:	8082                	ret

00000000800026ce <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026ce:	1101                	addi	sp,sp,-32
    800026d0:	ec06                	sd	ra,24(sp)
    800026d2:	e822                	sd	s0,16(sp)
    800026d4:	e426                	sd	s1,8(sp)
    800026d6:	e04a                	sd	s2,0(sp)
    800026d8:	1000                	addi	s0,sp,32
    800026da:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026dc:	00d5d59b          	srliw	a1,a1,0xd
    800026e0:	00022797          	auipc	a5,0x22
    800026e4:	e947a783          	lw	a5,-364(a5) # 80024574 <sb+0x1c>
    800026e8:	9dbd                	addw	a1,a1,a5
    800026ea:	00000097          	auipc	ra,0x0
    800026ee:	da0080e7          	jalr	-608(ra) # 8000248a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026f2:	0074f713          	andi	a4,s1,7
    800026f6:	4785                	li	a5,1
    800026f8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026fc:	14ce                	slli	s1,s1,0x33
    800026fe:	90d9                	srli	s1,s1,0x36
    80002700:	00950733          	add	a4,a0,s1
    80002704:	05874703          	lbu	a4,88(a4)
    80002708:	00e7f6b3          	and	a3,a5,a4
    8000270c:	c69d                	beqz	a3,8000273a <bfree+0x6c>
    8000270e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002710:	94aa                	add	s1,s1,a0
    80002712:	fff7c793          	not	a5,a5
    80002716:	8f7d                	and	a4,a4,a5
    80002718:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000271c:	00001097          	auipc	ra,0x1
    80002720:	112080e7          	jalr	274(ra) # 8000382e <log_write>
  brelse(bp);
    80002724:	854a                	mv	a0,s2
    80002726:	00000097          	auipc	ra,0x0
    8000272a:	e94080e7          	jalr	-364(ra) # 800025ba <brelse>
}
    8000272e:	60e2                	ld	ra,24(sp)
    80002730:	6442                	ld	s0,16(sp)
    80002732:	64a2                	ld	s1,8(sp)
    80002734:	6902                	ld	s2,0(sp)
    80002736:	6105                	addi	sp,sp,32
    80002738:	8082                	ret
    panic("freeing free block");
    8000273a:	00006517          	auipc	a0,0x6
    8000273e:	c4650513          	addi	a0,a0,-954 # 80008380 <etext+0x380>
    80002742:	00004097          	auipc	ra,0x4
    80002746:	92a080e7          	jalr	-1750(ra) # 8000606c <panic>

000000008000274a <balloc>:
{
    8000274a:	711d                	addi	sp,sp,-96
    8000274c:	ec86                	sd	ra,88(sp)
    8000274e:	e8a2                	sd	s0,80(sp)
    80002750:	e4a6                	sd	s1,72(sp)
    80002752:	e0ca                	sd	s2,64(sp)
    80002754:	fc4e                	sd	s3,56(sp)
    80002756:	f852                	sd	s4,48(sp)
    80002758:	f456                	sd	s5,40(sp)
    8000275a:	f05a                	sd	s6,32(sp)
    8000275c:	ec5e                	sd	s7,24(sp)
    8000275e:	e862                	sd	s8,16(sp)
    80002760:	e466                	sd	s9,8(sp)
    80002762:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002764:	00022797          	auipc	a5,0x22
    80002768:	df87a783          	lw	a5,-520(a5) # 8002455c <sb+0x4>
    8000276c:	cbc1                	beqz	a5,800027fc <balloc+0xb2>
    8000276e:	8baa                	mv	s7,a0
    80002770:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002772:	00022b17          	auipc	s6,0x22
    80002776:	de6b0b13          	addi	s6,s6,-538 # 80024558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000277a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000277c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000277e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002780:	6c89                	lui	s9,0x2
    80002782:	a831                	j	8000279e <balloc+0x54>
    brelse(bp);
    80002784:	854a                	mv	a0,s2
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	e34080e7          	jalr	-460(ra) # 800025ba <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000278e:	015c87bb          	addw	a5,s9,s5
    80002792:	00078a9b          	sext.w	s5,a5
    80002796:	004b2703          	lw	a4,4(s6)
    8000279a:	06eaf163          	bgeu	s5,a4,800027fc <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000279e:	41fad79b          	sraiw	a5,s5,0x1f
    800027a2:	0137d79b          	srliw	a5,a5,0x13
    800027a6:	015787bb          	addw	a5,a5,s5
    800027aa:	40d7d79b          	sraiw	a5,a5,0xd
    800027ae:	01cb2583          	lw	a1,28(s6)
    800027b2:	9dbd                	addw	a1,a1,a5
    800027b4:	855e                	mv	a0,s7
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	cd4080e7          	jalr	-812(ra) # 8000248a <bread>
    800027be:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c0:	004b2503          	lw	a0,4(s6)
    800027c4:	000a849b          	sext.w	s1,s5
    800027c8:	8762                	mv	a4,s8
    800027ca:	faa4fde3          	bgeu	s1,a0,80002784 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027ce:	00777693          	andi	a3,a4,7
    800027d2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027d6:	41f7579b          	sraiw	a5,a4,0x1f
    800027da:	01d7d79b          	srliw	a5,a5,0x1d
    800027de:	9fb9                	addw	a5,a5,a4
    800027e0:	4037d79b          	sraiw	a5,a5,0x3
    800027e4:	00f90633          	add	a2,s2,a5
    800027e8:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800027ec:	00c6f5b3          	and	a1,a3,a2
    800027f0:	cd91                	beqz	a1,8000280c <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f2:	2705                	addiw	a4,a4,1
    800027f4:	2485                	addiw	s1,s1,1
    800027f6:	fd471ae3          	bne	a4,s4,800027ca <balloc+0x80>
    800027fa:	b769                	j	80002784 <balloc+0x3a>
  panic("balloc: out of blocks");
    800027fc:	00006517          	auipc	a0,0x6
    80002800:	b9c50513          	addi	a0,a0,-1124 # 80008398 <etext+0x398>
    80002804:	00004097          	auipc	ra,0x4
    80002808:	868080e7          	jalr	-1944(ra) # 8000606c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000280c:	97ca                	add	a5,a5,s2
    8000280e:	8e55                	or	a2,a2,a3
    80002810:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002814:	854a                	mv	a0,s2
    80002816:	00001097          	auipc	ra,0x1
    8000281a:	018080e7          	jalr	24(ra) # 8000382e <log_write>
        brelse(bp);
    8000281e:	854a                	mv	a0,s2
    80002820:	00000097          	auipc	ra,0x0
    80002824:	d9a080e7          	jalr	-614(ra) # 800025ba <brelse>
  bp = bread(dev, bno);
    80002828:	85a6                	mv	a1,s1
    8000282a:	855e                	mv	a0,s7
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	c5e080e7          	jalr	-930(ra) # 8000248a <bread>
    80002834:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002836:	40000613          	li	a2,1024
    8000283a:	4581                	li	a1,0
    8000283c:	05850513          	addi	a0,a0,88
    80002840:	ffffe097          	auipc	ra,0xffffe
    80002844:	93a080e7          	jalr	-1734(ra) # 8000017a <memset>
  log_write(bp);
    80002848:	854a                	mv	a0,s2
    8000284a:	00001097          	auipc	ra,0x1
    8000284e:	fe4080e7          	jalr	-28(ra) # 8000382e <log_write>
  brelse(bp);
    80002852:	854a                	mv	a0,s2
    80002854:	00000097          	auipc	ra,0x0
    80002858:	d66080e7          	jalr	-666(ra) # 800025ba <brelse>
}
    8000285c:	8526                	mv	a0,s1
    8000285e:	60e6                	ld	ra,88(sp)
    80002860:	6446                	ld	s0,80(sp)
    80002862:	64a6                	ld	s1,72(sp)
    80002864:	6906                	ld	s2,64(sp)
    80002866:	79e2                	ld	s3,56(sp)
    80002868:	7a42                	ld	s4,48(sp)
    8000286a:	7aa2                	ld	s5,40(sp)
    8000286c:	7b02                	ld	s6,32(sp)
    8000286e:	6be2                	ld	s7,24(sp)
    80002870:	6c42                	ld	s8,16(sp)
    80002872:	6ca2                	ld	s9,8(sp)
    80002874:	6125                	addi	sp,sp,96
    80002876:	8082                	ret

0000000080002878 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002878:	7179                	addi	sp,sp,-48
    8000287a:	f406                	sd	ra,40(sp)
    8000287c:	f022                	sd	s0,32(sp)
    8000287e:	ec26                	sd	s1,24(sp)
    80002880:	e84a                	sd	s2,16(sp)
    80002882:	e44e                	sd	s3,8(sp)
    80002884:	1800                	addi	s0,sp,48
    80002886:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002888:	47ad                	li	a5,11
    8000288a:	04b7ff63          	bgeu	a5,a1,800028e8 <bmap+0x70>
    8000288e:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002890:	ff45849b          	addiw	s1,a1,-12
    80002894:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002898:	0ff00793          	li	a5,255
    8000289c:	0ae7e463          	bltu	a5,a4,80002944 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028a0:	08052583          	lw	a1,128(a0)
    800028a4:	c5b5                	beqz	a1,80002910 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028a6:	00092503          	lw	a0,0(s2)
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	be0080e7          	jalr	-1056(ra) # 8000248a <bread>
    800028b2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028b4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028b8:	02049713          	slli	a4,s1,0x20
    800028bc:	01e75593          	srli	a1,a4,0x1e
    800028c0:	00b784b3          	add	s1,a5,a1
    800028c4:	0004a983          	lw	s3,0(s1)
    800028c8:	04098e63          	beqz	s3,80002924 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028cc:	8552                	mv	a0,s4
    800028ce:	00000097          	auipc	ra,0x0
    800028d2:	cec080e7          	jalr	-788(ra) # 800025ba <brelse>
    return addr;
    800028d6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800028d8:	854e                	mv	a0,s3
    800028da:	70a2                	ld	ra,40(sp)
    800028dc:	7402                	ld	s0,32(sp)
    800028de:	64e2                	ld	s1,24(sp)
    800028e0:	6942                	ld	s2,16(sp)
    800028e2:	69a2                	ld	s3,8(sp)
    800028e4:	6145                	addi	sp,sp,48
    800028e6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028e8:	02059793          	slli	a5,a1,0x20
    800028ec:	01e7d593          	srli	a1,a5,0x1e
    800028f0:	00b504b3          	add	s1,a0,a1
    800028f4:	0504a983          	lw	s3,80(s1)
    800028f8:	fe0990e3          	bnez	s3,800028d8 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028fc:	4108                	lw	a0,0(a0)
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	e4c080e7          	jalr	-436(ra) # 8000274a <balloc>
    80002906:	0005099b          	sext.w	s3,a0
    8000290a:	0534a823          	sw	s3,80(s1)
    8000290e:	b7e9                	j	800028d8 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002910:	4108                	lw	a0,0(a0)
    80002912:	00000097          	auipc	ra,0x0
    80002916:	e38080e7          	jalr	-456(ra) # 8000274a <balloc>
    8000291a:	0005059b          	sext.w	a1,a0
    8000291e:	08b92023          	sw	a1,128(s2)
    80002922:	b751                	j	800028a6 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002924:	00092503          	lw	a0,0(s2)
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	e22080e7          	jalr	-478(ra) # 8000274a <balloc>
    80002930:	0005099b          	sext.w	s3,a0
    80002934:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002938:	8552                	mv	a0,s4
    8000293a:	00001097          	auipc	ra,0x1
    8000293e:	ef4080e7          	jalr	-268(ra) # 8000382e <log_write>
    80002942:	b769                	j	800028cc <bmap+0x54>
  panic("bmap: out of range");
    80002944:	00006517          	auipc	a0,0x6
    80002948:	a6c50513          	addi	a0,a0,-1428 # 800083b0 <etext+0x3b0>
    8000294c:	00003097          	auipc	ra,0x3
    80002950:	720080e7          	jalr	1824(ra) # 8000606c <panic>

0000000080002954 <iget>:
{
    80002954:	7179                	addi	sp,sp,-48
    80002956:	f406                	sd	ra,40(sp)
    80002958:	f022                	sd	s0,32(sp)
    8000295a:	ec26                	sd	s1,24(sp)
    8000295c:	e84a                	sd	s2,16(sp)
    8000295e:	e44e                	sd	s3,8(sp)
    80002960:	e052                	sd	s4,0(sp)
    80002962:	1800                	addi	s0,sp,48
    80002964:	89aa                	mv	s3,a0
    80002966:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002968:	00022517          	auipc	a0,0x22
    8000296c:	c1050513          	addi	a0,a0,-1008 # 80024578 <itable>
    80002970:	00004097          	auipc	ra,0x4
    80002974:	c76080e7          	jalr	-906(ra) # 800065e6 <acquire>
  empty = 0;
    80002978:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000297a:	00022497          	auipc	s1,0x22
    8000297e:	c1648493          	addi	s1,s1,-1002 # 80024590 <itable+0x18>
    80002982:	00023697          	auipc	a3,0x23
    80002986:	69e68693          	addi	a3,a3,1694 # 80026020 <log>
    8000298a:	a039                	j	80002998 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000298c:	02090b63          	beqz	s2,800029c2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002990:	08848493          	addi	s1,s1,136
    80002994:	02d48a63          	beq	s1,a3,800029c8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002998:	449c                	lw	a5,8(s1)
    8000299a:	fef059e3          	blez	a5,8000298c <iget+0x38>
    8000299e:	4098                	lw	a4,0(s1)
    800029a0:	ff3716e3          	bne	a4,s3,8000298c <iget+0x38>
    800029a4:	40d8                	lw	a4,4(s1)
    800029a6:	ff4713e3          	bne	a4,s4,8000298c <iget+0x38>
      ip->ref++;
    800029aa:	2785                	addiw	a5,a5,1
    800029ac:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029ae:	00022517          	auipc	a0,0x22
    800029b2:	bca50513          	addi	a0,a0,-1078 # 80024578 <itable>
    800029b6:	00004097          	auipc	ra,0x4
    800029ba:	ce4080e7          	jalr	-796(ra) # 8000669a <release>
      return ip;
    800029be:	8926                	mv	s2,s1
    800029c0:	a03d                	j	800029ee <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029c2:	f7f9                	bnez	a5,80002990 <iget+0x3c>
      empty = ip;
    800029c4:	8926                	mv	s2,s1
    800029c6:	b7e9                	j	80002990 <iget+0x3c>
  if(empty == 0)
    800029c8:	02090c63          	beqz	s2,80002a00 <iget+0xac>
  ip->dev = dev;
    800029cc:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029d0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029d4:	4785                	li	a5,1
    800029d6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029da:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029de:	00022517          	auipc	a0,0x22
    800029e2:	b9a50513          	addi	a0,a0,-1126 # 80024578 <itable>
    800029e6:	00004097          	auipc	ra,0x4
    800029ea:	cb4080e7          	jalr	-844(ra) # 8000669a <release>
}
    800029ee:	854a                	mv	a0,s2
    800029f0:	70a2                	ld	ra,40(sp)
    800029f2:	7402                	ld	s0,32(sp)
    800029f4:	64e2                	ld	s1,24(sp)
    800029f6:	6942                	ld	s2,16(sp)
    800029f8:	69a2                	ld	s3,8(sp)
    800029fa:	6a02                	ld	s4,0(sp)
    800029fc:	6145                	addi	sp,sp,48
    800029fe:	8082                	ret
    panic("iget: no inodes");
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	9c850513          	addi	a0,a0,-1592 # 800083c8 <etext+0x3c8>
    80002a08:	00003097          	auipc	ra,0x3
    80002a0c:	664080e7          	jalr	1636(ra) # 8000606c <panic>

0000000080002a10 <fsinit>:
fsinit(int dev) {
    80002a10:	7179                	addi	sp,sp,-48
    80002a12:	f406                	sd	ra,40(sp)
    80002a14:	f022                	sd	s0,32(sp)
    80002a16:	ec26                	sd	s1,24(sp)
    80002a18:	e84a                	sd	s2,16(sp)
    80002a1a:	e44e                	sd	s3,8(sp)
    80002a1c:	1800                	addi	s0,sp,48
    80002a1e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a20:	4585                	li	a1,1
    80002a22:	00000097          	auipc	ra,0x0
    80002a26:	a68080e7          	jalr	-1432(ra) # 8000248a <bread>
    80002a2a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a2c:	00022997          	auipc	s3,0x22
    80002a30:	b2c98993          	addi	s3,s3,-1236 # 80024558 <sb>
    80002a34:	02000613          	li	a2,32
    80002a38:	05850593          	addi	a1,a0,88
    80002a3c:	854e                	mv	a0,s3
    80002a3e:	ffffd097          	auipc	ra,0xffffd
    80002a42:	798080e7          	jalr	1944(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a46:	8526                	mv	a0,s1
    80002a48:	00000097          	auipc	ra,0x0
    80002a4c:	b72080e7          	jalr	-1166(ra) # 800025ba <brelse>
  if(sb.magic != FSMAGIC)
    80002a50:	0009a703          	lw	a4,0(s3)
    80002a54:	102037b7          	lui	a5,0x10203
    80002a58:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a5c:	02f71263          	bne	a4,a5,80002a80 <fsinit+0x70>
  initlog(dev, &sb);
    80002a60:	00022597          	auipc	a1,0x22
    80002a64:	af858593          	addi	a1,a1,-1288 # 80024558 <sb>
    80002a68:	854a                	mv	a0,s2
    80002a6a:	00001097          	auipc	ra,0x1
    80002a6e:	b54080e7          	jalr	-1196(ra) # 800035be <initlog>
}
    80002a72:	70a2                	ld	ra,40(sp)
    80002a74:	7402                	ld	s0,32(sp)
    80002a76:	64e2                	ld	s1,24(sp)
    80002a78:	6942                	ld	s2,16(sp)
    80002a7a:	69a2                	ld	s3,8(sp)
    80002a7c:	6145                	addi	sp,sp,48
    80002a7e:	8082                	ret
    panic("invalid file system");
    80002a80:	00006517          	auipc	a0,0x6
    80002a84:	95850513          	addi	a0,a0,-1704 # 800083d8 <etext+0x3d8>
    80002a88:	00003097          	auipc	ra,0x3
    80002a8c:	5e4080e7          	jalr	1508(ra) # 8000606c <panic>

0000000080002a90 <iinit>:
{
    80002a90:	7179                	addi	sp,sp,-48
    80002a92:	f406                	sd	ra,40(sp)
    80002a94:	f022                	sd	s0,32(sp)
    80002a96:	ec26                	sd	s1,24(sp)
    80002a98:	e84a                	sd	s2,16(sp)
    80002a9a:	e44e                	sd	s3,8(sp)
    80002a9c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a9e:	00006597          	auipc	a1,0x6
    80002aa2:	95258593          	addi	a1,a1,-1710 # 800083f0 <etext+0x3f0>
    80002aa6:	00022517          	auipc	a0,0x22
    80002aaa:	ad250513          	addi	a0,a0,-1326 # 80024578 <itable>
    80002aae:	00004097          	auipc	ra,0x4
    80002ab2:	aa8080e7          	jalr	-1368(ra) # 80006556 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ab6:	00022497          	auipc	s1,0x22
    80002aba:	aea48493          	addi	s1,s1,-1302 # 800245a0 <itable+0x28>
    80002abe:	00023997          	auipc	s3,0x23
    80002ac2:	57298993          	addi	s3,s3,1394 # 80026030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ac6:	00006917          	auipc	s2,0x6
    80002aca:	93290913          	addi	s2,s2,-1742 # 800083f8 <etext+0x3f8>
    80002ace:	85ca                	mv	a1,s2
    80002ad0:	8526                	mv	a0,s1
    80002ad2:	00001097          	auipc	ra,0x1
    80002ad6:	e40080e7          	jalr	-448(ra) # 80003912 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ada:	08848493          	addi	s1,s1,136
    80002ade:	ff3498e3          	bne	s1,s3,80002ace <iinit+0x3e>
}
    80002ae2:	70a2                	ld	ra,40(sp)
    80002ae4:	7402                	ld	s0,32(sp)
    80002ae6:	64e2                	ld	s1,24(sp)
    80002ae8:	6942                	ld	s2,16(sp)
    80002aea:	69a2                	ld	s3,8(sp)
    80002aec:	6145                	addi	sp,sp,48
    80002aee:	8082                	ret

0000000080002af0 <ialloc>:
{
    80002af0:	7139                	addi	sp,sp,-64
    80002af2:	fc06                	sd	ra,56(sp)
    80002af4:	f822                	sd	s0,48(sp)
    80002af6:	f426                	sd	s1,40(sp)
    80002af8:	f04a                	sd	s2,32(sp)
    80002afa:	ec4e                	sd	s3,24(sp)
    80002afc:	e852                	sd	s4,16(sp)
    80002afe:	e456                	sd	s5,8(sp)
    80002b00:	e05a                	sd	s6,0(sp)
    80002b02:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b04:	00022717          	auipc	a4,0x22
    80002b08:	a6072703          	lw	a4,-1440(a4) # 80024564 <sb+0xc>
    80002b0c:	4785                	li	a5,1
    80002b0e:	04e7f863          	bgeu	a5,a4,80002b5e <ialloc+0x6e>
    80002b12:	8aaa                	mv	s5,a0
    80002b14:	8b2e                	mv	s6,a1
    80002b16:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b18:	00022a17          	auipc	s4,0x22
    80002b1c:	a40a0a13          	addi	s4,s4,-1472 # 80024558 <sb>
    80002b20:	00495593          	srli	a1,s2,0x4
    80002b24:	018a2783          	lw	a5,24(s4)
    80002b28:	9dbd                	addw	a1,a1,a5
    80002b2a:	8556                	mv	a0,s5
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	95e080e7          	jalr	-1698(ra) # 8000248a <bread>
    80002b34:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b36:	05850993          	addi	s3,a0,88
    80002b3a:	00f97793          	andi	a5,s2,15
    80002b3e:	079a                	slli	a5,a5,0x6
    80002b40:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b42:	00099783          	lh	a5,0(s3)
    80002b46:	c785                	beqz	a5,80002b6e <ialloc+0x7e>
    brelse(bp);
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	a72080e7          	jalr	-1422(ra) # 800025ba <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b50:	0905                	addi	s2,s2,1
    80002b52:	00ca2703          	lw	a4,12(s4)
    80002b56:	0009079b          	sext.w	a5,s2
    80002b5a:	fce7e3e3          	bltu	a5,a4,80002b20 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002b5e:	00006517          	auipc	a0,0x6
    80002b62:	8a250513          	addi	a0,a0,-1886 # 80008400 <etext+0x400>
    80002b66:	00003097          	auipc	ra,0x3
    80002b6a:	506080e7          	jalr	1286(ra) # 8000606c <panic>
      memset(dip, 0, sizeof(*dip));
    80002b6e:	04000613          	li	a2,64
    80002b72:	4581                	li	a1,0
    80002b74:	854e                	mv	a0,s3
    80002b76:	ffffd097          	auipc	ra,0xffffd
    80002b7a:	604080e7          	jalr	1540(ra) # 8000017a <memset>
      dip->type = type;
    80002b7e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b82:	8526                	mv	a0,s1
    80002b84:	00001097          	auipc	ra,0x1
    80002b88:	caa080e7          	jalr	-854(ra) # 8000382e <log_write>
      brelse(bp);
    80002b8c:	8526                	mv	a0,s1
    80002b8e:	00000097          	auipc	ra,0x0
    80002b92:	a2c080e7          	jalr	-1492(ra) # 800025ba <brelse>
      return iget(dev, inum);
    80002b96:	0009059b          	sext.w	a1,s2
    80002b9a:	8556                	mv	a0,s5
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	db8080e7          	jalr	-584(ra) # 80002954 <iget>
}
    80002ba4:	70e2                	ld	ra,56(sp)
    80002ba6:	7442                	ld	s0,48(sp)
    80002ba8:	74a2                	ld	s1,40(sp)
    80002baa:	7902                	ld	s2,32(sp)
    80002bac:	69e2                	ld	s3,24(sp)
    80002bae:	6a42                	ld	s4,16(sp)
    80002bb0:	6aa2                	ld	s5,8(sp)
    80002bb2:	6b02                	ld	s6,0(sp)
    80002bb4:	6121                	addi	sp,sp,64
    80002bb6:	8082                	ret

0000000080002bb8 <iupdate>:
{
    80002bb8:	1101                	addi	sp,sp,-32
    80002bba:	ec06                	sd	ra,24(sp)
    80002bbc:	e822                	sd	s0,16(sp)
    80002bbe:	e426                	sd	s1,8(sp)
    80002bc0:	e04a                	sd	s2,0(sp)
    80002bc2:	1000                	addi	s0,sp,32
    80002bc4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc6:	415c                	lw	a5,4(a0)
    80002bc8:	0047d79b          	srliw	a5,a5,0x4
    80002bcc:	00022597          	auipc	a1,0x22
    80002bd0:	9a45a583          	lw	a1,-1628(a1) # 80024570 <sb+0x18>
    80002bd4:	9dbd                	addw	a1,a1,a5
    80002bd6:	4108                	lw	a0,0(a0)
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	8b2080e7          	jalr	-1870(ra) # 8000248a <bread>
    80002be0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002be2:	05850793          	addi	a5,a0,88
    80002be6:	40d8                	lw	a4,4(s1)
    80002be8:	8b3d                	andi	a4,a4,15
    80002bea:	071a                	slli	a4,a4,0x6
    80002bec:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bee:	04449703          	lh	a4,68(s1)
    80002bf2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bf6:	04649703          	lh	a4,70(s1)
    80002bfa:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bfe:	04849703          	lh	a4,72(s1)
    80002c02:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c06:	04a49703          	lh	a4,74(s1)
    80002c0a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c0e:	44f8                	lw	a4,76(s1)
    80002c10:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c12:	03400613          	li	a2,52
    80002c16:	05048593          	addi	a1,s1,80
    80002c1a:	00c78513          	addi	a0,a5,12
    80002c1e:	ffffd097          	auipc	ra,0xffffd
    80002c22:	5b8080e7          	jalr	1464(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c26:	854a                	mv	a0,s2
    80002c28:	00001097          	auipc	ra,0x1
    80002c2c:	c06080e7          	jalr	-1018(ra) # 8000382e <log_write>
  brelse(bp);
    80002c30:	854a                	mv	a0,s2
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	988080e7          	jalr	-1656(ra) # 800025ba <brelse>
}
    80002c3a:	60e2                	ld	ra,24(sp)
    80002c3c:	6442                	ld	s0,16(sp)
    80002c3e:	64a2                	ld	s1,8(sp)
    80002c40:	6902                	ld	s2,0(sp)
    80002c42:	6105                	addi	sp,sp,32
    80002c44:	8082                	ret

0000000080002c46 <idup>:
{
    80002c46:	1101                	addi	sp,sp,-32
    80002c48:	ec06                	sd	ra,24(sp)
    80002c4a:	e822                	sd	s0,16(sp)
    80002c4c:	e426                	sd	s1,8(sp)
    80002c4e:	1000                	addi	s0,sp,32
    80002c50:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c52:	00022517          	auipc	a0,0x22
    80002c56:	92650513          	addi	a0,a0,-1754 # 80024578 <itable>
    80002c5a:	00004097          	auipc	ra,0x4
    80002c5e:	98c080e7          	jalr	-1652(ra) # 800065e6 <acquire>
  ip->ref++;
    80002c62:	449c                	lw	a5,8(s1)
    80002c64:	2785                	addiw	a5,a5,1
    80002c66:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c68:	00022517          	auipc	a0,0x22
    80002c6c:	91050513          	addi	a0,a0,-1776 # 80024578 <itable>
    80002c70:	00004097          	auipc	ra,0x4
    80002c74:	a2a080e7          	jalr	-1494(ra) # 8000669a <release>
}
    80002c78:	8526                	mv	a0,s1
    80002c7a:	60e2                	ld	ra,24(sp)
    80002c7c:	6442                	ld	s0,16(sp)
    80002c7e:	64a2                	ld	s1,8(sp)
    80002c80:	6105                	addi	sp,sp,32
    80002c82:	8082                	ret

0000000080002c84 <ilock>:
{
    80002c84:	1101                	addi	sp,sp,-32
    80002c86:	ec06                	sd	ra,24(sp)
    80002c88:	e822                	sd	s0,16(sp)
    80002c8a:	e426                	sd	s1,8(sp)
    80002c8c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c8e:	c10d                	beqz	a0,80002cb0 <ilock+0x2c>
    80002c90:	84aa                	mv	s1,a0
    80002c92:	451c                	lw	a5,8(a0)
    80002c94:	00f05e63          	blez	a5,80002cb0 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c98:	0541                	addi	a0,a0,16
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	cb2080e7          	jalr	-846(ra) # 8000394c <acquiresleep>
  if(ip->valid == 0){
    80002ca2:	40bc                	lw	a5,64(s1)
    80002ca4:	cf99                	beqz	a5,80002cc2 <ilock+0x3e>
}
    80002ca6:	60e2                	ld	ra,24(sp)
    80002ca8:	6442                	ld	s0,16(sp)
    80002caa:	64a2                	ld	s1,8(sp)
    80002cac:	6105                	addi	sp,sp,32
    80002cae:	8082                	ret
    80002cb0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002cb2:	00005517          	auipc	a0,0x5
    80002cb6:	76650513          	addi	a0,a0,1894 # 80008418 <etext+0x418>
    80002cba:	00003097          	auipc	ra,0x3
    80002cbe:	3b2080e7          	jalr	946(ra) # 8000606c <panic>
    80002cc2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cc4:	40dc                	lw	a5,4(s1)
    80002cc6:	0047d79b          	srliw	a5,a5,0x4
    80002cca:	00022597          	auipc	a1,0x22
    80002cce:	8a65a583          	lw	a1,-1882(a1) # 80024570 <sb+0x18>
    80002cd2:	9dbd                	addw	a1,a1,a5
    80002cd4:	4088                	lw	a0,0(s1)
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	7b4080e7          	jalr	1972(ra) # 8000248a <bread>
    80002cde:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ce0:	05850593          	addi	a1,a0,88
    80002ce4:	40dc                	lw	a5,4(s1)
    80002ce6:	8bbd                	andi	a5,a5,15
    80002ce8:	079a                	slli	a5,a5,0x6
    80002cea:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cec:	00059783          	lh	a5,0(a1)
    80002cf0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cf4:	00259783          	lh	a5,2(a1)
    80002cf8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cfc:	00459783          	lh	a5,4(a1)
    80002d00:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d04:	00659783          	lh	a5,6(a1)
    80002d08:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d0c:	459c                	lw	a5,8(a1)
    80002d0e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d10:	03400613          	li	a2,52
    80002d14:	05b1                	addi	a1,a1,12
    80002d16:	05048513          	addi	a0,s1,80
    80002d1a:	ffffd097          	auipc	ra,0xffffd
    80002d1e:	4bc080e7          	jalr	1212(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d22:	854a                	mv	a0,s2
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	896080e7          	jalr	-1898(ra) # 800025ba <brelse>
    ip->valid = 1;
    80002d2c:	4785                	li	a5,1
    80002d2e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d30:	04449783          	lh	a5,68(s1)
    80002d34:	c399                	beqz	a5,80002d3a <ilock+0xb6>
    80002d36:	6902                	ld	s2,0(sp)
    80002d38:	b7bd                	j	80002ca6 <ilock+0x22>
      panic("ilock: no type");
    80002d3a:	00005517          	auipc	a0,0x5
    80002d3e:	6e650513          	addi	a0,a0,1766 # 80008420 <etext+0x420>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	32a080e7          	jalr	810(ra) # 8000606c <panic>

0000000080002d4a <iunlock>:
{
    80002d4a:	1101                	addi	sp,sp,-32
    80002d4c:	ec06                	sd	ra,24(sp)
    80002d4e:	e822                	sd	s0,16(sp)
    80002d50:	e426                	sd	s1,8(sp)
    80002d52:	e04a                	sd	s2,0(sp)
    80002d54:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d56:	c905                	beqz	a0,80002d86 <iunlock+0x3c>
    80002d58:	84aa                	mv	s1,a0
    80002d5a:	01050913          	addi	s2,a0,16
    80002d5e:	854a                	mv	a0,s2
    80002d60:	00001097          	auipc	ra,0x1
    80002d64:	c86080e7          	jalr	-890(ra) # 800039e6 <holdingsleep>
    80002d68:	cd19                	beqz	a0,80002d86 <iunlock+0x3c>
    80002d6a:	449c                	lw	a5,8(s1)
    80002d6c:	00f05d63          	blez	a5,80002d86 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d70:	854a                	mv	a0,s2
    80002d72:	00001097          	auipc	ra,0x1
    80002d76:	c30080e7          	jalr	-976(ra) # 800039a2 <releasesleep>
}
    80002d7a:	60e2                	ld	ra,24(sp)
    80002d7c:	6442                	ld	s0,16(sp)
    80002d7e:	64a2                	ld	s1,8(sp)
    80002d80:	6902                	ld	s2,0(sp)
    80002d82:	6105                	addi	sp,sp,32
    80002d84:	8082                	ret
    panic("iunlock");
    80002d86:	00005517          	auipc	a0,0x5
    80002d8a:	6aa50513          	addi	a0,a0,1706 # 80008430 <etext+0x430>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	2de080e7          	jalr	734(ra) # 8000606c <panic>

0000000080002d96 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d96:	7179                	addi	sp,sp,-48
    80002d98:	f406                	sd	ra,40(sp)
    80002d9a:	f022                	sd	s0,32(sp)
    80002d9c:	ec26                	sd	s1,24(sp)
    80002d9e:	e84a                	sd	s2,16(sp)
    80002da0:	e44e                	sd	s3,8(sp)
    80002da2:	1800                	addi	s0,sp,48
    80002da4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002da6:	05050493          	addi	s1,a0,80
    80002daa:	08050913          	addi	s2,a0,128
    80002dae:	a021                	j	80002db6 <itrunc+0x20>
    80002db0:	0491                	addi	s1,s1,4
    80002db2:	01248d63          	beq	s1,s2,80002dcc <itrunc+0x36>
    if(ip->addrs[i]){
    80002db6:	408c                	lw	a1,0(s1)
    80002db8:	dde5                	beqz	a1,80002db0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002dba:	0009a503          	lw	a0,0(s3)
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	910080e7          	jalr	-1776(ra) # 800026ce <bfree>
      ip->addrs[i] = 0;
    80002dc6:	0004a023          	sw	zero,0(s1)
    80002dca:	b7dd                	j	80002db0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dcc:	0809a583          	lw	a1,128(s3)
    80002dd0:	ed99                	bnez	a1,80002dee <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dd2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dd6:	854e                	mv	a0,s3
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	de0080e7          	jalr	-544(ra) # 80002bb8 <iupdate>
}
    80002de0:	70a2                	ld	ra,40(sp)
    80002de2:	7402                	ld	s0,32(sp)
    80002de4:	64e2                	ld	s1,24(sp)
    80002de6:	6942                	ld	s2,16(sp)
    80002de8:	69a2                	ld	s3,8(sp)
    80002dea:	6145                	addi	sp,sp,48
    80002dec:	8082                	ret
    80002dee:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002df0:	0009a503          	lw	a0,0(s3)
    80002df4:	fffff097          	auipc	ra,0xfffff
    80002df8:	696080e7          	jalr	1686(ra) # 8000248a <bread>
    80002dfc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dfe:	05850493          	addi	s1,a0,88
    80002e02:	45850913          	addi	s2,a0,1112
    80002e06:	a021                	j	80002e0e <itrunc+0x78>
    80002e08:	0491                	addi	s1,s1,4
    80002e0a:	01248b63          	beq	s1,s2,80002e20 <itrunc+0x8a>
      if(a[j])
    80002e0e:	408c                	lw	a1,0(s1)
    80002e10:	dde5                	beqz	a1,80002e08 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e12:	0009a503          	lw	a0,0(s3)
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	8b8080e7          	jalr	-1864(ra) # 800026ce <bfree>
    80002e1e:	b7ed                	j	80002e08 <itrunc+0x72>
    brelse(bp);
    80002e20:	8552                	mv	a0,s4
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	798080e7          	jalr	1944(ra) # 800025ba <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e2a:	0809a583          	lw	a1,128(s3)
    80002e2e:	0009a503          	lw	a0,0(s3)
    80002e32:	00000097          	auipc	ra,0x0
    80002e36:	89c080e7          	jalr	-1892(ra) # 800026ce <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e3a:	0809a023          	sw	zero,128(s3)
    80002e3e:	6a02                	ld	s4,0(sp)
    80002e40:	bf49                	j	80002dd2 <itrunc+0x3c>

0000000080002e42 <iput>:
{
    80002e42:	1101                	addi	sp,sp,-32
    80002e44:	ec06                	sd	ra,24(sp)
    80002e46:	e822                	sd	s0,16(sp)
    80002e48:	e426                	sd	s1,8(sp)
    80002e4a:	1000                	addi	s0,sp,32
    80002e4c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e4e:	00021517          	auipc	a0,0x21
    80002e52:	72a50513          	addi	a0,a0,1834 # 80024578 <itable>
    80002e56:	00003097          	auipc	ra,0x3
    80002e5a:	790080e7          	jalr	1936(ra) # 800065e6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e5e:	4498                	lw	a4,8(s1)
    80002e60:	4785                	li	a5,1
    80002e62:	02f70263          	beq	a4,a5,80002e86 <iput+0x44>
  ip->ref--;
    80002e66:	449c                	lw	a5,8(s1)
    80002e68:	37fd                	addiw	a5,a5,-1
    80002e6a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e6c:	00021517          	auipc	a0,0x21
    80002e70:	70c50513          	addi	a0,a0,1804 # 80024578 <itable>
    80002e74:	00004097          	auipc	ra,0x4
    80002e78:	826080e7          	jalr	-2010(ra) # 8000669a <release>
}
    80002e7c:	60e2                	ld	ra,24(sp)
    80002e7e:	6442                	ld	s0,16(sp)
    80002e80:	64a2                	ld	s1,8(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e86:	40bc                	lw	a5,64(s1)
    80002e88:	dff9                	beqz	a5,80002e66 <iput+0x24>
    80002e8a:	04a49783          	lh	a5,74(s1)
    80002e8e:	ffe1                	bnez	a5,80002e66 <iput+0x24>
    80002e90:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e92:	01048913          	addi	s2,s1,16
    80002e96:	854a                	mv	a0,s2
    80002e98:	00001097          	auipc	ra,0x1
    80002e9c:	ab4080e7          	jalr	-1356(ra) # 8000394c <acquiresleep>
    release(&itable.lock);
    80002ea0:	00021517          	auipc	a0,0x21
    80002ea4:	6d850513          	addi	a0,a0,1752 # 80024578 <itable>
    80002ea8:	00003097          	auipc	ra,0x3
    80002eac:	7f2080e7          	jalr	2034(ra) # 8000669a <release>
    itrunc(ip);
    80002eb0:	8526                	mv	a0,s1
    80002eb2:	00000097          	auipc	ra,0x0
    80002eb6:	ee4080e7          	jalr	-284(ra) # 80002d96 <itrunc>
    ip->type = 0;
    80002eba:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ebe:	8526                	mv	a0,s1
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	cf8080e7          	jalr	-776(ra) # 80002bb8 <iupdate>
    ip->valid = 0;
    80002ec8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ecc:	854a                	mv	a0,s2
    80002ece:	00001097          	auipc	ra,0x1
    80002ed2:	ad4080e7          	jalr	-1324(ra) # 800039a2 <releasesleep>
    acquire(&itable.lock);
    80002ed6:	00021517          	auipc	a0,0x21
    80002eda:	6a250513          	addi	a0,a0,1698 # 80024578 <itable>
    80002ede:	00003097          	auipc	ra,0x3
    80002ee2:	708080e7          	jalr	1800(ra) # 800065e6 <acquire>
    80002ee6:	6902                	ld	s2,0(sp)
    80002ee8:	bfbd                	j	80002e66 <iput+0x24>

0000000080002eea <iunlockput>:
{
    80002eea:	1101                	addi	sp,sp,-32
    80002eec:	ec06                	sd	ra,24(sp)
    80002eee:	e822                	sd	s0,16(sp)
    80002ef0:	e426                	sd	s1,8(sp)
    80002ef2:	1000                	addi	s0,sp,32
    80002ef4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	e54080e7          	jalr	-428(ra) # 80002d4a <iunlock>
  iput(ip);
    80002efe:	8526                	mv	a0,s1
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	f42080e7          	jalr	-190(ra) # 80002e42 <iput>
}
    80002f08:	60e2                	ld	ra,24(sp)
    80002f0a:	6442                	ld	s0,16(sp)
    80002f0c:	64a2                	ld	s1,8(sp)
    80002f0e:	6105                	addi	sp,sp,32
    80002f10:	8082                	ret

0000000080002f12 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f12:	1141                	addi	sp,sp,-16
    80002f14:	e422                	sd	s0,8(sp)
    80002f16:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f18:	411c                	lw	a5,0(a0)
    80002f1a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f1c:	415c                	lw	a5,4(a0)
    80002f1e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f20:	04451783          	lh	a5,68(a0)
    80002f24:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f28:	04a51783          	lh	a5,74(a0)
    80002f2c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f30:	04c56783          	lwu	a5,76(a0)
    80002f34:	e99c                	sd	a5,16(a1)
}
    80002f36:	6422                	ld	s0,8(sp)
    80002f38:	0141                	addi	sp,sp,16
    80002f3a:	8082                	ret

0000000080002f3c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f3c:	457c                	lw	a5,76(a0)
    80002f3e:	0ed7ef63          	bltu	a5,a3,8000303c <readi+0x100>
{
    80002f42:	7159                	addi	sp,sp,-112
    80002f44:	f486                	sd	ra,104(sp)
    80002f46:	f0a2                	sd	s0,96(sp)
    80002f48:	eca6                	sd	s1,88(sp)
    80002f4a:	fc56                	sd	s5,56(sp)
    80002f4c:	f85a                	sd	s6,48(sp)
    80002f4e:	f45e                	sd	s7,40(sp)
    80002f50:	f062                	sd	s8,32(sp)
    80002f52:	1880                	addi	s0,sp,112
    80002f54:	8baa                	mv	s7,a0
    80002f56:	8c2e                	mv	s8,a1
    80002f58:	8ab2                	mv	s5,a2
    80002f5a:	84b6                	mv	s1,a3
    80002f5c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f5e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f60:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f62:	0ad76c63          	bltu	a4,a3,8000301a <readi+0xde>
    80002f66:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f68:	00e7f463          	bgeu	a5,a4,80002f70 <readi+0x34>
    n = ip->size - off;
    80002f6c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f70:	0c0b0463          	beqz	s6,80003038 <readi+0xfc>
    80002f74:	e8ca                	sd	s2,80(sp)
    80002f76:	e0d2                	sd	s4,64(sp)
    80002f78:	ec66                	sd	s9,24(sp)
    80002f7a:	e86a                	sd	s10,16(sp)
    80002f7c:	e46e                	sd	s11,8(sp)
    80002f7e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f80:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f84:	5cfd                	li	s9,-1
    80002f86:	a82d                	j	80002fc0 <readi+0x84>
    80002f88:	020a1d93          	slli	s11,s4,0x20
    80002f8c:	020ddd93          	srli	s11,s11,0x20
    80002f90:	05890613          	addi	a2,s2,88
    80002f94:	86ee                	mv	a3,s11
    80002f96:	963a                	add	a2,a2,a4
    80002f98:	85d6                	mv	a1,s5
    80002f9a:	8562                	mv	a0,s8
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	9ca080e7          	jalr	-1590(ra) # 80001966 <either_copyout>
    80002fa4:	05950d63          	beq	a0,s9,80002ffe <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fa8:	854a                	mv	a0,s2
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	610080e7          	jalr	1552(ra) # 800025ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fb2:	013a09bb          	addw	s3,s4,s3
    80002fb6:	009a04bb          	addw	s1,s4,s1
    80002fba:	9aee                	add	s5,s5,s11
    80002fbc:	0769f863          	bgeu	s3,s6,8000302c <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fc0:	000ba903          	lw	s2,0(s7)
    80002fc4:	00a4d59b          	srliw	a1,s1,0xa
    80002fc8:	855e                	mv	a0,s7
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	8ae080e7          	jalr	-1874(ra) # 80002878 <bmap>
    80002fd2:	0005059b          	sext.w	a1,a0
    80002fd6:	854a                	mv	a0,s2
    80002fd8:	fffff097          	auipc	ra,0xfffff
    80002fdc:	4b2080e7          	jalr	1202(ra) # 8000248a <bread>
    80002fe0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe2:	3ff4f713          	andi	a4,s1,1023
    80002fe6:	40ed07bb          	subw	a5,s10,a4
    80002fea:	413b06bb          	subw	a3,s6,s3
    80002fee:	8a3e                	mv	s4,a5
    80002ff0:	2781                	sext.w	a5,a5
    80002ff2:	0006861b          	sext.w	a2,a3
    80002ff6:	f8f679e3          	bgeu	a2,a5,80002f88 <readi+0x4c>
    80002ffa:	8a36                	mv	s4,a3
    80002ffc:	b771                	j	80002f88 <readi+0x4c>
      brelse(bp);
    80002ffe:	854a                	mv	a0,s2
    80003000:	fffff097          	auipc	ra,0xfffff
    80003004:	5ba080e7          	jalr	1466(ra) # 800025ba <brelse>
      tot = -1;
    80003008:	59fd                	li	s3,-1
      break;
    8000300a:	6946                	ld	s2,80(sp)
    8000300c:	6a06                	ld	s4,64(sp)
    8000300e:	6ce2                	ld	s9,24(sp)
    80003010:	6d42                	ld	s10,16(sp)
    80003012:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003014:	0009851b          	sext.w	a0,s3
    80003018:	69a6                	ld	s3,72(sp)
}
    8000301a:	70a6                	ld	ra,104(sp)
    8000301c:	7406                	ld	s0,96(sp)
    8000301e:	64e6                	ld	s1,88(sp)
    80003020:	7ae2                	ld	s5,56(sp)
    80003022:	7b42                	ld	s6,48(sp)
    80003024:	7ba2                	ld	s7,40(sp)
    80003026:	7c02                	ld	s8,32(sp)
    80003028:	6165                	addi	sp,sp,112
    8000302a:	8082                	ret
    8000302c:	6946                	ld	s2,80(sp)
    8000302e:	6a06                	ld	s4,64(sp)
    80003030:	6ce2                	ld	s9,24(sp)
    80003032:	6d42                	ld	s10,16(sp)
    80003034:	6da2                	ld	s11,8(sp)
    80003036:	bff9                	j	80003014 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003038:	89da                	mv	s3,s6
    8000303a:	bfe9                	j	80003014 <readi+0xd8>
    return 0;
    8000303c:	4501                	li	a0,0
}
    8000303e:	8082                	ret

0000000080003040 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003040:	457c                	lw	a5,76(a0)
    80003042:	10d7ee63          	bltu	a5,a3,8000315e <writei+0x11e>
{
    80003046:	7159                	addi	sp,sp,-112
    80003048:	f486                	sd	ra,104(sp)
    8000304a:	f0a2                	sd	s0,96(sp)
    8000304c:	e8ca                	sd	s2,80(sp)
    8000304e:	fc56                	sd	s5,56(sp)
    80003050:	f85a                	sd	s6,48(sp)
    80003052:	f45e                	sd	s7,40(sp)
    80003054:	f062                	sd	s8,32(sp)
    80003056:	1880                	addi	s0,sp,112
    80003058:	8b2a                	mv	s6,a0
    8000305a:	8c2e                	mv	s8,a1
    8000305c:	8ab2                	mv	s5,a2
    8000305e:	8936                	mv	s2,a3
    80003060:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003062:	00e687bb          	addw	a5,a3,a4
    80003066:	0ed7ee63          	bltu	a5,a3,80003162 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000306a:	00043737          	lui	a4,0x43
    8000306e:	0ef76c63          	bltu	a4,a5,80003166 <writei+0x126>
    80003072:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003074:	0c0b8d63          	beqz	s7,8000314e <writei+0x10e>
    80003078:	eca6                	sd	s1,88(sp)
    8000307a:	e4ce                	sd	s3,72(sp)
    8000307c:	ec66                	sd	s9,24(sp)
    8000307e:	e86a                	sd	s10,16(sp)
    80003080:	e46e                	sd	s11,8(sp)
    80003082:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003084:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003088:	5cfd                	li	s9,-1
    8000308a:	a091                	j	800030ce <writei+0x8e>
    8000308c:	02099d93          	slli	s11,s3,0x20
    80003090:	020ddd93          	srli	s11,s11,0x20
    80003094:	05848513          	addi	a0,s1,88
    80003098:	86ee                	mv	a3,s11
    8000309a:	8656                	mv	a2,s5
    8000309c:	85e2                	mv	a1,s8
    8000309e:	953a                	add	a0,a0,a4
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	91c080e7          	jalr	-1764(ra) # 800019bc <either_copyin>
    800030a8:	07950263          	beq	a0,s9,8000310c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ac:	8526                	mv	a0,s1
    800030ae:	00000097          	auipc	ra,0x0
    800030b2:	780080e7          	jalr	1920(ra) # 8000382e <log_write>
    brelse(bp);
    800030b6:	8526                	mv	a0,s1
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	502080e7          	jalr	1282(ra) # 800025ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c0:	01498a3b          	addw	s4,s3,s4
    800030c4:	0129893b          	addw	s2,s3,s2
    800030c8:	9aee                	add	s5,s5,s11
    800030ca:	057a7663          	bgeu	s4,s7,80003116 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030ce:	000b2483          	lw	s1,0(s6)
    800030d2:	00a9559b          	srliw	a1,s2,0xa
    800030d6:	855a                	mv	a0,s6
    800030d8:	fffff097          	auipc	ra,0xfffff
    800030dc:	7a0080e7          	jalr	1952(ra) # 80002878 <bmap>
    800030e0:	0005059b          	sext.w	a1,a0
    800030e4:	8526                	mv	a0,s1
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	3a4080e7          	jalr	932(ra) # 8000248a <bread>
    800030ee:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030f0:	3ff97713          	andi	a4,s2,1023
    800030f4:	40ed07bb          	subw	a5,s10,a4
    800030f8:	414b86bb          	subw	a3,s7,s4
    800030fc:	89be                	mv	s3,a5
    800030fe:	2781                	sext.w	a5,a5
    80003100:	0006861b          	sext.w	a2,a3
    80003104:	f8f674e3          	bgeu	a2,a5,8000308c <writei+0x4c>
    80003108:	89b6                	mv	s3,a3
    8000310a:	b749                	j	8000308c <writei+0x4c>
      brelse(bp);
    8000310c:	8526                	mv	a0,s1
    8000310e:	fffff097          	auipc	ra,0xfffff
    80003112:	4ac080e7          	jalr	1196(ra) # 800025ba <brelse>
  }

  if(off > ip->size)
    80003116:	04cb2783          	lw	a5,76(s6)
    8000311a:	0327fc63          	bgeu	a5,s2,80003152 <writei+0x112>
    ip->size = off;
    8000311e:	052b2623          	sw	s2,76(s6)
    80003122:	64e6                	ld	s1,88(sp)
    80003124:	69a6                	ld	s3,72(sp)
    80003126:	6ce2                	ld	s9,24(sp)
    80003128:	6d42                	ld	s10,16(sp)
    8000312a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000312c:	855a                	mv	a0,s6
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	a8a080e7          	jalr	-1398(ra) # 80002bb8 <iupdate>

  return tot;
    80003136:	000a051b          	sext.w	a0,s4
    8000313a:	6a06                	ld	s4,64(sp)
}
    8000313c:	70a6                	ld	ra,104(sp)
    8000313e:	7406                	ld	s0,96(sp)
    80003140:	6946                	ld	s2,80(sp)
    80003142:	7ae2                	ld	s5,56(sp)
    80003144:	7b42                	ld	s6,48(sp)
    80003146:	7ba2                	ld	s7,40(sp)
    80003148:	7c02                	ld	s8,32(sp)
    8000314a:	6165                	addi	sp,sp,112
    8000314c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000314e:	8a5e                	mv	s4,s7
    80003150:	bff1                	j	8000312c <writei+0xec>
    80003152:	64e6                	ld	s1,88(sp)
    80003154:	69a6                	ld	s3,72(sp)
    80003156:	6ce2                	ld	s9,24(sp)
    80003158:	6d42                	ld	s10,16(sp)
    8000315a:	6da2                	ld	s11,8(sp)
    8000315c:	bfc1                	j	8000312c <writei+0xec>
    return -1;
    8000315e:	557d                	li	a0,-1
}
    80003160:	8082                	ret
    return -1;
    80003162:	557d                	li	a0,-1
    80003164:	bfe1                	j	8000313c <writei+0xfc>
    return -1;
    80003166:	557d                	li	a0,-1
    80003168:	bfd1                	j	8000313c <writei+0xfc>

000000008000316a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000316a:	1141                	addi	sp,sp,-16
    8000316c:	e406                	sd	ra,8(sp)
    8000316e:	e022                	sd	s0,0(sp)
    80003170:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003172:	4639                	li	a2,14
    80003174:	ffffd097          	auipc	ra,0xffffd
    80003178:	0d6080e7          	jalr	214(ra) # 8000024a <strncmp>
}
    8000317c:	60a2                	ld	ra,8(sp)
    8000317e:	6402                	ld	s0,0(sp)
    80003180:	0141                	addi	sp,sp,16
    80003182:	8082                	ret

0000000080003184 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003184:	7139                	addi	sp,sp,-64
    80003186:	fc06                	sd	ra,56(sp)
    80003188:	f822                	sd	s0,48(sp)
    8000318a:	f426                	sd	s1,40(sp)
    8000318c:	f04a                	sd	s2,32(sp)
    8000318e:	ec4e                	sd	s3,24(sp)
    80003190:	e852                	sd	s4,16(sp)
    80003192:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003194:	04451703          	lh	a4,68(a0)
    80003198:	4785                	li	a5,1
    8000319a:	00f71a63          	bne	a4,a5,800031ae <dirlookup+0x2a>
    8000319e:	892a                	mv	s2,a0
    800031a0:	89ae                	mv	s3,a1
    800031a2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a4:	457c                	lw	a5,76(a0)
    800031a6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031a8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031aa:	e79d                	bnez	a5,800031d8 <dirlookup+0x54>
    800031ac:	a8a5                	j	80003224 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031ae:	00005517          	auipc	a0,0x5
    800031b2:	28a50513          	addi	a0,a0,650 # 80008438 <etext+0x438>
    800031b6:	00003097          	auipc	ra,0x3
    800031ba:	eb6080e7          	jalr	-330(ra) # 8000606c <panic>
      panic("dirlookup read");
    800031be:	00005517          	auipc	a0,0x5
    800031c2:	29250513          	addi	a0,a0,658 # 80008450 <etext+0x450>
    800031c6:	00003097          	auipc	ra,0x3
    800031ca:	ea6080e7          	jalr	-346(ra) # 8000606c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ce:	24c1                	addiw	s1,s1,16
    800031d0:	04c92783          	lw	a5,76(s2)
    800031d4:	04f4f763          	bgeu	s1,a5,80003222 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031d8:	4741                	li	a4,16
    800031da:	86a6                	mv	a3,s1
    800031dc:	fc040613          	addi	a2,s0,-64
    800031e0:	4581                	li	a1,0
    800031e2:	854a                	mv	a0,s2
    800031e4:	00000097          	auipc	ra,0x0
    800031e8:	d58080e7          	jalr	-680(ra) # 80002f3c <readi>
    800031ec:	47c1                	li	a5,16
    800031ee:	fcf518e3          	bne	a0,a5,800031be <dirlookup+0x3a>
    if(de.inum == 0)
    800031f2:	fc045783          	lhu	a5,-64(s0)
    800031f6:	dfe1                	beqz	a5,800031ce <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031f8:	fc240593          	addi	a1,s0,-62
    800031fc:	854e                	mv	a0,s3
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	f6c080e7          	jalr	-148(ra) # 8000316a <namecmp>
    80003206:	f561                	bnez	a0,800031ce <dirlookup+0x4a>
      if(poff)
    80003208:	000a0463          	beqz	s4,80003210 <dirlookup+0x8c>
        *poff = off;
    8000320c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003210:	fc045583          	lhu	a1,-64(s0)
    80003214:	00092503          	lw	a0,0(s2)
    80003218:	fffff097          	auipc	ra,0xfffff
    8000321c:	73c080e7          	jalr	1852(ra) # 80002954 <iget>
    80003220:	a011                	j	80003224 <dirlookup+0xa0>
  return 0;
    80003222:	4501                	li	a0,0
}
    80003224:	70e2                	ld	ra,56(sp)
    80003226:	7442                	ld	s0,48(sp)
    80003228:	74a2                	ld	s1,40(sp)
    8000322a:	7902                	ld	s2,32(sp)
    8000322c:	69e2                	ld	s3,24(sp)
    8000322e:	6a42                	ld	s4,16(sp)
    80003230:	6121                	addi	sp,sp,64
    80003232:	8082                	ret

0000000080003234 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003234:	711d                	addi	sp,sp,-96
    80003236:	ec86                	sd	ra,88(sp)
    80003238:	e8a2                	sd	s0,80(sp)
    8000323a:	e4a6                	sd	s1,72(sp)
    8000323c:	e0ca                	sd	s2,64(sp)
    8000323e:	fc4e                	sd	s3,56(sp)
    80003240:	f852                	sd	s4,48(sp)
    80003242:	f456                	sd	s5,40(sp)
    80003244:	f05a                	sd	s6,32(sp)
    80003246:	ec5e                	sd	s7,24(sp)
    80003248:	e862                	sd	s8,16(sp)
    8000324a:	e466                	sd	s9,8(sp)
    8000324c:	1080                	addi	s0,sp,96
    8000324e:	84aa                	mv	s1,a0
    80003250:	8b2e                	mv	s6,a1
    80003252:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003254:	00054703          	lbu	a4,0(a0)
    80003258:	02f00793          	li	a5,47
    8000325c:	02f70263          	beq	a4,a5,80003280 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003260:	ffffe097          	auipc	ra,0xffffe
    80003264:	bfa080e7          	jalr	-1030(ra) # 80000e5a <myproc>
    80003268:	15053503          	ld	a0,336(a0)
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	9da080e7          	jalr	-1574(ra) # 80002c46 <idup>
    80003274:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003276:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000327a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000327c:	4b85                	li	s7,1
    8000327e:	a875                	j	8000333a <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003280:	4585                	li	a1,1
    80003282:	4505                	li	a0,1
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	6d0080e7          	jalr	1744(ra) # 80002954 <iget>
    8000328c:	8a2a                	mv	s4,a0
    8000328e:	b7e5                	j	80003276 <namex+0x42>
      iunlockput(ip);
    80003290:	8552                	mv	a0,s4
    80003292:	00000097          	auipc	ra,0x0
    80003296:	c58080e7          	jalr	-936(ra) # 80002eea <iunlockput>
      return 0;
    8000329a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000329c:	8552                	mv	a0,s4
    8000329e:	60e6                	ld	ra,88(sp)
    800032a0:	6446                	ld	s0,80(sp)
    800032a2:	64a6                	ld	s1,72(sp)
    800032a4:	6906                	ld	s2,64(sp)
    800032a6:	79e2                	ld	s3,56(sp)
    800032a8:	7a42                	ld	s4,48(sp)
    800032aa:	7aa2                	ld	s5,40(sp)
    800032ac:	7b02                	ld	s6,32(sp)
    800032ae:	6be2                	ld	s7,24(sp)
    800032b0:	6c42                	ld	s8,16(sp)
    800032b2:	6ca2                	ld	s9,8(sp)
    800032b4:	6125                	addi	sp,sp,96
    800032b6:	8082                	ret
      iunlock(ip);
    800032b8:	8552                	mv	a0,s4
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	a90080e7          	jalr	-1392(ra) # 80002d4a <iunlock>
      return ip;
    800032c2:	bfe9                	j	8000329c <namex+0x68>
      iunlockput(ip);
    800032c4:	8552                	mv	a0,s4
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	c24080e7          	jalr	-988(ra) # 80002eea <iunlockput>
      return 0;
    800032ce:	8a4e                	mv	s4,s3
    800032d0:	b7f1                	j	8000329c <namex+0x68>
  len = path - s;
    800032d2:	40998633          	sub	a2,s3,s1
    800032d6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800032da:	099c5863          	bge	s8,s9,8000336a <namex+0x136>
    memmove(name, s, DIRSIZ);
    800032de:	4639                	li	a2,14
    800032e0:	85a6                	mv	a1,s1
    800032e2:	8556                	mv	a0,s5
    800032e4:	ffffd097          	auipc	ra,0xffffd
    800032e8:	ef2080e7          	jalr	-270(ra) # 800001d6 <memmove>
    800032ec:	84ce                	mv	s1,s3
  while(*path == '/')
    800032ee:	0004c783          	lbu	a5,0(s1)
    800032f2:	01279763          	bne	a5,s2,80003300 <namex+0xcc>
    path++;
    800032f6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032f8:	0004c783          	lbu	a5,0(s1)
    800032fc:	ff278de3          	beq	a5,s2,800032f6 <namex+0xc2>
    ilock(ip);
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	982080e7          	jalr	-1662(ra) # 80002c84 <ilock>
    if(ip->type != T_DIR){
    8000330a:	044a1783          	lh	a5,68(s4)
    8000330e:	f97791e3          	bne	a5,s7,80003290 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003312:	000b0563          	beqz	s6,8000331c <namex+0xe8>
    80003316:	0004c783          	lbu	a5,0(s1)
    8000331a:	dfd9                	beqz	a5,800032b8 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000331c:	4601                	li	a2,0
    8000331e:	85d6                	mv	a1,s5
    80003320:	8552                	mv	a0,s4
    80003322:	00000097          	auipc	ra,0x0
    80003326:	e62080e7          	jalr	-414(ra) # 80003184 <dirlookup>
    8000332a:	89aa                	mv	s3,a0
    8000332c:	dd41                	beqz	a0,800032c4 <namex+0x90>
    iunlockput(ip);
    8000332e:	8552                	mv	a0,s4
    80003330:	00000097          	auipc	ra,0x0
    80003334:	bba080e7          	jalr	-1094(ra) # 80002eea <iunlockput>
    ip = next;
    80003338:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000333a:	0004c783          	lbu	a5,0(s1)
    8000333e:	01279763          	bne	a5,s2,8000334c <namex+0x118>
    path++;
    80003342:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003344:	0004c783          	lbu	a5,0(s1)
    80003348:	ff278de3          	beq	a5,s2,80003342 <namex+0x10e>
  if(*path == 0)
    8000334c:	cb9d                	beqz	a5,80003382 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000334e:	0004c783          	lbu	a5,0(s1)
    80003352:	89a6                	mv	s3,s1
  len = path - s;
    80003354:	4c81                	li	s9,0
    80003356:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003358:	01278963          	beq	a5,s2,8000336a <namex+0x136>
    8000335c:	dbbd                	beqz	a5,800032d2 <namex+0x9e>
    path++;
    8000335e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003360:	0009c783          	lbu	a5,0(s3)
    80003364:	ff279ce3          	bne	a5,s2,8000335c <namex+0x128>
    80003368:	b7ad                	j	800032d2 <namex+0x9e>
    memmove(name, s, len);
    8000336a:	2601                	sext.w	a2,a2
    8000336c:	85a6                	mv	a1,s1
    8000336e:	8556                	mv	a0,s5
    80003370:	ffffd097          	auipc	ra,0xffffd
    80003374:	e66080e7          	jalr	-410(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003378:	9cd6                	add	s9,s9,s5
    8000337a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000337e:	84ce                	mv	s1,s3
    80003380:	b7bd                	j	800032ee <namex+0xba>
  if(nameiparent){
    80003382:	f00b0de3          	beqz	s6,8000329c <namex+0x68>
    iput(ip);
    80003386:	8552                	mv	a0,s4
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	aba080e7          	jalr	-1350(ra) # 80002e42 <iput>
    return 0;
    80003390:	4a01                	li	s4,0
    80003392:	b729                	j	8000329c <namex+0x68>

0000000080003394 <dirlink>:
{
    80003394:	7139                	addi	sp,sp,-64
    80003396:	fc06                	sd	ra,56(sp)
    80003398:	f822                	sd	s0,48(sp)
    8000339a:	f04a                	sd	s2,32(sp)
    8000339c:	ec4e                	sd	s3,24(sp)
    8000339e:	e852                	sd	s4,16(sp)
    800033a0:	0080                	addi	s0,sp,64
    800033a2:	892a                	mv	s2,a0
    800033a4:	8a2e                	mv	s4,a1
    800033a6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033a8:	4601                	li	a2,0
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	dda080e7          	jalr	-550(ra) # 80003184 <dirlookup>
    800033b2:	ed25                	bnez	a0,8000342a <dirlink+0x96>
    800033b4:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033b6:	04c92483          	lw	s1,76(s2)
    800033ba:	c49d                	beqz	s1,800033e8 <dirlink+0x54>
    800033bc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033be:	4741                	li	a4,16
    800033c0:	86a6                	mv	a3,s1
    800033c2:	fc040613          	addi	a2,s0,-64
    800033c6:	4581                	li	a1,0
    800033c8:	854a                	mv	a0,s2
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	b72080e7          	jalr	-1166(ra) # 80002f3c <readi>
    800033d2:	47c1                	li	a5,16
    800033d4:	06f51163          	bne	a0,a5,80003436 <dirlink+0xa2>
    if(de.inum == 0)
    800033d8:	fc045783          	lhu	a5,-64(s0)
    800033dc:	c791                	beqz	a5,800033e8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033de:	24c1                	addiw	s1,s1,16
    800033e0:	04c92783          	lw	a5,76(s2)
    800033e4:	fcf4ede3          	bltu	s1,a5,800033be <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033e8:	4639                	li	a2,14
    800033ea:	85d2                	mv	a1,s4
    800033ec:	fc240513          	addi	a0,s0,-62
    800033f0:	ffffd097          	auipc	ra,0xffffd
    800033f4:	e90080e7          	jalr	-368(ra) # 80000280 <strncpy>
  de.inum = inum;
    800033f8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033fc:	4741                	li	a4,16
    800033fe:	86a6                	mv	a3,s1
    80003400:	fc040613          	addi	a2,s0,-64
    80003404:	4581                	li	a1,0
    80003406:	854a                	mv	a0,s2
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	c38080e7          	jalr	-968(ra) # 80003040 <writei>
    80003410:	872a                	mv	a4,a0
    80003412:	47c1                	li	a5,16
  return 0;
    80003414:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003416:	02f71863          	bne	a4,a5,80003446 <dirlink+0xb2>
    8000341a:	74a2                	ld	s1,40(sp)
}
    8000341c:	70e2                	ld	ra,56(sp)
    8000341e:	7442                	ld	s0,48(sp)
    80003420:	7902                	ld	s2,32(sp)
    80003422:	69e2                	ld	s3,24(sp)
    80003424:	6a42                	ld	s4,16(sp)
    80003426:	6121                	addi	sp,sp,64
    80003428:	8082                	ret
    iput(ip);
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	a18080e7          	jalr	-1512(ra) # 80002e42 <iput>
    return -1;
    80003432:	557d                	li	a0,-1
    80003434:	b7e5                	j	8000341c <dirlink+0x88>
      panic("dirlink read");
    80003436:	00005517          	auipc	a0,0x5
    8000343a:	02a50513          	addi	a0,a0,42 # 80008460 <etext+0x460>
    8000343e:	00003097          	auipc	ra,0x3
    80003442:	c2e080e7          	jalr	-978(ra) # 8000606c <panic>
    panic("dirlink");
    80003446:	00005517          	auipc	a0,0x5
    8000344a:	12a50513          	addi	a0,a0,298 # 80008570 <etext+0x570>
    8000344e:	00003097          	auipc	ra,0x3
    80003452:	c1e080e7          	jalr	-994(ra) # 8000606c <panic>

0000000080003456 <namei>:

struct inode*
namei(char *path)
{
    80003456:	1101                	addi	sp,sp,-32
    80003458:	ec06                	sd	ra,24(sp)
    8000345a:	e822                	sd	s0,16(sp)
    8000345c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000345e:	fe040613          	addi	a2,s0,-32
    80003462:	4581                	li	a1,0
    80003464:	00000097          	auipc	ra,0x0
    80003468:	dd0080e7          	jalr	-560(ra) # 80003234 <namex>
}
    8000346c:	60e2                	ld	ra,24(sp)
    8000346e:	6442                	ld	s0,16(sp)
    80003470:	6105                	addi	sp,sp,32
    80003472:	8082                	ret

0000000080003474 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003474:	1141                	addi	sp,sp,-16
    80003476:	e406                	sd	ra,8(sp)
    80003478:	e022                	sd	s0,0(sp)
    8000347a:	0800                	addi	s0,sp,16
    8000347c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000347e:	4585                	li	a1,1
    80003480:	00000097          	auipc	ra,0x0
    80003484:	db4080e7          	jalr	-588(ra) # 80003234 <namex>
}
    80003488:	60a2                	ld	ra,8(sp)
    8000348a:	6402                	ld	s0,0(sp)
    8000348c:	0141                	addi	sp,sp,16
    8000348e:	8082                	ret

0000000080003490 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003490:	1101                	addi	sp,sp,-32
    80003492:	ec06                	sd	ra,24(sp)
    80003494:	e822                	sd	s0,16(sp)
    80003496:	e426                	sd	s1,8(sp)
    80003498:	e04a                	sd	s2,0(sp)
    8000349a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000349c:	00023917          	auipc	s2,0x23
    800034a0:	b8490913          	addi	s2,s2,-1148 # 80026020 <log>
    800034a4:	01892583          	lw	a1,24(s2)
    800034a8:	02892503          	lw	a0,40(s2)
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	fde080e7          	jalr	-34(ra) # 8000248a <bread>
    800034b4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034b6:	02c92603          	lw	a2,44(s2)
    800034ba:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034bc:	00c05f63          	blez	a2,800034da <write_head+0x4a>
    800034c0:	00023717          	auipc	a4,0x23
    800034c4:	b9070713          	addi	a4,a4,-1136 # 80026050 <log+0x30>
    800034c8:	87aa                	mv	a5,a0
    800034ca:	060a                	slli	a2,a2,0x2
    800034cc:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800034ce:	4314                	lw	a3,0(a4)
    800034d0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034d2:	0711                	addi	a4,a4,4
    800034d4:	0791                	addi	a5,a5,4
    800034d6:	fec79ce3          	bne	a5,a2,800034ce <write_head+0x3e>
  }
  bwrite(buf);
    800034da:	8526                	mv	a0,s1
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	0a0080e7          	jalr	160(ra) # 8000257c <bwrite>
  brelse(buf);
    800034e4:	8526                	mv	a0,s1
    800034e6:	fffff097          	auipc	ra,0xfffff
    800034ea:	0d4080e7          	jalr	212(ra) # 800025ba <brelse>
}
    800034ee:	60e2                	ld	ra,24(sp)
    800034f0:	6442                	ld	s0,16(sp)
    800034f2:	64a2                	ld	s1,8(sp)
    800034f4:	6902                	ld	s2,0(sp)
    800034f6:	6105                	addi	sp,sp,32
    800034f8:	8082                	ret

00000000800034fa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034fa:	00023797          	auipc	a5,0x23
    800034fe:	b527a783          	lw	a5,-1198(a5) # 8002604c <log+0x2c>
    80003502:	0af05d63          	blez	a5,800035bc <install_trans+0xc2>
{
    80003506:	7139                	addi	sp,sp,-64
    80003508:	fc06                	sd	ra,56(sp)
    8000350a:	f822                	sd	s0,48(sp)
    8000350c:	f426                	sd	s1,40(sp)
    8000350e:	f04a                	sd	s2,32(sp)
    80003510:	ec4e                	sd	s3,24(sp)
    80003512:	e852                	sd	s4,16(sp)
    80003514:	e456                	sd	s5,8(sp)
    80003516:	e05a                	sd	s6,0(sp)
    80003518:	0080                	addi	s0,sp,64
    8000351a:	8b2a                	mv	s6,a0
    8000351c:	00023a97          	auipc	s5,0x23
    80003520:	b34a8a93          	addi	s5,s5,-1228 # 80026050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003524:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003526:	00023997          	auipc	s3,0x23
    8000352a:	afa98993          	addi	s3,s3,-1286 # 80026020 <log>
    8000352e:	a00d                	j	80003550 <install_trans+0x56>
    brelse(lbuf);
    80003530:	854a                	mv	a0,s2
    80003532:	fffff097          	auipc	ra,0xfffff
    80003536:	088080e7          	jalr	136(ra) # 800025ba <brelse>
    brelse(dbuf);
    8000353a:	8526                	mv	a0,s1
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	07e080e7          	jalr	126(ra) # 800025ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003544:	2a05                	addiw	s4,s4,1
    80003546:	0a91                	addi	s5,s5,4
    80003548:	02c9a783          	lw	a5,44(s3)
    8000354c:	04fa5e63          	bge	s4,a5,800035a8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003550:	0189a583          	lw	a1,24(s3)
    80003554:	014585bb          	addw	a1,a1,s4
    80003558:	2585                	addiw	a1,a1,1
    8000355a:	0289a503          	lw	a0,40(s3)
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	f2c080e7          	jalr	-212(ra) # 8000248a <bread>
    80003566:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003568:	000aa583          	lw	a1,0(s5)
    8000356c:	0289a503          	lw	a0,40(s3)
    80003570:	fffff097          	auipc	ra,0xfffff
    80003574:	f1a080e7          	jalr	-230(ra) # 8000248a <bread>
    80003578:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000357a:	40000613          	li	a2,1024
    8000357e:	05890593          	addi	a1,s2,88
    80003582:	05850513          	addi	a0,a0,88
    80003586:	ffffd097          	auipc	ra,0xffffd
    8000358a:	c50080e7          	jalr	-944(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000358e:	8526                	mv	a0,s1
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	fec080e7          	jalr	-20(ra) # 8000257c <bwrite>
    if(recovering == 0)
    80003598:	f80b1ce3          	bnez	s6,80003530 <install_trans+0x36>
      bunpin(dbuf);
    8000359c:	8526                	mv	a0,s1
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	0f4080e7          	jalr	244(ra) # 80002692 <bunpin>
    800035a6:	b769                	j	80003530 <install_trans+0x36>
}
    800035a8:	70e2                	ld	ra,56(sp)
    800035aa:	7442                	ld	s0,48(sp)
    800035ac:	74a2                	ld	s1,40(sp)
    800035ae:	7902                	ld	s2,32(sp)
    800035b0:	69e2                	ld	s3,24(sp)
    800035b2:	6a42                	ld	s4,16(sp)
    800035b4:	6aa2                	ld	s5,8(sp)
    800035b6:	6b02                	ld	s6,0(sp)
    800035b8:	6121                	addi	sp,sp,64
    800035ba:	8082                	ret
    800035bc:	8082                	ret

00000000800035be <initlog>:
{
    800035be:	7179                	addi	sp,sp,-48
    800035c0:	f406                	sd	ra,40(sp)
    800035c2:	f022                	sd	s0,32(sp)
    800035c4:	ec26                	sd	s1,24(sp)
    800035c6:	e84a                	sd	s2,16(sp)
    800035c8:	e44e                	sd	s3,8(sp)
    800035ca:	1800                	addi	s0,sp,48
    800035cc:	892a                	mv	s2,a0
    800035ce:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035d0:	00023497          	auipc	s1,0x23
    800035d4:	a5048493          	addi	s1,s1,-1456 # 80026020 <log>
    800035d8:	00005597          	auipc	a1,0x5
    800035dc:	e9858593          	addi	a1,a1,-360 # 80008470 <etext+0x470>
    800035e0:	8526                	mv	a0,s1
    800035e2:	00003097          	auipc	ra,0x3
    800035e6:	f74080e7          	jalr	-140(ra) # 80006556 <initlock>
  log.start = sb->logstart;
    800035ea:	0149a583          	lw	a1,20(s3)
    800035ee:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035f0:	0109a783          	lw	a5,16(s3)
    800035f4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035f6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035fa:	854a                	mv	a0,s2
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	e8e080e7          	jalr	-370(ra) # 8000248a <bread>
  log.lh.n = lh->n;
    80003604:	4d30                	lw	a2,88(a0)
    80003606:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003608:	00c05f63          	blez	a2,80003626 <initlog+0x68>
    8000360c:	87aa                	mv	a5,a0
    8000360e:	00023717          	auipc	a4,0x23
    80003612:	a4270713          	addi	a4,a4,-1470 # 80026050 <log+0x30>
    80003616:	060a                	slli	a2,a2,0x2
    80003618:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000361a:	4ff4                	lw	a3,92(a5)
    8000361c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000361e:	0791                	addi	a5,a5,4
    80003620:	0711                	addi	a4,a4,4
    80003622:	fec79ce3          	bne	a5,a2,8000361a <initlog+0x5c>
  brelse(buf);
    80003626:	fffff097          	auipc	ra,0xfffff
    8000362a:	f94080e7          	jalr	-108(ra) # 800025ba <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000362e:	4505                	li	a0,1
    80003630:	00000097          	auipc	ra,0x0
    80003634:	eca080e7          	jalr	-310(ra) # 800034fa <install_trans>
  log.lh.n = 0;
    80003638:	00023797          	auipc	a5,0x23
    8000363c:	a007aa23          	sw	zero,-1516(a5) # 8002604c <log+0x2c>
  write_head(); // clear the log
    80003640:	00000097          	auipc	ra,0x0
    80003644:	e50080e7          	jalr	-432(ra) # 80003490 <write_head>
}
    80003648:	70a2                	ld	ra,40(sp)
    8000364a:	7402                	ld	s0,32(sp)
    8000364c:	64e2                	ld	s1,24(sp)
    8000364e:	6942                	ld	s2,16(sp)
    80003650:	69a2                	ld	s3,8(sp)
    80003652:	6145                	addi	sp,sp,48
    80003654:	8082                	ret

0000000080003656 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003656:	1101                	addi	sp,sp,-32
    80003658:	ec06                	sd	ra,24(sp)
    8000365a:	e822                	sd	s0,16(sp)
    8000365c:	e426                	sd	s1,8(sp)
    8000365e:	e04a                	sd	s2,0(sp)
    80003660:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003662:	00023517          	auipc	a0,0x23
    80003666:	9be50513          	addi	a0,a0,-1602 # 80026020 <log>
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	f7c080e7          	jalr	-132(ra) # 800065e6 <acquire>
  while(1){
    if(log.committing){
    80003672:	00023497          	auipc	s1,0x23
    80003676:	9ae48493          	addi	s1,s1,-1618 # 80026020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000367a:	4979                	li	s2,30
    8000367c:	a039                	j	8000368a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000367e:	85a6                	mv	a1,s1
    80003680:	8526                	mv	a0,s1
    80003682:	ffffe097          	auipc	ra,0xffffe
    80003686:	ed8080e7          	jalr	-296(ra) # 8000155a <sleep>
    if(log.committing){
    8000368a:	50dc                	lw	a5,36(s1)
    8000368c:	fbed                	bnez	a5,8000367e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000368e:	5098                	lw	a4,32(s1)
    80003690:	2705                	addiw	a4,a4,1
    80003692:	0027179b          	slliw	a5,a4,0x2
    80003696:	9fb9                	addw	a5,a5,a4
    80003698:	0017979b          	slliw	a5,a5,0x1
    8000369c:	54d4                	lw	a3,44(s1)
    8000369e:	9fb5                	addw	a5,a5,a3
    800036a0:	00f95963          	bge	s2,a5,800036b2 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036a4:	85a6                	mv	a1,s1
    800036a6:	8526                	mv	a0,s1
    800036a8:	ffffe097          	auipc	ra,0xffffe
    800036ac:	eb2080e7          	jalr	-334(ra) # 8000155a <sleep>
    800036b0:	bfe9                	j	8000368a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036b2:	00023517          	auipc	a0,0x23
    800036b6:	96e50513          	addi	a0,a0,-1682 # 80026020 <log>
    800036ba:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800036bc:	00003097          	auipc	ra,0x3
    800036c0:	fde080e7          	jalr	-34(ra) # 8000669a <release>
      break;
    }
  }
}
    800036c4:	60e2                	ld	ra,24(sp)
    800036c6:	6442                	ld	s0,16(sp)
    800036c8:	64a2                	ld	s1,8(sp)
    800036ca:	6902                	ld	s2,0(sp)
    800036cc:	6105                	addi	sp,sp,32
    800036ce:	8082                	ret

00000000800036d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036d0:	7139                	addi	sp,sp,-64
    800036d2:	fc06                	sd	ra,56(sp)
    800036d4:	f822                	sd	s0,48(sp)
    800036d6:	f426                	sd	s1,40(sp)
    800036d8:	f04a                	sd	s2,32(sp)
    800036da:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036dc:	00023497          	auipc	s1,0x23
    800036e0:	94448493          	addi	s1,s1,-1724 # 80026020 <log>
    800036e4:	8526                	mv	a0,s1
    800036e6:	00003097          	auipc	ra,0x3
    800036ea:	f00080e7          	jalr	-256(ra) # 800065e6 <acquire>
  log.outstanding -= 1;
    800036ee:	509c                	lw	a5,32(s1)
    800036f0:	37fd                	addiw	a5,a5,-1
    800036f2:	0007891b          	sext.w	s2,a5
    800036f6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036f8:	50dc                	lw	a5,36(s1)
    800036fa:	e7b9                	bnez	a5,80003748 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800036fc:	06091163          	bnez	s2,8000375e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003700:	00023497          	auipc	s1,0x23
    80003704:	92048493          	addi	s1,s1,-1760 # 80026020 <log>
    80003708:	4785                	li	a5,1
    8000370a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000370c:	8526                	mv	a0,s1
    8000370e:	00003097          	auipc	ra,0x3
    80003712:	f8c080e7          	jalr	-116(ra) # 8000669a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003716:	54dc                	lw	a5,44(s1)
    80003718:	06f04763          	bgtz	a5,80003786 <end_op+0xb6>
    acquire(&log.lock);
    8000371c:	00023497          	auipc	s1,0x23
    80003720:	90448493          	addi	s1,s1,-1788 # 80026020 <log>
    80003724:	8526                	mv	a0,s1
    80003726:	00003097          	auipc	ra,0x3
    8000372a:	ec0080e7          	jalr	-320(ra) # 800065e6 <acquire>
    log.committing = 0;
    8000372e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003732:	8526                	mv	a0,s1
    80003734:	ffffe097          	auipc	ra,0xffffe
    80003738:	fb2080e7          	jalr	-78(ra) # 800016e6 <wakeup>
    release(&log.lock);
    8000373c:	8526                	mv	a0,s1
    8000373e:	00003097          	auipc	ra,0x3
    80003742:	f5c080e7          	jalr	-164(ra) # 8000669a <release>
}
    80003746:	a815                	j	8000377a <end_op+0xaa>
    80003748:	ec4e                	sd	s3,24(sp)
    8000374a:	e852                	sd	s4,16(sp)
    8000374c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000374e:	00005517          	auipc	a0,0x5
    80003752:	d2a50513          	addi	a0,a0,-726 # 80008478 <etext+0x478>
    80003756:	00003097          	auipc	ra,0x3
    8000375a:	916080e7          	jalr	-1770(ra) # 8000606c <panic>
    wakeup(&log);
    8000375e:	00023497          	auipc	s1,0x23
    80003762:	8c248493          	addi	s1,s1,-1854 # 80026020 <log>
    80003766:	8526                	mv	a0,s1
    80003768:	ffffe097          	auipc	ra,0xffffe
    8000376c:	f7e080e7          	jalr	-130(ra) # 800016e6 <wakeup>
  release(&log.lock);
    80003770:	8526                	mv	a0,s1
    80003772:	00003097          	auipc	ra,0x3
    80003776:	f28080e7          	jalr	-216(ra) # 8000669a <release>
}
    8000377a:	70e2                	ld	ra,56(sp)
    8000377c:	7442                	ld	s0,48(sp)
    8000377e:	74a2                	ld	s1,40(sp)
    80003780:	7902                	ld	s2,32(sp)
    80003782:	6121                	addi	sp,sp,64
    80003784:	8082                	ret
    80003786:	ec4e                	sd	s3,24(sp)
    80003788:	e852                	sd	s4,16(sp)
    8000378a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000378c:	00023a97          	auipc	s5,0x23
    80003790:	8c4a8a93          	addi	s5,s5,-1852 # 80026050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003794:	00023a17          	auipc	s4,0x23
    80003798:	88ca0a13          	addi	s4,s4,-1908 # 80026020 <log>
    8000379c:	018a2583          	lw	a1,24(s4)
    800037a0:	012585bb          	addw	a1,a1,s2
    800037a4:	2585                	addiw	a1,a1,1
    800037a6:	028a2503          	lw	a0,40(s4)
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	ce0080e7          	jalr	-800(ra) # 8000248a <bread>
    800037b2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037b4:	000aa583          	lw	a1,0(s5)
    800037b8:	028a2503          	lw	a0,40(s4)
    800037bc:	fffff097          	auipc	ra,0xfffff
    800037c0:	cce080e7          	jalr	-818(ra) # 8000248a <bread>
    800037c4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037c6:	40000613          	li	a2,1024
    800037ca:	05850593          	addi	a1,a0,88
    800037ce:	05848513          	addi	a0,s1,88
    800037d2:	ffffd097          	auipc	ra,0xffffd
    800037d6:	a04080e7          	jalr	-1532(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037da:	8526                	mv	a0,s1
    800037dc:	fffff097          	auipc	ra,0xfffff
    800037e0:	da0080e7          	jalr	-608(ra) # 8000257c <bwrite>
    brelse(from);
    800037e4:	854e                	mv	a0,s3
    800037e6:	fffff097          	auipc	ra,0xfffff
    800037ea:	dd4080e7          	jalr	-556(ra) # 800025ba <brelse>
    brelse(to);
    800037ee:	8526                	mv	a0,s1
    800037f0:	fffff097          	auipc	ra,0xfffff
    800037f4:	dca080e7          	jalr	-566(ra) # 800025ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f8:	2905                	addiw	s2,s2,1
    800037fa:	0a91                	addi	s5,s5,4
    800037fc:	02ca2783          	lw	a5,44(s4)
    80003800:	f8f94ee3          	blt	s2,a5,8000379c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003804:	00000097          	auipc	ra,0x0
    80003808:	c8c080e7          	jalr	-884(ra) # 80003490 <write_head>
    install_trans(0); // Now install writes to home locations
    8000380c:	4501                	li	a0,0
    8000380e:	00000097          	auipc	ra,0x0
    80003812:	cec080e7          	jalr	-788(ra) # 800034fa <install_trans>
    log.lh.n = 0;
    80003816:	00023797          	auipc	a5,0x23
    8000381a:	8207ab23          	sw	zero,-1994(a5) # 8002604c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000381e:	00000097          	auipc	ra,0x0
    80003822:	c72080e7          	jalr	-910(ra) # 80003490 <write_head>
    80003826:	69e2                	ld	s3,24(sp)
    80003828:	6a42                	ld	s4,16(sp)
    8000382a:	6aa2                	ld	s5,8(sp)
    8000382c:	bdc5                	j	8000371c <end_op+0x4c>

000000008000382e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000382e:	1101                	addi	sp,sp,-32
    80003830:	ec06                	sd	ra,24(sp)
    80003832:	e822                	sd	s0,16(sp)
    80003834:	e426                	sd	s1,8(sp)
    80003836:	e04a                	sd	s2,0(sp)
    80003838:	1000                	addi	s0,sp,32
    8000383a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000383c:	00022917          	auipc	s2,0x22
    80003840:	7e490913          	addi	s2,s2,2020 # 80026020 <log>
    80003844:	854a                	mv	a0,s2
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	da0080e7          	jalr	-608(ra) # 800065e6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000384e:	02c92603          	lw	a2,44(s2)
    80003852:	47f5                	li	a5,29
    80003854:	06c7c563          	blt	a5,a2,800038be <log_write+0x90>
    80003858:	00022797          	auipc	a5,0x22
    8000385c:	7e47a783          	lw	a5,2020(a5) # 8002603c <log+0x1c>
    80003860:	37fd                	addiw	a5,a5,-1
    80003862:	04f65e63          	bge	a2,a5,800038be <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003866:	00022797          	auipc	a5,0x22
    8000386a:	7da7a783          	lw	a5,2010(a5) # 80026040 <log+0x20>
    8000386e:	06f05063          	blez	a5,800038ce <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003872:	4781                	li	a5,0
    80003874:	06c05563          	blez	a2,800038de <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003878:	44cc                	lw	a1,12(s1)
    8000387a:	00022717          	auipc	a4,0x22
    8000387e:	7d670713          	addi	a4,a4,2006 # 80026050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003882:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003884:	4314                	lw	a3,0(a4)
    80003886:	04b68c63          	beq	a3,a1,800038de <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000388a:	2785                	addiw	a5,a5,1
    8000388c:	0711                	addi	a4,a4,4
    8000388e:	fef61be3          	bne	a2,a5,80003884 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003892:	0621                	addi	a2,a2,8
    80003894:	060a                	slli	a2,a2,0x2
    80003896:	00022797          	auipc	a5,0x22
    8000389a:	78a78793          	addi	a5,a5,1930 # 80026020 <log>
    8000389e:	97b2                	add	a5,a5,a2
    800038a0:	44d8                	lw	a4,12(s1)
    800038a2:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038a4:	8526                	mv	a0,s1
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	db0080e7          	jalr	-592(ra) # 80002656 <bpin>
    log.lh.n++;
    800038ae:	00022717          	auipc	a4,0x22
    800038b2:	77270713          	addi	a4,a4,1906 # 80026020 <log>
    800038b6:	575c                	lw	a5,44(a4)
    800038b8:	2785                	addiw	a5,a5,1
    800038ba:	d75c                	sw	a5,44(a4)
    800038bc:	a82d                	j	800038f6 <log_write+0xc8>
    panic("too big a transaction");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	bca50513          	addi	a0,a0,-1078 # 80008488 <etext+0x488>
    800038c6:	00002097          	auipc	ra,0x2
    800038ca:	7a6080e7          	jalr	1958(ra) # 8000606c <panic>
    panic("log_write outside of trans");
    800038ce:	00005517          	auipc	a0,0x5
    800038d2:	bd250513          	addi	a0,a0,-1070 # 800084a0 <etext+0x4a0>
    800038d6:	00002097          	auipc	ra,0x2
    800038da:	796080e7          	jalr	1942(ra) # 8000606c <panic>
  log.lh.block[i] = b->blockno;
    800038de:	00878693          	addi	a3,a5,8
    800038e2:	068a                	slli	a3,a3,0x2
    800038e4:	00022717          	auipc	a4,0x22
    800038e8:	73c70713          	addi	a4,a4,1852 # 80026020 <log>
    800038ec:	9736                	add	a4,a4,a3
    800038ee:	44d4                	lw	a3,12(s1)
    800038f0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038f2:	faf609e3          	beq	a2,a5,800038a4 <log_write+0x76>
  }
  release(&log.lock);
    800038f6:	00022517          	auipc	a0,0x22
    800038fa:	72a50513          	addi	a0,a0,1834 # 80026020 <log>
    800038fe:	00003097          	auipc	ra,0x3
    80003902:	d9c080e7          	jalr	-612(ra) # 8000669a <release>
}
    80003906:	60e2                	ld	ra,24(sp)
    80003908:	6442                	ld	s0,16(sp)
    8000390a:	64a2                	ld	s1,8(sp)
    8000390c:	6902                	ld	s2,0(sp)
    8000390e:	6105                	addi	sp,sp,32
    80003910:	8082                	ret

0000000080003912 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003912:	1101                	addi	sp,sp,-32
    80003914:	ec06                	sd	ra,24(sp)
    80003916:	e822                	sd	s0,16(sp)
    80003918:	e426                	sd	s1,8(sp)
    8000391a:	e04a                	sd	s2,0(sp)
    8000391c:	1000                	addi	s0,sp,32
    8000391e:	84aa                	mv	s1,a0
    80003920:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003922:	00005597          	auipc	a1,0x5
    80003926:	b9e58593          	addi	a1,a1,-1122 # 800084c0 <etext+0x4c0>
    8000392a:	0521                	addi	a0,a0,8
    8000392c:	00003097          	auipc	ra,0x3
    80003930:	c2a080e7          	jalr	-982(ra) # 80006556 <initlock>
  lk->name = name;
    80003934:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003938:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000393c:	0204a423          	sw	zero,40(s1)
}
    80003940:	60e2                	ld	ra,24(sp)
    80003942:	6442                	ld	s0,16(sp)
    80003944:	64a2                	ld	s1,8(sp)
    80003946:	6902                	ld	s2,0(sp)
    80003948:	6105                	addi	sp,sp,32
    8000394a:	8082                	ret

000000008000394c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000394c:	1101                	addi	sp,sp,-32
    8000394e:	ec06                	sd	ra,24(sp)
    80003950:	e822                	sd	s0,16(sp)
    80003952:	e426                	sd	s1,8(sp)
    80003954:	e04a                	sd	s2,0(sp)
    80003956:	1000                	addi	s0,sp,32
    80003958:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000395a:	00850913          	addi	s2,a0,8
    8000395e:	854a                	mv	a0,s2
    80003960:	00003097          	auipc	ra,0x3
    80003964:	c86080e7          	jalr	-890(ra) # 800065e6 <acquire>
  while (lk->locked) {
    80003968:	409c                	lw	a5,0(s1)
    8000396a:	cb89                	beqz	a5,8000397c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000396c:	85ca                	mv	a1,s2
    8000396e:	8526                	mv	a0,s1
    80003970:	ffffe097          	auipc	ra,0xffffe
    80003974:	bea080e7          	jalr	-1046(ra) # 8000155a <sleep>
  while (lk->locked) {
    80003978:	409c                	lw	a5,0(s1)
    8000397a:	fbed                	bnez	a5,8000396c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000397c:	4785                	li	a5,1
    8000397e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003980:	ffffd097          	auipc	ra,0xffffd
    80003984:	4da080e7          	jalr	1242(ra) # 80000e5a <myproc>
    80003988:	591c                	lw	a5,48(a0)
    8000398a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000398c:	854a                	mv	a0,s2
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	d0c080e7          	jalr	-756(ra) # 8000669a <release>
}
    80003996:	60e2                	ld	ra,24(sp)
    80003998:	6442                	ld	s0,16(sp)
    8000399a:	64a2                	ld	s1,8(sp)
    8000399c:	6902                	ld	s2,0(sp)
    8000399e:	6105                	addi	sp,sp,32
    800039a0:	8082                	ret

00000000800039a2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039a2:	1101                	addi	sp,sp,-32
    800039a4:	ec06                	sd	ra,24(sp)
    800039a6:	e822                	sd	s0,16(sp)
    800039a8:	e426                	sd	s1,8(sp)
    800039aa:	e04a                	sd	s2,0(sp)
    800039ac:	1000                	addi	s0,sp,32
    800039ae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039b0:	00850913          	addi	s2,a0,8
    800039b4:	854a                	mv	a0,s2
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	c30080e7          	jalr	-976(ra) # 800065e6 <acquire>
  lk->locked = 0;
    800039be:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039c2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039c6:	8526                	mv	a0,s1
    800039c8:	ffffe097          	auipc	ra,0xffffe
    800039cc:	d1e080e7          	jalr	-738(ra) # 800016e6 <wakeup>
  release(&lk->lk);
    800039d0:	854a                	mv	a0,s2
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	cc8080e7          	jalr	-824(ra) # 8000669a <release>
}
    800039da:	60e2                	ld	ra,24(sp)
    800039dc:	6442                	ld	s0,16(sp)
    800039de:	64a2                	ld	s1,8(sp)
    800039e0:	6902                	ld	s2,0(sp)
    800039e2:	6105                	addi	sp,sp,32
    800039e4:	8082                	ret

00000000800039e6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039e6:	7179                	addi	sp,sp,-48
    800039e8:	f406                	sd	ra,40(sp)
    800039ea:	f022                	sd	s0,32(sp)
    800039ec:	ec26                	sd	s1,24(sp)
    800039ee:	e84a                	sd	s2,16(sp)
    800039f0:	1800                	addi	s0,sp,48
    800039f2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039f4:	00850913          	addi	s2,a0,8
    800039f8:	854a                	mv	a0,s2
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	bec080e7          	jalr	-1044(ra) # 800065e6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a02:	409c                	lw	a5,0(s1)
    80003a04:	ef91                	bnez	a5,80003a20 <holdingsleep+0x3a>
    80003a06:	4481                	li	s1,0
  release(&lk->lk);
    80003a08:	854a                	mv	a0,s2
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	c90080e7          	jalr	-880(ra) # 8000669a <release>
  return r;
}
    80003a12:	8526                	mv	a0,s1
    80003a14:	70a2                	ld	ra,40(sp)
    80003a16:	7402                	ld	s0,32(sp)
    80003a18:	64e2                	ld	s1,24(sp)
    80003a1a:	6942                	ld	s2,16(sp)
    80003a1c:	6145                	addi	sp,sp,48
    80003a1e:	8082                	ret
    80003a20:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a22:	0284a983          	lw	s3,40(s1)
    80003a26:	ffffd097          	auipc	ra,0xffffd
    80003a2a:	434080e7          	jalr	1076(ra) # 80000e5a <myproc>
    80003a2e:	5904                	lw	s1,48(a0)
    80003a30:	413484b3          	sub	s1,s1,s3
    80003a34:	0014b493          	seqz	s1,s1
    80003a38:	69a2                	ld	s3,8(sp)
    80003a3a:	b7f9                	j	80003a08 <holdingsleep+0x22>

0000000080003a3c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a3c:	1141                	addi	sp,sp,-16
    80003a3e:	e406                	sd	ra,8(sp)
    80003a40:	e022                	sd	s0,0(sp)
    80003a42:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a44:	00005597          	auipc	a1,0x5
    80003a48:	a8c58593          	addi	a1,a1,-1396 # 800084d0 <etext+0x4d0>
    80003a4c:	00022517          	auipc	a0,0x22
    80003a50:	71c50513          	addi	a0,a0,1820 # 80026168 <ftable>
    80003a54:	00003097          	auipc	ra,0x3
    80003a58:	b02080e7          	jalr	-1278(ra) # 80006556 <initlock>
}
    80003a5c:	60a2                	ld	ra,8(sp)
    80003a5e:	6402                	ld	s0,0(sp)
    80003a60:	0141                	addi	sp,sp,16
    80003a62:	8082                	ret

0000000080003a64 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a64:	1101                	addi	sp,sp,-32
    80003a66:	ec06                	sd	ra,24(sp)
    80003a68:	e822                	sd	s0,16(sp)
    80003a6a:	e426                	sd	s1,8(sp)
    80003a6c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a6e:	00022517          	auipc	a0,0x22
    80003a72:	6fa50513          	addi	a0,a0,1786 # 80026168 <ftable>
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	b70080e7          	jalr	-1168(ra) # 800065e6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a7e:	00022497          	auipc	s1,0x22
    80003a82:	70248493          	addi	s1,s1,1794 # 80026180 <ftable+0x18>
    80003a86:	00023717          	auipc	a4,0x23
    80003a8a:	69a70713          	addi	a4,a4,1690 # 80027120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a8e:	40dc                	lw	a5,4(s1)
    80003a90:	cf99                	beqz	a5,80003aae <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a92:	02848493          	addi	s1,s1,40
    80003a96:	fee49ce3          	bne	s1,a4,80003a8e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a9a:	00022517          	auipc	a0,0x22
    80003a9e:	6ce50513          	addi	a0,a0,1742 # 80026168 <ftable>
    80003aa2:	00003097          	auipc	ra,0x3
    80003aa6:	bf8080e7          	jalr	-1032(ra) # 8000669a <release>
  return 0;
    80003aaa:	4481                	li	s1,0
    80003aac:	a819                	j	80003ac2 <filealloc+0x5e>
      f->ref = 1;
    80003aae:	4785                	li	a5,1
    80003ab0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ab2:	00022517          	auipc	a0,0x22
    80003ab6:	6b650513          	addi	a0,a0,1718 # 80026168 <ftable>
    80003aba:	00003097          	auipc	ra,0x3
    80003abe:	be0080e7          	jalr	-1056(ra) # 8000669a <release>
}
    80003ac2:	8526                	mv	a0,s1
    80003ac4:	60e2                	ld	ra,24(sp)
    80003ac6:	6442                	ld	s0,16(sp)
    80003ac8:	64a2                	ld	s1,8(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret

0000000080003ace <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ace:	1101                	addi	sp,sp,-32
    80003ad0:	ec06                	sd	ra,24(sp)
    80003ad2:	e822                	sd	s0,16(sp)
    80003ad4:	e426                	sd	s1,8(sp)
    80003ad6:	1000                	addi	s0,sp,32
    80003ad8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ada:	00022517          	auipc	a0,0x22
    80003ade:	68e50513          	addi	a0,a0,1678 # 80026168 <ftable>
    80003ae2:	00003097          	auipc	ra,0x3
    80003ae6:	b04080e7          	jalr	-1276(ra) # 800065e6 <acquire>
  if(f->ref < 1)
    80003aea:	40dc                	lw	a5,4(s1)
    80003aec:	02f05263          	blez	a5,80003b10 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003af0:	2785                	addiw	a5,a5,1
    80003af2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003af4:	00022517          	auipc	a0,0x22
    80003af8:	67450513          	addi	a0,a0,1652 # 80026168 <ftable>
    80003afc:	00003097          	auipc	ra,0x3
    80003b00:	b9e080e7          	jalr	-1122(ra) # 8000669a <release>
  return f;
}
    80003b04:	8526                	mv	a0,s1
    80003b06:	60e2                	ld	ra,24(sp)
    80003b08:	6442                	ld	s0,16(sp)
    80003b0a:	64a2                	ld	s1,8(sp)
    80003b0c:	6105                	addi	sp,sp,32
    80003b0e:	8082                	ret
    panic("filedup");
    80003b10:	00005517          	auipc	a0,0x5
    80003b14:	9c850513          	addi	a0,a0,-1592 # 800084d8 <etext+0x4d8>
    80003b18:	00002097          	auipc	ra,0x2
    80003b1c:	554080e7          	jalr	1364(ra) # 8000606c <panic>

0000000080003b20 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b20:	7139                	addi	sp,sp,-64
    80003b22:	fc06                	sd	ra,56(sp)
    80003b24:	f822                	sd	s0,48(sp)
    80003b26:	f426                	sd	s1,40(sp)
    80003b28:	0080                	addi	s0,sp,64
    80003b2a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b2c:	00022517          	auipc	a0,0x22
    80003b30:	63c50513          	addi	a0,a0,1596 # 80026168 <ftable>
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	ab2080e7          	jalr	-1358(ra) # 800065e6 <acquire>
  if(f->ref < 1)
    80003b3c:	40dc                	lw	a5,4(s1)
    80003b3e:	04f05c63          	blez	a5,80003b96 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003b42:	37fd                	addiw	a5,a5,-1
    80003b44:	0007871b          	sext.w	a4,a5
    80003b48:	c0dc                	sw	a5,4(s1)
    80003b4a:	06e04263          	bgtz	a4,80003bae <fileclose+0x8e>
    80003b4e:	f04a                	sd	s2,32(sp)
    80003b50:	ec4e                	sd	s3,24(sp)
    80003b52:	e852                	sd	s4,16(sp)
    80003b54:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b56:	0004a903          	lw	s2,0(s1)
    80003b5a:	0094ca83          	lbu	s5,9(s1)
    80003b5e:	0104ba03          	ld	s4,16(s1)
    80003b62:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b66:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b6a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b6e:	00022517          	auipc	a0,0x22
    80003b72:	5fa50513          	addi	a0,a0,1530 # 80026168 <ftable>
    80003b76:	00003097          	auipc	ra,0x3
    80003b7a:	b24080e7          	jalr	-1244(ra) # 8000669a <release>

  if(ff.type == FD_PIPE){
    80003b7e:	4785                	li	a5,1
    80003b80:	04f90463          	beq	s2,a5,80003bc8 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b84:	3979                	addiw	s2,s2,-2
    80003b86:	4785                	li	a5,1
    80003b88:	0527fb63          	bgeu	a5,s2,80003bde <fileclose+0xbe>
    80003b8c:	7902                	ld	s2,32(sp)
    80003b8e:	69e2                	ld	s3,24(sp)
    80003b90:	6a42                	ld	s4,16(sp)
    80003b92:	6aa2                	ld	s5,8(sp)
    80003b94:	a02d                	j	80003bbe <fileclose+0x9e>
    80003b96:	f04a                	sd	s2,32(sp)
    80003b98:	ec4e                	sd	s3,24(sp)
    80003b9a:	e852                	sd	s4,16(sp)
    80003b9c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b9e:	00005517          	auipc	a0,0x5
    80003ba2:	94250513          	addi	a0,a0,-1726 # 800084e0 <etext+0x4e0>
    80003ba6:	00002097          	auipc	ra,0x2
    80003baa:	4c6080e7          	jalr	1222(ra) # 8000606c <panic>
    release(&ftable.lock);
    80003bae:	00022517          	auipc	a0,0x22
    80003bb2:	5ba50513          	addi	a0,a0,1466 # 80026168 <ftable>
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	ae4080e7          	jalr	-1308(ra) # 8000669a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003bbe:	70e2                	ld	ra,56(sp)
    80003bc0:	7442                	ld	s0,48(sp)
    80003bc2:	74a2                	ld	s1,40(sp)
    80003bc4:	6121                	addi	sp,sp,64
    80003bc6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bc8:	85d6                	mv	a1,s5
    80003bca:	8552                	mv	a0,s4
    80003bcc:	00000097          	auipc	ra,0x0
    80003bd0:	3a2080e7          	jalr	930(ra) # 80003f6e <pipeclose>
    80003bd4:	7902                	ld	s2,32(sp)
    80003bd6:	69e2                	ld	s3,24(sp)
    80003bd8:	6a42                	ld	s4,16(sp)
    80003bda:	6aa2                	ld	s5,8(sp)
    80003bdc:	b7cd                	j	80003bbe <fileclose+0x9e>
    begin_op();
    80003bde:	00000097          	auipc	ra,0x0
    80003be2:	a78080e7          	jalr	-1416(ra) # 80003656 <begin_op>
    iput(ff.ip);
    80003be6:	854e                	mv	a0,s3
    80003be8:	fffff097          	auipc	ra,0xfffff
    80003bec:	25a080e7          	jalr	602(ra) # 80002e42 <iput>
    end_op();
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	ae0080e7          	jalr	-1312(ra) # 800036d0 <end_op>
    80003bf8:	7902                	ld	s2,32(sp)
    80003bfa:	69e2                	ld	s3,24(sp)
    80003bfc:	6a42                	ld	s4,16(sp)
    80003bfe:	6aa2                	ld	s5,8(sp)
    80003c00:	bf7d                	j	80003bbe <fileclose+0x9e>

0000000080003c02 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c02:	715d                	addi	sp,sp,-80
    80003c04:	e486                	sd	ra,72(sp)
    80003c06:	e0a2                	sd	s0,64(sp)
    80003c08:	fc26                	sd	s1,56(sp)
    80003c0a:	f44e                	sd	s3,40(sp)
    80003c0c:	0880                	addi	s0,sp,80
    80003c0e:	84aa                	mv	s1,a0
    80003c10:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c12:	ffffd097          	auipc	ra,0xffffd
    80003c16:	248080e7          	jalr	584(ra) # 80000e5a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c1a:	409c                	lw	a5,0(s1)
    80003c1c:	37f9                	addiw	a5,a5,-2
    80003c1e:	4705                	li	a4,1
    80003c20:	04f76863          	bltu	a4,a5,80003c70 <filestat+0x6e>
    80003c24:	f84a                	sd	s2,48(sp)
    80003c26:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c28:	6c88                	ld	a0,24(s1)
    80003c2a:	fffff097          	auipc	ra,0xfffff
    80003c2e:	05a080e7          	jalr	90(ra) # 80002c84 <ilock>
    stati(f->ip, &st);
    80003c32:	fb840593          	addi	a1,s0,-72
    80003c36:	6c88                	ld	a0,24(s1)
    80003c38:	fffff097          	auipc	ra,0xfffff
    80003c3c:	2da080e7          	jalr	730(ra) # 80002f12 <stati>
    iunlock(f->ip);
    80003c40:	6c88                	ld	a0,24(s1)
    80003c42:	fffff097          	auipc	ra,0xfffff
    80003c46:	108080e7          	jalr	264(ra) # 80002d4a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c4a:	46e1                	li	a3,24
    80003c4c:	fb840613          	addi	a2,s0,-72
    80003c50:	85ce                	mv	a1,s3
    80003c52:	05093503          	ld	a0,80(s2)
    80003c56:	ffffd097          	auipc	ra,0xffffd
    80003c5a:	ea8080e7          	jalr	-344(ra) # 80000afe <copyout>
    80003c5e:	41f5551b          	sraiw	a0,a0,0x1f
    80003c62:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c64:	60a6                	ld	ra,72(sp)
    80003c66:	6406                	ld	s0,64(sp)
    80003c68:	74e2                	ld	s1,56(sp)
    80003c6a:	79a2                	ld	s3,40(sp)
    80003c6c:	6161                	addi	sp,sp,80
    80003c6e:	8082                	ret
  return -1;
    80003c70:	557d                	li	a0,-1
    80003c72:	bfcd                	j	80003c64 <filestat+0x62>

0000000080003c74 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c74:	7179                	addi	sp,sp,-48
    80003c76:	f406                	sd	ra,40(sp)
    80003c78:	f022                	sd	s0,32(sp)
    80003c7a:	e84a                	sd	s2,16(sp)
    80003c7c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c7e:	00854783          	lbu	a5,8(a0)
    80003c82:	cbc5                	beqz	a5,80003d32 <fileread+0xbe>
    80003c84:	ec26                	sd	s1,24(sp)
    80003c86:	e44e                	sd	s3,8(sp)
    80003c88:	84aa                	mv	s1,a0
    80003c8a:	89ae                	mv	s3,a1
    80003c8c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c8e:	411c                	lw	a5,0(a0)
    80003c90:	4705                	li	a4,1
    80003c92:	04e78963          	beq	a5,a4,80003ce4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c96:	470d                	li	a4,3
    80003c98:	04e78f63          	beq	a5,a4,80003cf6 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c9c:	4709                	li	a4,2
    80003c9e:	08e79263          	bne	a5,a4,80003d22 <fileread+0xae>
    ilock(f->ip);
    80003ca2:	6d08                	ld	a0,24(a0)
    80003ca4:	fffff097          	auipc	ra,0xfffff
    80003ca8:	fe0080e7          	jalr	-32(ra) # 80002c84 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cac:	874a                	mv	a4,s2
    80003cae:	5094                	lw	a3,32(s1)
    80003cb0:	864e                	mv	a2,s3
    80003cb2:	4585                	li	a1,1
    80003cb4:	6c88                	ld	a0,24(s1)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	286080e7          	jalr	646(ra) # 80002f3c <readi>
    80003cbe:	892a                	mv	s2,a0
    80003cc0:	00a05563          	blez	a0,80003cca <fileread+0x56>
      f->off += r;
    80003cc4:	509c                	lw	a5,32(s1)
    80003cc6:	9fa9                	addw	a5,a5,a0
    80003cc8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cca:	6c88                	ld	a0,24(s1)
    80003ccc:	fffff097          	auipc	ra,0xfffff
    80003cd0:	07e080e7          	jalr	126(ra) # 80002d4a <iunlock>
    80003cd4:	64e2                	ld	s1,24(sp)
    80003cd6:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003cd8:	854a                	mv	a0,s2
    80003cda:	70a2                	ld	ra,40(sp)
    80003cdc:	7402                	ld	s0,32(sp)
    80003cde:	6942                	ld	s2,16(sp)
    80003ce0:	6145                	addi	sp,sp,48
    80003ce2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ce4:	6908                	ld	a0,16(a0)
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	3fa080e7          	jalr	1018(ra) # 800040e0 <piperead>
    80003cee:	892a                	mv	s2,a0
    80003cf0:	64e2                	ld	s1,24(sp)
    80003cf2:	69a2                	ld	s3,8(sp)
    80003cf4:	b7d5                	j	80003cd8 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cf6:	02451783          	lh	a5,36(a0)
    80003cfa:	03079693          	slli	a3,a5,0x30
    80003cfe:	92c1                	srli	a3,a3,0x30
    80003d00:	4725                	li	a4,9
    80003d02:	02d76a63          	bltu	a4,a3,80003d36 <fileread+0xc2>
    80003d06:	0792                	slli	a5,a5,0x4
    80003d08:	00022717          	auipc	a4,0x22
    80003d0c:	3c070713          	addi	a4,a4,960 # 800260c8 <devsw>
    80003d10:	97ba                	add	a5,a5,a4
    80003d12:	639c                	ld	a5,0(a5)
    80003d14:	c78d                	beqz	a5,80003d3e <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d16:	4505                	li	a0,1
    80003d18:	9782                	jalr	a5
    80003d1a:	892a                	mv	s2,a0
    80003d1c:	64e2                	ld	s1,24(sp)
    80003d1e:	69a2                	ld	s3,8(sp)
    80003d20:	bf65                	j	80003cd8 <fileread+0x64>
    panic("fileread");
    80003d22:	00004517          	auipc	a0,0x4
    80003d26:	7ce50513          	addi	a0,a0,1998 # 800084f0 <etext+0x4f0>
    80003d2a:	00002097          	auipc	ra,0x2
    80003d2e:	342080e7          	jalr	834(ra) # 8000606c <panic>
    return -1;
    80003d32:	597d                	li	s2,-1
    80003d34:	b755                	j	80003cd8 <fileread+0x64>
      return -1;
    80003d36:	597d                	li	s2,-1
    80003d38:	64e2                	ld	s1,24(sp)
    80003d3a:	69a2                	ld	s3,8(sp)
    80003d3c:	bf71                	j	80003cd8 <fileread+0x64>
    80003d3e:	597d                	li	s2,-1
    80003d40:	64e2                	ld	s1,24(sp)
    80003d42:	69a2                	ld	s3,8(sp)
    80003d44:	bf51                	j	80003cd8 <fileread+0x64>

0000000080003d46 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003d46:	00954783          	lbu	a5,9(a0)
    80003d4a:	12078963          	beqz	a5,80003e7c <filewrite+0x136>
{
    80003d4e:	715d                	addi	sp,sp,-80
    80003d50:	e486                	sd	ra,72(sp)
    80003d52:	e0a2                	sd	s0,64(sp)
    80003d54:	f84a                	sd	s2,48(sp)
    80003d56:	f052                	sd	s4,32(sp)
    80003d58:	e85a                	sd	s6,16(sp)
    80003d5a:	0880                	addi	s0,sp,80
    80003d5c:	892a                	mv	s2,a0
    80003d5e:	8b2e                	mv	s6,a1
    80003d60:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d62:	411c                	lw	a5,0(a0)
    80003d64:	4705                	li	a4,1
    80003d66:	02e78763          	beq	a5,a4,80003d94 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d6a:	470d                	li	a4,3
    80003d6c:	02e78a63          	beq	a5,a4,80003da0 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d70:	4709                	li	a4,2
    80003d72:	0ee79863          	bne	a5,a4,80003e62 <filewrite+0x11c>
    80003d76:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d78:	0cc05463          	blez	a2,80003e40 <filewrite+0xfa>
    80003d7c:	fc26                	sd	s1,56(sp)
    80003d7e:	ec56                	sd	s5,24(sp)
    80003d80:	e45e                	sd	s7,8(sp)
    80003d82:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d84:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d86:	6b85                	lui	s7,0x1
    80003d88:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d8c:	6c05                	lui	s8,0x1
    80003d8e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d92:	a851                	j	80003e26 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d94:	6908                	ld	a0,16(a0)
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	248080e7          	jalr	584(ra) # 80003fde <pipewrite>
    80003d9e:	a85d                	j	80003e54 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003da0:	02451783          	lh	a5,36(a0)
    80003da4:	03079693          	slli	a3,a5,0x30
    80003da8:	92c1                	srli	a3,a3,0x30
    80003daa:	4725                	li	a4,9
    80003dac:	0cd76a63          	bltu	a4,a3,80003e80 <filewrite+0x13a>
    80003db0:	0792                	slli	a5,a5,0x4
    80003db2:	00022717          	auipc	a4,0x22
    80003db6:	31670713          	addi	a4,a4,790 # 800260c8 <devsw>
    80003dba:	97ba                	add	a5,a5,a4
    80003dbc:	679c                	ld	a5,8(a5)
    80003dbe:	c3f9                	beqz	a5,80003e84 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003dc0:	4505                	li	a0,1
    80003dc2:	9782                	jalr	a5
    80003dc4:	a841                	j	80003e54 <filewrite+0x10e>
      if(n1 > max)
    80003dc6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	88c080e7          	jalr	-1908(ra) # 80003656 <begin_op>
      ilock(f->ip);
    80003dd2:	01893503          	ld	a0,24(s2)
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	eae080e7          	jalr	-338(ra) # 80002c84 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dde:	8756                	mv	a4,s5
    80003de0:	02092683          	lw	a3,32(s2)
    80003de4:	01698633          	add	a2,s3,s6
    80003de8:	4585                	li	a1,1
    80003dea:	01893503          	ld	a0,24(s2)
    80003dee:	fffff097          	auipc	ra,0xfffff
    80003df2:	252080e7          	jalr	594(ra) # 80003040 <writei>
    80003df6:	84aa                	mv	s1,a0
    80003df8:	00a05763          	blez	a0,80003e06 <filewrite+0xc0>
        f->off += r;
    80003dfc:	02092783          	lw	a5,32(s2)
    80003e00:	9fa9                	addw	a5,a5,a0
    80003e02:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e06:	01893503          	ld	a0,24(s2)
    80003e0a:	fffff097          	auipc	ra,0xfffff
    80003e0e:	f40080e7          	jalr	-192(ra) # 80002d4a <iunlock>
      end_op();
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	8be080e7          	jalr	-1858(ra) # 800036d0 <end_op>

      if(r != n1){
    80003e1a:	029a9563          	bne	s5,s1,80003e44 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003e1e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e22:	0149da63          	bge	s3,s4,80003e36 <filewrite+0xf0>
      int n1 = n - i;
    80003e26:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003e2a:	0004879b          	sext.w	a5,s1
    80003e2e:	f8fbdce3          	bge	s7,a5,80003dc6 <filewrite+0x80>
    80003e32:	84e2                	mv	s1,s8
    80003e34:	bf49                	j	80003dc6 <filewrite+0x80>
    80003e36:	74e2                	ld	s1,56(sp)
    80003e38:	6ae2                	ld	s5,24(sp)
    80003e3a:	6ba2                	ld	s7,8(sp)
    80003e3c:	6c02                	ld	s8,0(sp)
    80003e3e:	a039                	j	80003e4c <filewrite+0x106>
    int i = 0;
    80003e40:	4981                	li	s3,0
    80003e42:	a029                	j	80003e4c <filewrite+0x106>
    80003e44:	74e2                	ld	s1,56(sp)
    80003e46:	6ae2                	ld	s5,24(sp)
    80003e48:	6ba2                	ld	s7,8(sp)
    80003e4a:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003e4c:	033a1e63          	bne	s4,s3,80003e88 <filewrite+0x142>
    80003e50:	8552                	mv	a0,s4
    80003e52:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e54:	60a6                	ld	ra,72(sp)
    80003e56:	6406                	ld	s0,64(sp)
    80003e58:	7942                	ld	s2,48(sp)
    80003e5a:	7a02                	ld	s4,32(sp)
    80003e5c:	6b42                	ld	s6,16(sp)
    80003e5e:	6161                	addi	sp,sp,80
    80003e60:	8082                	ret
    80003e62:	fc26                	sd	s1,56(sp)
    80003e64:	f44e                	sd	s3,40(sp)
    80003e66:	ec56                	sd	s5,24(sp)
    80003e68:	e45e                	sd	s7,8(sp)
    80003e6a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e6c:	00004517          	auipc	a0,0x4
    80003e70:	69450513          	addi	a0,a0,1684 # 80008500 <etext+0x500>
    80003e74:	00002097          	auipc	ra,0x2
    80003e78:	1f8080e7          	jalr	504(ra) # 8000606c <panic>
    return -1;
    80003e7c:	557d                	li	a0,-1
}
    80003e7e:	8082                	ret
      return -1;
    80003e80:	557d                	li	a0,-1
    80003e82:	bfc9                	j	80003e54 <filewrite+0x10e>
    80003e84:	557d                	li	a0,-1
    80003e86:	b7f9                	j	80003e54 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e88:	557d                	li	a0,-1
    80003e8a:	79a2                	ld	s3,40(sp)
    80003e8c:	b7e1                	j	80003e54 <filewrite+0x10e>

0000000080003e8e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e8e:	7179                	addi	sp,sp,-48
    80003e90:	f406                	sd	ra,40(sp)
    80003e92:	f022                	sd	s0,32(sp)
    80003e94:	ec26                	sd	s1,24(sp)
    80003e96:	e052                	sd	s4,0(sp)
    80003e98:	1800                	addi	s0,sp,48
    80003e9a:	84aa                	mv	s1,a0
    80003e9c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e9e:	0005b023          	sd	zero,0(a1)
    80003ea2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	bbe080e7          	jalr	-1090(ra) # 80003a64 <filealloc>
    80003eae:	e088                	sd	a0,0(s1)
    80003eb0:	cd49                	beqz	a0,80003f4a <pipealloc+0xbc>
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	bb2080e7          	jalr	-1102(ra) # 80003a64 <filealloc>
    80003eba:	00aa3023          	sd	a0,0(s4)
    80003ebe:	c141                	beqz	a0,80003f3e <pipealloc+0xb0>
    80003ec0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ec2:	ffffc097          	auipc	ra,0xffffc
    80003ec6:	258080e7          	jalr	600(ra) # 8000011a <kalloc>
    80003eca:	892a                	mv	s2,a0
    80003ecc:	c13d                	beqz	a0,80003f32 <pipealloc+0xa4>
    80003ece:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003ed0:	4985                	li	s3,1
    80003ed2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ed6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003eda:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ede:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ee2:	00004597          	auipc	a1,0x4
    80003ee6:	62e58593          	addi	a1,a1,1582 # 80008510 <etext+0x510>
    80003eea:	00002097          	auipc	ra,0x2
    80003eee:	66c080e7          	jalr	1644(ra) # 80006556 <initlock>
  (*f0)->type = FD_PIPE;
    80003ef2:	609c                	ld	a5,0(s1)
    80003ef4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ef8:	609c                	ld	a5,0(s1)
    80003efa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003efe:	609c                	ld	a5,0(s1)
    80003f00:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f04:	609c                	ld	a5,0(s1)
    80003f06:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f0a:	000a3783          	ld	a5,0(s4)
    80003f0e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f12:	000a3783          	ld	a5,0(s4)
    80003f16:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f1a:	000a3783          	ld	a5,0(s4)
    80003f1e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f22:	000a3783          	ld	a5,0(s4)
    80003f26:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f2a:	4501                	li	a0,0
    80003f2c:	6942                	ld	s2,16(sp)
    80003f2e:	69a2                	ld	s3,8(sp)
    80003f30:	a03d                	j	80003f5e <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f32:	6088                	ld	a0,0(s1)
    80003f34:	c119                	beqz	a0,80003f3a <pipealloc+0xac>
    80003f36:	6942                	ld	s2,16(sp)
    80003f38:	a029                	j	80003f42 <pipealloc+0xb4>
    80003f3a:	6942                	ld	s2,16(sp)
    80003f3c:	a039                	j	80003f4a <pipealloc+0xbc>
    80003f3e:	6088                	ld	a0,0(s1)
    80003f40:	c50d                	beqz	a0,80003f6a <pipealloc+0xdc>
    fileclose(*f0);
    80003f42:	00000097          	auipc	ra,0x0
    80003f46:	bde080e7          	jalr	-1058(ra) # 80003b20 <fileclose>
  if(*f1)
    80003f4a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f4e:	557d                	li	a0,-1
  if(*f1)
    80003f50:	c799                	beqz	a5,80003f5e <pipealloc+0xd0>
    fileclose(*f1);
    80003f52:	853e                	mv	a0,a5
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	bcc080e7          	jalr	-1076(ra) # 80003b20 <fileclose>
  return -1;
    80003f5c:	557d                	li	a0,-1
}
    80003f5e:	70a2                	ld	ra,40(sp)
    80003f60:	7402                	ld	s0,32(sp)
    80003f62:	64e2                	ld	s1,24(sp)
    80003f64:	6a02                	ld	s4,0(sp)
    80003f66:	6145                	addi	sp,sp,48
    80003f68:	8082                	ret
  return -1;
    80003f6a:	557d                	li	a0,-1
    80003f6c:	bfcd                	j	80003f5e <pipealloc+0xd0>

0000000080003f6e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f6e:	1101                	addi	sp,sp,-32
    80003f70:	ec06                	sd	ra,24(sp)
    80003f72:	e822                	sd	s0,16(sp)
    80003f74:	e426                	sd	s1,8(sp)
    80003f76:	e04a                	sd	s2,0(sp)
    80003f78:	1000                	addi	s0,sp,32
    80003f7a:	84aa                	mv	s1,a0
    80003f7c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f7e:	00002097          	auipc	ra,0x2
    80003f82:	668080e7          	jalr	1640(ra) # 800065e6 <acquire>
  if(writable){
    80003f86:	02090d63          	beqz	s2,80003fc0 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f8a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f8e:	21848513          	addi	a0,s1,536
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	754080e7          	jalr	1876(ra) # 800016e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f9a:	2204b783          	ld	a5,544(s1)
    80003f9e:	eb95                	bnez	a5,80003fd2 <pipeclose+0x64>
    release(&pi->lock);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	00002097          	auipc	ra,0x2
    80003fa6:	6f8080e7          	jalr	1784(ra) # 8000669a <release>
    kfree((char*)pi);
    80003faa:	8526                	mv	a0,s1
    80003fac:	ffffc097          	auipc	ra,0xffffc
    80003fb0:	070080e7          	jalr	112(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fb4:	60e2                	ld	ra,24(sp)
    80003fb6:	6442                	ld	s0,16(sp)
    80003fb8:	64a2                	ld	s1,8(sp)
    80003fba:	6902                	ld	s2,0(sp)
    80003fbc:	6105                	addi	sp,sp,32
    80003fbe:	8082                	ret
    pi->readopen = 0;
    80003fc0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fc4:	21c48513          	addi	a0,s1,540
    80003fc8:	ffffd097          	auipc	ra,0xffffd
    80003fcc:	71e080e7          	jalr	1822(ra) # 800016e6 <wakeup>
    80003fd0:	b7e9                	j	80003f9a <pipeclose+0x2c>
    release(&pi->lock);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	00002097          	auipc	ra,0x2
    80003fd8:	6c6080e7          	jalr	1734(ra) # 8000669a <release>
}
    80003fdc:	bfe1                	j	80003fb4 <pipeclose+0x46>

0000000080003fde <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fde:	711d                	addi	sp,sp,-96
    80003fe0:	ec86                	sd	ra,88(sp)
    80003fe2:	e8a2                	sd	s0,80(sp)
    80003fe4:	e4a6                	sd	s1,72(sp)
    80003fe6:	e0ca                	sd	s2,64(sp)
    80003fe8:	fc4e                	sd	s3,56(sp)
    80003fea:	f852                	sd	s4,48(sp)
    80003fec:	f456                	sd	s5,40(sp)
    80003fee:	1080                	addi	s0,sp,96
    80003ff0:	84aa                	mv	s1,a0
    80003ff2:	8aae                	mv	s5,a1
    80003ff4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	e64080e7          	jalr	-412(ra) # 80000e5a <myproc>
    80003ffe:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004000:	8526                	mv	a0,s1
    80004002:	00002097          	auipc	ra,0x2
    80004006:	5e4080e7          	jalr	1508(ra) # 800065e6 <acquire>
  while(i < n){
    8000400a:	0d405563          	blez	s4,800040d4 <pipewrite+0xf6>
    8000400e:	f05a                	sd	s6,32(sp)
    80004010:	ec5e                	sd	s7,24(sp)
    80004012:	e862                	sd	s8,16(sp)
  int i = 0;
    80004014:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004016:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004018:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000401c:	21c48b93          	addi	s7,s1,540
    80004020:	a089                	j	80004062 <pipewrite+0x84>
      release(&pi->lock);
    80004022:	8526                	mv	a0,s1
    80004024:	00002097          	auipc	ra,0x2
    80004028:	676080e7          	jalr	1654(ra) # 8000669a <release>
      return -1;
    8000402c:	597d                	li	s2,-1
    8000402e:	7b02                	ld	s6,32(sp)
    80004030:	6be2                	ld	s7,24(sp)
    80004032:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004034:	854a                	mv	a0,s2
    80004036:	60e6                	ld	ra,88(sp)
    80004038:	6446                	ld	s0,80(sp)
    8000403a:	64a6                	ld	s1,72(sp)
    8000403c:	6906                	ld	s2,64(sp)
    8000403e:	79e2                	ld	s3,56(sp)
    80004040:	7a42                	ld	s4,48(sp)
    80004042:	7aa2                	ld	s5,40(sp)
    80004044:	6125                	addi	sp,sp,96
    80004046:	8082                	ret
      wakeup(&pi->nread);
    80004048:	8562                	mv	a0,s8
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	69c080e7          	jalr	1692(ra) # 800016e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004052:	85a6                	mv	a1,s1
    80004054:	855e                	mv	a0,s7
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	504080e7          	jalr	1284(ra) # 8000155a <sleep>
  while(i < n){
    8000405e:	05495c63          	bge	s2,s4,800040b6 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004062:	2204a783          	lw	a5,544(s1)
    80004066:	dfd5                	beqz	a5,80004022 <pipewrite+0x44>
    80004068:	0289a783          	lw	a5,40(s3)
    8000406c:	fbdd                	bnez	a5,80004022 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000406e:	2184a783          	lw	a5,536(s1)
    80004072:	21c4a703          	lw	a4,540(s1)
    80004076:	2007879b          	addiw	a5,a5,512
    8000407a:	fcf707e3          	beq	a4,a5,80004048 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000407e:	4685                	li	a3,1
    80004080:	01590633          	add	a2,s2,s5
    80004084:	faf40593          	addi	a1,s0,-81
    80004088:	0509b503          	ld	a0,80(s3)
    8000408c:	ffffd097          	auipc	ra,0xffffd
    80004090:	afe080e7          	jalr	-1282(ra) # 80000b8a <copyin>
    80004094:	05650263          	beq	a0,s6,800040d8 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004098:	21c4a783          	lw	a5,540(s1)
    8000409c:	0017871b          	addiw	a4,a5,1
    800040a0:	20e4ae23          	sw	a4,540(s1)
    800040a4:	1ff7f793          	andi	a5,a5,511
    800040a8:	97a6                	add	a5,a5,s1
    800040aa:	faf44703          	lbu	a4,-81(s0)
    800040ae:	00e78c23          	sb	a4,24(a5)
      i++;
    800040b2:	2905                	addiw	s2,s2,1
    800040b4:	b76d                	j	8000405e <pipewrite+0x80>
    800040b6:	7b02                	ld	s6,32(sp)
    800040b8:	6be2                	ld	s7,24(sp)
    800040ba:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800040bc:	21848513          	addi	a0,s1,536
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	626080e7          	jalr	1574(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    800040c8:	8526                	mv	a0,s1
    800040ca:	00002097          	auipc	ra,0x2
    800040ce:	5d0080e7          	jalr	1488(ra) # 8000669a <release>
  return i;
    800040d2:	b78d                	j	80004034 <pipewrite+0x56>
  int i = 0;
    800040d4:	4901                	li	s2,0
    800040d6:	b7dd                	j	800040bc <pipewrite+0xde>
    800040d8:	7b02                	ld	s6,32(sp)
    800040da:	6be2                	ld	s7,24(sp)
    800040dc:	6c42                	ld	s8,16(sp)
    800040de:	bff9                	j	800040bc <pipewrite+0xde>

00000000800040e0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040e0:	715d                	addi	sp,sp,-80
    800040e2:	e486                	sd	ra,72(sp)
    800040e4:	e0a2                	sd	s0,64(sp)
    800040e6:	fc26                	sd	s1,56(sp)
    800040e8:	f84a                	sd	s2,48(sp)
    800040ea:	f44e                	sd	s3,40(sp)
    800040ec:	f052                	sd	s4,32(sp)
    800040ee:	ec56                	sd	s5,24(sp)
    800040f0:	0880                	addi	s0,sp,80
    800040f2:	84aa                	mv	s1,a0
    800040f4:	892e                	mv	s2,a1
    800040f6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	d62080e7          	jalr	-670(ra) # 80000e5a <myproc>
    80004100:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	4e2080e7          	jalr	1250(ra) # 800065e6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000410c:	2184a703          	lw	a4,536(s1)
    80004110:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004114:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004118:	02f71663          	bne	a4,a5,80004144 <piperead+0x64>
    8000411c:	2244a783          	lw	a5,548(s1)
    80004120:	cb9d                	beqz	a5,80004156 <piperead+0x76>
    if(pr->killed){
    80004122:	028a2783          	lw	a5,40(s4)
    80004126:	e38d                	bnez	a5,80004148 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004128:	85a6                	mv	a1,s1
    8000412a:	854e                	mv	a0,s3
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	42e080e7          	jalr	1070(ra) # 8000155a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004134:	2184a703          	lw	a4,536(s1)
    80004138:	21c4a783          	lw	a5,540(s1)
    8000413c:	fef700e3          	beq	a4,a5,8000411c <piperead+0x3c>
    80004140:	e85a                	sd	s6,16(sp)
    80004142:	a819                	j	80004158 <piperead+0x78>
    80004144:	e85a                	sd	s6,16(sp)
    80004146:	a809                	j	80004158 <piperead+0x78>
      release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	550080e7          	jalr	1360(ra) # 8000669a <release>
      return -1;
    80004152:	59fd                	li	s3,-1
    80004154:	a0a5                	j	800041bc <piperead+0xdc>
    80004156:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004158:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000415a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000415c:	05505463          	blez	s5,800041a4 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004160:	2184a783          	lw	a5,536(s1)
    80004164:	21c4a703          	lw	a4,540(s1)
    80004168:	02f70e63          	beq	a4,a5,800041a4 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000416c:	0017871b          	addiw	a4,a5,1
    80004170:	20e4ac23          	sw	a4,536(s1)
    80004174:	1ff7f793          	andi	a5,a5,511
    80004178:	97a6                	add	a5,a5,s1
    8000417a:	0187c783          	lbu	a5,24(a5)
    8000417e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004182:	4685                	li	a3,1
    80004184:	fbf40613          	addi	a2,s0,-65
    80004188:	85ca                	mv	a1,s2
    8000418a:	050a3503          	ld	a0,80(s4)
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	970080e7          	jalr	-1680(ra) # 80000afe <copyout>
    80004196:	01650763          	beq	a0,s6,800041a4 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419a:	2985                	addiw	s3,s3,1
    8000419c:	0905                	addi	s2,s2,1
    8000419e:	fd3a91e3          	bne	s5,s3,80004160 <piperead+0x80>
    800041a2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041a4:	21c48513          	addi	a0,s1,540
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	53e080e7          	jalr	1342(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    800041b0:	8526                	mv	a0,s1
    800041b2:	00002097          	auipc	ra,0x2
    800041b6:	4e8080e7          	jalr	1256(ra) # 8000669a <release>
    800041ba:	6b42                	ld	s6,16(sp)
  return i;
}
    800041bc:	854e                	mv	a0,s3
    800041be:	60a6                	ld	ra,72(sp)
    800041c0:	6406                	ld	s0,64(sp)
    800041c2:	74e2                	ld	s1,56(sp)
    800041c4:	7942                	ld	s2,48(sp)
    800041c6:	79a2                	ld	s3,40(sp)
    800041c8:	7a02                	ld	s4,32(sp)
    800041ca:	6ae2                	ld	s5,24(sp)
    800041cc:	6161                	addi	sp,sp,80
    800041ce:	8082                	ret

00000000800041d0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041d0:	df010113          	addi	sp,sp,-528
    800041d4:	20113423          	sd	ra,520(sp)
    800041d8:	20813023          	sd	s0,512(sp)
    800041dc:	ffa6                	sd	s1,504(sp)
    800041de:	fbca                	sd	s2,496(sp)
    800041e0:	0c00                	addi	s0,sp,528
    800041e2:	892a                	mv	s2,a0
    800041e4:	dea43c23          	sd	a0,-520(s0)
    800041e8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041ec:	ffffd097          	auipc	ra,0xffffd
    800041f0:	c6e080e7          	jalr	-914(ra) # 80000e5a <myproc>
    800041f4:	84aa                	mv	s1,a0

  begin_op();
    800041f6:	fffff097          	auipc	ra,0xfffff
    800041fa:	460080e7          	jalr	1120(ra) # 80003656 <begin_op>

  if((ip = namei(path)) == 0){
    800041fe:	854a                	mv	a0,s2
    80004200:	fffff097          	auipc	ra,0xfffff
    80004204:	256080e7          	jalr	598(ra) # 80003456 <namei>
    80004208:	c135                	beqz	a0,8000426c <exec+0x9c>
    8000420a:	f3d2                	sd	s4,480(sp)
    8000420c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000420e:	fffff097          	auipc	ra,0xfffff
    80004212:	a76080e7          	jalr	-1418(ra) # 80002c84 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004216:	04000713          	li	a4,64
    8000421a:	4681                	li	a3,0
    8000421c:	e5040613          	addi	a2,s0,-432
    80004220:	4581                	li	a1,0
    80004222:	8552                	mv	a0,s4
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	d18080e7          	jalr	-744(ra) # 80002f3c <readi>
    8000422c:	04000793          	li	a5,64
    80004230:	00f51a63          	bne	a0,a5,80004244 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004234:	e5042703          	lw	a4,-432(s0)
    80004238:	464c47b7          	lui	a5,0x464c4
    8000423c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004240:	02f70c63          	beq	a4,a5,80004278 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004244:	8552                	mv	a0,s4
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	ca4080e7          	jalr	-860(ra) # 80002eea <iunlockput>
    end_op();
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	482080e7          	jalr	1154(ra) # 800036d0 <end_op>
  }
  return -1;
    80004256:	557d                	li	a0,-1
    80004258:	7a1e                	ld	s4,480(sp)
}
    8000425a:	20813083          	ld	ra,520(sp)
    8000425e:	20013403          	ld	s0,512(sp)
    80004262:	74fe                	ld	s1,504(sp)
    80004264:	795e                	ld	s2,496(sp)
    80004266:	21010113          	addi	sp,sp,528
    8000426a:	8082                	ret
    end_op();
    8000426c:	fffff097          	auipc	ra,0xfffff
    80004270:	464080e7          	jalr	1124(ra) # 800036d0 <end_op>
    return -1;
    80004274:	557d                	li	a0,-1
    80004276:	b7d5                	j	8000425a <exec+0x8a>
    80004278:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000427a:	8526                	mv	a0,s1
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	ca2080e7          	jalr	-862(ra) # 80000f1e <proc_pagetable>
    80004284:	8b2a                	mv	s6,a0
    80004286:	30050563          	beqz	a0,80004590 <exec+0x3c0>
    8000428a:	f7ce                	sd	s3,488(sp)
    8000428c:	efd6                	sd	s5,472(sp)
    8000428e:	e7de                	sd	s7,456(sp)
    80004290:	e3e2                	sd	s8,448(sp)
    80004292:	ff66                	sd	s9,440(sp)
    80004294:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004296:	e7042d03          	lw	s10,-400(s0)
    8000429a:	e8845783          	lhu	a5,-376(s0)
    8000429e:	14078563          	beqz	a5,800043e8 <exec+0x218>
    800042a2:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042a4:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042a6:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800042a8:	6c85                	lui	s9,0x1
    800042aa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042ae:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800042b2:	6a85                	lui	s5,0x1
    800042b4:	a0b5                	j	80004320 <exec+0x150>
      panic("loadseg: address should exist");
    800042b6:	00004517          	auipc	a0,0x4
    800042ba:	26250513          	addi	a0,a0,610 # 80008518 <etext+0x518>
    800042be:	00002097          	auipc	ra,0x2
    800042c2:	dae080e7          	jalr	-594(ra) # 8000606c <panic>
    if(sz - i < PGSIZE)
    800042c6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042c8:	8726                	mv	a4,s1
    800042ca:	012c06bb          	addw	a3,s8,s2
    800042ce:	4581                	li	a1,0
    800042d0:	8552                	mv	a0,s4
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	c6a080e7          	jalr	-918(ra) # 80002f3c <readi>
    800042da:	2501                	sext.w	a0,a0
    800042dc:	26a49e63          	bne	s1,a0,80004558 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800042e0:	012a893b          	addw	s2,s5,s2
    800042e4:	03397563          	bgeu	s2,s3,8000430e <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800042e8:	02091593          	slli	a1,s2,0x20
    800042ec:	9181                	srli	a1,a1,0x20
    800042ee:	95de                	add	a1,a1,s7
    800042f0:	855a                	mv	a0,s6
    800042f2:	ffffc097          	auipc	ra,0xffffc
    800042f6:	206080e7          	jalr	518(ra) # 800004f8 <walkaddr>
    800042fa:	862a                	mv	a2,a0
    if(pa == 0)
    800042fc:	dd4d                	beqz	a0,800042b6 <exec+0xe6>
    if(sz - i < PGSIZE)
    800042fe:	412984bb          	subw	s1,s3,s2
    80004302:	0004879b          	sext.w	a5,s1
    80004306:	fcfcf0e3          	bgeu	s9,a5,800042c6 <exec+0xf6>
    8000430a:	84d6                	mv	s1,s5
    8000430c:	bf6d                	j	800042c6 <exec+0xf6>
    sz = sz1;
    8000430e:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004312:	2d85                	addiw	s11,s11,1
    80004314:	038d0d1b          	addiw	s10,s10,56
    80004318:	e8845783          	lhu	a5,-376(s0)
    8000431c:	06fddf63          	bge	s11,a5,8000439a <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004320:	2d01                	sext.w	s10,s10
    80004322:	03800713          	li	a4,56
    80004326:	86ea                	mv	a3,s10
    80004328:	e1840613          	addi	a2,s0,-488
    8000432c:	4581                	li	a1,0
    8000432e:	8552                	mv	a0,s4
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	c0c080e7          	jalr	-1012(ra) # 80002f3c <readi>
    80004338:	03800793          	li	a5,56
    8000433c:	1ef51863          	bne	a0,a5,8000452c <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    80004340:	e1842783          	lw	a5,-488(s0)
    80004344:	4705                	li	a4,1
    80004346:	fce796e3          	bne	a5,a4,80004312 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000434a:	e4043603          	ld	a2,-448(s0)
    8000434e:	e3843783          	ld	a5,-456(s0)
    80004352:	1ef66163          	bltu	a2,a5,80004534 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004356:	e2843783          	ld	a5,-472(s0)
    8000435a:	963e                	add	a2,a2,a5
    8000435c:	1ef66063          	bltu	a2,a5,8000453c <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004360:	85a6                	mv	a1,s1
    80004362:	855a                	mv	a0,s6
    80004364:	ffffc097          	auipc	ra,0xffffc
    80004368:	54a080e7          	jalr	1354(ra) # 800008ae <uvmalloc>
    8000436c:	e0a43423          	sd	a0,-504(s0)
    80004370:	1c050a63          	beqz	a0,80004544 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004374:	e2843b83          	ld	s7,-472(s0)
    80004378:	df043783          	ld	a5,-528(s0)
    8000437c:	00fbf7b3          	and	a5,s7,a5
    80004380:	1c079a63          	bnez	a5,80004554 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004384:	e2042c03          	lw	s8,-480(s0)
    80004388:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000438c:	00098463          	beqz	s3,80004394 <exec+0x1c4>
    80004390:	4901                	li	s2,0
    80004392:	bf99                	j	800042e8 <exec+0x118>
    sz = sz1;
    80004394:	e0843483          	ld	s1,-504(s0)
    80004398:	bfad                	j	80004312 <exec+0x142>
    8000439a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000439c:	8552                	mv	a0,s4
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	b4c080e7          	jalr	-1204(ra) # 80002eea <iunlockput>
  end_op();
    800043a6:	fffff097          	auipc	ra,0xfffff
    800043aa:	32a080e7          	jalr	810(ra) # 800036d0 <end_op>
  p = myproc();
    800043ae:	ffffd097          	auipc	ra,0xffffd
    800043b2:	aac080e7          	jalr	-1364(ra) # 80000e5a <myproc>
    800043b6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043b8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800043bc:	6985                	lui	s3,0x1
    800043be:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800043c0:	99a6                	add	s3,s3,s1
    800043c2:	77fd                	lui	a5,0xfffff
    800043c4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043c8:	6609                	lui	a2,0x2
    800043ca:	964e                	add	a2,a2,s3
    800043cc:	85ce                	mv	a1,s3
    800043ce:	855a                	mv	a0,s6
    800043d0:	ffffc097          	auipc	ra,0xffffc
    800043d4:	4de080e7          	jalr	1246(ra) # 800008ae <uvmalloc>
    800043d8:	892a                	mv	s2,a0
    800043da:	e0a43423          	sd	a0,-504(s0)
    800043de:	e519                	bnez	a0,800043ec <exec+0x21c>
  if(pagetable)
    800043e0:	e1343423          	sd	s3,-504(s0)
    800043e4:	4a01                	li	s4,0
    800043e6:	aa95                	j	8000455a <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043e8:	4481                	li	s1,0
    800043ea:	bf4d                	j	8000439c <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043ec:	75f9                	lui	a1,0xffffe
    800043ee:	95aa                	add	a1,a1,a0
    800043f0:	855a                	mv	a0,s6
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	6da080e7          	jalr	1754(ra) # 80000acc <uvmclear>
  stackbase = sp - PGSIZE;
    800043fa:	7bfd                	lui	s7,0xfffff
    800043fc:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800043fe:	e0043783          	ld	a5,-512(s0)
    80004402:	6388                	ld	a0,0(a5)
    80004404:	c52d                	beqz	a0,8000446e <exec+0x29e>
    80004406:	e9040993          	addi	s3,s0,-368
    8000440a:	f9040c13          	addi	s8,s0,-112
    8000440e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	ede080e7          	jalr	-290(ra) # 800002ee <strlen>
    80004418:	0015079b          	addiw	a5,a0,1
    8000441c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004420:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004424:	13796463          	bltu	s2,s7,8000454c <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004428:	e0043d03          	ld	s10,-512(s0)
    8000442c:	000d3a03          	ld	s4,0(s10)
    80004430:	8552                	mv	a0,s4
    80004432:	ffffc097          	auipc	ra,0xffffc
    80004436:	ebc080e7          	jalr	-324(ra) # 800002ee <strlen>
    8000443a:	0015069b          	addiw	a3,a0,1
    8000443e:	8652                	mv	a2,s4
    80004440:	85ca                	mv	a1,s2
    80004442:	855a                	mv	a0,s6
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	6ba080e7          	jalr	1722(ra) # 80000afe <copyout>
    8000444c:	10054263          	bltz	a0,80004550 <exec+0x380>
    ustack[argc] = sp;
    80004450:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004454:	0485                	addi	s1,s1,1
    80004456:	008d0793          	addi	a5,s10,8
    8000445a:	e0f43023          	sd	a5,-512(s0)
    8000445e:	008d3503          	ld	a0,8(s10)
    80004462:	c909                	beqz	a0,80004474 <exec+0x2a4>
    if(argc >= MAXARG)
    80004464:	09a1                	addi	s3,s3,8
    80004466:	fb8995e3          	bne	s3,s8,80004410 <exec+0x240>
  ip = 0;
    8000446a:	4a01                	li	s4,0
    8000446c:	a0fd                	j	8000455a <exec+0x38a>
  sp = sz;
    8000446e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004472:	4481                	li	s1,0
  ustack[argc] = 0;
    80004474:	00349793          	slli	a5,s1,0x3
    80004478:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffcbd50>
    8000447c:	97a2                	add	a5,a5,s0
    8000447e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004482:	00148693          	addi	a3,s1,1
    80004486:	068e                	slli	a3,a3,0x3
    80004488:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000448c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004490:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004494:	f57966e3          	bltu	s2,s7,800043e0 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004498:	e9040613          	addi	a2,s0,-368
    8000449c:	85ca                	mv	a1,s2
    8000449e:	855a                	mv	a0,s6
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	65e080e7          	jalr	1630(ra) # 80000afe <copyout>
    800044a8:	0e054663          	bltz	a0,80004594 <exec+0x3c4>
  p->trapframe->a1 = sp;
    800044ac:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800044b0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044b4:	df843783          	ld	a5,-520(s0)
    800044b8:	0007c703          	lbu	a4,0(a5)
    800044bc:	cf11                	beqz	a4,800044d8 <exec+0x308>
    800044be:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044c0:	02f00693          	li	a3,47
    800044c4:	a039                	j	800044d2 <exec+0x302>
      last = s+1;
    800044c6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044ca:	0785                	addi	a5,a5,1
    800044cc:	fff7c703          	lbu	a4,-1(a5)
    800044d0:	c701                	beqz	a4,800044d8 <exec+0x308>
    if(*s == '/')
    800044d2:	fed71ce3          	bne	a4,a3,800044ca <exec+0x2fa>
    800044d6:	bfc5                	j	800044c6 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800044d8:	4641                	li	a2,16
    800044da:	df843583          	ld	a1,-520(s0)
    800044de:	158a8513          	addi	a0,s5,344
    800044e2:	ffffc097          	auipc	ra,0xffffc
    800044e6:	dda080e7          	jalr	-550(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800044ea:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044ee:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800044f2:	e0843783          	ld	a5,-504(s0)
    800044f6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044fa:	058ab783          	ld	a5,88(s5)
    800044fe:	e6843703          	ld	a4,-408(s0)
    80004502:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004504:	058ab783          	ld	a5,88(s5)
    80004508:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000450c:	85e6                	mv	a1,s9
    8000450e:	ffffd097          	auipc	ra,0xffffd
    80004512:	aac080e7          	jalr	-1364(ra) # 80000fba <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004516:	0004851b          	sext.w	a0,s1
    8000451a:	79be                	ld	s3,488(sp)
    8000451c:	7a1e                	ld	s4,480(sp)
    8000451e:	6afe                	ld	s5,472(sp)
    80004520:	6b5e                	ld	s6,464(sp)
    80004522:	6bbe                	ld	s7,456(sp)
    80004524:	6c1e                	ld	s8,448(sp)
    80004526:	7cfa                	ld	s9,440(sp)
    80004528:	7d5a                	ld	s10,432(sp)
    8000452a:	bb05                	j	8000425a <exec+0x8a>
    8000452c:	e0943423          	sd	s1,-504(s0)
    80004530:	7dba                	ld	s11,424(sp)
    80004532:	a025                	j	8000455a <exec+0x38a>
    80004534:	e0943423          	sd	s1,-504(s0)
    80004538:	7dba                	ld	s11,424(sp)
    8000453a:	a005                	j	8000455a <exec+0x38a>
    8000453c:	e0943423          	sd	s1,-504(s0)
    80004540:	7dba                	ld	s11,424(sp)
    80004542:	a821                	j	8000455a <exec+0x38a>
    80004544:	e0943423          	sd	s1,-504(s0)
    80004548:	7dba                	ld	s11,424(sp)
    8000454a:	a801                	j	8000455a <exec+0x38a>
  ip = 0;
    8000454c:	4a01                	li	s4,0
    8000454e:	a031                	j	8000455a <exec+0x38a>
    80004550:	4a01                	li	s4,0
  if(pagetable)
    80004552:	a021                	j	8000455a <exec+0x38a>
    80004554:	7dba                	ld	s11,424(sp)
    80004556:	a011                	j	8000455a <exec+0x38a>
    80004558:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000455a:	e0843583          	ld	a1,-504(s0)
    8000455e:	855a                	mv	a0,s6
    80004560:	ffffd097          	auipc	ra,0xffffd
    80004564:	a5a080e7          	jalr	-1446(ra) # 80000fba <proc_freepagetable>
  return -1;
    80004568:	557d                	li	a0,-1
  if(ip){
    8000456a:	000a1b63          	bnez	s4,80004580 <exec+0x3b0>
    8000456e:	79be                	ld	s3,488(sp)
    80004570:	7a1e                	ld	s4,480(sp)
    80004572:	6afe                	ld	s5,472(sp)
    80004574:	6b5e                	ld	s6,464(sp)
    80004576:	6bbe                	ld	s7,456(sp)
    80004578:	6c1e                	ld	s8,448(sp)
    8000457a:	7cfa                	ld	s9,440(sp)
    8000457c:	7d5a                	ld	s10,432(sp)
    8000457e:	b9f1                	j	8000425a <exec+0x8a>
    80004580:	79be                	ld	s3,488(sp)
    80004582:	6afe                	ld	s5,472(sp)
    80004584:	6b5e                	ld	s6,464(sp)
    80004586:	6bbe                	ld	s7,456(sp)
    80004588:	6c1e                	ld	s8,448(sp)
    8000458a:	7cfa                	ld	s9,440(sp)
    8000458c:	7d5a                	ld	s10,432(sp)
    8000458e:	b95d                	j	80004244 <exec+0x74>
    80004590:	6b5e                	ld	s6,464(sp)
    80004592:	b94d                	j	80004244 <exec+0x74>
  sz = sz1;
    80004594:	e0843983          	ld	s3,-504(s0)
    80004598:	b5a1                	j	800043e0 <exec+0x210>

000000008000459a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000459a:	7179                	addi	sp,sp,-48
    8000459c:	f406                	sd	ra,40(sp)
    8000459e:	f022                	sd	s0,32(sp)
    800045a0:	ec26                	sd	s1,24(sp)
    800045a2:	e84a                	sd	s2,16(sp)
    800045a4:	1800                	addi	s0,sp,48
    800045a6:	892e                	mv	s2,a1
    800045a8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045aa:	fdc40593          	addi	a1,s0,-36
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	b64080e7          	jalr	-1180(ra) # 80002112 <argint>
    800045b6:	04054063          	bltz	a0,800045f6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045ba:	fdc42703          	lw	a4,-36(s0)
    800045be:	47bd                	li	a5,15
    800045c0:	02e7ed63          	bltu	a5,a4,800045fa <argfd+0x60>
    800045c4:	ffffd097          	auipc	ra,0xffffd
    800045c8:	896080e7          	jalr	-1898(ra) # 80000e5a <myproc>
    800045cc:	fdc42703          	lw	a4,-36(s0)
    800045d0:	01a70793          	addi	a5,a4,26
    800045d4:	078e                	slli	a5,a5,0x3
    800045d6:	953e                	add	a0,a0,a5
    800045d8:	611c                	ld	a5,0(a0)
    800045da:	c395                	beqz	a5,800045fe <argfd+0x64>
    return -1;
  if(pfd)
    800045dc:	00090463          	beqz	s2,800045e4 <argfd+0x4a>
    *pfd = fd;
    800045e0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045e4:	4501                	li	a0,0
  if(pf)
    800045e6:	c091                	beqz	s1,800045ea <argfd+0x50>
    *pf = f;
    800045e8:	e09c                	sd	a5,0(s1)
}
    800045ea:	70a2                	ld	ra,40(sp)
    800045ec:	7402                	ld	s0,32(sp)
    800045ee:	64e2                	ld	s1,24(sp)
    800045f0:	6942                	ld	s2,16(sp)
    800045f2:	6145                	addi	sp,sp,48
    800045f4:	8082                	ret
    return -1;
    800045f6:	557d                	li	a0,-1
    800045f8:	bfcd                	j	800045ea <argfd+0x50>
    return -1;
    800045fa:	557d                	li	a0,-1
    800045fc:	b7fd                	j	800045ea <argfd+0x50>
    800045fe:	557d                	li	a0,-1
    80004600:	b7ed                	j	800045ea <argfd+0x50>

0000000080004602 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004602:	1101                	addi	sp,sp,-32
    80004604:	ec06                	sd	ra,24(sp)
    80004606:	e822                	sd	s0,16(sp)
    80004608:	e426                	sd	s1,8(sp)
    8000460a:	1000                	addi	s0,sp,32
    8000460c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000460e:	ffffd097          	auipc	ra,0xffffd
    80004612:	84c080e7          	jalr	-1972(ra) # 80000e5a <myproc>
    80004616:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004618:	0d050793          	addi	a5,a0,208
    8000461c:	4501                	li	a0,0
    8000461e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004620:	6398                	ld	a4,0(a5)
    80004622:	cb19                	beqz	a4,80004638 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004624:	2505                	addiw	a0,a0,1
    80004626:	07a1                	addi	a5,a5,8
    80004628:	fed51ce3          	bne	a0,a3,80004620 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000462c:	557d                	li	a0,-1
}
    8000462e:	60e2                	ld	ra,24(sp)
    80004630:	6442                	ld	s0,16(sp)
    80004632:	64a2                	ld	s1,8(sp)
    80004634:	6105                	addi	sp,sp,32
    80004636:	8082                	ret
      p->ofile[fd] = f;
    80004638:	01a50793          	addi	a5,a0,26
    8000463c:	078e                	slli	a5,a5,0x3
    8000463e:	963e                	add	a2,a2,a5
    80004640:	e204                	sd	s1,0(a2)
      return fd;
    80004642:	b7f5                	j	8000462e <fdalloc+0x2c>

0000000080004644 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004644:	715d                	addi	sp,sp,-80
    80004646:	e486                	sd	ra,72(sp)
    80004648:	e0a2                	sd	s0,64(sp)
    8000464a:	fc26                	sd	s1,56(sp)
    8000464c:	f84a                	sd	s2,48(sp)
    8000464e:	f44e                	sd	s3,40(sp)
    80004650:	f052                	sd	s4,32(sp)
    80004652:	ec56                	sd	s5,24(sp)
    80004654:	0880                	addi	s0,sp,80
    80004656:	8aae                	mv	s5,a1
    80004658:	8a32                	mv	s4,a2
    8000465a:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000465c:	fb040593          	addi	a1,s0,-80
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	e14080e7          	jalr	-492(ra) # 80003474 <nameiparent>
    80004668:	892a                	mv	s2,a0
    8000466a:	12050c63          	beqz	a0,800047a2 <create+0x15e>
    return 0;

  ilock(dp);
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	616080e7          	jalr	1558(ra) # 80002c84 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004676:	4601                	li	a2,0
    80004678:	fb040593          	addi	a1,s0,-80
    8000467c:	854a                	mv	a0,s2
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	b06080e7          	jalr	-1274(ra) # 80003184 <dirlookup>
    80004686:	84aa                	mv	s1,a0
    80004688:	c539                	beqz	a0,800046d6 <create+0x92>
    iunlockput(dp);
    8000468a:	854a                	mv	a0,s2
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	85e080e7          	jalr	-1954(ra) # 80002eea <iunlockput>
    ilock(ip);
    80004694:	8526                	mv	a0,s1
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	5ee080e7          	jalr	1518(ra) # 80002c84 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000469e:	4789                	li	a5,2
    800046a0:	02fa9463          	bne	s5,a5,800046c8 <create+0x84>
    800046a4:	0444d783          	lhu	a5,68(s1)
    800046a8:	37f9                	addiw	a5,a5,-2
    800046aa:	17c2                	slli	a5,a5,0x30
    800046ac:	93c1                	srli	a5,a5,0x30
    800046ae:	4705                	li	a4,1
    800046b0:	00f76c63          	bltu	a4,a5,800046c8 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046b4:	8526                	mv	a0,s1
    800046b6:	60a6                	ld	ra,72(sp)
    800046b8:	6406                	ld	s0,64(sp)
    800046ba:	74e2                	ld	s1,56(sp)
    800046bc:	7942                	ld	s2,48(sp)
    800046be:	79a2                	ld	s3,40(sp)
    800046c0:	7a02                	ld	s4,32(sp)
    800046c2:	6ae2                	ld	s5,24(sp)
    800046c4:	6161                	addi	sp,sp,80
    800046c6:	8082                	ret
    iunlockput(ip);
    800046c8:	8526                	mv	a0,s1
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	820080e7          	jalr	-2016(ra) # 80002eea <iunlockput>
    return 0;
    800046d2:	4481                	li	s1,0
    800046d4:	b7c5                	j	800046b4 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046d6:	85d6                	mv	a1,s5
    800046d8:	00092503          	lw	a0,0(s2)
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	414080e7          	jalr	1044(ra) # 80002af0 <ialloc>
    800046e4:	84aa                	mv	s1,a0
    800046e6:	c139                	beqz	a0,8000472c <create+0xe8>
  ilock(ip);
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	59c080e7          	jalr	1436(ra) # 80002c84 <ilock>
  ip->major = major;
    800046f0:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800046f4:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800046f8:	4985                	li	s3,1
    800046fa:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800046fe:	8526                	mv	a0,s1
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	4b8080e7          	jalr	1208(ra) # 80002bb8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004708:	033a8a63          	beq	s5,s3,8000473c <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000470c:	40d0                	lw	a2,4(s1)
    8000470e:	fb040593          	addi	a1,s0,-80
    80004712:	854a                	mv	a0,s2
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	c80080e7          	jalr	-896(ra) # 80003394 <dirlink>
    8000471c:	06054b63          	bltz	a0,80004792 <create+0x14e>
  iunlockput(dp);
    80004720:	854a                	mv	a0,s2
    80004722:	ffffe097          	auipc	ra,0xffffe
    80004726:	7c8080e7          	jalr	1992(ra) # 80002eea <iunlockput>
  return ip;
    8000472a:	b769                	j	800046b4 <create+0x70>
    panic("create: ialloc");
    8000472c:	00004517          	auipc	a0,0x4
    80004730:	e0c50513          	addi	a0,a0,-500 # 80008538 <etext+0x538>
    80004734:	00002097          	auipc	ra,0x2
    80004738:	938080e7          	jalr	-1736(ra) # 8000606c <panic>
    dp->nlink++;  // for ".."
    8000473c:	04a95783          	lhu	a5,74(s2)
    80004740:	2785                	addiw	a5,a5,1
    80004742:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004746:	854a                	mv	a0,s2
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	470080e7          	jalr	1136(ra) # 80002bb8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004750:	40d0                	lw	a2,4(s1)
    80004752:	00004597          	auipc	a1,0x4
    80004756:	df658593          	addi	a1,a1,-522 # 80008548 <etext+0x548>
    8000475a:	8526                	mv	a0,s1
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	c38080e7          	jalr	-968(ra) # 80003394 <dirlink>
    80004764:	00054f63          	bltz	a0,80004782 <create+0x13e>
    80004768:	00492603          	lw	a2,4(s2)
    8000476c:	00004597          	auipc	a1,0x4
    80004770:	de458593          	addi	a1,a1,-540 # 80008550 <etext+0x550>
    80004774:	8526                	mv	a0,s1
    80004776:	fffff097          	auipc	ra,0xfffff
    8000477a:	c1e080e7          	jalr	-994(ra) # 80003394 <dirlink>
    8000477e:	f80557e3          	bgez	a0,8000470c <create+0xc8>
      panic("create dots");
    80004782:	00004517          	auipc	a0,0x4
    80004786:	dd650513          	addi	a0,a0,-554 # 80008558 <etext+0x558>
    8000478a:	00002097          	auipc	ra,0x2
    8000478e:	8e2080e7          	jalr	-1822(ra) # 8000606c <panic>
    panic("create: dirlink");
    80004792:	00004517          	auipc	a0,0x4
    80004796:	dd650513          	addi	a0,a0,-554 # 80008568 <etext+0x568>
    8000479a:	00002097          	auipc	ra,0x2
    8000479e:	8d2080e7          	jalr	-1838(ra) # 8000606c <panic>
    return 0;
    800047a2:	84aa                	mv	s1,a0
    800047a4:	bf01                	j	800046b4 <create+0x70>

00000000800047a6 <sys_dup>:
{
    800047a6:	7179                	addi	sp,sp,-48
    800047a8:	f406                	sd	ra,40(sp)
    800047aa:	f022                	sd	s0,32(sp)
    800047ac:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047ae:	fd840613          	addi	a2,s0,-40
    800047b2:	4581                	li	a1,0
    800047b4:	4501                	li	a0,0
    800047b6:	00000097          	auipc	ra,0x0
    800047ba:	de4080e7          	jalr	-540(ra) # 8000459a <argfd>
    return -1;
    800047be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047c0:	02054763          	bltz	a0,800047ee <sys_dup+0x48>
    800047c4:	ec26                	sd	s1,24(sp)
    800047c6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800047c8:	fd843903          	ld	s2,-40(s0)
    800047cc:	854a                	mv	a0,s2
    800047ce:	00000097          	auipc	ra,0x0
    800047d2:	e34080e7          	jalr	-460(ra) # 80004602 <fdalloc>
    800047d6:	84aa                	mv	s1,a0
    return -1;
    800047d8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047da:	00054f63          	bltz	a0,800047f8 <sys_dup+0x52>
  filedup(f);
    800047de:	854a                	mv	a0,s2
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	2ee080e7          	jalr	750(ra) # 80003ace <filedup>
  return fd;
    800047e8:	87a6                	mv	a5,s1
    800047ea:	64e2                	ld	s1,24(sp)
    800047ec:	6942                	ld	s2,16(sp)
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	70a2                	ld	ra,40(sp)
    800047f2:	7402                	ld	s0,32(sp)
    800047f4:	6145                	addi	sp,sp,48
    800047f6:	8082                	ret
    800047f8:	64e2                	ld	s1,24(sp)
    800047fa:	6942                	ld	s2,16(sp)
    800047fc:	bfcd                	j	800047ee <sys_dup+0x48>

00000000800047fe <sys_read>:
{
    800047fe:	7179                	addi	sp,sp,-48
    80004800:	f406                	sd	ra,40(sp)
    80004802:	f022                	sd	s0,32(sp)
    80004804:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004806:	fe840613          	addi	a2,s0,-24
    8000480a:	4581                	li	a1,0
    8000480c:	4501                	li	a0,0
    8000480e:	00000097          	auipc	ra,0x0
    80004812:	d8c080e7          	jalr	-628(ra) # 8000459a <argfd>
    return -1;
    80004816:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004818:	04054163          	bltz	a0,8000485a <sys_read+0x5c>
    8000481c:	fe440593          	addi	a1,s0,-28
    80004820:	4509                	li	a0,2
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	8f0080e7          	jalr	-1808(ra) # 80002112 <argint>
    return -1;
    8000482a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482c:	02054763          	bltz	a0,8000485a <sys_read+0x5c>
    80004830:	fd840593          	addi	a1,s0,-40
    80004834:	4505                	li	a0,1
    80004836:	ffffe097          	auipc	ra,0xffffe
    8000483a:	8fe080e7          	jalr	-1794(ra) # 80002134 <argaddr>
    return -1;
    8000483e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004840:	00054d63          	bltz	a0,8000485a <sys_read+0x5c>
  return fileread(f, p, n);
    80004844:	fe442603          	lw	a2,-28(s0)
    80004848:	fd843583          	ld	a1,-40(s0)
    8000484c:	fe843503          	ld	a0,-24(s0)
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	424080e7          	jalr	1060(ra) # 80003c74 <fileread>
    80004858:	87aa                	mv	a5,a0
}
    8000485a:	853e                	mv	a0,a5
    8000485c:	70a2                	ld	ra,40(sp)
    8000485e:	7402                	ld	s0,32(sp)
    80004860:	6145                	addi	sp,sp,48
    80004862:	8082                	ret

0000000080004864 <sys_write>:
{
    80004864:	7179                	addi	sp,sp,-48
    80004866:	f406                	sd	ra,40(sp)
    80004868:	f022                	sd	s0,32(sp)
    8000486a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486c:	fe840613          	addi	a2,s0,-24
    80004870:	4581                	li	a1,0
    80004872:	4501                	li	a0,0
    80004874:	00000097          	auipc	ra,0x0
    80004878:	d26080e7          	jalr	-730(ra) # 8000459a <argfd>
    return -1;
    8000487c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487e:	04054163          	bltz	a0,800048c0 <sys_write+0x5c>
    80004882:	fe440593          	addi	a1,s0,-28
    80004886:	4509                	li	a0,2
    80004888:	ffffe097          	auipc	ra,0xffffe
    8000488c:	88a080e7          	jalr	-1910(ra) # 80002112 <argint>
    return -1;
    80004890:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004892:	02054763          	bltz	a0,800048c0 <sys_write+0x5c>
    80004896:	fd840593          	addi	a1,s0,-40
    8000489a:	4505                	li	a0,1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	898080e7          	jalr	-1896(ra) # 80002134 <argaddr>
    return -1;
    800048a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a6:	00054d63          	bltz	a0,800048c0 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048aa:	fe442603          	lw	a2,-28(s0)
    800048ae:	fd843583          	ld	a1,-40(s0)
    800048b2:	fe843503          	ld	a0,-24(s0)
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	490080e7          	jalr	1168(ra) # 80003d46 <filewrite>
    800048be:	87aa                	mv	a5,a0
}
    800048c0:	853e                	mv	a0,a5
    800048c2:	70a2                	ld	ra,40(sp)
    800048c4:	7402                	ld	s0,32(sp)
    800048c6:	6145                	addi	sp,sp,48
    800048c8:	8082                	ret

00000000800048ca <sys_close>:
{
    800048ca:	1101                	addi	sp,sp,-32
    800048cc:	ec06                	sd	ra,24(sp)
    800048ce:	e822                	sd	s0,16(sp)
    800048d0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048d2:	fe040613          	addi	a2,s0,-32
    800048d6:	fec40593          	addi	a1,s0,-20
    800048da:	4501                	li	a0,0
    800048dc:	00000097          	auipc	ra,0x0
    800048e0:	cbe080e7          	jalr	-834(ra) # 8000459a <argfd>
    return -1;
    800048e4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048e6:	02054463          	bltz	a0,8000490e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048ea:	ffffc097          	auipc	ra,0xffffc
    800048ee:	570080e7          	jalr	1392(ra) # 80000e5a <myproc>
    800048f2:	fec42783          	lw	a5,-20(s0)
    800048f6:	07e9                	addi	a5,a5,26
    800048f8:	078e                	slli	a5,a5,0x3
    800048fa:	953e                	add	a0,a0,a5
    800048fc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004900:	fe043503          	ld	a0,-32(s0)
    80004904:	fffff097          	auipc	ra,0xfffff
    80004908:	21c080e7          	jalr	540(ra) # 80003b20 <fileclose>
  return 0;
    8000490c:	4781                	li	a5,0
}
    8000490e:	853e                	mv	a0,a5
    80004910:	60e2                	ld	ra,24(sp)
    80004912:	6442                	ld	s0,16(sp)
    80004914:	6105                	addi	sp,sp,32
    80004916:	8082                	ret

0000000080004918 <sys_fstat>:
{
    80004918:	1101                	addi	sp,sp,-32
    8000491a:	ec06                	sd	ra,24(sp)
    8000491c:	e822                	sd	s0,16(sp)
    8000491e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004920:	fe840613          	addi	a2,s0,-24
    80004924:	4581                	li	a1,0
    80004926:	4501                	li	a0,0
    80004928:	00000097          	auipc	ra,0x0
    8000492c:	c72080e7          	jalr	-910(ra) # 8000459a <argfd>
    return -1;
    80004930:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004932:	02054563          	bltz	a0,8000495c <sys_fstat+0x44>
    80004936:	fe040593          	addi	a1,s0,-32
    8000493a:	4505                	li	a0,1
    8000493c:	ffffd097          	auipc	ra,0xffffd
    80004940:	7f8080e7          	jalr	2040(ra) # 80002134 <argaddr>
    return -1;
    80004944:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004946:	00054b63          	bltz	a0,8000495c <sys_fstat+0x44>
  return filestat(f, st);
    8000494a:	fe043583          	ld	a1,-32(s0)
    8000494e:	fe843503          	ld	a0,-24(s0)
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	2b0080e7          	jalr	688(ra) # 80003c02 <filestat>
    8000495a:	87aa                	mv	a5,a0
}
    8000495c:	853e                	mv	a0,a5
    8000495e:	60e2                	ld	ra,24(sp)
    80004960:	6442                	ld	s0,16(sp)
    80004962:	6105                	addi	sp,sp,32
    80004964:	8082                	ret

0000000080004966 <sys_link>:
{
    80004966:	7169                	addi	sp,sp,-304
    80004968:	f606                	sd	ra,296(sp)
    8000496a:	f222                	sd	s0,288(sp)
    8000496c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000496e:	08000613          	li	a2,128
    80004972:	ed040593          	addi	a1,s0,-304
    80004976:	4501                	li	a0,0
    80004978:	ffffd097          	auipc	ra,0xffffd
    8000497c:	7de080e7          	jalr	2014(ra) # 80002156 <argstr>
    return -1;
    80004980:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	12054663          	bltz	a0,80004aae <sys_link+0x148>
    80004986:	08000613          	li	a2,128
    8000498a:	f5040593          	addi	a1,s0,-176
    8000498e:	4505                	li	a0,1
    80004990:	ffffd097          	auipc	ra,0xffffd
    80004994:	7c6080e7          	jalr	1990(ra) # 80002156 <argstr>
    return -1;
    80004998:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499a:	10054a63          	bltz	a0,80004aae <sys_link+0x148>
    8000499e:	ee26                	sd	s1,280(sp)
  begin_op();
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	cb6080e7          	jalr	-842(ra) # 80003656 <begin_op>
  if((ip = namei(old)) == 0){
    800049a8:	ed040513          	addi	a0,s0,-304
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	aaa080e7          	jalr	-1366(ra) # 80003456 <namei>
    800049b4:	84aa                	mv	s1,a0
    800049b6:	c949                	beqz	a0,80004a48 <sys_link+0xe2>
  ilock(ip);
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	2cc080e7          	jalr	716(ra) # 80002c84 <ilock>
  if(ip->type == T_DIR){
    800049c0:	04449703          	lh	a4,68(s1)
    800049c4:	4785                	li	a5,1
    800049c6:	08f70863          	beq	a4,a5,80004a56 <sys_link+0xf0>
    800049ca:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800049cc:	04a4d783          	lhu	a5,74(s1)
    800049d0:	2785                	addiw	a5,a5,1
    800049d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	1e0080e7          	jalr	480(ra) # 80002bb8 <iupdate>
  iunlock(ip);
    800049e0:	8526                	mv	a0,s1
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	368080e7          	jalr	872(ra) # 80002d4a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049ea:	fd040593          	addi	a1,s0,-48
    800049ee:	f5040513          	addi	a0,s0,-176
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	a82080e7          	jalr	-1406(ra) # 80003474 <nameiparent>
    800049fa:	892a                	mv	s2,a0
    800049fc:	cd35                	beqz	a0,80004a78 <sys_link+0x112>
  ilock(dp);
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	286080e7          	jalr	646(ra) # 80002c84 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a06:	00092703          	lw	a4,0(s2)
    80004a0a:	409c                	lw	a5,0(s1)
    80004a0c:	06f71163          	bne	a4,a5,80004a6e <sys_link+0x108>
    80004a10:	40d0                	lw	a2,4(s1)
    80004a12:	fd040593          	addi	a1,s0,-48
    80004a16:	854a                	mv	a0,s2
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	97c080e7          	jalr	-1668(ra) # 80003394 <dirlink>
    80004a20:	04054763          	bltz	a0,80004a6e <sys_link+0x108>
  iunlockput(dp);
    80004a24:	854a                	mv	a0,s2
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	4c4080e7          	jalr	1220(ra) # 80002eea <iunlockput>
  iput(ip);
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	412080e7          	jalr	1042(ra) # 80002e42 <iput>
  end_op();
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	c98080e7          	jalr	-872(ra) # 800036d0 <end_op>
  return 0;
    80004a40:	4781                	li	a5,0
    80004a42:	64f2                	ld	s1,280(sp)
    80004a44:	6952                	ld	s2,272(sp)
    80004a46:	a0a5                	j	80004aae <sys_link+0x148>
    end_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	c88080e7          	jalr	-888(ra) # 800036d0 <end_op>
    return -1;
    80004a50:	57fd                	li	a5,-1
    80004a52:	64f2                	ld	s1,280(sp)
    80004a54:	a8a9                	j	80004aae <sys_link+0x148>
    iunlockput(ip);
    80004a56:	8526                	mv	a0,s1
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	492080e7          	jalr	1170(ra) # 80002eea <iunlockput>
    end_op();
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	c70080e7          	jalr	-912(ra) # 800036d0 <end_op>
    return -1;
    80004a68:	57fd                	li	a5,-1
    80004a6a:	64f2                	ld	s1,280(sp)
    80004a6c:	a089                	j	80004aae <sys_link+0x148>
    iunlockput(dp);
    80004a6e:	854a                	mv	a0,s2
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	47a080e7          	jalr	1146(ra) # 80002eea <iunlockput>
  ilock(ip);
    80004a78:	8526                	mv	a0,s1
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	20a080e7          	jalr	522(ra) # 80002c84 <ilock>
  ip->nlink--;
    80004a82:	04a4d783          	lhu	a5,74(s1)
    80004a86:	37fd                	addiw	a5,a5,-1
    80004a88:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	12a080e7          	jalr	298(ra) # 80002bb8 <iupdate>
  iunlockput(ip);
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	452080e7          	jalr	1106(ra) # 80002eea <iunlockput>
  end_op();
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	c30080e7          	jalr	-976(ra) # 800036d0 <end_op>
  return -1;
    80004aa8:	57fd                	li	a5,-1
    80004aaa:	64f2                	ld	s1,280(sp)
    80004aac:	6952                	ld	s2,272(sp)
}
    80004aae:	853e                	mv	a0,a5
    80004ab0:	70b2                	ld	ra,296(sp)
    80004ab2:	7412                	ld	s0,288(sp)
    80004ab4:	6155                	addi	sp,sp,304
    80004ab6:	8082                	ret

0000000080004ab8 <sys_unlink>:
{
    80004ab8:	7151                	addi	sp,sp,-240
    80004aba:	f586                	sd	ra,232(sp)
    80004abc:	f1a2                	sd	s0,224(sp)
    80004abe:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ac0:	08000613          	li	a2,128
    80004ac4:	f3040593          	addi	a1,s0,-208
    80004ac8:	4501                	li	a0,0
    80004aca:	ffffd097          	auipc	ra,0xffffd
    80004ace:	68c080e7          	jalr	1676(ra) # 80002156 <argstr>
    80004ad2:	1a054a63          	bltz	a0,80004c86 <sys_unlink+0x1ce>
    80004ad6:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	b7e080e7          	jalr	-1154(ra) # 80003656 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ae0:	fb040593          	addi	a1,s0,-80
    80004ae4:	f3040513          	addi	a0,s0,-208
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	98c080e7          	jalr	-1652(ra) # 80003474 <nameiparent>
    80004af0:	84aa                	mv	s1,a0
    80004af2:	cd71                	beqz	a0,80004bce <sys_unlink+0x116>
  ilock(dp);
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	190080e7          	jalr	400(ra) # 80002c84 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004afc:	00004597          	auipc	a1,0x4
    80004b00:	a4c58593          	addi	a1,a1,-1460 # 80008548 <etext+0x548>
    80004b04:	fb040513          	addi	a0,s0,-80
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	662080e7          	jalr	1634(ra) # 8000316a <namecmp>
    80004b10:	14050c63          	beqz	a0,80004c68 <sys_unlink+0x1b0>
    80004b14:	00004597          	auipc	a1,0x4
    80004b18:	a3c58593          	addi	a1,a1,-1476 # 80008550 <etext+0x550>
    80004b1c:	fb040513          	addi	a0,s0,-80
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	64a080e7          	jalr	1610(ra) # 8000316a <namecmp>
    80004b28:	14050063          	beqz	a0,80004c68 <sys_unlink+0x1b0>
    80004b2c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b2e:	f2c40613          	addi	a2,s0,-212
    80004b32:	fb040593          	addi	a1,s0,-80
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	64c080e7          	jalr	1612(ra) # 80003184 <dirlookup>
    80004b40:	892a                	mv	s2,a0
    80004b42:	12050263          	beqz	a0,80004c66 <sys_unlink+0x1ae>
  ilock(ip);
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	13e080e7          	jalr	318(ra) # 80002c84 <ilock>
  if(ip->nlink < 1)
    80004b4e:	04a91783          	lh	a5,74(s2)
    80004b52:	08f05563          	blez	a5,80004bdc <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b56:	04491703          	lh	a4,68(s2)
    80004b5a:	4785                	li	a5,1
    80004b5c:	08f70963          	beq	a4,a5,80004bee <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b60:	4641                	li	a2,16
    80004b62:	4581                	li	a1,0
    80004b64:	fc040513          	addi	a0,s0,-64
    80004b68:	ffffb097          	auipc	ra,0xffffb
    80004b6c:	612080e7          	jalr	1554(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b70:	4741                	li	a4,16
    80004b72:	f2c42683          	lw	a3,-212(s0)
    80004b76:	fc040613          	addi	a2,s0,-64
    80004b7a:	4581                	li	a1,0
    80004b7c:	8526                	mv	a0,s1
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	4c2080e7          	jalr	1218(ra) # 80003040 <writei>
    80004b86:	47c1                	li	a5,16
    80004b88:	0af51b63          	bne	a0,a5,80004c3e <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b8c:	04491703          	lh	a4,68(s2)
    80004b90:	4785                	li	a5,1
    80004b92:	0af70f63          	beq	a4,a5,80004c50 <sys_unlink+0x198>
  iunlockput(dp);
    80004b96:	8526                	mv	a0,s1
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	352080e7          	jalr	850(ra) # 80002eea <iunlockput>
  ip->nlink--;
    80004ba0:	04a95783          	lhu	a5,74(s2)
    80004ba4:	37fd                	addiw	a5,a5,-1
    80004ba6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	00c080e7          	jalr	12(ra) # 80002bb8 <iupdate>
  iunlockput(ip);
    80004bb4:	854a                	mv	a0,s2
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	334080e7          	jalr	820(ra) # 80002eea <iunlockput>
  end_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	b12080e7          	jalr	-1262(ra) # 800036d0 <end_op>
  return 0;
    80004bc6:	4501                	li	a0,0
    80004bc8:	64ee                	ld	s1,216(sp)
    80004bca:	694e                	ld	s2,208(sp)
    80004bcc:	a84d                	j	80004c7e <sys_unlink+0x1c6>
    end_op();
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	b02080e7          	jalr	-1278(ra) # 800036d0 <end_op>
    return -1;
    80004bd6:	557d                	li	a0,-1
    80004bd8:	64ee                	ld	s1,216(sp)
    80004bda:	a055                	j	80004c7e <sys_unlink+0x1c6>
    80004bdc:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004bde:	00004517          	auipc	a0,0x4
    80004be2:	99a50513          	addi	a0,a0,-1638 # 80008578 <etext+0x578>
    80004be6:	00001097          	auipc	ra,0x1
    80004bea:	486080e7          	jalr	1158(ra) # 8000606c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bee:	04c92703          	lw	a4,76(s2)
    80004bf2:	02000793          	li	a5,32
    80004bf6:	f6e7f5e3          	bgeu	a5,a4,80004b60 <sys_unlink+0xa8>
    80004bfa:	e5ce                	sd	s3,200(sp)
    80004bfc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c00:	4741                	li	a4,16
    80004c02:	86ce                	mv	a3,s3
    80004c04:	f1840613          	addi	a2,s0,-232
    80004c08:	4581                	li	a1,0
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	330080e7          	jalr	816(ra) # 80002f3c <readi>
    80004c14:	47c1                	li	a5,16
    80004c16:	00f51c63          	bne	a0,a5,80004c2e <sys_unlink+0x176>
    if(de.inum != 0)
    80004c1a:	f1845783          	lhu	a5,-232(s0)
    80004c1e:	e7b5                	bnez	a5,80004c8a <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c20:	29c1                	addiw	s3,s3,16
    80004c22:	04c92783          	lw	a5,76(s2)
    80004c26:	fcf9ede3          	bltu	s3,a5,80004c00 <sys_unlink+0x148>
    80004c2a:	69ae                	ld	s3,200(sp)
    80004c2c:	bf15                	j	80004b60 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004c2e:	00004517          	auipc	a0,0x4
    80004c32:	96250513          	addi	a0,a0,-1694 # 80008590 <etext+0x590>
    80004c36:	00001097          	auipc	ra,0x1
    80004c3a:	436080e7          	jalr	1078(ra) # 8000606c <panic>
    80004c3e:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004c40:	00004517          	auipc	a0,0x4
    80004c44:	96850513          	addi	a0,a0,-1688 # 800085a8 <etext+0x5a8>
    80004c48:	00001097          	auipc	ra,0x1
    80004c4c:	424080e7          	jalr	1060(ra) # 8000606c <panic>
    dp->nlink--;
    80004c50:	04a4d783          	lhu	a5,74(s1)
    80004c54:	37fd                	addiw	a5,a5,-1
    80004c56:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c5a:	8526                	mv	a0,s1
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	f5c080e7          	jalr	-164(ra) # 80002bb8 <iupdate>
    80004c64:	bf0d                	j	80004b96 <sys_unlink+0xde>
    80004c66:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c68:	8526                	mv	a0,s1
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	280080e7          	jalr	640(ra) # 80002eea <iunlockput>
  end_op();
    80004c72:	fffff097          	auipc	ra,0xfffff
    80004c76:	a5e080e7          	jalr	-1442(ra) # 800036d0 <end_op>
  return -1;
    80004c7a:	557d                	li	a0,-1
    80004c7c:	64ee                	ld	s1,216(sp)
}
    80004c7e:	70ae                	ld	ra,232(sp)
    80004c80:	740e                	ld	s0,224(sp)
    80004c82:	616d                	addi	sp,sp,240
    80004c84:	8082                	ret
    return -1;
    80004c86:	557d                	li	a0,-1
    80004c88:	bfdd                	j	80004c7e <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c8a:	854a                	mv	a0,s2
    80004c8c:	ffffe097          	auipc	ra,0xffffe
    80004c90:	25e080e7          	jalr	606(ra) # 80002eea <iunlockput>
    goto bad;
    80004c94:	694e                	ld	s2,208(sp)
    80004c96:	69ae                	ld	s3,200(sp)
    80004c98:	bfc1                	j	80004c68 <sys_unlink+0x1b0>

0000000080004c9a <sys_open>:

uint64
sys_open(void)
{
    80004c9a:	7131                	addi	sp,sp,-192
    80004c9c:	fd06                	sd	ra,184(sp)
    80004c9e:	f922                	sd	s0,176(sp)
    80004ca0:	f526                	sd	s1,168(sp)
    80004ca2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca4:	08000613          	li	a2,128
    80004ca8:	f5040593          	addi	a1,s0,-176
    80004cac:	4501                	li	a0,0
    80004cae:	ffffd097          	auipc	ra,0xffffd
    80004cb2:	4a8080e7          	jalr	1192(ra) # 80002156 <argstr>
    return -1;
    80004cb6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cb8:	0c054463          	bltz	a0,80004d80 <sys_open+0xe6>
    80004cbc:	f4c40593          	addi	a1,s0,-180
    80004cc0:	4505                	li	a0,1
    80004cc2:	ffffd097          	auipc	ra,0xffffd
    80004cc6:	450080e7          	jalr	1104(ra) # 80002112 <argint>
    80004cca:	0a054b63          	bltz	a0,80004d80 <sys_open+0xe6>
    80004cce:	f14a                	sd	s2,160(sp)

  begin_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	986080e7          	jalr	-1658(ra) # 80003656 <begin_op>

  if(omode & O_CREATE){
    80004cd8:	f4c42783          	lw	a5,-180(s0)
    80004cdc:	2007f793          	andi	a5,a5,512
    80004ce0:	cfc5                	beqz	a5,80004d98 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ce2:	4681                	li	a3,0
    80004ce4:	4601                	li	a2,0
    80004ce6:	4589                	li	a1,2
    80004ce8:	f5040513          	addi	a0,s0,-176
    80004cec:	00000097          	auipc	ra,0x0
    80004cf0:	958080e7          	jalr	-1704(ra) # 80004644 <create>
    80004cf4:	892a                	mv	s2,a0
    if(ip == 0){
    80004cf6:	c959                	beqz	a0,80004d8c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cf8:	04491703          	lh	a4,68(s2)
    80004cfc:	478d                	li	a5,3
    80004cfe:	00f71763          	bne	a4,a5,80004d0c <sys_open+0x72>
    80004d02:	04695703          	lhu	a4,70(s2)
    80004d06:	47a5                	li	a5,9
    80004d08:	0ce7ef63          	bltu	a5,a4,80004de6 <sys_open+0x14c>
    80004d0c:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	d56080e7          	jalr	-682(ra) # 80003a64 <filealloc>
    80004d16:	89aa                	mv	s3,a0
    80004d18:	c965                	beqz	a0,80004e08 <sys_open+0x16e>
    80004d1a:	00000097          	auipc	ra,0x0
    80004d1e:	8e8080e7          	jalr	-1816(ra) # 80004602 <fdalloc>
    80004d22:	84aa                	mv	s1,a0
    80004d24:	0c054d63          	bltz	a0,80004dfe <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d28:	04491703          	lh	a4,68(s2)
    80004d2c:	478d                	li	a5,3
    80004d2e:	0ef70a63          	beq	a4,a5,80004e22 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d32:	4789                	li	a5,2
    80004d34:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d38:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d3c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d40:	f4c42783          	lw	a5,-180(s0)
    80004d44:	0017c713          	xori	a4,a5,1
    80004d48:	8b05                	andi	a4,a4,1
    80004d4a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d4e:	0037f713          	andi	a4,a5,3
    80004d52:	00e03733          	snez	a4,a4
    80004d56:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d5a:	4007f793          	andi	a5,a5,1024
    80004d5e:	c791                	beqz	a5,80004d6a <sys_open+0xd0>
    80004d60:	04491703          	lh	a4,68(s2)
    80004d64:	4789                	li	a5,2
    80004d66:	0cf70563          	beq	a4,a5,80004e30 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004d6a:	854a                	mv	a0,s2
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	fde080e7          	jalr	-34(ra) # 80002d4a <iunlock>
  end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	95c080e7          	jalr	-1700(ra) # 800036d0 <end_op>
    80004d7c:	790a                	ld	s2,160(sp)
    80004d7e:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004d80:	8526                	mv	a0,s1
    80004d82:	70ea                	ld	ra,184(sp)
    80004d84:	744a                	ld	s0,176(sp)
    80004d86:	74aa                	ld	s1,168(sp)
    80004d88:	6129                	addi	sp,sp,192
    80004d8a:	8082                	ret
      end_op();
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	944080e7          	jalr	-1724(ra) # 800036d0 <end_op>
      return -1;
    80004d94:	790a                	ld	s2,160(sp)
    80004d96:	b7ed                	j	80004d80 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d98:	f5040513          	addi	a0,s0,-176
    80004d9c:	ffffe097          	auipc	ra,0xffffe
    80004da0:	6ba080e7          	jalr	1722(ra) # 80003456 <namei>
    80004da4:	892a                	mv	s2,a0
    80004da6:	c90d                	beqz	a0,80004dd8 <sys_open+0x13e>
    ilock(ip);
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	edc080e7          	jalr	-292(ra) # 80002c84 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004db0:	04491703          	lh	a4,68(s2)
    80004db4:	4785                	li	a5,1
    80004db6:	f4f711e3          	bne	a4,a5,80004cf8 <sys_open+0x5e>
    80004dba:	f4c42783          	lw	a5,-180(s0)
    80004dbe:	d7b9                	beqz	a5,80004d0c <sys_open+0x72>
      iunlockput(ip);
    80004dc0:	854a                	mv	a0,s2
    80004dc2:	ffffe097          	auipc	ra,0xffffe
    80004dc6:	128080e7          	jalr	296(ra) # 80002eea <iunlockput>
      end_op();
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	906080e7          	jalr	-1786(ra) # 800036d0 <end_op>
      return -1;
    80004dd2:	54fd                	li	s1,-1
    80004dd4:	790a                	ld	s2,160(sp)
    80004dd6:	b76d                	j	80004d80 <sys_open+0xe6>
      end_op();
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	8f8080e7          	jalr	-1800(ra) # 800036d0 <end_op>
      return -1;
    80004de0:	54fd                	li	s1,-1
    80004de2:	790a                	ld	s2,160(sp)
    80004de4:	bf71                	j	80004d80 <sys_open+0xe6>
    iunlockput(ip);
    80004de6:	854a                	mv	a0,s2
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	102080e7          	jalr	258(ra) # 80002eea <iunlockput>
    end_op();
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	8e0080e7          	jalr	-1824(ra) # 800036d0 <end_op>
    return -1;
    80004df8:	54fd                	li	s1,-1
    80004dfa:	790a                	ld	s2,160(sp)
    80004dfc:	b751                	j	80004d80 <sys_open+0xe6>
      fileclose(f);
    80004dfe:	854e                	mv	a0,s3
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	d20080e7          	jalr	-736(ra) # 80003b20 <fileclose>
    iunlockput(ip);
    80004e08:	854a                	mv	a0,s2
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	0e0080e7          	jalr	224(ra) # 80002eea <iunlockput>
    end_op();
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	8be080e7          	jalr	-1858(ra) # 800036d0 <end_op>
    return -1;
    80004e1a:	54fd                	li	s1,-1
    80004e1c:	790a                	ld	s2,160(sp)
    80004e1e:	69ea                	ld	s3,152(sp)
    80004e20:	b785                	j	80004d80 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004e22:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e26:	04691783          	lh	a5,70(s2)
    80004e2a:	02f99223          	sh	a5,36(s3)
    80004e2e:	b739                	j	80004d3c <sys_open+0xa2>
    itrunc(ip);
    80004e30:	854a                	mv	a0,s2
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	f64080e7          	jalr	-156(ra) # 80002d96 <itrunc>
    80004e3a:	bf05                	j	80004d6a <sys_open+0xd0>

0000000080004e3c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e3c:	7175                	addi	sp,sp,-144
    80004e3e:	e506                	sd	ra,136(sp)
    80004e40:	e122                	sd	s0,128(sp)
    80004e42:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	812080e7          	jalr	-2030(ra) # 80003656 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e4c:	08000613          	li	a2,128
    80004e50:	f7040593          	addi	a1,s0,-144
    80004e54:	4501                	li	a0,0
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	300080e7          	jalr	768(ra) # 80002156 <argstr>
    80004e5e:	02054963          	bltz	a0,80004e90 <sys_mkdir+0x54>
    80004e62:	4681                	li	a3,0
    80004e64:	4601                	li	a2,0
    80004e66:	4585                	li	a1,1
    80004e68:	f7040513          	addi	a0,s0,-144
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	7d8080e7          	jalr	2008(ra) # 80004644 <create>
    80004e74:	cd11                	beqz	a0,80004e90 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	074080e7          	jalr	116(ra) # 80002eea <iunlockput>
  end_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	852080e7          	jalr	-1966(ra) # 800036d0 <end_op>
  return 0;
    80004e86:	4501                	li	a0,0
}
    80004e88:	60aa                	ld	ra,136(sp)
    80004e8a:	640a                	ld	s0,128(sp)
    80004e8c:	6149                	addi	sp,sp,144
    80004e8e:	8082                	ret
    end_op();
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	840080e7          	jalr	-1984(ra) # 800036d0 <end_op>
    return -1;
    80004e98:	557d                	li	a0,-1
    80004e9a:	b7fd                	j	80004e88 <sys_mkdir+0x4c>

0000000080004e9c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e9c:	7135                	addi	sp,sp,-160
    80004e9e:	ed06                	sd	ra,152(sp)
    80004ea0:	e922                	sd	s0,144(sp)
    80004ea2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ea4:	ffffe097          	auipc	ra,0xffffe
    80004ea8:	7b2080e7          	jalr	1970(ra) # 80003656 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eac:	08000613          	li	a2,128
    80004eb0:	f7040593          	addi	a1,s0,-144
    80004eb4:	4501                	li	a0,0
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	2a0080e7          	jalr	672(ra) # 80002156 <argstr>
    80004ebe:	04054a63          	bltz	a0,80004f12 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ec2:	f6c40593          	addi	a1,s0,-148
    80004ec6:	4505                	li	a0,1
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	24a080e7          	jalr	586(ra) # 80002112 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ed0:	04054163          	bltz	a0,80004f12 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ed4:	f6840593          	addi	a1,s0,-152
    80004ed8:	4509                	li	a0,2
    80004eda:	ffffd097          	auipc	ra,0xffffd
    80004ede:	238080e7          	jalr	568(ra) # 80002112 <argint>
     argint(1, &major) < 0 ||
    80004ee2:	02054863          	bltz	a0,80004f12 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ee6:	f6841683          	lh	a3,-152(s0)
    80004eea:	f6c41603          	lh	a2,-148(s0)
    80004eee:	458d                	li	a1,3
    80004ef0:	f7040513          	addi	a0,s0,-144
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	750080e7          	jalr	1872(ra) # 80004644 <create>
     argint(2, &minor) < 0 ||
    80004efc:	c919                	beqz	a0,80004f12 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004efe:	ffffe097          	auipc	ra,0xffffe
    80004f02:	fec080e7          	jalr	-20(ra) # 80002eea <iunlockput>
  end_op();
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	7ca080e7          	jalr	1994(ra) # 800036d0 <end_op>
  return 0;
    80004f0e:	4501                	li	a0,0
    80004f10:	a031                	j	80004f1c <sys_mknod+0x80>
    end_op();
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	7be080e7          	jalr	1982(ra) # 800036d0 <end_op>
    return -1;
    80004f1a:	557d                	li	a0,-1
}
    80004f1c:	60ea                	ld	ra,152(sp)
    80004f1e:	644a                	ld	s0,144(sp)
    80004f20:	610d                	addi	sp,sp,160
    80004f22:	8082                	ret

0000000080004f24 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f24:	7135                	addi	sp,sp,-160
    80004f26:	ed06                	sd	ra,152(sp)
    80004f28:	e922                	sd	s0,144(sp)
    80004f2a:	e14a                	sd	s2,128(sp)
    80004f2c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f2e:	ffffc097          	auipc	ra,0xffffc
    80004f32:	f2c080e7          	jalr	-212(ra) # 80000e5a <myproc>
    80004f36:	892a                	mv	s2,a0
  
  begin_op();
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	71e080e7          	jalr	1822(ra) # 80003656 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f40:	08000613          	li	a2,128
    80004f44:	f6040593          	addi	a1,s0,-160
    80004f48:	4501                	li	a0,0
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	20c080e7          	jalr	524(ra) # 80002156 <argstr>
    80004f52:	04054d63          	bltz	a0,80004fac <sys_chdir+0x88>
    80004f56:	e526                	sd	s1,136(sp)
    80004f58:	f6040513          	addi	a0,s0,-160
    80004f5c:	ffffe097          	auipc	ra,0xffffe
    80004f60:	4fa080e7          	jalr	1274(ra) # 80003456 <namei>
    80004f64:	84aa                	mv	s1,a0
    80004f66:	c131                	beqz	a0,80004faa <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	d1c080e7          	jalr	-740(ra) # 80002c84 <ilock>
  if(ip->type != T_DIR){
    80004f70:	04449703          	lh	a4,68(s1)
    80004f74:	4785                	li	a5,1
    80004f76:	04f71163          	bne	a4,a5,80004fb8 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	dce080e7          	jalr	-562(ra) # 80002d4a <iunlock>
  iput(p->cwd);
    80004f84:	15093503          	ld	a0,336(s2)
    80004f88:	ffffe097          	auipc	ra,0xffffe
    80004f8c:	eba080e7          	jalr	-326(ra) # 80002e42 <iput>
  end_op();
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	740080e7          	jalr	1856(ra) # 800036d0 <end_op>
  p->cwd = ip;
    80004f98:	14993823          	sd	s1,336(s2)
  return 0;
    80004f9c:	4501                	li	a0,0
    80004f9e:	64aa                	ld	s1,136(sp)
}
    80004fa0:	60ea                	ld	ra,152(sp)
    80004fa2:	644a                	ld	s0,144(sp)
    80004fa4:	690a                	ld	s2,128(sp)
    80004fa6:	610d                	addi	sp,sp,160
    80004fa8:	8082                	ret
    80004faa:	64aa                	ld	s1,136(sp)
    end_op();
    80004fac:	ffffe097          	auipc	ra,0xffffe
    80004fb0:	724080e7          	jalr	1828(ra) # 800036d0 <end_op>
    return -1;
    80004fb4:	557d                	li	a0,-1
    80004fb6:	b7ed                	j	80004fa0 <sys_chdir+0x7c>
    iunlockput(ip);
    80004fb8:	8526                	mv	a0,s1
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	f30080e7          	jalr	-208(ra) # 80002eea <iunlockput>
    end_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	70e080e7          	jalr	1806(ra) # 800036d0 <end_op>
    return -1;
    80004fca:	557d                	li	a0,-1
    80004fcc:	64aa                	ld	s1,136(sp)
    80004fce:	bfc9                	j	80004fa0 <sys_chdir+0x7c>

0000000080004fd0 <sys_exec>:

uint64
sys_exec(void)
{
    80004fd0:	7121                	addi	sp,sp,-448
    80004fd2:	ff06                	sd	ra,440(sp)
    80004fd4:	fb22                	sd	s0,432(sp)
    80004fd6:	f34a                	sd	s2,416(sp)
    80004fd8:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fda:	08000613          	li	a2,128
    80004fde:	f5040593          	addi	a1,s0,-176
    80004fe2:	4501                	li	a0,0
    80004fe4:	ffffd097          	auipc	ra,0xffffd
    80004fe8:	172080e7          	jalr	370(ra) # 80002156 <argstr>
    return -1;
    80004fec:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fee:	0e054a63          	bltz	a0,800050e2 <sys_exec+0x112>
    80004ff2:	e4840593          	addi	a1,s0,-440
    80004ff6:	4505                	li	a0,1
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	13c080e7          	jalr	316(ra) # 80002134 <argaddr>
    80005000:	0e054163          	bltz	a0,800050e2 <sys_exec+0x112>
    80005004:	f726                	sd	s1,424(sp)
    80005006:	ef4e                	sd	s3,408(sp)
    80005008:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000500a:	10000613          	li	a2,256
    8000500e:	4581                	li	a1,0
    80005010:	e5040513          	addi	a0,s0,-432
    80005014:	ffffb097          	auipc	ra,0xffffb
    80005018:	166080e7          	jalr	358(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000501c:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005020:	89a6                	mv	s3,s1
    80005022:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005024:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005028:	00391513          	slli	a0,s2,0x3
    8000502c:	e4040593          	addi	a1,s0,-448
    80005030:	e4843783          	ld	a5,-440(s0)
    80005034:	953e                	add	a0,a0,a5
    80005036:	ffffd097          	auipc	ra,0xffffd
    8000503a:	042080e7          	jalr	66(ra) # 80002078 <fetchaddr>
    8000503e:	02054a63          	bltz	a0,80005072 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005042:	e4043783          	ld	a5,-448(s0)
    80005046:	c7b1                	beqz	a5,80005092 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005048:	ffffb097          	auipc	ra,0xffffb
    8000504c:	0d2080e7          	jalr	210(ra) # 8000011a <kalloc>
    80005050:	85aa                	mv	a1,a0
    80005052:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005056:	cd11                	beqz	a0,80005072 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005058:	6605                	lui	a2,0x1
    8000505a:	e4043503          	ld	a0,-448(s0)
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	06c080e7          	jalr	108(ra) # 800020ca <fetchstr>
    80005066:	00054663          	bltz	a0,80005072 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    8000506a:	0905                	addi	s2,s2,1
    8000506c:	09a1                	addi	s3,s3,8
    8000506e:	fb491de3          	bne	s2,s4,80005028 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005072:	f5040913          	addi	s2,s0,-176
    80005076:	6088                	ld	a0,0(s1)
    80005078:	c12d                	beqz	a0,800050da <sys_exec+0x10a>
    kfree(argv[i]);
    8000507a:	ffffb097          	auipc	ra,0xffffb
    8000507e:	fa2080e7          	jalr	-94(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005082:	04a1                	addi	s1,s1,8
    80005084:	ff2499e3          	bne	s1,s2,80005076 <sys_exec+0xa6>
  return -1;
    80005088:	597d                	li	s2,-1
    8000508a:	74ba                	ld	s1,424(sp)
    8000508c:	69fa                	ld	s3,408(sp)
    8000508e:	6a5a                	ld	s4,400(sp)
    80005090:	a889                	j	800050e2 <sys_exec+0x112>
      argv[i] = 0;
    80005092:	0009079b          	sext.w	a5,s2
    80005096:	078e                	slli	a5,a5,0x3
    80005098:	fd078793          	addi	a5,a5,-48
    8000509c:	97a2                	add	a5,a5,s0
    8000509e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050a2:	e5040593          	addi	a1,s0,-432
    800050a6:	f5040513          	addi	a0,s0,-176
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	126080e7          	jalr	294(ra) # 800041d0 <exec>
    800050b2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b4:	f5040993          	addi	s3,s0,-176
    800050b8:	6088                	ld	a0,0(s1)
    800050ba:	cd01                	beqz	a0,800050d2 <sys_exec+0x102>
    kfree(argv[i]);
    800050bc:	ffffb097          	auipc	ra,0xffffb
    800050c0:	f60080e7          	jalr	-160(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	04a1                	addi	s1,s1,8
    800050c6:	ff3499e3          	bne	s1,s3,800050b8 <sys_exec+0xe8>
    800050ca:	74ba                	ld	s1,424(sp)
    800050cc:	69fa                	ld	s3,408(sp)
    800050ce:	6a5a                	ld	s4,400(sp)
    800050d0:	a809                	j	800050e2 <sys_exec+0x112>
  return ret;
    800050d2:	74ba                	ld	s1,424(sp)
    800050d4:	69fa                	ld	s3,408(sp)
    800050d6:	6a5a                	ld	s4,400(sp)
    800050d8:	a029                	j	800050e2 <sys_exec+0x112>
  return -1;
    800050da:	597d                	li	s2,-1
    800050dc:	74ba                	ld	s1,424(sp)
    800050de:	69fa                	ld	s3,408(sp)
    800050e0:	6a5a                	ld	s4,400(sp)
}
    800050e2:	854a                	mv	a0,s2
    800050e4:	70fa                	ld	ra,440(sp)
    800050e6:	745a                	ld	s0,432(sp)
    800050e8:	791a                	ld	s2,416(sp)
    800050ea:	6139                	addi	sp,sp,448
    800050ec:	8082                	ret

00000000800050ee <sys_pipe>:

uint64
sys_pipe(void)
{
    800050ee:	7139                	addi	sp,sp,-64
    800050f0:	fc06                	sd	ra,56(sp)
    800050f2:	f822                	sd	s0,48(sp)
    800050f4:	f426                	sd	s1,40(sp)
    800050f6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	d62080e7          	jalr	-670(ra) # 80000e5a <myproc>
    80005100:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005102:	fd840593          	addi	a1,s0,-40
    80005106:	4501                	li	a0,0
    80005108:	ffffd097          	auipc	ra,0xffffd
    8000510c:	02c080e7          	jalr	44(ra) # 80002134 <argaddr>
    return -1;
    80005110:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005112:	0e054063          	bltz	a0,800051f2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005116:	fc840593          	addi	a1,s0,-56
    8000511a:	fd040513          	addi	a0,s0,-48
    8000511e:	fffff097          	auipc	ra,0xfffff
    80005122:	d70080e7          	jalr	-656(ra) # 80003e8e <pipealloc>
    return -1;
    80005126:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005128:	0c054563          	bltz	a0,800051f2 <sys_pipe+0x104>
  fd0 = -1;
    8000512c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005130:	fd043503          	ld	a0,-48(s0)
    80005134:	fffff097          	auipc	ra,0xfffff
    80005138:	4ce080e7          	jalr	1230(ra) # 80004602 <fdalloc>
    8000513c:	fca42223          	sw	a0,-60(s0)
    80005140:	08054c63          	bltz	a0,800051d8 <sys_pipe+0xea>
    80005144:	fc843503          	ld	a0,-56(s0)
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	4ba080e7          	jalr	1210(ra) # 80004602 <fdalloc>
    80005150:	fca42023          	sw	a0,-64(s0)
    80005154:	06054963          	bltz	a0,800051c6 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005158:	4691                	li	a3,4
    8000515a:	fc440613          	addi	a2,s0,-60
    8000515e:	fd843583          	ld	a1,-40(s0)
    80005162:	68a8                	ld	a0,80(s1)
    80005164:	ffffc097          	auipc	ra,0xffffc
    80005168:	99a080e7          	jalr	-1638(ra) # 80000afe <copyout>
    8000516c:	02054063          	bltz	a0,8000518c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005170:	4691                	li	a3,4
    80005172:	fc040613          	addi	a2,s0,-64
    80005176:	fd843583          	ld	a1,-40(s0)
    8000517a:	0591                	addi	a1,a1,4
    8000517c:	68a8                	ld	a0,80(s1)
    8000517e:	ffffc097          	auipc	ra,0xffffc
    80005182:	980080e7          	jalr	-1664(ra) # 80000afe <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005186:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005188:	06055563          	bgez	a0,800051f2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000518c:	fc442783          	lw	a5,-60(s0)
    80005190:	07e9                	addi	a5,a5,26
    80005192:	078e                	slli	a5,a5,0x3
    80005194:	97a6                	add	a5,a5,s1
    80005196:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000519a:	fc042783          	lw	a5,-64(s0)
    8000519e:	07e9                	addi	a5,a5,26
    800051a0:	078e                	slli	a5,a5,0x3
    800051a2:	00f48533          	add	a0,s1,a5
    800051a6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051aa:	fd043503          	ld	a0,-48(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	972080e7          	jalr	-1678(ra) # 80003b20 <fileclose>
    fileclose(wf);
    800051b6:	fc843503          	ld	a0,-56(s0)
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	966080e7          	jalr	-1690(ra) # 80003b20 <fileclose>
    return -1;
    800051c2:	57fd                	li	a5,-1
    800051c4:	a03d                	j	800051f2 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051c6:	fc442783          	lw	a5,-60(s0)
    800051ca:	0007c763          	bltz	a5,800051d8 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051ce:	07e9                	addi	a5,a5,26
    800051d0:	078e                	slli	a5,a5,0x3
    800051d2:	97a6                	add	a5,a5,s1
    800051d4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051d8:	fd043503          	ld	a0,-48(s0)
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	944080e7          	jalr	-1724(ra) # 80003b20 <fileclose>
    fileclose(wf);
    800051e4:	fc843503          	ld	a0,-56(s0)
    800051e8:	fffff097          	auipc	ra,0xfffff
    800051ec:	938080e7          	jalr	-1736(ra) # 80003b20 <fileclose>
    return -1;
    800051f0:	57fd                	li	a5,-1
}
    800051f2:	853e                	mv	a0,a5
    800051f4:	70e2                	ld	ra,56(sp)
    800051f6:	7442                	ld	s0,48(sp)
    800051f8:	74a2                	ld	s1,40(sp)
    800051fa:	6121                	addi	sp,sp,64
    800051fc:	8082                	ret

00000000800051fe <sys_mmap>:
uint64 sys_mmap(void)
 {
    800051fe:	711d                	addi	sp,sp,-96
    80005200:	ec86                	sd	ra,88(sp)
    80005202:	e8a2                	sd	s0,80(sp)
    80005204:	e0ca                	sd	s2,64(sp)
    80005206:	1080                	addi	s0,sp,96
  uint64 addr;
  int length, prot, flags, fd, offset;
  struct proc *p = myproc();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	c52080e7          	jalr	-942(ra) # 80000e5a <myproc>
    80005210:	892a                	mv	s2,a0
  struct file *file;
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005212:	fc840593          	addi	a1,s0,-56
    80005216:	4501                	li	a0,0
    80005218:	ffffd097          	auipc	ra,0xffffd
    8000521c:	f1c080e7          	jalr	-228(ra) # 80002134 <argaddr>
    argint(3, &flags) || argfd(4, &fd, &file) || argint(5, &offset)) 
    return -1;
    80005220:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005222:	ed5d                	bnez	a0,800052e0 <sys_mmap+0xe2>
    80005224:	fc440593          	addi	a1,s0,-60
    80005228:	4505                	li	a0,1
    8000522a:	ffffd097          	auipc	ra,0xffffd
    8000522e:	ee8080e7          	jalr	-280(ra) # 80002112 <argint>
    return -1;
    80005232:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005234:	e555                	bnez	a0,800052e0 <sys_mmap+0xe2>
    80005236:	fc040593          	addi	a1,s0,-64
    8000523a:	4509                	li	a0,2
    8000523c:	ffffd097          	auipc	ra,0xffffd
    80005240:	ed6080e7          	jalr	-298(ra) # 80002112 <argint>
    return -1;
    80005244:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005246:	ed49                	bnez	a0,800052e0 <sys_mmap+0xe2>
    argint(3, &flags) || argfd(4, &fd, &file) || argint(5, &offset)) 
    80005248:	fbc40593          	addi	a1,s0,-68
    8000524c:	450d                	li	a0,3
    8000524e:	ffffd097          	auipc	ra,0xffffd
    80005252:	ec4080e7          	jalr	-316(ra) # 80002112 <argint>
    return -1;
    80005256:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005258:	e541                	bnez	a0,800052e0 <sys_mmap+0xe2>
    argint(3, &flags) || argfd(4, &fd, &file) || argint(5, &offset)) 
    8000525a:	fa840613          	addi	a2,s0,-88
    8000525e:	fb840593          	addi	a1,s0,-72
    80005262:	4511                	li	a0,4
    80005264:	fffff097          	auipc	ra,0xfffff
    80005268:	336080e7          	jalr	822(ra) # 8000459a <argfd>
    return -1;
    8000526c:	57fd                	li	a5,-1
    argint(3, &flags) || argfd(4, &fd, &file) || argint(5, &offset)) 
    8000526e:	e92d                	bnez	a0,800052e0 <sys_mmap+0xe2>
    80005270:	e4a6                	sd	s1,72(sp)
    80005272:	fb440593          	addi	a1,s0,-76
    80005276:	4515                	li	a0,5
    80005278:	ffffd097          	auipc	ra,0xffffd
    8000527c:	e9a080e7          	jalr	-358(ra) # 80002112 <argint>
    80005280:	84aa                	mv	s1,a0
    return -1;
    80005282:	57fd                	li	a5,-1
    argint(3, &flags) || argfd(4, &fd, &file) || argint(5, &offset)) 
    80005284:	e979                	bnez	a0,8000535a <sys_mmap+0x15c>
  
  if(!file->writable && (prot & PROT_WRITE) && flags == MAP_SHARED)
    80005286:	fa843503          	ld	a0,-88(s0)
    8000528a:	00954783          	lbu	a5,9(a0)
    8000528e:	eb91                	bnez	a5,800052a2 <sys_mmap+0xa4>
    80005290:	fc042783          	lw	a5,-64(s0)
    80005294:	8b89                	andi	a5,a5,2
    80005296:	c791                	beqz	a5,800052a2 <sys_mmap+0xa4>
    80005298:	fbc42703          	lw	a4,-68(s0)
    8000529c:	4785                	li	a5,1
    8000529e:	0af70b63          	beq	a4,a5,80005354 <sys_mmap+0x156>
    return -1;

  length = PGROUNDUP(length);
    800052a2:	fc442783          	lw	a5,-60(s0)
    800052a6:	6685                	lui	a3,0x1
    800052a8:	36fd                	addiw	a3,a3,-1 # fff <_entry-0x7ffff001>
    800052aa:	9ebd                	addw	a3,a3,a5
    800052ac:	77fd                	lui	a5,0xfffff
    800052ae:	8efd                	and	a3,a3,a5
    800052b0:	2681                	sext.w	a3,a3
    800052b2:	fcd42223          	sw	a3,-60(s0)
  if(p->sz > MAXVA - length)
    800052b6:	04893583          	ld	a1,72(s2)
    800052ba:	4785                	li	a5,1
    800052bc:	179a                	slli	a5,a5,0x26
    800052be:	40d78733          	sub	a4,a5,a3
    return -1;
    800052c2:	57fd                	li	a5,-1
  if(p->sz > MAXVA - length)
    800052c4:	08b76d63          	bltu	a4,a1,8000535e <sys_mmap+0x160>
    800052c8:	17490793          	addi	a5,s2,372

  for(int i = 0; i < VMASIZE; i++) 
    800052cc:	4641                	li	a2,16
  {
    if(p->vma[i].used == 0)
    800052ce:	4398                	lw	a4,0(a5)
    800052d0:	cf11                	beqz	a4,800052ec <sys_mmap+0xee>
  for(int i = 0; i < VMASIZE; i++) 
    800052d2:	2485                	addiw	s1,s1,1
    800052d4:	02878793          	addi	a5,a5,40 # fffffffffffff028 <end+0xffffffff7ffcbde8>
    800052d8:	fec49be3          	bne	s1,a2,800052ce <sys_mmap+0xd0>
      filedup(file);
      p->sz += length;
      return p->vma[i].addr;
    }
  }
  return -1;
    800052dc:	57fd                	li	a5,-1
    800052de:	64a6                	ld	s1,72(sp)
}
    800052e0:	853e                	mv	a0,a5
    800052e2:	60e6                	ld	ra,88(sp)
    800052e4:	6446                	ld	s0,80(sp)
    800052e6:	6906                	ld	s2,64(sp)
    800052e8:	6125                	addi	sp,sp,96
    800052ea:	8082                	ret
    800052ec:	fc4e                	sd	s3,56(sp)
      p->vma[i].used = 1;
    800052ee:	00249993          	slli	s3,s1,0x2
    800052f2:	009987b3          	add	a5,s3,s1
    800052f6:	078e                	slli	a5,a5,0x3
    800052f8:	97ca                	add	a5,a5,s2
    800052fa:	4705                	li	a4,1
    800052fc:	16e7aa23          	sw	a4,372(a5)
      p->vma[i].addr = p->sz;
    80005300:	16b7bc23          	sd	a1,376(a5)
      p->vma[i].length = length;
    80005304:	18d7a023          	sw	a3,384(a5)
      p->vma[i].prot = prot;
    80005308:	fc042703          	lw	a4,-64(s0)
    8000530c:	18e7a223          	sw	a4,388(a5)
      p->vma[i].flags = flags;
    80005310:	fbc42703          	lw	a4,-68(s0)
    80005314:	18e7a423          	sw	a4,392(a5)
      p->vma[i].fd = fd;
    80005318:	fb842703          	lw	a4,-72(s0)
    8000531c:	16e7a823          	sw	a4,368(a5)
      p->vma[i].file = file;
    80005320:	16a7b423          	sd	a0,360(a5)
      p->vma[i].offset = offset;
    80005324:	fb442703          	lw	a4,-76(s0)
    80005328:	18e7a623          	sw	a4,396(a5)
      filedup(file);
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	7a2080e7          	jalr	1954(ra) # 80003ace <filedup>
      p->sz += length;
    80005334:	fc442703          	lw	a4,-60(s0)
    80005338:	04893783          	ld	a5,72(s2)
    8000533c:	97ba                	add	a5,a5,a4
    8000533e:	04f93423          	sd	a5,72(s2)
      return p->vma[i].addr;
    80005342:	99a6                	add	s3,s3,s1
    80005344:	098e                	slli	s3,s3,0x3
    80005346:	01390533          	add	a0,s2,s3
    8000534a:	17853783          	ld	a5,376(a0)
    8000534e:	64a6                	ld	s1,72(sp)
    80005350:	79e2                	ld	s3,56(sp)
    80005352:	b779                	j	800052e0 <sys_mmap+0xe2>
    return -1;
    80005354:	57fd                	li	a5,-1
    80005356:	64a6                	ld	s1,72(sp)
    80005358:	b761                	j	800052e0 <sys_mmap+0xe2>
    8000535a:	64a6                	ld	s1,72(sp)
    8000535c:	b751                	j	800052e0 <sys_mmap+0xe2>
    8000535e:	64a6                	ld	s1,72(sp)
    80005360:	b741                	j	800052e0 <sys_mmap+0xe2>

0000000080005362 <sys_munmap>:

uint64 sys_munmap(void)
{
    80005362:	7179                	addi	sp,sp,-48
    80005364:	f406                	sd	ra,40(sp)
    80005366:	f022                	sd	s0,32(sp)
    80005368:	ec26                	sd	s1,24(sp)
    8000536a:	1800                	addi	s0,sp,48
  uint64 addr;
  int length;
  struct proc *p = myproc();
    8000536c:	ffffc097          	auipc	ra,0xffffc
    80005370:	aee080e7          	jalr	-1298(ra) # 80000e5a <myproc>
    80005374:	84aa                	mv	s1,a0
  struct vma *vma = 0;
  if(argaddr(0, &addr) || argint(1, &length))
    80005376:	fd840593          	addi	a1,s0,-40
    8000537a:	4501                	li	a0,0
    8000537c:	ffffd097          	auipc	ra,0xffffd
    80005380:	db8080e7          	jalr	-584(ra) # 80002134 <argaddr>
    return -1;
    80005384:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length))
    80005386:	ed35                	bnez	a0,80005402 <sys_munmap+0xa0>
    80005388:	fd440593          	addi	a1,s0,-44
    8000538c:	4505                	li	a0,1
    8000538e:	ffffd097          	auipc	ra,0xffffd
    80005392:	d84080e7          	jalr	-636(ra) # 80002112 <argint>
    80005396:	86aa                	mv	a3,a0
    return -1;
    80005398:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length))
    8000539a:	e525                	bnez	a0,80005402 <sys_munmap+0xa0>
  addr = PGROUNDDOWN(addr);
    8000539c:	75fd                	lui	a1,0xfffff
    8000539e:	fd843783          	ld	a5,-40(s0)
    800053a2:	8dfd                	and	a1,a1,a5
    800053a4:	fcb43c23          	sd	a1,-40(s0)
  length = PGROUNDUP(length);
    800053a8:	fd442783          	lw	a5,-44(s0)
    800053ac:	6605                	lui	a2,0x1
    800053ae:	367d                	addiw	a2,a2,-1 # fff <_entry-0x7ffff001>
    800053b0:	9e3d                	addw	a2,a2,a5
    800053b2:	77fd                	lui	a5,0xfffff
    800053b4:	8e7d                	and	a2,a2,a5
    800053b6:	2601                	sext.w	a2,a2
    800053b8:	fcc42a23          	sw	a2,-44(s0)
  for(int i = 0; i < VMASIZE; i++)
    800053bc:	17848793          	addi	a5,s1,376
    800053c0:	4541                	li	a0,16
  {
    if (addr >= p->vma[i].addr || addr < p->vma[i].addr + p->vma[i].length) 
    800053c2:	0007b803          	ld	a6,0(a5) # fffffffffffff000 <end+0xffffffff7ffcbdc0>
    800053c6:	0105fd63          	bgeu	a1,a6,800053e0 <sys_munmap+0x7e>
    800053ca:	4798                	lw	a4,8(a5)
    800053cc:	9742                	add	a4,a4,a6
    800053ce:	00e5e963          	bltu	a1,a4,800053e0 <sys_munmap+0x7e>
  for(int i = 0; i < VMASIZE; i++)
    800053d2:	2685                	addiw	a3,a3,1
    800053d4:	02878793          	addi	a5,a5,40
    800053d8:	fea695e3          	bne	a3,a0,800053c2 <sys_munmap+0x60>
      vma = &p->vma[i];
      break;
    }
  }
  if(vma == 0) 
    return 0;
    800053dc:	4781                	li	a5,0
    800053de:	a015                	j	80005402 <sys_munmap+0xa0>
    800053e0:	e84a                	sd	s2,16(sp)
      vma = &p->vma[i];
    800053e2:	00269793          	slli	a5,a3,0x2
    800053e6:	97b6                	add	a5,a5,a3
    800053e8:	078e                	slli	a5,a5,0x3
    800053ea:	16878793          	addi	a5,a5,360
    800053ee:	00f48933          	add	s2,s1,a5
  if(vma == 0) 
    800053f2:	08090363          	beqz	s2,80005478 <sys_munmap+0x116>
  if(vma->addr == addr) 
    800053f6:	01093703          	ld	a4,16(s2)
    {
      fileclose(vma->file);
      vma->used = 0;
    }
  }
  return 0;
    800053fa:	4781                	li	a5,0
  if(vma->addr == addr) 
    800053fc:	00e58963          	beq	a1,a4,8000540e <sys_munmap+0xac>
    80005400:	6942                	ld	s2,16(sp)
    80005402:	853e                	mv	a0,a5
    80005404:	70a2                	ld	ra,40(sp)
    80005406:	7402                	ld	s0,32(sp)
    80005408:	64e2                	ld	s1,24(sp)
    8000540a:	6145                	addi	sp,sp,48
    8000540c:	8082                	ret
    vma->addr += length;
    8000540e:	9732                	add	a4,a4,a2
    80005410:	00e93823          	sd	a4,16(s2)
    vma->length -= length;
    80005414:	01892783          	lw	a5,24(s2)
    80005418:	9f91                	subw	a5,a5,a2
    8000541a:	00f92c23          	sw	a5,24(s2)
    if(vma->flags & MAP_SHARED)
    8000541e:	02092783          	lw	a5,32(s2)
    80005422:	8b85                	andi	a5,a5,1
    80005424:	eb85                	bnez	a5,80005454 <sys_munmap+0xf2>
    uvmunmap(p->pagetable, addr, length/PGSIZE, 1);
    80005426:	fd442783          	lw	a5,-44(s0)
    8000542a:	41f7d61b          	sraiw	a2,a5,0x1f
    8000542e:	0146561b          	srliw	a2,a2,0x14
    80005432:	9e3d                	addw	a2,a2,a5
    80005434:	4685                	li	a3,1
    80005436:	40c6561b          	sraiw	a2,a2,0xc
    8000543a:	fd843583          	ld	a1,-40(s0)
    8000543e:	68a8                	ld	a0,80(s1)
    80005440:	ffffb097          	auipc	ra,0xffffb
    80005444:	2c0080e7          	jalr	704(ra) # 80000700 <uvmunmap>
    if(vma->length == 0) 
    80005448:	01892703          	lw	a4,24(s2)
  return 0;
    8000544c:	4781                	li	a5,0
    if(vma->length == 0) 
    8000544e:	cb11                	beqz	a4,80005462 <sys_munmap+0x100>
    80005450:	6942                	ld	s2,16(sp)
    80005452:	bf45                	j	80005402 <sys_munmap+0xa0>
      filewrite(vma->file, addr, length);
    80005454:	00093503          	ld	a0,0(s2)
    80005458:	fffff097          	auipc	ra,0xfffff
    8000545c:	8ee080e7          	jalr	-1810(ra) # 80003d46 <filewrite>
    80005460:	b7d9                	j	80005426 <sys_munmap+0xc4>
      fileclose(vma->file);
    80005462:	00093503          	ld	a0,0(s2)
    80005466:	ffffe097          	auipc	ra,0xffffe
    8000546a:	6ba080e7          	jalr	1722(ra) # 80003b20 <fileclose>
      vma->used = 0;
    8000546e:	00092623          	sw	zero,12(s2)
  return 0;
    80005472:	4781                	li	a5,0
    80005474:	6942                	ld	s2,16(sp)
    80005476:	b771                	j	80005402 <sys_munmap+0xa0>
    return 0;
    80005478:	4781                	li	a5,0
    8000547a:	6942                	ld	s2,16(sp)
    8000547c:	b759                	j	80005402 <sys_munmap+0xa0>
	...

0000000080005480 <kernelvec>:
    80005480:	7111                	addi	sp,sp,-256
    80005482:	e006                	sd	ra,0(sp)
    80005484:	e40a                	sd	sp,8(sp)
    80005486:	e80e                	sd	gp,16(sp)
    80005488:	ec12                	sd	tp,24(sp)
    8000548a:	f016                	sd	t0,32(sp)
    8000548c:	f41a                	sd	t1,40(sp)
    8000548e:	f81e                	sd	t2,48(sp)
    80005490:	fc22                	sd	s0,56(sp)
    80005492:	e0a6                	sd	s1,64(sp)
    80005494:	e4aa                	sd	a0,72(sp)
    80005496:	e8ae                	sd	a1,80(sp)
    80005498:	ecb2                	sd	a2,88(sp)
    8000549a:	f0b6                	sd	a3,96(sp)
    8000549c:	f4ba                	sd	a4,104(sp)
    8000549e:	f8be                	sd	a5,112(sp)
    800054a0:	fcc2                	sd	a6,120(sp)
    800054a2:	e146                	sd	a7,128(sp)
    800054a4:	e54a                	sd	s2,136(sp)
    800054a6:	e94e                	sd	s3,144(sp)
    800054a8:	ed52                	sd	s4,152(sp)
    800054aa:	f156                	sd	s5,160(sp)
    800054ac:	f55a                	sd	s6,168(sp)
    800054ae:	f95e                	sd	s7,176(sp)
    800054b0:	fd62                	sd	s8,184(sp)
    800054b2:	e1e6                	sd	s9,192(sp)
    800054b4:	e5ea                	sd	s10,200(sp)
    800054b6:	e9ee                	sd	s11,208(sp)
    800054b8:	edf2                	sd	t3,216(sp)
    800054ba:	f1f6                	sd	t4,224(sp)
    800054bc:	f5fa                	sd	t5,232(sp)
    800054be:	f9fe                	sd	t6,240(sp)
    800054c0:	a85fc0ef          	jal	80001f44 <kerneltrap>
    800054c4:	6082                	ld	ra,0(sp)
    800054c6:	6122                	ld	sp,8(sp)
    800054c8:	61c2                	ld	gp,16(sp)
    800054ca:	7282                	ld	t0,32(sp)
    800054cc:	7322                	ld	t1,40(sp)
    800054ce:	73c2                	ld	t2,48(sp)
    800054d0:	7462                	ld	s0,56(sp)
    800054d2:	6486                	ld	s1,64(sp)
    800054d4:	6526                	ld	a0,72(sp)
    800054d6:	65c6                	ld	a1,80(sp)
    800054d8:	6666                	ld	a2,88(sp)
    800054da:	7686                	ld	a3,96(sp)
    800054dc:	7726                	ld	a4,104(sp)
    800054de:	77c6                	ld	a5,112(sp)
    800054e0:	7866                	ld	a6,120(sp)
    800054e2:	688a                	ld	a7,128(sp)
    800054e4:	692a                	ld	s2,136(sp)
    800054e6:	69ca                	ld	s3,144(sp)
    800054e8:	6a6a                	ld	s4,152(sp)
    800054ea:	7a8a                	ld	s5,160(sp)
    800054ec:	7b2a                	ld	s6,168(sp)
    800054ee:	7bca                	ld	s7,176(sp)
    800054f0:	7c6a                	ld	s8,184(sp)
    800054f2:	6c8e                	ld	s9,192(sp)
    800054f4:	6d2e                	ld	s10,200(sp)
    800054f6:	6dce                	ld	s11,208(sp)
    800054f8:	6e6e                	ld	t3,216(sp)
    800054fa:	7e8e                	ld	t4,224(sp)
    800054fc:	7f2e                	ld	t5,232(sp)
    800054fe:	7fce                	ld	t6,240(sp)
    80005500:	6111                	addi	sp,sp,256
    80005502:	10200073          	sret
    80005506:	00000013          	nop
    8000550a:	00000013          	nop
    8000550e:	0001                	nop

0000000080005510 <timervec>:
    80005510:	34051573          	csrrw	a0,mscratch,a0
    80005514:	e10c                	sd	a1,0(a0)
    80005516:	e510                	sd	a2,8(a0)
    80005518:	e914                	sd	a3,16(a0)
    8000551a:	6d0c                	ld	a1,24(a0)
    8000551c:	7110                	ld	a2,32(a0)
    8000551e:	6194                	ld	a3,0(a1)
    80005520:	96b2                	add	a3,a3,a2
    80005522:	e194                	sd	a3,0(a1)
    80005524:	4589                	li	a1,2
    80005526:	14459073          	csrw	sip,a1
    8000552a:	6914                	ld	a3,16(a0)
    8000552c:	6510                	ld	a2,8(a0)
    8000552e:	610c                	ld	a1,0(a0)
    80005530:	34051573          	csrrw	a0,mscratch,a0
    80005534:	30200073          	mret
	...

000000008000553a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000553a:	1141                	addi	sp,sp,-16
    8000553c:	e422                	sd	s0,8(sp)
    8000553e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005540:	0c0007b7          	lui	a5,0xc000
    80005544:	4705                	li	a4,1
    80005546:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005548:	0c0007b7          	lui	a5,0xc000
    8000554c:	c3d8                	sw	a4,4(a5)
}
    8000554e:	6422                	ld	s0,8(sp)
    80005550:	0141                	addi	sp,sp,16
    80005552:	8082                	ret

0000000080005554 <plicinithart>:

void
plicinithart(void)
{
    80005554:	1141                	addi	sp,sp,-16
    80005556:	e406                	sd	ra,8(sp)
    80005558:	e022                	sd	s0,0(sp)
    8000555a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000555c:	ffffc097          	auipc	ra,0xffffc
    80005560:	8d2080e7          	jalr	-1838(ra) # 80000e2e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005564:	0085171b          	slliw	a4,a0,0x8
    80005568:	0c0027b7          	lui	a5,0xc002
    8000556c:	97ba                	add	a5,a5,a4
    8000556e:	40200713          	li	a4,1026
    80005572:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005576:	00d5151b          	slliw	a0,a0,0xd
    8000557a:	0c2017b7          	lui	a5,0xc201
    8000557e:	97aa                	add	a5,a5,a0
    80005580:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005584:	60a2                	ld	ra,8(sp)
    80005586:	6402                	ld	s0,0(sp)
    80005588:	0141                	addi	sp,sp,16
    8000558a:	8082                	ret

000000008000558c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000558c:	1141                	addi	sp,sp,-16
    8000558e:	e406                	sd	ra,8(sp)
    80005590:	e022                	sd	s0,0(sp)
    80005592:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005594:	ffffc097          	auipc	ra,0xffffc
    80005598:	89a080e7          	jalr	-1894(ra) # 80000e2e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000559c:	00d5151b          	slliw	a0,a0,0xd
    800055a0:	0c2017b7          	lui	a5,0xc201
    800055a4:	97aa                	add	a5,a5,a0
  return irq;
}
    800055a6:	43c8                	lw	a0,4(a5)
    800055a8:	60a2                	ld	ra,8(sp)
    800055aa:	6402                	ld	s0,0(sp)
    800055ac:	0141                	addi	sp,sp,16
    800055ae:	8082                	ret

00000000800055b0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800055b0:	1101                	addi	sp,sp,-32
    800055b2:	ec06                	sd	ra,24(sp)
    800055b4:	e822                	sd	s0,16(sp)
    800055b6:	e426                	sd	s1,8(sp)
    800055b8:	1000                	addi	s0,sp,32
    800055ba:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055bc:	ffffc097          	auipc	ra,0xffffc
    800055c0:	872080e7          	jalr	-1934(ra) # 80000e2e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800055c4:	00d5151b          	slliw	a0,a0,0xd
    800055c8:	0c2017b7          	lui	a5,0xc201
    800055cc:	97aa                	add	a5,a5,a0
    800055ce:	c3c4                	sw	s1,4(a5)
}
    800055d0:	60e2                	ld	ra,24(sp)
    800055d2:	6442                	ld	s0,16(sp)
    800055d4:	64a2                	ld	s1,8(sp)
    800055d6:	6105                	addi	sp,sp,32
    800055d8:	8082                	ret

00000000800055da <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055da:	1141                	addi	sp,sp,-16
    800055dc:	e406                	sd	ra,8(sp)
    800055de:	e022                	sd	s0,0(sp)
    800055e0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800055e2:	479d                	li	a5,7
    800055e4:	06a7c863          	blt	a5,a0,80005654 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800055e8:	00023717          	auipc	a4,0x23
    800055ec:	a1870713          	addi	a4,a4,-1512 # 80028000 <disk>
    800055f0:	972a                	add	a4,a4,a0
    800055f2:	6789                	lui	a5,0x2
    800055f4:	97ba                	add	a5,a5,a4
    800055f6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800055fa:	e7ad                	bnez	a5,80005664 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800055fc:	00451793          	slli	a5,a0,0x4
    80005600:	00025717          	auipc	a4,0x25
    80005604:	a0070713          	addi	a4,a4,-1536 # 8002a000 <disk+0x2000>
    80005608:	6314                	ld	a3,0(a4)
    8000560a:	96be                	add	a3,a3,a5
    8000560c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005610:	6314                	ld	a3,0(a4)
    80005612:	96be                	add	a3,a3,a5
    80005614:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005618:	6314                	ld	a3,0(a4)
    8000561a:	96be                	add	a3,a3,a5
    8000561c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005620:	6318                	ld	a4,0(a4)
    80005622:	97ba                	add	a5,a5,a4
    80005624:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005628:	00023717          	auipc	a4,0x23
    8000562c:	9d870713          	addi	a4,a4,-1576 # 80028000 <disk>
    80005630:	972a                	add	a4,a4,a0
    80005632:	6789                	lui	a5,0x2
    80005634:	97ba                	add	a5,a5,a4
    80005636:	4705                	li	a4,1
    80005638:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000563c:	00025517          	auipc	a0,0x25
    80005640:	9dc50513          	addi	a0,a0,-1572 # 8002a018 <disk+0x2018>
    80005644:	ffffc097          	auipc	ra,0xffffc
    80005648:	0a2080e7          	jalr	162(ra) # 800016e6 <wakeup>
}
    8000564c:	60a2                	ld	ra,8(sp)
    8000564e:	6402                	ld	s0,0(sp)
    80005650:	0141                	addi	sp,sp,16
    80005652:	8082                	ret
    panic("free_desc 1");
    80005654:	00003517          	auipc	a0,0x3
    80005658:	f6450513          	addi	a0,a0,-156 # 800085b8 <etext+0x5b8>
    8000565c:	00001097          	auipc	ra,0x1
    80005660:	a10080e7          	jalr	-1520(ra) # 8000606c <panic>
    panic("free_desc 2");
    80005664:	00003517          	auipc	a0,0x3
    80005668:	f6450513          	addi	a0,a0,-156 # 800085c8 <etext+0x5c8>
    8000566c:	00001097          	auipc	ra,0x1
    80005670:	a00080e7          	jalr	-1536(ra) # 8000606c <panic>

0000000080005674 <virtio_disk_init>:
{
    80005674:	1141                	addi	sp,sp,-16
    80005676:	e406                	sd	ra,8(sp)
    80005678:	e022                	sd	s0,0(sp)
    8000567a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000567c:	00003597          	auipc	a1,0x3
    80005680:	f5c58593          	addi	a1,a1,-164 # 800085d8 <etext+0x5d8>
    80005684:	00025517          	auipc	a0,0x25
    80005688:	aa450513          	addi	a0,a0,-1372 # 8002a128 <disk+0x2128>
    8000568c:	00001097          	auipc	ra,0x1
    80005690:	eca080e7          	jalr	-310(ra) # 80006556 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005694:	100017b7          	lui	a5,0x10001
    80005698:	4398                	lw	a4,0(a5)
    8000569a:	2701                	sext.w	a4,a4
    8000569c:	747277b7          	lui	a5,0x74727
    800056a0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800056a4:	0ef71f63          	bne	a4,a5,800057a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800056a8:	100017b7          	lui	a5,0x10001
    800056ac:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800056ae:	439c                	lw	a5,0(a5)
    800056b0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056b2:	4705                	li	a4,1
    800056b4:	0ee79763          	bne	a5,a4,800057a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056b8:	100017b7          	lui	a5,0x10001
    800056bc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800056be:	439c                	lw	a5,0(a5)
    800056c0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800056c2:	4709                	li	a4,2
    800056c4:	0ce79f63          	bne	a5,a4,800057a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800056c8:	100017b7          	lui	a5,0x10001
    800056cc:	47d8                	lw	a4,12(a5)
    800056ce:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056d0:	554d47b7          	lui	a5,0x554d4
    800056d4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056d8:	0cf71563          	bne	a4,a5,800057a2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056dc:	100017b7          	lui	a5,0x10001
    800056e0:	4705                	li	a4,1
    800056e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056e4:	470d                	li	a4,3
    800056e6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056e8:	10001737          	lui	a4,0x10001
    800056ec:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056ee:	c7ffe737          	lui	a4,0xc7ffe
    800056f2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fcb51f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056f6:	8ef9                	and	a3,a3,a4
    800056f8:	10001737          	lui	a4,0x10001
    800056fc:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056fe:	472d                	li	a4,11
    80005700:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005702:	473d                	li	a4,15
    80005704:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005706:	100017b7          	lui	a5,0x10001
    8000570a:	6705                	lui	a4,0x1
    8000570c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000570e:	100017b7          	lui	a5,0x10001
    80005712:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005716:	100017b7          	lui	a5,0x10001
    8000571a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000571e:	439c                	lw	a5,0(a5)
    80005720:	2781                	sext.w	a5,a5
  if(max == 0)
    80005722:	cbc1                	beqz	a5,800057b2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005724:	471d                	li	a4,7
    80005726:	08f77e63          	bgeu	a4,a5,800057c2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000572a:	100017b7          	lui	a5,0x10001
    8000572e:	4721                	li	a4,8
    80005730:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005732:	6609                	lui	a2,0x2
    80005734:	4581                	li	a1,0
    80005736:	00023517          	auipc	a0,0x23
    8000573a:	8ca50513          	addi	a0,a0,-1846 # 80028000 <disk>
    8000573e:	ffffb097          	auipc	ra,0xffffb
    80005742:	a3c080e7          	jalr	-1476(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005746:	00023697          	auipc	a3,0x23
    8000574a:	8ba68693          	addi	a3,a3,-1862 # 80028000 <disk>
    8000574e:	00c6d713          	srli	a4,a3,0xc
    80005752:	2701                	sext.w	a4,a4
    80005754:	100017b7          	lui	a5,0x10001
    80005758:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000575a:	00025797          	auipc	a5,0x25
    8000575e:	8a678793          	addi	a5,a5,-1882 # 8002a000 <disk+0x2000>
    80005762:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005764:	00023717          	auipc	a4,0x23
    80005768:	91c70713          	addi	a4,a4,-1764 # 80028080 <disk+0x80>
    8000576c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000576e:	00024717          	auipc	a4,0x24
    80005772:	89270713          	addi	a4,a4,-1902 # 80029000 <disk+0x1000>
    80005776:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005778:	4705                	li	a4,1
    8000577a:	00e78c23          	sb	a4,24(a5)
    8000577e:	00e78ca3          	sb	a4,25(a5)
    80005782:	00e78d23          	sb	a4,26(a5)
    80005786:	00e78da3          	sb	a4,27(a5)
    8000578a:	00e78e23          	sb	a4,28(a5)
    8000578e:	00e78ea3          	sb	a4,29(a5)
    80005792:	00e78f23          	sb	a4,30(a5)
    80005796:	00e78fa3          	sb	a4,31(a5)
}
    8000579a:	60a2                	ld	ra,8(sp)
    8000579c:	6402                	ld	s0,0(sp)
    8000579e:	0141                	addi	sp,sp,16
    800057a0:	8082                	ret
    panic("could not find virtio disk");
    800057a2:	00003517          	auipc	a0,0x3
    800057a6:	e4650513          	addi	a0,a0,-442 # 800085e8 <etext+0x5e8>
    800057aa:	00001097          	auipc	ra,0x1
    800057ae:	8c2080e7          	jalr	-1854(ra) # 8000606c <panic>
    panic("virtio disk has no queue 0");
    800057b2:	00003517          	auipc	a0,0x3
    800057b6:	e5650513          	addi	a0,a0,-426 # 80008608 <etext+0x608>
    800057ba:	00001097          	auipc	ra,0x1
    800057be:	8b2080e7          	jalr	-1870(ra) # 8000606c <panic>
    panic("virtio disk max queue too short");
    800057c2:	00003517          	auipc	a0,0x3
    800057c6:	e6650513          	addi	a0,a0,-410 # 80008628 <etext+0x628>
    800057ca:	00001097          	auipc	ra,0x1
    800057ce:	8a2080e7          	jalr	-1886(ra) # 8000606c <panic>

00000000800057d2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057d2:	7159                	addi	sp,sp,-112
    800057d4:	f486                	sd	ra,104(sp)
    800057d6:	f0a2                	sd	s0,96(sp)
    800057d8:	eca6                	sd	s1,88(sp)
    800057da:	e8ca                	sd	s2,80(sp)
    800057dc:	e4ce                	sd	s3,72(sp)
    800057de:	e0d2                	sd	s4,64(sp)
    800057e0:	fc56                	sd	s5,56(sp)
    800057e2:	f85a                	sd	s6,48(sp)
    800057e4:	f45e                	sd	s7,40(sp)
    800057e6:	f062                	sd	s8,32(sp)
    800057e8:	ec66                	sd	s9,24(sp)
    800057ea:	1880                	addi	s0,sp,112
    800057ec:	8a2a                	mv	s4,a0
    800057ee:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057f0:	00c52c03          	lw	s8,12(a0)
    800057f4:	001c1c1b          	slliw	s8,s8,0x1
    800057f8:	1c02                	slli	s8,s8,0x20
    800057fa:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800057fe:	00025517          	auipc	a0,0x25
    80005802:	92a50513          	addi	a0,a0,-1750 # 8002a128 <disk+0x2128>
    80005806:	00001097          	auipc	ra,0x1
    8000580a:	de0080e7          	jalr	-544(ra) # 800065e6 <acquire>
  for(int i = 0; i < 3; i++){
    8000580e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005810:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005812:	00022b97          	auipc	s7,0x22
    80005816:	7eeb8b93          	addi	s7,s7,2030 # 80028000 <disk>
    8000581a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000581c:	4a8d                	li	s5,3
    8000581e:	a88d                	j	80005890 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005820:	00fb8733          	add	a4,s7,a5
    80005824:	975a                	add	a4,a4,s6
    80005826:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000582a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000582c:	0207c563          	bltz	a5,80005856 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005830:	2905                	addiw	s2,s2,1
    80005832:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005834:	1b590163          	beq	s2,s5,800059d6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005838:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000583a:	00024717          	auipc	a4,0x24
    8000583e:	7de70713          	addi	a4,a4,2014 # 8002a018 <disk+0x2018>
    80005842:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005844:	00074683          	lbu	a3,0(a4)
    80005848:	fee1                	bnez	a3,80005820 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000584a:	2785                	addiw	a5,a5,1
    8000584c:	0705                	addi	a4,a4,1
    8000584e:	fe979be3          	bne	a5,s1,80005844 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005852:	57fd                	li	a5,-1
    80005854:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005856:	03205163          	blez	s2,80005878 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000585a:	f9042503          	lw	a0,-112(s0)
    8000585e:	00000097          	auipc	ra,0x0
    80005862:	d7c080e7          	jalr	-644(ra) # 800055da <free_desc>
      for(int j = 0; j < i; j++)
    80005866:	4785                	li	a5,1
    80005868:	0127d863          	bge	a5,s2,80005878 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000586c:	f9442503          	lw	a0,-108(s0)
    80005870:	00000097          	auipc	ra,0x0
    80005874:	d6a080e7          	jalr	-662(ra) # 800055da <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005878:	00025597          	auipc	a1,0x25
    8000587c:	8b058593          	addi	a1,a1,-1872 # 8002a128 <disk+0x2128>
    80005880:	00024517          	auipc	a0,0x24
    80005884:	79850513          	addi	a0,a0,1944 # 8002a018 <disk+0x2018>
    80005888:	ffffc097          	auipc	ra,0xffffc
    8000588c:	cd2080e7          	jalr	-814(ra) # 8000155a <sleep>
  for(int i = 0; i < 3; i++){
    80005890:	f9040613          	addi	a2,s0,-112
    80005894:	894e                	mv	s2,s3
    80005896:	b74d                	j	80005838 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005898:	00024717          	auipc	a4,0x24
    8000589c:	76873703          	ld	a4,1896(a4) # 8002a000 <disk+0x2000>
    800058a0:	973e                	add	a4,a4,a5
    800058a2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058a6:	00022897          	auipc	a7,0x22
    800058aa:	75a88893          	addi	a7,a7,1882 # 80028000 <disk>
    800058ae:	00024717          	auipc	a4,0x24
    800058b2:	75270713          	addi	a4,a4,1874 # 8002a000 <disk+0x2000>
    800058b6:	6314                	ld	a3,0(a4)
    800058b8:	96be                	add	a3,a3,a5
    800058ba:	00c6d583          	lhu	a1,12(a3)
    800058be:	0015e593          	ori	a1,a1,1
    800058c2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800058c6:	f9842683          	lw	a3,-104(s0)
    800058ca:	630c                	ld	a1,0(a4)
    800058cc:	97ae                	add	a5,a5,a1
    800058ce:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058d2:	20050593          	addi	a1,a0,512
    800058d6:	0592                	slli	a1,a1,0x4
    800058d8:	95c6                	add	a1,a1,a7
    800058da:	57fd                	li	a5,-1
    800058dc:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058e0:	00469793          	slli	a5,a3,0x4
    800058e4:	00073803          	ld	a6,0(a4)
    800058e8:	983e                	add	a6,a6,a5
    800058ea:	6689                	lui	a3,0x2
    800058ec:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800058f0:	96b2                	add	a3,a3,a2
    800058f2:	96c6                	add	a3,a3,a7
    800058f4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800058f8:	6314                	ld	a3,0(a4)
    800058fa:	96be                	add	a3,a3,a5
    800058fc:	4605                	li	a2,1
    800058fe:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005900:	6314                	ld	a3,0(a4)
    80005902:	96be                	add	a3,a3,a5
    80005904:	4809                	li	a6,2
    80005906:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000590a:	6314                	ld	a3,0(a4)
    8000590c:	97b6                	add	a5,a5,a3
    8000590e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005912:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005916:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000591a:	6714                	ld	a3,8(a4)
    8000591c:	0026d783          	lhu	a5,2(a3)
    80005920:	8b9d                	andi	a5,a5,7
    80005922:	0786                	slli	a5,a5,0x1
    80005924:	96be                	add	a3,a3,a5
    80005926:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000592a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000592e:	6718                	ld	a4,8(a4)
    80005930:	00275783          	lhu	a5,2(a4)
    80005934:	2785                	addiw	a5,a5,1
    80005936:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000593a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000593e:	100017b7          	lui	a5,0x10001
    80005942:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005946:	004a2783          	lw	a5,4(s4)
    8000594a:	02c79163          	bne	a5,a2,8000596c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000594e:	00024917          	auipc	s2,0x24
    80005952:	7da90913          	addi	s2,s2,2010 # 8002a128 <disk+0x2128>
  while(b->disk == 1) {
    80005956:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005958:	85ca                	mv	a1,s2
    8000595a:	8552                	mv	a0,s4
    8000595c:	ffffc097          	auipc	ra,0xffffc
    80005960:	bfe080e7          	jalr	-1026(ra) # 8000155a <sleep>
  while(b->disk == 1) {
    80005964:	004a2783          	lw	a5,4(s4)
    80005968:	fe9788e3          	beq	a5,s1,80005958 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000596c:	f9042903          	lw	s2,-112(s0)
    80005970:	20090713          	addi	a4,s2,512
    80005974:	0712                	slli	a4,a4,0x4
    80005976:	00022797          	auipc	a5,0x22
    8000597a:	68a78793          	addi	a5,a5,1674 # 80028000 <disk>
    8000597e:	97ba                	add	a5,a5,a4
    80005980:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005984:	00024997          	auipc	s3,0x24
    80005988:	67c98993          	addi	s3,s3,1660 # 8002a000 <disk+0x2000>
    8000598c:	00491713          	slli	a4,s2,0x4
    80005990:	0009b783          	ld	a5,0(s3)
    80005994:	97ba                	add	a5,a5,a4
    80005996:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000599a:	854a                	mv	a0,s2
    8000599c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	c3a080e7          	jalr	-966(ra) # 800055da <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059a8:	8885                	andi	s1,s1,1
    800059aa:	f0ed                	bnez	s1,8000598c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059ac:	00024517          	auipc	a0,0x24
    800059b0:	77c50513          	addi	a0,a0,1916 # 8002a128 <disk+0x2128>
    800059b4:	00001097          	auipc	ra,0x1
    800059b8:	ce6080e7          	jalr	-794(ra) # 8000669a <release>
}
    800059bc:	70a6                	ld	ra,104(sp)
    800059be:	7406                	ld	s0,96(sp)
    800059c0:	64e6                	ld	s1,88(sp)
    800059c2:	6946                	ld	s2,80(sp)
    800059c4:	69a6                	ld	s3,72(sp)
    800059c6:	6a06                	ld	s4,64(sp)
    800059c8:	7ae2                	ld	s5,56(sp)
    800059ca:	7b42                	ld	s6,48(sp)
    800059cc:	7ba2                	ld	s7,40(sp)
    800059ce:	7c02                	ld	s8,32(sp)
    800059d0:	6ce2                	ld	s9,24(sp)
    800059d2:	6165                	addi	sp,sp,112
    800059d4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059d6:	f9042503          	lw	a0,-112(s0)
    800059da:	00451613          	slli	a2,a0,0x4
  if(write)
    800059de:	00022597          	auipc	a1,0x22
    800059e2:	62258593          	addi	a1,a1,1570 # 80028000 <disk>
    800059e6:	20050793          	addi	a5,a0,512
    800059ea:	0792                	slli	a5,a5,0x4
    800059ec:	97ae                	add	a5,a5,a1
    800059ee:	01903733          	snez	a4,s9
    800059f2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800059f6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800059fa:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800059fe:	00024717          	auipc	a4,0x24
    80005a02:	60270713          	addi	a4,a4,1538 # 8002a000 <disk+0x2000>
    80005a06:	6314                	ld	a3,0(a4)
    80005a08:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a0a:	6789                	lui	a5,0x2
    80005a0c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005a10:	97b2                	add	a5,a5,a2
    80005a12:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a14:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a16:	631c                	ld	a5,0(a4)
    80005a18:	97b2                	add	a5,a5,a2
    80005a1a:	46c1                	li	a3,16
    80005a1c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a1e:	631c                	ld	a5,0(a4)
    80005a20:	97b2                	add	a5,a5,a2
    80005a22:	4685                	li	a3,1
    80005a24:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005a28:	f9442783          	lw	a5,-108(s0)
    80005a2c:	6314                	ld	a3,0(a4)
    80005a2e:	96b2                	add	a3,a3,a2
    80005a30:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a34:	0792                	slli	a5,a5,0x4
    80005a36:	6314                	ld	a3,0(a4)
    80005a38:	96be                	add	a3,a3,a5
    80005a3a:	058a0593          	addi	a1,s4,88
    80005a3e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005a40:	6318                	ld	a4,0(a4)
    80005a42:	973e                	add	a4,a4,a5
    80005a44:	40000693          	li	a3,1024
    80005a48:	c714                	sw	a3,8(a4)
  if(write)
    80005a4a:	e40c97e3          	bnez	s9,80005898 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005a4e:	00024717          	auipc	a4,0x24
    80005a52:	5b273703          	ld	a4,1458(a4) # 8002a000 <disk+0x2000>
    80005a56:	973e                	add	a4,a4,a5
    80005a58:	4689                	li	a3,2
    80005a5a:	00d71623          	sh	a3,12(a4)
    80005a5e:	b5a1                	j	800058a6 <virtio_disk_rw+0xd4>

0000000080005a60 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a60:	1101                	addi	sp,sp,-32
    80005a62:	ec06                	sd	ra,24(sp)
    80005a64:	e822                	sd	s0,16(sp)
    80005a66:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a68:	00024517          	auipc	a0,0x24
    80005a6c:	6c050513          	addi	a0,a0,1728 # 8002a128 <disk+0x2128>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	b76080e7          	jalr	-1162(ra) # 800065e6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a78:	100017b7          	lui	a5,0x10001
    80005a7c:	53b8                	lw	a4,96(a5)
    80005a7e:	8b0d                	andi	a4,a4,3
    80005a80:	100017b7          	lui	a5,0x10001
    80005a84:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a86:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a8a:	00024797          	auipc	a5,0x24
    80005a8e:	57678793          	addi	a5,a5,1398 # 8002a000 <disk+0x2000>
    80005a92:	6b94                	ld	a3,16(a5)
    80005a94:	0207d703          	lhu	a4,32(a5)
    80005a98:	0026d783          	lhu	a5,2(a3)
    80005a9c:	06f70563          	beq	a4,a5,80005b06 <virtio_disk_intr+0xa6>
    80005aa0:	e426                	sd	s1,8(sp)
    80005aa2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005aa4:	00022917          	auipc	s2,0x22
    80005aa8:	55c90913          	addi	s2,s2,1372 # 80028000 <disk>
    80005aac:	00024497          	auipc	s1,0x24
    80005ab0:	55448493          	addi	s1,s1,1364 # 8002a000 <disk+0x2000>
    __sync_synchronize();
    80005ab4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ab8:	6898                	ld	a4,16(s1)
    80005aba:	0204d783          	lhu	a5,32(s1)
    80005abe:	8b9d                	andi	a5,a5,7
    80005ac0:	078e                	slli	a5,a5,0x3
    80005ac2:	97ba                	add	a5,a5,a4
    80005ac4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005ac6:	20078713          	addi	a4,a5,512
    80005aca:	0712                	slli	a4,a4,0x4
    80005acc:	974a                	add	a4,a4,s2
    80005ace:	03074703          	lbu	a4,48(a4)
    80005ad2:	e731                	bnez	a4,80005b1e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ad4:	20078793          	addi	a5,a5,512
    80005ad8:	0792                	slli	a5,a5,0x4
    80005ada:	97ca                	add	a5,a5,s2
    80005adc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005ade:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005ae2:	ffffc097          	auipc	ra,0xffffc
    80005ae6:	c04080e7          	jalr	-1020(ra) # 800016e6 <wakeup>

    disk.used_idx += 1;
    80005aea:	0204d783          	lhu	a5,32(s1)
    80005aee:	2785                	addiw	a5,a5,1
    80005af0:	17c2                	slli	a5,a5,0x30
    80005af2:	93c1                	srli	a5,a5,0x30
    80005af4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005af8:	6898                	ld	a4,16(s1)
    80005afa:	00275703          	lhu	a4,2(a4)
    80005afe:	faf71be3          	bne	a4,a5,80005ab4 <virtio_disk_intr+0x54>
    80005b02:	64a2                	ld	s1,8(sp)
    80005b04:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005b06:	00024517          	auipc	a0,0x24
    80005b0a:	62250513          	addi	a0,a0,1570 # 8002a128 <disk+0x2128>
    80005b0e:	00001097          	auipc	ra,0x1
    80005b12:	b8c080e7          	jalr	-1140(ra) # 8000669a <release>
}
    80005b16:	60e2                	ld	ra,24(sp)
    80005b18:	6442                	ld	s0,16(sp)
    80005b1a:	6105                	addi	sp,sp,32
    80005b1c:	8082                	ret
      panic("virtio_disk_intr status");
    80005b1e:	00003517          	auipc	a0,0x3
    80005b22:	b2a50513          	addi	a0,a0,-1238 # 80008648 <etext+0x648>
    80005b26:	00000097          	auipc	ra,0x0
    80005b2a:	546080e7          	jalr	1350(ra) # 8000606c <panic>

0000000080005b2e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005b2e:	1141                	addi	sp,sp,-16
    80005b30:	e422                	sd	s0,8(sp)
    80005b32:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b34:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b38:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b3c:	0037979b          	slliw	a5,a5,0x3
    80005b40:	02004737          	lui	a4,0x2004
    80005b44:	97ba                	add	a5,a5,a4
    80005b46:	0200c737          	lui	a4,0x200c
    80005b4a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005b4c:	6318                	ld	a4,0(a4)
    80005b4e:	000f4637          	lui	a2,0xf4
    80005b52:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b56:	9732                	add	a4,a4,a2
    80005b58:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b5a:	00259693          	slli	a3,a1,0x2
    80005b5e:	96ae                	add	a3,a3,a1
    80005b60:	068e                	slli	a3,a3,0x3
    80005b62:	00025717          	auipc	a4,0x25
    80005b66:	49e70713          	addi	a4,a4,1182 # 8002b000 <timer_scratch>
    80005b6a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b6c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b6e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b70:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b74:	00000797          	auipc	a5,0x0
    80005b78:	99c78793          	addi	a5,a5,-1636 # 80005510 <timervec>
    80005b7c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b80:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b84:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b88:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b8c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b90:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b94:	30479073          	csrw	mie,a5
}
    80005b98:	6422                	ld	s0,8(sp)
    80005b9a:	0141                	addi	sp,sp,16
    80005b9c:	8082                	ret

0000000080005b9e <start>:
{
    80005b9e:	1141                	addi	sp,sp,-16
    80005ba0:	e406                	sd	ra,8(sp)
    80005ba2:	e022                	sd	s0,0(sp)
    80005ba4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ba6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005baa:	7779                	lui	a4,0xffffe
    80005bac:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcb5bf>
    80005bb0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005bb2:	6705                	lui	a4,0x1
    80005bb4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005bb8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005bba:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005bbe:	ffffa797          	auipc	a5,0xffffa
    80005bc2:	75a78793          	addi	a5,a5,1882 # 80000318 <main>
    80005bc6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005bca:	4781                	li	a5,0
    80005bcc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005bd0:	67c1                	lui	a5,0x10
    80005bd2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005bd4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005bd8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005bdc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005be0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005be4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005be8:	57fd                	li	a5,-1
    80005bea:	83a9                	srli	a5,a5,0xa
    80005bec:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005bf0:	47bd                	li	a5,15
    80005bf2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005bf6:	00000097          	auipc	ra,0x0
    80005bfa:	f38080e7          	jalr	-200(ra) # 80005b2e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bfe:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c02:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005c04:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c06:	30200073          	mret
}
    80005c0a:	60a2                	ld	ra,8(sp)
    80005c0c:	6402                	ld	s0,0(sp)
    80005c0e:	0141                	addi	sp,sp,16
    80005c10:	8082                	ret

0000000080005c12 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005c12:	715d                	addi	sp,sp,-80
    80005c14:	e486                	sd	ra,72(sp)
    80005c16:	e0a2                	sd	s0,64(sp)
    80005c18:	f84a                	sd	s2,48(sp)
    80005c1a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005c1c:	04c05663          	blez	a2,80005c68 <consolewrite+0x56>
    80005c20:	fc26                	sd	s1,56(sp)
    80005c22:	f44e                	sd	s3,40(sp)
    80005c24:	f052                	sd	s4,32(sp)
    80005c26:	ec56                	sd	s5,24(sp)
    80005c28:	8a2a                	mv	s4,a0
    80005c2a:	84ae                	mv	s1,a1
    80005c2c:	89b2                	mv	s3,a2
    80005c2e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c30:	5afd                	li	s5,-1
    80005c32:	4685                	li	a3,1
    80005c34:	8626                	mv	a2,s1
    80005c36:	85d2                	mv	a1,s4
    80005c38:	fbf40513          	addi	a0,s0,-65
    80005c3c:	ffffc097          	auipc	ra,0xffffc
    80005c40:	d80080e7          	jalr	-640(ra) # 800019bc <either_copyin>
    80005c44:	03550463          	beq	a0,s5,80005c6c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005c48:	fbf44503          	lbu	a0,-65(s0)
    80005c4c:	00000097          	auipc	ra,0x0
    80005c50:	7de080e7          	jalr	2014(ra) # 8000642a <uartputc>
  for(i = 0; i < n; i++){
    80005c54:	2905                	addiw	s2,s2,1
    80005c56:	0485                	addi	s1,s1,1
    80005c58:	fd299de3          	bne	s3,s2,80005c32 <consolewrite+0x20>
    80005c5c:	894e                	mv	s2,s3
    80005c5e:	74e2                	ld	s1,56(sp)
    80005c60:	79a2                	ld	s3,40(sp)
    80005c62:	7a02                	ld	s4,32(sp)
    80005c64:	6ae2                	ld	s5,24(sp)
    80005c66:	a039                	j	80005c74 <consolewrite+0x62>
    80005c68:	4901                	li	s2,0
    80005c6a:	a029                	j	80005c74 <consolewrite+0x62>
    80005c6c:	74e2                	ld	s1,56(sp)
    80005c6e:	79a2                	ld	s3,40(sp)
    80005c70:	7a02                	ld	s4,32(sp)
    80005c72:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005c74:	854a                	mv	a0,s2
    80005c76:	60a6                	ld	ra,72(sp)
    80005c78:	6406                	ld	s0,64(sp)
    80005c7a:	7942                	ld	s2,48(sp)
    80005c7c:	6161                	addi	sp,sp,80
    80005c7e:	8082                	ret

0000000080005c80 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c80:	711d                	addi	sp,sp,-96
    80005c82:	ec86                	sd	ra,88(sp)
    80005c84:	e8a2                	sd	s0,80(sp)
    80005c86:	e4a6                	sd	s1,72(sp)
    80005c88:	e0ca                	sd	s2,64(sp)
    80005c8a:	fc4e                	sd	s3,56(sp)
    80005c8c:	f852                	sd	s4,48(sp)
    80005c8e:	f456                	sd	s5,40(sp)
    80005c90:	f05a                	sd	s6,32(sp)
    80005c92:	1080                	addi	s0,sp,96
    80005c94:	8aaa                	mv	s5,a0
    80005c96:	8a2e                	mv	s4,a1
    80005c98:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c9a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c9e:	0002d517          	auipc	a0,0x2d
    80005ca2:	4a250513          	addi	a0,a0,1186 # 80033140 <cons>
    80005ca6:	00001097          	auipc	ra,0x1
    80005caa:	940080e7          	jalr	-1728(ra) # 800065e6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005cae:	0002d497          	auipc	s1,0x2d
    80005cb2:	49248493          	addi	s1,s1,1170 # 80033140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005cb6:	0002d917          	auipc	s2,0x2d
    80005cba:	52290913          	addi	s2,s2,1314 # 800331d8 <cons+0x98>
  while(n > 0){
    80005cbe:	0d305463          	blez	s3,80005d86 <consoleread+0x106>
    while(cons.r == cons.w){
    80005cc2:	0984a783          	lw	a5,152(s1)
    80005cc6:	09c4a703          	lw	a4,156(s1)
    80005cca:	0af71963          	bne	a4,a5,80005d7c <consoleread+0xfc>
      if(myproc()->killed){
    80005cce:	ffffb097          	auipc	ra,0xffffb
    80005cd2:	18c080e7          	jalr	396(ra) # 80000e5a <myproc>
    80005cd6:	551c                	lw	a5,40(a0)
    80005cd8:	e7ad                	bnez	a5,80005d42 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005cda:	85a6                	mv	a1,s1
    80005cdc:	854a                	mv	a0,s2
    80005cde:	ffffc097          	auipc	ra,0xffffc
    80005ce2:	87c080e7          	jalr	-1924(ra) # 8000155a <sleep>
    while(cons.r == cons.w){
    80005ce6:	0984a783          	lw	a5,152(s1)
    80005cea:	09c4a703          	lw	a4,156(s1)
    80005cee:	fef700e3          	beq	a4,a5,80005cce <consoleread+0x4e>
    80005cf2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005cf4:	0002d717          	auipc	a4,0x2d
    80005cf8:	44c70713          	addi	a4,a4,1100 # 80033140 <cons>
    80005cfc:	0017869b          	addiw	a3,a5,1
    80005d00:	08d72c23          	sw	a3,152(a4)
    80005d04:	07f7f693          	andi	a3,a5,127
    80005d08:	9736                	add	a4,a4,a3
    80005d0a:	01874703          	lbu	a4,24(a4)
    80005d0e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005d12:	4691                	li	a3,4
    80005d14:	04db8a63          	beq	s7,a3,80005d68 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005d18:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d1c:	4685                	li	a3,1
    80005d1e:	faf40613          	addi	a2,s0,-81
    80005d22:	85d2                	mv	a1,s4
    80005d24:	8556                	mv	a0,s5
    80005d26:	ffffc097          	auipc	ra,0xffffc
    80005d2a:	c40080e7          	jalr	-960(ra) # 80001966 <either_copyout>
    80005d2e:	57fd                	li	a5,-1
    80005d30:	04f50a63          	beq	a0,a5,80005d84 <consoleread+0x104>
      break;

    dst++;
    80005d34:	0a05                	addi	s4,s4,1
    --n;
    80005d36:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005d38:	47a9                	li	a5,10
    80005d3a:	06fb8163          	beq	s7,a5,80005d9c <consoleread+0x11c>
    80005d3e:	6be2                	ld	s7,24(sp)
    80005d40:	bfbd                	j	80005cbe <consoleread+0x3e>
        release(&cons.lock);
    80005d42:	0002d517          	auipc	a0,0x2d
    80005d46:	3fe50513          	addi	a0,a0,1022 # 80033140 <cons>
    80005d4a:	00001097          	auipc	ra,0x1
    80005d4e:	950080e7          	jalr	-1712(ra) # 8000669a <release>
        return -1;
    80005d52:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005d54:	60e6                	ld	ra,88(sp)
    80005d56:	6446                	ld	s0,80(sp)
    80005d58:	64a6                	ld	s1,72(sp)
    80005d5a:	6906                	ld	s2,64(sp)
    80005d5c:	79e2                	ld	s3,56(sp)
    80005d5e:	7a42                	ld	s4,48(sp)
    80005d60:	7aa2                	ld	s5,40(sp)
    80005d62:	7b02                	ld	s6,32(sp)
    80005d64:	6125                	addi	sp,sp,96
    80005d66:	8082                	ret
      if(n < target){
    80005d68:	0009871b          	sext.w	a4,s3
    80005d6c:	01677a63          	bgeu	a4,s6,80005d80 <consoleread+0x100>
        cons.r--;
    80005d70:	0002d717          	auipc	a4,0x2d
    80005d74:	46f72423          	sw	a5,1128(a4) # 800331d8 <cons+0x98>
    80005d78:	6be2                	ld	s7,24(sp)
    80005d7a:	a031                	j	80005d86 <consoleread+0x106>
    80005d7c:	ec5e                	sd	s7,24(sp)
    80005d7e:	bf9d                	j	80005cf4 <consoleread+0x74>
    80005d80:	6be2                	ld	s7,24(sp)
    80005d82:	a011                	j	80005d86 <consoleread+0x106>
    80005d84:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005d86:	0002d517          	auipc	a0,0x2d
    80005d8a:	3ba50513          	addi	a0,a0,954 # 80033140 <cons>
    80005d8e:	00001097          	auipc	ra,0x1
    80005d92:	90c080e7          	jalr	-1780(ra) # 8000669a <release>
  return target - n;
    80005d96:	413b053b          	subw	a0,s6,s3
    80005d9a:	bf6d                	j	80005d54 <consoleread+0xd4>
    80005d9c:	6be2                	ld	s7,24(sp)
    80005d9e:	b7e5                	j	80005d86 <consoleread+0x106>

0000000080005da0 <consputc>:
{
    80005da0:	1141                	addi	sp,sp,-16
    80005da2:	e406                	sd	ra,8(sp)
    80005da4:	e022                	sd	s0,0(sp)
    80005da6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005da8:	10000793          	li	a5,256
    80005dac:	00f50a63          	beq	a0,a5,80005dc0 <consputc+0x20>
    uartputc_sync(c);
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	59c080e7          	jalr	1436(ra) # 8000634c <uartputc_sync>
}
    80005db8:	60a2                	ld	ra,8(sp)
    80005dba:	6402                	ld	s0,0(sp)
    80005dbc:	0141                	addi	sp,sp,16
    80005dbe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005dc0:	4521                	li	a0,8
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	58a080e7          	jalr	1418(ra) # 8000634c <uartputc_sync>
    80005dca:	02000513          	li	a0,32
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	57e080e7          	jalr	1406(ra) # 8000634c <uartputc_sync>
    80005dd6:	4521                	li	a0,8
    80005dd8:	00000097          	auipc	ra,0x0
    80005ddc:	574080e7          	jalr	1396(ra) # 8000634c <uartputc_sync>
    80005de0:	bfe1                	j	80005db8 <consputc+0x18>

0000000080005de2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005de2:	1101                	addi	sp,sp,-32
    80005de4:	ec06                	sd	ra,24(sp)
    80005de6:	e822                	sd	s0,16(sp)
    80005de8:	e426                	sd	s1,8(sp)
    80005dea:	1000                	addi	s0,sp,32
    80005dec:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005dee:	0002d517          	auipc	a0,0x2d
    80005df2:	35250513          	addi	a0,a0,850 # 80033140 <cons>
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	7f0080e7          	jalr	2032(ra) # 800065e6 <acquire>

  switch(c){
    80005dfe:	47d5                	li	a5,21
    80005e00:	0af48563          	beq	s1,a5,80005eaa <consoleintr+0xc8>
    80005e04:	0297c963          	blt	a5,s1,80005e36 <consoleintr+0x54>
    80005e08:	47a1                	li	a5,8
    80005e0a:	0ef48c63          	beq	s1,a5,80005f02 <consoleintr+0x120>
    80005e0e:	47c1                	li	a5,16
    80005e10:	10f49f63          	bne	s1,a5,80005f2e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005e14:	ffffc097          	auipc	ra,0xffffc
    80005e18:	bfe080e7          	jalr	-1026(ra) # 80001a12 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005e1c:	0002d517          	auipc	a0,0x2d
    80005e20:	32450513          	addi	a0,a0,804 # 80033140 <cons>
    80005e24:	00001097          	auipc	ra,0x1
    80005e28:	876080e7          	jalr	-1930(ra) # 8000669a <release>
}
    80005e2c:	60e2                	ld	ra,24(sp)
    80005e2e:	6442                	ld	s0,16(sp)
    80005e30:	64a2                	ld	s1,8(sp)
    80005e32:	6105                	addi	sp,sp,32
    80005e34:	8082                	ret
  switch(c){
    80005e36:	07f00793          	li	a5,127
    80005e3a:	0cf48463          	beq	s1,a5,80005f02 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e3e:	0002d717          	auipc	a4,0x2d
    80005e42:	30270713          	addi	a4,a4,770 # 80033140 <cons>
    80005e46:	0a072783          	lw	a5,160(a4)
    80005e4a:	09872703          	lw	a4,152(a4)
    80005e4e:	9f99                	subw	a5,a5,a4
    80005e50:	07f00713          	li	a4,127
    80005e54:	fcf764e3          	bltu	a4,a5,80005e1c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005e58:	47b5                	li	a5,13
    80005e5a:	0cf48d63          	beq	s1,a5,80005f34 <consoleintr+0x152>
      consputc(c);
    80005e5e:	8526                	mv	a0,s1
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	f40080e7          	jalr	-192(ra) # 80005da0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e68:	0002d797          	auipc	a5,0x2d
    80005e6c:	2d878793          	addi	a5,a5,728 # 80033140 <cons>
    80005e70:	0a07a703          	lw	a4,160(a5)
    80005e74:	0017069b          	addiw	a3,a4,1
    80005e78:	0006861b          	sext.w	a2,a3
    80005e7c:	0ad7a023          	sw	a3,160(a5)
    80005e80:	07f77713          	andi	a4,a4,127
    80005e84:	97ba                	add	a5,a5,a4
    80005e86:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005e8a:	47a9                	li	a5,10
    80005e8c:	0cf48b63          	beq	s1,a5,80005f62 <consoleintr+0x180>
    80005e90:	4791                	li	a5,4
    80005e92:	0cf48863          	beq	s1,a5,80005f62 <consoleintr+0x180>
    80005e96:	0002d797          	auipc	a5,0x2d
    80005e9a:	3427a783          	lw	a5,834(a5) # 800331d8 <cons+0x98>
    80005e9e:	0807879b          	addiw	a5,a5,128
    80005ea2:	f6f61de3          	bne	a2,a5,80005e1c <consoleintr+0x3a>
    80005ea6:	863e                	mv	a2,a5
    80005ea8:	a86d                	j	80005f62 <consoleintr+0x180>
    80005eaa:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005eac:	0002d717          	auipc	a4,0x2d
    80005eb0:	29470713          	addi	a4,a4,660 # 80033140 <cons>
    80005eb4:	0a072783          	lw	a5,160(a4)
    80005eb8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ebc:	0002d497          	auipc	s1,0x2d
    80005ec0:	28448493          	addi	s1,s1,644 # 80033140 <cons>
    while(cons.e != cons.w &&
    80005ec4:	4929                	li	s2,10
    80005ec6:	02f70a63          	beq	a4,a5,80005efa <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005eca:	37fd                	addiw	a5,a5,-1
    80005ecc:	07f7f713          	andi	a4,a5,127
    80005ed0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ed2:	01874703          	lbu	a4,24(a4)
    80005ed6:	03270463          	beq	a4,s2,80005efe <consoleintr+0x11c>
      cons.e--;
    80005eda:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ede:	10000513          	li	a0,256
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	ebe080e7          	jalr	-322(ra) # 80005da0 <consputc>
    while(cons.e != cons.w &&
    80005eea:	0a04a783          	lw	a5,160(s1)
    80005eee:	09c4a703          	lw	a4,156(s1)
    80005ef2:	fcf71ce3          	bne	a4,a5,80005eca <consoleintr+0xe8>
    80005ef6:	6902                	ld	s2,0(sp)
    80005ef8:	b715                	j	80005e1c <consoleintr+0x3a>
    80005efa:	6902                	ld	s2,0(sp)
    80005efc:	b705                	j	80005e1c <consoleintr+0x3a>
    80005efe:	6902                	ld	s2,0(sp)
    80005f00:	bf31                	j	80005e1c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005f02:	0002d717          	auipc	a4,0x2d
    80005f06:	23e70713          	addi	a4,a4,574 # 80033140 <cons>
    80005f0a:	0a072783          	lw	a5,160(a4)
    80005f0e:	09c72703          	lw	a4,156(a4)
    80005f12:	f0f705e3          	beq	a4,a5,80005e1c <consoleintr+0x3a>
      cons.e--;
    80005f16:	37fd                	addiw	a5,a5,-1
    80005f18:	0002d717          	auipc	a4,0x2d
    80005f1c:	2cf72423          	sw	a5,712(a4) # 800331e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005f20:	10000513          	li	a0,256
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	e7c080e7          	jalr	-388(ra) # 80005da0 <consputc>
    80005f2c:	bdc5                	j	80005e1c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f2e:	ee0487e3          	beqz	s1,80005e1c <consoleintr+0x3a>
    80005f32:	b731                	j	80005e3e <consoleintr+0x5c>
      consputc(c);
    80005f34:	4529                	li	a0,10
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	e6a080e7          	jalr	-406(ra) # 80005da0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f3e:	0002d797          	auipc	a5,0x2d
    80005f42:	20278793          	addi	a5,a5,514 # 80033140 <cons>
    80005f46:	0a07a703          	lw	a4,160(a5)
    80005f4a:	0017069b          	addiw	a3,a4,1
    80005f4e:	0006861b          	sext.w	a2,a3
    80005f52:	0ad7a023          	sw	a3,160(a5)
    80005f56:	07f77713          	andi	a4,a4,127
    80005f5a:	97ba                	add	a5,a5,a4
    80005f5c:	4729                	li	a4,10
    80005f5e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f62:	0002d797          	auipc	a5,0x2d
    80005f66:	26c7ad23          	sw	a2,634(a5) # 800331dc <cons+0x9c>
        wakeup(&cons.r);
    80005f6a:	0002d517          	auipc	a0,0x2d
    80005f6e:	26e50513          	addi	a0,a0,622 # 800331d8 <cons+0x98>
    80005f72:	ffffb097          	auipc	ra,0xffffb
    80005f76:	774080e7          	jalr	1908(ra) # 800016e6 <wakeup>
    80005f7a:	b54d                	j	80005e1c <consoleintr+0x3a>

0000000080005f7c <consoleinit>:

void
consoleinit(void)
{
    80005f7c:	1141                	addi	sp,sp,-16
    80005f7e:	e406                	sd	ra,8(sp)
    80005f80:	e022                	sd	s0,0(sp)
    80005f82:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f84:	00002597          	auipc	a1,0x2
    80005f88:	6dc58593          	addi	a1,a1,1756 # 80008660 <etext+0x660>
    80005f8c:	0002d517          	auipc	a0,0x2d
    80005f90:	1b450513          	addi	a0,a0,436 # 80033140 <cons>
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	5c2080e7          	jalr	1474(ra) # 80006556 <initlock>

  uartinit();
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	354080e7          	jalr	852(ra) # 800062f0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005fa4:	00020797          	auipc	a5,0x20
    80005fa8:	12478793          	addi	a5,a5,292 # 800260c8 <devsw>
    80005fac:	00000717          	auipc	a4,0x0
    80005fb0:	cd470713          	addi	a4,a4,-812 # 80005c80 <consoleread>
    80005fb4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005fb6:	00000717          	auipc	a4,0x0
    80005fba:	c5c70713          	addi	a4,a4,-932 # 80005c12 <consolewrite>
    80005fbe:	ef98                	sd	a4,24(a5)
}
    80005fc0:	60a2                	ld	ra,8(sp)
    80005fc2:	6402                	ld	s0,0(sp)
    80005fc4:	0141                	addi	sp,sp,16
    80005fc6:	8082                	ret

0000000080005fc8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005fc8:	7179                	addi	sp,sp,-48
    80005fca:	f406                	sd	ra,40(sp)
    80005fcc:	f022                	sd	s0,32(sp)
    80005fce:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005fd0:	c219                	beqz	a2,80005fd6 <printint+0xe>
    80005fd2:	08054963          	bltz	a0,80006064 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005fd6:	2501                	sext.w	a0,a0
    80005fd8:	4881                	li	a7,0
    80005fda:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005fde:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005fe0:	2581                	sext.w	a1,a1
    80005fe2:	00002617          	auipc	a2,0x2
    80005fe6:	7ee60613          	addi	a2,a2,2030 # 800087d0 <digits>
    80005fea:	883a                	mv	a6,a4
    80005fec:	2705                	addiw	a4,a4,1
    80005fee:	02b577bb          	remuw	a5,a0,a1
    80005ff2:	1782                	slli	a5,a5,0x20
    80005ff4:	9381                	srli	a5,a5,0x20
    80005ff6:	97b2                	add	a5,a5,a2
    80005ff8:	0007c783          	lbu	a5,0(a5)
    80005ffc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006000:	0005079b          	sext.w	a5,a0
    80006004:	02b5553b          	divuw	a0,a0,a1
    80006008:	0685                	addi	a3,a3,1
    8000600a:	feb7f0e3          	bgeu	a5,a1,80005fea <printint+0x22>

  if(sign)
    8000600e:	00088c63          	beqz	a7,80006026 <printint+0x5e>
    buf[i++] = '-';
    80006012:	fe070793          	addi	a5,a4,-32
    80006016:	00878733          	add	a4,a5,s0
    8000601a:	02d00793          	li	a5,45
    8000601e:	fef70823          	sb	a5,-16(a4)
    80006022:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006026:	02e05b63          	blez	a4,8000605c <printint+0x94>
    8000602a:	ec26                	sd	s1,24(sp)
    8000602c:	e84a                	sd	s2,16(sp)
    8000602e:	fd040793          	addi	a5,s0,-48
    80006032:	00e784b3          	add	s1,a5,a4
    80006036:	fff78913          	addi	s2,a5,-1
    8000603a:	993a                	add	s2,s2,a4
    8000603c:	377d                	addiw	a4,a4,-1
    8000603e:	1702                	slli	a4,a4,0x20
    80006040:	9301                	srli	a4,a4,0x20
    80006042:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006046:	fff4c503          	lbu	a0,-1(s1)
    8000604a:	00000097          	auipc	ra,0x0
    8000604e:	d56080e7          	jalr	-682(ra) # 80005da0 <consputc>
  while(--i >= 0)
    80006052:	14fd                	addi	s1,s1,-1
    80006054:	ff2499e3          	bne	s1,s2,80006046 <printint+0x7e>
    80006058:	64e2                	ld	s1,24(sp)
    8000605a:	6942                	ld	s2,16(sp)
}
    8000605c:	70a2                	ld	ra,40(sp)
    8000605e:	7402                	ld	s0,32(sp)
    80006060:	6145                	addi	sp,sp,48
    80006062:	8082                	ret
    x = -xx;
    80006064:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006068:	4885                	li	a7,1
    x = -xx;
    8000606a:	bf85                	j	80005fda <printint+0x12>

000000008000606c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	addi	s0,sp,32
    80006076:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006078:	0002d797          	auipc	a5,0x2d
    8000607c:	1807a423          	sw	zero,392(a5) # 80033200 <pr+0x18>
  printf("panic: ");
    80006080:	00002517          	auipc	a0,0x2
    80006084:	5e850513          	addi	a0,a0,1512 # 80008668 <etext+0x668>
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	02e080e7          	jalr	46(ra) # 800060b6 <printf>
  printf(s);
    80006090:	8526                	mv	a0,s1
    80006092:	00000097          	auipc	ra,0x0
    80006096:	024080e7          	jalr	36(ra) # 800060b6 <printf>
  printf("\n");
    8000609a:	00002517          	auipc	a0,0x2
    8000609e:	f7e50513          	addi	a0,a0,-130 # 80008018 <etext+0x18>
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	014080e7          	jalr	20(ra) # 800060b6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800060aa:	4785                	li	a5,1
    800060ac:	00006717          	auipc	a4,0x6
    800060b0:	f6f72823          	sw	a5,-144(a4) # 8000c01c <panicked>
  for(;;)
    800060b4:	a001                	j	800060b4 <panic+0x48>

00000000800060b6 <printf>:
{
    800060b6:	7131                	addi	sp,sp,-192
    800060b8:	fc86                	sd	ra,120(sp)
    800060ba:	f8a2                	sd	s0,112(sp)
    800060bc:	e8d2                	sd	s4,80(sp)
    800060be:	f06a                	sd	s10,32(sp)
    800060c0:	0100                	addi	s0,sp,128
    800060c2:	8a2a                	mv	s4,a0
    800060c4:	e40c                	sd	a1,8(s0)
    800060c6:	e810                	sd	a2,16(s0)
    800060c8:	ec14                	sd	a3,24(s0)
    800060ca:	f018                	sd	a4,32(s0)
    800060cc:	f41c                	sd	a5,40(s0)
    800060ce:	03043823          	sd	a6,48(s0)
    800060d2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800060d6:	0002dd17          	auipc	s10,0x2d
    800060da:	12ad2d03          	lw	s10,298(s10) # 80033200 <pr+0x18>
  if(locking)
    800060de:	040d1463          	bnez	s10,80006126 <printf+0x70>
  if (fmt == 0)
    800060e2:	040a0b63          	beqz	s4,80006138 <printf+0x82>
  va_start(ap, fmt);
    800060e6:	00840793          	addi	a5,s0,8
    800060ea:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060ee:	000a4503          	lbu	a0,0(s4)
    800060f2:	18050b63          	beqz	a0,80006288 <printf+0x1d2>
    800060f6:	f4a6                	sd	s1,104(sp)
    800060f8:	f0ca                	sd	s2,96(sp)
    800060fa:	ecce                	sd	s3,88(sp)
    800060fc:	e4d6                	sd	s5,72(sp)
    800060fe:	e0da                	sd	s6,64(sp)
    80006100:	fc5e                	sd	s7,56(sp)
    80006102:	f862                	sd	s8,48(sp)
    80006104:	f466                	sd	s9,40(sp)
    80006106:	ec6e                	sd	s11,24(sp)
    80006108:	4981                	li	s3,0
    if(c != '%'){
    8000610a:	02500b13          	li	s6,37
    switch(c){
    8000610e:	07000b93          	li	s7,112
  consputc('x');
    80006112:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006114:	00002a97          	auipc	s5,0x2
    80006118:	6bca8a93          	addi	s5,s5,1724 # 800087d0 <digits>
    switch(c){
    8000611c:	07300c13          	li	s8,115
    80006120:	06400d93          	li	s11,100
    80006124:	a0b1                	j	80006170 <printf+0xba>
    acquire(&pr.lock);
    80006126:	0002d517          	auipc	a0,0x2d
    8000612a:	0c250513          	addi	a0,a0,194 # 800331e8 <pr>
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	4b8080e7          	jalr	1208(ra) # 800065e6 <acquire>
    80006136:	b775                	j	800060e2 <printf+0x2c>
    80006138:	f4a6                	sd	s1,104(sp)
    8000613a:	f0ca                	sd	s2,96(sp)
    8000613c:	ecce                	sd	s3,88(sp)
    8000613e:	e4d6                	sd	s5,72(sp)
    80006140:	e0da                	sd	s6,64(sp)
    80006142:	fc5e                	sd	s7,56(sp)
    80006144:	f862                	sd	s8,48(sp)
    80006146:	f466                	sd	s9,40(sp)
    80006148:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000614a:	00002517          	auipc	a0,0x2
    8000614e:	52e50513          	addi	a0,a0,1326 # 80008678 <etext+0x678>
    80006152:	00000097          	auipc	ra,0x0
    80006156:	f1a080e7          	jalr	-230(ra) # 8000606c <panic>
      consputc(c);
    8000615a:	00000097          	auipc	ra,0x0
    8000615e:	c46080e7          	jalr	-954(ra) # 80005da0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006162:	2985                	addiw	s3,s3,1
    80006164:	013a07b3          	add	a5,s4,s3
    80006168:	0007c503          	lbu	a0,0(a5)
    8000616c:	10050563          	beqz	a0,80006276 <printf+0x1c0>
    if(c != '%'){
    80006170:	ff6515e3          	bne	a0,s6,8000615a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006174:	2985                	addiw	s3,s3,1
    80006176:	013a07b3          	add	a5,s4,s3
    8000617a:	0007c783          	lbu	a5,0(a5)
    8000617e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006182:	10078b63          	beqz	a5,80006298 <printf+0x1e2>
    switch(c){
    80006186:	05778a63          	beq	a5,s7,800061da <printf+0x124>
    8000618a:	02fbf663          	bgeu	s7,a5,800061b6 <printf+0x100>
    8000618e:	09878863          	beq	a5,s8,8000621e <printf+0x168>
    80006192:	07800713          	li	a4,120
    80006196:	0ce79563          	bne	a5,a4,80006260 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000619a:	f8843783          	ld	a5,-120(s0)
    8000619e:	00878713          	addi	a4,a5,8
    800061a2:	f8e43423          	sd	a4,-120(s0)
    800061a6:	4605                	li	a2,1
    800061a8:	85e6                	mv	a1,s9
    800061aa:	4388                	lw	a0,0(a5)
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	e1c080e7          	jalr	-484(ra) # 80005fc8 <printint>
      break;
    800061b4:	b77d                	j	80006162 <printf+0xac>
    switch(c){
    800061b6:	09678f63          	beq	a5,s6,80006254 <printf+0x19e>
    800061ba:	0bb79363          	bne	a5,s11,80006260 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800061be:	f8843783          	ld	a5,-120(s0)
    800061c2:	00878713          	addi	a4,a5,8
    800061c6:	f8e43423          	sd	a4,-120(s0)
    800061ca:	4605                	li	a2,1
    800061cc:	45a9                	li	a1,10
    800061ce:	4388                	lw	a0,0(a5)
    800061d0:	00000097          	auipc	ra,0x0
    800061d4:	df8080e7          	jalr	-520(ra) # 80005fc8 <printint>
      break;
    800061d8:	b769                	j	80006162 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800061da:	f8843783          	ld	a5,-120(s0)
    800061de:	00878713          	addi	a4,a5,8
    800061e2:	f8e43423          	sd	a4,-120(s0)
    800061e6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800061ea:	03000513          	li	a0,48
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	bb2080e7          	jalr	-1102(ra) # 80005da0 <consputc>
  consputc('x');
    800061f6:	07800513          	li	a0,120
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	ba6080e7          	jalr	-1114(ra) # 80005da0 <consputc>
    80006202:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006204:	03c95793          	srli	a5,s2,0x3c
    80006208:	97d6                	add	a5,a5,s5
    8000620a:	0007c503          	lbu	a0,0(a5)
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	b92080e7          	jalr	-1134(ra) # 80005da0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006216:	0912                	slli	s2,s2,0x4
    80006218:	34fd                	addiw	s1,s1,-1
    8000621a:	f4ed                	bnez	s1,80006204 <printf+0x14e>
    8000621c:	b799                	j	80006162 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000621e:	f8843783          	ld	a5,-120(s0)
    80006222:	00878713          	addi	a4,a5,8
    80006226:	f8e43423          	sd	a4,-120(s0)
    8000622a:	6384                	ld	s1,0(a5)
    8000622c:	cc89                	beqz	s1,80006246 <printf+0x190>
      for(; *s; s++)
    8000622e:	0004c503          	lbu	a0,0(s1)
    80006232:	d905                	beqz	a0,80006162 <printf+0xac>
        consputc(*s);
    80006234:	00000097          	auipc	ra,0x0
    80006238:	b6c080e7          	jalr	-1172(ra) # 80005da0 <consputc>
      for(; *s; s++)
    8000623c:	0485                	addi	s1,s1,1
    8000623e:	0004c503          	lbu	a0,0(s1)
    80006242:	f96d                	bnez	a0,80006234 <printf+0x17e>
    80006244:	bf39                	j	80006162 <printf+0xac>
        s = "(null)";
    80006246:	00002497          	auipc	s1,0x2
    8000624a:	42a48493          	addi	s1,s1,1066 # 80008670 <etext+0x670>
      for(; *s; s++)
    8000624e:	02800513          	li	a0,40
    80006252:	b7cd                	j	80006234 <printf+0x17e>
      consputc('%');
    80006254:	855a                	mv	a0,s6
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	b4a080e7          	jalr	-1206(ra) # 80005da0 <consputc>
      break;
    8000625e:	b711                	j	80006162 <printf+0xac>
      consputc('%');
    80006260:	855a                	mv	a0,s6
    80006262:	00000097          	auipc	ra,0x0
    80006266:	b3e080e7          	jalr	-1218(ra) # 80005da0 <consputc>
      consputc(c);
    8000626a:	8526                	mv	a0,s1
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	b34080e7          	jalr	-1228(ra) # 80005da0 <consputc>
      break;
    80006274:	b5fd                	j	80006162 <printf+0xac>
    80006276:	74a6                	ld	s1,104(sp)
    80006278:	7906                	ld	s2,96(sp)
    8000627a:	69e6                	ld	s3,88(sp)
    8000627c:	6aa6                	ld	s5,72(sp)
    8000627e:	6b06                	ld	s6,64(sp)
    80006280:	7be2                	ld	s7,56(sp)
    80006282:	7c42                	ld	s8,48(sp)
    80006284:	7ca2                	ld	s9,40(sp)
    80006286:	6de2                	ld	s11,24(sp)
  if(locking)
    80006288:	020d1263          	bnez	s10,800062ac <printf+0x1f6>
}
    8000628c:	70e6                	ld	ra,120(sp)
    8000628e:	7446                	ld	s0,112(sp)
    80006290:	6a46                	ld	s4,80(sp)
    80006292:	7d02                	ld	s10,32(sp)
    80006294:	6129                	addi	sp,sp,192
    80006296:	8082                	ret
    80006298:	74a6                	ld	s1,104(sp)
    8000629a:	7906                	ld	s2,96(sp)
    8000629c:	69e6                	ld	s3,88(sp)
    8000629e:	6aa6                	ld	s5,72(sp)
    800062a0:	6b06                	ld	s6,64(sp)
    800062a2:	7be2                	ld	s7,56(sp)
    800062a4:	7c42                	ld	s8,48(sp)
    800062a6:	7ca2                	ld	s9,40(sp)
    800062a8:	6de2                	ld	s11,24(sp)
    800062aa:	bff9                	j	80006288 <printf+0x1d2>
    release(&pr.lock);
    800062ac:	0002d517          	auipc	a0,0x2d
    800062b0:	f3c50513          	addi	a0,a0,-196 # 800331e8 <pr>
    800062b4:	00000097          	auipc	ra,0x0
    800062b8:	3e6080e7          	jalr	998(ra) # 8000669a <release>
}
    800062bc:	bfc1                	j	8000628c <printf+0x1d6>

00000000800062be <printfinit>:
    ;
}

void
printfinit(void)
{
    800062be:	1101                	addi	sp,sp,-32
    800062c0:	ec06                	sd	ra,24(sp)
    800062c2:	e822                	sd	s0,16(sp)
    800062c4:	e426                	sd	s1,8(sp)
    800062c6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800062c8:	0002d497          	auipc	s1,0x2d
    800062cc:	f2048493          	addi	s1,s1,-224 # 800331e8 <pr>
    800062d0:	00002597          	auipc	a1,0x2
    800062d4:	3b858593          	addi	a1,a1,952 # 80008688 <etext+0x688>
    800062d8:	8526                	mv	a0,s1
    800062da:	00000097          	auipc	ra,0x0
    800062de:	27c080e7          	jalr	636(ra) # 80006556 <initlock>
  pr.locking = 1;
    800062e2:	4785                	li	a5,1
    800062e4:	cc9c                	sw	a5,24(s1)
}
    800062e6:	60e2                	ld	ra,24(sp)
    800062e8:	6442                	ld	s0,16(sp)
    800062ea:	64a2                	ld	s1,8(sp)
    800062ec:	6105                	addi	sp,sp,32
    800062ee:	8082                	ret

00000000800062f0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800062f0:	1141                	addi	sp,sp,-16
    800062f2:	e406                	sd	ra,8(sp)
    800062f4:	e022                	sd	s0,0(sp)
    800062f6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800062f8:	100007b7          	lui	a5,0x10000
    800062fc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006300:	10000737          	lui	a4,0x10000
    80006304:	f8000693          	li	a3,-128
    80006308:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000630c:	468d                	li	a3,3
    8000630e:	10000637          	lui	a2,0x10000
    80006312:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006316:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000631a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000631e:	10000737          	lui	a4,0x10000
    80006322:	461d                	li	a2,7
    80006324:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006328:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000632c:	00002597          	auipc	a1,0x2
    80006330:	36458593          	addi	a1,a1,868 # 80008690 <etext+0x690>
    80006334:	0002d517          	auipc	a0,0x2d
    80006338:	ed450513          	addi	a0,a0,-300 # 80033208 <uart_tx_lock>
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	21a080e7          	jalr	538(ra) # 80006556 <initlock>
}
    80006344:	60a2                	ld	ra,8(sp)
    80006346:	6402                	ld	s0,0(sp)
    80006348:	0141                	addi	sp,sp,16
    8000634a:	8082                	ret

000000008000634c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000634c:	1101                	addi	sp,sp,-32
    8000634e:	ec06                	sd	ra,24(sp)
    80006350:	e822                	sd	s0,16(sp)
    80006352:	e426                	sd	s1,8(sp)
    80006354:	1000                	addi	s0,sp,32
    80006356:	84aa                	mv	s1,a0
  push_off();
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	242080e7          	jalr	578(ra) # 8000659a <push_off>

  if(panicked){
    80006360:	00006797          	auipc	a5,0x6
    80006364:	cbc7a783          	lw	a5,-836(a5) # 8000c01c <panicked>
    80006368:	eb85                	bnez	a5,80006398 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000636a:	10000737          	lui	a4,0x10000
    8000636e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006370:	00074783          	lbu	a5,0(a4)
    80006374:	0207f793          	andi	a5,a5,32
    80006378:	dfe5                	beqz	a5,80006370 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000637a:	0ff4f513          	zext.b	a0,s1
    8000637e:	100007b7          	lui	a5,0x10000
    80006382:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	2b4080e7          	jalr	692(ra) # 8000663a <pop_off>
}
    8000638e:	60e2                	ld	ra,24(sp)
    80006390:	6442                	ld	s0,16(sp)
    80006392:	64a2                	ld	s1,8(sp)
    80006394:	6105                	addi	sp,sp,32
    80006396:	8082                	ret
    for(;;)
    80006398:	a001                	j	80006398 <uartputc_sync+0x4c>

000000008000639a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000639a:	00006797          	auipc	a5,0x6
    8000639e:	c867b783          	ld	a5,-890(a5) # 8000c020 <uart_tx_r>
    800063a2:	00006717          	auipc	a4,0x6
    800063a6:	c8673703          	ld	a4,-890(a4) # 8000c028 <uart_tx_w>
    800063aa:	06f70f63          	beq	a4,a5,80006428 <uartstart+0x8e>
{
    800063ae:	7139                	addi	sp,sp,-64
    800063b0:	fc06                	sd	ra,56(sp)
    800063b2:	f822                	sd	s0,48(sp)
    800063b4:	f426                	sd	s1,40(sp)
    800063b6:	f04a                	sd	s2,32(sp)
    800063b8:	ec4e                	sd	s3,24(sp)
    800063ba:	e852                	sd	s4,16(sp)
    800063bc:	e456                	sd	s5,8(sp)
    800063be:	e05a                	sd	s6,0(sp)
    800063c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063c2:	10000937          	lui	s2,0x10000
    800063c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063c8:	0002da97          	auipc	s5,0x2d
    800063cc:	e40a8a93          	addi	s5,s5,-448 # 80033208 <uart_tx_lock>
    uart_tx_r += 1;
    800063d0:	00006497          	auipc	s1,0x6
    800063d4:	c5048493          	addi	s1,s1,-944 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800063d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800063dc:	00006997          	auipc	s3,0x6
    800063e0:	c4c98993          	addi	s3,s3,-948 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063e4:	00094703          	lbu	a4,0(s2)
    800063e8:	02077713          	andi	a4,a4,32
    800063ec:	c705                	beqz	a4,80006414 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063ee:	01f7f713          	andi	a4,a5,31
    800063f2:	9756                	add	a4,a4,s5
    800063f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800063f8:	0785                	addi	a5,a5,1
    800063fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800063fc:	8526                	mv	a0,s1
    800063fe:	ffffb097          	auipc	ra,0xffffb
    80006402:	2e8080e7          	jalr	744(ra) # 800016e6 <wakeup>
    WriteReg(THR, c);
    80006406:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000640a:	609c                	ld	a5,0(s1)
    8000640c:	0009b703          	ld	a4,0(s3)
    80006410:	fcf71ae3          	bne	a4,a5,800063e4 <uartstart+0x4a>
  }
}
    80006414:	70e2                	ld	ra,56(sp)
    80006416:	7442                	ld	s0,48(sp)
    80006418:	74a2                	ld	s1,40(sp)
    8000641a:	7902                	ld	s2,32(sp)
    8000641c:	69e2                	ld	s3,24(sp)
    8000641e:	6a42                	ld	s4,16(sp)
    80006420:	6aa2                	ld	s5,8(sp)
    80006422:	6b02                	ld	s6,0(sp)
    80006424:	6121                	addi	sp,sp,64
    80006426:	8082                	ret
    80006428:	8082                	ret

000000008000642a <uartputc>:
{
    8000642a:	7179                	addi	sp,sp,-48
    8000642c:	f406                	sd	ra,40(sp)
    8000642e:	f022                	sd	s0,32(sp)
    80006430:	e052                	sd	s4,0(sp)
    80006432:	1800                	addi	s0,sp,48
    80006434:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006436:	0002d517          	auipc	a0,0x2d
    8000643a:	dd250513          	addi	a0,a0,-558 # 80033208 <uart_tx_lock>
    8000643e:	00000097          	auipc	ra,0x0
    80006442:	1a8080e7          	jalr	424(ra) # 800065e6 <acquire>
  if(panicked){
    80006446:	00006797          	auipc	a5,0x6
    8000644a:	bd67a783          	lw	a5,-1066(a5) # 8000c01c <panicked>
    8000644e:	c391                	beqz	a5,80006452 <uartputc+0x28>
    for(;;)
    80006450:	a001                	j	80006450 <uartputc+0x26>
    80006452:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006454:	00006717          	auipc	a4,0x6
    80006458:	bd473703          	ld	a4,-1068(a4) # 8000c028 <uart_tx_w>
    8000645c:	00006797          	auipc	a5,0x6
    80006460:	bc47b783          	ld	a5,-1084(a5) # 8000c020 <uart_tx_r>
    80006464:	02078793          	addi	a5,a5,32
    80006468:	02e79f63          	bne	a5,a4,800064a6 <uartputc+0x7c>
    8000646c:	e84a                	sd	s2,16(sp)
    8000646e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006470:	0002d997          	auipc	s3,0x2d
    80006474:	d9898993          	addi	s3,s3,-616 # 80033208 <uart_tx_lock>
    80006478:	00006497          	auipc	s1,0x6
    8000647c:	ba848493          	addi	s1,s1,-1112 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006480:	00006917          	auipc	s2,0x6
    80006484:	ba890913          	addi	s2,s2,-1112 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006488:	85ce                	mv	a1,s3
    8000648a:	8526                	mv	a0,s1
    8000648c:	ffffb097          	auipc	ra,0xffffb
    80006490:	0ce080e7          	jalr	206(ra) # 8000155a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006494:	00093703          	ld	a4,0(s2)
    80006498:	609c                	ld	a5,0(s1)
    8000649a:	02078793          	addi	a5,a5,32
    8000649e:	fee785e3          	beq	a5,a4,80006488 <uartputc+0x5e>
    800064a2:	6942                	ld	s2,16(sp)
    800064a4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800064a6:	0002d497          	auipc	s1,0x2d
    800064aa:	d6248493          	addi	s1,s1,-670 # 80033208 <uart_tx_lock>
    800064ae:	01f77793          	andi	a5,a4,31
    800064b2:	97a6                	add	a5,a5,s1
    800064b4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800064b8:	0705                	addi	a4,a4,1
    800064ba:	00006797          	auipc	a5,0x6
    800064be:	b6e7b723          	sd	a4,-1170(a5) # 8000c028 <uart_tx_w>
      uartstart();
    800064c2:	00000097          	auipc	ra,0x0
    800064c6:	ed8080e7          	jalr	-296(ra) # 8000639a <uartstart>
      release(&uart_tx_lock);
    800064ca:	8526                	mv	a0,s1
    800064cc:	00000097          	auipc	ra,0x0
    800064d0:	1ce080e7          	jalr	462(ra) # 8000669a <release>
    800064d4:	64e2                	ld	s1,24(sp)
}
    800064d6:	70a2                	ld	ra,40(sp)
    800064d8:	7402                	ld	s0,32(sp)
    800064da:	6a02                	ld	s4,0(sp)
    800064dc:	6145                	addi	sp,sp,48
    800064de:	8082                	ret

00000000800064e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800064e0:	1141                	addi	sp,sp,-16
    800064e2:	e422                	sd	s0,8(sp)
    800064e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800064e6:	100007b7          	lui	a5,0x10000
    800064ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800064ec:	0007c783          	lbu	a5,0(a5)
    800064f0:	8b85                	andi	a5,a5,1
    800064f2:	cb81                	beqz	a5,80006502 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800064f4:	100007b7          	lui	a5,0x10000
    800064f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800064fc:	6422                	ld	s0,8(sp)
    800064fe:	0141                	addi	sp,sp,16
    80006500:	8082                	ret
    return -1;
    80006502:	557d                	li	a0,-1
    80006504:	bfe5                	j	800064fc <uartgetc+0x1c>

0000000080006506 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006506:	1101                	addi	sp,sp,-32
    80006508:	ec06                	sd	ra,24(sp)
    8000650a:	e822                	sd	s0,16(sp)
    8000650c:	e426                	sd	s1,8(sp)
    8000650e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006510:	54fd                	li	s1,-1
    80006512:	a029                	j	8000651c <uartintr+0x16>
      break;
    consoleintr(c);
    80006514:	00000097          	auipc	ra,0x0
    80006518:	8ce080e7          	jalr	-1842(ra) # 80005de2 <consoleintr>
    int c = uartgetc();
    8000651c:	00000097          	auipc	ra,0x0
    80006520:	fc4080e7          	jalr	-60(ra) # 800064e0 <uartgetc>
    if(c == -1)
    80006524:	fe9518e3          	bne	a0,s1,80006514 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006528:	0002d497          	auipc	s1,0x2d
    8000652c:	ce048493          	addi	s1,s1,-800 # 80033208 <uart_tx_lock>
    80006530:	8526                	mv	a0,s1
    80006532:	00000097          	auipc	ra,0x0
    80006536:	0b4080e7          	jalr	180(ra) # 800065e6 <acquire>
  uartstart();
    8000653a:	00000097          	auipc	ra,0x0
    8000653e:	e60080e7          	jalr	-416(ra) # 8000639a <uartstart>
  release(&uart_tx_lock);
    80006542:	8526                	mv	a0,s1
    80006544:	00000097          	auipc	ra,0x0
    80006548:	156080e7          	jalr	342(ra) # 8000669a <release>
}
    8000654c:	60e2                	ld	ra,24(sp)
    8000654e:	6442                	ld	s0,16(sp)
    80006550:	64a2                	ld	s1,8(sp)
    80006552:	6105                	addi	sp,sp,32
    80006554:	8082                	ret

0000000080006556 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006556:	1141                	addi	sp,sp,-16
    80006558:	e422                	sd	s0,8(sp)
    8000655a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000655c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000655e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006562:	00053823          	sd	zero,16(a0)
}
    80006566:	6422                	ld	s0,8(sp)
    80006568:	0141                	addi	sp,sp,16
    8000656a:	8082                	ret

000000008000656c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000656c:	411c                	lw	a5,0(a0)
    8000656e:	e399                	bnez	a5,80006574 <holding+0x8>
    80006570:	4501                	li	a0,0
  return r;
}
    80006572:	8082                	ret
{
    80006574:	1101                	addi	sp,sp,-32
    80006576:	ec06                	sd	ra,24(sp)
    80006578:	e822                	sd	s0,16(sp)
    8000657a:	e426                	sd	s1,8(sp)
    8000657c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000657e:	6904                	ld	s1,16(a0)
    80006580:	ffffb097          	auipc	ra,0xffffb
    80006584:	8be080e7          	jalr	-1858(ra) # 80000e3e <mycpu>
    80006588:	40a48533          	sub	a0,s1,a0
    8000658c:	00153513          	seqz	a0,a0
}
    80006590:	60e2                	ld	ra,24(sp)
    80006592:	6442                	ld	s0,16(sp)
    80006594:	64a2                	ld	s1,8(sp)
    80006596:	6105                	addi	sp,sp,32
    80006598:	8082                	ret

000000008000659a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000659a:	1101                	addi	sp,sp,-32
    8000659c:	ec06                	sd	ra,24(sp)
    8000659e:	e822                	sd	s0,16(sp)
    800065a0:	e426                	sd	s1,8(sp)
    800065a2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065a4:	100024f3          	csrr	s1,sstatus
    800065a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800065ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065ae:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800065b2:	ffffb097          	auipc	ra,0xffffb
    800065b6:	88c080e7          	jalr	-1908(ra) # 80000e3e <mycpu>
    800065ba:	5d3c                	lw	a5,120(a0)
    800065bc:	cf89                	beqz	a5,800065d6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800065be:	ffffb097          	auipc	ra,0xffffb
    800065c2:	880080e7          	jalr	-1920(ra) # 80000e3e <mycpu>
    800065c6:	5d3c                	lw	a5,120(a0)
    800065c8:	2785                	addiw	a5,a5,1
    800065ca:	dd3c                	sw	a5,120(a0)
}
    800065cc:	60e2                	ld	ra,24(sp)
    800065ce:	6442                	ld	s0,16(sp)
    800065d0:	64a2                	ld	s1,8(sp)
    800065d2:	6105                	addi	sp,sp,32
    800065d4:	8082                	ret
    mycpu()->intena = old;
    800065d6:	ffffb097          	auipc	ra,0xffffb
    800065da:	868080e7          	jalr	-1944(ra) # 80000e3e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800065de:	8085                	srli	s1,s1,0x1
    800065e0:	8885                	andi	s1,s1,1
    800065e2:	dd64                	sw	s1,124(a0)
    800065e4:	bfe9                	j	800065be <push_off+0x24>

00000000800065e6 <acquire>:
{
    800065e6:	1101                	addi	sp,sp,-32
    800065e8:	ec06                	sd	ra,24(sp)
    800065ea:	e822                	sd	s0,16(sp)
    800065ec:	e426                	sd	s1,8(sp)
    800065ee:	1000                	addi	s0,sp,32
    800065f0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800065f2:	00000097          	auipc	ra,0x0
    800065f6:	fa8080e7          	jalr	-88(ra) # 8000659a <push_off>
  if(holding(lk))
    800065fa:	8526                	mv	a0,s1
    800065fc:	00000097          	auipc	ra,0x0
    80006600:	f70080e7          	jalr	-144(ra) # 8000656c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006604:	4705                	li	a4,1
  if(holding(lk))
    80006606:	e115                	bnez	a0,8000662a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006608:	87ba                	mv	a5,a4
    8000660a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000660e:	2781                	sext.w	a5,a5
    80006610:	ffe5                	bnez	a5,80006608 <acquire+0x22>
  __sync_synchronize();
    80006612:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006616:	ffffb097          	auipc	ra,0xffffb
    8000661a:	828080e7          	jalr	-2008(ra) # 80000e3e <mycpu>
    8000661e:	e888                	sd	a0,16(s1)
}
    80006620:	60e2                	ld	ra,24(sp)
    80006622:	6442                	ld	s0,16(sp)
    80006624:	64a2                	ld	s1,8(sp)
    80006626:	6105                	addi	sp,sp,32
    80006628:	8082                	ret
    panic("acquire");
    8000662a:	00002517          	auipc	a0,0x2
    8000662e:	06e50513          	addi	a0,a0,110 # 80008698 <etext+0x698>
    80006632:	00000097          	auipc	ra,0x0
    80006636:	a3a080e7          	jalr	-1478(ra) # 8000606c <panic>

000000008000663a <pop_off>:

void
pop_off(void)
{
    8000663a:	1141                	addi	sp,sp,-16
    8000663c:	e406                	sd	ra,8(sp)
    8000663e:	e022                	sd	s0,0(sp)
    80006640:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006642:	ffffa097          	auipc	ra,0xffffa
    80006646:	7fc080e7          	jalr	2044(ra) # 80000e3e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000664a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000664e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006650:	e78d                	bnez	a5,8000667a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006652:	5d3c                	lw	a5,120(a0)
    80006654:	02f05b63          	blez	a5,8000668a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006658:	37fd                	addiw	a5,a5,-1
    8000665a:	0007871b          	sext.w	a4,a5
    8000665e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006660:	eb09                	bnez	a4,80006672 <pop_off+0x38>
    80006662:	5d7c                	lw	a5,124(a0)
    80006664:	c799                	beqz	a5,80006672 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006666:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000666a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000666e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006672:	60a2                	ld	ra,8(sp)
    80006674:	6402                	ld	s0,0(sp)
    80006676:	0141                	addi	sp,sp,16
    80006678:	8082                	ret
    panic("pop_off - interruptible");
    8000667a:	00002517          	auipc	a0,0x2
    8000667e:	02650513          	addi	a0,a0,38 # 800086a0 <etext+0x6a0>
    80006682:	00000097          	auipc	ra,0x0
    80006686:	9ea080e7          	jalr	-1558(ra) # 8000606c <panic>
    panic("pop_off");
    8000668a:	00002517          	auipc	a0,0x2
    8000668e:	02e50513          	addi	a0,a0,46 # 800086b8 <etext+0x6b8>
    80006692:	00000097          	auipc	ra,0x0
    80006696:	9da080e7          	jalr	-1574(ra) # 8000606c <panic>

000000008000669a <release>:
{
    8000669a:	1101                	addi	sp,sp,-32
    8000669c:	ec06                	sd	ra,24(sp)
    8000669e:	e822                	sd	s0,16(sp)
    800066a0:	e426                	sd	s1,8(sp)
    800066a2:	1000                	addi	s0,sp,32
    800066a4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800066a6:	00000097          	auipc	ra,0x0
    800066aa:	ec6080e7          	jalr	-314(ra) # 8000656c <holding>
    800066ae:	c115                	beqz	a0,800066d2 <release+0x38>
  lk->cpu = 0;
    800066b0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066b4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800066b8:	0310000f          	fence	rw,w
    800066bc:	0004a023          	sw	zero,0(s1)
  pop_off();
    800066c0:	00000097          	auipc	ra,0x0
    800066c4:	f7a080e7          	jalr	-134(ra) # 8000663a <pop_off>
}
    800066c8:	60e2                	ld	ra,24(sp)
    800066ca:	6442                	ld	s0,16(sp)
    800066cc:	64a2                	ld	s1,8(sp)
    800066ce:	6105                	addi	sp,sp,32
    800066d0:	8082                	ret
    panic("release");
    800066d2:	00002517          	auipc	a0,0x2
    800066d6:	fee50513          	addi	a0,a0,-18 # 800086c0 <etext+0x6c0>
    800066da:	00000097          	auipc	ra,0x0
    800066de:	992080e7          	jalr	-1646(ra) # 8000606c <panic>
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
