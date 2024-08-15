
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	1b013103          	ld	sp,432(sp) # 8000b1b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	2d9050ef          	jal	80005aee <start>

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
    8000002c:	efc9                	bnez	a5,800000c6 <kfree+0xaa>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00029797          	auipc	a5,0x29
    80000034:	21078793          	addi	a5,a5,528 # 80029240 <end>
    80000038:	08f56763          	bltu	a0,a5,800000c6 <kfree+0xaa>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	08f57363          	bgeu	a0,a5,800000c6 <kfree+0xaa>
    panic("kfree");

  acquire(&kmem.lock);
    80000044:	0000c917          	auipc	s2,0xc
    80000048:	fec90913          	addi	s2,s2,-20 # 8000c030 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	00006097          	auipc	ra,0x6
    80000052:	4e8080e7          	jalr	1256(ra) # 80006536 <acquire>
  if(--kmem.ref_count[INDEX(pa)])
    80000056:	0002a797          	auipc	a5,0x2a
    8000005a:	1e978793          	addi	a5,a5,489 # 8002a23f <end+0xfff>
    8000005e:	777d                	lui	a4,0xfffff
    80000060:	8ff9                	and	a5,a5,a4
    80000062:	40f487b3          	sub	a5,s1,a5
    80000066:	87b1                	srai	a5,a5,0xc
    80000068:	078a                	slli	a5,a5,0x2
    8000006a:	03893703          	ld	a4,56(s2)
    8000006e:	97ba                	add	a5,a5,a4
    80000070:	4398                	lw	a4,0(a5)
    80000072:	377d                	addiw	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd5dbf>
    80000074:	0007069b          	sext.w	a3,a4
    80000078:	c398                	sw	a4,0(a5)
    8000007a:	eeb1                	bnez	a3,800000d6 <kfree+0xba>
  {
    release(&kmem.lock);
    return;
  }
  release(&kmem.lock);
    8000007c:	0000c917          	auipc	s2,0xc
    80000080:	fb490913          	addi	s2,s2,-76 # 8000c030 <kmem>
    80000084:	854a                	mv	a0,s2
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	564080e7          	jalr	1380(ra) # 800065ea <release>
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000008e:	6605                	lui	a2,0x1
    80000090:	4585                	li	a1,1
    80000092:	8526                	mv	a0,s1
    80000094:	00000097          	auipc	ra,0x0
    80000098:	24e080e7          	jalr	590(ra) # 800002e2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000009c:	854a                	mv	a0,s2
    8000009e:	00006097          	auipc	ra,0x6
    800000a2:	498080e7          	jalr	1176(ra) # 80006536 <acquire>
  r->next = kmem.freelist;
    800000a6:	01893783          	ld	a5,24(s2)
    800000aa:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000ac:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000b0:	854a                	mv	a0,s2
    800000b2:	00006097          	auipc	ra,0x6
    800000b6:	538080e7          	jalr	1336(ra) # 800065ea <release>
}
    800000ba:	60e2                	ld	ra,24(sp)
    800000bc:	6442                	ld	s0,16(sp)
    800000be:	64a2                	ld	s1,8(sp)
    800000c0:	6902                	ld	s2,0(sp)
    800000c2:	6105                	addi	sp,sp,32
    800000c4:	8082                	ret
    panic("kfree");
    800000c6:	00008517          	auipc	a0,0x8
    800000ca:	f3a50513          	addi	a0,a0,-198 # 80008000 <etext>
    800000ce:	00006097          	auipc	ra,0x6
    800000d2:	eee080e7          	jalr	-274(ra) # 80005fbc <panic>
    release(&kmem.lock);
    800000d6:	854a                	mv	a0,s2
    800000d8:	00006097          	auipc	ra,0x6
    800000dc:	512080e7          	jalr	1298(ra) # 800065ea <release>
    return;
    800000e0:	bfe9                	j	800000ba <kfree+0x9e>

00000000800000e2 <freerange>:
{
    800000e2:	715d                	addi	sp,sp,-80
    800000e4:	e486                	sd	ra,72(sp)
    800000e6:	e0a2                	sd	s0,64(sp)
    800000e8:	fc26                	sd	s1,56(sp)
    800000ea:	0880                	addi	s0,sp,80
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000ec:	6785                	lui	a5,0x1
    800000ee:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000f2:	00e504b3          	add	s1,a0,a4
    800000f6:	777d                	lui	a4,0xfffff
    800000f8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000fa:	94be                	add	s1,s1,a5
    800000fc:	0495ee63          	bltu	a1,s1,80000158 <freerange+0x76>
    80000100:	f84a                	sd	s2,48(sp)
    80000102:	f44e                	sd	s3,40(sp)
    80000104:	f052                	sd	s4,32(sp)
    80000106:	ec56                	sd	s5,24(sp)
    80000108:	e85a                	sd	s6,16(sp)
    8000010a:	e45e                	sd	s7,8(sp)
    8000010c:	892e                	mv	s2,a1
    8000010e:	7a7d                	lui	s4,0xfffff
    kmem.ref_count[INDEX((void*)p)] = 1;
    80000110:	0000cb97          	auipc	s7,0xc
    80000114:	f20b8b93          	addi	s7,s7,-224 # 8000c030 <kmem>
    80000118:	6b05                	lui	s6,0x1
    8000011a:	0002a997          	auipc	s3,0x2a
    8000011e:	12598993          	addi	s3,s3,293 # 8002a23f <end+0xfff>
    80000122:	0149f9b3          	and	s3,s3,s4
    80000126:	4a85                	li	s5,1
    80000128:	01448533          	add	a0,s1,s4
    8000012c:	413507b3          	sub	a5,a0,s3
    80000130:	87b1                	srai	a5,a5,0xc
    80000132:	038bb703          	ld	a4,56(s7)
    80000136:	078a                	slli	a5,a5,0x2
    80000138:	97ba                	add	a5,a5,a4
    8000013a:	0157a023          	sw	s5,0(a5)
    kfree(p);
    8000013e:	00000097          	auipc	ra,0x0
    80000142:	ede080e7          	jalr	-290(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000146:	94da                	add	s1,s1,s6
    80000148:	fe9970e3          	bgeu	s2,s1,80000128 <freerange+0x46>
    8000014c:	7942                	ld	s2,48(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	6b42                	ld	s6,16(sp)
    80000156:	6ba2                	ld	s7,8(sp)
}
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	6161                	addi	sp,sp,80
    80000160:	8082                	ret

0000000080000162 <kinit>:
{
    80000162:	1101                	addi	sp,sp,-32
    80000164:	ec06                	sd	ra,24(sp)
    80000166:	e822                	sd	s0,16(sp)
    80000168:	e426                	sd	s1,8(sp)
    8000016a:	1000                	addi	s0,sp,32
  initlock(&kmem.lock, "kmem");
    8000016c:	0000c497          	auipc	s1,0xc
    80000170:	ec448493          	addi	s1,s1,-316 # 8000c030 <kmem>
    80000174:	00008597          	auipc	a1,0x8
    80000178:	e9c58593          	addi	a1,a1,-356 # 80008010 <etext+0x10>
    8000017c:	8526                	mv	a0,s1
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	328080e7          	jalr	808(ra) # 800064a6 <initlock>
  initlock(&kmem.ref_lock, "ref");
    80000186:	00008597          	auipc	a1,0x8
    8000018a:	e9258593          	addi	a1,a1,-366 # 80008018 <etext+0x18>
    8000018e:	0000c517          	auipc	a0,0xc
    80000192:	ec250513          	addi	a0,a0,-318 # 8000c050 <kmem+0x20>
    80000196:	00006097          	auipc	ra,0x6
    8000019a:	310080e7          	jalr	784(ra) # 800064a6 <initlock>
  uint64 physical_pages = ((PHYSTOP - (uint64)end) >> 12) + 1;
    8000019e:	45c5                	li	a1,17
    800001a0:	05ee                	slli	a1,a1,0x1b
    800001a2:	00029517          	auipc	a0,0x29
    800001a6:	09e50513          	addi	a0,a0,158 # 80029240 <end>
    800001aa:	40a587b3          	sub	a5,a1,a0
    800001ae:	83b1                	srli	a5,a5,0xc
    800001b0:	0785                	addi	a5,a5,1
  physical_pages = ((physical_pages * sizeof(uint)) >> 12) + 1;
    800001b2:	83a9                	srli	a5,a5,0xa
  kmem.ref_count = (uint*) end;
    800001b4:	fc88                	sd	a0,56(s1)
  physical_pages = ((physical_pages * sizeof(uint)) >> 12) + 1;
    800001b6:	0785                	addi	a5,a5,1
  uint64 offset = physical_pages << 12;
    800001b8:	07b2                	slli	a5,a5,0xc
  freerange(end + offset, (void*)PHYSTOP);
    800001ba:	953e                	add	a0,a0,a5
    800001bc:	00000097          	auipc	ra,0x0
    800001c0:	f26080e7          	jalr	-218(ra) # 800000e2 <freerange>
}
    800001c4:	60e2                	ld	ra,24(sp)
    800001c6:	6442                	ld	s0,16(sp)
    800001c8:	64a2                	ld	s1,8(sp)
    800001ca:	6105                	addi	sp,sp,32
    800001cc:	8082                	ret

00000000800001ce <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001ce:	1101                	addi	sp,sp,-32
    800001d0:	ec06                	sd	ra,24(sp)
    800001d2:	e822                	sd	s0,16(sp)
    800001d4:	e426                	sd	s1,8(sp)
    800001d6:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001d8:	0000c497          	auipc	s1,0xc
    800001dc:	e5848493          	addi	s1,s1,-424 # 8000c030 <kmem>
    800001e0:	8526                	mv	a0,s1
    800001e2:	00006097          	auipc	ra,0x6
    800001e6:	354080e7          	jalr	852(ra) # 80006536 <acquire>
  r = kmem.freelist;
    800001ea:	6c84                	ld	s1,24(s1)
  if(r)
    800001ec:	c4b1                	beqz	s1,80000238 <kalloc+0x6a>
  {
    kmem.freelist = r->next;
    800001ee:	609c                	ld	a5,0(s1)
    800001f0:	0000c517          	auipc	a0,0xc
    800001f4:	e4050513          	addi	a0,a0,-448 # 8000c030 <kmem>
    800001f8:	ed1c                	sd	a5,24(a0)
    kmem.ref_count[INDEX((void*)r)] = 1;
    800001fa:	0002a797          	auipc	a5,0x2a
    800001fe:	04578793          	addi	a5,a5,69 # 8002a23f <end+0xfff>
    80000202:	777d                	lui	a4,0xfffff
    80000204:	8ff9                	and	a5,a5,a4
    80000206:	40f487b3          	sub	a5,s1,a5
    8000020a:	87b1                	srai	a5,a5,0xc
    8000020c:	7d18                	ld	a4,56(a0)
    8000020e:	078a                	slli	a5,a5,0x2
    80000210:	97ba                	add	a5,a5,a4
    80000212:	4705                	li	a4,1
    80000214:	c398                	sw	a4,0(a5)
  }
  release(&kmem.lock);
    80000216:	00006097          	auipc	ra,0x6
    8000021a:	3d4080e7          	jalr	980(ra) # 800065ea <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000021e:	6605                	lui	a2,0x1
    80000220:	4595                	li	a1,5
    80000222:	8526                	mv	a0,s1
    80000224:	00000097          	auipc	ra,0x0
    80000228:	0be080e7          	jalr	190(ra) # 800002e2 <memset>
  return (void*)r;
}
    8000022c:	8526                	mv	a0,s1
    8000022e:	60e2                	ld	ra,24(sp)
    80000230:	6442                	ld	s0,16(sp)
    80000232:	64a2                	ld	s1,8(sp)
    80000234:	6105                	addi	sp,sp,32
    80000236:	8082                	ret
  release(&kmem.lock);
    80000238:	0000c517          	auipc	a0,0xc
    8000023c:	df850513          	addi	a0,a0,-520 # 8000c030 <kmem>
    80000240:	00006097          	auipc	ra,0x6
    80000244:	3aa080e7          	jalr	938(ra) # 800065ea <release>
  if(r)
    80000248:	b7d5                	j	8000022c <kalloc+0x5e>

000000008000024a <get_kmem_ref>:
int get_kmem_ref(void *pa)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  return kmem.ref_count[INDEX(pa)];
    80000250:	0002a797          	auipc	a5,0x2a
    80000254:	fef78793          	addi	a5,a5,-17 # 8002a23f <end+0xfff>
    80000258:	777d                	lui	a4,0xfffff
    8000025a:	8ff9                	and	a5,a5,a4
    8000025c:	8d1d                	sub	a0,a0,a5
    8000025e:	8531                	srai	a0,a0,0xc
    80000260:	050a                	slli	a0,a0,0x2
    80000262:	0000c797          	auipc	a5,0xc
    80000266:	e067b783          	ld	a5,-506(a5) # 8000c068 <kmem+0x38>
    8000026a:	97aa                	add	a5,a5,a0
}
    8000026c:	4388                	lw	a0,0(a5)
    8000026e:	6422                	ld	s0,8(sp)
    80000270:	0141                	addi	sp,sp,16
    80000272:	8082                	ret

0000000080000274 <add_kmem_ref>:
 
void add_kmem_ref(void *pa)
{
    80000274:	1141                	addi	sp,sp,-16
    80000276:	e422                	sd	s0,8(sp)
    80000278:	0800                	addi	s0,sp,16
  kmem.ref_count[INDEX(pa)]++;
    8000027a:	0002a797          	auipc	a5,0x2a
    8000027e:	fc578793          	addi	a5,a5,-59 # 8002a23f <end+0xfff>
    80000282:	777d                	lui	a4,0xfffff
    80000284:	8ff9                	and	a5,a5,a4
    80000286:	8d1d                	sub	a0,a0,a5
    80000288:	8531                	srai	a0,a0,0xc
    8000028a:	050a                	slli	a0,a0,0x2
    8000028c:	0000c797          	auipc	a5,0xc
    80000290:	ddc7b783          	ld	a5,-548(a5) # 8000c068 <kmem+0x38>
    80000294:	97aa                	add	a5,a5,a0
    80000296:	4398                	lw	a4,0(a5)
    80000298:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd5dc1>
    8000029a:	c398                	sw	a4,0(a5)
}
    8000029c:	6422                	ld	s0,8(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret

00000000800002a2 <acquire_ref_lock>:
 
void acquire_ref_lock()
{
    800002a2:	1141                	addi	sp,sp,-16
    800002a4:	e406                	sd	ra,8(sp)
    800002a6:	e022                	sd	s0,0(sp)
    800002a8:	0800                	addi	s0,sp,16
  acquire(&kmem.ref_lock);
    800002aa:	0000c517          	auipc	a0,0xc
    800002ae:	da650513          	addi	a0,a0,-602 # 8000c050 <kmem+0x20>
    800002b2:	00006097          	auipc	ra,0x6
    800002b6:	284080e7          	jalr	644(ra) # 80006536 <acquire>
}
    800002ba:	60a2                	ld	ra,8(sp)
    800002bc:	6402                	ld	s0,0(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <release_ref_lock>:
 
void release_ref_lock()
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e406                	sd	ra,8(sp)
    800002c6:	e022                	sd	s0,0(sp)
    800002c8:	0800                	addi	s0,sp,16
  release(&kmem.ref_lock);
    800002ca:	0000c517          	auipc	a0,0xc
    800002ce:	d8650513          	addi	a0,a0,-634 # 8000c050 <kmem+0x20>
    800002d2:	00006097          	auipc	ra,0x6
    800002d6:	318080e7          	jalr	792(ra) # 800065ea <release>
    800002da:	60a2                	ld	ra,8(sp)
    800002dc:	6402                	ld	s0,0(sp)
    800002de:	0141                	addi	sp,sp,16
    800002e0:	8082                	ret

00000000800002e2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002e2:	1141                	addi	sp,sp,-16
    800002e4:	e422                	sd	s0,8(sp)
    800002e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002e8:	ca19                	beqz	a2,800002fe <memset+0x1c>
    800002ea:	87aa                	mv	a5,a0
    800002ec:	1602                	slli	a2,a2,0x20
    800002ee:	9201                	srli	a2,a2,0x20
    800002f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002f8:	0785                	addi	a5,a5,1
    800002fa:	fee79de3          	bne	a5,a4,800002f4 <memset+0x12>
  }
  return dst;
}
    800002fe:	6422                	ld	s0,8(sp)
    80000300:	0141                	addi	sp,sp,16
    80000302:	8082                	ret

0000000080000304 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e422                	sd	s0,8(sp)
    80000308:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000030a:	ca05                	beqz	a2,8000033a <memcmp+0x36>
    8000030c:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000310:	1682                	slli	a3,a3,0x20
    80000312:	9281                	srli	a3,a3,0x20
    80000314:	0685                	addi	a3,a3,1
    80000316:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000318:	00054783          	lbu	a5,0(a0)
    8000031c:	0005c703          	lbu	a4,0(a1)
    80000320:	00e79863          	bne	a5,a4,80000330 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000324:	0505                	addi	a0,a0,1
    80000326:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000328:	fed518e3          	bne	a0,a3,80000318 <memcmp+0x14>
  }

  return 0;
    8000032c:	4501                	li	a0,0
    8000032e:	a019                	j	80000334 <memcmp+0x30>
      return *s1 - *s2;
    80000330:	40e7853b          	subw	a0,a5,a4
}
    80000334:	6422                	ld	s0,8(sp)
    80000336:	0141                	addi	sp,sp,16
    80000338:	8082                	ret
  return 0;
    8000033a:	4501                	li	a0,0
    8000033c:	bfe5                	j	80000334 <memcmp+0x30>

000000008000033e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000033e:	1141                	addi	sp,sp,-16
    80000340:	e422                	sd	s0,8(sp)
    80000342:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000344:	c205                	beqz	a2,80000364 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000346:	02a5e263          	bltu	a1,a0,8000036a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000034a:	1602                	slli	a2,a2,0x20
    8000034c:	9201                	srli	a2,a2,0x20
    8000034e:	00c587b3          	add	a5,a1,a2
{
    80000352:	872a                	mv	a4,a0
      *d++ = *s++;
    80000354:	0585                	addi	a1,a1,1
    80000356:	0705                	addi	a4,a4,1
    80000358:	fff5c683          	lbu	a3,-1(a1)
    8000035c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000360:	feb79ae3          	bne	a5,a1,80000354 <memmove+0x16>

  return dst;
}
    80000364:	6422                	ld	s0,8(sp)
    80000366:	0141                	addi	sp,sp,16
    80000368:	8082                	ret
  if(s < d && s + n > d){
    8000036a:	02061693          	slli	a3,a2,0x20
    8000036e:	9281                	srli	a3,a3,0x20
    80000370:	00d58733          	add	a4,a1,a3
    80000374:	fce57be3          	bgeu	a0,a4,8000034a <memmove+0xc>
    d += n;
    80000378:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000037a:	fff6079b          	addiw	a5,a2,-1
    8000037e:	1782                	slli	a5,a5,0x20
    80000380:	9381                	srli	a5,a5,0x20
    80000382:	fff7c793          	not	a5,a5
    80000386:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000388:	177d                	addi	a4,a4,-1
    8000038a:	16fd                	addi	a3,a3,-1
    8000038c:	00074603          	lbu	a2,0(a4)
    80000390:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000394:	fef71ae3          	bne	a4,a5,80000388 <memmove+0x4a>
    80000398:	b7f1                	j	80000364 <memmove+0x26>

000000008000039a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e406                	sd	ra,8(sp)
    8000039e:	e022                	sd	s0,0(sp)
    800003a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800003a2:	00000097          	auipc	ra,0x0
    800003a6:	f9c080e7          	jalr	-100(ra) # 8000033e <memmove>
}
    800003aa:	60a2                	ld	ra,8(sp)
    800003ac:	6402                	ld	s0,0(sp)
    800003ae:	0141                	addi	sp,sp,16
    800003b0:	8082                	ret

00000000800003b2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003b2:	1141                	addi	sp,sp,-16
    800003b4:	e422                	sd	s0,8(sp)
    800003b6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003b8:	ce11                	beqz	a2,800003d4 <strncmp+0x22>
    800003ba:	00054783          	lbu	a5,0(a0)
    800003be:	cf89                	beqz	a5,800003d8 <strncmp+0x26>
    800003c0:	0005c703          	lbu	a4,0(a1)
    800003c4:	00f71a63          	bne	a4,a5,800003d8 <strncmp+0x26>
    n--, p++, q++;
    800003c8:	367d                	addiw	a2,a2,-1
    800003ca:	0505                	addi	a0,a0,1
    800003cc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003ce:	f675                	bnez	a2,800003ba <strncmp+0x8>
  if(n == 0)
    return 0;
    800003d0:	4501                	li	a0,0
    800003d2:	a801                	j	800003e2 <strncmp+0x30>
    800003d4:	4501                	li	a0,0
    800003d6:	a031                	j	800003e2 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800003d8:	00054503          	lbu	a0,0(a0)
    800003dc:	0005c783          	lbu	a5,0(a1)
    800003e0:	9d1d                	subw	a0,a0,a5
}
    800003e2:	6422                	ld	s0,8(sp)
    800003e4:	0141                	addi	sp,sp,16
    800003e6:	8082                	ret

00000000800003e8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003e8:	1141                	addi	sp,sp,-16
    800003ea:	e422                	sd	s0,8(sp)
    800003ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003ee:	87aa                	mv	a5,a0
    800003f0:	86b2                	mv	a3,a2
    800003f2:	367d                	addiw	a2,a2,-1
    800003f4:	02d05563          	blez	a3,8000041e <strncpy+0x36>
    800003f8:	0785                	addi	a5,a5,1
    800003fa:	0005c703          	lbu	a4,0(a1)
    800003fe:	fee78fa3          	sb	a4,-1(a5)
    80000402:	0585                	addi	a1,a1,1
    80000404:	f775                	bnez	a4,800003f0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000406:	873e                	mv	a4,a5
    80000408:	9fb5                	addw	a5,a5,a3
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00c05963          	blez	a2,8000041e <strncpy+0x36>
    *s++ = 0;
    80000410:	0705                	addi	a4,a4,1
    80000412:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000416:	40e786bb          	subw	a3,a5,a4
    8000041a:	fed04be3          	bgtz	a3,80000410 <strncpy+0x28>
  return os;
}
    8000041e:	6422                	ld	s0,8(sp)
    80000420:	0141                	addi	sp,sp,16
    80000422:	8082                	ret

0000000080000424 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000424:	1141                	addi	sp,sp,-16
    80000426:	e422                	sd	s0,8(sp)
    80000428:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000042a:	02c05363          	blez	a2,80000450 <safestrcpy+0x2c>
    8000042e:	fff6069b          	addiw	a3,a2,-1
    80000432:	1682                	slli	a3,a3,0x20
    80000434:	9281                	srli	a3,a3,0x20
    80000436:	96ae                	add	a3,a3,a1
    80000438:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000043a:	00d58963          	beq	a1,a3,8000044c <safestrcpy+0x28>
    8000043e:	0585                	addi	a1,a1,1
    80000440:	0785                	addi	a5,a5,1
    80000442:	fff5c703          	lbu	a4,-1(a1)
    80000446:	fee78fa3          	sb	a4,-1(a5)
    8000044a:	fb65                	bnez	a4,8000043a <safestrcpy+0x16>
    ;
  *s = 0;
    8000044c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000450:	6422                	ld	s0,8(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <strlen>:

int
strlen(const char *s)
{
    80000456:	1141                	addi	sp,sp,-16
    80000458:	e422                	sd	s0,8(sp)
    8000045a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000045c:	00054783          	lbu	a5,0(a0)
    80000460:	cf91                	beqz	a5,8000047c <strlen+0x26>
    80000462:	0505                	addi	a0,a0,1
    80000464:	87aa                	mv	a5,a0
    80000466:	86be                	mv	a3,a5
    80000468:	0785                	addi	a5,a5,1
    8000046a:	fff7c703          	lbu	a4,-1(a5)
    8000046e:	ff65                	bnez	a4,80000466 <strlen+0x10>
    80000470:	40a6853b          	subw	a0,a3,a0
    80000474:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000476:	6422                	ld	s0,8(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000047c:	4501                	li	a0,0
    8000047e:	bfe5                	j	80000476 <strlen+0x20>

0000000080000480 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000480:	1141                	addi	sp,sp,-16
    80000482:	e406                	sd	ra,8(sp)
    80000484:	e022                	sd	s0,0(sp)
    80000486:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	c56080e7          	jalr	-938(ra) # 800010de <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000490:	0000c717          	auipc	a4,0xc
    80000494:	b7070713          	addi	a4,a4,-1168 # 8000c000 <started>
  if(cpuid() == 0){
    80000498:	c139                	beqz	a0,800004de <main+0x5e>
    while(started == 0)
    8000049a:	431c                	lw	a5,0(a4)
    8000049c:	2781                	sext.w	a5,a5
    8000049e:	dff5                	beqz	a5,8000049a <main+0x1a>
      ;
    __sync_synchronize();
    800004a0:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800004a4:	00001097          	auipc	ra,0x1
    800004a8:	c3a080e7          	jalr	-966(ra) # 800010de <cpuid>
    800004ac:	85aa                	mv	a1,a0
    800004ae:	00008517          	auipc	a0,0x8
    800004b2:	b9250513          	addi	a0,a0,-1134 # 80008040 <etext+0x40>
    800004b6:	00006097          	auipc	ra,0x6
    800004ba:	b50080e7          	jalr	-1200(ra) # 80006006 <printf>
    kvminithart();    // turn on paging
    800004be:	00000097          	auipc	ra,0x0
    800004c2:	0d8080e7          	jalr	216(ra) # 80000596 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004c6:	00002097          	auipc	ra,0x2
    800004ca:	89c080e7          	jalr	-1892(ra) # 80001d62 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004ce:	00005097          	auipc	ra,0x5
    800004d2:	fd6080e7          	jalr	-42(ra) # 800054a4 <plicinithart>
  }

  scheduler();        
    800004d6:	00001097          	auipc	ra,0x1
    800004da:	148080e7          	jalr	328(ra) # 8000161e <scheduler>
    consoleinit();
    800004de:	00006097          	auipc	ra,0x6
    800004e2:	9ee080e7          	jalr	-1554(ra) # 80005ecc <consoleinit>
    printfinit();
    800004e6:	00006097          	auipc	ra,0x6
    800004ea:	d28080e7          	jalr	-728(ra) # 8000620e <printfinit>
    printf("\n");
    800004ee:	00008517          	auipc	a0,0x8
    800004f2:	b3250513          	addi	a0,a0,-1230 # 80008020 <etext+0x20>
    800004f6:	00006097          	auipc	ra,0x6
    800004fa:	b10080e7          	jalr	-1264(ra) # 80006006 <printf>
    printf("xv6 kernel is booting\n");
    800004fe:	00008517          	auipc	a0,0x8
    80000502:	b2a50513          	addi	a0,a0,-1238 # 80008028 <etext+0x28>
    80000506:	00006097          	auipc	ra,0x6
    8000050a:	b00080e7          	jalr	-1280(ra) # 80006006 <printf>
    printf("\n");
    8000050e:	00008517          	auipc	a0,0x8
    80000512:	b1250513          	addi	a0,a0,-1262 # 80008020 <etext+0x20>
    80000516:	00006097          	auipc	ra,0x6
    8000051a:	af0080e7          	jalr	-1296(ra) # 80006006 <printf>
    kinit();         // physical page allocator
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	c44080e7          	jalr	-956(ra) # 80000162 <kinit>
    kvminit();       // create kernel page table
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	30c080e7          	jalr	780(ra) # 80000832 <kvminit>
    kvminithart();   // turn on paging
    8000052e:	00000097          	auipc	ra,0x0
    80000532:	068080e7          	jalr	104(ra) # 80000596 <kvminithart>
    procinit();      // process table
    80000536:	00001097          	auipc	ra,0x1
    8000053a:	aea080e7          	jalr	-1302(ra) # 80001020 <procinit>
    trapinit();      // trap vectors
    8000053e:	00001097          	auipc	ra,0x1
    80000542:	7fc080e7          	jalr	2044(ra) # 80001d3a <trapinit>
    trapinithart();  // install kernel trap vector
    80000546:	00002097          	auipc	ra,0x2
    8000054a:	81c080e7          	jalr	-2020(ra) # 80001d62 <trapinithart>
    plicinit();      // set up interrupt controller
    8000054e:	00005097          	auipc	ra,0x5
    80000552:	f3c080e7          	jalr	-196(ra) # 8000548a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000556:	00005097          	auipc	ra,0x5
    8000055a:	f4e080e7          	jalr	-178(ra) # 800054a4 <plicinithart>
    binit();         // buffer cache
    8000055e:	00002097          	auipc	ra,0x2
    80000562:	066080e7          	jalr	102(ra) # 800025c4 <binit>
    iinit();         // inode table
    80000566:	00002097          	auipc	ra,0x2
    8000056a:	6f2080e7          	jalr	1778(ra) # 80002c58 <iinit>
    fileinit();      // file table
    8000056e:	00003097          	auipc	ra,0x3
    80000572:	696080e7          	jalr	1686(ra) # 80003c04 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000576:	00005097          	auipc	ra,0x5
    8000057a:	04e080e7          	jalr	78(ra) # 800055c4 <virtio_disk_init>
    userinit();      // first user process
    8000057e:	00001097          	auipc	ra,0x1
    80000582:	e64080e7          	jalr	-412(ra) # 800013e2 <userinit>
    __sync_synchronize();
    80000586:	0330000f          	fence	rw,rw
    started = 1;
    8000058a:	4785                	li	a5,1
    8000058c:	0000c717          	auipc	a4,0xc
    80000590:	a6f72a23          	sw	a5,-1420(a4) # 8000c000 <started>
    80000594:	b789                	j	800004d6 <main+0x56>

0000000080000596 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000596:	1141                	addi	sp,sp,-16
    80000598:	e422                	sd	s0,8(sp)
    8000059a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000059c:	0000c797          	auipc	a5,0xc
    800005a0:	a6c7b783          	ld	a5,-1428(a5) # 8000c008 <kernel_pagetable>
    800005a4:	83b1                	srli	a5,a5,0xc
    800005a6:	577d                	li	a4,-1
    800005a8:	177e                	slli	a4,a4,0x3f
    800005aa:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005ac:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005b0:	12000073          	sfence.vma
  sfence_vma();
}
    800005b4:	6422                	ld	s0,8(sp)
    800005b6:	0141                	addi	sp,sp,16
    800005b8:	8082                	ret

00000000800005ba <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005ba:	7139                	addi	sp,sp,-64
    800005bc:	fc06                	sd	ra,56(sp)
    800005be:	f822                	sd	s0,48(sp)
    800005c0:	f426                	sd	s1,40(sp)
    800005c2:	f04a                	sd	s2,32(sp)
    800005c4:	ec4e                	sd	s3,24(sp)
    800005c6:	e852                	sd	s4,16(sp)
    800005c8:	e456                	sd	s5,8(sp)
    800005ca:	e05a                	sd	s6,0(sp)
    800005cc:	0080                	addi	s0,sp,64
    800005ce:	84aa                	mv	s1,a0
    800005d0:	89ae                	mv	s3,a1
    800005d2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005d4:	57fd                	li	a5,-1
    800005d6:	83e9                	srli	a5,a5,0x1a
    800005d8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005da:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005dc:	04b7f263          	bgeu	a5,a1,80000620 <walk+0x66>
    panic("walk");
    800005e0:	00008517          	auipc	a0,0x8
    800005e4:	a7850513          	addi	a0,a0,-1416 # 80008058 <etext+0x58>
    800005e8:	00006097          	auipc	ra,0x6
    800005ec:	9d4080e7          	jalr	-1580(ra) # 80005fbc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005f0:	060a8663          	beqz	s5,8000065c <walk+0xa2>
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	bda080e7          	jalr	-1062(ra) # 800001ce <kalloc>
    800005fc:	84aa                	mv	s1,a0
    800005fe:	c529                	beqz	a0,80000648 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000600:	6605                	lui	a2,0x1
    80000602:	4581                	li	a1,0
    80000604:	00000097          	auipc	ra,0x0
    80000608:	cde080e7          	jalr	-802(ra) # 800002e2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000060c:	00c4d793          	srli	a5,s1,0xc
    80000610:	07aa                	slli	a5,a5,0xa
    80000612:	0017e793          	ori	a5,a5,1
    80000616:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000061a:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd5db7>
    8000061c:	036a0063          	beq	s4,s6,8000063c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000620:	0149d933          	srl	s2,s3,s4
    80000624:	1ff97913          	andi	s2,s2,511
    80000628:	090e                	slli	s2,s2,0x3
    8000062a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000062c:	00093483          	ld	s1,0(s2)
    80000630:	0014f793          	andi	a5,s1,1
    80000634:	dfd5                	beqz	a5,800005f0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000636:	80a9                	srli	s1,s1,0xa
    80000638:	04b2                	slli	s1,s1,0xc
    8000063a:	b7c5                	j	8000061a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000063c:	00c9d513          	srli	a0,s3,0xc
    80000640:	1ff57513          	andi	a0,a0,511
    80000644:	050e                	slli	a0,a0,0x3
    80000646:	9526                	add	a0,a0,s1
}
    80000648:	70e2                	ld	ra,56(sp)
    8000064a:	7442                	ld	s0,48(sp)
    8000064c:	74a2                	ld	s1,40(sp)
    8000064e:	7902                	ld	s2,32(sp)
    80000650:	69e2                	ld	s3,24(sp)
    80000652:	6a42                	ld	s4,16(sp)
    80000654:	6aa2                	ld	s5,8(sp)
    80000656:	6b02                	ld	s6,0(sp)
    80000658:	6121                	addi	sp,sp,64
    8000065a:	8082                	ret
        return 0;
    8000065c:	4501                	li	a0,0
    8000065e:	b7ed                	j	80000648 <walk+0x8e>

0000000080000660 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000660:	57fd                	li	a5,-1
    80000662:	83e9                	srli	a5,a5,0x1a
    80000664:	00b7f463          	bgeu	a5,a1,8000066c <walkaddr+0xc>
    return 0;
    80000668:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000066a:	8082                	ret
{
    8000066c:	1141                	addi	sp,sp,-16
    8000066e:	e406                	sd	ra,8(sp)
    80000670:	e022                	sd	s0,0(sp)
    80000672:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000674:	4601                	li	a2,0
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f44080e7          	jalr	-188(ra) # 800005ba <walk>
  if(pte == 0)
    8000067e:	c105                	beqz	a0,8000069e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000680:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000682:	0117f693          	andi	a3,a5,17
    80000686:	4745                	li	a4,17
    return 0;
    80000688:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000068a:	00e68663          	beq	a3,a4,80000696 <walkaddr+0x36>
}
    8000068e:	60a2                	ld	ra,8(sp)
    80000690:	6402                	ld	s0,0(sp)
    80000692:	0141                	addi	sp,sp,16
    80000694:	8082                	ret
  pa = PTE2PA(*pte);
    80000696:	83a9                	srli	a5,a5,0xa
    80000698:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000069c:	bfcd                	j	8000068e <walkaddr+0x2e>
    return 0;
    8000069e:	4501                	li	a0,0
    800006a0:	b7fd                	j	8000068e <walkaddr+0x2e>

00000000800006a2 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006a2:	715d                	addi	sp,sp,-80
    800006a4:	e486                	sd	ra,72(sp)
    800006a6:	e0a2                	sd	s0,64(sp)
    800006a8:	fc26                	sd	s1,56(sp)
    800006aa:	f84a                	sd	s2,48(sp)
    800006ac:	f44e                	sd	s3,40(sp)
    800006ae:	f052                	sd	s4,32(sp)
    800006b0:	ec56                	sd	s5,24(sp)
    800006b2:	e85a                	sd	s6,16(sp)
    800006b4:	e45e                	sd	s7,8(sp)
    800006b6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800006b8:	c621                	beqz	a2,80000700 <mappages+0x5e>
    800006ba:	8aaa                	mv	s5,a0
    800006bc:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800006be:	777d                	lui	a4,0xfffff
    800006c0:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800006c4:	fff58993          	addi	s3,a1,-1
    800006c8:	99b2                	add	s3,s3,a2
    800006ca:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800006ce:	893e                	mv	s2,a5
    800006d0:	40f68a33          	sub	s4,a3,a5
    // if(*pte & PTE_V)
    //   panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006d4:	6b85                	lui	s7,0x1
    800006d6:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800006da:	4605                	li	a2,1
    800006dc:	85ca                	mv	a1,s2
    800006de:	8556                	mv	a0,s5
    800006e0:	00000097          	auipc	ra,0x0
    800006e4:	eda080e7          	jalr	-294(ra) # 800005ba <walk>
    800006e8:	c505                	beqz	a0,80000710 <mappages+0x6e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006ea:	80b1                	srli	s1,s1,0xc
    800006ec:	04aa                	slli	s1,s1,0xa
    800006ee:	0164e4b3          	or	s1,s1,s6
    800006f2:	0014e493          	ori	s1,s1,1
    800006f6:	e104                	sd	s1,0(a0)
    if(a == last)
    800006f8:	03390863          	beq	s2,s3,80000728 <mappages+0x86>
    a += PGSIZE;
    800006fc:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006fe:	bfe1                	j	800006d6 <mappages+0x34>
    panic("mappages: size");
    80000700:	00008517          	auipc	a0,0x8
    80000704:	96050513          	addi	a0,a0,-1696 # 80008060 <etext+0x60>
    80000708:	00006097          	auipc	ra,0x6
    8000070c:	8b4080e7          	jalr	-1868(ra) # 80005fbc <panic>
      return -1;
    80000710:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000712:	60a6                	ld	ra,72(sp)
    80000714:	6406                	ld	s0,64(sp)
    80000716:	74e2                	ld	s1,56(sp)
    80000718:	7942                	ld	s2,48(sp)
    8000071a:	79a2                	ld	s3,40(sp)
    8000071c:	7a02                	ld	s4,32(sp)
    8000071e:	6ae2                	ld	s5,24(sp)
    80000720:	6b42                	ld	s6,16(sp)
    80000722:	6ba2                	ld	s7,8(sp)
    80000724:	6161                	addi	sp,sp,80
    80000726:	8082                	ret
  return 0;
    80000728:	4501                	li	a0,0
    8000072a:	b7e5                	j	80000712 <mappages+0x70>

000000008000072c <kvmmap>:
{
    8000072c:	1141                	addi	sp,sp,-16
    8000072e:	e406                	sd	ra,8(sp)
    80000730:	e022                	sd	s0,0(sp)
    80000732:	0800                	addi	s0,sp,16
    80000734:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000736:	86b2                	mv	a3,a2
    80000738:	863e                	mv	a2,a5
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	f68080e7          	jalr	-152(ra) # 800006a2 <mappages>
    80000742:	e509                	bnez	a0,8000074c <kvmmap+0x20>
}
    80000744:	60a2                	ld	ra,8(sp)
    80000746:	6402                	ld	s0,0(sp)
    80000748:	0141                	addi	sp,sp,16
    8000074a:	8082                	ret
    panic("kvmmap");
    8000074c:	00008517          	auipc	a0,0x8
    80000750:	92450513          	addi	a0,a0,-1756 # 80008070 <etext+0x70>
    80000754:	00006097          	auipc	ra,0x6
    80000758:	868080e7          	jalr	-1944(ra) # 80005fbc <panic>

000000008000075c <kvmmake>:
{
    8000075c:	1101                	addi	sp,sp,-32
    8000075e:	ec06                	sd	ra,24(sp)
    80000760:	e822                	sd	s0,16(sp)
    80000762:	e426                	sd	s1,8(sp)
    80000764:	e04a                	sd	s2,0(sp)
    80000766:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	a66080e7          	jalr	-1434(ra) # 800001ce <kalloc>
    80000770:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000772:	6605                	lui	a2,0x1
    80000774:	4581                	li	a1,0
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	b6c080e7          	jalr	-1172(ra) # 800002e2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000077e:	4719                	li	a4,6
    80000780:	6685                	lui	a3,0x1
    80000782:	10000637          	lui	a2,0x10000
    80000786:	100005b7          	lui	a1,0x10000
    8000078a:	8526                	mv	a0,s1
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	fa0080e7          	jalr	-96(ra) # 8000072c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000794:	4719                	li	a4,6
    80000796:	6685                	lui	a3,0x1
    80000798:	10001637          	lui	a2,0x10001
    8000079c:	100015b7          	lui	a1,0x10001
    800007a0:	8526                	mv	a0,s1
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	f8a080e7          	jalr	-118(ra) # 8000072c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007aa:	4719                	li	a4,6
    800007ac:	004006b7          	lui	a3,0x400
    800007b0:	0c000637          	lui	a2,0xc000
    800007b4:	0c0005b7          	lui	a1,0xc000
    800007b8:	8526                	mv	a0,s1
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	f72080e7          	jalr	-142(ra) # 8000072c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007c2:	00008917          	auipc	s2,0x8
    800007c6:	83e90913          	addi	s2,s2,-1986 # 80008000 <etext>
    800007ca:	4729                	li	a4,10
    800007cc:	80008697          	auipc	a3,0x80008
    800007d0:	83468693          	addi	a3,a3,-1996 # 8000 <_entry-0x7fff8000>
    800007d4:	4605                	li	a2,1
    800007d6:	067e                	slli	a2,a2,0x1f
    800007d8:	85b2                	mv	a1,a2
    800007da:	8526                	mv	a0,s1
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	f50080e7          	jalr	-176(ra) # 8000072c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007e4:	46c5                	li	a3,17
    800007e6:	06ee                	slli	a3,a3,0x1b
    800007e8:	4719                	li	a4,6
    800007ea:	412686b3          	sub	a3,a3,s2
    800007ee:	864a                	mv	a2,s2
    800007f0:	85ca                	mv	a1,s2
    800007f2:	8526                	mv	a0,s1
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	f38080e7          	jalr	-200(ra) # 8000072c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007fc:	4729                	li	a4,10
    800007fe:	6685                	lui	a3,0x1
    80000800:	00007617          	auipc	a2,0x7
    80000804:	80060613          	addi	a2,a2,-2048 # 80007000 <_trampoline>
    80000808:	040005b7          	lui	a1,0x4000
    8000080c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000080e:	05b2                	slli	a1,a1,0xc
    80000810:	8526                	mv	a0,s1
    80000812:	00000097          	auipc	ra,0x0
    80000816:	f1a080e7          	jalr	-230(ra) # 8000072c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000081a:	8526                	mv	a0,s1
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	760080e7          	jalr	1888(ra) # 80000f7c <proc_mapstacks>
}
    80000824:	8526                	mv	a0,s1
    80000826:	60e2                	ld	ra,24(sp)
    80000828:	6442                	ld	s0,16(sp)
    8000082a:	64a2                	ld	s1,8(sp)
    8000082c:	6902                	ld	s2,0(sp)
    8000082e:	6105                	addi	sp,sp,32
    80000830:	8082                	ret

0000000080000832 <kvminit>:
{
    80000832:	1141                	addi	sp,sp,-16
    80000834:	e406                	sd	ra,8(sp)
    80000836:	e022                	sd	s0,0(sp)
    80000838:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	f22080e7          	jalr	-222(ra) # 8000075c <kvmmake>
    80000842:	0000b797          	auipc	a5,0xb
    80000846:	7ca7b323          	sd	a0,1990(a5) # 8000c008 <kernel_pagetable>
}
    8000084a:	60a2                	ld	ra,8(sp)
    8000084c:	6402                	ld	s0,0(sp)
    8000084e:	0141                	addi	sp,sp,16
    80000850:	8082                	ret

0000000080000852 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000852:	715d                	addi	sp,sp,-80
    80000854:	e486                	sd	ra,72(sp)
    80000856:	e0a2                	sd	s0,64(sp)
    80000858:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000085a:	03459793          	slli	a5,a1,0x34
    8000085e:	e39d                	bnez	a5,80000884 <uvmunmap+0x32>
    80000860:	f84a                	sd	s2,48(sp)
    80000862:	f44e                	sd	s3,40(sp)
    80000864:	f052                	sd	s4,32(sp)
    80000866:	ec56                	sd	s5,24(sp)
    80000868:	e85a                	sd	s6,16(sp)
    8000086a:	e45e                	sd	s7,8(sp)
    8000086c:	8a2a                	mv	s4,a0
    8000086e:	892e                	mv	s2,a1
    80000870:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000872:	0632                	slli	a2,a2,0xc
    80000874:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000878:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000087a:	6b05                	lui	s6,0x1
    8000087c:	0935fb63          	bgeu	a1,s3,80000912 <uvmunmap+0xc0>
    80000880:	fc26                	sd	s1,56(sp)
    80000882:	a8a9                	j	800008dc <uvmunmap+0x8a>
    80000884:	fc26                	sd	s1,56(sp)
    80000886:	f84a                	sd	s2,48(sp)
    80000888:	f44e                	sd	s3,40(sp)
    8000088a:	f052                	sd	s4,32(sp)
    8000088c:	ec56                	sd	s5,24(sp)
    8000088e:	e85a                	sd	s6,16(sp)
    80000890:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000892:	00007517          	auipc	a0,0x7
    80000896:	7e650513          	addi	a0,a0,2022 # 80008078 <etext+0x78>
    8000089a:	00005097          	auipc	ra,0x5
    8000089e:	722080e7          	jalr	1826(ra) # 80005fbc <panic>
      panic("uvmunmap: walk");
    800008a2:	00007517          	auipc	a0,0x7
    800008a6:	7ee50513          	addi	a0,a0,2030 # 80008090 <etext+0x90>
    800008aa:	00005097          	auipc	ra,0x5
    800008ae:	712080e7          	jalr	1810(ra) # 80005fbc <panic>
      panic("uvmunmap: not mapped");
    800008b2:	00007517          	auipc	a0,0x7
    800008b6:	7ee50513          	addi	a0,a0,2030 # 800080a0 <etext+0xa0>
    800008ba:	00005097          	auipc	ra,0x5
    800008be:	702080e7          	jalr	1794(ra) # 80005fbc <panic>
      panic("uvmunmap: not a leaf");
    800008c2:	00007517          	auipc	a0,0x7
    800008c6:	7f650513          	addi	a0,a0,2038 # 800080b8 <etext+0xb8>
    800008ca:	00005097          	auipc	ra,0x5
    800008ce:	6f2080e7          	jalr	1778(ra) # 80005fbc <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800008d2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008d6:	995a                	add	s2,s2,s6
    800008d8:	03397c63          	bgeu	s2,s3,80000910 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008dc:	4601                	li	a2,0
    800008de:	85ca                	mv	a1,s2
    800008e0:	8552                	mv	a0,s4
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	cd8080e7          	jalr	-808(ra) # 800005ba <walk>
    800008ea:	84aa                	mv	s1,a0
    800008ec:	d95d                	beqz	a0,800008a2 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800008ee:	6108                	ld	a0,0(a0)
    800008f0:	00157793          	andi	a5,a0,1
    800008f4:	dfdd                	beqz	a5,800008b2 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008f6:	3ff57793          	andi	a5,a0,1023
    800008fa:	fd7784e3          	beq	a5,s7,800008c2 <uvmunmap+0x70>
    if(do_free){
    800008fe:	fc0a8ae3          	beqz	s5,800008d2 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000902:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000904:	0532                	slli	a0,a0,0xc
    80000906:	fffff097          	auipc	ra,0xfffff
    8000090a:	716080e7          	jalr	1814(ra) # 8000001c <kfree>
    8000090e:	b7d1                	j	800008d2 <uvmunmap+0x80>
    80000910:	74e2                	ld	s1,56(sp)
    80000912:	7942                	ld	s2,48(sp)
    80000914:	79a2                	ld	s3,40(sp)
    80000916:	7a02                	ld	s4,32(sp)
    80000918:	6ae2                	ld	s5,24(sp)
    8000091a:	6b42                	ld	s6,16(sp)
    8000091c:	6ba2                	ld	s7,8(sp)
  }
}
    8000091e:	60a6                	ld	ra,72(sp)
    80000920:	6406                	ld	s0,64(sp)
    80000922:	6161                	addi	sp,sp,80
    80000924:	8082                	ret

0000000080000926 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000926:	1101                	addi	sp,sp,-32
    80000928:	ec06                	sd	ra,24(sp)
    8000092a:	e822                	sd	s0,16(sp)
    8000092c:	e426                	sd	s1,8(sp)
    8000092e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000930:	00000097          	auipc	ra,0x0
    80000934:	89e080e7          	jalr	-1890(ra) # 800001ce <kalloc>
    80000938:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000093a:	c519                	beqz	a0,80000948 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	9a2080e7          	jalr	-1630(ra) # 800002e2 <memset>
  return pagetable;
}
    80000948:	8526                	mv	a0,s1
    8000094a:	60e2                	ld	ra,24(sp)
    8000094c:	6442                	ld	s0,16(sp)
    8000094e:	64a2                	ld	s1,8(sp)
    80000950:	6105                	addi	sp,sp,32
    80000952:	8082                	ret

0000000080000954 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000954:	7179                	addi	sp,sp,-48
    80000956:	f406                	sd	ra,40(sp)
    80000958:	f022                	sd	s0,32(sp)
    8000095a:	ec26                	sd	s1,24(sp)
    8000095c:	e84a                	sd	s2,16(sp)
    8000095e:	e44e                	sd	s3,8(sp)
    80000960:	e052                	sd	s4,0(sp)
    80000962:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000964:	6785                	lui	a5,0x1
    80000966:	04f67863          	bgeu	a2,a5,800009b6 <uvminit+0x62>
    8000096a:	8a2a                	mv	s4,a0
    8000096c:	89ae                	mv	s3,a1
    8000096e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000970:	00000097          	auipc	ra,0x0
    80000974:	85e080e7          	jalr	-1954(ra) # 800001ce <kalloc>
    80000978:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000097a:	6605                	lui	a2,0x1
    8000097c:	4581                	li	a1,0
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	964080e7          	jalr	-1692(ra) # 800002e2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000986:	4779                	li	a4,30
    80000988:	86ca                	mv	a3,s2
    8000098a:	6605                	lui	a2,0x1
    8000098c:	4581                	li	a1,0
    8000098e:	8552                	mv	a0,s4
    80000990:	00000097          	auipc	ra,0x0
    80000994:	d12080e7          	jalr	-750(ra) # 800006a2 <mappages>
  memmove(mem, src, sz);
    80000998:	8626                	mv	a2,s1
    8000099a:	85ce                	mv	a1,s3
    8000099c:	854a                	mv	a0,s2
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	9a0080e7          	jalr	-1632(ra) # 8000033e <memmove>
}
    800009a6:	70a2                	ld	ra,40(sp)
    800009a8:	7402                	ld	s0,32(sp)
    800009aa:	64e2                	ld	s1,24(sp)
    800009ac:	6942                	ld	s2,16(sp)
    800009ae:	69a2                	ld	s3,8(sp)
    800009b0:	6a02                	ld	s4,0(sp)
    800009b2:	6145                	addi	sp,sp,48
    800009b4:	8082                	ret
    panic("inituvm: more than a page");
    800009b6:	00007517          	auipc	a0,0x7
    800009ba:	71a50513          	addi	a0,a0,1818 # 800080d0 <etext+0xd0>
    800009be:	00005097          	auipc	ra,0x5
    800009c2:	5fe080e7          	jalr	1534(ra) # 80005fbc <panic>

00000000800009c6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009c6:	1101                	addi	sp,sp,-32
    800009c8:	ec06                	sd	ra,24(sp)
    800009ca:	e822                	sd	s0,16(sp)
    800009cc:	e426                	sd	s1,8(sp)
    800009ce:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009d0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009d2:	00b67d63          	bgeu	a2,a1,800009ec <uvmdealloc+0x26>
    800009d6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009d8:	6785                	lui	a5,0x1
    800009da:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009dc:	00f60733          	add	a4,a2,a5
    800009e0:	76fd                	lui	a3,0xfffff
    800009e2:	8f75                	and	a4,a4,a3
    800009e4:	97ae                	add	a5,a5,a1
    800009e6:	8ff5                	and	a5,a5,a3
    800009e8:	00f76863          	bltu	a4,a5,800009f8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009ec:	8526                	mv	a0,s1
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009f8:	8f99                	sub	a5,a5,a4
    800009fa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009fc:	4685                	li	a3,1
    800009fe:	0007861b          	sext.w	a2,a5
    80000a02:	85ba                	mv	a1,a4
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	e4e080e7          	jalr	-434(ra) # 80000852 <uvmunmap>
    80000a0c:	b7c5                	j	800009ec <uvmdealloc+0x26>

0000000080000a0e <uvmalloc>:
  if(newsz < oldsz)
    80000a0e:	0ab66563          	bltu	a2,a1,80000ab8 <uvmalloc+0xaa>
{
    80000a12:	7139                	addi	sp,sp,-64
    80000a14:	fc06                	sd	ra,56(sp)
    80000a16:	f822                	sd	s0,48(sp)
    80000a18:	ec4e                	sd	s3,24(sp)
    80000a1a:	e852                	sd	s4,16(sp)
    80000a1c:	e456                	sd	s5,8(sp)
    80000a1e:	0080                	addi	s0,sp,64
    80000a20:	8aaa                	mv	s5,a0
    80000a22:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a24:	6785                	lui	a5,0x1
    80000a26:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a28:	95be                	add	a1,a1,a5
    80000a2a:	77fd                	lui	a5,0xfffff
    80000a2c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a30:	08c9f663          	bgeu	s3,a2,80000abc <uvmalloc+0xae>
    80000a34:	f426                	sd	s1,40(sp)
    80000a36:	f04a                	sd	s2,32(sp)
    80000a38:	894e                	mv	s2,s3
    mem = kalloc();
    80000a3a:	fffff097          	auipc	ra,0xfffff
    80000a3e:	794080e7          	jalr	1940(ra) # 800001ce <kalloc>
    80000a42:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a44:	c90d                	beqz	a0,80000a76 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000a46:	6605                	lui	a2,0x1
    80000a48:	4581                	li	a1,0
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	898080e7          	jalr	-1896(ra) # 800002e2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a52:	4779                	li	a4,30
    80000a54:	86a6                	mv	a3,s1
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85ca                	mv	a1,s2
    80000a5a:	8556                	mv	a0,s5
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	c46080e7          	jalr	-954(ra) # 800006a2 <mappages>
    80000a64:	e915                	bnez	a0,80000a98 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a66:	6785                	lui	a5,0x1
    80000a68:	993e                	add	s2,s2,a5
    80000a6a:	fd4968e3          	bltu	s2,s4,80000a3a <uvmalloc+0x2c>
  return newsz;
    80000a6e:	8552                	mv	a0,s4
    80000a70:	74a2                	ld	s1,40(sp)
    80000a72:	7902                	ld	s2,32(sp)
    80000a74:	a819                	j	80000a8a <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000a76:	864e                	mv	a2,s3
    80000a78:	85ca                	mv	a1,s2
    80000a7a:	8556                	mv	a0,s5
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	f4a080e7          	jalr	-182(ra) # 800009c6 <uvmdealloc>
      return 0;
    80000a84:	4501                	li	a0,0
    80000a86:	74a2                	ld	s1,40(sp)
    80000a88:	7902                	ld	s2,32(sp)
}
    80000a8a:	70e2                	ld	ra,56(sp)
    80000a8c:	7442                	ld	s0,48(sp)
    80000a8e:	69e2                	ld	s3,24(sp)
    80000a90:	6a42                	ld	s4,16(sp)
    80000a92:	6aa2                	ld	s5,8(sp)
    80000a94:	6121                	addi	sp,sp,64
    80000a96:	8082                	ret
      kfree(mem);
    80000a98:	8526                	mv	a0,s1
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000aa2:	864e                	mv	a2,s3
    80000aa4:	85ca                	mv	a1,s2
    80000aa6:	8556                	mv	a0,s5
    80000aa8:	00000097          	auipc	ra,0x0
    80000aac:	f1e080e7          	jalr	-226(ra) # 800009c6 <uvmdealloc>
      return 0;
    80000ab0:	4501                	li	a0,0
    80000ab2:	74a2                	ld	s1,40(sp)
    80000ab4:	7902                	ld	s2,32(sp)
    80000ab6:	bfd1                	j	80000a8a <uvmalloc+0x7c>
    return oldsz;
    80000ab8:	852e                	mv	a0,a1
}
    80000aba:	8082                	ret
  return newsz;
    80000abc:	8532                	mv	a0,a2
    80000abe:	b7f1                	j	80000a8a <uvmalloc+0x7c>

0000000080000ac0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000ac0:	7179                	addi	sp,sp,-48
    80000ac2:	f406                	sd	ra,40(sp)
    80000ac4:	f022                	sd	s0,32(sp)
    80000ac6:	ec26                	sd	s1,24(sp)
    80000ac8:	e84a                	sd	s2,16(sp)
    80000aca:	e44e                	sd	s3,8(sp)
    80000acc:	e052                	sd	s4,0(sp)
    80000ace:	1800                	addi	s0,sp,48
    80000ad0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000ad2:	84aa                	mv	s1,a0
    80000ad4:	6905                	lui	s2,0x1
    80000ad6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ad8:	4985                	li	s3,1
    80000ada:	a829                	j	80000af4 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000adc:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000ade:	00c79513          	slli	a0,a5,0xc
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	fde080e7          	jalr	-34(ra) # 80000ac0 <freewalk>
      pagetable[i] = 0;
    80000aea:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000aee:	04a1                	addi	s1,s1,8
    80000af0:	03248163          	beq	s1,s2,80000b12 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000af4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000af6:	00f7f713          	andi	a4,a5,15
    80000afa:	ff3701e3          	beq	a4,s3,80000adc <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000afe:	8b85                	andi	a5,a5,1
    80000b00:	d7fd                	beqz	a5,80000aee <freewalk+0x2e>
      panic("freewalk: leaf");
    80000b02:	00007517          	auipc	a0,0x7
    80000b06:	5ee50513          	addi	a0,a0,1518 # 800080f0 <etext+0xf0>
    80000b0a:	00005097          	auipc	ra,0x5
    80000b0e:	4b2080e7          	jalr	1202(ra) # 80005fbc <panic>
    }
  }
  kfree((void*)pagetable);
    80000b12:	8552                	mv	a0,s4
    80000b14:	fffff097          	auipc	ra,0xfffff
    80000b18:	508080e7          	jalr	1288(ra) # 8000001c <kfree>
}
    80000b1c:	70a2                	ld	ra,40(sp)
    80000b1e:	7402                	ld	s0,32(sp)
    80000b20:	64e2                	ld	s1,24(sp)
    80000b22:	6942                	ld	s2,16(sp)
    80000b24:	69a2                	ld	s3,8(sp)
    80000b26:	6a02                	ld	s4,0(sp)
    80000b28:	6145                	addi	sp,sp,48
    80000b2a:	8082                	ret

0000000080000b2c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b2c:	1101                	addi	sp,sp,-32
    80000b2e:	ec06                	sd	ra,24(sp)
    80000b30:	e822                	sd	s0,16(sp)
    80000b32:	e426                	sd	s1,8(sp)
    80000b34:	1000                	addi	s0,sp,32
    80000b36:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b38:	e999                	bnez	a1,80000b4e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b3a:	8526                	mv	a0,s1
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	f84080e7          	jalr	-124(ra) # 80000ac0 <freewalk>
}
    80000b44:	60e2                	ld	ra,24(sp)
    80000b46:	6442                	ld	s0,16(sp)
    80000b48:	64a2                	ld	s1,8(sp)
    80000b4a:	6105                	addi	sp,sp,32
    80000b4c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b4e:	6785                	lui	a5,0x1
    80000b50:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b52:	95be                	add	a1,a1,a5
    80000b54:	4685                	li	a3,1
    80000b56:	00c5d613          	srli	a2,a1,0xc
    80000b5a:	4581                	li	a1,0
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	cf6080e7          	jalr	-778(ra) # 80000852 <uvmunmap>
    80000b64:	bfd9                	j	80000b3a <uvmfree+0xe>

0000000080000b66 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b66:	7139                	addi	sp,sp,-64
    80000b68:	fc06                	sd	ra,56(sp)
    80000b6a:	f822                	sd	s0,48(sp)
    80000b6c:	e05a                	sd	s6,0(sp)
    80000b6e:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b70:	ce55                	beqz	a2,80000c2c <uvmcopy+0xc6>
    80000b72:	f426                	sd	s1,40(sp)
    80000b74:	f04a                	sd	s2,32(sp)
    80000b76:	ec4e                	sd	s3,24(sp)
    80000b78:	e852                	sd	s4,16(sp)
    80000b7a:	e456                	sd	s5,8(sp)
    80000b7c:	8aaa                	mv	s5,a0
    80000b7e:	8a2e                	mv	s4,a1
    80000b80:	89b2                	mv	s3,a2
    80000b82:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000b84:	4601                	li	a2,0
    80000b86:	85a6                	mv	a1,s1
    80000b88:	8556                	mv	a0,s5
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	a30080e7          	jalr	-1488(ra) # 800005ba <walk>
    80000b92:	c921                	beqz	a0,80000be2 <uvmcopy+0x7c>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b94:	6118                	ld	a4,0(a0)
    80000b96:	00177793          	andi	a5,a4,1
    80000b9a:	cfa1                	beqz	a5,80000bf2 <uvmcopy+0x8c>
      panic("uvmcopy: page not present");
    *pte=((*pte)&(~PTE_W))|PTE_COW;
    80000b9c:	efb77713          	andi	a4,a4,-261
    80000ba0:	10076713          	ori	a4,a4,256
    80000ba4:	e118                	sd	a4,0(a0)
    pa = PTE2PA(*pte);
    80000ba6:	00a75913          	srli	s2,a4,0xa
    80000baa:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    // if((mem = kalloc()) == 0)
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000bac:	3fb77713          	andi	a4,a4,1019
    80000bb0:	86ca                	mv	a3,s2
    80000bb2:	6605                	lui	a2,0x1
    80000bb4:	85a6                	mv	a1,s1
    80000bb6:	8552                	mv	a0,s4
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	aea080e7          	jalr	-1302(ra) # 800006a2 <mappages>
    80000bc0:	8b2a                	mv	s6,a0
    80000bc2:	e121                	bnez	a0,80000c02 <uvmcopy+0x9c>
      // kfree(mem);
      goto err;
    }
    add_kmem_ref((void*)pa);
    80000bc4:	854a                	mv	a0,s2
    80000bc6:	fffff097          	auipc	ra,0xfffff
    80000bca:	6ae080e7          	jalr	1710(ra) # 80000274 <add_kmem_ref>
  for(i = 0; i < sz; i += PGSIZE){
    80000bce:	6785                	lui	a5,0x1
    80000bd0:	94be                	add	s1,s1,a5
    80000bd2:	fb34e9e3          	bltu	s1,s3,80000b84 <uvmcopy+0x1e>
    80000bd6:	74a2                	ld	s1,40(sp)
    80000bd8:	7902                	ld	s2,32(sp)
    80000bda:	69e2                	ld	s3,24(sp)
    80000bdc:	6a42                	ld	s4,16(sp)
    80000bde:	6aa2                	ld	s5,8(sp)
    80000be0:	a081                	j	80000c20 <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    80000be2:	00007517          	auipc	a0,0x7
    80000be6:	51e50513          	addi	a0,a0,1310 # 80008100 <etext+0x100>
    80000bea:	00005097          	auipc	ra,0x5
    80000bee:	3d2080e7          	jalr	978(ra) # 80005fbc <panic>
      panic("uvmcopy: page not present");
    80000bf2:	00007517          	auipc	a0,0x7
    80000bf6:	52e50513          	addi	a0,a0,1326 # 80008120 <etext+0x120>
    80000bfa:	00005097          	auipc	ra,0x5
    80000bfe:	3c2080e7          	jalr	962(ra) # 80005fbc <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c02:	4685                	li	a3,1
    80000c04:	00c4d613          	srli	a2,s1,0xc
    80000c08:	4581                	li	a1,0
    80000c0a:	8552                	mv	a0,s4
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	c46080e7          	jalr	-954(ra) # 80000852 <uvmunmap>
  return -1;
    80000c14:	5b7d                	li	s6,-1
    80000c16:	74a2                	ld	s1,40(sp)
    80000c18:	7902                	ld	s2,32(sp)
    80000c1a:	69e2                	ld	s3,24(sp)
    80000c1c:	6a42                	ld	s4,16(sp)
    80000c1e:	6aa2                	ld	s5,8(sp)
}
    80000c20:	855a                	mv	a0,s6
    80000c22:	70e2                	ld	ra,56(sp)
    80000c24:	7442                	ld	s0,48(sp)
    80000c26:	6b02                	ld	s6,0(sp)
    80000c28:	6121                	addi	sp,sp,64
    80000c2a:	8082                	ret
  return 0;
    80000c2c:	4b01                	li	s6,0
    80000c2e:	bfcd                	j	80000c20 <uvmcopy+0xba>

0000000080000c30 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c30:	1141                	addi	sp,sp,-16
    80000c32:	e406                	sd	ra,8(sp)
    80000c34:	e022                	sd	s0,0(sp)
    80000c36:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c38:	4601                	li	a2,0
    80000c3a:	00000097          	auipc	ra,0x0
    80000c3e:	980080e7          	jalr	-1664(ra) # 800005ba <walk>
  if(pte == 0)
    80000c42:	c901                	beqz	a0,80000c52 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c44:	611c                	ld	a5,0(a0)
    80000c46:	9bbd                	andi	a5,a5,-17
    80000c48:	e11c                	sd	a5,0(a0)
}
    80000c4a:	60a2                	ld	ra,8(sp)
    80000c4c:	6402                	ld	s0,0(sp)
    80000c4e:	0141                	addi	sp,sp,16
    80000c50:	8082                	ret
    panic("uvmclear");
    80000c52:	00007517          	auipc	a0,0x7
    80000c56:	4ee50513          	addi	a0,a0,1262 # 80008140 <etext+0x140>
    80000c5a:	00005097          	auipc	ra,0x5
    80000c5e:	362080e7          	jalr	866(ra) # 80005fbc <panic>

0000000080000c62 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000c62:	16068c63          	beqz	a3,80000dda <copyout+0x178>
{
    80000c66:	7119                	addi	sp,sp,-128
    80000c68:	fc86                	sd	ra,120(sp)
    80000c6a:	f8a2                	sd	s0,112(sp)
    80000c6c:	f4a6                	sd	s1,104(sp)
    80000c6e:	e8d2                	sd	s4,80(sp)
    80000c70:	e4d6                	sd	s5,72(sp)
    80000c72:	e0da                	sd	s6,64(sp)
    80000c74:	fc5e                	sd	s7,56(sp)
    80000c76:	0100                	addi	s0,sp,128
    80000c78:	8baa                	mv	s7,a0
    80000c7a:	8aae                	mv	s5,a1
    80000c7c:	8b32                	mv	s6,a2
    80000c7e:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000c80:	74fd                	lui	s1,0xfffff
    80000c82:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)  
    80000c84:	57fd                	li	a5,-1
    80000c86:	83e9                	srli	a5,a5,0x1a
    80000c88:	1497eb63          	bltu	a5,s1,80000dde <copyout+0x17c>
    80000c8c:	f0ca                	sd	s2,96(sp)
    80000c8e:	ecce                	sd	s3,88(sp)
    80000c90:	f862                	sd	s8,48(sp)
    80000c92:	f466                	sd	s9,40(sp)
    80000c94:	f06a                	sd	s10,32(sp)
    80000c96:	ec6e                	sd	s11,24(sp)
      return -1;
    if((pte = walk(pagetable, va0, 0)) == 0)
      return -1;
    if (((*pte & PTE_V) == 0) || ((*pte & PTE_U)) == 0) 
    80000c98:	4cc5                	li	s9,17
      return -1;
    
    pa0 = PTE2PA(*pte);
    if (((*pte & PTE_W) == 0) && (*pte & PTE_COW))
    80000c9a:	10000d13          	li	s10,256
    {
      acquire_ref_lock();
      if (get_kmem_ref((void*)pa0) == 1) 
    80000c9e:	4d85                	li	s11,1
    if(va0 >= MAXVA)  
    80000ca0:	8c3e                	mv	s8,a5
    80000ca2:	a0d5                	j	80000d86 <copyout+0x124>
      acquire_ref_lock();
    80000ca4:	fffff097          	auipc	ra,0xfffff
    80000ca8:	5fe080e7          	jalr	1534(ra) # 800002a2 <acquire_ref_lock>
    pa0 = PTE2PA(*pte);
    80000cac:	00a9d993          	srli	s3,s3,0xa
    80000cb0:	09b2                	slli	s3,s3,0xc
      if (get_kmem_ref((void*)pa0) == 1) 
    80000cb2:	854e                	mv	a0,s3
    80000cb4:	fffff097          	auipc	ra,0xfffff
    80000cb8:	596080e7          	jalr	1430(ra) # 8000024a <get_kmem_ref>
    80000cbc:	01b51f63          	bne	a0,s11,80000cda <copyout+0x78>
      {
          *pte = (*pte | PTE_W) & (~PTE_COW);
    80000cc0:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000cc4:	efb7f793          	andi	a5,a5,-261
    80000cc8:	0047e793          	ori	a5,a5,4
    80000ccc:	00f93023          	sd	a5,0(s2)
          release_ref_lock();
          return -1;
        }
        kfree((void*)pa0);
      }
      release_ref_lock();
    80000cd0:	fffff097          	auipc	ra,0xfffff
    80000cd4:	5f2080e7          	jalr	1522(ra) # 800002c2 <release_ref_lock>
    80000cd8:	a8d1                	j	80000dac <copyout+0x14a>
        char* mem = kalloc();
    80000cda:	fffff097          	auipc	ra,0xfffff
    80000cde:	4f4080e7          	jalr	1268(ra) # 800001ce <kalloc>
    80000ce2:	f8a43423          	sd	a0,-120(s0)
        if (mem == 0)
    80000ce6:	cd1d                	beqz	a0,80000d24 <copyout+0xc2>
        memmove(mem, (char*)pa0, PGSIZE);
    80000ce8:	6605                	lui	a2,0x1
    80000cea:	85ce                	mv	a1,s3
    80000cec:	f8843503          	ld	a0,-120(s0)
    80000cf0:	fffff097          	auipc	ra,0xfffff
    80000cf4:	64e080e7          	jalr	1614(ra) # 8000033e <memmove>
        uint new_flags = (PTE_FLAGS(*pte) | PTE_COW) & (~PTE_W);
    80000cf8:	00093703          	ld	a4,0(s2)
    80000cfc:	2fb77713          	andi	a4,a4,763
        if (mappages(pagetable, va0, PGSIZE, (uint64)mem, new_flags) != 0)
    80000d00:	10076713          	ori	a4,a4,256
    80000d04:	f8843683          	ld	a3,-120(s0)
    80000d08:	6605                	lui	a2,0x1
    80000d0a:	85a6                	mv	a1,s1
    80000d0c:	855e                	mv	a0,s7
    80000d0e:	00000097          	auipc	ra,0x0
    80000d12:	994080e7          	jalr	-1644(ra) # 800006a2 <mappages>
    80000d16:	e11d                	bnez	a0,80000d3c <copyout+0xda>
        kfree((void*)pa0);
    80000d18:	854e                	mv	a0,s3
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	302080e7          	jalr	770(ra) # 8000001c <kfree>
    80000d22:	b77d                	j	80000cd0 <copyout+0x6e>
          release_ref_lock();
    80000d24:	fffff097          	auipc	ra,0xfffff
    80000d28:	59e080e7          	jalr	1438(ra) # 800002c2 <release_ref_lock>
          return -1;
    80000d2c:	557d                	li	a0,-1
    80000d2e:	7906                	ld	s2,96(sp)
    80000d30:	69e6                	ld	s3,88(sp)
    80000d32:	7c42                	ld	s8,48(sp)
    80000d34:	7ca2                	ld	s9,40(sp)
    80000d36:	7d02                	ld	s10,32(sp)
    80000d38:	6de2                	ld	s11,24(sp)
    80000d3a:	a0d9                	j	80000e00 <copyout+0x19e>
          kfree(mem);
    80000d3c:	f8843503          	ld	a0,-120(s0)
    80000d40:	fffff097          	auipc	ra,0xfffff
    80000d44:	2dc080e7          	jalr	732(ra) # 8000001c <kfree>
          release_ref_lock();
    80000d48:	fffff097          	auipc	ra,0xfffff
    80000d4c:	57a080e7          	jalr	1402(ra) # 800002c2 <release_ref_lock>
          return -1;
    80000d50:	557d                	li	a0,-1
    80000d52:	7906                	ld	s2,96(sp)
    80000d54:	69e6                	ld	s3,88(sp)
    80000d56:	7c42                	ld	s8,48(sp)
    80000d58:	7ca2                	ld	s9,40(sp)
    80000d5a:	7d02                	ld	s10,32(sp)
    80000d5c:	6de2                	ld	s11,24(sp)
    80000d5e:	a04d                	j	80000e00 <copyout+0x19e>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000d60:	409a84b3          	sub	s1,s5,s1
    80000d64:	0009861b          	sext.w	a2,s3
    80000d68:	85da                	mv	a1,s6
    80000d6a:	9526                	add	a0,a0,s1
    80000d6c:	fffff097          	auipc	ra,0xfffff
    80000d70:	5d2080e7          	jalr	1490(ra) # 8000033e <memmove>

    len -= n;
    80000d74:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000d78:	9b4e                	add	s6,s6,s3
  while(len > 0){
    80000d7a:	040a0863          	beqz	s4,80000dca <copyout+0x168>
    if(va0 >= MAXVA)  
    80000d7e:	072c6263          	bltu	s8,s2,80000de2 <copyout+0x180>
    80000d82:	84ca                	mv	s1,s2
    80000d84:	8aca                	mv	s5,s2
    if((pte = walk(pagetable, va0, 0)) == 0)
    80000d86:	4601                	li	a2,0
    80000d88:	85a6                	mv	a1,s1
    80000d8a:	855e                	mv	a0,s7
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	82e080e7          	jalr	-2002(ra) # 800005ba <walk>
    80000d94:	892a                	mv	s2,a0
    80000d96:	cd31                	beqz	a0,80000df2 <copyout+0x190>
    if (((*pte & PTE_V) == 0) || ((*pte & PTE_U)) == 0) 
    80000d98:	00053983          	ld	s3,0(a0)
    80000d9c:	0119f793          	andi	a5,s3,17
    80000da0:	07979963          	bne	a5,s9,80000e12 <copyout+0x1b0>
    if (((*pte & PTE_W) == 0) && (*pte & PTE_COW))
    80000da4:	1049f793          	andi	a5,s3,260
    80000da8:	efa78ee3          	beq	a5,s10,80000ca4 <copyout+0x42>
    pa0 = walkaddr(pagetable, va0);
    80000dac:	85a6                	mv	a1,s1
    80000dae:	855e                	mv	a0,s7
    80000db0:	00000097          	auipc	ra,0x0
    80000db4:	8b0080e7          	jalr	-1872(ra) # 80000660 <walkaddr>
    if(pa0 == 0)
    80000db8:	c52d                	beqz	a0,80000e22 <copyout+0x1c0>
    n = PGSIZE - (dstva - va0);
    80000dba:	6905                	lui	s2,0x1
    80000dbc:	9926                	add	s2,s2,s1
    80000dbe:	415909b3          	sub	s3,s2,s5
    if(n > len)
    80000dc2:	f93a7fe3          	bgeu	s4,s3,80000d60 <copyout+0xfe>
    80000dc6:	89d2                	mv	s3,s4
    80000dc8:	bf61                	j	80000d60 <copyout+0xfe>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000dca:	4501                	li	a0,0
    80000dcc:	7906                	ld	s2,96(sp)
    80000dce:	69e6                	ld	s3,88(sp)
    80000dd0:	7c42                	ld	s8,48(sp)
    80000dd2:	7ca2                	ld	s9,40(sp)
    80000dd4:	7d02                	ld	s10,32(sp)
    80000dd6:	6de2                	ld	s11,24(sp)
    80000dd8:	a025                	j	80000e00 <copyout+0x19e>
    80000dda:	4501                	li	a0,0
}
    80000ddc:	8082                	ret
      return -1;
    80000dde:	557d                	li	a0,-1
    80000de0:	a005                	j	80000e00 <copyout+0x19e>
    80000de2:	557d                	li	a0,-1
    80000de4:	7906                	ld	s2,96(sp)
    80000de6:	69e6                	ld	s3,88(sp)
    80000de8:	7c42                	ld	s8,48(sp)
    80000dea:	7ca2                	ld	s9,40(sp)
    80000dec:	7d02                	ld	s10,32(sp)
    80000dee:	6de2                	ld	s11,24(sp)
    80000df0:	a801                	j	80000e00 <copyout+0x19e>
      return -1;
    80000df2:	557d                	li	a0,-1
    80000df4:	7906                	ld	s2,96(sp)
    80000df6:	69e6                	ld	s3,88(sp)
    80000df8:	7c42                	ld	s8,48(sp)
    80000dfa:	7ca2                	ld	s9,40(sp)
    80000dfc:	7d02                	ld	s10,32(sp)
    80000dfe:	6de2                	ld	s11,24(sp)
}
    80000e00:	70e6                	ld	ra,120(sp)
    80000e02:	7446                	ld	s0,112(sp)
    80000e04:	74a6                	ld	s1,104(sp)
    80000e06:	6a46                	ld	s4,80(sp)
    80000e08:	6aa6                	ld	s5,72(sp)
    80000e0a:	6b06                	ld	s6,64(sp)
    80000e0c:	7be2                	ld	s7,56(sp)
    80000e0e:	6109                	addi	sp,sp,128
    80000e10:	8082                	ret
      return -1;
    80000e12:	557d                	li	a0,-1
    80000e14:	7906                	ld	s2,96(sp)
    80000e16:	69e6                	ld	s3,88(sp)
    80000e18:	7c42                	ld	s8,48(sp)
    80000e1a:	7ca2                	ld	s9,40(sp)
    80000e1c:	7d02                	ld	s10,32(sp)
    80000e1e:	6de2                	ld	s11,24(sp)
    80000e20:	b7c5                	j	80000e00 <copyout+0x19e>
      return -1;
    80000e22:	557d                	li	a0,-1
    80000e24:	7906                	ld	s2,96(sp)
    80000e26:	69e6                	ld	s3,88(sp)
    80000e28:	7c42                	ld	s8,48(sp)
    80000e2a:	7ca2                	ld	s9,40(sp)
    80000e2c:	7d02                	ld	s10,32(sp)
    80000e2e:	6de2                	ld	s11,24(sp)
    80000e30:	bfc1                	j	80000e00 <copyout+0x19e>

0000000080000e32 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000e32:	caa5                	beqz	a3,80000ea2 <copyin+0x70>
{
    80000e34:	715d                	addi	sp,sp,-80
    80000e36:	e486                	sd	ra,72(sp)
    80000e38:	e0a2                	sd	s0,64(sp)
    80000e3a:	fc26                	sd	s1,56(sp)
    80000e3c:	f84a                	sd	s2,48(sp)
    80000e3e:	f44e                	sd	s3,40(sp)
    80000e40:	f052                	sd	s4,32(sp)
    80000e42:	ec56                	sd	s5,24(sp)
    80000e44:	e85a                	sd	s6,16(sp)
    80000e46:	e45e                	sd	s7,8(sp)
    80000e48:	e062                	sd	s8,0(sp)
    80000e4a:	0880                	addi	s0,sp,80
    80000e4c:	8b2a                	mv	s6,a0
    80000e4e:	8a2e                	mv	s4,a1
    80000e50:	8c32                	mv	s8,a2
    80000e52:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000e54:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e56:	6a85                	lui	s5,0x1
    80000e58:	a01d                	j	80000e7e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000e5a:	018505b3          	add	a1,a0,s8
    80000e5e:	0004861b          	sext.w	a2,s1
    80000e62:	412585b3          	sub	a1,a1,s2
    80000e66:	8552                	mv	a0,s4
    80000e68:	fffff097          	auipc	ra,0xfffff
    80000e6c:	4d6080e7          	jalr	1238(ra) # 8000033e <memmove>

    len -= n;
    80000e70:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000e74:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000e76:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000e7a:	02098263          	beqz	s3,80000e9e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000e7e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000e82:	85ca                	mv	a1,s2
    80000e84:	855a                	mv	a0,s6
    80000e86:	fffff097          	auipc	ra,0xfffff
    80000e8a:	7da080e7          	jalr	2010(ra) # 80000660 <walkaddr>
    if(pa0 == 0)
    80000e8e:	cd01                	beqz	a0,80000ea6 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000e90:	418904b3          	sub	s1,s2,s8
    80000e94:	94d6                	add	s1,s1,s5
    if(n > len)
    80000e96:	fc99f2e3          	bgeu	s3,s1,80000e5a <copyin+0x28>
    80000e9a:	84ce                	mv	s1,s3
    80000e9c:	bf7d                	j	80000e5a <copyin+0x28>
  }
  return 0;
    80000e9e:	4501                	li	a0,0
    80000ea0:	a021                	j	80000ea8 <copyin+0x76>
    80000ea2:	4501                	li	a0,0
}
    80000ea4:	8082                	ret
      return -1;
    80000ea6:	557d                	li	a0,-1
}
    80000ea8:	60a6                	ld	ra,72(sp)
    80000eaa:	6406                	ld	s0,64(sp)
    80000eac:	74e2                	ld	s1,56(sp)
    80000eae:	7942                	ld	s2,48(sp)
    80000eb0:	79a2                	ld	s3,40(sp)
    80000eb2:	7a02                	ld	s4,32(sp)
    80000eb4:	6ae2                	ld	s5,24(sp)
    80000eb6:	6b42                	ld	s6,16(sp)
    80000eb8:	6ba2                	ld	s7,8(sp)
    80000eba:	6c02                	ld	s8,0(sp)
    80000ebc:	6161                	addi	sp,sp,80
    80000ebe:	8082                	ret

0000000080000ec0 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000ec0:	cacd                	beqz	a3,80000f72 <copyinstr+0xb2>
{
    80000ec2:	715d                	addi	sp,sp,-80
    80000ec4:	e486                	sd	ra,72(sp)
    80000ec6:	e0a2                	sd	s0,64(sp)
    80000ec8:	fc26                	sd	s1,56(sp)
    80000eca:	f84a                	sd	s2,48(sp)
    80000ecc:	f44e                	sd	s3,40(sp)
    80000ece:	f052                	sd	s4,32(sp)
    80000ed0:	ec56                	sd	s5,24(sp)
    80000ed2:	e85a                	sd	s6,16(sp)
    80000ed4:	e45e                	sd	s7,8(sp)
    80000ed6:	0880                	addi	s0,sp,80
    80000ed8:	8a2a                	mv	s4,a0
    80000eda:	8b2e                	mv	s6,a1
    80000edc:	8bb2                	mv	s7,a2
    80000ede:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000ee0:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ee2:	6985                	lui	s3,0x1
    80000ee4:	a825                	j	80000f1c <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ee6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000eea:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000eec:	37fd                	addiw	a5,a5,-1
    80000eee:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ef2:	60a6                	ld	ra,72(sp)
    80000ef4:	6406                	ld	s0,64(sp)
    80000ef6:	74e2                	ld	s1,56(sp)
    80000ef8:	7942                	ld	s2,48(sp)
    80000efa:	79a2                	ld	s3,40(sp)
    80000efc:	7a02                	ld	s4,32(sp)
    80000efe:	6ae2                	ld	s5,24(sp)
    80000f00:	6b42                	ld	s6,16(sp)
    80000f02:	6ba2                	ld	s7,8(sp)
    80000f04:	6161                	addi	sp,sp,80
    80000f06:	8082                	ret
    80000f08:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000f0c:	9742                	add	a4,a4,a6
      --max;
    80000f0e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000f12:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000f16:	04e58663          	beq	a1,a4,80000f62 <copyinstr+0xa2>
{
    80000f1a:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000f1c:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000f20:	85a6                	mv	a1,s1
    80000f22:	8552                	mv	a0,s4
    80000f24:	fffff097          	auipc	ra,0xfffff
    80000f28:	73c080e7          	jalr	1852(ra) # 80000660 <walkaddr>
    if(pa0 == 0)
    80000f2c:	cd0d                	beqz	a0,80000f66 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000f2e:	417486b3          	sub	a3,s1,s7
    80000f32:	96ce                	add	a3,a3,s3
    if(n > max)
    80000f34:	00d97363          	bgeu	s2,a3,80000f3a <copyinstr+0x7a>
    80000f38:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000f3a:	955e                	add	a0,a0,s7
    80000f3c:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000f3e:	c695                	beqz	a3,80000f6a <copyinstr+0xaa>
    80000f40:	87da                	mv	a5,s6
    80000f42:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000f44:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000f48:	96da                	add	a3,a3,s6
    80000f4a:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000f4c:	00f60733          	add	a4,a2,a5
    80000f50:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd5dc0>
    80000f54:	db49                	beqz	a4,80000ee6 <copyinstr+0x26>
        *dst = *p;
    80000f56:	00e78023          	sb	a4,0(a5)
      dst++;
    80000f5a:	0785                	addi	a5,a5,1
    while(n > 0){
    80000f5c:	fed797e3          	bne	a5,a3,80000f4a <copyinstr+0x8a>
    80000f60:	b765                	j	80000f08 <copyinstr+0x48>
    80000f62:	4781                	li	a5,0
    80000f64:	b761                	j	80000eec <copyinstr+0x2c>
      return -1;
    80000f66:	557d                	li	a0,-1
    80000f68:	b769                	j	80000ef2 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000f6a:	6b85                	lui	s7,0x1
    80000f6c:	9ba6                	add	s7,s7,s1
    80000f6e:	87da                	mv	a5,s6
    80000f70:	b76d                	j	80000f1a <copyinstr+0x5a>
  int got_null = 0;
    80000f72:	4781                	li	a5,0
  if(got_null){
    80000f74:	37fd                	addiw	a5,a5,-1
    80000f76:	0007851b          	sext.w	a0,a5
}
    80000f7a:	8082                	ret

0000000080000f7c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000f7c:	7139                	addi	sp,sp,-64
    80000f7e:	fc06                	sd	ra,56(sp)
    80000f80:	f822                	sd	s0,48(sp)
    80000f82:	f426                	sd	s1,40(sp)
    80000f84:	f04a                	sd	s2,32(sp)
    80000f86:	ec4e                	sd	s3,24(sp)
    80000f88:	e852                	sd	s4,16(sp)
    80000f8a:	e456                	sd	s5,8(sp)
    80000f8c:	e05a                	sd	s6,0(sp)
    80000f8e:	0080                	addi	s0,sp,64
    80000f90:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f92:	0000b497          	auipc	s1,0xb
    80000f96:	50e48493          	addi	s1,s1,1294 # 8000c4a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f9a:	8b26                	mv	s6,s1
    80000f9c:	04fa5937          	lui	s2,0x4fa5
    80000fa0:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000fa4:	0932                	slli	s2,s2,0xc
    80000fa6:	fa590913          	addi	s2,s2,-91
    80000faa:	0932                	slli	s2,s2,0xc
    80000fac:	fa590913          	addi	s2,s2,-91
    80000fb0:	0932                	slli	s2,s2,0xc
    80000fb2:	fa590913          	addi	s2,s2,-91
    80000fb6:	040009b7          	lui	s3,0x4000
    80000fba:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000fbc:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fbe:	00011a97          	auipc	s5,0x11
    80000fc2:	ee2a8a93          	addi	s5,s5,-286 # 80011ea0 <tickslock>
    char *pa = kalloc();
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	208080e7          	jalr	520(ra) # 800001ce <kalloc>
    80000fce:	862a                	mv	a2,a0
    if(pa == 0)
    80000fd0:	c121                	beqz	a0,80001010 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000fd2:	416485b3          	sub	a1,s1,s6
    80000fd6:	858d                	srai	a1,a1,0x3
    80000fd8:	032585b3          	mul	a1,a1,s2
    80000fdc:	2585                	addiw	a1,a1,1
    80000fde:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000fe2:	4719                	li	a4,6
    80000fe4:	6685                	lui	a3,0x1
    80000fe6:	40b985b3          	sub	a1,s3,a1
    80000fea:	8552                	mv	a0,s4
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	740080e7          	jalr	1856(ra) # 8000072c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff4:	16848493          	addi	s1,s1,360
    80000ff8:	fd5497e3          	bne	s1,s5,80000fc6 <proc_mapstacks+0x4a>
  }
}
    80000ffc:	70e2                	ld	ra,56(sp)
    80000ffe:	7442                	ld	s0,48(sp)
    80001000:	74a2                	ld	s1,40(sp)
    80001002:	7902                	ld	s2,32(sp)
    80001004:	69e2                	ld	s3,24(sp)
    80001006:	6a42                	ld	s4,16(sp)
    80001008:	6aa2                	ld	s5,8(sp)
    8000100a:	6b02                	ld	s6,0(sp)
    8000100c:	6121                	addi	sp,sp,64
    8000100e:	8082                	ret
      panic("kalloc");
    80001010:	00007517          	auipc	a0,0x7
    80001014:	14050513          	addi	a0,a0,320 # 80008150 <etext+0x150>
    80001018:	00005097          	auipc	ra,0x5
    8000101c:	fa4080e7          	jalr	-92(ra) # 80005fbc <panic>

0000000080001020 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80001020:	7139                	addi	sp,sp,-64
    80001022:	fc06                	sd	ra,56(sp)
    80001024:	f822                	sd	s0,48(sp)
    80001026:	f426                	sd	s1,40(sp)
    80001028:	f04a                	sd	s2,32(sp)
    8000102a:	ec4e                	sd	s3,24(sp)
    8000102c:	e852                	sd	s4,16(sp)
    8000102e:	e456                	sd	s5,8(sp)
    80001030:	e05a                	sd	s6,0(sp)
    80001032:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001034:	00007597          	auipc	a1,0x7
    80001038:	12458593          	addi	a1,a1,292 # 80008158 <etext+0x158>
    8000103c:	0000b517          	auipc	a0,0xb
    80001040:	03450513          	addi	a0,a0,52 # 8000c070 <pid_lock>
    80001044:	00005097          	auipc	ra,0x5
    80001048:	462080e7          	jalr	1122(ra) # 800064a6 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000104c:	00007597          	auipc	a1,0x7
    80001050:	11458593          	addi	a1,a1,276 # 80008160 <etext+0x160>
    80001054:	0000b517          	auipc	a0,0xb
    80001058:	03450513          	addi	a0,a0,52 # 8000c088 <wait_lock>
    8000105c:	00005097          	auipc	ra,0x5
    80001060:	44a080e7          	jalr	1098(ra) # 800064a6 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001064:	0000b497          	auipc	s1,0xb
    80001068:	43c48493          	addi	s1,s1,1084 # 8000c4a0 <proc>
      initlock(&p->lock, "proc");
    8000106c:	00007b17          	auipc	s6,0x7
    80001070:	104b0b13          	addi	s6,s6,260 # 80008170 <etext+0x170>
      p->kstack = KSTACK((int) (p - proc));
    80001074:	8aa6                	mv	s5,s1
    80001076:	04fa5937          	lui	s2,0x4fa5
    8000107a:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000107e:	0932                	slli	s2,s2,0xc
    80001080:	fa590913          	addi	s2,s2,-91
    80001084:	0932                	slli	s2,s2,0xc
    80001086:	fa590913          	addi	s2,s2,-91
    8000108a:	0932                	slli	s2,s2,0xc
    8000108c:	fa590913          	addi	s2,s2,-91
    80001090:	040009b7          	lui	s3,0x4000
    80001094:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001096:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001098:	00011a17          	auipc	s4,0x11
    8000109c:	e08a0a13          	addi	s4,s4,-504 # 80011ea0 <tickslock>
      initlock(&p->lock, "proc");
    800010a0:	85da                	mv	a1,s6
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	402080e7          	jalr	1026(ra) # 800064a6 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    800010ac:	415487b3          	sub	a5,s1,s5
    800010b0:	878d                	srai	a5,a5,0x3
    800010b2:	032787b3          	mul	a5,a5,s2
    800010b6:	2785                	addiw	a5,a5,1
    800010b8:	00d7979b          	slliw	a5,a5,0xd
    800010bc:	40f987b3          	sub	a5,s3,a5
    800010c0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c2:	16848493          	addi	s1,s1,360
    800010c6:	fd449de3          	bne	s1,s4,800010a0 <procinit+0x80>
  }
}
    800010ca:	70e2                	ld	ra,56(sp)
    800010cc:	7442                	ld	s0,48(sp)
    800010ce:	74a2                	ld	s1,40(sp)
    800010d0:	7902                	ld	s2,32(sp)
    800010d2:	69e2                	ld	s3,24(sp)
    800010d4:	6a42                	ld	s4,16(sp)
    800010d6:	6aa2                	ld	s5,8(sp)
    800010d8:	6b02                	ld	s6,0(sp)
    800010da:	6121                	addi	sp,sp,64
    800010dc:	8082                	ret

00000000800010de <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800010de:	1141                	addi	sp,sp,-16
    800010e0:	e422                	sd	s0,8(sp)
    800010e2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800010e4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800010e6:	2501                	sext.w	a0,a0
    800010e8:	6422                	ld	s0,8(sp)
    800010ea:	0141                	addi	sp,sp,16
    800010ec:	8082                	ret

00000000800010ee <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    800010ee:	1141                	addi	sp,sp,-16
    800010f0:	e422                	sd	s0,8(sp)
    800010f2:	0800                	addi	s0,sp,16
    800010f4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800010f6:	2781                	sext.w	a5,a5
    800010f8:	079e                	slli	a5,a5,0x7
  return c;
}
    800010fa:	0000b517          	auipc	a0,0xb
    800010fe:	fa650513          	addi	a0,a0,-90 # 8000c0a0 <cpus>
    80001102:	953e                	add	a0,a0,a5
    80001104:	6422                	ld	s0,8(sp)
    80001106:	0141                	addi	sp,sp,16
    80001108:	8082                	ret

000000008000110a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000110a:	1101                	addi	sp,sp,-32
    8000110c:	ec06                	sd	ra,24(sp)
    8000110e:	e822                	sd	s0,16(sp)
    80001110:	e426                	sd	s1,8(sp)
    80001112:	1000                	addi	s0,sp,32
  push_off();
    80001114:	00005097          	auipc	ra,0x5
    80001118:	3d6080e7          	jalr	982(ra) # 800064ea <push_off>
    8000111c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000111e:	2781                	sext.w	a5,a5
    80001120:	079e                	slli	a5,a5,0x7
    80001122:	0000b717          	auipc	a4,0xb
    80001126:	f4e70713          	addi	a4,a4,-178 # 8000c070 <pid_lock>
    8000112a:	97ba                	add	a5,a5,a4
    8000112c:	7b84                	ld	s1,48(a5)
  pop_off();
    8000112e:	00005097          	auipc	ra,0x5
    80001132:	45c080e7          	jalr	1116(ra) # 8000658a <pop_off>
  return p;
}
    80001136:	8526                	mv	a0,s1
    80001138:	60e2                	ld	ra,24(sp)
    8000113a:	6442                	ld	s0,16(sp)
    8000113c:	64a2                	ld	s1,8(sp)
    8000113e:	6105                	addi	sp,sp,32
    80001140:	8082                	ret

0000000080001142 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001142:	1141                	addi	sp,sp,-16
    80001144:	e406                	sd	ra,8(sp)
    80001146:	e022                	sd	s0,0(sp)
    80001148:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	fc0080e7          	jalr	-64(ra) # 8000110a <myproc>
    80001152:	00005097          	auipc	ra,0x5
    80001156:	498080e7          	jalr	1176(ra) # 800065ea <release>

  if (first) {
    8000115a:	0000a797          	auipc	a5,0xa
    8000115e:	0067a783          	lw	a5,6(a5) # 8000b160 <first.1>
    80001162:	eb89                	bnez	a5,80001174 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001164:	00001097          	auipc	ra,0x1
    80001168:	c16080e7          	jalr	-1002(ra) # 80001d7a <usertrapret>
}
    8000116c:	60a2                	ld	ra,8(sp)
    8000116e:	6402                	ld	s0,0(sp)
    80001170:	0141                	addi	sp,sp,16
    80001172:	8082                	ret
    first = 0;
    80001174:	0000a797          	auipc	a5,0xa
    80001178:	fe07a623          	sw	zero,-20(a5) # 8000b160 <first.1>
    fsinit(ROOTDEV);
    8000117c:	4505                	li	a0,1
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	a5a080e7          	jalr	-1446(ra) # 80002bd8 <fsinit>
    80001186:	bff9                	j	80001164 <forkret+0x22>

0000000080001188 <allocpid>:
allocpid() {
    80001188:	1101                	addi	sp,sp,-32
    8000118a:	ec06                	sd	ra,24(sp)
    8000118c:	e822                	sd	s0,16(sp)
    8000118e:	e426                	sd	s1,8(sp)
    80001190:	e04a                	sd	s2,0(sp)
    80001192:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001194:	0000b917          	auipc	s2,0xb
    80001198:	edc90913          	addi	s2,s2,-292 # 8000c070 <pid_lock>
    8000119c:	854a                	mv	a0,s2
    8000119e:	00005097          	auipc	ra,0x5
    800011a2:	398080e7          	jalr	920(ra) # 80006536 <acquire>
  pid = nextpid;
    800011a6:	0000a797          	auipc	a5,0xa
    800011aa:	fbe78793          	addi	a5,a5,-66 # 8000b164 <nextpid>
    800011ae:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011b0:	0014871b          	addiw	a4,s1,1
    800011b4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011b6:	854a                	mv	a0,s2
    800011b8:	00005097          	auipc	ra,0x5
    800011bc:	432080e7          	jalr	1074(ra) # 800065ea <release>
}
    800011c0:	8526                	mv	a0,s1
    800011c2:	60e2                	ld	ra,24(sp)
    800011c4:	6442                	ld	s0,16(sp)
    800011c6:	64a2                	ld	s1,8(sp)
    800011c8:	6902                	ld	s2,0(sp)
    800011ca:	6105                	addi	sp,sp,32
    800011cc:	8082                	ret

00000000800011ce <proc_pagetable>:
{
    800011ce:	1101                	addi	sp,sp,-32
    800011d0:	ec06                	sd	ra,24(sp)
    800011d2:	e822                	sd	s0,16(sp)
    800011d4:	e426                	sd	s1,8(sp)
    800011d6:	e04a                	sd	s2,0(sp)
    800011d8:	1000                	addi	s0,sp,32
    800011da:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800011dc:	fffff097          	auipc	ra,0xfffff
    800011e0:	74a080e7          	jalr	1866(ra) # 80000926 <uvmcreate>
    800011e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011e6:	c121                	beqz	a0,80001226 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800011e8:	4729                	li	a4,10
    800011ea:	00006697          	auipc	a3,0x6
    800011ee:	e1668693          	addi	a3,a3,-490 # 80007000 <_trampoline>
    800011f2:	6605                	lui	a2,0x1
    800011f4:	040005b7          	lui	a1,0x4000
    800011f8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011fa:	05b2                	slli	a1,a1,0xc
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	4a6080e7          	jalr	1190(ra) # 800006a2 <mappages>
    80001204:	02054863          	bltz	a0,80001234 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001208:	4719                	li	a4,6
    8000120a:	05893683          	ld	a3,88(s2)
    8000120e:	6605                	lui	a2,0x1
    80001210:	020005b7          	lui	a1,0x2000
    80001214:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001216:	05b6                	slli	a1,a1,0xd
    80001218:	8526                	mv	a0,s1
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	488080e7          	jalr	1160(ra) # 800006a2 <mappages>
    80001222:	02054163          	bltz	a0,80001244 <proc_pagetable+0x76>
}
    80001226:	8526                	mv	a0,s1
    80001228:	60e2                	ld	ra,24(sp)
    8000122a:	6442                	ld	s0,16(sp)
    8000122c:	64a2                	ld	s1,8(sp)
    8000122e:	6902                	ld	s2,0(sp)
    80001230:	6105                	addi	sp,sp,32
    80001232:	8082                	ret
    uvmfree(pagetable, 0);
    80001234:	4581                	li	a1,0
    80001236:	8526                	mv	a0,s1
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	8f4080e7          	jalr	-1804(ra) # 80000b2c <uvmfree>
    return 0;
    80001240:	4481                	li	s1,0
    80001242:	b7d5                	j	80001226 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001244:	4681                	li	a3,0
    80001246:	4605                	li	a2,1
    80001248:	040005b7          	lui	a1,0x4000
    8000124c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000124e:	05b2                	slli	a1,a1,0xc
    80001250:	8526                	mv	a0,s1
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	600080e7          	jalr	1536(ra) # 80000852 <uvmunmap>
    uvmfree(pagetable, 0);
    8000125a:	4581                	li	a1,0
    8000125c:	8526                	mv	a0,s1
    8000125e:	00000097          	auipc	ra,0x0
    80001262:	8ce080e7          	jalr	-1842(ra) # 80000b2c <uvmfree>
    return 0;
    80001266:	4481                	li	s1,0
    80001268:	bf7d                	j	80001226 <proc_pagetable+0x58>

000000008000126a <proc_freepagetable>:
{
    8000126a:	1101                	addi	sp,sp,-32
    8000126c:	ec06                	sd	ra,24(sp)
    8000126e:	e822                	sd	s0,16(sp)
    80001270:	e426                	sd	s1,8(sp)
    80001272:	e04a                	sd	s2,0(sp)
    80001274:	1000                	addi	s0,sp,32
    80001276:	84aa                	mv	s1,a0
    80001278:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000127a:	4681                	li	a3,0
    8000127c:	4605                	li	a2,1
    8000127e:	040005b7          	lui	a1,0x4000
    80001282:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001284:	05b2                	slli	a1,a1,0xc
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	5cc080e7          	jalr	1484(ra) # 80000852 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000128e:	4681                	li	a3,0
    80001290:	4605                	li	a2,1
    80001292:	020005b7          	lui	a1,0x2000
    80001296:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001298:	05b6                	slli	a1,a1,0xd
    8000129a:	8526                	mv	a0,s1
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	5b6080e7          	jalr	1462(ra) # 80000852 <uvmunmap>
  uvmfree(pagetable, sz);
    800012a4:	85ca                	mv	a1,s2
    800012a6:	8526                	mv	a0,s1
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	884080e7          	jalr	-1916(ra) # 80000b2c <uvmfree>
}
    800012b0:	60e2                	ld	ra,24(sp)
    800012b2:	6442                	ld	s0,16(sp)
    800012b4:	64a2                	ld	s1,8(sp)
    800012b6:	6902                	ld	s2,0(sp)
    800012b8:	6105                	addi	sp,sp,32
    800012ba:	8082                	ret

00000000800012bc <freeproc>:
{
    800012bc:	1101                	addi	sp,sp,-32
    800012be:	ec06                	sd	ra,24(sp)
    800012c0:	e822                	sd	s0,16(sp)
    800012c2:	e426                	sd	s1,8(sp)
    800012c4:	1000                	addi	s0,sp,32
    800012c6:	84aa                	mv	s1,a0
  if(p->trapframe)
    800012c8:	6d28                	ld	a0,88(a0)
    800012ca:	c509                	beqz	a0,800012d4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	d50080e7          	jalr	-688(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800012d4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800012d8:	68a8                	ld	a0,80(s1)
    800012da:	c511                	beqz	a0,800012e6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800012dc:	64ac                	ld	a1,72(s1)
    800012de:	00000097          	auipc	ra,0x0
    800012e2:	f8c080e7          	jalr	-116(ra) # 8000126a <proc_freepagetable>
  p->pagetable = 0;
    800012e6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800012ea:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800012ee:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800012f2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800012f6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800012fa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800012fe:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001302:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001306:	0004ac23          	sw	zero,24(s1)
}
    8000130a:	60e2                	ld	ra,24(sp)
    8000130c:	6442                	ld	s0,16(sp)
    8000130e:	64a2                	ld	s1,8(sp)
    80001310:	6105                	addi	sp,sp,32
    80001312:	8082                	ret

0000000080001314 <allocproc>:
{
    80001314:	1101                	addi	sp,sp,-32
    80001316:	ec06                	sd	ra,24(sp)
    80001318:	e822                	sd	s0,16(sp)
    8000131a:	e426                	sd	s1,8(sp)
    8000131c:	e04a                	sd	s2,0(sp)
    8000131e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001320:	0000b497          	auipc	s1,0xb
    80001324:	18048493          	addi	s1,s1,384 # 8000c4a0 <proc>
    80001328:	00011917          	auipc	s2,0x11
    8000132c:	b7890913          	addi	s2,s2,-1160 # 80011ea0 <tickslock>
    acquire(&p->lock);
    80001330:	8526                	mv	a0,s1
    80001332:	00005097          	auipc	ra,0x5
    80001336:	204080e7          	jalr	516(ra) # 80006536 <acquire>
    if(p->state == UNUSED) {
    8000133a:	4c9c                	lw	a5,24(s1)
    8000133c:	cf81                	beqz	a5,80001354 <allocproc+0x40>
      release(&p->lock);
    8000133e:	8526                	mv	a0,s1
    80001340:	00005097          	auipc	ra,0x5
    80001344:	2aa080e7          	jalr	682(ra) # 800065ea <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001348:	16848493          	addi	s1,s1,360
    8000134c:	ff2492e3          	bne	s1,s2,80001330 <allocproc+0x1c>
  return 0;
    80001350:	4481                	li	s1,0
    80001352:	a889                	j	800013a4 <allocproc+0x90>
  p->pid = allocpid();
    80001354:	00000097          	auipc	ra,0x0
    80001358:	e34080e7          	jalr	-460(ra) # 80001188 <allocpid>
    8000135c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000135e:	4785                	li	a5,1
    80001360:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001362:	fffff097          	auipc	ra,0xfffff
    80001366:	e6c080e7          	jalr	-404(ra) # 800001ce <kalloc>
    8000136a:	892a                	mv	s2,a0
    8000136c:	eca8                	sd	a0,88(s1)
    8000136e:	c131                	beqz	a0,800013b2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001370:	8526                	mv	a0,s1
    80001372:	00000097          	auipc	ra,0x0
    80001376:	e5c080e7          	jalr	-420(ra) # 800011ce <proc_pagetable>
    8000137a:	892a                	mv	s2,a0
    8000137c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000137e:	c531                	beqz	a0,800013ca <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001380:	07000613          	li	a2,112
    80001384:	4581                	li	a1,0
    80001386:	06048513          	addi	a0,s1,96
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	f58080e7          	jalr	-168(ra) # 800002e2 <memset>
  p->context.ra = (uint64)forkret;
    80001392:	00000797          	auipc	a5,0x0
    80001396:	db078793          	addi	a5,a5,-592 # 80001142 <forkret>
    8000139a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000139c:	60bc                	ld	a5,64(s1)
    8000139e:	6705                	lui	a4,0x1
    800013a0:	97ba                	add	a5,a5,a4
    800013a2:	f4bc                	sd	a5,104(s1)
}
    800013a4:	8526                	mv	a0,s1
    800013a6:	60e2                	ld	ra,24(sp)
    800013a8:	6442                	ld	s0,16(sp)
    800013aa:	64a2                	ld	s1,8(sp)
    800013ac:	6902                	ld	s2,0(sp)
    800013ae:	6105                	addi	sp,sp,32
    800013b0:	8082                	ret
    freeproc(p);
    800013b2:	8526                	mv	a0,s1
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	f08080e7          	jalr	-248(ra) # 800012bc <freeproc>
    release(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	22c080e7          	jalr	556(ra) # 800065ea <release>
    return 0;
    800013c6:	84ca                	mv	s1,s2
    800013c8:	bff1                	j	800013a4 <allocproc+0x90>
    freeproc(p);
    800013ca:	8526                	mv	a0,s1
    800013cc:	00000097          	auipc	ra,0x0
    800013d0:	ef0080e7          	jalr	-272(ra) # 800012bc <freeproc>
    release(&p->lock);
    800013d4:	8526                	mv	a0,s1
    800013d6:	00005097          	auipc	ra,0x5
    800013da:	214080e7          	jalr	532(ra) # 800065ea <release>
    return 0;
    800013de:	84ca                	mv	s1,s2
    800013e0:	b7d1                	j	800013a4 <allocproc+0x90>

00000000800013e2 <userinit>:
{
    800013e2:	1101                	addi	sp,sp,-32
    800013e4:	ec06                	sd	ra,24(sp)
    800013e6:	e822                	sd	s0,16(sp)
    800013e8:	e426                	sd	s1,8(sp)
    800013ea:	1000                	addi	s0,sp,32
  p = allocproc();
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	f28080e7          	jalr	-216(ra) # 80001314 <allocproc>
    800013f4:	84aa                	mv	s1,a0
  initproc = p;
    800013f6:	0000b797          	auipc	a5,0xb
    800013fa:	c0a7bd23          	sd	a0,-998(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800013fe:	03400613          	li	a2,52
    80001402:	0000a597          	auipc	a1,0xa
    80001406:	d6e58593          	addi	a1,a1,-658 # 8000b170 <initcode>
    8000140a:	6928                	ld	a0,80(a0)
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	548080e7          	jalr	1352(ra) # 80000954 <uvminit>
  p->sz = PGSIZE;
    80001414:	6785                	lui	a5,0x1
    80001416:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001418:	6cb8                	ld	a4,88(s1)
    8000141a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000141e:	6cb8                	ld	a4,88(s1)
    80001420:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001422:	4641                	li	a2,16
    80001424:	00007597          	auipc	a1,0x7
    80001428:	d5458593          	addi	a1,a1,-684 # 80008178 <etext+0x178>
    8000142c:	15848513          	addi	a0,s1,344
    80001430:	fffff097          	auipc	ra,0xfffff
    80001434:	ff4080e7          	jalr	-12(ra) # 80000424 <safestrcpy>
  p->cwd = namei("/");
    80001438:	00007517          	auipc	a0,0x7
    8000143c:	d5050513          	addi	a0,a0,-688 # 80008188 <etext+0x188>
    80001440:	00002097          	auipc	ra,0x2
    80001444:	1de080e7          	jalr	478(ra) # 8000361e <namei>
    80001448:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000144c:	478d                	li	a5,3
    8000144e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001450:	8526                	mv	a0,s1
    80001452:	00005097          	auipc	ra,0x5
    80001456:	198080e7          	jalr	408(ra) # 800065ea <release>
}
    8000145a:	60e2                	ld	ra,24(sp)
    8000145c:	6442                	ld	s0,16(sp)
    8000145e:	64a2                	ld	s1,8(sp)
    80001460:	6105                	addi	sp,sp,32
    80001462:	8082                	ret

0000000080001464 <growproc>:
{
    80001464:	1101                	addi	sp,sp,-32
    80001466:	ec06                	sd	ra,24(sp)
    80001468:	e822                	sd	s0,16(sp)
    8000146a:	e426                	sd	s1,8(sp)
    8000146c:	e04a                	sd	s2,0(sp)
    8000146e:	1000                	addi	s0,sp,32
    80001470:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001472:	00000097          	auipc	ra,0x0
    80001476:	c98080e7          	jalr	-872(ra) # 8000110a <myproc>
    8000147a:	892a                	mv	s2,a0
  sz = p->sz;
    8000147c:	652c                	ld	a1,72(a0)
    8000147e:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001482:	00904f63          	bgtz	s1,800014a0 <growproc+0x3c>
  } else if(n < 0){
    80001486:	0204cd63          	bltz	s1,800014c0 <growproc+0x5c>
  p->sz = sz;
    8000148a:	1782                	slli	a5,a5,0x20
    8000148c:	9381                	srli	a5,a5,0x20
    8000148e:	04f93423          	sd	a5,72(s2)
  return 0;
    80001492:	4501                	li	a0,0
}
    80001494:	60e2                	ld	ra,24(sp)
    80001496:	6442                	ld	s0,16(sp)
    80001498:	64a2                	ld	s1,8(sp)
    8000149a:	6902                	ld	s2,0(sp)
    8000149c:	6105                	addi	sp,sp,32
    8000149e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800014a0:	00f4863b          	addw	a2,s1,a5
    800014a4:	1602                	slli	a2,a2,0x20
    800014a6:	9201                	srli	a2,a2,0x20
    800014a8:	1582                	slli	a1,a1,0x20
    800014aa:	9181                	srli	a1,a1,0x20
    800014ac:	6928                	ld	a0,80(a0)
    800014ae:	fffff097          	auipc	ra,0xfffff
    800014b2:	560080e7          	jalr	1376(ra) # 80000a0e <uvmalloc>
    800014b6:	0005079b          	sext.w	a5,a0
    800014ba:	fbe1                	bnez	a5,8000148a <growproc+0x26>
      return -1;
    800014bc:	557d                	li	a0,-1
    800014be:	bfd9                	j	80001494 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800014c0:	00f4863b          	addw	a2,s1,a5
    800014c4:	1602                	slli	a2,a2,0x20
    800014c6:	9201                	srli	a2,a2,0x20
    800014c8:	1582                	slli	a1,a1,0x20
    800014ca:	9181                	srli	a1,a1,0x20
    800014cc:	6928                	ld	a0,80(a0)
    800014ce:	fffff097          	auipc	ra,0xfffff
    800014d2:	4f8080e7          	jalr	1272(ra) # 800009c6 <uvmdealloc>
    800014d6:	0005079b          	sext.w	a5,a0
    800014da:	bf45                	j	8000148a <growproc+0x26>

00000000800014dc <fork>:
{
    800014dc:	7139                	addi	sp,sp,-64
    800014de:	fc06                	sd	ra,56(sp)
    800014e0:	f822                	sd	s0,48(sp)
    800014e2:	f04a                	sd	s2,32(sp)
    800014e4:	e456                	sd	s5,8(sp)
    800014e6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	c22080e7          	jalr	-990(ra) # 8000110a <myproc>
    800014f0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800014f2:	00000097          	auipc	ra,0x0
    800014f6:	e22080e7          	jalr	-478(ra) # 80001314 <allocproc>
    800014fa:	12050063          	beqz	a0,8000161a <fork+0x13e>
    800014fe:	e852                	sd	s4,16(sp)
    80001500:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001502:	048ab603          	ld	a2,72(s5)
    80001506:	692c                	ld	a1,80(a0)
    80001508:	050ab503          	ld	a0,80(s5)
    8000150c:	fffff097          	auipc	ra,0xfffff
    80001510:	65a080e7          	jalr	1626(ra) # 80000b66 <uvmcopy>
    80001514:	04054a63          	bltz	a0,80001568 <fork+0x8c>
    80001518:	f426                	sd	s1,40(sp)
    8000151a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000151c:	048ab783          	ld	a5,72(s5)
    80001520:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001524:	058ab683          	ld	a3,88(s5)
    80001528:	87b6                	mv	a5,a3
    8000152a:	058a3703          	ld	a4,88(s4)
    8000152e:	12068693          	addi	a3,a3,288
    80001532:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001536:	6788                	ld	a0,8(a5)
    80001538:	6b8c                	ld	a1,16(a5)
    8000153a:	6f90                	ld	a2,24(a5)
    8000153c:	01073023          	sd	a6,0(a4)
    80001540:	e708                	sd	a0,8(a4)
    80001542:	eb0c                	sd	a1,16(a4)
    80001544:	ef10                	sd	a2,24(a4)
    80001546:	02078793          	addi	a5,a5,32
    8000154a:	02070713          	addi	a4,a4,32
    8000154e:	fed792e3          	bne	a5,a3,80001532 <fork+0x56>
  np->trapframe->a0 = 0;
    80001552:	058a3783          	ld	a5,88(s4)
    80001556:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000155a:	0d0a8493          	addi	s1,s5,208
    8000155e:	0d0a0913          	addi	s2,s4,208
    80001562:	150a8993          	addi	s3,s5,336
    80001566:	a015                	j	8000158a <fork+0xae>
    freeproc(np);
    80001568:	8552                	mv	a0,s4
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	d52080e7          	jalr	-686(ra) # 800012bc <freeproc>
    release(&np->lock);
    80001572:	8552                	mv	a0,s4
    80001574:	00005097          	auipc	ra,0x5
    80001578:	076080e7          	jalr	118(ra) # 800065ea <release>
    return -1;
    8000157c:	597d                	li	s2,-1
    8000157e:	6a42                	ld	s4,16(sp)
    80001580:	a071                	j	8000160c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001582:	04a1                	addi	s1,s1,8
    80001584:	0921                	addi	s2,s2,8
    80001586:	01348b63          	beq	s1,s3,8000159c <fork+0xc0>
    if(p->ofile[i])
    8000158a:	6088                	ld	a0,0(s1)
    8000158c:	d97d                	beqz	a0,80001582 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000158e:	00002097          	auipc	ra,0x2
    80001592:	708080e7          	jalr	1800(ra) # 80003c96 <filedup>
    80001596:	00a93023          	sd	a0,0(s2)
    8000159a:	b7e5                	j	80001582 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000159c:	150ab503          	ld	a0,336(s5)
    800015a0:	00002097          	auipc	ra,0x2
    800015a4:	86e080e7          	jalr	-1938(ra) # 80002e0e <idup>
    800015a8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800015ac:	4641                	li	a2,16
    800015ae:	158a8593          	addi	a1,s5,344
    800015b2:	158a0513          	addi	a0,s4,344
    800015b6:	fffff097          	auipc	ra,0xfffff
    800015ba:	e6e080e7          	jalr	-402(ra) # 80000424 <safestrcpy>
  pid = np->pid;
    800015be:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800015c2:	8552                	mv	a0,s4
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	026080e7          	jalr	38(ra) # 800065ea <release>
  acquire(&wait_lock);
    800015cc:	0000b497          	auipc	s1,0xb
    800015d0:	abc48493          	addi	s1,s1,-1348 # 8000c088 <wait_lock>
    800015d4:	8526                	mv	a0,s1
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	f60080e7          	jalr	-160(ra) # 80006536 <acquire>
  np->parent = p;
    800015de:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	006080e7          	jalr	6(ra) # 800065ea <release>
  acquire(&np->lock);
    800015ec:	8552                	mv	a0,s4
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	f48080e7          	jalr	-184(ra) # 80006536 <acquire>
  np->state = RUNNABLE;
    800015f6:	478d                	li	a5,3
    800015f8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800015fc:	8552                	mv	a0,s4
    800015fe:	00005097          	auipc	ra,0x5
    80001602:	fec080e7          	jalr	-20(ra) # 800065ea <release>
  return pid;
    80001606:	74a2                	ld	s1,40(sp)
    80001608:	69e2                	ld	s3,24(sp)
    8000160a:	6a42                	ld	s4,16(sp)
}
    8000160c:	854a                	mv	a0,s2
    8000160e:	70e2                	ld	ra,56(sp)
    80001610:	7442                	ld	s0,48(sp)
    80001612:	7902                	ld	s2,32(sp)
    80001614:	6aa2                	ld	s5,8(sp)
    80001616:	6121                	addi	sp,sp,64
    80001618:	8082                	ret
    return -1;
    8000161a:	597d                	li	s2,-1
    8000161c:	bfc5                	j	8000160c <fork+0x130>

000000008000161e <scheduler>:
{
    8000161e:	7139                	addi	sp,sp,-64
    80001620:	fc06                	sd	ra,56(sp)
    80001622:	f822                	sd	s0,48(sp)
    80001624:	f426                	sd	s1,40(sp)
    80001626:	f04a                	sd	s2,32(sp)
    80001628:	ec4e                	sd	s3,24(sp)
    8000162a:	e852                	sd	s4,16(sp)
    8000162c:	e456                	sd	s5,8(sp)
    8000162e:	e05a                	sd	s6,0(sp)
    80001630:	0080                	addi	s0,sp,64
    80001632:	8792                	mv	a5,tp
  int id = r_tp();
    80001634:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001636:	00779a93          	slli	s5,a5,0x7
    8000163a:	0000b717          	auipc	a4,0xb
    8000163e:	a3670713          	addi	a4,a4,-1482 # 8000c070 <pid_lock>
    80001642:	9756                	add	a4,a4,s5
    80001644:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001648:	0000b717          	auipc	a4,0xb
    8000164c:	a6070713          	addi	a4,a4,-1440 # 8000c0a8 <cpus+0x8>
    80001650:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001652:	498d                	li	s3,3
        p->state = RUNNING;
    80001654:	4b11                	li	s6,4
        c->proc = p;
    80001656:	079e                	slli	a5,a5,0x7
    80001658:	0000ba17          	auipc	s4,0xb
    8000165c:	a18a0a13          	addi	s4,s4,-1512 # 8000c070 <pid_lock>
    80001660:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001662:	00011917          	auipc	s2,0x11
    80001666:	83e90913          	addi	s2,s2,-1986 # 80011ea0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000166a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000166e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001672:	10079073          	csrw	sstatus,a5
    80001676:	0000b497          	auipc	s1,0xb
    8000167a:	e2a48493          	addi	s1,s1,-470 # 8000c4a0 <proc>
    8000167e:	a811                	j	80001692 <scheduler+0x74>
      release(&p->lock);
    80001680:	8526                	mv	a0,s1
    80001682:	00005097          	auipc	ra,0x5
    80001686:	f68080e7          	jalr	-152(ra) # 800065ea <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000168a:	16848493          	addi	s1,s1,360
    8000168e:	fd248ee3          	beq	s1,s2,8000166a <scheduler+0x4c>
      acquire(&p->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	ea2080e7          	jalr	-350(ra) # 80006536 <acquire>
      if(p->state == RUNNABLE) {
    8000169c:	4c9c                	lw	a5,24(s1)
    8000169e:	ff3791e3          	bne	a5,s3,80001680 <scheduler+0x62>
        p->state = RUNNING;
    800016a2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800016a6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800016aa:	06048593          	addi	a1,s1,96
    800016ae:	8556                	mv	a0,s5
    800016b0:	00000097          	auipc	ra,0x0
    800016b4:	620080e7          	jalr	1568(ra) # 80001cd0 <swtch>
        c->proc = 0;
    800016b8:	020a3823          	sd	zero,48(s4)
    800016bc:	b7d1                	j	80001680 <scheduler+0x62>

00000000800016be <sched>:
{
    800016be:	7179                	addi	sp,sp,-48
    800016c0:	f406                	sd	ra,40(sp)
    800016c2:	f022                	sd	s0,32(sp)
    800016c4:	ec26                	sd	s1,24(sp)
    800016c6:	e84a                	sd	s2,16(sp)
    800016c8:	e44e                	sd	s3,8(sp)
    800016ca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016cc:	00000097          	auipc	ra,0x0
    800016d0:	a3e080e7          	jalr	-1474(ra) # 8000110a <myproc>
    800016d4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800016d6:	00005097          	auipc	ra,0x5
    800016da:	de6080e7          	jalr	-538(ra) # 800064bc <holding>
    800016de:	c93d                	beqz	a0,80001754 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016e0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800016e2:	2781                	sext.w	a5,a5
    800016e4:	079e                	slli	a5,a5,0x7
    800016e6:	0000b717          	auipc	a4,0xb
    800016ea:	98a70713          	addi	a4,a4,-1654 # 8000c070 <pid_lock>
    800016ee:	97ba                	add	a5,a5,a4
    800016f0:	0a87a703          	lw	a4,168(a5)
    800016f4:	4785                	li	a5,1
    800016f6:	06f71763          	bne	a4,a5,80001764 <sched+0xa6>
  if(p->state == RUNNING)
    800016fa:	4c98                	lw	a4,24(s1)
    800016fc:	4791                	li	a5,4
    800016fe:	06f70b63          	beq	a4,a5,80001774 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001702:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001706:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001708:	efb5                	bnez	a5,80001784 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000170a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000170c:	0000b917          	auipc	s2,0xb
    80001710:	96490913          	addi	s2,s2,-1692 # 8000c070 <pid_lock>
    80001714:	2781                	sext.w	a5,a5
    80001716:	079e                	slli	a5,a5,0x7
    80001718:	97ca                	add	a5,a5,s2
    8000171a:	0ac7a983          	lw	s3,172(a5)
    8000171e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001720:	2781                	sext.w	a5,a5
    80001722:	079e                	slli	a5,a5,0x7
    80001724:	0000b597          	auipc	a1,0xb
    80001728:	98458593          	addi	a1,a1,-1660 # 8000c0a8 <cpus+0x8>
    8000172c:	95be                	add	a1,a1,a5
    8000172e:	06048513          	addi	a0,s1,96
    80001732:	00000097          	auipc	ra,0x0
    80001736:	59e080e7          	jalr	1438(ra) # 80001cd0 <swtch>
    8000173a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000173c:	2781                	sext.w	a5,a5
    8000173e:	079e                	slli	a5,a5,0x7
    80001740:	993e                	add	s2,s2,a5
    80001742:	0b392623          	sw	s3,172(s2)
}
    80001746:	70a2                	ld	ra,40(sp)
    80001748:	7402                	ld	s0,32(sp)
    8000174a:	64e2                	ld	s1,24(sp)
    8000174c:	6942                	ld	s2,16(sp)
    8000174e:	69a2                	ld	s3,8(sp)
    80001750:	6145                	addi	sp,sp,48
    80001752:	8082                	ret
    panic("sched p->lock");
    80001754:	00007517          	auipc	a0,0x7
    80001758:	a3c50513          	addi	a0,a0,-1476 # 80008190 <etext+0x190>
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	860080e7          	jalr	-1952(ra) # 80005fbc <panic>
    panic("sched locks");
    80001764:	00007517          	auipc	a0,0x7
    80001768:	a3c50513          	addi	a0,a0,-1476 # 800081a0 <etext+0x1a0>
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	850080e7          	jalr	-1968(ra) # 80005fbc <panic>
    panic("sched running");
    80001774:	00007517          	auipc	a0,0x7
    80001778:	a3c50513          	addi	a0,a0,-1476 # 800081b0 <etext+0x1b0>
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	840080e7          	jalr	-1984(ra) # 80005fbc <panic>
    panic("sched interruptible");
    80001784:	00007517          	auipc	a0,0x7
    80001788:	a3c50513          	addi	a0,a0,-1476 # 800081c0 <etext+0x1c0>
    8000178c:	00005097          	auipc	ra,0x5
    80001790:	830080e7          	jalr	-2000(ra) # 80005fbc <panic>

0000000080001794 <yield>:
{
    80001794:	1101                	addi	sp,sp,-32
    80001796:	ec06                	sd	ra,24(sp)
    80001798:	e822                	sd	s0,16(sp)
    8000179a:	e426                	sd	s1,8(sp)
    8000179c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000179e:	00000097          	auipc	ra,0x0
    800017a2:	96c080e7          	jalr	-1684(ra) # 8000110a <myproc>
    800017a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	d8e080e7          	jalr	-626(ra) # 80006536 <acquire>
  p->state = RUNNABLE;
    800017b0:	478d                	li	a5,3
    800017b2:	cc9c                	sw	a5,24(s1)
  sched();
    800017b4:	00000097          	auipc	ra,0x0
    800017b8:	f0a080e7          	jalr	-246(ra) # 800016be <sched>
  release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	e2c080e7          	jalr	-468(ra) # 800065ea <release>
}
    800017c6:	60e2                	ld	ra,24(sp)
    800017c8:	6442                	ld	s0,16(sp)
    800017ca:	64a2                	ld	s1,8(sp)
    800017cc:	6105                	addi	sp,sp,32
    800017ce:	8082                	ret

00000000800017d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800017d0:	7179                	addi	sp,sp,-48
    800017d2:	f406                	sd	ra,40(sp)
    800017d4:	f022                	sd	s0,32(sp)
    800017d6:	ec26                	sd	s1,24(sp)
    800017d8:	e84a                	sd	s2,16(sp)
    800017da:	e44e                	sd	s3,8(sp)
    800017dc:	1800                	addi	s0,sp,48
    800017de:	89aa                	mv	s3,a0
    800017e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800017e2:	00000097          	auipc	ra,0x0
    800017e6:	928080e7          	jalr	-1752(ra) # 8000110a <myproc>
    800017ea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	d4a080e7          	jalr	-694(ra) # 80006536 <acquire>
  release(lk);
    800017f4:	854a                	mv	a0,s2
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	df4080e7          	jalr	-524(ra) # 800065ea <release>

  // Go to sleep.
  p->chan = chan;
    800017fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001802:	4789                	li	a5,2
    80001804:	cc9c                	sw	a5,24(s1)

  sched();
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	eb8080e7          	jalr	-328(ra) # 800016be <sched>

  // Tidy up.
  p->chan = 0;
    8000180e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001812:	8526                	mv	a0,s1
    80001814:	00005097          	auipc	ra,0x5
    80001818:	dd6080e7          	jalr	-554(ra) # 800065ea <release>
  acquire(lk);
    8000181c:	854a                	mv	a0,s2
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	d18080e7          	jalr	-744(ra) # 80006536 <acquire>
}
    80001826:	70a2                	ld	ra,40(sp)
    80001828:	7402                	ld	s0,32(sp)
    8000182a:	64e2                	ld	s1,24(sp)
    8000182c:	6942                	ld	s2,16(sp)
    8000182e:	69a2                	ld	s3,8(sp)
    80001830:	6145                	addi	sp,sp,48
    80001832:	8082                	ret

0000000080001834 <wait>:
{
    80001834:	715d                	addi	sp,sp,-80
    80001836:	e486                	sd	ra,72(sp)
    80001838:	e0a2                	sd	s0,64(sp)
    8000183a:	fc26                	sd	s1,56(sp)
    8000183c:	f84a                	sd	s2,48(sp)
    8000183e:	f44e                	sd	s3,40(sp)
    80001840:	f052                	sd	s4,32(sp)
    80001842:	ec56                	sd	s5,24(sp)
    80001844:	e85a                	sd	s6,16(sp)
    80001846:	e45e                	sd	s7,8(sp)
    80001848:	e062                	sd	s8,0(sp)
    8000184a:	0880                	addi	s0,sp,80
    8000184c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	8bc080e7          	jalr	-1860(ra) # 8000110a <myproc>
    80001856:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001858:	0000b517          	auipc	a0,0xb
    8000185c:	83050513          	addi	a0,a0,-2000 # 8000c088 <wait_lock>
    80001860:	00005097          	auipc	ra,0x5
    80001864:	cd6080e7          	jalr	-810(ra) # 80006536 <acquire>
    havekids = 0;
    80001868:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000186a:	4a15                	li	s4,5
        havekids = 1;
    8000186c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000186e:	00010997          	auipc	s3,0x10
    80001872:	63298993          	addi	s3,s3,1586 # 80011ea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001876:	0000bc17          	auipc	s8,0xb
    8000187a:	812c0c13          	addi	s8,s8,-2030 # 8000c088 <wait_lock>
    8000187e:	a87d                	j	8000193c <wait+0x108>
          pid = np->pid;
    80001880:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001884:	000b0e63          	beqz	s6,800018a0 <wait+0x6c>
    80001888:	4691                	li	a3,4
    8000188a:	02c48613          	addi	a2,s1,44
    8000188e:	85da                	mv	a1,s6
    80001890:	05093503          	ld	a0,80(s2)
    80001894:	fffff097          	auipc	ra,0xfffff
    80001898:	3ce080e7          	jalr	974(ra) # 80000c62 <copyout>
    8000189c:	04054163          	bltz	a0,800018de <wait+0xaa>
          freeproc(np);
    800018a0:	8526                	mv	a0,s1
    800018a2:	00000097          	auipc	ra,0x0
    800018a6:	a1a080e7          	jalr	-1510(ra) # 800012bc <freeproc>
          release(&np->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	d3e080e7          	jalr	-706(ra) # 800065ea <release>
          release(&wait_lock);
    800018b4:	0000a517          	auipc	a0,0xa
    800018b8:	7d450513          	addi	a0,a0,2004 # 8000c088 <wait_lock>
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	d2e080e7          	jalr	-722(ra) # 800065ea <release>
}
    800018c4:	854e                	mv	a0,s3
    800018c6:	60a6                	ld	ra,72(sp)
    800018c8:	6406                	ld	s0,64(sp)
    800018ca:	74e2                	ld	s1,56(sp)
    800018cc:	7942                	ld	s2,48(sp)
    800018ce:	79a2                	ld	s3,40(sp)
    800018d0:	7a02                	ld	s4,32(sp)
    800018d2:	6ae2                	ld	s5,24(sp)
    800018d4:	6b42                	ld	s6,16(sp)
    800018d6:	6ba2                	ld	s7,8(sp)
    800018d8:	6c02                	ld	s8,0(sp)
    800018da:	6161                	addi	sp,sp,80
    800018dc:	8082                	ret
            release(&np->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	d0a080e7          	jalr	-758(ra) # 800065ea <release>
            release(&wait_lock);
    800018e8:	0000a517          	auipc	a0,0xa
    800018ec:	7a050513          	addi	a0,a0,1952 # 8000c088 <wait_lock>
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	cfa080e7          	jalr	-774(ra) # 800065ea <release>
            return -1;
    800018f8:	59fd                	li	s3,-1
    800018fa:	b7e9                	j	800018c4 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800018fc:	16848493          	addi	s1,s1,360
    80001900:	03348463          	beq	s1,s3,80001928 <wait+0xf4>
      if(np->parent == p){
    80001904:	7c9c                	ld	a5,56(s1)
    80001906:	ff279be3          	bne	a5,s2,800018fc <wait+0xc8>
        acquire(&np->lock);
    8000190a:	8526                	mv	a0,s1
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	c2a080e7          	jalr	-982(ra) # 80006536 <acquire>
        if(np->state == ZOMBIE){
    80001914:	4c9c                	lw	a5,24(s1)
    80001916:	f74785e3          	beq	a5,s4,80001880 <wait+0x4c>
        release(&np->lock);
    8000191a:	8526                	mv	a0,s1
    8000191c:	00005097          	auipc	ra,0x5
    80001920:	cce080e7          	jalr	-818(ra) # 800065ea <release>
        havekids = 1;
    80001924:	8756                	mv	a4,s5
    80001926:	bfd9                	j	800018fc <wait+0xc8>
    if(!havekids || p->killed){
    80001928:	c305                	beqz	a4,80001948 <wait+0x114>
    8000192a:	02892783          	lw	a5,40(s2)
    8000192e:	ef89                	bnez	a5,80001948 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001930:	85e2                	mv	a1,s8
    80001932:	854a                	mv	a0,s2
    80001934:	00000097          	auipc	ra,0x0
    80001938:	e9c080e7          	jalr	-356(ra) # 800017d0 <sleep>
    havekids = 0;
    8000193c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000193e:	0000b497          	auipc	s1,0xb
    80001942:	b6248493          	addi	s1,s1,-1182 # 8000c4a0 <proc>
    80001946:	bf7d                	j	80001904 <wait+0xd0>
      release(&wait_lock);
    80001948:	0000a517          	auipc	a0,0xa
    8000194c:	74050513          	addi	a0,a0,1856 # 8000c088 <wait_lock>
    80001950:	00005097          	auipc	ra,0x5
    80001954:	c9a080e7          	jalr	-870(ra) # 800065ea <release>
      return -1;
    80001958:	59fd                	li	s3,-1
    8000195a:	b7ad                	j	800018c4 <wait+0x90>

000000008000195c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000195c:	7139                	addi	sp,sp,-64
    8000195e:	fc06                	sd	ra,56(sp)
    80001960:	f822                	sd	s0,48(sp)
    80001962:	f426                	sd	s1,40(sp)
    80001964:	f04a                	sd	s2,32(sp)
    80001966:	ec4e                	sd	s3,24(sp)
    80001968:	e852                	sd	s4,16(sp)
    8000196a:	e456                	sd	s5,8(sp)
    8000196c:	0080                	addi	s0,sp,64
    8000196e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001970:	0000b497          	auipc	s1,0xb
    80001974:	b3048493          	addi	s1,s1,-1232 # 8000c4a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001978:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000197a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000197c:	00010917          	auipc	s2,0x10
    80001980:	52490913          	addi	s2,s2,1316 # 80011ea0 <tickslock>
    80001984:	a811                	j	80001998 <wakeup+0x3c>
      }
      release(&p->lock);
    80001986:	8526                	mv	a0,s1
    80001988:	00005097          	auipc	ra,0x5
    8000198c:	c62080e7          	jalr	-926(ra) # 800065ea <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001990:	16848493          	addi	s1,s1,360
    80001994:	03248663          	beq	s1,s2,800019c0 <wakeup+0x64>
    if(p != myproc()){
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	772080e7          	jalr	1906(ra) # 8000110a <myproc>
    800019a0:	fea488e3          	beq	s1,a0,80001990 <wakeup+0x34>
      acquire(&p->lock);
    800019a4:	8526                	mv	a0,s1
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	b90080e7          	jalr	-1136(ra) # 80006536 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800019ae:	4c9c                	lw	a5,24(s1)
    800019b0:	fd379be3          	bne	a5,s3,80001986 <wakeup+0x2a>
    800019b4:	709c                	ld	a5,32(s1)
    800019b6:	fd4798e3          	bne	a5,s4,80001986 <wakeup+0x2a>
        p->state = RUNNABLE;
    800019ba:	0154ac23          	sw	s5,24(s1)
    800019be:	b7e1                	j	80001986 <wakeup+0x2a>
    }
  }
}
    800019c0:	70e2                	ld	ra,56(sp)
    800019c2:	7442                	ld	s0,48(sp)
    800019c4:	74a2                	ld	s1,40(sp)
    800019c6:	7902                	ld	s2,32(sp)
    800019c8:	69e2                	ld	s3,24(sp)
    800019ca:	6a42                	ld	s4,16(sp)
    800019cc:	6aa2                	ld	s5,8(sp)
    800019ce:	6121                	addi	sp,sp,64
    800019d0:	8082                	ret

00000000800019d2 <reparent>:
{
    800019d2:	7179                	addi	sp,sp,-48
    800019d4:	f406                	sd	ra,40(sp)
    800019d6:	f022                	sd	s0,32(sp)
    800019d8:	ec26                	sd	s1,24(sp)
    800019da:	e84a                	sd	s2,16(sp)
    800019dc:	e44e                	sd	s3,8(sp)
    800019de:	e052                	sd	s4,0(sp)
    800019e0:	1800                	addi	s0,sp,48
    800019e2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019e4:	0000b497          	auipc	s1,0xb
    800019e8:	abc48493          	addi	s1,s1,-1348 # 8000c4a0 <proc>
      pp->parent = initproc;
    800019ec:	0000aa17          	auipc	s4,0xa
    800019f0:	624a0a13          	addi	s4,s4,1572 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019f4:	00010997          	auipc	s3,0x10
    800019f8:	4ac98993          	addi	s3,s3,1196 # 80011ea0 <tickslock>
    800019fc:	a029                	j	80001a06 <reparent+0x34>
    800019fe:	16848493          	addi	s1,s1,360
    80001a02:	01348d63          	beq	s1,s3,80001a1c <reparent+0x4a>
    if(pp->parent == p){
    80001a06:	7c9c                	ld	a5,56(s1)
    80001a08:	ff279be3          	bne	a5,s2,800019fe <reparent+0x2c>
      pp->parent = initproc;
    80001a0c:	000a3503          	ld	a0,0(s4)
    80001a10:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001a12:	00000097          	auipc	ra,0x0
    80001a16:	f4a080e7          	jalr	-182(ra) # 8000195c <wakeup>
    80001a1a:	b7d5                	j	800019fe <reparent+0x2c>
}
    80001a1c:	70a2                	ld	ra,40(sp)
    80001a1e:	7402                	ld	s0,32(sp)
    80001a20:	64e2                	ld	s1,24(sp)
    80001a22:	6942                	ld	s2,16(sp)
    80001a24:	69a2                	ld	s3,8(sp)
    80001a26:	6a02                	ld	s4,0(sp)
    80001a28:	6145                	addi	sp,sp,48
    80001a2a:	8082                	ret

0000000080001a2c <exit>:
{
    80001a2c:	7179                	addi	sp,sp,-48
    80001a2e:	f406                	sd	ra,40(sp)
    80001a30:	f022                	sd	s0,32(sp)
    80001a32:	ec26                	sd	s1,24(sp)
    80001a34:	e84a                	sd	s2,16(sp)
    80001a36:	e44e                	sd	s3,8(sp)
    80001a38:	e052                	sd	s4,0(sp)
    80001a3a:	1800                	addi	s0,sp,48
    80001a3c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	6cc080e7          	jalr	1740(ra) # 8000110a <myproc>
    80001a46:	89aa                	mv	s3,a0
  if(p == initproc)
    80001a48:	0000a797          	auipc	a5,0xa
    80001a4c:	5c87b783          	ld	a5,1480(a5) # 8000c010 <initproc>
    80001a50:	0d050493          	addi	s1,a0,208
    80001a54:	15050913          	addi	s2,a0,336
    80001a58:	02a79363          	bne	a5,a0,80001a7e <exit+0x52>
    panic("init exiting");
    80001a5c:	00006517          	auipc	a0,0x6
    80001a60:	77c50513          	addi	a0,a0,1916 # 800081d8 <etext+0x1d8>
    80001a64:	00004097          	auipc	ra,0x4
    80001a68:	558080e7          	jalr	1368(ra) # 80005fbc <panic>
      fileclose(f);
    80001a6c:	00002097          	auipc	ra,0x2
    80001a70:	27c080e7          	jalr	636(ra) # 80003ce8 <fileclose>
      p->ofile[fd] = 0;
    80001a74:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001a78:	04a1                	addi	s1,s1,8
    80001a7a:	01248563          	beq	s1,s2,80001a84 <exit+0x58>
    if(p->ofile[fd]){
    80001a7e:	6088                	ld	a0,0(s1)
    80001a80:	f575                	bnez	a0,80001a6c <exit+0x40>
    80001a82:	bfdd                	j	80001a78 <exit+0x4c>
  begin_op();
    80001a84:	00002097          	auipc	ra,0x2
    80001a88:	d9a080e7          	jalr	-614(ra) # 8000381e <begin_op>
  iput(p->cwd);
    80001a8c:	1509b503          	ld	a0,336(s3)
    80001a90:	00001097          	auipc	ra,0x1
    80001a94:	57a080e7          	jalr	1402(ra) # 8000300a <iput>
  end_op();
    80001a98:	00002097          	auipc	ra,0x2
    80001a9c:	e00080e7          	jalr	-512(ra) # 80003898 <end_op>
  p->cwd = 0;
    80001aa0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001aa4:	0000a497          	auipc	s1,0xa
    80001aa8:	5e448493          	addi	s1,s1,1508 # 8000c088 <wait_lock>
    80001aac:	8526                	mv	a0,s1
    80001aae:	00005097          	auipc	ra,0x5
    80001ab2:	a88080e7          	jalr	-1400(ra) # 80006536 <acquire>
  reparent(p);
    80001ab6:	854e                	mv	a0,s3
    80001ab8:	00000097          	auipc	ra,0x0
    80001abc:	f1a080e7          	jalr	-230(ra) # 800019d2 <reparent>
  wakeup(p->parent);
    80001ac0:	0389b503          	ld	a0,56(s3)
    80001ac4:	00000097          	auipc	ra,0x0
    80001ac8:	e98080e7          	jalr	-360(ra) # 8000195c <wakeup>
  acquire(&p->lock);
    80001acc:	854e                	mv	a0,s3
    80001ace:	00005097          	auipc	ra,0x5
    80001ad2:	a68080e7          	jalr	-1432(ra) # 80006536 <acquire>
  p->xstate = status;
    80001ad6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001ada:	4795                	li	a5,5
    80001adc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	00005097          	auipc	ra,0x5
    80001ae6:	b08080e7          	jalr	-1272(ra) # 800065ea <release>
  sched();
    80001aea:	00000097          	auipc	ra,0x0
    80001aee:	bd4080e7          	jalr	-1068(ra) # 800016be <sched>
  panic("zombie exit");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	6f650513          	addi	a0,a0,1782 # 800081e8 <etext+0x1e8>
    80001afa:	00004097          	auipc	ra,0x4
    80001afe:	4c2080e7          	jalr	1218(ra) # 80005fbc <panic>

0000000080001b02 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001b02:	7179                	addi	sp,sp,-48
    80001b04:	f406                	sd	ra,40(sp)
    80001b06:	f022                	sd	s0,32(sp)
    80001b08:	ec26                	sd	s1,24(sp)
    80001b0a:	e84a                	sd	s2,16(sp)
    80001b0c:	e44e                	sd	s3,8(sp)
    80001b0e:	1800                	addi	s0,sp,48
    80001b10:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001b12:	0000b497          	auipc	s1,0xb
    80001b16:	98e48493          	addi	s1,s1,-1650 # 8000c4a0 <proc>
    80001b1a:	00010997          	auipc	s3,0x10
    80001b1e:	38698993          	addi	s3,s3,902 # 80011ea0 <tickslock>
    acquire(&p->lock);
    80001b22:	8526                	mv	a0,s1
    80001b24:	00005097          	auipc	ra,0x5
    80001b28:	a12080e7          	jalr	-1518(ra) # 80006536 <acquire>
    if(p->pid == pid){
    80001b2c:	589c                	lw	a5,48(s1)
    80001b2e:	01278d63          	beq	a5,s2,80001b48 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001b32:	8526                	mv	a0,s1
    80001b34:	00005097          	auipc	ra,0x5
    80001b38:	ab6080e7          	jalr	-1354(ra) # 800065ea <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b3c:	16848493          	addi	s1,s1,360
    80001b40:	ff3491e3          	bne	s1,s3,80001b22 <kill+0x20>
  }
  return -1;
    80001b44:	557d                	li	a0,-1
    80001b46:	a829                	j	80001b60 <kill+0x5e>
      p->killed = 1;
    80001b48:	4785                	li	a5,1
    80001b4a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001b4c:	4c98                	lw	a4,24(s1)
    80001b4e:	4789                	li	a5,2
    80001b50:	00f70f63          	beq	a4,a5,80001b6e <kill+0x6c>
      release(&p->lock);
    80001b54:	8526                	mv	a0,s1
    80001b56:	00005097          	auipc	ra,0x5
    80001b5a:	a94080e7          	jalr	-1388(ra) # 800065ea <release>
      return 0;
    80001b5e:	4501                	li	a0,0
}
    80001b60:	70a2                	ld	ra,40(sp)
    80001b62:	7402                	ld	s0,32(sp)
    80001b64:	64e2                	ld	s1,24(sp)
    80001b66:	6942                	ld	s2,16(sp)
    80001b68:	69a2                	ld	s3,8(sp)
    80001b6a:	6145                	addi	sp,sp,48
    80001b6c:	8082                	ret
        p->state = RUNNABLE;
    80001b6e:	478d                	li	a5,3
    80001b70:	cc9c                	sw	a5,24(s1)
    80001b72:	b7cd                	j	80001b54 <kill+0x52>

0000000080001b74 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b74:	7179                	addi	sp,sp,-48
    80001b76:	f406                	sd	ra,40(sp)
    80001b78:	f022                	sd	s0,32(sp)
    80001b7a:	ec26                	sd	s1,24(sp)
    80001b7c:	e84a                	sd	s2,16(sp)
    80001b7e:	e44e                	sd	s3,8(sp)
    80001b80:	e052                	sd	s4,0(sp)
    80001b82:	1800                	addi	s0,sp,48
    80001b84:	84aa                	mv	s1,a0
    80001b86:	892e                	mv	s2,a1
    80001b88:	89b2                	mv	s3,a2
    80001b8a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	57e080e7          	jalr	1406(ra) # 8000110a <myproc>
  if(user_dst){
    80001b94:	c08d                	beqz	s1,80001bb6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b96:	86d2                	mv	a3,s4
    80001b98:	864e                	mv	a2,s3
    80001b9a:	85ca                	mv	a1,s2
    80001b9c:	6928                	ld	a0,80(a0)
    80001b9e:	fffff097          	auipc	ra,0xfffff
    80001ba2:	0c4080e7          	jalr	196(ra) # 80000c62 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ba6:	70a2                	ld	ra,40(sp)
    80001ba8:	7402                	ld	s0,32(sp)
    80001baa:	64e2                	ld	s1,24(sp)
    80001bac:	6942                	ld	s2,16(sp)
    80001bae:	69a2                	ld	s3,8(sp)
    80001bb0:	6a02                	ld	s4,0(sp)
    80001bb2:	6145                	addi	sp,sp,48
    80001bb4:	8082                	ret
    memmove((char *)dst, src, len);
    80001bb6:	000a061b          	sext.w	a2,s4
    80001bba:	85ce                	mv	a1,s3
    80001bbc:	854a                	mv	a0,s2
    80001bbe:	ffffe097          	auipc	ra,0xffffe
    80001bc2:	780080e7          	jalr	1920(ra) # 8000033e <memmove>
    return 0;
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	bff9                	j	80001ba6 <either_copyout+0x32>

0000000080001bca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001bca:	7179                	addi	sp,sp,-48
    80001bcc:	f406                	sd	ra,40(sp)
    80001bce:	f022                	sd	s0,32(sp)
    80001bd0:	ec26                	sd	s1,24(sp)
    80001bd2:	e84a                	sd	s2,16(sp)
    80001bd4:	e44e                	sd	s3,8(sp)
    80001bd6:	e052                	sd	s4,0(sp)
    80001bd8:	1800                	addi	s0,sp,48
    80001bda:	892a                	mv	s2,a0
    80001bdc:	84ae                	mv	s1,a1
    80001bde:	89b2                	mv	s3,a2
    80001be0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	528080e7          	jalr	1320(ra) # 8000110a <myproc>
  if(user_src){
    80001bea:	c08d                	beqz	s1,80001c0c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bec:	86d2                	mv	a3,s4
    80001bee:	864e                	mv	a2,s3
    80001bf0:	85ca                	mv	a1,s2
    80001bf2:	6928                	ld	a0,80(a0)
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	23e080e7          	jalr	574(ra) # 80000e32 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bfc:	70a2                	ld	ra,40(sp)
    80001bfe:	7402                	ld	s0,32(sp)
    80001c00:	64e2                	ld	s1,24(sp)
    80001c02:	6942                	ld	s2,16(sp)
    80001c04:	69a2                	ld	s3,8(sp)
    80001c06:	6a02                	ld	s4,0(sp)
    80001c08:	6145                	addi	sp,sp,48
    80001c0a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001c0c:	000a061b          	sext.w	a2,s4
    80001c10:	85ce                	mv	a1,s3
    80001c12:	854a                	mv	a0,s2
    80001c14:	ffffe097          	auipc	ra,0xffffe
    80001c18:	72a080e7          	jalr	1834(ra) # 8000033e <memmove>
    return 0;
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	bff9                	j	80001bfc <either_copyin+0x32>

0000000080001c20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001c20:	715d                	addi	sp,sp,-80
    80001c22:	e486                	sd	ra,72(sp)
    80001c24:	e0a2                	sd	s0,64(sp)
    80001c26:	fc26                	sd	s1,56(sp)
    80001c28:	f84a                	sd	s2,48(sp)
    80001c2a:	f44e                	sd	s3,40(sp)
    80001c2c:	f052                	sd	s4,32(sp)
    80001c2e:	ec56                	sd	s5,24(sp)
    80001c30:	e85a                	sd	s6,16(sp)
    80001c32:	e45e                	sd	s7,8(sp)
    80001c34:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c36:	00006517          	auipc	a0,0x6
    80001c3a:	3ea50513          	addi	a0,a0,1002 # 80008020 <etext+0x20>
    80001c3e:	00004097          	auipc	ra,0x4
    80001c42:	3c8080e7          	jalr	968(ra) # 80006006 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c46:	0000b497          	auipc	s1,0xb
    80001c4a:	9b248493          	addi	s1,s1,-1614 # 8000c5f8 <proc+0x158>
    80001c4e:	00010917          	auipc	s2,0x10
    80001c52:	3aa90913          	addi	s2,s2,938 # 80011ff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c56:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c58:	00006997          	auipc	s3,0x6
    80001c5c:	5a098993          	addi	s3,s3,1440 # 800081f8 <etext+0x1f8>
    printf("%d %s %s", p->pid, state, p->name);
    80001c60:	00006a97          	auipc	s5,0x6
    80001c64:	5a0a8a93          	addi	s5,s5,1440 # 80008200 <etext+0x200>
    printf("\n");
    80001c68:	00006a17          	auipc	s4,0x6
    80001c6c:	3b8a0a13          	addi	s4,s4,952 # 80008020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c70:	00007b97          	auipc	s7,0x7
    80001c74:	a88b8b93          	addi	s7,s7,-1400 # 800086f8 <states.0>
    80001c78:	a00d                	j	80001c9a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c7a:	ed86a583          	lw	a1,-296(a3)
    80001c7e:	8556                	mv	a0,s5
    80001c80:	00004097          	auipc	ra,0x4
    80001c84:	386080e7          	jalr	902(ra) # 80006006 <printf>
    printf("\n");
    80001c88:	8552                	mv	a0,s4
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	37c080e7          	jalr	892(ra) # 80006006 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c92:	16848493          	addi	s1,s1,360
    80001c96:	03248263          	beq	s1,s2,80001cba <procdump+0x9a>
    if(p->state == UNUSED)
    80001c9a:	86a6                	mv	a3,s1
    80001c9c:	ec04a783          	lw	a5,-320(s1)
    80001ca0:	dbed                	beqz	a5,80001c92 <procdump+0x72>
      state = "???";
    80001ca2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ca4:	fcfb6be3          	bltu	s6,a5,80001c7a <procdump+0x5a>
    80001ca8:	02079713          	slli	a4,a5,0x20
    80001cac:	01d75793          	srli	a5,a4,0x1d
    80001cb0:	97de                	add	a5,a5,s7
    80001cb2:	6390                	ld	a2,0(a5)
    80001cb4:	f279                	bnez	a2,80001c7a <procdump+0x5a>
      state = "???";
    80001cb6:	864e                	mv	a2,s3
    80001cb8:	b7c9                	j	80001c7a <procdump+0x5a>
  }
}
    80001cba:	60a6                	ld	ra,72(sp)
    80001cbc:	6406                	ld	s0,64(sp)
    80001cbe:	74e2                	ld	s1,56(sp)
    80001cc0:	7942                	ld	s2,48(sp)
    80001cc2:	79a2                	ld	s3,40(sp)
    80001cc4:	7a02                	ld	s4,32(sp)
    80001cc6:	6ae2                	ld	s5,24(sp)
    80001cc8:	6b42                	ld	s6,16(sp)
    80001cca:	6ba2                	ld	s7,8(sp)
    80001ccc:	6161                	addi	sp,sp,80
    80001cce:	8082                	ret

0000000080001cd0 <swtch>:
    80001cd0:	00153023          	sd	ra,0(a0)
    80001cd4:	00253423          	sd	sp,8(a0)
    80001cd8:	e900                	sd	s0,16(a0)
    80001cda:	ed04                	sd	s1,24(a0)
    80001cdc:	03253023          	sd	s2,32(a0)
    80001ce0:	03353423          	sd	s3,40(a0)
    80001ce4:	03453823          	sd	s4,48(a0)
    80001ce8:	03553c23          	sd	s5,56(a0)
    80001cec:	05653023          	sd	s6,64(a0)
    80001cf0:	05753423          	sd	s7,72(a0)
    80001cf4:	05853823          	sd	s8,80(a0)
    80001cf8:	05953c23          	sd	s9,88(a0)
    80001cfc:	07a53023          	sd	s10,96(a0)
    80001d00:	07b53423          	sd	s11,104(a0)
    80001d04:	0005b083          	ld	ra,0(a1)
    80001d08:	0085b103          	ld	sp,8(a1)
    80001d0c:	6980                	ld	s0,16(a1)
    80001d0e:	6d84                	ld	s1,24(a1)
    80001d10:	0205b903          	ld	s2,32(a1)
    80001d14:	0285b983          	ld	s3,40(a1)
    80001d18:	0305ba03          	ld	s4,48(a1)
    80001d1c:	0385ba83          	ld	s5,56(a1)
    80001d20:	0405bb03          	ld	s6,64(a1)
    80001d24:	0485bb83          	ld	s7,72(a1)
    80001d28:	0505bc03          	ld	s8,80(a1)
    80001d2c:	0585bc83          	ld	s9,88(a1)
    80001d30:	0605bd03          	ld	s10,96(a1)
    80001d34:	0685bd83          	ld	s11,104(a1)
    80001d38:	8082                	ret

0000000080001d3a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d3a:	1141                	addi	sp,sp,-16
    80001d3c:	e406                	sd	ra,8(sp)
    80001d3e:	e022                	sd	s0,0(sp)
    80001d40:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d42:	00006597          	auipc	a1,0x6
    80001d46:	4f658593          	addi	a1,a1,1270 # 80008238 <etext+0x238>
    80001d4a:	00010517          	auipc	a0,0x10
    80001d4e:	15650513          	addi	a0,a0,342 # 80011ea0 <tickslock>
    80001d52:	00004097          	auipc	ra,0x4
    80001d56:	754080e7          	jalr	1876(ra) # 800064a6 <initlock>
}
    80001d5a:	60a2                	ld	ra,8(sp)
    80001d5c:	6402                	ld	s0,0(sp)
    80001d5e:	0141                	addi	sp,sp,16
    80001d60:	8082                	ret

0000000080001d62 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d62:	1141                	addi	sp,sp,-16
    80001d64:	e422                	sd	s0,8(sp)
    80001d66:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d68:	00003797          	auipc	a5,0x3
    80001d6c:	66878793          	addi	a5,a5,1640 # 800053d0 <kernelvec>
    80001d70:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d74:	6422                	ld	s0,8(sp)
    80001d76:	0141                	addi	sp,sp,16
    80001d78:	8082                	ret

0000000080001d7a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d7a:	1141                	addi	sp,sp,-16
    80001d7c:	e406                	sd	ra,8(sp)
    80001d7e:	e022                	sd	s0,0(sp)
    80001d80:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	388080e7          	jalr	904(ra) # 8000110a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d90:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d94:	00005697          	auipc	a3,0x5
    80001d98:	26c68693          	addi	a3,a3,620 # 80007000 <_trampoline>
    80001d9c:	00005717          	auipc	a4,0x5
    80001da0:	26470713          	addi	a4,a4,612 # 80007000 <_trampoline>
    80001da4:	8f15                	sub	a4,a4,a3
    80001da6:	040007b7          	lui	a5,0x4000
    80001daa:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001dac:	07b2                	slli	a5,a5,0xc
    80001dae:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001db0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001db4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001db6:	18002673          	csrr	a2,satp
    80001dba:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001dbc:	6d30                	ld	a2,88(a0)
    80001dbe:	6138                	ld	a4,64(a0)
    80001dc0:	6585                	lui	a1,0x1
    80001dc2:	972e                	add	a4,a4,a1
    80001dc4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001dc6:	6d38                	ld	a4,88(a0)
    80001dc8:	00000617          	auipc	a2,0x0
    80001dcc:	14060613          	addi	a2,a2,320 # 80001f08 <usertrap>
    80001dd0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001dd2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dd4:	8612                	mv	a2,tp
    80001dd6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ddc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001de0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001de8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dea:	6f18                	ld	a4,24(a4)
    80001dec:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001df0:	692c                	ld	a1,80(a0)
    80001df2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001df4:	00005717          	auipc	a4,0x5
    80001df8:	29c70713          	addi	a4,a4,668 # 80007090 <userret>
    80001dfc:	8f15                	sub	a4,a4,a3
    80001dfe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001e00:	577d                	li	a4,-1
    80001e02:	177e                	slli	a4,a4,0x3f
    80001e04:	8dd9                	or	a1,a1,a4
    80001e06:	02000537          	lui	a0,0x2000
    80001e0a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001e0c:	0536                	slli	a0,a0,0xd
    80001e0e:	9782                	jalr	a5
}
    80001e10:	60a2                	ld	ra,8(sp)
    80001e12:	6402                	ld	s0,0(sp)
    80001e14:	0141                	addi	sp,sp,16
    80001e16:	8082                	ret

0000000080001e18 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e22:	00010497          	auipc	s1,0x10
    80001e26:	07e48493          	addi	s1,s1,126 # 80011ea0 <tickslock>
    80001e2a:	8526                	mv	a0,s1
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	70a080e7          	jalr	1802(ra) # 80006536 <acquire>
  ticks++;
    80001e34:	0000a517          	auipc	a0,0xa
    80001e38:	1e450513          	addi	a0,a0,484 # 8000c018 <ticks>
    80001e3c:	411c                	lw	a5,0(a0)
    80001e3e:	2785                	addiw	a5,a5,1
    80001e40:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e42:	00000097          	auipc	ra,0x0
    80001e46:	b1a080e7          	jalr	-1254(ra) # 8000195c <wakeup>
  release(&tickslock);
    80001e4a:	8526                	mv	a0,s1
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	79e080e7          	jalr	1950(ra) # 800065ea <release>
}
    80001e54:	60e2                	ld	ra,24(sp)
    80001e56:	6442                	ld	s0,16(sp)
    80001e58:	64a2                	ld	s1,8(sp)
    80001e5a:	6105                	addi	sp,sp,32
    80001e5c:	8082                	ret

0000000080001e5e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e62:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e64:	0a07d163          	bgez	a5,80001f06 <devintr+0xa8>
{
    80001e68:	1101                	addi	sp,sp,-32
    80001e6a:	ec06                	sd	ra,24(sp)
    80001e6c:	e822                	sd	s0,16(sp)
    80001e6e:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e70:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e74:	46a5                	li	a3,9
    80001e76:	00d70c63          	beq	a4,a3,80001e8e <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001e7a:	577d                	li	a4,-1
    80001e7c:	177e                	slli	a4,a4,0x3f
    80001e7e:	0705                	addi	a4,a4,1
    return 0;
    80001e80:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e82:	06e78163          	beq	a5,a4,80001ee4 <devintr+0x86>
  }
}
    80001e86:	60e2                	ld	ra,24(sp)
    80001e88:	6442                	ld	s0,16(sp)
    80001e8a:	6105                	addi	sp,sp,32
    80001e8c:	8082                	ret
    80001e8e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001e90:	00003097          	auipc	ra,0x3
    80001e94:	64c080e7          	jalr	1612(ra) # 800054dc <plic_claim>
    80001e98:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e9a:	47a9                	li	a5,10
    80001e9c:	00f50963          	beq	a0,a5,80001eae <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001ea0:	4785                	li	a5,1
    80001ea2:	00f50b63          	beq	a0,a5,80001eb8 <devintr+0x5a>
    return 1;
    80001ea6:	4505                	li	a0,1
    } else if(irq){
    80001ea8:	ec89                	bnez	s1,80001ec2 <devintr+0x64>
    80001eaa:	64a2                	ld	s1,8(sp)
    80001eac:	bfe9                	j	80001e86 <devintr+0x28>
      uartintr();
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	5a8080e7          	jalr	1448(ra) # 80006456 <uartintr>
    if(irq)
    80001eb6:	a839                	j	80001ed4 <devintr+0x76>
      virtio_disk_intr();
    80001eb8:	00004097          	auipc	ra,0x4
    80001ebc:	af8080e7          	jalr	-1288(ra) # 800059b0 <virtio_disk_intr>
    if(irq)
    80001ec0:	a811                	j	80001ed4 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ec2:	85a6                	mv	a1,s1
    80001ec4:	00006517          	auipc	a0,0x6
    80001ec8:	37c50513          	addi	a0,a0,892 # 80008240 <etext+0x240>
    80001ecc:	00004097          	auipc	ra,0x4
    80001ed0:	13a080e7          	jalr	314(ra) # 80006006 <printf>
      plic_complete(irq);
    80001ed4:	8526                	mv	a0,s1
    80001ed6:	00003097          	auipc	ra,0x3
    80001eda:	62a080e7          	jalr	1578(ra) # 80005500 <plic_complete>
    return 1;
    80001ede:	4505                	li	a0,1
    80001ee0:	64a2                	ld	s1,8(sp)
    80001ee2:	b755                	j	80001e86 <devintr+0x28>
    if(cpuid() == 0){
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	1fa080e7          	jalr	506(ra) # 800010de <cpuid>
    80001eec:	c901                	beqz	a0,80001efc <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001eee:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ef2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ef4:	14479073          	csrw	sip,a5
    return 2;
    80001ef8:	4509                	li	a0,2
    80001efa:	b771                	j	80001e86 <devintr+0x28>
      clockintr();
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	f1c080e7          	jalr	-228(ra) # 80001e18 <clockintr>
    80001f04:	b7ed                	j	80001eee <devintr+0x90>
}
    80001f06:	8082                	ret

0000000080001f08 <usertrap>:
{
    80001f08:	7139                	addi	sp,sp,-64
    80001f0a:	fc06                	sd	ra,56(sp)
    80001f0c:	f822                	sd	s0,48(sp)
    80001f0e:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f10:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001f14:	1007f793          	andi	a5,a5,256
    80001f18:	ebad                	bnez	a5,80001f8a <usertrap+0x82>
    80001f1a:	f426                	sd	s1,40(sp)
    80001f1c:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f1e:	00003797          	auipc	a5,0x3
    80001f22:	4b278793          	addi	a5,a5,1202 # 800053d0 <kernelvec>
    80001f26:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	1e0080e7          	jalr	480(ra) # 8000110a <myproc>
    80001f32:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f34:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f36:	14102773          	csrr	a4,sepc
    80001f3a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f40:	47a1                	li	a5,8
    80001f42:	06f70163          	beq	a4,a5,80001fa4 <usertrap+0x9c>
    80001f46:	14202773          	csrr	a4,scause
  }else if (r_scause() == 15) 
    80001f4a:	47bd                	li	a5,15
    80001f4c:	16f71763          	bne	a4,a5,800020ba <usertrap+0x1b2>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f50:	14302973          	csrr	s2,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001f54:	77fd                	lui	a5,0xfffff
    80001f56:	00f97933          	and	s2,s2,a5
    if (va > p->sz || (pte = walk(p->pagetable, va, 0)) == 0)
    80001f5a:	653c                	ld	a5,72(a0)
    80001f5c:	0727fe63          	bgeu	a5,s2,80001fd8 <usertrap+0xd0>
    p->killed = 1;
    80001f60:	4785                	li	a5,1
    80001f62:	d49c                	sw	a5,40(s1)
    80001f64:	4901                	li	s2,0
    exit(-1);
    80001f66:	557d                	li	a0,-1
    80001f68:	00000097          	auipc	ra,0x0
    80001f6c:	ac4080e7          	jalr	-1340(ra) # 80001a2c <exit>
  if(which_dev == 2)
    80001f70:	4789                	li	a5,2
    80001f72:	18f90663          	beq	s2,a5,800020fe <usertrap+0x1f6>
  usertrapret();
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	e04080e7          	jalr	-508(ra) # 80001d7a <usertrapret>
    80001f7e:	74a2                	ld	s1,40(sp)
    80001f80:	7902                	ld	s2,32(sp)
}
    80001f82:	70e2                	ld	ra,56(sp)
    80001f84:	7442                	ld	s0,48(sp)
    80001f86:	6121                	addi	sp,sp,64
    80001f88:	8082                	ret
    80001f8a:	f426                	sd	s1,40(sp)
    80001f8c:	f04a                	sd	s2,32(sp)
    80001f8e:	ec4e                	sd	s3,24(sp)
    80001f90:	e852                	sd	s4,16(sp)
    80001f92:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	2cc50513          	addi	a0,a0,716 # 80008260 <etext+0x260>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	020080e7          	jalr	32(ra) # 80005fbc <panic>
    if(p->killed)
    80001fa4:	551c                	lw	a5,40(a0)
    80001fa6:	e39d                	bnez	a5,80001fcc <usertrap+0xc4>
    p->trapframe->epc += 4;
    80001fa8:	6cb8                	ld	a4,88(s1)
    80001faa:	6f1c                	ld	a5,24(a4)
    80001fac:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7ffd5dc4>
    80001fae:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fb0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fb4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb8:	10079073          	csrw	sstatus,a5
    syscall();
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	392080e7          	jalr	914(ra) # 8000234e <syscall>
  if(p->killed)
    80001fc4:	549c                	lw	a5,40(s1)
    80001fc6:	dbc5                	beqz	a5,80001f76 <usertrap+0x6e>
    80001fc8:	4901                	li	s2,0
    80001fca:	bf71                	j	80001f66 <usertrap+0x5e>
      exit(-1);
    80001fcc:	557d                	li	a0,-1
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	a5e080e7          	jalr	-1442(ra) # 80001a2c <exit>
    80001fd6:	bfc9                	j	80001fa8 <usertrap+0xa0>
    80001fd8:	ec4e                	sd	s3,24(sp)
    if (va > p->sz || (pte = walk(p->pagetable, va, 0)) == 0)
    80001fda:	4601                	li	a2,0
    80001fdc:	85ca                	mv	a1,s2
    80001fde:	6928                	ld	a0,80(a0)
    80001fe0:	ffffe097          	auipc	ra,0xffffe
    80001fe4:	5da080e7          	jalr	1498(ra) # 800005ba <walk>
    80001fe8:	89aa                	mv	s3,a0
    80001fea:	10050f63          	beqz	a0,80002108 <usertrap+0x200>
    80001fee:	e852                	sd	s4,16(sp)
    if (((*pte) & PTE_COW) == 0 || ((*pte) & PTE_V) == 0 || ((*pte) & PTE_U) == 0)
    80001ff0:	00053a03          	ld	s4,0(a0)
    80001ff4:	111a7713          	andi	a4,s4,273
    80001ff8:	11100793          	li	a5,273
    80001ffc:	00f70563          	beq	a4,a5,80002006 <usertrap+0xfe>
    80002000:	69e2                	ld	s3,24(sp)
    80002002:	6a42                	ld	s4,16(sp)
    80002004:	bfb1                	j	80001f60 <usertrap+0x58>
    acquire_ref_lock();
    80002006:	ffffe097          	auipc	ra,0xffffe
    8000200a:	29c080e7          	jalr	668(ra) # 800002a2 <acquire_ref_lock>
    uint64 pa = PTE2PA(*pte);
    8000200e:	00aa5a13          	srli	s4,s4,0xa
    80002012:	0a32                	slli	s4,s4,0xc
    uint ref = get_kmem_ref((void*)pa);
    80002014:	8552                	mv	a0,s4
    80002016:	ffffe097          	auipc	ra,0xffffe
    8000201a:	234080e7          	jalr	564(ra) # 8000024a <get_kmem_ref>
    if (ref == 1)
    8000201e:	4785                	li	a5,1
    80002020:	02f51163          	bne	a0,a5,80002042 <usertrap+0x13a>
      *pte = ((*pte) & (~PTE_COW)) | PTE_W;
    80002024:	0009b783          	ld	a5,0(s3)
    80002028:	efb7f793          	andi	a5,a5,-261
    8000202c:	0047e793          	ori	a5,a5,4
    80002030:	00f9b023          	sd	a5,0(s3)
    release_ref_lock();
    80002034:	ffffe097          	auipc	ra,0xffffe
    80002038:	28e080e7          	jalr	654(ra) # 800002c2 <release_ref_lock>
    8000203c:	69e2                	ld	s3,24(sp)
    8000203e:	6a42                	ld	s4,16(sp)
    80002040:	b751                	j	80001fc4 <usertrap+0xbc>
    80002042:	e456                	sd	s5,8(sp)
      char* mem = kalloc();
    80002044:	ffffe097          	auipc	ra,0xffffe
    80002048:	18a080e7          	jalr	394(ra) # 800001ce <kalloc>
    8000204c:	8aaa                	mv	s5,a0
      if (mem == 0)
    8000204e:	cd0d                	beqz	a0,80002088 <usertrap+0x180>
      memmove(mem, (char*)pa, PGSIZE);
    80002050:	6605                	lui	a2,0x1
    80002052:	85d2                	mv	a1,s4
    80002054:	ffffe097          	auipc	ra,0xffffe
    80002058:	2ea080e7          	jalr	746(ra) # 8000033e <memmove>
      uint flag = (PTE_FLAGS(*pte) | PTE_W) & (~PTE_COW);
    8000205c:	0009b703          	ld	a4,0(s3)
    80002060:	2fb77713          	andi	a4,a4,763
      if (mappages(p->pagetable, va, PGSIZE, (uint64)mem,flag) != 0)
    80002064:	00476713          	ori	a4,a4,4
    80002068:	86d6                	mv	a3,s5
    8000206a:	6605                	lui	a2,0x1
    8000206c:	85ca                	mv	a1,s2
    8000206e:	68a8                	ld	a0,80(s1)
    80002070:	ffffe097          	auipc	ra,0xffffe
    80002074:	632080e7          	jalr	1586(ra) # 800006a2 <mappages>
    80002078:	e115                	bnez	a0,8000209c <usertrap+0x194>
      kfree((void*)pa);
    8000207a:	8552                	mv	a0,s4
    8000207c:	ffffe097          	auipc	ra,0xffffe
    80002080:	fa0080e7          	jalr	-96(ra) # 8000001c <kfree>
    80002084:	6aa2                	ld	s5,8(sp)
    80002086:	b77d                	j	80002034 <usertrap+0x12c>
        p->killed = 1;
    80002088:	4785                	li	a5,1
    8000208a:	d49c                	sw	a5,40(s1)
        release_ref_lock();
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	236080e7          	jalr	566(ra) # 800002c2 <release_ref_lock>
        goto end;
    80002094:	69e2                	ld	s3,24(sp)
    80002096:	6a42                	ld	s4,16(sp)
    80002098:	6aa2                	ld	s5,8(sp)
    8000209a:	b72d                	j	80001fc4 <usertrap+0xbc>
        kfree(mem);
    8000209c:	8556                	mv	a0,s5
    8000209e:	ffffe097          	auipc	ra,0xffffe
    800020a2:	f7e080e7          	jalr	-130(ra) # 8000001c <kfree>
        p->killed = 1;
    800020a6:	4785                	li	a5,1
    800020a8:	d49c                	sw	a5,40(s1)
        release_ref_lock();
    800020aa:	ffffe097          	auipc	ra,0xffffe
    800020ae:	218080e7          	jalr	536(ra) # 800002c2 <release_ref_lock>
        goto end;
    800020b2:	69e2                	ld	s3,24(sp)
    800020b4:	6a42                	ld	s4,16(sp)
    800020b6:	6aa2                	ld	s5,8(sp)
    800020b8:	b731                	j	80001fc4 <usertrap+0xbc>
  else if((which_dev = devintr()) != 0)
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	da4080e7          	jalr	-604(ra) # 80001e5e <devintr>
    800020c2:	892a                	mv	s2,a0
    800020c4:	c509                	beqz	a0,800020ce <usertrap+0x1c6>
  if(p->killed)
    800020c6:	549c                	lw	a5,40(s1)
    800020c8:	ea0784e3          	beqz	a5,80001f70 <usertrap+0x68>
    800020cc:	bd69                	j	80001f66 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800020ce:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800020d2:	5890                	lw	a2,48(s1)
    800020d4:	00006517          	auipc	a0,0x6
    800020d8:	1ac50513          	addi	a0,a0,428 # 80008280 <etext+0x280>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	f2a080e7          	jalr	-214(ra) # 80006006 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020e4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020e8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020ec:	00006517          	auipc	a0,0x6
    800020f0:	1c450513          	addi	a0,a0,452 # 800082b0 <etext+0x2b0>
    800020f4:	00004097          	auipc	ra,0x4
    800020f8:	f12080e7          	jalr	-238(ra) # 80006006 <printf>
    p->killed = 1;
    800020fc:	b595                	j	80001f60 <usertrap+0x58>
    yield();
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	696080e7          	jalr	1686(ra) # 80001794 <yield>
    80002106:	bd85                	j	80001f76 <usertrap+0x6e>
    80002108:	69e2                	ld	s3,24(sp)
    8000210a:	bd99                	j	80001f60 <usertrap+0x58>

000000008000210c <kerneltrap>:
{
    8000210c:	7179                	addi	sp,sp,-48
    8000210e:	f406                	sd	ra,40(sp)
    80002110:	f022                	sd	s0,32(sp)
    80002112:	ec26                	sd	s1,24(sp)
    80002114:	e84a                	sd	s2,16(sp)
    80002116:	e44e                	sd	s3,8(sp)
    80002118:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000211a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000211e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002122:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002126:	1004f793          	andi	a5,s1,256
    8000212a:	cb85                	beqz	a5,8000215a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000212c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002130:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002132:	ef85                	bnez	a5,8000216a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002134:	00000097          	auipc	ra,0x0
    80002138:	d2a080e7          	jalr	-726(ra) # 80001e5e <devintr>
    8000213c:	cd1d                	beqz	a0,8000217a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000213e:	4789                	li	a5,2
    80002140:	06f50a63          	beq	a0,a5,800021b4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002144:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002148:	10049073          	csrw	sstatus,s1
}
    8000214c:	70a2                	ld	ra,40(sp)
    8000214e:	7402                	ld	s0,32(sp)
    80002150:	64e2                	ld	s1,24(sp)
    80002152:	6942                	ld	s2,16(sp)
    80002154:	69a2                	ld	s3,8(sp)
    80002156:	6145                	addi	sp,sp,48
    80002158:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000215a:	00006517          	auipc	a0,0x6
    8000215e:	17650513          	addi	a0,a0,374 # 800082d0 <etext+0x2d0>
    80002162:	00004097          	auipc	ra,0x4
    80002166:	e5a080e7          	jalr	-422(ra) # 80005fbc <panic>
    panic("kerneltrap: interrupts enabled");
    8000216a:	00006517          	auipc	a0,0x6
    8000216e:	18e50513          	addi	a0,a0,398 # 800082f8 <etext+0x2f8>
    80002172:	00004097          	auipc	ra,0x4
    80002176:	e4a080e7          	jalr	-438(ra) # 80005fbc <panic>
    printf("scause %p\n", scause);
    8000217a:	85ce                	mv	a1,s3
    8000217c:	00006517          	auipc	a0,0x6
    80002180:	19c50513          	addi	a0,a0,412 # 80008318 <etext+0x318>
    80002184:	00004097          	auipc	ra,0x4
    80002188:	e82080e7          	jalr	-382(ra) # 80006006 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000218c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002190:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002194:	00006517          	auipc	a0,0x6
    80002198:	19450513          	addi	a0,a0,404 # 80008328 <etext+0x328>
    8000219c:	00004097          	auipc	ra,0x4
    800021a0:	e6a080e7          	jalr	-406(ra) # 80006006 <printf>
    panic("kerneltrap");
    800021a4:	00006517          	auipc	a0,0x6
    800021a8:	19c50513          	addi	a0,a0,412 # 80008340 <etext+0x340>
    800021ac:	00004097          	auipc	ra,0x4
    800021b0:	e10080e7          	jalr	-496(ra) # 80005fbc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	f56080e7          	jalr	-170(ra) # 8000110a <myproc>
    800021bc:	d541                	beqz	a0,80002144 <kerneltrap+0x38>
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	f4c080e7          	jalr	-180(ra) # 8000110a <myproc>
    800021c6:	4d18                	lw	a4,24(a0)
    800021c8:	4791                	li	a5,4
    800021ca:	f6f71de3          	bne	a4,a5,80002144 <kerneltrap+0x38>
    yield();
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	5c6080e7          	jalr	1478(ra) # 80001794 <yield>
    800021d6:	b7bd                	j	80002144 <kerneltrap+0x38>

00000000800021d8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800021d8:	1101                	addi	sp,sp,-32
    800021da:	ec06                	sd	ra,24(sp)
    800021dc:	e822                	sd	s0,16(sp)
    800021de:	e426                	sd	s1,8(sp)
    800021e0:	1000                	addi	s0,sp,32
    800021e2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	f26080e7          	jalr	-218(ra) # 8000110a <myproc>
  switch (n) {
    800021ec:	4795                	li	a5,5
    800021ee:	0497e163          	bltu	a5,s1,80002230 <argraw+0x58>
    800021f2:	048a                	slli	s1,s1,0x2
    800021f4:	00006717          	auipc	a4,0x6
    800021f8:	53470713          	addi	a4,a4,1332 # 80008728 <states.0+0x30>
    800021fc:	94ba                	add	s1,s1,a4
    800021fe:	409c                	lw	a5,0(s1)
    80002200:	97ba                	add	a5,a5,a4
    80002202:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002204:	6d3c                	ld	a5,88(a0)
    80002206:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002208:	60e2                	ld	ra,24(sp)
    8000220a:	6442                	ld	s0,16(sp)
    8000220c:	64a2                	ld	s1,8(sp)
    8000220e:	6105                	addi	sp,sp,32
    80002210:	8082                	ret
    return p->trapframe->a1;
    80002212:	6d3c                	ld	a5,88(a0)
    80002214:	7fa8                	ld	a0,120(a5)
    80002216:	bfcd                	j	80002208 <argraw+0x30>
    return p->trapframe->a2;
    80002218:	6d3c                	ld	a5,88(a0)
    8000221a:	63c8                	ld	a0,128(a5)
    8000221c:	b7f5                	j	80002208 <argraw+0x30>
    return p->trapframe->a3;
    8000221e:	6d3c                	ld	a5,88(a0)
    80002220:	67c8                	ld	a0,136(a5)
    80002222:	b7dd                	j	80002208 <argraw+0x30>
    return p->trapframe->a4;
    80002224:	6d3c                	ld	a5,88(a0)
    80002226:	6bc8                	ld	a0,144(a5)
    80002228:	b7c5                	j	80002208 <argraw+0x30>
    return p->trapframe->a5;
    8000222a:	6d3c                	ld	a5,88(a0)
    8000222c:	6fc8                	ld	a0,152(a5)
    8000222e:	bfe9                	j	80002208 <argraw+0x30>
  panic("argraw");
    80002230:	00006517          	auipc	a0,0x6
    80002234:	12050513          	addi	a0,a0,288 # 80008350 <etext+0x350>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	d84080e7          	jalr	-636(ra) # 80005fbc <panic>

0000000080002240 <fetchaddr>:
{
    80002240:	1101                	addi	sp,sp,-32
    80002242:	ec06                	sd	ra,24(sp)
    80002244:	e822                	sd	s0,16(sp)
    80002246:	e426                	sd	s1,8(sp)
    80002248:	e04a                	sd	s2,0(sp)
    8000224a:	1000                	addi	s0,sp,32
    8000224c:	84aa                	mv	s1,a0
    8000224e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	eba080e7          	jalr	-326(ra) # 8000110a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002258:	653c                	ld	a5,72(a0)
    8000225a:	02f4f863          	bgeu	s1,a5,8000228a <fetchaddr+0x4a>
    8000225e:	00848713          	addi	a4,s1,8
    80002262:	02e7e663          	bltu	a5,a4,8000228e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002266:	46a1                	li	a3,8
    80002268:	8626                	mv	a2,s1
    8000226a:	85ca                	mv	a1,s2
    8000226c:	6928                	ld	a0,80(a0)
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	bc4080e7          	jalr	-1084(ra) # 80000e32 <copyin>
    80002276:	00a03533          	snez	a0,a0
    8000227a:	40a00533          	neg	a0,a0
}
    8000227e:	60e2                	ld	ra,24(sp)
    80002280:	6442                	ld	s0,16(sp)
    80002282:	64a2                	ld	s1,8(sp)
    80002284:	6902                	ld	s2,0(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret
    return -1;
    8000228a:	557d                	li	a0,-1
    8000228c:	bfcd                	j	8000227e <fetchaddr+0x3e>
    8000228e:	557d                	li	a0,-1
    80002290:	b7fd                	j	8000227e <fetchaddr+0x3e>

0000000080002292 <fetchstr>:
{
    80002292:	7179                	addi	sp,sp,-48
    80002294:	f406                	sd	ra,40(sp)
    80002296:	f022                	sd	s0,32(sp)
    80002298:	ec26                	sd	s1,24(sp)
    8000229a:	e84a                	sd	s2,16(sp)
    8000229c:	e44e                	sd	s3,8(sp)
    8000229e:	1800                	addi	s0,sp,48
    800022a0:	892a                	mv	s2,a0
    800022a2:	84ae                	mv	s1,a1
    800022a4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	e64080e7          	jalr	-412(ra) # 8000110a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800022ae:	86ce                	mv	a3,s3
    800022b0:	864a                	mv	a2,s2
    800022b2:	85a6                	mv	a1,s1
    800022b4:	6928                	ld	a0,80(a0)
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	c0a080e7          	jalr	-1014(ra) # 80000ec0 <copyinstr>
  if(err < 0)
    800022be:	00054763          	bltz	a0,800022cc <fetchstr+0x3a>
  return strlen(buf);
    800022c2:	8526                	mv	a0,s1
    800022c4:	ffffe097          	auipc	ra,0xffffe
    800022c8:	192080e7          	jalr	402(ra) # 80000456 <strlen>
}
    800022cc:	70a2                	ld	ra,40(sp)
    800022ce:	7402                	ld	s0,32(sp)
    800022d0:	64e2                	ld	s1,24(sp)
    800022d2:	6942                	ld	s2,16(sp)
    800022d4:	69a2                	ld	s3,8(sp)
    800022d6:	6145                	addi	sp,sp,48
    800022d8:	8082                	ret

00000000800022da <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800022da:	1101                	addi	sp,sp,-32
    800022dc:	ec06                	sd	ra,24(sp)
    800022de:	e822                	sd	s0,16(sp)
    800022e0:	e426                	sd	s1,8(sp)
    800022e2:	1000                	addi	s0,sp,32
    800022e4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022e6:	00000097          	auipc	ra,0x0
    800022ea:	ef2080e7          	jalr	-270(ra) # 800021d8 <argraw>
    800022ee:	c088                	sw	a0,0(s1)
  return 0;
}
    800022f0:	4501                	li	a0,0
    800022f2:	60e2                	ld	ra,24(sp)
    800022f4:	6442                	ld	s0,16(sp)
    800022f6:	64a2                	ld	s1,8(sp)
    800022f8:	6105                	addi	sp,sp,32
    800022fa:	8082                	ret

00000000800022fc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800022fc:	1101                	addi	sp,sp,-32
    800022fe:	ec06                	sd	ra,24(sp)
    80002300:	e822                	sd	s0,16(sp)
    80002302:	e426                	sd	s1,8(sp)
    80002304:	1000                	addi	s0,sp,32
    80002306:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	ed0080e7          	jalr	-304(ra) # 800021d8 <argraw>
    80002310:	e088                	sd	a0,0(s1)
  return 0;
}
    80002312:	4501                	li	a0,0
    80002314:	60e2                	ld	ra,24(sp)
    80002316:	6442                	ld	s0,16(sp)
    80002318:	64a2                	ld	s1,8(sp)
    8000231a:	6105                	addi	sp,sp,32
    8000231c:	8082                	ret

000000008000231e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000231e:	1101                	addi	sp,sp,-32
    80002320:	ec06                	sd	ra,24(sp)
    80002322:	e822                	sd	s0,16(sp)
    80002324:	e426                	sd	s1,8(sp)
    80002326:	e04a                	sd	s2,0(sp)
    80002328:	1000                	addi	s0,sp,32
    8000232a:	84ae                	mv	s1,a1
    8000232c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000232e:	00000097          	auipc	ra,0x0
    80002332:	eaa080e7          	jalr	-342(ra) # 800021d8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002336:	864a                	mv	a2,s2
    80002338:	85a6                	mv	a1,s1
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	f58080e7          	jalr	-168(ra) # 80002292 <fetchstr>
}
    80002342:	60e2                	ld	ra,24(sp)
    80002344:	6442                	ld	s0,16(sp)
    80002346:	64a2                	ld	s1,8(sp)
    80002348:	6902                	ld	s2,0(sp)
    8000234a:	6105                	addi	sp,sp,32
    8000234c:	8082                	ret

000000008000234e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000234e:	1101                	addi	sp,sp,-32
    80002350:	ec06                	sd	ra,24(sp)
    80002352:	e822                	sd	s0,16(sp)
    80002354:	e426                	sd	s1,8(sp)
    80002356:	e04a                	sd	s2,0(sp)
    80002358:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	db0080e7          	jalr	-592(ra) # 8000110a <myproc>
    80002362:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002364:	05853903          	ld	s2,88(a0)
    80002368:	0a893783          	ld	a5,168(s2)
    8000236c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002370:	37fd                	addiw	a5,a5,-1
    80002372:	4751                	li	a4,20
    80002374:	00f76f63          	bltu	a4,a5,80002392 <syscall+0x44>
    80002378:	00369713          	slli	a4,a3,0x3
    8000237c:	00006797          	auipc	a5,0x6
    80002380:	3c478793          	addi	a5,a5,964 # 80008740 <syscalls>
    80002384:	97ba                	add	a5,a5,a4
    80002386:	639c                	ld	a5,0(a5)
    80002388:	c789                	beqz	a5,80002392 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000238a:	9782                	jalr	a5
    8000238c:	06a93823          	sd	a0,112(s2)
    80002390:	a839                	j	800023ae <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002392:	15848613          	addi	a2,s1,344
    80002396:	588c                	lw	a1,48(s1)
    80002398:	00006517          	auipc	a0,0x6
    8000239c:	fc050513          	addi	a0,a0,-64 # 80008358 <etext+0x358>
    800023a0:	00004097          	auipc	ra,0x4
    800023a4:	c66080e7          	jalr	-922(ra) # 80006006 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800023a8:	6cbc                	ld	a5,88(s1)
    800023aa:	577d                	li	a4,-1
    800023ac:	fbb8                	sd	a4,112(a5)
  }
}
    800023ae:	60e2                	ld	ra,24(sp)
    800023b0:	6442                	ld	s0,16(sp)
    800023b2:	64a2                	ld	s1,8(sp)
    800023b4:	6902                	ld	s2,0(sp)
    800023b6:	6105                	addi	sp,sp,32
    800023b8:	8082                	ret

00000000800023ba <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800023ba:	1101                	addi	sp,sp,-32
    800023bc:	ec06                	sd	ra,24(sp)
    800023be:	e822                	sd	s0,16(sp)
    800023c0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800023c2:	fec40593          	addi	a1,s0,-20
    800023c6:	4501                	li	a0,0
    800023c8:	00000097          	auipc	ra,0x0
    800023cc:	f12080e7          	jalr	-238(ra) # 800022da <argint>
    return -1;
    800023d0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800023d2:	00054963          	bltz	a0,800023e4 <sys_exit+0x2a>
  exit(n);
    800023d6:	fec42503          	lw	a0,-20(s0)
    800023da:	fffff097          	auipc	ra,0xfffff
    800023de:	652080e7          	jalr	1618(ra) # 80001a2c <exit>
  return 0;  // not reached
    800023e2:	4781                	li	a5,0
}
    800023e4:	853e                	mv	a0,a5
    800023e6:	60e2                	ld	ra,24(sp)
    800023e8:	6442                	ld	s0,16(sp)
    800023ea:	6105                	addi	sp,sp,32
    800023ec:	8082                	ret

00000000800023ee <sys_getpid>:

uint64
sys_getpid(void)
{
    800023ee:	1141                	addi	sp,sp,-16
    800023f0:	e406                	sd	ra,8(sp)
    800023f2:	e022                	sd	s0,0(sp)
    800023f4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	d14080e7          	jalr	-748(ra) # 8000110a <myproc>
}
    800023fe:	5908                	lw	a0,48(a0)
    80002400:	60a2                	ld	ra,8(sp)
    80002402:	6402                	ld	s0,0(sp)
    80002404:	0141                	addi	sp,sp,16
    80002406:	8082                	ret

0000000080002408 <sys_fork>:

uint64
sys_fork(void)
{
    80002408:	1141                	addi	sp,sp,-16
    8000240a:	e406                	sd	ra,8(sp)
    8000240c:	e022                	sd	s0,0(sp)
    8000240e:	0800                	addi	s0,sp,16
  return fork();
    80002410:	fffff097          	auipc	ra,0xfffff
    80002414:	0cc080e7          	jalr	204(ra) # 800014dc <fork>
}
    80002418:	60a2                	ld	ra,8(sp)
    8000241a:	6402                	ld	s0,0(sp)
    8000241c:	0141                	addi	sp,sp,16
    8000241e:	8082                	ret

0000000080002420 <sys_wait>:

uint64
sys_wait(void)
{
    80002420:	1101                	addi	sp,sp,-32
    80002422:	ec06                	sd	ra,24(sp)
    80002424:	e822                	sd	s0,16(sp)
    80002426:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002428:	fe840593          	addi	a1,s0,-24
    8000242c:	4501                	li	a0,0
    8000242e:	00000097          	auipc	ra,0x0
    80002432:	ece080e7          	jalr	-306(ra) # 800022fc <argaddr>
    80002436:	87aa                	mv	a5,a0
    return -1;
    80002438:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000243a:	0007c863          	bltz	a5,8000244a <sys_wait+0x2a>
  return wait(p);
    8000243e:	fe843503          	ld	a0,-24(s0)
    80002442:	fffff097          	auipc	ra,0xfffff
    80002446:	3f2080e7          	jalr	1010(ra) # 80001834 <wait>
}
    8000244a:	60e2                	ld	ra,24(sp)
    8000244c:	6442                	ld	s0,16(sp)
    8000244e:	6105                	addi	sp,sp,32
    80002450:	8082                	ret

0000000080002452 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002452:	7179                	addi	sp,sp,-48
    80002454:	f406                	sd	ra,40(sp)
    80002456:	f022                	sd	s0,32(sp)
    80002458:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000245a:	fdc40593          	addi	a1,s0,-36
    8000245e:	4501                	li	a0,0
    80002460:	00000097          	auipc	ra,0x0
    80002464:	e7a080e7          	jalr	-390(ra) # 800022da <argint>
    80002468:	87aa                	mv	a5,a0
    return -1;
    8000246a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000246c:	0207c263          	bltz	a5,80002490 <sys_sbrk+0x3e>
    80002470:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002472:	fffff097          	auipc	ra,0xfffff
    80002476:	c98080e7          	jalr	-872(ra) # 8000110a <myproc>
    8000247a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000247c:	fdc42503          	lw	a0,-36(s0)
    80002480:	fffff097          	auipc	ra,0xfffff
    80002484:	fe4080e7          	jalr	-28(ra) # 80001464 <growproc>
    80002488:	00054863          	bltz	a0,80002498 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000248c:	8526                	mv	a0,s1
    8000248e:	64e2                	ld	s1,24(sp)
}
    80002490:	70a2                	ld	ra,40(sp)
    80002492:	7402                	ld	s0,32(sp)
    80002494:	6145                	addi	sp,sp,48
    80002496:	8082                	ret
    return -1;
    80002498:	557d                	li	a0,-1
    8000249a:	64e2                	ld	s1,24(sp)
    8000249c:	bfd5                	j	80002490 <sys_sbrk+0x3e>

000000008000249e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000249e:	7139                	addi	sp,sp,-64
    800024a0:	fc06                	sd	ra,56(sp)
    800024a2:	f822                	sd	s0,48(sp)
    800024a4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800024a6:	fcc40593          	addi	a1,s0,-52
    800024aa:	4501                	li	a0,0
    800024ac:	00000097          	auipc	ra,0x0
    800024b0:	e2e080e7          	jalr	-466(ra) # 800022da <argint>
    return -1;
    800024b4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800024b6:	06054b63          	bltz	a0,8000252c <sys_sleep+0x8e>
    800024ba:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800024bc:	00010517          	auipc	a0,0x10
    800024c0:	9e450513          	addi	a0,a0,-1564 # 80011ea0 <tickslock>
    800024c4:	00004097          	auipc	ra,0x4
    800024c8:	072080e7          	jalr	114(ra) # 80006536 <acquire>
  ticks0 = ticks;
    800024cc:	0000a917          	auipc	s2,0xa
    800024d0:	b4c92903          	lw	s2,-1204(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    800024d4:	fcc42783          	lw	a5,-52(s0)
    800024d8:	c3a1                	beqz	a5,80002518 <sys_sleep+0x7a>
    800024da:	f426                	sd	s1,40(sp)
    800024dc:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024de:	00010997          	auipc	s3,0x10
    800024e2:	9c298993          	addi	s3,s3,-1598 # 80011ea0 <tickslock>
    800024e6:	0000a497          	auipc	s1,0xa
    800024ea:	b3248493          	addi	s1,s1,-1230 # 8000c018 <ticks>
    if(myproc()->killed){
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	c1c080e7          	jalr	-996(ra) # 8000110a <myproc>
    800024f6:	551c                	lw	a5,40(a0)
    800024f8:	ef9d                	bnez	a5,80002536 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800024fa:	85ce                	mv	a1,s3
    800024fc:	8526                	mv	a0,s1
    800024fe:	fffff097          	auipc	ra,0xfffff
    80002502:	2d2080e7          	jalr	722(ra) # 800017d0 <sleep>
  while(ticks - ticks0 < n){
    80002506:	409c                	lw	a5,0(s1)
    80002508:	412787bb          	subw	a5,a5,s2
    8000250c:	fcc42703          	lw	a4,-52(s0)
    80002510:	fce7efe3          	bltu	a5,a4,800024ee <sys_sleep+0x50>
    80002514:	74a2                	ld	s1,40(sp)
    80002516:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002518:	00010517          	auipc	a0,0x10
    8000251c:	98850513          	addi	a0,a0,-1656 # 80011ea0 <tickslock>
    80002520:	00004097          	auipc	ra,0x4
    80002524:	0ca080e7          	jalr	202(ra) # 800065ea <release>
  return 0;
    80002528:	4781                	li	a5,0
    8000252a:	7902                	ld	s2,32(sp)
}
    8000252c:	853e                	mv	a0,a5
    8000252e:	70e2                	ld	ra,56(sp)
    80002530:	7442                	ld	s0,48(sp)
    80002532:	6121                	addi	sp,sp,64
    80002534:	8082                	ret
      release(&tickslock);
    80002536:	00010517          	auipc	a0,0x10
    8000253a:	96a50513          	addi	a0,a0,-1686 # 80011ea0 <tickslock>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	0ac080e7          	jalr	172(ra) # 800065ea <release>
      return -1;
    80002546:	57fd                	li	a5,-1
    80002548:	74a2                	ld	s1,40(sp)
    8000254a:	7902                	ld	s2,32(sp)
    8000254c:	69e2                	ld	s3,24(sp)
    8000254e:	bff9                	j	8000252c <sys_sleep+0x8e>

0000000080002550 <sys_kill>:

uint64
sys_kill(void)
{
    80002550:	1101                	addi	sp,sp,-32
    80002552:	ec06                	sd	ra,24(sp)
    80002554:	e822                	sd	s0,16(sp)
    80002556:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002558:	fec40593          	addi	a1,s0,-20
    8000255c:	4501                	li	a0,0
    8000255e:	00000097          	auipc	ra,0x0
    80002562:	d7c080e7          	jalr	-644(ra) # 800022da <argint>
    80002566:	87aa                	mv	a5,a0
    return -1;
    80002568:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000256a:	0007c863          	bltz	a5,8000257a <sys_kill+0x2a>
  return kill(pid);
    8000256e:	fec42503          	lw	a0,-20(s0)
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	590080e7          	jalr	1424(ra) # 80001b02 <kill>
}
    8000257a:	60e2                	ld	ra,24(sp)
    8000257c:	6442                	ld	s0,16(sp)
    8000257e:	6105                	addi	sp,sp,32
    80002580:	8082                	ret

0000000080002582 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002582:	1101                	addi	sp,sp,-32
    80002584:	ec06                	sd	ra,24(sp)
    80002586:	e822                	sd	s0,16(sp)
    80002588:	e426                	sd	s1,8(sp)
    8000258a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000258c:	00010517          	auipc	a0,0x10
    80002590:	91450513          	addi	a0,a0,-1772 # 80011ea0 <tickslock>
    80002594:	00004097          	auipc	ra,0x4
    80002598:	fa2080e7          	jalr	-94(ra) # 80006536 <acquire>
  xticks = ticks;
    8000259c:	0000a497          	auipc	s1,0xa
    800025a0:	a7c4a483          	lw	s1,-1412(s1) # 8000c018 <ticks>
  release(&tickslock);
    800025a4:	00010517          	auipc	a0,0x10
    800025a8:	8fc50513          	addi	a0,a0,-1796 # 80011ea0 <tickslock>
    800025ac:	00004097          	auipc	ra,0x4
    800025b0:	03e080e7          	jalr	62(ra) # 800065ea <release>
  return xticks;
}
    800025b4:	02049513          	slli	a0,s1,0x20
    800025b8:	9101                	srli	a0,a0,0x20
    800025ba:	60e2                	ld	ra,24(sp)
    800025bc:	6442                	ld	s0,16(sp)
    800025be:	64a2                	ld	s1,8(sp)
    800025c0:	6105                	addi	sp,sp,32
    800025c2:	8082                	ret

00000000800025c4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800025c4:	7179                	addi	sp,sp,-48
    800025c6:	f406                	sd	ra,40(sp)
    800025c8:	f022                	sd	s0,32(sp)
    800025ca:	ec26                	sd	s1,24(sp)
    800025cc:	e84a                	sd	s2,16(sp)
    800025ce:	e44e                	sd	s3,8(sp)
    800025d0:	e052                	sd	s4,0(sp)
    800025d2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800025d4:	00006597          	auipc	a1,0x6
    800025d8:	da458593          	addi	a1,a1,-604 # 80008378 <etext+0x378>
    800025dc:	00010517          	auipc	a0,0x10
    800025e0:	8dc50513          	addi	a0,a0,-1828 # 80011eb8 <bcache>
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	ec2080e7          	jalr	-318(ra) # 800064a6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025ec:	00018797          	auipc	a5,0x18
    800025f0:	8cc78793          	addi	a5,a5,-1844 # 80019eb8 <bcache+0x8000>
    800025f4:	00018717          	auipc	a4,0x18
    800025f8:	b2c70713          	addi	a4,a4,-1236 # 8001a120 <bcache+0x8268>
    800025fc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002600:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002604:	00010497          	auipc	s1,0x10
    80002608:	8cc48493          	addi	s1,s1,-1844 # 80011ed0 <bcache+0x18>
    b->next = bcache.head.next;
    8000260c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000260e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002610:	00006a17          	auipc	s4,0x6
    80002614:	d70a0a13          	addi	s4,s4,-656 # 80008380 <etext+0x380>
    b->next = bcache.head.next;
    80002618:	2b893783          	ld	a5,696(s2)
    8000261c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000261e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002622:	85d2                	mv	a1,s4
    80002624:	01048513          	addi	a0,s1,16
    80002628:	00001097          	auipc	ra,0x1
    8000262c:	4b2080e7          	jalr	1202(ra) # 80003ada <initsleeplock>
    bcache.head.next->prev = b;
    80002630:	2b893783          	ld	a5,696(s2)
    80002634:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002636:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000263a:	45848493          	addi	s1,s1,1112
    8000263e:	fd349de3          	bne	s1,s3,80002618 <binit+0x54>
  }
}
    80002642:	70a2                	ld	ra,40(sp)
    80002644:	7402                	ld	s0,32(sp)
    80002646:	64e2                	ld	s1,24(sp)
    80002648:	6942                	ld	s2,16(sp)
    8000264a:	69a2                	ld	s3,8(sp)
    8000264c:	6a02                	ld	s4,0(sp)
    8000264e:	6145                	addi	sp,sp,48
    80002650:	8082                	ret

0000000080002652 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002652:	7179                	addi	sp,sp,-48
    80002654:	f406                	sd	ra,40(sp)
    80002656:	f022                	sd	s0,32(sp)
    80002658:	ec26                	sd	s1,24(sp)
    8000265a:	e84a                	sd	s2,16(sp)
    8000265c:	e44e                	sd	s3,8(sp)
    8000265e:	1800                	addi	s0,sp,48
    80002660:	892a                	mv	s2,a0
    80002662:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002664:	00010517          	auipc	a0,0x10
    80002668:	85450513          	addi	a0,a0,-1964 # 80011eb8 <bcache>
    8000266c:	00004097          	auipc	ra,0x4
    80002670:	eca080e7          	jalr	-310(ra) # 80006536 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002674:	00018497          	auipc	s1,0x18
    80002678:	afc4b483          	ld	s1,-1284(s1) # 8001a170 <bcache+0x82b8>
    8000267c:	00018797          	auipc	a5,0x18
    80002680:	aa478793          	addi	a5,a5,-1372 # 8001a120 <bcache+0x8268>
    80002684:	02f48f63          	beq	s1,a5,800026c2 <bread+0x70>
    80002688:	873e                	mv	a4,a5
    8000268a:	a021                	j	80002692 <bread+0x40>
    8000268c:	68a4                	ld	s1,80(s1)
    8000268e:	02e48a63          	beq	s1,a4,800026c2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002692:	449c                	lw	a5,8(s1)
    80002694:	ff279ce3          	bne	a5,s2,8000268c <bread+0x3a>
    80002698:	44dc                	lw	a5,12(s1)
    8000269a:	ff3799e3          	bne	a5,s3,8000268c <bread+0x3a>
      b->refcnt++;
    8000269e:	40bc                	lw	a5,64(s1)
    800026a0:	2785                	addiw	a5,a5,1
    800026a2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026a4:	00010517          	auipc	a0,0x10
    800026a8:	81450513          	addi	a0,a0,-2028 # 80011eb8 <bcache>
    800026ac:	00004097          	auipc	ra,0x4
    800026b0:	f3e080e7          	jalr	-194(ra) # 800065ea <release>
      acquiresleep(&b->lock);
    800026b4:	01048513          	addi	a0,s1,16
    800026b8:	00001097          	auipc	ra,0x1
    800026bc:	45c080e7          	jalr	1116(ra) # 80003b14 <acquiresleep>
      return b;
    800026c0:	a8b9                	j	8000271e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026c2:	00018497          	auipc	s1,0x18
    800026c6:	aa64b483          	ld	s1,-1370(s1) # 8001a168 <bcache+0x82b0>
    800026ca:	00018797          	auipc	a5,0x18
    800026ce:	a5678793          	addi	a5,a5,-1450 # 8001a120 <bcache+0x8268>
    800026d2:	00f48863          	beq	s1,a5,800026e2 <bread+0x90>
    800026d6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800026d8:	40bc                	lw	a5,64(s1)
    800026da:	cf81                	beqz	a5,800026f2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026dc:	64a4                	ld	s1,72(s1)
    800026de:	fee49de3          	bne	s1,a4,800026d8 <bread+0x86>
  panic("bget: no buffers");
    800026e2:	00006517          	auipc	a0,0x6
    800026e6:	ca650513          	addi	a0,a0,-858 # 80008388 <etext+0x388>
    800026ea:	00004097          	auipc	ra,0x4
    800026ee:	8d2080e7          	jalr	-1838(ra) # 80005fbc <panic>
      b->dev = dev;
    800026f2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026f6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026fa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026fe:	4785                	li	a5,1
    80002700:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002702:	0000f517          	auipc	a0,0xf
    80002706:	7b650513          	addi	a0,a0,1974 # 80011eb8 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	ee0080e7          	jalr	-288(ra) # 800065ea <release>
      acquiresleep(&b->lock);
    80002712:	01048513          	addi	a0,s1,16
    80002716:	00001097          	auipc	ra,0x1
    8000271a:	3fe080e7          	jalr	1022(ra) # 80003b14 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000271e:	409c                	lw	a5,0(s1)
    80002720:	cb89                	beqz	a5,80002732 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002722:	8526                	mv	a0,s1
    80002724:	70a2                	ld	ra,40(sp)
    80002726:	7402                	ld	s0,32(sp)
    80002728:	64e2                	ld	s1,24(sp)
    8000272a:	6942                	ld	s2,16(sp)
    8000272c:	69a2                	ld	s3,8(sp)
    8000272e:	6145                	addi	sp,sp,48
    80002730:	8082                	ret
    virtio_disk_rw(b, 0);
    80002732:	4581                	li	a1,0
    80002734:	8526                	mv	a0,s1
    80002736:	00003097          	auipc	ra,0x3
    8000273a:	fec080e7          	jalr	-20(ra) # 80005722 <virtio_disk_rw>
    b->valid = 1;
    8000273e:	4785                	li	a5,1
    80002740:	c09c                	sw	a5,0(s1)
  return b;
    80002742:	b7c5                	j	80002722 <bread+0xd0>

0000000080002744 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002744:	1101                	addi	sp,sp,-32
    80002746:	ec06                	sd	ra,24(sp)
    80002748:	e822                	sd	s0,16(sp)
    8000274a:	e426                	sd	s1,8(sp)
    8000274c:	1000                	addi	s0,sp,32
    8000274e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002750:	0541                	addi	a0,a0,16
    80002752:	00001097          	auipc	ra,0x1
    80002756:	45c080e7          	jalr	1116(ra) # 80003bae <holdingsleep>
    8000275a:	cd01                	beqz	a0,80002772 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000275c:	4585                	li	a1,1
    8000275e:	8526                	mv	a0,s1
    80002760:	00003097          	auipc	ra,0x3
    80002764:	fc2080e7          	jalr	-62(ra) # 80005722 <virtio_disk_rw>
}
    80002768:	60e2                	ld	ra,24(sp)
    8000276a:	6442                	ld	s0,16(sp)
    8000276c:	64a2                	ld	s1,8(sp)
    8000276e:	6105                	addi	sp,sp,32
    80002770:	8082                	ret
    panic("bwrite");
    80002772:	00006517          	auipc	a0,0x6
    80002776:	c2e50513          	addi	a0,a0,-978 # 800083a0 <etext+0x3a0>
    8000277a:	00004097          	auipc	ra,0x4
    8000277e:	842080e7          	jalr	-1982(ra) # 80005fbc <panic>

0000000080002782 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002782:	1101                	addi	sp,sp,-32
    80002784:	ec06                	sd	ra,24(sp)
    80002786:	e822                	sd	s0,16(sp)
    80002788:	e426                	sd	s1,8(sp)
    8000278a:	e04a                	sd	s2,0(sp)
    8000278c:	1000                	addi	s0,sp,32
    8000278e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002790:	01050913          	addi	s2,a0,16
    80002794:	854a                	mv	a0,s2
    80002796:	00001097          	auipc	ra,0x1
    8000279a:	418080e7          	jalr	1048(ra) # 80003bae <holdingsleep>
    8000279e:	c925                	beqz	a0,8000280e <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800027a0:	854a                	mv	a0,s2
    800027a2:	00001097          	auipc	ra,0x1
    800027a6:	3c8080e7          	jalr	968(ra) # 80003b6a <releasesleep>

  acquire(&bcache.lock);
    800027aa:	0000f517          	auipc	a0,0xf
    800027ae:	70e50513          	addi	a0,a0,1806 # 80011eb8 <bcache>
    800027b2:	00004097          	auipc	ra,0x4
    800027b6:	d84080e7          	jalr	-636(ra) # 80006536 <acquire>
  b->refcnt--;
    800027ba:	40bc                	lw	a5,64(s1)
    800027bc:	37fd                	addiw	a5,a5,-1
    800027be:	0007871b          	sext.w	a4,a5
    800027c2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800027c4:	e71d                	bnez	a4,800027f2 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800027c6:	68b8                	ld	a4,80(s1)
    800027c8:	64bc                	ld	a5,72(s1)
    800027ca:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800027cc:	68b8                	ld	a4,80(s1)
    800027ce:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800027d0:	00017797          	auipc	a5,0x17
    800027d4:	6e878793          	addi	a5,a5,1768 # 80019eb8 <bcache+0x8000>
    800027d8:	2b87b703          	ld	a4,696(a5)
    800027dc:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800027de:	00018717          	auipc	a4,0x18
    800027e2:	94270713          	addi	a4,a4,-1726 # 8001a120 <bcache+0x8268>
    800027e6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027e8:	2b87b703          	ld	a4,696(a5)
    800027ec:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027ee:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027f2:	0000f517          	auipc	a0,0xf
    800027f6:	6c650513          	addi	a0,a0,1734 # 80011eb8 <bcache>
    800027fa:	00004097          	auipc	ra,0x4
    800027fe:	df0080e7          	jalr	-528(ra) # 800065ea <release>
}
    80002802:	60e2                	ld	ra,24(sp)
    80002804:	6442                	ld	s0,16(sp)
    80002806:	64a2                	ld	s1,8(sp)
    80002808:	6902                	ld	s2,0(sp)
    8000280a:	6105                	addi	sp,sp,32
    8000280c:	8082                	ret
    panic("brelse");
    8000280e:	00006517          	auipc	a0,0x6
    80002812:	b9a50513          	addi	a0,a0,-1126 # 800083a8 <etext+0x3a8>
    80002816:	00003097          	auipc	ra,0x3
    8000281a:	7a6080e7          	jalr	1958(ra) # 80005fbc <panic>

000000008000281e <bpin>:

void
bpin(struct buf *b) {
    8000281e:	1101                	addi	sp,sp,-32
    80002820:	ec06                	sd	ra,24(sp)
    80002822:	e822                	sd	s0,16(sp)
    80002824:	e426                	sd	s1,8(sp)
    80002826:	1000                	addi	s0,sp,32
    80002828:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000282a:	0000f517          	auipc	a0,0xf
    8000282e:	68e50513          	addi	a0,a0,1678 # 80011eb8 <bcache>
    80002832:	00004097          	auipc	ra,0x4
    80002836:	d04080e7          	jalr	-764(ra) # 80006536 <acquire>
  b->refcnt++;
    8000283a:	40bc                	lw	a5,64(s1)
    8000283c:	2785                	addiw	a5,a5,1
    8000283e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002840:	0000f517          	auipc	a0,0xf
    80002844:	67850513          	addi	a0,a0,1656 # 80011eb8 <bcache>
    80002848:	00004097          	auipc	ra,0x4
    8000284c:	da2080e7          	jalr	-606(ra) # 800065ea <release>
}
    80002850:	60e2                	ld	ra,24(sp)
    80002852:	6442                	ld	s0,16(sp)
    80002854:	64a2                	ld	s1,8(sp)
    80002856:	6105                	addi	sp,sp,32
    80002858:	8082                	ret

000000008000285a <bunpin>:

void
bunpin(struct buf *b) {
    8000285a:	1101                	addi	sp,sp,-32
    8000285c:	ec06                	sd	ra,24(sp)
    8000285e:	e822                	sd	s0,16(sp)
    80002860:	e426                	sd	s1,8(sp)
    80002862:	1000                	addi	s0,sp,32
    80002864:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002866:	0000f517          	auipc	a0,0xf
    8000286a:	65250513          	addi	a0,a0,1618 # 80011eb8 <bcache>
    8000286e:	00004097          	auipc	ra,0x4
    80002872:	cc8080e7          	jalr	-824(ra) # 80006536 <acquire>
  b->refcnt--;
    80002876:	40bc                	lw	a5,64(s1)
    80002878:	37fd                	addiw	a5,a5,-1
    8000287a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000287c:	0000f517          	auipc	a0,0xf
    80002880:	63c50513          	addi	a0,a0,1596 # 80011eb8 <bcache>
    80002884:	00004097          	auipc	ra,0x4
    80002888:	d66080e7          	jalr	-666(ra) # 800065ea <release>
}
    8000288c:	60e2                	ld	ra,24(sp)
    8000288e:	6442                	ld	s0,16(sp)
    80002890:	64a2                	ld	s1,8(sp)
    80002892:	6105                	addi	sp,sp,32
    80002894:	8082                	ret

0000000080002896 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002896:	1101                	addi	sp,sp,-32
    80002898:	ec06                	sd	ra,24(sp)
    8000289a:	e822                	sd	s0,16(sp)
    8000289c:	e426                	sd	s1,8(sp)
    8000289e:	e04a                	sd	s2,0(sp)
    800028a0:	1000                	addi	s0,sp,32
    800028a2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800028a4:	00d5d59b          	srliw	a1,a1,0xd
    800028a8:	00018797          	auipc	a5,0x18
    800028ac:	cec7a783          	lw	a5,-788(a5) # 8001a594 <sb+0x1c>
    800028b0:	9dbd                	addw	a1,a1,a5
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	da0080e7          	jalr	-608(ra) # 80002652 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028ba:	0074f713          	andi	a4,s1,7
    800028be:	4785                	li	a5,1
    800028c0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028c4:	14ce                	slli	s1,s1,0x33
    800028c6:	90d9                	srli	s1,s1,0x36
    800028c8:	00950733          	add	a4,a0,s1
    800028cc:	05874703          	lbu	a4,88(a4)
    800028d0:	00e7f6b3          	and	a3,a5,a4
    800028d4:	c69d                	beqz	a3,80002902 <bfree+0x6c>
    800028d6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028d8:	94aa                	add	s1,s1,a0
    800028da:	fff7c793          	not	a5,a5
    800028de:	8f7d                	and	a4,a4,a5
    800028e0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028e4:	00001097          	auipc	ra,0x1
    800028e8:	112080e7          	jalr	274(ra) # 800039f6 <log_write>
  brelse(bp);
    800028ec:	854a                	mv	a0,s2
    800028ee:	00000097          	auipc	ra,0x0
    800028f2:	e94080e7          	jalr	-364(ra) # 80002782 <brelse>
}
    800028f6:	60e2                	ld	ra,24(sp)
    800028f8:	6442                	ld	s0,16(sp)
    800028fa:	64a2                	ld	s1,8(sp)
    800028fc:	6902                	ld	s2,0(sp)
    800028fe:	6105                	addi	sp,sp,32
    80002900:	8082                	ret
    panic("freeing free block");
    80002902:	00006517          	auipc	a0,0x6
    80002906:	aae50513          	addi	a0,a0,-1362 # 800083b0 <etext+0x3b0>
    8000290a:	00003097          	auipc	ra,0x3
    8000290e:	6b2080e7          	jalr	1714(ra) # 80005fbc <panic>

0000000080002912 <balloc>:
{
    80002912:	711d                	addi	sp,sp,-96
    80002914:	ec86                	sd	ra,88(sp)
    80002916:	e8a2                	sd	s0,80(sp)
    80002918:	e4a6                	sd	s1,72(sp)
    8000291a:	e0ca                	sd	s2,64(sp)
    8000291c:	fc4e                	sd	s3,56(sp)
    8000291e:	f852                	sd	s4,48(sp)
    80002920:	f456                	sd	s5,40(sp)
    80002922:	f05a                	sd	s6,32(sp)
    80002924:	ec5e                	sd	s7,24(sp)
    80002926:	e862                	sd	s8,16(sp)
    80002928:	e466                	sd	s9,8(sp)
    8000292a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000292c:	00018797          	auipc	a5,0x18
    80002930:	c507a783          	lw	a5,-944(a5) # 8001a57c <sb+0x4>
    80002934:	cbc1                	beqz	a5,800029c4 <balloc+0xb2>
    80002936:	8baa                	mv	s7,a0
    80002938:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000293a:	00018b17          	auipc	s6,0x18
    8000293e:	c3eb0b13          	addi	s6,s6,-962 # 8001a578 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002942:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002944:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002946:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002948:	6c89                	lui	s9,0x2
    8000294a:	a831                	j	80002966 <balloc+0x54>
    brelse(bp);
    8000294c:	854a                	mv	a0,s2
    8000294e:	00000097          	auipc	ra,0x0
    80002952:	e34080e7          	jalr	-460(ra) # 80002782 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002956:	015c87bb          	addw	a5,s9,s5
    8000295a:	00078a9b          	sext.w	s5,a5
    8000295e:	004b2703          	lw	a4,4(s6)
    80002962:	06eaf163          	bgeu	s5,a4,800029c4 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002966:	41fad79b          	sraiw	a5,s5,0x1f
    8000296a:	0137d79b          	srliw	a5,a5,0x13
    8000296e:	015787bb          	addw	a5,a5,s5
    80002972:	40d7d79b          	sraiw	a5,a5,0xd
    80002976:	01cb2583          	lw	a1,28(s6)
    8000297a:	9dbd                	addw	a1,a1,a5
    8000297c:	855e                	mv	a0,s7
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	cd4080e7          	jalr	-812(ra) # 80002652 <bread>
    80002986:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002988:	004b2503          	lw	a0,4(s6)
    8000298c:	000a849b          	sext.w	s1,s5
    80002990:	8762                	mv	a4,s8
    80002992:	faa4fde3          	bgeu	s1,a0,8000294c <balloc+0x3a>
      m = 1 << (bi % 8);
    80002996:	00777693          	andi	a3,a4,7
    8000299a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000299e:	41f7579b          	sraiw	a5,a4,0x1f
    800029a2:	01d7d79b          	srliw	a5,a5,0x1d
    800029a6:	9fb9                	addw	a5,a5,a4
    800029a8:	4037d79b          	sraiw	a5,a5,0x3
    800029ac:	00f90633          	add	a2,s2,a5
    800029b0:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800029b4:	00c6f5b3          	and	a1,a3,a2
    800029b8:	cd91                	beqz	a1,800029d4 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029ba:	2705                	addiw	a4,a4,1
    800029bc:	2485                	addiw	s1,s1,1
    800029be:	fd471ae3          	bne	a4,s4,80002992 <balloc+0x80>
    800029c2:	b769                	j	8000294c <balloc+0x3a>
  panic("balloc: out of blocks");
    800029c4:	00006517          	auipc	a0,0x6
    800029c8:	a0450513          	addi	a0,a0,-1532 # 800083c8 <etext+0x3c8>
    800029cc:	00003097          	auipc	ra,0x3
    800029d0:	5f0080e7          	jalr	1520(ra) # 80005fbc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029d4:	97ca                	add	a5,a5,s2
    800029d6:	8e55                	or	a2,a2,a3
    800029d8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800029dc:	854a                	mv	a0,s2
    800029de:	00001097          	auipc	ra,0x1
    800029e2:	018080e7          	jalr	24(ra) # 800039f6 <log_write>
        brelse(bp);
    800029e6:	854a                	mv	a0,s2
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	d9a080e7          	jalr	-614(ra) # 80002782 <brelse>
  bp = bread(dev, bno);
    800029f0:	85a6                	mv	a1,s1
    800029f2:	855e                	mv	a0,s7
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	c5e080e7          	jalr	-930(ra) # 80002652 <bread>
    800029fc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800029fe:	40000613          	li	a2,1024
    80002a02:	4581                	li	a1,0
    80002a04:	05850513          	addi	a0,a0,88
    80002a08:	ffffe097          	auipc	ra,0xffffe
    80002a0c:	8da080e7          	jalr	-1830(ra) # 800002e2 <memset>
  log_write(bp);
    80002a10:	854a                	mv	a0,s2
    80002a12:	00001097          	auipc	ra,0x1
    80002a16:	fe4080e7          	jalr	-28(ra) # 800039f6 <log_write>
  brelse(bp);
    80002a1a:	854a                	mv	a0,s2
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	d66080e7          	jalr	-666(ra) # 80002782 <brelse>
}
    80002a24:	8526                	mv	a0,s1
    80002a26:	60e6                	ld	ra,88(sp)
    80002a28:	6446                	ld	s0,80(sp)
    80002a2a:	64a6                	ld	s1,72(sp)
    80002a2c:	6906                	ld	s2,64(sp)
    80002a2e:	79e2                	ld	s3,56(sp)
    80002a30:	7a42                	ld	s4,48(sp)
    80002a32:	7aa2                	ld	s5,40(sp)
    80002a34:	7b02                	ld	s6,32(sp)
    80002a36:	6be2                	ld	s7,24(sp)
    80002a38:	6c42                	ld	s8,16(sp)
    80002a3a:	6ca2                	ld	s9,8(sp)
    80002a3c:	6125                	addi	sp,sp,96
    80002a3e:	8082                	ret

0000000080002a40 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a40:	7179                	addi	sp,sp,-48
    80002a42:	f406                	sd	ra,40(sp)
    80002a44:	f022                	sd	s0,32(sp)
    80002a46:	ec26                	sd	s1,24(sp)
    80002a48:	e84a                	sd	s2,16(sp)
    80002a4a:	e44e                	sd	s3,8(sp)
    80002a4c:	1800                	addi	s0,sp,48
    80002a4e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a50:	47ad                	li	a5,11
    80002a52:	04b7ff63          	bgeu	a5,a1,80002ab0 <bmap+0x70>
    80002a56:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a58:	ff45849b          	addiw	s1,a1,-12
    80002a5c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a60:	0ff00793          	li	a5,255
    80002a64:	0ae7e463          	bltu	a5,a4,80002b0c <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a68:	08052583          	lw	a1,128(a0)
    80002a6c:	c5b5                	beqz	a1,80002ad8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a6e:	00092503          	lw	a0,0(s2)
    80002a72:	00000097          	auipc	ra,0x0
    80002a76:	be0080e7          	jalr	-1056(ra) # 80002652 <bread>
    80002a7a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a7c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a80:	02049713          	slli	a4,s1,0x20
    80002a84:	01e75593          	srli	a1,a4,0x1e
    80002a88:	00b784b3          	add	s1,a5,a1
    80002a8c:	0004a983          	lw	s3,0(s1)
    80002a90:	04098e63          	beqz	s3,80002aec <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a94:	8552                	mv	a0,s4
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	cec080e7          	jalr	-788(ra) # 80002782 <brelse>
    return addr;
    80002a9e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002aa0:	854e                	mv	a0,s3
    80002aa2:	70a2                	ld	ra,40(sp)
    80002aa4:	7402                	ld	s0,32(sp)
    80002aa6:	64e2                	ld	s1,24(sp)
    80002aa8:	6942                	ld	s2,16(sp)
    80002aaa:	69a2                	ld	s3,8(sp)
    80002aac:	6145                	addi	sp,sp,48
    80002aae:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002ab0:	02059793          	slli	a5,a1,0x20
    80002ab4:	01e7d593          	srli	a1,a5,0x1e
    80002ab8:	00b504b3          	add	s1,a0,a1
    80002abc:	0504a983          	lw	s3,80(s1)
    80002ac0:	fe0990e3          	bnez	s3,80002aa0 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002ac4:	4108                	lw	a0,0(a0)
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	e4c080e7          	jalr	-436(ra) # 80002912 <balloc>
    80002ace:	0005099b          	sext.w	s3,a0
    80002ad2:	0534a823          	sw	s3,80(s1)
    80002ad6:	b7e9                	j	80002aa0 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002ad8:	4108                	lw	a0,0(a0)
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	e38080e7          	jalr	-456(ra) # 80002912 <balloc>
    80002ae2:	0005059b          	sext.w	a1,a0
    80002ae6:	08b92023          	sw	a1,128(s2)
    80002aea:	b751                	j	80002a6e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002aec:	00092503          	lw	a0,0(s2)
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	e22080e7          	jalr	-478(ra) # 80002912 <balloc>
    80002af8:	0005099b          	sext.w	s3,a0
    80002afc:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002b00:	8552                	mv	a0,s4
    80002b02:	00001097          	auipc	ra,0x1
    80002b06:	ef4080e7          	jalr	-268(ra) # 800039f6 <log_write>
    80002b0a:	b769                	j	80002a94 <bmap+0x54>
  panic("bmap: out of range");
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	8d450513          	addi	a0,a0,-1836 # 800083e0 <etext+0x3e0>
    80002b14:	00003097          	auipc	ra,0x3
    80002b18:	4a8080e7          	jalr	1192(ra) # 80005fbc <panic>

0000000080002b1c <iget>:
{
    80002b1c:	7179                	addi	sp,sp,-48
    80002b1e:	f406                	sd	ra,40(sp)
    80002b20:	f022                	sd	s0,32(sp)
    80002b22:	ec26                	sd	s1,24(sp)
    80002b24:	e84a                	sd	s2,16(sp)
    80002b26:	e44e                	sd	s3,8(sp)
    80002b28:	e052                	sd	s4,0(sp)
    80002b2a:	1800                	addi	s0,sp,48
    80002b2c:	89aa                	mv	s3,a0
    80002b2e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b30:	00018517          	auipc	a0,0x18
    80002b34:	a6850513          	addi	a0,a0,-1432 # 8001a598 <itable>
    80002b38:	00004097          	auipc	ra,0x4
    80002b3c:	9fe080e7          	jalr	-1538(ra) # 80006536 <acquire>
  empty = 0;
    80002b40:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b42:	00018497          	auipc	s1,0x18
    80002b46:	a6e48493          	addi	s1,s1,-1426 # 8001a5b0 <itable+0x18>
    80002b4a:	00019697          	auipc	a3,0x19
    80002b4e:	4f668693          	addi	a3,a3,1270 # 8001c040 <log>
    80002b52:	a039                	j	80002b60 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b54:	02090b63          	beqz	s2,80002b8a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b58:	08848493          	addi	s1,s1,136
    80002b5c:	02d48a63          	beq	s1,a3,80002b90 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b60:	449c                	lw	a5,8(s1)
    80002b62:	fef059e3          	blez	a5,80002b54 <iget+0x38>
    80002b66:	4098                	lw	a4,0(s1)
    80002b68:	ff3716e3          	bne	a4,s3,80002b54 <iget+0x38>
    80002b6c:	40d8                	lw	a4,4(s1)
    80002b6e:	ff4713e3          	bne	a4,s4,80002b54 <iget+0x38>
      ip->ref++;
    80002b72:	2785                	addiw	a5,a5,1
    80002b74:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b76:	00018517          	auipc	a0,0x18
    80002b7a:	a2250513          	addi	a0,a0,-1502 # 8001a598 <itable>
    80002b7e:	00004097          	auipc	ra,0x4
    80002b82:	a6c080e7          	jalr	-1428(ra) # 800065ea <release>
      return ip;
    80002b86:	8926                	mv	s2,s1
    80002b88:	a03d                	j	80002bb6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b8a:	f7f9                	bnez	a5,80002b58 <iget+0x3c>
      empty = ip;
    80002b8c:	8926                	mv	s2,s1
    80002b8e:	b7e9                	j	80002b58 <iget+0x3c>
  if(empty == 0)
    80002b90:	02090c63          	beqz	s2,80002bc8 <iget+0xac>
  ip->dev = dev;
    80002b94:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b98:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b9c:	4785                	li	a5,1
    80002b9e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ba2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ba6:	00018517          	auipc	a0,0x18
    80002baa:	9f250513          	addi	a0,a0,-1550 # 8001a598 <itable>
    80002bae:	00004097          	auipc	ra,0x4
    80002bb2:	a3c080e7          	jalr	-1476(ra) # 800065ea <release>
}
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	70a2                	ld	ra,40(sp)
    80002bba:	7402                	ld	s0,32(sp)
    80002bbc:	64e2                	ld	s1,24(sp)
    80002bbe:	6942                	ld	s2,16(sp)
    80002bc0:	69a2                	ld	s3,8(sp)
    80002bc2:	6a02                	ld	s4,0(sp)
    80002bc4:	6145                	addi	sp,sp,48
    80002bc6:	8082                	ret
    panic("iget: no inodes");
    80002bc8:	00006517          	auipc	a0,0x6
    80002bcc:	83050513          	addi	a0,a0,-2000 # 800083f8 <etext+0x3f8>
    80002bd0:	00003097          	auipc	ra,0x3
    80002bd4:	3ec080e7          	jalr	1004(ra) # 80005fbc <panic>

0000000080002bd8 <fsinit>:
fsinit(int dev) {
    80002bd8:	7179                	addi	sp,sp,-48
    80002bda:	f406                	sd	ra,40(sp)
    80002bdc:	f022                	sd	s0,32(sp)
    80002bde:	ec26                	sd	s1,24(sp)
    80002be0:	e84a                	sd	s2,16(sp)
    80002be2:	e44e                	sd	s3,8(sp)
    80002be4:	1800                	addi	s0,sp,48
    80002be6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002be8:	4585                	li	a1,1
    80002bea:	00000097          	auipc	ra,0x0
    80002bee:	a68080e7          	jalr	-1432(ra) # 80002652 <bread>
    80002bf2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bf4:	00018997          	auipc	s3,0x18
    80002bf8:	98498993          	addi	s3,s3,-1660 # 8001a578 <sb>
    80002bfc:	02000613          	li	a2,32
    80002c00:	05850593          	addi	a1,a0,88
    80002c04:	854e                	mv	a0,s3
    80002c06:	ffffd097          	auipc	ra,0xffffd
    80002c0a:	738080e7          	jalr	1848(ra) # 8000033e <memmove>
  brelse(bp);
    80002c0e:	8526                	mv	a0,s1
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	b72080e7          	jalr	-1166(ra) # 80002782 <brelse>
  if(sb.magic != FSMAGIC)
    80002c18:	0009a703          	lw	a4,0(s3)
    80002c1c:	102037b7          	lui	a5,0x10203
    80002c20:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c24:	02f71263          	bne	a4,a5,80002c48 <fsinit+0x70>
  initlog(dev, &sb);
    80002c28:	00018597          	auipc	a1,0x18
    80002c2c:	95058593          	addi	a1,a1,-1712 # 8001a578 <sb>
    80002c30:	854a                	mv	a0,s2
    80002c32:	00001097          	auipc	ra,0x1
    80002c36:	b54080e7          	jalr	-1196(ra) # 80003786 <initlog>
}
    80002c3a:	70a2                	ld	ra,40(sp)
    80002c3c:	7402                	ld	s0,32(sp)
    80002c3e:	64e2                	ld	s1,24(sp)
    80002c40:	6942                	ld	s2,16(sp)
    80002c42:	69a2                	ld	s3,8(sp)
    80002c44:	6145                	addi	sp,sp,48
    80002c46:	8082                	ret
    panic("invalid file system");
    80002c48:	00005517          	auipc	a0,0x5
    80002c4c:	7c050513          	addi	a0,a0,1984 # 80008408 <etext+0x408>
    80002c50:	00003097          	auipc	ra,0x3
    80002c54:	36c080e7          	jalr	876(ra) # 80005fbc <panic>

0000000080002c58 <iinit>:
{
    80002c58:	7179                	addi	sp,sp,-48
    80002c5a:	f406                	sd	ra,40(sp)
    80002c5c:	f022                	sd	s0,32(sp)
    80002c5e:	ec26                	sd	s1,24(sp)
    80002c60:	e84a                	sd	s2,16(sp)
    80002c62:	e44e                	sd	s3,8(sp)
    80002c64:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c66:	00005597          	auipc	a1,0x5
    80002c6a:	7ba58593          	addi	a1,a1,1978 # 80008420 <etext+0x420>
    80002c6e:	00018517          	auipc	a0,0x18
    80002c72:	92a50513          	addi	a0,a0,-1750 # 8001a598 <itable>
    80002c76:	00004097          	auipc	ra,0x4
    80002c7a:	830080e7          	jalr	-2000(ra) # 800064a6 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c7e:	00018497          	auipc	s1,0x18
    80002c82:	94248493          	addi	s1,s1,-1726 # 8001a5c0 <itable+0x28>
    80002c86:	00019997          	auipc	s3,0x19
    80002c8a:	3ca98993          	addi	s3,s3,970 # 8001c050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c8e:	00005917          	auipc	s2,0x5
    80002c92:	79a90913          	addi	s2,s2,1946 # 80008428 <etext+0x428>
    80002c96:	85ca                	mv	a1,s2
    80002c98:	8526                	mv	a0,s1
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	e40080e7          	jalr	-448(ra) # 80003ada <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ca2:	08848493          	addi	s1,s1,136
    80002ca6:	ff3498e3          	bne	s1,s3,80002c96 <iinit+0x3e>
}
    80002caa:	70a2                	ld	ra,40(sp)
    80002cac:	7402                	ld	s0,32(sp)
    80002cae:	64e2                	ld	s1,24(sp)
    80002cb0:	6942                	ld	s2,16(sp)
    80002cb2:	69a2                	ld	s3,8(sp)
    80002cb4:	6145                	addi	sp,sp,48
    80002cb6:	8082                	ret

0000000080002cb8 <ialloc>:
{
    80002cb8:	7139                	addi	sp,sp,-64
    80002cba:	fc06                	sd	ra,56(sp)
    80002cbc:	f822                	sd	s0,48(sp)
    80002cbe:	f426                	sd	s1,40(sp)
    80002cc0:	f04a                	sd	s2,32(sp)
    80002cc2:	ec4e                	sd	s3,24(sp)
    80002cc4:	e852                	sd	s4,16(sp)
    80002cc6:	e456                	sd	s5,8(sp)
    80002cc8:	e05a                	sd	s6,0(sp)
    80002cca:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ccc:	00018717          	auipc	a4,0x18
    80002cd0:	8b872703          	lw	a4,-1864(a4) # 8001a584 <sb+0xc>
    80002cd4:	4785                	li	a5,1
    80002cd6:	04e7f863          	bgeu	a5,a4,80002d26 <ialloc+0x6e>
    80002cda:	8aaa                	mv	s5,a0
    80002cdc:	8b2e                	mv	s6,a1
    80002cde:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ce0:	00018a17          	auipc	s4,0x18
    80002ce4:	898a0a13          	addi	s4,s4,-1896 # 8001a578 <sb>
    80002ce8:	00495593          	srli	a1,s2,0x4
    80002cec:	018a2783          	lw	a5,24(s4)
    80002cf0:	9dbd                	addw	a1,a1,a5
    80002cf2:	8556                	mv	a0,s5
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	95e080e7          	jalr	-1698(ra) # 80002652 <bread>
    80002cfc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cfe:	05850993          	addi	s3,a0,88
    80002d02:	00f97793          	andi	a5,s2,15
    80002d06:	079a                	slli	a5,a5,0x6
    80002d08:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d0a:	00099783          	lh	a5,0(s3)
    80002d0e:	c785                	beqz	a5,80002d36 <ialloc+0x7e>
    brelse(bp);
    80002d10:	00000097          	auipc	ra,0x0
    80002d14:	a72080e7          	jalr	-1422(ra) # 80002782 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d18:	0905                	addi	s2,s2,1
    80002d1a:	00ca2703          	lw	a4,12(s4)
    80002d1e:	0009079b          	sext.w	a5,s2
    80002d22:	fce7e3e3          	bltu	a5,a4,80002ce8 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002d26:	00005517          	auipc	a0,0x5
    80002d2a:	70a50513          	addi	a0,a0,1802 # 80008430 <etext+0x430>
    80002d2e:	00003097          	auipc	ra,0x3
    80002d32:	28e080e7          	jalr	654(ra) # 80005fbc <panic>
      memset(dip, 0, sizeof(*dip));
    80002d36:	04000613          	li	a2,64
    80002d3a:	4581                	li	a1,0
    80002d3c:	854e                	mv	a0,s3
    80002d3e:	ffffd097          	auipc	ra,0xffffd
    80002d42:	5a4080e7          	jalr	1444(ra) # 800002e2 <memset>
      dip->type = type;
    80002d46:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d4a:	8526                	mv	a0,s1
    80002d4c:	00001097          	auipc	ra,0x1
    80002d50:	caa080e7          	jalr	-854(ra) # 800039f6 <log_write>
      brelse(bp);
    80002d54:	8526                	mv	a0,s1
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	a2c080e7          	jalr	-1492(ra) # 80002782 <brelse>
      return iget(dev, inum);
    80002d5e:	0009059b          	sext.w	a1,s2
    80002d62:	8556                	mv	a0,s5
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	db8080e7          	jalr	-584(ra) # 80002b1c <iget>
}
    80002d6c:	70e2                	ld	ra,56(sp)
    80002d6e:	7442                	ld	s0,48(sp)
    80002d70:	74a2                	ld	s1,40(sp)
    80002d72:	7902                	ld	s2,32(sp)
    80002d74:	69e2                	ld	s3,24(sp)
    80002d76:	6a42                	ld	s4,16(sp)
    80002d78:	6aa2                	ld	s5,8(sp)
    80002d7a:	6b02                	ld	s6,0(sp)
    80002d7c:	6121                	addi	sp,sp,64
    80002d7e:	8082                	ret

0000000080002d80 <iupdate>:
{
    80002d80:	1101                	addi	sp,sp,-32
    80002d82:	ec06                	sd	ra,24(sp)
    80002d84:	e822                	sd	s0,16(sp)
    80002d86:	e426                	sd	s1,8(sp)
    80002d88:	e04a                	sd	s2,0(sp)
    80002d8a:	1000                	addi	s0,sp,32
    80002d8c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d8e:	415c                	lw	a5,4(a0)
    80002d90:	0047d79b          	srliw	a5,a5,0x4
    80002d94:	00017597          	auipc	a1,0x17
    80002d98:	7fc5a583          	lw	a1,2044(a1) # 8001a590 <sb+0x18>
    80002d9c:	9dbd                	addw	a1,a1,a5
    80002d9e:	4108                	lw	a0,0(a0)
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	8b2080e7          	jalr	-1870(ra) # 80002652 <bread>
    80002da8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002daa:	05850793          	addi	a5,a0,88
    80002dae:	40d8                	lw	a4,4(s1)
    80002db0:	8b3d                	andi	a4,a4,15
    80002db2:	071a                	slli	a4,a4,0x6
    80002db4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002db6:	04449703          	lh	a4,68(s1)
    80002dba:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002dbe:	04649703          	lh	a4,70(s1)
    80002dc2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002dc6:	04849703          	lh	a4,72(s1)
    80002dca:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dce:	04a49703          	lh	a4,74(s1)
    80002dd2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002dd6:	44f8                	lw	a4,76(s1)
    80002dd8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dda:	03400613          	li	a2,52
    80002dde:	05048593          	addi	a1,s1,80
    80002de2:	00c78513          	addi	a0,a5,12
    80002de6:	ffffd097          	auipc	ra,0xffffd
    80002dea:	558080e7          	jalr	1368(ra) # 8000033e <memmove>
  log_write(bp);
    80002dee:	854a                	mv	a0,s2
    80002df0:	00001097          	auipc	ra,0x1
    80002df4:	c06080e7          	jalr	-1018(ra) # 800039f6 <log_write>
  brelse(bp);
    80002df8:	854a                	mv	a0,s2
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	988080e7          	jalr	-1656(ra) # 80002782 <brelse>
}
    80002e02:	60e2                	ld	ra,24(sp)
    80002e04:	6442                	ld	s0,16(sp)
    80002e06:	64a2                	ld	s1,8(sp)
    80002e08:	6902                	ld	s2,0(sp)
    80002e0a:	6105                	addi	sp,sp,32
    80002e0c:	8082                	ret

0000000080002e0e <idup>:
{
    80002e0e:	1101                	addi	sp,sp,-32
    80002e10:	ec06                	sd	ra,24(sp)
    80002e12:	e822                	sd	s0,16(sp)
    80002e14:	e426                	sd	s1,8(sp)
    80002e16:	1000                	addi	s0,sp,32
    80002e18:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e1a:	00017517          	auipc	a0,0x17
    80002e1e:	77e50513          	addi	a0,a0,1918 # 8001a598 <itable>
    80002e22:	00003097          	auipc	ra,0x3
    80002e26:	714080e7          	jalr	1812(ra) # 80006536 <acquire>
  ip->ref++;
    80002e2a:	449c                	lw	a5,8(s1)
    80002e2c:	2785                	addiw	a5,a5,1
    80002e2e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e30:	00017517          	auipc	a0,0x17
    80002e34:	76850513          	addi	a0,a0,1896 # 8001a598 <itable>
    80002e38:	00003097          	auipc	ra,0x3
    80002e3c:	7b2080e7          	jalr	1970(ra) # 800065ea <release>
}
    80002e40:	8526                	mv	a0,s1
    80002e42:	60e2                	ld	ra,24(sp)
    80002e44:	6442                	ld	s0,16(sp)
    80002e46:	64a2                	ld	s1,8(sp)
    80002e48:	6105                	addi	sp,sp,32
    80002e4a:	8082                	ret

0000000080002e4c <ilock>:
{
    80002e4c:	1101                	addi	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	e426                	sd	s1,8(sp)
    80002e54:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e56:	c10d                	beqz	a0,80002e78 <ilock+0x2c>
    80002e58:	84aa                	mv	s1,a0
    80002e5a:	451c                	lw	a5,8(a0)
    80002e5c:	00f05e63          	blez	a5,80002e78 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002e60:	0541                	addi	a0,a0,16
    80002e62:	00001097          	auipc	ra,0x1
    80002e66:	cb2080e7          	jalr	-846(ra) # 80003b14 <acquiresleep>
  if(ip->valid == 0){
    80002e6a:	40bc                	lw	a5,64(s1)
    80002e6c:	cf99                	beqz	a5,80002e8a <ilock+0x3e>
}
    80002e6e:	60e2                	ld	ra,24(sp)
    80002e70:	6442                	ld	s0,16(sp)
    80002e72:	64a2                	ld	s1,8(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret
    80002e78:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e7a:	00005517          	auipc	a0,0x5
    80002e7e:	5ce50513          	addi	a0,a0,1486 # 80008448 <etext+0x448>
    80002e82:	00003097          	auipc	ra,0x3
    80002e86:	13a080e7          	jalr	314(ra) # 80005fbc <panic>
    80002e8a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e8c:	40dc                	lw	a5,4(s1)
    80002e8e:	0047d79b          	srliw	a5,a5,0x4
    80002e92:	00017597          	auipc	a1,0x17
    80002e96:	6fe5a583          	lw	a1,1790(a1) # 8001a590 <sb+0x18>
    80002e9a:	9dbd                	addw	a1,a1,a5
    80002e9c:	4088                	lw	a0,0(s1)
    80002e9e:	fffff097          	auipc	ra,0xfffff
    80002ea2:	7b4080e7          	jalr	1972(ra) # 80002652 <bread>
    80002ea6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ea8:	05850593          	addi	a1,a0,88
    80002eac:	40dc                	lw	a5,4(s1)
    80002eae:	8bbd                	andi	a5,a5,15
    80002eb0:	079a                	slli	a5,a5,0x6
    80002eb2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002eb4:	00059783          	lh	a5,0(a1)
    80002eb8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ebc:	00259783          	lh	a5,2(a1)
    80002ec0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ec4:	00459783          	lh	a5,4(a1)
    80002ec8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ecc:	00659783          	lh	a5,6(a1)
    80002ed0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ed4:	459c                	lw	a5,8(a1)
    80002ed6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ed8:	03400613          	li	a2,52
    80002edc:	05b1                	addi	a1,a1,12
    80002ede:	05048513          	addi	a0,s1,80
    80002ee2:	ffffd097          	auipc	ra,0xffffd
    80002ee6:	45c080e7          	jalr	1116(ra) # 8000033e <memmove>
    brelse(bp);
    80002eea:	854a                	mv	a0,s2
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	896080e7          	jalr	-1898(ra) # 80002782 <brelse>
    ip->valid = 1;
    80002ef4:	4785                	li	a5,1
    80002ef6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ef8:	04449783          	lh	a5,68(s1)
    80002efc:	c399                	beqz	a5,80002f02 <ilock+0xb6>
    80002efe:	6902                	ld	s2,0(sp)
    80002f00:	b7bd                	j	80002e6e <ilock+0x22>
      panic("ilock: no type");
    80002f02:	00005517          	auipc	a0,0x5
    80002f06:	54e50513          	addi	a0,a0,1358 # 80008450 <etext+0x450>
    80002f0a:	00003097          	auipc	ra,0x3
    80002f0e:	0b2080e7          	jalr	178(ra) # 80005fbc <panic>

0000000080002f12 <iunlock>:
{
    80002f12:	1101                	addi	sp,sp,-32
    80002f14:	ec06                	sd	ra,24(sp)
    80002f16:	e822                	sd	s0,16(sp)
    80002f18:	e426                	sd	s1,8(sp)
    80002f1a:	e04a                	sd	s2,0(sp)
    80002f1c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f1e:	c905                	beqz	a0,80002f4e <iunlock+0x3c>
    80002f20:	84aa                	mv	s1,a0
    80002f22:	01050913          	addi	s2,a0,16
    80002f26:	854a                	mv	a0,s2
    80002f28:	00001097          	auipc	ra,0x1
    80002f2c:	c86080e7          	jalr	-890(ra) # 80003bae <holdingsleep>
    80002f30:	cd19                	beqz	a0,80002f4e <iunlock+0x3c>
    80002f32:	449c                	lw	a5,8(s1)
    80002f34:	00f05d63          	blez	a5,80002f4e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	00001097          	auipc	ra,0x1
    80002f3e:	c30080e7          	jalr	-976(ra) # 80003b6a <releasesleep>
}
    80002f42:	60e2                	ld	ra,24(sp)
    80002f44:	6442                	ld	s0,16(sp)
    80002f46:	64a2                	ld	s1,8(sp)
    80002f48:	6902                	ld	s2,0(sp)
    80002f4a:	6105                	addi	sp,sp,32
    80002f4c:	8082                	ret
    panic("iunlock");
    80002f4e:	00005517          	auipc	a0,0x5
    80002f52:	51250513          	addi	a0,a0,1298 # 80008460 <etext+0x460>
    80002f56:	00003097          	auipc	ra,0x3
    80002f5a:	066080e7          	jalr	102(ra) # 80005fbc <panic>

0000000080002f5e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f5e:	7179                	addi	sp,sp,-48
    80002f60:	f406                	sd	ra,40(sp)
    80002f62:	f022                	sd	s0,32(sp)
    80002f64:	ec26                	sd	s1,24(sp)
    80002f66:	e84a                	sd	s2,16(sp)
    80002f68:	e44e                	sd	s3,8(sp)
    80002f6a:	1800                	addi	s0,sp,48
    80002f6c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f6e:	05050493          	addi	s1,a0,80
    80002f72:	08050913          	addi	s2,a0,128
    80002f76:	a021                	j	80002f7e <itrunc+0x20>
    80002f78:	0491                	addi	s1,s1,4
    80002f7a:	01248d63          	beq	s1,s2,80002f94 <itrunc+0x36>
    if(ip->addrs[i]){
    80002f7e:	408c                	lw	a1,0(s1)
    80002f80:	dde5                	beqz	a1,80002f78 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002f82:	0009a503          	lw	a0,0(s3)
    80002f86:	00000097          	auipc	ra,0x0
    80002f8a:	910080e7          	jalr	-1776(ra) # 80002896 <bfree>
      ip->addrs[i] = 0;
    80002f8e:	0004a023          	sw	zero,0(s1)
    80002f92:	b7dd                	j	80002f78 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f94:	0809a583          	lw	a1,128(s3)
    80002f98:	ed99                	bnez	a1,80002fb6 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f9a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f9e:	854e                	mv	a0,s3
    80002fa0:	00000097          	auipc	ra,0x0
    80002fa4:	de0080e7          	jalr	-544(ra) # 80002d80 <iupdate>
}
    80002fa8:	70a2                	ld	ra,40(sp)
    80002faa:	7402                	ld	s0,32(sp)
    80002fac:	64e2                	ld	s1,24(sp)
    80002fae:	6942                	ld	s2,16(sp)
    80002fb0:	69a2                	ld	s3,8(sp)
    80002fb2:	6145                	addi	sp,sp,48
    80002fb4:	8082                	ret
    80002fb6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fb8:	0009a503          	lw	a0,0(s3)
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	696080e7          	jalr	1686(ra) # 80002652 <bread>
    80002fc4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fc6:	05850493          	addi	s1,a0,88
    80002fca:	45850913          	addi	s2,a0,1112
    80002fce:	a021                	j	80002fd6 <itrunc+0x78>
    80002fd0:	0491                	addi	s1,s1,4
    80002fd2:	01248b63          	beq	s1,s2,80002fe8 <itrunc+0x8a>
      if(a[j])
    80002fd6:	408c                	lw	a1,0(s1)
    80002fd8:	dde5                	beqz	a1,80002fd0 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002fda:	0009a503          	lw	a0,0(s3)
    80002fde:	00000097          	auipc	ra,0x0
    80002fe2:	8b8080e7          	jalr	-1864(ra) # 80002896 <bfree>
    80002fe6:	b7ed                	j	80002fd0 <itrunc+0x72>
    brelse(bp);
    80002fe8:	8552                	mv	a0,s4
    80002fea:	fffff097          	auipc	ra,0xfffff
    80002fee:	798080e7          	jalr	1944(ra) # 80002782 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ff2:	0809a583          	lw	a1,128(s3)
    80002ff6:	0009a503          	lw	a0,0(s3)
    80002ffa:	00000097          	auipc	ra,0x0
    80002ffe:	89c080e7          	jalr	-1892(ra) # 80002896 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003002:	0809a023          	sw	zero,128(s3)
    80003006:	6a02                	ld	s4,0(sp)
    80003008:	bf49                	j	80002f9a <itrunc+0x3c>

000000008000300a <iput>:
{
    8000300a:	1101                	addi	sp,sp,-32
    8000300c:	ec06                	sd	ra,24(sp)
    8000300e:	e822                	sd	s0,16(sp)
    80003010:	e426                	sd	s1,8(sp)
    80003012:	1000                	addi	s0,sp,32
    80003014:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003016:	00017517          	auipc	a0,0x17
    8000301a:	58250513          	addi	a0,a0,1410 # 8001a598 <itable>
    8000301e:	00003097          	auipc	ra,0x3
    80003022:	518080e7          	jalr	1304(ra) # 80006536 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003026:	4498                	lw	a4,8(s1)
    80003028:	4785                	li	a5,1
    8000302a:	02f70263          	beq	a4,a5,8000304e <iput+0x44>
  ip->ref--;
    8000302e:	449c                	lw	a5,8(s1)
    80003030:	37fd                	addiw	a5,a5,-1
    80003032:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003034:	00017517          	auipc	a0,0x17
    80003038:	56450513          	addi	a0,a0,1380 # 8001a598 <itable>
    8000303c:	00003097          	auipc	ra,0x3
    80003040:	5ae080e7          	jalr	1454(ra) # 800065ea <release>
}
    80003044:	60e2                	ld	ra,24(sp)
    80003046:	6442                	ld	s0,16(sp)
    80003048:	64a2                	ld	s1,8(sp)
    8000304a:	6105                	addi	sp,sp,32
    8000304c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000304e:	40bc                	lw	a5,64(s1)
    80003050:	dff9                	beqz	a5,8000302e <iput+0x24>
    80003052:	04a49783          	lh	a5,74(s1)
    80003056:	ffe1                	bnez	a5,8000302e <iput+0x24>
    80003058:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000305a:	01048913          	addi	s2,s1,16
    8000305e:	854a                	mv	a0,s2
    80003060:	00001097          	auipc	ra,0x1
    80003064:	ab4080e7          	jalr	-1356(ra) # 80003b14 <acquiresleep>
    release(&itable.lock);
    80003068:	00017517          	auipc	a0,0x17
    8000306c:	53050513          	addi	a0,a0,1328 # 8001a598 <itable>
    80003070:	00003097          	auipc	ra,0x3
    80003074:	57a080e7          	jalr	1402(ra) # 800065ea <release>
    itrunc(ip);
    80003078:	8526                	mv	a0,s1
    8000307a:	00000097          	auipc	ra,0x0
    8000307e:	ee4080e7          	jalr	-284(ra) # 80002f5e <itrunc>
    ip->type = 0;
    80003082:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003086:	8526                	mv	a0,s1
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	cf8080e7          	jalr	-776(ra) # 80002d80 <iupdate>
    ip->valid = 0;
    80003090:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003094:	854a                	mv	a0,s2
    80003096:	00001097          	auipc	ra,0x1
    8000309a:	ad4080e7          	jalr	-1324(ra) # 80003b6a <releasesleep>
    acquire(&itable.lock);
    8000309e:	00017517          	auipc	a0,0x17
    800030a2:	4fa50513          	addi	a0,a0,1274 # 8001a598 <itable>
    800030a6:	00003097          	auipc	ra,0x3
    800030aa:	490080e7          	jalr	1168(ra) # 80006536 <acquire>
    800030ae:	6902                	ld	s2,0(sp)
    800030b0:	bfbd                	j	8000302e <iput+0x24>

00000000800030b2 <iunlockput>:
{
    800030b2:	1101                	addi	sp,sp,-32
    800030b4:	ec06                	sd	ra,24(sp)
    800030b6:	e822                	sd	s0,16(sp)
    800030b8:	e426                	sd	s1,8(sp)
    800030ba:	1000                	addi	s0,sp,32
    800030bc:	84aa                	mv	s1,a0
  iunlock(ip);
    800030be:	00000097          	auipc	ra,0x0
    800030c2:	e54080e7          	jalr	-428(ra) # 80002f12 <iunlock>
  iput(ip);
    800030c6:	8526                	mv	a0,s1
    800030c8:	00000097          	auipc	ra,0x0
    800030cc:	f42080e7          	jalr	-190(ra) # 8000300a <iput>
}
    800030d0:	60e2                	ld	ra,24(sp)
    800030d2:	6442                	ld	s0,16(sp)
    800030d4:	64a2                	ld	s1,8(sp)
    800030d6:	6105                	addi	sp,sp,32
    800030d8:	8082                	ret

00000000800030da <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030da:	1141                	addi	sp,sp,-16
    800030dc:	e422                	sd	s0,8(sp)
    800030de:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030e0:	411c                	lw	a5,0(a0)
    800030e2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030e4:	415c                	lw	a5,4(a0)
    800030e6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030e8:	04451783          	lh	a5,68(a0)
    800030ec:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030f0:	04a51783          	lh	a5,74(a0)
    800030f4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030f8:	04c56783          	lwu	a5,76(a0)
    800030fc:	e99c                	sd	a5,16(a1)
}
    800030fe:	6422                	ld	s0,8(sp)
    80003100:	0141                	addi	sp,sp,16
    80003102:	8082                	ret

0000000080003104 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003104:	457c                	lw	a5,76(a0)
    80003106:	0ed7ef63          	bltu	a5,a3,80003204 <readi+0x100>
{
    8000310a:	7159                	addi	sp,sp,-112
    8000310c:	f486                	sd	ra,104(sp)
    8000310e:	f0a2                	sd	s0,96(sp)
    80003110:	eca6                	sd	s1,88(sp)
    80003112:	fc56                	sd	s5,56(sp)
    80003114:	f85a                	sd	s6,48(sp)
    80003116:	f45e                	sd	s7,40(sp)
    80003118:	f062                	sd	s8,32(sp)
    8000311a:	1880                	addi	s0,sp,112
    8000311c:	8baa                	mv	s7,a0
    8000311e:	8c2e                	mv	s8,a1
    80003120:	8ab2                	mv	s5,a2
    80003122:	84b6                	mv	s1,a3
    80003124:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003126:	9f35                	addw	a4,a4,a3
    return 0;
    80003128:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000312a:	0ad76c63          	bltu	a4,a3,800031e2 <readi+0xde>
    8000312e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003130:	00e7f463          	bgeu	a5,a4,80003138 <readi+0x34>
    n = ip->size - off;
    80003134:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003138:	0c0b0463          	beqz	s6,80003200 <readi+0xfc>
    8000313c:	e8ca                	sd	s2,80(sp)
    8000313e:	e0d2                	sd	s4,64(sp)
    80003140:	ec66                	sd	s9,24(sp)
    80003142:	e86a                	sd	s10,16(sp)
    80003144:	e46e                	sd	s11,8(sp)
    80003146:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003148:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000314c:	5cfd                	li	s9,-1
    8000314e:	a82d                	j	80003188 <readi+0x84>
    80003150:	020a1d93          	slli	s11,s4,0x20
    80003154:	020ddd93          	srli	s11,s11,0x20
    80003158:	05890613          	addi	a2,s2,88
    8000315c:	86ee                	mv	a3,s11
    8000315e:	963a                	add	a2,a2,a4
    80003160:	85d6                	mv	a1,s5
    80003162:	8562                	mv	a0,s8
    80003164:	fffff097          	auipc	ra,0xfffff
    80003168:	a10080e7          	jalr	-1520(ra) # 80001b74 <either_copyout>
    8000316c:	05950d63          	beq	a0,s9,800031c6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003170:	854a                	mv	a0,s2
    80003172:	fffff097          	auipc	ra,0xfffff
    80003176:	610080e7          	jalr	1552(ra) # 80002782 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000317a:	013a09bb          	addw	s3,s4,s3
    8000317e:	009a04bb          	addw	s1,s4,s1
    80003182:	9aee                	add	s5,s5,s11
    80003184:	0769f863          	bgeu	s3,s6,800031f4 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003188:	000ba903          	lw	s2,0(s7)
    8000318c:	00a4d59b          	srliw	a1,s1,0xa
    80003190:	855e                	mv	a0,s7
    80003192:	00000097          	auipc	ra,0x0
    80003196:	8ae080e7          	jalr	-1874(ra) # 80002a40 <bmap>
    8000319a:	0005059b          	sext.w	a1,a0
    8000319e:	854a                	mv	a0,s2
    800031a0:	fffff097          	auipc	ra,0xfffff
    800031a4:	4b2080e7          	jalr	1202(ra) # 80002652 <bread>
    800031a8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031aa:	3ff4f713          	andi	a4,s1,1023
    800031ae:	40ed07bb          	subw	a5,s10,a4
    800031b2:	413b06bb          	subw	a3,s6,s3
    800031b6:	8a3e                	mv	s4,a5
    800031b8:	2781                	sext.w	a5,a5
    800031ba:	0006861b          	sext.w	a2,a3
    800031be:	f8f679e3          	bgeu	a2,a5,80003150 <readi+0x4c>
    800031c2:	8a36                	mv	s4,a3
    800031c4:	b771                	j	80003150 <readi+0x4c>
      brelse(bp);
    800031c6:	854a                	mv	a0,s2
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	5ba080e7          	jalr	1466(ra) # 80002782 <brelse>
      tot = -1;
    800031d0:	59fd                	li	s3,-1
      break;
    800031d2:	6946                	ld	s2,80(sp)
    800031d4:	6a06                	ld	s4,64(sp)
    800031d6:	6ce2                	ld	s9,24(sp)
    800031d8:	6d42                	ld	s10,16(sp)
    800031da:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800031dc:	0009851b          	sext.w	a0,s3
    800031e0:	69a6                	ld	s3,72(sp)
}
    800031e2:	70a6                	ld	ra,104(sp)
    800031e4:	7406                	ld	s0,96(sp)
    800031e6:	64e6                	ld	s1,88(sp)
    800031e8:	7ae2                	ld	s5,56(sp)
    800031ea:	7b42                	ld	s6,48(sp)
    800031ec:	7ba2                	ld	s7,40(sp)
    800031ee:	7c02                	ld	s8,32(sp)
    800031f0:	6165                	addi	sp,sp,112
    800031f2:	8082                	ret
    800031f4:	6946                	ld	s2,80(sp)
    800031f6:	6a06                	ld	s4,64(sp)
    800031f8:	6ce2                	ld	s9,24(sp)
    800031fa:	6d42                	ld	s10,16(sp)
    800031fc:	6da2                	ld	s11,8(sp)
    800031fe:	bff9                	j	800031dc <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003200:	89da                	mv	s3,s6
    80003202:	bfe9                	j	800031dc <readi+0xd8>
    return 0;
    80003204:	4501                	li	a0,0
}
    80003206:	8082                	ret

0000000080003208 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003208:	457c                	lw	a5,76(a0)
    8000320a:	10d7ee63          	bltu	a5,a3,80003326 <writei+0x11e>
{
    8000320e:	7159                	addi	sp,sp,-112
    80003210:	f486                	sd	ra,104(sp)
    80003212:	f0a2                	sd	s0,96(sp)
    80003214:	e8ca                	sd	s2,80(sp)
    80003216:	fc56                	sd	s5,56(sp)
    80003218:	f85a                	sd	s6,48(sp)
    8000321a:	f45e                	sd	s7,40(sp)
    8000321c:	f062                	sd	s8,32(sp)
    8000321e:	1880                	addi	s0,sp,112
    80003220:	8b2a                	mv	s6,a0
    80003222:	8c2e                	mv	s8,a1
    80003224:	8ab2                	mv	s5,a2
    80003226:	8936                	mv	s2,a3
    80003228:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000322a:	00e687bb          	addw	a5,a3,a4
    8000322e:	0ed7ee63          	bltu	a5,a3,8000332a <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003232:	00043737          	lui	a4,0x43
    80003236:	0ef76c63          	bltu	a4,a5,8000332e <writei+0x126>
    8000323a:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000323c:	0c0b8d63          	beqz	s7,80003316 <writei+0x10e>
    80003240:	eca6                	sd	s1,88(sp)
    80003242:	e4ce                	sd	s3,72(sp)
    80003244:	ec66                	sd	s9,24(sp)
    80003246:	e86a                	sd	s10,16(sp)
    80003248:	e46e                	sd	s11,8(sp)
    8000324a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000324c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003250:	5cfd                	li	s9,-1
    80003252:	a091                	j	80003296 <writei+0x8e>
    80003254:	02099d93          	slli	s11,s3,0x20
    80003258:	020ddd93          	srli	s11,s11,0x20
    8000325c:	05848513          	addi	a0,s1,88
    80003260:	86ee                	mv	a3,s11
    80003262:	8656                	mv	a2,s5
    80003264:	85e2                	mv	a1,s8
    80003266:	953a                	add	a0,a0,a4
    80003268:	fffff097          	auipc	ra,0xfffff
    8000326c:	962080e7          	jalr	-1694(ra) # 80001bca <either_copyin>
    80003270:	07950263          	beq	a0,s9,800032d4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003274:	8526                	mv	a0,s1
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	780080e7          	jalr	1920(ra) # 800039f6 <log_write>
    brelse(bp);
    8000327e:	8526                	mv	a0,s1
    80003280:	fffff097          	auipc	ra,0xfffff
    80003284:	502080e7          	jalr	1282(ra) # 80002782 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003288:	01498a3b          	addw	s4,s3,s4
    8000328c:	0129893b          	addw	s2,s3,s2
    80003290:	9aee                	add	s5,s5,s11
    80003292:	057a7663          	bgeu	s4,s7,800032de <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003296:	000b2483          	lw	s1,0(s6)
    8000329a:	00a9559b          	srliw	a1,s2,0xa
    8000329e:	855a                	mv	a0,s6
    800032a0:	fffff097          	auipc	ra,0xfffff
    800032a4:	7a0080e7          	jalr	1952(ra) # 80002a40 <bmap>
    800032a8:	0005059b          	sext.w	a1,a0
    800032ac:	8526                	mv	a0,s1
    800032ae:	fffff097          	auipc	ra,0xfffff
    800032b2:	3a4080e7          	jalr	932(ra) # 80002652 <bread>
    800032b6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032b8:	3ff97713          	andi	a4,s2,1023
    800032bc:	40ed07bb          	subw	a5,s10,a4
    800032c0:	414b86bb          	subw	a3,s7,s4
    800032c4:	89be                	mv	s3,a5
    800032c6:	2781                	sext.w	a5,a5
    800032c8:	0006861b          	sext.w	a2,a3
    800032cc:	f8f674e3          	bgeu	a2,a5,80003254 <writei+0x4c>
    800032d0:	89b6                	mv	s3,a3
    800032d2:	b749                	j	80003254 <writei+0x4c>
      brelse(bp);
    800032d4:	8526                	mv	a0,s1
    800032d6:	fffff097          	auipc	ra,0xfffff
    800032da:	4ac080e7          	jalr	1196(ra) # 80002782 <brelse>
  }

  if(off > ip->size)
    800032de:	04cb2783          	lw	a5,76(s6)
    800032e2:	0327fc63          	bgeu	a5,s2,8000331a <writei+0x112>
    ip->size = off;
    800032e6:	052b2623          	sw	s2,76(s6)
    800032ea:	64e6                	ld	s1,88(sp)
    800032ec:	69a6                	ld	s3,72(sp)
    800032ee:	6ce2                	ld	s9,24(sp)
    800032f0:	6d42                	ld	s10,16(sp)
    800032f2:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032f4:	855a                	mv	a0,s6
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	a8a080e7          	jalr	-1398(ra) # 80002d80 <iupdate>

  return tot;
    800032fe:	000a051b          	sext.w	a0,s4
    80003302:	6a06                	ld	s4,64(sp)
}
    80003304:	70a6                	ld	ra,104(sp)
    80003306:	7406                	ld	s0,96(sp)
    80003308:	6946                	ld	s2,80(sp)
    8000330a:	7ae2                	ld	s5,56(sp)
    8000330c:	7b42                	ld	s6,48(sp)
    8000330e:	7ba2                	ld	s7,40(sp)
    80003310:	7c02                	ld	s8,32(sp)
    80003312:	6165                	addi	sp,sp,112
    80003314:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003316:	8a5e                	mv	s4,s7
    80003318:	bff1                	j	800032f4 <writei+0xec>
    8000331a:	64e6                	ld	s1,88(sp)
    8000331c:	69a6                	ld	s3,72(sp)
    8000331e:	6ce2                	ld	s9,24(sp)
    80003320:	6d42                	ld	s10,16(sp)
    80003322:	6da2                	ld	s11,8(sp)
    80003324:	bfc1                	j	800032f4 <writei+0xec>
    return -1;
    80003326:	557d                	li	a0,-1
}
    80003328:	8082                	ret
    return -1;
    8000332a:	557d                	li	a0,-1
    8000332c:	bfe1                	j	80003304 <writei+0xfc>
    return -1;
    8000332e:	557d                	li	a0,-1
    80003330:	bfd1                	j	80003304 <writei+0xfc>

0000000080003332 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003332:	1141                	addi	sp,sp,-16
    80003334:	e406                	sd	ra,8(sp)
    80003336:	e022                	sd	s0,0(sp)
    80003338:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000333a:	4639                	li	a2,14
    8000333c:	ffffd097          	auipc	ra,0xffffd
    80003340:	076080e7          	jalr	118(ra) # 800003b2 <strncmp>
}
    80003344:	60a2                	ld	ra,8(sp)
    80003346:	6402                	ld	s0,0(sp)
    80003348:	0141                	addi	sp,sp,16
    8000334a:	8082                	ret

000000008000334c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000334c:	7139                	addi	sp,sp,-64
    8000334e:	fc06                	sd	ra,56(sp)
    80003350:	f822                	sd	s0,48(sp)
    80003352:	f426                	sd	s1,40(sp)
    80003354:	f04a                	sd	s2,32(sp)
    80003356:	ec4e                	sd	s3,24(sp)
    80003358:	e852                	sd	s4,16(sp)
    8000335a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000335c:	04451703          	lh	a4,68(a0)
    80003360:	4785                	li	a5,1
    80003362:	00f71a63          	bne	a4,a5,80003376 <dirlookup+0x2a>
    80003366:	892a                	mv	s2,a0
    80003368:	89ae                	mv	s3,a1
    8000336a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000336c:	457c                	lw	a5,76(a0)
    8000336e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003370:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003372:	e79d                	bnez	a5,800033a0 <dirlookup+0x54>
    80003374:	a8a5                	j	800033ec <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003376:	00005517          	auipc	a0,0x5
    8000337a:	0f250513          	addi	a0,a0,242 # 80008468 <etext+0x468>
    8000337e:	00003097          	auipc	ra,0x3
    80003382:	c3e080e7          	jalr	-962(ra) # 80005fbc <panic>
      panic("dirlookup read");
    80003386:	00005517          	auipc	a0,0x5
    8000338a:	0fa50513          	addi	a0,a0,250 # 80008480 <etext+0x480>
    8000338e:	00003097          	auipc	ra,0x3
    80003392:	c2e080e7          	jalr	-978(ra) # 80005fbc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003396:	24c1                	addiw	s1,s1,16
    80003398:	04c92783          	lw	a5,76(s2)
    8000339c:	04f4f763          	bgeu	s1,a5,800033ea <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a0:	4741                	li	a4,16
    800033a2:	86a6                	mv	a3,s1
    800033a4:	fc040613          	addi	a2,s0,-64
    800033a8:	4581                	li	a1,0
    800033aa:	854a                	mv	a0,s2
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	d58080e7          	jalr	-680(ra) # 80003104 <readi>
    800033b4:	47c1                	li	a5,16
    800033b6:	fcf518e3          	bne	a0,a5,80003386 <dirlookup+0x3a>
    if(de.inum == 0)
    800033ba:	fc045783          	lhu	a5,-64(s0)
    800033be:	dfe1                	beqz	a5,80003396 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033c0:	fc240593          	addi	a1,s0,-62
    800033c4:	854e                	mv	a0,s3
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	f6c080e7          	jalr	-148(ra) # 80003332 <namecmp>
    800033ce:	f561                	bnez	a0,80003396 <dirlookup+0x4a>
      if(poff)
    800033d0:	000a0463          	beqz	s4,800033d8 <dirlookup+0x8c>
        *poff = off;
    800033d4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033d8:	fc045583          	lhu	a1,-64(s0)
    800033dc:	00092503          	lw	a0,0(s2)
    800033e0:	fffff097          	auipc	ra,0xfffff
    800033e4:	73c080e7          	jalr	1852(ra) # 80002b1c <iget>
    800033e8:	a011                	j	800033ec <dirlookup+0xa0>
  return 0;
    800033ea:	4501                	li	a0,0
}
    800033ec:	70e2                	ld	ra,56(sp)
    800033ee:	7442                	ld	s0,48(sp)
    800033f0:	74a2                	ld	s1,40(sp)
    800033f2:	7902                	ld	s2,32(sp)
    800033f4:	69e2                	ld	s3,24(sp)
    800033f6:	6a42                	ld	s4,16(sp)
    800033f8:	6121                	addi	sp,sp,64
    800033fa:	8082                	ret

00000000800033fc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033fc:	711d                	addi	sp,sp,-96
    800033fe:	ec86                	sd	ra,88(sp)
    80003400:	e8a2                	sd	s0,80(sp)
    80003402:	e4a6                	sd	s1,72(sp)
    80003404:	e0ca                	sd	s2,64(sp)
    80003406:	fc4e                	sd	s3,56(sp)
    80003408:	f852                	sd	s4,48(sp)
    8000340a:	f456                	sd	s5,40(sp)
    8000340c:	f05a                	sd	s6,32(sp)
    8000340e:	ec5e                	sd	s7,24(sp)
    80003410:	e862                	sd	s8,16(sp)
    80003412:	e466                	sd	s9,8(sp)
    80003414:	1080                	addi	s0,sp,96
    80003416:	84aa                	mv	s1,a0
    80003418:	8b2e                	mv	s6,a1
    8000341a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000341c:	00054703          	lbu	a4,0(a0)
    80003420:	02f00793          	li	a5,47
    80003424:	02f70263          	beq	a4,a5,80003448 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003428:	ffffe097          	auipc	ra,0xffffe
    8000342c:	ce2080e7          	jalr	-798(ra) # 8000110a <myproc>
    80003430:	15053503          	ld	a0,336(a0)
    80003434:	00000097          	auipc	ra,0x0
    80003438:	9da080e7          	jalr	-1574(ra) # 80002e0e <idup>
    8000343c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000343e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003442:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003444:	4b85                	li	s7,1
    80003446:	a875                	j	80003502 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003448:	4585                	li	a1,1
    8000344a:	4505                	li	a0,1
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	6d0080e7          	jalr	1744(ra) # 80002b1c <iget>
    80003454:	8a2a                	mv	s4,a0
    80003456:	b7e5                	j	8000343e <namex+0x42>
      iunlockput(ip);
    80003458:	8552                	mv	a0,s4
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	c58080e7          	jalr	-936(ra) # 800030b2 <iunlockput>
      return 0;
    80003462:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003464:	8552                	mv	a0,s4
    80003466:	60e6                	ld	ra,88(sp)
    80003468:	6446                	ld	s0,80(sp)
    8000346a:	64a6                	ld	s1,72(sp)
    8000346c:	6906                	ld	s2,64(sp)
    8000346e:	79e2                	ld	s3,56(sp)
    80003470:	7a42                	ld	s4,48(sp)
    80003472:	7aa2                	ld	s5,40(sp)
    80003474:	7b02                	ld	s6,32(sp)
    80003476:	6be2                	ld	s7,24(sp)
    80003478:	6c42                	ld	s8,16(sp)
    8000347a:	6ca2                	ld	s9,8(sp)
    8000347c:	6125                	addi	sp,sp,96
    8000347e:	8082                	ret
      iunlock(ip);
    80003480:	8552                	mv	a0,s4
    80003482:	00000097          	auipc	ra,0x0
    80003486:	a90080e7          	jalr	-1392(ra) # 80002f12 <iunlock>
      return ip;
    8000348a:	bfe9                	j	80003464 <namex+0x68>
      iunlockput(ip);
    8000348c:	8552                	mv	a0,s4
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	c24080e7          	jalr	-988(ra) # 800030b2 <iunlockput>
      return 0;
    80003496:	8a4e                	mv	s4,s3
    80003498:	b7f1                	j	80003464 <namex+0x68>
  len = path - s;
    8000349a:	40998633          	sub	a2,s3,s1
    8000349e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800034a2:	099c5863          	bge	s8,s9,80003532 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800034a6:	4639                	li	a2,14
    800034a8:	85a6                	mv	a1,s1
    800034aa:	8556                	mv	a0,s5
    800034ac:	ffffd097          	auipc	ra,0xffffd
    800034b0:	e92080e7          	jalr	-366(ra) # 8000033e <memmove>
    800034b4:	84ce                	mv	s1,s3
  while(*path == '/')
    800034b6:	0004c783          	lbu	a5,0(s1)
    800034ba:	01279763          	bne	a5,s2,800034c8 <namex+0xcc>
    path++;
    800034be:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034c0:	0004c783          	lbu	a5,0(s1)
    800034c4:	ff278de3          	beq	a5,s2,800034be <namex+0xc2>
    ilock(ip);
    800034c8:	8552                	mv	a0,s4
    800034ca:	00000097          	auipc	ra,0x0
    800034ce:	982080e7          	jalr	-1662(ra) # 80002e4c <ilock>
    if(ip->type != T_DIR){
    800034d2:	044a1783          	lh	a5,68(s4)
    800034d6:	f97791e3          	bne	a5,s7,80003458 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800034da:	000b0563          	beqz	s6,800034e4 <namex+0xe8>
    800034de:	0004c783          	lbu	a5,0(s1)
    800034e2:	dfd9                	beqz	a5,80003480 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034e4:	4601                	li	a2,0
    800034e6:	85d6                	mv	a1,s5
    800034e8:	8552                	mv	a0,s4
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	e62080e7          	jalr	-414(ra) # 8000334c <dirlookup>
    800034f2:	89aa                	mv	s3,a0
    800034f4:	dd41                	beqz	a0,8000348c <namex+0x90>
    iunlockput(ip);
    800034f6:	8552                	mv	a0,s4
    800034f8:	00000097          	auipc	ra,0x0
    800034fc:	bba080e7          	jalr	-1094(ra) # 800030b2 <iunlockput>
    ip = next;
    80003500:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003502:	0004c783          	lbu	a5,0(s1)
    80003506:	01279763          	bne	a5,s2,80003514 <namex+0x118>
    path++;
    8000350a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000350c:	0004c783          	lbu	a5,0(s1)
    80003510:	ff278de3          	beq	a5,s2,8000350a <namex+0x10e>
  if(*path == 0)
    80003514:	cb9d                	beqz	a5,8000354a <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003516:	0004c783          	lbu	a5,0(s1)
    8000351a:	89a6                	mv	s3,s1
  len = path - s;
    8000351c:	4c81                	li	s9,0
    8000351e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003520:	01278963          	beq	a5,s2,80003532 <namex+0x136>
    80003524:	dbbd                	beqz	a5,8000349a <namex+0x9e>
    path++;
    80003526:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003528:	0009c783          	lbu	a5,0(s3)
    8000352c:	ff279ce3          	bne	a5,s2,80003524 <namex+0x128>
    80003530:	b7ad                	j	8000349a <namex+0x9e>
    memmove(name, s, len);
    80003532:	2601                	sext.w	a2,a2
    80003534:	85a6                	mv	a1,s1
    80003536:	8556                	mv	a0,s5
    80003538:	ffffd097          	auipc	ra,0xffffd
    8000353c:	e06080e7          	jalr	-506(ra) # 8000033e <memmove>
    name[len] = 0;
    80003540:	9cd6                	add	s9,s9,s5
    80003542:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003546:	84ce                	mv	s1,s3
    80003548:	b7bd                	j	800034b6 <namex+0xba>
  if(nameiparent){
    8000354a:	f00b0de3          	beqz	s6,80003464 <namex+0x68>
    iput(ip);
    8000354e:	8552                	mv	a0,s4
    80003550:	00000097          	auipc	ra,0x0
    80003554:	aba080e7          	jalr	-1350(ra) # 8000300a <iput>
    return 0;
    80003558:	4a01                	li	s4,0
    8000355a:	b729                	j	80003464 <namex+0x68>

000000008000355c <dirlink>:
{
    8000355c:	7139                	addi	sp,sp,-64
    8000355e:	fc06                	sd	ra,56(sp)
    80003560:	f822                	sd	s0,48(sp)
    80003562:	f04a                	sd	s2,32(sp)
    80003564:	ec4e                	sd	s3,24(sp)
    80003566:	e852                	sd	s4,16(sp)
    80003568:	0080                	addi	s0,sp,64
    8000356a:	892a                	mv	s2,a0
    8000356c:	8a2e                	mv	s4,a1
    8000356e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003570:	4601                	li	a2,0
    80003572:	00000097          	auipc	ra,0x0
    80003576:	dda080e7          	jalr	-550(ra) # 8000334c <dirlookup>
    8000357a:	ed25                	bnez	a0,800035f2 <dirlink+0x96>
    8000357c:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000357e:	04c92483          	lw	s1,76(s2)
    80003582:	c49d                	beqz	s1,800035b0 <dirlink+0x54>
    80003584:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003586:	4741                	li	a4,16
    80003588:	86a6                	mv	a3,s1
    8000358a:	fc040613          	addi	a2,s0,-64
    8000358e:	4581                	li	a1,0
    80003590:	854a                	mv	a0,s2
    80003592:	00000097          	auipc	ra,0x0
    80003596:	b72080e7          	jalr	-1166(ra) # 80003104 <readi>
    8000359a:	47c1                	li	a5,16
    8000359c:	06f51163          	bne	a0,a5,800035fe <dirlink+0xa2>
    if(de.inum == 0)
    800035a0:	fc045783          	lhu	a5,-64(s0)
    800035a4:	c791                	beqz	a5,800035b0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035a6:	24c1                	addiw	s1,s1,16
    800035a8:	04c92783          	lw	a5,76(s2)
    800035ac:	fcf4ede3          	bltu	s1,a5,80003586 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035b0:	4639                	li	a2,14
    800035b2:	85d2                	mv	a1,s4
    800035b4:	fc240513          	addi	a0,s0,-62
    800035b8:	ffffd097          	auipc	ra,0xffffd
    800035bc:	e30080e7          	jalr	-464(ra) # 800003e8 <strncpy>
  de.inum = inum;
    800035c0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035c4:	4741                	li	a4,16
    800035c6:	86a6                	mv	a3,s1
    800035c8:	fc040613          	addi	a2,s0,-64
    800035cc:	4581                	li	a1,0
    800035ce:	854a                	mv	a0,s2
    800035d0:	00000097          	auipc	ra,0x0
    800035d4:	c38080e7          	jalr	-968(ra) # 80003208 <writei>
    800035d8:	872a                	mv	a4,a0
    800035da:	47c1                	li	a5,16
  return 0;
    800035dc:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035de:	02f71863          	bne	a4,a5,8000360e <dirlink+0xb2>
    800035e2:	74a2                	ld	s1,40(sp)
}
    800035e4:	70e2                	ld	ra,56(sp)
    800035e6:	7442                	ld	s0,48(sp)
    800035e8:	7902                	ld	s2,32(sp)
    800035ea:	69e2                	ld	s3,24(sp)
    800035ec:	6a42                	ld	s4,16(sp)
    800035ee:	6121                	addi	sp,sp,64
    800035f0:	8082                	ret
    iput(ip);
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	a18080e7          	jalr	-1512(ra) # 8000300a <iput>
    return -1;
    800035fa:	557d                	li	a0,-1
    800035fc:	b7e5                	j	800035e4 <dirlink+0x88>
      panic("dirlink read");
    800035fe:	00005517          	auipc	a0,0x5
    80003602:	e9250513          	addi	a0,a0,-366 # 80008490 <etext+0x490>
    80003606:	00003097          	auipc	ra,0x3
    8000360a:	9b6080e7          	jalr	-1610(ra) # 80005fbc <panic>
    panic("dirlink");
    8000360e:	00005517          	auipc	a0,0x5
    80003612:	f9250513          	addi	a0,a0,-110 # 800085a0 <etext+0x5a0>
    80003616:	00003097          	auipc	ra,0x3
    8000361a:	9a6080e7          	jalr	-1626(ra) # 80005fbc <panic>

000000008000361e <namei>:

struct inode*
namei(char *path)
{
    8000361e:	1101                	addi	sp,sp,-32
    80003620:	ec06                	sd	ra,24(sp)
    80003622:	e822                	sd	s0,16(sp)
    80003624:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003626:	fe040613          	addi	a2,s0,-32
    8000362a:	4581                	li	a1,0
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	dd0080e7          	jalr	-560(ra) # 800033fc <namex>
}
    80003634:	60e2                	ld	ra,24(sp)
    80003636:	6442                	ld	s0,16(sp)
    80003638:	6105                	addi	sp,sp,32
    8000363a:	8082                	ret

000000008000363c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000363c:	1141                	addi	sp,sp,-16
    8000363e:	e406                	sd	ra,8(sp)
    80003640:	e022                	sd	s0,0(sp)
    80003642:	0800                	addi	s0,sp,16
    80003644:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003646:	4585                	li	a1,1
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	db4080e7          	jalr	-588(ra) # 800033fc <namex>
}
    80003650:	60a2                	ld	ra,8(sp)
    80003652:	6402                	ld	s0,0(sp)
    80003654:	0141                	addi	sp,sp,16
    80003656:	8082                	ret

0000000080003658 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003658:	1101                	addi	sp,sp,-32
    8000365a:	ec06                	sd	ra,24(sp)
    8000365c:	e822                	sd	s0,16(sp)
    8000365e:	e426                	sd	s1,8(sp)
    80003660:	e04a                	sd	s2,0(sp)
    80003662:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003664:	00019917          	auipc	s2,0x19
    80003668:	9dc90913          	addi	s2,s2,-1572 # 8001c040 <log>
    8000366c:	01892583          	lw	a1,24(s2)
    80003670:	02892503          	lw	a0,40(s2)
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	fde080e7          	jalr	-34(ra) # 80002652 <bread>
    8000367c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000367e:	02c92603          	lw	a2,44(s2)
    80003682:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003684:	00c05f63          	blez	a2,800036a2 <write_head+0x4a>
    80003688:	00019717          	auipc	a4,0x19
    8000368c:	9e870713          	addi	a4,a4,-1560 # 8001c070 <log+0x30>
    80003690:	87aa                	mv	a5,a0
    80003692:	060a                	slli	a2,a2,0x2
    80003694:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003696:	4314                	lw	a3,0(a4)
    80003698:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000369a:	0711                	addi	a4,a4,4
    8000369c:	0791                	addi	a5,a5,4
    8000369e:	fec79ce3          	bne	a5,a2,80003696 <write_head+0x3e>
  }
  bwrite(buf);
    800036a2:	8526                	mv	a0,s1
    800036a4:	fffff097          	auipc	ra,0xfffff
    800036a8:	0a0080e7          	jalr	160(ra) # 80002744 <bwrite>
  brelse(buf);
    800036ac:	8526                	mv	a0,s1
    800036ae:	fffff097          	auipc	ra,0xfffff
    800036b2:	0d4080e7          	jalr	212(ra) # 80002782 <brelse>
}
    800036b6:	60e2                	ld	ra,24(sp)
    800036b8:	6442                	ld	s0,16(sp)
    800036ba:	64a2                	ld	s1,8(sp)
    800036bc:	6902                	ld	s2,0(sp)
    800036be:	6105                	addi	sp,sp,32
    800036c0:	8082                	ret

00000000800036c2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c2:	00019797          	auipc	a5,0x19
    800036c6:	9aa7a783          	lw	a5,-1622(a5) # 8001c06c <log+0x2c>
    800036ca:	0af05d63          	blez	a5,80003784 <install_trans+0xc2>
{
    800036ce:	7139                	addi	sp,sp,-64
    800036d0:	fc06                	sd	ra,56(sp)
    800036d2:	f822                	sd	s0,48(sp)
    800036d4:	f426                	sd	s1,40(sp)
    800036d6:	f04a                	sd	s2,32(sp)
    800036d8:	ec4e                	sd	s3,24(sp)
    800036da:	e852                	sd	s4,16(sp)
    800036dc:	e456                	sd	s5,8(sp)
    800036de:	e05a                	sd	s6,0(sp)
    800036e0:	0080                	addi	s0,sp,64
    800036e2:	8b2a                	mv	s6,a0
    800036e4:	00019a97          	auipc	s5,0x19
    800036e8:	98ca8a93          	addi	s5,s5,-1652 # 8001c070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ec:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036ee:	00019997          	auipc	s3,0x19
    800036f2:	95298993          	addi	s3,s3,-1710 # 8001c040 <log>
    800036f6:	a00d                	j	80003718 <install_trans+0x56>
    brelse(lbuf);
    800036f8:	854a                	mv	a0,s2
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	088080e7          	jalr	136(ra) # 80002782 <brelse>
    brelse(dbuf);
    80003702:	8526                	mv	a0,s1
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	07e080e7          	jalr	126(ra) # 80002782 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370c:	2a05                	addiw	s4,s4,1
    8000370e:	0a91                	addi	s5,s5,4
    80003710:	02c9a783          	lw	a5,44(s3)
    80003714:	04fa5e63          	bge	s4,a5,80003770 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003718:	0189a583          	lw	a1,24(s3)
    8000371c:	014585bb          	addw	a1,a1,s4
    80003720:	2585                	addiw	a1,a1,1
    80003722:	0289a503          	lw	a0,40(s3)
    80003726:	fffff097          	auipc	ra,0xfffff
    8000372a:	f2c080e7          	jalr	-212(ra) # 80002652 <bread>
    8000372e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003730:	000aa583          	lw	a1,0(s5)
    80003734:	0289a503          	lw	a0,40(s3)
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	f1a080e7          	jalr	-230(ra) # 80002652 <bread>
    80003740:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003742:	40000613          	li	a2,1024
    80003746:	05890593          	addi	a1,s2,88
    8000374a:	05850513          	addi	a0,a0,88
    8000374e:	ffffd097          	auipc	ra,0xffffd
    80003752:	bf0080e7          	jalr	-1040(ra) # 8000033e <memmove>
    bwrite(dbuf);  // write dst to disk
    80003756:	8526                	mv	a0,s1
    80003758:	fffff097          	auipc	ra,0xfffff
    8000375c:	fec080e7          	jalr	-20(ra) # 80002744 <bwrite>
    if(recovering == 0)
    80003760:	f80b1ce3          	bnez	s6,800036f8 <install_trans+0x36>
      bunpin(dbuf);
    80003764:	8526                	mv	a0,s1
    80003766:	fffff097          	auipc	ra,0xfffff
    8000376a:	0f4080e7          	jalr	244(ra) # 8000285a <bunpin>
    8000376e:	b769                	j	800036f8 <install_trans+0x36>
}
    80003770:	70e2                	ld	ra,56(sp)
    80003772:	7442                	ld	s0,48(sp)
    80003774:	74a2                	ld	s1,40(sp)
    80003776:	7902                	ld	s2,32(sp)
    80003778:	69e2                	ld	s3,24(sp)
    8000377a:	6a42                	ld	s4,16(sp)
    8000377c:	6aa2                	ld	s5,8(sp)
    8000377e:	6b02                	ld	s6,0(sp)
    80003780:	6121                	addi	sp,sp,64
    80003782:	8082                	ret
    80003784:	8082                	ret

0000000080003786 <initlog>:
{
    80003786:	7179                	addi	sp,sp,-48
    80003788:	f406                	sd	ra,40(sp)
    8000378a:	f022                	sd	s0,32(sp)
    8000378c:	ec26                	sd	s1,24(sp)
    8000378e:	e84a                	sd	s2,16(sp)
    80003790:	e44e                	sd	s3,8(sp)
    80003792:	1800                	addi	s0,sp,48
    80003794:	892a                	mv	s2,a0
    80003796:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003798:	00019497          	auipc	s1,0x19
    8000379c:	8a848493          	addi	s1,s1,-1880 # 8001c040 <log>
    800037a0:	00005597          	auipc	a1,0x5
    800037a4:	d0058593          	addi	a1,a1,-768 # 800084a0 <etext+0x4a0>
    800037a8:	8526                	mv	a0,s1
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	cfc080e7          	jalr	-772(ra) # 800064a6 <initlock>
  log.start = sb->logstart;
    800037b2:	0149a583          	lw	a1,20(s3)
    800037b6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800037b8:	0109a783          	lw	a5,16(s3)
    800037bc:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800037be:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037c2:	854a                	mv	a0,s2
    800037c4:	fffff097          	auipc	ra,0xfffff
    800037c8:	e8e080e7          	jalr	-370(ra) # 80002652 <bread>
  log.lh.n = lh->n;
    800037cc:	4d30                	lw	a2,88(a0)
    800037ce:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037d0:	00c05f63          	blez	a2,800037ee <initlog+0x68>
    800037d4:	87aa                	mv	a5,a0
    800037d6:	00019717          	auipc	a4,0x19
    800037da:	89a70713          	addi	a4,a4,-1894 # 8001c070 <log+0x30>
    800037de:	060a                	slli	a2,a2,0x2
    800037e0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037e2:	4ff4                	lw	a3,92(a5)
    800037e4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037e6:	0791                	addi	a5,a5,4
    800037e8:	0711                	addi	a4,a4,4
    800037ea:	fec79ce3          	bne	a5,a2,800037e2 <initlog+0x5c>
  brelse(buf);
    800037ee:	fffff097          	auipc	ra,0xfffff
    800037f2:	f94080e7          	jalr	-108(ra) # 80002782 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037f6:	4505                	li	a0,1
    800037f8:	00000097          	auipc	ra,0x0
    800037fc:	eca080e7          	jalr	-310(ra) # 800036c2 <install_trans>
  log.lh.n = 0;
    80003800:	00019797          	auipc	a5,0x19
    80003804:	8607a623          	sw	zero,-1940(a5) # 8001c06c <log+0x2c>
  write_head(); // clear the log
    80003808:	00000097          	auipc	ra,0x0
    8000380c:	e50080e7          	jalr	-432(ra) # 80003658 <write_head>
}
    80003810:	70a2                	ld	ra,40(sp)
    80003812:	7402                	ld	s0,32(sp)
    80003814:	64e2                	ld	s1,24(sp)
    80003816:	6942                	ld	s2,16(sp)
    80003818:	69a2                	ld	s3,8(sp)
    8000381a:	6145                	addi	sp,sp,48
    8000381c:	8082                	ret

000000008000381e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000381e:	1101                	addi	sp,sp,-32
    80003820:	ec06                	sd	ra,24(sp)
    80003822:	e822                	sd	s0,16(sp)
    80003824:	e426                	sd	s1,8(sp)
    80003826:	e04a                	sd	s2,0(sp)
    80003828:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000382a:	00019517          	auipc	a0,0x19
    8000382e:	81650513          	addi	a0,a0,-2026 # 8001c040 <log>
    80003832:	00003097          	auipc	ra,0x3
    80003836:	d04080e7          	jalr	-764(ra) # 80006536 <acquire>
  while(1){
    if(log.committing){
    8000383a:	00019497          	auipc	s1,0x19
    8000383e:	80648493          	addi	s1,s1,-2042 # 8001c040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003842:	4979                	li	s2,30
    80003844:	a039                	j	80003852 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003846:	85a6                	mv	a1,s1
    80003848:	8526                	mv	a0,s1
    8000384a:	ffffe097          	auipc	ra,0xffffe
    8000384e:	f86080e7          	jalr	-122(ra) # 800017d0 <sleep>
    if(log.committing){
    80003852:	50dc                	lw	a5,36(s1)
    80003854:	fbed                	bnez	a5,80003846 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003856:	5098                	lw	a4,32(s1)
    80003858:	2705                	addiw	a4,a4,1
    8000385a:	0027179b          	slliw	a5,a4,0x2
    8000385e:	9fb9                	addw	a5,a5,a4
    80003860:	0017979b          	slliw	a5,a5,0x1
    80003864:	54d4                	lw	a3,44(s1)
    80003866:	9fb5                	addw	a5,a5,a3
    80003868:	00f95963          	bge	s2,a5,8000387a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000386c:	85a6                	mv	a1,s1
    8000386e:	8526                	mv	a0,s1
    80003870:	ffffe097          	auipc	ra,0xffffe
    80003874:	f60080e7          	jalr	-160(ra) # 800017d0 <sleep>
    80003878:	bfe9                	j	80003852 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000387a:	00018517          	auipc	a0,0x18
    8000387e:	7c650513          	addi	a0,a0,1990 # 8001c040 <log>
    80003882:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003884:	00003097          	auipc	ra,0x3
    80003888:	d66080e7          	jalr	-666(ra) # 800065ea <release>
      break;
    }
  }
}
    8000388c:	60e2                	ld	ra,24(sp)
    8000388e:	6442                	ld	s0,16(sp)
    80003890:	64a2                	ld	s1,8(sp)
    80003892:	6902                	ld	s2,0(sp)
    80003894:	6105                	addi	sp,sp,32
    80003896:	8082                	ret

0000000080003898 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003898:	7139                	addi	sp,sp,-64
    8000389a:	fc06                	sd	ra,56(sp)
    8000389c:	f822                	sd	s0,48(sp)
    8000389e:	f426                	sd	s1,40(sp)
    800038a0:	f04a                	sd	s2,32(sp)
    800038a2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800038a4:	00018497          	auipc	s1,0x18
    800038a8:	79c48493          	addi	s1,s1,1948 # 8001c040 <log>
    800038ac:	8526                	mv	a0,s1
    800038ae:	00003097          	auipc	ra,0x3
    800038b2:	c88080e7          	jalr	-888(ra) # 80006536 <acquire>
  log.outstanding -= 1;
    800038b6:	509c                	lw	a5,32(s1)
    800038b8:	37fd                	addiw	a5,a5,-1
    800038ba:	0007891b          	sext.w	s2,a5
    800038be:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800038c0:	50dc                	lw	a5,36(s1)
    800038c2:	e7b9                	bnez	a5,80003910 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800038c4:	06091163          	bnez	s2,80003926 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038c8:	00018497          	auipc	s1,0x18
    800038cc:	77848493          	addi	s1,s1,1912 # 8001c040 <log>
    800038d0:	4785                	li	a5,1
    800038d2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038d4:	8526                	mv	a0,s1
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	d14080e7          	jalr	-748(ra) # 800065ea <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038de:	54dc                	lw	a5,44(s1)
    800038e0:	06f04763          	bgtz	a5,8000394e <end_op+0xb6>
    acquire(&log.lock);
    800038e4:	00018497          	auipc	s1,0x18
    800038e8:	75c48493          	addi	s1,s1,1884 # 8001c040 <log>
    800038ec:	8526                	mv	a0,s1
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	c48080e7          	jalr	-952(ra) # 80006536 <acquire>
    log.committing = 0;
    800038f6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038fa:	8526                	mv	a0,s1
    800038fc:	ffffe097          	auipc	ra,0xffffe
    80003900:	060080e7          	jalr	96(ra) # 8000195c <wakeup>
    release(&log.lock);
    80003904:	8526                	mv	a0,s1
    80003906:	00003097          	auipc	ra,0x3
    8000390a:	ce4080e7          	jalr	-796(ra) # 800065ea <release>
}
    8000390e:	a815                	j	80003942 <end_op+0xaa>
    80003910:	ec4e                	sd	s3,24(sp)
    80003912:	e852                	sd	s4,16(sp)
    80003914:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003916:	00005517          	auipc	a0,0x5
    8000391a:	b9250513          	addi	a0,a0,-1134 # 800084a8 <etext+0x4a8>
    8000391e:	00002097          	auipc	ra,0x2
    80003922:	69e080e7          	jalr	1694(ra) # 80005fbc <panic>
    wakeup(&log);
    80003926:	00018497          	auipc	s1,0x18
    8000392a:	71a48493          	addi	s1,s1,1818 # 8001c040 <log>
    8000392e:	8526                	mv	a0,s1
    80003930:	ffffe097          	auipc	ra,0xffffe
    80003934:	02c080e7          	jalr	44(ra) # 8000195c <wakeup>
  release(&log.lock);
    80003938:	8526                	mv	a0,s1
    8000393a:	00003097          	auipc	ra,0x3
    8000393e:	cb0080e7          	jalr	-848(ra) # 800065ea <release>
}
    80003942:	70e2                	ld	ra,56(sp)
    80003944:	7442                	ld	s0,48(sp)
    80003946:	74a2                	ld	s1,40(sp)
    80003948:	7902                	ld	s2,32(sp)
    8000394a:	6121                	addi	sp,sp,64
    8000394c:	8082                	ret
    8000394e:	ec4e                	sd	s3,24(sp)
    80003950:	e852                	sd	s4,16(sp)
    80003952:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003954:	00018a97          	auipc	s5,0x18
    80003958:	71ca8a93          	addi	s5,s5,1820 # 8001c070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000395c:	00018a17          	auipc	s4,0x18
    80003960:	6e4a0a13          	addi	s4,s4,1764 # 8001c040 <log>
    80003964:	018a2583          	lw	a1,24(s4)
    80003968:	012585bb          	addw	a1,a1,s2
    8000396c:	2585                	addiw	a1,a1,1
    8000396e:	028a2503          	lw	a0,40(s4)
    80003972:	fffff097          	auipc	ra,0xfffff
    80003976:	ce0080e7          	jalr	-800(ra) # 80002652 <bread>
    8000397a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000397c:	000aa583          	lw	a1,0(s5)
    80003980:	028a2503          	lw	a0,40(s4)
    80003984:	fffff097          	auipc	ra,0xfffff
    80003988:	cce080e7          	jalr	-818(ra) # 80002652 <bread>
    8000398c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000398e:	40000613          	li	a2,1024
    80003992:	05850593          	addi	a1,a0,88
    80003996:	05848513          	addi	a0,s1,88
    8000399a:	ffffd097          	auipc	ra,0xffffd
    8000399e:	9a4080e7          	jalr	-1628(ra) # 8000033e <memmove>
    bwrite(to);  // write the log
    800039a2:	8526                	mv	a0,s1
    800039a4:	fffff097          	auipc	ra,0xfffff
    800039a8:	da0080e7          	jalr	-608(ra) # 80002744 <bwrite>
    brelse(from);
    800039ac:	854e                	mv	a0,s3
    800039ae:	fffff097          	auipc	ra,0xfffff
    800039b2:	dd4080e7          	jalr	-556(ra) # 80002782 <brelse>
    brelse(to);
    800039b6:	8526                	mv	a0,s1
    800039b8:	fffff097          	auipc	ra,0xfffff
    800039bc:	dca080e7          	jalr	-566(ra) # 80002782 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039c0:	2905                	addiw	s2,s2,1
    800039c2:	0a91                	addi	s5,s5,4
    800039c4:	02ca2783          	lw	a5,44(s4)
    800039c8:	f8f94ee3          	blt	s2,a5,80003964 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	c8c080e7          	jalr	-884(ra) # 80003658 <write_head>
    install_trans(0); // Now install writes to home locations
    800039d4:	4501                	li	a0,0
    800039d6:	00000097          	auipc	ra,0x0
    800039da:	cec080e7          	jalr	-788(ra) # 800036c2 <install_trans>
    log.lh.n = 0;
    800039de:	00018797          	auipc	a5,0x18
    800039e2:	6807a723          	sw	zero,1678(a5) # 8001c06c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	c72080e7          	jalr	-910(ra) # 80003658 <write_head>
    800039ee:	69e2                	ld	s3,24(sp)
    800039f0:	6a42                	ld	s4,16(sp)
    800039f2:	6aa2                	ld	s5,8(sp)
    800039f4:	bdc5                	j	800038e4 <end_op+0x4c>

00000000800039f6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039f6:	1101                	addi	sp,sp,-32
    800039f8:	ec06                	sd	ra,24(sp)
    800039fa:	e822                	sd	s0,16(sp)
    800039fc:	e426                	sd	s1,8(sp)
    800039fe:	e04a                	sd	s2,0(sp)
    80003a00:	1000                	addi	s0,sp,32
    80003a02:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a04:	00018917          	auipc	s2,0x18
    80003a08:	63c90913          	addi	s2,s2,1596 # 8001c040 <log>
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	b28080e7          	jalr	-1240(ra) # 80006536 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a16:	02c92603          	lw	a2,44(s2)
    80003a1a:	47f5                	li	a5,29
    80003a1c:	06c7c563          	blt	a5,a2,80003a86 <log_write+0x90>
    80003a20:	00018797          	auipc	a5,0x18
    80003a24:	63c7a783          	lw	a5,1596(a5) # 8001c05c <log+0x1c>
    80003a28:	37fd                	addiw	a5,a5,-1
    80003a2a:	04f65e63          	bge	a2,a5,80003a86 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a2e:	00018797          	auipc	a5,0x18
    80003a32:	6327a783          	lw	a5,1586(a5) # 8001c060 <log+0x20>
    80003a36:	06f05063          	blez	a5,80003a96 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a3a:	4781                	li	a5,0
    80003a3c:	06c05563          	blez	a2,80003aa6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a40:	44cc                	lw	a1,12(s1)
    80003a42:	00018717          	auipc	a4,0x18
    80003a46:	62e70713          	addi	a4,a4,1582 # 8001c070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a4a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a4c:	4314                	lw	a3,0(a4)
    80003a4e:	04b68c63          	beq	a3,a1,80003aa6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a52:	2785                	addiw	a5,a5,1
    80003a54:	0711                	addi	a4,a4,4
    80003a56:	fef61be3          	bne	a2,a5,80003a4c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a5a:	0621                	addi	a2,a2,8
    80003a5c:	060a                	slli	a2,a2,0x2
    80003a5e:	00018797          	auipc	a5,0x18
    80003a62:	5e278793          	addi	a5,a5,1506 # 8001c040 <log>
    80003a66:	97b2                	add	a5,a5,a2
    80003a68:	44d8                	lw	a4,12(s1)
    80003a6a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	fffff097          	auipc	ra,0xfffff
    80003a72:	db0080e7          	jalr	-592(ra) # 8000281e <bpin>
    log.lh.n++;
    80003a76:	00018717          	auipc	a4,0x18
    80003a7a:	5ca70713          	addi	a4,a4,1482 # 8001c040 <log>
    80003a7e:	575c                	lw	a5,44(a4)
    80003a80:	2785                	addiw	a5,a5,1
    80003a82:	d75c                	sw	a5,44(a4)
    80003a84:	a82d                	j	80003abe <log_write+0xc8>
    panic("too big a transaction");
    80003a86:	00005517          	auipc	a0,0x5
    80003a8a:	a3250513          	addi	a0,a0,-1486 # 800084b8 <etext+0x4b8>
    80003a8e:	00002097          	auipc	ra,0x2
    80003a92:	52e080e7          	jalr	1326(ra) # 80005fbc <panic>
    panic("log_write outside of trans");
    80003a96:	00005517          	auipc	a0,0x5
    80003a9a:	a3a50513          	addi	a0,a0,-1478 # 800084d0 <etext+0x4d0>
    80003a9e:	00002097          	auipc	ra,0x2
    80003aa2:	51e080e7          	jalr	1310(ra) # 80005fbc <panic>
  log.lh.block[i] = b->blockno;
    80003aa6:	00878693          	addi	a3,a5,8
    80003aaa:	068a                	slli	a3,a3,0x2
    80003aac:	00018717          	auipc	a4,0x18
    80003ab0:	59470713          	addi	a4,a4,1428 # 8001c040 <log>
    80003ab4:	9736                	add	a4,a4,a3
    80003ab6:	44d4                	lw	a3,12(s1)
    80003ab8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003aba:	faf609e3          	beq	a2,a5,80003a6c <log_write+0x76>
  }
  release(&log.lock);
    80003abe:	00018517          	auipc	a0,0x18
    80003ac2:	58250513          	addi	a0,a0,1410 # 8001c040 <log>
    80003ac6:	00003097          	auipc	ra,0x3
    80003aca:	b24080e7          	jalr	-1244(ra) # 800065ea <release>
}
    80003ace:	60e2                	ld	ra,24(sp)
    80003ad0:	6442                	ld	s0,16(sp)
    80003ad2:	64a2                	ld	s1,8(sp)
    80003ad4:	6902                	ld	s2,0(sp)
    80003ad6:	6105                	addi	sp,sp,32
    80003ad8:	8082                	ret

0000000080003ada <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ada:	1101                	addi	sp,sp,-32
    80003adc:	ec06                	sd	ra,24(sp)
    80003ade:	e822                	sd	s0,16(sp)
    80003ae0:	e426                	sd	s1,8(sp)
    80003ae2:	e04a                	sd	s2,0(sp)
    80003ae4:	1000                	addi	s0,sp,32
    80003ae6:	84aa                	mv	s1,a0
    80003ae8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003aea:	00005597          	auipc	a1,0x5
    80003aee:	a0658593          	addi	a1,a1,-1530 # 800084f0 <etext+0x4f0>
    80003af2:	0521                	addi	a0,a0,8
    80003af4:	00003097          	auipc	ra,0x3
    80003af8:	9b2080e7          	jalr	-1614(ra) # 800064a6 <initlock>
  lk->name = name;
    80003afc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b00:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b04:	0204a423          	sw	zero,40(s1)
}
    80003b08:	60e2                	ld	ra,24(sp)
    80003b0a:	6442                	ld	s0,16(sp)
    80003b0c:	64a2                	ld	s1,8(sp)
    80003b0e:	6902                	ld	s2,0(sp)
    80003b10:	6105                	addi	sp,sp,32
    80003b12:	8082                	ret

0000000080003b14 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b14:	1101                	addi	sp,sp,-32
    80003b16:	ec06                	sd	ra,24(sp)
    80003b18:	e822                	sd	s0,16(sp)
    80003b1a:	e426                	sd	s1,8(sp)
    80003b1c:	e04a                	sd	s2,0(sp)
    80003b1e:	1000                	addi	s0,sp,32
    80003b20:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b22:	00850913          	addi	s2,a0,8
    80003b26:	854a                	mv	a0,s2
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	a0e080e7          	jalr	-1522(ra) # 80006536 <acquire>
  while (lk->locked) {
    80003b30:	409c                	lw	a5,0(s1)
    80003b32:	cb89                	beqz	a5,80003b44 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b34:	85ca                	mv	a1,s2
    80003b36:	8526                	mv	a0,s1
    80003b38:	ffffe097          	auipc	ra,0xffffe
    80003b3c:	c98080e7          	jalr	-872(ra) # 800017d0 <sleep>
  while (lk->locked) {
    80003b40:	409c                	lw	a5,0(s1)
    80003b42:	fbed                	bnez	a5,80003b34 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b44:	4785                	li	a5,1
    80003b46:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b48:	ffffd097          	auipc	ra,0xffffd
    80003b4c:	5c2080e7          	jalr	1474(ra) # 8000110a <myproc>
    80003b50:	591c                	lw	a5,48(a0)
    80003b52:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b54:	854a                	mv	a0,s2
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	a94080e7          	jalr	-1388(ra) # 800065ea <release>
}
    80003b5e:	60e2                	ld	ra,24(sp)
    80003b60:	6442                	ld	s0,16(sp)
    80003b62:	64a2                	ld	s1,8(sp)
    80003b64:	6902                	ld	s2,0(sp)
    80003b66:	6105                	addi	sp,sp,32
    80003b68:	8082                	ret

0000000080003b6a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b6a:	1101                	addi	sp,sp,-32
    80003b6c:	ec06                	sd	ra,24(sp)
    80003b6e:	e822                	sd	s0,16(sp)
    80003b70:	e426                	sd	s1,8(sp)
    80003b72:	e04a                	sd	s2,0(sp)
    80003b74:	1000                	addi	s0,sp,32
    80003b76:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b78:	00850913          	addi	s2,a0,8
    80003b7c:	854a                	mv	a0,s2
    80003b7e:	00003097          	auipc	ra,0x3
    80003b82:	9b8080e7          	jalr	-1608(ra) # 80006536 <acquire>
  lk->locked = 0;
    80003b86:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b8a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b8e:	8526                	mv	a0,s1
    80003b90:	ffffe097          	auipc	ra,0xffffe
    80003b94:	dcc080e7          	jalr	-564(ra) # 8000195c <wakeup>
  release(&lk->lk);
    80003b98:	854a                	mv	a0,s2
    80003b9a:	00003097          	auipc	ra,0x3
    80003b9e:	a50080e7          	jalr	-1456(ra) # 800065ea <release>
}
    80003ba2:	60e2                	ld	ra,24(sp)
    80003ba4:	6442                	ld	s0,16(sp)
    80003ba6:	64a2                	ld	s1,8(sp)
    80003ba8:	6902                	ld	s2,0(sp)
    80003baa:	6105                	addi	sp,sp,32
    80003bac:	8082                	ret

0000000080003bae <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003bae:	7179                	addi	sp,sp,-48
    80003bb0:	f406                	sd	ra,40(sp)
    80003bb2:	f022                	sd	s0,32(sp)
    80003bb4:	ec26                	sd	s1,24(sp)
    80003bb6:	e84a                	sd	s2,16(sp)
    80003bb8:	1800                	addi	s0,sp,48
    80003bba:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bbc:	00850913          	addi	s2,a0,8
    80003bc0:	854a                	mv	a0,s2
    80003bc2:	00003097          	auipc	ra,0x3
    80003bc6:	974080e7          	jalr	-1676(ra) # 80006536 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bca:	409c                	lw	a5,0(s1)
    80003bcc:	ef91                	bnez	a5,80003be8 <holdingsleep+0x3a>
    80003bce:	4481                	li	s1,0
  release(&lk->lk);
    80003bd0:	854a                	mv	a0,s2
    80003bd2:	00003097          	auipc	ra,0x3
    80003bd6:	a18080e7          	jalr	-1512(ra) # 800065ea <release>
  return r;
}
    80003bda:	8526                	mv	a0,s1
    80003bdc:	70a2                	ld	ra,40(sp)
    80003bde:	7402                	ld	s0,32(sp)
    80003be0:	64e2                	ld	s1,24(sp)
    80003be2:	6942                	ld	s2,16(sp)
    80003be4:	6145                	addi	sp,sp,48
    80003be6:	8082                	ret
    80003be8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bea:	0284a983          	lw	s3,40(s1)
    80003bee:	ffffd097          	auipc	ra,0xffffd
    80003bf2:	51c080e7          	jalr	1308(ra) # 8000110a <myproc>
    80003bf6:	5904                	lw	s1,48(a0)
    80003bf8:	413484b3          	sub	s1,s1,s3
    80003bfc:	0014b493          	seqz	s1,s1
    80003c00:	69a2                	ld	s3,8(sp)
    80003c02:	b7f9                	j	80003bd0 <holdingsleep+0x22>

0000000080003c04 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c04:	1141                	addi	sp,sp,-16
    80003c06:	e406                	sd	ra,8(sp)
    80003c08:	e022                	sd	s0,0(sp)
    80003c0a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c0c:	00005597          	auipc	a1,0x5
    80003c10:	8f458593          	addi	a1,a1,-1804 # 80008500 <etext+0x500>
    80003c14:	00018517          	auipc	a0,0x18
    80003c18:	57450513          	addi	a0,a0,1396 # 8001c188 <ftable>
    80003c1c:	00003097          	auipc	ra,0x3
    80003c20:	88a080e7          	jalr	-1910(ra) # 800064a6 <initlock>
}
    80003c24:	60a2                	ld	ra,8(sp)
    80003c26:	6402                	ld	s0,0(sp)
    80003c28:	0141                	addi	sp,sp,16
    80003c2a:	8082                	ret

0000000080003c2c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c2c:	1101                	addi	sp,sp,-32
    80003c2e:	ec06                	sd	ra,24(sp)
    80003c30:	e822                	sd	s0,16(sp)
    80003c32:	e426                	sd	s1,8(sp)
    80003c34:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c36:	00018517          	auipc	a0,0x18
    80003c3a:	55250513          	addi	a0,a0,1362 # 8001c188 <ftable>
    80003c3e:	00003097          	auipc	ra,0x3
    80003c42:	8f8080e7          	jalr	-1800(ra) # 80006536 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c46:	00018497          	auipc	s1,0x18
    80003c4a:	55a48493          	addi	s1,s1,1370 # 8001c1a0 <ftable+0x18>
    80003c4e:	00019717          	auipc	a4,0x19
    80003c52:	4f270713          	addi	a4,a4,1266 # 8001d140 <ftable+0xfb8>
    if(f->ref == 0){
    80003c56:	40dc                	lw	a5,4(s1)
    80003c58:	cf99                	beqz	a5,80003c76 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c5a:	02848493          	addi	s1,s1,40
    80003c5e:	fee49ce3          	bne	s1,a4,80003c56 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c62:	00018517          	auipc	a0,0x18
    80003c66:	52650513          	addi	a0,a0,1318 # 8001c188 <ftable>
    80003c6a:	00003097          	auipc	ra,0x3
    80003c6e:	980080e7          	jalr	-1664(ra) # 800065ea <release>
  return 0;
    80003c72:	4481                	li	s1,0
    80003c74:	a819                	j	80003c8a <filealloc+0x5e>
      f->ref = 1;
    80003c76:	4785                	li	a5,1
    80003c78:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c7a:	00018517          	auipc	a0,0x18
    80003c7e:	50e50513          	addi	a0,a0,1294 # 8001c188 <ftable>
    80003c82:	00003097          	auipc	ra,0x3
    80003c86:	968080e7          	jalr	-1688(ra) # 800065ea <release>
}
    80003c8a:	8526                	mv	a0,s1
    80003c8c:	60e2                	ld	ra,24(sp)
    80003c8e:	6442                	ld	s0,16(sp)
    80003c90:	64a2                	ld	s1,8(sp)
    80003c92:	6105                	addi	sp,sp,32
    80003c94:	8082                	ret

0000000080003c96 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c96:	1101                	addi	sp,sp,-32
    80003c98:	ec06                	sd	ra,24(sp)
    80003c9a:	e822                	sd	s0,16(sp)
    80003c9c:	e426                	sd	s1,8(sp)
    80003c9e:	1000                	addi	s0,sp,32
    80003ca0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ca2:	00018517          	auipc	a0,0x18
    80003ca6:	4e650513          	addi	a0,a0,1254 # 8001c188 <ftable>
    80003caa:	00003097          	auipc	ra,0x3
    80003cae:	88c080e7          	jalr	-1908(ra) # 80006536 <acquire>
  if(f->ref < 1)
    80003cb2:	40dc                	lw	a5,4(s1)
    80003cb4:	02f05263          	blez	a5,80003cd8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003cb8:	2785                	addiw	a5,a5,1
    80003cba:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cbc:	00018517          	auipc	a0,0x18
    80003cc0:	4cc50513          	addi	a0,a0,1228 # 8001c188 <ftable>
    80003cc4:	00003097          	auipc	ra,0x3
    80003cc8:	926080e7          	jalr	-1754(ra) # 800065ea <release>
  return f;
}
    80003ccc:	8526                	mv	a0,s1
    80003cce:	60e2                	ld	ra,24(sp)
    80003cd0:	6442                	ld	s0,16(sp)
    80003cd2:	64a2                	ld	s1,8(sp)
    80003cd4:	6105                	addi	sp,sp,32
    80003cd6:	8082                	ret
    panic("filedup");
    80003cd8:	00005517          	auipc	a0,0x5
    80003cdc:	83050513          	addi	a0,a0,-2000 # 80008508 <etext+0x508>
    80003ce0:	00002097          	auipc	ra,0x2
    80003ce4:	2dc080e7          	jalr	732(ra) # 80005fbc <panic>

0000000080003ce8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ce8:	7139                	addi	sp,sp,-64
    80003cea:	fc06                	sd	ra,56(sp)
    80003cec:	f822                	sd	s0,48(sp)
    80003cee:	f426                	sd	s1,40(sp)
    80003cf0:	0080                	addi	s0,sp,64
    80003cf2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cf4:	00018517          	auipc	a0,0x18
    80003cf8:	49450513          	addi	a0,a0,1172 # 8001c188 <ftable>
    80003cfc:	00003097          	auipc	ra,0x3
    80003d00:	83a080e7          	jalr	-1990(ra) # 80006536 <acquire>
  if(f->ref < 1)
    80003d04:	40dc                	lw	a5,4(s1)
    80003d06:	04f05c63          	blez	a5,80003d5e <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003d0a:	37fd                	addiw	a5,a5,-1
    80003d0c:	0007871b          	sext.w	a4,a5
    80003d10:	c0dc                	sw	a5,4(s1)
    80003d12:	06e04263          	bgtz	a4,80003d76 <fileclose+0x8e>
    80003d16:	f04a                	sd	s2,32(sp)
    80003d18:	ec4e                	sd	s3,24(sp)
    80003d1a:	e852                	sd	s4,16(sp)
    80003d1c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d1e:	0004a903          	lw	s2,0(s1)
    80003d22:	0094ca83          	lbu	s5,9(s1)
    80003d26:	0104ba03          	ld	s4,16(s1)
    80003d2a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d2e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d32:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d36:	00018517          	auipc	a0,0x18
    80003d3a:	45250513          	addi	a0,a0,1106 # 8001c188 <ftable>
    80003d3e:	00003097          	auipc	ra,0x3
    80003d42:	8ac080e7          	jalr	-1876(ra) # 800065ea <release>

  if(ff.type == FD_PIPE){
    80003d46:	4785                	li	a5,1
    80003d48:	04f90463          	beq	s2,a5,80003d90 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d4c:	3979                	addiw	s2,s2,-2
    80003d4e:	4785                	li	a5,1
    80003d50:	0527fb63          	bgeu	a5,s2,80003da6 <fileclose+0xbe>
    80003d54:	7902                	ld	s2,32(sp)
    80003d56:	69e2                	ld	s3,24(sp)
    80003d58:	6a42                	ld	s4,16(sp)
    80003d5a:	6aa2                	ld	s5,8(sp)
    80003d5c:	a02d                	j	80003d86 <fileclose+0x9e>
    80003d5e:	f04a                	sd	s2,32(sp)
    80003d60:	ec4e                	sd	s3,24(sp)
    80003d62:	e852                	sd	s4,16(sp)
    80003d64:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003d66:	00004517          	auipc	a0,0x4
    80003d6a:	7aa50513          	addi	a0,a0,1962 # 80008510 <etext+0x510>
    80003d6e:	00002097          	auipc	ra,0x2
    80003d72:	24e080e7          	jalr	590(ra) # 80005fbc <panic>
    release(&ftable.lock);
    80003d76:	00018517          	auipc	a0,0x18
    80003d7a:	41250513          	addi	a0,a0,1042 # 8001c188 <ftable>
    80003d7e:	00003097          	auipc	ra,0x3
    80003d82:	86c080e7          	jalr	-1940(ra) # 800065ea <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d86:	70e2                	ld	ra,56(sp)
    80003d88:	7442                	ld	s0,48(sp)
    80003d8a:	74a2                	ld	s1,40(sp)
    80003d8c:	6121                	addi	sp,sp,64
    80003d8e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d90:	85d6                	mv	a1,s5
    80003d92:	8552                	mv	a0,s4
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	3a2080e7          	jalr	930(ra) # 80004136 <pipeclose>
    80003d9c:	7902                	ld	s2,32(sp)
    80003d9e:	69e2                	ld	s3,24(sp)
    80003da0:	6a42                	ld	s4,16(sp)
    80003da2:	6aa2                	ld	s5,8(sp)
    80003da4:	b7cd                	j	80003d86 <fileclose+0x9e>
    begin_op();
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	a78080e7          	jalr	-1416(ra) # 8000381e <begin_op>
    iput(ff.ip);
    80003dae:	854e                	mv	a0,s3
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	25a080e7          	jalr	602(ra) # 8000300a <iput>
    end_op();
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	ae0080e7          	jalr	-1312(ra) # 80003898 <end_op>
    80003dc0:	7902                	ld	s2,32(sp)
    80003dc2:	69e2                	ld	s3,24(sp)
    80003dc4:	6a42                	ld	s4,16(sp)
    80003dc6:	6aa2                	ld	s5,8(sp)
    80003dc8:	bf7d                	j	80003d86 <fileclose+0x9e>

0000000080003dca <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003dca:	715d                	addi	sp,sp,-80
    80003dcc:	e486                	sd	ra,72(sp)
    80003dce:	e0a2                	sd	s0,64(sp)
    80003dd0:	fc26                	sd	s1,56(sp)
    80003dd2:	f44e                	sd	s3,40(sp)
    80003dd4:	0880                	addi	s0,sp,80
    80003dd6:	84aa                	mv	s1,a0
    80003dd8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dda:	ffffd097          	auipc	ra,0xffffd
    80003dde:	330080e7          	jalr	816(ra) # 8000110a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003de2:	409c                	lw	a5,0(s1)
    80003de4:	37f9                	addiw	a5,a5,-2
    80003de6:	4705                	li	a4,1
    80003de8:	04f76863          	bltu	a4,a5,80003e38 <filestat+0x6e>
    80003dec:	f84a                	sd	s2,48(sp)
    80003dee:	892a                	mv	s2,a0
    ilock(f->ip);
    80003df0:	6c88                	ld	a0,24(s1)
    80003df2:	fffff097          	auipc	ra,0xfffff
    80003df6:	05a080e7          	jalr	90(ra) # 80002e4c <ilock>
    stati(f->ip, &st);
    80003dfa:	fb840593          	addi	a1,s0,-72
    80003dfe:	6c88                	ld	a0,24(s1)
    80003e00:	fffff097          	auipc	ra,0xfffff
    80003e04:	2da080e7          	jalr	730(ra) # 800030da <stati>
    iunlock(f->ip);
    80003e08:	6c88                	ld	a0,24(s1)
    80003e0a:	fffff097          	auipc	ra,0xfffff
    80003e0e:	108080e7          	jalr	264(ra) # 80002f12 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e12:	46e1                	li	a3,24
    80003e14:	fb840613          	addi	a2,s0,-72
    80003e18:	85ce                	mv	a1,s3
    80003e1a:	05093503          	ld	a0,80(s2)
    80003e1e:	ffffd097          	auipc	ra,0xffffd
    80003e22:	e44080e7          	jalr	-444(ra) # 80000c62 <copyout>
    80003e26:	41f5551b          	sraiw	a0,a0,0x1f
    80003e2a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003e2c:	60a6                	ld	ra,72(sp)
    80003e2e:	6406                	ld	s0,64(sp)
    80003e30:	74e2                	ld	s1,56(sp)
    80003e32:	79a2                	ld	s3,40(sp)
    80003e34:	6161                	addi	sp,sp,80
    80003e36:	8082                	ret
  return -1;
    80003e38:	557d                	li	a0,-1
    80003e3a:	bfcd                	j	80003e2c <filestat+0x62>

0000000080003e3c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e3c:	7179                	addi	sp,sp,-48
    80003e3e:	f406                	sd	ra,40(sp)
    80003e40:	f022                	sd	s0,32(sp)
    80003e42:	e84a                	sd	s2,16(sp)
    80003e44:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e46:	00854783          	lbu	a5,8(a0)
    80003e4a:	cbc5                	beqz	a5,80003efa <fileread+0xbe>
    80003e4c:	ec26                	sd	s1,24(sp)
    80003e4e:	e44e                	sd	s3,8(sp)
    80003e50:	84aa                	mv	s1,a0
    80003e52:	89ae                	mv	s3,a1
    80003e54:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e56:	411c                	lw	a5,0(a0)
    80003e58:	4705                	li	a4,1
    80003e5a:	04e78963          	beq	a5,a4,80003eac <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e5e:	470d                	li	a4,3
    80003e60:	04e78f63          	beq	a5,a4,80003ebe <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e64:	4709                	li	a4,2
    80003e66:	08e79263          	bne	a5,a4,80003eea <fileread+0xae>
    ilock(f->ip);
    80003e6a:	6d08                	ld	a0,24(a0)
    80003e6c:	fffff097          	auipc	ra,0xfffff
    80003e70:	fe0080e7          	jalr	-32(ra) # 80002e4c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e74:	874a                	mv	a4,s2
    80003e76:	5094                	lw	a3,32(s1)
    80003e78:	864e                	mv	a2,s3
    80003e7a:	4585                	li	a1,1
    80003e7c:	6c88                	ld	a0,24(s1)
    80003e7e:	fffff097          	auipc	ra,0xfffff
    80003e82:	286080e7          	jalr	646(ra) # 80003104 <readi>
    80003e86:	892a                	mv	s2,a0
    80003e88:	00a05563          	blez	a0,80003e92 <fileread+0x56>
      f->off += r;
    80003e8c:	509c                	lw	a5,32(s1)
    80003e8e:	9fa9                	addw	a5,a5,a0
    80003e90:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e92:	6c88                	ld	a0,24(s1)
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	07e080e7          	jalr	126(ra) # 80002f12 <iunlock>
    80003e9c:	64e2                	ld	s1,24(sp)
    80003e9e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003ea0:	854a                	mv	a0,s2
    80003ea2:	70a2                	ld	ra,40(sp)
    80003ea4:	7402                	ld	s0,32(sp)
    80003ea6:	6942                	ld	s2,16(sp)
    80003ea8:	6145                	addi	sp,sp,48
    80003eaa:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003eac:	6908                	ld	a0,16(a0)
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	3fa080e7          	jalr	1018(ra) # 800042a8 <piperead>
    80003eb6:	892a                	mv	s2,a0
    80003eb8:	64e2                	ld	s1,24(sp)
    80003eba:	69a2                	ld	s3,8(sp)
    80003ebc:	b7d5                	j	80003ea0 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ebe:	02451783          	lh	a5,36(a0)
    80003ec2:	03079693          	slli	a3,a5,0x30
    80003ec6:	92c1                	srli	a3,a3,0x30
    80003ec8:	4725                	li	a4,9
    80003eca:	02d76a63          	bltu	a4,a3,80003efe <fileread+0xc2>
    80003ece:	0792                	slli	a5,a5,0x4
    80003ed0:	00018717          	auipc	a4,0x18
    80003ed4:	21870713          	addi	a4,a4,536 # 8001c0e8 <devsw>
    80003ed8:	97ba                	add	a5,a5,a4
    80003eda:	639c                	ld	a5,0(a5)
    80003edc:	c78d                	beqz	a5,80003f06 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ede:	4505                	li	a0,1
    80003ee0:	9782                	jalr	a5
    80003ee2:	892a                	mv	s2,a0
    80003ee4:	64e2                	ld	s1,24(sp)
    80003ee6:	69a2                	ld	s3,8(sp)
    80003ee8:	bf65                	j	80003ea0 <fileread+0x64>
    panic("fileread");
    80003eea:	00004517          	auipc	a0,0x4
    80003eee:	63650513          	addi	a0,a0,1590 # 80008520 <etext+0x520>
    80003ef2:	00002097          	auipc	ra,0x2
    80003ef6:	0ca080e7          	jalr	202(ra) # 80005fbc <panic>
    return -1;
    80003efa:	597d                	li	s2,-1
    80003efc:	b755                	j	80003ea0 <fileread+0x64>
      return -1;
    80003efe:	597d                	li	s2,-1
    80003f00:	64e2                	ld	s1,24(sp)
    80003f02:	69a2                	ld	s3,8(sp)
    80003f04:	bf71                	j	80003ea0 <fileread+0x64>
    80003f06:	597d                	li	s2,-1
    80003f08:	64e2                	ld	s1,24(sp)
    80003f0a:	69a2                	ld	s3,8(sp)
    80003f0c:	bf51                	j	80003ea0 <fileread+0x64>

0000000080003f0e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f0e:	00954783          	lbu	a5,9(a0)
    80003f12:	12078963          	beqz	a5,80004044 <filewrite+0x136>
{
    80003f16:	715d                	addi	sp,sp,-80
    80003f18:	e486                	sd	ra,72(sp)
    80003f1a:	e0a2                	sd	s0,64(sp)
    80003f1c:	f84a                	sd	s2,48(sp)
    80003f1e:	f052                	sd	s4,32(sp)
    80003f20:	e85a                	sd	s6,16(sp)
    80003f22:	0880                	addi	s0,sp,80
    80003f24:	892a                	mv	s2,a0
    80003f26:	8b2e                	mv	s6,a1
    80003f28:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f2a:	411c                	lw	a5,0(a0)
    80003f2c:	4705                	li	a4,1
    80003f2e:	02e78763          	beq	a5,a4,80003f5c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f32:	470d                	li	a4,3
    80003f34:	02e78a63          	beq	a5,a4,80003f68 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f38:	4709                	li	a4,2
    80003f3a:	0ee79863          	bne	a5,a4,8000402a <filewrite+0x11c>
    80003f3e:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f40:	0cc05463          	blez	a2,80004008 <filewrite+0xfa>
    80003f44:	fc26                	sd	s1,56(sp)
    80003f46:	ec56                	sd	s5,24(sp)
    80003f48:	e45e                	sd	s7,8(sp)
    80003f4a:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f4c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f4e:	6b85                	lui	s7,0x1
    80003f50:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f54:	6c05                	lui	s8,0x1
    80003f56:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f5a:	a851                	j	80003fee <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003f5c:	6908                	ld	a0,16(a0)
    80003f5e:	00000097          	auipc	ra,0x0
    80003f62:	248080e7          	jalr	584(ra) # 800041a6 <pipewrite>
    80003f66:	a85d                	j	8000401c <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f68:	02451783          	lh	a5,36(a0)
    80003f6c:	03079693          	slli	a3,a5,0x30
    80003f70:	92c1                	srli	a3,a3,0x30
    80003f72:	4725                	li	a4,9
    80003f74:	0cd76a63          	bltu	a4,a3,80004048 <filewrite+0x13a>
    80003f78:	0792                	slli	a5,a5,0x4
    80003f7a:	00018717          	auipc	a4,0x18
    80003f7e:	16e70713          	addi	a4,a4,366 # 8001c0e8 <devsw>
    80003f82:	97ba                	add	a5,a5,a4
    80003f84:	679c                	ld	a5,8(a5)
    80003f86:	c3f9                	beqz	a5,8000404c <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003f88:	4505                	li	a0,1
    80003f8a:	9782                	jalr	a5
    80003f8c:	a841                	j	8000401c <filewrite+0x10e>
      if(n1 > max)
    80003f8e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	88c080e7          	jalr	-1908(ra) # 8000381e <begin_op>
      ilock(f->ip);
    80003f9a:	01893503          	ld	a0,24(s2)
    80003f9e:	fffff097          	auipc	ra,0xfffff
    80003fa2:	eae080e7          	jalr	-338(ra) # 80002e4c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fa6:	8756                	mv	a4,s5
    80003fa8:	02092683          	lw	a3,32(s2)
    80003fac:	01698633          	add	a2,s3,s6
    80003fb0:	4585                	li	a1,1
    80003fb2:	01893503          	ld	a0,24(s2)
    80003fb6:	fffff097          	auipc	ra,0xfffff
    80003fba:	252080e7          	jalr	594(ra) # 80003208 <writei>
    80003fbe:	84aa                	mv	s1,a0
    80003fc0:	00a05763          	blez	a0,80003fce <filewrite+0xc0>
        f->off += r;
    80003fc4:	02092783          	lw	a5,32(s2)
    80003fc8:	9fa9                	addw	a5,a5,a0
    80003fca:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fce:	01893503          	ld	a0,24(s2)
    80003fd2:	fffff097          	auipc	ra,0xfffff
    80003fd6:	f40080e7          	jalr	-192(ra) # 80002f12 <iunlock>
      end_op();
    80003fda:	00000097          	auipc	ra,0x0
    80003fde:	8be080e7          	jalr	-1858(ra) # 80003898 <end_op>

      if(r != n1){
    80003fe2:	029a9563          	bne	s5,s1,8000400c <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003fe6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fea:	0149da63          	bge	s3,s4,80003ffe <filewrite+0xf0>
      int n1 = n - i;
    80003fee:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003ff2:	0004879b          	sext.w	a5,s1
    80003ff6:	f8fbdce3          	bge	s7,a5,80003f8e <filewrite+0x80>
    80003ffa:	84e2                	mv	s1,s8
    80003ffc:	bf49                	j	80003f8e <filewrite+0x80>
    80003ffe:	74e2                	ld	s1,56(sp)
    80004000:	6ae2                	ld	s5,24(sp)
    80004002:	6ba2                	ld	s7,8(sp)
    80004004:	6c02                	ld	s8,0(sp)
    80004006:	a039                	j	80004014 <filewrite+0x106>
    int i = 0;
    80004008:	4981                	li	s3,0
    8000400a:	a029                	j	80004014 <filewrite+0x106>
    8000400c:	74e2                	ld	s1,56(sp)
    8000400e:	6ae2                	ld	s5,24(sp)
    80004010:	6ba2                	ld	s7,8(sp)
    80004012:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004014:	033a1e63          	bne	s4,s3,80004050 <filewrite+0x142>
    80004018:	8552                	mv	a0,s4
    8000401a:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000401c:	60a6                	ld	ra,72(sp)
    8000401e:	6406                	ld	s0,64(sp)
    80004020:	7942                	ld	s2,48(sp)
    80004022:	7a02                	ld	s4,32(sp)
    80004024:	6b42                	ld	s6,16(sp)
    80004026:	6161                	addi	sp,sp,80
    80004028:	8082                	ret
    8000402a:	fc26                	sd	s1,56(sp)
    8000402c:	f44e                	sd	s3,40(sp)
    8000402e:	ec56                	sd	s5,24(sp)
    80004030:	e45e                	sd	s7,8(sp)
    80004032:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004034:	00004517          	auipc	a0,0x4
    80004038:	4fc50513          	addi	a0,a0,1276 # 80008530 <etext+0x530>
    8000403c:	00002097          	auipc	ra,0x2
    80004040:	f80080e7          	jalr	-128(ra) # 80005fbc <panic>
    return -1;
    80004044:	557d                	li	a0,-1
}
    80004046:	8082                	ret
      return -1;
    80004048:	557d                	li	a0,-1
    8000404a:	bfc9                	j	8000401c <filewrite+0x10e>
    8000404c:	557d                	li	a0,-1
    8000404e:	b7f9                	j	8000401c <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004050:	557d                	li	a0,-1
    80004052:	79a2                	ld	s3,40(sp)
    80004054:	b7e1                	j	8000401c <filewrite+0x10e>

0000000080004056 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004056:	7179                	addi	sp,sp,-48
    80004058:	f406                	sd	ra,40(sp)
    8000405a:	f022                	sd	s0,32(sp)
    8000405c:	ec26                	sd	s1,24(sp)
    8000405e:	e052                	sd	s4,0(sp)
    80004060:	1800                	addi	s0,sp,48
    80004062:	84aa                	mv	s1,a0
    80004064:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004066:	0005b023          	sd	zero,0(a1)
    8000406a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000406e:	00000097          	auipc	ra,0x0
    80004072:	bbe080e7          	jalr	-1090(ra) # 80003c2c <filealloc>
    80004076:	e088                	sd	a0,0(s1)
    80004078:	cd49                	beqz	a0,80004112 <pipealloc+0xbc>
    8000407a:	00000097          	auipc	ra,0x0
    8000407e:	bb2080e7          	jalr	-1102(ra) # 80003c2c <filealloc>
    80004082:	00aa3023          	sd	a0,0(s4)
    80004086:	c141                	beqz	a0,80004106 <pipealloc+0xb0>
    80004088:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000408a:	ffffc097          	auipc	ra,0xffffc
    8000408e:	144080e7          	jalr	324(ra) # 800001ce <kalloc>
    80004092:	892a                	mv	s2,a0
    80004094:	c13d                	beqz	a0,800040fa <pipealloc+0xa4>
    80004096:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004098:	4985                	li	s3,1
    8000409a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000409e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800040a2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800040a6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800040aa:	00004597          	auipc	a1,0x4
    800040ae:	49658593          	addi	a1,a1,1174 # 80008540 <etext+0x540>
    800040b2:	00002097          	auipc	ra,0x2
    800040b6:	3f4080e7          	jalr	1012(ra) # 800064a6 <initlock>
  (*f0)->type = FD_PIPE;
    800040ba:	609c                	ld	a5,0(s1)
    800040bc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040c0:	609c                	ld	a5,0(s1)
    800040c2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040c6:	609c                	ld	a5,0(s1)
    800040c8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040cc:	609c                	ld	a5,0(s1)
    800040ce:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040d2:	000a3783          	ld	a5,0(s4)
    800040d6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040da:	000a3783          	ld	a5,0(s4)
    800040de:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040e2:	000a3783          	ld	a5,0(s4)
    800040e6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040ea:	000a3783          	ld	a5,0(s4)
    800040ee:	0127b823          	sd	s2,16(a5)
  return 0;
    800040f2:	4501                	li	a0,0
    800040f4:	6942                	ld	s2,16(sp)
    800040f6:	69a2                	ld	s3,8(sp)
    800040f8:	a03d                	j	80004126 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040fa:	6088                	ld	a0,0(s1)
    800040fc:	c119                	beqz	a0,80004102 <pipealloc+0xac>
    800040fe:	6942                	ld	s2,16(sp)
    80004100:	a029                	j	8000410a <pipealloc+0xb4>
    80004102:	6942                	ld	s2,16(sp)
    80004104:	a039                	j	80004112 <pipealloc+0xbc>
    80004106:	6088                	ld	a0,0(s1)
    80004108:	c50d                	beqz	a0,80004132 <pipealloc+0xdc>
    fileclose(*f0);
    8000410a:	00000097          	auipc	ra,0x0
    8000410e:	bde080e7          	jalr	-1058(ra) # 80003ce8 <fileclose>
  if(*f1)
    80004112:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004116:	557d                	li	a0,-1
  if(*f1)
    80004118:	c799                	beqz	a5,80004126 <pipealloc+0xd0>
    fileclose(*f1);
    8000411a:	853e                	mv	a0,a5
    8000411c:	00000097          	auipc	ra,0x0
    80004120:	bcc080e7          	jalr	-1076(ra) # 80003ce8 <fileclose>
  return -1;
    80004124:	557d                	li	a0,-1
}
    80004126:	70a2                	ld	ra,40(sp)
    80004128:	7402                	ld	s0,32(sp)
    8000412a:	64e2                	ld	s1,24(sp)
    8000412c:	6a02                	ld	s4,0(sp)
    8000412e:	6145                	addi	sp,sp,48
    80004130:	8082                	ret
  return -1;
    80004132:	557d                	li	a0,-1
    80004134:	bfcd                	j	80004126 <pipealloc+0xd0>

0000000080004136 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004136:	1101                	addi	sp,sp,-32
    80004138:	ec06                	sd	ra,24(sp)
    8000413a:	e822                	sd	s0,16(sp)
    8000413c:	e426                	sd	s1,8(sp)
    8000413e:	e04a                	sd	s2,0(sp)
    80004140:	1000                	addi	s0,sp,32
    80004142:	84aa                	mv	s1,a0
    80004144:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004146:	00002097          	auipc	ra,0x2
    8000414a:	3f0080e7          	jalr	1008(ra) # 80006536 <acquire>
  if(writable){
    8000414e:	02090d63          	beqz	s2,80004188 <pipeclose+0x52>
    pi->writeopen = 0;
    80004152:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004156:	21848513          	addi	a0,s1,536
    8000415a:	ffffe097          	auipc	ra,0xffffe
    8000415e:	802080e7          	jalr	-2046(ra) # 8000195c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004162:	2204b783          	ld	a5,544(s1)
    80004166:	eb95                	bnez	a5,8000419a <pipeclose+0x64>
    release(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	480080e7          	jalr	1152(ra) # 800065ea <release>
    kfree((char*)pi);
    80004172:	8526                	mv	a0,s1
    80004174:	ffffc097          	auipc	ra,0xffffc
    80004178:	ea8080e7          	jalr	-344(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000417c:	60e2                	ld	ra,24(sp)
    8000417e:	6442                	ld	s0,16(sp)
    80004180:	64a2                	ld	s1,8(sp)
    80004182:	6902                	ld	s2,0(sp)
    80004184:	6105                	addi	sp,sp,32
    80004186:	8082                	ret
    pi->readopen = 0;
    80004188:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000418c:	21c48513          	addi	a0,s1,540
    80004190:	ffffd097          	auipc	ra,0xffffd
    80004194:	7cc080e7          	jalr	1996(ra) # 8000195c <wakeup>
    80004198:	b7e9                	j	80004162 <pipeclose+0x2c>
    release(&pi->lock);
    8000419a:	8526                	mv	a0,s1
    8000419c:	00002097          	auipc	ra,0x2
    800041a0:	44e080e7          	jalr	1102(ra) # 800065ea <release>
}
    800041a4:	bfe1                	j	8000417c <pipeclose+0x46>

00000000800041a6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800041a6:	711d                	addi	sp,sp,-96
    800041a8:	ec86                	sd	ra,88(sp)
    800041aa:	e8a2                	sd	s0,80(sp)
    800041ac:	e4a6                	sd	s1,72(sp)
    800041ae:	e0ca                	sd	s2,64(sp)
    800041b0:	fc4e                	sd	s3,56(sp)
    800041b2:	f852                	sd	s4,48(sp)
    800041b4:	f456                	sd	s5,40(sp)
    800041b6:	1080                	addi	s0,sp,96
    800041b8:	84aa                	mv	s1,a0
    800041ba:	8aae                	mv	s5,a1
    800041bc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	f4c080e7          	jalr	-180(ra) # 8000110a <myproc>
    800041c6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041c8:	8526                	mv	a0,s1
    800041ca:	00002097          	auipc	ra,0x2
    800041ce:	36c080e7          	jalr	876(ra) # 80006536 <acquire>
  while(i < n){
    800041d2:	0d405563          	blez	s4,8000429c <pipewrite+0xf6>
    800041d6:	f05a                	sd	s6,32(sp)
    800041d8:	ec5e                	sd	s7,24(sp)
    800041da:	e862                	sd	s8,16(sp)
  int i = 0;
    800041dc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041de:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041e0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041e4:	21c48b93          	addi	s7,s1,540
    800041e8:	a089                	j	8000422a <pipewrite+0x84>
      release(&pi->lock);
    800041ea:	8526                	mv	a0,s1
    800041ec:	00002097          	auipc	ra,0x2
    800041f0:	3fe080e7          	jalr	1022(ra) # 800065ea <release>
      return -1;
    800041f4:	597d                	li	s2,-1
    800041f6:	7b02                	ld	s6,32(sp)
    800041f8:	6be2                	ld	s7,24(sp)
    800041fa:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041fc:	854a                	mv	a0,s2
    800041fe:	60e6                	ld	ra,88(sp)
    80004200:	6446                	ld	s0,80(sp)
    80004202:	64a6                	ld	s1,72(sp)
    80004204:	6906                	ld	s2,64(sp)
    80004206:	79e2                	ld	s3,56(sp)
    80004208:	7a42                	ld	s4,48(sp)
    8000420a:	7aa2                	ld	s5,40(sp)
    8000420c:	6125                	addi	sp,sp,96
    8000420e:	8082                	ret
      wakeup(&pi->nread);
    80004210:	8562                	mv	a0,s8
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	74a080e7          	jalr	1866(ra) # 8000195c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000421a:	85a6                	mv	a1,s1
    8000421c:	855e                	mv	a0,s7
    8000421e:	ffffd097          	auipc	ra,0xffffd
    80004222:	5b2080e7          	jalr	1458(ra) # 800017d0 <sleep>
  while(i < n){
    80004226:	05495c63          	bge	s2,s4,8000427e <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    8000422a:	2204a783          	lw	a5,544(s1)
    8000422e:	dfd5                	beqz	a5,800041ea <pipewrite+0x44>
    80004230:	0289a783          	lw	a5,40(s3)
    80004234:	fbdd                	bnez	a5,800041ea <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004236:	2184a783          	lw	a5,536(s1)
    8000423a:	21c4a703          	lw	a4,540(s1)
    8000423e:	2007879b          	addiw	a5,a5,512
    80004242:	fcf707e3          	beq	a4,a5,80004210 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004246:	4685                	li	a3,1
    80004248:	01590633          	add	a2,s2,s5
    8000424c:	faf40593          	addi	a1,s0,-81
    80004250:	0509b503          	ld	a0,80(s3)
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	bde080e7          	jalr	-1058(ra) # 80000e32 <copyin>
    8000425c:	05650263          	beq	a0,s6,800042a0 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004260:	21c4a783          	lw	a5,540(s1)
    80004264:	0017871b          	addiw	a4,a5,1
    80004268:	20e4ae23          	sw	a4,540(s1)
    8000426c:	1ff7f793          	andi	a5,a5,511
    80004270:	97a6                	add	a5,a5,s1
    80004272:	faf44703          	lbu	a4,-81(s0)
    80004276:	00e78c23          	sb	a4,24(a5)
      i++;
    8000427a:	2905                	addiw	s2,s2,1
    8000427c:	b76d                	j	80004226 <pipewrite+0x80>
    8000427e:	7b02                	ld	s6,32(sp)
    80004280:	6be2                	ld	s7,24(sp)
    80004282:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004284:	21848513          	addi	a0,s1,536
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	6d4080e7          	jalr	1748(ra) # 8000195c <wakeup>
  release(&pi->lock);
    80004290:	8526                	mv	a0,s1
    80004292:	00002097          	auipc	ra,0x2
    80004296:	358080e7          	jalr	856(ra) # 800065ea <release>
  return i;
    8000429a:	b78d                	j	800041fc <pipewrite+0x56>
  int i = 0;
    8000429c:	4901                	li	s2,0
    8000429e:	b7dd                	j	80004284 <pipewrite+0xde>
    800042a0:	7b02                	ld	s6,32(sp)
    800042a2:	6be2                	ld	s7,24(sp)
    800042a4:	6c42                	ld	s8,16(sp)
    800042a6:	bff9                	j	80004284 <pipewrite+0xde>

00000000800042a8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800042a8:	715d                	addi	sp,sp,-80
    800042aa:	e486                	sd	ra,72(sp)
    800042ac:	e0a2                	sd	s0,64(sp)
    800042ae:	fc26                	sd	s1,56(sp)
    800042b0:	f84a                	sd	s2,48(sp)
    800042b2:	f44e                	sd	s3,40(sp)
    800042b4:	f052                	sd	s4,32(sp)
    800042b6:	ec56                	sd	s5,24(sp)
    800042b8:	0880                	addi	s0,sp,80
    800042ba:	84aa                	mv	s1,a0
    800042bc:	892e                	mv	s2,a1
    800042be:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042c0:	ffffd097          	auipc	ra,0xffffd
    800042c4:	e4a080e7          	jalr	-438(ra) # 8000110a <myproc>
    800042c8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042ca:	8526                	mv	a0,s1
    800042cc:	00002097          	auipc	ra,0x2
    800042d0:	26a080e7          	jalr	618(ra) # 80006536 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042d4:	2184a703          	lw	a4,536(s1)
    800042d8:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042dc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042e0:	02f71663          	bne	a4,a5,8000430c <piperead+0x64>
    800042e4:	2244a783          	lw	a5,548(s1)
    800042e8:	cb9d                	beqz	a5,8000431e <piperead+0x76>
    if(pr->killed){
    800042ea:	028a2783          	lw	a5,40(s4)
    800042ee:	e38d                	bnez	a5,80004310 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042f0:	85a6                	mv	a1,s1
    800042f2:	854e                	mv	a0,s3
    800042f4:	ffffd097          	auipc	ra,0xffffd
    800042f8:	4dc080e7          	jalr	1244(ra) # 800017d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042fc:	2184a703          	lw	a4,536(s1)
    80004300:	21c4a783          	lw	a5,540(s1)
    80004304:	fef700e3          	beq	a4,a5,800042e4 <piperead+0x3c>
    80004308:	e85a                	sd	s6,16(sp)
    8000430a:	a819                	j	80004320 <piperead+0x78>
    8000430c:	e85a                	sd	s6,16(sp)
    8000430e:	a809                	j	80004320 <piperead+0x78>
      release(&pi->lock);
    80004310:	8526                	mv	a0,s1
    80004312:	00002097          	auipc	ra,0x2
    80004316:	2d8080e7          	jalr	728(ra) # 800065ea <release>
      return -1;
    8000431a:	59fd                	li	s3,-1
    8000431c:	a0a5                	j	80004384 <piperead+0xdc>
    8000431e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004320:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004322:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004324:	05505463          	blez	s5,8000436c <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004328:	2184a783          	lw	a5,536(s1)
    8000432c:	21c4a703          	lw	a4,540(s1)
    80004330:	02f70e63          	beq	a4,a5,8000436c <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004334:	0017871b          	addiw	a4,a5,1
    80004338:	20e4ac23          	sw	a4,536(s1)
    8000433c:	1ff7f793          	andi	a5,a5,511
    80004340:	97a6                	add	a5,a5,s1
    80004342:	0187c783          	lbu	a5,24(a5)
    80004346:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000434a:	4685                	li	a3,1
    8000434c:	fbf40613          	addi	a2,s0,-65
    80004350:	85ca                	mv	a1,s2
    80004352:	050a3503          	ld	a0,80(s4)
    80004356:	ffffd097          	auipc	ra,0xffffd
    8000435a:	90c080e7          	jalr	-1780(ra) # 80000c62 <copyout>
    8000435e:	01650763          	beq	a0,s6,8000436c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004362:	2985                	addiw	s3,s3,1
    80004364:	0905                	addi	s2,s2,1
    80004366:	fd3a91e3          	bne	s5,s3,80004328 <piperead+0x80>
    8000436a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000436c:	21c48513          	addi	a0,s1,540
    80004370:	ffffd097          	auipc	ra,0xffffd
    80004374:	5ec080e7          	jalr	1516(ra) # 8000195c <wakeup>
  release(&pi->lock);
    80004378:	8526                	mv	a0,s1
    8000437a:	00002097          	auipc	ra,0x2
    8000437e:	270080e7          	jalr	624(ra) # 800065ea <release>
    80004382:	6b42                	ld	s6,16(sp)
  return i;
}
    80004384:	854e                	mv	a0,s3
    80004386:	60a6                	ld	ra,72(sp)
    80004388:	6406                	ld	s0,64(sp)
    8000438a:	74e2                	ld	s1,56(sp)
    8000438c:	7942                	ld	s2,48(sp)
    8000438e:	79a2                	ld	s3,40(sp)
    80004390:	7a02                	ld	s4,32(sp)
    80004392:	6ae2                	ld	s5,24(sp)
    80004394:	6161                	addi	sp,sp,80
    80004396:	8082                	ret

0000000080004398 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004398:	df010113          	addi	sp,sp,-528
    8000439c:	20113423          	sd	ra,520(sp)
    800043a0:	20813023          	sd	s0,512(sp)
    800043a4:	ffa6                	sd	s1,504(sp)
    800043a6:	fbca                	sd	s2,496(sp)
    800043a8:	0c00                	addi	s0,sp,528
    800043aa:	892a                	mv	s2,a0
    800043ac:	dea43c23          	sd	a0,-520(s0)
    800043b0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	d56080e7          	jalr	-682(ra) # 8000110a <myproc>
    800043bc:	84aa                	mv	s1,a0

  begin_op();
    800043be:	fffff097          	auipc	ra,0xfffff
    800043c2:	460080e7          	jalr	1120(ra) # 8000381e <begin_op>

  if((ip = namei(path)) == 0){
    800043c6:	854a                	mv	a0,s2
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	256080e7          	jalr	598(ra) # 8000361e <namei>
    800043d0:	c135                	beqz	a0,80004434 <exec+0x9c>
    800043d2:	f3d2                	sd	s4,480(sp)
    800043d4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043d6:	fffff097          	auipc	ra,0xfffff
    800043da:	a76080e7          	jalr	-1418(ra) # 80002e4c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043de:	04000713          	li	a4,64
    800043e2:	4681                	li	a3,0
    800043e4:	e5040613          	addi	a2,s0,-432
    800043e8:	4581                	li	a1,0
    800043ea:	8552                	mv	a0,s4
    800043ec:	fffff097          	auipc	ra,0xfffff
    800043f0:	d18080e7          	jalr	-744(ra) # 80003104 <readi>
    800043f4:	04000793          	li	a5,64
    800043f8:	00f51a63          	bne	a0,a5,8000440c <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800043fc:	e5042703          	lw	a4,-432(s0)
    80004400:	464c47b7          	lui	a5,0x464c4
    80004404:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004408:	02f70c63          	beq	a4,a5,80004440 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000440c:	8552                	mv	a0,s4
    8000440e:	fffff097          	auipc	ra,0xfffff
    80004412:	ca4080e7          	jalr	-860(ra) # 800030b2 <iunlockput>
    end_op();
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	482080e7          	jalr	1154(ra) # 80003898 <end_op>
  }
  return -1;
    8000441e:	557d                	li	a0,-1
    80004420:	7a1e                	ld	s4,480(sp)
}
    80004422:	20813083          	ld	ra,520(sp)
    80004426:	20013403          	ld	s0,512(sp)
    8000442a:	74fe                	ld	s1,504(sp)
    8000442c:	795e                	ld	s2,496(sp)
    8000442e:	21010113          	addi	sp,sp,528
    80004432:	8082                	ret
    end_op();
    80004434:	fffff097          	auipc	ra,0xfffff
    80004438:	464080e7          	jalr	1124(ra) # 80003898 <end_op>
    return -1;
    8000443c:	557d                	li	a0,-1
    8000443e:	b7d5                	j	80004422 <exec+0x8a>
    80004440:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004442:	8526                	mv	a0,s1
    80004444:	ffffd097          	auipc	ra,0xffffd
    80004448:	d8a080e7          	jalr	-630(ra) # 800011ce <proc_pagetable>
    8000444c:	8b2a                	mv	s6,a0
    8000444e:	30050563          	beqz	a0,80004758 <exec+0x3c0>
    80004452:	f7ce                	sd	s3,488(sp)
    80004454:	efd6                	sd	s5,472(sp)
    80004456:	e7de                	sd	s7,456(sp)
    80004458:	e3e2                	sd	s8,448(sp)
    8000445a:	ff66                	sd	s9,440(sp)
    8000445c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000445e:	e7042d03          	lw	s10,-400(s0)
    80004462:	e8845783          	lhu	a5,-376(s0)
    80004466:	14078563          	beqz	a5,800045b0 <exec+0x218>
    8000446a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000446c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000446e:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004470:	6c85                	lui	s9,0x1
    80004472:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004476:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000447a:	6a85                	lui	s5,0x1
    8000447c:	a0b5                	j	800044e8 <exec+0x150>
      panic("loadseg: address should exist");
    8000447e:	00004517          	auipc	a0,0x4
    80004482:	0ca50513          	addi	a0,a0,202 # 80008548 <etext+0x548>
    80004486:	00002097          	auipc	ra,0x2
    8000448a:	b36080e7          	jalr	-1226(ra) # 80005fbc <panic>
    if(sz - i < PGSIZE)
    8000448e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004490:	8726                	mv	a4,s1
    80004492:	012c06bb          	addw	a3,s8,s2
    80004496:	4581                	li	a1,0
    80004498:	8552                	mv	a0,s4
    8000449a:	fffff097          	auipc	ra,0xfffff
    8000449e:	c6a080e7          	jalr	-918(ra) # 80003104 <readi>
    800044a2:	2501                	sext.w	a0,a0
    800044a4:	26a49e63          	bne	s1,a0,80004720 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800044a8:	012a893b          	addw	s2,s5,s2
    800044ac:	03397563          	bgeu	s2,s3,800044d6 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800044b0:	02091593          	slli	a1,s2,0x20
    800044b4:	9181                	srli	a1,a1,0x20
    800044b6:	95de                	add	a1,a1,s7
    800044b8:	855a                	mv	a0,s6
    800044ba:	ffffc097          	auipc	ra,0xffffc
    800044be:	1a6080e7          	jalr	422(ra) # 80000660 <walkaddr>
    800044c2:	862a                	mv	a2,a0
    if(pa == 0)
    800044c4:	dd4d                	beqz	a0,8000447e <exec+0xe6>
    if(sz - i < PGSIZE)
    800044c6:	412984bb          	subw	s1,s3,s2
    800044ca:	0004879b          	sext.w	a5,s1
    800044ce:	fcfcf0e3          	bgeu	s9,a5,8000448e <exec+0xf6>
    800044d2:	84d6                	mv	s1,s5
    800044d4:	bf6d                	j	8000448e <exec+0xf6>
    sz = sz1;
    800044d6:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044da:	2d85                	addiw	s11,s11,1
    800044dc:	038d0d1b          	addiw	s10,s10,56
    800044e0:	e8845783          	lhu	a5,-376(s0)
    800044e4:	06fddf63          	bge	s11,a5,80004562 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044e8:	2d01                	sext.w	s10,s10
    800044ea:	03800713          	li	a4,56
    800044ee:	86ea                	mv	a3,s10
    800044f0:	e1840613          	addi	a2,s0,-488
    800044f4:	4581                	li	a1,0
    800044f6:	8552                	mv	a0,s4
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	c0c080e7          	jalr	-1012(ra) # 80003104 <readi>
    80004500:	03800793          	li	a5,56
    80004504:	1ef51863          	bne	a0,a5,800046f4 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    80004508:	e1842783          	lw	a5,-488(s0)
    8000450c:	4705                	li	a4,1
    8000450e:	fce796e3          	bne	a5,a4,800044da <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004512:	e4043603          	ld	a2,-448(s0)
    80004516:	e3843783          	ld	a5,-456(s0)
    8000451a:	1ef66163          	bltu	a2,a5,800046fc <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000451e:	e2843783          	ld	a5,-472(s0)
    80004522:	963e                	add	a2,a2,a5
    80004524:	1ef66063          	bltu	a2,a5,80004704 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004528:	85a6                	mv	a1,s1
    8000452a:	855a                	mv	a0,s6
    8000452c:	ffffc097          	auipc	ra,0xffffc
    80004530:	4e2080e7          	jalr	1250(ra) # 80000a0e <uvmalloc>
    80004534:	e0a43423          	sd	a0,-504(s0)
    80004538:	1c050a63          	beqz	a0,8000470c <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    8000453c:	e2843b83          	ld	s7,-472(s0)
    80004540:	df043783          	ld	a5,-528(s0)
    80004544:	00fbf7b3          	and	a5,s7,a5
    80004548:	1c079a63          	bnez	a5,8000471c <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000454c:	e2042c03          	lw	s8,-480(s0)
    80004550:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004554:	00098463          	beqz	s3,8000455c <exec+0x1c4>
    80004558:	4901                	li	s2,0
    8000455a:	bf99                	j	800044b0 <exec+0x118>
    sz = sz1;
    8000455c:	e0843483          	ld	s1,-504(s0)
    80004560:	bfad                	j	800044da <exec+0x142>
    80004562:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004564:	8552                	mv	a0,s4
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	b4c080e7          	jalr	-1204(ra) # 800030b2 <iunlockput>
  end_op();
    8000456e:	fffff097          	auipc	ra,0xfffff
    80004572:	32a080e7          	jalr	810(ra) # 80003898 <end_op>
  p = myproc();
    80004576:	ffffd097          	auipc	ra,0xffffd
    8000457a:	b94080e7          	jalr	-1132(ra) # 8000110a <myproc>
    8000457e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004580:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004584:	6985                	lui	s3,0x1
    80004586:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004588:	99a6                	add	s3,s3,s1
    8000458a:	77fd                	lui	a5,0xfffff
    8000458c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004590:	6609                	lui	a2,0x2
    80004592:	964e                	add	a2,a2,s3
    80004594:	85ce                	mv	a1,s3
    80004596:	855a                	mv	a0,s6
    80004598:	ffffc097          	auipc	ra,0xffffc
    8000459c:	476080e7          	jalr	1142(ra) # 80000a0e <uvmalloc>
    800045a0:	892a                	mv	s2,a0
    800045a2:	e0a43423          	sd	a0,-504(s0)
    800045a6:	e519                	bnez	a0,800045b4 <exec+0x21c>
  if(pagetable)
    800045a8:	e1343423          	sd	s3,-504(s0)
    800045ac:	4a01                	li	s4,0
    800045ae:	aa95                	j	80004722 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045b0:	4481                	li	s1,0
    800045b2:	bf4d                	j	80004564 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045b4:	75f9                	lui	a1,0xffffe
    800045b6:	95aa                	add	a1,a1,a0
    800045b8:	855a                	mv	a0,s6
    800045ba:	ffffc097          	auipc	ra,0xffffc
    800045be:	676080e7          	jalr	1654(ra) # 80000c30 <uvmclear>
  stackbase = sp - PGSIZE;
    800045c2:	7bfd                	lui	s7,0xfffff
    800045c4:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800045c6:	e0043783          	ld	a5,-512(s0)
    800045ca:	6388                	ld	a0,0(a5)
    800045cc:	c52d                	beqz	a0,80004636 <exec+0x29e>
    800045ce:	e9040993          	addi	s3,s0,-368
    800045d2:	f9040c13          	addi	s8,s0,-112
    800045d6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800045d8:	ffffc097          	auipc	ra,0xffffc
    800045dc:	e7e080e7          	jalr	-386(ra) # 80000456 <strlen>
    800045e0:	0015079b          	addiw	a5,a0,1
    800045e4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045e8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800045ec:	13796463          	bltu	s2,s7,80004714 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045f0:	e0043d03          	ld	s10,-512(s0)
    800045f4:	000d3a03          	ld	s4,0(s10)
    800045f8:	8552                	mv	a0,s4
    800045fa:	ffffc097          	auipc	ra,0xffffc
    800045fe:	e5c080e7          	jalr	-420(ra) # 80000456 <strlen>
    80004602:	0015069b          	addiw	a3,a0,1
    80004606:	8652                	mv	a2,s4
    80004608:	85ca                	mv	a1,s2
    8000460a:	855a                	mv	a0,s6
    8000460c:	ffffc097          	auipc	ra,0xffffc
    80004610:	656080e7          	jalr	1622(ra) # 80000c62 <copyout>
    80004614:	10054263          	bltz	a0,80004718 <exec+0x380>
    ustack[argc] = sp;
    80004618:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000461c:	0485                	addi	s1,s1,1
    8000461e:	008d0793          	addi	a5,s10,8
    80004622:	e0f43023          	sd	a5,-512(s0)
    80004626:	008d3503          	ld	a0,8(s10)
    8000462a:	c909                	beqz	a0,8000463c <exec+0x2a4>
    if(argc >= MAXARG)
    8000462c:	09a1                	addi	s3,s3,8
    8000462e:	fb8995e3          	bne	s3,s8,800045d8 <exec+0x240>
  ip = 0;
    80004632:	4a01                	li	s4,0
    80004634:	a0fd                	j	80004722 <exec+0x38a>
  sp = sz;
    80004636:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000463a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000463c:	00349793          	slli	a5,s1,0x3
    80004640:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5d50>
    80004644:	97a2                	add	a5,a5,s0
    80004646:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000464a:	00148693          	addi	a3,s1,1
    8000464e:	068e                	slli	a3,a3,0x3
    80004650:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004654:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004658:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000465c:	f57966e3          	bltu	s2,s7,800045a8 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004660:	e9040613          	addi	a2,s0,-368
    80004664:	85ca                	mv	a1,s2
    80004666:	855a                	mv	a0,s6
    80004668:	ffffc097          	auipc	ra,0xffffc
    8000466c:	5fa080e7          	jalr	1530(ra) # 80000c62 <copyout>
    80004670:	0e054663          	bltz	a0,8000475c <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004674:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004678:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000467c:	df843783          	ld	a5,-520(s0)
    80004680:	0007c703          	lbu	a4,0(a5)
    80004684:	cf11                	beqz	a4,800046a0 <exec+0x308>
    80004686:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004688:	02f00693          	li	a3,47
    8000468c:	a039                	j	8000469a <exec+0x302>
      last = s+1;
    8000468e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004692:	0785                	addi	a5,a5,1
    80004694:	fff7c703          	lbu	a4,-1(a5)
    80004698:	c701                	beqz	a4,800046a0 <exec+0x308>
    if(*s == '/')
    8000469a:	fed71ce3          	bne	a4,a3,80004692 <exec+0x2fa>
    8000469e:	bfc5                	j	8000468e <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800046a0:	4641                	li	a2,16
    800046a2:	df843583          	ld	a1,-520(s0)
    800046a6:	158a8513          	addi	a0,s5,344
    800046aa:	ffffc097          	auipc	ra,0xffffc
    800046ae:	d7a080e7          	jalr	-646(ra) # 80000424 <safestrcpy>
  oldpagetable = p->pagetable;
    800046b2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046b6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800046ba:	e0843783          	ld	a5,-504(s0)
    800046be:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046c2:	058ab783          	ld	a5,88(s5)
    800046c6:	e6843703          	ld	a4,-408(s0)
    800046ca:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046cc:	058ab783          	ld	a5,88(s5)
    800046d0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046d4:	85e6                	mv	a1,s9
    800046d6:	ffffd097          	auipc	ra,0xffffd
    800046da:	b94080e7          	jalr	-1132(ra) # 8000126a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046de:	0004851b          	sext.w	a0,s1
    800046e2:	79be                	ld	s3,488(sp)
    800046e4:	7a1e                	ld	s4,480(sp)
    800046e6:	6afe                	ld	s5,472(sp)
    800046e8:	6b5e                	ld	s6,464(sp)
    800046ea:	6bbe                	ld	s7,456(sp)
    800046ec:	6c1e                	ld	s8,448(sp)
    800046ee:	7cfa                	ld	s9,440(sp)
    800046f0:	7d5a                	ld	s10,432(sp)
    800046f2:	bb05                	j	80004422 <exec+0x8a>
    800046f4:	e0943423          	sd	s1,-504(s0)
    800046f8:	7dba                	ld	s11,424(sp)
    800046fa:	a025                	j	80004722 <exec+0x38a>
    800046fc:	e0943423          	sd	s1,-504(s0)
    80004700:	7dba                	ld	s11,424(sp)
    80004702:	a005                	j	80004722 <exec+0x38a>
    80004704:	e0943423          	sd	s1,-504(s0)
    80004708:	7dba                	ld	s11,424(sp)
    8000470a:	a821                	j	80004722 <exec+0x38a>
    8000470c:	e0943423          	sd	s1,-504(s0)
    80004710:	7dba                	ld	s11,424(sp)
    80004712:	a801                	j	80004722 <exec+0x38a>
  ip = 0;
    80004714:	4a01                	li	s4,0
    80004716:	a031                	j	80004722 <exec+0x38a>
    80004718:	4a01                	li	s4,0
  if(pagetable)
    8000471a:	a021                	j	80004722 <exec+0x38a>
    8000471c:	7dba                	ld	s11,424(sp)
    8000471e:	a011                	j	80004722 <exec+0x38a>
    80004720:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004722:	e0843583          	ld	a1,-504(s0)
    80004726:	855a                	mv	a0,s6
    80004728:	ffffd097          	auipc	ra,0xffffd
    8000472c:	b42080e7          	jalr	-1214(ra) # 8000126a <proc_freepagetable>
  return -1;
    80004730:	557d                	li	a0,-1
  if(ip){
    80004732:	000a1b63          	bnez	s4,80004748 <exec+0x3b0>
    80004736:	79be                	ld	s3,488(sp)
    80004738:	7a1e                	ld	s4,480(sp)
    8000473a:	6afe                	ld	s5,472(sp)
    8000473c:	6b5e                	ld	s6,464(sp)
    8000473e:	6bbe                	ld	s7,456(sp)
    80004740:	6c1e                	ld	s8,448(sp)
    80004742:	7cfa                	ld	s9,440(sp)
    80004744:	7d5a                	ld	s10,432(sp)
    80004746:	b9f1                	j	80004422 <exec+0x8a>
    80004748:	79be                	ld	s3,488(sp)
    8000474a:	6afe                	ld	s5,472(sp)
    8000474c:	6b5e                	ld	s6,464(sp)
    8000474e:	6bbe                	ld	s7,456(sp)
    80004750:	6c1e                	ld	s8,448(sp)
    80004752:	7cfa                	ld	s9,440(sp)
    80004754:	7d5a                	ld	s10,432(sp)
    80004756:	b95d                	j	8000440c <exec+0x74>
    80004758:	6b5e                	ld	s6,464(sp)
    8000475a:	b94d                	j	8000440c <exec+0x74>
  sz = sz1;
    8000475c:	e0843983          	ld	s3,-504(s0)
    80004760:	b5a1                	j	800045a8 <exec+0x210>

0000000080004762 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004762:	7179                	addi	sp,sp,-48
    80004764:	f406                	sd	ra,40(sp)
    80004766:	f022                	sd	s0,32(sp)
    80004768:	ec26                	sd	s1,24(sp)
    8000476a:	e84a                	sd	s2,16(sp)
    8000476c:	1800                	addi	s0,sp,48
    8000476e:	892e                	mv	s2,a1
    80004770:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004772:	fdc40593          	addi	a1,s0,-36
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	b64080e7          	jalr	-1180(ra) # 800022da <argint>
    8000477e:	04054063          	bltz	a0,800047be <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004782:	fdc42703          	lw	a4,-36(s0)
    80004786:	47bd                	li	a5,15
    80004788:	02e7ed63          	bltu	a5,a4,800047c2 <argfd+0x60>
    8000478c:	ffffd097          	auipc	ra,0xffffd
    80004790:	97e080e7          	jalr	-1666(ra) # 8000110a <myproc>
    80004794:	fdc42703          	lw	a4,-36(s0)
    80004798:	01a70793          	addi	a5,a4,26
    8000479c:	078e                	slli	a5,a5,0x3
    8000479e:	953e                	add	a0,a0,a5
    800047a0:	611c                	ld	a5,0(a0)
    800047a2:	c395                	beqz	a5,800047c6 <argfd+0x64>
    return -1;
  if(pfd)
    800047a4:	00090463          	beqz	s2,800047ac <argfd+0x4a>
    *pfd = fd;
    800047a8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047ac:	4501                	li	a0,0
  if(pf)
    800047ae:	c091                	beqz	s1,800047b2 <argfd+0x50>
    *pf = f;
    800047b0:	e09c                	sd	a5,0(s1)
}
    800047b2:	70a2                	ld	ra,40(sp)
    800047b4:	7402                	ld	s0,32(sp)
    800047b6:	64e2                	ld	s1,24(sp)
    800047b8:	6942                	ld	s2,16(sp)
    800047ba:	6145                	addi	sp,sp,48
    800047bc:	8082                	ret
    return -1;
    800047be:	557d                	li	a0,-1
    800047c0:	bfcd                	j	800047b2 <argfd+0x50>
    return -1;
    800047c2:	557d                	li	a0,-1
    800047c4:	b7fd                	j	800047b2 <argfd+0x50>
    800047c6:	557d                	li	a0,-1
    800047c8:	b7ed                	j	800047b2 <argfd+0x50>

00000000800047ca <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047ca:	1101                	addi	sp,sp,-32
    800047cc:	ec06                	sd	ra,24(sp)
    800047ce:	e822                	sd	s0,16(sp)
    800047d0:	e426                	sd	s1,8(sp)
    800047d2:	1000                	addi	s0,sp,32
    800047d4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047d6:	ffffd097          	auipc	ra,0xffffd
    800047da:	934080e7          	jalr	-1740(ra) # 8000110a <myproc>
    800047de:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047e0:	0d050793          	addi	a5,a0,208
    800047e4:	4501                	li	a0,0
    800047e6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047e8:	6398                	ld	a4,0(a5)
    800047ea:	cb19                	beqz	a4,80004800 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800047ec:	2505                	addiw	a0,a0,1
    800047ee:	07a1                	addi	a5,a5,8
    800047f0:	fed51ce3          	bne	a0,a3,800047e8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047f4:	557d                	li	a0,-1
}
    800047f6:	60e2                	ld	ra,24(sp)
    800047f8:	6442                	ld	s0,16(sp)
    800047fa:	64a2                	ld	s1,8(sp)
    800047fc:	6105                	addi	sp,sp,32
    800047fe:	8082                	ret
      p->ofile[fd] = f;
    80004800:	01a50793          	addi	a5,a0,26
    80004804:	078e                	slli	a5,a5,0x3
    80004806:	963e                	add	a2,a2,a5
    80004808:	e204                	sd	s1,0(a2)
      return fd;
    8000480a:	b7f5                	j	800047f6 <fdalloc+0x2c>

000000008000480c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000480c:	715d                	addi	sp,sp,-80
    8000480e:	e486                	sd	ra,72(sp)
    80004810:	e0a2                	sd	s0,64(sp)
    80004812:	fc26                	sd	s1,56(sp)
    80004814:	f84a                	sd	s2,48(sp)
    80004816:	f44e                	sd	s3,40(sp)
    80004818:	f052                	sd	s4,32(sp)
    8000481a:	ec56                	sd	s5,24(sp)
    8000481c:	0880                	addi	s0,sp,80
    8000481e:	8aae                	mv	s5,a1
    80004820:	8a32                	mv	s4,a2
    80004822:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004824:	fb040593          	addi	a1,s0,-80
    80004828:	fffff097          	auipc	ra,0xfffff
    8000482c:	e14080e7          	jalr	-492(ra) # 8000363c <nameiparent>
    80004830:	892a                	mv	s2,a0
    80004832:	12050c63          	beqz	a0,8000496a <create+0x15e>
    return 0;

  ilock(dp);
    80004836:	ffffe097          	auipc	ra,0xffffe
    8000483a:	616080e7          	jalr	1558(ra) # 80002e4c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000483e:	4601                	li	a2,0
    80004840:	fb040593          	addi	a1,s0,-80
    80004844:	854a                	mv	a0,s2
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	b06080e7          	jalr	-1274(ra) # 8000334c <dirlookup>
    8000484e:	84aa                	mv	s1,a0
    80004850:	c539                	beqz	a0,8000489e <create+0x92>
    iunlockput(dp);
    80004852:	854a                	mv	a0,s2
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	85e080e7          	jalr	-1954(ra) # 800030b2 <iunlockput>
    ilock(ip);
    8000485c:	8526                	mv	a0,s1
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	5ee080e7          	jalr	1518(ra) # 80002e4c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004866:	4789                	li	a5,2
    80004868:	02fa9463          	bne	s5,a5,80004890 <create+0x84>
    8000486c:	0444d783          	lhu	a5,68(s1)
    80004870:	37f9                	addiw	a5,a5,-2
    80004872:	17c2                	slli	a5,a5,0x30
    80004874:	93c1                	srli	a5,a5,0x30
    80004876:	4705                	li	a4,1
    80004878:	00f76c63          	bltu	a4,a5,80004890 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000487c:	8526                	mv	a0,s1
    8000487e:	60a6                	ld	ra,72(sp)
    80004880:	6406                	ld	s0,64(sp)
    80004882:	74e2                	ld	s1,56(sp)
    80004884:	7942                	ld	s2,48(sp)
    80004886:	79a2                	ld	s3,40(sp)
    80004888:	7a02                	ld	s4,32(sp)
    8000488a:	6ae2                	ld	s5,24(sp)
    8000488c:	6161                	addi	sp,sp,80
    8000488e:	8082                	ret
    iunlockput(ip);
    80004890:	8526                	mv	a0,s1
    80004892:	fffff097          	auipc	ra,0xfffff
    80004896:	820080e7          	jalr	-2016(ra) # 800030b2 <iunlockput>
    return 0;
    8000489a:	4481                	li	s1,0
    8000489c:	b7c5                	j	8000487c <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000489e:	85d6                	mv	a1,s5
    800048a0:	00092503          	lw	a0,0(s2)
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	414080e7          	jalr	1044(ra) # 80002cb8 <ialloc>
    800048ac:	84aa                	mv	s1,a0
    800048ae:	c139                	beqz	a0,800048f4 <create+0xe8>
  ilock(ip);
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	59c080e7          	jalr	1436(ra) # 80002e4c <ilock>
  ip->major = major;
    800048b8:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800048bc:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800048c0:	4985                	li	s3,1
    800048c2:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800048c6:	8526                	mv	a0,s1
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	4b8080e7          	jalr	1208(ra) # 80002d80 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048d0:	033a8a63          	beq	s5,s3,80004904 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800048d4:	40d0                	lw	a2,4(s1)
    800048d6:	fb040593          	addi	a1,s0,-80
    800048da:	854a                	mv	a0,s2
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	c80080e7          	jalr	-896(ra) # 8000355c <dirlink>
    800048e4:	06054b63          	bltz	a0,8000495a <create+0x14e>
  iunlockput(dp);
    800048e8:	854a                	mv	a0,s2
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	7c8080e7          	jalr	1992(ra) # 800030b2 <iunlockput>
  return ip;
    800048f2:	b769                	j	8000487c <create+0x70>
    panic("create: ialloc");
    800048f4:	00004517          	auipc	a0,0x4
    800048f8:	c7450513          	addi	a0,a0,-908 # 80008568 <etext+0x568>
    800048fc:	00001097          	auipc	ra,0x1
    80004900:	6c0080e7          	jalr	1728(ra) # 80005fbc <panic>
    dp->nlink++;  // for ".."
    80004904:	04a95783          	lhu	a5,74(s2)
    80004908:	2785                	addiw	a5,a5,1
    8000490a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000490e:	854a                	mv	a0,s2
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	470080e7          	jalr	1136(ra) # 80002d80 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004918:	40d0                	lw	a2,4(s1)
    8000491a:	00004597          	auipc	a1,0x4
    8000491e:	c5e58593          	addi	a1,a1,-930 # 80008578 <etext+0x578>
    80004922:	8526                	mv	a0,s1
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	c38080e7          	jalr	-968(ra) # 8000355c <dirlink>
    8000492c:	00054f63          	bltz	a0,8000494a <create+0x13e>
    80004930:	00492603          	lw	a2,4(s2)
    80004934:	00004597          	auipc	a1,0x4
    80004938:	c4c58593          	addi	a1,a1,-948 # 80008580 <etext+0x580>
    8000493c:	8526                	mv	a0,s1
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	c1e080e7          	jalr	-994(ra) # 8000355c <dirlink>
    80004946:	f80557e3          	bgez	a0,800048d4 <create+0xc8>
      panic("create dots");
    8000494a:	00004517          	auipc	a0,0x4
    8000494e:	c3e50513          	addi	a0,a0,-962 # 80008588 <etext+0x588>
    80004952:	00001097          	auipc	ra,0x1
    80004956:	66a080e7          	jalr	1642(ra) # 80005fbc <panic>
    panic("create: dirlink");
    8000495a:	00004517          	auipc	a0,0x4
    8000495e:	c3e50513          	addi	a0,a0,-962 # 80008598 <etext+0x598>
    80004962:	00001097          	auipc	ra,0x1
    80004966:	65a080e7          	jalr	1626(ra) # 80005fbc <panic>
    return 0;
    8000496a:	84aa                	mv	s1,a0
    8000496c:	bf01                	j	8000487c <create+0x70>

000000008000496e <sys_dup>:
{
    8000496e:	7179                	addi	sp,sp,-48
    80004970:	f406                	sd	ra,40(sp)
    80004972:	f022                	sd	s0,32(sp)
    80004974:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004976:	fd840613          	addi	a2,s0,-40
    8000497a:	4581                	li	a1,0
    8000497c:	4501                	li	a0,0
    8000497e:	00000097          	auipc	ra,0x0
    80004982:	de4080e7          	jalr	-540(ra) # 80004762 <argfd>
    return -1;
    80004986:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004988:	02054763          	bltz	a0,800049b6 <sys_dup+0x48>
    8000498c:	ec26                	sd	s1,24(sp)
    8000498e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004990:	fd843903          	ld	s2,-40(s0)
    80004994:	854a                	mv	a0,s2
    80004996:	00000097          	auipc	ra,0x0
    8000499a:	e34080e7          	jalr	-460(ra) # 800047ca <fdalloc>
    8000499e:	84aa                	mv	s1,a0
    return -1;
    800049a0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049a2:	00054f63          	bltz	a0,800049c0 <sys_dup+0x52>
  filedup(f);
    800049a6:	854a                	mv	a0,s2
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	2ee080e7          	jalr	750(ra) # 80003c96 <filedup>
  return fd;
    800049b0:	87a6                	mv	a5,s1
    800049b2:	64e2                	ld	s1,24(sp)
    800049b4:	6942                	ld	s2,16(sp)
}
    800049b6:	853e                	mv	a0,a5
    800049b8:	70a2                	ld	ra,40(sp)
    800049ba:	7402                	ld	s0,32(sp)
    800049bc:	6145                	addi	sp,sp,48
    800049be:	8082                	ret
    800049c0:	64e2                	ld	s1,24(sp)
    800049c2:	6942                	ld	s2,16(sp)
    800049c4:	bfcd                	j	800049b6 <sys_dup+0x48>

00000000800049c6 <sys_read>:
{
    800049c6:	7179                	addi	sp,sp,-48
    800049c8:	f406                	sd	ra,40(sp)
    800049ca:	f022                	sd	s0,32(sp)
    800049cc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049ce:	fe840613          	addi	a2,s0,-24
    800049d2:	4581                	li	a1,0
    800049d4:	4501                	li	a0,0
    800049d6:	00000097          	auipc	ra,0x0
    800049da:	d8c080e7          	jalr	-628(ra) # 80004762 <argfd>
    return -1;
    800049de:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049e0:	04054163          	bltz	a0,80004a22 <sys_read+0x5c>
    800049e4:	fe440593          	addi	a1,s0,-28
    800049e8:	4509                	li	a0,2
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	8f0080e7          	jalr	-1808(ra) # 800022da <argint>
    return -1;
    800049f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049f4:	02054763          	bltz	a0,80004a22 <sys_read+0x5c>
    800049f8:	fd840593          	addi	a1,s0,-40
    800049fc:	4505                	li	a0,1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	8fe080e7          	jalr	-1794(ra) # 800022fc <argaddr>
    return -1;
    80004a06:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a08:	00054d63          	bltz	a0,80004a22 <sys_read+0x5c>
  return fileread(f, p, n);
    80004a0c:	fe442603          	lw	a2,-28(s0)
    80004a10:	fd843583          	ld	a1,-40(s0)
    80004a14:	fe843503          	ld	a0,-24(s0)
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	424080e7          	jalr	1060(ra) # 80003e3c <fileread>
    80004a20:	87aa                	mv	a5,a0
}
    80004a22:	853e                	mv	a0,a5
    80004a24:	70a2                	ld	ra,40(sp)
    80004a26:	7402                	ld	s0,32(sp)
    80004a28:	6145                	addi	sp,sp,48
    80004a2a:	8082                	ret

0000000080004a2c <sys_write>:
{
    80004a2c:	7179                	addi	sp,sp,-48
    80004a2e:	f406                	sd	ra,40(sp)
    80004a30:	f022                	sd	s0,32(sp)
    80004a32:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a34:	fe840613          	addi	a2,s0,-24
    80004a38:	4581                	li	a1,0
    80004a3a:	4501                	li	a0,0
    80004a3c:	00000097          	auipc	ra,0x0
    80004a40:	d26080e7          	jalr	-730(ra) # 80004762 <argfd>
    return -1;
    80004a44:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a46:	04054163          	bltz	a0,80004a88 <sys_write+0x5c>
    80004a4a:	fe440593          	addi	a1,s0,-28
    80004a4e:	4509                	li	a0,2
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	88a080e7          	jalr	-1910(ra) # 800022da <argint>
    return -1;
    80004a58:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a5a:	02054763          	bltz	a0,80004a88 <sys_write+0x5c>
    80004a5e:	fd840593          	addi	a1,s0,-40
    80004a62:	4505                	li	a0,1
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	898080e7          	jalr	-1896(ra) # 800022fc <argaddr>
    return -1;
    80004a6c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a6e:	00054d63          	bltz	a0,80004a88 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004a72:	fe442603          	lw	a2,-28(s0)
    80004a76:	fd843583          	ld	a1,-40(s0)
    80004a7a:	fe843503          	ld	a0,-24(s0)
    80004a7e:	fffff097          	auipc	ra,0xfffff
    80004a82:	490080e7          	jalr	1168(ra) # 80003f0e <filewrite>
    80004a86:	87aa                	mv	a5,a0
}
    80004a88:	853e                	mv	a0,a5
    80004a8a:	70a2                	ld	ra,40(sp)
    80004a8c:	7402                	ld	s0,32(sp)
    80004a8e:	6145                	addi	sp,sp,48
    80004a90:	8082                	ret

0000000080004a92 <sys_close>:
{
    80004a92:	1101                	addi	sp,sp,-32
    80004a94:	ec06                	sd	ra,24(sp)
    80004a96:	e822                	sd	s0,16(sp)
    80004a98:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a9a:	fe040613          	addi	a2,s0,-32
    80004a9e:	fec40593          	addi	a1,s0,-20
    80004aa2:	4501                	li	a0,0
    80004aa4:	00000097          	auipc	ra,0x0
    80004aa8:	cbe080e7          	jalr	-834(ra) # 80004762 <argfd>
    return -1;
    80004aac:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004aae:	02054463          	bltz	a0,80004ad6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004ab2:	ffffc097          	auipc	ra,0xffffc
    80004ab6:	658080e7          	jalr	1624(ra) # 8000110a <myproc>
    80004aba:	fec42783          	lw	a5,-20(s0)
    80004abe:	07e9                	addi	a5,a5,26
    80004ac0:	078e                	slli	a5,a5,0x3
    80004ac2:	953e                	add	a0,a0,a5
    80004ac4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ac8:	fe043503          	ld	a0,-32(s0)
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	21c080e7          	jalr	540(ra) # 80003ce8 <fileclose>
  return 0;
    80004ad4:	4781                	li	a5,0
}
    80004ad6:	853e                	mv	a0,a5
    80004ad8:	60e2                	ld	ra,24(sp)
    80004ada:	6442                	ld	s0,16(sp)
    80004adc:	6105                	addi	sp,sp,32
    80004ade:	8082                	ret

0000000080004ae0 <sys_fstat>:
{
    80004ae0:	1101                	addi	sp,sp,-32
    80004ae2:	ec06                	sd	ra,24(sp)
    80004ae4:	e822                	sd	s0,16(sp)
    80004ae6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004ae8:	fe840613          	addi	a2,s0,-24
    80004aec:	4581                	li	a1,0
    80004aee:	4501                	li	a0,0
    80004af0:	00000097          	auipc	ra,0x0
    80004af4:	c72080e7          	jalr	-910(ra) # 80004762 <argfd>
    return -1;
    80004af8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004afa:	02054563          	bltz	a0,80004b24 <sys_fstat+0x44>
    80004afe:	fe040593          	addi	a1,s0,-32
    80004b02:	4505                	li	a0,1
    80004b04:	ffffd097          	auipc	ra,0xffffd
    80004b08:	7f8080e7          	jalr	2040(ra) # 800022fc <argaddr>
    return -1;
    80004b0c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b0e:	00054b63          	bltz	a0,80004b24 <sys_fstat+0x44>
  return filestat(f, st);
    80004b12:	fe043583          	ld	a1,-32(s0)
    80004b16:	fe843503          	ld	a0,-24(s0)
    80004b1a:	fffff097          	auipc	ra,0xfffff
    80004b1e:	2b0080e7          	jalr	688(ra) # 80003dca <filestat>
    80004b22:	87aa                	mv	a5,a0
}
    80004b24:	853e                	mv	a0,a5
    80004b26:	60e2                	ld	ra,24(sp)
    80004b28:	6442                	ld	s0,16(sp)
    80004b2a:	6105                	addi	sp,sp,32
    80004b2c:	8082                	ret

0000000080004b2e <sys_link>:
{
    80004b2e:	7169                	addi	sp,sp,-304
    80004b30:	f606                	sd	ra,296(sp)
    80004b32:	f222                	sd	s0,288(sp)
    80004b34:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b36:	08000613          	li	a2,128
    80004b3a:	ed040593          	addi	a1,s0,-304
    80004b3e:	4501                	li	a0,0
    80004b40:	ffffd097          	auipc	ra,0xffffd
    80004b44:	7de080e7          	jalr	2014(ra) # 8000231e <argstr>
    return -1;
    80004b48:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b4a:	12054663          	bltz	a0,80004c76 <sys_link+0x148>
    80004b4e:	08000613          	li	a2,128
    80004b52:	f5040593          	addi	a1,s0,-176
    80004b56:	4505                	li	a0,1
    80004b58:	ffffd097          	auipc	ra,0xffffd
    80004b5c:	7c6080e7          	jalr	1990(ra) # 8000231e <argstr>
    return -1;
    80004b60:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b62:	10054a63          	bltz	a0,80004c76 <sys_link+0x148>
    80004b66:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	cb6080e7          	jalr	-842(ra) # 8000381e <begin_op>
  if((ip = namei(old)) == 0){
    80004b70:	ed040513          	addi	a0,s0,-304
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	aaa080e7          	jalr	-1366(ra) # 8000361e <namei>
    80004b7c:	84aa                	mv	s1,a0
    80004b7e:	c949                	beqz	a0,80004c10 <sys_link+0xe2>
  ilock(ip);
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	2cc080e7          	jalr	716(ra) # 80002e4c <ilock>
  if(ip->type == T_DIR){
    80004b88:	04449703          	lh	a4,68(s1)
    80004b8c:	4785                	li	a5,1
    80004b8e:	08f70863          	beq	a4,a5,80004c1e <sys_link+0xf0>
    80004b92:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b94:	04a4d783          	lhu	a5,74(s1)
    80004b98:	2785                	addiw	a5,a5,1
    80004b9a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	ffffe097          	auipc	ra,0xffffe
    80004ba4:	1e0080e7          	jalr	480(ra) # 80002d80 <iupdate>
  iunlock(ip);
    80004ba8:	8526                	mv	a0,s1
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	368080e7          	jalr	872(ra) # 80002f12 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bb2:	fd040593          	addi	a1,s0,-48
    80004bb6:	f5040513          	addi	a0,s0,-176
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	a82080e7          	jalr	-1406(ra) # 8000363c <nameiparent>
    80004bc2:	892a                	mv	s2,a0
    80004bc4:	cd35                	beqz	a0,80004c40 <sys_link+0x112>
  ilock(dp);
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	286080e7          	jalr	646(ra) # 80002e4c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bce:	00092703          	lw	a4,0(s2)
    80004bd2:	409c                	lw	a5,0(s1)
    80004bd4:	06f71163          	bne	a4,a5,80004c36 <sys_link+0x108>
    80004bd8:	40d0                	lw	a2,4(s1)
    80004bda:	fd040593          	addi	a1,s0,-48
    80004bde:	854a                	mv	a0,s2
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	97c080e7          	jalr	-1668(ra) # 8000355c <dirlink>
    80004be8:	04054763          	bltz	a0,80004c36 <sys_link+0x108>
  iunlockput(dp);
    80004bec:	854a                	mv	a0,s2
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	4c4080e7          	jalr	1220(ra) # 800030b2 <iunlockput>
  iput(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	412080e7          	jalr	1042(ra) # 8000300a <iput>
  end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	c98080e7          	jalr	-872(ra) # 80003898 <end_op>
  return 0;
    80004c08:	4781                	li	a5,0
    80004c0a:	64f2                	ld	s1,280(sp)
    80004c0c:	6952                	ld	s2,272(sp)
    80004c0e:	a0a5                	j	80004c76 <sys_link+0x148>
    end_op();
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	c88080e7          	jalr	-888(ra) # 80003898 <end_op>
    return -1;
    80004c18:	57fd                	li	a5,-1
    80004c1a:	64f2                	ld	s1,280(sp)
    80004c1c:	a8a9                	j	80004c76 <sys_link+0x148>
    iunlockput(ip);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	492080e7          	jalr	1170(ra) # 800030b2 <iunlockput>
    end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	c70080e7          	jalr	-912(ra) # 80003898 <end_op>
    return -1;
    80004c30:	57fd                	li	a5,-1
    80004c32:	64f2                	ld	s1,280(sp)
    80004c34:	a089                	j	80004c76 <sys_link+0x148>
    iunlockput(dp);
    80004c36:	854a                	mv	a0,s2
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	47a080e7          	jalr	1146(ra) # 800030b2 <iunlockput>
  ilock(ip);
    80004c40:	8526                	mv	a0,s1
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	20a080e7          	jalr	522(ra) # 80002e4c <ilock>
  ip->nlink--;
    80004c4a:	04a4d783          	lhu	a5,74(s1)
    80004c4e:	37fd                	addiw	a5,a5,-1
    80004c50:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c54:	8526                	mv	a0,s1
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	12a080e7          	jalr	298(ra) # 80002d80 <iupdate>
  iunlockput(ip);
    80004c5e:	8526                	mv	a0,s1
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	452080e7          	jalr	1106(ra) # 800030b2 <iunlockput>
  end_op();
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	c30080e7          	jalr	-976(ra) # 80003898 <end_op>
  return -1;
    80004c70:	57fd                	li	a5,-1
    80004c72:	64f2                	ld	s1,280(sp)
    80004c74:	6952                	ld	s2,272(sp)
}
    80004c76:	853e                	mv	a0,a5
    80004c78:	70b2                	ld	ra,296(sp)
    80004c7a:	7412                	ld	s0,288(sp)
    80004c7c:	6155                	addi	sp,sp,304
    80004c7e:	8082                	ret

0000000080004c80 <sys_unlink>:
{
    80004c80:	7151                	addi	sp,sp,-240
    80004c82:	f586                	sd	ra,232(sp)
    80004c84:	f1a2                	sd	s0,224(sp)
    80004c86:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c88:	08000613          	li	a2,128
    80004c8c:	f3040593          	addi	a1,s0,-208
    80004c90:	4501                	li	a0,0
    80004c92:	ffffd097          	auipc	ra,0xffffd
    80004c96:	68c080e7          	jalr	1676(ra) # 8000231e <argstr>
    80004c9a:	1a054a63          	bltz	a0,80004e4e <sys_unlink+0x1ce>
    80004c9e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	b7e080e7          	jalr	-1154(ra) # 8000381e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ca8:	fb040593          	addi	a1,s0,-80
    80004cac:	f3040513          	addi	a0,s0,-208
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	98c080e7          	jalr	-1652(ra) # 8000363c <nameiparent>
    80004cb8:	84aa                	mv	s1,a0
    80004cba:	cd71                	beqz	a0,80004d96 <sys_unlink+0x116>
  ilock(dp);
    80004cbc:	ffffe097          	auipc	ra,0xffffe
    80004cc0:	190080e7          	jalr	400(ra) # 80002e4c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cc4:	00004597          	auipc	a1,0x4
    80004cc8:	8b458593          	addi	a1,a1,-1868 # 80008578 <etext+0x578>
    80004ccc:	fb040513          	addi	a0,s0,-80
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	662080e7          	jalr	1634(ra) # 80003332 <namecmp>
    80004cd8:	14050c63          	beqz	a0,80004e30 <sys_unlink+0x1b0>
    80004cdc:	00004597          	auipc	a1,0x4
    80004ce0:	8a458593          	addi	a1,a1,-1884 # 80008580 <etext+0x580>
    80004ce4:	fb040513          	addi	a0,s0,-80
    80004ce8:	ffffe097          	auipc	ra,0xffffe
    80004cec:	64a080e7          	jalr	1610(ra) # 80003332 <namecmp>
    80004cf0:	14050063          	beqz	a0,80004e30 <sys_unlink+0x1b0>
    80004cf4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cf6:	f2c40613          	addi	a2,s0,-212
    80004cfa:	fb040593          	addi	a1,s0,-80
    80004cfe:	8526                	mv	a0,s1
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	64c080e7          	jalr	1612(ra) # 8000334c <dirlookup>
    80004d08:	892a                	mv	s2,a0
    80004d0a:	12050263          	beqz	a0,80004e2e <sys_unlink+0x1ae>
  ilock(ip);
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	13e080e7          	jalr	318(ra) # 80002e4c <ilock>
  if(ip->nlink < 1)
    80004d16:	04a91783          	lh	a5,74(s2)
    80004d1a:	08f05563          	blez	a5,80004da4 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d1e:	04491703          	lh	a4,68(s2)
    80004d22:	4785                	li	a5,1
    80004d24:	08f70963          	beq	a4,a5,80004db6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004d28:	4641                	li	a2,16
    80004d2a:	4581                	li	a1,0
    80004d2c:	fc040513          	addi	a0,s0,-64
    80004d30:	ffffb097          	auipc	ra,0xffffb
    80004d34:	5b2080e7          	jalr	1458(ra) # 800002e2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d38:	4741                	li	a4,16
    80004d3a:	f2c42683          	lw	a3,-212(s0)
    80004d3e:	fc040613          	addi	a2,s0,-64
    80004d42:	4581                	li	a1,0
    80004d44:	8526                	mv	a0,s1
    80004d46:	ffffe097          	auipc	ra,0xffffe
    80004d4a:	4c2080e7          	jalr	1218(ra) # 80003208 <writei>
    80004d4e:	47c1                	li	a5,16
    80004d50:	0af51b63          	bne	a0,a5,80004e06 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004d54:	04491703          	lh	a4,68(s2)
    80004d58:	4785                	li	a5,1
    80004d5a:	0af70f63          	beq	a4,a5,80004e18 <sys_unlink+0x198>
  iunlockput(dp);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	352080e7          	jalr	850(ra) # 800030b2 <iunlockput>
  ip->nlink--;
    80004d68:	04a95783          	lhu	a5,74(s2)
    80004d6c:	37fd                	addiw	a5,a5,-1
    80004d6e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d72:	854a                	mv	a0,s2
    80004d74:	ffffe097          	auipc	ra,0xffffe
    80004d78:	00c080e7          	jalr	12(ra) # 80002d80 <iupdate>
  iunlockput(ip);
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	334080e7          	jalr	820(ra) # 800030b2 <iunlockput>
  end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	b12080e7          	jalr	-1262(ra) # 80003898 <end_op>
  return 0;
    80004d8e:	4501                	li	a0,0
    80004d90:	64ee                	ld	s1,216(sp)
    80004d92:	694e                	ld	s2,208(sp)
    80004d94:	a84d                	j	80004e46 <sys_unlink+0x1c6>
    end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	b02080e7          	jalr	-1278(ra) # 80003898 <end_op>
    return -1;
    80004d9e:	557d                	li	a0,-1
    80004da0:	64ee                	ld	s1,216(sp)
    80004da2:	a055                	j	80004e46 <sys_unlink+0x1c6>
    80004da4:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004da6:	00004517          	auipc	a0,0x4
    80004daa:	80250513          	addi	a0,a0,-2046 # 800085a8 <etext+0x5a8>
    80004dae:	00001097          	auipc	ra,0x1
    80004db2:	20e080e7          	jalr	526(ra) # 80005fbc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004db6:	04c92703          	lw	a4,76(s2)
    80004dba:	02000793          	li	a5,32
    80004dbe:	f6e7f5e3          	bgeu	a5,a4,80004d28 <sys_unlink+0xa8>
    80004dc2:	e5ce                	sd	s3,200(sp)
    80004dc4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dc8:	4741                	li	a4,16
    80004dca:	86ce                	mv	a3,s3
    80004dcc:	f1840613          	addi	a2,s0,-232
    80004dd0:	4581                	li	a1,0
    80004dd2:	854a                	mv	a0,s2
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	330080e7          	jalr	816(ra) # 80003104 <readi>
    80004ddc:	47c1                	li	a5,16
    80004dde:	00f51c63          	bne	a0,a5,80004df6 <sys_unlink+0x176>
    if(de.inum != 0)
    80004de2:	f1845783          	lhu	a5,-232(s0)
    80004de6:	e7b5                	bnez	a5,80004e52 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004de8:	29c1                	addiw	s3,s3,16
    80004dea:	04c92783          	lw	a5,76(s2)
    80004dee:	fcf9ede3          	bltu	s3,a5,80004dc8 <sys_unlink+0x148>
    80004df2:	69ae                	ld	s3,200(sp)
    80004df4:	bf15                	j	80004d28 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004df6:	00003517          	auipc	a0,0x3
    80004dfa:	7ca50513          	addi	a0,a0,1994 # 800085c0 <etext+0x5c0>
    80004dfe:	00001097          	auipc	ra,0x1
    80004e02:	1be080e7          	jalr	446(ra) # 80005fbc <panic>
    80004e06:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e08:	00003517          	auipc	a0,0x3
    80004e0c:	7d050513          	addi	a0,a0,2000 # 800085d8 <etext+0x5d8>
    80004e10:	00001097          	auipc	ra,0x1
    80004e14:	1ac080e7          	jalr	428(ra) # 80005fbc <panic>
    dp->nlink--;
    80004e18:	04a4d783          	lhu	a5,74(s1)
    80004e1c:	37fd                	addiw	a5,a5,-1
    80004e1e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e22:	8526                	mv	a0,s1
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	f5c080e7          	jalr	-164(ra) # 80002d80 <iupdate>
    80004e2c:	bf0d                	j	80004d5e <sys_unlink+0xde>
    80004e2e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	280080e7          	jalr	640(ra) # 800030b2 <iunlockput>
  end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	a5e080e7          	jalr	-1442(ra) # 80003898 <end_op>
  return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	64ee                	ld	s1,216(sp)
}
    80004e46:	70ae                	ld	ra,232(sp)
    80004e48:	740e                	ld	s0,224(sp)
    80004e4a:	616d                	addi	sp,sp,240
    80004e4c:	8082                	ret
    return -1;
    80004e4e:	557d                	li	a0,-1
    80004e50:	bfdd                	j	80004e46 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004e52:	854a                	mv	a0,s2
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	25e080e7          	jalr	606(ra) # 800030b2 <iunlockput>
    goto bad;
    80004e5c:	694e                	ld	s2,208(sp)
    80004e5e:	69ae                	ld	s3,200(sp)
    80004e60:	bfc1                	j	80004e30 <sys_unlink+0x1b0>

0000000080004e62 <sys_open>:

uint64
sys_open(void)
{
    80004e62:	7131                	addi	sp,sp,-192
    80004e64:	fd06                	sd	ra,184(sp)
    80004e66:	f922                	sd	s0,176(sp)
    80004e68:	f526                	sd	s1,168(sp)
    80004e6a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e6c:	08000613          	li	a2,128
    80004e70:	f5040593          	addi	a1,s0,-176
    80004e74:	4501                	li	a0,0
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	4a8080e7          	jalr	1192(ra) # 8000231e <argstr>
    return -1;
    80004e7e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e80:	0c054463          	bltz	a0,80004f48 <sys_open+0xe6>
    80004e84:	f4c40593          	addi	a1,s0,-180
    80004e88:	4505                	li	a0,1
    80004e8a:	ffffd097          	auipc	ra,0xffffd
    80004e8e:	450080e7          	jalr	1104(ra) # 800022da <argint>
    80004e92:	0a054b63          	bltz	a0,80004f48 <sys_open+0xe6>
    80004e96:	f14a                	sd	s2,160(sp)

  begin_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	986080e7          	jalr	-1658(ra) # 8000381e <begin_op>

  if(omode & O_CREATE){
    80004ea0:	f4c42783          	lw	a5,-180(s0)
    80004ea4:	2007f793          	andi	a5,a5,512
    80004ea8:	cfc5                	beqz	a5,80004f60 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004eaa:	4681                	li	a3,0
    80004eac:	4601                	li	a2,0
    80004eae:	4589                	li	a1,2
    80004eb0:	f5040513          	addi	a0,s0,-176
    80004eb4:	00000097          	auipc	ra,0x0
    80004eb8:	958080e7          	jalr	-1704(ra) # 8000480c <create>
    80004ebc:	892a                	mv	s2,a0
    if(ip == 0){
    80004ebe:	c959                	beqz	a0,80004f54 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ec0:	04491703          	lh	a4,68(s2)
    80004ec4:	478d                	li	a5,3
    80004ec6:	00f71763          	bne	a4,a5,80004ed4 <sys_open+0x72>
    80004eca:	04695703          	lhu	a4,70(s2)
    80004ece:	47a5                	li	a5,9
    80004ed0:	0ce7ef63          	bltu	a5,a4,80004fae <sys_open+0x14c>
    80004ed4:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	d56080e7          	jalr	-682(ra) # 80003c2c <filealloc>
    80004ede:	89aa                	mv	s3,a0
    80004ee0:	c965                	beqz	a0,80004fd0 <sys_open+0x16e>
    80004ee2:	00000097          	auipc	ra,0x0
    80004ee6:	8e8080e7          	jalr	-1816(ra) # 800047ca <fdalloc>
    80004eea:	84aa                	mv	s1,a0
    80004eec:	0c054d63          	bltz	a0,80004fc6 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ef0:	04491703          	lh	a4,68(s2)
    80004ef4:	478d                	li	a5,3
    80004ef6:	0ef70a63          	beq	a4,a5,80004fea <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004efa:	4789                	li	a5,2
    80004efc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f00:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f04:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f08:	f4c42783          	lw	a5,-180(s0)
    80004f0c:	0017c713          	xori	a4,a5,1
    80004f10:	8b05                	andi	a4,a4,1
    80004f12:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f16:	0037f713          	andi	a4,a5,3
    80004f1a:	00e03733          	snez	a4,a4
    80004f1e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f22:	4007f793          	andi	a5,a5,1024
    80004f26:	c791                	beqz	a5,80004f32 <sys_open+0xd0>
    80004f28:	04491703          	lh	a4,68(s2)
    80004f2c:	4789                	li	a5,2
    80004f2e:	0cf70563          	beq	a4,a5,80004ff8 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004f32:	854a                	mv	a0,s2
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	fde080e7          	jalr	-34(ra) # 80002f12 <iunlock>
  end_op();
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	95c080e7          	jalr	-1700(ra) # 80003898 <end_op>
    80004f44:	790a                	ld	s2,160(sp)
    80004f46:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004f48:	8526                	mv	a0,s1
    80004f4a:	70ea                	ld	ra,184(sp)
    80004f4c:	744a                	ld	s0,176(sp)
    80004f4e:	74aa                	ld	s1,168(sp)
    80004f50:	6129                	addi	sp,sp,192
    80004f52:	8082                	ret
      end_op();
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	944080e7          	jalr	-1724(ra) # 80003898 <end_op>
      return -1;
    80004f5c:	790a                	ld	s2,160(sp)
    80004f5e:	b7ed                	j	80004f48 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004f60:	f5040513          	addi	a0,s0,-176
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	6ba080e7          	jalr	1722(ra) # 8000361e <namei>
    80004f6c:	892a                	mv	s2,a0
    80004f6e:	c90d                	beqz	a0,80004fa0 <sys_open+0x13e>
    ilock(ip);
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	edc080e7          	jalr	-292(ra) # 80002e4c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f78:	04491703          	lh	a4,68(s2)
    80004f7c:	4785                	li	a5,1
    80004f7e:	f4f711e3          	bne	a4,a5,80004ec0 <sys_open+0x5e>
    80004f82:	f4c42783          	lw	a5,-180(s0)
    80004f86:	d7b9                	beqz	a5,80004ed4 <sys_open+0x72>
      iunlockput(ip);
    80004f88:	854a                	mv	a0,s2
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	128080e7          	jalr	296(ra) # 800030b2 <iunlockput>
      end_op();
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	906080e7          	jalr	-1786(ra) # 80003898 <end_op>
      return -1;
    80004f9a:	54fd                	li	s1,-1
    80004f9c:	790a                	ld	s2,160(sp)
    80004f9e:	b76d                	j	80004f48 <sys_open+0xe6>
      end_op();
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	8f8080e7          	jalr	-1800(ra) # 80003898 <end_op>
      return -1;
    80004fa8:	54fd                	li	s1,-1
    80004faa:	790a                	ld	s2,160(sp)
    80004fac:	bf71                	j	80004f48 <sys_open+0xe6>
    iunlockput(ip);
    80004fae:	854a                	mv	a0,s2
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	102080e7          	jalr	258(ra) # 800030b2 <iunlockput>
    end_op();
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	8e0080e7          	jalr	-1824(ra) # 80003898 <end_op>
    return -1;
    80004fc0:	54fd                	li	s1,-1
    80004fc2:	790a                	ld	s2,160(sp)
    80004fc4:	b751                	j	80004f48 <sys_open+0xe6>
      fileclose(f);
    80004fc6:	854e                	mv	a0,s3
    80004fc8:	fffff097          	auipc	ra,0xfffff
    80004fcc:	d20080e7          	jalr	-736(ra) # 80003ce8 <fileclose>
    iunlockput(ip);
    80004fd0:	854a                	mv	a0,s2
    80004fd2:	ffffe097          	auipc	ra,0xffffe
    80004fd6:	0e0080e7          	jalr	224(ra) # 800030b2 <iunlockput>
    end_op();
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	8be080e7          	jalr	-1858(ra) # 80003898 <end_op>
    return -1;
    80004fe2:	54fd                	li	s1,-1
    80004fe4:	790a                	ld	s2,160(sp)
    80004fe6:	69ea                	ld	s3,152(sp)
    80004fe8:	b785                	j	80004f48 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004fea:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004fee:	04691783          	lh	a5,70(s2)
    80004ff2:	02f99223          	sh	a5,36(s3)
    80004ff6:	b739                	j	80004f04 <sys_open+0xa2>
    itrunc(ip);
    80004ff8:	854a                	mv	a0,s2
    80004ffa:	ffffe097          	auipc	ra,0xffffe
    80004ffe:	f64080e7          	jalr	-156(ra) # 80002f5e <itrunc>
    80005002:	bf05                	j	80004f32 <sys_open+0xd0>

0000000080005004 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005004:	7175                	addi	sp,sp,-144
    80005006:	e506                	sd	ra,136(sp)
    80005008:	e122                	sd	s0,128(sp)
    8000500a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000500c:	fffff097          	auipc	ra,0xfffff
    80005010:	812080e7          	jalr	-2030(ra) # 8000381e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005014:	08000613          	li	a2,128
    80005018:	f7040593          	addi	a1,s0,-144
    8000501c:	4501                	li	a0,0
    8000501e:	ffffd097          	auipc	ra,0xffffd
    80005022:	300080e7          	jalr	768(ra) # 8000231e <argstr>
    80005026:	02054963          	bltz	a0,80005058 <sys_mkdir+0x54>
    8000502a:	4681                	li	a3,0
    8000502c:	4601                	li	a2,0
    8000502e:	4585                	li	a1,1
    80005030:	f7040513          	addi	a0,s0,-144
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	7d8080e7          	jalr	2008(ra) # 8000480c <create>
    8000503c:	cd11                	beqz	a0,80005058 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000503e:	ffffe097          	auipc	ra,0xffffe
    80005042:	074080e7          	jalr	116(ra) # 800030b2 <iunlockput>
  end_op();
    80005046:	fffff097          	auipc	ra,0xfffff
    8000504a:	852080e7          	jalr	-1966(ra) # 80003898 <end_op>
  return 0;
    8000504e:	4501                	li	a0,0
}
    80005050:	60aa                	ld	ra,136(sp)
    80005052:	640a                	ld	s0,128(sp)
    80005054:	6149                	addi	sp,sp,144
    80005056:	8082                	ret
    end_op();
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	840080e7          	jalr	-1984(ra) # 80003898 <end_op>
    return -1;
    80005060:	557d                	li	a0,-1
    80005062:	b7fd                	j	80005050 <sys_mkdir+0x4c>

0000000080005064 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005064:	7135                	addi	sp,sp,-160
    80005066:	ed06                	sd	ra,152(sp)
    80005068:	e922                	sd	s0,144(sp)
    8000506a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000506c:	ffffe097          	auipc	ra,0xffffe
    80005070:	7b2080e7          	jalr	1970(ra) # 8000381e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005074:	08000613          	li	a2,128
    80005078:	f7040593          	addi	a1,s0,-144
    8000507c:	4501                	li	a0,0
    8000507e:	ffffd097          	auipc	ra,0xffffd
    80005082:	2a0080e7          	jalr	672(ra) # 8000231e <argstr>
    80005086:	04054a63          	bltz	a0,800050da <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000508a:	f6c40593          	addi	a1,s0,-148
    8000508e:	4505                	li	a0,1
    80005090:	ffffd097          	auipc	ra,0xffffd
    80005094:	24a080e7          	jalr	586(ra) # 800022da <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005098:	04054163          	bltz	a0,800050da <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000509c:	f6840593          	addi	a1,s0,-152
    800050a0:	4509                	li	a0,2
    800050a2:	ffffd097          	auipc	ra,0xffffd
    800050a6:	238080e7          	jalr	568(ra) # 800022da <argint>
     argint(1, &major) < 0 ||
    800050aa:	02054863          	bltz	a0,800050da <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050ae:	f6841683          	lh	a3,-152(s0)
    800050b2:	f6c41603          	lh	a2,-148(s0)
    800050b6:	458d                	li	a1,3
    800050b8:	f7040513          	addi	a0,s0,-144
    800050bc:	fffff097          	auipc	ra,0xfffff
    800050c0:	750080e7          	jalr	1872(ra) # 8000480c <create>
     argint(2, &minor) < 0 ||
    800050c4:	c919                	beqz	a0,800050da <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050c6:	ffffe097          	auipc	ra,0xffffe
    800050ca:	fec080e7          	jalr	-20(ra) # 800030b2 <iunlockput>
  end_op();
    800050ce:	ffffe097          	auipc	ra,0xffffe
    800050d2:	7ca080e7          	jalr	1994(ra) # 80003898 <end_op>
  return 0;
    800050d6:	4501                	li	a0,0
    800050d8:	a031                	j	800050e4 <sys_mknod+0x80>
    end_op();
    800050da:	ffffe097          	auipc	ra,0xffffe
    800050de:	7be080e7          	jalr	1982(ra) # 80003898 <end_op>
    return -1;
    800050e2:	557d                	li	a0,-1
}
    800050e4:	60ea                	ld	ra,152(sp)
    800050e6:	644a                	ld	s0,144(sp)
    800050e8:	610d                	addi	sp,sp,160
    800050ea:	8082                	ret

00000000800050ec <sys_chdir>:

uint64
sys_chdir(void)
{
    800050ec:	7135                	addi	sp,sp,-160
    800050ee:	ed06                	sd	ra,152(sp)
    800050f0:	e922                	sd	s0,144(sp)
    800050f2:	e14a                	sd	s2,128(sp)
    800050f4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050f6:	ffffc097          	auipc	ra,0xffffc
    800050fa:	014080e7          	jalr	20(ra) # 8000110a <myproc>
    800050fe:	892a                	mv	s2,a0
  
  begin_op();
    80005100:	ffffe097          	auipc	ra,0xffffe
    80005104:	71e080e7          	jalr	1822(ra) # 8000381e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005108:	08000613          	li	a2,128
    8000510c:	f6040593          	addi	a1,s0,-160
    80005110:	4501                	li	a0,0
    80005112:	ffffd097          	auipc	ra,0xffffd
    80005116:	20c080e7          	jalr	524(ra) # 8000231e <argstr>
    8000511a:	04054d63          	bltz	a0,80005174 <sys_chdir+0x88>
    8000511e:	e526                	sd	s1,136(sp)
    80005120:	f6040513          	addi	a0,s0,-160
    80005124:	ffffe097          	auipc	ra,0xffffe
    80005128:	4fa080e7          	jalr	1274(ra) # 8000361e <namei>
    8000512c:	84aa                	mv	s1,a0
    8000512e:	c131                	beqz	a0,80005172 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005130:	ffffe097          	auipc	ra,0xffffe
    80005134:	d1c080e7          	jalr	-740(ra) # 80002e4c <ilock>
  if(ip->type != T_DIR){
    80005138:	04449703          	lh	a4,68(s1)
    8000513c:	4785                	li	a5,1
    8000513e:	04f71163          	bne	a4,a5,80005180 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005142:	8526                	mv	a0,s1
    80005144:	ffffe097          	auipc	ra,0xffffe
    80005148:	dce080e7          	jalr	-562(ra) # 80002f12 <iunlock>
  iput(p->cwd);
    8000514c:	15093503          	ld	a0,336(s2)
    80005150:	ffffe097          	auipc	ra,0xffffe
    80005154:	eba080e7          	jalr	-326(ra) # 8000300a <iput>
  end_op();
    80005158:	ffffe097          	auipc	ra,0xffffe
    8000515c:	740080e7          	jalr	1856(ra) # 80003898 <end_op>
  p->cwd = ip;
    80005160:	14993823          	sd	s1,336(s2)
  return 0;
    80005164:	4501                	li	a0,0
    80005166:	64aa                	ld	s1,136(sp)
}
    80005168:	60ea                	ld	ra,152(sp)
    8000516a:	644a                	ld	s0,144(sp)
    8000516c:	690a                	ld	s2,128(sp)
    8000516e:	610d                	addi	sp,sp,160
    80005170:	8082                	ret
    80005172:	64aa                	ld	s1,136(sp)
    end_op();
    80005174:	ffffe097          	auipc	ra,0xffffe
    80005178:	724080e7          	jalr	1828(ra) # 80003898 <end_op>
    return -1;
    8000517c:	557d                	li	a0,-1
    8000517e:	b7ed                	j	80005168 <sys_chdir+0x7c>
    iunlockput(ip);
    80005180:	8526                	mv	a0,s1
    80005182:	ffffe097          	auipc	ra,0xffffe
    80005186:	f30080e7          	jalr	-208(ra) # 800030b2 <iunlockput>
    end_op();
    8000518a:	ffffe097          	auipc	ra,0xffffe
    8000518e:	70e080e7          	jalr	1806(ra) # 80003898 <end_op>
    return -1;
    80005192:	557d                	li	a0,-1
    80005194:	64aa                	ld	s1,136(sp)
    80005196:	bfc9                	j	80005168 <sys_chdir+0x7c>

0000000080005198 <sys_exec>:

uint64
sys_exec(void)
{
    80005198:	7121                	addi	sp,sp,-448
    8000519a:	ff06                	sd	ra,440(sp)
    8000519c:	fb22                	sd	s0,432(sp)
    8000519e:	f34a                	sd	s2,416(sp)
    800051a0:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051a2:	08000613          	li	a2,128
    800051a6:	f5040593          	addi	a1,s0,-176
    800051aa:	4501                	li	a0,0
    800051ac:	ffffd097          	auipc	ra,0xffffd
    800051b0:	172080e7          	jalr	370(ra) # 8000231e <argstr>
    return -1;
    800051b4:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051b6:	0e054a63          	bltz	a0,800052aa <sys_exec+0x112>
    800051ba:	e4840593          	addi	a1,s0,-440
    800051be:	4505                	li	a0,1
    800051c0:	ffffd097          	auipc	ra,0xffffd
    800051c4:	13c080e7          	jalr	316(ra) # 800022fc <argaddr>
    800051c8:	0e054163          	bltz	a0,800052aa <sys_exec+0x112>
    800051cc:	f726                	sd	s1,424(sp)
    800051ce:	ef4e                	sd	s3,408(sp)
    800051d0:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051d2:	10000613          	li	a2,256
    800051d6:	4581                	li	a1,0
    800051d8:	e5040513          	addi	a0,s0,-432
    800051dc:	ffffb097          	auipc	ra,0xffffb
    800051e0:	106080e7          	jalr	262(ra) # 800002e2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051e4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051e8:	89a6                	mv	s3,s1
    800051ea:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051ec:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051f0:	00391513          	slli	a0,s2,0x3
    800051f4:	e4040593          	addi	a1,s0,-448
    800051f8:	e4843783          	ld	a5,-440(s0)
    800051fc:	953e                	add	a0,a0,a5
    800051fe:	ffffd097          	auipc	ra,0xffffd
    80005202:	042080e7          	jalr	66(ra) # 80002240 <fetchaddr>
    80005206:	02054a63          	bltz	a0,8000523a <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    8000520a:	e4043783          	ld	a5,-448(s0)
    8000520e:	c7b1                	beqz	a5,8000525a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005210:	ffffb097          	auipc	ra,0xffffb
    80005214:	fbe080e7          	jalr	-66(ra) # 800001ce <kalloc>
    80005218:	85aa                	mv	a1,a0
    8000521a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000521e:	cd11                	beqz	a0,8000523a <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005220:	6605                	lui	a2,0x1
    80005222:	e4043503          	ld	a0,-448(s0)
    80005226:	ffffd097          	auipc	ra,0xffffd
    8000522a:	06c080e7          	jalr	108(ra) # 80002292 <fetchstr>
    8000522e:	00054663          	bltz	a0,8000523a <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005232:	0905                	addi	s2,s2,1
    80005234:	09a1                	addi	s3,s3,8
    80005236:	fb491de3          	bne	s2,s4,800051f0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000523a:	f5040913          	addi	s2,s0,-176
    8000523e:	6088                	ld	a0,0(s1)
    80005240:	c12d                	beqz	a0,800052a2 <sys_exec+0x10a>
    kfree(argv[i]);
    80005242:	ffffb097          	auipc	ra,0xffffb
    80005246:	dda080e7          	jalr	-550(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000524a:	04a1                	addi	s1,s1,8
    8000524c:	ff2499e3          	bne	s1,s2,8000523e <sys_exec+0xa6>
  return -1;
    80005250:	597d                	li	s2,-1
    80005252:	74ba                	ld	s1,424(sp)
    80005254:	69fa                	ld	s3,408(sp)
    80005256:	6a5a                	ld	s4,400(sp)
    80005258:	a889                	j	800052aa <sys_exec+0x112>
      argv[i] = 0;
    8000525a:	0009079b          	sext.w	a5,s2
    8000525e:	078e                	slli	a5,a5,0x3
    80005260:	fd078793          	addi	a5,a5,-48
    80005264:	97a2                	add	a5,a5,s0
    80005266:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000526a:	e5040593          	addi	a1,s0,-432
    8000526e:	f5040513          	addi	a0,s0,-176
    80005272:	fffff097          	auipc	ra,0xfffff
    80005276:	126080e7          	jalr	294(ra) # 80004398 <exec>
    8000527a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000527c:	f5040993          	addi	s3,s0,-176
    80005280:	6088                	ld	a0,0(s1)
    80005282:	cd01                	beqz	a0,8000529a <sys_exec+0x102>
    kfree(argv[i]);
    80005284:	ffffb097          	auipc	ra,0xffffb
    80005288:	d98080e7          	jalr	-616(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000528c:	04a1                	addi	s1,s1,8
    8000528e:	ff3499e3          	bne	s1,s3,80005280 <sys_exec+0xe8>
    80005292:	74ba                	ld	s1,424(sp)
    80005294:	69fa                	ld	s3,408(sp)
    80005296:	6a5a                	ld	s4,400(sp)
    80005298:	a809                	j	800052aa <sys_exec+0x112>
  return ret;
    8000529a:	74ba                	ld	s1,424(sp)
    8000529c:	69fa                	ld	s3,408(sp)
    8000529e:	6a5a                	ld	s4,400(sp)
    800052a0:	a029                	j	800052aa <sys_exec+0x112>
  return -1;
    800052a2:	597d                	li	s2,-1
    800052a4:	74ba                	ld	s1,424(sp)
    800052a6:	69fa                	ld	s3,408(sp)
    800052a8:	6a5a                	ld	s4,400(sp)
}
    800052aa:	854a                	mv	a0,s2
    800052ac:	70fa                	ld	ra,440(sp)
    800052ae:	745a                	ld	s0,432(sp)
    800052b0:	791a                	ld	s2,416(sp)
    800052b2:	6139                	addi	sp,sp,448
    800052b4:	8082                	ret

00000000800052b6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800052b6:	7139                	addi	sp,sp,-64
    800052b8:	fc06                	sd	ra,56(sp)
    800052ba:	f822                	sd	s0,48(sp)
    800052bc:	f426                	sd	s1,40(sp)
    800052be:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	e4a080e7          	jalr	-438(ra) # 8000110a <myproc>
    800052c8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800052ca:	fd840593          	addi	a1,s0,-40
    800052ce:	4501                	li	a0,0
    800052d0:	ffffd097          	auipc	ra,0xffffd
    800052d4:	02c080e7          	jalr	44(ra) # 800022fc <argaddr>
    return -1;
    800052d8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800052da:	0e054063          	bltz	a0,800053ba <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800052de:	fc840593          	addi	a1,s0,-56
    800052e2:	fd040513          	addi	a0,s0,-48
    800052e6:	fffff097          	auipc	ra,0xfffff
    800052ea:	d70080e7          	jalr	-656(ra) # 80004056 <pipealloc>
    return -1;
    800052ee:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052f0:	0c054563          	bltz	a0,800053ba <sys_pipe+0x104>
  fd0 = -1;
    800052f4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052f8:	fd043503          	ld	a0,-48(s0)
    800052fc:	fffff097          	auipc	ra,0xfffff
    80005300:	4ce080e7          	jalr	1230(ra) # 800047ca <fdalloc>
    80005304:	fca42223          	sw	a0,-60(s0)
    80005308:	08054c63          	bltz	a0,800053a0 <sys_pipe+0xea>
    8000530c:	fc843503          	ld	a0,-56(s0)
    80005310:	fffff097          	auipc	ra,0xfffff
    80005314:	4ba080e7          	jalr	1210(ra) # 800047ca <fdalloc>
    80005318:	fca42023          	sw	a0,-64(s0)
    8000531c:	06054963          	bltz	a0,8000538e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005320:	4691                	li	a3,4
    80005322:	fc440613          	addi	a2,s0,-60
    80005326:	fd843583          	ld	a1,-40(s0)
    8000532a:	68a8                	ld	a0,80(s1)
    8000532c:	ffffc097          	auipc	ra,0xffffc
    80005330:	936080e7          	jalr	-1738(ra) # 80000c62 <copyout>
    80005334:	02054063          	bltz	a0,80005354 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005338:	4691                	li	a3,4
    8000533a:	fc040613          	addi	a2,s0,-64
    8000533e:	fd843583          	ld	a1,-40(s0)
    80005342:	0591                	addi	a1,a1,4
    80005344:	68a8                	ld	a0,80(s1)
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	91c080e7          	jalr	-1764(ra) # 80000c62 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000534e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005350:	06055563          	bgez	a0,800053ba <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005354:	fc442783          	lw	a5,-60(s0)
    80005358:	07e9                	addi	a5,a5,26
    8000535a:	078e                	slli	a5,a5,0x3
    8000535c:	97a6                	add	a5,a5,s1
    8000535e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005362:	fc042783          	lw	a5,-64(s0)
    80005366:	07e9                	addi	a5,a5,26
    80005368:	078e                	slli	a5,a5,0x3
    8000536a:	00f48533          	add	a0,s1,a5
    8000536e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005372:	fd043503          	ld	a0,-48(s0)
    80005376:	fffff097          	auipc	ra,0xfffff
    8000537a:	972080e7          	jalr	-1678(ra) # 80003ce8 <fileclose>
    fileclose(wf);
    8000537e:	fc843503          	ld	a0,-56(s0)
    80005382:	fffff097          	auipc	ra,0xfffff
    80005386:	966080e7          	jalr	-1690(ra) # 80003ce8 <fileclose>
    return -1;
    8000538a:	57fd                	li	a5,-1
    8000538c:	a03d                	j	800053ba <sys_pipe+0x104>
    if(fd0 >= 0)
    8000538e:	fc442783          	lw	a5,-60(s0)
    80005392:	0007c763          	bltz	a5,800053a0 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005396:	07e9                	addi	a5,a5,26
    80005398:	078e                	slli	a5,a5,0x3
    8000539a:	97a6                	add	a5,a5,s1
    8000539c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800053a0:	fd043503          	ld	a0,-48(s0)
    800053a4:	fffff097          	auipc	ra,0xfffff
    800053a8:	944080e7          	jalr	-1724(ra) # 80003ce8 <fileclose>
    fileclose(wf);
    800053ac:	fc843503          	ld	a0,-56(s0)
    800053b0:	fffff097          	auipc	ra,0xfffff
    800053b4:	938080e7          	jalr	-1736(ra) # 80003ce8 <fileclose>
    return -1;
    800053b8:	57fd                	li	a5,-1
}
    800053ba:	853e                	mv	a0,a5
    800053bc:	70e2                	ld	ra,56(sp)
    800053be:	7442                	ld	s0,48(sp)
    800053c0:	74a2                	ld	s1,40(sp)
    800053c2:	6121                	addi	sp,sp,64
    800053c4:	8082                	ret
	...

00000000800053d0 <kernelvec>:
    800053d0:	7111                	addi	sp,sp,-256
    800053d2:	e006                	sd	ra,0(sp)
    800053d4:	e40a                	sd	sp,8(sp)
    800053d6:	e80e                	sd	gp,16(sp)
    800053d8:	ec12                	sd	tp,24(sp)
    800053da:	f016                	sd	t0,32(sp)
    800053dc:	f41a                	sd	t1,40(sp)
    800053de:	f81e                	sd	t2,48(sp)
    800053e0:	fc22                	sd	s0,56(sp)
    800053e2:	e0a6                	sd	s1,64(sp)
    800053e4:	e4aa                	sd	a0,72(sp)
    800053e6:	e8ae                	sd	a1,80(sp)
    800053e8:	ecb2                	sd	a2,88(sp)
    800053ea:	f0b6                	sd	a3,96(sp)
    800053ec:	f4ba                	sd	a4,104(sp)
    800053ee:	f8be                	sd	a5,112(sp)
    800053f0:	fcc2                	sd	a6,120(sp)
    800053f2:	e146                	sd	a7,128(sp)
    800053f4:	e54a                	sd	s2,136(sp)
    800053f6:	e94e                	sd	s3,144(sp)
    800053f8:	ed52                	sd	s4,152(sp)
    800053fa:	f156                	sd	s5,160(sp)
    800053fc:	f55a                	sd	s6,168(sp)
    800053fe:	f95e                	sd	s7,176(sp)
    80005400:	fd62                	sd	s8,184(sp)
    80005402:	e1e6                	sd	s9,192(sp)
    80005404:	e5ea                	sd	s10,200(sp)
    80005406:	e9ee                	sd	s11,208(sp)
    80005408:	edf2                	sd	t3,216(sp)
    8000540a:	f1f6                	sd	t4,224(sp)
    8000540c:	f5fa                	sd	t5,232(sp)
    8000540e:	f9fe                	sd	t6,240(sp)
    80005410:	cfdfc0ef          	jal	8000210c <kerneltrap>
    80005414:	6082                	ld	ra,0(sp)
    80005416:	6122                	ld	sp,8(sp)
    80005418:	61c2                	ld	gp,16(sp)
    8000541a:	7282                	ld	t0,32(sp)
    8000541c:	7322                	ld	t1,40(sp)
    8000541e:	73c2                	ld	t2,48(sp)
    80005420:	7462                	ld	s0,56(sp)
    80005422:	6486                	ld	s1,64(sp)
    80005424:	6526                	ld	a0,72(sp)
    80005426:	65c6                	ld	a1,80(sp)
    80005428:	6666                	ld	a2,88(sp)
    8000542a:	7686                	ld	a3,96(sp)
    8000542c:	7726                	ld	a4,104(sp)
    8000542e:	77c6                	ld	a5,112(sp)
    80005430:	7866                	ld	a6,120(sp)
    80005432:	688a                	ld	a7,128(sp)
    80005434:	692a                	ld	s2,136(sp)
    80005436:	69ca                	ld	s3,144(sp)
    80005438:	6a6a                	ld	s4,152(sp)
    8000543a:	7a8a                	ld	s5,160(sp)
    8000543c:	7b2a                	ld	s6,168(sp)
    8000543e:	7bca                	ld	s7,176(sp)
    80005440:	7c6a                	ld	s8,184(sp)
    80005442:	6c8e                	ld	s9,192(sp)
    80005444:	6d2e                	ld	s10,200(sp)
    80005446:	6dce                	ld	s11,208(sp)
    80005448:	6e6e                	ld	t3,216(sp)
    8000544a:	7e8e                	ld	t4,224(sp)
    8000544c:	7f2e                	ld	t5,232(sp)
    8000544e:	7fce                	ld	t6,240(sp)
    80005450:	6111                	addi	sp,sp,256
    80005452:	10200073          	sret
    80005456:	00000013          	nop
    8000545a:	00000013          	nop
    8000545e:	0001                	nop

0000000080005460 <timervec>:
    80005460:	34051573          	csrrw	a0,mscratch,a0
    80005464:	e10c                	sd	a1,0(a0)
    80005466:	e510                	sd	a2,8(a0)
    80005468:	e914                	sd	a3,16(a0)
    8000546a:	6d0c                	ld	a1,24(a0)
    8000546c:	7110                	ld	a2,32(a0)
    8000546e:	6194                	ld	a3,0(a1)
    80005470:	96b2                	add	a3,a3,a2
    80005472:	e194                	sd	a3,0(a1)
    80005474:	4589                	li	a1,2
    80005476:	14459073          	csrw	sip,a1
    8000547a:	6914                	ld	a3,16(a0)
    8000547c:	6510                	ld	a2,8(a0)
    8000547e:	610c                	ld	a1,0(a0)
    80005480:	34051573          	csrrw	a0,mscratch,a0
    80005484:	30200073          	mret
	...

000000008000548a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000548a:	1141                	addi	sp,sp,-16
    8000548c:	e422                	sd	s0,8(sp)
    8000548e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005490:	0c0007b7          	lui	a5,0xc000
    80005494:	4705                	li	a4,1
    80005496:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005498:	0c0007b7          	lui	a5,0xc000
    8000549c:	c3d8                	sw	a4,4(a5)
}
    8000549e:	6422                	ld	s0,8(sp)
    800054a0:	0141                	addi	sp,sp,16
    800054a2:	8082                	ret

00000000800054a4 <plicinithart>:

void
plicinithart(void)
{
    800054a4:	1141                	addi	sp,sp,-16
    800054a6:	e406                	sd	ra,8(sp)
    800054a8:	e022                	sd	s0,0(sp)
    800054aa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054ac:	ffffc097          	auipc	ra,0xffffc
    800054b0:	c32080e7          	jalr	-974(ra) # 800010de <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054b4:	0085171b          	slliw	a4,a0,0x8
    800054b8:	0c0027b7          	lui	a5,0xc002
    800054bc:	97ba                	add	a5,a5,a4
    800054be:	40200713          	li	a4,1026
    800054c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054c6:	00d5151b          	slliw	a0,a0,0xd
    800054ca:	0c2017b7          	lui	a5,0xc201
    800054ce:	97aa                	add	a5,a5,a0
    800054d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054d4:	60a2                	ld	ra,8(sp)
    800054d6:	6402                	ld	s0,0(sp)
    800054d8:	0141                	addi	sp,sp,16
    800054da:	8082                	ret

00000000800054dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054dc:	1141                	addi	sp,sp,-16
    800054de:	e406                	sd	ra,8(sp)
    800054e0:	e022                	sd	s0,0(sp)
    800054e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054e4:	ffffc097          	auipc	ra,0xffffc
    800054e8:	bfa080e7          	jalr	-1030(ra) # 800010de <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054ec:	00d5151b          	slliw	a0,a0,0xd
    800054f0:	0c2017b7          	lui	a5,0xc201
    800054f4:	97aa                	add	a5,a5,a0
  return irq;
}
    800054f6:	43c8                	lw	a0,4(a5)
    800054f8:	60a2                	ld	ra,8(sp)
    800054fa:	6402                	ld	s0,0(sp)
    800054fc:	0141                	addi	sp,sp,16
    800054fe:	8082                	ret

0000000080005500 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005500:	1101                	addi	sp,sp,-32
    80005502:	ec06                	sd	ra,24(sp)
    80005504:	e822                	sd	s0,16(sp)
    80005506:	e426                	sd	s1,8(sp)
    80005508:	1000                	addi	s0,sp,32
    8000550a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000550c:	ffffc097          	auipc	ra,0xffffc
    80005510:	bd2080e7          	jalr	-1070(ra) # 800010de <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005514:	00d5151b          	slliw	a0,a0,0xd
    80005518:	0c2017b7          	lui	a5,0xc201
    8000551c:	97aa                	add	a5,a5,a0
    8000551e:	c3c4                	sw	s1,4(a5)
}
    80005520:	60e2                	ld	ra,24(sp)
    80005522:	6442                	ld	s0,16(sp)
    80005524:	64a2                	ld	s1,8(sp)
    80005526:	6105                	addi	sp,sp,32
    80005528:	8082                	ret

000000008000552a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000552a:	1141                	addi	sp,sp,-16
    8000552c:	e406                	sd	ra,8(sp)
    8000552e:	e022                	sd	s0,0(sp)
    80005530:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005532:	479d                	li	a5,7
    80005534:	06a7c863          	blt	a5,a0,800055a4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005538:	00019717          	auipc	a4,0x19
    8000553c:	ac870713          	addi	a4,a4,-1336 # 8001e000 <disk>
    80005540:	972a                	add	a4,a4,a0
    80005542:	6789                	lui	a5,0x2
    80005544:	97ba                	add	a5,a5,a4
    80005546:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000554a:	e7ad                	bnez	a5,800055b4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000554c:	00451793          	slli	a5,a0,0x4
    80005550:	0001b717          	auipc	a4,0x1b
    80005554:	ab070713          	addi	a4,a4,-1360 # 80020000 <disk+0x2000>
    80005558:	6314                	ld	a3,0(a4)
    8000555a:	96be                	add	a3,a3,a5
    8000555c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005560:	6314                	ld	a3,0(a4)
    80005562:	96be                	add	a3,a3,a5
    80005564:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005568:	6314                	ld	a3,0(a4)
    8000556a:	96be                	add	a3,a3,a5
    8000556c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005570:	6318                	ld	a4,0(a4)
    80005572:	97ba                	add	a5,a5,a4
    80005574:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005578:	00019717          	auipc	a4,0x19
    8000557c:	a8870713          	addi	a4,a4,-1400 # 8001e000 <disk>
    80005580:	972a                	add	a4,a4,a0
    80005582:	6789                	lui	a5,0x2
    80005584:	97ba                	add	a5,a5,a4
    80005586:	4705                	li	a4,1
    80005588:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000558c:	0001b517          	auipc	a0,0x1b
    80005590:	a8c50513          	addi	a0,a0,-1396 # 80020018 <disk+0x2018>
    80005594:	ffffc097          	auipc	ra,0xffffc
    80005598:	3c8080e7          	jalr	968(ra) # 8000195c <wakeup>
}
    8000559c:	60a2                	ld	ra,8(sp)
    8000559e:	6402                	ld	s0,0(sp)
    800055a0:	0141                	addi	sp,sp,16
    800055a2:	8082                	ret
    panic("free_desc 1");
    800055a4:	00003517          	auipc	a0,0x3
    800055a8:	04450513          	addi	a0,a0,68 # 800085e8 <etext+0x5e8>
    800055ac:	00001097          	auipc	ra,0x1
    800055b0:	a10080e7          	jalr	-1520(ra) # 80005fbc <panic>
    panic("free_desc 2");
    800055b4:	00003517          	auipc	a0,0x3
    800055b8:	04450513          	addi	a0,a0,68 # 800085f8 <etext+0x5f8>
    800055bc:	00001097          	auipc	ra,0x1
    800055c0:	a00080e7          	jalr	-1536(ra) # 80005fbc <panic>

00000000800055c4 <virtio_disk_init>:
{
    800055c4:	1141                	addi	sp,sp,-16
    800055c6:	e406                	sd	ra,8(sp)
    800055c8:	e022                	sd	s0,0(sp)
    800055ca:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055cc:	00003597          	auipc	a1,0x3
    800055d0:	03c58593          	addi	a1,a1,60 # 80008608 <etext+0x608>
    800055d4:	0001b517          	auipc	a0,0x1b
    800055d8:	b5450513          	addi	a0,a0,-1196 # 80020128 <disk+0x2128>
    800055dc:	00001097          	auipc	ra,0x1
    800055e0:	eca080e7          	jalr	-310(ra) # 800064a6 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055e4:	100017b7          	lui	a5,0x10001
    800055e8:	4398                	lw	a4,0(a5)
    800055ea:	2701                	sext.w	a4,a4
    800055ec:	747277b7          	lui	a5,0x74727
    800055f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055f4:	0ef71f63          	bne	a4,a5,800056f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800055fe:	439c                	lw	a5,0(a5)
    80005600:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005602:	4705                	li	a4,1
    80005604:	0ee79763          	bne	a5,a4,800056f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005608:	100017b7          	lui	a5,0x10001
    8000560c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000560e:	439c                	lw	a5,0(a5)
    80005610:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005612:	4709                	li	a4,2
    80005614:	0ce79f63          	bne	a5,a4,800056f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	47d8                	lw	a4,12(a5)
    8000561e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005620:	554d47b7          	lui	a5,0x554d4
    80005624:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005628:	0cf71563          	bne	a4,a5,800056f2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000562c:	100017b7          	lui	a5,0x10001
    80005630:	4705                	li	a4,1
    80005632:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005634:	470d                	li	a4,3
    80005636:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005638:	10001737          	lui	a4,0x10001
    8000563c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000563e:	c7ffe737          	lui	a4,0xc7ffe
    80005642:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005646:	8ef9                	and	a3,a3,a4
    80005648:	10001737          	lui	a4,0x10001
    8000564c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000564e:	472d                	li	a4,11
    80005650:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005652:	473d                	li	a4,15
    80005654:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	6705                	lui	a4,0x1
    8000565c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000565e:	100017b7          	lui	a5,0x10001
    80005662:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005666:	100017b7          	lui	a5,0x10001
    8000566a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000566e:	439c                	lw	a5,0(a5)
    80005670:	2781                	sext.w	a5,a5
  if(max == 0)
    80005672:	cbc1                	beqz	a5,80005702 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005674:	471d                	li	a4,7
    80005676:	08f77e63          	bgeu	a4,a5,80005712 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000567a:	100017b7          	lui	a5,0x10001
    8000567e:	4721                	li	a4,8
    80005680:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005682:	6609                	lui	a2,0x2
    80005684:	4581                	li	a1,0
    80005686:	00019517          	auipc	a0,0x19
    8000568a:	97a50513          	addi	a0,a0,-1670 # 8001e000 <disk>
    8000568e:	ffffb097          	auipc	ra,0xffffb
    80005692:	c54080e7          	jalr	-940(ra) # 800002e2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005696:	00019697          	auipc	a3,0x19
    8000569a:	96a68693          	addi	a3,a3,-1686 # 8001e000 <disk>
    8000569e:	00c6d713          	srli	a4,a3,0xc
    800056a2:	2701                	sext.w	a4,a4
    800056a4:	100017b7          	lui	a5,0x10001
    800056a8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800056aa:	0001b797          	auipc	a5,0x1b
    800056ae:	95678793          	addi	a5,a5,-1706 # 80020000 <disk+0x2000>
    800056b2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800056b4:	00019717          	auipc	a4,0x19
    800056b8:	9cc70713          	addi	a4,a4,-1588 # 8001e080 <disk+0x80>
    800056bc:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800056be:	0001a717          	auipc	a4,0x1a
    800056c2:	94270713          	addi	a4,a4,-1726 # 8001f000 <disk+0x1000>
    800056c6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800056c8:	4705                	li	a4,1
    800056ca:	00e78c23          	sb	a4,24(a5)
    800056ce:	00e78ca3          	sb	a4,25(a5)
    800056d2:	00e78d23          	sb	a4,26(a5)
    800056d6:	00e78da3          	sb	a4,27(a5)
    800056da:	00e78e23          	sb	a4,28(a5)
    800056de:	00e78ea3          	sb	a4,29(a5)
    800056e2:	00e78f23          	sb	a4,30(a5)
    800056e6:	00e78fa3          	sb	a4,31(a5)
}
    800056ea:	60a2                	ld	ra,8(sp)
    800056ec:	6402                	ld	s0,0(sp)
    800056ee:	0141                	addi	sp,sp,16
    800056f0:	8082                	ret
    panic("could not find virtio disk");
    800056f2:	00003517          	auipc	a0,0x3
    800056f6:	f2650513          	addi	a0,a0,-218 # 80008618 <etext+0x618>
    800056fa:	00001097          	auipc	ra,0x1
    800056fe:	8c2080e7          	jalr	-1854(ra) # 80005fbc <panic>
    panic("virtio disk has no queue 0");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	f3650513          	addi	a0,a0,-202 # 80008638 <etext+0x638>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	8b2080e7          	jalr	-1870(ra) # 80005fbc <panic>
    panic("virtio disk max queue too short");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	f4650513          	addi	a0,a0,-186 # 80008658 <etext+0x658>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	8a2080e7          	jalr	-1886(ra) # 80005fbc <panic>

0000000080005722 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005722:	7159                	addi	sp,sp,-112
    80005724:	f486                	sd	ra,104(sp)
    80005726:	f0a2                	sd	s0,96(sp)
    80005728:	eca6                	sd	s1,88(sp)
    8000572a:	e8ca                	sd	s2,80(sp)
    8000572c:	e4ce                	sd	s3,72(sp)
    8000572e:	e0d2                	sd	s4,64(sp)
    80005730:	fc56                	sd	s5,56(sp)
    80005732:	f85a                	sd	s6,48(sp)
    80005734:	f45e                	sd	s7,40(sp)
    80005736:	f062                	sd	s8,32(sp)
    80005738:	ec66                	sd	s9,24(sp)
    8000573a:	1880                	addi	s0,sp,112
    8000573c:	8a2a                	mv	s4,a0
    8000573e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005740:	00c52c03          	lw	s8,12(a0)
    80005744:	001c1c1b          	slliw	s8,s8,0x1
    80005748:	1c02                	slli	s8,s8,0x20
    8000574a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000574e:	0001b517          	auipc	a0,0x1b
    80005752:	9da50513          	addi	a0,a0,-1574 # 80020128 <disk+0x2128>
    80005756:	00001097          	auipc	ra,0x1
    8000575a:	de0080e7          	jalr	-544(ra) # 80006536 <acquire>
  for(int i = 0; i < 3; i++){
    8000575e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005760:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005762:	00019b97          	auipc	s7,0x19
    80005766:	89eb8b93          	addi	s7,s7,-1890 # 8001e000 <disk>
    8000576a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000576c:	4a8d                	li	s5,3
    8000576e:	a88d                	j	800057e0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005770:	00fb8733          	add	a4,s7,a5
    80005774:	975a                	add	a4,a4,s6
    80005776:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000577a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000577c:	0207c563          	bltz	a5,800057a6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005780:	2905                	addiw	s2,s2,1
    80005782:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005784:	1b590163          	beq	s2,s5,80005926 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005788:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000578a:	0001b717          	auipc	a4,0x1b
    8000578e:	88e70713          	addi	a4,a4,-1906 # 80020018 <disk+0x2018>
    80005792:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005794:	00074683          	lbu	a3,0(a4)
    80005798:	fee1                	bnez	a3,80005770 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000579a:	2785                	addiw	a5,a5,1
    8000579c:	0705                	addi	a4,a4,1
    8000579e:	fe979be3          	bne	a5,s1,80005794 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800057a2:	57fd                	li	a5,-1
    800057a4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800057a6:	03205163          	blez	s2,800057c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800057aa:	f9042503          	lw	a0,-112(s0)
    800057ae:	00000097          	auipc	ra,0x0
    800057b2:	d7c080e7          	jalr	-644(ra) # 8000552a <free_desc>
      for(int j = 0; j < i; j++)
    800057b6:	4785                	li	a5,1
    800057b8:	0127d863          	bge	a5,s2,800057c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800057bc:	f9442503          	lw	a0,-108(s0)
    800057c0:	00000097          	auipc	ra,0x0
    800057c4:	d6a080e7          	jalr	-662(ra) # 8000552a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057c8:	0001b597          	auipc	a1,0x1b
    800057cc:	96058593          	addi	a1,a1,-1696 # 80020128 <disk+0x2128>
    800057d0:	0001b517          	auipc	a0,0x1b
    800057d4:	84850513          	addi	a0,a0,-1976 # 80020018 <disk+0x2018>
    800057d8:	ffffc097          	auipc	ra,0xffffc
    800057dc:	ff8080e7          	jalr	-8(ra) # 800017d0 <sleep>
  for(int i = 0; i < 3; i++){
    800057e0:	f9040613          	addi	a2,s0,-112
    800057e4:	894e                	mv	s2,s3
    800057e6:	b74d                	j	80005788 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800057e8:	0001b717          	auipc	a4,0x1b
    800057ec:	81873703          	ld	a4,-2024(a4) # 80020000 <disk+0x2000>
    800057f0:	973e                	add	a4,a4,a5
    800057f2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057f6:	00019897          	auipc	a7,0x19
    800057fa:	80a88893          	addi	a7,a7,-2038 # 8001e000 <disk>
    800057fe:	0001b717          	auipc	a4,0x1b
    80005802:	80270713          	addi	a4,a4,-2046 # 80020000 <disk+0x2000>
    80005806:	6314                	ld	a3,0(a4)
    80005808:	96be                	add	a3,a3,a5
    8000580a:	00c6d583          	lhu	a1,12(a3)
    8000580e:	0015e593          	ori	a1,a1,1
    80005812:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005816:	f9842683          	lw	a3,-104(s0)
    8000581a:	630c                	ld	a1,0(a4)
    8000581c:	97ae                	add	a5,a5,a1
    8000581e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005822:	20050593          	addi	a1,a0,512
    80005826:	0592                	slli	a1,a1,0x4
    80005828:	95c6                	add	a1,a1,a7
    8000582a:	57fd                	li	a5,-1
    8000582c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005830:	00469793          	slli	a5,a3,0x4
    80005834:	00073803          	ld	a6,0(a4)
    80005838:	983e                	add	a6,a6,a5
    8000583a:	6689                	lui	a3,0x2
    8000583c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005840:	96b2                	add	a3,a3,a2
    80005842:	96c6                	add	a3,a3,a7
    80005844:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005848:	6314                	ld	a3,0(a4)
    8000584a:	96be                	add	a3,a3,a5
    8000584c:	4605                	li	a2,1
    8000584e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005850:	6314                	ld	a3,0(a4)
    80005852:	96be                	add	a3,a3,a5
    80005854:	4809                	li	a6,2
    80005856:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000585a:	6314                	ld	a3,0(a4)
    8000585c:	97b6                	add	a5,a5,a3
    8000585e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005862:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005866:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000586a:	6714                	ld	a3,8(a4)
    8000586c:	0026d783          	lhu	a5,2(a3)
    80005870:	8b9d                	andi	a5,a5,7
    80005872:	0786                	slli	a5,a5,0x1
    80005874:	96be                	add	a3,a3,a5
    80005876:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000587a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000587e:	6718                	ld	a4,8(a4)
    80005880:	00275783          	lhu	a5,2(a4)
    80005884:	2785                	addiw	a5,a5,1
    80005886:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000588a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000588e:	100017b7          	lui	a5,0x10001
    80005892:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005896:	004a2783          	lw	a5,4(s4)
    8000589a:	02c79163          	bne	a5,a2,800058bc <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000589e:	0001b917          	auipc	s2,0x1b
    800058a2:	88a90913          	addi	s2,s2,-1910 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800058a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800058a8:	85ca                	mv	a1,s2
    800058aa:	8552                	mv	a0,s4
    800058ac:	ffffc097          	auipc	ra,0xffffc
    800058b0:	f24080e7          	jalr	-220(ra) # 800017d0 <sleep>
  while(b->disk == 1) {
    800058b4:	004a2783          	lw	a5,4(s4)
    800058b8:	fe9788e3          	beq	a5,s1,800058a8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800058bc:	f9042903          	lw	s2,-112(s0)
    800058c0:	20090713          	addi	a4,s2,512
    800058c4:	0712                	slli	a4,a4,0x4
    800058c6:	00018797          	auipc	a5,0x18
    800058ca:	73a78793          	addi	a5,a5,1850 # 8001e000 <disk>
    800058ce:	97ba                	add	a5,a5,a4
    800058d0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800058d4:	0001a997          	auipc	s3,0x1a
    800058d8:	72c98993          	addi	s3,s3,1836 # 80020000 <disk+0x2000>
    800058dc:	00491713          	slli	a4,s2,0x4
    800058e0:	0009b783          	ld	a5,0(s3)
    800058e4:	97ba                	add	a5,a5,a4
    800058e6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058ea:	854a                	mv	a0,s2
    800058ec:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058f0:	00000097          	auipc	ra,0x0
    800058f4:	c3a080e7          	jalr	-966(ra) # 8000552a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058f8:	8885                	andi	s1,s1,1
    800058fa:	f0ed                	bnez	s1,800058dc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058fc:	0001b517          	auipc	a0,0x1b
    80005900:	82c50513          	addi	a0,a0,-2004 # 80020128 <disk+0x2128>
    80005904:	00001097          	auipc	ra,0x1
    80005908:	ce6080e7          	jalr	-794(ra) # 800065ea <release>
}
    8000590c:	70a6                	ld	ra,104(sp)
    8000590e:	7406                	ld	s0,96(sp)
    80005910:	64e6                	ld	s1,88(sp)
    80005912:	6946                	ld	s2,80(sp)
    80005914:	69a6                	ld	s3,72(sp)
    80005916:	6a06                	ld	s4,64(sp)
    80005918:	7ae2                	ld	s5,56(sp)
    8000591a:	7b42                	ld	s6,48(sp)
    8000591c:	7ba2                	ld	s7,40(sp)
    8000591e:	7c02                	ld	s8,32(sp)
    80005920:	6ce2                	ld	s9,24(sp)
    80005922:	6165                	addi	sp,sp,112
    80005924:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005926:	f9042503          	lw	a0,-112(s0)
    8000592a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000592e:	00018597          	auipc	a1,0x18
    80005932:	6d258593          	addi	a1,a1,1746 # 8001e000 <disk>
    80005936:	20050793          	addi	a5,a0,512
    8000593a:	0792                	slli	a5,a5,0x4
    8000593c:	97ae                	add	a5,a5,a1
    8000593e:	01903733          	snez	a4,s9
    80005942:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005946:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000594a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000594e:	0001a717          	auipc	a4,0x1a
    80005952:	6b270713          	addi	a4,a4,1714 # 80020000 <disk+0x2000>
    80005956:	6314                	ld	a3,0(a4)
    80005958:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000595a:	6789                	lui	a5,0x2
    8000595c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005960:	97b2                	add	a5,a5,a2
    80005962:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005964:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005966:	631c                	ld	a5,0(a4)
    80005968:	97b2                	add	a5,a5,a2
    8000596a:	46c1                	li	a3,16
    8000596c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000596e:	631c                	ld	a5,0(a4)
    80005970:	97b2                	add	a5,a5,a2
    80005972:	4685                	li	a3,1
    80005974:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005978:	f9442783          	lw	a5,-108(s0)
    8000597c:	6314                	ld	a3,0(a4)
    8000597e:	96b2                	add	a3,a3,a2
    80005980:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005984:	0792                	slli	a5,a5,0x4
    80005986:	6314                	ld	a3,0(a4)
    80005988:	96be                	add	a3,a3,a5
    8000598a:	058a0593          	addi	a1,s4,88
    8000598e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005990:	6318                	ld	a4,0(a4)
    80005992:	973e                	add	a4,a4,a5
    80005994:	40000693          	li	a3,1024
    80005998:	c714                	sw	a3,8(a4)
  if(write)
    8000599a:	e40c97e3          	bnez	s9,800057e8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000599e:	0001a717          	auipc	a4,0x1a
    800059a2:	66273703          	ld	a4,1634(a4) # 80020000 <disk+0x2000>
    800059a6:	973e                	add	a4,a4,a5
    800059a8:	4689                	li	a3,2
    800059aa:	00d71623          	sh	a3,12(a4)
    800059ae:	b5a1                	j	800057f6 <virtio_disk_rw+0xd4>

00000000800059b0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059b0:	1101                	addi	sp,sp,-32
    800059b2:	ec06                	sd	ra,24(sp)
    800059b4:	e822                	sd	s0,16(sp)
    800059b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059b8:	0001a517          	auipc	a0,0x1a
    800059bc:	77050513          	addi	a0,a0,1904 # 80020128 <disk+0x2128>
    800059c0:	00001097          	auipc	ra,0x1
    800059c4:	b76080e7          	jalr	-1162(ra) # 80006536 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059c8:	100017b7          	lui	a5,0x10001
    800059cc:	53b8                	lw	a4,96(a5)
    800059ce:	8b0d                	andi	a4,a4,3
    800059d0:	100017b7          	lui	a5,0x10001
    800059d4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800059d6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059da:	0001a797          	auipc	a5,0x1a
    800059de:	62678793          	addi	a5,a5,1574 # 80020000 <disk+0x2000>
    800059e2:	6b94                	ld	a3,16(a5)
    800059e4:	0207d703          	lhu	a4,32(a5)
    800059e8:	0026d783          	lhu	a5,2(a3)
    800059ec:	06f70563          	beq	a4,a5,80005a56 <virtio_disk_intr+0xa6>
    800059f0:	e426                	sd	s1,8(sp)
    800059f2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059f4:	00018917          	auipc	s2,0x18
    800059f8:	60c90913          	addi	s2,s2,1548 # 8001e000 <disk>
    800059fc:	0001a497          	auipc	s1,0x1a
    80005a00:	60448493          	addi	s1,s1,1540 # 80020000 <disk+0x2000>
    __sync_synchronize();
    80005a04:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a08:	6898                	ld	a4,16(s1)
    80005a0a:	0204d783          	lhu	a5,32(s1)
    80005a0e:	8b9d                	andi	a5,a5,7
    80005a10:	078e                	slli	a5,a5,0x3
    80005a12:	97ba                	add	a5,a5,a4
    80005a14:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a16:	20078713          	addi	a4,a5,512
    80005a1a:	0712                	slli	a4,a4,0x4
    80005a1c:	974a                	add	a4,a4,s2
    80005a1e:	03074703          	lbu	a4,48(a4)
    80005a22:	e731                	bnez	a4,80005a6e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a24:	20078793          	addi	a5,a5,512
    80005a28:	0792                	slli	a5,a5,0x4
    80005a2a:	97ca                	add	a5,a5,s2
    80005a2c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005a2e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a32:	ffffc097          	auipc	ra,0xffffc
    80005a36:	f2a080e7          	jalr	-214(ra) # 8000195c <wakeup>

    disk.used_idx += 1;
    80005a3a:	0204d783          	lhu	a5,32(s1)
    80005a3e:	2785                	addiw	a5,a5,1
    80005a40:	17c2                	slli	a5,a5,0x30
    80005a42:	93c1                	srli	a5,a5,0x30
    80005a44:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a48:	6898                	ld	a4,16(s1)
    80005a4a:	00275703          	lhu	a4,2(a4)
    80005a4e:	faf71be3          	bne	a4,a5,80005a04 <virtio_disk_intr+0x54>
    80005a52:	64a2                	ld	s1,8(sp)
    80005a54:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005a56:	0001a517          	auipc	a0,0x1a
    80005a5a:	6d250513          	addi	a0,a0,1746 # 80020128 <disk+0x2128>
    80005a5e:	00001097          	auipc	ra,0x1
    80005a62:	b8c080e7          	jalr	-1140(ra) # 800065ea <release>
}
    80005a66:	60e2                	ld	ra,24(sp)
    80005a68:	6442                	ld	s0,16(sp)
    80005a6a:	6105                	addi	sp,sp,32
    80005a6c:	8082                	ret
      panic("virtio_disk_intr status");
    80005a6e:	00003517          	auipc	a0,0x3
    80005a72:	c0a50513          	addi	a0,a0,-1014 # 80008678 <etext+0x678>
    80005a76:	00000097          	auipc	ra,0x0
    80005a7a:	546080e7          	jalr	1350(ra) # 80005fbc <panic>

0000000080005a7e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a7e:	1141                	addi	sp,sp,-16
    80005a80:	e422                	sd	s0,8(sp)
    80005a82:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a84:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a88:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a8c:	0037979b          	slliw	a5,a5,0x3
    80005a90:	02004737          	lui	a4,0x2004
    80005a94:	97ba                	add	a5,a5,a4
    80005a96:	0200c737          	lui	a4,0x200c
    80005a9a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005a9c:	6318                	ld	a4,0(a4)
    80005a9e:	000f4637          	lui	a2,0xf4
    80005aa2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005aa6:	9732                	add	a4,a4,a2
    80005aa8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005aaa:	00259693          	slli	a3,a1,0x2
    80005aae:	96ae                	add	a3,a3,a1
    80005ab0:	068e                	slli	a3,a3,0x3
    80005ab2:	0001b717          	auipc	a4,0x1b
    80005ab6:	54e70713          	addi	a4,a4,1358 # 80021000 <timer_scratch>
    80005aba:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005abc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005abe:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005ac0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005ac4:	00000797          	auipc	a5,0x0
    80005ac8:	99c78793          	addi	a5,a5,-1636 # 80005460 <timervec>
    80005acc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ad0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005ad4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ad8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005adc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005ae0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ae4:	30479073          	csrw	mie,a5
}
    80005ae8:	6422                	ld	s0,8(sp)
    80005aea:	0141                	addi	sp,sp,16
    80005aec:	8082                	ret

0000000080005aee <start>:
{
    80005aee:	1141                	addi	sp,sp,-16
    80005af0:	e406                	sd	ra,8(sp)
    80005af2:	e022                	sd	s0,0(sp)
    80005af4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005af6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005afa:	7779                	lui	a4,0xffffe
    80005afc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd55bf>
    80005b00:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b02:	6705                	lui	a4,0x1
    80005b04:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b08:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b0a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b0e:	ffffb797          	auipc	a5,0xffffb
    80005b12:	97278793          	addi	a5,a5,-1678 # 80000480 <main>
    80005b16:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b1a:	4781                	li	a5,0
    80005b1c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b20:	67c1                	lui	a5,0x10
    80005b22:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005b24:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b28:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b2c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b30:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b34:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b38:	57fd                	li	a5,-1
    80005b3a:	83a9                	srli	a5,a5,0xa
    80005b3c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b40:	47bd                	li	a5,15
    80005b42:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b46:	00000097          	auipc	ra,0x0
    80005b4a:	f38080e7          	jalr	-200(ra) # 80005a7e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b4e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b52:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b54:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b56:	30200073          	mret
}
    80005b5a:	60a2                	ld	ra,8(sp)
    80005b5c:	6402                	ld	s0,0(sp)
    80005b5e:	0141                	addi	sp,sp,16
    80005b60:	8082                	ret

0000000080005b62 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b62:	715d                	addi	sp,sp,-80
    80005b64:	e486                	sd	ra,72(sp)
    80005b66:	e0a2                	sd	s0,64(sp)
    80005b68:	f84a                	sd	s2,48(sp)
    80005b6a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b6c:	04c05663          	blez	a2,80005bb8 <consolewrite+0x56>
    80005b70:	fc26                	sd	s1,56(sp)
    80005b72:	f44e                	sd	s3,40(sp)
    80005b74:	f052                	sd	s4,32(sp)
    80005b76:	ec56                	sd	s5,24(sp)
    80005b78:	8a2a                	mv	s4,a0
    80005b7a:	84ae                	mv	s1,a1
    80005b7c:	89b2                	mv	s3,a2
    80005b7e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b80:	5afd                	li	s5,-1
    80005b82:	4685                	li	a3,1
    80005b84:	8626                	mv	a2,s1
    80005b86:	85d2                	mv	a1,s4
    80005b88:	fbf40513          	addi	a0,s0,-65
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	03e080e7          	jalr	62(ra) # 80001bca <either_copyin>
    80005b94:	03550463          	beq	a0,s5,80005bbc <consolewrite+0x5a>
      break;
    uartputc(c);
    80005b98:	fbf44503          	lbu	a0,-65(s0)
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	7de080e7          	jalr	2014(ra) # 8000637a <uartputc>
  for(i = 0; i < n; i++){
    80005ba4:	2905                	addiw	s2,s2,1
    80005ba6:	0485                	addi	s1,s1,1
    80005ba8:	fd299de3          	bne	s3,s2,80005b82 <consolewrite+0x20>
    80005bac:	894e                	mv	s2,s3
    80005bae:	74e2                	ld	s1,56(sp)
    80005bb0:	79a2                	ld	s3,40(sp)
    80005bb2:	7a02                	ld	s4,32(sp)
    80005bb4:	6ae2                	ld	s5,24(sp)
    80005bb6:	a039                	j	80005bc4 <consolewrite+0x62>
    80005bb8:	4901                	li	s2,0
    80005bba:	a029                	j	80005bc4 <consolewrite+0x62>
    80005bbc:	74e2                	ld	s1,56(sp)
    80005bbe:	79a2                	ld	s3,40(sp)
    80005bc0:	7a02                	ld	s4,32(sp)
    80005bc2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005bc4:	854a                	mv	a0,s2
    80005bc6:	60a6                	ld	ra,72(sp)
    80005bc8:	6406                	ld	s0,64(sp)
    80005bca:	7942                	ld	s2,48(sp)
    80005bcc:	6161                	addi	sp,sp,80
    80005bce:	8082                	ret

0000000080005bd0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005bd0:	711d                	addi	sp,sp,-96
    80005bd2:	ec86                	sd	ra,88(sp)
    80005bd4:	e8a2                	sd	s0,80(sp)
    80005bd6:	e4a6                	sd	s1,72(sp)
    80005bd8:	e0ca                	sd	s2,64(sp)
    80005bda:	fc4e                	sd	s3,56(sp)
    80005bdc:	f852                	sd	s4,48(sp)
    80005bde:	f456                	sd	s5,40(sp)
    80005be0:	f05a                	sd	s6,32(sp)
    80005be2:	1080                	addi	s0,sp,96
    80005be4:	8aaa                	mv	s5,a0
    80005be6:	8a2e                	mv	s4,a1
    80005be8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005bea:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005bee:	00023517          	auipc	a0,0x23
    80005bf2:	55250513          	addi	a0,a0,1362 # 80029140 <cons>
    80005bf6:	00001097          	auipc	ra,0x1
    80005bfa:	940080e7          	jalr	-1728(ra) # 80006536 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005bfe:	00023497          	auipc	s1,0x23
    80005c02:	54248493          	addi	s1,s1,1346 # 80029140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c06:	00023917          	auipc	s2,0x23
    80005c0a:	5d290913          	addi	s2,s2,1490 # 800291d8 <cons+0x98>
  while(n > 0){
    80005c0e:	0d305463          	blez	s3,80005cd6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005c12:	0984a783          	lw	a5,152(s1)
    80005c16:	09c4a703          	lw	a4,156(s1)
    80005c1a:	0af71963          	bne	a4,a5,80005ccc <consoleread+0xfc>
      if(myproc()->killed){
    80005c1e:	ffffb097          	auipc	ra,0xffffb
    80005c22:	4ec080e7          	jalr	1260(ra) # 8000110a <myproc>
    80005c26:	551c                	lw	a5,40(a0)
    80005c28:	e7ad                	bnez	a5,80005c92 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005c2a:	85a6                	mv	a1,s1
    80005c2c:	854a                	mv	a0,s2
    80005c2e:	ffffc097          	auipc	ra,0xffffc
    80005c32:	ba2080e7          	jalr	-1118(ra) # 800017d0 <sleep>
    while(cons.r == cons.w){
    80005c36:	0984a783          	lw	a5,152(s1)
    80005c3a:	09c4a703          	lw	a4,156(s1)
    80005c3e:	fef700e3          	beq	a4,a5,80005c1e <consoleread+0x4e>
    80005c42:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005c44:	00023717          	auipc	a4,0x23
    80005c48:	4fc70713          	addi	a4,a4,1276 # 80029140 <cons>
    80005c4c:	0017869b          	addiw	a3,a5,1
    80005c50:	08d72c23          	sw	a3,152(a4)
    80005c54:	07f7f693          	andi	a3,a5,127
    80005c58:	9736                	add	a4,a4,a3
    80005c5a:	01874703          	lbu	a4,24(a4)
    80005c5e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005c62:	4691                	li	a3,4
    80005c64:	04db8a63          	beq	s7,a3,80005cb8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005c68:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c6c:	4685                	li	a3,1
    80005c6e:	faf40613          	addi	a2,s0,-81
    80005c72:	85d2                	mv	a1,s4
    80005c74:	8556                	mv	a0,s5
    80005c76:	ffffc097          	auipc	ra,0xffffc
    80005c7a:	efe080e7          	jalr	-258(ra) # 80001b74 <either_copyout>
    80005c7e:	57fd                	li	a5,-1
    80005c80:	04f50a63          	beq	a0,a5,80005cd4 <consoleread+0x104>
      break;

    dst++;
    80005c84:	0a05                	addi	s4,s4,1
    --n;
    80005c86:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005c88:	47a9                	li	a5,10
    80005c8a:	06fb8163          	beq	s7,a5,80005cec <consoleread+0x11c>
    80005c8e:	6be2                	ld	s7,24(sp)
    80005c90:	bfbd                	j	80005c0e <consoleread+0x3e>
        release(&cons.lock);
    80005c92:	00023517          	auipc	a0,0x23
    80005c96:	4ae50513          	addi	a0,a0,1198 # 80029140 <cons>
    80005c9a:	00001097          	auipc	ra,0x1
    80005c9e:	950080e7          	jalr	-1712(ra) # 800065ea <release>
        return -1;
    80005ca2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005ca4:	60e6                	ld	ra,88(sp)
    80005ca6:	6446                	ld	s0,80(sp)
    80005ca8:	64a6                	ld	s1,72(sp)
    80005caa:	6906                	ld	s2,64(sp)
    80005cac:	79e2                	ld	s3,56(sp)
    80005cae:	7a42                	ld	s4,48(sp)
    80005cb0:	7aa2                	ld	s5,40(sp)
    80005cb2:	7b02                	ld	s6,32(sp)
    80005cb4:	6125                	addi	sp,sp,96
    80005cb6:	8082                	ret
      if(n < target){
    80005cb8:	0009871b          	sext.w	a4,s3
    80005cbc:	01677a63          	bgeu	a4,s6,80005cd0 <consoleread+0x100>
        cons.r--;
    80005cc0:	00023717          	auipc	a4,0x23
    80005cc4:	50f72c23          	sw	a5,1304(a4) # 800291d8 <cons+0x98>
    80005cc8:	6be2                	ld	s7,24(sp)
    80005cca:	a031                	j	80005cd6 <consoleread+0x106>
    80005ccc:	ec5e                	sd	s7,24(sp)
    80005cce:	bf9d                	j	80005c44 <consoleread+0x74>
    80005cd0:	6be2                	ld	s7,24(sp)
    80005cd2:	a011                	j	80005cd6 <consoleread+0x106>
    80005cd4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005cd6:	00023517          	auipc	a0,0x23
    80005cda:	46a50513          	addi	a0,a0,1130 # 80029140 <cons>
    80005cde:	00001097          	auipc	ra,0x1
    80005ce2:	90c080e7          	jalr	-1780(ra) # 800065ea <release>
  return target - n;
    80005ce6:	413b053b          	subw	a0,s6,s3
    80005cea:	bf6d                	j	80005ca4 <consoleread+0xd4>
    80005cec:	6be2                	ld	s7,24(sp)
    80005cee:	b7e5                	j	80005cd6 <consoleread+0x106>

0000000080005cf0 <consputc>:
{
    80005cf0:	1141                	addi	sp,sp,-16
    80005cf2:	e406                	sd	ra,8(sp)
    80005cf4:	e022                	sd	s0,0(sp)
    80005cf6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005cf8:	10000793          	li	a5,256
    80005cfc:	00f50a63          	beq	a0,a5,80005d10 <consputc+0x20>
    uartputc_sync(c);
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	59c080e7          	jalr	1436(ra) # 8000629c <uartputc_sync>
}
    80005d08:	60a2                	ld	ra,8(sp)
    80005d0a:	6402                	ld	s0,0(sp)
    80005d0c:	0141                	addi	sp,sp,16
    80005d0e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d10:	4521                	li	a0,8
    80005d12:	00000097          	auipc	ra,0x0
    80005d16:	58a080e7          	jalr	1418(ra) # 8000629c <uartputc_sync>
    80005d1a:	02000513          	li	a0,32
    80005d1e:	00000097          	auipc	ra,0x0
    80005d22:	57e080e7          	jalr	1406(ra) # 8000629c <uartputc_sync>
    80005d26:	4521                	li	a0,8
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	574080e7          	jalr	1396(ra) # 8000629c <uartputc_sync>
    80005d30:	bfe1                	j	80005d08 <consputc+0x18>

0000000080005d32 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d32:	1101                	addi	sp,sp,-32
    80005d34:	ec06                	sd	ra,24(sp)
    80005d36:	e822                	sd	s0,16(sp)
    80005d38:	e426                	sd	s1,8(sp)
    80005d3a:	1000                	addi	s0,sp,32
    80005d3c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d3e:	00023517          	auipc	a0,0x23
    80005d42:	40250513          	addi	a0,a0,1026 # 80029140 <cons>
    80005d46:	00000097          	auipc	ra,0x0
    80005d4a:	7f0080e7          	jalr	2032(ra) # 80006536 <acquire>

  switch(c){
    80005d4e:	47d5                	li	a5,21
    80005d50:	0af48563          	beq	s1,a5,80005dfa <consoleintr+0xc8>
    80005d54:	0297c963          	blt	a5,s1,80005d86 <consoleintr+0x54>
    80005d58:	47a1                	li	a5,8
    80005d5a:	0ef48c63          	beq	s1,a5,80005e52 <consoleintr+0x120>
    80005d5e:	47c1                	li	a5,16
    80005d60:	10f49f63          	bne	s1,a5,80005e7e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005d64:	ffffc097          	auipc	ra,0xffffc
    80005d68:	ebc080e7          	jalr	-324(ra) # 80001c20 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d6c:	00023517          	auipc	a0,0x23
    80005d70:	3d450513          	addi	a0,a0,980 # 80029140 <cons>
    80005d74:	00001097          	auipc	ra,0x1
    80005d78:	876080e7          	jalr	-1930(ra) # 800065ea <release>
}
    80005d7c:	60e2                	ld	ra,24(sp)
    80005d7e:	6442                	ld	s0,16(sp)
    80005d80:	64a2                	ld	s1,8(sp)
    80005d82:	6105                	addi	sp,sp,32
    80005d84:	8082                	ret
  switch(c){
    80005d86:	07f00793          	li	a5,127
    80005d8a:	0cf48463          	beq	s1,a5,80005e52 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d8e:	00023717          	auipc	a4,0x23
    80005d92:	3b270713          	addi	a4,a4,946 # 80029140 <cons>
    80005d96:	0a072783          	lw	a5,160(a4)
    80005d9a:	09872703          	lw	a4,152(a4)
    80005d9e:	9f99                	subw	a5,a5,a4
    80005da0:	07f00713          	li	a4,127
    80005da4:	fcf764e3          	bltu	a4,a5,80005d6c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005da8:	47b5                	li	a5,13
    80005daa:	0cf48d63          	beq	s1,a5,80005e84 <consoleintr+0x152>
      consputc(c);
    80005dae:	8526                	mv	a0,s1
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	f40080e7          	jalr	-192(ra) # 80005cf0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005db8:	00023797          	auipc	a5,0x23
    80005dbc:	38878793          	addi	a5,a5,904 # 80029140 <cons>
    80005dc0:	0a07a703          	lw	a4,160(a5)
    80005dc4:	0017069b          	addiw	a3,a4,1
    80005dc8:	0006861b          	sext.w	a2,a3
    80005dcc:	0ad7a023          	sw	a3,160(a5)
    80005dd0:	07f77713          	andi	a4,a4,127
    80005dd4:	97ba                	add	a5,a5,a4
    80005dd6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005dda:	47a9                	li	a5,10
    80005ddc:	0cf48b63          	beq	s1,a5,80005eb2 <consoleintr+0x180>
    80005de0:	4791                	li	a5,4
    80005de2:	0cf48863          	beq	s1,a5,80005eb2 <consoleintr+0x180>
    80005de6:	00023797          	auipc	a5,0x23
    80005dea:	3f27a783          	lw	a5,1010(a5) # 800291d8 <cons+0x98>
    80005dee:	0807879b          	addiw	a5,a5,128
    80005df2:	f6f61de3          	bne	a2,a5,80005d6c <consoleintr+0x3a>
    80005df6:	863e                	mv	a2,a5
    80005df8:	a86d                	j	80005eb2 <consoleintr+0x180>
    80005dfa:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005dfc:	00023717          	auipc	a4,0x23
    80005e00:	34470713          	addi	a4,a4,836 # 80029140 <cons>
    80005e04:	0a072783          	lw	a5,160(a4)
    80005e08:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e0c:	00023497          	auipc	s1,0x23
    80005e10:	33448493          	addi	s1,s1,820 # 80029140 <cons>
    while(cons.e != cons.w &&
    80005e14:	4929                	li	s2,10
    80005e16:	02f70a63          	beq	a4,a5,80005e4a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e1a:	37fd                	addiw	a5,a5,-1
    80005e1c:	07f7f713          	andi	a4,a5,127
    80005e20:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e22:	01874703          	lbu	a4,24(a4)
    80005e26:	03270463          	beq	a4,s2,80005e4e <consoleintr+0x11c>
      cons.e--;
    80005e2a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e2e:	10000513          	li	a0,256
    80005e32:	00000097          	auipc	ra,0x0
    80005e36:	ebe080e7          	jalr	-322(ra) # 80005cf0 <consputc>
    while(cons.e != cons.w &&
    80005e3a:	0a04a783          	lw	a5,160(s1)
    80005e3e:	09c4a703          	lw	a4,156(s1)
    80005e42:	fcf71ce3          	bne	a4,a5,80005e1a <consoleintr+0xe8>
    80005e46:	6902                	ld	s2,0(sp)
    80005e48:	b715                	j	80005d6c <consoleintr+0x3a>
    80005e4a:	6902                	ld	s2,0(sp)
    80005e4c:	b705                	j	80005d6c <consoleintr+0x3a>
    80005e4e:	6902                	ld	s2,0(sp)
    80005e50:	bf31                	j	80005d6c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005e52:	00023717          	auipc	a4,0x23
    80005e56:	2ee70713          	addi	a4,a4,750 # 80029140 <cons>
    80005e5a:	0a072783          	lw	a5,160(a4)
    80005e5e:	09c72703          	lw	a4,156(a4)
    80005e62:	f0f705e3          	beq	a4,a5,80005d6c <consoleintr+0x3a>
      cons.e--;
    80005e66:	37fd                	addiw	a5,a5,-1
    80005e68:	00023717          	auipc	a4,0x23
    80005e6c:	36f72c23          	sw	a5,888(a4) # 800291e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e70:	10000513          	li	a0,256
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	e7c080e7          	jalr	-388(ra) # 80005cf0 <consputc>
    80005e7c:	bdc5                	j	80005d6c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e7e:	ee0487e3          	beqz	s1,80005d6c <consoleintr+0x3a>
    80005e82:	b731                	j	80005d8e <consoleintr+0x5c>
      consputc(c);
    80005e84:	4529                	li	a0,10
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	e6a080e7          	jalr	-406(ra) # 80005cf0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e8e:	00023797          	auipc	a5,0x23
    80005e92:	2b278793          	addi	a5,a5,690 # 80029140 <cons>
    80005e96:	0a07a703          	lw	a4,160(a5)
    80005e9a:	0017069b          	addiw	a3,a4,1
    80005e9e:	0006861b          	sext.w	a2,a3
    80005ea2:	0ad7a023          	sw	a3,160(a5)
    80005ea6:	07f77713          	andi	a4,a4,127
    80005eaa:	97ba                	add	a5,a5,a4
    80005eac:	4729                	li	a4,10
    80005eae:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005eb2:	00023797          	auipc	a5,0x23
    80005eb6:	32c7a523          	sw	a2,810(a5) # 800291dc <cons+0x9c>
        wakeup(&cons.r);
    80005eba:	00023517          	auipc	a0,0x23
    80005ebe:	31e50513          	addi	a0,a0,798 # 800291d8 <cons+0x98>
    80005ec2:	ffffc097          	auipc	ra,0xffffc
    80005ec6:	a9a080e7          	jalr	-1382(ra) # 8000195c <wakeup>
    80005eca:	b54d                	j	80005d6c <consoleintr+0x3a>

0000000080005ecc <consoleinit>:

void
consoleinit(void)
{
    80005ecc:	1141                	addi	sp,sp,-16
    80005ece:	e406                	sd	ra,8(sp)
    80005ed0:	e022                	sd	s0,0(sp)
    80005ed2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ed4:	00002597          	auipc	a1,0x2
    80005ed8:	7bc58593          	addi	a1,a1,1980 # 80008690 <etext+0x690>
    80005edc:	00023517          	auipc	a0,0x23
    80005ee0:	26450513          	addi	a0,a0,612 # 80029140 <cons>
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	5c2080e7          	jalr	1474(ra) # 800064a6 <initlock>

  uartinit();
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	354080e7          	jalr	852(ra) # 80006240 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ef4:	00016797          	auipc	a5,0x16
    80005ef8:	1f478793          	addi	a5,a5,500 # 8001c0e8 <devsw>
    80005efc:	00000717          	auipc	a4,0x0
    80005f00:	cd470713          	addi	a4,a4,-812 # 80005bd0 <consoleread>
    80005f04:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f06:	00000717          	auipc	a4,0x0
    80005f0a:	c5c70713          	addi	a4,a4,-932 # 80005b62 <consolewrite>
    80005f0e:	ef98                	sd	a4,24(a5)
}
    80005f10:	60a2                	ld	ra,8(sp)
    80005f12:	6402                	ld	s0,0(sp)
    80005f14:	0141                	addi	sp,sp,16
    80005f16:	8082                	ret

0000000080005f18 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f18:	7179                	addi	sp,sp,-48
    80005f1a:	f406                	sd	ra,40(sp)
    80005f1c:	f022                	sd	s0,32(sp)
    80005f1e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f20:	c219                	beqz	a2,80005f26 <printint+0xe>
    80005f22:	08054963          	bltz	a0,80005fb4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005f26:	2501                	sext.w	a0,a0
    80005f28:	4881                	li	a7,0
    80005f2a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f2e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f30:	2581                	sext.w	a1,a1
    80005f32:	00003617          	auipc	a2,0x3
    80005f36:	8be60613          	addi	a2,a2,-1858 # 800087f0 <digits>
    80005f3a:	883a                	mv	a6,a4
    80005f3c:	2705                	addiw	a4,a4,1
    80005f3e:	02b577bb          	remuw	a5,a0,a1
    80005f42:	1782                	slli	a5,a5,0x20
    80005f44:	9381                	srli	a5,a5,0x20
    80005f46:	97b2                	add	a5,a5,a2
    80005f48:	0007c783          	lbu	a5,0(a5)
    80005f4c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f50:	0005079b          	sext.w	a5,a0
    80005f54:	02b5553b          	divuw	a0,a0,a1
    80005f58:	0685                	addi	a3,a3,1
    80005f5a:	feb7f0e3          	bgeu	a5,a1,80005f3a <printint+0x22>

  if(sign)
    80005f5e:	00088c63          	beqz	a7,80005f76 <printint+0x5e>
    buf[i++] = '-';
    80005f62:	fe070793          	addi	a5,a4,-32
    80005f66:	00878733          	add	a4,a5,s0
    80005f6a:	02d00793          	li	a5,45
    80005f6e:	fef70823          	sb	a5,-16(a4)
    80005f72:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f76:	02e05b63          	blez	a4,80005fac <printint+0x94>
    80005f7a:	ec26                	sd	s1,24(sp)
    80005f7c:	e84a                	sd	s2,16(sp)
    80005f7e:	fd040793          	addi	a5,s0,-48
    80005f82:	00e784b3          	add	s1,a5,a4
    80005f86:	fff78913          	addi	s2,a5,-1
    80005f8a:	993a                	add	s2,s2,a4
    80005f8c:	377d                	addiw	a4,a4,-1
    80005f8e:	1702                	slli	a4,a4,0x20
    80005f90:	9301                	srli	a4,a4,0x20
    80005f92:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f96:	fff4c503          	lbu	a0,-1(s1)
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	d56080e7          	jalr	-682(ra) # 80005cf0 <consputc>
  while(--i >= 0)
    80005fa2:	14fd                	addi	s1,s1,-1
    80005fa4:	ff2499e3          	bne	s1,s2,80005f96 <printint+0x7e>
    80005fa8:	64e2                	ld	s1,24(sp)
    80005faa:	6942                	ld	s2,16(sp)
}
    80005fac:	70a2                	ld	ra,40(sp)
    80005fae:	7402                	ld	s0,32(sp)
    80005fb0:	6145                	addi	sp,sp,48
    80005fb2:	8082                	ret
    x = -xx;
    80005fb4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fb8:	4885                	li	a7,1
    x = -xx;
    80005fba:	bf85                	j	80005f2a <printint+0x12>

0000000080005fbc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fbc:	1101                	addi	sp,sp,-32
    80005fbe:	ec06                	sd	ra,24(sp)
    80005fc0:	e822                	sd	s0,16(sp)
    80005fc2:	e426                	sd	s1,8(sp)
    80005fc4:	1000                	addi	s0,sp,32
    80005fc6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005fc8:	00023797          	auipc	a5,0x23
    80005fcc:	2207ac23          	sw	zero,568(a5) # 80029200 <pr+0x18>
  printf("panic: ");
    80005fd0:	00002517          	auipc	a0,0x2
    80005fd4:	6c850513          	addi	a0,a0,1736 # 80008698 <etext+0x698>
    80005fd8:	00000097          	auipc	ra,0x0
    80005fdc:	02e080e7          	jalr	46(ra) # 80006006 <printf>
  printf(s);
    80005fe0:	8526                	mv	a0,s1
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	024080e7          	jalr	36(ra) # 80006006 <printf>
  printf("\n");
    80005fea:	00002517          	auipc	a0,0x2
    80005fee:	03650513          	addi	a0,a0,54 # 80008020 <etext+0x20>
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	014080e7          	jalr	20(ra) # 80006006 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ffa:	4785                	li	a5,1
    80005ffc:	00006717          	auipc	a4,0x6
    80006000:	02f72023          	sw	a5,32(a4) # 8000c01c <panicked>
  for(;;)
    80006004:	a001                	j	80006004 <panic+0x48>

0000000080006006 <printf>:
{
    80006006:	7131                	addi	sp,sp,-192
    80006008:	fc86                	sd	ra,120(sp)
    8000600a:	f8a2                	sd	s0,112(sp)
    8000600c:	e8d2                	sd	s4,80(sp)
    8000600e:	f06a                	sd	s10,32(sp)
    80006010:	0100                	addi	s0,sp,128
    80006012:	8a2a                	mv	s4,a0
    80006014:	e40c                	sd	a1,8(s0)
    80006016:	e810                	sd	a2,16(s0)
    80006018:	ec14                	sd	a3,24(s0)
    8000601a:	f018                	sd	a4,32(s0)
    8000601c:	f41c                	sd	a5,40(s0)
    8000601e:	03043823          	sd	a6,48(s0)
    80006022:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006026:	00023d17          	auipc	s10,0x23
    8000602a:	1dad2d03          	lw	s10,474(s10) # 80029200 <pr+0x18>
  if(locking)
    8000602e:	040d1463          	bnez	s10,80006076 <printf+0x70>
  if (fmt == 0)
    80006032:	040a0b63          	beqz	s4,80006088 <printf+0x82>
  va_start(ap, fmt);
    80006036:	00840793          	addi	a5,s0,8
    8000603a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000603e:	000a4503          	lbu	a0,0(s4)
    80006042:	18050b63          	beqz	a0,800061d8 <printf+0x1d2>
    80006046:	f4a6                	sd	s1,104(sp)
    80006048:	f0ca                	sd	s2,96(sp)
    8000604a:	ecce                	sd	s3,88(sp)
    8000604c:	e4d6                	sd	s5,72(sp)
    8000604e:	e0da                	sd	s6,64(sp)
    80006050:	fc5e                	sd	s7,56(sp)
    80006052:	f862                	sd	s8,48(sp)
    80006054:	f466                	sd	s9,40(sp)
    80006056:	ec6e                	sd	s11,24(sp)
    80006058:	4981                	li	s3,0
    if(c != '%'){
    8000605a:	02500b13          	li	s6,37
    switch(c){
    8000605e:	07000b93          	li	s7,112
  consputc('x');
    80006062:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006064:	00002a97          	auipc	s5,0x2
    80006068:	78ca8a93          	addi	s5,s5,1932 # 800087f0 <digits>
    switch(c){
    8000606c:	07300c13          	li	s8,115
    80006070:	06400d93          	li	s11,100
    80006074:	a0b1                	j	800060c0 <printf+0xba>
    acquire(&pr.lock);
    80006076:	00023517          	auipc	a0,0x23
    8000607a:	17250513          	addi	a0,a0,370 # 800291e8 <pr>
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	4b8080e7          	jalr	1208(ra) # 80006536 <acquire>
    80006086:	b775                	j	80006032 <printf+0x2c>
    80006088:	f4a6                	sd	s1,104(sp)
    8000608a:	f0ca                	sd	s2,96(sp)
    8000608c:	ecce                	sd	s3,88(sp)
    8000608e:	e4d6                	sd	s5,72(sp)
    80006090:	e0da                	sd	s6,64(sp)
    80006092:	fc5e                	sd	s7,56(sp)
    80006094:	f862                	sd	s8,48(sp)
    80006096:	f466                	sd	s9,40(sp)
    80006098:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000609a:	00002517          	auipc	a0,0x2
    8000609e:	60e50513          	addi	a0,a0,1550 # 800086a8 <etext+0x6a8>
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	f1a080e7          	jalr	-230(ra) # 80005fbc <panic>
      consputc(c);
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	c46080e7          	jalr	-954(ra) # 80005cf0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060b2:	2985                	addiw	s3,s3,1
    800060b4:	013a07b3          	add	a5,s4,s3
    800060b8:	0007c503          	lbu	a0,0(a5)
    800060bc:	10050563          	beqz	a0,800061c6 <printf+0x1c0>
    if(c != '%'){
    800060c0:	ff6515e3          	bne	a0,s6,800060aa <printf+0xa4>
    c = fmt[++i] & 0xff;
    800060c4:	2985                	addiw	s3,s3,1
    800060c6:	013a07b3          	add	a5,s4,s3
    800060ca:	0007c783          	lbu	a5,0(a5)
    800060ce:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800060d2:	10078b63          	beqz	a5,800061e8 <printf+0x1e2>
    switch(c){
    800060d6:	05778a63          	beq	a5,s7,8000612a <printf+0x124>
    800060da:	02fbf663          	bgeu	s7,a5,80006106 <printf+0x100>
    800060de:	09878863          	beq	a5,s8,8000616e <printf+0x168>
    800060e2:	07800713          	li	a4,120
    800060e6:	0ce79563          	bne	a5,a4,800061b0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    800060ea:	f8843783          	ld	a5,-120(s0)
    800060ee:	00878713          	addi	a4,a5,8
    800060f2:	f8e43423          	sd	a4,-120(s0)
    800060f6:	4605                	li	a2,1
    800060f8:	85e6                	mv	a1,s9
    800060fa:	4388                	lw	a0,0(a5)
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	e1c080e7          	jalr	-484(ra) # 80005f18 <printint>
      break;
    80006104:	b77d                	j	800060b2 <printf+0xac>
    switch(c){
    80006106:	09678f63          	beq	a5,s6,800061a4 <printf+0x19e>
    8000610a:	0bb79363          	bne	a5,s11,800061b0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000610e:	f8843783          	ld	a5,-120(s0)
    80006112:	00878713          	addi	a4,a5,8
    80006116:	f8e43423          	sd	a4,-120(s0)
    8000611a:	4605                	li	a2,1
    8000611c:	45a9                	li	a1,10
    8000611e:	4388                	lw	a0,0(a5)
    80006120:	00000097          	auipc	ra,0x0
    80006124:	df8080e7          	jalr	-520(ra) # 80005f18 <printint>
      break;
    80006128:	b769                	j	800060b2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000612a:	f8843783          	ld	a5,-120(s0)
    8000612e:	00878713          	addi	a4,a5,8
    80006132:	f8e43423          	sd	a4,-120(s0)
    80006136:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000613a:	03000513          	li	a0,48
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	bb2080e7          	jalr	-1102(ra) # 80005cf0 <consputc>
  consputc('x');
    80006146:	07800513          	li	a0,120
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	ba6080e7          	jalr	-1114(ra) # 80005cf0 <consputc>
    80006152:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006154:	03c95793          	srli	a5,s2,0x3c
    80006158:	97d6                	add	a5,a5,s5
    8000615a:	0007c503          	lbu	a0,0(a5)
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	b92080e7          	jalr	-1134(ra) # 80005cf0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006166:	0912                	slli	s2,s2,0x4
    80006168:	34fd                	addiw	s1,s1,-1
    8000616a:	f4ed                	bnez	s1,80006154 <printf+0x14e>
    8000616c:	b799                	j	800060b2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000616e:	f8843783          	ld	a5,-120(s0)
    80006172:	00878713          	addi	a4,a5,8
    80006176:	f8e43423          	sd	a4,-120(s0)
    8000617a:	6384                	ld	s1,0(a5)
    8000617c:	cc89                	beqz	s1,80006196 <printf+0x190>
      for(; *s; s++)
    8000617e:	0004c503          	lbu	a0,0(s1)
    80006182:	d905                	beqz	a0,800060b2 <printf+0xac>
        consputc(*s);
    80006184:	00000097          	auipc	ra,0x0
    80006188:	b6c080e7          	jalr	-1172(ra) # 80005cf0 <consputc>
      for(; *s; s++)
    8000618c:	0485                	addi	s1,s1,1
    8000618e:	0004c503          	lbu	a0,0(s1)
    80006192:	f96d                	bnez	a0,80006184 <printf+0x17e>
    80006194:	bf39                	j	800060b2 <printf+0xac>
        s = "(null)";
    80006196:	00002497          	auipc	s1,0x2
    8000619a:	50a48493          	addi	s1,s1,1290 # 800086a0 <etext+0x6a0>
      for(; *s; s++)
    8000619e:	02800513          	li	a0,40
    800061a2:	b7cd                	j	80006184 <printf+0x17e>
      consputc('%');
    800061a4:	855a                	mv	a0,s6
    800061a6:	00000097          	auipc	ra,0x0
    800061aa:	b4a080e7          	jalr	-1206(ra) # 80005cf0 <consputc>
      break;
    800061ae:	b711                	j	800060b2 <printf+0xac>
      consputc('%');
    800061b0:	855a                	mv	a0,s6
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	b3e080e7          	jalr	-1218(ra) # 80005cf0 <consputc>
      consputc(c);
    800061ba:	8526                	mv	a0,s1
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	b34080e7          	jalr	-1228(ra) # 80005cf0 <consputc>
      break;
    800061c4:	b5fd                	j	800060b2 <printf+0xac>
    800061c6:	74a6                	ld	s1,104(sp)
    800061c8:	7906                	ld	s2,96(sp)
    800061ca:	69e6                	ld	s3,88(sp)
    800061cc:	6aa6                	ld	s5,72(sp)
    800061ce:	6b06                	ld	s6,64(sp)
    800061d0:	7be2                	ld	s7,56(sp)
    800061d2:	7c42                	ld	s8,48(sp)
    800061d4:	7ca2                	ld	s9,40(sp)
    800061d6:	6de2                	ld	s11,24(sp)
  if(locking)
    800061d8:	020d1263          	bnez	s10,800061fc <printf+0x1f6>
}
    800061dc:	70e6                	ld	ra,120(sp)
    800061de:	7446                	ld	s0,112(sp)
    800061e0:	6a46                	ld	s4,80(sp)
    800061e2:	7d02                	ld	s10,32(sp)
    800061e4:	6129                	addi	sp,sp,192
    800061e6:	8082                	ret
    800061e8:	74a6                	ld	s1,104(sp)
    800061ea:	7906                	ld	s2,96(sp)
    800061ec:	69e6                	ld	s3,88(sp)
    800061ee:	6aa6                	ld	s5,72(sp)
    800061f0:	6b06                	ld	s6,64(sp)
    800061f2:	7be2                	ld	s7,56(sp)
    800061f4:	7c42                	ld	s8,48(sp)
    800061f6:	7ca2                	ld	s9,40(sp)
    800061f8:	6de2                	ld	s11,24(sp)
    800061fa:	bff9                	j	800061d8 <printf+0x1d2>
    release(&pr.lock);
    800061fc:	00023517          	auipc	a0,0x23
    80006200:	fec50513          	addi	a0,a0,-20 # 800291e8 <pr>
    80006204:	00000097          	auipc	ra,0x0
    80006208:	3e6080e7          	jalr	998(ra) # 800065ea <release>
}
    8000620c:	bfc1                	j	800061dc <printf+0x1d6>

000000008000620e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000620e:	1101                	addi	sp,sp,-32
    80006210:	ec06                	sd	ra,24(sp)
    80006212:	e822                	sd	s0,16(sp)
    80006214:	e426                	sd	s1,8(sp)
    80006216:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006218:	00023497          	auipc	s1,0x23
    8000621c:	fd048493          	addi	s1,s1,-48 # 800291e8 <pr>
    80006220:	00002597          	auipc	a1,0x2
    80006224:	49858593          	addi	a1,a1,1176 # 800086b8 <etext+0x6b8>
    80006228:	8526                	mv	a0,s1
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	27c080e7          	jalr	636(ra) # 800064a6 <initlock>
  pr.locking = 1;
    80006232:	4785                	li	a5,1
    80006234:	cc9c                	sw	a5,24(s1)
}
    80006236:	60e2                	ld	ra,24(sp)
    80006238:	6442                	ld	s0,16(sp)
    8000623a:	64a2                	ld	s1,8(sp)
    8000623c:	6105                	addi	sp,sp,32
    8000623e:	8082                	ret

0000000080006240 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006240:	1141                	addi	sp,sp,-16
    80006242:	e406                	sd	ra,8(sp)
    80006244:	e022                	sd	s0,0(sp)
    80006246:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006248:	100007b7          	lui	a5,0x10000
    8000624c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006250:	10000737          	lui	a4,0x10000
    80006254:	f8000693          	li	a3,-128
    80006258:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000625c:	468d                	li	a3,3
    8000625e:	10000637          	lui	a2,0x10000
    80006262:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006266:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000626a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000626e:	10000737          	lui	a4,0x10000
    80006272:	461d                	li	a2,7
    80006274:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006278:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000627c:	00002597          	auipc	a1,0x2
    80006280:	44458593          	addi	a1,a1,1092 # 800086c0 <etext+0x6c0>
    80006284:	00023517          	auipc	a0,0x23
    80006288:	f8450513          	addi	a0,a0,-124 # 80029208 <uart_tx_lock>
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	21a080e7          	jalr	538(ra) # 800064a6 <initlock>
}
    80006294:	60a2                	ld	ra,8(sp)
    80006296:	6402                	ld	s0,0(sp)
    80006298:	0141                	addi	sp,sp,16
    8000629a:	8082                	ret

000000008000629c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000629c:	1101                	addi	sp,sp,-32
    8000629e:	ec06                	sd	ra,24(sp)
    800062a0:	e822                	sd	s0,16(sp)
    800062a2:	e426                	sd	s1,8(sp)
    800062a4:	1000                	addi	s0,sp,32
    800062a6:	84aa                	mv	s1,a0
  push_off();
    800062a8:	00000097          	auipc	ra,0x0
    800062ac:	242080e7          	jalr	578(ra) # 800064ea <push_off>

  if(panicked){
    800062b0:	00006797          	auipc	a5,0x6
    800062b4:	d6c7a783          	lw	a5,-660(a5) # 8000c01c <panicked>
    800062b8:	eb85                	bnez	a5,800062e8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062ba:	10000737          	lui	a4,0x10000
    800062be:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800062c0:	00074783          	lbu	a5,0(a4)
    800062c4:	0207f793          	andi	a5,a5,32
    800062c8:	dfe5                	beqz	a5,800062c0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062ca:	0ff4f513          	zext.b	a0,s1
    800062ce:	100007b7          	lui	a5,0x10000
    800062d2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800062d6:	00000097          	auipc	ra,0x0
    800062da:	2b4080e7          	jalr	692(ra) # 8000658a <pop_off>
}
    800062de:	60e2                	ld	ra,24(sp)
    800062e0:	6442                	ld	s0,16(sp)
    800062e2:	64a2                	ld	s1,8(sp)
    800062e4:	6105                	addi	sp,sp,32
    800062e6:	8082                	ret
    for(;;)
    800062e8:	a001                	j	800062e8 <uartputc_sync+0x4c>

00000000800062ea <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062ea:	00006797          	auipc	a5,0x6
    800062ee:	d367b783          	ld	a5,-714(a5) # 8000c020 <uart_tx_r>
    800062f2:	00006717          	auipc	a4,0x6
    800062f6:	d3673703          	ld	a4,-714(a4) # 8000c028 <uart_tx_w>
    800062fa:	06f70f63          	beq	a4,a5,80006378 <uartstart+0x8e>
{
    800062fe:	7139                	addi	sp,sp,-64
    80006300:	fc06                	sd	ra,56(sp)
    80006302:	f822                	sd	s0,48(sp)
    80006304:	f426                	sd	s1,40(sp)
    80006306:	f04a                	sd	s2,32(sp)
    80006308:	ec4e                	sd	s3,24(sp)
    8000630a:	e852                	sd	s4,16(sp)
    8000630c:	e456                	sd	s5,8(sp)
    8000630e:	e05a                	sd	s6,0(sp)
    80006310:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006312:	10000937          	lui	s2,0x10000
    80006316:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006318:	00023a97          	auipc	s5,0x23
    8000631c:	ef0a8a93          	addi	s5,s5,-272 # 80029208 <uart_tx_lock>
    uart_tx_r += 1;
    80006320:	00006497          	auipc	s1,0x6
    80006324:	d0048493          	addi	s1,s1,-768 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006328:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000632c:	00006997          	auipc	s3,0x6
    80006330:	cfc98993          	addi	s3,s3,-772 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006334:	00094703          	lbu	a4,0(s2)
    80006338:	02077713          	andi	a4,a4,32
    8000633c:	c705                	beqz	a4,80006364 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000633e:	01f7f713          	andi	a4,a5,31
    80006342:	9756                	add	a4,a4,s5
    80006344:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006348:	0785                	addi	a5,a5,1
    8000634a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000634c:	8526                	mv	a0,s1
    8000634e:	ffffb097          	auipc	ra,0xffffb
    80006352:	60e080e7          	jalr	1550(ra) # 8000195c <wakeup>
    WriteReg(THR, c);
    80006356:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000635a:	609c                	ld	a5,0(s1)
    8000635c:	0009b703          	ld	a4,0(s3)
    80006360:	fcf71ae3          	bne	a4,a5,80006334 <uartstart+0x4a>
  }
}
    80006364:	70e2                	ld	ra,56(sp)
    80006366:	7442                	ld	s0,48(sp)
    80006368:	74a2                	ld	s1,40(sp)
    8000636a:	7902                	ld	s2,32(sp)
    8000636c:	69e2                	ld	s3,24(sp)
    8000636e:	6a42                	ld	s4,16(sp)
    80006370:	6aa2                	ld	s5,8(sp)
    80006372:	6b02                	ld	s6,0(sp)
    80006374:	6121                	addi	sp,sp,64
    80006376:	8082                	ret
    80006378:	8082                	ret

000000008000637a <uartputc>:
{
    8000637a:	7179                	addi	sp,sp,-48
    8000637c:	f406                	sd	ra,40(sp)
    8000637e:	f022                	sd	s0,32(sp)
    80006380:	e052                	sd	s4,0(sp)
    80006382:	1800                	addi	s0,sp,48
    80006384:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006386:	00023517          	auipc	a0,0x23
    8000638a:	e8250513          	addi	a0,a0,-382 # 80029208 <uart_tx_lock>
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	1a8080e7          	jalr	424(ra) # 80006536 <acquire>
  if(panicked){
    80006396:	00006797          	auipc	a5,0x6
    8000639a:	c867a783          	lw	a5,-890(a5) # 8000c01c <panicked>
    8000639e:	c391                	beqz	a5,800063a2 <uartputc+0x28>
    for(;;)
    800063a0:	a001                	j	800063a0 <uartputc+0x26>
    800063a2:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063a4:	00006717          	auipc	a4,0x6
    800063a8:	c8473703          	ld	a4,-892(a4) # 8000c028 <uart_tx_w>
    800063ac:	00006797          	auipc	a5,0x6
    800063b0:	c747b783          	ld	a5,-908(a5) # 8000c020 <uart_tx_r>
    800063b4:	02078793          	addi	a5,a5,32
    800063b8:	02e79f63          	bne	a5,a4,800063f6 <uartputc+0x7c>
    800063bc:	e84a                	sd	s2,16(sp)
    800063be:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800063c0:	00023997          	auipc	s3,0x23
    800063c4:	e4898993          	addi	s3,s3,-440 # 80029208 <uart_tx_lock>
    800063c8:	00006497          	auipc	s1,0x6
    800063cc:	c5848493          	addi	s1,s1,-936 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063d0:	00006917          	auipc	s2,0x6
    800063d4:	c5890913          	addi	s2,s2,-936 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063d8:	85ce                	mv	a1,s3
    800063da:	8526                	mv	a0,s1
    800063dc:	ffffb097          	auipc	ra,0xffffb
    800063e0:	3f4080e7          	jalr	1012(ra) # 800017d0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063e4:	00093703          	ld	a4,0(s2)
    800063e8:	609c                	ld	a5,0(s1)
    800063ea:	02078793          	addi	a5,a5,32
    800063ee:	fee785e3          	beq	a5,a4,800063d8 <uartputc+0x5e>
    800063f2:	6942                	ld	s2,16(sp)
    800063f4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063f6:	00023497          	auipc	s1,0x23
    800063fa:	e1248493          	addi	s1,s1,-494 # 80029208 <uart_tx_lock>
    800063fe:	01f77793          	andi	a5,a4,31
    80006402:	97a6                	add	a5,a5,s1
    80006404:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006408:	0705                	addi	a4,a4,1
    8000640a:	00006797          	auipc	a5,0x6
    8000640e:	c0e7bf23          	sd	a4,-994(a5) # 8000c028 <uart_tx_w>
      uartstart();
    80006412:	00000097          	auipc	ra,0x0
    80006416:	ed8080e7          	jalr	-296(ra) # 800062ea <uartstart>
      release(&uart_tx_lock);
    8000641a:	8526                	mv	a0,s1
    8000641c:	00000097          	auipc	ra,0x0
    80006420:	1ce080e7          	jalr	462(ra) # 800065ea <release>
    80006424:	64e2                	ld	s1,24(sp)
}
    80006426:	70a2                	ld	ra,40(sp)
    80006428:	7402                	ld	s0,32(sp)
    8000642a:	6a02                	ld	s4,0(sp)
    8000642c:	6145                	addi	sp,sp,48
    8000642e:	8082                	ret

0000000080006430 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006430:	1141                	addi	sp,sp,-16
    80006432:	e422                	sd	s0,8(sp)
    80006434:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006436:	100007b7          	lui	a5,0x10000
    8000643a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000643c:	0007c783          	lbu	a5,0(a5)
    80006440:	8b85                	andi	a5,a5,1
    80006442:	cb81                	beqz	a5,80006452 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006444:	100007b7          	lui	a5,0x10000
    80006448:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000644c:	6422                	ld	s0,8(sp)
    8000644e:	0141                	addi	sp,sp,16
    80006450:	8082                	ret
    return -1;
    80006452:	557d                	li	a0,-1
    80006454:	bfe5                	j	8000644c <uartgetc+0x1c>

0000000080006456 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006456:	1101                	addi	sp,sp,-32
    80006458:	ec06                	sd	ra,24(sp)
    8000645a:	e822                	sd	s0,16(sp)
    8000645c:	e426                	sd	s1,8(sp)
    8000645e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006460:	54fd                	li	s1,-1
    80006462:	a029                	j	8000646c <uartintr+0x16>
      break;
    consoleintr(c);
    80006464:	00000097          	auipc	ra,0x0
    80006468:	8ce080e7          	jalr	-1842(ra) # 80005d32 <consoleintr>
    int c = uartgetc();
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	fc4080e7          	jalr	-60(ra) # 80006430 <uartgetc>
    if(c == -1)
    80006474:	fe9518e3          	bne	a0,s1,80006464 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006478:	00023497          	auipc	s1,0x23
    8000647c:	d9048493          	addi	s1,s1,-624 # 80029208 <uart_tx_lock>
    80006480:	8526                	mv	a0,s1
    80006482:	00000097          	auipc	ra,0x0
    80006486:	0b4080e7          	jalr	180(ra) # 80006536 <acquire>
  uartstart();
    8000648a:	00000097          	auipc	ra,0x0
    8000648e:	e60080e7          	jalr	-416(ra) # 800062ea <uartstart>
  release(&uart_tx_lock);
    80006492:	8526                	mv	a0,s1
    80006494:	00000097          	auipc	ra,0x0
    80006498:	156080e7          	jalr	342(ra) # 800065ea <release>
}
    8000649c:	60e2                	ld	ra,24(sp)
    8000649e:	6442                	ld	s0,16(sp)
    800064a0:	64a2                	ld	s1,8(sp)
    800064a2:	6105                	addi	sp,sp,32
    800064a4:	8082                	ret

00000000800064a6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064a6:	1141                	addi	sp,sp,-16
    800064a8:	e422                	sd	s0,8(sp)
    800064aa:	0800                	addi	s0,sp,16
  lk->name = name;
    800064ac:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064ae:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064b2:	00053823          	sd	zero,16(a0)
}
    800064b6:	6422                	ld	s0,8(sp)
    800064b8:	0141                	addi	sp,sp,16
    800064ba:	8082                	ret

00000000800064bc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064bc:	411c                	lw	a5,0(a0)
    800064be:	e399                	bnez	a5,800064c4 <holding+0x8>
    800064c0:	4501                	li	a0,0
  return r;
}
    800064c2:	8082                	ret
{
    800064c4:	1101                	addi	sp,sp,-32
    800064c6:	ec06                	sd	ra,24(sp)
    800064c8:	e822                	sd	s0,16(sp)
    800064ca:	e426                	sd	s1,8(sp)
    800064cc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064ce:	6904                	ld	s1,16(a0)
    800064d0:	ffffb097          	auipc	ra,0xffffb
    800064d4:	c1e080e7          	jalr	-994(ra) # 800010ee <mycpu>
    800064d8:	40a48533          	sub	a0,s1,a0
    800064dc:	00153513          	seqz	a0,a0
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6105                	addi	sp,sp,32
    800064e8:	8082                	ret

00000000800064ea <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064ea:	1101                	addi	sp,sp,-32
    800064ec:	ec06                	sd	ra,24(sp)
    800064ee:	e822                	sd	s0,16(sp)
    800064f0:	e426                	sd	s1,8(sp)
    800064f2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064f4:	100024f3          	csrr	s1,sstatus
    800064f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064fc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064fe:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006502:	ffffb097          	auipc	ra,0xffffb
    80006506:	bec080e7          	jalr	-1044(ra) # 800010ee <mycpu>
    8000650a:	5d3c                	lw	a5,120(a0)
    8000650c:	cf89                	beqz	a5,80006526 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000650e:	ffffb097          	auipc	ra,0xffffb
    80006512:	be0080e7          	jalr	-1056(ra) # 800010ee <mycpu>
    80006516:	5d3c                	lw	a5,120(a0)
    80006518:	2785                	addiw	a5,a5,1
    8000651a:	dd3c                	sw	a5,120(a0)
}
    8000651c:	60e2                	ld	ra,24(sp)
    8000651e:	6442                	ld	s0,16(sp)
    80006520:	64a2                	ld	s1,8(sp)
    80006522:	6105                	addi	sp,sp,32
    80006524:	8082                	ret
    mycpu()->intena = old;
    80006526:	ffffb097          	auipc	ra,0xffffb
    8000652a:	bc8080e7          	jalr	-1080(ra) # 800010ee <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000652e:	8085                	srli	s1,s1,0x1
    80006530:	8885                	andi	s1,s1,1
    80006532:	dd64                	sw	s1,124(a0)
    80006534:	bfe9                	j	8000650e <push_off+0x24>

0000000080006536 <acquire>:
{
    80006536:	1101                	addi	sp,sp,-32
    80006538:	ec06                	sd	ra,24(sp)
    8000653a:	e822                	sd	s0,16(sp)
    8000653c:	e426                	sd	s1,8(sp)
    8000653e:	1000                	addi	s0,sp,32
    80006540:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006542:	00000097          	auipc	ra,0x0
    80006546:	fa8080e7          	jalr	-88(ra) # 800064ea <push_off>
  if(holding(lk))
    8000654a:	8526                	mv	a0,s1
    8000654c:	00000097          	auipc	ra,0x0
    80006550:	f70080e7          	jalr	-144(ra) # 800064bc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006554:	4705                	li	a4,1
  if(holding(lk))
    80006556:	e115                	bnez	a0,8000657a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006558:	87ba                	mv	a5,a4
    8000655a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000655e:	2781                	sext.w	a5,a5
    80006560:	ffe5                	bnez	a5,80006558 <acquire+0x22>
  __sync_synchronize();
    80006562:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006566:	ffffb097          	auipc	ra,0xffffb
    8000656a:	b88080e7          	jalr	-1144(ra) # 800010ee <mycpu>
    8000656e:	e888                	sd	a0,16(s1)
}
    80006570:	60e2                	ld	ra,24(sp)
    80006572:	6442                	ld	s0,16(sp)
    80006574:	64a2                	ld	s1,8(sp)
    80006576:	6105                	addi	sp,sp,32
    80006578:	8082                	ret
    panic("acquire");
    8000657a:	00002517          	auipc	a0,0x2
    8000657e:	14e50513          	addi	a0,a0,334 # 800086c8 <etext+0x6c8>
    80006582:	00000097          	auipc	ra,0x0
    80006586:	a3a080e7          	jalr	-1478(ra) # 80005fbc <panic>

000000008000658a <pop_off>:

void
pop_off(void)
{
    8000658a:	1141                	addi	sp,sp,-16
    8000658c:	e406                	sd	ra,8(sp)
    8000658e:	e022                	sd	s0,0(sp)
    80006590:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006592:	ffffb097          	auipc	ra,0xffffb
    80006596:	b5c080e7          	jalr	-1188(ra) # 800010ee <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000659a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000659e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800065a0:	e78d                	bnez	a5,800065ca <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800065a2:	5d3c                	lw	a5,120(a0)
    800065a4:	02f05b63          	blez	a5,800065da <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065a8:	37fd                	addiw	a5,a5,-1
    800065aa:	0007871b          	sext.w	a4,a5
    800065ae:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065b0:	eb09                	bnez	a4,800065c2 <pop_off+0x38>
    800065b2:	5d7c                	lw	a5,124(a0)
    800065b4:	c799                	beqz	a5,800065c2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065ba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065be:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065c2:	60a2                	ld	ra,8(sp)
    800065c4:	6402                	ld	s0,0(sp)
    800065c6:	0141                	addi	sp,sp,16
    800065c8:	8082                	ret
    panic("pop_off - interruptible");
    800065ca:	00002517          	auipc	a0,0x2
    800065ce:	10650513          	addi	a0,a0,262 # 800086d0 <etext+0x6d0>
    800065d2:	00000097          	auipc	ra,0x0
    800065d6:	9ea080e7          	jalr	-1558(ra) # 80005fbc <panic>
    panic("pop_off");
    800065da:	00002517          	auipc	a0,0x2
    800065de:	10e50513          	addi	a0,a0,270 # 800086e8 <etext+0x6e8>
    800065e2:	00000097          	auipc	ra,0x0
    800065e6:	9da080e7          	jalr	-1574(ra) # 80005fbc <panic>

00000000800065ea <release>:
{
    800065ea:	1101                	addi	sp,sp,-32
    800065ec:	ec06                	sd	ra,24(sp)
    800065ee:	e822                	sd	s0,16(sp)
    800065f0:	e426                	sd	s1,8(sp)
    800065f2:	1000                	addi	s0,sp,32
    800065f4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065f6:	00000097          	auipc	ra,0x0
    800065fa:	ec6080e7          	jalr	-314(ra) # 800064bc <holding>
    800065fe:	c115                	beqz	a0,80006622 <release+0x38>
  lk->cpu = 0;
    80006600:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006604:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006608:	0310000f          	fence	rw,w
    8000660c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006610:	00000097          	auipc	ra,0x0
    80006614:	f7a080e7          	jalr	-134(ra) # 8000658a <pop_off>
}
    80006618:	60e2                	ld	ra,24(sp)
    8000661a:	6442                	ld	s0,16(sp)
    8000661c:	64a2                	ld	s1,8(sp)
    8000661e:	6105                	addi	sp,sp,32
    80006620:	8082                	ret
    panic("release");
    80006622:	00002517          	auipc	a0,0x2
    80006626:	0ce50513          	addi	a0,a0,206 # 800086f0 <etext+0x6f0>
    8000662a:	00000097          	auipc	ra,0x0
    8000662e:	992080e7          	jalr	-1646(ra) # 80005fbc <panic>
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
