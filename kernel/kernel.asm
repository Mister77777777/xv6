
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	3f013103          	ld	sp,1008(sp) # 8000b3f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	513050ef          	jal	80005d28 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002e797          	auipc	a5,0x2e
    8000003a:	21278793          	addi	a5,a5,530 # 8002e248 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	23a080e7          	jalr	570(ra) # 80000288 <memset>

  r = (struct run*)pa;
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	6b8080e7          	jalr	1720(ra) # 8000670e <push_off>
  int id = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	f10080e7          	jalr	-240(ra) # 80000f6e <cpuid>

  acquire(&kmem[id].lock);
    80000066:	0000ca97          	auipc	s5,0xc
    8000006a:	fcaa8a93          	addi	s5,s5,-54 # 8000c030 <kmem>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	6de080e7          	jalr	1758(ra) # 8000675a <acquire>
  r->next = kmem[id].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
  kmem[id].freelist = r;
    8000008a:	02993023          	sd	s1,32(s2)
  release(&kmem[id].lock);
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	792080e7          	jalr	1938(ra) # 80006822 <release>
  pop_off();
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	72a080e7          	jalr	1834(ra) # 800067c2 <pop_off>
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
    panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f4e50513          	addi	a0,a0,-178 # 80008000 <etext>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	13c080e7          	jalr	316(ra) # 800061f6 <panic>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000cc:	6785                	lui	a5,0x1
    800000ce:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d2:	00e504b3          	add	s1,a0,a4
    800000d6:	777d                	lui	a4,0xfffff
    800000d8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000da:	94be                	add	s1,s1,a5
    800000dc:	0295e463          	bltu	a1,s1,80000104 <freerange+0x42>
    800000e0:	e84a                	sd	s2,16(sp)
    800000e2:	e44e                	sd	s3,8(sp)
    800000e4:	e052                	sd	s4,0(sp)
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x2a>
    800000fe:	6942                	ld	s2,16(sp)
    80000100:	69a2                	ld	s3,8(sp)
    80000102:	6a02                	ld	s4,0(sp)
}
    80000104:	70a2                	ld	ra,40(sp)
    80000106:	7402                	ld	s0,32(sp)
    80000108:	64e2                	ld	s1,24(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	7139                	addi	sp,sp,-64
    80000110:	fc06                	sd	ra,56(sp)
    80000112:	f822                	sd	s0,48(sp)
    80000114:	f426                	sd	s1,40(sp)
    80000116:	f04a                	sd	s2,32(sp)
    80000118:	ec4e                	sd	s3,24(sp)
    8000011a:	e852                	sd	s4,16(sp)
    8000011c:	0080                	addi	s0,sp,64
  for(int i =0;i<NCPU;i++)
    8000011e:	0000c917          	auipc	s2,0xc
    80000122:	f1290913          	addi	s2,s2,-238 # 8000c030 <kmem>
    80000126:	4481                	li	s1,0
    snprintf(lock_name,sizeof(lock_name),"kmem%d",i);
    80000128:	00008a17          	auipc	s4,0x8
    8000012c:	ee8a0a13          	addi	s4,s4,-280 # 80008010 <etext+0x10>
  for(int i =0;i<NCPU;i++)
    80000130:	49a1                	li	s3,8
    snprintf(lock_name,sizeof(lock_name),"kmem%d",i);
    80000132:	86a6                	mv	a3,s1
    80000134:	8652                	mv	a2,s4
    80000136:	45a9                	li	a1,10
    80000138:	fc040513          	addi	a0,s0,-64
    8000013c:	00006097          	auipc	ra,0x6
    80000140:	9c4080e7          	jalr	-1596(ra) # 80005b00 <snprintf>
    initlock(&kmem[i].lock,lock_name);
    80000144:	fc040593          	addi	a1,s0,-64
    80000148:	854a                	mv	a0,s2
    8000014a:	00006097          	auipc	ra,0x6
    8000014e:	784080e7          	jalr	1924(ra) # 800068ce <initlock>
  for(int i =0;i<NCPU;i++)
    80000152:	2485                	addiw	s1,s1,1
    80000154:	02890913          	addi	s2,s2,40
    80000158:	fd349de3          	bne	s1,s3,80000132 <kinit+0x24>
  freerange(end, (void*)PHYSTOP);
    8000015c:	45c5                	li	a1,17
    8000015e:	05ee                	slli	a1,a1,0x1b
    80000160:	0002e517          	auipc	a0,0x2e
    80000164:	0e850513          	addi	a0,a0,232 # 8002e248 <end>
    80000168:	00000097          	auipc	ra,0x0
    8000016c:	f5a080e7          	jalr	-166(ra) # 800000c2 <freerange>
}
    80000170:	70e2                	ld	ra,56(sp)
    80000172:	7442                	ld	s0,48(sp)
    80000174:	74a2                	ld	s1,40(sp)
    80000176:	7902                	ld	s2,32(sp)
    80000178:	69e2                	ld	s3,24(sp)
    8000017a:	6a42                	ld	s4,16(sp)
    8000017c:	6121                	addi	sp,sp,64
    8000017e:	8082                	ret

0000000080000180 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000180:	715d                	addi	sp,sp,-80
    80000182:	e486                	sd	ra,72(sp)
    80000184:	e0a2                	sd	s0,64(sp)
    80000186:	fc26                	sd	s1,56(sp)
    80000188:	f052                	sd	s4,32(sp)
    8000018a:	ec56                	sd	s5,24(sp)
    8000018c:	0880                	addi	s0,sp,80
  struct run *r;
  push_off();
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	580080e7          	jalr	1408(ra) # 8000670e <push_off>
  int id =cpuid();
    80000196:	00001097          	auipc	ra,0x1
    8000019a:	dd8080e7          	jalr	-552(ra) # 80000f6e <cpuid>
    8000019e:	84aa                	mv	s1,a0
  acquire(&kmem[id].lock);
    800001a0:	00251793          	slli	a5,a0,0x2
    800001a4:	97aa                	add	a5,a5,a0
    800001a6:	078e                	slli	a5,a5,0x3
    800001a8:	0000ca17          	auipc	s4,0xc
    800001ac:	e88a0a13          	addi	s4,s4,-376 # 8000c030 <kmem>
    800001b0:	9a3e                	add	s4,s4,a5
    800001b2:	8552                	mv	a0,s4
    800001b4:	00006097          	auipc	ra,0x6
    800001b8:	5a6080e7          	jalr	1446(ra) # 8000675a <acquire>
  r = kmem[id].freelist;
    800001bc:	020a3a83          	ld	s5,32(s4)
  if(r)
    800001c0:	020a8e63          	beqz	s5,800001fc <kalloc+0x7c>
    kmem[id].freelist = r->next;
    800001c4:	000ab683          	ld	a3,0(s5)
    800001c8:	02da3023          	sd	a3,32(s4)
        break;
      }
      release(&kmem[new_id].lock);
    }
  }
  release(&kmem[id].lock);
    800001cc:	8552                	mv	a0,s4
    800001ce:	00006097          	auipc	ra,0x6
    800001d2:	654080e7          	jalr	1620(ra) # 80006822 <release>
  pop_off();
    800001d6:	00006097          	auipc	ra,0x6
    800001da:	5ec080e7          	jalr	1516(ra) # 800067c2 <pop_off>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001de:	6605                	lui	a2,0x1
    800001e0:	4595                	li	a1,5
    800001e2:	8556                	mv	a0,s5
    800001e4:	00000097          	auipc	ra,0x0
    800001e8:	0a4080e7          	jalr	164(ra) # 80000288 <memset>
  return (void*)r;
}
    800001ec:	8556                	mv	a0,s5
    800001ee:	60a6                	ld	ra,72(sp)
    800001f0:	6406                	ld	s0,64(sp)
    800001f2:	74e2                	ld	s1,56(sp)
    800001f4:	7a02                	ld	s4,32(sp)
    800001f6:	6ae2                	ld	s5,24(sp)
    800001f8:	6161                	addi	sp,sp,80
    800001fa:	8082                	ret
    800001fc:	f84a                	sd	s2,48(sp)
    800001fe:	f44e                	sd	s3,40(sp)
    80000200:	e85a                	sd	s6,16(sp)
    80000202:	e45e                	sd	s7,8(sp)
    80000204:	0000c997          	auipc	s3,0xc
    80000208:	e2c98993          	addi	s3,s3,-468 # 8000c030 <kmem>
    for(int new_id=0;new_id < NCPU;new_id++)
    8000020c:	4901                	li	s2,0
    8000020e:	4ba1                	li	s7,8
    80000210:	a82d                	j	8000024a <kalloc+0xca>
        kmem[new_id].freelist = r->next;
    80000212:	000b3683          	ld	a3,0(s6)
    80000216:	00291793          	slli	a5,s2,0x2
    8000021a:	97ca                	add	a5,a5,s2
    8000021c:	078e                	slli	a5,a5,0x3
    8000021e:	0000c717          	auipc	a4,0xc
    80000222:	e1270713          	addi	a4,a4,-494 # 8000c030 <kmem>
    80000226:	97ba                	add	a5,a5,a4
    80000228:	f394                	sd	a3,32(a5)
        release(&kmem[new_id].lock);
    8000022a:	854e                	mv	a0,s3
    8000022c:	00006097          	auipc	ra,0x6
    80000230:	5f6080e7          	jalr	1526(ra) # 80006822 <release>
      r = kmem[new_id].freelist;
    80000234:	8ada                	mv	s5,s6
        break;
    80000236:	7942                	ld	s2,48(sp)
    80000238:	79a2                	ld	s3,40(sp)
    8000023a:	6b42                	ld	s6,16(sp)
    8000023c:	6ba2                	ld	s7,8(sp)
    8000023e:	b779                	j	800001cc <kalloc+0x4c>
    for(int new_id=0;new_id < NCPU;new_id++)
    80000240:	2905                	addiw	s2,s2,1
    80000242:	02898993          	addi	s3,s3,40
    80000246:	03790363          	beq	s2,s7,8000026c <kalloc+0xec>
      if(new_id==id)
    8000024a:	ff248be3          	beq	s1,s2,80000240 <kalloc+0xc0>
      acquire(&kmem[new_id].lock);
    8000024e:	854e                	mv	a0,s3
    80000250:	00006097          	auipc	ra,0x6
    80000254:	50a080e7          	jalr	1290(ra) # 8000675a <acquire>
      r = kmem[new_id].freelist;
    80000258:	0209bb03          	ld	s6,32(s3)
      if(r)
    8000025c:	fa0b1be3          	bnez	s6,80000212 <kalloc+0x92>
      release(&kmem[new_id].lock);
    80000260:	854e                	mv	a0,s3
    80000262:	00006097          	auipc	ra,0x6
    80000266:	5c0080e7          	jalr	1472(ra) # 80006822 <release>
    8000026a:	bfd9                	j	80000240 <kalloc+0xc0>
  release(&kmem[id].lock);
    8000026c:	8552                	mv	a0,s4
    8000026e:	00006097          	auipc	ra,0x6
    80000272:	5b4080e7          	jalr	1460(ra) # 80006822 <release>
  pop_off();
    80000276:	00006097          	auipc	ra,0x6
    8000027a:	54c080e7          	jalr	1356(ra) # 800067c2 <pop_off>
  return (void*)r;
    8000027e:	7942                	ld	s2,48(sp)
    80000280:	79a2                	ld	s3,40(sp)
    80000282:	6b42                	ld	s6,16(sp)
    80000284:	6ba2                	ld	s7,8(sp)
    80000286:	b79d                	j	800001ec <kalloc+0x6c>

0000000080000288 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000288:	1141                	addi	sp,sp,-16
    8000028a:	e422                	sd	s0,8(sp)
    8000028c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000028e:	ca19                	beqz	a2,800002a4 <memset+0x1c>
    80000290:	87aa                	mv	a5,a0
    80000292:	1602                	slli	a2,a2,0x20
    80000294:	9201                	srli	a2,a2,0x20
    80000296:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000029a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000029e:	0785                	addi	a5,a5,1
    800002a0:	fee79de3          	bne	a5,a4,8000029a <memset+0x12>
  }
  return dst;
}
    800002a4:	6422                	ld	s0,8(sp)
    800002a6:	0141                	addi	sp,sp,16
    800002a8:	8082                	ret

00000000800002aa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e422                	sd	s0,8(sp)
    800002ae:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002b0:	ca05                	beqz	a2,800002e0 <memcmp+0x36>
    800002b2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002b6:	1682                	slli	a3,a3,0x20
    800002b8:	9281                	srli	a3,a3,0x20
    800002ba:	0685                	addi	a3,a3,1
    800002bc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002be:	00054783          	lbu	a5,0(a0)
    800002c2:	0005c703          	lbu	a4,0(a1)
    800002c6:	00e79863          	bne	a5,a4,800002d6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002ce:	fed518e3          	bne	a0,a3,800002be <memcmp+0x14>
  }

  return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	a019                	j	800002da <memcmp+0x30>
      return *s1 - *s2;
    800002d6:	40e7853b          	subw	a0,a5,a4
}
    800002da:	6422                	ld	s0,8(sp)
    800002dc:	0141                	addi	sp,sp,16
    800002de:	8082                	ret
  return 0;
    800002e0:	4501                	li	a0,0
    800002e2:	bfe5                	j	800002da <memcmp+0x30>

00000000800002e4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002e4:	1141                	addi	sp,sp,-16
    800002e6:	e422                	sd	s0,8(sp)
    800002e8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002ea:	c205                	beqz	a2,8000030a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002ec:	02a5e263          	bltu	a1,a0,80000310 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002f0:	1602                	slli	a2,a2,0x20
    800002f2:	9201                	srli	a2,a2,0x20
    800002f4:	00c587b3          	add	a5,a1,a2
{
    800002f8:	872a                	mv	a4,a0
      *d++ = *s++;
    800002fa:	0585                	addi	a1,a1,1
    800002fc:	0705                	addi	a4,a4,1
    800002fe:	fff5c683          	lbu	a3,-1(a1)
    80000302:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000306:	feb79ae3          	bne	a5,a1,800002fa <memmove+0x16>

  return dst;
}
    8000030a:	6422                	ld	s0,8(sp)
    8000030c:	0141                	addi	sp,sp,16
    8000030e:	8082                	ret
  if(s < d && s + n > d){
    80000310:	02061693          	slli	a3,a2,0x20
    80000314:	9281                	srli	a3,a3,0x20
    80000316:	00d58733          	add	a4,a1,a3
    8000031a:	fce57be3          	bgeu	a0,a4,800002f0 <memmove+0xc>
    d += n;
    8000031e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000320:	fff6079b          	addiw	a5,a2,-1
    80000324:	1782                	slli	a5,a5,0x20
    80000326:	9381                	srli	a5,a5,0x20
    80000328:	fff7c793          	not	a5,a5
    8000032c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000032e:	177d                	addi	a4,a4,-1
    80000330:	16fd                	addi	a3,a3,-1
    80000332:	00074603          	lbu	a2,0(a4)
    80000336:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000033a:	fef71ae3          	bne	a4,a5,8000032e <memmove+0x4a>
    8000033e:	b7f1                	j	8000030a <memmove+0x26>

0000000080000340 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000340:	1141                	addi	sp,sp,-16
    80000342:	e406                	sd	ra,8(sp)
    80000344:	e022                	sd	s0,0(sp)
    80000346:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000348:	00000097          	auipc	ra,0x0
    8000034c:	f9c080e7          	jalr	-100(ra) # 800002e4 <memmove>
}
    80000350:	60a2                	ld	ra,8(sp)
    80000352:	6402                	ld	s0,0(sp)
    80000354:	0141                	addi	sp,sp,16
    80000356:	8082                	ret

0000000080000358 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000358:	1141                	addi	sp,sp,-16
    8000035a:	e422                	sd	s0,8(sp)
    8000035c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000035e:	ce11                	beqz	a2,8000037a <strncmp+0x22>
    80000360:	00054783          	lbu	a5,0(a0)
    80000364:	cf89                	beqz	a5,8000037e <strncmp+0x26>
    80000366:	0005c703          	lbu	a4,0(a1)
    8000036a:	00f71a63          	bne	a4,a5,8000037e <strncmp+0x26>
    n--, p++, q++;
    8000036e:	367d                	addiw	a2,a2,-1
    80000370:	0505                	addi	a0,a0,1
    80000372:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000374:	f675                	bnez	a2,80000360 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000376:	4501                	li	a0,0
    80000378:	a801                	j	80000388 <strncmp+0x30>
    8000037a:	4501                	li	a0,0
    8000037c:	a031                	j	80000388 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    8000037e:	00054503          	lbu	a0,0(a0)
    80000382:	0005c783          	lbu	a5,0(a1)
    80000386:	9d1d                	subw	a0,a0,a5
}
    80000388:	6422                	ld	s0,8(sp)
    8000038a:	0141                	addi	sp,sp,16
    8000038c:	8082                	ret

000000008000038e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000038e:	1141                	addi	sp,sp,-16
    80000390:	e422                	sd	s0,8(sp)
    80000392:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000394:	87aa                	mv	a5,a0
    80000396:	86b2                	mv	a3,a2
    80000398:	367d                	addiw	a2,a2,-1
    8000039a:	02d05563          	blez	a3,800003c4 <strncpy+0x36>
    8000039e:	0785                	addi	a5,a5,1
    800003a0:	0005c703          	lbu	a4,0(a1)
    800003a4:	fee78fa3          	sb	a4,-1(a5)
    800003a8:	0585                	addi	a1,a1,1
    800003aa:	f775                	bnez	a4,80000396 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003ac:	873e                	mv	a4,a5
    800003ae:	9fb5                	addw	a5,a5,a3
    800003b0:	37fd                	addiw	a5,a5,-1
    800003b2:	00c05963          	blez	a2,800003c4 <strncpy+0x36>
    *s++ = 0;
    800003b6:	0705                	addi	a4,a4,1
    800003b8:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003bc:	40e786bb          	subw	a3,a5,a4
    800003c0:	fed04be3          	bgtz	a3,800003b6 <strncpy+0x28>
  return os;
}
    800003c4:	6422                	ld	s0,8(sp)
    800003c6:	0141                	addi	sp,sp,16
    800003c8:	8082                	ret

00000000800003ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e422                	sd	s0,8(sp)
    800003ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003d0:	02c05363          	blez	a2,800003f6 <safestrcpy+0x2c>
    800003d4:	fff6069b          	addiw	a3,a2,-1
    800003d8:	1682                	slli	a3,a3,0x20
    800003da:	9281                	srli	a3,a3,0x20
    800003dc:	96ae                	add	a3,a3,a1
    800003de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003e0:	00d58963          	beq	a1,a3,800003f2 <safestrcpy+0x28>
    800003e4:	0585                	addi	a1,a1,1
    800003e6:	0785                	addi	a5,a5,1
    800003e8:	fff5c703          	lbu	a4,-1(a1)
    800003ec:	fee78fa3          	sb	a4,-1(a5)
    800003f0:	fb65                	bnez	a4,800003e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800003f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800003f6:	6422                	ld	s0,8(sp)
    800003f8:	0141                	addi	sp,sp,16
    800003fa:	8082                	ret

00000000800003fc <strlen>:

int
strlen(const char *s)
{
    800003fc:	1141                	addi	sp,sp,-16
    800003fe:	e422                	sd	s0,8(sp)
    80000400:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000402:	00054783          	lbu	a5,0(a0)
    80000406:	cf91                	beqz	a5,80000422 <strlen+0x26>
    80000408:	0505                	addi	a0,a0,1
    8000040a:	87aa                	mv	a5,a0
    8000040c:	86be                	mv	a3,a5
    8000040e:	0785                	addi	a5,a5,1
    80000410:	fff7c703          	lbu	a4,-1(a5)
    80000414:	ff65                	bnez	a4,8000040c <strlen+0x10>
    80000416:	40a6853b          	subw	a0,a3,a0
    8000041a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000041c:	6422                	ld	s0,8(sp)
    8000041e:	0141                	addi	sp,sp,16
    80000420:	8082                	ret
  for(n = 0; s[n]; n++)
    80000422:	4501                	li	a0,0
    80000424:	bfe5                	j	8000041c <strlen+0x20>

0000000080000426 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000426:	1101                	addi	sp,sp,-32
    80000428:	ec06                	sd	ra,24(sp)
    8000042a:	e822                	sd	s0,16(sp)
    8000042c:	e426                	sd	s1,8(sp)
    8000042e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000430:	00001097          	auipc	ra,0x1
    80000434:	b3e080e7          	jalr	-1218(ra) # 80000f6e <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000438:	0000c497          	auipc	s1,0xc
    8000043c:	bc848493          	addi	s1,s1,-1080 # 8000c000 <started>
  if(cpuid() == 0){
    80000440:	c531                	beqz	a0,8000048c <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000442:	8526                	mv	a0,s1
    80000444:	00006097          	auipc	ra,0x6
    80000448:	520080e7          	jalr	1312(ra) # 80006964 <lockfree_read4>
    8000044c:	d97d                	beqz	a0,80000442 <main+0x1c>
      ;
    __sync_synchronize();
    8000044e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000452:	00001097          	auipc	ra,0x1
    80000456:	b1c080e7          	jalr	-1252(ra) # 80000f6e <cpuid>
    8000045a:	85aa                	mv	a1,a0
    8000045c:	00008517          	auipc	a0,0x8
    80000460:	bdc50513          	addi	a0,a0,-1060 # 80008038 <etext+0x38>
    80000464:	00006097          	auipc	ra,0x6
    80000468:	ddc080e7          	jalr	-548(ra) # 80006240 <printf>
    kvminithart();    // turn on paging
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	0e0080e7          	jalr	224(ra) # 8000054c <kvminithart>
    trapinithart();   // install kernel trap vector
    80000474:	00001097          	auipc	ra,0x1
    80000478:	77e080e7          	jalr	1918(ra) # 80001bf2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000047c:	00005097          	auipc	ra,0x5
    80000480:	ee8080e7          	jalr	-280(ra) # 80005364 <plicinithart>
  }

  scheduler();        
    80000484:	00001097          	auipc	ra,0x1
    80000488:	02a080e7          	jalr	42(ra) # 800014ae <scheduler>
    consoleinit();
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	c7a080e7          	jalr	-902(ra) # 80006106 <consoleinit>
    statsinit();
    80000494:	00005097          	auipc	ra,0x5
    80000498:	58e080e7          	jalr	1422(ra) # 80005a22 <statsinit>
    printfinit();
    8000049c:	00006097          	auipc	ra,0x6
    800004a0:	fac080e7          	jalr	-84(ra) # 80006448 <printfinit>
    printf("\n");
    800004a4:	00008517          	auipc	a0,0x8
    800004a8:	b7450513          	addi	a0,a0,-1164 # 80008018 <etext+0x18>
    800004ac:	00006097          	auipc	ra,0x6
    800004b0:	d94080e7          	jalr	-620(ra) # 80006240 <printf>
    printf("xv6 kernel is booting\n");
    800004b4:	00008517          	auipc	a0,0x8
    800004b8:	b6c50513          	addi	a0,a0,-1172 # 80008020 <etext+0x20>
    800004bc:	00006097          	auipc	ra,0x6
    800004c0:	d84080e7          	jalr	-636(ra) # 80006240 <printf>
    printf("\n");
    800004c4:	00008517          	auipc	a0,0x8
    800004c8:	b5450513          	addi	a0,a0,-1196 # 80008018 <etext+0x18>
    800004cc:	00006097          	auipc	ra,0x6
    800004d0:	d74080e7          	jalr	-652(ra) # 80006240 <printf>
    kinit();         // physical page allocator
    800004d4:	00000097          	auipc	ra,0x0
    800004d8:	c3a080e7          	jalr	-966(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    800004dc:	00000097          	auipc	ra,0x0
    800004e0:	322080e7          	jalr	802(ra) # 800007fe <kvminit>
    kvminithart();   // turn on paging
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	068080e7          	jalr	104(ra) # 8000054c <kvminithart>
    procinit();      // process table
    800004ec:	00001097          	auipc	ra,0x1
    800004f0:	9c4080e7          	jalr	-1596(ra) # 80000eb0 <procinit>
    trapinit();      // trap vectors
    800004f4:	00001097          	auipc	ra,0x1
    800004f8:	6d6080e7          	jalr	1750(ra) # 80001bca <trapinit>
    trapinithart();  // install kernel trap vector
    800004fc:	00001097          	auipc	ra,0x1
    80000500:	6f6080e7          	jalr	1782(ra) # 80001bf2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000504:	00005097          	auipc	ra,0x5
    80000508:	e46080e7          	jalr	-442(ra) # 8000534a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000050c:	00005097          	auipc	ra,0x5
    80000510:	e58080e7          	jalr	-424(ra) # 80005364 <plicinithart>
    binit();         // buffer cache
    80000514:	00002097          	auipc	ra,0x2
    80000518:	e44080e7          	jalr	-444(ra) # 80002358 <binit>
    iinit();         // inode table
    8000051c:	00002097          	auipc	ra,0x2
    80000520:	5f4080e7          	jalr	1524(ra) # 80002b10 <iinit>
    fileinit();      // file table
    80000524:	00003097          	auipc	ra,0x3
    80000528:	598080e7          	jalr	1432(ra) # 80003abc <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000052c:	00005097          	auipc	ra,0x5
    80000530:	f58080e7          	jalr	-168(ra) # 80005484 <virtio_disk_init>
    userinit();      // first user process
    80000534:	00001097          	auipc	ra,0x1
    80000538:	d3e080e7          	jalr	-706(ra) # 80001272 <userinit>
    __sync_synchronize();
    8000053c:	0330000f          	fence	rw,rw
    started = 1;
    80000540:	4785                	li	a5,1
    80000542:	0000c717          	auipc	a4,0xc
    80000546:	aaf72f23          	sw	a5,-1346(a4) # 8000c000 <started>
    8000054a:	bf2d                	j	80000484 <main+0x5e>

000000008000054c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000054c:	1141                	addi	sp,sp,-16
    8000054e:	e422                	sd	s0,8(sp)
    80000550:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000552:	0000c797          	auipc	a5,0xc
    80000556:	ab67b783          	ld	a5,-1354(a5) # 8000c008 <kernel_pagetable>
    8000055a:	83b1                	srli	a5,a5,0xc
    8000055c:	577d                	li	a4,-1
    8000055e:	177e                	slli	a4,a4,0x3f
    80000560:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000562:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000566:	12000073          	sfence.vma
  sfence_vma();
}
    8000056a:	6422                	ld	s0,8(sp)
    8000056c:	0141                	addi	sp,sp,16
    8000056e:	8082                	ret

0000000080000570 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000570:	7139                	addi	sp,sp,-64
    80000572:	fc06                	sd	ra,56(sp)
    80000574:	f822                	sd	s0,48(sp)
    80000576:	f426                	sd	s1,40(sp)
    80000578:	f04a                	sd	s2,32(sp)
    8000057a:	ec4e                	sd	s3,24(sp)
    8000057c:	e852                	sd	s4,16(sp)
    8000057e:	e456                	sd	s5,8(sp)
    80000580:	e05a                	sd	s6,0(sp)
    80000582:	0080                	addi	s0,sp,64
    80000584:	84aa                	mv	s1,a0
    80000586:	89ae                	mv	s3,a1
    80000588:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000058a:	57fd                	li	a5,-1
    8000058c:	83e9                	srli	a5,a5,0x1a
    8000058e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000590:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000592:	04b7f263          	bgeu	a5,a1,800005d6 <walk+0x66>
    panic("walk");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	aba50513          	addi	a0,a0,-1350 # 80008050 <etext+0x50>
    8000059e:	00006097          	auipc	ra,0x6
    800005a2:	c58080e7          	jalr	-936(ra) # 800061f6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005a6:	060a8663          	beqz	s5,80000612 <walk+0xa2>
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	bd6080e7          	jalr	-1066(ra) # 80000180 <kalloc>
    800005b2:	84aa                	mv	s1,a0
    800005b4:	c529                	beqz	a0,800005fe <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005b6:	6605                	lui	a2,0x1
    800005b8:	4581                	li	a1,0
    800005ba:	00000097          	auipc	ra,0x0
    800005be:	cce080e7          	jalr	-818(ra) # 80000288 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005c2:	00c4d793          	srli	a5,s1,0xc
    800005c6:	07aa                	slli	a5,a5,0xa
    800005c8:	0017e793          	ori	a5,a5,1
    800005cc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005d0:	3a5d                	addiw	s4,s4,-9
    800005d2:	036a0063          	beq	s4,s6,800005f2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005d6:	0149d933          	srl	s2,s3,s4
    800005da:	1ff97913          	andi	s2,s2,511
    800005de:	090e                	slli	s2,s2,0x3
    800005e0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005e2:	00093483          	ld	s1,0(s2)
    800005e6:	0014f793          	andi	a5,s1,1
    800005ea:	dfd5                	beqz	a5,800005a6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005ec:	80a9                	srli	s1,s1,0xa
    800005ee:	04b2                	slli	s1,s1,0xc
    800005f0:	b7c5                	j	800005d0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005f2:	00c9d513          	srli	a0,s3,0xc
    800005f6:	1ff57513          	andi	a0,a0,511
    800005fa:	050e                	slli	a0,a0,0x3
    800005fc:	9526                	add	a0,a0,s1
}
    800005fe:	70e2                	ld	ra,56(sp)
    80000600:	7442                	ld	s0,48(sp)
    80000602:	74a2                	ld	s1,40(sp)
    80000604:	7902                	ld	s2,32(sp)
    80000606:	69e2                	ld	s3,24(sp)
    80000608:	6a42                	ld	s4,16(sp)
    8000060a:	6aa2                	ld	s5,8(sp)
    8000060c:	6b02                	ld	s6,0(sp)
    8000060e:	6121                	addi	sp,sp,64
    80000610:	8082                	ret
        return 0;
    80000612:	4501                	li	a0,0
    80000614:	b7ed                	j	800005fe <walk+0x8e>

0000000080000616 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000616:	57fd                	li	a5,-1
    80000618:	83e9                	srli	a5,a5,0x1a
    8000061a:	00b7f463          	bgeu	a5,a1,80000622 <walkaddr+0xc>
    return 0;
    8000061e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000620:	8082                	ret
{
    80000622:	1141                	addi	sp,sp,-16
    80000624:	e406                	sd	ra,8(sp)
    80000626:	e022                	sd	s0,0(sp)
    80000628:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000062a:	4601                	li	a2,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	f44080e7          	jalr	-188(ra) # 80000570 <walk>
  if(pte == 0)
    80000634:	c105                	beqz	a0,80000654 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000636:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000638:	0117f693          	andi	a3,a5,17
    8000063c:	4745                	li	a4,17
    return 0;
    8000063e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000640:	00e68663          	beq	a3,a4,8000064c <walkaddr+0x36>
}
    80000644:	60a2                	ld	ra,8(sp)
    80000646:	6402                	ld	s0,0(sp)
    80000648:	0141                	addi	sp,sp,16
    8000064a:	8082                	ret
  pa = PTE2PA(*pte);
    8000064c:	83a9                	srli	a5,a5,0xa
    8000064e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000652:	bfcd                	j	80000644 <walkaddr+0x2e>
    return 0;
    80000654:	4501                	li	a0,0
    80000656:	b7fd                	j	80000644 <walkaddr+0x2e>

0000000080000658 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000658:	715d                	addi	sp,sp,-80
    8000065a:	e486                	sd	ra,72(sp)
    8000065c:	e0a2                	sd	s0,64(sp)
    8000065e:	fc26                	sd	s1,56(sp)
    80000660:	f84a                	sd	s2,48(sp)
    80000662:	f44e                	sd	s3,40(sp)
    80000664:	f052                	sd	s4,32(sp)
    80000666:	ec56                	sd	s5,24(sp)
    80000668:	e85a                	sd	s6,16(sp)
    8000066a:	e45e                	sd	s7,8(sp)
    8000066c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000066e:	c639                	beqz	a2,800006bc <mappages+0x64>
    80000670:	8aaa                	mv	s5,a0
    80000672:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000674:	777d                	lui	a4,0xfffff
    80000676:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000067a:	fff58993          	addi	s3,a1,-1
    8000067e:	99b2                	add	s3,s3,a2
    80000680:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000684:	893e                	mv	s2,a5
    80000686:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000068a:	6b85                	lui	s7,0x1
    8000068c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000690:	4605                	li	a2,1
    80000692:	85ca                	mv	a1,s2
    80000694:	8556                	mv	a0,s5
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	eda080e7          	jalr	-294(ra) # 80000570 <walk>
    8000069e:	cd1d                	beqz	a0,800006dc <mappages+0x84>
    if(*pte & PTE_V)
    800006a0:	611c                	ld	a5,0(a0)
    800006a2:	8b85                	andi	a5,a5,1
    800006a4:	e785                	bnez	a5,800006cc <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006a6:	80b1                	srli	s1,s1,0xc
    800006a8:	04aa                	slli	s1,s1,0xa
    800006aa:	0164e4b3          	or	s1,s1,s6
    800006ae:	0014e493          	ori	s1,s1,1
    800006b2:	e104                	sd	s1,0(a0)
    if(a == last)
    800006b4:	05390063          	beq	s2,s3,800006f4 <mappages+0x9c>
    a += PGSIZE;
    800006b8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006ba:	bfc9                	j	8000068c <mappages+0x34>
    panic("mappages: size");
    800006bc:	00008517          	auipc	a0,0x8
    800006c0:	99c50513          	addi	a0,a0,-1636 # 80008058 <etext+0x58>
    800006c4:	00006097          	auipc	ra,0x6
    800006c8:	b32080e7          	jalr	-1230(ra) # 800061f6 <panic>
      panic("mappages: remap");
    800006cc:	00008517          	auipc	a0,0x8
    800006d0:	99c50513          	addi	a0,a0,-1636 # 80008068 <etext+0x68>
    800006d4:	00006097          	auipc	ra,0x6
    800006d8:	b22080e7          	jalr	-1246(ra) # 800061f6 <panic>
      return -1;
    800006dc:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006de:	60a6                	ld	ra,72(sp)
    800006e0:	6406                	ld	s0,64(sp)
    800006e2:	74e2                	ld	s1,56(sp)
    800006e4:	7942                	ld	s2,48(sp)
    800006e6:	79a2                	ld	s3,40(sp)
    800006e8:	7a02                	ld	s4,32(sp)
    800006ea:	6ae2                	ld	s5,24(sp)
    800006ec:	6b42                	ld	s6,16(sp)
    800006ee:	6ba2                	ld	s7,8(sp)
    800006f0:	6161                	addi	sp,sp,80
    800006f2:	8082                	ret
  return 0;
    800006f4:	4501                	li	a0,0
    800006f6:	b7e5                	j	800006de <mappages+0x86>

00000000800006f8 <kvmmap>:
{
    800006f8:	1141                	addi	sp,sp,-16
    800006fa:	e406                	sd	ra,8(sp)
    800006fc:	e022                	sd	s0,0(sp)
    800006fe:	0800                	addi	s0,sp,16
    80000700:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000702:	86b2                	mv	a3,a2
    80000704:	863e                	mv	a2,a5
    80000706:	00000097          	auipc	ra,0x0
    8000070a:	f52080e7          	jalr	-174(ra) # 80000658 <mappages>
    8000070e:	e509                	bnez	a0,80000718 <kvmmap+0x20>
}
    80000710:	60a2                	ld	ra,8(sp)
    80000712:	6402                	ld	s0,0(sp)
    80000714:	0141                	addi	sp,sp,16
    80000716:	8082                	ret
    panic("kvmmap");
    80000718:	00008517          	auipc	a0,0x8
    8000071c:	96050513          	addi	a0,a0,-1696 # 80008078 <etext+0x78>
    80000720:	00006097          	auipc	ra,0x6
    80000724:	ad6080e7          	jalr	-1322(ra) # 800061f6 <panic>

0000000080000728 <kvmmake>:
{
    80000728:	1101                	addi	sp,sp,-32
    8000072a:	ec06                	sd	ra,24(sp)
    8000072c:	e822                	sd	s0,16(sp)
    8000072e:	e426                	sd	s1,8(sp)
    80000730:	e04a                	sd	s2,0(sp)
    80000732:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000734:	00000097          	auipc	ra,0x0
    80000738:	a4c080e7          	jalr	-1460(ra) # 80000180 <kalloc>
    8000073c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000073e:	6605                	lui	a2,0x1
    80000740:	4581                	li	a1,0
    80000742:	00000097          	auipc	ra,0x0
    80000746:	b46080e7          	jalr	-1210(ra) # 80000288 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000074a:	4719                	li	a4,6
    8000074c:	6685                	lui	a3,0x1
    8000074e:	10000637          	lui	a2,0x10000
    80000752:	100005b7          	lui	a1,0x10000
    80000756:	8526                	mv	a0,s1
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	fa0080e7          	jalr	-96(ra) # 800006f8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000760:	4719                	li	a4,6
    80000762:	6685                	lui	a3,0x1
    80000764:	10001637          	lui	a2,0x10001
    80000768:	100015b7          	lui	a1,0x10001
    8000076c:	8526                	mv	a0,s1
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	f8a080e7          	jalr	-118(ra) # 800006f8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000776:	4719                	li	a4,6
    80000778:	004006b7          	lui	a3,0x400
    8000077c:	0c000637          	lui	a2,0xc000
    80000780:	0c0005b7          	lui	a1,0xc000
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	f72080e7          	jalr	-142(ra) # 800006f8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000078e:	00008917          	auipc	s2,0x8
    80000792:	87290913          	addi	s2,s2,-1934 # 80008000 <etext>
    80000796:	4729                	li	a4,10
    80000798:	80008697          	auipc	a3,0x80008
    8000079c:	86868693          	addi	a3,a3,-1944 # 8000 <_entry-0x7fff8000>
    800007a0:	4605                	li	a2,1
    800007a2:	067e                	slli	a2,a2,0x1f
    800007a4:	85b2                	mv	a1,a2
    800007a6:	8526                	mv	a0,s1
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	f50080e7          	jalr	-176(ra) # 800006f8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007b0:	46c5                	li	a3,17
    800007b2:	06ee                	slli	a3,a3,0x1b
    800007b4:	4719                	li	a4,6
    800007b6:	412686b3          	sub	a3,a3,s2
    800007ba:	864a                	mv	a2,s2
    800007bc:	85ca                	mv	a1,s2
    800007be:	8526                	mv	a0,s1
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	f38080e7          	jalr	-200(ra) # 800006f8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007c8:	4729                	li	a4,10
    800007ca:	6685                	lui	a3,0x1
    800007cc:	00007617          	auipc	a2,0x7
    800007d0:	83460613          	addi	a2,a2,-1996 # 80007000 <_trampoline>
    800007d4:	040005b7          	lui	a1,0x4000
    800007d8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007da:	05b2                	slli	a1,a1,0xc
    800007dc:	8526                	mv	a0,s1
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	f1a080e7          	jalr	-230(ra) # 800006f8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007e6:	8526                	mv	a0,s1
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	624080e7          	jalr	1572(ra) # 80000e0c <proc_mapstacks>
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6902                	ld	s2,0(sp)
    800007fa:	6105                	addi	sp,sp,32
    800007fc:	8082                	ret

00000000800007fe <kvminit>:
{
    800007fe:	1141                	addi	sp,sp,-16
    80000800:	e406                	sd	ra,8(sp)
    80000802:	e022                	sd	s0,0(sp)
    80000804:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	f22080e7          	jalr	-222(ra) # 80000728 <kvmmake>
    8000080e:	0000b797          	auipc	a5,0xb
    80000812:	7ea7bd23          	sd	a0,2042(a5) # 8000c008 <kernel_pagetable>
}
    80000816:	60a2                	ld	ra,8(sp)
    80000818:	6402                	ld	s0,0(sp)
    8000081a:	0141                	addi	sp,sp,16
    8000081c:	8082                	ret

000000008000081e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000081e:	715d                	addi	sp,sp,-80
    80000820:	e486                	sd	ra,72(sp)
    80000822:	e0a2                	sd	s0,64(sp)
    80000824:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000826:	03459793          	slli	a5,a1,0x34
    8000082a:	e39d                	bnez	a5,80000850 <uvmunmap+0x32>
    8000082c:	f84a                	sd	s2,48(sp)
    8000082e:	f44e                	sd	s3,40(sp)
    80000830:	f052                	sd	s4,32(sp)
    80000832:	ec56                	sd	s5,24(sp)
    80000834:	e85a                	sd	s6,16(sp)
    80000836:	e45e                	sd	s7,8(sp)
    80000838:	8a2a                	mv	s4,a0
    8000083a:	892e                	mv	s2,a1
    8000083c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000083e:	0632                	slli	a2,a2,0xc
    80000840:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000844:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000846:	6b05                	lui	s6,0x1
    80000848:	0935fb63          	bgeu	a1,s3,800008de <uvmunmap+0xc0>
    8000084c:	fc26                	sd	s1,56(sp)
    8000084e:	a8a9                	j	800008a8 <uvmunmap+0x8a>
    80000850:	fc26                	sd	s1,56(sp)
    80000852:	f84a                	sd	s2,48(sp)
    80000854:	f44e                	sd	s3,40(sp)
    80000856:	f052                	sd	s4,32(sp)
    80000858:	ec56                	sd	s5,24(sp)
    8000085a:	e85a                	sd	s6,16(sp)
    8000085c:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	82250513          	addi	a0,a0,-2014 # 80008080 <etext+0x80>
    80000866:	00006097          	auipc	ra,0x6
    8000086a:	990080e7          	jalr	-1648(ra) # 800061f6 <panic>
      panic("uvmunmap: walk");
    8000086e:	00008517          	auipc	a0,0x8
    80000872:	82a50513          	addi	a0,a0,-2006 # 80008098 <etext+0x98>
    80000876:	00006097          	auipc	ra,0x6
    8000087a:	980080e7          	jalr	-1664(ra) # 800061f6 <panic>
      panic("uvmunmap: not mapped");
    8000087e:	00008517          	auipc	a0,0x8
    80000882:	82a50513          	addi	a0,a0,-2006 # 800080a8 <etext+0xa8>
    80000886:	00006097          	auipc	ra,0x6
    8000088a:	970080e7          	jalr	-1680(ra) # 800061f6 <panic>
      panic("uvmunmap: not a leaf");
    8000088e:	00008517          	auipc	a0,0x8
    80000892:	83250513          	addi	a0,a0,-1998 # 800080c0 <etext+0xc0>
    80000896:	00006097          	auipc	ra,0x6
    8000089a:	960080e7          	jalr	-1696(ra) # 800061f6 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000089e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008a2:	995a                	add	s2,s2,s6
    800008a4:	03397c63          	bgeu	s2,s3,800008dc <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008a8:	4601                	li	a2,0
    800008aa:	85ca                	mv	a1,s2
    800008ac:	8552                	mv	a0,s4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	cc2080e7          	jalr	-830(ra) # 80000570 <walk>
    800008b6:	84aa                	mv	s1,a0
    800008b8:	d95d                	beqz	a0,8000086e <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800008ba:	6108                	ld	a0,0(a0)
    800008bc:	00157793          	andi	a5,a0,1
    800008c0:	dfdd                	beqz	a5,8000087e <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008c2:	3ff57793          	andi	a5,a0,1023
    800008c6:	fd7784e3          	beq	a5,s7,8000088e <uvmunmap+0x70>
    if(do_free){
    800008ca:	fc0a8ae3          	beqz	s5,8000089e <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800008ce:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008d0:	0532                	slli	a0,a0,0xc
    800008d2:	fffff097          	auipc	ra,0xfffff
    800008d6:	74a080e7          	jalr	1866(ra) # 8000001c <kfree>
    800008da:	b7d1                	j	8000089e <uvmunmap+0x80>
    800008dc:	74e2                	ld	s1,56(sp)
    800008de:	7942                	ld	s2,48(sp)
    800008e0:	79a2                	ld	s3,40(sp)
    800008e2:	7a02                	ld	s4,32(sp)
    800008e4:	6ae2                	ld	s5,24(sp)
    800008e6:	6b42                	ld	s6,16(sp)
    800008e8:	6ba2                	ld	s7,8(sp)
  }
}
    800008ea:	60a6                	ld	ra,72(sp)
    800008ec:	6406                	ld	s0,64(sp)
    800008ee:	6161                	addi	sp,sp,80
    800008f0:	8082                	ret

00000000800008f2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008f2:	1101                	addi	sp,sp,-32
    800008f4:	ec06                	sd	ra,24(sp)
    800008f6:	e822                	sd	s0,16(sp)
    800008f8:	e426                	sd	s1,8(sp)
    800008fa:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	884080e7          	jalr	-1916(ra) # 80000180 <kalloc>
    80000904:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000906:	c519                	beqz	a0,80000914 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000908:	6605                	lui	a2,0x1
    8000090a:	4581                	li	a1,0
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	97c080e7          	jalr	-1668(ra) # 80000288 <memset>
  return pagetable;
}
    80000914:	8526                	mv	a0,s1
    80000916:	60e2                	ld	ra,24(sp)
    80000918:	6442                	ld	s0,16(sp)
    8000091a:	64a2                	ld	s1,8(sp)
    8000091c:	6105                	addi	sp,sp,32
    8000091e:	8082                	ret

0000000080000920 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000920:	7179                	addi	sp,sp,-48
    80000922:	f406                	sd	ra,40(sp)
    80000924:	f022                	sd	s0,32(sp)
    80000926:	ec26                	sd	s1,24(sp)
    80000928:	e84a                	sd	s2,16(sp)
    8000092a:	e44e                	sd	s3,8(sp)
    8000092c:	e052                	sd	s4,0(sp)
    8000092e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000930:	6785                	lui	a5,0x1
    80000932:	04f67863          	bgeu	a2,a5,80000982 <uvminit+0x62>
    80000936:	8a2a                	mv	s4,a0
    80000938:	89ae                	mv	s3,a1
    8000093a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	844080e7          	jalr	-1980(ra) # 80000180 <kalloc>
    80000944:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000946:	6605                	lui	a2,0x1
    80000948:	4581                	li	a1,0
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	93e080e7          	jalr	-1730(ra) # 80000288 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000952:	4779                	li	a4,30
    80000954:	86ca                	mv	a3,s2
    80000956:	6605                	lui	a2,0x1
    80000958:	4581                	li	a1,0
    8000095a:	8552                	mv	a0,s4
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	cfc080e7          	jalr	-772(ra) # 80000658 <mappages>
  memmove(mem, src, sz);
    80000964:	8626                	mv	a2,s1
    80000966:	85ce                	mv	a1,s3
    80000968:	854a                	mv	a0,s2
    8000096a:	00000097          	auipc	ra,0x0
    8000096e:	97a080e7          	jalr	-1670(ra) # 800002e4 <memmove>
}
    80000972:	70a2                	ld	ra,40(sp)
    80000974:	7402                	ld	s0,32(sp)
    80000976:	64e2                	ld	s1,24(sp)
    80000978:	6942                	ld	s2,16(sp)
    8000097a:	69a2                	ld	s3,8(sp)
    8000097c:	6a02                	ld	s4,0(sp)
    8000097e:	6145                	addi	sp,sp,48
    80000980:	8082                	ret
    panic("inituvm: more than a page");
    80000982:	00007517          	auipc	a0,0x7
    80000986:	75650513          	addi	a0,a0,1878 # 800080d8 <etext+0xd8>
    8000098a:	00006097          	auipc	ra,0x6
    8000098e:	86c080e7          	jalr	-1940(ra) # 800061f6 <panic>

0000000080000992 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000992:	1101                	addi	sp,sp,-32
    80000994:	ec06                	sd	ra,24(sp)
    80000996:	e822                	sd	s0,16(sp)
    80000998:	e426                	sd	s1,8(sp)
    8000099a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000099c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000099e:	00b67d63          	bgeu	a2,a1,800009b8 <uvmdealloc+0x26>
    800009a2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009a4:	6785                	lui	a5,0x1
    800009a6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009a8:	00f60733          	add	a4,a2,a5
    800009ac:	76fd                	lui	a3,0xfffff
    800009ae:	8f75                	and	a4,a4,a3
    800009b0:	97ae                	add	a5,a5,a1
    800009b2:	8ff5                	and	a5,a5,a3
    800009b4:	00f76863          	bltu	a4,a5,800009c4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009b8:	8526                	mv	a0,s1
    800009ba:	60e2                	ld	ra,24(sp)
    800009bc:	6442                	ld	s0,16(sp)
    800009be:	64a2                	ld	s1,8(sp)
    800009c0:	6105                	addi	sp,sp,32
    800009c2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009c4:	8f99                	sub	a5,a5,a4
    800009c6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009c8:	4685                	li	a3,1
    800009ca:	0007861b          	sext.w	a2,a5
    800009ce:	85ba                	mv	a1,a4
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	e4e080e7          	jalr	-434(ra) # 8000081e <uvmunmap>
    800009d8:	b7c5                	j	800009b8 <uvmdealloc+0x26>

00000000800009da <uvmalloc>:
  if(newsz < oldsz)
    800009da:	0ab66563          	bltu	a2,a1,80000a84 <uvmalloc+0xaa>
{
    800009de:	7139                	addi	sp,sp,-64
    800009e0:	fc06                	sd	ra,56(sp)
    800009e2:	f822                	sd	s0,48(sp)
    800009e4:	ec4e                	sd	s3,24(sp)
    800009e6:	e852                	sd	s4,16(sp)
    800009e8:	e456                	sd	s5,8(sp)
    800009ea:	0080                	addi	s0,sp,64
    800009ec:	8aaa                	mv	s5,a0
    800009ee:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009f0:	6785                	lui	a5,0x1
    800009f2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f4:	95be                	add	a1,a1,a5
    800009f6:	77fd                	lui	a5,0xfffff
    800009f8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009fc:	08c9f663          	bgeu	s3,a2,80000a88 <uvmalloc+0xae>
    80000a00:	f426                	sd	s1,40(sp)
    80000a02:	f04a                	sd	s2,32(sp)
    80000a04:	894e                	mv	s2,s3
    mem = kalloc();
    80000a06:	fffff097          	auipc	ra,0xfffff
    80000a0a:	77a080e7          	jalr	1914(ra) # 80000180 <kalloc>
    80000a0e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a10:	c90d                	beqz	a0,80000a42 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4581                	li	a1,0
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	872080e7          	jalr	-1934(ra) # 80000288 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a1e:	4779                	li	a4,30
    80000a20:	86a6                	mv	a3,s1
    80000a22:	6605                	lui	a2,0x1
    80000a24:	85ca                	mv	a1,s2
    80000a26:	8556                	mv	a0,s5
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	c30080e7          	jalr	-976(ra) # 80000658 <mappages>
    80000a30:	e915                	bnez	a0,80000a64 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a32:	6785                	lui	a5,0x1
    80000a34:	993e                	add	s2,s2,a5
    80000a36:	fd4968e3          	bltu	s2,s4,80000a06 <uvmalloc+0x2c>
  return newsz;
    80000a3a:	8552                	mv	a0,s4
    80000a3c:	74a2                	ld	s1,40(sp)
    80000a3e:	7902                	ld	s2,32(sp)
    80000a40:	a819                	j	80000a56 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000a42:	864e                	mv	a2,s3
    80000a44:	85ca                	mv	a1,s2
    80000a46:	8556                	mv	a0,s5
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	f4a080e7          	jalr	-182(ra) # 80000992 <uvmdealloc>
      return 0;
    80000a50:	4501                	li	a0,0
    80000a52:	74a2                	ld	s1,40(sp)
    80000a54:	7902                	ld	s2,32(sp)
}
    80000a56:	70e2                	ld	ra,56(sp)
    80000a58:	7442                	ld	s0,48(sp)
    80000a5a:	69e2                	ld	s3,24(sp)
    80000a5c:	6a42                	ld	s4,16(sp)
    80000a5e:	6aa2                	ld	s5,8(sp)
    80000a60:	6121                	addi	sp,sp,64
    80000a62:	8082                	ret
      kfree(mem);
    80000a64:	8526                	mv	a0,s1
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	5b6080e7          	jalr	1462(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a6e:	864e                	mv	a2,s3
    80000a70:	85ca                	mv	a1,s2
    80000a72:	8556                	mv	a0,s5
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	f1e080e7          	jalr	-226(ra) # 80000992 <uvmdealloc>
      return 0;
    80000a7c:	4501                	li	a0,0
    80000a7e:	74a2                	ld	s1,40(sp)
    80000a80:	7902                	ld	s2,32(sp)
    80000a82:	bfd1                	j	80000a56 <uvmalloc+0x7c>
    return oldsz;
    80000a84:	852e                	mv	a0,a1
}
    80000a86:	8082                	ret
  return newsz;
    80000a88:	8532                	mv	a0,a2
    80000a8a:	b7f1                	j	80000a56 <uvmalloc+0x7c>

0000000080000a8c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a8c:	7179                	addi	sp,sp,-48
    80000a8e:	f406                	sd	ra,40(sp)
    80000a90:	f022                	sd	s0,32(sp)
    80000a92:	ec26                	sd	s1,24(sp)
    80000a94:	e84a                	sd	s2,16(sp)
    80000a96:	e44e                	sd	s3,8(sp)
    80000a98:	e052                	sd	s4,0(sp)
    80000a9a:	1800                	addi	s0,sp,48
    80000a9c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a9e:	84aa                	mv	s1,a0
    80000aa0:	6905                	lui	s2,0x1
    80000aa2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aa4:	4985                	li	s3,1
    80000aa6:	a829                	j	80000ac0 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000aa8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000aaa:	00c79513          	slli	a0,a5,0xc
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	fde080e7          	jalr	-34(ra) # 80000a8c <freewalk>
      pagetable[i] = 0;
    80000ab6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000aba:	04a1                	addi	s1,s1,8
    80000abc:	03248163          	beq	s1,s2,80000ade <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000ac0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ac2:	00f7f713          	andi	a4,a5,15
    80000ac6:	ff3701e3          	beq	a4,s3,80000aa8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000aca:	8b85                	andi	a5,a5,1
    80000acc:	d7fd                	beqz	a5,80000aba <freewalk+0x2e>
      panic("freewalk: leaf");
    80000ace:	00007517          	auipc	a0,0x7
    80000ad2:	62a50513          	addi	a0,a0,1578 # 800080f8 <etext+0xf8>
    80000ad6:	00005097          	auipc	ra,0x5
    80000ada:	720080e7          	jalr	1824(ra) # 800061f6 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ade:	8552                	mv	a0,s4
    80000ae0:	fffff097          	auipc	ra,0xfffff
    80000ae4:	53c080e7          	jalr	1340(ra) # 8000001c <kfree>
}
    80000ae8:	70a2                	ld	ra,40(sp)
    80000aea:	7402                	ld	s0,32(sp)
    80000aec:	64e2                	ld	s1,24(sp)
    80000aee:	6942                	ld	s2,16(sp)
    80000af0:	69a2                	ld	s3,8(sp)
    80000af2:	6a02                	ld	s4,0(sp)
    80000af4:	6145                	addi	sp,sp,48
    80000af6:	8082                	ret

0000000080000af8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000af8:	1101                	addi	sp,sp,-32
    80000afa:	ec06                	sd	ra,24(sp)
    80000afc:	e822                	sd	s0,16(sp)
    80000afe:	e426                	sd	s1,8(sp)
    80000b00:	1000                	addi	s0,sp,32
    80000b02:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b04:	e999                	bnez	a1,80000b1a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b06:	8526                	mv	a0,s1
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	f84080e7          	jalr	-124(ra) # 80000a8c <freewalk>
}
    80000b10:	60e2                	ld	ra,24(sp)
    80000b12:	6442                	ld	s0,16(sp)
    80000b14:	64a2                	ld	s1,8(sp)
    80000b16:	6105                	addi	sp,sp,32
    80000b18:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b1a:	6785                	lui	a5,0x1
    80000b1c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b1e:	95be                	add	a1,a1,a5
    80000b20:	4685                	li	a3,1
    80000b22:	00c5d613          	srli	a2,a1,0xc
    80000b26:	4581                	li	a1,0
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	cf6080e7          	jalr	-778(ra) # 8000081e <uvmunmap>
    80000b30:	bfd9                	j	80000b06 <uvmfree+0xe>

0000000080000b32 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b32:	c679                	beqz	a2,80000c00 <uvmcopy+0xce>
{
    80000b34:	715d                	addi	sp,sp,-80
    80000b36:	e486                	sd	ra,72(sp)
    80000b38:	e0a2                	sd	s0,64(sp)
    80000b3a:	fc26                	sd	s1,56(sp)
    80000b3c:	f84a                	sd	s2,48(sp)
    80000b3e:	f44e                	sd	s3,40(sp)
    80000b40:	f052                	sd	s4,32(sp)
    80000b42:	ec56                	sd	s5,24(sp)
    80000b44:	e85a                	sd	s6,16(sp)
    80000b46:	e45e                	sd	s7,8(sp)
    80000b48:	0880                	addi	s0,sp,80
    80000b4a:	8b2a                	mv	s6,a0
    80000b4c:	8aae                	mv	s5,a1
    80000b4e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b50:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b52:	4601                	li	a2,0
    80000b54:	85ce                	mv	a1,s3
    80000b56:	855a                	mv	a0,s6
    80000b58:	00000097          	auipc	ra,0x0
    80000b5c:	a18080e7          	jalr	-1512(ra) # 80000570 <walk>
    80000b60:	c531                	beqz	a0,80000bac <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b62:	6118                	ld	a4,0(a0)
    80000b64:	00177793          	andi	a5,a4,1
    80000b68:	cbb1                	beqz	a5,80000bbc <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b6a:	00a75593          	srli	a1,a4,0xa
    80000b6e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b72:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b76:	fffff097          	auipc	ra,0xfffff
    80000b7a:	60a080e7          	jalr	1546(ra) # 80000180 <kalloc>
    80000b7e:	892a                	mv	s2,a0
    80000b80:	c939                	beqz	a0,80000bd6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b82:	6605                	lui	a2,0x1
    80000b84:	85de                	mv	a1,s7
    80000b86:	fffff097          	auipc	ra,0xfffff
    80000b8a:	75e080e7          	jalr	1886(ra) # 800002e4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b8e:	8726                	mv	a4,s1
    80000b90:	86ca                	mv	a3,s2
    80000b92:	6605                	lui	a2,0x1
    80000b94:	85ce                	mv	a1,s3
    80000b96:	8556                	mv	a0,s5
    80000b98:	00000097          	auipc	ra,0x0
    80000b9c:	ac0080e7          	jalr	-1344(ra) # 80000658 <mappages>
    80000ba0:	e515                	bnez	a0,80000bcc <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ba2:	6785                	lui	a5,0x1
    80000ba4:	99be                	add	s3,s3,a5
    80000ba6:	fb49e6e3          	bltu	s3,s4,80000b52 <uvmcopy+0x20>
    80000baa:	a081                	j	80000bea <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000bac:	00007517          	auipc	a0,0x7
    80000bb0:	55c50513          	addi	a0,a0,1372 # 80008108 <etext+0x108>
    80000bb4:	00005097          	auipc	ra,0x5
    80000bb8:	642080e7          	jalr	1602(ra) # 800061f6 <panic>
      panic("uvmcopy: page not present");
    80000bbc:	00007517          	auipc	a0,0x7
    80000bc0:	56c50513          	addi	a0,a0,1388 # 80008128 <etext+0x128>
    80000bc4:	00005097          	auipc	ra,0x5
    80000bc8:	632080e7          	jalr	1586(ra) # 800061f6 <panic>
      kfree(mem);
    80000bcc:	854a                	mv	a0,s2
    80000bce:	fffff097          	auipc	ra,0xfffff
    80000bd2:	44e080e7          	jalr	1102(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bd6:	4685                	li	a3,1
    80000bd8:	00c9d613          	srli	a2,s3,0xc
    80000bdc:	4581                	li	a1,0
    80000bde:	8556                	mv	a0,s5
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	c3e080e7          	jalr	-962(ra) # 8000081e <uvmunmap>
  return -1;
    80000be8:	557d                	li	a0,-1
}
    80000bea:	60a6                	ld	ra,72(sp)
    80000bec:	6406                	ld	s0,64(sp)
    80000bee:	74e2                	ld	s1,56(sp)
    80000bf0:	7942                	ld	s2,48(sp)
    80000bf2:	79a2                	ld	s3,40(sp)
    80000bf4:	7a02                	ld	s4,32(sp)
    80000bf6:	6ae2                	ld	s5,24(sp)
    80000bf8:	6b42                	ld	s6,16(sp)
    80000bfa:	6ba2                	ld	s7,8(sp)
    80000bfc:	6161                	addi	sp,sp,80
    80000bfe:	8082                	ret
  return 0;
    80000c00:	4501                	li	a0,0
}
    80000c02:	8082                	ret

0000000080000c04 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c04:	1141                	addi	sp,sp,-16
    80000c06:	e406                	sd	ra,8(sp)
    80000c08:	e022                	sd	s0,0(sp)
    80000c0a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c0c:	4601                	li	a2,0
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	962080e7          	jalr	-1694(ra) # 80000570 <walk>
  if(pte == 0)
    80000c16:	c901                	beqz	a0,80000c26 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c18:	611c                	ld	a5,0(a0)
    80000c1a:	9bbd                	andi	a5,a5,-17
    80000c1c:	e11c                	sd	a5,0(a0)
}
    80000c1e:	60a2                	ld	ra,8(sp)
    80000c20:	6402                	ld	s0,0(sp)
    80000c22:	0141                	addi	sp,sp,16
    80000c24:	8082                	ret
    panic("uvmclear");
    80000c26:	00007517          	auipc	a0,0x7
    80000c2a:	52250513          	addi	a0,a0,1314 # 80008148 <etext+0x148>
    80000c2e:	00005097          	auipc	ra,0x5
    80000c32:	5c8080e7          	jalr	1480(ra) # 800061f6 <panic>

0000000080000c36 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c36:	c6bd                	beqz	a3,80000ca4 <copyout+0x6e>
{
    80000c38:	715d                	addi	sp,sp,-80
    80000c3a:	e486                	sd	ra,72(sp)
    80000c3c:	e0a2                	sd	s0,64(sp)
    80000c3e:	fc26                	sd	s1,56(sp)
    80000c40:	f84a                	sd	s2,48(sp)
    80000c42:	f44e                	sd	s3,40(sp)
    80000c44:	f052                	sd	s4,32(sp)
    80000c46:	ec56                	sd	s5,24(sp)
    80000c48:	e85a                	sd	s6,16(sp)
    80000c4a:	e45e                	sd	s7,8(sp)
    80000c4c:	e062                	sd	s8,0(sp)
    80000c4e:	0880                	addi	s0,sp,80
    80000c50:	8b2a                	mv	s6,a0
    80000c52:	8c2e                	mv	s8,a1
    80000c54:	8a32                	mv	s4,a2
    80000c56:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c58:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c5a:	6a85                	lui	s5,0x1
    80000c5c:	a015                	j	80000c80 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c5e:	9562                	add	a0,a0,s8
    80000c60:	0004861b          	sext.w	a2,s1
    80000c64:	85d2                	mv	a1,s4
    80000c66:	41250533          	sub	a0,a0,s2
    80000c6a:	fffff097          	auipc	ra,0xfffff
    80000c6e:	67a080e7          	jalr	1658(ra) # 800002e4 <memmove>

    len -= n;
    80000c72:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c76:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c78:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c7c:	02098263          	beqz	s3,80000ca0 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c80:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c84:	85ca                	mv	a1,s2
    80000c86:	855a                	mv	a0,s6
    80000c88:	00000097          	auipc	ra,0x0
    80000c8c:	98e080e7          	jalr	-1650(ra) # 80000616 <walkaddr>
    if(pa0 == 0)
    80000c90:	cd01                	beqz	a0,80000ca8 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c92:	418904b3          	sub	s1,s2,s8
    80000c96:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c98:	fc99f3e3          	bgeu	s3,s1,80000c5e <copyout+0x28>
    80000c9c:	84ce                	mv	s1,s3
    80000c9e:	b7c1                	j	80000c5e <copyout+0x28>
  }
  return 0;
    80000ca0:	4501                	li	a0,0
    80000ca2:	a021                	j	80000caa <copyout+0x74>
    80000ca4:	4501                	li	a0,0
}
    80000ca6:	8082                	ret
      return -1;
    80000ca8:	557d                	li	a0,-1
}
    80000caa:	60a6                	ld	ra,72(sp)
    80000cac:	6406                	ld	s0,64(sp)
    80000cae:	74e2                	ld	s1,56(sp)
    80000cb0:	7942                	ld	s2,48(sp)
    80000cb2:	79a2                	ld	s3,40(sp)
    80000cb4:	7a02                	ld	s4,32(sp)
    80000cb6:	6ae2                	ld	s5,24(sp)
    80000cb8:	6b42                	ld	s6,16(sp)
    80000cba:	6ba2                	ld	s7,8(sp)
    80000cbc:	6c02                	ld	s8,0(sp)
    80000cbe:	6161                	addi	sp,sp,80
    80000cc0:	8082                	ret

0000000080000cc2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cc2:	caa5                	beqz	a3,80000d32 <copyin+0x70>
{
    80000cc4:	715d                	addi	sp,sp,-80
    80000cc6:	e486                	sd	ra,72(sp)
    80000cc8:	e0a2                	sd	s0,64(sp)
    80000cca:	fc26                	sd	s1,56(sp)
    80000ccc:	f84a                	sd	s2,48(sp)
    80000cce:	f44e                	sd	s3,40(sp)
    80000cd0:	f052                	sd	s4,32(sp)
    80000cd2:	ec56                	sd	s5,24(sp)
    80000cd4:	e85a                	sd	s6,16(sp)
    80000cd6:	e45e                	sd	s7,8(sp)
    80000cd8:	e062                	sd	s8,0(sp)
    80000cda:	0880                	addi	s0,sp,80
    80000cdc:	8b2a                	mv	s6,a0
    80000cde:	8a2e                	mv	s4,a1
    80000ce0:	8c32                	mv	s8,a2
    80000ce2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ce4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ce6:	6a85                	lui	s5,0x1
    80000ce8:	a01d                	j	80000d0e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cea:	018505b3          	add	a1,a0,s8
    80000cee:	0004861b          	sext.w	a2,s1
    80000cf2:	412585b3          	sub	a1,a1,s2
    80000cf6:	8552                	mv	a0,s4
    80000cf8:	fffff097          	auipc	ra,0xfffff
    80000cfc:	5ec080e7          	jalr	1516(ra) # 800002e4 <memmove>

    len -= n;
    80000d00:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d04:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d06:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d0a:	02098263          	beqz	s3,80000d2e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d0e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d12:	85ca                	mv	a1,s2
    80000d14:	855a                	mv	a0,s6
    80000d16:	00000097          	auipc	ra,0x0
    80000d1a:	900080e7          	jalr	-1792(ra) # 80000616 <walkaddr>
    if(pa0 == 0)
    80000d1e:	cd01                	beqz	a0,80000d36 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d20:	418904b3          	sub	s1,s2,s8
    80000d24:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d26:	fc99f2e3          	bgeu	s3,s1,80000cea <copyin+0x28>
    80000d2a:	84ce                	mv	s1,s3
    80000d2c:	bf7d                	j	80000cea <copyin+0x28>
  }
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	a021                	j	80000d38 <copyin+0x76>
    80000d32:	4501                	li	a0,0
}
    80000d34:	8082                	ret
      return -1;
    80000d36:	557d                	li	a0,-1
}
    80000d38:	60a6                	ld	ra,72(sp)
    80000d3a:	6406                	ld	s0,64(sp)
    80000d3c:	74e2                	ld	s1,56(sp)
    80000d3e:	7942                	ld	s2,48(sp)
    80000d40:	79a2                	ld	s3,40(sp)
    80000d42:	7a02                	ld	s4,32(sp)
    80000d44:	6ae2                	ld	s5,24(sp)
    80000d46:	6b42                	ld	s6,16(sp)
    80000d48:	6ba2                	ld	s7,8(sp)
    80000d4a:	6c02                	ld	s8,0(sp)
    80000d4c:	6161                	addi	sp,sp,80
    80000d4e:	8082                	ret

0000000080000d50 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d50:	cacd                	beqz	a3,80000e02 <copyinstr+0xb2>
{
    80000d52:	715d                	addi	sp,sp,-80
    80000d54:	e486                	sd	ra,72(sp)
    80000d56:	e0a2                	sd	s0,64(sp)
    80000d58:	fc26                	sd	s1,56(sp)
    80000d5a:	f84a                	sd	s2,48(sp)
    80000d5c:	f44e                	sd	s3,40(sp)
    80000d5e:	f052                	sd	s4,32(sp)
    80000d60:	ec56                	sd	s5,24(sp)
    80000d62:	e85a                	sd	s6,16(sp)
    80000d64:	e45e                	sd	s7,8(sp)
    80000d66:	0880                	addi	s0,sp,80
    80000d68:	8a2a                	mv	s4,a0
    80000d6a:	8b2e                	mv	s6,a1
    80000d6c:	8bb2                	mv	s7,a2
    80000d6e:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d70:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d72:	6985                	lui	s3,0x1
    80000d74:	a825                	j	80000dac <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d76:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d7a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d7c:	37fd                	addiw	a5,a5,-1
    80000d7e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d82:	60a6                	ld	ra,72(sp)
    80000d84:	6406                	ld	s0,64(sp)
    80000d86:	74e2                	ld	s1,56(sp)
    80000d88:	7942                	ld	s2,48(sp)
    80000d8a:	79a2                	ld	s3,40(sp)
    80000d8c:	7a02                	ld	s4,32(sp)
    80000d8e:	6ae2                	ld	s5,24(sp)
    80000d90:	6b42                	ld	s6,16(sp)
    80000d92:	6ba2                	ld	s7,8(sp)
    80000d94:	6161                	addi	sp,sp,80
    80000d96:	8082                	ret
    80000d98:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d9c:	9742                	add	a4,a4,a6
      --max;
    80000d9e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000da2:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000da6:	04e58663          	beq	a1,a4,80000df2 <copyinstr+0xa2>
{
    80000daa:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000dac:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000db0:	85a6                	mv	a1,s1
    80000db2:	8552                	mv	a0,s4
    80000db4:	00000097          	auipc	ra,0x0
    80000db8:	862080e7          	jalr	-1950(ra) # 80000616 <walkaddr>
    if(pa0 == 0)
    80000dbc:	cd0d                	beqz	a0,80000df6 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000dbe:	417486b3          	sub	a3,s1,s7
    80000dc2:	96ce                	add	a3,a3,s3
    if(n > max)
    80000dc4:	00d97363          	bgeu	s2,a3,80000dca <copyinstr+0x7a>
    80000dc8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000dca:	955e                	add	a0,a0,s7
    80000dcc:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000dce:	c695                	beqz	a3,80000dfa <copyinstr+0xaa>
    80000dd0:	87da                	mv	a5,s6
    80000dd2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000dd4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000dd8:	96da                	add	a3,a3,s6
    80000dda:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ddc:	00f60733          	add	a4,a2,a5
    80000de0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd0db8>
    80000de4:	db49                	beqz	a4,80000d76 <copyinstr+0x26>
        *dst = *p;
    80000de6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000dea:	0785                	addi	a5,a5,1
    while(n > 0){
    80000dec:	fed797e3          	bne	a5,a3,80000dda <copyinstr+0x8a>
    80000df0:	b765                	j	80000d98 <copyinstr+0x48>
    80000df2:	4781                	li	a5,0
    80000df4:	b761                	j	80000d7c <copyinstr+0x2c>
      return -1;
    80000df6:	557d                	li	a0,-1
    80000df8:	b769                	j	80000d82 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000dfa:	6b85                	lui	s7,0x1
    80000dfc:	9ba6                	add	s7,s7,s1
    80000dfe:	87da                	mv	a5,s6
    80000e00:	b76d                	j	80000daa <copyinstr+0x5a>
  int got_null = 0;
    80000e02:	4781                	li	a5,0
  if(got_null){
    80000e04:	37fd                	addiw	a5,a5,-1
    80000e06:	0007851b          	sext.w	a0,a5
}
    80000e0a:	8082                	ret

0000000080000e0c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e0c:	7139                	addi	sp,sp,-64
    80000e0e:	fc06                	sd	ra,56(sp)
    80000e10:	f822                	sd	s0,48(sp)
    80000e12:	f426                	sd	s1,40(sp)
    80000e14:	f04a                	sd	s2,32(sp)
    80000e16:	ec4e                	sd	s3,24(sp)
    80000e18:	e852                	sd	s4,16(sp)
    80000e1a:	e456                	sd	s5,8(sp)
    80000e1c:	e05a                	sd	s6,0(sp)
    80000e1e:	0080                	addi	s0,sp,64
    80000e20:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e22:	0000b497          	auipc	s1,0xb
    80000e26:	78e48493          	addi	s1,s1,1934 # 8000c5b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e2a:	8b26                	mv	s6,s1
    80000e2c:	ff4df937          	lui	s2,0xff4df
    80000e30:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b0775>
    80000e34:	0936                	slli	s2,s2,0xd
    80000e36:	6f590913          	addi	s2,s2,1781
    80000e3a:	0936                	slli	s2,s2,0xd
    80000e3c:	bd390913          	addi	s2,s2,-1069
    80000e40:	0932                	slli	s2,s2,0xc
    80000e42:	7a790913          	addi	s2,s2,1959
    80000e46:	040009b7          	lui	s3,0x4000
    80000e4a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e4c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4e:	00011a97          	auipc	s5,0x11
    80000e52:	362a8a93          	addi	s5,s5,866 # 800121b0 <tickslock>
    char *pa = kalloc();
    80000e56:	fffff097          	auipc	ra,0xfffff
    80000e5a:	32a080e7          	jalr	810(ra) # 80000180 <kalloc>
    80000e5e:	862a                	mv	a2,a0
    if(pa == 0)
    80000e60:	c121                	beqz	a0,80000ea0 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000e62:	416485b3          	sub	a1,s1,s6
    80000e66:	8591                	srai	a1,a1,0x4
    80000e68:	032585b3          	mul	a1,a1,s2
    80000e6c:	2585                	addiw	a1,a1,1
    80000e6e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e72:	4719                	li	a4,6
    80000e74:	6685                	lui	a3,0x1
    80000e76:	40b985b3          	sub	a1,s3,a1
    80000e7a:	8552                	mv	a0,s4
    80000e7c:	00000097          	auipc	ra,0x0
    80000e80:	87c080e7          	jalr	-1924(ra) # 800006f8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e84:	17048493          	addi	s1,s1,368
    80000e88:	fd5497e3          	bne	s1,s5,80000e56 <proc_mapstacks+0x4a>
  }
}
    80000e8c:	70e2                	ld	ra,56(sp)
    80000e8e:	7442                	ld	s0,48(sp)
    80000e90:	74a2                	ld	s1,40(sp)
    80000e92:	7902                	ld	s2,32(sp)
    80000e94:	69e2                	ld	s3,24(sp)
    80000e96:	6a42                	ld	s4,16(sp)
    80000e98:	6aa2                	ld	s5,8(sp)
    80000e9a:	6b02                	ld	s6,0(sp)
    80000e9c:	6121                	addi	sp,sp,64
    80000e9e:	8082                	ret
      panic("kalloc");
    80000ea0:	00007517          	auipc	a0,0x7
    80000ea4:	2b850513          	addi	a0,a0,696 # 80008158 <etext+0x158>
    80000ea8:	00005097          	auipc	ra,0x5
    80000eac:	34e080e7          	jalr	846(ra) # 800061f6 <panic>

0000000080000eb0 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000eb0:	7139                	addi	sp,sp,-64
    80000eb2:	fc06                	sd	ra,56(sp)
    80000eb4:	f822                	sd	s0,48(sp)
    80000eb6:	f426                	sd	s1,40(sp)
    80000eb8:	f04a                	sd	s2,32(sp)
    80000eba:	ec4e                	sd	s3,24(sp)
    80000ebc:	e852                	sd	s4,16(sp)
    80000ebe:	e456                	sd	s5,8(sp)
    80000ec0:	e05a                	sd	s6,0(sp)
    80000ec2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ec4:	00007597          	auipc	a1,0x7
    80000ec8:	29c58593          	addi	a1,a1,668 # 80008160 <etext+0x160>
    80000ecc:	0000b517          	auipc	a0,0xb
    80000ed0:	2a450513          	addi	a0,a0,676 # 8000c170 <pid_lock>
    80000ed4:	00006097          	auipc	ra,0x6
    80000ed8:	9fa080e7          	jalr	-1542(ra) # 800068ce <initlock>
  initlock(&wait_lock, "wait_lock");
    80000edc:	00007597          	auipc	a1,0x7
    80000ee0:	28c58593          	addi	a1,a1,652 # 80008168 <etext+0x168>
    80000ee4:	0000b517          	auipc	a0,0xb
    80000ee8:	2ac50513          	addi	a0,a0,684 # 8000c190 <wait_lock>
    80000eec:	00006097          	auipc	ra,0x6
    80000ef0:	9e2080e7          	jalr	-1566(ra) # 800068ce <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef4:	0000b497          	auipc	s1,0xb
    80000ef8:	6bc48493          	addi	s1,s1,1724 # 8000c5b0 <proc>
      initlock(&p->lock, "proc");
    80000efc:	00007b17          	auipc	s6,0x7
    80000f00:	27cb0b13          	addi	s6,s6,636 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000f04:	8aa6                	mv	s5,s1
    80000f06:	ff4df937          	lui	s2,0xff4df
    80000f0a:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b0775>
    80000f0e:	0936                	slli	s2,s2,0xd
    80000f10:	6f590913          	addi	s2,s2,1781
    80000f14:	0936                	slli	s2,s2,0xd
    80000f16:	bd390913          	addi	s2,s2,-1069
    80000f1a:	0932                	slli	s2,s2,0xc
    80000f1c:	7a790913          	addi	s2,s2,1959
    80000f20:	040009b7          	lui	s3,0x4000
    80000f24:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f26:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f28:	00011a17          	auipc	s4,0x11
    80000f2c:	288a0a13          	addi	s4,s4,648 # 800121b0 <tickslock>
      initlock(&p->lock, "proc");
    80000f30:	85da                	mv	a1,s6
    80000f32:	8526                	mv	a0,s1
    80000f34:	00006097          	auipc	ra,0x6
    80000f38:	99a080e7          	jalr	-1638(ra) # 800068ce <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f3c:	415487b3          	sub	a5,s1,s5
    80000f40:	8791                	srai	a5,a5,0x4
    80000f42:	032787b3          	mul	a5,a5,s2
    80000f46:	2785                	addiw	a5,a5,1
    80000f48:	00d7979b          	slliw	a5,a5,0xd
    80000f4c:	40f987b3          	sub	a5,s3,a5
    80000f50:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f52:	17048493          	addi	s1,s1,368
    80000f56:	fd449de3          	bne	s1,s4,80000f30 <procinit+0x80>
  }
}
    80000f5a:	70e2                	ld	ra,56(sp)
    80000f5c:	7442                	ld	s0,48(sp)
    80000f5e:	74a2                	ld	s1,40(sp)
    80000f60:	7902                	ld	s2,32(sp)
    80000f62:	69e2                	ld	s3,24(sp)
    80000f64:	6a42                	ld	s4,16(sp)
    80000f66:	6aa2                	ld	s5,8(sp)
    80000f68:	6b02                	ld	s6,0(sp)
    80000f6a:	6121                	addi	sp,sp,64
    80000f6c:	8082                	ret

0000000080000f6e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f6e:	1141                	addi	sp,sp,-16
    80000f70:	e422                	sd	s0,8(sp)
    80000f72:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f74:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f76:	2501                	sext.w	a0,a0
    80000f78:	6422                	ld	s0,8(sp)
    80000f7a:	0141                	addi	sp,sp,16
    80000f7c:	8082                	ret

0000000080000f7e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f7e:	1141                	addi	sp,sp,-16
    80000f80:	e422                	sd	s0,8(sp)
    80000f82:	0800                	addi	s0,sp,16
    80000f84:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f86:	2781                	sext.w	a5,a5
    80000f88:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f8a:	0000b517          	auipc	a0,0xb
    80000f8e:	22650513          	addi	a0,a0,550 # 8000c1b0 <cpus>
    80000f92:	953e                	add	a0,a0,a5
    80000f94:	6422                	ld	s0,8(sp)
    80000f96:	0141                	addi	sp,sp,16
    80000f98:	8082                	ret

0000000080000f9a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f9a:	1101                	addi	sp,sp,-32
    80000f9c:	ec06                	sd	ra,24(sp)
    80000f9e:	e822                	sd	s0,16(sp)
    80000fa0:	e426                	sd	s1,8(sp)
    80000fa2:	1000                	addi	s0,sp,32
  push_off();
    80000fa4:	00005097          	auipc	ra,0x5
    80000fa8:	76a080e7          	jalr	1898(ra) # 8000670e <push_off>
    80000fac:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fae:	2781                	sext.w	a5,a5
    80000fb0:	079e                	slli	a5,a5,0x7
    80000fb2:	0000b717          	auipc	a4,0xb
    80000fb6:	1be70713          	addi	a4,a4,446 # 8000c170 <pid_lock>
    80000fba:	97ba                	add	a5,a5,a4
    80000fbc:	63a4                	ld	s1,64(a5)
  pop_off();
    80000fbe:	00006097          	auipc	ra,0x6
    80000fc2:	804080e7          	jalr	-2044(ra) # 800067c2 <pop_off>
  return p;
}
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	60e2                	ld	ra,24(sp)
    80000fca:	6442                	ld	s0,16(sp)
    80000fcc:	64a2                	ld	s1,8(sp)
    80000fce:	6105                	addi	sp,sp,32
    80000fd0:	8082                	ret

0000000080000fd2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fd2:	1141                	addi	sp,sp,-16
    80000fd4:	e406                	sd	ra,8(sp)
    80000fd6:	e022                	sd	s0,0(sp)
    80000fd8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fda:	00000097          	auipc	ra,0x0
    80000fde:	fc0080e7          	jalr	-64(ra) # 80000f9a <myproc>
    80000fe2:	00006097          	auipc	ra,0x6
    80000fe6:	840080e7          	jalr	-1984(ra) # 80006822 <release>

  if (first) {
    80000fea:	0000a797          	auipc	a5,0xa
    80000fee:	3b67a783          	lw	a5,950(a5) # 8000b3a0 <first.1>
    80000ff2:	eb89                	bnez	a5,80001004 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ff4:	00001097          	auipc	ra,0x1
    80000ff8:	c16080e7          	jalr	-1002(ra) # 80001c0a <usertrapret>
}
    80000ffc:	60a2                	ld	ra,8(sp)
    80000ffe:	6402                	ld	s0,0(sp)
    80001000:	0141                	addi	sp,sp,16
    80001002:	8082                	ret
    first = 0;
    80001004:	0000a797          	auipc	a5,0xa
    80001008:	3807ae23          	sw	zero,924(a5) # 8000b3a0 <first.1>
    fsinit(ROOTDEV);
    8000100c:	4505                	li	a0,1
    8000100e:	00002097          	auipc	ra,0x2
    80001012:	a82080e7          	jalr	-1406(ra) # 80002a90 <fsinit>
    80001016:	bff9                	j	80000ff4 <forkret+0x22>

0000000080001018 <allocpid>:
allocpid() {
    80001018:	1101                	addi	sp,sp,-32
    8000101a:	ec06                	sd	ra,24(sp)
    8000101c:	e822                	sd	s0,16(sp)
    8000101e:	e426                	sd	s1,8(sp)
    80001020:	e04a                	sd	s2,0(sp)
    80001022:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001024:	0000b917          	auipc	s2,0xb
    80001028:	14c90913          	addi	s2,s2,332 # 8000c170 <pid_lock>
    8000102c:	854a                	mv	a0,s2
    8000102e:	00005097          	auipc	ra,0x5
    80001032:	72c080e7          	jalr	1836(ra) # 8000675a <acquire>
  pid = nextpid;
    80001036:	0000a797          	auipc	a5,0xa
    8000103a:	36e78793          	addi	a5,a5,878 # 8000b3a4 <nextpid>
    8000103e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001040:	0014871b          	addiw	a4,s1,1
    80001044:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001046:	854a                	mv	a0,s2
    80001048:	00005097          	auipc	ra,0x5
    8000104c:	7da080e7          	jalr	2010(ra) # 80006822 <release>
}
    80001050:	8526                	mv	a0,s1
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6902                	ld	s2,0(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret

000000008000105e <proc_pagetable>:
{
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	e04a                	sd	s2,0(sp)
    80001068:	1000                	addi	s0,sp,32
    8000106a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000106c:	00000097          	auipc	ra,0x0
    80001070:	886080e7          	jalr	-1914(ra) # 800008f2 <uvmcreate>
    80001074:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001076:	c121                	beqz	a0,800010b6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001078:	4729                	li	a4,10
    8000107a:	00006697          	auipc	a3,0x6
    8000107e:	f8668693          	addi	a3,a3,-122 # 80007000 <_trampoline>
    80001082:	6605                	lui	a2,0x1
    80001084:	040005b7          	lui	a1,0x4000
    80001088:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000108a:	05b2                	slli	a1,a1,0xc
    8000108c:	fffff097          	auipc	ra,0xfffff
    80001090:	5cc080e7          	jalr	1484(ra) # 80000658 <mappages>
    80001094:	02054863          	bltz	a0,800010c4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001098:	4719                	li	a4,6
    8000109a:	06093683          	ld	a3,96(s2)
    8000109e:	6605                	lui	a2,0x1
    800010a0:	020005b7          	lui	a1,0x2000
    800010a4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010a6:	05b6                	slli	a1,a1,0xd
    800010a8:	8526                	mv	a0,s1
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	5ae080e7          	jalr	1454(ra) # 80000658 <mappages>
    800010b2:	02054163          	bltz	a0,800010d4 <proc_pagetable+0x76>
}
    800010b6:	8526                	mv	a0,s1
    800010b8:	60e2                	ld	ra,24(sp)
    800010ba:	6442                	ld	s0,16(sp)
    800010bc:	64a2                	ld	s1,8(sp)
    800010be:	6902                	ld	s2,0(sp)
    800010c0:	6105                	addi	sp,sp,32
    800010c2:	8082                	ret
    uvmfree(pagetable, 0);
    800010c4:	4581                	li	a1,0
    800010c6:	8526                	mv	a0,s1
    800010c8:	00000097          	auipc	ra,0x0
    800010cc:	a30080e7          	jalr	-1488(ra) # 80000af8 <uvmfree>
    return 0;
    800010d0:	4481                	li	s1,0
    800010d2:	b7d5                	j	800010b6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010d4:	4681                	li	a3,0
    800010d6:	4605                	li	a2,1
    800010d8:	040005b7          	lui	a1,0x4000
    800010dc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010de:	05b2                	slli	a1,a1,0xc
    800010e0:	8526                	mv	a0,s1
    800010e2:	fffff097          	auipc	ra,0xfffff
    800010e6:	73c080e7          	jalr	1852(ra) # 8000081e <uvmunmap>
    uvmfree(pagetable, 0);
    800010ea:	4581                	li	a1,0
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	a0a080e7          	jalr	-1526(ra) # 80000af8 <uvmfree>
    return 0;
    800010f6:	4481                	li	s1,0
    800010f8:	bf7d                	j	800010b6 <proc_pagetable+0x58>

00000000800010fa <proc_freepagetable>:
{
    800010fa:	1101                	addi	sp,sp,-32
    800010fc:	ec06                	sd	ra,24(sp)
    800010fe:	e822                	sd	s0,16(sp)
    80001100:	e426                	sd	s1,8(sp)
    80001102:	e04a                	sd	s2,0(sp)
    80001104:	1000                	addi	s0,sp,32
    80001106:	84aa                	mv	s1,a0
    80001108:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000110a:	4681                	li	a3,0
    8000110c:	4605                	li	a2,1
    8000110e:	040005b7          	lui	a1,0x4000
    80001112:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001114:	05b2                	slli	a1,a1,0xc
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	708080e7          	jalr	1800(ra) # 8000081e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000111e:	4681                	li	a3,0
    80001120:	4605                	li	a2,1
    80001122:	020005b7          	lui	a1,0x2000
    80001126:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001128:	05b6                	slli	a1,a1,0xd
    8000112a:	8526                	mv	a0,s1
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	6f2080e7          	jalr	1778(ra) # 8000081e <uvmunmap>
  uvmfree(pagetable, sz);
    80001134:	85ca                	mv	a1,s2
    80001136:	8526                	mv	a0,s1
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	9c0080e7          	jalr	-1600(ra) # 80000af8 <uvmfree>
}
    80001140:	60e2                	ld	ra,24(sp)
    80001142:	6442                	ld	s0,16(sp)
    80001144:	64a2                	ld	s1,8(sp)
    80001146:	6902                	ld	s2,0(sp)
    80001148:	6105                	addi	sp,sp,32
    8000114a:	8082                	ret

000000008000114c <freeproc>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	1000                	addi	s0,sp,32
    80001156:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001158:	7128                	ld	a0,96(a0)
    8000115a:	c509                	beqz	a0,80001164 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	ec0080e7          	jalr	-320(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001164:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001168:	6ca8                	ld	a0,88(s1)
    8000116a:	c511                	beqz	a0,80001176 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000116c:	68ac                	ld	a1,80(s1)
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f8c080e7          	jalr	-116(ra) # 800010fa <proc_freepagetable>
  p->pagetable = 0;
    80001176:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    8000117a:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000117e:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001182:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001186:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    8000118a:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000118e:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001192:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001196:	0204a023          	sw	zero,32(s1)
}
    8000119a:	60e2                	ld	ra,24(sp)
    8000119c:	6442                	ld	s0,16(sp)
    8000119e:	64a2                	ld	s1,8(sp)
    800011a0:	6105                	addi	sp,sp,32
    800011a2:	8082                	ret

00000000800011a4 <allocproc>:
{
    800011a4:	1101                	addi	sp,sp,-32
    800011a6:	ec06                	sd	ra,24(sp)
    800011a8:	e822                	sd	s0,16(sp)
    800011aa:	e426                	sd	s1,8(sp)
    800011ac:	e04a                	sd	s2,0(sp)
    800011ae:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011b0:	0000b497          	auipc	s1,0xb
    800011b4:	40048493          	addi	s1,s1,1024 # 8000c5b0 <proc>
    800011b8:	00011917          	auipc	s2,0x11
    800011bc:	ff890913          	addi	s2,s2,-8 # 800121b0 <tickslock>
    acquire(&p->lock);
    800011c0:	8526                	mv	a0,s1
    800011c2:	00005097          	auipc	ra,0x5
    800011c6:	598080e7          	jalr	1432(ra) # 8000675a <acquire>
    if(p->state == UNUSED) {
    800011ca:	509c                	lw	a5,32(s1)
    800011cc:	cf81                	beqz	a5,800011e4 <allocproc+0x40>
      release(&p->lock);
    800011ce:	8526                	mv	a0,s1
    800011d0:	00005097          	auipc	ra,0x5
    800011d4:	652080e7          	jalr	1618(ra) # 80006822 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d8:	17048493          	addi	s1,s1,368
    800011dc:	ff2492e3          	bne	s1,s2,800011c0 <allocproc+0x1c>
  return 0;
    800011e0:	4481                	li	s1,0
    800011e2:	a889                	j	80001234 <allocproc+0x90>
  p->pid = allocpid();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	e34080e7          	jalr	-460(ra) # 80001018 <allocpid>
    800011ec:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011ee:	4785                	li	a5,1
    800011f0:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	f8e080e7          	jalr	-114(ra) # 80000180 <kalloc>
    800011fa:	892a                	mv	s2,a0
    800011fc:	f0a8                	sd	a0,96(s1)
    800011fe:	c131                	beqz	a0,80001242 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001200:	8526                	mv	a0,s1
    80001202:	00000097          	auipc	ra,0x0
    80001206:	e5c080e7          	jalr	-420(ra) # 8000105e <proc_pagetable>
    8000120a:	892a                	mv	s2,a0
    8000120c:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    8000120e:	c531                	beqz	a0,8000125a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001210:	07000613          	li	a2,112
    80001214:	4581                	li	a1,0
    80001216:	06848513          	addi	a0,s1,104
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	06e080e7          	jalr	110(ra) # 80000288 <memset>
  p->context.ra = (uint64)forkret;
    80001222:	00000797          	auipc	a5,0x0
    80001226:	db078793          	addi	a5,a5,-592 # 80000fd2 <forkret>
    8000122a:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000122c:	64bc                	ld	a5,72(s1)
    8000122e:	6705                	lui	a4,0x1
    80001230:	97ba                	add	a5,a5,a4
    80001232:	f8bc                	sd	a5,112(s1)
}
    80001234:	8526                	mv	a0,s1
    80001236:	60e2                	ld	ra,24(sp)
    80001238:	6442                	ld	s0,16(sp)
    8000123a:	64a2                	ld	s1,8(sp)
    8000123c:	6902                	ld	s2,0(sp)
    8000123e:	6105                	addi	sp,sp,32
    80001240:	8082                	ret
    freeproc(p);
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	f08080e7          	jalr	-248(ra) # 8000114c <freeproc>
    release(&p->lock);
    8000124c:	8526                	mv	a0,s1
    8000124e:	00005097          	auipc	ra,0x5
    80001252:	5d4080e7          	jalr	1492(ra) # 80006822 <release>
    return 0;
    80001256:	84ca                	mv	s1,s2
    80001258:	bff1                	j	80001234 <allocproc+0x90>
    freeproc(p);
    8000125a:	8526                	mv	a0,s1
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	ef0080e7          	jalr	-272(ra) # 8000114c <freeproc>
    release(&p->lock);
    80001264:	8526                	mv	a0,s1
    80001266:	00005097          	auipc	ra,0x5
    8000126a:	5bc080e7          	jalr	1468(ra) # 80006822 <release>
    return 0;
    8000126e:	84ca                	mv	s1,s2
    80001270:	b7d1                	j	80001234 <allocproc+0x90>

0000000080001272 <userinit>:
{
    80001272:	1101                	addi	sp,sp,-32
    80001274:	ec06                	sd	ra,24(sp)
    80001276:	e822                	sd	s0,16(sp)
    80001278:	e426                	sd	s1,8(sp)
    8000127a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	f28080e7          	jalr	-216(ra) # 800011a4 <allocproc>
    80001284:	84aa                	mv	s1,a0
  initproc = p;
    80001286:	0000b797          	auipc	a5,0xb
    8000128a:	d8a7b523          	sd	a0,-630(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000128e:	03400613          	li	a2,52
    80001292:	0000a597          	auipc	a1,0xa
    80001296:	11e58593          	addi	a1,a1,286 # 8000b3b0 <initcode>
    8000129a:	6d28                	ld	a0,88(a0)
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	684080e7          	jalr	1668(ra) # 80000920 <uvminit>
  p->sz = PGSIZE;
    800012a4:	6785                	lui	a5,0x1
    800012a6:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800012a8:	70b8                	ld	a4,96(s1)
    800012aa:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012ae:	70b8                	ld	a4,96(s1)
    800012b0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012b2:	4641                	li	a2,16
    800012b4:	00007597          	auipc	a1,0x7
    800012b8:	ecc58593          	addi	a1,a1,-308 # 80008180 <etext+0x180>
    800012bc:	16048513          	addi	a0,s1,352
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	10a080e7          	jalr	266(ra) # 800003ca <safestrcpy>
  p->cwd = namei("/");
    800012c8:	00007517          	auipc	a0,0x7
    800012cc:	ec850513          	addi	a0,a0,-312 # 80008190 <etext+0x190>
    800012d0:	00002097          	auipc	ra,0x2
    800012d4:	206080e7          	jalr	518(ra) # 800034d6 <namei>
    800012d8:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012dc:	478d                	li	a5,3
    800012de:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800012e0:	8526                	mv	a0,s1
    800012e2:	00005097          	auipc	ra,0x5
    800012e6:	540080e7          	jalr	1344(ra) # 80006822 <release>
}
    800012ea:	60e2                	ld	ra,24(sp)
    800012ec:	6442                	ld	s0,16(sp)
    800012ee:	64a2                	ld	s1,8(sp)
    800012f0:	6105                	addi	sp,sp,32
    800012f2:	8082                	ret

00000000800012f4 <growproc>:
{
    800012f4:	1101                	addi	sp,sp,-32
    800012f6:	ec06                	sd	ra,24(sp)
    800012f8:	e822                	sd	s0,16(sp)
    800012fa:	e426                	sd	s1,8(sp)
    800012fc:	e04a                	sd	s2,0(sp)
    800012fe:	1000                	addi	s0,sp,32
    80001300:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001302:	00000097          	auipc	ra,0x0
    80001306:	c98080e7          	jalr	-872(ra) # 80000f9a <myproc>
    8000130a:	892a                	mv	s2,a0
  sz = p->sz;
    8000130c:	692c                	ld	a1,80(a0)
    8000130e:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001312:	00904f63          	bgtz	s1,80001330 <growproc+0x3c>
  } else if(n < 0){
    80001316:	0204cd63          	bltz	s1,80001350 <growproc+0x5c>
  p->sz = sz;
    8000131a:	1782                	slli	a5,a5,0x20
    8000131c:	9381                	srli	a5,a5,0x20
    8000131e:	04f93823          	sd	a5,80(s2)
  return 0;
    80001322:	4501                	li	a0,0
}
    80001324:	60e2                	ld	ra,24(sp)
    80001326:	6442                	ld	s0,16(sp)
    80001328:	64a2                	ld	s1,8(sp)
    8000132a:	6902                	ld	s2,0(sp)
    8000132c:	6105                	addi	sp,sp,32
    8000132e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001330:	00f4863b          	addw	a2,s1,a5
    80001334:	1602                	slli	a2,a2,0x20
    80001336:	9201                	srli	a2,a2,0x20
    80001338:	1582                	slli	a1,a1,0x20
    8000133a:	9181                	srli	a1,a1,0x20
    8000133c:	6d28                	ld	a0,88(a0)
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	69c080e7          	jalr	1692(ra) # 800009da <uvmalloc>
    80001346:	0005079b          	sext.w	a5,a0
    8000134a:	fbe1                	bnez	a5,8000131a <growproc+0x26>
      return -1;
    8000134c:	557d                	li	a0,-1
    8000134e:	bfd9                	j	80001324 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001350:	00f4863b          	addw	a2,s1,a5
    80001354:	1602                	slli	a2,a2,0x20
    80001356:	9201                	srli	a2,a2,0x20
    80001358:	1582                	slli	a1,a1,0x20
    8000135a:	9181                	srli	a1,a1,0x20
    8000135c:	6d28                	ld	a0,88(a0)
    8000135e:	fffff097          	auipc	ra,0xfffff
    80001362:	634080e7          	jalr	1588(ra) # 80000992 <uvmdealloc>
    80001366:	0005079b          	sext.w	a5,a0
    8000136a:	bf45                	j	8000131a <growproc+0x26>

000000008000136c <fork>:
{
    8000136c:	7139                	addi	sp,sp,-64
    8000136e:	fc06                	sd	ra,56(sp)
    80001370:	f822                	sd	s0,48(sp)
    80001372:	f04a                	sd	s2,32(sp)
    80001374:	e456                	sd	s5,8(sp)
    80001376:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001378:	00000097          	auipc	ra,0x0
    8000137c:	c22080e7          	jalr	-990(ra) # 80000f9a <myproc>
    80001380:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001382:	00000097          	auipc	ra,0x0
    80001386:	e22080e7          	jalr	-478(ra) # 800011a4 <allocproc>
    8000138a:	12050063          	beqz	a0,800014aa <fork+0x13e>
    8000138e:	e852                	sd	s4,16(sp)
    80001390:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001392:	050ab603          	ld	a2,80(s5)
    80001396:	6d2c                	ld	a1,88(a0)
    80001398:	058ab503          	ld	a0,88(s5)
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	796080e7          	jalr	1942(ra) # 80000b32 <uvmcopy>
    800013a4:	04054a63          	bltz	a0,800013f8 <fork+0x8c>
    800013a8:	f426                	sd	s1,40(sp)
    800013aa:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800013ac:	050ab783          	ld	a5,80(s5)
    800013b0:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    800013b4:	060ab683          	ld	a3,96(s5)
    800013b8:	87b6                	mv	a5,a3
    800013ba:	060a3703          	ld	a4,96(s4)
    800013be:	12068693          	addi	a3,a3,288
    800013c2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013c6:	6788                	ld	a0,8(a5)
    800013c8:	6b8c                	ld	a1,16(a5)
    800013ca:	6f90                	ld	a2,24(a5)
    800013cc:	01073023          	sd	a6,0(a4)
    800013d0:	e708                	sd	a0,8(a4)
    800013d2:	eb0c                	sd	a1,16(a4)
    800013d4:	ef10                	sd	a2,24(a4)
    800013d6:	02078793          	addi	a5,a5,32
    800013da:	02070713          	addi	a4,a4,32
    800013de:	fed792e3          	bne	a5,a3,800013c2 <fork+0x56>
  np->trapframe->a0 = 0;
    800013e2:	060a3783          	ld	a5,96(s4)
    800013e6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013ea:	0d8a8493          	addi	s1,s5,216
    800013ee:	0d8a0913          	addi	s2,s4,216
    800013f2:	158a8993          	addi	s3,s5,344
    800013f6:	a015                	j	8000141a <fork+0xae>
    freeproc(np);
    800013f8:	8552                	mv	a0,s4
    800013fa:	00000097          	auipc	ra,0x0
    800013fe:	d52080e7          	jalr	-686(ra) # 8000114c <freeproc>
    release(&np->lock);
    80001402:	8552                	mv	a0,s4
    80001404:	00005097          	auipc	ra,0x5
    80001408:	41e080e7          	jalr	1054(ra) # 80006822 <release>
    return -1;
    8000140c:	597d                	li	s2,-1
    8000140e:	6a42                	ld	s4,16(sp)
    80001410:	a071                	j	8000149c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001412:	04a1                	addi	s1,s1,8
    80001414:	0921                	addi	s2,s2,8
    80001416:	01348b63          	beq	s1,s3,8000142c <fork+0xc0>
    if(p->ofile[i])
    8000141a:	6088                	ld	a0,0(s1)
    8000141c:	d97d                	beqz	a0,80001412 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000141e:	00002097          	auipc	ra,0x2
    80001422:	730080e7          	jalr	1840(ra) # 80003b4e <filedup>
    80001426:	00a93023          	sd	a0,0(s2)
    8000142a:	b7e5                	j	80001412 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000142c:	158ab503          	ld	a0,344(s5)
    80001430:	00002097          	auipc	ra,0x2
    80001434:	896080e7          	jalr	-1898(ra) # 80002cc6 <idup>
    80001438:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000143c:	4641                	li	a2,16
    8000143e:	160a8593          	addi	a1,s5,352
    80001442:	160a0513          	addi	a0,s4,352
    80001446:	fffff097          	auipc	ra,0xfffff
    8000144a:	f84080e7          	jalr	-124(ra) # 800003ca <safestrcpy>
  pid = np->pid;
    8000144e:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    80001452:	8552                	mv	a0,s4
    80001454:	00005097          	auipc	ra,0x5
    80001458:	3ce080e7          	jalr	974(ra) # 80006822 <release>
  acquire(&wait_lock);
    8000145c:	0000b497          	auipc	s1,0xb
    80001460:	d3448493          	addi	s1,s1,-716 # 8000c190 <wait_lock>
    80001464:	8526                	mv	a0,s1
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	2f4080e7          	jalr	756(ra) # 8000675a <acquire>
  np->parent = p;
    8000146e:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001472:	8526                	mv	a0,s1
    80001474:	00005097          	auipc	ra,0x5
    80001478:	3ae080e7          	jalr	942(ra) # 80006822 <release>
  acquire(&np->lock);
    8000147c:	8552                	mv	a0,s4
    8000147e:	00005097          	auipc	ra,0x5
    80001482:	2dc080e7          	jalr	732(ra) # 8000675a <acquire>
  np->state = RUNNABLE;
    80001486:	478d                	li	a5,3
    80001488:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    8000148c:	8552                	mv	a0,s4
    8000148e:	00005097          	auipc	ra,0x5
    80001492:	394080e7          	jalr	916(ra) # 80006822 <release>
  return pid;
    80001496:	74a2                	ld	s1,40(sp)
    80001498:	69e2                	ld	s3,24(sp)
    8000149a:	6a42                	ld	s4,16(sp)
}
    8000149c:	854a                	mv	a0,s2
    8000149e:	70e2                	ld	ra,56(sp)
    800014a0:	7442                	ld	s0,48(sp)
    800014a2:	7902                	ld	s2,32(sp)
    800014a4:	6aa2                	ld	s5,8(sp)
    800014a6:	6121                	addi	sp,sp,64
    800014a8:	8082                	ret
    return -1;
    800014aa:	597d                	li	s2,-1
    800014ac:	bfc5                	j	8000149c <fork+0x130>

00000000800014ae <scheduler>:
{
    800014ae:	7139                	addi	sp,sp,-64
    800014b0:	fc06                	sd	ra,56(sp)
    800014b2:	f822                	sd	s0,48(sp)
    800014b4:	f426                	sd	s1,40(sp)
    800014b6:	f04a                	sd	s2,32(sp)
    800014b8:	ec4e                	sd	s3,24(sp)
    800014ba:	e852                	sd	s4,16(sp)
    800014bc:	e456                	sd	s5,8(sp)
    800014be:	e05a                	sd	s6,0(sp)
    800014c0:	0080                	addi	s0,sp,64
    800014c2:	8792                	mv	a5,tp
  int id = r_tp();
    800014c4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014c6:	00779a93          	slli	s5,a5,0x7
    800014ca:	0000b717          	auipc	a4,0xb
    800014ce:	ca670713          	addi	a4,a4,-858 # 8000c170 <pid_lock>
    800014d2:	9756                	add	a4,a4,s5
    800014d4:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    800014d8:	0000b717          	auipc	a4,0xb
    800014dc:	ce070713          	addi	a4,a4,-800 # 8000c1b8 <cpus+0x8>
    800014e0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014e2:	498d                	li	s3,3
        p->state = RUNNING;
    800014e4:	4b11                	li	s6,4
        c->proc = p;
    800014e6:	079e                	slli	a5,a5,0x7
    800014e8:	0000ba17          	auipc	s4,0xb
    800014ec:	c88a0a13          	addi	s4,s4,-888 # 8000c170 <pid_lock>
    800014f0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014f2:	00011917          	auipc	s2,0x11
    800014f6:	cbe90913          	addi	s2,s2,-834 # 800121b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014fe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001502:	10079073          	csrw	sstatus,a5
    80001506:	0000b497          	auipc	s1,0xb
    8000150a:	0aa48493          	addi	s1,s1,170 # 8000c5b0 <proc>
    8000150e:	a811                	j	80001522 <scheduler+0x74>
      release(&p->lock);
    80001510:	8526                	mv	a0,s1
    80001512:	00005097          	auipc	ra,0x5
    80001516:	310080e7          	jalr	784(ra) # 80006822 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000151a:	17048493          	addi	s1,s1,368
    8000151e:	fd248ee3          	beq	s1,s2,800014fa <scheduler+0x4c>
      acquire(&p->lock);
    80001522:	8526                	mv	a0,s1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	236080e7          	jalr	566(ra) # 8000675a <acquire>
      if(p->state == RUNNABLE) {
    8000152c:	509c                	lw	a5,32(s1)
    8000152e:	ff3791e3          	bne	a5,s3,80001510 <scheduler+0x62>
        p->state = RUNNING;
    80001532:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001536:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    8000153a:	06848593          	addi	a1,s1,104
    8000153e:	8556                	mv	a0,s5
    80001540:	00000097          	auipc	ra,0x0
    80001544:	620080e7          	jalr	1568(ra) # 80001b60 <swtch>
        c->proc = 0;
    80001548:	040a3023          	sd	zero,64(s4)
    8000154c:	b7d1                	j	80001510 <scheduler+0x62>

000000008000154e <sched>:
{
    8000154e:	7179                	addi	sp,sp,-48
    80001550:	f406                	sd	ra,40(sp)
    80001552:	f022                	sd	s0,32(sp)
    80001554:	ec26                	sd	s1,24(sp)
    80001556:	e84a                	sd	s2,16(sp)
    80001558:	e44e                	sd	s3,8(sp)
    8000155a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	a3e080e7          	jalr	-1474(ra) # 80000f9a <myproc>
    80001564:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	17a080e7          	jalr	378(ra) # 800066e0 <holding>
    8000156e:	c93d                	beqz	a0,800015e4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001570:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001572:	2781                	sext.w	a5,a5
    80001574:	079e                	slli	a5,a5,0x7
    80001576:	0000b717          	auipc	a4,0xb
    8000157a:	bfa70713          	addi	a4,a4,-1030 # 8000c170 <pid_lock>
    8000157e:	97ba                	add	a5,a5,a4
    80001580:	0b87a703          	lw	a4,184(a5)
    80001584:	4785                	li	a5,1
    80001586:	06f71763          	bne	a4,a5,800015f4 <sched+0xa6>
  if(p->state == RUNNING)
    8000158a:	5098                	lw	a4,32(s1)
    8000158c:	4791                	li	a5,4
    8000158e:	06f70b63          	beq	a4,a5,80001604 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001592:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001596:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001598:	efb5                	bnez	a5,80001614 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000159a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000159c:	0000b917          	auipc	s2,0xb
    800015a0:	bd490913          	addi	s2,s2,-1068 # 8000c170 <pid_lock>
    800015a4:	2781                	sext.w	a5,a5
    800015a6:	079e                	slli	a5,a5,0x7
    800015a8:	97ca                	add	a5,a5,s2
    800015aa:	0bc7a983          	lw	s3,188(a5)
    800015ae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015b0:	2781                	sext.w	a5,a5
    800015b2:	079e                	slli	a5,a5,0x7
    800015b4:	0000b597          	auipc	a1,0xb
    800015b8:	c0458593          	addi	a1,a1,-1020 # 8000c1b8 <cpus+0x8>
    800015bc:	95be                	add	a1,a1,a5
    800015be:	06848513          	addi	a0,s1,104
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	59e080e7          	jalr	1438(ra) # 80001b60 <swtch>
    800015ca:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015cc:	2781                	sext.w	a5,a5
    800015ce:	079e                	slli	a5,a5,0x7
    800015d0:	993e                	add	s2,s2,a5
    800015d2:	0b392e23          	sw	s3,188(s2)
}
    800015d6:	70a2                	ld	ra,40(sp)
    800015d8:	7402                	ld	s0,32(sp)
    800015da:	64e2                	ld	s1,24(sp)
    800015dc:	6942                	ld	s2,16(sp)
    800015de:	69a2                	ld	s3,8(sp)
    800015e0:	6145                	addi	sp,sp,48
    800015e2:	8082                	ret
    panic("sched p->lock");
    800015e4:	00007517          	auipc	a0,0x7
    800015e8:	bb450513          	addi	a0,a0,-1100 # 80008198 <etext+0x198>
    800015ec:	00005097          	auipc	ra,0x5
    800015f0:	c0a080e7          	jalr	-1014(ra) # 800061f6 <panic>
    panic("sched locks");
    800015f4:	00007517          	auipc	a0,0x7
    800015f8:	bb450513          	addi	a0,a0,-1100 # 800081a8 <etext+0x1a8>
    800015fc:	00005097          	auipc	ra,0x5
    80001600:	bfa080e7          	jalr	-1030(ra) # 800061f6 <panic>
    panic("sched running");
    80001604:	00007517          	auipc	a0,0x7
    80001608:	bb450513          	addi	a0,a0,-1100 # 800081b8 <etext+0x1b8>
    8000160c:	00005097          	auipc	ra,0x5
    80001610:	bea080e7          	jalr	-1046(ra) # 800061f6 <panic>
    panic("sched interruptible");
    80001614:	00007517          	auipc	a0,0x7
    80001618:	bb450513          	addi	a0,a0,-1100 # 800081c8 <etext+0x1c8>
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	bda080e7          	jalr	-1062(ra) # 800061f6 <panic>

0000000080001624 <yield>:
{
    80001624:	1101                	addi	sp,sp,-32
    80001626:	ec06                	sd	ra,24(sp)
    80001628:	e822                	sd	s0,16(sp)
    8000162a:	e426                	sd	s1,8(sp)
    8000162c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	96c080e7          	jalr	-1684(ra) # 80000f9a <myproc>
    80001636:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001638:	00005097          	auipc	ra,0x5
    8000163c:	122080e7          	jalr	290(ra) # 8000675a <acquire>
  p->state = RUNNABLE;
    80001640:	478d                	li	a5,3
    80001642:	d09c                	sw	a5,32(s1)
  sched();
    80001644:	00000097          	auipc	ra,0x0
    80001648:	f0a080e7          	jalr	-246(ra) # 8000154e <sched>
  release(&p->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	1d4080e7          	jalr	468(ra) # 80006822 <release>
}
    80001656:	60e2                	ld	ra,24(sp)
    80001658:	6442                	ld	s0,16(sp)
    8000165a:	64a2                	ld	s1,8(sp)
    8000165c:	6105                	addi	sp,sp,32
    8000165e:	8082                	ret

0000000080001660 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001660:	7179                	addi	sp,sp,-48
    80001662:	f406                	sd	ra,40(sp)
    80001664:	f022                	sd	s0,32(sp)
    80001666:	ec26                	sd	s1,24(sp)
    80001668:	e84a                	sd	s2,16(sp)
    8000166a:	e44e                	sd	s3,8(sp)
    8000166c:	1800                	addi	s0,sp,48
    8000166e:	89aa                	mv	s3,a0
    80001670:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001672:	00000097          	auipc	ra,0x0
    80001676:	928080e7          	jalr	-1752(ra) # 80000f9a <myproc>
    8000167a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	0de080e7          	jalr	222(ra) # 8000675a <acquire>
  release(lk);
    80001684:	854a                	mv	a0,s2
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	19c080e7          	jalr	412(ra) # 80006822 <release>

  // Go to sleep.
  p->chan = chan;
    8000168e:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001692:	4789                	li	a5,2
    80001694:	d09c                	sw	a5,32(s1)

  sched();
    80001696:	00000097          	auipc	ra,0x0
    8000169a:	eb8080e7          	jalr	-328(ra) # 8000154e <sched>

  // Tidy up.
  p->chan = 0;
    8000169e:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	17e080e7          	jalr	382(ra) # 80006822 <release>
  acquire(lk);
    800016ac:	854a                	mv	a0,s2
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	0ac080e7          	jalr	172(ra) # 8000675a <acquire>
}
    800016b6:	70a2                	ld	ra,40(sp)
    800016b8:	7402                	ld	s0,32(sp)
    800016ba:	64e2                	ld	s1,24(sp)
    800016bc:	6942                	ld	s2,16(sp)
    800016be:	69a2                	ld	s3,8(sp)
    800016c0:	6145                	addi	sp,sp,48
    800016c2:	8082                	ret

00000000800016c4 <wait>:
{
    800016c4:	715d                	addi	sp,sp,-80
    800016c6:	e486                	sd	ra,72(sp)
    800016c8:	e0a2                	sd	s0,64(sp)
    800016ca:	fc26                	sd	s1,56(sp)
    800016cc:	f84a                	sd	s2,48(sp)
    800016ce:	f44e                	sd	s3,40(sp)
    800016d0:	f052                	sd	s4,32(sp)
    800016d2:	ec56                	sd	s5,24(sp)
    800016d4:	e85a                	sd	s6,16(sp)
    800016d6:	e45e                	sd	s7,8(sp)
    800016d8:	e062                	sd	s8,0(sp)
    800016da:	0880                	addi	s0,sp,80
    800016dc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	8bc080e7          	jalr	-1860(ra) # 80000f9a <myproc>
    800016e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016e8:	0000b517          	auipc	a0,0xb
    800016ec:	aa850513          	addi	a0,a0,-1368 # 8000c190 <wait_lock>
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	06a080e7          	jalr	106(ra) # 8000675a <acquire>
    havekids = 0;
    800016f8:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016fa:	4a15                	li	s4,5
        havekids = 1;
    800016fc:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800016fe:	00011997          	auipc	s3,0x11
    80001702:	ab298993          	addi	s3,s3,-1358 # 800121b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001706:	0000bc17          	auipc	s8,0xb
    8000170a:	a8ac0c13          	addi	s8,s8,-1398 # 8000c190 <wait_lock>
    8000170e:	a87d                	j	800017cc <wait+0x108>
          pid = np->pid;
    80001710:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001714:	000b0e63          	beqz	s6,80001730 <wait+0x6c>
    80001718:	4691                	li	a3,4
    8000171a:	03448613          	addi	a2,s1,52
    8000171e:	85da                	mv	a1,s6
    80001720:	05893503          	ld	a0,88(s2)
    80001724:	fffff097          	auipc	ra,0xfffff
    80001728:	512080e7          	jalr	1298(ra) # 80000c36 <copyout>
    8000172c:	04054163          	bltz	a0,8000176e <wait+0xaa>
          freeproc(np);
    80001730:	8526                	mv	a0,s1
    80001732:	00000097          	auipc	ra,0x0
    80001736:	a1a080e7          	jalr	-1510(ra) # 8000114c <freeproc>
          release(&np->lock);
    8000173a:	8526                	mv	a0,s1
    8000173c:	00005097          	auipc	ra,0x5
    80001740:	0e6080e7          	jalr	230(ra) # 80006822 <release>
          release(&wait_lock);
    80001744:	0000b517          	auipc	a0,0xb
    80001748:	a4c50513          	addi	a0,a0,-1460 # 8000c190 <wait_lock>
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	0d6080e7          	jalr	214(ra) # 80006822 <release>
}
    80001754:	854e                	mv	a0,s3
    80001756:	60a6                	ld	ra,72(sp)
    80001758:	6406                	ld	s0,64(sp)
    8000175a:	74e2                	ld	s1,56(sp)
    8000175c:	7942                	ld	s2,48(sp)
    8000175e:	79a2                	ld	s3,40(sp)
    80001760:	7a02                	ld	s4,32(sp)
    80001762:	6ae2                	ld	s5,24(sp)
    80001764:	6b42                	ld	s6,16(sp)
    80001766:	6ba2                	ld	s7,8(sp)
    80001768:	6c02                	ld	s8,0(sp)
    8000176a:	6161                	addi	sp,sp,80
    8000176c:	8082                	ret
            release(&np->lock);
    8000176e:	8526                	mv	a0,s1
    80001770:	00005097          	auipc	ra,0x5
    80001774:	0b2080e7          	jalr	178(ra) # 80006822 <release>
            release(&wait_lock);
    80001778:	0000b517          	auipc	a0,0xb
    8000177c:	a1850513          	addi	a0,a0,-1512 # 8000c190 <wait_lock>
    80001780:	00005097          	auipc	ra,0x5
    80001784:	0a2080e7          	jalr	162(ra) # 80006822 <release>
            return -1;
    80001788:	59fd                	li	s3,-1
    8000178a:	b7e9                	j	80001754 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000178c:	17048493          	addi	s1,s1,368
    80001790:	03348463          	beq	s1,s3,800017b8 <wait+0xf4>
      if(np->parent == p){
    80001794:	60bc                	ld	a5,64(s1)
    80001796:	ff279be3          	bne	a5,s2,8000178c <wait+0xc8>
        acquire(&np->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	fbe080e7          	jalr	-66(ra) # 8000675a <acquire>
        if(np->state == ZOMBIE){
    800017a4:	509c                	lw	a5,32(s1)
    800017a6:	f74785e3          	beq	a5,s4,80001710 <wait+0x4c>
        release(&np->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	076080e7          	jalr	118(ra) # 80006822 <release>
        havekids = 1;
    800017b4:	8756                	mv	a4,s5
    800017b6:	bfd9                	j	8000178c <wait+0xc8>
    if(!havekids || p->killed){
    800017b8:	c305                	beqz	a4,800017d8 <wait+0x114>
    800017ba:	03092783          	lw	a5,48(s2)
    800017be:	ef89                	bnez	a5,800017d8 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017c0:	85e2                	mv	a1,s8
    800017c2:	854a                	mv	a0,s2
    800017c4:	00000097          	auipc	ra,0x0
    800017c8:	e9c080e7          	jalr	-356(ra) # 80001660 <sleep>
    havekids = 0;
    800017cc:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800017ce:	0000b497          	auipc	s1,0xb
    800017d2:	de248493          	addi	s1,s1,-542 # 8000c5b0 <proc>
    800017d6:	bf7d                	j	80001794 <wait+0xd0>
      release(&wait_lock);
    800017d8:	0000b517          	auipc	a0,0xb
    800017dc:	9b850513          	addi	a0,a0,-1608 # 8000c190 <wait_lock>
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	042080e7          	jalr	66(ra) # 80006822 <release>
      return -1;
    800017e8:	59fd                	li	s3,-1
    800017ea:	b7ad                	j	80001754 <wait+0x90>

00000000800017ec <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017ec:	7139                	addi	sp,sp,-64
    800017ee:	fc06                	sd	ra,56(sp)
    800017f0:	f822                	sd	s0,48(sp)
    800017f2:	f426                	sd	s1,40(sp)
    800017f4:	f04a                	sd	s2,32(sp)
    800017f6:	ec4e                	sd	s3,24(sp)
    800017f8:	e852                	sd	s4,16(sp)
    800017fa:	e456                	sd	s5,8(sp)
    800017fc:	0080                	addi	s0,sp,64
    800017fe:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001800:	0000b497          	auipc	s1,0xb
    80001804:	db048493          	addi	s1,s1,-592 # 8000c5b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001808:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000180a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180c:	00011917          	auipc	s2,0x11
    80001810:	9a490913          	addi	s2,s2,-1628 # 800121b0 <tickslock>
    80001814:	a811                	j	80001828 <wakeup+0x3c>
      }
      release(&p->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	00a080e7          	jalr	10(ra) # 80006822 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001820:	17048493          	addi	s1,s1,368
    80001824:	03248663          	beq	s1,s2,80001850 <wakeup+0x64>
    if(p != myproc()){
    80001828:	fffff097          	auipc	ra,0xfffff
    8000182c:	772080e7          	jalr	1906(ra) # 80000f9a <myproc>
    80001830:	fea488e3          	beq	s1,a0,80001820 <wakeup+0x34>
      acquire(&p->lock);
    80001834:	8526                	mv	a0,s1
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	f24080e7          	jalr	-220(ra) # 8000675a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000183e:	509c                	lw	a5,32(s1)
    80001840:	fd379be3          	bne	a5,s3,80001816 <wakeup+0x2a>
    80001844:	749c                	ld	a5,40(s1)
    80001846:	fd4798e3          	bne	a5,s4,80001816 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000184a:	0354a023          	sw	s5,32(s1)
    8000184e:	b7e1                	j	80001816 <wakeup+0x2a>
    }
  }
}
    80001850:	70e2                	ld	ra,56(sp)
    80001852:	7442                	ld	s0,48(sp)
    80001854:	74a2                	ld	s1,40(sp)
    80001856:	7902                	ld	s2,32(sp)
    80001858:	69e2                	ld	s3,24(sp)
    8000185a:	6a42                	ld	s4,16(sp)
    8000185c:	6aa2                	ld	s5,8(sp)
    8000185e:	6121                	addi	sp,sp,64
    80001860:	8082                	ret

0000000080001862 <reparent>:
{
    80001862:	7179                	addi	sp,sp,-48
    80001864:	f406                	sd	ra,40(sp)
    80001866:	f022                	sd	s0,32(sp)
    80001868:	ec26                	sd	s1,24(sp)
    8000186a:	e84a                	sd	s2,16(sp)
    8000186c:	e44e                	sd	s3,8(sp)
    8000186e:	e052                	sd	s4,0(sp)
    80001870:	1800                	addi	s0,sp,48
    80001872:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001874:	0000b497          	auipc	s1,0xb
    80001878:	d3c48493          	addi	s1,s1,-708 # 8000c5b0 <proc>
      pp->parent = initproc;
    8000187c:	0000aa17          	auipc	s4,0xa
    80001880:	794a0a13          	addi	s4,s4,1940 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001884:	00011997          	auipc	s3,0x11
    80001888:	92c98993          	addi	s3,s3,-1748 # 800121b0 <tickslock>
    8000188c:	a029                	j	80001896 <reparent+0x34>
    8000188e:	17048493          	addi	s1,s1,368
    80001892:	01348d63          	beq	s1,s3,800018ac <reparent+0x4a>
    if(pp->parent == p){
    80001896:	60bc                	ld	a5,64(s1)
    80001898:	ff279be3          	bne	a5,s2,8000188e <reparent+0x2c>
      pp->parent = initproc;
    8000189c:	000a3503          	ld	a0,0(s4)
    800018a0:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800018a2:	00000097          	auipc	ra,0x0
    800018a6:	f4a080e7          	jalr	-182(ra) # 800017ec <wakeup>
    800018aa:	b7d5                	j	8000188e <reparent+0x2c>
}
    800018ac:	70a2                	ld	ra,40(sp)
    800018ae:	7402                	ld	s0,32(sp)
    800018b0:	64e2                	ld	s1,24(sp)
    800018b2:	6942                	ld	s2,16(sp)
    800018b4:	69a2                	ld	s3,8(sp)
    800018b6:	6a02                	ld	s4,0(sp)
    800018b8:	6145                	addi	sp,sp,48
    800018ba:	8082                	ret

00000000800018bc <exit>:
{
    800018bc:	7179                	addi	sp,sp,-48
    800018be:	f406                	sd	ra,40(sp)
    800018c0:	f022                	sd	s0,32(sp)
    800018c2:	ec26                	sd	s1,24(sp)
    800018c4:	e84a                	sd	s2,16(sp)
    800018c6:	e44e                	sd	s3,8(sp)
    800018c8:	e052                	sd	s4,0(sp)
    800018ca:	1800                	addi	s0,sp,48
    800018cc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018ce:	fffff097          	auipc	ra,0xfffff
    800018d2:	6cc080e7          	jalr	1740(ra) # 80000f9a <myproc>
    800018d6:	89aa                	mv	s3,a0
  if(p == initproc)
    800018d8:	0000a797          	auipc	a5,0xa
    800018dc:	7387b783          	ld	a5,1848(a5) # 8000c010 <initproc>
    800018e0:	0d850493          	addi	s1,a0,216
    800018e4:	15850913          	addi	s2,a0,344
    800018e8:	02a79363          	bne	a5,a0,8000190e <exit+0x52>
    panic("init exiting");
    800018ec:	00007517          	auipc	a0,0x7
    800018f0:	8f450513          	addi	a0,a0,-1804 # 800081e0 <etext+0x1e0>
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	902080e7          	jalr	-1790(ra) # 800061f6 <panic>
      fileclose(f);
    800018fc:	00002097          	auipc	ra,0x2
    80001900:	2a4080e7          	jalr	676(ra) # 80003ba0 <fileclose>
      p->ofile[fd] = 0;
    80001904:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001908:	04a1                	addi	s1,s1,8
    8000190a:	01248563          	beq	s1,s2,80001914 <exit+0x58>
    if(p->ofile[fd]){
    8000190e:	6088                	ld	a0,0(s1)
    80001910:	f575                	bnez	a0,800018fc <exit+0x40>
    80001912:	bfdd                	j	80001908 <exit+0x4c>
  begin_op();
    80001914:	00002097          	auipc	ra,0x2
    80001918:	dc2080e7          	jalr	-574(ra) # 800036d6 <begin_op>
  iput(p->cwd);
    8000191c:	1589b503          	ld	a0,344(s3)
    80001920:	00001097          	auipc	ra,0x1
    80001924:	5a2080e7          	jalr	1442(ra) # 80002ec2 <iput>
  end_op();
    80001928:	00002097          	auipc	ra,0x2
    8000192c:	e28080e7          	jalr	-472(ra) # 80003750 <end_op>
  p->cwd = 0;
    80001930:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001934:	0000b497          	auipc	s1,0xb
    80001938:	85c48493          	addi	s1,s1,-1956 # 8000c190 <wait_lock>
    8000193c:	8526                	mv	a0,s1
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	e1c080e7          	jalr	-484(ra) # 8000675a <acquire>
  reparent(p);
    80001946:	854e                	mv	a0,s3
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	f1a080e7          	jalr	-230(ra) # 80001862 <reparent>
  wakeup(p->parent);
    80001950:	0409b503          	ld	a0,64(s3)
    80001954:	00000097          	auipc	ra,0x0
    80001958:	e98080e7          	jalr	-360(ra) # 800017ec <wakeup>
  acquire(&p->lock);
    8000195c:	854e                	mv	a0,s3
    8000195e:	00005097          	auipc	ra,0x5
    80001962:	dfc080e7          	jalr	-516(ra) # 8000675a <acquire>
  p->xstate = status;
    80001966:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000196a:	4795                	li	a5,5
    8000196c:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001970:	8526                	mv	a0,s1
    80001972:	00005097          	auipc	ra,0x5
    80001976:	eb0080e7          	jalr	-336(ra) # 80006822 <release>
  sched();
    8000197a:	00000097          	auipc	ra,0x0
    8000197e:	bd4080e7          	jalr	-1068(ra) # 8000154e <sched>
  panic("zombie exit");
    80001982:	00007517          	auipc	a0,0x7
    80001986:	86e50513          	addi	a0,a0,-1938 # 800081f0 <etext+0x1f0>
    8000198a:	00005097          	auipc	ra,0x5
    8000198e:	86c080e7          	jalr	-1940(ra) # 800061f6 <panic>

0000000080001992 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001992:	7179                	addi	sp,sp,-48
    80001994:	f406                	sd	ra,40(sp)
    80001996:	f022                	sd	s0,32(sp)
    80001998:	ec26                	sd	s1,24(sp)
    8000199a:	e84a                	sd	s2,16(sp)
    8000199c:	e44e                	sd	s3,8(sp)
    8000199e:	1800                	addi	s0,sp,48
    800019a0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019a2:	0000b497          	auipc	s1,0xb
    800019a6:	c0e48493          	addi	s1,s1,-1010 # 8000c5b0 <proc>
    800019aa:	00011997          	auipc	s3,0x11
    800019ae:	80698993          	addi	s3,s3,-2042 # 800121b0 <tickslock>
    acquire(&p->lock);
    800019b2:	8526                	mv	a0,s1
    800019b4:	00005097          	auipc	ra,0x5
    800019b8:	da6080e7          	jalr	-602(ra) # 8000675a <acquire>
    if(p->pid == pid){
    800019bc:	5c9c                	lw	a5,56(s1)
    800019be:	01278d63          	beq	a5,s2,800019d8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019c2:	8526                	mv	a0,s1
    800019c4:	00005097          	auipc	ra,0x5
    800019c8:	e5e080e7          	jalr	-418(ra) # 80006822 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019cc:	17048493          	addi	s1,s1,368
    800019d0:	ff3491e3          	bne	s1,s3,800019b2 <kill+0x20>
  }
  return -1;
    800019d4:	557d                	li	a0,-1
    800019d6:	a829                	j	800019f0 <kill+0x5e>
      p->killed = 1;
    800019d8:	4785                	li	a5,1
    800019da:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800019dc:	5098                	lw	a4,32(s1)
    800019de:	4789                	li	a5,2
    800019e0:	00f70f63          	beq	a4,a5,800019fe <kill+0x6c>
      release(&p->lock);
    800019e4:	8526                	mv	a0,s1
    800019e6:	00005097          	auipc	ra,0x5
    800019ea:	e3c080e7          	jalr	-452(ra) # 80006822 <release>
      return 0;
    800019ee:	4501                	li	a0,0
}
    800019f0:	70a2                	ld	ra,40(sp)
    800019f2:	7402                	ld	s0,32(sp)
    800019f4:	64e2                	ld	s1,24(sp)
    800019f6:	6942                	ld	s2,16(sp)
    800019f8:	69a2                	ld	s3,8(sp)
    800019fa:	6145                	addi	sp,sp,48
    800019fc:	8082                	ret
        p->state = RUNNABLE;
    800019fe:	478d                	li	a5,3
    80001a00:	d09c                	sw	a5,32(s1)
    80001a02:	b7cd                	j	800019e4 <kill+0x52>

0000000080001a04 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a04:	7179                	addi	sp,sp,-48
    80001a06:	f406                	sd	ra,40(sp)
    80001a08:	f022                	sd	s0,32(sp)
    80001a0a:	ec26                	sd	s1,24(sp)
    80001a0c:	e84a                	sd	s2,16(sp)
    80001a0e:	e44e                	sd	s3,8(sp)
    80001a10:	e052                	sd	s4,0(sp)
    80001a12:	1800                	addi	s0,sp,48
    80001a14:	84aa                	mv	s1,a0
    80001a16:	892e                	mv	s2,a1
    80001a18:	89b2                	mv	s3,a2
    80001a1a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a1c:	fffff097          	auipc	ra,0xfffff
    80001a20:	57e080e7          	jalr	1406(ra) # 80000f9a <myproc>
  if(user_dst){
    80001a24:	c08d                	beqz	s1,80001a46 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a26:	86d2                	mv	a3,s4
    80001a28:	864e                	mv	a2,s3
    80001a2a:	85ca                	mv	a1,s2
    80001a2c:	6d28                	ld	a0,88(a0)
    80001a2e:	fffff097          	auipc	ra,0xfffff
    80001a32:	208080e7          	jalr	520(ra) # 80000c36 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a36:	70a2                	ld	ra,40(sp)
    80001a38:	7402                	ld	s0,32(sp)
    80001a3a:	64e2                	ld	s1,24(sp)
    80001a3c:	6942                	ld	s2,16(sp)
    80001a3e:	69a2                	ld	s3,8(sp)
    80001a40:	6a02                	ld	s4,0(sp)
    80001a42:	6145                	addi	sp,sp,48
    80001a44:	8082                	ret
    memmove((char *)dst, src, len);
    80001a46:	000a061b          	sext.w	a2,s4
    80001a4a:	85ce                	mv	a1,s3
    80001a4c:	854a                	mv	a0,s2
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	896080e7          	jalr	-1898(ra) # 800002e4 <memmove>
    return 0;
    80001a56:	8526                	mv	a0,s1
    80001a58:	bff9                	j	80001a36 <either_copyout+0x32>

0000000080001a5a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a5a:	7179                	addi	sp,sp,-48
    80001a5c:	f406                	sd	ra,40(sp)
    80001a5e:	f022                	sd	s0,32(sp)
    80001a60:	ec26                	sd	s1,24(sp)
    80001a62:	e84a                	sd	s2,16(sp)
    80001a64:	e44e                	sd	s3,8(sp)
    80001a66:	e052                	sd	s4,0(sp)
    80001a68:	1800                	addi	s0,sp,48
    80001a6a:	892a                	mv	s2,a0
    80001a6c:	84ae                	mv	s1,a1
    80001a6e:	89b2                	mv	s3,a2
    80001a70:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	528080e7          	jalr	1320(ra) # 80000f9a <myproc>
  if(user_src){
    80001a7a:	c08d                	beqz	s1,80001a9c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a7c:	86d2                	mv	a3,s4
    80001a7e:	864e                	mv	a2,s3
    80001a80:	85ca                	mv	a1,s2
    80001a82:	6d28                	ld	a0,88(a0)
    80001a84:	fffff097          	auipc	ra,0xfffff
    80001a88:	23e080e7          	jalr	574(ra) # 80000cc2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a8c:	70a2                	ld	ra,40(sp)
    80001a8e:	7402                	ld	s0,32(sp)
    80001a90:	64e2                	ld	s1,24(sp)
    80001a92:	6942                	ld	s2,16(sp)
    80001a94:	69a2                	ld	s3,8(sp)
    80001a96:	6a02                	ld	s4,0(sp)
    80001a98:	6145                	addi	sp,sp,48
    80001a9a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a9c:	000a061b          	sext.w	a2,s4
    80001aa0:	85ce                	mv	a1,s3
    80001aa2:	854a                	mv	a0,s2
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	840080e7          	jalr	-1984(ra) # 800002e4 <memmove>
    return 0;
    80001aac:	8526                	mv	a0,s1
    80001aae:	bff9                	j	80001a8c <either_copyin+0x32>

0000000080001ab0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ab0:	715d                	addi	sp,sp,-80
    80001ab2:	e486                	sd	ra,72(sp)
    80001ab4:	e0a2                	sd	s0,64(sp)
    80001ab6:	fc26                	sd	s1,56(sp)
    80001ab8:	f84a                	sd	s2,48(sp)
    80001aba:	f44e                	sd	s3,40(sp)
    80001abc:	f052                	sd	s4,32(sp)
    80001abe:	ec56                	sd	s5,24(sp)
    80001ac0:	e85a                	sd	s6,16(sp)
    80001ac2:	e45e                	sd	s7,8(sp)
    80001ac4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ac6:	00006517          	auipc	a0,0x6
    80001aca:	55250513          	addi	a0,a0,1362 # 80008018 <etext+0x18>
    80001ace:	00004097          	auipc	ra,0x4
    80001ad2:	772080e7          	jalr	1906(ra) # 80006240 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ad6:	0000b497          	auipc	s1,0xb
    80001ada:	c3a48493          	addi	s1,s1,-966 # 8000c710 <proc+0x160>
    80001ade:	00011917          	auipc	s2,0x11
    80001ae2:	83290913          	addi	s2,s2,-1998 # 80012310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ae8:	00006997          	auipc	s3,0x6
    80001aec:	71898993          	addi	s3,s3,1816 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001af0:	00006a97          	auipc	s5,0x6
    80001af4:	718a8a93          	addi	s5,s5,1816 # 80008208 <etext+0x208>
    printf("\n");
    80001af8:	00006a17          	auipc	s4,0x6
    80001afc:	520a0a13          	addi	s4,s4,1312 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b00:	00007b97          	auipc	s7,0x7
    80001b04:	c88b8b93          	addi	s7,s7,-888 # 80008788 <states.0>
    80001b08:	a00d                	j	80001b2a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b0a:	ed86a583          	lw	a1,-296(a3)
    80001b0e:	8556                	mv	a0,s5
    80001b10:	00004097          	auipc	ra,0x4
    80001b14:	730080e7          	jalr	1840(ra) # 80006240 <printf>
    printf("\n");
    80001b18:	8552                	mv	a0,s4
    80001b1a:	00004097          	auipc	ra,0x4
    80001b1e:	726080e7          	jalr	1830(ra) # 80006240 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b22:	17048493          	addi	s1,s1,368
    80001b26:	03248263          	beq	s1,s2,80001b4a <procdump+0x9a>
    if(p->state == UNUSED)
    80001b2a:	86a6                	mv	a3,s1
    80001b2c:	ec04a783          	lw	a5,-320(s1)
    80001b30:	dbed                	beqz	a5,80001b22 <procdump+0x72>
      state = "???";
    80001b32:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b34:	fcfb6be3          	bltu	s6,a5,80001b0a <procdump+0x5a>
    80001b38:	02079713          	slli	a4,a5,0x20
    80001b3c:	01d75793          	srli	a5,a4,0x1d
    80001b40:	97de                	add	a5,a5,s7
    80001b42:	6390                	ld	a2,0(a5)
    80001b44:	f279                	bnez	a2,80001b0a <procdump+0x5a>
      state = "???";
    80001b46:	864e                	mv	a2,s3
    80001b48:	b7c9                	j	80001b0a <procdump+0x5a>
  }
}
    80001b4a:	60a6                	ld	ra,72(sp)
    80001b4c:	6406                	ld	s0,64(sp)
    80001b4e:	74e2                	ld	s1,56(sp)
    80001b50:	7942                	ld	s2,48(sp)
    80001b52:	79a2                	ld	s3,40(sp)
    80001b54:	7a02                	ld	s4,32(sp)
    80001b56:	6ae2                	ld	s5,24(sp)
    80001b58:	6b42                	ld	s6,16(sp)
    80001b5a:	6ba2                	ld	s7,8(sp)
    80001b5c:	6161                	addi	sp,sp,80
    80001b5e:	8082                	ret

0000000080001b60 <swtch>:
    80001b60:	00153023          	sd	ra,0(a0)
    80001b64:	00253423          	sd	sp,8(a0)
    80001b68:	e900                	sd	s0,16(a0)
    80001b6a:	ed04                	sd	s1,24(a0)
    80001b6c:	03253023          	sd	s2,32(a0)
    80001b70:	03353423          	sd	s3,40(a0)
    80001b74:	03453823          	sd	s4,48(a0)
    80001b78:	03553c23          	sd	s5,56(a0)
    80001b7c:	05653023          	sd	s6,64(a0)
    80001b80:	05753423          	sd	s7,72(a0)
    80001b84:	05853823          	sd	s8,80(a0)
    80001b88:	05953c23          	sd	s9,88(a0)
    80001b8c:	07a53023          	sd	s10,96(a0)
    80001b90:	07b53423          	sd	s11,104(a0)
    80001b94:	0005b083          	ld	ra,0(a1)
    80001b98:	0085b103          	ld	sp,8(a1)
    80001b9c:	6980                	ld	s0,16(a1)
    80001b9e:	6d84                	ld	s1,24(a1)
    80001ba0:	0205b903          	ld	s2,32(a1)
    80001ba4:	0285b983          	ld	s3,40(a1)
    80001ba8:	0305ba03          	ld	s4,48(a1)
    80001bac:	0385ba83          	ld	s5,56(a1)
    80001bb0:	0405bb03          	ld	s6,64(a1)
    80001bb4:	0485bb83          	ld	s7,72(a1)
    80001bb8:	0505bc03          	ld	s8,80(a1)
    80001bbc:	0585bc83          	ld	s9,88(a1)
    80001bc0:	0605bd03          	ld	s10,96(a1)
    80001bc4:	0685bd83          	ld	s11,104(a1)
    80001bc8:	8082                	ret

0000000080001bca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bca:	1141                	addi	sp,sp,-16
    80001bcc:	e406                	sd	ra,8(sp)
    80001bce:	e022                	sd	s0,0(sp)
    80001bd0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bd2:	00006597          	auipc	a1,0x6
    80001bd6:	66e58593          	addi	a1,a1,1646 # 80008240 <etext+0x240>
    80001bda:	00010517          	auipc	a0,0x10
    80001bde:	5d650513          	addi	a0,a0,1494 # 800121b0 <tickslock>
    80001be2:	00005097          	auipc	ra,0x5
    80001be6:	cec080e7          	jalr	-788(ra) # 800068ce <initlock>
}
    80001bea:	60a2                	ld	ra,8(sp)
    80001bec:	6402                	ld	s0,0(sp)
    80001bee:	0141                	addi	sp,sp,16
    80001bf0:	8082                	ret

0000000080001bf2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bf2:	1141                	addi	sp,sp,-16
    80001bf4:	e422                	sd	s0,8(sp)
    80001bf6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf8:	00003797          	auipc	a5,0x3
    80001bfc:	69878793          	addi	a5,a5,1688 # 80005290 <kernelvec>
    80001c00:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c04:	6422                	ld	s0,8(sp)
    80001c06:	0141                	addi	sp,sp,16
    80001c08:	8082                	ret

0000000080001c0a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c0a:	1141                	addi	sp,sp,-16
    80001c0c:	e406                	sd	ra,8(sp)
    80001c0e:	e022                	sd	s0,0(sp)
    80001c10:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	388080e7          	jalr	904(ra) # 80000f9a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c20:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c24:	00005697          	auipc	a3,0x5
    80001c28:	3dc68693          	addi	a3,a3,988 # 80007000 <_trampoline>
    80001c2c:	00005717          	auipc	a4,0x5
    80001c30:	3d470713          	addi	a4,a4,980 # 80007000 <_trampoline>
    80001c34:	8f15                	sub	a4,a4,a3
    80001c36:	040007b7          	lui	a5,0x4000
    80001c3a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c3c:	07b2                	slli	a5,a5,0xc
    80001c3e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c40:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c44:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c46:	18002673          	csrr	a2,satp
    80001c4a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c4c:	7130                	ld	a2,96(a0)
    80001c4e:	6538                	ld	a4,72(a0)
    80001c50:	6585                	lui	a1,0x1
    80001c52:	972e                	add	a4,a4,a1
    80001c54:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c56:	7138                	ld	a4,96(a0)
    80001c58:	00000617          	auipc	a2,0x0
    80001c5c:	14060613          	addi	a2,a2,320 # 80001d98 <usertrap>
    80001c60:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c62:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c64:	8612                	mv	a2,tp
    80001c66:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c68:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c6c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c70:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c74:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c78:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c7a:	6f18                	ld	a4,24(a4)
    80001c7c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c80:	6d2c                	ld	a1,88(a0)
    80001c82:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c84:	00005717          	auipc	a4,0x5
    80001c88:	40c70713          	addi	a4,a4,1036 # 80007090 <userret>
    80001c8c:	8f15                	sub	a4,a4,a3
    80001c8e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c90:	577d                	li	a4,-1
    80001c92:	177e                	slli	a4,a4,0x3f
    80001c94:	8dd9                	or	a1,a1,a4
    80001c96:	02000537          	lui	a0,0x2000
    80001c9a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c9c:	0536                	slli	a0,a0,0xd
    80001c9e:	9782                	jalr	a5
}
    80001ca0:	60a2                	ld	ra,8(sp)
    80001ca2:	6402                	ld	s0,0(sp)
    80001ca4:	0141                	addi	sp,sp,16
    80001ca6:	8082                	ret

0000000080001ca8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ca8:	1101                	addi	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	e426                	sd	s1,8(sp)
    80001cb0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cb2:	00010497          	auipc	s1,0x10
    80001cb6:	4fe48493          	addi	s1,s1,1278 # 800121b0 <tickslock>
    80001cba:	8526                	mv	a0,s1
    80001cbc:	00005097          	auipc	ra,0x5
    80001cc0:	a9e080e7          	jalr	-1378(ra) # 8000675a <acquire>
  ticks++;
    80001cc4:	0000a517          	auipc	a0,0xa
    80001cc8:	35450513          	addi	a0,a0,852 # 8000c018 <ticks>
    80001ccc:	411c                	lw	a5,0(a0)
    80001cce:	2785                	addiw	a5,a5,1
    80001cd0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	b1a080e7          	jalr	-1254(ra) # 800017ec <wakeup>
  release(&tickslock);
    80001cda:	8526                	mv	a0,s1
    80001cdc:	00005097          	auipc	ra,0x5
    80001ce0:	b46080e7          	jalr	-1210(ra) # 80006822 <release>
}
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	64a2                	ld	s1,8(sp)
    80001cea:	6105                	addi	sp,sp,32
    80001cec:	8082                	ret

0000000080001cee <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cee:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cf2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001cf4:	0a07d163          	bgez	a5,80001d96 <devintr+0xa8>
{
    80001cf8:	1101                	addi	sp,sp,-32
    80001cfa:	ec06                	sd	ra,24(sp)
    80001cfc:	e822                	sd	s0,16(sp)
    80001cfe:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001d00:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001d04:	46a5                	li	a3,9
    80001d06:	00d70c63          	beq	a4,a3,80001d1e <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001d0a:	577d                	li	a4,-1
    80001d0c:	177e                	slli	a4,a4,0x3f
    80001d0e:	0705                	addi	a4,a4,1
    return 0;
    80001d10:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d12:	06e78163          	beq	a5,a4,80001d74 <devintr+0x86>
  }
}
    80001d16:	60e2                	ld	ra,24(sp)
    80001d18:	6442                	ld	s0,16(sp)
    80001d1a:	6105                	addi	sp,sp,32
    80001d1c:	8082                	ret
    80001d1e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d20:	00003097          	auipc	ra,0x3
    80001d24:	67c080e7          	jalr	1660(ra) # 8000539c <plic_claim>
    80001d28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d2a:	47a9                	li	a5,10
    80001d2c:	00f50963          	beq	a0,a5,80001d3e <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001d30:	4785                	li	a5,1
    80001d32:	00f50b63          	beq	a0,a5,80001d48 <devintr+0x5a>
    return 1;
    80001d36:	4505                	li	a0,1
    } else if(irq){
    80001d38:	ec89                	bnez	s1,80001d52 <devintr+0x64>
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	bfe9                	j	80001d16 <devintr+0x28>
      uartintr();
    80001d3e:	00005097          	auipc	ra,0x5
    80001d42:	952080e7          	jalr	-1710(ra) # 80006690 <uartintr>
    if(irq)
    80001d46:	a839                	j	80001d64 <devintr+0x76>
      virtio_disk_intr();
    80001d48:	00004097          	auipc	ra,0x4
    80001d4c:	b28080e7          	jalr	-1240(ra) # 80005870 <virtio_disk_intr>
    if(irq)
    80001d50:	a811                	j	80001d64 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d52:	85a6                	mv	a1,s1
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	4f450513          	addi	a0,a0,1268 # 80008248 <etext+0x248>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	4e4080e7          	jalr	1252(ra) # 80006240 <printf>
      plic_complete(irq);
    80001d64:	8526                	mv	a0,s1
    80001d66:	00003097          	auipc	ra,0x3
    80001d6a:	65a080e7          	jalr	1626(ra) # 800053c0 <plic_complete>
    return 1;
    80001d6e:	4505                	li	a0,1
    80001d70:	64a2                	ld	s1,8(sp)
    80001d72:	b755                	j	80001d16 <devintr+0x28>
    if(cpuid() == 0){
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	1fa080e7          	jalr	506(ra) # 80000f6e <cpuid>
    80001d7c:	c901                	beqz	a0,80001d8c <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d7e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d84:	14479073          	csrw	sip,a5
    return 2;
    80001d88:	4509                	li	a0,2
    80001d8a:	b771                	j	80001d16 <devintr+0x28>
      clockintr();
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	f1c080e7          	jalr	-228(ra) # 80001ca8 <clockintr>
    80001d94:	b7ed                	j	80001d7e <devintr+0x90>
}
    80001d96:	8082                	ret

0000000080001d98 <usertrap>:
{
    80001d98:	1101                	addi	sp,sp,-32
    80001d9a:	ec06                	sd	ra,24(sp)
    80001d9c:	e822                	sd	s0,16(sp)
    80001d9e:	e426                	sd	s1,8(sp)
    80001da0:	e04a                	sd	s2,0(sp)
    80001da2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001da8:	1007f793          	andi	a5,a5,256
    80001dac:	e3ad                	bnez	a5,80001e0e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dae:	00003797          	auipc	a5,0x3
    80001db2:	4e278793          	addi	a5,a5,1250 # 80005290 <kernelvec>
    80001db6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	1e0080e7          	jalr	480(ra) # 80000f9a <myproc>
    80001dc2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dc4:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc6:	14102773          	csrr	a4,sepc
    80001dca:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dcc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dd0:	47a1                	li	a5,8
    80001dd2:	04f71c63          	bne	a4,a5,80001e2a <usertrap+0x92>
    if(p->killed)
    80001dd6:	591c                	lw	a5,48(a0)
    80001dd8:	e3b9                	bnez	a5,80001e1e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001dda:	70b8                	ld	a4,96(s1)
    80001ddc:	6f1c                	ld	a5,24(a4)
    80001dde:	0791                	addi	a5,a5,4
    80001de0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001de6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dea:	10079073          	csrw	sstatus,a5
    syscall();
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	2e0080e7          	jalr	736(ra) # 800020ce <syscall>
  if(p->killed)
    80001df6:	589c                	lw	a5,48(s1)
    80001df8:	ebc1                	bnez	a5,80001e88 <usertrap+0xf0>
  usertrapret();
    80001dfa:	00000097          	auipc	ra,0x0
    80001dfe:	e10080e7          	jalr	-496(ra) # 80001c0a <usertrapret>
}
    80001e02:	60e2                	ld	ra,24(sp)
    80001e04:	6442                	ld	s0,16(sp)
    80001e06:	64a2                	ld	s1,8(sp)
    80001e08:	6902                	ld	s2,0(sp)
    80001e0a:	6105                	addi	sp,sp,32
    80001e0c:	8082                	ret
    panic("usertrap: not from user mode");
    80001e0e:	00006517          	auipc	a0,0x6
    80001e12:	45a50513          	addi	a0,a0,1114 # 80008268 <etext+0x268>
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	3e0080e7          	jalr	992(ra) # 800061f6 <panic>
      exit(-1);
    80001e1e:	557d                	li	a0,-1
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	a9c080e7          	jalr	-1380(ra) # 800018bc <exit>
    80001e28:	bf4d                	j	80001dda <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	ec4080e7          	jalr	-316(ra) # 80001cee <devintr>
    80001e32:	892a                	mv	s2,a0
    80001e34:	c501                	beqz	a0,80001e3c <usertrap+0xa4>
  if(p->killed)
    80001e36:	589c                	lw	a5,48(s1)
    80001e38:	c3a1                	beqz	a5,80001e78 <usertrap+0xe0>
    80001e3a:	a815                	j	80001e6e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e3c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e40:	5c90                	lw	a2,56(s1)
    80001e42:	00006517          	auipc	a0,0x6
    80001e46:	44650513          	addi	a0,a0,1094 # 80008288 <etext+0x288>
    80001e4a:	00004097          	auipc	ra,0x4
    80001e4e:	3f6080e7          	jalr	1014(ra) # 80006240 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e52:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e56:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	45e50513          	addi	a0,a0,1118 # 800082b8 <etext+0x2b8>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	3de080e7          	jalr	990(ra) # 80006240 <printf>
    p->killed = 1;
    80001e6a:	4785                	li	a5,1
    80001e6c:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e6e:	557d                	li	a0,-1
    80001e70:	00000097          	auipc	ra,0x0
    80001e74:	a4c080e7          	jalr	-1460(ra) # 800018bc <exit>
  if(which_dev == 2)
    80001e78:	4789                	li	a5,2
    80001e7a:	f8f910e3          	bne	s2,a5,80001dfa <usertrap+0x62>
    yield();
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	7a6080e7          	jalr	1958(ra) # 80001624 <yield>
    80001e86:	bf95                	j	80001dfa <usertrap+0x62>
  int which_dev = 0;
    80001e88:	4901                	li	s2,0
    80001e8a:	b7d5                	j	80001e6e <usertrap+0xd6>

0000000080001e8c <kerneltrap>:
{
    80001e8c:	7179                	addi	sp,sp,-48
    80001e8e:	f406                	sd	ra,40(sp)
    80001e90:	f022                	sd	s0,32(sp)
    80001e92:	ec26                	sd	s1,24(sp)
    80001e94:	e84a                	sd	s2,16(sp)
    80001e96:	e44e                	sd	s3,8(sp)
    80001e98:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e9a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e9e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ea2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ea6:	1004f793          	andi	a5,s1,256
    80001eaa:	cb85                	beqz	a5,80001eda <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001eb0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001eb2:	ef85                	bnez	a5,80001eea <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	e3a080e7          	jalr	-454(ra) # 80001cee <devintr>
    80001ebc:	cd1d                	beqz	a0,80001efa <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ebe:	4789                	li	a5,2
    80001ec0:	06f50a63          	beq	a0,a5,80001f34 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ec4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ec8:	10049073          	csrw	sstatus,s1
}
    80001ecc:	70a2                	ld	ra,40(sp)
    80001ece:	7402                	ld	s0,32(sp)
    80001ed0:	64e2                	ld	s1,24(sp)
    80001ed2:	6942                	ld	s2,16(sp)
    80001ed4:	69a2                	ld	s3,8(sp)
    80001ed6:	6145                	addi	sp,sp,48
    80001ed8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	3fe50513          	addi	a0,a0,1022 # 800082d8 <etext+0x2d8>
    80001ee2:	00004097          	auipc	ra,0x4
    80001ee6:	314080e7          	jalr	788(ra) # 800061f6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eea:	00006517          	auipc	a0,0x6
    80001eee:	41650513          	addi	a0,a0,1046 # 80008300 <etext+0x300>
    80001ef2:	00004097          	auipc	ra,0x4
    80001ef6:	304080e7          	jalr	772(ra) # 800061f6 <panic>
    printf("scause %p\n", scause);
    80001efa:	85ce                	mv	a1,s3
    80001efc:	00006517          	auipc	a0,0x6
    80001f00:	42450513          	addi	a0,a0,1060 # 80008320 <etext+0x320>
    80001f04:	00004097          	auipc	ra,0x4
    80001f08:	33c080e7          	jalr	828(ra) # 80006240 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f10:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f14:	00006517          	auipc	a0,0x6
    80001f18:	41c50513          	addi	a0,a0,1052 # 80008330 <etext+0x330>
    80001f1c:	00004097          	auipc	ra,0x4
    80001f20:	324080e7          	jalr	804(ra) # 80006240 <printf>
    panic("kerneltrap");
    80001f24:	00006517          	auipc	a0,0x6
    80001f28:	42450513          	addi	a0,a0,1060 # 80008348 <etext+0x348>
    80001f2c:	00004097          	auipc	ra,0x4
    80001f30:	2ca080e7          	jalr	714(ra) # 800061f6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	066080e7          	jalr	102(ra) # 80000f9a <myproc>
    80001f3c:	d541                	beqz	a0,80001ec4 <kerneltrap+0x38>
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	05c080e7          	jalr	92(ra) # 80000f9a <myproc>
    80001f46:	5118                	lw	a4,32(a0)
    80001f48:	4791                	li	a5,4
    80001f4a:	f6f71de3          	bne	a4,a5,80001ec4 <kerneltrap+0x38>
    yield();
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	6d6080e7          	jalr	1750(ra) # 80001624 <yield>
    80001f56:	b7bd                	j	80001ec4 <kerneltrap+0x38>

0000000080001f58 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f58:	1101                	addi	sp,sp,-32
    80001f5a:	ec06                	sd	ra,24(sp)
    80001f5c:	e822                	sd	s0,16(sp)
    80001f5e:	e426                	sd	s1,8(sp)
    80001f60:	1000                	addi	s0,sp,32
    80001f62:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	036080e7          	jalr	54(ra) # 80000f9a <myproc>
  switch (n) {
    80001f6c:	4795                	li	a5,5
    80001f6e:	0497e163          	bltu	a5,s1,80001fb0 <argraw+0x58>
    80001f72:	048a                	slli	s1,s1,0x2
    80001f74:	00007717          	auipc	a4,0x7
    80001f78:	84470713          	addi	a4,a4,-1980 # 800087b8 <states.0+0x30>
    80001f7c:	94ba                	add	s1,s1,a4
    80001f7e:	409c                	lw	a5,0(s1)
    80001f80:	97ba                	add	a5,a5,a4
    80001f82:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f84:	713c                	ld	a5,96(a0)
    80001f86:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f88:	60e2                	ld	ra,24(sp)
    80001f8a:	6442                	ld	s0,16(sp)
    80001f8c:	64a2                	ld	s1,8(sp)
    80001f8e:	6105                	addi	sp,sp,32
    80001f90:	8082                	ret
    return p->trapframe->a1;
    80001f92:	713c                	ld	a5,96(a0)
    80001f94:	7fa8                	ld	a0,120(a5)
    80001f96:	bfcd                	j	80001f88 <argraw+0x30>
    return p->trapframe->a2;
    80001f98:	713c                	ld	a5,96(a0)
    80001f9a:	63c8                	ld	a0,128(a5)
    80001f9c:	b7f5                	j	80001f88 <argraw+0x30>
    return p->trapframe->a3;
    80001f9e:	713c                	ld	a5,96(a0)
    80001fa0:	67c8                	ld	a0,136(a5)
    80001fa2:	b7dd                	j	80001f88 <argraw+0x30>
    return p->trapframe->a4;
    80001fa4:	713c                	ld	a5,96(a0)
    80001fa6:	6bc8                	ld	a0,144(a5)
    80001fa8:	b7c5                	j	80001f88 <argraw+0x30>
    return p->trapframe->a5;
    80001faa:	713c                	ld	a5,96(a0)
    80001fac:	6fc8                	ld	a0,152(a5)
    80001fae:	bfe9                	j	80001f88 <argraw+0x30>
  panic("argraw");
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	3a850513          	addi	a0,a0,936 # 80008358 <etext+0x358>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	23e080e7          	jalr	574(ra) # 800061f6 <panic>

0000000080001fc0 <fetchaddr>:
{
    80001fc0:	1101                	addi	sp,sp,-32
    80001fc2:	ec06                	sd	ra,24(sp)
    80001fc4:	e822                	sd	s0,16(sp)
    80001fc6:	e426                	sd	s1,8(sp)
    80001fc8:	e04a                	sd	s2,0(sp)
    80001fca:	1000                	addi	s0,sp,32
    80001fcc:	84aa                	mv	s1,a0
    80001fce:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	fca080e7          	jalr	-54(ra) # 80000f9a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fd8:	693c                	ld	a5,80(a0)
    80001fda:	02f4f863          	bgeu	s1,a5,8000200a <fetchaddr+0x4a>
    80001fde:	00848713          	addi	a4,s1,8
    80001fe2:	02e7e663          	bltu	a5,a4,8000200e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fe6:	46a1                	li	a3,8
    80001fe8:	8626                	mv	a2,s1
    80001fea:	85ca                	mv	a1,s2
    80001fec:	6d28                	ld	a0,88(a0)
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	cd4080e7          	jalr	-812(ra) # 80000cc2 <copyin>
    80001ff6:	00a03533          	snez	a0,a0
    80001ffa:	40a00533          	neg	a0,a0
}
    80001ffe:	60e2                	ld	ra,24(sp)
    80002000:	6442                	ld	s0,16(sp)
    80002002:	64a2                	ld	s1,8(sp)
    80002004:	6902                	ld	s2,0(sp)
    80002006:	6105                	addi	sp,sp,32
    80002008:	8082                	ret
    return -1;
    8000200a:	557d                	li	a0,-1
    8000200c:	bfcd                	j	80001ffe <fetchaddr+0x3e>
    8000200e:	557d                	li	a0,-1
    80002010:	b7fd                	j	80001ffe <fetchaddr+0x3e>

0000000080002012 <fetchstr>:
{
    80002012:	7179                	addi	sp,sp,-48
    80002014:	f406                	sd	ra,40(sp)
    80002016:	f022                	sd	s0,32(sp)
    80002018:	ec26                	sd	s1,24(sp)
    8000201a:	e84a                	sd	s2,16(sp)
    8000201c:	e44e                	sd	s3,8(sp)
    8000201e:	1800                	addi	s0,sp,48
    80002020:	892a                	mv	s2,a0
    80002022:	84ae                	mv	s1,a1
    80002024:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	f74080e7          	jalr	-140(ra) # 80000f9a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000202e:	86ce                	mv	a3,s3
    80002030:	864a                	mv	a2,s2
    80002032:	85a6                	mv	a1,s1
    80002034:	6d28                	ld	a0,88(a0)
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	d1a080e7          	jalr	-742(ra) # 80000d50 <copyinstr>
  if(err < 0)
    8000203e:	00054763          	bltz	a0,8000204c <fetchstr+0x3a>
  return strlen(buf);
    80002042:	8526                	mv	a0,s1
    80002044:	ffffe097          	auipc	ra,0xffffe
    80002048:	3b8080e7          	jalr	952(ra) # 800003fc <strlen>
}
    8000204c:	70a2                	ld	ra,40(sp)
    8000204e:	7402                	ld	s0,32(sp)
    80002050:	64e2                	ld	s1,24(sp)
    80002052:	6942                	ld	s2,16(sp)
    80002054:	69a2                	ld	s3,8(sp)
    80002056:	6145                	addi	sp,sp,48
    80002058:	8082                	ret

000000008000205a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000205a:	1101                	addi	sp,sp,-32
    8000205c:	ec06                	sd	ra,24(sp)
    8000205e:	e822                	sd	s0,16(sp)
    80002060:	e426                	sd	s1,8(sp)
    80002062:	1000                	addi	s0,sp,32
    80002064:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	ef2080e7          	jalr	-270(ra) # 80001f58 <argraw>
    8000206e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002070:	4501                	li	a0,0
    80002072:	60e2                	ld	ra,24(sp)
    80002074:	6442                	ld	s0,16(sp)
    80002076:	64a2                	ld	s1,8(sp)
    80002078:	6105                	addi	sp,sp,32
    8000207a:	8082                	ret

000000008000207c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	e426                	sd	s1,8(sp)
    80002084:	1000                	addi	s0,sp,32
    80002086:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	ed0080e7          	jalr	-304(ra) # 80001f58 <argraw>
    80002090:	e088                	sd	a0,0(s1)
  return 0;
}
    80002092:	4501                	li	a0,0
    80002094:	60e2                	ld	ra,24(sp)
    80002096:	6442                	ld	s0,16(sp)
    80002098:	64a2                	ld	s1,8(sp)
    8000209a:	6105                	addi	sp,sp,32
    8000209c:	8082                	ret

000000008000209e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000209e:	1101                	addi	sp,sp,-32
    800020a0:	ec06                	sd	ra,24(sp)
    800020a2:	e822                	sd	s0,16(sp)
    800020a4:	e426                	sd	s1,8(sp)
    800020a6:	e04a                	sd	s2,0(sp)
    800020a8:	1000                	addi	s0,sp,32
    800020aa:	84ae                	mv	s1,a1
    800020ac:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	eaa080e7          	jalr	-342(ra) # 80001f58 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020b6:	864a                	mv	a2,s2
    800020b8:	85a6                	mv	a1,s1
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	f58080e7          	jalr	-168(ra) # 80002012 <fetchstr>
}
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6902                	ld	s2,0(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret

00000000800020ce <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	e426                	sd	s1,8(sp)
    800020d6:	e04a                	sd	s2,0(sp)
    800020d8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	ec0080e7          	jalr	-320(ra) # 80000f9a <myproc>
    800020e2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020e4:	06053903          	ld	s2,96(a0)
    800020e8:	0a893783          	ld	a5,168(s2)
    800020ec:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020f0:	37fd                	addiw	a5,a5,-1
    800020f2:	4751                	li	a4,20
    800020f4:	00f76f63          	bltu	a4,a5,80002112 <syscall+0x44>
    800020f8:	00369713          	slli	a4,a3,0x3
    800020fc:	00006797          	auipc	a5,0x6
    80002100:	6d478793          	addi	a5,a5,1748 # 800087d0 <syscalls>
    80002104:	97ba                	add	a5,a5,a4
    80002106:	639c                	ld	a5,0(a5)
    80002108:	c789                	beqz	a5,80002112 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000210a:	9782                	jalr	a5
    8000210c:	06a93823          	sd	a0,112(s2)
    80002110:	a839                	j	8000212e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002112:	16048613          	addi	a2,s1,352
    80002116:	5c8c                	lw	a1,56(s1)
    80002118:	00006517          	auipc	a0,0x6
    8000211c:	24850513          	addi	a0,a0,584 # 80008360 <etext+0x360>
    80002120:	00004097          	auipc	ra,0x4
    80002124:	120080e7          	jalr	288(ra) # 80006240 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002128:	70bc                	ld	a5,96(s1)
    8000212a:	577d                	li	a4,-1
    8000212c:	fbb8                	sd	a4,112(a5)
  }
}
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	64a2                	ld	s1,8(sp)
    80002134:	6902                	ld	s2,0(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret

000000008000213a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002142:	fec40593          	addi	a1,s0,-20
    80002146:	4501                	li	a0,0
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	f12080e7          	jalr	-238(ra) # 8000205a <argint>
    return -1;
    80002150:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002152:	00054963          	bltz	a0,80002164 <sys_exit+0x2a>
  exit(n);
    80002156:	fec42503          	lw	a0,-20(s0)
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	762080e7          	jalr	1890(ra) # 800018bc <exit>
  return 0;  // not reached
    80002162:	4781                	li	a5,0
}
    80002164:	853e                	mv	a0,a5
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	6105                	addi	sp,sp,32
    8000216c:	8082                	ret

000000008000216e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000216e:	1141                	addi	sp,sp,-16
    80002170:	e406                	sd	ra,8(sp)
    80002172:	e022                	sd	s0,0(sp)
    80002174:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	e24080e7          	jalr	-476(ra) # 80000f9a <myproc>
}
    8000217e:	5d08                	lw	a0,56(a0)
    80002180:	60a2                	ld	ra,8(sp)
    80002182:	6402                	ld	s0,0(sp)
    80002184:	0141                	addi	sp,sp,16
    80002186:	8082                	ret

0000000080002188 <sys_fork>:

uint64
sys_fork(void)
{
    80002188:	1141                	addi	sp,sp,-16
    8000218a:	e406                	sd	ra,8(sp)
    8000218c:	e022                	sd	s0,0(sp)
    8000218e:	0800                	addi	s0,sp,16
  return fork();
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	1dc080e7          	jalr	476(ra) # 8000136c <fork>
}
    80002198:	60a2                	ld	ra,8(sp)
    8000219a:	6402                	ld	s0,0(sp)
    8000219c:	0141                	addi	sp,sp,16
    8000219e:	8082                	ret

00000000800021a0 <sys_wait>:

uint64
sys_wait(void)
{
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021a8:	fe840593          	addi	a1,s0,-24
    800021ac:	4501                	li	a0,0
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	ece080e7          	jalr	-306(ra) # 8000207c <argaddr>
    800021b6:	87aa                	mv	a5,a0
    return -1;
    800021b8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021ba:	0007c863          	bltz	a5,800021ca <sys_wait+0x2a>
  return wait(p);
    800021be:	fe843503          	ld	a0,-24(s0)
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	502080e7          	jalr	1282(ra) # 800016c4 <wait>
}
    800021ca:	60e2                	ld	ra,24(sp)
    800021cc:	6442                	ld	s0,16(sp)
    800021ce:	6105                	addi	sp,sp,32
    800021d0:	8082                	ret

00000000800021d2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021d2:	7179                	addi	sp,sp,-48
    800021d4:	f406                	sd	ra,40(sp)
    800021d6:	f022                	sd	s0,32(sp)
    800021d8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021da:	fdc40593          	addi	a1,s0,-36
    800021de:	4501                	li	a0,0
    800021e0:	00000097          	auipc	ra,0x0
    800021e4:	e7a080e7          	jalr	-390(ra) # 8000205a <argint>
    800021e8:	87aa                	mv	a5,a0
    return -1;
    800021ea:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021ec:	0207c263          	bltz	a5,80002210 <sys_sbrk+0x3e>
    800021f0:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	da8080e7          	jalr	-600(ra) # 80000f9a <myproc>
    800021fa:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021fc:	fdc42503          	lw	a0,-36(s0)
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	0f4080e7          	jalr	244(ra) # 800012f4 <growproc>
    80002208:	00054863          	bltz	a0,80002218 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000220c:	8526                	mv	a0,s1
    8000220e:	64e2                	ld	s1,24(sp)
}
    80002210:	70a2                	ld	ra,40(sp)
    80002212:	7402                	ld	s0,32(sp)
    80002214:	6145                	addi	sp,sp,48
    80002216:	8082                	ret
    return -1;
    80002218:	557d                	li	a0,-1
    8000221a:	64e2                	ld	s1,24(sp)
    8000221c:	bfd5                	j	80002210 <sys_sbrk+0x3e>

000000008000221e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000221e:	7139                	addi	sp,sp,-64
    80002220:	fc06                	sd	ra,56(sp)
    80002222:	f822                	sd	s0,48(sp)
    80002224:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002226:	fcc40593          	addi	a1,s0,-52
    8000222a:	4501                	li	a0,0
    8000222c:	00000097          	auipc	ra,0x0
    80002230:	e2e080e7          	jalr	-466(ra) # 8000205a <argint>
    return -1;
    80002234:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002236:	06054b63          	bltz	a0,800022ac <sys_sleep+0x8e>
    8000223a:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000223c:	00010517          	auipc	a0,0x10
    80002240:	f7450513          	addi	a0,a0,-140 # 800121b0 <tickslock>
    80002244:	00004097          	auipc	ra,0x4
    80002248:	516080e7          	jalr	1302(ra) # 8000675a <acquire>
  ticks0 = ticks;
    8000224c:	0000a917          	auipc	s2,0xa
    80002250:	dcc92903          	lw	s2,-564(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    80002254:	fcc42783          	lw	a5,-52(s0)
    80002258:	c3a1                	beqz	a5,80002298 <sys_sleep+0x7a>
    8000225a:	f426                	sd	s1,40(sp)
    8000225c:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000225e:	00010997          	auipc	s3,0x10
    80002262:	f5298993          	addi	s3,s3,-174 # 800121b0 <tickslock>
    80002266:	0000a497          	auipc	s1,0xa
    8000226a:	db248493          	addi	s1,s1,-590 # 8000c018 <ticks>
    if(myproc()->killed){
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	d2c080e7          	jalr	-724(ra) # 80000f9a <myproc>
    80002276:	591c                	lw	a5,48(a0)
    80002278:	ef9d                	bnez	a5,800022b6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000227a:	85ce                	mv	a1,s3
    8000227c:	8526                	mv	a0,s1
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	3e2080e7          	jalr	994(ra) # 80001660 <sleep>
  while(ticks - ticks0 < n){
    80002286:	409c                	lw	a5,0(s1)
    80002288:	412787bb          	subw	a5,a5,s2
    8000228c:	fcc42703          	lw	a4,-52(s0)
    80002290:	fce7efe3          	bltu	a5,a4,8000226e <sys_sleep+0x50>
    80002294:	74a2                	ld	s1,40(sp)
    80002296:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002298:	00010517          	auipc	a0,0x10
    8000229c:	f1850513          	addi	a0,a0,-232 # 800121b0 <tickslock>
    800022a0:	00004097          	auipc	ra,0x4
    800022a4:	582080e7          	jalr	1410(ra) # 80006822 <release>
  return 0;
    800022a8:	4781                	li	a5,0
    800022aa:	7902                	ld	s2,32(sp)
}
    800022ac:	853e                	mv	a0,a5
    800022ae:	70e2                	ld	ra,56(sp)
    800022b0:	7442                	ld	s0,48(sp)
    800022b2:	6121                	addi	sp,sp,64
    800022b4:	8082                	ret
      release(&tickslock);
    800022b6:	00010517          	auipc	a0,0x10
    800022ba:	efa50513          	addi	a0,a0,-262 # 800121b0 <tickslock>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	564080e7          	jalr	1380(ra) # 80006822 <release>
      return -1;
    800022c6:	57fd                	li	a5,-1
    800022c8:	74a2                	ld	s1,40(sp)
    800022ca:	7902                	ld	s2,32(sp)
    800022cc:	69e2                	ld	s3,24(sp)
    800022ce:	bff9                	j	800022ac <sys_sleep+0x8e>

00000000800022d0 <sys_kill>:

uint64
sys_kill(void)
{
    800022d0:	1101                	addi	sp,sp,-32
    800022d2:	ec06                	sd	ra,24(sp)
    800022d4:	e822                	sd	s0,16(sp)
    800022d6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022d8:	fec40593          	addi	a1,s0,-20
    800022dc:	4501                	li	a0,0
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	d7c080e7          	jalr	-644(ra) # 8000205a <argint>
    800022e6:	87aa                	mv	a5,a0
    return -1;
    800022e8:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022ea:	0007c863          	bltz	a5,800022fa <sys_kill+0x2a>
  return kill(pid);
    800022ee:	fec42503          	lw	a0,-20(s0)
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	6a0080e7          	jalr	1696(ra) # 80001992 <kill>
}
    800022fa:	60e2                	ld	ra,24(sp)
    800022fc:	6442                	ld	s0,16(sp)
    800022fe:	6105                	addi	sp,sp,32
    80002300:	8082                	ret

0000000080002302 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002302:	1101                	addi	sp,sp,-32
    80002304:	ec06                	sd	ra,24(sp)
    80002306:	e822                	sd	s0,16(sp)
    80002308:	e426                	sd	s1,8(sp)
    8000230a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000230c:	00010517          	auipc	a0,0x10
    80002310:	ea450513          	addi	a0,a0,-348 # 800121b0 <tickslock>
    80002314:	00004097          	auipc	ra,0x4
    80002318:	446080e7          	jalr	1094(ra) # 8000675a <acquire>
  xticks = ticks;
    8000231c:	0000a497          	auipc	s1,0xa
    80002320:	cfc4a483          	lw	s1,-772(s1) # 8000c018 <ticks>
  release(&tickslock);
    80002324:	00010517          	auipc	a0,0x10
    80002328:	e8c50513          	addi	a0,a0,-372 # 800121b0 <tickslock>
    8000232c:	00004097          	auipc	ra,0x4
    80002330:	4f6080e7          	jalr	1270(ra) # 80006822 <release>
  return xticks;
}
    80002334:	02049513          	slli	a0,s1,0x20
    80002338:	9101                	srli	a0,a0,0x20
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	64a2                	ld	s1,8(sp)
    80002340:	6105                	addi	sp,sp,32
    80002342:	8082                	ret

0000000080002344 <hash>:
  // head.next is most recent, head.prev is least.
  struct buf head[NBUCKETS];
} bcache;

int hash(uint blockno)
{
    80002344:	1141                	addi	sp,sp,-16
    80002346:	e422                	sd	s0,8(sp)
    80002348:	0800                	addi	s0,sp,16
  return blockno % NBUCKETS;
    8000234a:	47b5                	li	a5,13
    8000234c:	02f5753b          	remuw	a0,a0,a5
}
    80002350:	2501                	sext.w	a0,a0
    80002352:	6422                	ld	s0,8(sp)
    80002354:	0141                	addi	sp,sp,16
    80002356:	8082                	ret

0000000080002358 <binit>:
void
binit(void)
{
    80002358:	7179                	addi	sp,sp,-48
    8000235a:	f406                	sd	ra,40(sp)
    8000235c:	f022                	sd	s0,32(sp)
    8000235e:	ec26                	sd	s1,24(sp)
    80002360:	e84a                	sd	s2,16(sp)
    80002362:	e44e                	sd	s3,8(sp)
    80002364:	e052                	sd	s4,0(sp)
    80002366:	1800                	addi	s0,sp,48
  struct buf *b;

  for (int i = 0; i < NBUCKETS; i++)
    80002368:	00010917          	auipc	s2,0x10
    8000236c:	e6890913          	addi	s2,s2,-408 # 800121d0 <bcache>
    80002370:	00010a17          	auipc	s4,0x10
    80002374:	000a0a13          	mv	s4,s4
{
    80002378:	84ca                	mv	s1,s2
  {
    initlock(&bcache.lock[i], "bcache"); 
    8000237a:	00006997          	auipc	s3,0x6
    8000237e:	00698993          	addi	s3,s3,6 # 80008380 <etext+0x380>
    80002382:	85ce                	mv	a1,s3
    80002384:	8526                	mv	a0,s1
    80002386:	00004097          	auipc	ra,0x4
    8000238a:	548080e7          	jalr	1352(ra) # 800068ce <initlock>
  for (int i = 0; i < NBUCKETS; i++)
    8000238e:	02048493          	addi	s1,s1,32
    80002392:	ff4498e3          	bne	s1,s4,80002382 <binit+0x2a>
    80002396:	00018797          	auipc	a5,0x18
    8000239a:	31a78793          	addi	a5,a5,794 # 8001a6b0 <bcache+0x84e0>
    8000239e:	6731                	lui	a4,0xc
    800023a0:	dc070713          	addi	a4,a4,-576 # bdc0 <_entry-0x7fff4240>
    800023a4:	974a                	add	a4,a4,s2
  }

  // Create linked list of buffers
  for(int i =0;i<NBUCKETS;i++)
  {
    bcache.head[i].prev = &bcache.head[i];
    800023a6:	ebbc                	sd	a5,80(a5)
    bcache.head[i].next = &bcache.head[i];
    800023a8:	efbc                	sd	a5,88(a5)
  for(int i =0;i<NBUCKETS;i++)
    800023aa:	46078793          	addi	a5,a5,1120
    800023ae:	fee79ce3          	bne	a5,a4,800023a6 <binit+0x4e>
  }

  for(b = bcache.buf; b < bcache.buf+NBUF; b++)
    800023b2:	00010497          	auipc	s1,0x10
    800023b6:	fbe48493          	addi	s1,s1,-66 # 80012370 <bcache+0x1a0>
  {
    b->next = bcache.head[0].next;
    800023ba:	00018917          	auipc	s2,0x18
    800023be:	e1690913          	addi	s2,s2,-490 # 8001a1d0 <bcache+0x8000>
    b->prev = &bcache.head[0];
    800023c2:	00018997          	auipc	s3,0x18
    800023c6:	2ee98993          	addi	s3,s3,750 # 8001a6b0 <bcache+0x84e0>

    initsleeplock(&b->lock, "buffer");
    800023ca:	00006a17          	auipc	s4,0x6
    800023ce:	fbea0a13          	addi	s4,s4,-66 # 80008388 <etext+0x388>
    b->next = bcache.head[0].next;
    800023d2:	53893783          	ld	a5,1336(s2)
    800023d6:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head[0];
    800023d8:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    800023dc:	85d2                	mv	a1,s4
    800023de:	01048513          	addi	a0,s1,16
    800023e2:	00001097          	auipc	ra,0x1
    800023e6:	5b0080e7          	jalr	1456(ra) # 80003992 <initsleeplock>
    bcache.head[0].next->prev = b;
    800023ea:	53893783          	ld	a5,1336(s2)
    800023ee:	eba4                	sd	s1,80(a5)
    bcache.head[0].next = b;
    800023f0:	52993c23          	sd	s1,1336(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++)
    800023f4:	46048493          	addi	s1,s1,1120
    800023f8:	fd349de3          	bne	s1,s3,800023d2 <binit+0x7a>
  }
}
    800023fc:	70a2                	ld	ra,40(sp)
    800023fe:	7402                	ld	s0,32(sp)
    80002400:	64e2                	ld	s1,24(sp)
    80002402:	6942                	ld	s2,16(sp)
    80002404:	69a2                	ld	s3,8(sp)
    80002406:	6a02                	ld	s4,0(sp)
    80002408:	6145                	addi	sp,sp,48
    8000240a:	8082                	ret

000000008000240c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000240c:	7119                	addi	sp,sp,-128
    8000240e:	fc86                	sd	ra,120(sp)
    80002410:	f8a2                	sd	s0,112(sp)
    80002412:	f4a6                	sd	s1,104(sp)
    80002414:	f0ca                	sd	s2,96(sp)
    80002416:	ecce                	sd	s3,88(sp)
    80002418:	e4d6                	sd	s5,72(sp)
    8000241a:	e0da                	sd	s6,64(sp)
    8000241c:	f466                	sd	s9,40(sp)
    8000241e:	0100                	addi	s0,sp,128
    80002420:	89aa                	mv	s3,a0
    80002422:	8b2e                	mv	s6,a1
  return blockno % NBUCKETS;
    80002424:	4ab5                	li	s5,13
    80002426:	0355fabb          	remuw	s5,a1,s5
    8000242a:	2a81                	sext.w	s5,s5
  acquire(&bcache.lock[id]);
    8000242c:	005a9c93          	slli	s9,s5,0x5
    80002430:	00010497          	auipc	s1,0x10
    80002434:	da048493          	addi	s1,s1,-608 # 800121d0 <bcache>
    80002438:	009c87b3          	add	a5,s9,s1
    8000243c:	f8f43423          	sd	a5,-120(s0)
    80002440:	853e                	mv	a0,a5
    80002442:	00004097          	auipc	ra,0x4
    80002446:	318080e7          	jalr	792(ra) # 8000675a <acquire>
  for(b=bcache.head[id].next;b!=&bcache.head[id];b=b->next)
    8000244a:	46000713          	li	a4,1120
    8000244e:	02ea8733          	mul	a4,s5,a4
    80002452:	00e486b3          	add	a3,s1,a4
    80002456:	67a1                	lui	a5,0x8
    80002458:	97b6                	add	a5,a5,a3
    8000245a:	5387b903          	ld	s2,1336(a5) # 8538 <_entry-0x7fff7ac8>
    8000245e:	67a1                	lui	a5,0x8
    80002460:	4e078793          	addi	a5,a5,1248 # 84e0 <_entry-0x7fff7b20>
    80002464:	973e                	add	a4,a4,a5
    80002466:	9726                	add	a4,a4,s1
    80002468:	03271663          	bne	a4,s2,80002494 <bread+0x88>
    8000246c:	e8d2                	sd	s4,80(sp)
    8000246e:	fc5e                	sd	s7,56(sp)
    80002470:	f862                	sd	s8,48(sp)
    80002472:	f06a                	sd	s10,32(sp)
    80002474:	ec6e                	sd	s11,24(sp)
  int i = id;
    80002476:	8a56                	mv	s4,s5
    i = (i + 1) % NBUCKETS;
    80002478:	4db5                	li	s11,13
    acquire(&bcache.lock[i]);
    8000247a:	00010c17          	auipc	s8,0x10
    8000247e:	d56c0c13          	addi	s8,s8,-682 # 800121d0 <bcache>
    for(b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev)
    80002482:	6ca1                	lui	s9,0x8
    80002484:	6d21                	lui	s10,0x8
    80002486:	4e0d0d13          	addi	s10,s10,1248 # 84e0 <_entry-0x7fff7b20>
    8000248a:	a8d1                	j	8000255e <bread+0x152>
  for(b=bcache.head[id].next;b!=&bcache.head[id];b=b->next)
    8000248c:	05893903          	ld	s2,88(s2)
    80002490:	fd270ee3          	beq	a4,s2,8000246c <bread+0x60>
    if(b->dev==dev&&b->blockno == blockno)
    80002494:	00892783          	lw	a5,8(s2)
    80002498:	ff379ae3          	bne	a5,s3,8000248c <bread+0x80>
    8000249c:	00c92783          	lw	a5,12(s2)
    800024a0:	ff6796e3          	bne	a5,s6,8000248c <bread+0x80>
      b->refcnt++;
    800024a4:	04892783          	lw	a5,72(s2)
    800024a8:	2785                	addiw	a5,a5,1
    800024aa:	04f92423          	sw	a5,72(s2)
      release(&bcache.lock[id]);
    800024ae:	f8843503          	ld	a0,-120(s0)
    800024b2:	00004097          	auipc	ra,0x4
    800024b6:	370080e7          	jalr	880(ra) # 80006822 <release>
      acquiresleep(&b->lock);
    800024ba:	01090513          	addi	a0,s2,16
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	50e080e7          	jalr	1294(ra) # 800039cc <acquiresleep>
      return b;
    800024c6:	84ca                	mv	s1,s2
    800024c8:	a88d                	j	8000253a <bread+0x12e>
    800024ca:	8a56                	mv	s4,s5
    800024cc:	a849                	j	8000255e <bread+0x152>
        b->dev = dev;
    800024ce:	0134a423          	sw	s3,8(s1)
        b->blockno = blockno;
    800024d2:	0164a623          	sw	s6,12(s1)
        b->valid = 0;
    800024d6:	0004a023          	sw	zero,0(s1)
        b->refcnt = 1;
    800024da:	4785                	li	a5,1
    800024dc:	c4bc                	sw	a5,72(s1)
        b->prev->next = b->next;
    800024de:	68b8                	ld	a4,80(s1)
    800024e0:	6cbc                	ld	a5,88(s1)
    800024e2:	ef3c                	sd	a5,88(a4)
        b->next->prev = b->prev;
    800024e4:	68b8                	ld	a4,80(s1)
    800024e6:	ebb8                	sd	a4,80(a5)
        release(&bcache.lock[i]);
    800024e8:	855e                	mv	a0,s7
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	338080e7          	jalr	824(ra) # 80006822 <release>
        b->prev = &bcache.head[id];
    800024f2:	0524b823          	sd	s2,80(s1)
        b->next = bcache.head[id].next;
    800024f6:	46000793          	li	a5,1120
    800024fa:	02fa8ab3          	mul	s5,s5,a5
    800024fe:	00010717          	auipc	a4,0x10
    80002502:	cd270713          	addi	a4,a4,-814 # 800121d0 <bcache>
    80002506:	9756                	add	a4,a4,s5
    80002508:	67a1                	lui	a5,0x8
    8000250a:	97ba                	add	a5,a5,a4
    8000250c:	5387b783          	ld	a5,1336(a5) # 8538 <_entry-0x7fff7ac8>
    80002510:	ecbc                	sd	a5,88(s1)
        b->next->prev = b;
    80002512:	eba4                	sd	s1,80(a5)
        b->prev->next = b;
    80002514:	68bc                	ld	a5,80(s1)
    80002516:	efa4                	sd	s1,88(a5)
        release(&bcache.lock[id]);
    80002518:	f8843503          	ld	a0,-120(s0)
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	306080e7          	jalr	774(ra) # 80006822 <release>
        acquiresleep(&b->lock);
    80002524:	01048513          	addi	a0,s1,16
    80002528:	00001097          	auipc	ra,0x1
    8000252c:	4a4080e7          	jalr	1188(ra) # 800039cc <acquiresleep>
        return b;
    80002530:	6a46                	ld	s4,80(sp)
    80002532:	7be2                	ld	s7,56(sp)
    80002534:	7c42                	ld	s8,48(sp)
    80002536:	7d02                	ld	s10,32(sp)
    80002538:	6de2                	ld	s11,24(sp)
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000253a:	409c                	lw	a5,0(s1)
    8000253c:	c3ad                	beqz	a5,8000259e <bread+0x192>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000253e:	8526                	mv	a0,s1
    80002540:	70e6                	ld	ra,120(sp)
    80002542:	7446                	ld	s0,112(sp)
    80002544:	74a6                	ld	s1,104(sp)
    80002546:	7906                	ld	s2,96(sp)
    80002548:	69e6                	ld	s3,88(sp)
    8000254a:	6aa6                	ld	s5,72(sp)
    8000254c:	6b06                	ld	s6,64(sp)
    8000254e:	7ca2                	ld	s9,40(sp)
    80002550:	6109                	addi	sp,sp,128
    80002552:	8082                	ret
    release(&bcache.lock[i]);
    80002554:	855e                	mv	a0,s7
    80002556:	00004097          	auipc	ra,0x4
    8000255a:	2cc080e7          	jalr	716(ra) # 80006822 <release>
    i = (i + 1) % NBUCKETS;
    8000255e:	2a05                	addiw	s4,s4,1
    80002560:	03ba6a3b          	remw	s4,s4,s11
    if (i == id) continue;
    80002564:	f75a03e3          	beq	s4,s5,800024ca <bread+0xbe>
    acquire(&bcache.lock[i]);
    80002568:	005a1b93          	slli	s7,s4,0x5
    8000256c:	9be2                	add	s7,s7,s8
    8000256e:	855e                	mv	a0,s7
    80002570:	00004097          	auipc	ra,0x4
    80002574:	1ea080e7          	jalr	490(ra) # 8000675a <acquire>
    for(b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev)
    80002578:	46000793          	li	a5,1120
    8000257c:	02fa0733          	mul	a4,s4,a5
    80002580:	00ec07b3          	add	a5,s8,a4
    80002584:	97e6                	add	a5,a5,s9
    80002586:	5307b483          	ld	s1,1328(a5)
    8000258a:	976a                	add	a4,a4,s10
    8000258c:	9762                	add	a4,a4,s8
    8000258e:	fce483e3          	beq	s1,a4,80002554 <bread+0x148>
      if(b->refcnt == 0) 
    80002592:	44bc                	lw	a5,72(s1)
    80002594:	df8d                	beqz	a5,800024ce <bread+0xc2>
    for(b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev)
    80002596:	68a4                	ld	s1,80(s1)
    80002598:	fee49de3          	bne	s1,a4,80002592 <bread+0x186>
    8000259c:	bf65                	j	80002554 <bread+0x148>
    virtio_disk_rw(b, 0);
    8000259e:	4581                	li	a1,0
    800025a0:	8526                	mv	a0,s1
    800025a2:	00003097          	auipc	ra,0x3
    800025a6:	040080e7          	jalr	64(ra) # 800055e2 <virtio_disk_rw>
    b->valid = 1;
    800025aa:	4785                	li	a5,1
    800025ac:	c09c                	sw	a5,0(s1)
  return b;
    800025ae:	bf41                	j	8000253e <bread+0x132>

00000000800025b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025b0:	1101                	addi	sp,sp,-32
    800025b2:	ec06                	sd	ra,24(sp)
    800025b4:	e822                	sd	s0,16(sp)
    800025b6:	e426                	sd	s1,8(sp)
    800025b8:	1000                	addi	s0,sp,32
    800025ba:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025bc:	0541                	addi	a0,a0,16
    800025be:	00001097          	auipc	ra,0x1
    800025c2:	4a8080e7          	jalr	1192(ra) # 80003a66 <holdingsleep>
    800025c6:	cd01                	beqz	a0,800025de <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025c8:	4585                	li	a1,1
    800025ca:	8526                	mv	a0,s1
    800025cc:	00003097          	auipc	ra,0x3
    800025d0:	016080e7          	jalr	22(ra) # 800055e2 <virtio_disk_rw>
}
    800025d4:	60e2                	ld	ra,24(sp)
    800025d6:	6442                	ld	s0,16(sp)
    800025d8:	64a2                	ld	s1,8(sp)
    800025da:	6105                	addi	sp,sp,32
    800025dc:	8082                	ret
    panic("bwrite");
    800025de:	00006517          	auipc	a0,0x6
    800025e2:	db250513          	addi	a0,a0,-590 # 80008390 <etext+0x390>
    800025e6:	00004097          	auipc	ra,0x4
    800025ea:	c10080e7          	jalr	-1008(ra) # 800061f6 <panic>

00000000800025ee <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025ee:	7179                	addi	sp,sp,-48
    800025f0:	f406                	sd	ra,40(sp)
    800025f2:	f022                	sd	s0,32(sp)
    800025f4:	ec26                	sd	s1,24(sp)
    800025f6:	e84a                	sd	s2,16(sp)
    800025f8:	e44e                	sd	s3,8(sp)
    800025fa:	1800                	addi	s0,sp,48
    800025fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025fe:	01050993          	addi	s3,a0,16
    80002602:	854e                	mv	a0,s3
    80002604:	00001097          	auipc	ra,0x1
    80002608:	462080e7          	jalr	1122(ra) # 80003a66 <holdingsleep>
    8000260c:	c959                	beqz	a0,800026a2 <brelse+0xb4>
  return blockno % NBUCKETS;
    8000260e:	00c4a903          	lw	s2,12(s1)
    80002612:	47b5                	li	a5,13
    80002614:	02f9793b          	remuw	s2,s2,a5
    80002618:	2901                	sext.w	s2,s2
    panic("brelse");

  int id = hash(b->blockno);
  releasesleep(&b->lock);
    8000261a:	854e                	mv	a0,s3
    8000261c:	00001097          	auipc	ra,0x1
    80002620:	406080e7          	jalr	1030(ra) # 80003a22 <releasesleep>

  acquire(&bcache.lock[id]);
    80002624:	00591993          	slli	s3,s2,0x5
    80002628:	00010797          	auipc	a5,0x10
    8000262c:	ba878793          	addi	a5,a5,-1112 # 800121d0 <bcache>
    80002630:	99be                	add	s3,s3,a5
    80002632:	854e                	mv	a0,s3
    80002634:	00004097          	auipc	ra,0x4
    80002638:	126080e7          	jalr	294(ra) # 8000675a <acquire>
  b->refcnt--;
    8000263c:	44bc                	lw	a5,72(s1)
    8000263e:	37fd                	addiw	a5,a5,-1
    80002640:	0007871b          	sext.w	a4,a5
    80002644:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    80002646:	e331                	bnez	a4,8000268a <brelse+0x9c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002648:	6cb8                	ld	a4,88(s1)
    8000264a:	68bc                	ld	a5,80(s1)
    8000264c:	eb3c                	sd	a5,80(a4)
    b->prev->next = b->next;
    8000264e:	6cb8                	ld	a4,88(s1)
    80002650:	efb8                	sd	a4,88(a5)
    b->next = bcache.head[id].next;
    80002652:	00010697          	auipc	a3,0x10
    80002656:	b7e68693          	addi	a3,a3,-1154 # 800121d0 <bcache>
    8000265a:	46000613          	li	a2,1120
    8000265e:	02c90733          	mul	a4,s2,a2
    80002662:	9736                	add	a4,a4,a3
    80002664:	67a1                	lui	a5,0x8
    80002666:	97ba                	add	a5,a5,a4
    80002668:	5387b703          	ld	a4,1336(a5) # 8538 <_entry-0x7fff7ac8>
    8000266c:	ecb8                	sd	a4,88(s1)
    b->prev = &bcache.head[id];
    8000266e:	02c90933          	mul	s2,s2,a2
    80002672:	6721                	lui	a4,0x8
    80002674:	4e070713          	addi	a4,a4,1248 # 84e0 <_entry-0x7fff7b20>
    80002678:	993a                	add	s2,s2,a4
    8000267a:	9936                	add	s2,s2,a3
    8000267c:	0524b823          	sd	s2,80(s1)
    bcache.head[id].next->prev = b;
    80002680:	5387b703          	ld	a4,1336(a5)
    80002684:	eb24                	sd	s1,80(a4)
    bcache.head[id].next = b;
    80002686:	5297bc23          	sd	s1,1336(a5)
  }
  
  release(&bcache.lock[id]);
    8000268a:	854e                	mv	a0,s3
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	196080e7          	jalr	406(ra) # 80006822 <release>
}
    80002694:	70a2                	ld	ra,40(sp)
    80002696:	7402                	ld	s0,32(sp)
    80002698:	64e2                	ld	s1,24(sp)
    8000269a:	6942                	ld	s2,16(sp)
    8000269c:	69a2                	ld	s3,8(sp)
    8000269e:	6145                	addi	sp,sp,48
    800026a0:	8082                	ret
    panic("brelse");
    800026a2:	00006517          	auipc	a0,0x6
    800026a6:	cf650513          	addi	a0,a0,-778 # 80008398 <etext+0x398>
    800026aa:	00004097          	auipc	ra,0x4
    800026ae:	b4c080e7          	jalr	-1204(ra) # 800061f6 <panic>

00000000800026b2 <bpin>:

void
bpin(struct buf *b) {
    800026b2:	1101                	addi	sp,sp,-32
    800026b4:	ec06                	sd	ra,24(sp)
    800026b6:	e822                	sd	s0,16(sp)
    800026b8:	e426                	sd	s1,8(sp)
    800026ba:	e04a                	sd	s2,0(sp)
    800026bc:	1000                	addi	s0,sp,32
    800026be:	892a                	mv	s2,a0
  return blockno % NBUCKETS;
    800026c0:	4544                	lw	s1,12(a0)
    800026c2:	47b5                	li	a5,13
    800026c4:	02f4f4bb          	remuw	s1,s1,a5
  int id =hash(b->blockno);
  acquire(&bcache.lock[id]);
    800026c8:	2481                	sext.w	s1,s1
    800026ca:	0496                	slli	s1,s1,0x5
    800026cc:	00010797          	auipc	a5,0x10
    800026d0:	b0478793          	addi	a5,a5,-1276 # 800121d0 <bcache>
    800026d4:	94be                	add	s1,s1,a5
    800026d6:	8526                	mv	a0,s1
    800026d8:	00004097          	auipc	ra,0x4
    800026dc:	082080e7          	jalr	130(ra) # 8000675a <acquire>
  b->refcnt++;
    800026e0:	04892783          	lw	a5,72(s2)
    800026e4:	2785                	addiw	a5,a5,1
    800026e6:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[id]);
    800026ea:	8526                	mv	a0,s1
    800026ec:	00004097          	auipc	ra,0x4
    800026f0:	136080e7          	jalr	310(ra) # 80006822 <release>
}
    800026f4:	60e2                	ld	ra,24(sp)
    800026f6:	6442                	ld	s0,16(sp)
    800026f8:	64a2                	ld	s1,8(sp)
    800026fa:	6902                	ld	s2,0(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret

0000000080002700 <bunpin>:

void
bunpin(struct buf *b) {
    80002700:	1101                	addi	sp,sp,-32
    80002702:	ec06                	sd	ra,24(sp)
    80002704:	e822                	sd	s0,16(sp)
    80002706:	e426                	sd	s1,8(sp)
    80002708:	e04a                	sd	s2,0(sp)
    8000270a:	1000                	addi	s0,sp,32
    8000270c:	892a                	mv	s2,a0
  return blockno % NBUCKETS;
    8000270e:	4544                	lw	s1,12(a0)
    80002710:	47b5                	li	a5,13
    80002712:	02f4f4bb          	remuw	s1,s1,a5
  int id = hash(b->blockno);
  acquire(&bcache.lock[id]);
    80002716:	2481                	sext.w	s1,s1
    80002718:	0496                	slli	s1,s1,0x5
    8000271a:	00010797          	auipc	a5,0x10
    8000271e:	ab678793          	addi	a5,a5,-1354 # 800121d0 <bcache>
    80002722:	94be                	add	s1,s1,a5
    80002724:	8526                	mv	a0,s1
    80002726:	00004097          	auipc	ra,0x4
    8000272a:	034080e7          	jalr	52(ra) # 8000675a <acquire>
  b->refcnt--;
    8000272e:	04892783          	lw	a5,72(s2)
    80002732:	37fd                	addiw	a5,a5,-1
    80002734:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[id]);
    80002738:	8526                	mv	a0,s1
    8000273a:	00004097          	auipc	ra,0x4
    8000273e:	0e8080e7          	jalr	232(ra) # 80006822 <release>
}
    80002742:	60e2                	ld	ra,24(sp)
    80002744:	6442                	ld	s0,16(sp)
    80002746:	64a2                	ld	s1,8(sp)
    80002748:	6902                	ld	s2,0(sp)
    8000274a:	6105                	addi	sp,sp,32
    8000274c:	8082                	ret

000000008000274e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	e04a                	sd	s2,0(sp)
    80002758:	1000                	addi	s0,sp,32
    8000275a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000275c:	00d5d59b          	srliw	a1,a1,0xd
    80002760:	0001c797          	auipc	a5,0x1c
    80002764:	84c7a783          	lw	a5,-1972(a5) # 8001dfac <sb+0x1c>
    80002768:	9dbd                	addw	a1,a1,a5
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	ca2080e7          	jalr	-862(ra) # 8000240c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002772:	0074f713          	andi	a4,s1,7
    80002776:	4785                	li	a5,1
    80002778:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000277c:	14ce                	slli	s1,s1,0x33
    8000277e:	90d9                	srli	s1,s1,0x36
    80002780:	00950733          	add	a4,a0,s1
    80002784:	06074703          	lbu	a4,96(a4)
    80002788:	00e7f6b3          	and	a3,a5,a4
    8000278c:	c69d                	beqz	a3,800027ba <bfree+0x6c>
    8000278e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002790:	94aa                	add	s1,s1,a0
    80002792:	fff7c793          	not	a5,a5
    80002796:	8f7d                	and	a4,a4,a5
    80002798:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    8000279c:	00001097          	auipc	ra,0x1
    800027a0:	112080e7          	jalr	274(ra) # 800038ae <log_write>
  brelse(bp);
    800027a4:	854a                	mv	a0,s2
    800027a6:	00000097          	auipc	ra,0x0
    800027aa:	e48080e7          	jalr	-440(ra) # 800025ee <brelse>
}
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6902                	ld	s2,0(sp)
    800027b6:	6105                	addi	sp,sp,32
    800027b8:	8082                	ret
    panic("freeing free block");
    800027ba:	00006517          	auipc	a0,0x6
    800027be:	be650513          	addi	a0,a0,-1050 # 800083a0 <etext+0x3a0>
    800027c2:	00004097          	auipc	ra,0x4
    800027c6:	a34080e7          	jalr	-1484(ra) # 800061f6 <panic>

00000000800027ca <balloc>:
{
    800027ca:	711d                	addi	sp,sp,-96
    800027cc:	ec86                	sd	ra,88(sp)
    800027ce:	e8a2                	sd	s0,80(sp)
    800027d0:	e4a6                	sd	s1,72(sp)
    800027d2:	e0ca                	sd	s2,64(sp)
    800027d4:	fc4e                	sd	s3,56(sp)
    800027d6:	f852                	sd	s4,48(sp)
    800027d8:	f456                	sd	s5,40(sp)
    800027da:	f05a                	sd	s6,32(sp)
    800027dc:	ec5e                	sd	s7,24(sp)
    800027de:	e862                	sd	s8,16(sp)
    800027e0:	e466                	sd	s9,8(sp)
    800027e2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027e4:	0001b797          	auipc	a5,0x1b
    800027e8:	7b07a783          	lw	a5,1968(a5) # 8001df94 <sb+0x4>
    800027ec:	cbc1                	beqz	a5,8000287c <balloc+0xb2>
    800027ee:	8baa                	mv	s7,a0
    800027f0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027f2:	0001bb17          	auipc	s6,0x1b
    800027f6:	79eb0b13          	addi	s6,s6,1950 # 8001df90 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fa:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027fc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fe:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002800:	6c89                	lui	s9,0x2
    80002802:	a831                	j	8000281e <balloc+0x54>
    brelse(bp);
    80002804:	854a                	mv	a0,s2
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	de8080e7          	jalr	-536(ra) # 800025ee <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000280e:	015c87bb          	addw	a5,s9,s5
    80002812:	00078a9b          	sext.w	s5,a5
    80002816:	004b2703          	lw	a4,4(s6)
    8000281a:	06eaf163          	bgeu	s5,a4,8000287c <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000281e:	41fad79b          	sraiw	a5,s5,0x1f
    80002822:	0137d79b          	srliw	a5,a5,0x13
    80002826:	015787bb          	addw	a5,a5,s5
    8000282a:	40d7d79b          	sraiw	a5,a5,0xd
    8000282e:	01cb2583          	lw	a1,28(s6)
    80002832:	9dbd                	addw	a1,a1,a5
    80002834:	855e                	mv	a0,s7
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	bd6080e7          	jalr	-1066(ra) # 8000240c <bread>
    8000283e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002840:	004b2503          	lw	a0,4(s6)
    80002844:	000a849b          	sext.w	s1,s5
    80002848:	8762                	mv	a4,s8
    8000284a:	faa4fde3          	bgeu	s1,a0,80002804 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000284e:	00777693          	andi	a3,a4,7
    80002852:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002856:	41f7579b          	sraiw	a5,a4,0x1f
    8000285a:	01d7d79b          	srliw	a5,a5,0x1d
    8000285e:	9fb9                	addw	a5,a5,a4
    80002860:	4037d79b          	sraiw	a5,a5,0x3
    80002864:	00f90633          	add	a2,s2,a5
    80002868:	06064603          	lbu	a2,96(a2)
    8000286c:	00c6f5b3          	and	a1,a3,a2
    80002870:	cd91                	beqz	a1,8000288c <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002872:	2705                	addiw	a4,a4,1
    80002874:	2485                	addiw	s1,s1,1
    80002876:	fd471ae3          	bne	a4,s4,8000284a <balloc+0x80>
    8000287a:	b769                	j	80002804 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000287c:	00006517          	auipc	a0,0x6
    80002880:	b3c50513          	addi	a0,a0,-1220 # 800083b8 <etext+0x3b8>
    80002884:	00004097          	auipc	ra,0x4
    80002888:	972080e7          	jalr	-1678(ra) # 800061f6 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000288c:	97ca                	add	a5,a5,s2
    8000288e:	8e55                	or	a2,a2,a3
    80002890:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    80002894:	854a                	mv	a0,s2
    80002896:	00001097          	auipc	ra,0x1
    8000289a:	018080e7          	jalr	24(ra) # 800038ae <log_write>
        brelse(bp);
    8000289e:	854a                	mv	a0,s2
    800028a0:	00000097          	auipc	ra,0x0
    800028a4:	d4e080e7          	jalr	-690(ra) # 800025ee <brelse>
  bp = bread(dev, bno);
    800028a8:	85a6                	mv	a1,s1
    800028aa:	855e                	mv	a0,s7
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	b60080e7          	jalr	-1184(ra) # 8000240c <bread>
    800028b4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028b6:	40000613          	li	a2,1024
    800028ba:	4581                	li	a1,0
    800028bc:	06050513          	addi	a0,a0,96
    800028c0:	ffffe097          	auipc	ra,0xffffe
    800028c4:	9c8080e7          	jalr	-1592(ra) # 80000288 <memset>
  log_write(bp);
    800028c8:	854a                	mv	a0,s2
    800028ca:	00001097          	auipc	ra,0x1
    800028ce:	fe4080e7          	jalr	-28(ra) # 800038ae <log_write>
  brelse(bp);
    800028d2:	854a                	mv	a0,s2
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	d1a080e7          	jalr	-742(ra) # 800025ee <brelse>
}
    800028dc:	8526                	mv	a0,s1
    800028de:	60e6                	ld	ra,88(sp)
    800028e0:	6446                	ld	s0,80(sp)
    800028e2:	64a6                	ld	s1,72(sp)
    800028e4:	6906                	ld	s2,64(sp)
    800028e6:	79e2                	ld	s3,56(sp)
    800028e8:	7a42                	ld	s4,48(sp)
    800028ea:	7aa2                	ld	s5,40(sp)
    800028ec:	7b02                	ld	s6,32(sp)
    800028ee:	6be2                	ld	s7,24(sp)
    800028f0:	6c42                	ld	s8,16(sp)
    800028f2:	6ca2                	ld	s9,8(sp)
    800028f4:	6125                	addi	sp,sp,96
    800028f6:	8082                	ret

00000000800028f8 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028f8:	7179                	addi	sp,sp,-48
    800028fa:	f406                	sd	ra,40(sp)
    800028fc:	f022                	sd	s0,32(sp)
    800028fe:	ec26                	sd	s1,24(sp)
    80002900:	e84a                	sd	s2,16(sp)
    80002902:	e44e                	sd	s3,8(sp)
    80002904:	1800                	addi	s0,sp,48
    80002906:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002908:	47ad                	li	a5,11
    8000290a:	04b7ff63          	bgeu	a5,a1,80002968 <bmap+0x70>
    8000290e:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002910:	ff45849b          	addiw	s1,a1,-12 # ff4 <_entry-0x7ffff00c>
    80002914:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002918:	0ff00793          	li	a5,255
    8000291c:	0ae7e463          	bltu	a5,a4,800029c4 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002920:	08852583          	lw	a1,136(a0)
    80002924:	c5b5                	beqz	a1,80002990 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002926:	00092503          	lw	a0,0(s2)
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	ae2080e7          	jalr	-1310(ra) # 8000240c <bread>
    80002932:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002934:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002938:	02049713          	slli	a4,s1,0x20
    8000293c:	01e75593          	srli	a1,a4,0x1e
    80002940:	00b784b3          	add	s1,a5,a1
    80002944:	0004a983          	lw	s3,0(s1)
    80002948:	04098e63          	beqz	s3,800029a4 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000294c:	8552                	mv	a0,s4
    8000294e:	00000097          	auipc	ra,0x0
    80002952:	ca0080e7          	jalr	-864(ra) # 800025ee <brelse>
    return addr;
    80002956:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002958:	854e                	mv	a0,s3
    8000295a:	70a2                	ld	ra,40(sp)
    8000295c:	7402                	ld	s0,32(sp)
    8000295e:	64e2                	ld	s1,24(sp)
    80002960:	6942                	ld	s2,16(sp)
    80002962:	69a2                	ld	s3,8(sp)
    80002964:	6145                	addi	sp,sp,48
    80002966:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002968:	02059793          	slli	a5,a1,0x20
    8000296c:	01e7d593          	srli	a1,a5,0x1e
    80002970:	00b504b3          	add	s1,a0,a1
    80002974:	0584a983          	lw	s3,88(s1)
    80002978:	fe0990e3          	bnez	s3,80002958 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000297c:	4108                	lw	a0,0(a0)
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	e4c080e7          	jalr	-436(ra) # 800027ca <balloc>
    80002986:	0005099b          	sext.w	s3,a0
    8000298a:	0534ac23          	sw	s3,88(s1)
    8000298e:	b7e9                	j	80002958 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002990:	4108                	lw	a0,0(a0)
    80002992:	00000097          	auipc	ra,0x0
    80002996:	e38080e7          	jalr	-456(ra) # 800027ca <balloc>
    8000299a:	0005059b          	sext.w	a1,a0
    8000299e:	08b92423          	sw	a1,136(s2)
    800029a2:	b751                	j	80002926 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029a4:	00092503          	lw	a0,0(s2)
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	e22080e7          	jalr	-478(ra) # 800027ca <balloc>
    800029b0:	0005099b          	sext.w	s3,a0
    800029b4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029b8:	8552                	mv	a0,s4
    800029ba:	00001097          	auipc	ra,0x1
    800029be:	ef4080e7          	jalr	-268(ra) # 800038ae <log_write>
    800029c2:	b769                	j	8000294c <bmap+0x54>
  panic("bmap: out of range");
    800029c4:	00006517          	auipc	a0,0x6
    800029c8:	a0c50513          	addi	a0,a0,-1524 # 800083d0 <etext+0x3d0>
    800029cc:	00004097          	auipc	ra,0x4
    800029d0:	82a080e7          	jalr	-2006(ra) # 800061f6 <panic>

00000000800029d4 <iget>:
{
    800029d4:	7179                	addi	sp,sp,-48
    800029d6:	f406                	sd	ra,40(sp)
    800029d8:	f022                	sd	s0,32(sp)
    800029da:	ec26                	sd	s1,24(sp)
    800029dc:	e84a                	sd	s2,16(sp)
    800029de:	e44e                	sd	s3,8(sp)
    800029e0:	e052                	sd	s4,0(sp)
    800029e2:	1800                	addi	s0,sp,48
    800029e4:	89aa                	mv	s3,a0
    800029e6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029e8:	0001b517          	auipc	a0,0x1b
    800029ec:	5c850513          	addi	a0,a0,1480 # 8001dfb0 <itable>
    800029f0:	00004097          	auipc	ra,0x4
    800029f4:	d6a080e7          	jalr	-662(ra) # 8000675a <acquire>
  empty = 0;
    800029f8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029fa:	0001b497          	auipc	s1,0x1b
    800029fe:	5d648493          	addi	s1,s1,1494 # 8001dfd0 <itable+0x20>
    80002a02:	0001d697          	auipc	a3,0x1d
    80002a06:	1ee68693          	addi	a3,a3,494 # 8001fbf0 <log>
    80002a0a:	a039                	j	80002a18 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0c:	02090b63          	beqz	s2,80002a42 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a10:	09048493          	addi	s1,s1,144
    80002a14:	02d48a63          	beq	s1,a3,80002a48 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a18:	449c                	lw	a5,8(s1)
    80002a1a:	fef059e3          	blez	a5,80002a0c <iget+0x38>
    80002a1e:	4098                	lw	a4,0(s1)
    80002a20:	ff3716e3          	bne	a4,s3,80002a0c <iget+0x38>
    80002a24:	40d8                	lw	a4,4(s1)
    80002a26:	ff4713e3          	bne	a4,s4,80002a0c <iget+0x38>
      ip->ref++;
    80002a2a:	2785                	addiw	a5,a5,1
    80002a2c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a2e:	0001b517          	auipc	a0,0x1b
    80002a32:	58250513          	addi	a0,a0,1410 # 8001dfb0 <itable>
    80002a36:	00004097          	auipc	ra,0x4
    80002a3a:	dec080e7          	jalr	-532(ra) # 80006822 <release>
      return ip;
    80002a3e:	8926                	mv	s2,s1
    80002a40:	a03d                	j	80002a6e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a42:	f7f9                	bnez	a5,80002a10 <iget+0x3c>
      empty = ip;
    80002a44:	8926                	mv	s2,s1
    80002a46:	b7e9                	j	80002a10 <iget+0x3c>
  if(empty == 0)
    80002a48:	02090c63          	beqz	s2,80002a80 <iget+0xac>
  ip->dev = dev;
    80002a4c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a50:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a54:	4785                	li	a5,1
    80002a56:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a5a:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002a5e:	0001b517          	auipc	a0,0x1b
    80002a62:	55250513          	addi	a0,a0,1362 # 8001dfb0 <itable>
    80002a66:	00004097          	auipc	ra,0x4
    80002a6a:	dbc080e7          	jalr	-580(ra) # 80006822 <release>
}
    80002a6e:	854a                	mv	a0,s2
    80002a70:	70a2                	ld	ra,40(sp)
    80002a72:	7402                	ld	s0,32(sp)
    80002a74:	64e2                	ld	s1,24(sp)
    80002a76:	6942                	ld	s2,16(sp)
    80002a78:	69a2                	ld	s3,8(sp)
    80002a7a:	6a02                	ld	s4,0(sp)
    80002a7c:	6145                	addi	sp,sp,48
    80002a7e:	8082                	ret
    panic("iget: no inodes");
    80002a80:	00006517          	auipc	a0,0x6
    80002a84:	96850513          	addi	a0,a0,-1688 # 800083e8 <etext+0x3e8>
    80002a88:	00003097          	auipc	ra,0x3
    80002a8c:	76e080e7          	jalr	1902(ra) # 800061f6 <panic>

0000000080002a90 <fsinit>:
fsinit(int dev) {
    80002a90:	7179                	addi	sp,sp,-48
    80002a92:	f406                	sd	ra,40(sp)
    80002a94:	f022                	sd	s0,32(sp)
    80002a96:	ec26                	sd	s1,24(sp)
    80002a98:	e84a                	sd	s2,16(sp)
    80002a9a:	e44e                	sd	s3,8(sp)
    80002a9c:	1800                	addi	s0,sp,48
    80002a9e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aa0:	4585                	li	a1,1
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	96a080e7          	jalr	-1686(ra) # 8000240c <bread>
    80002aaa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aac:	0001b997          	auipc	s3,0x1b
    80002ab0:	4e498993          	addi	s3,s3,1252 # 8001df90 <sb>
    80002ab4:	02000613          	li	a2,32
    80002ab8:	06050593          	addi	a1,a0,96
    80002abc:	854e                	mv	a0,s3
    80002abe:	ffffe097          	auipc	ra,0xffffe
    80002ac2:	826080e7          	jalr	-2010(ra) # 800002e4 <memmove>
  brelse(bp);
    80002ac6:	8526                	mv	a0,s1
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	b26080e7          	jalr	-1242(ra) # 800025ee <brelse>
  if(sb.magic != FSMAGIC)
    80002ad0:	0009a703          	lw	a4,0(s3)
    80002ad4:	102037b7          	lui	a5,0x10203
    80002ad8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002adc:	02f71263          	bne	a4,a5,80002b00 <fsinit+0x70>
  initlog(dev, &sb);
    80002ae0:	0001b597          	auipc	a1,0x1b
    80002ae4:	4b058593          	addi	a1,a1,1200 # 8001df90 <sb>
    80002ae8:	854a                	mv	a0,s2
    80002aea:	00001097          	auipc	ra,0x1
    80002aee:	b54080e7          	jalr	-1196(ra) # 8000363e <initlog>
}
    80002af2:	70a2                	ld	ra,40(sp)
    80002af4:	7402                	ld	s0,32(sp)
    80002af6:	64e2                	ld	s1,24(sp)
    80002af8:	6942                	ld	s2,16(sp)
    80002afa:	69a2                	ld	s3,8(sp)
    80002afc:	6145                	addi	sp,sp,48
    80002afe:	8082                	ret
    panic("invalid file system");
    80002b00:	00006517          	auipc	a0,0x6
    80002b04:	8f850513          	addi	a0,a0,-1800 # 800083f8 <etext+0x3f8>
    80002b08:	00003097          	auipc	ra,0x3
    80002b0c:	6ee080e7          	jalr	1774(ra) # 800061f6 <panic>

0000000080002b10 <iinit>:
{
    80002b10:	7179                	addi	sp,sp,-48
    80002b12:	f406                	sd	ra,40(sp)
    80002b14:	f022                	sd	s0,32(sp)
    80002b16:	ec26                	sd	s1,24(sp)
    80002b18:	e84a                	sd	s2,16(sp)
    80002b1a:	e44e                	sd	s3,8(sp)
    80002b1c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b1e:	00006597          	auipc	a1,0x6
    80002b22:	8f258593          	addi	a1,a1,-1806 # 80008410 <etext+0x410>
    80002b26:	0001b517          	auipc	a0,0x1b
    80002b2a:	48a50513          	addi	a0,a0,1162 # 8001dfb0 <itable>
    80002b2e:	00004097          	auipc	ra,0x4
    80002b32:	da0080e7          	jalr	-608(ra) # 800068ce <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b36:	0001b497          	auipc	s1,0x1b
    80002b3a:	4aa48493          	addi	s1,s1,1194 # 8001dfe0 <itable+0x30>
    80002b3e:	0001d997          	auipc	s3,0x1d
    80002b42:	0c298993          	addi	s3,s3,194 # 8001fc00 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b46:	00006917          	auipc	s2,0x6
    80002b4a:	8d290913          	addi	s2,s2,-1838 # 80008418 <etext+0x418>
    80002b4e:	85ca                	mv	a1,s2
    80002b50:	8526                	mv	a0,s1
    80002b52:	00001097          	auipc	ra,0x1
    80002b56:	e40080e7          	jalr	-448(ra) # 80003992 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b5a:	09048493          	addi	s1,s1,144
    80002b5e:	ff3498e3          	bne	s1,s3,80002b4e <iinit+0x3e>
}
    80002b62:	70a2                	ld	ra,40(sp)
    80002b64:	7402                	ld	s0,32(sp)
    80002b66:	64e2                	ld	s1,24(sp)
    80002b68:	6942                	ld	s2,16(sp)
    80002b6a:	69a2                	ld	s3,8(sp)
    80002b6c:	6145                	addi	sp,sp,48
    80002b6e:	8082                	ret

0000000080002b70 <ialloc>:
{
    80002b70:	7139                	addi	sp,sp,-64
    80002b72:	fc06                	sd	ra,56(sp)
    80002b74:	f822                	sd	s0,48(sp)
    80002b76:	f426                	sd	s1,40(sp)
    80002b78:	f04a                	sd	s2,32(sp)
    80002b7a:	ec4e                	sd	s3,24(sp)
    80002b7c:	e852                	sd	s4,16(sp)
    80002b7e:	e456                	sd	s5,8(sp)
    80002b80:	e05a                	sd	s6,0(sp)
    80002b82:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b84:	0001b717          	auipc	a4,0x1b
    80002b88:	41872703          	lw	a4,1048(a4) # 8001df9c <sb+0xc>
    80002b8c:	4785                	li	a5,1
    80002b8e:	04e7f863          	bgeu	a5,a4,80002bde <ialloc+0x6e>
    80002b92:	8aaa                	mv	s5,a0
    80002b94:	8b2e                	mv	s6,a1
    80002b96:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b98:	0001ba17          	auipc	s4,0x1b
    80002b9c:	3f8a0a13          	addi	s4,s4,1016 # 8001df90 <sb>
    80002ba0:	00495593          	srli	a1,s2,0x4
    80002ba4:	018a2783          	lw	a5,24(s4)
    80002ba8:	9dbd                	addw	a1,a1,a5
    80002baa:	8556                	mv	a0,s5
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	860080e7          	jalr	-1952(ra) # 8000240c <bread>
    80002bb4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bb6:	06050993          	addi	s3,a0,96
    80002bba:	00f97793          	andi	a5,s2,15
    80002bbe:	079a                	slli	a5,a5,0x6
    80002bc0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bc2:	00099783          	lh	a5,0(s3)
    80002bc6:	c785                	beqz	a5,80002bee <ialloc+0x7e>
    brelse(bp);
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	a26080e7          	jalr	-1498(ra) # 800025ee <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd0:	0905                	addi	s2,s2,1
    80002bd2:	00ca2703          	lw	a4,12(s4)
    80002bd6:	0009079b          	sext.w	a5,s2
    80002bda:	fce7e3e3          	bltu	a5,a4,80002ba0 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002bde:	00006517          	auipc	a0,0x6
    80002be2:	84250513          	addi	a0,a0,-1982 # 80008420 <etext+0x420>
    80002be6:	00003097          	auipc	ra,0x3
    80002bea:	610080e7          	jalr	1552(ra) # 800061f6 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bee:	04000613          	li	a2,64
    80002bf2:	4581                	li	a1,0
    80002bf4:	854e                	mv	a0,s3
    80002bf6:	ffffd097          	auipc	ra,0xffffd
    80002bfa:	692080e7          	jalr	1682(ra) # 80000288 <memset>
      dip->type = type;
    80002bfe:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c02:	8526                	mv	a0,s1
    80002c04:	00001097          	auipc	ra,0x1
    80002c08:	caa080e7          	jalr	-854(ra) # 800038ae <log_write>
      brelse(bp);
    80002c0c:	8526                	mv	a0,s1
    80002c0e:	00000097          	auipc	ra,0x0
    80002c12:	9e0080e7          	jalr	-1568(ra) # 800025ee <brelse>
      return iget(dev, inum);
    80002c16:	0009059b          	sext.w	a1,s2
    80002c1a:	8556                	mv	a0,s5
    80002c1c:	00000097          	auipc	ra,0x0
    80002c20:	db8080e7          	jalr	-584(ra) # 800029d4 <iget>
}
    80002c24:	70e2                	ld	ra,56(sp)
    80002c26:	7442                	ld	s0,48(sp)
    80002c28:	74a2                	ld	s1,40(sp)
    80002c2a:	7902                	ld	s2,32(sp)
    80002c2c:	69e2                	ld	s3,24(sp)
    80002c2e:	6a42                	ld	s4,16(sp)
    80002c30:	6aa2                	ld	s5,8(sp)
    80002c32:	6b02                	ld	s6,0(sp)
    80002c34:	6121                	addi	sp,sp,64
    80002c36:	8082                	ret

0000000080002c38 <iupdate>:
{
    80002c38:	1101                	addi	sp,sp,-32
    80002c3a:	ec06                	sd	ra,24(sp)
    80002c3c:	e822                	sd	s0,16(sp)
    80002c3e:	e426                	sd	s1,8(sp)
    80002c40:	e04a                	sd	s2,0(sp)
    80002c42:	1000                	addi	s0,sp,32
    80002c44:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c46:	415c                	lw	a5,4(a0)
    80002c48:	0047d79b          	srliw	a5,a5,0x4
    80002c4c:	0001b597          	auipc	a1,0x1b
    80002c50:	35c5a583          	lw	a1,860(a1) # 8001dfa8 <sb+0x18>
    80002c54:	9dbd                	addw	a1,a1,a5
    80002c56:	4108                	lw	a0,0(a0)
    80002c58:	fffff097          	auipc	ra,0xfffff
    80002c5c:	7b4080e7          	jalr	1972(ra) # 8000240c <bread>
    80002c60:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c62:	06050793          	addi	a5,a0,96
    80002c66:	40d8                	lw	a4,4(s1)
    80002c68:	8b3d                	andi	a4,a4,15
    80002c6a:	071a                	slli	a4,a4,0x6
    80002c6c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c6e:	04c49703          	lh	a4,76(s1)
    80002c72:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c76:	04e49703          	lh	a4,78(s1)
    80002c7a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c7e:	05049703          	lh	a4,80(s1)
    80002c82:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c86:	05249703          	lh	a4,82(s1)
    80002c8a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c8e:	48f8                	lw	a4,84(s1)
    80002c90:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c92:	03400613          	li	a2,52
    80002c96:	05848593          	addi	a1,s1,88
    80002c9a:	00c78513          	addi	a0,a5,12
    80002c9e:	ffffd097          	auipc	ra,0xffffd
    80002ca2:	646080e7          	jalr	1606(ra) # 800002e4 <memmove>
  log_write(bp);
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	00001097          	auipc	ra,0x1
    80002cac:	c06080e7          	jalr	-1018(ra) # 800038ae <log_write>
  brelse(bp);
    80002cb0:	854a                	mv	a0,s2
    80002cb2:	00000097          	auipc	ra,0x0
    80002cb6:	93c080e7          	jalr	-1732(ra) # 800025ee <brelse>
}
    80002cba:	60e2                	ld	ra,24(sp)
    80002cbc:	6442                	ld	s0,16(sp)
    80002cbe:	64a2                	ld	s1,8(sp)
    80002cc0:	6902                	ld	s2,0(sp)
    80002cc2:	6105                	addi	sp,sp,32
    80002cc4:	8082                	ret

0000000080002cc6 <idup>:
{
    80002cc6:	1101                	addi	sp,sp,-32
    80002cc8:	ec06                	sd	ra,24(sp)
    80002cca:	e822                	sd	s0,16(sp)
    80002ccc:	e426                	sd	s1,8(sp)
    80002cce:	1000                	addi	s0,sp,32
    80002cd0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cd2:	0001b517          	auipc	a0,0x1b
    80002cd6:	2de50513          	addi	a0,a0,734 # 8001dfb0 <itable>
    80002cda:	00004097          	auipc	ra,0x4
    80002cde:	a80080e7          	jalr	-1408(ra) # 8000675a <acquire>
  ip->ref++;
    80002ce2:	449c                	lw	a5,8(s1)
    80002ce4:	2785                	addiw	a5,a5,1
    80002ce6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ce8:	0001b517          	auipc	a0,0x1b
    80002cec:	2c850513          	addi	a0,a0,712 # 8001dfb0 <itable>
    80002cf0:	00004097          	auipc	ra,0x4
    80002cf4:	b32080e7          	jalr	-1230(ra) # 80006822 <release>
}
    80002cf8:	8526                	mv	a0,s1
    80002cfa:	60e2                	ld	ra,24(sp)
    80002cfc:	6442                	ld	s0,16(sp)
    80002cfe:	64a2                	ld	s1,8(sp)
    80002d00:	6105                	addi	sp,sp,32
    80002d02:	8082                	ret

0000000080002d04 <ilock>:
{
    80002d04:	1101                	addi	sp,sp,-32
    80002d06:	ec06                	sd	ra,24(sp)
    80002d08:	e822                	sd	s0,16(sp)
    80002d0a:	e426                	sd	s1,8(sp)
    80002d0c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d0e:	c10d                	beqz	a0,80002d30 <ilock+0x2c>
    80002d10:	84aa                	mv	s1,a0
    80002d12:	451c                	lw	a5,8(a0)
    80002d14:	00f05e63          	blez	a5,80002d30 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d18:	0541                	addi	a0,a0,16
    80002d1a:	00001097          	auipc	ra,0x1
    80002d1e:	cb2080e7          	jalr	-846(ra) # 800039cc <acquiresleep>
  if(ip->valid == 0){
    80002d22:	44bc                	lw	a5,72(s1)
    80002d24:	cf99                	beqz	a5,80002d42 <ilock+0x3e>
}
    80002d26:	60e2                	ld	ra,24(sp)
    80002d28:	6442                	ld	s0,16(sp)
    80002d2a:	64a2                	ld	s1,8(sp)
    80002d2c:	6105                	addi	sp,sp,32
    80002d2e:	8082                	ret
    80002d30:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d32:	00005517          	auipc	a0,0x5
    80002d36:	70650513          	addi	a0,a0,1798 # 80008438 <etext+0x438>
    80002d3a:	00003097          	auipc	ra,0x3
    80002d3e:	4bc080e7          	jalr	1212(ra) # 800061f6 <panic>
    80002d42:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d44:	40dc                	lw	a5,4(s1)
    80002d46:	0047d79b          	srliw	a5,a5,0x4
    80002d4a:	0001b597          	auipc	a1,0x1b
    80002d4e:	25e5a583          	lw	a1,606(a1) # 8001dfa8 <sb+0x18>
    80002d52:	9dbd                	addw	a1,a1,a5
    80002d54:	4088                	lw	a0,0(s1)
    80002d56:	fffff097          	auipc	ra,0xfffff
    80002d5a:	6b6080e7          	jalr	1718(ra) # 8000240c <bread>
    80002d5e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d60:	06050593          	addi	a1,a0,96
    80002d64:	40dc                	lw	a5,4(s1)
    80002d66:	8bbd                	andi	a5,a5,15
    80002d68:	079a                	slli	a5,a5,0x6
    80002d6a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d6c:	00059783          	lh	a5,0(a1)
    80002d70:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002d74:	00259783          	lh	a5,2(a1)
    80002d78:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002d7c:	00459783          	lh	a5,4(a1)
    80002d80:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002d84:	00659783          	lh	a5,6(a1)
    80002d88:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002d8c:	459c                	lw	a5,8(a1)
    80002d8e:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d90:	03400613          	li	a2,52
    80002d94:	05b1                	addi	a1,a1,12
    80002d96:	05848513          	addi	a0,s1,88
    80002d9a:	ffffd097          	auipc	ra,0xffffd
    80002d9e:	54a080e7          	jalr	1354(ra) # 800002e4 <memmove>
    brelse(bp);
    80002da2:	854a                	mv	a0,s2
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	84a080e7          	jalr	-1974(ra) # 800025ee <brelse>
    ip->valid = 1;
    80002dac:	4785                	li	a5,1
    80002dae:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002db0:	04c49783          	lh	a5,76(s1)
    80002db4:	c399                	beqz	a5,80002dba <ilock+0xb6>
    80002db6:	6902                	ld	s2,0(sp)
    80002db8:	b7bd                	j	80002d26 <ilock+0x22>
      panic("ilock: no type");
    80002dba:	00005517          	auipc	a0,0x5
    80002dbe:	68650513          	addi	a0,a0,1670 # 80008440 <etext+0x440>
    80002dc2:	00003097          	auipc	ra,0x3
    80002dc6:	434080e7          	jalr	1076(ra) # 800061f6 <panic>

0000000080002dca <iunlock>:
{
    80002dca:	1101                	addi	sp,sp,-32
    80002dcc:	ec06                	sd	ra,24(sp)
    80002dce:	e822                	sd	s0,16(sp)
    80002dd0:	e426                	sd	s1,8(sp)
    80002dd2:	e04a                	sd	s2,0(sp)
    80002dd4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dd6:	c905                	beqz	a0,80002e06 <iunlock+0x3c>
    80002dd8:	84aa                	mv	s1,a0
    80002dda:	01050913          	addi	s2,a0,16
    80002dde:	854a                	mv	a0,s2
    80002de0:	00001097          	auipc	ra,0x1
    80002de4:	c86080e7          	jalr	-890(ra) # 80003a66 <holdingsleep>
    80002de8:	cd19                	beqz	a0,80002e06 <iunlock+0x3c>
    80002dea:	449c                	lw	a5,8(s1)
    80002dec:	00f05d63          	blez	a5,80002e06 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002df0:	854a                	mv	a0,s2
    80002df2:	00001097          	auipc	ra,0x1
    80002df6:	c30080e7          	jalr	-976(ra) # 80003a22 <releasesleep>
}
    80002dfa:	60e2                	ld	ra,24(sp)
    80002dfc:	6442                	ld	s0,16(sp)
    80002dfe:	64a2                	ld	s1,8(sp)
    80002e00:	6902                	ld	s2,0(sp)
    80002e02:	6105                	addi	sp,sp,32
    80002e04:	8082                	ret
    panic("iunlock");
    80002e06:	00005517          	auipc	a0,0x5
    80002e0a:	64a50513          	addi	a0,a0,1610 # 80008450 <etext+0x450>
    80002e0e:	00003097          	auipc	ra,0x3
    80002e12:	3e8080e7          	jalr	1000(ra) # 800061f6 <panic>

0000000080002e16 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e16:	7179                	addi	sp,sp,-48
    80002e18:	f406                	sd	ra,40(sp)
    80002e1a:	f022                	sd	s0,32(sp)
    80002e1c:	ec26                	sd	s1,24(sp)
    80002e1e:	e84a                	sd	s2,16(sp)
    80002e20:	e44e                	sd	s3,8(sp)
    80002e22:	1800                	addi	s0,sp,48
    80002e24:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e26:	05850493          	addi	s1,a0,88
    80002e2a:	08850913          	addi	s2,a0,136
    80002e2e:	a021                	j	80002e36 <itrunc+0x20>
    80002e30:	0491                	addi	s1,s1,4
    80002e32:	01248d63          	beq	s1,s2,80002e4c <itrunc+0x36>
    if(ip->addrs[i]){
    80002e36:	408c                	lw	a1,0(s1)
    80002e38:	dde5                	beqz	a1,80002e30 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e3a:	0009a503          	lw	a0,0(s3)
    80002e3e:	00000097          	auipc	ra,0x0
    80002e42:	910080e7          	jalr	-1776(ra) # 8000274e <bfree>
      ip->addrs[i] = 0;
    80002e46:	0004a023          	sw	zero,0(s1)
    80002e4a:	b7dd                	j	80002e30 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e4c:	0889a583          	lw	a1,136(s3)
    80002e50:	ed99                	bnez	a1,80002e6e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e52:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002e56:	854e                	mv	a0,s3
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	de0080e7          	jalr	-544(ra) # 80002c38 <iupdate>
}
    80002e60:	70a2                	ld	ra,40(sp)
    80002e62:	7402                	ld	s0,32(sp)
    80002e64:	64e2                	ld	s1,24(sp)
    80002e66:	6942                	ld	s2,16(sp)
    80002e68:	69a2                	ld	s3,8(sp)
    80002e6a:	6145                	addi	sp,sp,48
    80002e6c:	8082                	ret
    80002e6e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e70:	0009a503          	lw	a0,0(s3)
    80002e74:	fffff097          	auipc	ra,0xfffff
    80002e78:	598080e7          	jalr	1432(ra) # 8000240c <bread>
    80002e7c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e7e:	06050493          	addi	s1,a0,96
    80002e82:	46050913          	addi	s2,a0,1120
    80002e86:	a021                	j	80002e8e <itrunc+0x78>
    80002e88:	0491                	addi	s1,s1,4
    80002e8a:	01248b63          	beq	s1,s2,80002ea0 <itrunc+0x8a>
      if(a[j])
    80002e8e:	408c                	lw	a1,0(s1)
    80002e90:	dde5                	beqz	a1,80002e88 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e92:	0009a503          	lw	a0,0(s3)
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	8b8080e7          	jalr	-1864(ra) # 8000274e <bfree>
    80002e9e:	b7ed                	j	80002e88 <itrunc+0x72>
    brelse(bp);
    80002ea0:	8552                	mv	a0,s4
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	74c080e7          	jalr	1868(ra) # 800025ee <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eaa:	0889a583          	lw	a1,136(s3)
    80002eae:	0009a503          	lw	a0,0(s3)
    80002eb2:	00000097          	auipc	ra,0x0
    80002eb6:	89c080e7          	jalr	-1892(ra) # 8000274e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002eba:	0809a423          	sw	zero,136(s3)
    80002ebe:	6a02                	ld	s4,0(sp)
    80002ec0:	bf49                	j	80002e52 <itrunc+0x3c>

0000000080002ec2 <iput>:
{
    80002ec2:	1101                	addi	sp,sp,-32
    80002ec4:	ec06                	sd	ra,24(sp)
    80002ec6:	e822                	sd	s0,16(sp)
    80002ec8:	e426                	sd	s1,8(sp)
    80002eca:	1000                	addi	s0,sp,32
    80002ecc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ece:	0001b517          	auipc	a0,0x1b
    80002ed2:	0e250513          	addi	a0,a0,226 # 8001dfb0 <itable>
    80002ed6:	00004097          	auipc	ra,0x4
    80002eda:	884080e7          	jalr	-1916(ra) # 8000675a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ede:	4498                	lw	a4,8(s1)
    80002ee0:	4785                	li	a5,1
    80002ee2:	02f70263          	beq	a4,a5,80002f06 <iput+0x44>
  ip->ref--;
    80002ee6:	449c                	lw	a5,8(s1)
    80002ee8:	37fd                	addiw	a5,a5,-1
    80002eea:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eec:	0001b517          	auipc	a0,0x1b
    80002ef0:	0c450513          	addi	a0,a0,196 # 8001dfb0 <itable>
    80002ef4:	00004097          	auipc	ra,0x4
    80002ef8:	92e080e7          	jalr	-1746(ra) # 80006822 <release>
}
    80002efc:	60e2                	ld	ra,24(sp)
    80002efe:	6442                	ld	s0,16(sp)
    80002f00:	64a2                	ld	s1,8(sp)
    80002f02:	6105                	addi	sp,sp,32
    80002f04:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f06:	44bc                	lw	a5,72(s1)
    80002f08:	dff9                	beqz	a5,80002ee6 <iput+0x24>
    80002f0a:	05249783          	lh	a5,82(s1)
    80002f0e:	ffe1                	bnez	a5,80002ee6 <iput+0x24>
    80002f10:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f12:	01048913          	addi	s2,s1,16
    80002f16:	854a                	mv	a0,s2
    80002f18:	00001097          	auipc	ra,0x1
    80002f1c:	ab4080e7          	jalr	-1356(ra) # 800039cc <acquiresleep>
    release(&itable.lock);
    80002f20:	0001b517          	auipc	a0,0x1b
    80002f24:	09050513          	addi	a0,a0,144 # 8001dfb0 <itable>
    80002f28:	00004097          	auipc	ra,0x4
    80002f2c:	8fa080e7          	jalr	-1798(ra) # 80006822 <release>
    itrunc(ip);
    80002f30:	8526                	mv	a0,s1
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	ee4080e7          	jalr	-284(ra) # 80002e16 <itrunc>
    ip->type = 0;
    80002f3a:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002f3e:	8526                	mv	a0,s1
    80002f40:	00000097          	auipc	ra,0x0
    80002f44:	cf8080e7          	jalr	-776(ra) # 80002c38 <iupdate>
    ip->valid = 0;
    80002f48:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80002f4c:	854a                	mv	a0,s2
    80002f4e:	00001097          	auipc	ra,0x1
    80002f52:	ad4080e7          	jalr	-1324(ra) # 80003a22 <releasesleep>
    acquire(&itable.lock);
    80002f56:	0001b517          	auipc	a0,0x1b
    80002f5a:	05a50513          	addi	a0,a0,90 # 8001dfb0 <itable>
    80002f5e:	00003097          	auipc	ra,0x3
    80002f62:	7fc080e7          	jalr	2044(ra) # 8000675a <acquire>
    80002f66:	6902                	ld	s2,0(sp)
    80002f68:	bfbd                	j	80002ee6 <iput+0x24>

0000000080002f6a <iunlockput>:
{
    80002f6a:	1101                	addi	sp,sp,-32
    80002f6c:	ec06                	sd	ra,24(sp)
    80002f6e:	e822                	sd	s0,16(sp)
    80002f70:	e426                	sd	s1,8(sp)
    80002f72:	1000                	addi	s0,sp,32
    80002f74:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	e54080e7          	jalr	-428(ra) # 80002dca <iunlock>
  iput(ip);
    80002f7e:	8526                	mv	a0,s1
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	f42080e7          	jalr	-190(ra) # 80002ec2 <iput>
}
    80002f88:	60e2                	ld	ra,24(sp)
    80002f8a:	6442                	ld	s0,16(sp)
    80002f8c:	64a2                	ld	s1,8(sp)
    80002f8e:	6105                	addi	sp,sp,32
    80002f90:	8082                	ret

0000000080002f92 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f92:	1141                	addi	sp,sp,-16
    80002f94:	e422                	sd	s0,8(sp)
    80002f96:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f98:	411c                	lw	a5,0(a0)
    80002f9a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f9c:	415c                	lw	a5,4(a0)
    80002f9e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fa0:	04c51783          	lh	a5,76(a0)
    80002fa4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fa8:	05251783          	lh	a5,82(a0)
    80002fac:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fb0:	05456783          	lwu	a5,84(a0)
    80002fb4:	e99c                	sd	a5,16(a1)
}
    80002fb6:	6422                	ld	s0,8(sp)
    80002fb8:	0141                	addi	sp,sp,16
    80002fba:	8082                	ret

0000000080002fbc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fbc:	497c                	lw	a5,84(a0)
    80002fbe:	0ed7ef63          	bltu	a5,a3,800030bc <readi+0x100>
{
    80002fc2:	7159                	addi	sp,sp,-112
    80002fc4:	f486                	sd	ra,104(sp)
    80002fc6:	f0a2                	sd	s0,96(sp)
    80002fc8:	eca6                	sd	s1,88(sp)
    80002fca:	fc56                	sd	s5,56(sp)
    80002fcc:	f85a                	sd	s6,48(sp)
    80002fce:	f45e                	sd	s7,40(sp)
    80002fd0:	f062                	sd	s8,32(sp)
    80002fd2:	1880                	addi	s0,sp,112
    80002fd4:	8baa                	mv	s7,a0
    80002fd6:	8c2e                	mv	s8,a1
    80002fd8:	8ab2                	mv	s5,a2
    80002fda:	84b6                	mv	s1,a3
    80002fdc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fde:	9f35                	addw	a4,a4,a3
    return 0;
    80002fe0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fe2:	0ad76c63          	bltu	a4,a3,8000309a <readi+0xde>
    80002fe6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002fe8:	00e7f463          	bgeu	a5,a4,80002ff0 <readi+0x34>
    n = ip->size - off;
    80002fec:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ff0:	0c0b0463          	beqz	s6,800030b8 <readi+0xfc>
    80002ff4:	e8ca                	sd	s2,80(sp)
    80002ff6:	e0d2                	sd	s4,64(sp)
    80002ff8:	ec66                	sd	s9,24(sp)
    80002ffa:	e86a                	sd	s10,16(sp)
    80002ffc:	e46e                	sd	s11,8(sp)
    80002ffe:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003000:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003004:	5cfd                	li	s9,-1
    80003006:	a82d                	j	80003040 <readi+0x84>
    80003008:	020a1d93          	slli	s11,s4,0x20
    8000300c:	020ddd93          	srli	s11,s11,0x20
    80003010:	06090613          	addi	a2,s2,96
    80003014:	86ee                	mv	a3,s11
    80003016:	963a                	add	a2,a2,a4
    80003018:	85d6                	mv	a1,s5
    8000301a:	8562                	mv	a0,s8
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	9e8080e7          	jalr	-1560(ra) # 80001a04 <either_copyout>
    80003024:	05950d63          	beq	a0,s9,8000307e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003028:	854a                	mv	a0,s2
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	5c4080e7          	jalr	1476(ra) # 800025ee <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003032:	013a09bb          	addw	s3,s4,s3
    80003036:	009a04bb          	addw	s1,s4,s1
    8000303a:	9aee                	add	s5,s5,s11
    8000303c:	0769f863          	bgeu	s3,s6,800030ac <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003040:	000ba903          	lw	s2,0(s7)
    80003044:	00a4d59b          	srliw	a1,s1,0xa
    80003048:	855e                	mv	a0,s7
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	8ae080e7          	jalr	-1874(ra) # 800028f8 <bmap>
    80003052:	0005059b          	sext.w	a1,a0
    80003056:	854a                	mv	a0,s2
    80003058:	fffff097          	auipc	ra,0xfffff
    8000305c:	3b4080e7          	jalr	948(ra) # 8000240c <bread>
    80003060:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003062:	3ff4f713          	andi	a4,s1,1023
    80003066:	40ed07bb          	subw	a5,s10,a4
    8000306a:	413b06bb          	subw	a3,s6,s3
    8000306e:	8a3e                	mv	s4,a5
    80003070:	2781                	sext.w	a5,a5
    80003072:	0006861b          	sext.w	a2,a3
    80003076:	f8f679e3          	bgeu	a2,a5,80003008 <readi+0x4c>
    8000307a:	8a36                	mv	s4,a3
    8000307c:	b771                	j	80003008 <readi+0x4c>
      brelse(bp);
    8000307e:	854a                	mv	a0,s2
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	56e080e7          	jalr	1390(ra) # 800025ee <brelse>
      tot = -1;
    80003088:	59fd                	li	s3,-1
      break;
    8000308a:	6946                	ld	s2,80(sp)
    8000308c:	6a06                	ld	s4,64(sp)
    8000308e:	6ce2                	ld	s9,24(sp)
    80003090:	6d42                	ld	s10,16(sp)
    80003092:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003094:	0009851b          	sext.w	a0,s3
    80003098:	69a6                	ld	s3,72(sp)
}
    8000309a:	70a6                	ld	ra,104(sp)
    8000309c:	7406                	ld	s0,96(sp)
    8000309e:	64e6                	ld	s1,88(sp)
    800030a0:	7ae2                	ld	s5,56(sp)
    800030a2:	7b42                	ld	s6,48(sp)
    800030a4:	7ba2                	ld	s7,40(sp)
    800030a6:	7c02                	ld	s8,32(sp)
    800030a8:	6165                	addi	sp,sp,112
    800030aa:	8082                	ret
    800030ac:	6946                	ld	s2,80(sp)
    800030ae:	6a06                	ld	s4,64(sp)
    800030b0:	6ce2                	ld	s9,24(sp)
    800030b2:	6d42                	ld	s10,16(sp)
    800030b4:	6da2                	ld	s11,8(sp)
    800030b6:	bff9                	j	80003094 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b8:	89da                	mv	s3,s6
    800030ba:	bfe9                	j	80003094 <readi+0xd8>
    return 0;
    800030bc:	4501                	li	a0,0
}
    800030be:	8082                	ret

00000000800030c0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030c0:	497c                	lw	a5,84(a0)
    800030c2:	10d7ee63          	bltu	a5,a3,800031de <writei+0x11e>
{
    800030c6:	7159                	addi	sp,sp,-112
    800030c8:	f486                	sd	ra,104(sp)
    800030ca:	f0a2                	sd	s0,96(sp)
    800030cc:	e8ca                	sd	s2,80(sp)
    800030ce:	fc56                	sd	s5,56(sp)
    800030d0:	f85a                	sd	s6,48(sp)
    800030d2:	f45e                	sd	s7,40(sp)
    800030d4:	f062                	sd	s8,32(sp)
    800030d6:	1880                	addi	s0,sp,112
    800030d8:	8b2a                	mv	s6,a0
    800030da:	8c2e                	mv	s8,a1
    800030dc:	8ab2                	mv	s5,a2
    800030de:	8936                	mv	s2,a3
    800030e0:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030e2:	00e687bb          	addw	a5,a3,a4
    800030e6:	0ed7ee63          	bltu	a5,a3,800031e2 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030ea:	00043737          	lui	a4,0x43
    800030ee:	0ef76c63          	bltu	a4,a5,800031e6 <writei+0x126>
    800030f2:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f4:	0c0b8d63          	beqz	s7,800031ce <writei+0x10e>
    800030f8:	eca6                	sd	s1,88(sp)
    800030fa:	e4ce                	sd	s3,72(sp)
    800030fc:	ec66                	sd	s9,24(sp)
    800030fe:	e86a                	sd	s10,16(sp)
    80003100:	e46e                	sd	s11,8(sp)
    80003102:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003104:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003108:	5cfd                	li	s9,-1
    8000310a:	a091                	j	8000314e <writei+0x8e>
    8000310c:	02099d93          	slli	s11,s3,0x20
    80003110:	020ddd93          	srli	s11,s11,0x20
    80003114:	06048513          	addi	a0,s1,96
    80003118:	86ee                	mv	a3,s11
    8000311a:	8656                	mv	a2,s5
    8000311c:	85e2                	mv	a1,s8
    8000311e:	953a                	add	a0,a0,a4
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	93a080e7          	jalr	-1734(ra) # 80001a5a <either_copyin>
    80003128:	07950263          	beq	a0,s9,8000318c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000312c:	8526                	mv	a0,s1
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	780080e7          	jalr	1920(ra) # 800038ae <log_write>
    brelse(bp);
    80003136:	8526                	mv	a0,s1
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	4b6080e7          	jalr	1206(ra) # 800025ee <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003140:	01498a3b          	addw	s4,s3,s4
    80003144:	0129893b          	addw	s2,s3,s2
    80003148:	9aee                	add	s5,s5,s11
    8000314a:	057a7663          	bgeu	s4,s7,80003196 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000314e:	000b2483          	lw	s1,0(s6)
    80003152:	00a9559b          	srliw	a1,s2,0xa
    80003156:	855a                	mv	a0,s6
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	7a0080e7          	jalr	1952(ra) # 800028f8 <bmap>
    80003160:	0005059b          	sext.w	a1,a0
    80003164:	8526                	mv	a0,s1
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	2a6080e7          	jalr	678(ra) # 8000240c <bread>
    8000316e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003170:	3ff97713          	andi	a4,s2,1023
    80003174:	40ed07bb          	subw	a5,s10,a4
    80003178:	414b86bb          	subw	a3,s7,s4
    8000317c:	89be                	mv	s3,a5
    8000317e:	2781                	sext.w	a5,a5
    80003180:	0006861b          	sext.w	a2,a3
    80003184:	f8f674e3          	bgeu	a2,a5,8000310c <writei+0x4c>
    80003188:	89b6                	mv	s3,a3
    8000318a:	b749                	j	8000310c <writei+0x4c>
      brelse(bp);
    8000318c:	8526                	mv	a0,s1
    8000318e:	fffff097          	auipc	ra,0xfffff
    80003192:	460080e7          	jalr	1120(ra) # 800025ee <brelse>
  }

  if(off > ip->size)
    80003196:	054b2783          	lw	a5,84(s6)
    8000319a:	0327fc63          	bgeu	a5,s2,800031d2 <writei+0x112>
    ip->size = off;
    8000319e:	052b2a23          	sw	s2,84(s6)
    800031a2:	64e6                	ld	s1,88(sp)
    800031a4:	69a6                	ld	s3,72(sp)
    800031a6:	6ce2                	ld	s9,24(sp)
    800031a8:	6d42                	ld	s10,16(sp)
    800031aa:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ac:	855a                	mv	a0,s6
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	a8a080e7          	jalr	-1398(ra) # 80002c38 <iupdate>

  return tot;
    800031b6:	000a051b          	sext.w	a0,s4
    800031ba:	6a06                	ld	s4,64(sp)
}
    800031bc:	70a6                	ld	ra,104(sp)
    800031be:	7406                	ld	s0,96(sp)
    800031c0:	6946                	ld	s2,80(sp)
    800031c2:	7ae2                	ld	s5,56(sp)
    800031c4:	7b42                	ld	s6,48(sp)
    800031c6:	7ba2                	ld	s7,40(sp)
    800031c8:	7c02                	ld	s8,32(sp)
    800031ca:	6165                	addi	sp,sp,112
    800031cc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ce:	8a5e                	mv	s4,s7
    800031d0:	bff1                	j	800031ac <writei+0xec>
    800031d2:	64e6                	ld	s1,88(sp)
    800031d4:	69a6                	ld	s3,72(sp)
    800031d6:	6ce2                	ld	s9,24(sp)
    800031d8:	6d42                	ld	s10,16(sp)
    800031da:	6da2                	ld	s11,8(sp)
    800031dc:	bfc1                	j	800031ac <writei+0xec>
    return -1;
    800031de:	557d                	li	a0,-1
}
    800031e0:	8082                	ret
    return -1;
    800031e2:	557d                	li	a0,-1
    800031e4:	bfe1                	j	800031bc <writei+0xfc>
    return -1;
    800031e6:	557d                	li	a0,-1
    800031e8:	bfd1                	j	800031bc <writei+0xfc>

00000000800031ea <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031ea:	1141                	addi	sp,sp,-16
    800031ec:	e406                	sd	ra,8(sp)
    800031ee:	e022                	sd	s0,0(sp)
    800031f0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031f2:	4639                	li	a2,14
    800031f4:	ffffd097          	auipc	ra,0xffffd
    800031f8:	164080e7          	jalr	356(ra) # 80000358 <strncmp>
}
    800031fc:	60a2                	ld	ra,8(sp)
    800031fe:	6402                	ld	s0,0(sp)
    80003200:	0141                	addi	sp,sp,16
    80003202:	8082                	ret

0000000080003204 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003204:	7139                	addi	sp,sp,-64
    80003206:	fc06                	sd	ra,56(sp)
    80003208:	f822                	sd	s0,48(sp)
    8000320a:	f426                	sd	s1,40(sp)
    8000320c:	f04a                	sd	s2,32(sp)
    8000320e:	ec4e                	sd	s3,24(sp)
    80003210:	e852                	sd	s4,16(sp)
    80003212:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003214:	04c51703          	lh	a4,76(a0)
    80003218:	4785                	li	a5,1
    8000321a:	00f71a63          	bne	a4,a5,8000322e <dirlookup+0x2a>
    8000321e:	892a                	mv	s2,a0
    80003220:	89ae                	mv	s3,a1
    80003222:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003224:	497c                	lw	a5,84(a0)
    80003226:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003228:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322a:	e79d                	bnez	a5,80003258 <dirlookup+0x54>
    8000322c:	a8a5                	j	800032a4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000322e:	00005517          	auipc	a0,0x5
    80003232:	22a50513          	addi	a0,a0,554 # 80008458 <etext+0x458>
    80003236:	00003097          	auipc	ra,0x3
    8000323a:	fc0080e7          	jalr	-64(ra) # 800061f6 <panic>
      panic("dirlookup read");
    8000323e:	00005517          	auipc	a0,0x5
    80003242:	23250513          	addi	a0,a0,562 # 80008470 <etext+0x470>
    80003246:	00003097          	auipc	ra,0x3
    8000324a:	fb0080e7          	jalr	-80(ra) # 800061f6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000324e:	24c1                	addiw	s1,s1,16
    80003250:	05492783          	lw	a5,84(s2)
    80003254:	04f4f763          	bgeu	s1,a5,800032a2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003258:	4741                	li	a4,16
    8000325a:	86a6                	mv	a3,s1
    8000325c:	fc040613          	addi	a2,s0,-64
    80003260:	4581                	li	a1,0
    80003262:	854a                	mv	a0,s2
    80003264:	00000097          	auipc	ra,0x0
    80003268:	d58080e7          	jalr	-680(ra) # 80002fbc <readi>
    8000326c:	47c1                	li	a5,16
    8000326e:	fcf518e3          	bne	a0,a5,8000323e <dirlookup+0x3a>
    if(de.inum == 0)
    80003272:	fc045783          	lhu	a5,-64(s0)
    80003276:	dfe1                	beqz	a5,8000324e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003278:	fc240593          	addi	a1,s0,-62
    8000327c:	854e                	mv	a0,s3
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	f6c080e7          	jalr	-148(ra) # 800031ea <namecmp>
    80003286:	f561                	bnez	a0,8000324e <dirlookup+0x4a>
      if(poff)
    80003288:	000a0463          	beqz	s4,80003290 <dirlookup+0x8c>
        *poff = off;
    8000328c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003290:	fc045583          	lhu	a1,-64(s0)
    80003294:	00092503          	lw	a0,0(s2)
    80003298:	fffff097          	auipc	ra,0xfffff
    8000329c:	73c080e7          	jalr	1852(ra) # 800029d4 <iget>
    800032a0:	a011                	j	800032a4 <dirlookup+0xa0>
  return 0;
    800032a2:	4501                	li	a0,0
}
    800032a4:	70e2                	ld	ra,56(sp)
    800032a6:	7442                	ld	s0,48(sp)
    800032a8:	74a2                	ld	s1,40(sp)
    800032aa:	7902                	ld	s2,32(sp)
    800032ac:	69e2                	ld	s3,24(sp)
    800032ae:	6a42                	ld	s4,16(sp)
    800032b0:	6121                	addi	sp,sp,64
    800032b2:	8082                	ret

00000000800032b4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032b4:	711d                	addi	sp,sp,-96
    800032b6:	ec86                	sd	ra,88(sp)
    800032b8:	e8a2                	sd	s0,80(sp)
    800032ba:	e4a6                	sd	s1,72(sp)
    800032bc:	e0ca                	sd	s2,64(sp)
    800032be:	fc4e                	sd	s3,56(sp)
    800032c0:	f852                	sd	s4,48(sp)
    800032c2:	f456                	sd	s5,40(sp)
    800032c4:	f05a                	sd	s6,32(sp)
    800032c6:	ec5e                	sd	s7,24(sp)
    800032c8:	e862                	sd	s8,16(sp)
    800032ca:	e466                	sd	s9,8(sp)
    800032cc:	1080                	addi	s0,sp,96
    800032ce:	84aa                	mv	s1,a0
    800032d0:	8b2e                	mv	s6,a1
    800032d2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032d4:	00054703          	lbu	a4,0(a0)
    800032d8:	02f00793          	li	a5,47
    800032dc:	02f70263          	beq	a4,a5,80003300 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032e0:	ffffe097          	auipc	ra,0xffffe
    800032e4:	cba080e7          	jalr	-838(ra) # 80000f9a <myproc>
    800032e8:	15853503          	ld	a0,344(a0)
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	9da080e7          	jalr	-1574(ra) # 80002cc6 <idup>
    800032f4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032f6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032fa:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032fc:	4b85                	li	s7,1
    800032fe:	a875                	j	800033ba <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003300:	4585                	li	a1,1
    80003302:	4505                	li	a0,1
    80003304:	fffff097          	auipc	ra,0xfffff
    80003308:	6d0080e7          	jalr	1744(ra) # 800029d4 <iget>
    8000330c:	8a2a                	mv	s4,a0
    8000330e:	b7e5                	j	800032f6 <namex+0x42>
      iunlockput(ip);
    80003310:	8552                	mv	a0,s4
    80003312:	00000097          	auipc	ra,0x0
    80003316:	c58080e7          	jalr	-936(ra) # 80002f6a <iunlockput>
      return 0;
    8000331a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000331c:	8552                	mv	a0,s4
    8000331e:	60e6                	ld	ra,88(sp)
    80003320:	6446                	ld	s0,80(sp)
    80003322:	64a6                	ld	s1,72(sp)
    80003324:	6906                	ld	s2,64(sp)
    80003326:	79e2                	ld	s3,56(sp)
    80003328:	7a42                	ld	s4,48(sp)
    8000332a:	7aa2                	ld	s5,40(sp)
    8000332c:	7b02                	ld	s6,32(sp)
    8000332e:	6be2                	ld	s7,24(sp)
    80003330:	6c42                	ld	s8,16(sp)
    80003332:	6ca2                	ld	s9,8(sp)
    80003334:	6125                	addi	sp,sp,96
    80003336:	8082                	ret
      iunlock(ip);
    80003338:	8552                	mv	a0,s4
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	a90080e7          	jalr	-1392(ra) # 80002dca <iunlock>
      return ip;
    80003342:	bfe9                	j	8000331c <namex+0x68>
      iunlockput(ip);
    80003344:	8552                	mv	a0,s4
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	c24080e7          	jalr	-988(ra) # 80002f6a <iunlockput>
      return 0;
    8000334e:	8a4e                	mv	s4,s3
    80003350:	b7f1                	j	8000331c <namex+0x68>
  len = path - s;
    80003352:	40998633          	sub	a2,s3,s1
    80003356:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000335a:	099c5863          	bge	s8,s9,800033ea <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000335e:	4639                	li	a2,14
    80003360:	85a6                	mv	a1,s1
    80003362:	8556                	mv	a0,s5
    80003364:	ffffd097          	auipc	ra,0xffffd
    80003368:	f80080e7          	jalr	-128(ra) # 800002e4 <memmove>
    8000336c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000336e:	0004c783          	lbu	a5,0(s1)
    80003372:	01279763          	bne	a5,s2,80003380 <namex+0xcc>
    path++;
    80003376:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003378:	0004c783          	lbu	a5,0(s1)
    8000337c:	ff278de3          	beq	a5,s2,80003376 <namex+0xc2>
    ilock(ip);
    80003380:	8552                	mv	a0,s4
    80003382:	00000097          	auipc	ra,0x0
    80003386:	982080e7          	jalr	-1662(ra) # 80002d04 <ilock>
    if(ip->type != T_DIR){
    8000338a:	04ca1783          	lh	a5,76(s4)
    8000338e:	f97791e3          	bne	a5,s7,80003310 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003392:	000b0563          	beqz	s6,8000339c <namex+0xe8>
    80003396:	0004c783          	lbu	a5,0(s1)
    8000339a:	dfd9                	beqz	a5,80003338 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000339c:	4601                	li	a2,0
    8000339e:	85d6                	mv	a1,s5
    800033a0:	8552                	mv	a0,s4
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	e62080e7          	jalr	-414(ra) # 80003204 <dirlookup>
    800033aa:	89aa                	mv	s3,a0
    800033ac:	dd41                	beqz	a0,80003344 <namex+0x90>
    iunlockput(ip);
    800033ae:	8552                	mv	a0,s4
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	bba080e7          	jalr	-1094(ra) # 80002f6a <iunlockput>
    ip = next;
    800033b8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033ba:	0004c783          	lbu	a5,0(s1)
    800033be:	01279763          	bne	a5,s2,800033cc <namex+0x118>
    path++;
    800033c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c4:	0004c783          	lbu	a5,0(s1)
    800033c8:	ff278de3          	beq	a5,s2,800033c2 <namex+0x10e>
  if(*path == 0)
    800033cc:	cb9d                	beqz	a5,80003402 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800033ce:	0004c783          	lbu	a5,0(s1)
    800033d2:	89a6                	mv	s3,s1
  len = path - s;
    800033d4:	4c81                	li	s9,0
    800033d6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800033d8:	01278963          	beq	a5,s2,800033ea <namex+0x136>
    800033dc:	dbbd                	beqz	a5,80003352 <namex+0x9e>
    path++;
    800033de:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033e0:	0009c783          	lbu	a5,0(s3)
    800033e4:	ff279ce3          	bne	a5,s2,800033dc <namex+0x128>
    800033e8:	b7ad                	j	80003352 <namex+0x9e>
    memmove(name, s, len);
    800033ea:	2601                	sext.w	a2,a2
    800033ec:	85a6                	mv	a1,s1
    800033ee:	8556                	mv	a0,s5
    800033f0:	ffffd097          	auipc	ra,0xffffd
    800033f4:	ef4080e7          	jalr	-268(ra) # 800002e4 <memmove>
    name[len] = 0;
    800033f8:	9cd6                	add	s9,s9,s5
    800033fa:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800033fe:	84ce                	mv	s1,s3
    80003400:	b7bd                	j	8000336e <namex+0xba>
  if(nameiparent){
    80003402:	f00b0de3          	beqz	s6,8000331c <namex+0x68>
    iput(ip);
    80003406:	8552                	mv	a0,s4
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	aba080e7          	jalr	-1350(ra) # 80002ec2 <iput>
    return 0;
    80003410:	4a01                	li	s4,0
    80003412:	b729                	j	8000331c <namex+0x68>

0000000080003414 <dirlink>:
{
    80003414:	7139                	addi	sp,sp,-64
    80003416:	fc06                	sd	ra,56(sp)
    80003418:	f822                	sd	s0,48(sp)
    8000341a:	f04a                	sd	s2,32(sp)
    8000341c:	ec4e                	sd	s3,24(sp)
    8000341e:	e852                	sd	s4,16(sp)
    80003420:	0080                	addi	s0,sp,64
    80003422:	892a                	mv	s2,a0
    80003424:	8a2e                	mv	s4,a1
    80003426:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003428:	4601                	li	a2,0
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	dda080e7          	jalr	-550(ra) # 80003204 <dirlookup>
    80003432:	ed25                	bnez	a0,800034aa <dirlink+0x96>
    80003434:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003436:	05492483          	lw	s1,84(s2)
    8000343a:	c49d                	beqz	s1,80003468 <dirlink+0x54>
    8000343c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000343e:	4741                	li	a4,16
    80003440:	86a6                	mv	a3,s1
    80003442:	fc040613          	addi	a2,s0,-64
    80003446:	4581                	li	a1,0
    80003448:	854a                	mv	a0,s2
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	b72080e7          	jalr	-1166(ra) # 80002fbc <readi>
    80003452:	47c1                	li	a5,16
    80003454:	06f51163          	bne	a0,a5,800034b6 <dirlink+0xa2>
    if(de.inum == 0)
    80003458:	fc045783          	lhu	a5,-64(s0)
    8000345c:	c791                	beqz	a5,80003468 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000345e:	24c1                	addiw	s1,s1,16
    80003460:	05492783          	lw	a5,84(s2)
    80003464:	fcf4ede3          	bltu	s1,a5,8000343e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003468:	4639                	li	a2,14
    8000346a:	85d2                	mv	a1,s4
    8000346c:	fc240513          	addi	a0,s0,-62
    80003470:	ffffd097          	auipc	ra,0xffffd
    80003474:	f1e080e7          	jalr	-226(ra) # 8000038e <strncpy>
  de.inum = inum;
    80003478:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000347c:	4741                	li	a4,16
    8000347e:	86a6                	mv	a3,s1
    80003480:	fc040613          	addi	a2,s0,-64
    80003484:	4581                	li	a1,0
    80003486:	854a                	mv	a0,s2
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	c38080e7          	jalr	-968(ra) # 800030c0 <writei>
    80003490:	872a                	mv	a4,a0
    80003492:	47c1                	li	a5,16
  return 0;
    80003494:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003496:	02f71863          	bne	a4,a5,800034c6 <dirlink+0xb2>
    8000349a:	74a2                	ld	s1,40(sp)
}
    8000349c:	70e2                	ld	ra,56(sp)
    8000349e:	7442                	ld	s0,48(sp)
    800034a0:	7902                	ld	s2,32(sp)
    800034a2:	69e2                	ld	s3,24(sp)
    800034a4:	6a42                	ld	s4,16(sp)
    800034a6:	6121                	addi	sp,sp,64
    800034a8:	8082                	ret
    iput(ip);
    800034aa:	00000097          	auipc	ra,0x0
    800034ae:	a18080e7          	jalr	-1512(ra) # 80002ec2 <iput>
    return -1;
    800034b2:	557d                	li	a0,-1
    800034b4:	b7e5                	j	8000349c <dirlink+0x88>
      panic("dirlink read");
    800034b6:	00005517          	auipc	a0,0x5
    800034ba:	fca50513          	addi	a0,a0,-54 # 80008480 <etext+0x480>
    800034be:	00003097          	auipc	ra,0x3
    800034c2:	d38080e7          	jalr	-712(ra) # 800061f6 <panic>
    panic("dirlink");
    800034c6:	00005517          	auipc	a0,0x5
    800034ca:	0ca50513          	addi	a0,a0,202 # 80008590 <etext+0x590>
    800034ce:	00003097          	auipc	ra,0x3
    800034d2:	d28080e7          	jalr	-728(ra) # 800061f6 <panic>

00000000800034d6 <namei>:

struct inode*
namei(char *path)
{
    800034d6:	1101                	addi	sp,sp,-32
    800034d8:	ec06                	sd	ra,24(sp)
    800034da:	e822                	sd	s0,16(sp)
    800034dc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034de:	fe040613          	addi	a2,s0,-32
    800034e2:	4581                	li	a1,0
    800034e4:	00000097          	auipc	ra,0x0
    800034e8:	dd0080e7          	jalr	-560(ra) # 800032b4 <namex>
}
    800034ec:	60e2                	ld	ra,24(sp)
    800034ee:	6442                	ld	s0,16(sp)
    800034f0:	6105                	addi	sp,sp,32
    800034f2:	8082                	ret

00000000800034f4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034f4:	1141                	addi	sp,sp,-16
    800034f6:	e406                	sd	ra,8(sp)
    800034f8:	e022                	sd	s0,0(sp)
    800034fa:	0800                	addi	s0,sp,16
    800034fc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034fe:	4585                	li	a1,1
    80003500:	00000097          	auipc	ra,0x0
    80003504:	db4080e7          	jalr	-588(ra) # 800032b4 <namex>
}
    80003508:	60a2                	ld	ra,8(sp)
    8000350a:	6402                	ld	s0,0(sp)
    8000350c:	0141                	addi	sp,sp,16
    8000350e:	8082                	ret

0000000080003510 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003510:	1101                	addi	sp,sp,-32
    80003512:	ec06                	sd	ra,24(sp)
    80003514:	e822                	sd	s0,16(sp)
    80003516:	e426                	sd	s1,8(sp)
    80003518:	e04a                	sd	s2,0(sp)
    8000351a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000351c:	0001c917          	auipc	s2,0x1c
    80003520:	6d490913          	addi	s2,s2,1748 # 8001fbf0 <log>
    80003524:	02092583          	lw	a1,32(s2)
    80003528:	03092503          	lw	a0,48(s2)
    8000352c:	fffff097          	auipc	ra,0xfffff
    80003530:	ee0080e7          	jalr	-288(ra) # 8000240c <bread>
    80003534:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003536:	03492603          	lw	a2,52(s2)
    8000353a:	d130                	sw	a2,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000353c:	00c05f63          	blez	a2,8000355a <write_head+0x4a>
    80003540:	0001c717          	auipc	a4,0x1c
    80003544:	6e870713          	addi	a4,a4,1768 # 8001fc28 <log+0x38>
    80003548:	87aa                	mv	a5,a0
    8000354a:	060a                	slli	a2,a2,0x2
    8000354c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000354e:	4314                	lw	a3,0(a4)
    80003550:	d3f4                	sw	a3,100(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003552:	0711                	addi	a4,a4,4
    80003554:	0791                	addi	a5,a5,4
    80003556:	fec79ce3          	bne	a5,a2,8000354e <write_head+0x3e>
  }
  bwrite(buf);
    8000355a:	8526                	mv	a0,s1
    8000355c:	fffff097          	auipc	ra,0xfffff
    80003560:	054080e7          	jalr	84(ra) # 800025b0 <bwrite>
  brelse(buf);
    80003564:	8526                	mv	a0,s1
    80003566:	fffff097          	auipc	ra,0xfffff
    8000356a:	088080e7          	jalr	136(ra) # 800025ee <brelse>
}
    8000356e:	60e2                	ld	ra,24(sp)
    80003570:	6442                	ld	s0,16(sp)
    80003572:	64a2                	ld	s1,8(sp)
    80003574:	6902                	ld	s2,0(sp)
    80003576:	6105                	addi	sp,sp,32
    80003578:	8082                	ret

000000008000357a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357a:	0001c797          	auipc	a5,0x1c
    8000357e:	6aa7a783          	lw	a5,1706(a5) # 8001fc24 <log+0x34>
    80003582:	0af05d63          	blez	a5,8000363c <install_trans+0xc2>
{
    80003586:	7139                	addi	sp,sp,-64
    80003588:	fc06                	sd	ra,56(sp)
    8000358a:	f822                	sd	s0,48(sp)
    8000358c:	f426                	sd	s1,40(sp)
    8000358e:	f04a                	sd	s2,32(sp)
    80003590:	ec4e                	sd	s3,24(sp)
    80003592:	e852                	sd	s4,16(sp)
    80003594:	e456                	sd	s5,8(sp)
    80003596:	e05a                	sd	s6,0(sp)
    80003598:	0080                	addi	s0,sp,64
    8000359a:	8b2a                	mv	s6,a0
    8000359c:	0001ca97          	auipc	s5,0x1c
    800035a0:	68ca8a93          	addi	s5,s5,1676 # 8001fc28 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a6:	0001c997          	auipc	s3,0x1c
    800035aa:	64a98993          	addi	s3,s3,1610 # 8001fbf0 <log>
    800035ae:	a00d                	j	800035d0 <install_trans+0x56>
    brelse(lbuf);
    800035b0:	854a                	mv	a0,s2
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	03c080e7          	jalr	60(ra) # 800025ee <brelse>
    brelse(dbuf);
    800035ba:	8526                	mv	a0,s1
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	032080e7          	jalr	50(ra) # 800025ee <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c4:	2a05                	addiw	s4,s4,1
    800035c6:	0a91                	addi	s5,s5,4
    800035c8:	0349a783          	lw	a5,52(s3)
    800035cc:	04fa5e63          	bge	s4,a5,80003628 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035d0:	0209a583          	lw	a1,32(s3)
    800035d4:	014585bb          	addw	a1,a1,s4
    800035d8:	2585                	addiw	a1,a1,1
    800035da:	0309a503          	lw	a0,48(s3)
    800035de:	fffff097          	auipc	ra,0xfffff
    800035e2:	e2e080e7          	jalr	-466(ra) # 8000240c <bread>
    800035e6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035e8:	000aa583          	lw	a1,0(s5)
    800035ec:	0309a503          	lw	a0,48(s3)
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	e1c080e7          	jalr	-484(ra) # 8000240c <bread>
    800035f8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035fa:	40000613          	li	a2,1024
    800035fe:	06090593          	addi	a1,s2,96
    80003602:	06050513          	addi	a0,a0,96
    80003606:	ffffd097          	auipc	ra,0xffffd
    8000360a:	cde080e7          	jalr	-802(ra) # 800002e4 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000360e:	8526                	mv	a0,s1
    80003610:	fffff097          	auipc	ra,0xfffff
    80003614:	fa0080e7          	jalr	-96(ra) # 800025b0 <bwrite>
    if(recovering == 0)
    80003618:	f80b1ce3          	bnez	s6,800035b0 <install_trans+0x36>
      bunpin(dbuf);
    8000361c:	8526                	mv	a0,s1
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	0e2080e7          	jalr	226(ra) # 80002700 <bunpin>
    80003626:	b769                	j	800035b0 <install_trans+0x36>
}
    80003628:	70e2                	ld	ra,56(sp)
    8000362a:	7442                	ld	s0,48(sp)
    8000362c:	74a2                	ld	s1,40(sp)
    8000362e:	7902                	ld	s2,32(sp)
    80003630:	69e2                	ld	s3,24(sp)
    80003632:	6a42                	ld	s4,16(sp)
    80003634:	6aa2                	ld	s5,8(sp)
    80003636:	6b02                	ld	s6,0(sp)
    80003638:	6121                	addi	sp,sp,64
    8000363a:	8082                	ret
    8000363c:	8082                	ret

000000008000363e <initlog>:
{
    8000363e:	7179                	addi	sp,sp,-48
    80003640:	f406                	sd	ra,40(sp)
    80003642:	f022                	sd	s0,32(sp)
    80003644:	ec26                	sd	s1,24(sp)
    80003646:	e84a                	sd	s2,16(sp)
    80003648:	e44e                	sd	s3,8(sp)
    8000364a:	1800                	addi	s0,sp,48
    8000364c:	892a                	mv	s2,a0
    8000364e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003650:	0001c497          	auipc	s1,0x1c
    80003654:	5a048493          	addi	s1,s1,1440 # 8001fbf0 <log>
    80003658:	00005597          	auipc	a1,0x5
    8000365c:	e3858593          	addi	a1,a1,-456 # 80008490 <etext+0x490>
    80003660:	8526                	mv	a0,s1
    80003662:	00003097          	auipc	ra,0x3
    80003666:	26c080e7          	jalr	620(ra) # 800068ce <initlock>
  log.start = sb->logstart;
    8000366a:	0149a583          	lw	a1,20(s3)
    8000366e:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    80003670:	0109a783          	lw	a5,16(s3)
    80003674:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    80003676:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000367a:	854a                	mv	a0,s2
    8000367c:	fffff097          	auipc	ra,0xfffff
    80003680:	d90080e7          	jalr	-624(ra) # 8000240c <bread>
  log.lh.n = lh->n;
    80003684:	5130                	lw	a2,96(a0)
    80003686:	d8d0                	sw	a2,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003688:	00c05f63          	blez	a2,800036a6 <initlog+0x68>
    8000368c:	87aa                	mv	a5,a0
    8000368e:	0001c717          	auipc	a4,0x1c
    80003692:	59a70713          	addi	a4,a4,1434 # 8001fc28 <log+0x38>
    80003696:	060a                	slli	a2,a2,0x2
    80003698:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000369a:	53f4                	lw	a3,100(a5)
    8000369c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000369e:	0791                	addi	a5,a5,4
    800036a0:	0711                	addi	a4,a4,4
    800036a2:	fec79ce3          	bne	a5,a2,8000369a <initlog+0x5c>
  brelse(buf);
    800036a6:	fffff097          	auipc	ra,0xfffff
    800036aa:	f48080e7          	jalr	-184(ra) # 800025ee <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036ae:	4505                	li	a0,1
    800036b0:	00000097          	auipc	ra,0x0
    800036b4:	eca080e7          	jalr	-310(ra) # 8000357a <install_trans>
  log.lh.n = 0;
    800036b8:	0001c797          	auipc	a5,0x1c
    800036bc:	5607a623          	sw	zero,1388(a5) # 8001fc24 <log+0x34>
  write_head(); // clear the log
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	e50080e7          	jalr	-432(ra) # 80003510 <write_head>
}
    800036c8:	70a2                	ld	ra,40(sp)
    800036ca:	7402                	ld	s0,32(sp)
    800036cc:	64e2                	ld	s1,24(sp)
    800036ce:	6942                	ld	s2,16(sp)
    800036d0:	69a2                	ld	s3,8(sp)
    800036d2:	6145                	addi	sp,sp,48
    800036d4:	8082                	ret

00000000800036d6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036d6:	1101                	addi	sp,sp,-32
    800036d8:	ec06                	sd	ra,24(sp)
    800036da:	e822                	sd	s0,16(sp)
    800036dc:	e426                	sd	s1,8(sp)
    800036de:	e04a                	sd	s2,0(sp)
    800036e0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036e2:	0001c517          	auipc	a0,0x1c
    800036e6:	50e50513          	addi	a0,a0,1294 # 8001fbf0 <log>
    800036ea:	00003097          	auipc	ra,0x3
    800036ee:	070080e7          	jalr	112(ra) # 8000675a <acquire>
  while(1){
    if(log.committing){
    800036f2:	0001c497          	auipc	s1,0x1c
    800036f6:	4fe48493          	addi	s1,s1,1278 # 8001fbf0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036fa:	4979                	li	s2,30
    800036fc:	a039                	j	8000370a <begin_op+0x34>
      sleep(&log, &log.lock);
    800036fe:	85a6                	mv	a1,s1
    80003700:	8526                	mv	a0,s1
    80003702:	ffffe097          	auipc	ra,0xffffe
    80003706:	f5e080e7          	jalr	-162(ra) # 80001660 <sleep>
    if(log.committing){
    8000370a:	54dc                	lw	a5,44(s1)
    8000370c:	fbed                	bnez	a5,800036fe <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000370e:	5498                	lw	a4,40(s1)
    80003710:	2705                	addiw	a4,a4,1
    80003712:	0027179b          	slliw	a5,a4,0x2
    80003716:	9fb9                	addw	a5,a5,a4
    80003718:	0017979b          	slliw	a5,a5,0x1
    8000371c:	58d4                	lw	a3,52(s1)
    8000371e:	9fb5                	addw	a5,a5,a3
    80003720:	00f95963          	bge	s2,a5,80003732 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003724:	85a6                	mv	a1,s1
    80003726:	8526                	mv	a0,s1
    80003728:	ffffe097          	auipc	ra,0xffffe
    8000372c:	f38080e7          	jalr	-200(ra) # 80001660 <sleep>
    80003730:	bfe9                	j	8000370a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003732:	0001c517          	auipc	a0,0x1c
    80003736:	4be50513          	addi	a0,a0,1214 # 8001fbf0 <log>
    8000373a:	d518                	sw	a4,40(a0)
      release(&log.lock);
    8000373c:	00003097          	auipc	ra,0x3
    80003740:	0e6080e7          	jalr	230(ra) # 80006822 <release>
      break;
    }
  }
}
    80003744:	60e2                	ld	ra,24(sp)
    80003746:	6442                	ld	s0,16(sp)
    80003748:	64a2                	ld	s1,8(sp)
    8000374a:	6902                	ld	s2,0(sp)
    8000374c:	6105                	addi	sp,sp,32
    8000374e:	8082                	ret

0000000080003750 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003750:	7139                	addi	sp,sp,-64
    80003752:	fc06                	sd	ra,56(sp)
    80003754:	f822                	sd	s0,48(sp)
    80003756:	f426                	sd	s1,40(sp)
    80003758:	f04a                	sd	s2,32(sp)
    8000375a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000375c:	0001c497          	auipc	s1,0x1c
    80003760:	49448493          	addi	s1,s1,1172 # 8001fbf0 <log>
    80003764:	8526                	mv	a0,s1
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	ff4080e7          	jalr	-12(ra) # 8000675a <acquire>
  log.outstanding -= 1;
    8000376e:	549c                	lw	a5,40(s1)
    80003770:	37fd                	addiw	a5,a5,-1
    80003772:	0007891b          	sext.w	s2,a5
    80003776:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003778:	54dc                	lw	a5,44(s1)
    8000377a:	e7b9                	bnez	a5,800037c8 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000377c:	06091163          	bnez	s2,800037de <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003780:	0001c497          	auipc	s1,0x1c
    80003784:	47048493          	addi	s1,s1,1136 # 8001fbf0 <log>
    80003788:	4785                	li	a5,1
    8000378a:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000378c:	8526                	mv	a0,s1
    8000378e:	00003097          	auipc	ra,0x3
    80003792:	094080e7          	jalr	148(ra) # 80006822 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003796:	58dc                	lw	a5,52(s1)
    80003798:	06f04763          	bgtz	a5,80003806 <end_op+0xb6>
    acquire(&log.lock);
    8000379c:	0001c497          	auipc	s1,0x1c
    800037a0:	45448493          	addi	s1,s1,1108 # 8001fbf0 <log>
    800037a4:	8526                	mv	a0,s1
    800037a6:	00003097          	auipc	ra,0x3
    800037aa:	fb4080e7          	jalr	-76(ra) # 8000675a <acquire>
    log.committing = 0;
    800037ae:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    800037b2:	8526                	mv	a0,s1
    800037b4:	ffffe097          	auipc	ra,0xffffe
    800037b8:	038080e7          	jalr	56(ra) # 800017ec <wakeup>
    release(&log.lock);
    800037bc:	8526                	mv	a0,s1
    800037be:	00003097          	auipc	ra,0x3
    800037c2:	064080e7          	jalr	100(ra) # 80006822 <release>
}
    800037c6:	a815                	j	800037fa <end_op+0xaa>
    800037c8:	ec4e                	sd	s3,24(sp)
    800037ca:	e852                	sd	s4,16(sp)
    800037cc:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800037ce:	00005517          	auipc	a0,0x5
    800037d2:	cca50513          	addi	a0,a0,-822 # 80008498 <etext+0x498>
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	a20080e7          	jalr	-1504(ra) # 800061f6 <panic>
    wakeup(&log);
    800037de:	0001c497          	auipc	s1,0x1c
    800037e2:	41248493          	addi	s1,s1,1042 # 8001fbf0 <log>
    800037e6:	8526                	mv	a0,s1
    800037e8:	ffffe097          	auipc	ra,0xffffe
    800037ec:	004080e7          	jalr	4(ra) # 800017ec <wakeup>
  release(&log.lock);
    800037f0:	8526                	mv	a0,s1
    800037f2:	00003097          	auipc	ra,0x3
    800037f6:	030080e7          	jalr	48(ra) # 80006822 <release>
}
    800037fa:	70e2                	ld	ra,56(sp)
    800037fc:	7442                	ld	s0,48(sp)
    800037fe:	74a2                	ld	s1,40(sp)
    80003800:	7902                	ld	s2,32(sp)
    80003802:	6121                	addi	sp,sp,64
    80003804:	8082                	ret
    80003806:	ec4e                	sd	s3,24(sp)
    80003808:	e852                	sd	s4,16(sp)
    8000380a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000380c:	0001ca97          	auipc	s5,0x1c
    80003810:	41ca8a93          	addi	s5,s5,1052 # 8001fc28 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003814:	0001ca17          	auipc	s4,0x1c
    80003818:	3dca0a13          	addi	s4,s4,988 # 8001fbf0 <log>
    8000381c:	020a2583          	lw	a1,32(s4)
    80003820:	012585bb          	addw	a1,a1,s2
    80003824:	2585                	addiw	a1,a1,1
    80003826:	030a2503          	lw	a0,48(s4)
    8000382a:	fffff097          	auipc	ra,0xfffff
    8000382e:	be2080e7          	jalr	-1054(ra) # 8000240c <bread>
    80003832:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003834:	000aa583          	lw	a1,0(s5)
    80003838:	030a2503          	lw	a0,48(s4)
    8000383c:	fffff097          	auipc	ra,0xfffff
    80003840:	bd0080e7          	jalr	-1072(ra) # 8000240c <bread>
    80003844:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003846:	40000613          	li	a2,1024
    8000384a:	06050593          	addi	a1,a0,96
    8000384e:	06048513          	addi	a0,s1,96
    80003852:	ffffd097          	auipc	ra,0xffffd
    80003856:	a92080e7          	jalr	-1390(ra) # 800002e4 <memmove>
    bwrite(to);  // write the log
    8000385a:	8526                	mv	a0,s1
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	d54080e7          	jalr	-684(ra) # 800025b0 <bwrite>
    brelse(from);
    80003864:	854e                	mv	a0,s3
    80003866:	fffff097          	auipc	ra,0xfffff
    8000386a:	d88080e7          	jalr	-632(ra) # 800025ee <brelse>
    brelse(to);
    8000386e:	8526                	mv	a0,s1
    80003870:	fffff097          	auipc	ra,0xfffff
    80003874:	d7e080e7          	jalr	-642(ra) # 800025ee <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003878:	2905                	addiw	s2,s2,1
    8000387a:	0a91                	addi	s5,s5,4
    8000387c:	034a2783          	lw	a5,52(s4)
    80003880:	f8f94ee3          	blt	s2,a5,8000381c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003884:	00000097          	auipc	ra,0x0
    80003888:	c8c080e7          	jalr	-884(ra) # 80003510 <write_head>
    install_trans(0); // Now install writes to home locations
    8000388c:	4501                	li	a0,0
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	cec080e7          	jalr	-788(ra) # 8000357a <install_trans>
    log.lh.n = 0;
    80003896:	0001c797          	auipc	a5,0x1c
    8000389a:	3807a723          	sw	zero,910(a5) # 8001fc24 <log+0x34>
    write_head();    // Erase the transaction from the log
    8000389e:	00000097          	auipc	ra,0x0
    800038a2:	c72080e7          	jalr	-910(ra) # 80003510 <write_head>
    800038a6:	69e2                	ld	s3,24(sp)
    800038a8:	6a42                	ld	s4,16(sp)
    800038aa:	6aa2                	ld	s5,8(sp)
    800038ac:	bdc5                	j	8000379c <end_op+0x4c>

00000000800038ae <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	e04a                	sd	s2,0(sp)
    800038b8:	1000                	addi	s0,sp,32
    800038ba:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038bc:	0001c917          	auipc	s2,0x1c
    800038c0:	33490913          	addi	s2,s2,820 # 8001fbf0 <log>
    800038c4:	854a                	mv	a0,s2
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	e94080e7          	jalr	-364(ra) # 8000675a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038ce:	03492603          	lw	a2,52(s2)
    800038d2:	47f5                	li	a5,29
    800038d4:	06c7c563          	blt	a5,a2,8000393e <log_write+0x90>
    800038d8:	0001c797          	auipc	a5,0x1c
    800038dc:	33c7a783          	lw	a5,828(a5) # 8001fc14 <log+0x24>
    800038e0:	37fd                	addiw	a5,a5,-1
    800038e2:	04f65e63          	bge	a2,a5,8000393e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038e6:	0001c797          	auipc	a5,0x1c
    800038ea:	3327a783          	lw	a5,818(a5) # 8001fc18 <log+0x28>
    800038ee:	06f05063          	blez	a5,8000394e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038f2:	4781                	li	a5,0
    800038f4:	06c05563          	blez	a2,8000395e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f8:	44cc                	lw	a1,12(s1)
    800038fa:	0001c717          	auipc	a4,0x1c
    800038fe:	32e70713          	addi	a4,a4,814 # 8001fc28 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003902:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003904:	4314                	lw	a3,0(a4)
    80003906:	04b68c63          	beq	a3,a1,8000395e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000390a:	2785                	addiw	a5,a5,1
    8000390c:	0711                	addi	a4,a4,4
    8000390e:	fef61be3          	bne	a2,a5,80003904 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003912:	0631                	addi	a2,a2,12
    80003914:	060a                	slli	a2,a2,0x2
    80003916:	0001c797          	auipc	a5,0x1c
    8000391a:	2da78793          	addi	a5,a5,730 # 8001fbf0 <log>
    8000391e:	97b2                	add	a5,a5,a2
    80003920:	44d8                	lw	a4,12(s1)
    80003922:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003924:	8526                	mv	a0,s1
    80003926:	fffff097          	auipc	ra,0xfffff
    8000392a:	d8c080e7          	jalr	-628(ra) # 800026b2 <bpin>
    log.lh.n++;
    8000392e:	0001c717          	auipc	a4,0x1c
    80003932:	2c270713          	addi	a4,a4,706 # 8001fbf0 <log>
    80003936:	5b5c                	lw	a5,52(a4)
    80003938:	2785                	addiw	a5,a5,1
    8000393a:	db5c                	sw	a5,52(a4)
    8000393c:	a82d                	j	80003976 <log_write+0xc8>
    panic("too big a transaction");
    8000393e:	00005517          	auipc	a0,0x5
    80003942:	b6a50513          	addi	a0,a0,-1174 # 800084a8 <etext+0x4a8>
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	8b0080e7          	jalr	-1872(ra) # 800061f6 <panic>
    panic("log_write outside of trans");
    8000394e:	00005517          	auipc	a0,0x5
    80003952:	b7250513          	addi	a0,a0,-1166 # 800084c0 <etext+0x4c0>
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	8a0080e7          	jalr	-1888(ra) # 800061f6 <panic>
  log.lh.block[i] = b->blockno;
    8000395e:	00c78693          	addi	a3,a5,12
    80003962:	068a                	slli	a3,a3,0x2
    80003964:	0001c717          	auipc	a4,0x1c
    80003968:	28c70713          	addi	a4,a4,652 # 8001fbf0 <log>
    8000396c:	9736                	add	a4,a4,a3
    8000396e:	44d4                	lw	a3,12(s1)
    80003970:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003972:	faf609e3          	beq	a2,a5,80003924 <log_write+0x76>
  }
  release(&log.lock);
    80003976:	0001c517          	auipc	a0,0x1c
    8000397a:	27a50513          	addi	a0,a0,634 # 8001fbf0 <log>
    8000397e:	00003097          	auipc	ra,0x3
    80003982:	ea4080e7          	jalr	-348(ra) # 80006822 <release>
}
    80003986:	60e2                	ld	ra,24(sp)
    80003988:	6442                	ld	s0,16(sp)
    8000398a:	64a2                	ld	s1,8(sp)
    8000398c:	6902                	ld	s2,0(sp)
    8000398e:	6105                	addi	sp,sp,32
    80003990:	8082                	ret

0000000080003992 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003992:	1101                	addi	sp,sp,-32
    80003994:	ec06                	sd	ra,24(sp)
    80003996:	e822                	sd	s0,16(sp)
    80003998:	e426                	sd	s1,8(sp)
    8000399a:	e04a                	sd	s2,0(sp)
    8000399c:	1000                	addi	s0,sp,32
    8000399e:	84aa                	mv	s1,a0
    800039a0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039a2:	00005597          	auipc	a1,0x5
    800039a6:	b3e58593          	addi	a1,a1,-1218 # 800084e0 <etext+0x4e0>
    800039aa:	0521                	addi	a0,a0,8
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	f22080e7          	jalr	-222(ra) # 800068ce <initlock>
  lk->name = name;
    800039b4:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    800039b8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039bc:	0204a823          	sw	zero,48(s1)
}
    800039c0:	60e2                	ld	ra,24(sp)
    800039c2:	6442                	ld	s0,16(sp)
    800039c4:	64a2                	ld	s1,8(sp)
    800039c6:	6902                	ld	s2,0(sp)
    800039c8:	6105                	addi	sp,sp,32
    800039ca:	8082                	ret

00000000800039cc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039cc:	1101                	addi	sp,sp,-32
    800039ce:	ec06                	sd	ra,24(sp)
    800039d0:	e822                	sd	s0,16(sp)
    800039d2:	e426                	sd	s1,8(sp)
    800039d4:	e04a                	sd	s2,0(sp)
    800039d6:	1000                	addi	s0,sp,32
    800039d8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039da:	00850913          	addi	s2,a0,8
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	d7a080e7          	jalr	-646(ra) # 8000675a <acquire>
  while (lk->locked) {
    800039e8:	409c                	lw	a5,0(s1)
    800039ea:	cb89                	beqz	a5,800039fc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039ec:	85ca                	mv	a1,s2
    800039ee:	8526                	mv	a0,s1
    800039f0:	ffffe097          	auipc	ra,0xffffe
    800039f4:	c70080e7          	jalr	-912(ra) # 80001660 <sleep>
  while (lk->locked) {
    800039f8:	409c                	lw	a5,0(s1)
    800039fa:	fbed                	bnez	a5,800039ec <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039fc:	4785                	li	a5,1
    800039fe:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a00:	ffffd097          	auipc	ra,0xffffd
    80003a04:	59a080e7          	jalr	1434(ra) # 80000f9a <myproc>
    80003a08:	5d1c                	lw	a5,56(a0)
    80003a0a:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	e14080e7          	jalr	-492(ra) # 80006822 <release>
}
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6902                	ld	s2,0(sp)
    80003a1e:	6105                	addi	sp,sp,32
    80003a20:	8082                	ret

0000000080003a22 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a22:	1101                	addi	sp,sp,-32
    80003a24:	ec06                	sd	ra,24(sp)
    80003a26:	e822                	sd	s0,16(sp)
    80003a28:	e426                	sd	s1,8(sp)
    80003a2a:	e04a                	sd	s2,0(sp)
    80003a2c:	1000                	addi	s0,sp,32
    80003a2e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a30:	00850913          	addi	s2,a0,8
    80003a34:	854a                	mv	a0,s2
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	d24080e7          	jalr	-732(ra) # 8000675a <acquire>
  lk->locked = 0;
    80003a3e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a42:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003a46:	8526                	mv	a0,s1
    80003a48:	ffffe097          	auipc	ra,0xffffe
    80003a4c:	da4080e7          	jalr	-604(ra) # 800017ec <wakeup>
  release(&lk->lk);
    80003a50:	854a                	mv	a0,s2
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	dd0080e7          	jalr	-560(ra) # 80006822 <release>
}
    80003a5a:	60e2                	ld	ra,24(sp)
    80003a5c:	6442                	ld	s0,16(sp)
    80003a5e:	64a2                	ld	s1,8(sp)
    80003a60:	6902                	ld	s2,0(sp)
    80003a62:	6105                	addi	sp,sp,32
    80003a64:	8082                	ret

0000000080003a66 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a66:	7179                	addi	sp,sp,-48
    80003a68:	f406                	sd	ra,40(sp)
    80003a6a:	f022                	sd	s0,32(sp)
    80003a6c:	ec26                	sd	s1,24(sp)
    80003a6e:	e84a                	sd	s2,16(sp)
    80003a70:	1800                	addi	s0,sp,48
    80003a72:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a74:	00850913          	addi	s2,a0,8
    80003a78:	854a                	mv	a0,s2
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	ce0080e7          	jalr	-800(ra) # 8000675a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a82:	409c                	lw	a5,0(s1)
    80003a84:	ef91                	bnez	a5,80003aa0 <holdingsleep+0x3a>
    80003a86:	4481                	li	s1,0
  release(&lk->lk);
    80003a88:	854a                	mv	a0,s2
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	d98080e7          	jalr	-616(ra) # 80006822 <release>
  return r;
}
    80003a92:	8526                	mv	a0,s1
    80003a94:	70a2                	ld	ra,40(sp)
    80003a96:	7402                	ld	s0,32(sp)
    80003a98:	64e2                	ld	s1,24(sp)
    80003a9a:	6942                	ld	s2,16(sp)
    80003a9c:	6145                	addi	sp,sp,48
    80003a9e:	8082                	ret
    80003aa0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aa2:	0304a983          	lw	s3,48(s1)
    80003aa6:	ffffd097          	auipc	ra,0xffffd
    80003aaa:	4f4080e7          	jalr	1268(ra) # 80000f9a <myproc>
    80003aae:	5d04                	lw	s1,56(a0)
    80003ab0:	413484b3          	sub	s1,s1,s3
    80003ab4:	0014b493          	seqz	s1,s1
    80003ab8:	69a2                	ld	s3,8(sp)
    80003aba:	b7f9                	j	80003a88 <holdingsleep+0x22>

0000000080003abc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003abc:	1141                	addi	sp,sp,-16
    80003abe:	e406                	sd	ra,8(sp)
    80003ac0:	e022                	sd	s0,0(sp)
    80003ac2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ac4:	00005597          	auipc	a1,0x5
    80003ac8:	a2c58593          	addi	a1,a1,-1492 # 800084f0 <etext+0x4f0>
    80003acc:	0001c517          	auipc	a0,0x1c
    80003ad0:	27450513          	addi	a0,a0,628 # 8001fd40 <ftable>
    80003ad4:	00003097          	auipc	ra,0x3
    80003ad8:	dfa080e7          	jalr	-518(ra) # 800068ce <initlock>
}
    80003adc:	60a2                	ld	ra,8(sp)
    80003ade:	6402                	ld	s0,0(sp)
    80003ae0:	0141                	addi	sp,sp,16
    80003ae2:	8082                	ret

0000000080003ae4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ae4:	1101                	addi	sp,sp,-32
    80003ae6:	ec06                	sd	ra,24(sp)
    80003ae8:	e822                	sd	s0,16(sp)
    80003aea:	e426                	sd	s1,8(sp)
    80003aec:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aee:	0001c517          	auipc	a0,0x1c
    80003af2:	25250513          	addi	a0,a0,594 # 8001fd40 <ftable>
    80003af6:	00003097          	auipc	ra,0x3
    80003afa:	c64080e7          	jalr	-924(ra) # 8000675a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003afe:	0001c497          	auipc	s1,0x1c
    80003b02:	26248493          	addi	s1,s1,610 # 8001fd60 <ftable+0x20>
    80003b06:	0001d717          	auipc	a4,0x1d
    80003b0a:	1fa70713          	addi	a4,a4,506 # 80020d00 <ftable+0xfc0>
    if(f->ref == 0){
    80003b0e:	40dc                	lw	a5,4(s1)
    80003b10:	cf99                	beqz	a5,80003b2e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b12:	02848493          	addi	s1,s1,40
    80003b16:	fee49ce3          	bne	s1,a4,80003b0e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b1a:	0001c517          	auipc	a0,0x1c
    80003b1e:	22650513          	addi	a0,a0,550 # 8001fd40 <ftable>
    80003b22:	00003097          	auipc	ra,0x3
    80003b26:	d00080e7          	jalr	-768(ra) # 80006822 <release>
  return 0;
    80003b2a:	4481                	li	s1,0
    80003b2c:	a819                	j	80003b42 <filealloc+0x5e>
      f->ref = 1;
    80003b2e:	4785                	li	a5,1
    80003b30:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b32:	0001c517          	auipc	a0,0x1c
    80003b36:	20e50513          	addi	a0,a0,526 # 8001fd40 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	ce8080e7          	jalr	-792(ra) # 80006822 <release>
}
    80003b42:	8526                	mv	a0,s1
    80003b44:	60e2                	ld	ra,24(sp)
    80003b46:	6442                	ld	s0,16(sp)
    80003b48:	64a2                	ld	s1,8(sp)
    80003b4a:	6105                	addi	sp,sp,32
    80003b4c:	8082                	ret

0000000080003b4e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b4e:	1101                	addi	sp,sp,-32
    80003b50:	ec06                	sd	ra,24(sp)
    80003b52:	e822                	sd	s0,16(sp)
    80003b54:	e426                	sd	s1,8(sp)
    80003b56:	1000                	addi	s0,sp,32
    80003b58:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b5a:	0001c517          	auipc	a0,0x1c
    80003b5e:	1e650513          	addi	a0,a0,486 # 8001fd40 <ftable>
    80003b62:	00003097          	auipc	ra,0x3
    80003b66:	bf8080e7          	jalr	-1032(ra) # 8000675a <acquire>
  if(f->ref < 1)
    80003b6a:	40dc                	lw	a5,4(s1)
    80003b6c:	02f05263          	blez	a5,80003b90 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b70:	2785                	addiw	a5,a5,1
    80003b72:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b74:	0001c517          	auipc	a0,0x1c
    80003b78:	1cc50513          	addi	a0,a0,460 # 8001fd40 <ftable>
    80003b7c:	00003097          	auipc	ra,0x3
    80003b80:	ca6080e7          	jalr	-858(ra) # 80006822 <release>
  return f;
}
    80003b84:	8526                	mv	a0,s1
    80003b86:	60e2                	ld	ra,24(sp)
    80003b88:	6442                	ld	s0,16(sp)
    80003b8a:	64a2                	ld	s1,8(sp)
    80003b8c:	6105                	addi	sp,sp,32
    80003b8e:	8082                	ret
    panic("filedup");
    80003b90:	00005517          	auipc	a0,0x5
    80003b94:	96850513          	addi	a0,a0,-1688 # 800084f8 <etext+0x4f8>
    80003b98:	00002097          	auipc	ra,0x2
    80003b9c:	65e080e7          	jalr	1630(ra) # 800061f6 <panic>

0000000080003ba0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ba0:	7139                	addi	sp,sp,-64
    80003ba2:	fc06                	sd	ra,56(sp)
    80003ba4:	f822                	sd	s0,48(sp)
    80003ba6:	f426                	sd	s1,40(sp)
    80003ba8:	0080                	addi	s0,sp,64
    80003baa:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bac:	0001c517          	auipc	a0,0x1c
    80003bb0:	19450513          	addi	a0,a0,404 # 8001fd40 <ftable>
    80003bb4:	00003097          	auipc	ra,0x3
    80003bb8:	ba6080e7          	jalr	-1114(ra) # 8000675a <acquire>
  if(f->ref < 1)
    80003bbc:	40dc                	lw	a5,4(s1)
    80003bbe:	04f05c63          	blez	a5,80003c16 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003bc2:	37fd                	addiw	a5,a5,-1
    80003bc4:	0007871b          	sext.w	a4,a5
    80003bc8:	c0dc                	sw	a5,4(s1)
    80003bca:	06e04263          	bgtz	a4,80003c2e <fileclose+0x8e>
    80003bce:	f04a                	sd	s2,32(sp)
    80003bd0:	ec4e                	sd	s3,24(sp)
    80003bd2:	e852                	sd	s4,16(sp)
    80003bd4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bd6:	0004a903          	lw	s2,0(s1)
    80003bda:	0094ca83          	lbu	s5,9(s1)
    80003bde:	0104ba03          	ld	s4,16(s1)
    80003be2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003be6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bea:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bee:	0001c517          	auipc	a0,0x1c
    80003bf2:	15250513          	addi	a0,a0,338 # 8001fd40 <ftable>
    80003bf6:	00003097          	auipc	ra,0x3
    80003bfa:	c2c080e7          	jalr	-980(ra) # 80006822 <release>

  if(ff.type == FD_PIPE){
    80003bfe:	4785                	li	a5,1
    80003c00:	04f90463          	beq	s2,a5,80003c48 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c04:	3979                	addiw	s2,s2,-2
    80003c06:	4785                	li	a5,1
    80003c08:	0527fb63          	bgeu	a5,s2,80003c5e <fileclose+0xbe>
    80003c0c:	7902                	ld	s2,32(sp)
    80003c0e:	69e2                	ld	s3,24(sp)
    80003c10:	6a42                	ld	s4,16(sp)
    80003c12:	6aa2                	ld	s5,8(sp)
    80003c14:	a02d                	j	80003c3e <fileclose+0x9e>
    80003c16:	f04a                	sd	s2,32(sp)
    80003c18:	ec4e                	sd	s3,24(sp)
    80003c1a:	e852                	sd	s4,16(sp)
    80003c1c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c1e:	00005517          	auipc	a0,0x5
    80003c22:	8e250513          	addi	a0,a0,-1822 # 80008500 <etext+0x500>
    80003c26:	00002097          	auipc	ra,0x2
    80003c2a:	5d0080e7          	jalr	1488(ra) # 800061f6 <panic>
    release(&ftable.lock);
    80003c2e:	0001c517          	auipc	a0,0x1c
    80003c32:	11250513          	addi	a0,a0,274 # 8001fd40 <ftable>
    80003c36:	00003097          	auipc	ra,0x3
    80003c3a:	bec080e7          	jalr	-1044(ra) # 80006822 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c3e:	70e2                	ld	ra,56(sp)
    80003c40:	7442                	ld	s0,48(sp)
    80003c42:	74a2                	ld	s1,40(sp)
    80003c44:	6121                	addi	sp,sp,64
    80003c46:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c48:	85d6                	mv	a1,s5
    80003c4a:	8552                	mv	a0,s4
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	3a2080e7          	jalr	930(ra) # 80003fee <pipeclose>
    80003c54:	7902                	ld	s2,32(sp)
    80003c56:	69e2                	ld	s3,24(sp)
    80003c58:	6a42                	ld	s4,16(sp)
    80003c5a:	6aa2                	ld	s5,8(sp)
    80003c5c:	b7cd                	j	80003c3e <fileclose+0x9e>
    begin_op();
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	a78080e7          	jalr	-1416(ra) # 800036d6 <begin_op>
    iput(ff.ip);
    80003c66:	854e                	mv	a0,s3
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	25a080e7          	jalr	602(ra) # 80002ec2 <iput>
    end_op();
    80003c70:	00000097          	auipc	ra,0x0
    80003c74:	ae0080e7          	jalr	-1312(ra) # 80003750 <end_op>
    80003c78:	7902                	ld	s2,32(sp)
    80003c7a:	69e2                	ld	s3,24(sp)
    80003c7c:	6a42                	ld	s4,16(sp)
    80003c7e:	6aa2                	ld	s5,8(sp)
    80003c80:	bf7d                	j	80003c3e <fileclose+0x9e>

0000000080003c82 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c82:	715d                	addi	sp,sp,-80
    80003c84:	e486                	sd	ra,72(sp)
    80003c86:	e0a2                	sd	s0,64(sp)
    80003c88:	fc26                	sd	s1,56(sp)
    80003c8a:	f44e                	sd	s3,40(sp)
    80003c8c:	0880                	addi	s0,sp,80
    80003c8e:	84aa                	mv	s1,a0
    80003c90:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c92:	ffffd097          	auipc	ra,0xffffd
    80003c96:	308080e7          	jalr	776(ra) # 80000f9a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c9a:	409c                	lw	a5,0(s1)
    80003c9c:	37f9                	addiw	a5,a5,-2
    80003c9e:	4705                	li	a4,1
    80003ca0:	04f76863          	bltu	a4,a5,80003cf0 <filestat+0x6e>
    80003ca4:	f84a                	sd	s2,48(sp)
    80003ca6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ca8:	6c88                	ld	a0,24(s1)
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	05a080e7          	jalr	90(ra) # 80002d04 <ilock>
    stati(f->ip, &st);
    80003cb2:	fb840593          	addi	a1,s0,-72
    80003cb6:	6c88                	ld	a0,24(s1)
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	2da080e7          	jalr	730(ra) # 80002f92 <stati>
    iunlock(f->ip);
    80003cc0:	6c88                	ld	a0,24(s1)
    80003cc2:	fffff097          	auipc	ra,0xfffff
    80003cc6:	108080e7          	jalr	264(ra) # 80002dca <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cca:	46e1                	li	a3,24
    80003ccc:	fb840613          	addi	a2,s0,-72
    80003cd0:	85ce                	mv	a1,s3
    80003cd2:	05893503          	ld	a0,88(s2)
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	f60080e7          	jalr	-160(ra) # 80000c36 <copyout>
    80003cde:	41f5551b          	sraiw	a0,a0,0x1f
    80003ce2:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003ce4:	60a6                	ld	ra,72(sp)
    80003ce6:	6406                	ld	s0,64(sp)
    80003ce8:	74e2                	ld	s1,56(sp)
    80003cea:	79a2                	ld	s3,40(sp)
    80003cec:	6161                	addi	sp,sp,80
    80003cee:	8082                	ret
  return -1;
    80003cf0:	557d                	li	a0,-1
    80003cf2:	bfcd                	j	80003ce4 <filestat+0x62>

0000000080003cf4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cf4:	7179                	addi	sp,sp,-48
    80003cf6:	f406                	sd	ra,40(sp)
    80003cf8:	f022                	sd	s0,32(sp)
    80003cfa:	e84a                	sd	s2,16(sp)
    80003cfc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cfe:	00854783          	lbu	a5,8(a0)
    80003d02:	cbc5                	beqz	a5,80003db2 <fileread+0xbe>
    80003d04:	ec26                	sd	s1,24(sp)
    80003d06:	e44e                	sd	s3,8(sp)
    80003d08:	84aa                	mv	s1,a0
    80003d0a:	89ae                	mv	s3,a1
    80003d0c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d0e:	411c                	lw	a5,0(a0)
    80003d10:	4705                	li	a4,1
    80003d12:	04e78963          	beq	a5,a4,80003d64 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d16:	470d                	li	a4,3
    80003d18:	04e78f63          	beq	a5,a4,80003d76 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d1c:	4709                	li	a4,2
    80003d1e:	08e79263          	bne	a5,a4,80003da2 <fileread+0xae>
    ilock(f->ip);
    80003d22:	6d08                	ld	a0,24(a0)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	fe0080e7          	jalr	-32(ra) # 80002d04 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d2c:	874a                	mv	a4,s2
    80003d2e:	5094                	lw	a3,32(s1)
    80003d30:	864e                	mv	a2,s3
    80003d32:	4585                	li	a1,1
    80003d34:	6c88                	ld	a0,24(s1)
    80003d36:	fffff097          	auipc	ra,0xfffff
    80003d3a:	286080e7          	jalr	646(ra) # 80002fbc <readi>
    80003d3e:	892a                	mv	s2,a0
    80003d40:	00a05563          	blez	a0,80003d4a <fileread+0x56>
      f->off += r;
    80003d44:	509c                	lw	a5,32(s1)
    80003d46:	9fa9                	addw	a5,a5,a0
    80003d48:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d4a:	6c88                	ld	a0,24(s1)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	07e080e7          	jalr	126(ra) # 80002dca <iunlock>
    80003d54:	64e2                	ld	s1,24(sp)
    80003d56:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d58:	854a                	mv	a0,s2
    80003d5a:	70a2                	ld	ra,40(sp)
    80003d5c:	7402                	ld	s0,32(sp)
    80003d5e:	6942                	ld	s2,16(sp)
    80003d60:	6145                	addi	sp,sp,48
    80003d62:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d64:	6908                	ld	a0,16(a0)
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	404080e7          	jalr	1028(ra) # 8000416a <piperead>
    80003d6e:	892a                	mv	s2,a0
    80003d70:	64e2                	ld	s1,24(sp)
    80003d72:	69a2                	ld	s3,8(sp)
    80003d74:	b7d5                	j	80003d58 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d76:	02451783          	lh	a5,36(a0)
    80003d7a:	03079693          	slli	a3,a5,0x30
    80003d7e:	92c1                	srli	a3,a3,0x30
    80003d80:	4725                	li	a4,9
    80003d82:	02d76a63          	bltu	a4,a3,80003db6 <fileread+0xc2>
    80003d86:	0792                	slli	a5,a5,0x4
    80003d88:	0001c717          	auipc	a4,0x1c
    80003d8c:	f1870713          	addi	a4,a4,-232 # 8001fca0 <devsw>
    80003d90:	97ba                	add	a5,a5,a4
    80003d92:	639c                	ld	a5,0(a5)
    80003d94:	c78d                	beqz	a5,80003dbe <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d96:	4505                	li	a0,1
    80003d98:	9782                	jalr	a5
    80003d9a:	892a                	mv	s2,a0
    80003d9c:	64e2                	ld	s1,24(sp)
    80003d9e:	69a2                	ld	s3,8(sp)
    80003da0:	bf65                	j	80003d58 <fileread+0x64>
    panic("fileread");
    80003da2:	00004517          	auipc	a0,0x4
    80003da6:	76e50513          	addi	a0,a0,1902 # 80008510 <etext+0x510>
    80003daa:	00002097          	auipc	ra,0x2
    80003dae:	44c080e7          	jalr	1100(ra) # 800061f6 <panic>
    return -1;
    80003db2:	597d                	li	s2,-1
    80003db4:	b755                	j	80003d58 <fileread+0x64>
      return -1;
    80003db6:	597d                	li	s2,-1
    80003db8:	64e2                	ld	s1,24(sp)
    80003dba:	69a2                	ld	s3,8(sp)
    80003dbc:	bf71                	j	80003d58 <fileread+0x64>
    80003dbe:	597d                	li	s2,-1
    80003dc0:	64e2                	ld	s1,24(sp)
    80003dc2:	69a2                	ld	s3,8(sp)
    80003dc4:	bf51                	j	80003d58 <fileread+0x64>

0000000080003dc6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003dc6:	00954783          	lbu	a5,9(a0)
    80003dca:	12078963          	beqz	a5,80003efc <filewrite+0x136>
{
    80003dce:	715d                	addi	sp,sp,-80
    80003dd0:	e486                	sd	ra,72(sp)
    80003dd2:	e0a2                	sd	s0,64(sp)
    80003dd4:	f84a                	sd	s2,48(sp)
    80003dd6:	f052                	sd	s4,32(sp)
    80003dd8:	e85a                	sd	s6,16(sp)
    80003dda:	0880                	addi	s0,sp,80
    80003ddc:	892a                	mv	s2,a0
    80003dde:	8b2e                	mv	s6,a1
    80003de0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de2:	411c                	lw	a5,0(a0)
    80003de4:	4705                	li	a4,1
    80003de6:	02e78763          	beq	a5,a4,80003e14 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dea:	470d                	li	a4,3
    80003dec:	02e78a63          	beq	a5,a4,80003e20 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df0:	4709                	li	a4,2
    80003df2:	0ee79863          	bne	a5,a4,80003ee2 <filewrite+0x11c>
    80003df6:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003df8:	0cc05463          	blez	a2,80003ec0 <filewrite+0xfa>
    80003dfc:	fc26                	sd	s1,56(sp)
    80003dfe:	ec56                	sd	s5,24(sp)
    80003e00:	e45e                	sd	s7,8(sp)
    80003e02:	e062                	sd	s8,0(sp)
    int i = 0;
    80003e04:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e06:	6b85                	lui	s7,0x1
    80003e08:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e0c:	6c05                	lui	s8,0x1
    80003e0e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e12:	a851                	j	80003ea6 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e14:	6908                	ld	a0,16(a0)
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	252080e7          	jalr	594(ra) # 80004068 <pipewrite>
    80003e1e:	a85d                	j	80003ed4 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e20:	02451783          	lh	a5,36(a0)
    80003e24:	03079693          	slli	a3,a5,0x30
    80003e28:	92c1                	srli	a3,a3,0x30
    80003e2a:	4725                	li	a4,9
    80003e2c:	0cd76a63          	bltu	a4,a3,80003f00 <filewrite+0x13a>
    80003e30:	0792                	slli	a5,a5,0x4
    80003e32:	0001c717          	auipc	a4,0x1c
    80003e36:	e6e70713          	addi	a4,a4,-402 # 8001fca0 <devsw>
    80003e3a:	97ba                	add	a5,a5,a4
    80003e3c:	679c                	ld	a5,8(a5)
    80003e3e:	c3f9                	beqz	a5,80003f04 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003e40:	4505                	li	a0,1
    80003e42:	9782                	jalr	a5
    80003e44:	a841                	j	80003ed4 <filewrite+0x10e>
      if(n1 > max)
    80003e46:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	88c080e7          	jalr	-1908(ra) # 800036d6 <begin_op>
      ilock(f->ip);
    80003e52:	01893503          	ld	a0,24(s2)
    80003e56:	fffff097          	auipc	ra,0xfffff
    80003e5a:	eae080e7          	jalr	-338(ra) # 80002d04 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e5e:	8756                	mv	a4,s5
    80003e60:	02092683          	lw	a3,32(s2)
    80003e64:	01698633          	add	a2,s3,s6
    80003e68:	4585                	li	a1,1
    80003e6a:	01893503          	ld	a0,24(s2)
    80003e6e:	fffff097          	auipc	ra,0xfffff
    80003e72:	252080e7          	jalr	594(ra) # 800030c0 <writei>
    80003e76:	84aa                	mv	s1,a0
    80003e78:	00a05763          	blez	a0,80003e86 <filewrite+0xc0>
        f->off += r;
    80003e7c:	02092783          	lw	a5,32(s2)
    80003e80:	9fa9                	addw	a5,a5,a0
    80003e82:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e86:	01893503          	ld	a0,24(s2)
    80003e8a:	fffff097          	auipc	ra,0xfffff
    80003e8e:	f40080e7          	jalr	-192(ra) # 80002dca <iunlock>
      end_op();
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	8be080e7          	jalr	-1858(ra) # 80003750 <end_op>

      if(r != n1){
    80003e9a:	029a9563          	bne	s5,s1,80003ec4 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003e9e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ea2:	0149da63          	bge	s3,s4,80003eb6 <filewrite+0xf0>
      int n1 = n - i;
    80003ea6:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003eaa:	0004879b          	sext.w	a5,s1
    80003eae:	f8fbdce3          	bge	s7,a5,80003e46 <filewrite+0x80>
    80003eb2:	84e2                	mv	s1,s8
    80003eb4:	bf49                	j	80003e46 <filewrite+0x80>
    80003eb6:	74e2                	ld	s1,56(sp)
    80003eb8:	6ae2                	ld	s5,24(sp)
    80003eba:	6ba2                	ld	s7,8(sp)
    80003ebc:	6c02                	ld	s8,0(sp)
    80003ebe:	a039                	j	80003ecc <filewrite+0x106>
    int i = 0;
    80003ec0:	4981                	li	s3,0
    80003ec2:	a029                	j	80003ecc <filewrite+0x106>
    80003ec4:	74e2                	ld	s1,56(sp)
    80003ec6:	6ae2                	ld	s5,24(sp)
    80003ec8:	6ba2                	ld	s7,8(sp)
    80003eca:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003ecc:	033a1e63          	bne	s4,s3,80003f08 <filewrite+0x142>
    80003ed0:	8552                	mv	a0,s4
    80003ed2:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ed4:	60a6                	ld	ra,72(sp)
    80003ed6:	6406                	ld	s0,64(sp)
    80003ed8:	7942                	ld	s2,48(sp)
    80003eda:	7a02                	ld	s4,32(sp)
    80003edc:	6b42                	ld	s6,16(sp)
    80003ede:	6161                	addi	sp,sp,80
    80003ee0:	8082                	ret
    80003ee2:	fc26                	sd	s1,56(sp)
    80003ee4:	f44e                	sd	s3,40(sp)
    80003ee6:	ec56                	sd	s5,24(sp)
    80003ee8:	e45e                	sd	s7,8(sp)
    80003eea:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003eec:	00004517          	auipc	a0,0x4
    80003ef0:	63450513          	addi	a0,a0,1588 # 80008520 <etext+0x520>
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	302080e7          	jalr	770(ra) # 800061f6 <panic>
    return -1;
    80003efc:	557d                	li	a0,-1
}
    80003efe:	8082                	ret
      return -1;
    80003f00:	557d                	li	a0,-1
    80003f02:	bfc9                	j	80003ed4 <filewrite+0x10e>
    80003f04:	557d                	li	a0,-1
    80003f06:	b7f9                	j	80003ed4 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003f08:	557d                	li	a0,-1
    80003f0a:	79a2                	ld	s3,40(sp)
    80003f0c:	b7e1                	j	80003ed4 <filewrite+0x10e>

0000000080003f0e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f0e:	7179                	addi	sp,sp,-48
    80003f10:	f406                	sd	ra,40(sp)
    80003f12:	f022                	sd	s0,32(sp)
    80003f14:	ec26                	sd	s1,24(sp)
    80003f16:	e052                	sd	s4,0(sp)
    80003f18:	1800                	addi	s0,sp,48
    80003f1a:	84aa                	mv	s1,a0
    80003f1c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f1e:	0005b023          	sd	zero,0(a1)
    80003f22:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f26:	00000097          	auipc	ra,0x0
    80003f2a:	bbe080e7          	jalr	-1090(ra) # 80003ae4 <filealloc>
    80003f2e:	e088                	sd	a0,0(s1)
    80003f30:	cd49                	beqz	a0,80003fca <pipealloc+0xbc>
    80003f32:	00000097          	auipc	ra,0x0
    80003f36:	bb2080e7          	jalr	-1102(ra) # 80003ae4 <filealloc>
    80003f3a:	00aa3023          	sd	a0,0(s4)
    80003f3e:	c141                	beqz	a0,80003fbe <pipealloc+0xb0>
    80003f40:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f42:	ffffc097          	auipc	ra,0xffffc
    80003f46:	23e080e7          	jalr	574(ra) # 80000180 <kalloc>
    80003f4a:	892a                	mv	s2,a0
    80003f4c:	c13d                	beqz	a0,80003fb2 <pipealloc+0xa4>
    80003f4e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f50:	4985                	li	s3,1
    80003f52:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003f56:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003f5a:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003f5e:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003f62:	00004597          	auipc	a1,0x4
    80003f66:	5ce58593          	addi	a1,a1,1486 # 80008530 <etext+0x530>
    80003f6a:	00003097          	auipc	ra,0x3
    80003f6e:	964080e7          	jalr	-1692(ra) # 800068ce <initlock>
  (*f0)->type = FD_PIPE;
    80003f72:	609c                	ld	a5,0(s1)
    80003f74:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f78:	609c                	ld	a5,0(s1)
    80003f7a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f7e:	609c                	ld	a5,0(s1)
    80003f80:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f84:	609c                	ld	a5,0(s1)
    80003f86:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f8a:	000a3783          	ld	a5,0(s4)
    80003f8e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f92:	000a3783          	ld	a5,0(s4)
    80003f96:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f9a:	000a3783          	ld	a5,0(s4)
    80003f9e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fa2:	000a3783          	ld	a5,0(s4)
    80003fa6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003faa:	4501                	li	a0,0
    80003fac:	6942                	ld	s2,16(sp)
    80003fae:	69a2                	ld	s3,8(sp)
    80003fb0:	a03d                	j	80003fde <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fb2:	6088                	ld	a0,0(s1)
    80003fb4:	c119                	beqz	a0,80003fba <pipealloc+0xac>
    80003fb6:	6942                	ld	s2,16(sp)
    80003fb8:	a029                	j	80003fc2 <pipealloc+0xb4>
    80003fba:	6942                	ld	s2,16(sp)
    80003fbc:	a039                	j	80003fca <pipealloc+0xbc>
    80003fbe:	6088                	ld	a0,0(s1)
    80003fc0:	c50d                	beqz	a0,80003fea <pipealloc+0xdc>
    fileclose(*f0);
    80003fc2:	00000097          	auipc	ra,0x0
    80003fc6:	bde080e7          	jalr	-1058(ra) # 80003ba0 <fileclose>
  if(*f1)
    80003fca:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fce:	557d                	li	a0,-1
  if(*f1)
    80003fd0:	c799                	beqz	a5,80003fde <pipealloc+0xd0>
    fileclose(*f1);
    80003fd2:	853e                	mv	a0,a5
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	bcc080e7          	jalr	-1076(ra) # 80003ba0 <fileclose>
  return -1;
    80003fdc:	557d                	li	a0,-1
}
    80003fde:	70a2                	ld	ra,40(sp)
    80003fe0:	7402                	ld	s0,32(sp)
    80003fe2:	64e2                	ld	s1,24(sp)
    80003fe4:	6a02                	ld	s4,0(sp)
    80003fe6:	6145                	addi	sp,sp,48
    80003fe8:	8082                	ret
  return -1;
    80003fea:	557d                	li	a0,-1
    80003fec:	bfcd                	j	80003fde <pipealloc+0xd0>

0000000080003fee <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fee:	1101                	addi	sp,sp,-32
    80003ff0:	ec06                	sd	ra,24(sp)
    80003ff2:	e822                	sd	s0,16(sp)
    80003ff4:	e426                	sd	s1,8(sp)
    80003ff6:	e04a                	sd	s2,0(sp)
    80003ff8:	1000                	addi	s0,sp,32
    80003ffa:	84aa                	mv	s1,a0
    80003ffc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	75c080e7          	jalr	1884(ra) # 8000675a <acquire>
  if(writable){
    80004006:	04090263          	beqz	s2,8000404a <pipeclose+0x5c>
    pi->writeopen = 0;
    8000400a:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    8000400e:	22048513          	addi	a0,s1,544
    80004012:	ffffd097          	auipc	ra,0xffffd
    80004016:	7da080e7          	jalr	2010(ra) # 800017ec <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000401a:	2284b783          	ld	a5,552(s1)
    8000401e:	ef9d                	bnez	a5,8000405c <pipeclose+0x6e>
    release(&pi->lock);
    80004020:	8526                	mv	a0,s1
    80004022:	00003097          	auipc	ra,0x3
    80004026:	800080e7          	jalr	-2048(ra) # 80006822 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    8000402a:	8526                	mv	a0,s1
    8000402c:	00003097          	auipc	ra,0x3
    80004030:	83e080e7          	jalr	-1986(ra) # 8000686a <freelock>
#endif    
    kfree((char*)pi);
    80004034:	8526                	mv	a0,s1
    80004036:	ffffc097          	auipc	ra,0xffffc
    8000403a:	fe6080e7          	jalr	-26(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000403e:	60e2                	ld	ra,24(sp)
    80004040:	6442                	ld	s0,16(sp)
    80004042:	64a2                	ld	s1,8(sp)
    80004044:	6902                	ld	s2,0(sp)
    80004046:	6105                	addi	sp,sp,32
    80004048:	8082                	ret
    pi->readopen = 0;
    8000404a:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    8000404e:	22448513          	addi	a0,s1,548
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	79a080e7          	jalr	1946(ra) # 800017ec <wakeup>
    8000405a:	b7c1                	j	8000401a <pipeclose+0x2c>
    release(&pi->lock);
    8000405c:	8526                	mv	a0,s1
    8000405e:	00002097          	auipc	ra,0x2
    80004062:	7c4080e7          	jalr	1988(ra) # 80006822 <release>
}
    80004066:	bfe1                	j	8000403e <pipeclose+0x50>

0000000080004068 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004068:	711d                	addi	sp,sp,-96
    8000406a:	ec86                	sd	ra,88(sp)
    8000406c:	e8a2                	sd	s0,80(sp)
    8000406e:	e4a6                	sd	s1,72(sp)
    80004070:	e0ca                	sd	s2,64(sp)
    80004072:	fc4e                	sd	s3,56(sp)
    80004074:	f852                	sd	s4,48(sp)
    80004076:	f456                	sd	s5,40(sp)
    80004078:	1080                	addi	s0,sp,96
    8000407a:	84aa                	mv	s1,a0
    8000407c:	8aae                	mv	s5,a1
    8000407e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	f1a080e7          	jalr	-230(ra) # 80000f9a <myproc>
    80004088:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000408a:	8526                	mv	a0,s1
    8000408c:	00002097          	auipc	ra,0x2
    80004090:	6ce080e7          	jalr	1742(ra) # 8000675a <acquire>
  while(i < n){
    80004094:	0d405563          	blez	s4,8000415e <pipewrite+0xf6>
    80004098:	f05a                	sd	s6,32(sp)
    8000409a:	ec5e                	sd	s7,24(sp)
    8000409c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000409e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040a0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040a2:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800040a6:	22448b93          	addi	s7,s1,548
    800040aa:	a089                	j	800040ec <pipewrite+0x84>
      release(&pi->lock);
    800040ac:	8526                	mv	a0,s1
    800040ae:	00002097          	auipc	ra,0x2
    800040b2:	774080e7          	jalr	1908(ra) # 80006822 <release>
      return -1;
    800040b6:	597d                	li	s2,-1
    800040b8:	7b02                	ld	s6,32(sp)
    800040ba:	6be2                	ld	s7,24(sp)
    800040bc:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040be:	854a                	mv	a0,s2
    800040c0:	60e6                	ld	ra,88(sp)
    800040c2:	6446                	ld	s0,80(sp)
    800040c4:	64a6                	ld	s1,72(sp)
    800040c6:	6906                	ld	s2,64(sp)
    800040c8:	79e2                	ld	s3,56(sp)
    800040ca:	7a42                	ld	s4,48(sp)
    800040cc:	7aa2                	ld	s5,40(sp)
    800040ce:	6125                	addi	sp,sp,96
    800040d0:	8082                	ret
      wakeup(&pi->nread);
    800040d2:	8562                	mv	a0,s8
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	718080e7          	jalr	1816(ra) # 800017ec <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040dc:	85a6                	mv	a1,s1
    800040de:	855e                	mv	a0,s7
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	580080e7          	jalr	1408(ra) # 80001660 <sleep>
  while(i < n){
    800040e8:	05495c63          	bge	s2,s4,80004140 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    800040ec:	2284a783          	lw	a5,552(s1)
    800040f0:	dfd5                	beqz	a5,800040ac <pipewrite+0x44>
    800040f2:	0309a783          	lw	a5,48(s3)
    800040f6:	fbdd                	bnez	a5,800040ac <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040f8:	2204a783          	lw	a5,544(s1)
    800040fc:	2244a703          	lw	a4,548(s1)
    80004100:	2007879b          	addiw	a5,a5,512
    80004104:	fcf707e3          	beq	a4,a5,800040d2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004108:	4685                	li	a3,1
    8000410a:	01590633          	add	a2,s2,s5
    8000410e:	faf40593          	addi	a1,s0,-81
    80004112:	0589b503          	ld	a0,88(s3)
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	bac080e7          	jalr	-1108(ra) # 80000cc2 <copyin>
    8000411e:	05650263          	beq	a0,s6,80004162 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004122:	2244a783          	lw	a5,548(s1)
    80004126:	0017871b          	addiw	a4,a5,1
    8000412a:	22e4a223          	sw	a4,548(s1)
    8000412e:	1ff7f793          	andi	a5,a5,511
    80004132:	97a6                	add	a5,a5,s1
    80004134:	faf44703          	lbu	a4,-81(s0)
    80004138:	02e78023          	sb	a4,32(a5)
      i++;
    8000413c:	2905                	addiw	s2,s2,1
    8000413e:	b76d                	j	800040e8 <pipewrite+0x80>
    80004140:	7b02                	ld	s6,32(sp)
    80004142:	6be2                	ld	s7,24(sp)
    80004144:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004146:	22048513          	addi	a0,s1,544
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	6a2080e7          	jalr	1698(ra) # 800017ec <wakeup>
  release(&pi->lock);
    80004152:	8526                	mv	a0,s1
    80004154:	00002097          	auipc	ra,0x2
    80004158:	6ce080e7          	jalr	1742(ra) # 80006822 <release>
  return i;
    8000415c:	b78d                	j	800040be <pipewrite+0x56>
  int i = 0;
    8000415e:	4901                	li	s2,0
    80004160:	b7dd                	j	80004146 <pipewrite+0xde>
    80004162:	7b02                	ld	s6,32(sp)
    80004164:	6be2                	ld	s7,24(sp)
    80004166:	6c42                	ld	s8,16(sp)
    80004168:	bff9                	j	80004146 <pipewrite+0xde>

000000008000416a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000416a:	715d                	addi	sp,sp,-80
    8000416c:	e486                	sd	ra,72(sp)
    8000416e:	e0a2                	sd	s0,64(sp)
    80004170:	fc26                	sd	s1,56(sp)
    80004172:	f84a                	sd	s2,48(sp)
    80004174:	f44e                	sd	s3,40(sp)
    80004176:	f052                	sd	s4,32(sp)
    80004178:	ec56                	sd	s5,24(sp)
    8000417a:	0880                	addi	s0,sp,80
    8000417c:	84aa                	mv	s1,a0
    8000417e:	892e                	mv	s2,a1
    80004180:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004182:	ffffd097          	auipc	ra,0xffffd
    80004186:	e18080e7          	jalr	-488(ra) # 80000f9a <myproc>
    8000418a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000418c:	8526                	mv	a0,s1
    8000418e:	00002097          	auipc	ra,0x2
    80004192:	5cc080e7          	jalr	1484(ra) # 8000675a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004196:	2204a703          	lw	a4,544(s1)
    8000419a:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000419e:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a2:	02f71663          	bne	a4,a5,800041ce <piperead+0x64>
    800041a6:	22c4a783          	lw	a5,556(s1)
    800041aa:	cb9d                	beqz	a5,800041e0 <piperead+0x76>
    if(pr->killed){
    800041ac:	030a2783          	lw	a5,48(s4)
    800041b0:	e38d                	bnez	a5,800041d2 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b2:	85a6                	mv	a1,s1
    800041b4:	854e                	mv	a0,s3
    800041b6:	ffffd097          	auipc	ra,0xffffd
    800041ba:	4aa080e7          	jalr	1194(ra) # 80001660 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041be:	2204a703          	lw	a4,544(s1)
    800041c2:	2244a783          	lw	a5,548(s1)
    800041c6:	fef700e3          	beq	a4,a5,800041a6 <piperead+0x3c>
    800041ca:	e85a                	sd	s6,16(sp)
    800041cc:	a819                	j	800041e2 <piperead+0x78>
    800041ce:	e85a                	sd	s6,16(sp)
    800041d0:	a809                	j	800041e2 <piperead+0x78>
      release(&pi->lock);
    800041d2:	8526                	mv	a0,s1
    800041d4:	00002097          	auipc	ra,0x2
    800041d8:	64e080e7          	jalr	1614(ra) # 80006822 <release>
      return -1;
    800041dc:	59fd                	li	s3,-1
    800041de:	a0a5                	j	80004246 <piperead+0xdc>
    800041e0:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041e4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e6:	05505463          	blez	s5,8000422e <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800041ea:	2204a783          	lw	a5,544(s1)
    800041ee:	2244a703          	lw	a4,548(s1)
    800041f2:	02f70e63          	beq	a4,a5,8000422e <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041f6:	0017871b          	addiw	a4,a5,1
    800041fa:	22e4a023          	sw	a4,544(s1)
    800041fe:	1ff7f793          	andi	a5,a5,511
    80004202:	97a6                	add	a5,a5,s1
    80004204:	0207c783          	lbu	a5,32(a5)
    80004208:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000420c:	4685                	li	a3,1
    8000420e:	fbf40613          	addi	a2,s0,-65
    80004212:	85ca                	mv	a1,s2
    80004214:	058a3503          	ld	a0,88(s4)
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	a1e080e7          	jalr	-1506(ra) # 80000c36 <copyout>
    80004220:	01650763          	beq	a0,s6,8000422e <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004224:	2985                	addiw	s3,s3,1
    80004226:	0905                	addi	s2,s2,1
    80004228:	fd3a91e3          	bne	s5,s3,800041ea <piperead+0x80>
    8000422c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000422e:	22448513          	addi	a0,s1,548
    80004232:	ffffd097          	auipc	ra,0xffffd
    80004236:	5ba080e7          	jalr	1466(ra) # 800017ec <wakeup>
  release(&pi->lock);
    8000423a:	8526                	mv	a0,s1
    8000423c:	00002097          	auipc	ra,0x2
    80004240:	5e6080e7          	jalr	1510(ra) # 80006822 <release>
    80004244:	6b42                	ld	s6,16(sp)
  return i;
}
    80004246:	854e                	mv	a0,s3
    80004248:	60a6                	ld	ra,72(sp)
    8000424a:	6406                	ld	s0,64(sp)
    8000424c:	74e2                	ld	s1,56(sp)
    8000424e:	7942                	ld	s2,48(sp)
    80004250:	79a2                	ld	s3,40(sp)
    80004252:	7a02                	ld	s4,32(sp)
    80004254:	6ae2                	ld	s5,24(sp)
    80004256:	6161                	addi	sp,sp,80
    80004258:	8082                	ret

000000008000425a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000425a:	df010113          	addi	sp,sp,-528
    8000425e:	20113423          	sd	ra,520(sp)
    80004262:	20813023          	sd	s0,512(sp)
    80004266:	ffa6                	sd	s1,504(sp)
    80004268:	fbca                	sd	s2,496(sp)
    8000426a:	0c00                	addi	s0,sp,528
    8000426c:	892a                	mv	s2,a0
    8000426e:	dea43c23          	sd	a0,-520(s0)
    80004272:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004276:	ffffd097          	auipc	ra,0xffffd
    8000427a:	d24080e7          	jalr	-732(ra) # 80000f9a <myproc>
    8000427e:	84aa                	mv	s1,a0

  begin_op();
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	456080e7          	jalr	1110(ra) # 800036d6 <begin_op>

  if((ip = namei(path)) == 0){
    80004288:	854a                	mv	a0,s2
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	24c080e7          	jalr	588(ra) # 800034d6 <namei>
    80004292:	c135                	beqz	a0,800042f6 <exec+0x9c>
    80004294:	f3d2                	sd	s4,480(sp)
    80004296:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	a6c080e7          	jalr	-1428(ra) # 80002d04 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042a0:	04000713          	li	a4,64
    800042a4:	4681                	li	a3,0
    800042a6:	e5040613          	addi	a2,s0,-432
    800042aa:	4581                	li	a1,0
    800042ac:	8552                	mv	a0,s4
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	d0e080e7          	jalr	-754(ra) # 80002fbc <readi>
    800042b6:	04000793          	li	a5,64
    800042ba:	00f51a63          	bne	a0,a5,800042ce <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042be:	e5042703          	lw	a4,-432(s0)
    800042c2:	464c47b7          	lui	a5,0x464c4
    800042c6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042ca:	02f70c63          	beq	a4,a5,80004302 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042ce:	8552                	mv	a0,s4
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	c9a080e7          	jalr	-870(ra) # 80002f6a <iunlockput>
    end_op();
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	478080e7          	jalr	1144(ra) # 80003750 <end_op>
  }
  return -1;
    800042e0:	557d                	li	a0,-1
    800042e2:	7a1e                	ld	s4,480(sp)
}
    800042e4:	20813083          	ld	ra,520(sp)
    800042e8:	20013403          	ld	s0,512(sp)
    800042ec:	74fe                	ld	s1,504(sp)
    800042ee:	795e                	ld	s2,496(sp)
    800042f0:	21010113          	addi	sp,sp,528
    800042f4:	8082                	ret
    end_op();
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	45a080e7          	jalr	1114(ra) # 80003750 <end_op>
    return -1;
    800042fe:	557d                	li	a0,-1
    80004300:	b7d5                	j	800042e4 <exec+0x8a>
    80004302:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004304:	8526                	mv	a0,s1
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	d58080e7          	jalr	-680(ra) # 8000105e <proc_pagetable>
    8000430e:	8b2a                	mv	s6,a0
    80004310:	30050563          	beqz	a0,8000461a <exec+0x3c0>
    80004314:	f7ce                	sd	s3,488(sp)
    80004316:	efd6                	sd	s5,472(sp)
    80004318:	e7de                	sd	s7,456(sp)
    8000431a:	e3e2                	sd	s8,448(sp)
    8000431c:	ff66                	sd	s9,440(sp)
    8000431e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004320:	e7042d03          	lw	s10,-400(s0)
    80004324:	e8845783          	lhu	a5,-376(s0)
    80004328:	14078563          	beqz	a5,80004472 <exec+0x218>
    8000432c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000432e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004330:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004332:	6c85                	lui	s9,0x1
    80004334:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004338:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000433c:	6a85                	lui	s5,0x1
    8000433e:	a0b5                	j	800043aa <exec+0x150>
      panic("loadseg: address should exist");
    80004340:	00004517          	auipc	a0,0x4
    80004344:	1f850513          	addi	a0,a0,504 # 80008538 <etext+0x538>
    80004348:	00002097          	auipc	ra,0x2
    8000434c:	eae080e7          	jalr	-338(ra) # 800061f6 <panic>
    if(sz - i < PGSIZE)
    80004350:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004352:	8726                	mv	a4,s1
    80004354:	012c06bb          	addw	a3,s8,s2
    80004358:	4581                	li	a1,0
    8000435a:	8552                	mv	a0,s4
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	c60080e7          	jalr	-928(ra) # 80002fbc <readi>
    80004364:	2501                	sext.w	a0,a0
    80004366:	26a49e63          	bne	s1,a0,800045e2 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000436a:	012a893b          	addw	s2,s5,s2
    8000436e:	03397563          	bgeu	s2,s3,80004398 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004372:	02091593          	slli	a1,s2,0x20
    80004376:	9181                	srli	a1,a1,0x20
    80004378:	95de                	add	a1,a1,s7
    8000437a:	855a                	mv	a0,s6
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	29a080e7          	jalr	666(ra) # 80000616 <walkaddr>
    80004384:	862a                	mv	a2,a0
    if(pa == 0)
    80004386:	dd4d                	beqz	a0,80004340 <exec+0xe6>
    if(sz - i < PGSIZE)
    80004388:	412984bb          	subw	s1,s3,s2
    8000438c:	0004879b          	sext.w	a5,s1
    80004390:	fcfcf0e3          	bgeu	s9,a5,80004350 <exec+0xf6>
    80004394:	84d6                	mv	s1,s5
    80004396:	bf6d                	j	80004350 <exec+0xf6>
    sz = sz1;
    80004398:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000439c:	2d85                	addiw	s11,s11,1
    8000439e:	038d0d1b          	addiw	s10,s10,56
    800043a2:	e8845783          	lhu	a5,-376(s0)
    800043a6:	06fddf63          	bge	s11,a5,80004424 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043aa:	2d01                	sext.w	s10,s10
    800043ac:	03800713          	li	a4,56
    800043b0:	86ea                	mv	a3,s10
    800043b2:	e1840613          	addi	a2,s0,-488
    800043b6:	4581                	li	a1,0
    800043b8:	8552                	mv	a0,s4
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	c02080e7          	jalr	-1022(ra) # 80002fbc <readi>
    800043c2:	03800793          	li	a5,56
    800043c6:	1ef51863          	bne	a0,a5,800045b6 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800043ca:	e1842783          	lw	a5,-488(s0)
    800043ce:	4705                	li	a4,1
    800043d0:	fce796e3          	bne	a5,a4,8000439c <exec+0x142>
    if(ph.memsz < ph.filesz)
    800043d4:	e4043603          	ld	a2,-448(s0)
    800043d8:	e3843783          	ld	a5,-456(s0)
    800043dc:	1ef66163          	bltu	a2,a5,800045be <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043e0:	e2843783          	ld	a5,-472(s0)
    800043e4:	963e                	add	a2,a2,a5
    800043e6:	1ef66063          	bltu	a2,a5,800045c6 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043ea:	85a6                	mv	a1,s1
    800043ec:	855a                	mv	a0,s6
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	5ec080e7          	jalr	1516(ra) # 800009da <uvmalloc>
    800043f6:	e0a43423          	sd	a0,-504(s0)
    800043fa:	1c050a63          	beqz	a0,800045ce <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    800043fe:	e2843b83          	ld	s7,-472(s0)
    80004402:	df043783          	ld	a5,-528(s0)
    80004406:	00fbf7b3          	and	a5,s7,a5
    8000440a:	1c079a63          	bnez	a5,800045de <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000440e:	e2042c03          	lw	s8,-480(s0)
    80004412:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004416:	00098463          	beqz	s3,8000441e <exec+0x1c4>
    8000441a:	4901                	li	s2,0
    8000441c:	bf99                	j	80004372 <exec+0x118>
    sz = sz1;
    8000441e:	e0843483          	ld	s1,-504(s0)
    80004422:	bfad                	j	8000439c <exec+0x142>
    80004424:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004426:	8552                	mv	a0,s4
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	b42080e7          	jalr	-1214(ra) # 80002f6a <iunlockput>
  end_op();
    80004430:	fffff097          	auipc	ra,0xfffff
    80004434:	320080e7          	jalr	800(ra) # 80003750 <end_op>
  p = myproc();
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	b62080e7          	jalr	-1182(ra) # 80000f9a <myproc>
    80004440:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004442:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004446:	6985                	lui	s3,0x1
    80004448:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000444a:	99a6                	add	s3,s3,s1
    8000444c:	77fd                	lui	a5,0xfffff
    8000444e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004452:	6609                	lui	a2,0x2
    80004454:	964e                	add	a2,a2,s3
    80004456:	85ce                	mv	a1,s3
    80004458:	855a                	mv	a0,s6
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	580080e7          	jalr	1408(ra) # 800009da <uvmalloc>
    80004462:	892a                	mv	s2,a0
    80004464:	e0a43423          	sd	a0,-504(s0)
    80004468:	e519                	bnez	a0,80004476 <exec+0x21c>
  if(pagetable)
    8000446a:	e1343423          	sd	s3,-504(s0)
    8000446e:	4a01                	li	s4,0
    80004470:	aa95                	j	800045e4 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004472:	4481                	li	s1,0
    80004474:	bf4d                	j	80004426 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004476:	75f9                	lui	a1,0xffffe
    80004478:	95aa                	add	a1,a1,a0
    8000447a:	855a                	mv	a0,s6
    8000447c:	ffffc097          	auipc	ra,0xffffc
    80004480:	788080e7          	jalr	1928(ra) # 80000c04 <uvmclear>
  stackbase = sp - PGSIZE;
    80004484:	7bfd                	lui	s7,0xfffff
    80004486:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004488:	e0043783          	ld	a5,-512(s0)
    8000448c:	6388                	ld	a0,0(a5)
    8000448e:	c52d                	beqz	a0,800044f8 <exec+0x29e>
    80004490:	e9040993          	addi	s3,s0,-368
    80004494:	f9040c13          	addi	s8,s0,-112
    80004498:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000449a:	ffffc097          	auipc	ra,0xffffc
    8000449e:	f62080e7          	jalr	-158(ra) # 800003fc <strlen>
    800044a2:	0015079b          	addiw	a5,a0,1
    800044a6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044aa:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044ae:	13796463          	bltu	s2,s7,800045d6 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044b2:	e0043d03          	ld	s10,-512(s0)
    800044b6:	000d3a03          	ld	s4,0(s10)
    800044ba:	8552                	mv	a0,s4
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	f40080e7          	jalr	-192(ra) # 800003fc <strlen>
    800044c4:	0015069b          	addiw	a3,a0,1
    800044c8:	8652                	mv	a2,s4
    800044ca:	85ca                	mv	a1,s2
    800044cc:	855a                	mv	a0,s6
    800044ce:	ffffc097          	auipc	ra,0xffffc
    800044d2:	768080e7          	jalr	1896(ra) # 80000c36 <copyout>
    800044d6:	10054263          	bltz	a0,800045da <exec+0x380>
    ustack[argc] = sp;
    800044da:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044de:	0485                	addi	s1,s1,1
    800044e0:	008d0793          	addi	a5,s10,8
    800044e4:	e0f43023          	sd	a5,-512(s0)
    800044e8:	008d3503          	ld	a0,8(s10)
    800044ec:	c909                	beqz	a0,800044fe <exec+0x2a4>
    if(argc >= MAXARG)
    800044ee:	09a1                	addi	s3,s3,8
    800044f0:	fb8995e3          	bne	s3,s8,8000449a <exec+0x240>
  ip = 0;
    800044f4:	4a01                	li	s4,0
    800044f6:	a0fd                	j	800045e4 <exec+0x38a>
  sp = sz;
    800044f8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800044fc:	4481                	li	s1,0
  ustack[argc] = 0;
    800044fe:	00349793          	slli	a5,s1,0x3
    80004502:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd0d48>
    80004506:	97a2                	add	a5,a5,s0
    80004508:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000450c:	00148693          	addi	a3,s1,1
    80004510:	068e                	slli	a3,a3,0x3
    80004512:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004516:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000451a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000451e:	f57966e3          	bltu	s2,s7,8000446a <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004522:	e9040613          	addi	a2,s0,-368
    80004526:	85ca                	mv	a1,s2
    80004528:	855a                	mv	a0,s6
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	70c080e7          	jalr	1804(ra) # 80000c36 <copyout>
    80004532:	0e054663          	bltz	a0,8000461e <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004536:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    8000453a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000453e:	df843783          	ld	a5,-520(s0)
    80004542:	0007c703          	lbu	a4,0(a5)
    80004546:	cf11                	beqz	a4,80004562 <exec+0x308>
    80004548:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000454a:	02f00693          	li	a3,47
    8000454e:	a039                	j	8000455c <exec+0x302>
      last = s+1;
    80004550:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004554:	0785                	addi	a5,a5,1
    80004556:	fff7c703          	lbu	a4,-1(a5)
    8000455a:	c701                	beqz	a4,80004562 <exec+0x308>
    if(*s == '/')
    8000455c:	fed71ce3          	bne	a4,a3,80004554 <exec+0x2fa>
    80004560:	bfc5                	j	80004550 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004562:	4641                	li	a2,16
    80004564:	df843583          	ld	a1,-520(s0)
    80004568:	160a8513          	addi	a0,s5,352
    8000456c:	ffffc097          	auipc	ra,0xffffc
    80004570:	e5e080e7          	jalr	-418(ra) # 800003ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004574:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004578:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    8000457c:	e0843783          	ld	a5,-504(s0)
    80004580:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004584:	060ab783          	ld	a5,96(s5)
    80004588:	e6843703          	ld	a4,-408(s0)
    8000458c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000458e:	060ab783          	ld	a5,96(s5)
    80004592:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004596:	85e6                	mv	a1,s9
    80004598:	ffffd097          	auipc	ra,0xffffd
    8000459c:	b62080e7          	jalr	-1182(ra) # 800010fa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045a0:	0004851b          	sext.w	a0,s1
    800045a4:	79be                	ld	s3,488(sp)
    800045a6:	7a1e                	ld	s4,480(sp)
    800045a8:	6afe                	ld	s5,472(sp)
    800045aa:	6b5e                	ld	s6,464(sp)
    800045ac:	6bbe                	ld	s7,456(sp)
    800045ae:	6c1e                	ld	s8,448(sp)
    800045b0:	7cfa                	ld	s9,440(sp)
    800045b2:	7d5a                	ld	s10,432(sp)
    800045b4:	bb05                	j	800042e4 <exec+0x8a>
    800045b6:	e0943423          	sd	s1,-504(s0)
    800045ba:	7dba                	ld	s11,424(sp)
    800045bc:	a025                	j	800045e4 <exec+0x38a>
    800045be:	e0943423          	sd	s1,-504(s0)
    800045c2:	7dba                	ld	s11,424(sp)
    800045c4:	a005                	j	800045e4 <exec+0x38a>
    800045c6:	e0943423          	sd	s1,-504(s0)
    800045ca:	7dba                	ld	s11,424(sp)
    800045cc:	a821                	j	800045e4 <exec+0x38a>
    800045ce:	e0943423          	sd	s1,-504(s0)
    800045d2:	7dba                	ld	s11,424(sp)
    800045d4:	a801                	j	800045e4 <exec+0x38a>
  ip = 0;
    800045d6:	4a01                	li	s4,0
    800045d8:	a031                	j	800045e4 <exec+0x38a>
    800045da:	4a01                	li	s4,0
  if(pagetable)
    800045dc:	a021                	j	800045e4 <exec+0x38a>
    800045de:	7dba                	ld	s11,424(sp)
    800045e0:	a011                	j	800045e4 <exec+0x38a>
    800045e2:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800045e4:	e0843583          	ld	a1,-504(s0)
    800045e8:	855a                	mv	a0,s6
    800045ea:	ffffd097          	auipc	ra,0xffffd
    800045ee:	b10080e7          	jalr	-1264(ra) # 800010fa <proc_freepagetable>
  return -1;
    800045f2:	557d                	li	a0,-1
  if(ip){
    800045f4:	000a1b63          	bnez	s4,8000460a <exec+0x3b0>
    800045f8:	79be                	ld	s3,488(sp)
    800045fa:	7a1e                	ld	s4,480(sp)
    800045fc:	6afe                	ld	s5,472(sp)
    800045fe:	6b5e                	ld	s6,464(sp)
    80004600:	6bbe                	ld	s7,456(sp)
    80004602:	6c1e                	ld	s8,448(sp)
    80004604:	7cfa                	ld	s9,440(sp)
    80004606:	7d5a                	ld	s10,432(sp)
    80004608:	b9f1                	j	800042e4 <exec+0x8a>
    8000460a:	79be                	ld	s3,488(sp)
    8000460c:	6afe                	ld	s5,472(sp)
    8000460e:	6b5e                	ld	s6,464(sp)
    80004610:	6bbe                	ld	s7,456(sp)
    80004612:	6c1e                	ld	s8,448(sp)
    80004614:	7cfa                	ld	s9,440(sp)
    80004616:	7d5a                	ld	s10,432(sp)
    80004618:	b95d                	j	800042ce <exec+0x74>
    8000461a:	6b5e                	ld	s6,464(sp)
    8000461c:	b94d                	j	800042ce <exec+0x74>
  sz = sz1;
    8000461e:	e0843983          	ld	s3,-504(s0)
    80004622:	b5a1                	j	8000446a <exec+0x210>

0000000080004624 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004624:	7179                	addi	sp,sp,-48
    80004626:	f406                	sd	ra,40(sp)
    80004628:	f022                	sd	s0,32(sp)
    8000462a:	ec26                	sd	s1,24(sp)
    8000462c:	e84a                	sd	s2,16(sp)
    8000462e:	1800                	addi	s0,sp,48
    80004630:	892e                	mv	s2,a1
    80004632:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004634:	fdc40593          	addi	a1,s0,-36
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	a22080e7          	jalr	-1502(ra) # 8000205a <argint>
    80004640:	04054063          	bltz	a0,80004680 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004644:	fdc42703          	lw	a4,-36(s0)
    80004648:	47bd                	li	a5,15
    8000464a:	02e7ed63          	bltu	a5,a4,80004684 <argfd+0x60>
    8000464e:	ffffd097          	auipc	ra,0xffffd
    80004652:	94c080e7          	jalr	-1716(ra) # 80000f9a <myproc>
    80004656:	fdc42703          	lw	a4,-36(s0)
    8000465a:	01a70793          	addi	a5,a4,26
    8000465e:	078e                	slli	a5,a5,0x3
    80004660:	953e                	add	a0,a0,a5
    80004662:	651c                	ld	a5,8(a0)
    80004664:	c395                	beqz	a5,80004688 <argfd+0x64>
    return -1;
  if(pfd)
    80004666:	00090463          	beqz	s2,8000466e <argfd+0x4a>
    *pfd = fd;
    8000466a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000466e:	4501                	li	a0,0
  if(pf)
    80004670:	c091                	beqz	s1,80004674 <argfd+0x50>
    *pf = f;
    80004672:	e09c                	sd	a5,0(s1)
}
    80004674:	70a2                	ld	ra,40(sp)
    80004676:	7402                	ld	s0,32(sp)
    80004678:	64e2                	ld	s1,24(sp)
    8000467a:	6942                	ld	s2,16(sp)
    8000467c:	6145                	addi	sp,sp,48
    8000467e:	8082                	ret
    return -1;
    80004680:	557d                	li	a0,-1
    80004682:	bfcd                	j	80004674 <argfd+0x50>
    return -1;
    80004684:	557d                	li	a0,-1
    80004686:	b7fd                	j	80004674 <argfd+0x50>
    80004688:	557d                	li	a0,-1
    8000468a:	b7ed                	j	80004674 <argfd+0x50>

000000008000468c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000468c:	1101                	addi	sp,sp,-32
    8000468e:	ec06                	sd	ra,24(sp)
    80004690:	e822                	sd	s0,16(sp)
    80004692:	e426                	sd	s1,8(sp)
    80004694:	1000                	addi	s0,sp,32
    80004696:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004698:	ffffd097          	auipc	ra,0xffffd
    8000469c:	902080e7          	jalr	-1790(ra) # 80000f9a <myproc>
    800046a0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046a2:	0d850793          	addi	a5,a0,216
    800046a6:	4501                	li	a0,0
    800046a8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046aa:	6398                	ld	a4,0(a5)
    800046ac:	cb19                	beqz	a4,800046c2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046ae:	2505                	addiw	a0,a0,1
    800046b0:	07a1                	addi	a5,a5,8
    800046b2:	fed51ce3          	bne	a0,a3,800046aa <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046b6:	557d                	li	a0,-1
}
    800046b8:	60e2                	ld	ra,24(sp)
    800046ba:	6442                	ld	s0,16(sp)
    800046bc:	64a2                	ld	s1,8(sp)
    800046be:	6105                	addi	sp,sp,32
    800046c0:	8082                	ret
      p->ofile[fd] = f;
    800046c2:	01a50793          	addi	a5,a0,26
    800046c6:	078e                	slli	a5,a5,0x3
    800046c8:	963e                	add	a2,a2,a5
    800046ca:	e604                	sd	s1,8(a2)
      return fd;
    800046cc:	b7f5                	j	800046b8 <fdalloc+0x2c>

00000000800046ce <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046ce:	715d                	addi	sp,sp,-80
    800046d0:	e486                	sd	ra,72(sp)
    800046d2:	e0a2                	sd	s0,64(sp)
    800046d4:	fc26                	sd	s1,56(sp)
    800046d6:	f84a                	sd	s2,48(sp)
    800046d8:	f44e                	sd	s3,40(sp)
    800046da:	f052                	sd	s4,32(sp)
    800046dc:	ec56                	sd	s5,24(sp)
    800046de:	0880                	addi	s0,sp,80
    800046e0:	8aae                	mv	s5,a1
    800046e2:	8a32                	mv	s4,a2
    800046e4:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046e6:	fb040593          	addi	a1,s0,-80
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	e0a080e7          	jalr	-502(ra) # 800034f4 <nameiparent>
    800046f2:	892a                	mv	s2,a0
    800046f4:	12050c63          	beqz	a0,8000482c <create+0x15e>
    return 0;

  ilock(dp);
    800046f8:	ffffe097          	auipc	ra,0xffffe
    800046fc:	60c080e7          	jalr	1548(ra) # 80002d04 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004700:	4601                	li	a2,0
    80004702:	fb040593          	addi	a1,s0,-80
    80004706:	854a                	mv	a0,s2
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	afc080e7          	jalr	-1284(ra) # 80003204 <dirlookup>
    80004710:	84aa                	mv	s1,a0
    80004712:	c539                	beqz	a0,80004760 <create+0x92>
    iunlockput(dp);
    80004714:	854a                	mv	a0,s2
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	854080e7          	jalr	-1964(ra) # 80002f6a <iunlockput>
    ilock(ip);
    8000471e:	8526                	mv	a0,s1
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	5e4080e7          	jalr	1508(ra) # 80002d04 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004728:	4789                	li	a5,2
    8000472a:	02fa9463          	bne	s5,a5,80004752 <create+0x84>
    8000472e:	04c4d783          	lhu	a5,76(s1)
    80004732:	37f9                	addiw	a5,a5,-2
    80004734:	17c2                	slli	a5,a5,0x30
    80004736:	93c1                	srli	a5,a5,0x30
    80004738:	4705                	li	a4,1
    8000473a:	00f76c63          	bltu	a4,a5,80004752 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000473e:	8526                	mv	a0,s1
    80004740:	60a6                	ld	ra,72(sp)
    80004742:	6406                	ld	s0,64(sp)
    80004744:	74e2                	ld	s1,56(sp)
    80004746:	7942                	ld	s2,48(sp)
    80004748:	79a2                	ld	s3,40(sp)
    8000474a:	7a02                	ld	s4,32(sp)
    8000474c:	6ae2                	ld	s5,24(sp)
    8000474e:	6161                	addi	sp,sp,80
    80004750:	8082                	ret
    iunlockput(ip);
    80004752:	8526                	mv	a0,s1
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	816080e7          	jalr	-2026(ra) # 80002f6a <iunlockput>
    return 0;
    8000475c:	4481                	li	s1,0
    8000475e:	b7c5                	j	8000473e <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004760:	85d6                	mv	a1,s5
    80004762:	00092503          	lw	a0,0(s2)
    80004766:	ffffe097          	auipc	ra,0xffffe
    8000476a:	40a080e7          	jalr	1034(ra) # 80002b70 <ialloc>
    8000476e:	84aa                	mv	s1,a0
    80004770:	c139                	beqz	a0,800047b6 <create+0xe8>
  ilock(ip);
    80004772:	ffffe097          	auipc	ra,0xffffe
    80004776:	592080e7          	jalr	1426(ra) # 80002d04 <ilock>
  ip->major = major;
    8000477a:	05449723          	sh	s4,78(s1)
  ip->minor = minor;
    8000477e:	05349823          	sh	s3,80(s1)
  ip->nlink = 1;
    80004782:	4985                	li	s3,1
    80004784:	05349923          	sh	s3,82(s1)
  iupdate(ip);
    80004788:	8526                	mv	a0,s1
    8000478a:	ffffe097          	auipc	ra,0xffffe
    8000478e:	4ae080e7          	jalr	1198(ra) # 80002c38 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004792:	033a8a63          	beq	s5,s3,800047c6 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004796:	40d0                	lw	a2,4(s1)
    80004798:	fb040593          	addi	a1,s0,-80
    8000479c:	854a                	mv	a0,s2
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	c76080e7          	jalr	-906(ra) # 80003414 <dirlink>
    800047a6:	06054b63          	bltz	a0,8000481c <create+0x14e>
  iunlockput(dp);
    800047aa:	854a                	mv	a0,s2
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	7be080e7          	jalr	1982(ra) # 80002f6a <iunlockput>
  return ip;
    800047b4:	b769                	j	8000473e <create+0x70>
    panic("create: ialloc");
    800047b6:	00004517          	auipc	a0,0x4
    800047ba:	da250513          	addi	a0,a0,-606 # 80008558 <etext+0x558>
    800047be:	00002097          	auipc	ra,0x2
    800047c2:	a38080e7          	jalr	-1480(ra) # 800061f6 <panic>
    dp->nlink++;  // for ".."
    800047c6:	05295783          	lhu	a5,82(s2)
    800047ca:	2785                	addiw	a5,a5,1
    800047cc:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    800047d0:	854a                	mv	a0,s2
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	466080e7          	jalr	1126(ra) # 80002c38 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047da:	40d0                	lw	a2,4(s1)
    800047dc:	00004597          	auipc	a1,0x4
    800047e0:	d8c58593          	addi	a1,a1,-628 # 80008568 <etext+0x568>
    800047e4:	8526                	mv	a0,s1
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	c2e080e7          	jalr	-978(ra) # 80003414 <dirlink>
    800047ee:	00054f63          	bltz	a0,8000480c <create+0x13e>
    800047f2:	00492603          	lw	a2,4(s2)
    800047f6:	00004597          	auipc	a1,0x4
    800047fa:	d7a58593          	addi	a1,a1,-646 # 80008570 <etext+0x570>
    800047fe:	8526                	mv	a0,s1
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	c14080e7          	jalr	-1004(ra) # 80003414 <dirlink>
    80004808:	f80557e3          	bgez	a0,80004796 <create+0xc8>
      panic("create dots");
    8000480c:	00004517          	auipc	a0,0x4
    80004810:	d6c50513          	addi	a0,a0,-660 # 80008578 <etext+0x578>
    80004814:	00002097          	auipc	ra,0x2
    80004818:	9e2080e7          	jalr	-1566(ra) # 800061f6 <panic>
    panic("create: dirlink");
    8000481c:	00004517          	auipc	a0,0x4
    80004820:	d6c50513          	addi	a0,a0,-660 # 80008588 <etext+0x588>
    80004824:	00002097          	auipc	ra,0x2
    80004828:	9d2080e7          	jalr	-1582(ra) # 800061f6 <panic>
    return 0;
    8000482c:	84aa                	mv	s1,a0
    8000482e:	bf01                	j	8000473e <create+0x70>

0000000080004830 <sys_dup>:
{
    80004830:	7179                	addi	sp,sp,-48
    80004832:	f406                	sd	ra,40(sp)
    80004834:	f022                	sd	s0,32(sp)
    80004836:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004838:	fd840613          	addi	a2,s0,-40
    8000483c:	4581                	li	a1,0
    8000483e:	4501                	li	a0,0
    80004840:	00000097          	auipc	ra,0x0
    80004844:	de4080e7          	jalr	-540(ra) # 80004624 <argfd>
    return -1;
    80004848:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000484a:	02054763          	bltz	a0,80004878 <sys_dup+0x48>
    8000484e:	ec26                	sd	s1,24(sp)
    80004850:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004852:	fd843903          	ld	s2,-40(s0)
    80004856:	854a                	mv	a0,s2
    80004858:	00000097          	auipc	ra,0x0
    8000485c:	e34080e7          	jalr	-460(ra) # 8000468c <fdalloc>
    80004860:	84aa                	mv	s1,a0
    return -1;
    80004862:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004864:	00054f63          	bltz	a0,80004882 <sys_dup+0x52>
  filedup(f);
    80004868:	854a                	mv	a0,s2
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	2e4080e7          	jalr	740(ra) # 80003b4e <filedup>
  return fd;
    80004872:	87a6                	mv	a5,s1
    80004874:	64e2                	ld	s1,24(sp)
    80004876:	6942                	ld	s2,16(sp)
}
    80004878:	853e                	mv	a0,a5
    8000487a:	70a2                	ld	ra,40(sp)
    8000487c:	7402                	ld	s0,32(sp)
    8000487e:	6145                	addi	sp,sp,48
    80004880:	8082                	ret
    80004882:	64e2                	ld	s1,24(sp)
    80004884:	6942                	ld	s2,16(sp)
    80004886:	bfcd                	j	80004878 <sys_dup+0x48>

0000000080004888 <sys_read>:
{
    80004888:	7179                	addi	sp,sp,-48
    8000488a:	f406                	sd	ra,40(sp)
    8000488c:	f022                	sd	s0,32(sp)
    8000488e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004890:	fe840613          	addi	a2,s0,-24
    80004894:	4581                	li	a1,0
    80004896:	4501                	li	a0,0
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	d8c080e7          	jalr	-628(ra) # 80004624 <argfd>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a2:	04054163          	bltz	a0,800048e4 <sys_read+0x5c>
    800048a6:	fe440593          	addi	a1,s0,-28
    800048aa:	4509                	li	a0,2
    800048ac:	ffffd097          	auipc	ra,0xffffd
    800048b0:	7ae080e7          	jalr	1966(ra) # 8000205a <argint>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b6:	02054763          	bltz	a0,800048e4 <sys_read+0x5c>
    800048ba:	fd840593          	addi	a1,s0,-40
    800048be:	4505                	li	a0,1
    800048c0:	ffffd097          	auipc	ra,0xffffd
    800048c4:	7bc080e7          	jalr	1980(ra) # 8000207c <argaddr>
    return -1;
    800048c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ca:	00054d63          	bltz	a0,800048e4 <sys_read+0x5c>
  return fileread(f, p, n);
    800048ce:	fe442603          	lw	a2,-28(s0)
    800048d2:	fd843583          	ld	a1,-40(s0)
    800048d6:	fe843503          	ld	a0,-24(s0)
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	41a080e7          	jalr	1050(ra) # 80003cf4 <fileread>
    800048e2:	87aa                	mv	a5,a0
}
    800048e4:	853e                	mv	a0,a5
    800048e6:	70a2                	ld	ra,40(sp)
    800048e8:	7402                	ld	s0,32(sp)
    800048ea:	6145                	addi	sp,sp,48
    800048ec:	8082                	ret

00000000800048ee <sys_write>:
{
    800048ee:	7179                	addi	sp,sp,-48
    800048f0:	f406                	sd	ra,40(sp)
    800048f2:	f022                	sd	s0,32(sp)
    800048f4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f6:	fe840613          	addi	a2,s0,-24
    800048fa:	4581                	li	a1,0
    800048fc:	4501                	li	a0,0
    800048fe:	00000097          	auipc	ra,0x0
    80004902:	d26080e7          	jalr	-730(ra) # 80004624 <argfd>
    return -1;
    80004906:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004908:	04054163          	bltz	a0,8000494a <sys_write+0x5c>
    8000490c:	fe440593          	addi	a1,s0,-28
    80004910:	4509                	li	a0,2
    80004912:	ffffd097          	auipc	ra,0xffffd
    80004916:	748080e7          	jalr	1864(ra) # 8000205a <argint>
    return -1;
    8000491a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000491c:	02054763          	bltz	a0,8000494a <sys_write+0x5c>
    80004920:	fd840593          	addi	a1,s0,-40
    80004924:	4505                	li	a0,1
    80004926:	ffffd097          	auipc	ra,0xffffd
    8000492a:	756080e7          	jalr	1878(ra) # 8000207c <argaddr>
    return -1;
    8000492e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004930:	00054d63          	bltz	a0,8000494a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004934:	fe442603          	lw	a2,-28(s0)
    80004938:	fd843583          	ld	a1,-40(s0)
    8000493c:	fe843503          	ld	a0,-24(s0)
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	486080e7          	jalr	1158(ra) # 80003dc6 <filewrite>
    80004948:	87aa                	mv	a5,a0
}
    8000494a:	853e                	mv	a0,a5
    8000494c:	70a2                	ld	ra,40(sp)
    8000494e:	7402                	ld	s0,32(sp)
    80004950:	6145                	addi	sp,sp,48
    80004952:	8082                	ret

0000000080004954 <sys_close>:
{
    80004954:	1101                	addi	sp,sp,-32
    80004956:	ec06                	sd	ra,24(sp)
    80004958:	e822                	sd	s0,16(sp)
    8000495a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000495c:	fe040613          	addi	a2,s0,-32
    80004960:	fec40593          	addi	a1,s0,-20
    80004964:	4501                	li	a0,0
    80004966:	00000097          	auipc	ra,0x0
    8000496a:	cbe080e7          	jalr	-834(ra) # 80004624 <argfd>
    return -1;
    8000496e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004970:	02054463          	bltz	a0,80004998 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004974:	ffffc097          	auipc	ra,0xffffc
    80004978:	626080e7          	jalr	1574(ra) # 80000f9a <myproc>
    8000497c:	fec42783          	lw	a5,-20(s0)
    80004980:	07e9                	addi	a5,a5,26
    80004982:	078e                	slli	a5,a5,0x3
    80004984:	953e                	add	a0,a0,a5
    80004986:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000498a:	fe043503          	ld	a0,-32(s0)
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	212080e7          	jalr	530(ra) # 80003ba0 <fileclose>
  return 0;
    80004996:	4781                	li	a5,0
}
    80004998:	853e                	mv	a0,a5
    8000499a:	60e2                	ld	ra,24(sp)
    8000499c:	6442                	ld	s0,16(sp)
    8000499e:	6105                	addi	sp,sp,32
    800049a0:	8082                	ret

00000000800049a2 <sys_fstat>:
{
    800049a2:	1101                	addi	sp,sp,-32
    800049a4:	ec06                	sd	ra,24(sp)
    800049a6:	e822                	sd	s0,16(sp)
    800049a8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049aa:	fe840613          	addi	a2,s0,-24
    800049ae:	4581                	li	a1,0
    800049b0:	4501                	li	a0,0
    800049b2:	00000097          	auipc	ra,0x0
    800049b6:	c72080e7          	jalr	-910(ra) # 80004624 <argfd>
    return -1;
    800049ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049bc:	02054563          	bltz	a0,800049e6 <sys_fstat+0x44>
    800049c0:	fe040593          	addi	a1,s0,-32
    800049c4:	4505                	li	a0,1
    800049c6:	ffffd097          	auipc	ra,0xffffd
    800049ca:	6b6080e7          	jalr	1718(ra) # 8000207c <argaddr>
    return -1;
    800049ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049d0:	00054b63          	bltz	a0,800049e6 <sys_fstat+0x44>
  return filestat(f, st);
    800049d4:	fe043583          	ld	a1,-32(s0)
    800049d8:	fe843503          	ld	a0,-24(s0)
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	2a6080e7          	jalr	678(ra) # 80003c82 <filestat>
    800049e4:	87aa                	mv	a5,a0
}
    800049e6:	853e                	mv	a0,a5
    800049e8:	60e2                	ld	ra,24(sp)
    800049ea:	6442                	ld	s0,16(sp)
    800049ec:	6105                	addi	sp,sp,32
    800049ee:	8082                	ret

00000000800049f0 <sys_link>:
{
    800049f0:	7169                	addi	sp,sp,-304
    800049f2:	f606                	sd	ra,296(sp)
    800049f4:	f222                	sd	s0,288(sp)
    800049f6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049f8:	08000613          	li	a2,128
    800049fc:	ed040593          	addi	a1,s0,-304
    80004a00:	4501                	li	a0,0
    80004a02:	ffffd097          	auipc	ra,0xffffd
    80004a06:	69c080e7          	jalr	1692(ra) # 8000209e <argstr>
    return -1;
    80004a0a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a0c:	12054663          	bltz	a0,80004b38 <sys_link+0x148>
    80004a10:	08000613          	li	a2,128
    80004a14:	f5040593          	addi	a1,s0,-176
    80004a18:	4505                	li	a0,1
    80004a1a:	ffffd097          	auipc	ra,0xffffd
    80004a1e:	684080e7          	jalr	1668(ra) # 8000209e <argstr>
    return -1;
    80004a22:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a24:	10054a63          	bltz	a0,80004b38 <sys_link+0x148>
    80004a28:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	cac080e7          	jalr	-852(ra) # 800036d6 <begin_op>
  if((ip = namei(old)) == 0){
    80004a32:	ed040513          	addi	a0,s0,-304
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	aa0080e7          	jalr	-1376(ra) # 800034d6 <namei>
    80004a3e:	84aa                	mv	s1,a0
    80004a40:	c949                	beqz	a0,80004ad2 <sys_link+0xe2>
  ilock(ip);
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	2c2080e7          	jalr	706(ra) # 80002d04 <ilock>
  if(ip->type == T_DIR){
    80004a4a:	04c49703          	lh	a4,76(s1)
    80004a4e:	4785                	li	a5,1
    80004a50:	08f70863          	beq	a4,a5,80004ae0 <sys_link+0xf0>
    80004a54:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a56:	0524d783          	lhu	a5,82(s1)
    80004a5a:	2785                	addiw	a5,a5,1
    80004a5c:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	1d6080e7          	jalr	470(ra) # 80002c38 <iupdate>
  iunlock(ip);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	35e080e7          	jalr	862(ra) # 80002dca <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a74:	fd040593          	addi	a1,s0,-48
    80004a78:	f5040513          	addi	a0,s0,-176
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	a78080e7          	jalr	-1416(ra) # 800034f4 <nameiparent>
    80004a84:	892a                	mv	s2,a0
    80004a86:	cd35                	beqz	a0,80004b02 <sys_link+0x112>
  ilock(dp);
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	27c080e7          	jalr	636(ra) # 80002d04 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a90:	00092703          	lw	a4,0(s2)
    80004a94:	409c                	lw	a5,0(s1)
    80004a96:	06f71163          	bne	a4,a5,80004af8 <sys_link+0x108>
    80004a9a:	40d0                	lw	a2,4(s1)
    80004a9c:	fd040593          	addi	a1,s0,-48
    80004aa0:	854a                	mv	a0,s2
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	972080e7          	jalr	-1678(ra) # 80003414 <dirlink>
    80004aaa:	04054763          	bltz	a0,80004af8 <sys_link+0x108>
  iunlockput(dp);
    80004aae:	854a                	mv	a0,s2
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	4ba080e7          	jalr	1210(ra) # 80002f6a <iunlockput>
  iput(ip);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	408080e7          	jalr	1032(ra) # 80002ec2 <iput>
  end_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	c8e080e7          	jalr	-882(ra) # 80003750 <end_op>
  return 0;
    80004aca:	4781                	li	a5,0
    80004acc:	64f2                	ld	s1,280(sp)
    80004ace:	6952                	ld	s2,272(sp)
    80004ad0:	a0a5                	j	80004b38 <sys_link+0x148>
    end_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	c7e080e7          	jalr	-898(ra) # 80003750 <end_op>
    return -1;
    80004ada:	57fd                	li	a5,-1
    80004adc:	64f2                	ld	s1,280(sp)
    80004ade:	a8a9                	j	80004b38 <sys_link+0x148>
    iunlockput(ip);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	488080e7          	jalr	1160(ra) # 80002f6a <iunlockput>
    end_op();
    80004aea:	fffff097          	auipc	ra,0xfffff
    80004aee:	c66080e7          	jalr	-922(ra) # 80003750 <end_op>
    return -1;
    80004af2:	57fd                	li	a5,-1
    80004af4:	64f2                	ld	s1,280(sp)
    80004af6:	a089                	j	80004b38 <sys_link+0x148>
    iunlockput(dp);
    80004af8:	854a                	mv	a0,s2
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	470080e7          	jalr	1136(ra) # 80002f6a <iunlockput>
  ilock(ip);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	200080e7          	jalr	512(ra) # 80002d04 <ilock>
  ip->nlink--;
    80004b0c:	0524d783          	lhu	a5,82(s1)
    80004b10:	37fd                	addiw	a5,a5,-1
    80004b12:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	120080e7          	jalr	288(ra) # 80002c38 <iupdate>
  iunlockput(ip);
    80004b20:	8526                	mv	a0,s1
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	448080e7          	jalr	1096(ra) # 80002f6a <iunlockput>
  end_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	c26080e7          	jalr	-986(ra) # 80003750 <end_op>
  return -1;
    80004b32:	57fd                	li	a5,-1
    80004b34:	64f2                	ld	s1,280(sp)
    80004b36:	6952                	ld	s2,272(sp)
}
    80004b38:	853e                	mv	a0,a5
    80004b3a:	70b2                	ld	ra,296(sp)
    80004b3c:	7412                	ld	s0,288(sp)
    80004b3e:	6155                	addi	sp,sp,304
    80004b40:	8082                	ret

0000000080004b42 <sys_unlink>:
{
    80004b42:	7151                	addi	sp,sp,-240
    80004b44:	f586                	sd	ra,232(sp)
    80004b46:	f1a2                	sd	s0,224(sp)
    80004b48:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b4a:	08000613          	li	a2,128
    80004b4e:	f3040593          	addi	a1,s0,-208
    80004b52:	4501                	li	a0,0
    80004b54:	ffffd097          	auipc	ra,0xffffd
    80004b58:	54a080e7          	jalr	1354(ra) # 8000209e <argstr>
    80004b5c:	1a054a63          	bltz	a0,80004d10 <sys_unlink+0x1ce>
    80004b60:	eda6                	sd	s1,216(sp)
  begin_op();
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	b74080e7          	jalr	-1164(ra) # 800036d6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b6a:	fb040593          	addi	a1,s0,-80
    80004b6e:	f3040513          	addi	a0,s0,-208
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	982080e7          	jalr	-1662(ra) # 800034f4 <nameiparent>
    80004b7a:	84aa                	mv	s1,a0
    80004b7c:	cd71                	beqz	a0,80004c58 <sys_unlink+0x116>
  ilock(dp);
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	186080e7          	jalr	390(ra) # 80002d04 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b86:	00004597          	auipc	a1,0x4
    80004b8a:	9e258593          	addi	a1,a1,-1566 # 80008568 <etext+0x568>
    80004b8e:	fb040513          	addi	a0,s0,-80
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	658080e7          	jalr	1624(ra) # 800031ea <namecmp>
    80004b9a:	14050c63          	beqz	a0,80004cf2 <sys_unlink+0x1b0>
    80004b9e:	00004597          	auipc	a1,0x4
    80004ba2:	9d258593          	addi	a1,a1,-1582 # 80008570 <etext+0x570>
    80004ba6:	fb040513          	addi	a0,s0,-80
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	640080e7          	jalr	1600(ra) # 800031ea <namecmp>
    80004bb2:	14050063          	beqz	a0,80004cf2 <sys_unlink+0x1b0>
    80004bb6:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bb8:	f2c40613          	addi	a2,s0,-212
    80004bbc:	fb040593          	addi	a1,s0,-80
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	642080e7          	jalr	1602(ra) # 80003204 <dirlookup>
    80004bca:	892a                	mv	s2,a0
    80004bcc:	12050263          	beqz	a0,80004cf0 <sys_unlink+0x1ae>
  ilock(ip);
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	134080e7          	jalr	308(ra) # 80002d04 <ilock>
  if(ip->nlink < 1)
    80004bd8:	05291783          	lh	a5,82(s2)
    80004bdc:	08f05563          	blez	a5,80004c66 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004be0:	04c91703          	lh	a4,76(s2)
    80004be4:	4785                	li	a5,1
    80004be6:	08f70963          	beq	a4,a5,80004c78 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004bea:	4641                	li	a2,16
    80004bec:	4581                	li	a1,0
    80004bee:	fc040513          	addi	a0,s0,-64
    80004bf2:	ffffb097          	auipc	ra,0xffffb
    80004bf6:	696080e7          	jalr	1686(ra) # 80000288 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bfa:	4741                	li	a4,16
    80004bfc:	f2c42683          	lw	a3,-212(s0)
    80004c00:	fc040613          	addi	a2,s0,-64
    80004c04:	4581                	li	a1,0
    80004c06:	8526                	mv	a0,s1
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	4b8080e7          	jalr	1208(ra) # 800030c0 <writei>
    80004c10:	47c1                	li	a5,16
    80004c12:	0af51b63          	bne	a0,a5,80004cc8 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004c16:	04c91703          	lh	a4,76(s2)
    80004c1a:	4785                	li	a5,1
    80004c1c:	0af70f63          	beq	a4,a5,80004cda <sys_unlink+0x198>
  iunlockput(dp);
    80004c20:	8526                	mv	a0,s1
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	348080e7          	jalr	840(ra) # 80002f6a <iunlockput>
  ip->nlink--;
    80004c2a:	05295783          	lhu	a5,82(s2)
    80004c2e:	37fd                	addiw	a5,a5,-1
    80004c30:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004c34:	854a                	mv	a0,s2
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	002080e7          	jalr	2(ra) # 80002c38 <iupdate>
  iunlockput(ip);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	32a080e7          	jalr	810(ra) # 80002f6a <iunlockput>
  end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	b08080e7          	jalr	-1272(ra) # 80003750 <end_op>
  return 0;
    80004c50:	4501                	li	a0,0
    80004c52:	64ee                	ld	s1,216(sp)
    80004c54:	694e                	ld	s2,208(sp)
    80004c56:	a84d                	j	80004d08 <sys_unlink+0x1c6>
    end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	af8080e7          	jalr	-1288(ra) # 80003750 <end_op>
    return -1;
    80004c60:	557d                	li	a0,-1
    80004c62:	64ee                	ld	s1,216(sp)
    80004c64:	a055                	j	80004d08 <sys_unlink+0x1c6>
    80004c66:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004c68:	00004517          	auipc	a0,0x4
    80004c6c:	93050513          	addi	a0,a0,-1744 # 80008598 <etext+0x598>
    80004c70:	00001097          	auipc	ra,0x1
    80004c74:	586080e7          	jalr	1414(ra) # 800061f6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c78:	05492703          	lw	a4,84(s2)
    80004c7c:	02000793          	li	a5,32
    80004c80:	f6e7f5e3          	bgeu	a5,a4,80004bea <sys_unlink+0xa8>
    80004c84:	e5ce                	sd	s3,200(sp)
    80004c86:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c8a:	4741                	li	a4,16
    80004c8c:	86ce                	mv	a3,s3
    80004c8e:	f1840613          	addi	a2,s0,-232
    80004c92:	4581                	li	a1,0
    80004c94:	854a                	mv	a0,s2
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	326080e7          	jalr	806(ra) # 80002fbc <readi>
    80004c9e:	47c1                	li	a5,16
    80004ca0:	00f51c63          	bne	a0,a5,80004cb8 <sys_unlink+0x176>
    if(de.inum != 0)
    80004ca4:	f1845783          	lhu	a5,-232(s0)
    80004ca8:	e7b5                	bnez	a5,80004d14 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004caa:	29c1                	addiw	s3,s3,16
    80004cac:	05492783          	lw	a5,84(s2)
    80004cb0:	fcf9ede3          	bltu	s3,a5,80004c8a <sys_unlink+0x148>
    80004cb4:	69ae                	ld	s3,200(sp)
    80004cb6:	bf15                	j	80004bea <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004cb8:	00004517          	auipc	a0,0x4
    80004cbc:	8f850513          	addi	a0,a0,-1800 # 800085b0 <etext+0x5b0>
    80004cc0:	00001097          	auipc	ra,0x1
    80004cc4:	536080e7          	jalr	1334(ra) # 800061f6 <panic>
    80004cc8:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004cca:	00004517          	auipc	a0,0x4
    80004cce:	8fe50513          	addi	a0,a0,-1794 # 800085c8 <etext+0x5c8>
    80004cd2:	00001097          	auipc	ra,0x1
    80004cd6:	524080e7          	jalr	1316(ra) # 800061f6 <panic>
    dp->nlink--;
    80004cda:	0524d783          	lhu	a5,82(s1)
    80004cde:	37fd                	addiw	a5,a5,-1
    80004ce0:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004ce4:	8526                	mv	a0,s1
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	f52080e7          	jalr	-174(ra) # 80002c38 <iupdate>
    80004cee:	bf0d                	j	80004c20 <sys_unlink+0xde>
    80004cf0:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	276080e7          	jalr	630(ra) # 80002f6a <iunlockput>
  end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	a54080e7          	jalr	-1452(ra) # 80003750 <end_op>
  return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	64ee                	ld	s1,216(sp)
}
    80004d08:	70ae                	ld	ra,232(sp)
    80004d0a:	740e                	ld	s0,224(sp)
    80004d0c:	616d                	addi	sp,sp,240
    80004d0e:	8082                	ret
    return -1;
    80004d10:	557d                	li	a0,-1
    80004d12:	bfdd                	j	80004d08 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d14:	854a                	mv	a0,s2
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	254080e7          	jalr	596(ra) # 80002f6a <iunlockput>
    goto bad;
    80004d1e:	694e                	ld	s2,208(sp)
    80004d20:	69ae                	ld	s3,200(sp)
    80004d22:	bfc1                	j	80004cf2 <sys_unlink+0x1b0>

0000000080004d24 <sys_open>:

uint64
sys_open(void)
{
    80004d24:	7131                	addi	sp,sp,-192
    80004d26:	fd06                	sd	ra,184(sp)
    80004d28:	f922                	sd	s0,176(sp)
    80004d2a:	f526                	sd	s1,168(sp)
    80004d2c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d2e:	08000613          	li	a2,128
    80004d32:	f5040593          	addi	a1,s0,-176
    80004d36:	4501                	li	a0,0
    80004d38:	ffffd097          	auipc	ra,0xffffd
    80004d3c:	366080e7          	jalr	870(ra) # 8000209e <argstr>
    return -1;
    80004d40:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d42:	0c054463          	bltz	a0,80004e0a <sys_open+0xe6>
    80004d46:	f4c40593          	addi	a1,s0,-180
    80004d4a:	4505                	li	a0,1
    80004d4c:	ffffd097          	auipc	ra,0xffffd
    80004d50:	30e080e7          	jalr	782(ra) # 8000205a <argint>
    80004d54:	0a054b63          	bltz	a0,80004e0a <sys_open+0xe6>
    80004d58:	f14a                	sd	s2,160(sp)

  begin_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	97c080e7          	jalr	-1668(ra) # 800036d6 <begin_op>

  if(omode & O_CREATE){
    80004d62:	f4c42783          	lw	a5,-180(s0)
    80004d66:	2007f793          	andi	a5,a5,512
    80004d6a:	cfc5                	beqz	a5,80004e22 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d6c:	4681                	li	a3,0
    80004d6e:	4601                	li	a2,0
    80004d70:	4589                	li	a1,2
    80004d72:	f5040513          	addi	a0,s0,-176
    80004d76:	00000097          	auipc	ra,0x0
    80004d7a:	958080e7          	jalr	-1704(ra) # 800046ce <create>
    80004d7e:	892a                	mv	s2,a0
    if(ip == 0){
    80004d80:	c959                	beqz	a0,80004e16 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d82:	04c91703          	lh	a4,76(s2)
    80004d86:	478d                	li	a5,3
    80004d88:	00f71763          	bne	a4,a5,80004d96 <sys_open+0x72>
    80004d8c:	04e95703          	lhu	a4,78(s2)
    80004d90:	47a5                	li	a5,9
    80004d92:	0ce7ef63          	bltu	a5,a4,80004e70 <sys_open+0x14c>
    80004d96:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	d4c080e7          	jalr	-692(ra) # 80003ae4 <filealloc>
    80004da0:	89aa                	mv	s3,a0
    80004da2:	c965                	beqz	a0,80004e92 <sys_open+0x16e>
    80004da4:	00000097          	auipc	ra,0x0
    80004da8:	8e8080e7          	jalr	-1816(ra) # 8000468c <fdalloc>
    80004dac:	84aa                	mv	s1,a0
    80004dae:	0c054d63          	bltz	a0,80004e88 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004db2:	04c91703          	lh	a4,76(s2)
    80004db6:	478d                	li	a5,3
    80004db8:	0ef70a63          	beq	a4,a5,80004eac <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dbc:	4789                	li	a5,2
    80004dbe:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dc2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dc6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dca:	f4c42783          	lw	a5,-180(s0)
    80004dce:	0017c713          	xori	a4,a5,1
    80004dd2:	8b05                	andi	a4,a4,1
    80004dd4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dd8:	0037f713          	andi	a4,a5,3
    80004ddc:	00e03733          	snez	a4,a4
    80004de0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004de4:	4007f793          	andi	a5,a5,1024
    80004de8:	c791                	beqz	a5,80004df4 <sys_open+0xd0>
    80004dea:	04c91703          	lh	a4,76(s2)
    80004dee:	4789                	li	a5,2
    80004df0:	0cf70563          	beq	a4,a5,80004eba <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004df4:	854a                	mv	a0,s2
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	fd4080e7          	jalr	-44(ra) # 80002dca <iunlock>
  end_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	952080e7          	jalr	-1710(ra) # 80003750 <end_op>
    80004e06:	790a                	ld	s2,160(sp)
    80004e08:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	70ea                	ld	ra,184(sp)
    80004e0e:	744a                	ld	s0,176(sp)
    80004e10:	74aa                	ld	s1,168(sp)
    80004e12:	6129                	addi	sp,sp,192
    80004e14:	8082                	ret
      end_op();
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	93a080e7          	jalr	-1734(ra) # 80003750 <end_op>
      return -1;
    80004e1e:	790a                	ld	s2,160(sp)
    80004e20:	b7ed                	j	80004e0a <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004e22:	f5040513          	addi	a0,s0,-176
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	6b0080e7          	jalr	1712(ra) # 800034d6 <namei>
    80004e2e:	892a                	mv	s2,a0
    80004e30:	c90d                	beqz	a0,80004e62 <sys_open+0x13e>
    ilock(ip);
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	ed2080e7          	jalr	-302(ra) # 80002d04 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e3a:	04c91703          	lh	a4,76(s2)
    80004e3e:	4785                	li	a5,1
    80004e40:	f4f711e3          	bne	a4,a5,80004d82 <sys_open+0x5e>
    80004e44:	f4c42783          	lw	a5,-180(s0)
    80004e48:	d7b9                	beqz	a5,80004d96 <sys_open+0x72>
      iunlockput(ip);
    80004e4a:	854a                	mv	a0,s2
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	11e080e7          	jalr	286(ra) # 80002f6a <iunlockput>
      end_op();
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	8fc080e7          	jalr	-1796(ra) # 80003750 <end_op>
      return -1;
    80004e5c:	54fd                	li	s1,-1
    80004e5e:	790a                	ld	s2,160(sp)
    80004e60:	b76d                	j	80004e0a <sys_open+0xe6>
      end_op();
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	8ee080e7          	jalr	-1810(ra) # 80003750 <end_op>
      return -1;
    80004e6a:	54fd                	li	s1,-1
    80004e6c:	790a                	ld	s2,160(sp)
    80004e6e:	bf71                	j	80004e0a <sys_open+0xe6>
    iunlockput(ip);
    80004e70:	854a                	mv	a0,s2
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	0f8080e7          	jalr	248(ra) # 80002f6a <iunlockput>
    end_op();
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	8d6080e7          	jalr	-1834(ra) # 80003750 <end_op>
    return -1;
    80004e82:	54fd                	li	s1,-1
    80004e84:	790a                	ld	s2,160(sp)
    80004e86:	b751                	j	80004e0a <sys_open+0xe6>
      fileclose(f);
    80004e88:	854e                	mv	a0,s3
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	d16080e7          	jalr	-746(ra) # 80003ba0 <fileclose>
    iunlockput(ip);
    80004e92:	854a                	mv	a0,s2
    80004e94:	ffffe097          	auipc	ra,0xffffe
    80004e98:	0d6080e7          	jalr	214(ra) # 80002f6a <iunlockput>
    end_op();
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	8b4080e7          	jalr	-1868(ra) # 80003750 <end_op>
    return -1;
    80004ea4:	54fd                	li	s1,-1
    80004ea6:	790a                	ld	s2,160(sp)
    80004ea8:	69ea                	ld	s3,152(sp)
    80004eaa:	b785                	j	80004e0a <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004eac:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eb0:	04e91783          	lh	a5,78(s2)
    80004eb4:	02f99223          	sh	a5,36(s3)
    80004eb8:	b739                	j	80004dc6 <sys_open+0xa2>
    itrunc(ip);
    80004eba:	854a                	mv	a0,s2
    80004ebc:	ffffe097          	auipc	ra,0xffffe
    80004ec0:	f5a080e7          	jalr	-166(ra) # 80002e16 <itrunc>
    80004ec4:	bf05                	j	80004df4 <sys_open+0xd0>

0000000080004ec6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ec6:	7175                	addi	sp,sp,-144
    80004ec8:	e506                	sd	ra,136(sp)
    80004eca:	e122                	sd	s0,128(sp)
    80004ecc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	808080e7          	jalr	-2040(ra) # 800036d6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ed6:	08000613          	li	a2,128
    80004eda:	f7040593          	addi	a1,s0,-144
    80004ede:	4501                	li	a0,0
    80004ee0:	ffffd097          	auipc	ra,0xffffd
    80004ee4:	1be080e7          	jalr	446(ra) # 8000209e <argstr>
    80004ee8:	02054963          	bltz	a0,80004f1a <sys_mkdir+0x54>
    80004eec:	4681                	li	a3,0
    80004eee:	4601                	li	a2,0
    80004ef0:	4585                	li	a1,1
    80004ef2:	f7040513          	addi	a0,s0,-144
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	7d8080e7          	jalr	2008(ra) # 800046ce <create>
    80004efe:	cd11                	beqz	a0,80004f1a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	06a080e7          	jalr	106(ra) # 80002f6a <iunlockput>
  end_op();
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	848080e7          	jalr	-1976(ra) # 80003750 <end_op>
  return 0;
    80004f10:	4501                	li	a0,0
}
    80004f12:	60aa                	ld	ra,136(sp)
    80004f14:	640a                	ld	s0,128(sp)
    80004f16:	6149                	addi	sp,sp,144
    80004f18:	8082                	ret
    end_op();
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	836080e7          	jalr	-1994(ra) # 80003750 <end_op>
    return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	b7fd                	j	80004f12 <sys_mkdir+0x4c>

0000000080004f26 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f26:	7135                	addi	sp,sp,-160
    80004f28:	ed06                	sd	ra,152(sp)
    80004f2a:	e922                	sd	s0,144(sp)
    80004f2c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f2e:	ffffe097          	auipc	ra,0xffffe
    80004f32:	7a8080e7          	jalr	1960(ra) # 800036d6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f36:	08000613          	li	a2,128
    80004f3a:	f7040593          	addi	a1,s0,-144
    80004f3e:	4501                	li	a0,0
    80004f40:	ffffd097          	auipc	ra,0xffffd
    80004f44:	15e080e7          	jalr	350(ra) # 8000209e <argstr>
    80004f48:	04054a63          	bltz	a0,80004f9c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f4c:	f6c40593          	addi	a1,s0,-148
    80004f50:	4505                	li	a0,1
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	108080e7          	jalr	264(ra) # 8000205a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f5a:	04054163          	bltz	a0,80004f9c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f5e:	f6840593          	addi	a1,s0,-152
    80004f62:	4509                	li	a0,2
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	0f6080e7          	jalr	246(ra) # 8000205a <argint>
     argint(1, &major) < 0 ||
    80004f6c:	02054863          	bltz	a0,80004f9c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f70:	f6841683          	lh	a3,-152(s0)
    80004f74:	f6c41603          	lh	a2,-148(s0)
    80004f78:	458d                	li	a1,3
    80004f7a:	f7040513          	addi	a0,s0,-144
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	750080e7          	jalr	1872(ra) # 800046ce <create>
     argint(2, &minor) < 0 ||
    80004f86:	c919                	beqz	a0,80004f9c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f88:	ffffe097          	auipc	ra,0xffffe
    80004f8c:	fe2080e7          	jalr	-30(ra) # 80002f6a <iunlockput>
  end_op();
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	7c0080e7          	jalr	1984(ra) # 80003750 <end_op>
  return 0;
    80004f98:	4501                	li	a0,0
    80004f9a:	a031                	j	80004fa6 <sys_mknod+0x80>
    end_op();
    80004f9c:	ffffe097          	auipc	ra,0xffffe
    80004fa0:	7b4080e7          	jalr	1972(ra) # 80003750 <end_op>
    return -1;
    80004fa4:	557d                	li	a0,-1
}
    80004fa6:	60ea                	ld	ra,152(sp)
    80004fa8:	644a                	ld	s0,144(sp)
    80004faa:	610d                	addi	sp,sp,160
    80004fac:	8082                	ret

0000000080004fae <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fae:	7135                	addi	sp,sp,-160
    80004fb0:	ed06                	sd	ra,152(sp)
    80004fb2:	e922                	sd	s0,144(sp)
    80004fb4:	e14a                	sd	s2,128(sp)
    80004fb6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	fe2080e7          	jalr	-30(ra) # 80000f9a <myproc>
    80004fc0:	892a                	mv	s2,a0
  
  begin_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	714080e7          	jalr	1812(ra) # 800036d6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fca:	08000613          	li	a2,128
    80004fce:	f6040593          	addi	a1,s0,-160
    80004fd2:	4501                	li	a0,0
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	0ca080e7          	jalr	202(ra) # 8000209e <argstr>
    80004fdc:	04054d63          	bltz	a0,80005036 <sys_chdir+0x88>
    80004fe0:	e526                	sd	s1,136(sp)
    80004fe2:	f6040513          	addi	a0,s0,-160
    80004fe6:	ffffe097          	auipc	ra,0xffffe
    80004fea:	4f0080e7          	jalr	1264(ra) # 800034d6 <namei>
    80004fee:	84aa                	mv	s1,a0
    80004ff0:	c131                	beqz	a0,80005034 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ff2:	ffffe097          	auipc	ra,0xffffe
    80004ff6:	d12080e7          	jalr	-750(ra) # 80002d04 <ilock>
  if(ip->type != T_DIR){
    80004ffa:	04c49703          	lh	a4,76(s1)
    80004ffe:	4785                	li	a5,1
    80005000:	04f71163          	bne	a4,a5,80005042 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005004:	8526                	mv	a0,s1
    80005006:	ffffe097          	auipc	ra,0xffffe
    8000500a:	dc4080e7          	jalr	-572(ra) # 80002dca <iunlock>
  iput(p->cwd);
    8000500e:	15893503          	ld	a0,344(s2)
    80005012:	ffffe097          	auipc	ra,0xffffe
    80005016:	eb0080e7          	jalr	-336(ra) # 80002ec2 <iput>
  end_op();
    8000501a:	ffffe097          	auipc	ra,0xffffe
    8000501e:	736080e7          	jalr	1846(ra) # 80003750 <end_op>
  p->cwd = ip;
    80005022:	14993c23          	sd	s1,344(s2)
  return 0;
    80005026:	4501                	li	a0,0
    80005028:	64aa                	ld	s1,136(sp)
}
    8000502a:	60ea                	ld	ra,152(sp)
    8000502c:	644a                	ld	s0,144(sp)
    8000502e:	690a                	ld	s2,128(sp)
    80005030:	610d                	addi	sp,sp,160
    80005032:	8082                	ret
    80005034:	64aa                	ld	s1,136(sp)
    end_op();
    80005036:	ffffe097          	auipc	ra,0xffffe
    8000503a:	71a080e7          	jalr	1818(ra) # 80003750 <end_op>
    return -1;
    8000503e:	557d                	li	a0,-1
    80005040:	b7ed                	j	8000502a <sys_chdir+0x7c>
    iunlockput(ip);
    80005042:	8526                	mv	a0,s1
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	f26080e7          	jalr	-218(ra) # 80002f6a <iunlockput>
    end_op();
    8000504c:	ffffe097          	auipc	ra,0xffffe
    80005050:	704080e7          	jalr	1796(ra) # 80003750 <end_op>
    return -1;
    80005054:	557d                	li	a0,-1
    80005056:	64aa                	ld	s1,136(sp)
    80005058:	bfc9                	j	8000502a <sys_chdir+0x7c>

000000008000505a <sys_exec>:

uint64
sys_exec(void)
{
    8000505a:	7121                	addi	sp,sp,-448
    8000505c:	ff06                	sd	ra,440(sp)
    8000505e:	fb22                	sd	s0,432(sp)
    80005060:	f34a                	sd	s2,416(sp)
    80005062:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005064:	08000613          	li	a2,128
    80005068:	f5040593          	addi	a1,s0,-176
    8000506c:	4501                	li	a0,0
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	030080e7          	jalr	48(ra) # 8000209e <argstr>
    return -1;
    80005076:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005078:	0e054a63          	bltz	a0,8000516c <sys_exec+0x112>
    8000507c:	e4840593          	addi	a1,s0,-440
    80005080:	4505                	li	a0,1
    80005082:	ffffd097          	auipc	ra,0xffffd
    80005086:	ffa080e7          	jalr	-6(ra) # 8000207c <argaddr>
    8000508a:	0e054163          	bltz	a0,8000516c <sys_exec+0x112>
    8000508e:	f726                	sd	s1,424(sp)
    80005090:	ef4e                	sd	s3,408(sp)
    80005092:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005094:	10000613          	li	a2,256
    80005098:	4581                	li	a1,0
    8000509a:	e5040513          	addi	a0,s0,-432
    8000509e:	ffffb097          	auipc	ra,0xffffb
    800050a2:	1ea080e7          	jalr	490(ra) # 80000288 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050a6:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050aa:	89a6                	mv	s3,s1
    800050ac:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050ae:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050b2:	00391513          	slli	a0,s2,0x3
    800050b6:	e4040593          	addi	a1,s0,-448
    800050ba:	e4843783          	ld	a5,-440(s0)
    800050be:	953e                	add	a0,a0,a5
    800050c0:	ffffd097          	auipc	ra,0xffffd
    800050c4:	f00080e7          	jalr	-256(ra) # 80001fc0 <fetchaddr>
    800050c8:	02054a63          	bltz	a0,800050fc <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800050cc:	e4043783          	ld	a5,-448(s0)
    800050d0:	c7b1                	beqz	a5,8000511c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050d2:	ffffb097          	auipc	ra,0xffffb
    800050d6:	0ae080e7          	jalr	174(ra) # 80000180 <kalloc>
    800050da:	85aa                	mv	a1,a0
    800050dc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050e0:	cd11                	beqz	a0,800050fc <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050e2:	6605                	lui	a2,0x1
    800050e4:	e4043503          	ld	a0,-448(s0)
    800050e8:	ffffd097          	auipc	ra,0xffffd
    800050ec:	f2a080e7          	jalr	-214(ra) # 80002012 <fetchstr>
    800050f0:	00054663          	bltz	a0,800050fc <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    800050f4:	0905                	addi	s2,s2,1
    800050f6:	09a1                	addi	s3,s3,8
    800050f8:	fb491de3          	bne	s2,s4,800050b2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fc:	f5040913          	addi	s2,s0,-176
    80005100:	6088                	ld	a0,0(s1)
    80005102:	c12d                	beqz	a0,80005164 <sys_exec+0x10a>
    kfree(argv[i]);
    80005104:	ffffb097          	auipc	ra,0xffffb
    80005108:	f18080e7          	jalr	-232(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000510c:	04a1                	addi	s1,s1,8
    8000510e:	ff2499e3          	bne	s1,s2,80005100 <sys_exec+0xa6>
  return -1;
    80005112:	597d                	li	s2,-1
    80005114:	74ba                	ld	s1,424(sp)
    80005116:	69fa                	ld	s3,408(sp)
    80005118:	6a5a                	ld	s4,400(sp)
    8000511a:	a889                	j	8000516c <sys_exec+0x112>
      argv[i] = 0;
    8000511c:	0009079b          	sext.w	a5,s2
    80005120:	078e                	slli	a5,a5,0x3
    80005122:	fd078793          	addi	a5,a5,-48
    80005126:	97a2                	add	a5,a5,s0
    80005128:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000512c:	e5040593          	addi	a1,s0,-432
    80005130:	f5040513          	addi	a0,s0,-176
    80005134:	fffff097          	auipc	ra,0xfffff
    80005138:	126080e7          	jalr	294(ra) # 8000425a <exec>
    8000513c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000513e:	f5040993          	addi	s3,s0,-176
    80005142:	6088                	ld	a0,0(s1)
    80005144:	cd01                	beqz	a0,8000515c <sys_exec+0x102>
    kfree(argv[i]);
    80005146:	ffffb097          	auipc	ra,0xffffb
    8000514a:	ed6080e7          	jalr	-298(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000514e:	04a1                	addi	s1,s1,8
    80005150:	ff3499e3          	bne	s1,s3,80005142 <sys_exec+0xe8>
    80005154:	74ba                	ld	s1,424(sp)
    80005156:	69fa                	ld	s3,408(sp)
    80005158:	6a5a                	ld	s4,400(sp)
    8000515a:	a809                	j	8000516c <sys_exec+0x112>
  return ret;
    8000515c:	74ba                	ld	s1,424(sp)
    8000515e:	69fa                	ld	s3,408(sp)
    80005160:	6a5a                	ld	s4,400(sp)
    80005162:	a029                	j	8000516c <sys_exec+0x112>
  return -1;
    80005164:	597d                	li	s2,-1
    80005166:	74ba                	ld	s1,424(sp)
    80005168:	69fa                	ld	s3,408(sp)
    8000516a:	6a5a                	ld	s4,400(sp)
}
    8000516c:	854a                	mv	a0,s2
    8000516e:	70fa                	ld	ra,440(sp)
    80005170:	745a                	ld	s0,432(sp)
    80005172:	791a                	ld	s2,416(sp)
    80005174:	6139                	addi	sp,sp,448
    80005176:	8082                	ret

0000000080005178 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005178:	7139                	addi	sp,sp,-64
    8000517a:	fc06                	sd	ra,56(sp)
    8000517c:	f822                	sd	s0,48(sp)
    8000517e:	f426                	sd	s1,40(sp)
    80005180:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005182:	ffffc097          	auipc	ra,0xffffc
    80005186:	e18080e7          	jalr	-488(ra) # 80000f9a <myproc>
    8000518a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000518c:	fd840593          	addi	a1,s0,-40
    80005190:	4501                	li	a0,0
    80005192:	ffffd097          	auipc	ra,0xffffd
    80005196:	eea080e7          	jalr	-278(ra) # 8000207c <argaddr>
    return -1;
    8000519a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000519c:	0e054063          	bltz	a0,8000527c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051a0:	fc840593          	addi	a1,s0,-56
    800051a4:	fd040513          	addi	a0,s0,-48
    800051a8:	fffff097          	auipc	ra,0xfffff
    800051ac:	d66080e7          	jalr	-666(ra) # 80003f0e <pipealloc>
    return -1;
    800051b0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051b2:	0c054563          	bltz	a0,8000527c <sys_pipe+0x104>
  fd0 = -1;
    800051b6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051ba:	fd043503          	ld	a0,-48(s0)
    800051be:	fffff097          	auipc	ra,0xfffff
    800051c2:	4ce080e7          	jalr	1230(ra) # 8000468c <fdalloc>
    800051c6:	fca42223          	sw	a0,-60(s0)
    800051ca:	08054c63          	bltz	a0,80005262 <sys_pipe+0xea>
    800051ce:	fc843503          	ld	a0,-56(s0)
    800051d2:	fffff097          	auipc	ra,0xfffff
    800051d6:	4ba080e7          	jalr	1210(ra) # 8000468c <fdalloc>
    800051da:	fca42023          	sw	a0,-64(s0)
    800051de:	06054963          	bltz	a0,80005250 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051e2:	4691                	li	a3,4
    800051e4:	fc440613          	addi	a2,s0,-60
    800051e8:	fd843583          	ld	a1,-40(s0)
    800051ec:	6ca8                	ld	a0,88(s1)
    800051ee:	ffffc097          	auipc	ra,0xffffc
    800051f2:	a48080e7          	jalr	-1464(ra) # 80000c36 <copyout>
    800051f6:	02054063          	bltz	a0,80005216 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051fa:	4691                	li	a3,4
    800051fc:	fc040613          	addi	a2,s0,-64
    80005200:	fd843583          	ld	a1,-40(s0)
    80005204:	0591                	addi	a1,a1,4
    80005206:	6ca8                	ld	a0,88(s1)
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	a2e080e7          	jalr	-1490(ra) # 80000c36 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005210:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005212:	06055563          	bgez	a0,8000527c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005216:	fc442783          	lw	a5,-60(s0)
    8000521a:	07e9                	addi	a5,a5,26
    8000521c:	078e                	slli	a5,a5,0x3
    8000521e:	97a6                	add	a5,a5,s1
    80005220:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005224:	fc042783          	lw	a5,-64(s0)
    80005228:	07e9                	addi	a5,a5,26
    8000522a:	078e                	slli	a5,a5,0x3
    8000522c:	00f48533          	add	a0,s1,a5
    80005230:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005234:	fd043503          	ld	a0,-48(s0)
    80005238:	fffff097          	auipc	ra,0xfffff
    8000523c:	968080e7          	jalr	-1688(ra) # 80003ba0 <fileclose>
    fileclose(wf);
    80005240:	fc843503          	ld	a0,-56(s0)
    80005244:	fffff097          	auipc	ra,0xfffff
    80005248:	95c080e7          	jalr	-1700(ra) # 80003ba0 <fileclose>
    return -1;
    8000524c:	57fd                	li	a5,-1
    8000524e:	a03d                	j	8000527c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005250:	fc442783          	lw	a5,-60(s0)
    80005254:	0007c763          	bltz	a5,80005262 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005258:	07e9                	addi	a5,a5,26
    8000525a:	078e                	slli	a5,a5,0x3
    8000525c:	97a6                	add	a5,a5,s1
    8000525e:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005262:	fd043503          	ld	a0,-48(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	93a080e7          	jalr	-1734(ra) # 80003ba0 <fileclose>
    fileclose(wf);
    8000526e:	fc843503          	ld	a0,-56(s0)
    80005272:	fffff097          	auipc	ra,0xfffff
    80005276:	92e080e7          	jalr	-1746(ra) # 80003ba0 <fileclose>
    return -1;
    8000527a:	57fd                	li	a5,-1
}
    8000527c:	853e                	mv	a0,a5
    8000527e:	70e2                	ld	ra,56(sp)
    80005280:	7442                	ld	s0,48(sp)
    80005282:	74a2                	ld	s1,40(sp)
    80005284:	6121                	addi	sp,sp,64
    80005286:	8082                	ret
	...

0000000080005290 <kernelvec>:
    80005290:	7111                	addi	sp,sp,-256
    80005292:	e006                	sd	ra,0(sp)
    80005294:	e40a                	sd	sp,8(sp)
    80005296:	e80e                	sd	gp,16(sp)
    80005298:	ec12                	sd	tp,24(sp)
    8000529a:	f016                	sd	t0,32(sp)
    8000529c:	f41a                	sd	t1,40(sp)
    8000529e:	f81e                	sd	t2,48(sp)
    800052a0:	fc22                	sd	s0,56(sp)
    800052a2:	e0a6                	sd	s1,64(sp)
    800052a4:	e4aa                	sd	a0,72(sp)
    800052a6:	e8ae                	sd	a1,80(sp)
    800052a8:	ecb2                	sd	a2,88(sp)
    800052aa:	f0b6                	sd	a3,96(sp)
    800052ac:	f4ba                	sd	a4,104(sp)
    800052ae:	f8be                	sd	a5,112(sp)
    800052b0:	fcc2                	sd	a6,120(sp)
    800052b2:	e146                	sd	a7,128(sp)
    800052b4:	e54a                	sd	s2,136(sp)
    800052b6:	e94e                	sd	s3,144(sp)
    800052b8:	ed52                	sd	s4,152(sp)
    800052ba:	f156                	sd	s5,160(sp)
    800052bc:	f55a                	sd	s6,168(sp)
    800052be:	f95e                	sd	s7,176(sp)
    800052c0:	fd62                	sd	s8,184(sp)
    800052c2:	e1e6                	sd	s9,192(sp)
    800052c4:	e5ea                	sd	s10,200(sp)
    800052c6:	e9ee                	sd	s11,208(sp)
    800052c8:	edf2                	sd	t3,216(sp)
    800052ca:	f1f6                	sd	t4,224(sp)
    800052cc:	f5fa                	sd	t5,232(sp)
    800052ce:	f9fe                	sd	t6,240(sp)
    800052d0:	bbdfc0ef          	jal	80001e8c <kerneltrap>
    800052d4:	6082                	ld	ra,0(sp)
    800052d6:	6122                	ld	sp,8(sp)
    800052d8:	61c2                	ld	gp,16(sp)
    800052da:	7282                	ld	t0,32(sp)
    800052dc:	7322                	ld	t1,40(sp)
    800052de:	73c2                	ld	t2,48(sp)
    800052e0:	7462                	ld	s0,56(sp)
    800052e2:	6486                	ld	s1,64(sp)
    800052e4:	6526                	ld	a0,72(sp)
    800052e6:	65c6                	ld	a1,80(sp)
    800052e8:	6666                	ld	a2,88(sp)
    800052ea:	7686                	ld	a3,96(sp)
    800052ec:	7726                	ld	a4,104(sp)
    800052ee:	77c6                	ld	a5,112(sp)
    800052f0:	7866                	ld	a6,120(sp)
    800052f2:	688a                	ld	a7,128(sp)
    800052f4:	692a                	ld	s2,136(sp)
    800052f6:	69ca                	ld	s3,144(sp)
    800052f8:	6a6a                	ld	s4,152(sp)
    800052fa:	7a8a                	ld	s5,160(sp)
    800052fc:	7b2a                	ld	s6,168(sp)
    800052fe:	7bca                	ld	s7,176(sp)
    80005300:	7c6a                	ld	s8,184(sp)
    80005302:	6c8e                	ld	s9,192(sp)
    80005304:	6d2e                	ld	s10,200(sp)
    80005306:	6dce                	ld	s11,208(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
    80005316:	00000013          	nop
    8000531a:	00000013          	nop
    8000531e:	0001                	nop

0000000080005320 <timervec>:
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	e10c                	sd	a1,0(a0)
    80005326:	e510                	sd	a2,8(a0)
    80005328:	e914                	sd	a3,16(a0)
    8000532a:	6d0c                	ld	a1,24(a0)
    8000532c:	7110                	ld	a2,32(a0)
    8000532e:	6194                	ld	a3,0(a1)
    80005330:	96b2                	add	a3,a3,a2
    80005332:	e194                	sd	a3,0(a1)
    80005334:	4589                	li	a1,2
    80005336:	14459073          	csrw	sip,a1
    8000533a:	6914                	ld	a3,16(a0)
    8000533c:	6510                	ld	a2,8(a0)
    8000533e:	610c                	ld	a1,0(a0)
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	30200073          	mret
	...

000000008000534a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534a:	1141                	addi	sp,sp,-16
    8000534c:	e422                	sd	s0,8(sp)
    8000534e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005350:	0c0007b7          	lui	a5,0xc000
    80005354:	4705                	li	a4,1
    80005356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005358:	0c0007b7          	lui	a5,0xc000
    8000535c:	c3d8                	sw	a4,4(a5)
}
    8000535e:	6422                	ld	s0,8(sp)
    80005360:	0141                	addi	sp,sp,16
    80005362:	8082                	ret

0000000080005364 <plicinithart>:

void
plicinithart(void)
{
    80005364:	1141                	addi	sp,sp,-16
    80005366:	e406                	sd	ra,8(sp)
    80005368:	e022                	sd	s0,0(sp)
    8000536a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000536c:	ffffc097          	auipc	ra,0xffffc
    80005370:	c02080e7          	jalr	-1022(ra) # 80000f6e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005374:	0085171b          	slliw	a4,a0,0x8
    80005378:	0c0027b7          	lui	a5,0xc002
    8000537c:	97ba                	add	a5,a5,a4
    8000537e:	40200713          	li	a4,1026
    80005382:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005386:	00d5151b          	slliw	a0,a0,0xd
    8000538a:	0c2017b7          	lui	a5,0xc201
    8000538e:	97aa                	add	a5,a5,a0
    80005390:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005394:	60a2                	ld	ra,8(sp)
    80005396:	6402                	ld	s0,0(sp)
    80005398:	0141                	addi	sp,sp,16
    8000539a:	8082                	ret

000000008000539c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000539c:	1141                	addi	sp,sp,-16
    8000539e:	e406                	sd	ra,8(sp)
    800053a0:	e022                	sd	s0,0(sp)
    800053a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a4:	ffffc097          	auipc	ra,0xffffc
    800053a8:	bca080e7          	jalr	-1078(ra) # 80000f6e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053ac:	00d5151b          	slliw	a0,a0,0xd
    800053b0:	0c2017b7          	lui	a5,0xc201
    800053b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800053b6:	43c8                	lw	a0,4(a5)
    800053b8:	60a2                	ld	ra,8(sp)
    800053ba:	6402                	ld	s0,0(sp)
    800053bc:	0141                	addi	sp,sp,16
    800053be:	8082                	ret

00000000800053c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053c0:	1101                	addi	sp,sp,-32
    800053c2:	ec06                	sd	ra,24(sp)
    800053c4:	e822                	sd	s0,16(sp)
    800053c6:	e426                	sd	s1,8(sp)
    800053c8:	1000                	addi	s0,sp,32
    800053ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053cc:	ffffc097          	auipc	ra,0xffffc
    800053d0:	ba2080e7          	jalr	-1118(ra) # 80000f6e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053d4:	00d5151b          	slliw	a0,a0,0xd
    800053d8:	0c2017b7          	lui	a5,0xc201
    800053dc:	97aa                	add	a5,a5,a0
    800053de:	c3c4                	sw	s1,4(a5)
}
    800053e0:	60e2                	ld	ra,24(sp)
    800053e2:	6442                	ld	s0,16(sp)
    800053e4:	64a2                	ld	s1,8(sp)
    800053e6:	6105                	addi	sp,sp,32
    800053e8:	8082                	ret

00000000800053ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053ea:	1141                	addi	sp,sp,-16
    800053ec:	e406                	sd	ra,8(sp)
    800053ee:	e022                	sd	s0,0(sp)
    800053f0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053f2:	479d                	li	a5,7
    800053f4:	06a7c863          	blt	a5,a0,80005464 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800053f8:	0001c717          	auipc	a4,0x1c
    800053fc:	c0870713          	addi	a4,a4,-1016 # 80021000 <disk>
    80005400:	972a                	add	a4,a4,a0
    80005402:	6789                	lui	a5,0x2
    80005404:	97ba                	add	a5,a5,a4
    80005406:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000540a:	e7ad                	bnez	a5,80005474 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000540c:	00451793          	slli	a5,a0,0x4
    80005410:	0001e717          	auipc	a4,0x1e
    80005414:	bf070713          	addi	a4,a4,-1040 # 80023000 <disk+0x2000>
    80005418:	6314                	ld	a3,0(a4)
    8000541a:	96be                	add	a3,a3,a5
    8000541c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005420:	6314                	ld	a3,0(a4)
    80005422:	96be                	add	a3,a3,a5
    80005424:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005428:	6314                	ld	a3,0(a4)
    8000542a:	96be                	add	a3,a3,a5
    8000542c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005430:	6318                	ld	a4,0(a4)
    80005432:	97ba                	add	a5,a5,a4
    80005434:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005438:	0001c717          	auipc	a4,0x1c
    8000543c:	bc870713          	addi	a4,a4,-1080 # 80021000 <disk>
    80005440:	972a                	add	a4,a4,a0
    80005442:	6789                	lui	a5,0x2
    80005444:	97ba                	add	a5,a5,a4
    80005446:	4705                	li	a4,1
    80005448:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000544c:	0001e517          	auipc	a0,0x1e
    80005450:	bcc50513          	addi	a0,a0,-1076 # 80023018 <disk+0x2018>
    80005454:	ffffc097          	auipc	ra,0xffffc
    80005458:	398080e7          	jalr	920(ra) # 800017ec <wakeup>
}
    8000545c:	60a2                	ld	ra,8(sp)
    8000545e:	6402                	ld	s0,0(sp)
    80005460:	0141                	addi	sp,sp,16
    80005462:	8082                	ret
    panic("free_desc 1");
    80005464:	00003517          	auipc	a0,0x3
    80005468:	17450513          	addi	a0,a0,372 # 800085d8 <etext+0x5d8>
    8000546c:	00001097          	auipc	ra,0x1
    80005470:	d8a080e7          	jalr	-630(ra) # 800061f6 <panic>
    panic("free_desc 2");
    80005474:	00003517          	auipc	a0,0x3
    80005478:	17450513          	addi	a0,a0,372 # 800085e8 <etext+0x5e8>
    8000547c:	00001097          	auipc	ra,0x1
    80005480:	d7a080e7          	jalr	-646(ra) # 800061f6 <panic>

0000000080005484 <virtio_disk_init>:
{
    80005484:	1141                	addi	sp,sp,-16
    80005486:	e406                	sd	ra,8(sp)
    80005488:	e022                	sd	s0,0(sp)
    8000548a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000548c:	00003597          	auipc	a1,0x3
    80005490:	16c58593          	addi	a1,a1,364 # 800085f8 <etext+0x5f8>
    80005494:	0001e517          	auipc	a0,0x1e
    80005498:	c9450513          	addi	a0,a0,-876 # 80023128 <disk+0x2128>
    8000549c:	00001097          	auipc	ra,0x1
    800054a0:	432080e7          	jalr	1074(ra) # 800068ce <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	4398                	lw	a4,0(a5)
    800054aa:	2701                	sext.w	a4,a4
    800054ac:	747277b7          	lui	a5,0x74727
    800054b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054b4:	0ef71f63          	bne	a4,a5,800055b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054b8:	100017b7          	lui	a5,0x10001
    800054bc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800054be:	439c                	lw	a5,0(a5)
    800054c0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c2:	4705                	li	a4,1
    800054c4:	0ee79763          	bne	a5,a4,800055b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054c8:	100017b7          	lui	a5,0x10001
    800054cc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800054ce:	439c                	lw	a5,0(a5)
    800054d0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054d2:	4709                	li	a4,2
    800054d4:	0ce79f63          	bne	a5,a4,800055b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054d8:	100017b7          	lui	a5,0x10001
    800054dc:	47d8                	lw	a4,12(a5)
    800054de:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054e0:	554d47b7          	lui	a5,0x554d4
    800054e4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054e8:	0cf71563          	bne	a4,a5,800055b2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ec:	100017b7          	lui	a5,0x10001
    800054f0:	4705                	li	a4,1
    800054f2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f4:	470d                	li	a4,3
    800054f6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054f8:	10001737          	lui	a4,0x10001
    800054fc:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054fe:	c7ffe737          	lui	a4,0xc7ffe
    80005502:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd0517>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005506:	8ef9                	and	a3,a3,a4
    80005508:	10001737          	lui	a4,0x10001
    8000550c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000550e:	472d                	li	a4,11
    80005510:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005512:	473d                	li	a4,15
    80005514:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005516:	100017b7          	lui	a5,0x10001
    8000551a:	6705                	lui	a4,0x1
    8000551c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000551e:	100017b7          	lui	a5,0x10001
    80005522:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005526:	100017b7          	lui	a5,0x10001
    8000552a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000552e:	439c                	lw	a5,0(a5)
    80005530:	2781                	sext.w	a5,a5
  if(max == 0)
    80005532:	cbc1                	beqz	a5,800055c2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005534:	471d                	li	a4,7
    80005536:	08f77e63          	bgeu	a4,a5,800055d2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000553a:	100017b7          	lui	a5,0x10001
    8000553e:	4721                	li	a4,8
    80005540:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005542:	6609                	lui	a2,0x2
    80005544:	4581                	li	a1,0
    80005546:	0001c517          	auipc	a0,0x1c
    8000554a:	aba50513          	addi	a0,a0,-1350 # 80021000 <disk>
    8000554e:	ffffb097          	auipc	ra,0xffffb
    80005552:	d3a080e7          	jalr	-710(ra) # 80000288 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005556:	0001c697          	auipc	a3,0x1c
    8000555a:	aaa68693          	addi	a3,a3,-1366 # 80021000 <disk>
    8000555e:	00c6d713          	srli	a4,a3,0xc
    80005562:	2701                	sext.w	a4,a4
    80005564:	100017b7          	lui	a5,0x10001
    80005568:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000556a:	0001e797          	auipc	a5,0x1e
    8000556e:	a9678793          	addi	a5,a5,-1386 # 80023000 <disk+0x2000>
    80005572:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005574:	0001c717          	auipc	a4,0x1c
    80005578:	b0c70713          	addi	a4,a4,-1268 # 80021080 <disk+0x80>
    8000557c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000557e:	0001d717          	auipc	a4,0x1d
    80005582:	a8270713          	addi	a4,a4,-1406 # 80022000 <disk+0x1000>
    80005586:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005588:	4705                	li	a4,1
    8000558a:	00e78c23          	sb	a4,24(a5)
    8000558e:	00e78ca3          	sb	a4,25(a5)
    80005592:	00e78d23          	sb	a4,26(a5)
    80005596:	00e78da3          	sb	a4,27(a5)
    8000559a:	00e78e23          	sb	a4,28(a5)
    8000559e:	00e78ea3          	sb	a4,29(a5)
    800055a2:	00e78f23          	sb	a4,30(a5)
    800055a6:	00e78fa3          	sb	a4,31(a5)
}
    800055aa:	60a2                	ld	ra,8(sp)
    800055ac:	6402                	ld	s0,0(sp)
    800055ae:	0141                	addi	sp,sp,16
    800055b0:	8082                	ret
    panic("could not find virtio disk");
    800055b2:	00003517          	auipc	a0,0x3
    800055b6:	05650513          	addi	a0,a0,86 # 80008608 <etext+0x608>
    800055ba:	00001097          	auipc	ra,0x1
    800055be:	c3c080e7          	jalr	-964(ra) # 800061f6 <panic>
    panic("virtio disk has no queue 0");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	06650513          	addi	a0,a0,102 # 80008628 <etext+0x628>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	c2c080e7          	jalr	-980(ra) # 800061f6 <panic>
    panic("virtio disk max queue too short");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	07650513          	addi	a0,a0,118 # 80008648 <etext+0x648>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	c1c080e7          	jalr	-996(ra) # 800061f6 <panic>

00000000800055e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055e2:	7159                	addi	sp,sp,-112
    800055e4:	f486                	sd	ra,104(sp)
    800055e6:	f0a2                	sd	s0,96(sp)
    800055e8:	eca6                	sd	s1,88(sp)
    800055ea:	e8ca                	sd	s2,80(sp)
    800055ec:	e4ce                	sd	s3,72(sp)
    800055ee:	e0d2                	sd	s4,64(sp)
    800055f0:	fc56                	sd	s5,56(sp)
    800055f2:	f85a                	sd	s6,48(sp)
    800055f4:	f45e                	sd	s7,40(sp)
    800055f6:	f062                	sd	s8,32(sp)
    800055f8:	ec66                	sd	s9,24(sp)
    800055fa:	1880                	addi	s0,sp,112
    800055fc:	8a2a                	mv	s4,a0
    800055fe:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005600:	00c52c03          	lw	s8,12(a0)
    80005604:	001c1c1b          	slliw	s8,s8,0x1
    80005608:	1c02                	slli	s8,s8,0x20
    8000560a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000560e:	0001e517          	auipc	a0,0x1e
    80005612:	b1a50513          	addi	a0,a0,-1254 # 80023128 <disk+0x2128>
    80005616:	00001097          	auipc	ra,0x1
    8000561a:	144080e7          	jalr	324(ra) # 8000675a <acquire>
  for(int i = 0; i < 3; i++){
    8000561e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005620:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005622:	0001cb97          	auipc	s7,0x1c
    80005626:	9deb8b93          	addi	s7,s7,-1570 # 80021000 <disk>
    8000562a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000562c:	4a8d                	li	s5,3
    8000562e:	a88d                	j	800056a0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005630:	00fb8733          	add	a4,s7,a5
    80005634:	975a                	add	a4,a4,s6
    80005636:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000563a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000563c:	0207c563          	bltz	a5,80005666 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005640:	2905                	addiw	s2,s2,1
    80005642:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005644:	1b590163          	beq	s2,s5,800057e6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005648:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000564a:	0001e717          	auipc	a4,0x1e
    8000564e:	9ce70713          	addi	a4,a4,-1586 # 80023018 <disk+0x2018>
    80005652:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005654:	00074683          	lbu	a3,0(a4)
    80005658:	fee1                	bnez	a3,80005630 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000565a:	2785                	addiw	a5,a5,1
    8000565c:	0705                	addi	a4,a4,1
    8000565e:	fe979be3          	bne	a5,s1,80005654 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005662:	57fd                	li	a5,-1
    80005664:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005666:	03205163          	blez	s2,80005688 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000566a:	f9042503          	lw	a0,-112(s0)
    8000566e:	00000097          	auipc	ra,0x0
    80005672:	d7c080e7          	jalr	-644(ra) # 800053ea <free_desc>
      for(int j = 0; j < i; j++)
    80005676:	4785                	li	a5,1
    80005678:	0127d863          	bge	a5,s2,80005688 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000567c:	f9442503          	lw	a0,-108(s0)
    80005680:	00000097          	auipc	ra,0x0
    80005684:	d6a080e7          	jalr	-662(ra) # 800053ea <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005688:	0001e597          	auipc	a1,0x1e
    8000568c:	aa058593          	addi	a1,a1,-1376 # 80023128 <disk+0x2128>
    80005690:	0001e517          	auipc	a0,0x1e
    80005694:	98850513          	addi	a0,a0,-1656 # 80023018 <disk+0x2018>
    80005698:	ffffc097          	auipc	ra,0xffffc
    8000569c:	fc8080e7          	jalr	-56(ra) # 80001660 <sleep>
  for(int i = 0; i < 3; i++){
    800056a0:	f9040613          	addi	a2,s0,-112
    800056a4:	894e                	mv	s2,s3
    800056a6:	b74d                	j	80005648 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056a8:	0001e717          	auipc	a4,0x1e
    800056ac:	95873703          	ld	a4,-1704(a4) # 80023000 <disk+0x2000>
    800056b0:	973e                	add	a4,a4,a5
    800056b2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056b6:	0001c897          	auipc	a7,0x1c
    800056ba:	94a88893          	addi	a7,a7,-1718 # 80021000 <disk>
    800056be:	0001e717          	auipc	a4,0x1e
    800056c2:	94270713          	addi	a4,a4,-1726 # 80023000 <disk+0x2000>
    800056c6:	6314                	ld	a3,0(a4)
    800056c8:	96be                	add	a3,a3,a5
    800056ca:	00c6d583          	lhu	a1,12(a3)
    800056ce:	0015e593          	ori	a1,a1,1
    800056d2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056d6:	f9842683          	lw	a3,-104(s0)
    800056da:	630c                	ld	a1,0(a4)
    800056dc:	97ae                	add	a5,a5,a1
    800056de:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056e2:	20050593          	addi	a1,a0,512
    800056e6:	0592                	slli	a1,a1,0x4
    800056e8:	95c6                	add	a1,a1,a7
    800056ea:	57fd                	li	a5,-1
    800056ec:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056f0:	00469793          	slli	a5,a3,0x4
    800056f4:	00073803          	ld	a6,0(a4)
    800056f8:	983e                	add	a6,a6,a5
    800056fa:	6689                	lui	a3,0x2
    800056fc:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005700:	96b2                	add	a3,a3,a2
    80005702:	96c6                	add	a3,a3,a7
    80005704:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005708:	6314                	ld	a3,0(a4)
    8000570a:	96be                	add	a3,a3,a5
    8000570c:	4605                	li	a2,1
    8000570e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005710:	6314                	ld	a3,0(a4)
    80005712:	96be                	add	a3,a3,a5
    80005714:	4809                	li	a6,2
    80005716:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000571a:	6314                	ld	a3,0(a4)
    8000571c:	97b6                	add	a5,a5,a3
    8000571e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005722:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005726:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000572a:	6714                	ld	a3,8(a4)
    8000572c:	0026d783          	lhu	a5,2(a3)
    80005730:	8b9d                	andi	a5,a5,7
    80005732:	0786                	slli	a5,a5,0x1
    80005734:	96be                	add	a3,a3,a5
    80005736:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000573a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000573e:	6718                	ld	a4,8(a4)
    80005740:	00275783          	lhu	a5,2(a4)
    80005744:	2785                	addiw	a5,a5,1
    80005746:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000574a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000574e:	100017b7          	lui	a5,0x10001
    80005752:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005756:	004a2783          	lw	a5,4(s4)
    8000575a:	02c79163          	bne	a5,a2,8000577c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000575e:	0001e917          	auipc	s2,0x1e
    80005762:	9ca90913          	addi	s2,s2,-1590 # 80023128 <disk+0x2128>
  while(b->disk == 1) {
    80005766:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005768:	85ca                	mv	a1,s2
    8000576a:	8552                	mv	a0,s4
    8000576c:	ffffc097          	auipc	ra,0xffffc
    80005770:	ef4080e7          	jalr	-268(ra) # 80001660 <sleep>
  while(b->disk == 1) {
    80005774:	004a2783          	lw	a5,4(s4)
    80005778:	fe9788e3          	beq	a5,s1,80005768 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000577c:	f9042903          	lw	s2,-112(s0)
    80005780:	20090713          	addi	a4,s2,512
    80005784:	0712                	slli	a4,a4,0x4
    80005786:	0001c797          	auipc	a5,0x1c
    8000578a:	87a78793          	addi	a5,a5,-1926 # 80021000 <disk>
    8000578e:	97ba                	add	a5,a5,a4
    80005790:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005794:	0001e997          	auipc	s3,0x1e
    80005798:	86c98993          	addi	s3,s3,-1940 # 80023000 <disk+0x2000>
    8000579c:	00491713          	slli	a4,s2,0x4
    800057a0:	0009b783          	ld	a5,0(s3)
    800057a4:	97ba                	add	a5,a5,a4
    800057a6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057aa:	854a                	mv	a0,s2
    800057ac:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057b0:	00000097          	auipc	ra,0x0
    800057b4:	c3a080e7          	jalr	-966(ra) # 800053ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057b8:	8885                	andi	s1,s1,1
    800057ba:	f0ed                	bnez	s1,8000579c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057bc:	0001e517          	auipc	a0,0x1e
    800057c0:	96c50513          	addi	a0,a0,-1684 # 80023128 <disk+0x2128>
    800057c4:	00001097          	auipc	ra,0x1
    800057c8:	05e080e7          	jalr	94(ra) # 80006822 <release>
}
    800057cc:	70a6                	ld	ra,104(sp)
    800057ce:	7406                	ld	s0,96(sp)
    800057d0:	64e6                	ld	s1,88(sp)
    800057d2:	6946                	ld	s2,80(sp)
    800057d4:	69a6                	ld	s3,72(sp)
    800057d6:	6a06                	ld	s4,64(sp)
    800057d8:	7ae2                	ld	s5,56(sp)
    800057da:	7b42                	ld	s6,48(sp)
    800057dc:	7ba2                	ld	s7,40(sp)
    800057de:	7c02                	ld	s8,32(sp)
    800057e0:	6ce2                	ld	s9,24(sp)
    800057e2:	6165                	addi	sp,sp,112
    800057e4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057e6:	f9042503          	lw	a0,-112(s0)
    800057ea:	00451613          	slli	a2,a0,0x4
  if(write)
    800057ee:	0001c597          	auipc	a1,0x1c
    800057f2:	81258593          	addi	a1,a1,-2030 # 80021000 <disk>
    800057f6:	20050793          	addi	a5,a0,512
    800057fa:	0792                	slli	a5,a5,0x4
    800057fc:	97ae                	add	a5,a5,a1
    800057fe:	01903733          	snez	a4,s9
    80005802:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005806:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000580a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000580e:	0001d717          	auipc	a4,0x1d
    80005812:	7f270713          	addi	a4,a4,2034 # 80023000 <disk+0x2000>
    80005816:	6314                	ld	a3,0(a4)
    80005818:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000581a:	6789                	lui	a5,0x2
    8000581c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005820:	97b2                	add	a5,a5,a2
    80005822:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005824:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005826:	631c                	ld	a5,0(a4)
    80005828:	97b2                	add	a5,a5,a2
    8000582a:	46c1                	li	a3,16
    8000582c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000582e:	631c                	ld	a5,0(a4)
    80005830:	97b2                	add	a5,a5,a2
    80005832:	4685                	li	a3,1
    80005834:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005838:	f9442783          	lw	a5,-108(s0)
    8000583c:	6314                	ld	a3,0(a4)
    8000583e:	96b2                	add	a3,a3,a2
    80005840:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005844:	0792                	slli	a5,a5,0x4
    80005846:	6314                	ld	a3,0(a4)
    80005848:	96be                	add	a3,a3,a5
    8000584a:	060a0593          	addi	a1,s4,96
    8000584e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005850:	6318                	ld	a4,0(a4)
    80005852:	973e                	add	a4,a4,a5
    80005854:	40000693          	li	a3,1024
    80005858:	c714                	sw	a3,8(a4)
  if(write)
    8000585a:	e40c97e3          	bnez	s9,800056a8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000585e:	0001d717          	auipc	a4,0x1d
    80005862:	7a273703          	ld	a4,1954(a4) # 80023000 <disk+0x2000>
    80005866:	973e                	add	a4,a4,a5
    80005868:	4689                	li	a3,2
    8000586a:	00d71623          	sh	a3,12(a4)
    8000586e:	b5a1                	j	800056b6 <virtio_disk_rw+0xd4>

0000000080005870 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005870:	1101                	addi	sp,sp,-32
    80005872:	ec06                	sd	ra,24(sp)
    80005874:	e822                	sd	s0,16(sp)
    80005876:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005878:	0001e517          	auipc	a0,0x1e
    8000587c:	8b050513          	addi	a0,a0,-1872 # 80023128 <disk+0x2128>
    80005880:	00001097          	auipc	ra,0x1
    80005884:	eda080e7          	jalr	-294(ra) # 8000675a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005888:	100017b7          	lui	a5,0x10001
    8000588c:	53b8                	lw	a4,96(a5)
    8000588e:	8b0d                	andi	a4,a4,3
    80005890:	100017b7          	lui	a5,0x10001
    80005894:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005896:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000589a:	0001d797          	auipc	a5,0x1d
    8000589e:	76678793          	addi	a5,a5,1894 # 80023000 <disk+0x2000>
    800058a2:	6b94                	ld	a3,16(a5)
    800058a4:	0207d703          	lhu	a4,32(a5)
    800058a8:	0026d783          	lhu	a5,2(a3)
    800058ac:	06f70563          	beq	a4,a5,80005916 <virtio_disk_intr+0xa6>
    800058b0:	e426                	sd	s1,8(sp)
    800058b2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058b4:	0001b917          	auipc	s2,0x1b
    800058b8:	74c90913          	addi	s2,s2,1868 # 80021000 <disk>
    800058bc:	0001d497          	auipc	s1,0x1d
    800058c0:	74448493          	addi	s1,s1,1860 # 80023000 <disk+0x2000>
    __sync_synchronize();
    800058c4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058c8:	6898                	ld	a4,16(s1)
    800058ca:	0204d783          	lhu	a5,32(s1)
    800058ce:	8b9d                	andi	a5,a5,7
    800058d0:	078e                	slli	a5,a5,0x3
    800058d2:	97ba                	add	a5,a5,a4
    800058d4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058d6:	20078713          	addi	a4,a5,512
    800058da:	0712                	slli	a4,a4,0x4
    800058dc:	974a                	add	a4,a4,s2
    800058de:	03074703          	lbu	a4,48(a4)
    800058e2:	e731                	bnez	a4,8000592e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058e4:	20078793          	addi	a5,a5,512
    800058e8:	0792                	slli	a5,a5,0x4
    800058ea:	97ca                	add	a5,a5,s2
    800058ec:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058ee:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058f2:	ffffc097          	auipc	ra,0xffffc
    800058f6:	efa080e7          	jalr	-262(ra) # 800017ec <wakeup>

    disk.used_idx += 1;
    800058fa:	0204d783          	lhu	a5,32(s1)
    800058fe:	2785                	addiw	a5,a5,1
    80005900:	17c2                	slli	a5,a5,0x30
    80005902:	93c1                	srli	a5,a5,0x30
    80005904:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005908:	6898                	ld	a4,16(s1)
    8000590a:	00275703          	lhu	a4,2(a4)
    8000590e:	faf71be3          	bne	a4,a5,800058c4 <virtio_disk_intr+0x54>
    80005912:	64a2                	ld	s1,8(sp)
    80005914:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005916:	0001e517          	auipc	a0,0x1e
    8000591a:	81250513          	addi	a0,a0,-2030 # 80023128 <disk+0x2128>
    8000591e:	00001097          	auipc	ra,0x1
    80005922:	f04080e7          	jalr	-252(ra) # 80006822 <release>
}
    80005926:	60e2                	ld	ra,24(sp)
    80005928:	6442                	ld	s0,16(sp)
    8000592a:	6105                	addi	sp,sp,32
    8000592c:	8082                	ret
      panic("virtio_disk_intr status");
    8000592e:	00003517          	auipc	a0,0x3
    80005932:	d3a50513          	addi	a0,a0,-710 # 80008668 <etext+0x668>
    80005936:	00001097          	auipc	ra,0x1
    8000593a:	8c0080e7          	jalr	-1856(ra) # 800061f6 <panic>

000000008000593e <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    8000593e:	1141                	addi	sp,sp,-16
    80005940:	e422                	sd	s0,8(sp)
    80005942:	0800                	addi	s0,sp,16
  return -1;
}
    80005944:	557d                	li	a0,-1
    80005946:	6422                	ld	s0,8(sp)
    80005948:	0141                	addi	sp,sp,16
    8000594a:	8082                	ret

000000008000594c <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    8000594c:	7179                	addi	sp,sp,-48
    8000594e:	f406                	sd	ra,40(sp)
    80005950:	f022                	sd	s0,32(sp)
    80005952:	ec26                	sd	s1,24(sp)
    80005954:	e84a                	sd	s2,16(sp)
    80005956:	e44e                	sd	s3,8(sp)
    80005958:	1800                	addi	s0,sp,48
    8000595a:	892a                	mv	s2,a0
    8000595c:	89ae                	mv	s3,a1
    8000595e:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80005960:	0001e517          	auipc	a0,0x1e
    80005964:	6a050513          	addi	a0,a0,1696 # 80024000 <stats>
    80005968:	00001097          	auipc	ra,0x1
    8000596c:	df2080e7          	jalr	-526(ra) # 8000675a <acquire>

  if(stats.sz == 0) {
    80005970:	0001f797          	auipc	a5,0x1f
    80005974:	6b07a783          	lw	a5,1712(a5) # 80025020 <stats+0x1020>
    80005978:	cbbd                	beqz	a5,800059ee <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    8000597a:	0001f797          	auipc	a5,0x1f
    8000597e:	68678793          	addi	a5,a5,1670 # 80025000 <stats+0x1000>
    80005982:	53d8                	lw	a4,36(a5)
    80005984:	539c                	lw	a5,32(a5)
    80005986:	9f99                	subw	a5,a5,a4
    80005988:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    8000598c:	06d05f63          	blez	a3,80005a0a <statsread+0xbe>
    80005990:	e052                	sd	s4,0(sp)
    if(m > n)
    80005992:	8a3e                	mv	s4,a5
    80005994:	00d4d363          	bge	s1,a3,8000599a <statsread+0x4e>
    80005998:	8a26                	mv	s4,s1
    8000599a:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    8000599e:	86a6                	mv	a3,s1
    800059a0:	0001e617          	auipc	a2,0x1e
    800059a4:	68060613          	addi	a2,a2,1664 # 80024020 <stats+0x20>
    800059a8:	963a                	add	a2,a2,a4
    800059aa:	85ce                	mv	a1,s3
    800059ac:	854a                	mv	a0,s2
    800059ae:	ffffc097          	auipc	ra,0xffffc
    800059b2:	056080e7          	jalr	86(ra) # 80001a04 <either_copyout>
    800059b6:	57fd                	li	a5,-1
    800059b8:	06f50363          	beq	a0,a5,80005a1e <statsread+0xd2>
      stats.off += m;
    800059bc:	0001f717          	auipc	a4,0x1f
    800059c0:	64470713          	addi	a4,a4,1604 # 80025000 <stats+0x1000>
    800059c4:	535c                	lw	a5,36(a4)
    800059c6:	00fa07bb          	addw	a5,s4,a5
    800059ca:	d35c                	sw	a5,36(a4)
    800059cc:	6a02                	ld	s4,0(sp)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    800059ce:	0001e517          	auipc	a0,0x1e
    800059d2:	63250513          	addi	a0,a0,1586 # 80024000 <stats>
    800059d6:	00001097          	auipc	ra,0x1
    800059da:	e4c080e7          	jalr	-436(ra) # 80006822 <release>
  return m;
}
    800059de:	8526                	mv	a0,s1
    800059e0:	70a2                	ld	ra,40(sp)
    800059e2:	7402                	ld	s0,32(sp)
    800059e4:	64e2                	ld	s1,24(sp)
    800059e6:	6942                	ld	s2,16(sp)
    800059e8:	69a2                	ld	s3,8(sp)
    800059ea:	6145                	addi	sp,sp,48
    800059ec:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    800059ee:	6585                	lui	a1,0x1
    800059f0:	0001e517          	auipc	a0,0x1e
    800059f4:	63050513          	addi	a0,a0,1584 # 80024020 <stats+0x20>
    800059f8:	00001097          	auipc	ra,0x1
    800059fc:	fb2080e7          	jalr	-78(ra) # 800069aa <statslock>
    80005a00:	0001f797          	auipc	a5,0x1f
    80005a04:	62a7a023          	sw	a0,1568(a5) # 80025020 <stats+0x1020>
    80005a08:	bf8d                	j	8000597a <statsread+0x2e>
    stats.sz = 0;
    80005a0a:	0001f797          	auipc	a5,0x1f
    80005a0e:	5f678793          	addi	a5,a5,1526 # 80025000 <stats+0x1000>
    80005a12:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005a16:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005a1a:	54fd                	li	s1,-1
    80005a1c:	bf4d                	j	800059ce <statsread+0x82>
    80005a1e:	6a02                	ld	s4,0(sp)
    80005a20:	b77d                	j	800059ce <statsread+0x82>

0000000080005a22 <statsinit>:

void
statsinit(void)
{
    80005a22:	1141                	addi	sp,sp,-16
    80005a24:	e406                	sd	ra,8(sp)
    80005a26:	e022                	sd	s0,0(sp)
    80005a28:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005a2a:	00003597          	auipc	a1,0x3
    80005a2e:	c5658593          	addi	a1,a1,-938 # 80008680 <etext+0x680>
    80005a32:	0001e517          	auipc	a0,0x1e
    80005a36:	5ce50513          	addi	a0,a0,1486 # 80024000 <stats>
    80005a3a:	00001097          	auipc	ra,0x1
    80005a3e:	e94080e7          	jalr	-364(ra) # 800068ce <initlock>

  devsw[STATS].read = statsread;
    80005a42:	0001a797          	auipc	a5,0x1a
    80005a46:	25e78793          	addi	a5,a5,606 # 8001fca0 <devsw>
    80005a4a:	00000717          	auipc	a4,0x0
    80005a4e:	f0270713          	addi	a4,a4,-254 # 8000594c <statsread>
    80005a52:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005a54:	00000717          	auipc	a4,0x0
    80005a58:	eea70713          	addi	a4,a4,-278 # 8000593e <statswrite>
    80005a5c:	f798                	sd	a4,40(a5)
}
    80005a5e:	60a2                	ld	ra,8(sp)
    80005a60:	6402                	ld	s0,0(sp)
    80005a62:	0141                	addi	sp,sp,16
    80005a64:	8082                	ret

0000000080005a66 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005a66:	1101                	addi	sp,sp,-32
    80005a68:	ec22                	sd	s0,24(sp)
    80005a6a:	1000                	addi	s0,sp,32
    80005a6c:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005a6e:	c299                	beqz	a3,80005a74 <sprintint+0xe>
    80005a70:	0805c263          	bltz	a1,80005af4 <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    80005a74:	2581                	sext.w	a1,a1
    80005a76:	4301                	li	t1,0

  i = 0;
    80005a78:	fe040713          	addi	a4,s0,-32
    80005a7c:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005a7e:	2601                	sext.w	a2,a2
    80005a80:	00003697          	auipc	a3,0x3
    80005a84:	e0068693          	addi	a3,a3,-512 # 80008880 <digits>
    80005a88:	88aa                	mv	a7,a0
    80005a8a:	2505                	addiw	a0,a0,1
    80005a8c:	02c5f7bb          	remuw	a5,a1,a2
    80005a90:	1782                	slli	a5,a5,0x20
    80005a92:	9381                	srli	a5,a5,0x20
    80005a94:	97b6                	add	a5,a5,a3
    80005a96:	0007c783          	lbu	a5,0(a5)
    80005a9a:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005a9e:	0005879b          	sext.w	a5,a1
    80005aa2:	02c5d5bb          	divuw	a1,a1,a2
    80005aa6:	0705                	addi	a4,a4,1
    80005aa8:	fec7f0e3          	bgeu	a5,a2,80005a88 <sprintint+0x22>

  if(sign)
    80005aac:	00030b63          	beqz	t1,80005ac2 <sprintint+0x5c>
    buf[i++] = '-';
    80005ab0:	ff050793          	addi	a5,a0,-16
    80005ab4:	97a2                	add	a5,a5,s0
    80005ab6:	02d00713          	li	a4,45
    80005aba:	fee78823          	sb	a4,-16(a5)
    80005abe:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005ac2:	02a05d63          	blez	a0,80005afc <sprintint+0x96>
    80005ac6:	fe040793          	addi	a5,s0,-32
    80005aca:	00a78733          	add	a4,a5,a0
    80005ace:	87c2                	mv	a5,a6
    80005ad0:	00180613          	addi	a2,a6,1
    80005ad4:	fff5069b          	addiw	a3,a0,-1
    80005ad8:	1682                	slli	a3,a3,0x20
    80005ada:	9281                	srli	a3,a3,0x20
    80005adc:	9636                	add	a2,a2,a3
  *s = c;
    80005ade:	fff74683          	lbu	a3,-1(a4)
    80005ae2:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005ae6:	177d                	addi	a4,a4,-1
    80005ae8:	0785                	addi	a5,a5,1
    80005aea:	fec79ae3          	bne	a5,a2,80005ade <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005aee:	6462                	ld	s0,24(sp)
    80005af0:	6105                	addi	sp,sp,32
    80005af2:	8082                	ret
    x = -xx;
    80005af4:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005af8:	4305                	li	t1,1
    x = -xx;
    80005afa:	bfbd                	j	80005a78 <sprintint+0x12>
  while(--i >= 0)
    80005afc:	4501                	li	a0,0
    80005afe:	bfc5                	j	80005aee <sprintint+0x88>

0000000080005b00 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005b00:	7135                	addi	sp,sp,-160
    80005b02:	f486                	sd	ra,104(sp)
    80005b04:	f0a2                	sd	s0,96(sp)
    80005b06:	1880                	addi	s0,sp,112
    80005b08:	e414                	sd	a3,8(s0)
    80005b0a:	e818                	sd	a4,16(s0)
    80005b0c:	ec1c                	sd	a5,24(s0)
    80005b0e:	03043023          	sd	a6,32(s0)
    80005b12:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005b16:	ce15                	beqz	a2,80005b52 <snprintf+0x52>
    80005b18:	eca6                	sd	s1,88(sp)
    80005b1a:	e8ca                	sd	s2,80(sp)
    80005b1c:	e4ce                	sd	s3,72(sp)
    80005b1e:	fc56                	sd	s5,56(sp)
    80005b20:	f85a                	sd	s6,48(sp)
    80005b22:	8b2a                	mv	s6,a0
    80005b24:	8aae                	mv	s5,a1
    80005b26:	89b2                	mv	s3,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005b28:	00840793          	addi	a5,s0,8
    80005b2c:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005b30:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b32:	4901                	li	s2,0
    80005b34:	04b05063          	blez	a1,80005b74 <snprintf+0x74>
    80005b38:	e0d2                	sd	s4,64(sp)
    80005b3a:	f45e                	sd	s7,40(sp)
    80005b3c:	f062                	sd	s8,32(sp)
    80005b3e:	ec66                	sd	s9,24(sp)
    if(c != '%'){
    80005b40:	02500a13          	li	s4,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005b44:	07300b93          	li	s7,115
    80005b48:	07800c93          	li	s9,120
    80005b4c:	06400c13          	li	s8,100
    80005b50:	a825                	j	80005b88 <snprintf+0x88>
    80005b52:	eca6                	sd	s1,88(sp)
    80005b54:	e8ca                	sd	s2,80(sp)
    80005b56:	e4ce                	sd	s3,72(sp)
    80005b58:	e0d2                	sd	s4,64(sp)
    80005b5a:	fc56                	sd	s5,56(sp)
    80005b5c:	f85a                	sd	s6,48(sp)
    80005b5e:	f45e                	sd	s7,40(sp)
    80005b60:	f062                	sd	s8,32(sp)
    80005b62:	ec66                	sd	s9,24(sp)
    panic("null fmt");
    80005b64:	00003517          	auipc	a0,0x3
    80005b68:	b2c50513          	addi	a0,a0,-1236 # 80008690 <etext+0x690>
    80005b6c:	00000097          	auipc	ra,0x0
    80005b70:	68a080e7          	jalr	1674(ra) # 800061f6 <panic>
  int off = 0;
    80005b74:	4481                	li	s1,0
    80005b76:	a8d9                	j	80005c4c <snprintf+0x14c>
  *s = c;
    80005b78:	009b0733          	add	a4,s6,s1
    80005b7c:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b80:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b82:	2905                	addiw	s2,s2,1
    80005b84:	1354d563          	bge	s1,s5,80005cae <snprintf+0x1ae>
    80005b88:	012987b3          	add	a5,s3,s2
    80005b8c:	0007c783          	lbu	a5,0(a5)
    80005b90:	0007871b          	sext.w	a4,a5
    80005b94:	cff5                	beqz	a5,80005c90 <snprintf+0x190>
    if(c != '%'){
    80005b96:	ff4711e3          	bne	a4,s4,80005b78 <snprintf+0x78>
    c = fmt[++i] & 0xff;
    80005b9a:	2905                	addiw	s2,s2,1
    80005b9c:	012987b3          	add	a5,s3,s2
    80005ba0:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005ba4:	cbfd                	beqz	a5,80005c9a <snprintf+0x19a>
    switch(c){
    80005ba6:	05778c63          	beq	a5,s7,80005bfe <snprintf+0xfe>
    80005baa:	02fbe763          	bltu	s7,a5,80005bd8 <snprintf+0xd8>
    80005bae:	0d478063          	beq	a5,s4,80005c6e <snprintf+0x16e>
    80005bb2:	0d879463          	bne	a5,s8,80005c7a <snprintf+0x17a>
    case 'd':
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005bb6:	f9843783          	ld	a5,-104(s0)
    80005bba:	00878713          	addi	a4,a5,8
    80005bbe:	f8e43c23          	sd	a4,-104(s0)
    80005bc2:	4685                	li	a3,1
    80005bc4:	4629                	li	a2,10
    80005bc6:	438c                	lw	a1,0(a5)
    80005bc8:	009b0533          	add	a0,s6,s1
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	e9a080e7          	jalr	-358(ra) # 80005a66 <sprintint>
    80005bd4:	9ca9                	addw	s1,s1,a0
      break;
    80005bd6:	b775                	j	80005b82 <snprintf+0x82>
    switch(c){
    80005bd8:	0b979163          	bne	a5,s9,80005c7a <snprintf+0x17a>
    case 'x':
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005bdc:	f9843783          	ld	a5,-104(s0)
    80005be0:	00878713          	addi	a4,a5,8
    80005be4:	f8e43c23          	sd	a4,-104(s0)
    80005be8:	4685                	li	a3,1
    80005bea:	4641                	li	a2,16
    80005bec:	438c                	lw	a1,0(a5)
    80005bee:	009b0533          	add	a0,s6,s1
    80005bf2:	00000097          	auipc	ra,0x0
    80005bf6:	e74080e7          	jalr	-396(ra) # 80005a66 <sprintint>
    80005bfa:	9ca9                	addw	s1,s1,a0
      break;
    80005bfc:	b759                	j	80005b82 <snprintf+0x82>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    80005bfe:	f9843783          	ld	a5,-104(s0)
    80005c02:	00878713          	addi	a4,a5,8
    80005c06:	f8e43c23          	sd	a4,-104(s0)
    80005c0a:	6388                	ld	a0,0(a5)
    80005c0c:	c931                	beqz	a0,80005c60 <snprintf+0x160>
        s = "(null)";
      for(; *s && off < sz; s++)
    80005c0e:	00054703          	lbu	a4,0(a0)
    80005c12:	db25                	beqz	a4,80005b82 <snprintf+0x82>
    80005c14:	0954d863          	bge	s1,s5,80005ca4 <snprintf+0x1a4>
    80005c18:	009b06b3          	add	a3,s6,s1
    80005c1c:	409a863b          	subw	a2,s5,s1
    80005c20:	1602                	slli	a2,a2,0x20
    80005c22:	9201                	srli	a2,a2,0x20
    80005c24:	962a                	add	a2,a2,a0
    80005c26:	87aa                	mv	a5,a0
        off += sputc(buf+off, *s);
    80005c28:	0014859b          	addiw	a1,s1,1
    80005c2c:	9d89                	subw	a1,a1,a0
  *s = c;
    80005c2e:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005c32:	00f584bb          	addw	s1,a1,a5
      for(; *s && off < sz; s++)
    80005c36:	0785                	addi	a5,a5,1
    80005c38:	0007c703          	lbu	a4,0(a5)
    80005c3c:	d339                	beqz	a4,80005b82 <snprintf+0x82>
    80005c3e:	0685                	addi	a3,a3,1
    80005c40:	fec797e3          	bne	a5,a2,80005c2e <snprintf+0x12e>
    80005c44:	6a06                	ld	s4,64(sp)
    80005c46:	7ba2                	ld	s7,40(sp)
    80005c48:	7c02                	ld	s8,32(sp)
    80005c4a:	6ce2                	ld	s9,24(sp)
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005c4c:	8526                	mv	a0,s1
    80005c4e:	64e6                	ld	s1,88(sp)
    80005c50:	6946                	ld	s2,80(sp)
    80005c52:	69a6                	ld	s3,72(sp)
    80005c54:	7ae2                	ld	s5,56(sp)
    80005c56:	7b42                	ld	s6,48(sp)
    80005c58:	70a6                	ld	ra,104(sp)
    80005c5a:	7406                	ld	s0,96(sp)
    80005c5c:	610d                	addi	sp,sp,160
    80005c5e:	8082                	ret
      for(; *s && off < sz; s++)
    80005c60:	02800713          	li	a4,40
        s = "(null)";
    80005c64:	00003517          	auipc	a0,0x3
    80005c68:	a2450513          	addi	a0,a0,-1500 # 80008688 <etext+0x688>
    80005c6c:	b765                	j	80005c14 <snprintf+0x114>
  *s = c;
    80005c6e:	009b07b3          	add	a5,s6,s1
    80005c72:	01478023          	sb	s4,0(a5)
      off += sputc(buf+off, '%');
    80005c76:	2485                	addiw	s1,s1,1
      break;
    80005c78:	b729                	j	80005b82 <snprintf+0x82>
  *s = c;
    80005c7a:	009b0733          	add	a4,s6,s1
    80005c7e:	01470023          	sb	s4,0(a4)
      off += sputc(buf+off, c);
    80005c82:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005c86:	975a                	add	a4,a4,s6
    80005c88:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c8c:	2489                	addiw	s1,s1,2
      break;
    80005c8e:	bdd5                	j	80005b82 <snprintf+0x82>
    80005c90:	6a06                	ld	s4,64(sp)
    80005c92:	7ba2                	ld	s7,40(sp)
    80005c94:	7c02                	ld	s8,32(sp)
    80005c96:	6ce2                	ld	s9,24(sp)
    80005c98:	bf55                	j	80005c4c <snprintf+0x14c>
    80005c9a:	6a06                	ld	s4,64(sp)
    80005c9c:	7ba2                	ld	s7,40(sp)
    80005c9e:	7c02                	ld	s8,32(sp)
    80005ca0:	6ce2                	ld	s9,24(sp)
    80005ca2:	b76d                	j	80005c4c <snprintf+0x14c>
    80005ca4:	6a06                	ld	s4,64(sp)
    80005ca6:	7ba2                	ld	s7,40(sp)
    80005ca8:	7c02                	ld	s8,32(sp)
    80005caa:	6ce2                	ld	s9,24(sp)
    80005cac:	b745                	j	80005c4c <snprintf+0x14c>
    80005cae:	6a06                	ld	s4,64(sp)
    80005cb0:	7ba2                	ld	s7,40(sp)
    80005cb2:	7c02                	ld	s8,32(sp)
    80005cb4:	6ce2                	ld	s9,24(sp)
    80005cb6:	bf59                	j	80005c4c <snprintf+0x14c>

0000000080005cb8 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005cb8:	1141                	addi	sp,sp,-16
    80005cba:	e422                	sd	s0,8(sp)
    80005cbc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cbe:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005cc2:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005cc6:	0037979b          	slliw	a5,a5,0x3
    80005cca:	02004737          	lui	a4,0x2004
    80005cce:	97ba                	add	a5,a5,a4
    80005cd0:	0200c737          	lui	a4,0x200c
    80005cd4:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005cd6:	6318                	ld	a4,0(a4)
    80005cd8:	000f4637          	lui	a2,0xf4
    80005cdc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005ce0:	9732                	add	a4,a4,a2
    80005ce2:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005ce4:	00259693          	slli	a3,a1,0x2
    80005ce8:	96ae                	add	a3,a3,a1
    80005cea:	068e                	slli	a3,a3,0x3
    80005cec:	0001f717          	auipc	a4,0x1f
    80005cf0:	34470713          	addi	a4,a4,836 # 80025030 <timer_scratch>
    80005cf4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005cf6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005cf8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005cfa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005cfe:	fffff797          	auipc	a5,0xfffff
    80005d02:	62278793          	addi	a5,a5,1570 # 80005320 <timervec>
    80005d06:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d0a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005d0e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d12:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005d16:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005d1a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005d1e:	30479073          	csrw	mie,a5
}
    80005d22:	6422                	ld	s0,8(sp)
    80005d24:	0141                	addi	sp,sp,16
    80005d26:	8082                	ret

0000000080005d28 <start>:
{
    80005d28:	1141                	addi	sp,sp,-16
    80005d2a:	e406                	sd	ra,8(sp)
    80005d2c:	e022                	sd	s0,0(sp)
    80005d2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d30:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005d34:	7779                	lui	a4,0xffffe
    80005d36:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd05b7>
    80005d3a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005d3c:	6705                	lui	a4,0x1
    80005d3e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005d42:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d44:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005d48:	ffffa797          	auipc	a5,0xffffa
    80005d4c:	6de78793          	addi	a5,a5,1758 # 80000426 <main>
    80005d50:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005d54:	4781                	li	a5,0
    80005d56:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005d5a:	67c1                	lui	a5,0x10
    80005d5c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005d5e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005d62:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005d66:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005d6a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005d6e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005d72:	57fd                	li	a5,-1
    80005d74:	83a9                	srli	a5,a5,0xa
    80005d76:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005d7a:	47bd                	li	a5,15
    80005d7c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	f38080e7          	jalr	-200(ra) # 80005cb8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d88:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005d8c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005d8e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005d90:	30200073          	mret
}
    80005d94:	60a2                	ld	ra,8(sp)
    80005d96:	6402                	ld	s0,0(sp)
    80005d98:	0141                	addi	sp,sp,16
    80005d9a:	8082                	ret

0000000080005d9c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005d9c:	715d                	addi	sp,sp,-80
    80005d9e:	e486                	sd	ra,72(sp)
    80005da0:	e0a2                	sd	s0,64(sp)
    80005da2:	f84a                	sd	s2,48(sp)
    80005da4:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005da6:	04c05663          	blez	a2,80005df2 <consolewrite+0x56>
    80005daa:	fc26                	sd	s1,56(sp)
    80005dac:	f44e                	sd	s3,40(sp)
    80005dae:	f052                	sd	s4,32(sp)
    80005db0:	ec56                	sd	s5,24(sp)
    80005db2:	8a2a                	mv	s4,a0
    80005db4:	84ae                	mv	s1,a1
    80005db6:	89b2                	mv	s3,a2
    80005db8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005dba:	5afd                	li	s5,-1
    80005dbc:	4685                	li	a3,1
    80005dbe:	8626                	mv	a2,s1
    80005dc0:	85d2                	mv	a1,s4
    80005dc2:	fbf40513          	addi	a0,s0,-65
    80005dc6:	ffffc097          	auipc	ra,0xffffc
    80005dca:	c94080e7          	jalr	-876(ra) # 80001a5a <either_copyin>
    80005dce:	03550463          	beq	a0,s5,80005df6 <consolewrite+0x5a>
      break;
    uartputc(c);
    80005dd2:	fbf44503          	lbu	a0,-65(s0)
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	7de080e7          	jalr	2014(ra) # 800065b4 <uartputc>
  for(i = 0; i < n; i++){
    80005dde:	2905                	addiw	s2,s2,1
    80005de0:	0485                	addi	s1,s1,1
    80005de2:	fd299de3          	bne	s3,s2,80005dbc <consolewrite+0x20>
    80005de6:	894e                	mv	s2,s3
    80005de8:	74e2                	ld	s1,56(sp)
    80005dea:	79a2                	ld	s3,40(sp)
    80005dec:	7a02                	ld	s4,32(sp)
    80005dee:	6ae2                	ld	s5,24(sp)
    80005df0:	a039                	j	80005dfe <consolewrite+0x62>
    80005df2:	4901                	li	s2,0
    80005df4:	a029                	j	80005dfe <consolewrite+0x62>
    80005df6:	74e2                	ld	s1,56(sp)
    80005df8:	79a2                	ld	s3,40(sp)
    80005dfa:	7a02                	ld	s4,32(sp)
    80005dfc:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005dfe:	854a                	mv	a0,s2
    80005e00:	60a6                	ld	ra,72(sp)
    80005e02:	6406                	ld	s0,64(sp)
    80005e04:	7942                	ld	s2,48(sp)
    80005e06:	6161                	addi	sp,sp,80
    80005e08:	8082                	ret

0000000080005e0a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005e0a:	711d                	addi	sp,sp,-96
    80005e0c:	ec86                	sd	ra,88(sp)
    80005e0e:	e8a2                	sd	s0,80(sp)
    80005e10:	e4a6                	sd	s1,72(sp)
    80005e12:	e0ca                	sd	s2,64(sp)
    80005e14:	fc4e                	sd	s3,56(sp)
    80005e16:	f852                	sd	s4,48(sp)
    80005e18:	f456                	sd	s5,40(sp)
    80005e1a:	f05a                	sd	s6,32(sp)
    80005e1c:	1080                	addi	s0,sp,96
    80005e1e:	8aaa                	mv	s5,a0
    80005e20:	8a2e                	mv	s4,a1
    80005e22:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005e24:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005e28:	00027517          	auipc	a0,0x27
    80005e2c:	34850513          	addi	a0,a0,840 # 8002d170 <cons>
    80005e30:	00001097          	auipc	ra,0x1
    80005e34:	92a080e7          	jalr	-1750(ra) # 8000675a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005e38:	00027497          	auipc	s1,0x27
    80005e3c:	33848493          	addi	s1,s1,824 # 8002d170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005e40:	00027917          	auipc	s2,0x27
    80005e44:	3d090913          	addi	s2,s2,976 # 8002d210 <cons+0xa0>
  while(n > 0){
    80005e48:	0d305463          	blez	s3,80005f10 <consoleread+0x106>
    while(cons.r == cons.w){
    80005e4c:	0a04a783          	lw	a5,160(s1)
    80005e50:	0a44a703          	lw	a4,164(s1)
    80005e54:	0af71963          	bne	a4,a5,80005f06 <consoleread+0xfc>
      if(myproc()->killed){
    80005e58:	ffffb097          	auipc	ra,0xffffb
    80005e5c:	142080e7          	jalr	322(ra) # 80000f9a <myproc>
    80005e60:	591c                	lw	a5,48(a0)
    80005e62:	e7ad                	bnez	a5,80005ecc <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005e64:	85a6                	mv	a1,s1
    80005e66:	854a                	mv	a0,s2
    80005e68:	ffffb097          	auipc	ra,0xffffb
    80005e6c:	7f8080e7          	jalr	2040(ra) # 80001660 <sleep>
    while(cons.r == cons.w){
    80005e70:	0a04a783          	lw	a5,160(s1)
    80005e74:	0a44a703          	lw	a4,164(s1)
    80005e78:	fef700e3          	beq	a4,a5,80005e58 <consoleread+0x4e>
    80005e7c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005e7e:	00027717          	auipc	a4,0x27
    80005e82:	2f270713          	addi	a4,a4,754 # 8002d170 <cons>
    80005e86:	0017869b          	addiw	a3,a5,1
    80005e8a:	0ad72023          	sw	a3,160(a4)
    80005e8e:	07f7f693          	andi	a3,a5,127
    80005e92:	9736                	add	a4,a4,a3
    80005e94:	02074703          	lbu	a4,32(a4)
    80005e98:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005e9c:	4691                	li	a3,4
    80005e9e:	04db8a63          	beq	s7,a3,80005ef2 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005ea2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ea6:	4685                	li	a3,1
    80005ea8:	faf40613          	addi	a2,s0,-81
    80005eac:	85d2                	mv	a1,s4
    80005eae:	8556                	mv	a0,s5
    80005eb0:	ffffc097          	auipc	ra,0xffffc
    80005eb4:	b54080e7          	jalr	-1196(ra) # 80001a04 <either_copyout>
    80005eb8:	57fd                	li	a5,-1
    80005eba:	04f50a63          	beq	a0,a5,80005f0e <consoleread+0x104>
      break;

    dst++;
    80005ebe:	0a05                	addi	s4,s4,1
    --n;
    80005ec0:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005ec2:	47a9                	li	a5,10
    80005ec4:	06fb8163          	beq	s7,a5,80005f26 <consoleread+0x11c>
    80005ec8:	6be2                	ld	s7,24(sp)
    80005eca:	bfbd                	j	80005e48 <consoleread+0x3e>
        release(&cons.lock);
    80005ecc:	00027517          	auipc	a0,0x27
    80005ed0:	2a450513          	addi	a0,a0,676 # 8002d170 <cons>
    80005ed4:	00001097          	auipc	ra,0x1
    80005ed8:	94e080e7          	jalr	-1714(ra) # 80006822 <release>
        return -1;
    80005edc:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005ede:	60e6                	ld	ra,88(sp)
    80005ee0:	6446                	ld	s0,80(sp)
    80005ee2:	64a6                	ld	s1,72(sp)
    80005ee4:	6906                	ld	s2,64(sp)
    80005ee6:	79e2                	ld	s3,56(sp)
    80005ee8:	7a42                	ld	s4,48(sp)
    80005eea:	7aa2                	ld	s5,40(sp)
    80005eec:	7b02                	ld	s6,32(sp)
    80005eee:	6125                	addi	sp,sp,96
    80005ef0:	8082                	ret
      if(n < target){
    80005ef2:	0009871b          	sext.w	a4,s3
    80005ef6:	01677a63          	bgeu	a4,s6,80005f0a <consoleread+0x100>
        cons.r--;
    80005efa:	00027717          	auipc	a4,0x27
    80005efe:	30f72b23          	sw	a5,790(a4) # 8002d210 <cons+0xa0>
    80005f02:	6be2                	ld	s7,24(sp)
    80005f04:	a031                	j	80005f10 <consoleread+0x106>
    80005f06:	ec5e                	sd	s7,24(sp)
    80005f08:	bf9d                	j	80005e7e <consoleread+0x74>
    80005f0a:	6be2                	ld	s7,24(sp)
    80005f0c:	a011                	j	80005f10 <consoleread+0x106>
    80005f0e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005f10:	00027517          	auipc	a0,0x27
    80005f14:	26050513          	addi	a0,a0,608 # 8002d170 <cons>
    80005f18:	00001097          	auipc	ra,0x1
    80005f1c:	90a080e7          	jalr	-1782(ra) # 80006822 <release>
  return target - n;
    80005f20:	413b053b          	subw	a0,s6,s3
    80005f24:	bf6d                	j	80005ede <consoleread+0xd4>
    80005f26:	6be2                	ld	s7,24(sp)
    80005f28:	b7e5                	j	80005f10 <consoleread+0x106>

0000000080005f2a <consputc>:
{
    80005f2a:	1141                	addi	sp,sp,-16
    80005f2c:	e406                	sd	ra,8(sp)
    80005f2e:	e022                	sd	s0,0(sp)
    80005f30:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005f32:	10000793          	li	a5,256
    80005f36:	00f50a63          	beq	a0,a5,80005f4a <consputc+0x20>
    uartputc_sync(c);
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	59c080e7          	jalr	1436(ra) # 800064d6 <uartputc_sync>
}
    80005f42:	60a2                	ld	ra,8(sp)
    80005f44:	6402                	ld	s0,0(sp)
    80005f46:	0141                	addi	sp,sp,16
    80005f48:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005f4a:	4521                	li	a0,8
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	58a080e7          	jalr	1418(ra) # 800064d6 <uartputc_sync>
    80005f54:	02000513          	li	a0,32
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	57e080e7          	jalr	1406(ra) # 800064d6 <uartputc_sync>
    80005f60:	4521                	li	a0,8
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	574080e7          	jalr	1396(ra) # 800064d6 <uartputc_sync>
    80005f6a:	bfe1                	j	80005f42 <consputc+0x18>

0000000080005f6c <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005f6c:	1101                	addi	sp,sp,-32
    80005f6e:	ec06                	sd	ra,24(sp)
    80005f70:	e822                	sd	s0,16(sp)
    80005f72:	e426                	sd	s1,8(sp)
    80005f74:	1000                	addi	s0,sp,32
    80005f76:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005f78:	00027517          	auipc	a0,0x27
    80005f7c:	1f850513          	addi	a0,a0,504 # 8002d170 <cons>
    80005f80:	00000097          	auipc	ra,0x0
    80005f84:	7da080e7          	jalr	2010(ra) # 8000675a <acquire>

  switch(c){
    80005f88:	47d5                	li	a5,21
    80005f8a:	0af48563          	beq	s1,a5,80006034 <consoleintr+0xc8>
    80005f8e:	0297c963          	blt	a5,s1,80005fc0 <consoleintr+0x54>
    80005f92:	47a1                	li	a5,8
    80005f94:	0ef48c63          	beq	s1,a5,8000608c <consoleintr+0x120>
    80005f98:	47c1                	li	a5,16
    80005f9a:	10f49f63          	bne	s1,a5,800060b8 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005f9e:	ffffc097          	auipc	ra,0xffffc
    80005fa2:	b12080e7          	jalr	-1262(ra) # 80001ab0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005fa6:	00027517          	auipc	a0,0x27
    80005faa:	1ca50513          	addi	a0,a0,458 # 8002d170 <cons>
    80005fae:	00001097          	auipc	ra,0x1
    80005fb2:	874080e7          	jalr	-1932(ra) # 80006822 <release>
}
    80005fb6:	60e2                	ld	ra,24(sp)
    80005fb8:	6442                	ld	s0,16(sp)
    80005fba:	64a2                	ld	s1,8(sp)
    80005fbc:	6105                	addi	sp,sp,32
    80005fbe:	8082                	ret
  switch(c){
    80005fc0:	07f00793          	li	a5,127
    80005fc4:	0cf48463          	beq	s1,a5,8000608c <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fc8:	00027717          	auipc	a4,0x27
    80005fcc:	1a870713          	addi	a4,a4,424 # 8002d170 <cons>
    80005fd0:	0a872783          	lw	a5,168(a4)
    80005fd4:	0a072703          	lw	a4,160(a4)
    80005fd8:	9f99                	subw	a5,a5,a4
    80005fda:	07f00713          	li	a4,127
    80005fde:	fcf764e3          	bltu	a4,a5,80005fa6 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005fe2:	47b5                	li	a5,13
    80005fe4:	0cf48d63          	beq	s1,a5,800060be <consoleintr+0x152>
      consputc(c);
    80005fe8:	8526                	mv	a0,s1
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	f40080e7          	jalr	-192(ra) # 80005f2a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ff2:	00027797          	auipc	a5,0x27
    80005ff6:	17e78793          	addi	a5,a5,382 # 8002d170 <cons>
    80005ffa:	0a87a703          	lw	a4,168(a5)
    80005ffe:	0017069b          	addiw	a3,a4,1
    80006002:	0006861b          	sext.w	a2,a3
    80006006:	0ad7a423          	sw	a3,168(a5)
    8000600a:	07f77713          	andi	a4,a4,127
    8000600e:	97ba                	add	a5,a5,a4
    80006010:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006014:	47a9                	li	a5,10
    80006016:	0cf48b63          	beq	s1,a5,800060ec <consoleintr+0x180>
    8000601a:	4791                	li	a5,4
    8000601c:	0cf48863          	beq	s1,a5,800060ec <consoleintr+0x180>
    80006020:	00027797          	auipc	a5,0x27
    80006024:	1f07a783          	lw	a5,496(a5) # 8002d210 <cons+0xa0>
    80006028:	0807879b          	addiw	a5,a5,128
    8000602c:	f6f61de3          	bne	a2,a5,80005fa6 <consoleintr+0x3a>
    80006030:	863e                	mv	a2,a5
    80006032:	a86d                	j	800060ec <consoleintr+0x180>
    80006034:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80006036:	00027717          	auipc	a4,0x27
    8000603a:	13a70713          	addi	a4,a4,314 # 8002d170 <cons>
    8000603e:	0a872783          	lw	a5,168(a4)
    80006042:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006046:	00027497          	auipc	s1,0x27
    8000604a:	12a48493          	addi	s1,s1,298 # 8002d170 <cons>
    while(cons.e != cons.w &&
    8000604e:	4929                	li	s2,10
    80006050:	02f70a63          	beq	a4,a5,80006084 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006054:	37fd                	addiw	a5,a5,-1
    80006056:	07f7f713          	andi	a4,a5,127
    8000605a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000605c:	02074703          	lbu	a4,32(a4)
    80006060:	03270463          	beq	a4,s2,80006088 <consoleintr+0x11c>
      cons.e--;
    80006064:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80006068:	10000513          	li	a0,256
    8000606c:	00000097          	auipc	ra,0x0
    80006070:	ebe080e7          	jalr	-322(ra) # 80005f2a <consputc>
    while(cons.e != cons.w &&
    80006074:	0a84a783          	lw	a5,168(s1)
    80006078:	0a44a703          	lw	a4,164(s1)
    8000607c:	fcf71ce3          	bne	a4,a5,80006054 <consoleintr+0xe8>
    80006080:	6902                	ld	s2,0(sp)
    80006082:	b715                	j	80005fa6 <consoleintr+0x3a>
    80006084:	6902                	ld	s2,0(sp)
    80006086:	b705                	j	80005fa6 <consoleintr+0x3a>
    80006088:	6902                	ld	s2,0(sp)
    8000608a:	bf31                	j	80005fa6 <consoleintr+0x3a>
    if(cons.e != cons.w){
    8000608c:	00027717          	auipc	a4,0x27
    80006090:	0e470713          	addi	a4,a4,228 # 8002d170 <cons>
    80006094:	0a872783          	lw	a5,168(a4)
    80006098:	0a472703          	lw	a4,164(a4)
    8000609c:	f0f705e3          	beq	a4,a5,80005fa6 <consoleintr+0x3a>
      cons.e--;
    800060a0:	37fd                	addiw	a5,a5,-1
    800060a2:	00027717          	auipc	a4,0x27
    800060a6:	16f72b23          	sw	a5,374(a4) # 8002d218 <cons+0xa8>
      consputc(BACKSPACE);
    800060aa:	10000513          	li	a0,256
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	e7c080e7          	jalr	-388(ra) # 80005f2a <consputc>
    800060b6:	bdc5                	j	80005fa6 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800060b8:	ee0487e3          	beqz	s1,80005fa6 <consoleintr+0x3a>
    800060bc:	b731                	j	80005fc8 <consoleintr+0x5c>
      consputc(c);
    800060be:	4529                	li	a0,10
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	e6a080e7          	jalr	-406(ra) # 80005f2a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800060c8:	00027797          	auipc	a5,0x27
    800060cc:	0a878793          	addi	a5,a5,168 # 8002d170 <cons>
    800060d0:	0a87a703          	lw	a4,168(a5)
    800060d4:	0017069b          	addiw	a3,a4,1
    800060d8:	0006861b          	sext.w	a2,a3
    800060dc:	0ad7a423          	sw	a3,168(a5)
    800060e0:	07f77713          	andi	a4,a4,127
    800060e4:	97ba                	add	a5,a5,a4
    800060e6:	4729                	li	a4,10
    800060e8:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    800060ec:	00027797          	auipc	a5,0x27
    800060f0:	12c7a423          	sw	a2,296(a5) # 8002d214 <cons+0xa4>
        wakeup(&cons.r);
    800060f4:	00027517          	auipc	a0,0x27
    800060f8:	11c50513          	addi	a0,a0,284 # 8002d210 <cons+0xa0>
    800060fc:	ffffb097          	auipc	ra,0xffffb
    80006100:	6f0080e7          	jalr	1776(ra) # 800017ec <wakeup>
    80006104:	b54d                	j	80005fa6 <consoleintr+0x3a>

0000000080006106 <consoleinit>:

void
consoleinit(void)
{
    80006106:	1141                	addi	sp,sp,-16
    80006108:	e406                	sd	ra,8(sp)
    8000610a:	e022                	sd	s0,0(sp)
    8000610c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000610e:	00002597          	auipc	a1,0x2
    80006112:	59258593          	addi	a1,a1,1426 # 800086a0 <etext+0x6a0>
    80006116:	00027517          	auipc	a0,0x27
    8000611a:	05a50513          	addi	a0,a0,90 # 8002d170 <cons>
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	7b0080e7          	jalr	1968(ra) # 800068ce <initlock>

  uartinit();
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	354080e7          	jalr	852(ra) # 8000647a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000612e:	0001a797          	auipc	a5,0x1a
    80006132:	b7278793          	addi	a5,a5,-1166 # 8001fca0 <devsw>
    80006136:	00000717          	auipc	a4,0x0
    8000613a:	cd470713          	addi	a4,a4,-812 # 80005e0a <consoleread>
    8000613e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006140:	00000717          	auipc	a4,0x0
    80006144:	c5c70713          	addi	a4,a4,-932 # 80005d9c <consolewrite>
    80006148:	ef98                	sd	a4,24(a5)
}
    8000614a:	60a2                	ld	ra,8(sp)
    8000614c:	6402                	ld	s0,0(sp)
    8000614e:	0141                	addi	sp,sp,16
    80006150:	8082                	ret

0000000080006152 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006152:	7179                	addi	sp,sp,-48
    80006154:	f406                	sd	ra,40(sp)
    80006156:	f022                	sd	s0,32(sp)
    80006158:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000615a:	c219                	beqz	a2,80006160 <printint+0xe>
    8000615c:	08054963          	bltz	a0,800061ee <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006160:	2501                	sext.w	a0,a0
    80006162:	4881                	li	a7,0
    80006164:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006168:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000616a:	2581                	sext.w	a1,a1
    8000616c:	00002617          	auipc	a2,0x2
    80006170:	72c60613          	addi	a2,a2,1836 # 80008898 <digits>
    80006174:	883a                	mv	a6,a4
    80006176:	2705                	addiw	a4,a4,1
    80006178:	02b577bb          	remuw	a5,a0,a1
    8000617c:	1782                	slli	a5,a5,0x20
    8000617e:	9381                	srli	a5,a5,0x20
    80006180:	97b2                	add	a5,a5,a2
    80006182:	0007c783          	lbu	a5,0(a5)
    80006186:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000618a:	0005079b          	sext.w	a5,a0
    8000618e:	02b5553b          	divuw	a0,a0,a1
    80006192:	0685                	addi	a3,a3,1
    80006194:	feb7f0e3          	bgeu	a5,a1,80006174 <printint+0x22>

  if(sign)
    80006198:	00088c63          	beqz	a7,800061b0 <printint+0x5e>
    buf[i++] = '-';
    8000619c:	fe070793          	addi	a5,a4,-32
    800061a0:	00878733          	add	a4,a5,s0
    800061a4:	02d00793          	li	a5,45
    800061a8:	fef70823          	sb	a5,-16(a4)
    800061ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800061b0:	02e05b63          	blez	a4,800061e6 <printint+0x94>
    800061b4:	ec26                	sd	s1,24(sp)
    800061b6:	e84a                	sd	s2,16(sp)
    800061b8:	fd040793          	addi	a5,s0,-48
    800061bc:	00e784b3          	add	s1,a5,a4
    800061c0:	fff78913          	addi	s2,a5,-1
    800061c4:	993a                	add	s2,s2,a4
    800061c6:	377d                	addiw	a4,a4,-1
    800061c8:	1702                	slli	a4,a4,0x20
    800061ca:	9301                	srli	a4,a4,0x20
    800061cc:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800061d0:	fff4c503          	lbu	a0,-1(s1)
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	d56080e7          	jalr	-682(ra) # 80005f2a <consputc>
  while(--i >= 0)
    800061dc:	14fd                	addi	s1,s1,-1
    800061de:	ff2499e3          	bne	s1,s2,800061d0 <printint+0x7e>
    800061e2:	64e2                	ld	s1,24(sp)
    800061e4:	6942                	ld	s2,16(sp)
}
    800061e6:	70a2                	ld	ra,40(sp)
    800061e8:	7402                	ld	s0,32(sp)
    800061ea:	6145                	addi	sp,sp,48
    800061ec:	8082                	ret
    x = -xx;
    800061ee:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800061f2:	4885                	li	a7,1
    x = -xx;
    800061f4:	bf85                	j	80006164 <printint+0x12>

00000000800061f6 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800061f6:	1101                	addi	sp,sp,-32
    800061f8:	ec06                	sd	ra,24(sp)
    800061fa:	e822                	sd	s0,16(sp)
    800061fc:	e426                	sd	s1,8(sp)
    800061fe:	1000                	addi	s0,sp,32
    80006200:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006202:	00027797          	auipc	a5,0x27
    80006206:	0207af23          	sw	zero,62(a5) # 8002d240 <pr+0x20>
  printf("panic: ");
    8000620a:	00002517          	auipc	a0,0x2
    8000620e:	49e50513          	addi	a0,a0,1182 # 800086a8 <etext+0x6a8>
    80006212:	00000097          	auipc	ra,0x0
    80006216:	02e080e7          	jalr	46(ra) # 80006240 <printf>
  printf(s);
    8000621a:	8526                	mv	a0,s1
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	024080e7          	jalr	36(ra) # 80006240 <printf>
  printf("\n");
    80006224:	00002517          	auipc	a0,0x2
    80006228:	df450513          	addi	a0,a0,-524 # 80008018 <etext+0x18>
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	014080e7          	jalr	20(ra) # 80006240 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006234:	4785                	li	a5,1
    80006236:	00006717          	auipc	a4,0x6
    8000623a:	def72323          	sw	a5,-538(a4) # 8000c01c <panicked>
  for(;;)
    8000623e:	a001                	j	8000623e <panic+0x48>

0000000080006240 <printf>:
{
    80006240:	7131                	addi	sp,sp,-192
    80006242:	fc86                	sd	ra,120(sp)
    80006244:	f8a2                	sd	s0,112(sp)
    80006246:	e8d2                	sd	s4,80(sp)
    80006248:	f06a                	sd	s10,32(sp)
    8000624a:	0100                	addi	s0,sp,128
    8000624c:	8a2a                	mv	s4,a0
    8000624e:	e40c                	sd	a1,8(s0)
    80006250:	e810                	sd	a2,16(s0)
    80006252:	ec14                	sd	a3,24(s0)
    80006254:	f018                	sd	a4,32(s0)
    80006256:	f41c                	sd	a5,40(s0)
    80006258:	03043823          	sd	a6,48(s0)
    8000625c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006260:	00027d17          	auipc	s10,0x27
    80006264:	fe0d2d03          	lw	s10,-32(s10) # 8002d240 <pr+0x20>
  if(locking)
    80006268:	040d1463          	bnez	s10,800062b0 <printf+0x70>
  if (fmt == 0)
    8000626c:	040a0b63          	beqz	s4,800062c2 <printf+0x82>
  va_start(ap, fmt);
    80006270:	00840793          	addi	a5,s0,8
    80006274:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006278:	000a4503          	lbu	a0,0(s4)
    8000627c:	18050b63          	beqz	a0,80006412 <printf+0x1d2>
    80006280:	f4a6                	sd	s1,104(sp)
    80006282:	f0ca                	sd	s2,96(sp)
    80006284:	ecce                	sd	s3,88(sp)
    80006286:	e4d6                	sd	s5,72(sp)
    80006288:	e0da                	sd	s6,64(sp)
    8000628a:	fc5e                	sd	s7,56(sp)
    8000628c:	f862                	sd	s8,48(sp)
    8000628e:	f466                	sd	s9,40(sp)
    80006290:	ec6e                	sd	s11,24(sp)
    80006292:	4981                	li	s3,0
    if(c != '%'){
    80006294:	02500b13          	li	s6,37
    switch(c){
    80006298:	07000b93          	li	s7,112
  consputc('x');
    8000629c:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000629e:	00002a97          	auipc	s5,0x2
    800062a2:	5faa8a93          	addi	s5,s5,1530 # 80008898 <digits>
    switch(c){
    800062a6:	07300c13          	li	s8,115
    800062aa:	06400d93          	li	s11,100
    800062ae:	a0b1                	j	800062fa <printf+0xba>
    acquire(&pr.lock);
    800062b0:	00027517          	auipc	a0,0x27
    800062b4:	f7050513          	addi	a0,a0,-144 # 8002d220 <pr>
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	4a2080e7          	jalr	1186(ra) # 8000675a <acquire>
    800062c0:	b775                	j	8000626c <printf+0x2c>
    800062c2:	f4a6                	sd	s1,104(sp)
    800062c4:	f0ca                	sd	s2,96(sp)
    800062c6:	ecce                	sd	s3,88(sp)
    800062c8:	e4d6                	sd	s5,72(sp)
    800062ca:	e0da                	sd	s6,64(sp)
    800062cc:	fc5e                	sd	s7,56(sp)
    800062ce:	f862                	sd	s8,48(sp)
    800062d0:	f466                	sd	s9,40(sp)
    800062d2:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    800062d4:	00002517          	auipc	a0,0x2
    800062d8:	3bc50513          	addi	a0,a0,956 # 80008690 <etext+0x690>
    800062dc:	00000097          	auipc	ra,0x0
    800062e0:	f1a080e7          	jalr	-230(ra) # 800061f6 <panic>
      consputc(c);
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	c46080e7          	jalr	-954(ra) # 80005f2a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800062ec:	2985                	addiw	s3,s3,1
    800062ee:	013a07b3          	add	a5,s4,s3
    800062f2:	0007c503          	lbu	a0,0(a5)
    800062f6:	10050563          	beqz	a0,80006400 <printf+0x1c0>
    if(c != '%'){
    800062fa:	ff6515e3          	bne	a0,s6,800062e4 <printf+0xa4>
    c = fmt[++i] & 0xff;
    800062fe:	2985                	addiw	s3,s3,1
    80006300:	013a07b3          	add	a5,s4,s3
    80006304:	0007c783          	lbu	a5,0(a5)
    80006308:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000630c:	10078b63          	beqz	a5,80006422 <printf+0x1e2>
    switch(c){
    80006310:	05778a63          	beq	a5,s7,80006364 <printf+0x124>
    80006314:	02fbf663          	bgeu	s7,a5,80006340 <printf+0x100>
    80006318:	09878863          	beq	a5,s8,800063a8 <printf+0x168>
    8000631c:	07800713          	li	a4,120
    80006320:	0ce79563          	bne	a5,a4,800063ea <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006324:	f8843783          	ld	a5,-120(s0)
    80006328:	00878713          	addi	a4,a5,8
    8000632c:	f8e43423          	sd	a4,-120(s0)
    80006330:	4605                	li	a2,1
    80006332:	85e6                	mv	a1,s9
    80006334:	4388                	lw	a0,0(a5)
    80006336:	00000097          	auipc	ra,0x0
    8000633a:	e1c080e7          	jalr	-484(ra) # 80006152 <printint>
      break;
    8000633e:	b77d                	j	800062ec <printf+0xac>
    switch(c){
    80006340:	09678f63          	beq	a5,s6,800063de <printf+0x19e>
    80006344:	0bb79363          	bne	a5,s11,800063ea <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80006348:	f8843783          	ld	a5,-120(s0)
    8000634c:	00878713          	addi	a4,a5,8
    80006350:	f8e43423          	sd	a4,-120(s0)
    80006354:	4605                	li	a2,1
    80006356:	45a9                	li	a1,10
    80006358:	4388                	lw	a0,0(a5)
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	df8080e7          	jalr	-520(ra) # 80006152 <printint>
      break;
    80006362:	b769                	j	800062ec <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006364:	f8843783          	ld	a5,-120(s0)
    80006368:	00878713          	addi	a4,a5,8
    8000636c:	f8e43423          	sd	a4,-120(s0)
    80006370:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006374:	03000513          	li	a0,48
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	bb2080e7          	jalr	-1102(ra) # 80005f2a <consputc>
  consputc('x');
    80006380:	07800513          	li	a0,120
    80006384:	00000097          	auipc	ra,0x0
    80006388:	ba6080e7          	jalr	-1114(ra) # 80005f2a <consputc>
    8000638c:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000638e:	03c95793          	srli	a5,s2,0x3c
    80006392:	97d6                	add	a5,a5,s5
    80006394:	0007c503          	lbu	a0,0(a5)
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	b92080e7          	jalr	-1134(ra) # 80005f2a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800063a0:	0912                	slli	s2,s2,0x4
    800063a2:	34fd                	addiw	s1,s1,-1
    800063a4:	f4ed                	bnez	s1,8000638e <printf+0x14e>
    800063a6:	b799                	j	800062ec <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800063a8:	f8843783          	ld	a5,-120(s0)
    800063ac:	00878713          	addi	a4,a5,8
    800063b0:	f8e43423          	sd	a4,-120(s0)
    800063b4:	6384                	ld	s1,0(a5)
    800063b6:	cc89                	beqz	s1,800063d0 <printf+0x190>
      for(; *s; s++)
    800063b8:	0004c503          	lbu	a0,0(s1)
    800063bc:	d905                	beqz	a0,800062ec <printf+0xac>
        consputc(*s);
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	b6c080e7          	jalr	-1172(ra) # 80005f2a <consputc>
      for(; *s; s++)
    800063c6:	0485                	addi	s1,s1,1
    800063c8:	0004c503          	lbu	a0,0(s1)
    800063cc:	f96d                	bnez	a0,800063be <printf+0x17e>
    800063ce:	bf39                	j	800062ec <printf+0xac>
        s = "(null)";
    800063d0:	00002497          	auipc	s1,0x2
    800063d4:	2b848493          	addi	s1,s1,696 # 80008688 <etext+0x688>
      for(; *s; s++)
    800063d8:	02800513          	li	a0,40
    800063dc:	b7cd                	j	800063be <printf+0x17e>
      consputc('%');
    800063de:	855a                	mv	a0,s6
    800063e0:	00000097          	auipc	ra,0x0
    800063e4:	b4a080e7          	jalr	-1206(ra) # 80005f2a <consputc>
      break;
    800063e8:	b711                	j	800062ec <printf+0xac>
      consputc('%');
    800063ea:	855a                	mv	a0,s6
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	b3e080e7          	jalr	-1218(ra) # 80005f2a <consputc>
      consputc(c);
    800063f4:	8526                	mv	a0,s1
    800063f6:	00000097          	auipc	ra,0x0
    800063fa:	b34080e7          	jalr	-1228(ra) # 80005f2a <consputc>
      break;
    800063fe:	b5fd                	j	800062ec <printf+0xac>
    80006400:	74a6                	ld	s1,104(sp)
    80006402:	7906                	ld	s2,96(sp)
    80006404:	69e6                	ld	s3,88(sp)
    80006406:	6aa6                	ld	s5,72(sp)
    80006408:	6b06                	ld	s6,64(sp)
    8000640a:	7be2                	ld	s7,56(sp)
    8000640c:	7c42                	ld	s8,48(sp)
    8000640e:	7ca2                	ld	s9,40(sp)
    80006410:	6de2                	ld	s11,24(sp)
  if(locking)
    80006412:	020d1263          	bnez	s10,80006436 <printf+0x1f6>
}
    80006416:	70e6                	ld	ra,120(sp)
    80006418:	7446                	ld	s0,112(sp)
    8000641a:	6a46                	ld	s4,80(sp)
    8000641c:	7d02                	ld	s10,32(sp)
    8000641e:	6129                	addi	sp,sp,192
    80006420:	8082                	ret
    80006422:	74a6                	ld	s1,104(sp)
    80006424:	7906                	ld	s2,96(sp)
    80006426:	69e6                	ld	s3,88(sp)
    80006428:	6aa6                	ld	s5,72(sp)
    8000642a:	6b06                	ld	s6,64(sp)
    8000642c:	7be2                	ld	s7,56(sp)
    8000642e:	7c42                	ld	s8,48(sp)
    80006430:	7ca2                	ld	s9,40(sp)
    80006432:	6de2                	ld	s11,24(sp)
    80006434:	bff9                	j	80006412 <printf+0x1d2>
    release(&pr.lock);
    80006436:	00027517          	auipc	a0,0x27
    8000643a:	dea50513          	addi	a0,a0,-534 # 8002d220 <pr>
    8000643e:	00000097          	auipc	ra,0x0
    80006442:	3e4080e7          	jalr	996(ra) # 80006822 <release>
}
    80006446:	bfc1                	j	80006416 <printf+0x1d6>

0000000080006448 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006448:	1101                	addi	sp,sp,-32
    8000644a:	ec06                	sd	ra,24(sp)
    8000644c:	e822                	sd	s0,16(sp)
    8000644e:	e426                	sd	s1,8(sp)
    80006450:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006452:	00027497          	auipc	s1,0x27
    80006456:	dce48493          	addi	s1,s1,-562 # 8002d220 <pr>
    8000645a:	00002597          	auipc	a1,0x2
    8000645e:	25658593          	addi	a1,a1,598 # 800086b0 <etext+0x6b0>
    80006462:	8526                	mv	a0,s1
    80006464:	00000097          	auipc	ra,0x0
    80006468:	46a080e7          	jalr	1130(ra) # 800068ce <initlock>
  pr.locking = 1;
    8000646c:	4785                	li	a5,1
    8000646e:	d09c                	sw	a5,32(s1)
}
    80006470:	60e2                	ld	ra,24(sp)
    80006472:	6442                	ld	s0,16(sp)
    80006474:	64a2                	ld	s1,8(sp)
    80006476:	6105                	addi	sp,sp,32
    80006478:	8082                	ret

000000008000647a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000647a:	1141                	addi	sp,sp,-16
    8000647c:	e406                	sd	ra,8(sp)
    8000647e:	e022                	sd	s0,0(sp)
    80006480:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006482:	100007b7          	lui	a5,0x10000
    80006486:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000648a:	10000737          	lui	a4,0x10000
    8000648e:	f8000693          	li	a3,-128
    80006492:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006496:	468d                	li	a3,3
    80006498:	10000637          	lui	a2,0x10000
    8000649c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800064a0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800064a4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800064a8:	10000737          	lui	a4,0x10000
    800064ac:	461d                	li	a2,7
    800064ae:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800064b2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800064b6:	00002597          	auipc	a1,0x2
    800064ba:	20258593          	addi	a1,a1,514 # 800086b8 <etext+0x6b8>
    800064be:	00027517          	auipc	a0,0x27
    800064c2:	d8a50513          	addi	a0,a0,-630 # 8002d248 <uart_tx_lock>
    800064c6:	00000097          	auipc	ra,0x0
    800064ca:	408080e7          	jalr	1032(ra) # 800068ce <initlock>
}
    800064ce:	60a2                	ld	ra,8(sp)
    800064d0:	6402                	ld	s0,0(sp)
    800064d2:	0141                	addi	sp,sp,16
    800064d4:	8082                	ret

00000000800064d6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800064d6:	1101                	addi	sp,sp,-32
    800064d8:	ec06                	sd	ra,24(sp)
    800064da:	e822                	sd	s0,16(sp)
    800064dc:	e426                	sd	s1,8(sp)
    800064de:	1000                	addi	s0,sp,32
    800064e0:	84aa                	mv	s1,a0
  push_off();
    800064e2:	00000097          	auipc	ra,0x0
    800064e6:	22c080e7          	jalr	556(ra) # 8000670e <push_off>

  if(panicked){
    800064ea:	00006797          	auipc	a5,0x6
    800064ee:	b327a783          	lw	a5,-1230(a5) # 8000c01c <panicked>
    800064f2:	eb85                	bnez	a5,80006522 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800064f4:	10000737          	lui	a4,0x10000
    800064f8:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800064fa:	00074783          	lbu	a5,0(a4)
    800064fe:	0207f793          	andi	a5,a5,32
    80006502:	dfe5                	beqz	a5,800064fa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006504:	0ff4f513          	zext.b	a0,s1
    80006508:	100007b7          	lui	a5,0x10000
    8000650c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006510:	00000097          	auipc	ra,0x0
    80006514:	2b2080e7          	jalr	690(ra) # 800067c2 <pop_off>
}
    80006518:	60e2                	ld	ra,24(sp)
    8000651a:	6442                	ld	s0,16(sp)
    8000651c:	64a2                	ld	s1,8(sp)
    8000651e:	6105                	addi	sp,sp,32
    80006520:	8082                	ret
    for(;;)
    80006522:	a001                	j	80006522 <uartputc_sync+0x4c>

0000000080006524 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006524:	00006797          	auipc	a5,0x6
    80006528:	afc7b783          	ld	a5,-1284(a5) # 8000c020 <uart_tx_r>
    8000652c:	00006717          	auipc	a4,0x6
    80006530:	afc73703          	ld	a4,-1284(a4) # 8000c028 <uart_tx_w>
    80006534:	06f70f63          	beq	a4,a5,800065b2 <uartstart+0x8e>
{
    80006538:	7139                	addi	sp,sp,-64
    8000653a:	fc06                	sd	ra,56(sp)
    8000653c:	f822                	sd	s0,48(sp)
    8000653e:	f426                	sd	s1,40(sp)
    80006540:	f04a                	sd	s2,32(sp)
    80006542:	ec4e                	sd	s3,24(sp)
    80006544:	e852                	sd	s4,16(sp)
    80006546:	e456                	sd	s5,8(sp)
    80006548:	e05a                	sd	s6,0(sp)
    8000654a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000654c:	10000937          	lui	s2,0x10000
    80006550:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006552:	00027a97          	auipc	s5,0x27
    80006556:	cf6a8a93          	addi	s5,s5,-778 # 8002d248 <uart_tx_lock>
    uart_tx_r += 1;
    8000655a:	00006497          	auipc	s1,0x6
    8000655e:	ac648493          	addi	s1,s1,-1338 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006562:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006566:	00006997          	auipc	s3,0x6
    8000656a:	ac298993          	addi	s3,s3,-1342 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000656e:	00094703          	lbu	a4,0(s2)
    80006572:	02077713          	andi	a4,a4,32
    80006576:	c705                	beqz	a4,8000659e <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006578:	01f7f713          	andi	a4,a5,31
    8000657c:	9756                	add	a4,a4,s5
    8000657e:	02074b03          	lbu	s6,32(a4)
    uart_tx_r += 1;
    80006582:	0785                	addi	a5,a5,1
    80006584:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006586:	8526                	mv	a0,s1
    80006588:	ffffb097          	auipc	ra,0xffffb
    8000658c:	264080e7          	jalr	612(ra) # 800017ec <wakeup>
    WriteReg(THR, c);
    80006590:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006594:	609c                	ld	a5,0(s1)
    80006596:	0009b703          	ld	a4,0(s3)
    8000659a:	fcf71ae3          	bne	a4,a5,8000656e <uartstart+0x4a>
  }
}
    8000659e:	70e2                	ld	ra,56(sp)
    800065a0:	7442                	ld	s0,48(sp)
    800065a2:	74a2                	ld	s1,40(sp)
    800065a4:	7902                	ld	s2,32(sp)
    800065a6:	69e2                	ld	s3,24(sp)
    800065a8:	6a42                	ld	s4,16(sp)
    800065aa:	6aa2                	ld	s5,8(sp)
    800065ac:	6b02                	ld	s6,0(sp)
    800065ae:	6121                	addi	sp,sp,64
    800065b0:	8082                	ret
    800065b2:	8082                	ret

00000000800065b4 <uartputc>:
{
    800065b4:	7179                	addi	sp,sp,-48
    800065b6:	f406                	sd	ra,40(sp)
    800065b8:	f022                	sd	s0,32(sp)
    800065ba:	e052                	sd	s4,0(sp)
    800065bc:	1800                	addi	s0,sp,48
    800065be:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800065c0:	00027517          	auipc	a0,0x27
    800065c4:	c8850513          	addi	a0,a0,-888 # 8002d248 <uart_tx_lock>
    800065c8:	00000097          	auipc	ra,0x0
    800065cc:	192080e7          	jalr	402(ra) # 8000675a <acquire>
  if(panicked){
    800065d0:	00006797          	auipc	a5,0x6
    800065d4:	a4c7a783          	lw	a5,-1460(a5) # 8000c01c <panicked>
    800065d8:	c391                	beqz	a5,800065dc <uartputc+0x28>
    for(;;)
    800065da:	a001                	j	800065da <uartputc+0x26>
    800065dc:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065de:	00006717          	auipc	a4,0x6
    800065e2:	a4a73703          	ld	a4,-1462(a4) # 8000c028 <uart_tx_w>
    800065e6:	00006797          	auipc	a5,0x6
    800065ea:	a3a7b783          	ld	a5,-1478(a5) # 8000c020 <uart_tx_r>
    800065ee:	02078793          	addi	a5,a5,32
    800065f2:	02e79f63          	bne	a5,a4,80006630 <uartputc+0x7c>
    800065f6:	e84a                	sd	s2,16(sp)
    800065f8:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800065fa:	00027997          	auipc	s3,0x27
    800065fe:	c4e98993          	addi	s3,s3,-946 # 8002d248 <uart_tx_lock>
    80006602:	00006497          	auipc	s1,0x6
    80006606:	a1e48493          	addi	s1,s1,-1506 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000660a:	00006917          	auipc	s2,0x6
    8000660e:	a1e90913          	addi	s2,s2,-1506 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006612:	85ce                	mv	a1,s3
    80006614:	8526                	mv	a0,s1
    80006616:	ffffb097          	auipc	ra,0xffffb
    8000661a:	04a080e7          	jalr	74(ra) # 80001660 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000661e:	00093703          	ld	a4,0(s2)
    80006622:	609c                	ld	a5,0(s1)
    80006624:	02078793          	addi	a5,a5,32
    80006628:	fee785e3          	beq	a5,a4,80006612 <uartputc+0x5e>
    8000662c:	6942                	ld	s2,16(sp)
    8000662e:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006630:	00027497          	auipc	s1,0x27
    80006634:	c1848493          	addi	s1,s1,-1000 # 8002d248 <uart_tx_lock>
    80006638:	01f77793          	andi	a5,a4,31
    8000663c:	97a6                	add	a5,a5,s1
    8000663e:	03478023          	sb	s4,32(a5)
      uart_tx_w += 1;
    80006642:	0705                	addi	a4,a4,1
    80006644:	00006797          	auipc	a5,0x6
    80006648:	9ee7b223          	sd	a4,-1564(a5) # 8000c028 <uart_tx_w>
      uartstart();
    8000664c:	00000097          	auipc	ra,0x0
    80006650:	ed8080e7          	jalr	-296(ra) # 80006524 <uartstart>
      release(&uart_tx_lock);
    80006654:	8526                	mv	a0,s1
    80006656:	00000097          	auipc	ra,0x0
    8000665a:	1cc080e7          	jalr	460(ra) # 80006822 <release>
    8000665e:	64e2                	ld	s1,24(sp)
}
    80006660:	70a2                	ld	ra,40(sp)
    80006662:	7402                	ld	s0,32(sp)
    80006664:	6a02                	ld	s4,0(sp)
    80006666:	6145                	addi	sp,sp,48
    80006668:	8082                	ret

000000008000666a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000666a:	1141                	addi	sp,sp,-16
    8000666c:	e422                	sd	s0,8(sp)
    8000666e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006670:	100007b7          	lui	a5,0x10000
    80006674:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006676:	0007c783          	lbu	a5,0(a5)
    8000667a:	8b85                	andi	a5,a5,1
    8000667c:	cb81                	beqz	a5,8000668c <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000667e:	100007b7          	lui	a5,0x10000
    80006682:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006686:	6422                	ld	s0,8(sp)
    80006688:	0141                	addi	sp,sp,16
    8000668a:	8082                	ret
    return -1;
    8000668c:	557d                	li	a0,-1
    8000668e:	bfe5                	j	80006686 <uartgetc+0x1c>

0000000080006690 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006690:	1101                	addi	sp,sp,-32
    80006692:	ec06                	sd	ra,24(sp)
    80006694:	e822                	sd	s0,16(sp)
    80006696:	e426                	sd	s1,8(sp)
    80006698:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000669a:	54fd                	li	s1,-1
    8000669c:	a029                	j	800066a6 <uartintr+0x16>
      break;
    consoleintr(c);
    8000669e:	00000097          	auipc	ra,0x0
    800066a2:	8ce080e7          	jalr	-1842(ra) # 80005f6c <consoleintr>
    int c = uartgetc();
    800066a6:	00000097          	auipc	ra,0x0
    800066aa:	fc4080e7          	jalr	-60(ra) # 8000666a <uartgetc>
    if(c == -1)
    800066ae:	fe9518e3          	bne	a0,s1,8000669e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800066b2:	00027497          	auipc	s1,0x27
    800066b6:	b9648493          	addi	s1,s1,-1130 # 8002d248 <uart_tx_lock>
    800066ba:	8526                	mv	a0,s1
    800066bc:	00000097          	auipc	ra,0x0
    800066c0:	09e080e7          	jalr	158(ra) # 8000675a <acquire>
  uartstart();
    800066c4:	00000097          	auipc	ra,0x0
    800066c8:	e60080e7          	jalr	-416(ra) # 80006524 <uartstart>
  release(&uart_tx_lock);
    800066cc:	8526                	mv	a0,s1
    800066ce:	00000097          	auipc	ra,0x0
    800066d2:	154080e7          	jalr	340(ra) # 80006822 <release>
}
    800066d6:	60e2                	ld	ra,24(sp)
    800066d8:	6442                	ld	s0,16(sp)
    800066da:	64a2                	ld	s1,8(sp)
    800066dc:	6105                	addi	sp,sp,32
    800066de:	8082                	ret

00000000800066e0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800066e0:	411c                	lw	a5,0(a0)
    800066e2:	e399                	bnez	a5,800066e8 <holding+0x8>
    800066e4:	4501                	li	a0,0
  return r;
}
    800066e6:	8082                	ret
{
    800066e8:	1101                	addi	sp,sp,-32
    800066ea:	ec06                	sd	ra,24(sp)
    800066ec:	e822                	sd	s0,16(sp)
    800066ee:	e426                	sd	s1,8(sp)
    800066f0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800066f2:	6904                	ld	s1,16(a0)
    800066f4:	ffffb097          	auipc	ra,0xffffb
    800066f8:	88a080e7          	jalr	-1910(ra) # 80000f7e <mycpu>
    800066fc:	40a48533          	sub	a0,s1,a0
    80006700:	00153513          	seqz	a0,a0
}
    80006704:	60e2                	ld	ra,24(sp)
    80006706:	6442                	ld	s0,16(sp)
    80006708:	64a2                	ld	s1,8(sp)
    8000670a:	6105                	addi	sp,sp,32
    8000670c:	8082                	ret

000000008000670e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000670e:	1101                	addi	sp,sp,-32
    80006710:	ec06                	sd	ra,24(sp)
    80006712:	e822                	sd	s0,16(sp)
    80006714:	e426                	sd	s1,8(sp)
    80006716:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006718:	100024f3          	csrr	s1,sstatus
    8000671c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006720:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006722:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006726:	ffffb097          	auipc	ra,0xffffb
    8000672a:	858080e7          	jalr	-1960(ra) # 80000f7e <mycpu>
    8000672e:	5d3c                	lw	a5,120(a0)
    80006730:	cf89                	beqz	a5,8000674a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006732:	ffffb097          	auipc	ra,0xffffb
    80006736:	84c080e7          	jalr	-1972(ra) # 80000f7e <mycpu>
    8000673a:	5d3c                	lw	a5,120(a0)
    8000673c:	2785                	addiw	a5,a5,1
    8000673e:	dd3c                	sw	a5,120(a0)
}
    80006740:	60e2                	ld	ra,24(sp)
    80006742:	6442                	ld	s0,16(sp)
    80006744:	64a2                	ld	s1,8(sp)
    80006746:	6105                	addi	sp,sp,32
    80006748:	8082                	ret
    mycpu()->intena = old;
    8000674a:	ffffb097          	auipc	ra,0xffffb
    8000674e:	834080e7          	jalr	-1996(ra) # 80000f7e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006752:	8085                	srli	s1,s1,0x1
    80006754:	8885                	andi	s1,s1,1
    80006756:	dd64                	sw	s1,124(a0)
    80006758:	bfe9                	j	80006732 <push_off+0x24>

000000008000675a <acquire>:
{
    8000675a:	1101                	addi	sp,sp,-32
    8000675c:	ec06                	sd	ra,24(sp)
    8000675e:	e822                	sd	s0,16(sp)
    80006760:	e426                	sd	s1,8(sp)
    80006762:	1000                	addi	s0,sp,32
    80006764:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006766:	00000097          	auipc	ra,0x0
    8000676a:	fa8080e7          	jalr	-88(ra) # 8000670e <push_off>
  if(holding(lk))
    8000676e:	8526                	mv	a0,s1
    80006770:	00000097          	auipc	ra,0x0
    80006774:	f70080e7          	jalr	-144(ra) # 800066e0 <holding>
    80006778:	e901                	bnez	a0,80006788 <acquire+0x2e>
    __sync_fetch_and_add(&(lk->n), 1);
    8000677a:	4785                	li	a5,1
    8000677c:	01c48713          	addi	a4,s1,28
    80006780:	06f7202f          	amoadd.w.aqrl	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006784:	4705                	li	a4,1
    80006786:	a829                	j	800067a0 <acquire+0x46>
    panic("acquire");
    80006788:	00002517          	auipc	a0,0x2
    8000678c:	f3850513          	addi	a0,a0,-200 # 800086c0 <etext+0x6c0>
    80006790:	00000097          	auipc	ra,0x0
    80006794:	a66080e7          	jalr	-1434(ra) # 800061f6 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006798:	01848793          	addi	a5,s1,24
    8000679c:	06e7a02f          	amoadd.w.aqrl	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800067a0:	87ba                	mv	a5,a4
    800067a2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800067a6:	2781                	sext.w	a5,a5
    800067a8:	fbe5                	bnez	a5,80006798 <acquire+0x3e>
  __sync_synchronize();
    800067aa:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800067ae:	ffffa097          	auipc	ra,0xffffa
    800067b2:	7d0080e7          	jalr	2000(ra) # 80000f7e <mycpu>
    800067b6:	e888                	sd	a0,16(s1)
}
    800067b8:	60e2                	ld	ra,24(sp)
    800067ba:	6442                	ld	s0,16(sp)
    800067bc:	64a2                	ld	s1,8(sp)
    800067be:	6105                	addi	sp,sp,32
    800067c0:	8082                	ret

00000000800067c2 <pop_off>:

void
pop_off(void)
{
    800067c2:	1141                	addi	sp,sp,-16
    800067c4:	e406                	sd	ra,8(sp)
    800067c6:	e022                	sd	s0,0(sp)
    800067c8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800067ca:	ffffa097          	auipc	ra,0xffffa
    800067ce:	7b4080e7          	jalr	1972(ra) # 80000f7e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067d2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800067d6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800067d8:	e78d                	bnez	a5,80006802 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800067da:	5d3c                	lw	a5,120(a0)
    800067dc:	02f05b63          	blez	a5,80006812 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800067e0:	37fd                	addiw	a5,a5,-1
    800067e2:	0007871b          	sext.w	a4,a5
    800067e6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800067e8:	eb09                	bnez	a4,800067fa <pop_off+0x38>
    800067ea:	5d7c                	lw	a5,124(a0)
    800067ec:	c799                	beqz	a5,800067fa <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800067f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800067f6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800067fa:	60a2                	ld	ra,8(sp)
    800067fc:	6402                	ld	s0,0(sp)
    800067fe:	0141                	addi	sp,sp,16
    80006800:	8082                	ret
    panic("pop_off - interruptible");
    80006802:	00002517          	auipc	a0,0x2
    80006806:	ec650513          	addi	a0,a0,-314 # 800086c8 <etext+0x6c8>
    8000680a:	00000097          	auipc	ra,0x0
    8000680e:	9ec080e7          	jalr	-1556(ra) # 800061f6 <panic>
    panic("pop_off");
    80006812:	00002517          	auipc	a0,0x2
    80006816:	ece50513          	addi	a0,a0,-306 # 800086e0 <etext+0x6e0>
    8000681a:	00000097          	auipc	ra,0x0
    8000681e:	9dc080e7          	jalr	-1572(ra) # 800061f6 <panic>

0000000080006822 <release>:
{
    80006822:	1101                	addi	sp,sp,-32
    80006824:	ec06                	sd	ra,24(sp)
    80006826:	e822                	sd	s0,16(sp)
    80006828:	e426                	sd	s1,8(sp)
    8000682a:	1000                	addi	s0,sp,32
    8000682c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000682e:	00000097          	auipc	ra,0x0
    80006832:	eb2080e7          	jalr	-334(ra) # 800066e0 <holding>
    80006836:	c115                	beqz	a0,8000685a <release+0x38>
  lk->cpu = 0;
    80006838:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000683c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006840:	0310000f          	fence	rw,w
    80006844:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006848:	00000097          	auipc	ra,0x0
    8000684c:	f7a080e7          	jalr	-134(ra) # 800067c2 <pop_off>
}
    80006850:	60e2                	ld	ra,24(sp)
    80006852:	6442                	ld	s0,16(sp)
    80006854:	64a2                	ld	s1,8(sp)
    80006856:	6105                	addi	sp,sp,32
    80006858:	8082                	ret
    panic("release");
    8000685a:	00002517          	auipc	a0,0x2
    8000685e:	e8e50513          	addi	a0,a0,-370 # 800086e8 <etext+0x6e8>
    80006862:	00000097          	auipc	ra,0x0
    80006866:	994080e7          	jalr	-1644(ra) # 800061f6 <panic>

000000008000686a <freelock>:
{
    8000686a:	1101                	addi	sp,sp,-32
    8000686c:	ec06                	sd	ra,24(sp)
    8000686e:	e822                	sd	s0,16(sp)
    80006870:	e426                	sd	s1,8(sp)
    80006872:	1000                	addi	s0,sp,32
    80006874:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    80006876:	00027517          	auipc	a0,0x27
    8000687a:	a1250513          	addi	a0,a0,-1518 # 8002d288 <lock_locks>
    8000687e:	00000097          	auipc	ra,0x0
    80006882:	edc080e7          	jalr	-292(ra) # 8000675a <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006886:	00027717          	auipc	a4,0x27
    8000688a:	a2270713          	addi	a4,a4,-1502 # 8002d2a8 <locks>
    8000688e:	4781                	li	a5,0
    80006890:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006894:	6314                	ld	a3,0(a4)
    80006896:	00968763          	beq	a3,s1,800068a4 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    8000689a:	2785                	addiw	a5,a5,1
    8000689c:	0721                	addi	a4,a4,8
    8000689e:	fec79be3          	bne	a5,a2,80006894 <freelock+0x2a>
    800068a2:	a809                	j	800068b4 <freelock+0x4a>
      locks[i] = 0;
    800068a4:	078e                	slli	a5,a5,0x3
    800068a6:	00027717          	auipc	a4,0x27
    800068aa:	a0270713          	addi	a4,a4,-1534 # 8002d2a8 <locks>
    800068ae:	97ba                	add	a5,a5,a4
    800068b0:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    800068b4:	00027517          	auipc	a0,0x27
    800068b8:	9d450513          	addi	a0,a0,-1580 # 8002d288 <lock_locks>
    800068bc:	00000097          	auipc	ra,0x0
    800068c0:	f66080e7          	jalr	-154(ra) # 80006822 <release>
}
    800068c4:	60e2                	ld	ra,24(sp)
    800068c6:	6442                	ld	s0,16(sp)
    800068c8:	64a2                	ld	s1,8(sp)
    800068ca:	6105                	addi	sp,sp,32
    800068cc:	8082                	ret

00000000800068ce <initlock>:
{
    800068ce:	1101                	addi	sp,sp,-32
    800068d0:	ec06                	sd	ra,24(sp)
    800068d2:	e822                	sd	s0,16(sp)
    800068d4:	e426                	sd	s1,8(sp)
    800068d6:	1000                	addi	s0,sp,32
    800068d8:	84aa                	mv	s1,a0
  lk->name = name;
    800068da:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800068dc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800068e0:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800068e4:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    800068e8:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    800068ec:	00027517          	auipc	a0,0x27
    800068f0:	99c50513          	addi	a0,a0,-1636 # 8002d288 <lock_locks>
    800068f4:	00000097          	auipc	ra,0x0
    800068f8:	e66080e7          	jalr	-410(ra) # 8000675a <acquire>
  for (i = 0; i < NLOCK; i++) {
    800068fc:	00027717          	auipc	a4,0x27
    80006900:	9ac70713          	addi	a4,a4,-1620 # 8002d2a8 <locks>
    80006904:	4781                	li	a5,0
    80006906:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    8000690a:	6314                	ld	a3,0(a4)
    8000690c:	ce89                	beqz	a3,80006926 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    8000690e:	2785                	addiw	a5,a5,1
    80006910:	0721                	addi	a4,a4,8
    80006912:	fec79ce3          	bne	a5,a2,8000690a <initlock+0x3c>
  panic("findslot");
    80006916:	00002517          	auipc	a0,0x2
    8000691a:	dda50513          	addi	a0,a0,-550 # 800086f0 <etext+0x6f0>
    8000691e:	00000097          	auipc	ra,0x0
    80006922:	8d8080e7          	jalr	-1832(ra) # 800061f6 <panic>
      locks[i] = lk;
    80006926:	078e                	slli	a5,a5,0x3
    80006928:	00027717          	auipc	a4,0x27
    8000692c:	98070713          	addi	a4,a4,-1664 # 8002d2a8 <locks>
    80006930:	97ba                	add	a5,a5,a4
    80006932:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006934:	00027517          	auipc	a0,0x27
    80006938:	95450513          	addi	a0,a0,-1708 # 8002d288 <lock_locks>
    8000693c:	00000097          	auipc	ra,0x0
    80006940:	ee6080e7          	jalr	-282(ra) # 80006822 <release>
}
    80006944:	60e2                	ld	ra,24(sp)
    80006946:	6442                	ld	s0,16(sp)
    80006948:	64a2                	ld	s1,8(sp)
    8000694a:	6105                	addi	sp,sp,32
    8000694c:	8082                	ret

000000008000694e <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000694e:	1141                	addi	sp,sp,-16
    80006950:	e422                	sd	s0,8(sp)
    80006952:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006954:	0330000f          	fence	rw,rw
    80006958:	6108                	ld	a0,0(a0)
    8000695a:	0230000f          	fence	r,rw
  return val;
}
    8000695e:	6422                	ld	s0,8(sp)
    80006960:	0141                	addi	sp,sp,16
    80006962:	8082                	ret

0000000080006964 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006964:	1141                	addi	sp,sp,-16
    80006966:	e422                	sd	s0,8(sp)
    80006968:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000696a:	0330000f          	fence	rw,rw
    8000696e:	4108                	lw	a0,0(a0)
    80006970:	0230000f          	fence	r,rw
  return val;
}
    80006974:	2501                	sext.w	a0,a0
    80006976:	6422                	ld	s0,8(sp)
    80006978:	0141                	addi	sp,sp,16
    8000697a:	8082                	ret

000000008000697c <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000697c:	4e5c                	lw	a5,28(a2)
    8000697e:	00f04463          	bgtz	a5,80006986 <snprint_lock+0xa>
  int n = 0;
    80006982:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006984:	8082                	ret
{
    80006986:	1141                	addi	sp,sp,-16
    80006988:	e406                	sd	ra,8(sp)
    8000698a:	e022                	sd	s0,0(sp)
    8000698c:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    8000698e:	4e18                	lw	a4,24(a2)
    80006990:	6614                	ld	a3,8(a2)
    80006992:	00002617          	auipc	a2,0x2
    80006996:	d6e60613          	addi	a2,a2,-658 # 80008700 <etext+0x700>
    8000699a:	fffff097          	auipc	ra,0xfffff
    8000699e:	166080e7          	jalr	358(ra) # 80005b00 <snprintf>
}
    800069a2:	60a2                	ld	ra,8(sp)
    800069a4:	6402                	ld	s0,0(sp)
    800069a6:	0141                	addi	sp,sp,16
    800069a8:	8082                	ret

00000000800069aa <statslock>:

int
statslock(char *buf, int sz) {
    800069aa:	7159                	addi	sp,sp,-112
    800069ac:	f486                	sd	ra,104(sp)
    800069ae:	f0a2                	sd	s0,96(sp)
    800069b0:	eca6                	sd	s1,88(sp)
    800069b2:	e8ca                	sd	s2,80(sp)
    800069b4:	e4ce                	sd	s3,72(sp)
    800069b6:	e0d2                	sd	s4,64(sp)
    800069b8:	fc56                	sd	s5,56(sp)
    800069ba:	f85a                	sd	s6,48(sp)
    800069bc:	f45e                	sd	s7,40(sp)
    800069be:	f062                	sd	s8,32(sp)
    800069c0:	ec66                	sd	s9,24(sp)
    800069c2:	e86a                	sd	s10,16(sp)
    800069c4:	e46e                	sd	s11,8(sp)
    800069c6:	1880                	addi	s0,sp,112
    800069c8:	8aaa                	mv	s5,a0
    800069ca:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    800069cc:	00027517          	auipc	a0,0x27
    800069d0:	8bc50513          	addi	a0,a0,-1860 # 8002d288 <lock_locks>
    800069d4:	00000097          	auipc	ra,0x0
    800069d8:	d86080e7          	jalr	-634(ra) # 8000675a <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800069dc:	00002617          	auipc	a2,0x2
    800069e0:	d5460613          	addi	a2,a2,-684 # 80008730 <etext+0x730>
    800069e4:	85da                	mv	a1,s6
    800069e6:	8556                	mv	a0,s5
    800069e8:	fffff097          	auipc	ra,0xfffff
    800069ec:	118080e7          	jalr	280(ra) # 80005b00 <snprintf>
    800069f0:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    800069f2:	00027c97          	auipc	s9,0x27
    800069f6:	8b6c8c93          	addi	s9,s9,-1866 # 8002d2a8 <locks>
    800069fa:	00028c17          	auipc	s8,0x28
    800069fe:	84ec0c13          	addi	s8,s8,-1970 # 8002e248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a02:	84e6                	mv	s1,s9
  int tot = 0;
    80006a04:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a06:	00002b97          	auipc	s7,0x2
    80006a0a:	97ab8b93          	addi	s7,s7,-1670 # 80008380 <etext+0x380>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a0e:	00002d17          	auipc	s10,0x2
    80006a12:	d42d0d13          	addi	s10,s10,-702 # 80008750 <etext+0x750>
    80006a16:	a01d                	j	80006a3c <statslock+0x92>
      tot += locks[i]->nts;
    80006a18:	0009b603          	ld	a2,0(s3)
    80006a1c:	4e1c                	lw	a5,24(a2)
    80006a1e:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006a22:	412b05bb          	subw	a1,s6,s2
    80006a26:	012a8533          	add	a0,s5,s2
    80006a2a:	00000097          	auipc	ra,0x0
    80006a2e:	f52080e7          	jalr	-174(ra) # 8000697c <snprint_lock>
    80006a32:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006a36:	04a1                	addi	s1,s1,8
    80006a38:	05848763          	beq	s1,s8,80006a86 <statslock+0xdc>
    if(locks[i] == 0)
    80006a3c:	89a6                	mv	s3,s1
    80006a3e:	609c                	ld	a5,0(s1)
    80006a40:	c3b9                	beqz	a5,80006a86 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a42:	0087bd83          	ld	s11,8(a5)
    80006a46:	855e                	mv	a0,s7
    80006a48:	ffffa097          	auipc	ra,0xffffa
    80006a4c:	9b4080e7          	jalr	-1612(ra) # 800003fc <strlen>
    80006a50:	0005061b          	sext.w	a2,a0
    80006a54:	85de                	mv	a1,s7
    80006a56:	856e                	mv	a0,s11
    80006a58:	ffffa097          	auipc	ra,0xffffa
    80006a5c:	900080e7          	jalr	-1792(ra) # 80000358 <strncmp>
    80006a60:	dd45                	beqz	a0,80006a18 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a62:	609c                	ld	a5,0(s1)
    80006a64:	0087bd83          	ld	s11,8(a5)
    80006a68:	856a                	mv	a0,s10
    80006a6a:	ffffa097          	auipc	ra,0xffffa
    80006a6e:	992080e7          	jalr	-1646(ra) # 800003fc <strlen>
    80006a72:	0005061b          	sext.w	a2,a0
    80006a76:	85ea                	mv	a1,s10
    80006a78:	856e                	mv	a0,s11
    80006a7a:	ffffa097          	auipc	ra,0xffffa
    80006a7e:	8de080e7          	jalr	-1826(ra) # 80000358 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a82:	f955                	bnez	a0,80006a36 <statslock+0x8c>
    80006a84:	bf51                	j	80006a18 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006a86:	00002617          	auipc	a2,0x2
    80006a8a:	cd260613          	addi	a2,a2,-814 # 80008758 <etext+0x758>
    80006a8e:	412b05bb          	subw	a1,s6,s2
    80006a92:	012a8533          	add	a0,s5,s2
    80006a96:	fffff097          	auipc	ra,0xfffff
    80006a9a:	06a080e7          	jalr	106(ra) # 80005b00 <snprintf>
    80006a9e:	012509bb          	addw	s3,a0,s2
    80006aa2:	4b95                	li	s7,5
  int last = 100000000;
    80006aa4:	05f5e537          	lui	a0,0x5f5e
    80006aa8:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006aac:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006aae:	00026497          	auipc	s1,0x26
    80006ab2:	7fa48493          	addi	s1,s1,2042 # 8002d2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006ab6:	1f400913          	li	s2,500
    80006aba:	a891                	j	80006b0e <statslock+0x164>
    80006abc:	2705                	addiw	a4,a4,1
    80006abe:	06a1                	addi	a3,a3,8
    80006ac0:	03270063          	beq	a4,s2,80006ae0 <statslock+0x136>
      if(locks[i] == 0)
    80006ac4:	629c                	ld	a5,0(a3)
    80006ac6:	cf89                	beqz	a5,80006ae0 <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006ac8:	4f90                	lw	a2,24(a5)
    80006aca:	00359793          	slli	a5,a1,0x3
    80006ace:	97a6                	add	a5,a5,s1
    80006ad0:	639c                	ld	a5,0(a5)
    80006ad2:	4f9c                	lw	a5,24(a5)
    80006ad4:	fec7d4e3          	bge	a5,a2,80006abc <statslock+0x112>
    80006ad8:	fea652e3          	bge	a2,a0,80006abc <statslock+0x112>
        top = i;
    80006adc:	85ba                	mv	a1,a4
    80006ade:	bff9                	j	80006abc <statslock+0x112>
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006ae0:	058e                	slli	a1,a1,0x3
    80006ae2:	00b48d33          	add	s10,s1,a1
    80006ae6:	000d3603          	ld	a2,0(s10)
    80006aea:	413b05bb          	subw	a1,s6,s3
    80006aee:	013a8533          	add	a0,s5,s3
    80006af2:	00000097          	auipc	ra,0x0
    80006af6:	e8a080e7          	jalr	-374(ra) # 8000697c <snprint_lock>
    80006afa:	01350dbb          	addw	s11,a0,s3
    80006afe:	000d899b          	sext.w	s3,s11
    last = locks[top]->nts;
    80006b02:	000d3783          	ld	a5,0(s10)
    80006b06:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006b08:	3bfd                	addiw	s7,s7,-1
    80006b0a:	000b8663          	beqz	s7,80006b16 <statslock+0x16c>
  int tot = 0;
    80006b0e:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006b10:	8762                	mv	a4,s8
    int top = 0;
    80006b12:	85e2                	mv	a1,s8
    80006b14:	bf45                	j	80006ac4 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006b16:	86d2                	mv	a3,s4
    80006b18:	00002617          	auipc	a2,0x2
    80006b1c:	c6060613          	addi	a2,a2,-928 # 80008778 <etext+0x778>
    80006b20:	41bb05bb          	subw	a1,s6,s11
    80006b24:	013a8533          	add	a0,s5,s3
    80006b28:	fffff097          	auipc	ra,0xfffff
    80006b2c:	fd8080e7          	jalr	-40(ra) # 80005b00 <snprintf>
    80006b30:	00ad8dbb          	addw	s11,s11,a0
  release(&lock_locks);  
    80006b34:	00026517          	auipc	a0,0x26
    80006b38:	75450513          	addi	a0,a0,1876 # 8002d288 <lock_locks>
    80006b3c:	00000097          	auipc	ra,0x0
    80006b40:	ce6080e7          	jalr	-794(ra) # 80006822 <release>
  return n;
}
    80006b44:	856e                	mv	a0,s11
    80006b46:	70a6                	ld	ra,104(sp)
    80006b48:	7406                	ld	s0,96(sp)
    80006b4a:	64e6                	ld	s1,88(sp)
    80006b4c:	6946                	ld	s2,80(sp)
    80006b4e:	69a6                	ld	s3,72(sp)
    80006b50:	6a06                	ld	s4,64(sp)
    80006b52:	7ae2                	ld	s5,56(sp)
    80006b54:	7b42                	ld	s6,48(sp)
    80006b56:	7ba2                	ld	s7,40(sp)
    80006b58:	7c02                	ld	s8,32(sp)
    80006b5a:	6ce2                	ld	s9,24(sp)
    80006b5c:	6d42                	ld	s10,16(sp)
    80006b5e:	6da2                	ld	s11,8(sp)
    80006b60:	6165                	addi	sp,sp,112
    80006b62:	8082                	ret
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
