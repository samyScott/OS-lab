
user/_nettests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decode_qname>:
}

// Decode a DNS name
static void
decode_qname(char *qn)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  while(*qn != '\0') {
   6:	00054783          	lbu	a5,0(a0)
    int l = *qn;
   a:	0007861b          	sext.w	a2,a5
    if(l == 0)
      break;
    for(int i = 0; i < l; i++) {
   e:	4581                	li	a1,0
  10:	4885                	li	a7,1
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
  12:	02e00813          	li	a6,46
  while(*qn != '\0') {
  16:	ef81                	bnez	a5,2e <decode_qname+0x2e>
  }
}
  18:	6422                	ld	s0,8(sp)
  1a:	0141                	addi	sp,sp,16
  1c:	8082                	ret
    *qn++ = '.';
  1e:	0709                	addi	a4,a4,2
  20:	953a                	add	a0,a0,a4
  22:	01078023          	sb	a6,0(a5)
  while(*qn != '\0') {
  26:	0017c603          	lbu	a2,1(a5)
  2a:	d67d                	beqz	a2,18 <decode_qname+0x18>
    int l = *qn;
  2c:	2601                	sext.w	a2,a2
{
  2e:	87aa                	mv	a5,a0
    for(int i = 0; i < l; i++) {
  30:	872e                	mv	a4,a1
      *qn = *(qn+1);
  32:	0017c683          	lbu	a3,1(a5)
  36:	00d78023          	sb	a3,0(a5)
      qn++;
  3a:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
  3c:	2705                	addiw	a4,a4,1
  3e:	fec74ae3          	blt	a4,a2,32 <decode_qname+0x32>
  42:	fff6069b          	addiw	a3,a2,-1
  46:	1682                	slli	a3,a3,0x20
  48:	9281                	srli	a3,a3,0x20
  4a:	87c6                	mv	a5,a7
  4c:	00c05463          	blez	a2,54 <decode_qname+0x54>
  50:	00168793          	addi	a5,a3,1
  54:	97aa                	add	a5,a5,a0
    *qn++ = '.';
  56:	872e                	mv	a4,a1
  58:	fcc053e3          	blez	a2,1e <decode_qname+0x1e>
  5c:	8736                	mv	a4,a3
  5e:	b7c1                	j	1e <decode_qname+0x1e>

0000000000000060 <ping>:
{
  60:	7171                	addi	sp,sp,-176
  62:	f506                	sd	ra,168(sp)
  64:	f122                	sd	s0,160(sp)
  66:	ed26                	sd	s1,152(sp)
  68:	e94a                	sd	s2,144(sp)
  6a:	e54e                	sd	s3,136(sp)
  6c:	e152                	sd	s4,128(sp)
  6e:	1900                	addi	s0,sp,176
  70:	8a32                	mv	s4,a2
  if((fd = connect(dst, sport, dport)) < 0){
  72:	862e                	mv	a2,a1
  74:	85aa                	mv	a1,a0
  76:	0a000537          	lui	a0,0xa000
  7a:	20250513          	addi	a0,a0,514 # a000202 <__global_pointer$+0x9ffe879>
  7e:	00001097          	auipc	ra,0x1
  82:	a1a080e7          	jalr	-1510(ra) # a98 <connect>
  86:	08054563          	bltz	a0,110 <ping+0xb0>
  8a:	89aa                	mv	s3,a0
  for(int i = 0; i < attempts; i++) {
  8c:	4481                	li	s1,0
    if(write(fd, obuf, strlen(obuf)) < 0){
  8e:	00001917          	auipc	s2,0x1
  92:	eaa90913          	addi	s2,s2,-342 # f38 <malloc+0x102>
  for(int i = 0; i < attempts; i++) {
  96:	03405463          	blez	s4,be <ping+0x5e>
    if(write(fd, obuf, strlen(obuf)) < 0){
  9a:	854a                	mv	a0,s2
  9c:	00000097          	auipc	ra,0x0
  a0:	72e080e7          	jalr	1838(ra) # 7ca <strlen>
  a4:	0005061b          	sext.w	a2,a0
  a8:	85ca                	mv	a1,s2
  aa:	854e                	mv	a0,s3
  ac:	00001097          	auipc	ra,0x1
  b0:	96c080e7          	jalr	-1684(ra) # a18 <write>
  b4:	06054c63          	bltz	a0,12c <ping+0xcc>
  for(int i = 0; i < attempts; i++) {
  b8:	2485                	addiw	s1,s1,1
  ba:	fe9a10e3          	bne	s4,s1,9a <ping+0x3a>
  int cc = read(fd, ibuf, sizeof(ibuf)-1);
  be:	07f00613          	li	a2,127
  c2:	f5040593          	addi	a1,s0,-176
  c6:	854e                	mv	a0,s3
  c8:	00001097          	auipc	ra,0x1
  cc:	948080e7          	jalr	-1720(ra) # a10 <read>
  d0:	84aa                	mv	s1,a0
  if(cc < 0){
  d2:	06054b63          	bltz	a0,148 <ping+0xe8>
  close(fd);
  d6:	854e                	mv	a0,s3
  d8:	00001097          	auipc	ra,0x1
  dc:	948080e7          	jalr	-1720(ra) # a20 <close>
  ibuf[cc] = '\0';
  e0:	fd040793          	addi	a5,s0,-48
  e4:	94be                	add	s1,s1,a5
  e6:	f8048023          	sb	zero,-128(s1)
  if(strcmp(ibuf, "this is the host!") != 0){
  ea:	00001597          	auipc	a1,0x1
  ee:	e9658593          	addi	a1,a1,-362 # f80 <malloc+0x14a>
  f2:	f5040513          	addi	a0,s0,-176
  f6:	00000097          	auipc	ra,0x0
  fa:	6a8080e7          	jalr	1704(ra) # 79e <strcmp>
  fe:	e13d                	bnez	a0,164 <ping+0x104>
}
 100:	70aa                	ld	ra,168(sp)
 102:	740a                	ld	s0,160(sp)
 104:	64ea                	ld	s1,152(sp)
 106:	694a                	ld	s2,144(sp)
 108:	69aa                	ld	s3,136(sp)
 10a:	6a0a                	ld	s4,128(sp)
 10c:	614d                	addi	sp,sp,176
 10e:	8082                	ret
    fprintf(2, "ping: connect() failed\n");
 110:	00001597          	auipc	a1,0x1
 114:	e1058593          	addi	a1,a1,-496 # f20 <malloc+0xea>
 118:	4509                	li	a0,2
 11a:	00001097          	auipc	ra,0x1
 11e:	c30080e7          	jalr	-976(ra) # d4a <fprintf>
    exit(1);
 122:	4505                	li	a0,1
 124:	00001097          	auipc	ra,0x1
 128:	8d4080e7          	jalr	-1836(ra) # 9f8 <exit>
      fprintf(2, "ping: send() failed\n");
 12c:	00001597          	auipc	a1,0x1
 130:	e2458593          	addi	a1,a1,-476 # f50 <malloc+0x11a>
 134:	4509                	li	a0,2
 136:	00001097          	auipc	ra,0x1
 13a:	c14080e7          	jalr	-1004(ra) # d4a <fprintf>
      exit(1);
 13e:	4505                	li	a0,1
 140:	00001097          	auipc	ra,0x1
 144:	8b8080e7          	jalr	-1864(ra) # 9f8 <exit>
    fprintf(2, "ping: recv() failed\n");
 148:	00001597          	auipc	a1,0x1
 14c:	e2058593          	addi	a1,a1,-480 # f68 <malloc+0x132>
 150:	4509                	li	a0,2
 152:	00001097          	auipc	ra,0x1
 156:	bf8080e7          	jalr	-1032(ra) # d4a <fprintf>
    exit(1);
 15a:	4505                	li	a0,1
 15c:	00001097          	auipc	ra,0x1
 160:	89c080e7          	jalr	-1892(ra) # 9f8 <exit>
    fprintf(2, "ping didn't receive correct payload\n");
 164:	00001597          	auipc	a1,0x1
 168:	e3458593          	addi	a1,a1,-460 # f98 <malloc+0x162>
 16c:	4509                	li	a0,2
 16e:	00001097          	auipc	ra,0x1
 172:	bdc080e7          	jalr	-1060(ra) # d4a <fprintf>
    exit(1);
 176:	4505                	li	a0,1
 178:	00001097          	auipc	ra,0x1
 17c:	880080e7          	jalr	-1920(ra) # 9f8 <exit>

0000000000000180 <dns>:
  }
}

static void
dns()
{
 180:	7119                	addi	sp,sp,-128
 182:	fc86                	sd	ra,120(sp)
 184:	f8a2                	sd	s0,112(sp)
 186:	f4a6                	sd	s1,104(sp)
 188:	f0ca                	sd	s2,96(sp)
 18a:	ecce                	sd	s3,88(sp)
 18c:	e8d2                	sd	s4,80(sp)
 18e:	e4d6                	sd	s5,72(sp)
 190:	e0da                	sd	s6,64(sp)
 192:	fc5e                	sd	s7,56(sp)
 194:	f862                	sd	s8,48(sp)
 196:	f466                	sd	s9,40(sp)
 198:	f06a                	sd	s10,32(sp)
 19a:	ec6e                	sd	s11,24(sp)
 19c:	0100                	addi	s0,sp,128
 19e:	83010113          	addi	sp,sp,-2000
  uint8 ibuf[N];
  uint32 dst;
  int fd;
  int len;

  memset(obuf, 0, N);
 1a2:	3e800613          	li	a2,1000
 1a6:	4581                	li	a1,0
 1a8:	ba840513          	addi	a0,s0,-1112
 1ac:	00000097          	auipc	ra,0x0
 1b0:	648080e7          	jalr	1608(ra) # 7f4 <memset>
  memset(ibuf, 0, N);
 1b4:	3e800613          	li	a2,1000
 1b8:	4581                	li	a1,0
 1ba:	77fd                	lui	a5,0xfffff
 1bc:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffde37>
 1c0:	00f40533          	add	a0,s0,a5
 1c4:	00000097          	auipc	ra,0x0
 1c8:	630080e7          	jalr	1584(ra) # 7f4 <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  if((fd = connect(dst, 10000, 53)) < 0){
 1cc:	03500613          	li	a2,53
 1d0:	6589                	lui	a1,0x2
 1d2:	71058593          	addi	a1,a1,1808 # 2710 <__global_pointer$+0xd87>
 1d6:	08081537          	lui	a0,0x8081
 1da:	80850513          	addi	a0,a0,-2040 # 8080808 <__global_pointer$+0x807ee7f>
 1de:	00001097          	auipc	ra,0x1
 1e2:	8ba080e7          	jalr	-1862(ra) # a98 <connect>
 1e6:	02054d63          	bltz	a0,220 <dns+0xa0>
 1ea:	892a                	mv	s2,a0
  hdr->id = htons(6828);
 1ec:	77ed                	lui	a5,0xffffb
 1ee:	c1a7879b          	addiw	a5,a5,-998
 1f2:	baf41423          	sh	a5,-1112(s0)
  hdr->rd = 1;
 1f6:	baa45783          	lhu	a5,-1110(s0)
 1fa:	0017e793          	ori	a5,a5,1
 1fe:	baf41523          	sh	a5,-1110(s0)
  hdr->qdcount = htons(1);
 202:	10000793          	li	a5,256
 206:	baf41623          	sh	a5,-1108(s0)
  for(char *c = host; c < host+strlen(host)+1; c++) {
 20a:	00001497          	auipc	s1,0x1
 20e:	db648493          	addi	s1,s1,-586 # fc0 <malloc+0x18a>
  char *l = host; 
 212:	8a26                	mv	s4,s1
  for(char *c = host; c < host+strlen(host)+1; c++) {
 214:	bb440993          	addi	s3,s0,-1100
 218:	8aa6                	mv	s5,s1
    if(*c == '.') {
 21a:	02e00b13          	li	s6,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
 21e:	a01d                	j	244 <dns+0xc4>
    fprintf(2, "ping: connect() failed\n");
 220:	00001597          	auipc	a1,0x1
 224:	d0058593          	addi	a1,a1,-768 # f20 <malloc+0xea>
 228:	4509                	li	a0,2
 22a:	00001097          	auipc	ra,0x1
 22e:	b20080e7          	jalr	-1248(ra) # d4a <fprintf>
    exit(1);
 232:	4505                	li	a0,1
 234:	00000097          	auipc	ra,0x0
 238:	7c4080e7          	jalr	1988(ra) # 9f8 <exit>
      *qn++ = (char) (c-l);
 23c:	89b6                	mv	s3,a3
      l = c+1; // skip .
 23e:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
 242:	0485                	addi	s1,s1,1
 244:	8556                	mv	a0,s5
 246:	00000097          	auipc	ra,0x0
 24a:	584080e7          	jalr	1412(ra) # 7ca <strlen>
 24e:	1502                	slli	a0,a0,0x20
 250:	9101                	srli	a0,a0,0x20
 252:	0505                	addi	a0,a0,1
 254:	9556                	add	a0,a0,s5
 256:	02a4fc63          	bgeu	s1,a0,28e <dns+0x10e>
    if(*c == '.') {
 25a:	0004c783          	lbu	a5,0(s1)
 25e:	ff6792e3          	bne	a5,s6,242 <dns+0xc2>
      *qn++ = (char) (c-l);
 262:	00198693          	addi	a3,s3,1
 266:	414487b3          	sub	a5,s1,s4
 26a:	00f98023          	sb	a5,0(s3)
      for(char *d = l; d < c; d++) {
 26e:	fc9a77e3          	bgeu	s4,s1,23c <dns+0xbc>
 272:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
 274:	8736                	mv	a4,a3
        *qn++ = *d;
 276:	0705                	addi	a4,a4,1
 278:	0007c603          	lbu	a2,0(a5) # ffffffffffffb000 <__global_pointer$+0xffffffffffff9677>
 27c:	fec70fa3          	sb	a2,-1(a4)
      for(char *d = l; d < c; d++) {
 280:	0785                	addi	a5,a5,1
 282:	fef49ae3          	bne	s1,a5,276 <dns+0xf6>
 286:	414489b3          	sub	s3,s1,s4
 28a:	99b6                	add	s3,s3,a3
 28c:	bf4d                	j	23e <dns+0xbe>
  *qn = '\0';
 28e:	00098023          	sb	zero,0(s3)
  len += strlen(qname) + 1;
 292:	bb440513          	addi	a0,s0,-1100
 296:	00000097          	auipc	ra,0x0
 29a:	534080e7          	jalr	1332(ra) # 7ca <strlen>
 29e:	0005049b          	sext.w	s1,a0
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
 2a2:	bb440513          	addi	a0,s0,-1100
 2a6:	00000097          	auipc	ra,0x0
 2aa:	524080e7          	jalr	1316(ra) # 7ca <strlen>
 2ae:	02051793          	slli	a5,a0,0x20
 2b2:	9381                	srli	a5,a5,0x20
 2b4:	0785                	addi	a5,a5,1
 2b6:	bb440713          	addi	a4,s0,-1100
 2ba:	97ba                	add	a5,a5,a4
  h->qtype = htons(0x1);
 2bc:	00078023          	sb	zero,0(a5)
 2c0:	4705                	li	a4,1
 2c2:	00e780a3          	sb	a4,1(a5)
  h->qclass = htons(0x1);
 2c6:	00078123          	sb	zero,2(a5)
 2ca:	00e781a3          	sb	a4,3(a5)
  }

  len = dns_req(obuf);
  
  if(write(fd, obuf, len) < 0){
 2ce:	0114861b          	addiw	a2,s1,17
 2d2:	ba840593          	addi	a1,s0,-1112
 2d6:	854a                	mv	a0,s2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	740080e7          	jalr	1856(ra) # a18 <write>
 2e0:	12054463          	bltz	a0,408 <dns+0x288>
    fprintf(2, "dns: send() failed\n");
    exit(1);
  }
  int cc = read(fd, ibuf, sizeof(ibuf));
 2e4:	3e800613          	li	a2,1000
 2e8:	77fd                	lui	a5,0xfffff
 2ea:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffde37>
 2ee:	00f405b3          	add	a1,s0,a5
 2f2:	854a                	mv	a0,s2
 2f4:	00000097          	auipc	ra,0x0
 2f8:	71c080e7          	jalr	1820(ra) # a10 <read>
 2fc:	89aa                	mv	s3,a0
  if(cc < 0){
 2fe:	12054363          	bltz	a0,424 <dns+0x2a4>
  if(!hdr->qr) {
 302:	77fd                	lui	a5,0xfffff
 304:	7c278793          	addi	a5,a5,1986 # fffffffffffff7c2 <__global_pointer$+0xffffffffffffde39>
 308:	97a2                	add	a5,a5,s0
 30a:	00078783          	lb	a5,0(a5)
 30e:	1207d963          	bgez	a5,440 <dns+0x2c0>
  if(hdr->id != htons(6828))
 312:	77fd                	lui	a5,0xfffff
 314:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffde37>
 318:	97a2                	add	a5,a5,s0
 31a:	0007d783          	lhu	a5,0(a5)
 31e:	0007869b          	sext.w	a3,a5
 322:	672d                	lui	a4,0xb
 324:	c1a70713          	addi	a4,a4,-998 # ac1a <__global_pointer$+0x9291>
 328:	12e69163          	bne	a3,a4,44a <dns+0x2ca>
  if(hdr->rcode != 0) {
 32c:	777d                	lui	a4,0xfffff
 32e:	7c370793          	addi	a5,a4,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffde3a>
 332:	97a2                	add	a5,a5,s0
 334:	0007c783          	lbu	a5,0(a5)
 338:	8bbd                	andi	a5,a5,15
 33a:	12079863          	bnez	a5,46a <dns+0x2ea>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
 33e:	7c470793          	addi	a5,a4,1988
 342:	97a2                	add	a5,a5,s0
 344:	0007d783          	lhu	a5,0(a5)
 348:	0087d713          	srli	a4,a5,0x8
 34c:	0087979b          	slliw	a5,a5,0x8
 350:	0ff77713          	andi	a4,a4,255
 354:	8fd9                	or	a5,a5,a4
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 356:	17c2                	slli	a5,a5,0x30
 358:	93c1                	srli	a5,a5,0x30
 35a:	4a81                	li	s5,0
  len = sizeof(struct dns);
 35c:	44b1                	li	s1,12
  char *qname = 0;
 35e:	4a01                	li	s4,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 360:	c7a1                	beqz	a5,3a8 <dns+0x228>
    char *qn = (char *) (ibuf+len);
 362:	7b7d                	lui	s6,0xfffff
 364:	7c0b0793          	addi	a5,s6,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffde37>
 368:	97a2                	add	a5,a5,s0
 36a:	00978a33          	add	s4,a5,s1
    decode_qname(qn);
 36e:	8552                	mv	a0,s4
 370:	00000097          	auipc	ra,0x0
 374:	c90080e7          	jalr	-880(ra) # 0 <decode_qname>
    len += strlen(qn)+1;
 378:	8552                	mv	a0,s4
 37a:	00000097          	auipc	ra,0x0
 37e:	450080e7          	jalr	1104(ra) # 7ca <strlen>
    len += sizeof(struct dns_question);
 382:	2515                	addiw	a0,a0,5
 384:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 386:	2a85                	addiw	s5,s5,1
 388:	7c4b0793          	addi	a5,s6,1988
 38c:	97a2                	add	a5,a5,s0
 38e:	0007d783          	lhu	a5,0(a5)
 392:	0087d713          	srli	a4,a5,0x8
 396:	0087979b          	slliw	a5,a5,0x8
 39a:	0ff77713          	andi	a4,a4,255
 39e:	8fd9                	or	a5,a5,a4
 3a0:	17c2                	slli	a5,a5,0x30
 3a2:	93c1                	srli	a5,a5,0x30
 3a4:	fafacfe3          	blt	s5,a5,362 <dns+0x1e2>
 3a8:	77fd                	lui	a5,0xfffff
 3aa:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffde3d>
 3ae:	97a2                	add	a5,a5,s0
 3b0:	0007d783          	lhu	a5,0(a5)
 3b4:	0087d713          	srli	a4,a5,0x8
 3b8:	0087979b          	slliw	a5,a5,0x8
 3bc:	0ff77713          	andi	a4,a4,255
 3c0:	8fd9                	or	a5,a5,a4
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
 3c2:	17c2                	slli	a5,a5,0x30
 3c4:	93c1                	srli	a5,a5,0x30
 3c6:	24078863          	beqz	a5,616 <dns+0x496>
 3ca:	00001797          	auipc	a5,0x1
 3ce:	cd678793          	addi	a5,a5,-810 # 10a0 <malloc+0x26a>
 3d2:	000a0363          	beqz	s4,3d8 <dns+0x258>
 3d6:	87d2                	mv	a5,s4
 3d8:	76fd                	lui	a3,0xfffff
 3da:	7b068713          	addi	a4,a3,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffde27>
 3de:	9722                	add	a4,a4,s0
 3e0:	e31c                	sd	a5,0(a4)
  int record = 0;
 3e2:	7b868793          	addi	a5,a3,1976
 3e6:	97a2                	add	a5,a5,s0
 3e8:	0007b023          	sd	zero,0(a5)
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
 3ec:	4a01                	li	s4,0
    if((int) qn[0] > 63) {  // compression?
 3ee:	03f00d93          	li	s11,63
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
 3f2:	4a85                	li	s5,1
 3f4:	4d11                	li	s10,4
      printf("DNS arecord for %s is ", qname ? qname : "" );
 3f6:	00001c97          	auipc	s9,0x1
 3fa:	c42c8c93          	addi	s9,s9,-958 # 1038 <malloc+0x202>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
 3fe:	08000c13          	li	s8,128
 402:	03400b93          	li	s7,52
 406:	a8e9                	j	4e0 <dns+0x360>
    fprintf(2, "dns: send() failed\n");
 408:	00001597          	auipc	a1,0x1
 40c:	bd058593          	addi	a1,a1,-1072 # fd8 <malloc+0x1a2>
 410:	4509                	li	a0,2
 412:	00001097          	auipc	ra,0x1
 416:	938080e7          	jalr	-1736(ra) # d4a <fprintf>
    exit(1);
 41a:	4505                	li	a0,1
 41c:	00000097          	auipc	ra,0x0
 420:	5dc080e7          	jalr	1500(ra) # 9f8 <exit>
    fprintf(2, "dns: recv() failed\n");
 424:	00001597          	auipc	a1,0x1
 428:	bcc58593          	addi	a1,a1,-1076 # ff0 <malloc+0x1ba>
 42c:	4509                	li	a0,2
 42e:	00001097          	auipc	ra,0x1
 432:	91c080e7          	jalr	-1764(ra) # d4a <fprintf>
    exit(1);
 436:	4505                	li	a0,1
 438:	00000097          	auipc	ra,0x0
 43c:	5c0080e7          	jalr	1472(ra) # 9f8 <exit>
    exit(1);
 440:	4505                	li	a0,1
 442:	00000097          	auipc	ra,0x0
 446:	5b6080e7          	jalr	1462(ra) # 9f8 <exit>
 44a:	0087d59b          	srliw	a1,a5,0x8
 44e:	0087979b          	slliw	a5,a5,0x8
 452:	8ddd                	or	a1,a1,a5
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
 454:	15c2                	slli	a1,a1,0x30
 456:	91c1                	srli	a1,a1,0x30
 458:	00001517          	auipc	a0,0x1
 45c:	bb050513          	addi	a0,a0,-1104 # 1008 <malloc+0x1d2>
 460:	00001097          	auipc	ra,0x1
 464:	918080e7          	jalr	-1768(ra) # d78 <printf>
 468:	b5d1                	j	32c <dns+0x1ac>
    printf("DNS rcode error: %x\n", hdr->rcode);
 46a:	77fd                	lui	a5,0xfffff
 46c:	7c378793          	addi	a5,a5,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffde3a>
 470:	97a2                	add	a5,a5,s0
 472:	0007c583          	lbu	a1,0(a5)
 476:	89bd                	andi	a1,a1,15
 478:	00001517          	auipc	a0,0x1
 47c:	ba850513          	addi	a0,a0,-1112 # 1020 <malloc+0x1ea>
 480:	00001097          	auipc	ra,0x1
 484:	8f8080e7          	jalr	-1800(ra) # d78 <printf>
    exit(1);
 488:	4505                	li	a0,1
 48a:	00000097          	auipc	ra,0x0
 48e:	56e080e7          	jalr	1390(ra) # 9f8 <exit>
      decode_qname(qn);
 492:	855a                	mv	a0,s6
 494:	00000097          	auipc	ra,0x0
 498:	b6c080e7          	jalr	-1172(ra) # 0 <decode_qname>
      len += strlen(qn)+1;
 49c:	855a                	mv	a0,s6
 49e:	00000097          	auipc	ra,0x0
 4a2:	32c080e7          	jalr	812(ra) # 7ca <strlen>
 4a6:	2485                	addiw	s1,s1,1
 4a8:	9ca9                	addw	s1,s1,a0
 4aa:	a0b1                	j	4f6 <dns+0x376>
      len += 4;
 4ac:	00eb049b          	addiw	s1,s6,14
      record = 1;
 4b0:	77fd                	lui	a5,0xfffff
 4b2:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffde2f>
 4b6:	97a2                	add	a5,a5,s0
 4b8:	0157b023          	sd	s5,0(a5)
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
 4bc:	2a05                	addiw	s4,s4,1
 4be:	77fd                	lui	a5,0xfffff
 4c0:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffde3d>
 4c4:	97a2                	add	a5,a5,s0
 4c6:	0007d783          	lhu	a5,0(a5)
 4ca:	0087d713          	srli	a4,a5,0x8
 4ce:	0087979b          	slliw	a5,a5,0x8
 4d2:	0ff77713          	andi	a4,a4,255
 4d6:	8fd9                	or	a5,a5,a4
 4d8:	17c2                	slli	a5,a5,0x30
 4da:	93c1                	srli	a5,a5,0x30
 4dc:	0efa5263          	bge	s4,a5,5c0 <dns+0x440>
    char *qn = (char *) (ibuf+len);
 4e0:	77fd                	lui	a5,0xfffff
 4e2:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffde37>
 4e6:	97a2                	add	a5,a5,s0
 4e8:	00978b33          	add	s6,a5,s1
    if((int) qn[0] > 63) {  // compression?
 4ec:	000b4783          	lbu	a5,0(s6)
 4f0:	fafdf1e3          	bgeu	s11,a5,492 <dns+0x312>
      len += 2;
 4f4:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
 4f6:	77fd                	lui	a5,0xfffff
 4f8:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffde37>
 4fc:	97a2                	add	a5,a5,s0
 4fe:	009786b3          	add	a3,a5,s1
    len += sizeof(struct dns_data);
 502:	00048b1b          	sext.w	s6,s1
 506:	24a9                	addiw	s1,s1,10
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
 508:	0006c783          	lbu	a5,0(a3)
 50c:	0016c703          	lbu	a4,1(a3)
 510:	0722                	slli	a4,a4,0x8
 512:	8fd9                	or	a5,a5,a4
 514:	0087979b          	slliw	a5,a5,0x8
 518:	8321                	srli	a4,a4,0x8
 51a:	8fd9                	or	a5,a5,a4
 51c:	17c2                	slli	a5,a5,0x30
 51e:	93c1                	srli	a5,a5,0x30
 520:	f9579ee3          	bne	a5,s5,4bc <dns+0x33c>
 524:	0086c783          	lbu	a5,8(a3)
 528:	0096c703          	lbu	a4,9(a3)
 52c:	0722                	slli	a4,a4,0x8
 52e:	8fd9                	or	a5,a5,a4
 530:	0087979b          	slliw	a5,a5,0x8
 534:	8321                	srli	a4,a4,0x8
 536:	8fd9                	or	a5,a5,a4
 538:	17c2                	slli	a5,a5,0x30
 53a:	93c1                	srli	a5,a5,0x30
 53c:	f9a790e3          	bne	a5,s10,4bc <dns+0x33c>
      printf("DNS arecord for %s is ", qname ? qname : "" );
 540:	77fd                	lui	a5,0xfffff
 542:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffde27>
 546:	97a2                	add	a5,a5,s0
 548:	638c                	ld	a1,0(a5)
 54a:	8566                	mv	a0,s9
 54c:	00001097          	auipc	ra,0x1
 550:	82c080e7          	jalr	-2004(ra) # d78 <printf>
      uint8 *ip = (ibuf+len);
 554:	77fd                	lui	a5,0xfffff
 556:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffde37>
 55a:	97a2                	add	a5,a5,s0
 55c:	94be                	add	s1,s1,a5
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
 55e:	0034c703          	lbu	a4,3(s1)
 562:	0024c683          	lbu	a3,2(s1)
 566:	0014c603          	lbu	a2,1(s1)
 56a:	0004c583          	lbu	a1,0(s1)
 56e:	00001517          	auipc	a0,0x1
 572:	ae250513          	addi	a0,a0,-1310 # 1050 <malloc+0x21a>
 576:	00001097          	auipc	ra,0x1
 57a:	802080e7          	jalr	-2046(ra) # d78 <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
 57e:	0004c783          	lbu	a5,0(s1)
 582:	03879263          	bne	a5,s8,5a6 <dns+0x426>
 586:	0014c783          	lbu	a5,1(s1)
 58a:	01779e63          	bne	a5,s7,5a6 <dns+0x426>
 58e:	0024c703          	lbu	a4,2(s1)
 592:	08100793          	li	a5,129
 596:	00f71863          	bne	a4,a5,5a6 <dns+0x426>
 59a:	0034c703          	lbu	a4,3(s1)
 59e:	07e00793          	li	a5,126
 5a2:	f0f705e3          	beq	a4,a5,4ac <dns+0x32c>
        printf("wrong ip address");
 5a6:	00001517          	auipc	a0,0x1
 5aa:	aba50513          	addi	a0,a0,-1350 # 1060 <malloc+0x22a>
 5ae:	00000097          	auipc	ra,0x0
 5b2:	7ca080e7          	jalr	1994(ra) # d78 <printf>
        exit(1);
 5b6:	4505                	li	a0,1
 5b8:	00000097          	auipc	ra,0x0
 5bc:	440080e7          	jalr	1088(ra) # 9f8 <exit>
  if(len != cc) {
 5c0:	04999d63          	bne	s3,s1,61a <dns+0x49a>
  if(!record) {
 5c4:	77fd                	lui	a5,0xfffff
 5c6:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffde2f>
 5ca:	97a2                	add	a5,a5,s0
 5cc:	639c                	ld	a5,0(a5)
 5ce:	c79d                	beqz	a5,5fc <dns+0x47c>
  }
  dns_rep(ibuf, cc);

  close(fd);
 5d0:	854a                	mv	a0,s2
 5d2:	00000097          	auipc	ra,0x0
 5d6:	44e080e7          	jalr	1102(ra) # a20 <close>
}  
 5da:	7d010113          	addi	sp,sp,2000
 5de:	70e6                	ld	ra,120(sp)
 5e0:	7446                	ld	s0,112(sp)
 5e2:	74a6                	ld	s1,104(sp)
 5e4:	7906                	ld	s2,96(sp)
 5e6:	69e6                	ld	s3,88(sp)
 5e8:	6a46                	ld	s4,80(sp)
 5ea:	6aa6                	ld	s5,72(sp)
 5ec:	6b06                	ld	s6,64(sp)
 5ee:	7be2                	ld	s7,56(sp)
 5f0:	7c42                	ld	s8,48(sp)
 5f2:	7ca2                	ld	s9,40(sp)
 5f4:	7d02                	ld	s10,32(sp)
 5f6:	6de2                	ld	s11,24(sp)
 5f8:	6109                	addi	sp,sp,128
 5fa:	8082                	ret
    printf("Didn't receive an arecord\n");
 5fc:	00001517          	auipc	a0,0x1
 600:	aac50513          	addi	a0,a0,-1364 # 10a8 <malloc+0x272>
 604:	00000097          	auipc	ra,0x0
 608:	774080e7          	jalr	1908(ra) # d78 <printf>
    exit(1);
 60c:	4505                	li	a0,1
 60e:	00000097          	auipc	ra,0x0
 612:	3ea080e7          	jalr	1002(ra) # 9f8 <exit>
  if(len != cc) {
 616:	fe9983e3          	beq	s3,s1,5fc <dns+0x47c>
    printf("Processed %d data bytes but received %d\n", len, cc);
 61a:	864e                	mv	a2,s3
 61c:	85a6                	mv	a1,s1
 61e:	00001517          	auipc	a0,0x1
 622:	a5a50513          	addi	a0,a0,-1446 # 1078 <malloc+0x242>
 626:	00000097          	auipc	ra,0x0
 62a:	752080e7          	jalr	1874(ra) # d78 <printf>
    exit(1);
 62e:	4505                	li	a0,1
 630:	00000097          	auipc	ra,0x0
 634:	3c8080e7          	jalr	968(ra) # 9f8 <exit>

0000000000000638 <main>:

int
main(int argc, char *argv[])
{
 638:	7179                	addi	sp,sp,-48
 63a:	f406                	sd	ra,40(sp)
 63c:	f022                	sd	s0,32(sp)
 63e:	ec26                	sd	s1,24(sp)
 640:	e84a                	sd	s2,16(sp)
 642:	1800                	addi	s0,sp,48
  int i, ret;
  uint16 dport = NET_TESTS_PORT;

  printf("nettests running on port %d\n", dport);
 644:	6499                	lui	s1,0x6
 646:	5f348593          	addi	a1,s1,1523 # 65f3 <__global_pointer$+0x4c6a>
 64a:	00001517          	auipc	a0,0x1
 64e:	a7e50513          	addi	a0,a0,-1410 # 10c8 <malloc+0x292>
 652:	00000097          	auipc	ra,0x0
 656:	726080e7          	jalr	1830(ra) # d78 <printf>

  printf("testing ping: ");
 65a:	00001517          	auipc	a0,0x1
 65e:	a8e50513          	addi	a0,a0,-1394 # 10e8 <malloc+0x2b2>
 662:	00000097          	auipc	ra,0x0
 666:	716080e7          	jalr	1814(ra) # d78 <printf>
  ping(2000, dport, 1);
 66a:	4605                	li	a2,1
 66c:	5f348593          	addi	a1,s1,1523
 670:	7d000513          	li	a0,2000
 674:	00000097          	auipc	ra,0x0
 678:	9ec080e7          	jalr	-1556(ra) # 60 <ping>
  printf("OK\n");
 67c:	00001517          	auipc	a0,0x1
 680:	a7c50513          	addi	a0,a0,-1412 # 10f8 <malloc+0x2c2>
 684:	00000097          	auipc	ra,0x0
 688:	6f4080e7          	jalr	1780(ra) # d78 <printf>

  printf("testing single-process pings: ");
 68c:	00001517          	auipc	a0,0x1
 690:	a7450513          	addi	a0,a0,-1420 # 1100 <malloc+0x2ca>
 694:	00000097          	auipc	ra,0x0
 698:	6e4080e7          	jalr	1764(ra) # d78 <printf>
 69c:	06400493          	li	s1,100
  for (i = 0; i < 100; i++)
    ping(2000, dport, 1);
 6a0:	6919                	lui	s2,0x6
 6a2:	5f390913          	addi	s2,s2,1523 # 65f3 <__global_pointer$+0x4c6a>
 6a6:	4605                	li	a2,1
 6a8:	85ca                	mv	a1,s2
 6aa:	7d000513          	li	a0,2000
 6ae:	00000097          	auipc	ra,0x0
 6b2:	9b2080e7          	jalr	-1614(ra) # 60 <ping>
  for (i = 0; i < 100; i++)
 6b6:	34fd                	addiw	s1,s1,-1
 6b8:	f4fd                	bnez	s1,6a6 <main+0x6e>
  printf("OK\n");
 6ba:	00001517          	auipc	a0,0x1
 6be:	a3e50513          	addi	a0,a0,-1474 # 10f8 <malloc+0x2c2>
 6c2:	00000097          	auipc	ra,0x0
 6c6:	6b6080e7          	jalr	1718(ra) # d78 <printf>

  printf("testing multi-process pings: ");
 6ca:	00001517          	auipc	a0,0x1
 6ce:	a5650513          	addi	a0,a0,-1450 # 1120 <malloc+0x2ea>
 6d2:	00000097          	auipc	ra,0x0
 6d6:	6a6080e7          	jalr	1702(ra) # d78 <printf>
  for (i = 0; i < 10; i++){
 6da:	4929                	li	s2,10
    int pid = fork();
 6dc:	00000097          	auipc	ra,0x0
 6e0:	314080e7          	jalr	788(ra) # 9f0 <fork>
    if (pid == 0){
 6e4:	c92d                	beqz	a0,756 <main+0x11e>
  for (i = 0; i < 10; i++){
 6e6:	2485                	addiw	s1,s1,1
 6e8:	ff249ae3          	bne	s1,s2,6dc <main+0xa4>
 6ec:	44a9                	li	s1,10
      ping(2000 + i + 1, dport, 1);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++){
    wait(&ret);
 6ee:	fdc40513          	addi	a0,s0,-36
 6f2:	00000097          	auipc	ra,0x0
 6f6:	30e080e7          	jalr	782(ra) # a00 <wait>
    if (ret != 0)
 6fa:	fdc42783          	lw	a5,-36(s0)
 6fe:	efad                	bnez	a5,778 <main+0x140>
  for (i = 0; i < 10; i++){
 700:	34fd                	addiw	s1,s1,-1
 702:	f4f5                	bnez	s1,6ee <main+0xb6>
      exit(1);
  }
  printf("OK\n");
 704:	00001517          	auipc	a0,0x1
 708:	9f450513          	addi	a0,a0,-1548 # 10f8 <malloc+0x2c2>
 70c:	00000097          	auipc	ra,0x0
 710:	66c080e7          	jalr	1644(ra) # d78 <printf>
  
  printf("testing DNS\n");
 714:	00001517          	auipc	a0,0x1
 718:	a2c50513          	addi	a0,a0,-1492 # 1140 <malloc+0x30a>
 71c:	00000097          	auipc	ra,0x0
 720:	65c080e7          	jalr	1628(ra) # d78 <printf>
  dns();
 724:	00000097          	auipc	ra,0x0
 728:	a5c080e7          	jalr	-1444(ra) # 180 <dns>
  printf("DNS OK\n");
 72c:	00001517          	auipc	a0,0x1
 730:	a2450513          	addi	a0,a0,-1500 # 1150 <malloc+0x31a>
 734:	00000097          	auipc	ra,0x0
 738:	644080e7          	jalr	1604(ra) # d78 <printf>
  
  printf("all tests passed.\n");
 73c:	00001517          	auipc	a0,0x1
 740:	a1c50513          	addi	a0,a0,-1508 # 1158 <malloc+0x322>
 744:	00000097          	auipc	ra,0x0
 748:	634080e7          	jalr	1588(ra) # d78 <printf>
  exit(0);
 74c:	4501                	li	a0,0
 74e:	00000097          	auipc	ra,0x0
 752:	2aa080e7          	jalr	682(ra) # 9f8 <exit>
      ping(2000 + i + 1, dport, 1);
 756:	7d14851b          	addiw	a0,s1,2001
 75a:	4605                	li	a2,1
 75c:	6599                	lui	a1,0x6
 75e:	5f358593          	addi	a1,a1,1523 # 65f3 <__global_pointer$+0x4c6a>
 762:	1542                	slli	a0,a0,0x30
 764:	9141                	srli	a0,a0,0x30
 766:	00000097          	auipc	ra,0x0
 76a:	8fa080e7          	jalr	-1798(ra) # 60 <ping>
      exit(0);
 76e:	4501                	li	a0,0
 770:	00000097          	auipc	ra,0x0
 774:	288080e7          	jalr	648(ra) # 9f8 <exit>
      exit(1);
 778:	4505                	li	a0,1
 77a:	00000097          	auipc	ra,0x0
 77e:	27e080e7          	jalr	638(ra) # 9f8 <exit>

0000000000000782 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 782:	1141                	addi	sp,sp,-16
 784:	e422                	sd	s0,8(sp)
 786:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 788:	87aa                	mv	a5,a0
 78a:	0585                	addi	a1,a1,1
 78c:	0785                	addi	a5,a5,1
 78e:	fff5c703          	lbu	a4,-1(a1)
 792:	fee78fa3          	sb	a4,-1(a5)
 796:	fb75                	bnez	a4,78a <strcpy+0x8>
    ;
  return os;
}
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	addi	sp,sp,16
 79c:	8082                	ret

000000000000079e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 79e:	1141                	addi	sp,sp,-16
 7a0:	e422                	sd	s0,8(sp)
 7a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 7a4:	00054783          	lbu	a5,0(a0)
 7a8:	cb91                	beqz	a5,7bc <strcmp+0x1e>
 7aa:	0005c703          	lbu	a4,0(a1)
 7ae:	00f71763          	bne	a4,a5,7bc <strcmp+0x1e>
    p++, q++;
 7b2:	0505                	addi	a0,a0,1
 7b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 7b6:	00054783          	lbu	a5,0(a0)
 7ba:	fbe5                	bnez	a5,7aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 7bc:	0005c503          	lbu	a0,0(a1)
}
 7c0:	40a7853b          	subw	a0,a5,a0
 7c4:	6422                	ld	s0,8(sp)
 7c6:	0141                	addi	sp,sp,16
 7c8:	8082                	ret

00000000000007ca <strlen>:

uint
strlen(const char *s)
{
 7ca:	1141                	addi	sp,sp,-16
 7cc:	e422                	sd	s0,8(sp)
 7ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 7d0:	00054783          	lbu	a5,0(a0)
 7d4:	cf91                	beqz	a5,7f0 <strlen+0x26>
 7d6:	0505                	addi	a0,a0,1
 7d8:	87aa                	mv	a5,a0
 7da:	4685                	li	a3,1
 7dc:	9e89                	subw	a3,a3,a0
 7de:	00f6853b          	addw	a0,a3,a5
 7e2:	0785                	addi	a5,a5,1
 7e4:	fff7c703          	lbu	a4,-1(a5)
 7e8:	fb7d                	bnez	a4,7de <strlen+0x14>
    ;
  return n;
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret
  for(n = 0; s[n]; n++)
 7f0:	4501                	li	a0,0
 7f2:	bfe5                	j	7ea <strlen+0x20>

00000000000007f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 7f4:	1141                	addi	sp,sp,-16
 7f6:	e422                	sd	s0,8(sp)
 7f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 7fa:	ce09                	beqz	a2,814 <memset+0x20>
 7fc:	87aa                	mv	a5,a0
 7fe:	fff6071b          	addiw	a4,a2,-1
 802:	1702                	slli	a4,a4,0x20
 804:	9301                	srli	a4,a4,0x20
 806:	0705                	addi	a4,a4,1
 808:	972a                	add	a4,a4,a0
    cdst[i] = c;
 80a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 80e:	0785                	addi	a5,a5,1
 810:	fee79de3          	bne	a5,a4,80a <memset+0x16>
  }
  return dst;
}
 814:	6422                	ld	s0,8(sp)
 816:	0141                	addi	sp,sp,16
 818:	8082                	ret

000000000000081a <strchr>:

char*
strchr(const char *s, char c)
{
 81a:	1141                	addi	sp,sp,-16
 81c:	e422                	sd	s0,8(sp)
 81e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 820:	00054783          	lbu	a5,0(a0)
 824:	cb99                	beqz	a5,83a <strchr+0x20>
    if(*s == c)
 826:	00f58763          	beq	a1,a5,834 <strchr+0x1a>
  for(; *s; s++)
 82a:	0505                	addi	a0,a0,1
 82c:	00054783          	lbu	a5,0(a0)
 830:	fbfd                	bnez	a5,826 <strchr+0xc>
      return (char*)s;
  return 0;
 832:	4501                	li	a0,0
}
 834:	6422                	ld	s0,8(sp)
 836:	0141                	addi	sp,sp,16
 838:	8082                	ret
  return 0;
 83a:	4501                	li	a0,0
 83c:	bfe5                	j	834 <strchr+0x1a>

000000000000083e <gets>:

char*
gets(char *buf, int max)
{
 83e:	711d                	addi	sp,sp,-96
 840:	ec86                	sd	ra,88(sp)
 842:	e8a2                	sd	s0,80(sp)
 844:	e4a6                	sd	s1,72(sp)
 846:	e0ca                	sd	s2,64(sp)
 848:	fc4e                	sd	s3,56(sp)
 84a:	f852                	sd	s4,48(sp)
 84c:	f456                	sd	s5,40(sp)
 84e:	f05a                	sd	s6,32(sp)
 850:	ec5e                	sd	s7,24(sp)
 852:	1080                	addi	s0,sp,96
 854:	8baa                	mv	s7,a0
 856:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 858:	892a                	mv	s2,a0
 85a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 85c:	4aa9                	li	s5,10
 85e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 860:	89a6                	mv	s3,s1
 862:	2485                	addiw	s1,s1,1
 864:	0344d863          	bge	s1,s4,894 <gets+0x56>
    cc = read(0, &c, 1);
 868:	4605                	li	a2,1
 86a:	faf40593          	addi	a1,s0,-81
 86e:	4501                	li	a0,0
 870:	00000097          	auipc	ra,0x0
 874:	1a0080e7          	jalr	416(ra) # a10 <read>
    if(cc < 1)
 878:	00a05e63          	blez	a0,894 <gets+0x56>
    buf[i++] = c;
 87c:	faf44783          	lbu	a5,-81(s0)
 880:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 884:	01578763          	beq	a5,s5,892 <gets+0x54>
 888:	0905                	addi	s2,s2,1
 88a:	fd679be3          	bne	a5,s6,860 <gets+0x22>
  for(i=0; i+1 < max; ){
 88e:	89a6                	mv	s3,s1
 890:	a011                	j	894 <gets+0x56>
 892:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 894:	99de                	add	s3,s3,s7
 896:	00098023          	sb	zero,0(s3)
  return buf;
}
 89a:	855e                	mv	a0,s7
 89c:	60e6                	ld	ra,88(sp)
 89e:	6446                	ld	s0,80(sp)
 8a0:	64a6                	ld	s1,72(sp)
 8a2:	6906                	ld	s2,64(sp)
 8a4:	79e2                	ld	s3,56(sp)
 8a6:	7a42                	ld	s4,48(sp)
 8a8:	7aa2                	ld	s5,40(sp)
 8aa:	7b02                	ld	s6,32(sp)
 8ac:	6be2                	ld	s7,24(sp)
 8ae:	6125                	addi	sp,sp,96
 8b0:	8082                	ret

00000000000008b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 8b2:	1101                	addi	sp,sp,-32
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	e426                	sd	s1,8(sp)
 8ba:	e04a                	sd	s2,0(sp)
 8bc:	1000                	addi	s0,sp,32
 8be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 8c0:	4581                	li	a1,0
 8c2:	00000097          	auipc	ra,0x0
 8c6:	176080e7          	jalr	374(ra) # a38 <open>
  if(fd < 0)
 8ca:	02054563          	bltz	a0,8f4 <stat+0x42>
 8ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 8d0:	85ca                	mv	a1,s2
 8d2:	00000097          	auipc	ra,0x0
 8d6:	17e080e7          	jalr	382(ra) # a50 <fstat>
 8da:	892a                	mv	s2,a0
  close(fd);
 8dc:	8526                	mv	a0,s1
 8de:	00000097          	auipc	ra,0x0
 8e2:	142080e7          	jalr	322(ra) # a20 <close>
  return r;
}
 8e6:	854a                	mv	a0,s2
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	64a2                	ld	s1,8(sp)
 8ee:	6902                	ld	s2,0(sp)
 8f0:	6105                	addi	sp,sp,32
 8f2:	8082                	ret
    return -1;
 8f4:	597d                	li	s2,-1
 8f6:	bfc5                	j	8e6 <stat+0x34>

00000000000008f8 <atoi>:

int
atoi(const char *s)
{
 8f8:	1141                	addi	sp,sp,-16
 8fa:	e422                	sd	s0,8(sp)
 8fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8fe:	00054603          	lbu	a2,0(a0)
 902:	fd06079b          	addiw	a5,a2,-48
 906:	0ff7f793          	andi	a5,a5,255
 90a:	4725                	li	a4,9
 90c:	02f76963          	bltu	a4,a5,93e <atoi+0x46>
 910:	86aa                	mv	a3,a0
  n = 0;
 912:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 914:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 916:	0685                	addi	a3,a3,1
 918:	0025179b          	slliw	a5,a0,0x2
 91c:	9fa9                	addw	a5,a5,a0
 91e:	0017979b          	slliw	a5,a5,0x1
 922:	9fb1                	addw	a5,a5,a2
 924:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 928:	0006c603          	lbu	a2,0(a3)
 92c:	fd06071b          	addiw	a4,a2,-48
 930:	0ff77713          	andi	a4,a4,255
 934:	fee5f1e3          	bgeu	a1,a4,916 <atoi+0x1e>
  return n;
}
 938:	6422                	ld	s0,8(sp)
 93a:	0141                	addi	sp,sp,16
 93c:	8082                	ret
  n = 0;
 93e:	4501                	li	a0,0
 940:	bfe5                	j	938 <atoi+0x40>

0000000000000942 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 942:	1141                	addi	sp,sp,-16
 944:	e422                	sd	s0,8(sp)
 946:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 948:	02b57663          	bgeu	a0,a1,974 <memmove+0x32>
    while(n-- > 0)
 94c:	02c05163          	blez	a2,96e <memmove+0x2c>
 950:	fff6079b          	addiw	a5,a2,-1
 954:	1782                	slli	a5,a5,0x20
 956:	9381                	srli	a5,a5,0x20
 958:	0785                	addi	a5,a5,1
 95a:	97aa                	add	a5,a5,a0
  dst = vdst;
 95c:	872a                	mv	a4,a0
      *dst++ = *src++;
 95e:	0585                	addi	a1,a1,1
 960:	0705                	addi	a4,a4,1
 962:	fff5c683          	lbu	a3,-1(a1)
 966:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 96a:	fee79ae3          	bne	a5,a4,95e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 96e:	6422                	ld	s0,8(sp)
 970:	0141                	addi	sp,sp,16
 972:	8082                	ret
    dst += n;
 974:	00c50733          	add	a4,a0,a2
    src += n;
 978:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 97a:	fec05ae3          	blez	a2,96e <memmove+0x2c>
 97e:	fff6079b          	addiw	a5,a2,-1
 982:	1782                	slli	a5,a5,0x20
 984:	9381                	srli	a5,a5,0x20
 986:	fff7c793          	not	a5,a5
 98a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 98c:	15fd                	addi	a1,a1,-1
 98e:	177d                	addi	a4,a4,-1
 990:	0005c683          	lbu	a3,0(a1)
 994:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 998:	fee79ae3          	bne	a5,a4,98c <memmove+0x4a>
 99c:	bfc9                	j	96e <memmove+0x2c>

000000000000099e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 99e:	1141                	addi	sp,sp,-16
 9a0:	e422                	sd	s0,8(sp)
 9a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 9a4:	ca05                	beqz	a2,9d4 <memcmp+0x36>
 9a6:	fff6069b          	addiw	a3,a2,-1
 9aa:	1682                	slli	a3,a3,0x20
 9ac:	9281                	srli	a3,a3,0x20
 9ae:	0685                	addi	a3,a3,1
 9b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 9b2:	00054783          	lbu	a5,0(a0)
 9b6:	0005c703          	lbu	a4,0(a1)
 9ba:	00e79863          	bne	a5,a4,9ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 9be:	0505                	addi	a0,a0,1
    p2++;
 9c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 9c2:	fed518e3          	bne	a0,a3,9b2 <memcmp+0x14>
  }
  return 0;
 9c6:	4501                	li	a0,0
 9c8:	a019                	j	9ce <memcmp+0x30>
      return *p1 - *p2;
 9ca:	40e7853b          	subw	a0,a5,a4
}
 9ce:	6422                	ld	s0,8(sp)
 9d0:	0141                	addi	sp,sp,16
 9d2:	8082                	ret
  return 0;
 9d4:	4501                	li	a0,0
 9d6:	bfe5                	j	9ce <memcmp+0x30>

00000000000009d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 9d8:	1141                	addi	sp,sp,-16
 9da:	e406                	sd	ra,8(sp)
 9dc:	e022                	sd	s0,0(sp)
 9de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 9e0:	00000097          	auipc	ra,0x0
 9e4:	f62080e7          	jalr	-158(ra) # 942 <memmove>
}
 9e8:	60a2                	ld	ra,8(sp)
 9ea:	6402                	ld	s0,0(sp)
 9ec:	0141                	addi	sp,sp,16
 9ee:	8082                	ret

00000000000009f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 9f0:	4885                	li	a7,1
 ecall
 9f2:	00000073          	ecall
 ret
 9f6:	8082                	ret

00000000000009f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 9f8:	4889                	li	a7,2
 ecall
 9fa:	00000073          	ecall
 ret
 9fe:	8082                	ret

0000000000000a00 <wait>:
.global wait
wait:
 li a7, SYS_wait
 a00:	488d                	li	a7,3
 ecall
 a02:	00000073          	ecall
 ret
 a06:	8082                	ret

0000000000000a08 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 a08:	4891                	li	a7,4
 ecall
 a0a:	00000073          	ecall
 ret
 a0e:	8082                	ret

0000000000000a10 <read>:
.global read
read:
 li a7, SYS_read
 a10:	4895                	li	a7,5
 ecall
 a12:	00000073          	ecall
 ret
 a16:	8082                	ret

0000000000000a18 <write>:
.global write
write:
 li a7, SYS_write
 a18:	48c1                	li	a7,16
 ecall
 a1a:	00000073          	ecall
 ret
 a1e:	8082                	ret

0000000000000a20 <close>:
.global close
close:
 li a7, SYS_close
 a20:	48d5                	li	a7,21
 ecall
 a22:	00000073          	ecall
 ret
 a26:	8082                	ret

0000000000000a28 <kill>:
.global kill
kill:
 li a7, SYS_kill
 a28:	4899                	li	a7,6
 ecall
 a2a:	00000073          	ecall
 ret
 a2e:	8082                	ret

0000000000000a30 <exec>:
.global exec
exec:
 li a7, SYS_exec
 a30:	489d                	li	a7,7
 ecall
 a32:	00000073          	ecall
 ret
 a36:	8082                	ret

0000000000000a38 <open>:
.global open
open:
 li a7, SYS_open
 a38:	48bd                	li	a7,15
 ecall
 a3a:	00000073          	ecall
 ret
 a3e:	8082                	ret

0000000000000a40 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 a40:	48c5                	li	a7,17
 ecall
 a42:	00000073          	ecall
 ret
 a46:	8082                	ret

0000000000000a48 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 a48:	48c9                	li	a7,18
 ecall
 a4a:	00000073          	ecall
 ret
 a4e:	8082                	ret

0000000000000a50 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 a50:	48a1                	li	a7,8
 ecall
 a52:	00000073          	ecall
 ret
 a56:	8082                	ret

0000000000000a58 <link>:
.global link
link:
 li a7, SYS_link
 a58:	48cd                	li	a7,19
 ecall
 a5a:	00000073          	ecall
 ret
 a5e:	8082                	ret

0000000000000a60 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 a60:	48d1                	li	a7,20
 ecall
 a62:	00000073          	ecall
 ret
 a66:	8082                	ret

0000000000000a68 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 a68:	48a5                	li	a7,9
 ecall
 a6a:	00000073          	ecall
 ret
 a6e:	8082                	ret

0000000000000a70 <dup>:
.global dup
dup:
 li a7, SYS_dup
 a70:	48a9                	li	a7,10
 ecall
 a72:	00000073          	ecall
 ret
 a76:	8082                	ret

0000000000000a78 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 a78:	48ad                	li	a7,11
 ecall
 a7a:	00000073          	ecall
 ret
 a7e:	8082                	ret

0000000000000a80 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 a80:	48b1                	li	a7,12
 ecall
 a82:	00000073          	ecall
 ret
 a86:	8082                	ret

0000000000000a88 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 a88:	48b5                	li	a7,13
 ecall
 a8a:	00000073          	ecall
 ret
 a8e:	8082                	ret

0000000000000a90 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 a90:	48b9                	li	a7,14
 ecall
 a92:	00000073          	ecall
 ret
 a96:	8082                	ret

0000000000000a98 <connect>:
.global connect
connect:
 li a7, SYS_connect
 a98:	48f5                	li	a7,29
 ecall
 a9a:	00000073          	ecall
 ret
 a9e:	8082                	ret

0000000000000aa0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 aa0:	1101                	addi	sp,sp,-32
 aa2:	ec06                	sd	ra,24(sp)
 aa4:	e822                	sd	s0,16(sp)
 aa6:	1000                	addi	s0,sp,32
 aa8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 aac:	4605                	li	a2,1
 aae:	fef40593          	addi	a1,s0,-17
 ab2:	00000097          	auipc	ra,0x0
 ab6:	f66080e7          	jalr	-154(ra) # a18 <write>
}
 aba:	60e2                	ld	ra,24(sp)
 abc:	6442                	ld	s0,16(sp)
 abe:	6105                	addi	sp,sp,32
 ac0:	8082                	ret

0000000000000ac2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 ac2:	7139                	addi	sp,sp,-64
 ac4:	fc06                	sd	ra,56(sp)
 ac6:	f822                	sd	s0,48(sp)
 ac8:	f426                	sd	s1,40(sp)
 aca:	f04a                	sd	s2,32(sp)
 acc:	ec4e                	sd	s3,24(sp)
 ace:	0080                	addi	s0,sp,64
 ad0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 ad2:	c299                	beqz	a3,ad8 <printint+0x16>
 ad4:	0805c863          	bltz	a1,b64 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 ad8:	2581                	sext.w	a1,a1
  neg = 0;
 ada:	4881                	li	a7,0
 adc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 ae0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 ae2:	2601                	sext.w	a2,a2
 ae4:	00000517          	auipc	a0,0x0
 ae8:	69450513          	addi	a0,a0,1684 # 1178 <digits>
 aec:	883a                	mv	a6,a4
 aee:	2705                	addiw	a4,a4,1
 af0:	02c5f7bb          	remuw	a5,a1,a2
 af4:	1782                	slli	a5,a5,0x20
 af6:	9381                	srli	a5,a5,0x20
 af8:	97aa                	add	a5,a5,a0
 afa:	0007c783          	lbu	a5,0(a5)
 afe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 b02:	0005879b          	sext.w	a5,a1
 b06:	02c5d5bb          	divuw	a1,a1,a2
 b0a:	0685                	addi	a3,a3,1
 b0c:	fec7f0e3          	bgeu	a5,a2,aec <printint+0x2a>
  if(neg)
 b10:	00088b63          	beqz	a7,b26 <printint+0x64>
    buf[i++] = '-';
 b14:	fd040793          	addi	a5,s0,-48
 b18:	973e                	add	a4,a4,a5
 b1a:	02d00793          	li	a5,45
 b1e:	fef70823          	sb	a5,-16(a4)
 b22:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 b26:	02e05863          	blez	a4,b56 <printint+0x94>
 b2a:	fc040793          	addi	a5,s0,-64
 b2e:	00e78933          	add	s2,a5,a4
 b32:	fff78993          	addi	s3,a5,-1
 b36:	99ba                	add	s3,s3,a4
 b38:	377d                	addiw	a4,a4,-1
 b3a:	1702                	slli	a4,a4,0x20
 b3c:	9301                	srli	a4,a4,0x20
 b3e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 b42:	fff94583          	lbu	a1,-1(s2)
 b46:	8526                	mv	a0,s1
 b48:	00000097          	auipc	ra,0x0
 b4c:	f58080e7          	jalr	-168(ra) # aa0 <putc>
  while(--i >= 0)
 b50:	197d                	addi	s2,s2,-1
 b52:	ff3918e3          	bne	s2,s3,b42 <printint+0x80>
}
 b56:	70e2                	ld	ra,56(sp)
 b58:	7442                	ld	s0,48(sp)
 b5a:	74a2                	ld	s1,40(sp)
 b5c:	7902                	ld	s2,32(sp)
 b5e:	69e2                	ld	s3,24(sp)
 b60:	6121                	addi	sp,sp,64
 b62:	8082                	ret
    x = -xx;
 b64:	40b005bb          	negw	a1,a1
    neg = 1;
 b68:	4885                	li	a7,1
    x = -xx;
 b6a:	bf8d                	j	adc <printint+0x1a>

0000000000000b6c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 b6c:	7119                	addi	sp,sp,-128
 b6e:	fc86                	sd	ra,120(sp)
 b70:	f8a2                	sd	s0,112(sp)
 b72:	f4a6                	sd	s1,104(sp)
 b74:	f0ca                	sd	s2,96(sp)
 b76:	ecce                	sd	s3,88(sp)
 b78:	e8d2                	sd	s4,80(sp)
 b7a:	e4d6                	sd	s5,72(sp)
 b7c:	e0da                	sd	s6,64(sp)
 b7e:	fc5e                	sd	s7,56(sp)
 b80:	f862                	sd	s8,48(sp)
 b82:	f466                	sd	s9,40(sp)
 b84:	f06a                	sd	s10,32(sp)
 b86:	ec6e                	sd	s11,24(sp)
 b88:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 b8a:	0005c903          	lbu	s2,0(a1)
 b8e:	18090f63          	beqz	s2,d2c <vprintf+0x1c0>
 b92:	8aaa                	mv	s5,a0
 b94:	8b32                	mv	s6,a2
 b96:	00158493          	addi	s1,a1,1
  state = 0;
 b9a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b9c:	02500a13          	li	s4,37
      if(c == 'd'){
 ba0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 ba4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 ba8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 bac:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bb0:	00000b97          	auipc	s7,0x0
 bb4:	5c8b8b93          	addi	s7,s7,1480 # 1178 <digits>
 bb8:	a839                	j	bd6 <vprintf+0x6a>
        putc(fd, c);
 bba:	85ca                	mv	a1,s2
 bbc:	8556                	mv	a0,s5
 bbe:	00000097          	auipc	ra,0x0
 bc2:	ee2080e7          	jalr	-286(ra) # aa0 <putc>
 bc6:	a019                	j	bcc <vprintf+0x60>
    } else if(state == '%'){
 bc8:	01498f63          	beq	s3,s4,be6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 bcc:	0485                	addi	s1,s1,1
 bce:	fff4c903          	lbu	s2,-1(s1)
 bd2:	14090d63          	beqz	s2,d2c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 bd6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 bda:	fe0997e3          	bnez	s3,bc8 <vprintf+0x5c>
      if(c == '%'){
 bde:	fd479ee3          	bne	a5,s4,bba <vprintf+0x4e>
        state = '%';
 be2:	89be                	mv	s3,a5
 be4:	b7e5                	j	bcc <vprintf+0x60>
      if(c == 'd'){
 be6:	05878063          	beq	a5,s8,c26 <vprintf+0xba>
      } else if(c == 'l') {
 bea:	05978c63          	beq	a5,s9,c42 <vprintf+0xd6>
      } else if(c == 'x') {
 bee:	07a78863          	beq	a5,s10,c5e <vprintf+0xf2>
      } else if(c == 'p') {
 bf2:	09b78463          	beq	a5,s11,c7a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 bf6:	07300713          	li	a4,115
 bfa:	0ce78663          	beq	a5,a4,cc6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 bfe:	06300713          	li	a4,99
 c02:	0ee78e63          	beq	a5,a4,cfe <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 c06:	11478863          	beq	a5,s4,d16 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c0a:	85d2                	mv	a1,s4
 c0c:	8556                	mv	a0,s5
 c0e:	00000097          	auipc	ra,0x0
 c12:	e92080e7          	jalr	-366(ra) # aa0 <putc>
        putc(fd, c);
 c16:	85ca                	mv	a1,s2
 c18:	8556                	mv	a0,s5
 c1a:	00000097          	auipc	ra,0x0
 c1e:	e86080e7          	jalr	-378(ra) # aa0 <putc>
      }
      state = 0;
 c22:	4981                	li	s3,0
 c24:	b765                	j	bcc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 c26:	008b0913          	addi	s2,s6,8
 c2a:	4685                	li	a3,1
 c2c:	4629                	li	a2,10
 c2e:	000b2583          	lw	a1,0(s6)
 c32:	8556                	mv	a0,s5
 c34:	00000097          	auipc	ra,0x0
 c38:	e8e080e7          	jalr	-370(ra) # ac2 <printint>
 c3c:	8b4a                	mv	s6,s2
      state = 0;
 c3e:	4981                	li	s3,0
 c40:	b771                	j	bcc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 c42:	008b0913          	addi	s2,s6,8
 c46:	4681                	li	a3,0
 c48:	4629                	li	a2,10
 c4a:	000b2583          	lw	a1,0(s6)
 c4e:	8556                	mv	a0,s5
 c50:	00000097          	auipc	ra,0x0
 c54:	e72080e7          	jalr	-398(ra) # ac2 <printint>
 c58:	8b4a                	mv	s6,s2
      state = 0;
 c5a:	4981                	li	s3,0
 c5c:	bf85                	j	bcc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 c5e:	008b0913          	addi	s2,s6,8
 c62:	4681                	li	a3,0
 c64:	4641                	li	a2,16
 c66:	000b2583          	lw	a1,0(s6)
 c6a:	8556                	mv	a0,s5
 c6c:	00000097          	auipc	ra,0x0
 c70:	e56080e7          	jalr	-426(ra) # ac2 <printint>
 c74:	8b4a                	mv	s6,s2
      state = 0;
 c76:	4981                	li	s3,0
 c78:	bf91                	j	bcc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 c7a:	008b0793          	addi	a5,s6,8
 c7e:	f8f43423          	sd	a5,-120(s0)
 c82:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 c86:	03000593          	li	a1,48
 c8a:	8556                	mv	a0,s5
 c8c:	00000097          	auipc	ra,0x0
 c90:	e14080e7          	jalr	-492(ra) # aa0 <putc>
  putc(fd, 'x');
 c94:	85ea                	mv	a1,s10
 c96:	8556                	mv	a0,s5
 c98:	00000097          	auipc	ra,0x0
 c9c:	e08080e7          	jalr	-504(ra) # aa0 <putc>
 ca0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ca2:	03c9d793          	srli	a5,s3,0x3c
 ca6:	97de                	add	a5,a5,s7
 ca8:	0007c583          	lbu	a1,0(a5)
 cac:	8556                	mv	a0,s5
 cae:	00000097          	auipc	ra,0x0
 cb2:	df2080e7          	jalr	-526(ra) # aa0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 cb6:	0992                	slli	s3,s3,0x4
 cb8:	397d                	addiw	s2,s2,-1
 cba:	fe0914e3          	bnez	s2,ca2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 cbe:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 cc2:	4981                	li	s3,0
 cc4:	b721                	j	bcc <vprintf+0x60>
        s = va_arg(ap, char*);
 cc6:	008b0993          	addi	s3,s6,8
 cca:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 cce:	02090163          	beqz	s2,cf0 <vprintf+0x184>
        while(*s != 0){
 cd2:	00094583          	lbu	a1,0(s2)
 cd6:	c9a1                	beqz	a1,d26 <vprintf+0x1ba>
          putc(fd, *s);
 cd8:	8556                	mv	a0,s5
 cda:	00000097          	auipc	ra,0x0
 cde:	dc6080e7          	jalr	-570(ra) # aa0 <putc>
          s++;
 ce2:	0905                	addi	s2,s2,1
        while(*s != 0){
 ce4:	00094583          	lbu	a1,0(s2)
 ce8:	f9e5                	bnez	a1,cd8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 cea:	8b4e                	mv	s6,s3
      state = 0;
 cec:	4981                	li	s3,0
 cee:	bdf9                	j	bcc <vprintf+0x60>
          s = "(null)";
 cf0:	00000917          	auipc	s2,0x0
 cf4:	48090913          	addi	s2,s2,1152 # 1170 <malloc+0x33a>
        while(*s != 0){
 cf8:	02800593          	li	a1,40
 cfc:	bff1                	j	cd8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 cfe:	008b0913          	addi	s2,s6,8
 d02:	000b4583          	lbu	a1,0(s6)
 d06:	8556                	mv	a0,s5
 d08:	00000097          	auipc	ra,0x0
 d0c:	d98080e7          	jalr	-616(ra) # aa0 <putc>
 d10:	8b4a                	mv	s6,s2
      state = 0;
 d12:	4981                	li	s3,0
 d14:	bd65                	j	bcc <vprintf+0x60>
        putc(fd, c);
 d16:	85d2                	mv	a1,s4
 d18:	8556                	mv	a0,s5
 d1a:	00000097          	auipc	ra,0x0
 d1e:	d86080e7          	jalr	-634(ra) # aa0 <putc>
      state = 0;
 d22:	4981                	li	s3,0
 d24:	b565                	j	bcc <vprintf+0x60>
        s = va_arg(ap, char*);
 d26:	8b4e                	mv	s6,s3
      state = 0;
 d28:	4981                	li	s3,0
 d2a:	b54d                	j	bcc <vprintf+0x60>
    }
  }
}
 d2c:	70e6                	ld	ra,120(sp)
 d2e:	7446                	ld	s0,112(sp)
 d30:	74a6                	ld	s1,104(sp)
 d32:	7906                	ld	s2,96(sp)
 d34:	69e6                	ld	s3,88(sp)
 d36:	6a46                	ld	s4,80(sp)
 d38:	6aa6                	ld	s5,72(sp)
 d3a:	6b06                	ld	s6,64(sp)
 d3c:	7be2                	ld	s7,56(sp)
 d3e:	7c42                	ld	s8,48(sp)
 d40:	7ca2                	ld	s9,40(sp)
 d42:	7d02                	ld	s10,32(sp)
 d44:	6de2                	ld	s11,24(sp)
 d46:	6109                	addi	sp,sp,128
 d48:	8082                	ret

0000000000000d4a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 d4a:	715d                	addi	sp,sp,-80
 d4c:	ec06                	sd	ra,24(sp)
 d4e:	e822                	sd	s0,16(sp)
 d50:	1000                	addi	s0,sp,32
 d52:	e010                	sd	a2,0(s0)
 d54:	e414                	sd	a3,8(s0)
 d56:	e818                	sd	a4,16(s0)
 d58:	ec1c                	sd	a5,24(s0)
 d5a:	03043023          	sd	a6,32(s0)
 d5e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 d62:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 d66:	8622                	mv	a2,s0
 d68:	00000097          	auipc	ra,0x0
 d6c:	e04080e7          	jalr	-508(ra) # b6c <vprintf>
}
 d70:	60e2                	ld	ra,24(sp)
 d72:	6442                	ld	s0,16(sp)
 d74:	6161                	addi	sp,sp,80
 d76:	8082                	ret

0000000000000d78 <printf>:

void
printf(const char *fmt, ...)
{
 d78:	711d                	addi	sp,sp,-96
 d7a:	ec06                	sd	ra,24(sp)
 d7c:	e822                	sd	s0,16(sp)
 d7e:	1000                	addi	s0,sp,32
 d80:	e40c                	sd	a1,8(s0)
 d82:	e810                	sd	a2,16(s0)
 d84:	ec14                	sd	a3,24(s0)
 d86:	f018                	sd	a4,32(s0)
 d88:	f41c                	sd	a5,40(s0)
 d8a:	03043823          	sd	a6,48(s0)
 d8e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 d92:	00840613          	addi	a2,s0,8
 d96:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 d9a:	85aa                	mv	a1,a0
 d9c:	4505                	li	a0,1
 d9e:	00000097          	auipc	ra,0x0
 da2:	dce080e7          	jalr	-562(ra) # b6c <vprintf>
}
 da6:	60e2                	ld	ra,24(sp)
 da8:	6442                	ld	s0,16(sp)
 daa:	6125                	addi	sp,sp,96
 dac:	8082                	ret

0000000000000dae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 dae:	1141                	addi	sp,sp,-16
 db0:	e422                	sd	s0,8(sp)
 db2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 db4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 db8:	00000797          	auipc	a5,0x0
 dbc:	3d87b783          	ld	a5,984(a5) # 1190 <freep>
 dc0:	a805                	j	df0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 dc2:	4618                	lw	a4,8(a2)
 dc4:	9db9                	addw	a1,a1,a4
 dc6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 dca:	6398                	ld	a4,0(a5)
 dcc:	6318                	ld	a4,0(a4)
 dce:	fee53823          	sd	a4,-16(a0)
 dd2:	a091                	j	e16 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 dd4:	ff852703          	lw	a4,-8(a0)
 dd8:	9e39                	addw	a2,a2,a4
 dda:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ddc:	ff053703          	ld	a4,-16(a0)
 de0:	e398                	sd	a4,0(a5)
 de2:	a099                	j	e28 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 de4:	6398                	ld	a4,0(a5)
 de6:	00e7e463          	bltu	a5,a4,dee <free+0x40>
 dea:	00e6ea63          	bltu	a3,a4,dfe <free+0x50>
{
 dee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 df0:	fed7fae3          	bgeu	a5,a3,de4 <free+0x36>
 df4:	6398                	ld	a4,0(a5)
 df6:	00e6e463          	bltu	a3,a4,dfe <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dfa:	fee7eae3          	bltu	a5,a4,dee <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 dfe:	ff852583          	lw	a1,-8(a0)
 e02:	6390                	ld	a2,0(a5)
 e04:	02059713          	slli	a4,a1,0x20
 e08:	9301                	srli	a4,a4,0x20
 e0a:	0712                	slli	a4,a4,0x4
 e0c:	9736                	add	a4,a4,a3
 e0e:	fae60ae3          	beq	a2,a4,dc2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 e12:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 e16:	4790                	lw	a2,8(a5)
 e18:	02061713          	slli	a4,a2,0x20
 e1c:	9301                	srli	a4,a4,0x20
 e1e:	0712                	slli	a4,a4,0x4
 e20:	973e                	add	a4,a4,a5
 e22:	fae689e3          	beq	a3,a4,dd4 <free+0x26>
  } else
    p->s.ptr = bp;
 e26:	e394                	sd	a3,0(a5)
  freep = p;
 e28:	00000717          	auipc	a4,0x0
 e2c:	36f73423          	sd	a5,872(a4) # 1190 <freep>
}
 e30:	6422                	ld	s0,8(sp)
 e32:	0141                	addi	sp,sp,16
 e34:	8082                	ret

0000000000000e36 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e36:	7139                	addi	sp,sp,-64
 e38:	fc06                	sd	ra,56(sp)
 e3a:	f822                	sd	s0,48(sp)
 e3c:	f426                	sd	s1,40(sp)
 e3e:	f04a                	sd	s2,32(sp)
 e40:	ec4e                	sd	s3,24(sp)
 e42:	e852                	sd	s4,16(sp)
 e44:	e456                	sd	s5,8(sp)
 e46:	e05a                	sd	s6,0(sp)
 e48:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e4a:	02051493          	slli	s1,a0,0x20
 e4e:	9081                	srli	s1,s1,0x20
 e50:	04bd                	addi	s1,s1,15
 e52:	8091                	srli	s1,s1,0x4
 e54:	0014899b          	addiw	s3,s1,1
 e58:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 e5a:	00000517          	auipc	a0,0x0
 e5e:	33653503          	ld	a0,822(a0) # 1190 <freep>
 e62:	c515                	beqz	a0,e8e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e64:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e66:	4798                	lw	a4,8(a5)
 e68:	02977f63          	bgeu	a4,s1,ea6 <malloc+0x70>
 e6c:	8a4e                	mv	s4,s3
 e6e:	0009871b          	sext.w	a4,s3
 e72:	6685                	lui	a3,0x1
 e74:	00d77363          	bgeu	a4,a3,e7a <malloc+0x44>
 e78:	6a05                	lui	s4,0x1
 e7a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 e7e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 e82:	00000917          	auipc	s2,0x0
 e86:	30e90913          	addi	s2,s2,782 # 1190 <freep>
  if(p == (char*)-1)
 e8a:	5afd                	li	s5,-1
 e8c:	a88d                	j	efe <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 e8e:	00000797          	auipc	a5,0x0
 e92:	30a78793          	addi	a5,a5,778 # 1198 <base>
 e96:	00000717          	auipc	a4,0x0
 e9a:	2ef73d23          	sd	a5,762(a4) # 1190 <freep>
 e9e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ea0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ea4:	b7e1                	j	e6c <malloc+0x36>
      if(p->s.size == nunits)
 ea6:	02e48b63          	beq	s1,a4,edc <malloc+0xa6>
        p->s.size -= nunits;
 eaa:	4137073b          	subw	a4,a4,s3
 eae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 eb0:	1702                	slli	a4,a4,0x20
 eb2:	9301                	srli	a4,a4,0x20
 eb4:	0712                	slli	a4,a4,0x4
 eb6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 eb8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ebc:	00000717          	auipc	a4,0x0
 ec0:	2ca73a23          	sd	a0,724(a4) # 1190 <freep>
      return (void*)(p + 1);
 ec4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ec8:	70e2                	ld	ra,56(sp)
 eca:	7442                	ld	s0,48(sp)
 ecc:	74a2                	ld	s1,40(sp)
 ece:	7902                	ld	s2,32(sp)
 ed0:	69e2                	ld	s3,24(sp)
 ed2:	6a42                	ld	s4,16(sp)
 ed4:	6aa2                	ld	s5,8(sp)
 ed6:	6b02                	ld	s6,0(sp)
 ed8:	6121                	addi	sp,sp,64
 eda:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 edc:	6398                	ld	a4,0(a5)
 ede:	e118                	sd	a4,0(a0)
 ee0:	bff1                	j	ebc <malloc+0x86>
  hp->s.size = nu;
 ee2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ee6:	0541                	addi	a0,a0,16
 ee8:	00000097          	auipc	ra,0x0
 eec:	ec6080e7          	jalr	-314(ra) # dae <free>
  return freep;
 ef0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ef4:	d971                	beqz	a0,ec8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ef6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ef8:	4798                	lw	a4,8(a5)
 efa:	fa9776e3          	bgeu	a4,s1,ea6 <malloc+0x70>
    if(p == freep)
 efe:	00093703          	ld	a4,0(s2)
 f02:	853e                	mv	a0,a5
 f04:	fef719e3          	bne	a4,a5,ef6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 f08:	8552                	mv	a0,s4
 f0a:	00000097          	auipc	ra,0x0
 f0e:	b76080e7          	jalr	-1162(ra) # a80 <sbrk>
  if(p == (char*)-1)
 f12:	fd5518e3          	bne	a0,s5,ee2 <malloc+0xac>
        return 0;
 f16:	4501                	li	a0,0
 f18:	bf45                	j	ec8 <malloc+0x92>
