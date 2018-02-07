
kern/kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <stab_binsearch>:
 * will exit setting left = 118, right = 554.
 * */
    static void 
stab_binsearch(struct stab *stabs, int *region_left, int *region_right,
        int type, uint addr)
{
80100000:	55                   	push   %ebp
80100001:	89 e5                	mov    %esp,%ebp
80100003:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left , r = *region_right;
80100006:	8b 45 0c             	mov    0xc(%ebp),%eax
80100009:	8b 00                	mov    (%eax),%eax
8010000b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010000e:	8b 45 10             	mov    0x10(%ebp),%eax
80100011:	8b 00                	mov    (%eax),%eax
80100013:	89 45 f8             	mov    %eax,-0x8(%ebp)
    int m, true_m;
    int have_matches = 0;
80100016:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    //    int true_addr = addr;
    while(l <= r)
8010001d:	e9 cf 00 00 00       	jmp    801000f1 <stab_binsearch+0xf1>
    {
        true_m = (l + r) / 2;
80100022:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100025:	8b 45 f8             	mov    -0x8(%ebp),%eax
80100028:	01 d0                	add    %edx,%eax
8010002a:	89 c2                	mov    %eax,%edx
8010002c:	c1 ea 1f             	shr    $0x1f,%edx
8010002f:	01 d0                	add    %edx,%eax
80100031:	d1 f8                	sar    %eax
80100033:	89 45 ec             	mov    %eax,-0x14(%ebp)
        m = true_m;
80100036:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100039:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(m >= l && stabs[m].n_type != type)
8010003c:	eb 04                	jmp    80100042 <stab_binsearch+0x42>
            m --;
8010003e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    //    int true_addr = addr;
    while(l <= r)
    {
        true_m = (l + r) / 2;
        m = true_m;
        while(m >= l && stabs[m].n_type != type)
80100042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100045:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80100048:	7c 1f                	jl     80100069 <stab_binsearch+0x69>
8010004a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010004d:	89 d0                	mov    %edx,%eax
8010004f:	01 c0                	add    %eax,%eax
80100051:	01 d0                	add    %edx,%eax
80100053:	c1 e0 02             	shl    $0x2,%eax
80100056:	89 c2                	mov    %eax,%edx
80100058:	8b 45 08             	mov    0x8(%ebp),%eax
8010005b:	01 d0                	add    %edx,%eax
8010005d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80100061:	0f b6 c0             	movzbl %al,%eax
80100064:	3b 45 14             	cmp    0x14(%ebp),%eax
80100067:	75 d5                	jne    8010003e <stab_binsearch+0x3e>
            m --;
        if(m < l)
80100069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010006c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010006f:	7d 0b                	jge    8010007c <stab_binsearch+0x7c>
        {
            l = true_m + 1;
80100071:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100074:	83 c0 01             	add    $0x1,%eax
80100077:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
8010007a:	eb 75                	jmp    801000f1 <stab_binsearch+0xf1>
        }

        //find a stab
        have_matches = 1;
8010007c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        if(stabs[m].n_value < addr)
80100083:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100086:	89 d0                	mov    %edx,%eax
80100088:	01 c0                	add    %eax,%eax
8010008a:	01 d0                	add    %edx,%eax
8010008c:	c1 e0 02             	shl    $0x2,%eax
8010008f:	89 c2                	mov    %eax,%edx
80100091:	8b 45 08             	mov    0x8(%ebp),%eax
80100094:	01 d0                	add    %edx,%eax
80100096:	8b 40 08             	mov    0x8(%eax),%eax
80100099:	3b 45 18             	cmp    0x18(%ebp),%eax
8010009c:	73 13                	jae    801000b1 <stab_binsearch+0xb1>
        {
            *region_left = m;
8010009e:	8b 45 0c             	mov    0xc(%ebp),%eax
801000a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a4:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
801000a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801000a9:	83 c0 01             	add    $0x1,%eax
801000ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
801000af:	eb 40                	jmp    801000f1 <stab_binsearch+0xf1>
        }else if(stabs[m].n_value > addr)
801000b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000b4:	89 d0                	mov    %edx,%eax
801000b6:	01 c0                	add    %eax,%eax
801000b8:	01 d0                	add    %edx,%eax
801000ba:	c1 e0 02             	shl    $0x2,%eax
801000bd:	89 c2                	mov    %eax,%edx
801000bf:	8b 45 08             	mov    0x8(%ebp),%eax
801000c2:	01 d0                	add    %edx,%eax
801000c4:	8b 40 08             	mov    0x8(%eax),%eax
801000c7:	3b 45 18             	cmp    0x18(%ebp),%eax
801000ca:	76 13                	jbe    801000df <stab_binsearch+0xdf>
        {
            *region_right = m;
801000cc:	8b 45 10             	mov    0x10(%ebp),%eax
801000cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
801000d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d7:	83 e8 01             	sub    $0x1,%eax
801000da:	89 45 f8             	mov    %eax,-0x8(%ebp)
801000dd:	eb 12                	jmp    801000f1 <stab_binsearch+0xf1>
        }else{
            *region_left = m;
801000df:	8b 45 0c             	mov    0xc(%ebp),%eax
801000e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000e5:	89 10                	mov    %edx,(%eax)
            addr ++;
801000e7:	83 45 18 01          	addl   $0x1,0x18(%ebp)
            l = m;
801000eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
    int l = *region_left , r = *region_right;
    int m, true_m;
    int have_matches = 0;
    //    int true_addr = addr;
    while(l <= r)
801000f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801000f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801000f7:	0f 8e 25 ff ff ff    	jle    80100022 <stab_binsearch+0x22>
            *region_left = m;
            addr ++;
            l = m;
        }
    }
    if(!have_matches)
801000fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100101:	75 0d                	jne    80100110 <stab_binsearch+0x110>
    {
        *region_right = *region_left - 1;
80100103:	8b 45 0c             	mov    0xc(%ebp),%eax
80100106:	8b 00                	mov    (%eax),%eax
80100108:	8d 50 ff             	lea    -0x1(%eax),%edx
8010010b:	8b 45 10             	mov    0x10(%ebp),%eax
8010010e:	89 10                	mov    %edx,(%eax)
    }
}
80100110:	90                   	nop
80100111:	c9                   	leave  
80100112:	c3                   	ret    

80100113 <debuginfo_eip>:
struct eipdebuginfo {
    const char *eip_file;                   // source code filename for eip
    char eip_fn_name[MAX_FN_NAME];                // name of function containing eip
};
static int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
80100113:	55                   	push   %ebp
80100114:	89 e5                	mov    %esp,%ebp
80100116:	83 ec 28             	sub    $0x28,%esp
    struct stab *stab_begin =(struct stab*)__STAB_BEGIN__ , *stab_end = (struct stab*)__STAB_END__;
80100119:	c7 45 f4 58 bf 10 80 	movl   $0x8010bf58,-0xc(%ebp)
80100120:	c7 45 f0 3c d1 11 80 	movl   $0x8011d13c,-0x10(%ebp)
    char * strst_begin = (char*)__STABSTR_BEGIN__;
80100127:	c7 45 ec 3d d1 11 80 	movl   $0x8011d13d,-0x14(%ebp)
    char* tmp;
    int tmplen;
    int left, right;
    //ignore the first one
    stab_begin ++; 
8010012e:	83 45 f4 0c          	addl   $0xc,-0xc(%ebp)
    left = 0;
80100132:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    right = (stab_end - stab_begin) - 1;
80100139:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010013c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013f:	29 c2                	sub    %eax,%edx
80100141:	89 d0                	mov    %edx,%eax
80100143:	c1 f8 02             	sar    $0x2,%eax
80100146:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
8010014c:	83 e8 01             	sub    $0x1,%eax
8010014f:	89 45 dc             	mov    %eax,-0x24(%ebp)

    //find the name of file
    stab_binsearch(stab_begin, &left, &right, N_SO, addr);
80100152:	ff 75 08             	pushl  0x8(%ebp)
80100155:	6a 64                	push   $0x64
80100157:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010015a:	50                   	push   %eax
8010015b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010015e:	50                   	push   %eax
8010015f:	ff 75 f4             	pushl  -0xc(%ebp)
80100162:	e8 99 fe ff ff       	call   80100000 <stab_binsearch>
80100167:	83 c4 14             	add    $0x14,%esp
    if(left > right) return -1;
8010016a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010016d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100170:	39 c2                	cmp    %eax,%edx
80100172:	7e 0a                	jle    8010017e <debuginfo_eip+0x6b>
80100174:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100179:	e9 b1 00 00 00       	jmp    8010022f <debuginfo_eip+0x11c>

    info->eip_file = stab_begin[left].n_strx + strst_begin;
8010017e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100181:	89 c2                	mov    %eax,%edx
80100183:	89 d0                	mov    %edx,%eax
80100185:	01 c0                	add    %eax,%eax
80100187:	01 d0                	add    %edx,%eax
80100189:	c1 e0 02             	shl    $0x2,%eax
8010018c:	89 c2                	mov    %eax,%edx
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	01 d0                	add    %edx,%eax
80100193:	8b 10                	mov    (%eax),%edx
80100195:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100198:	01 c2                	add    %eax,%edx
8010019a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010019d:	89 10                	mov    %edx,(%eax)

    // find the name of function
    stab_binsearch(stab_begin, &left, &right, N_FUN, addr);
8010019f:	ff 75 08             	pushl  0x8(%ebp)
801001a2:	6a 24                	push   $0x24
801001a4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801001a7:	50                   	push   %eax
801001a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801001ab:	50                   	push   %eax
801001ac:	ff 75 f4             	pushl  -0xc(%ebp)
801001af:	e8 4c fe ff ff       	call   80100000 <stab_binsearch>
801001b4:	83 c4 14             	add    $0x14,%esp
    if(left > right) return -1;
801001b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801001ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801001bd:	39 c2                	cmp    %eax,%edx
801001bf:	7e 07                	jle    801001c8 <debuginfo_eip+0xb5>
801001c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801001c6:	eb 67                	jmp    8010022f <debuginfo_eip+0x11c>

    //copy to info
    tmp = stab_begin[left].n_strx + strst_begin;
801001c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801001cb:	89 c2                	mov    %eax,%edx
801001cd:	89 d0                	mov    %edx,%eax
801001cf:	01 c0                	add    %eax,%eax
801001d1:	01 d0                	add    %edx,%eax
801001d3:	c1 e0 02             	shl    $0x2,%eax
801001d6:	89 c2                	mov    %eax,%edx
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001db:	01 d0                	add    %edx,%eax
801001dd:	8b 10                	mov    (%eax),%edx
801001df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801001e2:	01 d0                	add    %edx,%eax
801001e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    tmplen = strfind(tmp,':') - tmp;
801001e7:	83 ec 08             	sub    $0x8,%esp
801001ea:	6a 3a                	push   $0x3a
801001ec:	ff 75 e8             	pushl  -0x18(%ebp)
801001ef:	e8 c8 a0 00 00       	call   8010a2bc <strfind>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	89 c2                	mov    %eax,%edx
801001f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801001fc:	29 c2                	sub    %eax,%edx
801001fe:	89 d0                	mov    %edx,%eax
80100200:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    strncpy(info->eip_fn_name, tmp, tmplen);
80100203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100206:	8b 55 0c             	mov    0xc(%ebp),%edx
80100209:	83 c2 04             	add    $0x4,%edx
8010020c:	83 ec 04             	sub    $0x4,%esp
8010020f:	50                   	push   %eax
80100210:	ff 75 e8             	pushl  -0x18(%ebp)
80100213:	52                   	push   %edx
80100214:	e8 91 9f 00 00       	call   8010a1aa <strncpy>
80100219:	83 c4 10             	add    $0x10,%esp
    info->eip_fn_name[tmplen] = '\0';
8010021c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010021f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100222:	01 d0                	add    %edx,%eax
80100224:	83 c0 04             	add    $0x4,%eax
80100227:	c6 00 00             	movb   $0x0,(%eax)

    return 1;
8010022a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010022f:	c9                   	leave  
80100230:	c3                   	ret    

80100231 <print_stack_trace>:

void
print_stack_trace()
{
80100231:	55                   	push   %ebp
80100232:	89 e5                	mov    %esp,%ebp
80100234:	83 ec 38             	sub    $0x38,%esp
    uint32_t *ebp,*eip;
    struct eipdebuginfo info;
    asm volatile("movl %%ebp,%0" : "=r" (ebp));
80100237:	89 e8                	mov    %ebp,%eax
80100239:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(ebp)
8010023c:	eb 4d                	jmp    8010028b <print_stack_trace+0x5a>
    {
        eip = ebp + 1;
8010023e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100241:	83 c0 04             	add    $0x4,%eax
80100244:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(*eip == 0) break;
80100247:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010024a:	8b 00                	mov    (%eax),%eax
8010024c:	85 c0                	test   %eax,%eax
8010024e:	74 43                	je     80100293 <print_stack_trace+0x62>
        debuginfo_eip(*eip, &info);                
80100250:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100253:	8b 00                	mov    (%eax),%eax
80100255:	83 ec 08             	sub    $0x8,%esp
80100258:	8d 55 cc             	lea    -0x34(%ebp),%edx
8010025b:	52                   	push   %edx
8010025c:	50                   	push   %eax
8010025d:	e8 b1 fe ff ff       	call   80100113 <debuginfo_eip>
80100262:	83 c4 10             	add    $0x10,%esp
        cprintf("eip : %x , file : %s, function : %s \n",*eip,  info.eip_file, info.eip_fn_name);
80100265:	8b 55 cc             	mov    -0x34(%ebp),%edx
80100268:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010026b:	8b 00                	mov    (%eax),%eax
8010026d:	8d 4d cc             	lea    -0x34(%ebp),%ecx
80100270:	83 c1 04             	add    $0x4,%ecx
80100273:	51                   	push   %ecx
80100274:	52                   	push   %edx
80100275:	50                   	push   %eax
80100276:	68 0c a7 10 80       	push   $0x8010a70c
8010027b:	e8 57 6a 00 00       	call   80106cd7 <cprintf>
80100280:	83 c4 10             	add    $0x10,%esp
        ebp = (uint32_t*)(*ebp);
80100283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100286:	8b 00                	mov    (%eax),%eax
80100288:	89 45 f4             	mov    %eax,-0xc(%ebp)
print_stack_trace()
{
    uint32_t *ebp,*eip;
    struct eipdebuginfo info;
    asm volatile("movl %%ebp,%0" : "=r" (ebp));
    while(ebp)
8010028b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010028f:	75 ad                	jne    8010023e <print_stack_trace+0xd>
        if(*eip == 0) break;
        debuginfo_eip(*eip, &info);                
        cprintf("eip : %x , file : %s, function : %s \n",*eip,  info.eip_file, info.eip_fn_name);
        ebp = (uint32_t*)(*ebp);
    }
}
80100291:	eb 01                	jmp    80100294 <print_stack_trace+0x63>
    struct eipdebuginfo info;
    asm volatile("movl %%ebp,%0" : "=r" (ebp));
    while(ebp)
    {
        eip = ebp + 1;
        if(*eip == 0) break;
80100293:	90                   	nop
        debuginfo_eip(*eip, &info);                
        cprintf("eip : %x , file : %s, function : %s \n",*eip,  info.eip_file, info.eip_fn_name);
        ebp = (uint32_t*)(*ebp);
    }
}
80100294:	90                   	nop
80100295:	c9                   	leave  
80100296:	c3                   	ret    

80100297 <print_cur_status>:
void
print_cur_status()
{
80100297:	55                   	push   %ebp
80100298:	89 e5                	mov    %esp,%ebp
8010029a:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1,reg2,reg3,reg4;

    asm volatile( "mov %%cs, %0;"
8010029d:	8c 4d f6             	mov    %cs,-0xa(%ebp)
801002a0:	8c 5d f4             	mov    %ds,-0xc(%ebp)
801002a3:	8c 45 f2             	mov    %es,-0xe(%ebp)
801002a6:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));

    cprintf("%d: @ring %d\n", round, reg1&0x3);
801002a9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
801002ad:	0f b7 c0             	movzwl %ax,%eax
801002b0:	83 e0 03             	and    $0x3,%eax
801002b3:	89 c2                	mov    %eax,%edx
801002b5:	a1 a4 6e 12 80       	mov    0x80126ea4,%eax
801002ba:	83 ec 04             	sub    $0x4,%esp
801002bd:	52                   	push   %edx
801002be:	50                   	push   %eax
801002bf:	68 32 a7 10 80       	push   $0x8010a732
801002c4:	e8 0e 6a 00 00       	call   80106cd7 <cprintf>
801002c9:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: cs = %x\n", round, reg1);
801002cc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
801002d0:	0f b7 d0             	movzwl %ax,%edx
801002d3:	a1 a4 6e 12 80       	mov    0x80126ea4,%eax
801002d8:	83 ec 04             	sub    $0x4,%esp
801002db:	52                   	push   %edx
801002dc:	50                   	push   %eax
801002dd:	68 40 a7 10 80       	push   $0x8010a740
801002e2:	e8 f0 69 00 00       	call   80106cd7 <cprintf>
801002e7:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: ds = %x\n", round, reg2);
801002ea:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
801002ee:	0f b7 d0             	movzwl %ax,%edx
801002f1:	a1 a4 6e 12 80       	mov    0x80126ea4,%eax
801002f6:	83 ec 04             	sub    $0x4,%esp
801002f9:	52                   	push   %edx
801002fa:	50                   	push   %eax
801002fb:	68 4d a7 10 80       	push   $0x8010a74d
80100300:	e8 d2 69 00 00       	call   80106cd7 <cprintf>
80100305:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: es = %x\n", round, reg3);
80100308:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
8010030c:	0f b7 d0             	movzwl %ax,%edx
8010030f:	a1 a4 6e 12 80       	mov    0x80126ea4,%eax
80100314:	83 ec 04             	sub    $0x4,%esp
80100317:	52                   	push   %edx
80100318:	50                   	push   %eax
80100319:	68 5a a7 10 80       	push   $0x8010a75a
8010031e:	e8 b4 69 00 00       	call   80106cd7 <cprintf>
80100323:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: ss = %x\n", round, reg4);
80100326:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
8010032a:	0f b7 d0             	movzwl %ax,%edx
8010032d:	a1 a4 6e 12 80       	mov    0x80126ea4,%eax
80100332:	83 ec 04             	sub    $0x4,%esp
80100335:	52                   	push   %edx
80100336:	50                   	push   %eax
80100337:	68 67 a7 10 80       	push   $0x8010a767
8010033c:	e8 96 69 00 00       	call   80106cd7 <cprintf>
80100341:	83 c4 10             	add    $0x10,%esp
    ++ round; 
80100344:	a1 a4 6e 12 80       	mov    0x80126ea4,%eax
80100349:	83 c0 01             	add    $0x1,%eax
8010034c:	a3 a4 6e 12 80       	mov    %eax,0x80126ea4

}
80100351:	90                   	nop
80100352:	c9                   	leave  
80100353:	c3                   	ret    

80100354 <__panic>:

static bool is_panic = 0;
void  
__panic(const char *file, int line, const char *fmt, ...)
{
80100354:	55                   	push   %ebp
80100355:	89 e5                	mov    %esp,%ebp
80100357:	83 ec 18             	sub    $0x18,%esp
    if (is_panic)
8010035a:	a1 a0 6e 12 80       	mov    0x80126ea0,%eax
8010035f:	85 c0                	test   %eax,%eax
80100361:	75 6f                	jne    801003d2 <__panic+0x7e>
    {
        goto panic_dead;
    }
    cprintf("*****************PANIC!!!*******************\n");
80100363:	83 ec 0c             	sub    $0xc,%esp
80100366:	68 74 a7 10 80       	push   $0x8010a774
8010036b:	e8 67 69 00 00       	call   80106cd7 <cprintf>
80100370:	83 c4 10             	add    $0x10,%esp
    is_panic = 1;
80100373:	c7 05 a0 6e 12 80 01 	movl   $0x1,0x80126ea0
8010037a:	00 00 00 
    va_list ap;
    va_start(ap, fmt);
8010037d:	8d 45 14             	lea    0x14(%ebp),%eax
80100380:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("*****************PANIC!!!*******************\n");
80100383:	83 ec 0c             	sub    $0xc,%esp
80100386:	68 74 a7 10 80       	push   $0x8010a774
8010038b:	e8 47 69 00 00       	call   80106cd7 <cprintf>
80100390:	83 c4 10             	add    $0x10,%esp
    cprintf("kernel panic at %s:%d:\n", file, line);
80100393:	83 ec 04             	sub    $0x4,%esp
80100396:	ff 75 0c             	pushl  0xc(%ebp)
80100399:	ff 75 08             	pushl  0x8(%ebp)
8010039c:	68 a2 a7 10 80       	push   $0x8010a7a2
801003a1:	e8 31 69 00 00       	call   80106cd7 <cprintf>
801003a6:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
801003a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003ac:	83 ec 08             	sub    $0x8,%esp
801003af:	50                   	push   %eax
801003b0:	ff 75 10             	pushl  0x10(%ebp)
801003b3:	e8 01 69 00 00       	call   80106cb9 <vcprintf>
801003b8:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
801003bb:	83 ec 0c             	sub    $0xc,%esp
801003be:	68 ba a7 10 80       	push   $0x8010a7ba
801003c3:	e8 0f 69 00 00       	call   80106cd7 <cprintf>
801003c8:	83 c4 10             	add    $0x10,%esp
    print_stack_trace();
801003cb:	e8 61 fe ff ff       	call   80100231 <print_stack_trace>
801003d0:	eb 01                	jmp    801003d3 <__panic+0x7f>
void  
__panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
    {
        goto panic_dead;
801003d2:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    print_stack_trace();
    va_end(ap);
panic_dead:
    cprintf("panic_dead\n");
801003d3:	83 ec 0c             	sub    $0xc,%esp
801003d6:	68 bc a7 10 80       	push   $0x8010a7bc
801003db:	e8 f7 68 00 00       	call   80106cd7 <cprintf>
801003e0:	83 c4 10             	add    $0x10,%esp
    while(1)
    {
        ;
    }
801003e3:	eb fe                	jmp    801003e3 <__panic+0x8f>

801003e5 <sys_put>:
#include "console.h"
#include "syscall.h"

int
sys_put(void)
{
801003e5:	55                   	push   %ebp
801003e6:	89 e5                	mov    %esp,%ebp
801003e8:	83 ec 18             	sub    $0x18,%esp
    int ch;
    argint(0, &ch);
801003eb:	83 ec 08             	sub    $0x8,%esp
801003ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801003f1:	50                   	push   %eax
801003f2:	6a 00                	push   $0x0
801003f4:	e8 10 53 00 00       	call   80105709 <argint>
801003f9:	83 c4 10             	add    $0x10,%esp
    putc_cons(ch);
801003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003ff:	0f be c0             	movsbl %al,%eax
80100402:	83 ec 0c             	sub    $0xc,%esp
80100405:	50                   	push   %eax
80100406:	e8 62 68 00 00       	call   80106c6d <putc_cons>
8010040b:	83 c4 10             	add    $0x10,%esp
    putc_uart(ch);
8010040e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100411:	83 ec 0c             	sub    $0xc,%esp
80100414:	50                   	push   %eax
80100415:	e8 31 63 00 00       	call   8010674b <putc_uart>
8010041a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010041d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100422:	c9                   	leave  
80100423:	c3                   	ret    

80100424 <rcr3>:
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
    return cr2;
}

static inline uintptr_t
rcr3(void) {
80100424:	55                   	push   %ebp
80100425:	89 e5                	mov    %esp,%ebp
80100427:	83 ec 10             	sub    $0x10,%esp
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
8010042a:	0f 20 d8             	mov    %cr3,%eax
8010042d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return cr3;
80100430:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80100433:	c9                   	leave  
80100434:	c3                   	ret    

80100435 <invlpg>:

static inline void
invlpg(void *addr) {
80100435:	55                   	push   %ebp
80100436:	89 e5                	mov    %esp,%ebp
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
80100438:	8b 45 08             	mov    0x8(%ebp),%eax
8010043b:	0f 01 38             	invlpg (%eax)
}
8010043e:	90                   	nop
8010043f:	5d                   	pop    %ebp
80100440:	c3                   	ret    

80100441 <print_e280map>:
#define E820MAP_ADD 0x8000
#define E820MAP_AVA 0x1
//print mem layout
static void
print_e280map()
{
80100441:	55                   	push   %ebp
80100442:	89 e5                	mov    %esp,%ebp
80100444:	83 ec 18             	sub    $0x18,%esp
    int i;
    e820map = (struct e820map*)P2V(E820MAP_ADD);  
80100447:	c7 05 b4 6e 12 80 00 	movl   $0x80008000,0x80126eb4
8010044e:	80 00 80 
    assert(e820map->nr_map != 12345);
80100451:	a1 b4 6e 12 80       	mov    0x80126eb4,%eax
80100456:	8b 00                	mov    (%eax),%eax
80100458:	3d 39 30 00 00       	cmp    $0x3039,%eax
8010045d:	75 19                	jne    80100478 <print_e280map+0x37>
8010045f:	68 c8 a7 10 80       	push   $0x8010a7c8
80100464:	68 e1 a7 10 80       	push   $0x8010a7e1
80100469:	6a 26                	push   $0x26
8010046b:	68 f7 a7 10 80       	push   $0x8010a7f7
80100470:	e8 df fe ff ff       	call   80100354 <__panic>
80100475:	83 c4 10             	add    $0x10,%esp
    for(i = 0 ; i < e820map->nr_map ; i ++)
80100478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010047f:	eb 7f                	jmp    80100500 <print_e280map+0xbf>
    {
        uintptr_t map_start = (uintptr_t)e820map->map[i].addr;
80100481:	8b 0d b4 6e 12 80    	mov    0x80126eb4,%ecx
80100487:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010048a:	89 d0                	mov    %edx,%eax
8010048c:	c1 e0 02             	shl    $0x2,%eax
8010048f:	01 d0                	add    %edx,%eax
80100491:	c1 e0 02             	shl    $0x2,%eax
80100494:	01 c8                	add    %ecx,%eax
80100496:	8b 50 08             	mov    0x8(%eax),%edx
80100499:	8b 40 04             	mov    0x4(%eax),%eax
8010049c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        uint32_t map_size = (uint32_t)e820map->map[i].size;
8010049f:	8b 0d b4 6e 12 80    	mov    0x80126eb4,%ecx
801004a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801004a8:	89 d0                	mov    %edx,%eax
801004aa:	c1 e0 02             	shl    $0x2,%eax
801004ad:	01 d0                	add    %edx,%eax
801004af:	c1 e0 02             	shl    $0x2,%eax
801004b2:	01 c8                	add    %ecx,%eax
801004b4:	8b 50 10             	mov    0x10(%eax),%edx
801004b7:	8b 40 0c             	mov    0xc(%eax),%eax
801004ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
        cprintf("start : %8x, size : %8x, flag : %s\n",map_start,
                map_size, (int)e820map->map[i].type == E820MAP_AVA ? "AVAILABLE" : "USED" );
801004bd:	8b 0d b4 6e 12 80    	mov    0x80126eb4,%ecx
801004c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801004c6:	89 d0                	mov    %edx,%eax
801004c8:	c1 e0 02             	shl    $0x2,%eax
801004cb:	01 d0                	add    %edx,%eax
801004cd:	c1 e0 02             	shl    $0x2,%eax
801004d0:	01 c8                	add    %ecx,%eax
801004d2:	83 c0 14             	add    $0x14,%eax
801004d5:	8b 00                	mov    (%eax),%eax
    assert(e820map->nr_map != 12345);
    for(i = 0 ; i < e820map->nr_map ; i ++)
    {
        uintptr_t map_start = (uintptr_t)e820map->map[i].addr;
        uint32_t map_size = (uint32_t)e820map->map[i].size;
        cprintf("start : %8x, size : %8x, flag : %s\n",map_start,
801004d7:	83 f8 01             	cmp    $0x1,%eax
801004da:	75 07                	jne    801004e3 <print_e280map+0xa2>
801004dc:	b8 05 a8 10 80       	mov    $0x8010a805,%eax
801004e1:	eb 05                	jmp    801004e8 <print_e280map+0xa7>
801004e3:	b8 0f a8 10 80       	mov    $0x8010a80f,%eax
801004e8:	50                   	push   %eax
801004e9:	ff 75 ec             	pushl  -0x14(%ebp)
801004ec:	ff 75 f0             	pushl  -0x10(%ebp)
801004ef:	68 14 a8 10 80       	push   $0x8010a814
801004f4:	e8 de 67 00 00       	call   80106cd7 <cprintf>
801004f9:	83 c4 10             	add    $0x10,%esp
print_e280map()
{
    int i;
    e820map = (struct e820map*)P2V(E820MAP_ADD);  
    assert(e820map->nr_map != 12345);
    for(i = 0 ; i < e820map->nr_map ; i ++)
801004fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100500:	a1 b4 6e 12 80       	mov    0x80126eb4,%eax
80100505:	8b 00                	mov    (%eax),%eax
80100507:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010050a:	0f 8f 71 ff ff ff    	jg     80100481 <print_e280map+0x40>
        uintptr_t map_start = (uintptr_t)e820map->map[i].addr;
        uint32_t map_size = (uint32_t)e820map->map[i].size;
        cprintf("start : %8x, size : %8x, flag : %s\n",map_start,
                map_size, (int)e820map->map[i].type == E820MAP_AVA ? "AVAILABLE" : "USED" );
    }
}
80100510:	90                   	nop
80100511:	c9                   	leave  
80100512:	c3                   	ret    

80100513 <init_pmm_info>:

//init the struct about pmm_info
static void 
init_pmm_info()
{
80100513:	55                   	push   %ebp
80100514:	89 e5                	mov    %esp,%ebp
80100516:	83 ec 28             	sub    $0x28,%esp
    int32_t i;
    pmm_info.start = ROUNDUP(V2P_WO((uintptr_t)end), PGSIZE);
80100519:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
80100520:	b8 d0 9b 12 80       	mov    $0x80129bd0,%eax
80100525:	05 00 00 00 80       	add    $0x80000000,%eax
8010052a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010052d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100535:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100538:	ba 00 00 00 00       	mov    $0x0,%edx
8010053d:	f7 75 ec             	divl   -0x14(%ebp)
80100540:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100543:	29 d0                	sub    %edx,%eax
80100545:	a3 a8 6e 12 80       	mov    %eax,0x80126ea8
    //find available mem
    e820map = (struct e820map*)P2V(E820MAP_ADD);  
8010054a:	c7 05 b4 6e 12 80 00 	movl   $0x80008000,0x80126eb4
80100551:	80 00 80 
    assert(e820map->nr_map != 12345);
80100554:	a1 b4 6e 12 80       	mov    0x80126eb4,%eax
80100559:	8b 00                	mov    (%eax),%eax
8010055b:	3d 39 30 00 00       	cmp    $0x3039,%eax
80100560:	75 19                	jne    8010057b <init_pmm_info+0x68>
80100562:	68 c8 a7 10 80       	push   $0x8010a7c8
80100567:	68 e1 a7 10 80       	push   $0x8010a7e1
8010056c:	6a 38                	push   $0x38
8010056e:	68 f7 a7 10 80       	push   $0x8010a7f7
80100573:	e8 dc fd ff ff       	call   80100354 <__panic>
80100578:	83 c4 10             	add    $0x10,%esp
    for(i = 0 ; i < e820map->nr_map ; i ++)
8010057b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100582:	e9 e5 00 00 00       	jmp    8010066c <init_pmm_info+0x159>
    {
        uintptr_t map_start = (uintptr_t)e820map->map[i].addr;
80100587:	8b 0d b4 6e 12 80    	mov    0x80126eb4,%ecx
8010058d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100590:	89 d0                	mov    %edx,%eax
80100592:	c1 e0 02             	shl    $0x2,%eax
80100595:	01 d0                	add    %edx,%eax
80100597:	c1 e0 02             	shl    $0x2,%eax
8010059a:	01 c8                	add    %ecx,%eax
8010059c:	8b 50 08             	mov    0x8(%eax),%edx
8010059f:	8b 40 04             	mov    0x4(%eax),%eax
801005a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uint32_t map_size = (uint32_t)e820map->map[i].size;
801005a5:	8b 0d b4 6e 12 80    	mov    0x80126eb4,%ecx
801005ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801005ae:	89 d0                	mov    %edx,%eax
801005b0:	c1 e0 02             	shl    $0x2,%eax
801005b3:	01 d0                	add    %edx,%eax
801005b5:	c1 e0 02             	shl    $0x2,%eax
801005b8:	01 c8                	add    %ecx,%eax
801005ba:	8b 50 10             	mov    0x10(%eax),%edx
801005bd:	8b 40 0c             	mov    0xc(%eax),%eax
801005c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        uintptr_t map_end = map_start + map_size;
801005c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801005c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801005c9:	01 d0                	add    %edx,%eax
801005cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
        uint32_t mm_size;
        if((int)e820map->map[i].type == E820MAP_AVA && map_start < pmm_info.start && pmm_info.start < map_end )
801005ce:	8b 0d b4 6e 12 80    	mov    0x80126eb4,%ecx
801005d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801005d7:	89 d0                	mov    %edx,%eax
801005d9:	c1 e0 02             	shl    $0x2,%eax
801005dc:	01 d0                	add    %edx,%eax
801005de:	c1 e0 02             	shl    $0x2,%eax
801005e1:	01 c8                	add    %ecx,%eax
801005e3:	83 c0 14             	add    $0x14,%eax
801005e6:	8b 00                	mov    (%eax),%eax
801005e8:	83 f8 01             	cmp    $0x1,%eax
801005eb:	75 7b                	jne    80100668 <init_pmm_info+0x155>
801005ed:	a1 a8 6e 12 80       	mov    0x80126ea8,%eax
801005f2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
801005f5:	76 71                	jbe    80100668 <init_pmm_info+0x155>
801005f7:	a1 a8 6e 12 80       	mov    0x80126ea8,%eax
801005fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
801005ff:	73 67                	jae    80100668 <init_pmm_info+0x155>
        {
            pmm_info.end = ROUNDDOWN(map_end, PGSIZE);
80100601:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100604:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100607:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010060a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010060f:	a3 ac 6e 12 80       	mov    %eax,0x80126eac
            mm_size = pmm_info.end - pmm_info.start; 
80100614:	8b 15 ac 6e 12 80    	mov    0x80126eac,%edx
8010061a:	a1 a8 6e 12 80       	mov    0x80126ea8,%eax
8010061f:	29 c2                	sub    %eax,%edx
80100621:	89 d0                	mov    %edx,%eax
80100623:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if(mm_size > KMEMSIZE)
80100626:	81 7d f0 00 00 00 38 	cmpl   $0x38000000,-0x10(%ebp)
8010062d:	76 07                	jbe    80100636 <init_pmm_info+0x123>
                mm_size = KMEMSIZE;
8010062f:	c7 45 f0 00 00 00 38 	movl   $0x38000000,-0x10(%ebp)
            assert(mm_size % PGSIZE == 0);
80100636:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100639:	25 ff 0f 00 00       	and    $0xfff,%eax
8010063e:	85 c0                	test   %eax,%eax
80100640:	74 19                	je     8010065b <init_pmm_info+0x148>
80100642:	68 38 a8 10 80       	push   $0x8010a838
80100647:	68 e1 a7 10 80       	push   $0x8010a7e1
8010064c:	6a 45                	push   $0x45
8010064e:	68 f7 a7 10 80       	push   $0x8010a7f7
80100653:	e8 fc fc ff ff       	call   80100354 <__panic>
80100658:	83 c4 10             	add    $0x10,%esp
            pmm_info.size = mm_size / PGSIZE; 
8010065b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010065e:	c1 e8 0c             	shr    $0xc,%eax
80100661:	a3 b0 6e 12 80       	mov    %eax,0x80126eb0
            break;
80100666:	eb 14                	jmp    8010067c <init_pmm_info+0x169>
    int32_t i;
    pmm_info.start = ROUNDUP(V2P_WO((uintptr_t)end), PGSIZE);
    //find available mem
    e820map = (struct e820map*)P2V(E820MAP_ADD);  
    assert(e820map->nr_map != 12345);
    for(i = 0 ; i < e820map->nr_map ; i ++)
80100668:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010066c:	a1 b4 6e 12 80       	mov    0x80126eb4,%eax
80100671:	8b 00                	mov    (%eax),%eax
80100673:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100676:	0f 8f 0b ff ff ff    	jg     80100587 <init_pmm_info+0x74>
            pmm_info.size = mm_size / PGSIZE; 
            break;
        }
    }

    assert(pmm_info.size != 0);
8010067c:	a1 b0 6e 12 80       	mov    0x80126eb0,%eax
80100681:	85 c0                	test   %eax,%eax
80100683:	75 19                	jne    8010069e <init_pmm_info+0x18b>
80100685:	68 4e a8 10 80       	push   $0x8010a84e
8010068a:	68 e1 a7 10 80       	push   $0x8010a7e1
8010068f:	6a 4b                	push   $0x4b
80100691:	68 f7 a7 10 80       	push   $0x8010a7f7
80100696:	e8 b9 fc ff ff       	call   80100354 <__panic>
8010069b:	83 c4 10             	add    $0x10,%esp
}
8010069e:	90                   	nop
8010069f:	c9                   	leave  
801006a0:	c3                   	ret    

801006a1 <print_pmm_info>:

//print pmm_info
static inline void 
print_pmm_info()
{
801006a1:	55                   	push   %ebp
801006a2:	89 e5                	mov    %esp,%ebp
801006a4:	83 ec 08             	sub    $0x8,%esp
    assert(pmm_info.size != 0);
801006a7:	a1 b0 6e 12 80       	mov    0x80126eb0,%eax
801006ac:	85 c0                	test   %eax,%eax
801006ae:	75 19                	jne    801006c9 <print_pmm_info+0x28>
801006b0:	68 4e a8 10 80       	push   $0x8010a84e
801006b5:	68 e1 a7 10 80       	push   $0x8010a7e1
801006ba:	6a 52                	push   $0x52
801006bc:	68 f7 a7 10 80       	push   $0x8010a7f7
801006c1:	e8 8e fc ff ff       	call   80100354 <__panic>
801006c6:	83 c4 10             	add    $0x10,%esp
    cprintf("pmm_start : %8x, pmm_end : %8x, pmm_size(PGSIZE) : %8x\n",pmm_info.start, pmm_info.end,
801006c9:	8b 0d b0 6e 12 80    	mov    0x80126eb0,%ecx
801006cf:	8b 15 ac 6e 12 80    	mov    0x80126eac,%edx
801006d5:	a1 a8 6e 12 80       	mov    0x80126ea8,%eax
801006da:	51                   	push   %ecx
801006db:	52                   	push   %edx
801006dc:	50                   	push   %eax
801006dd:	68 64 a8 10 80       	push   $0x8010a864
801006e2:	e8 f0 65 00 00       	call   80106cd7 <cprintf>
801006e7:	83 c4 10             	add    $0x10,%esp
            pmm_info.size);
}
801006ea:	90                   	nop
801006eb:	c9                   	leave  
801006ec:	c3                   	ret    

801006ed <offset2kva>:

/********************************PMM*****************************************/

static inline void*
offset2kva(uint32_t n)
{
801006ed:	55                   	push   %ebp
801006ee:	89 e5                	mov    %esp,%ebp
    return (void*)P2V_WO(pmm_info.start + PGSIZE * (n));
801006f0:	a1 a8 6e 12 80       	mov    0x80126ea8,%eax
801006f5:	8b 55 08             	mov    0x8(%ebp),%edx
801006f8:	c1 e2 0c             	shl    $0xc,%edx
801006fb:	01 d0                	add    %edx,%eax
801006fd:	05 00 00 00 80       	add    $0x80000000,%eax
}
80100702:	5d                   	pop    %ebp
80100703:	c3                   	ret    

80100704 <kpa2offset>:
static inline uint32_t
kpa2offset(uint32_t addr)
{
80100704:	55                   	push   %ebp
80100705:	89 e5                	mov    %esp,%ebp
    return ((uint32_t)addr - pmm_info.start) / PGSIZE;
80100707:	a1 a8 6e 12 80       	mov    0x80126ea8,%eax
8010070c:	8b 55 08             	mov    0x8(%ebp),%edx
8010070f:	29 c2                	sub    %eax,%edx
80100711:	89 d0                	mov    %edx,%eax
80100713:	c1 e8 0c             	shr    $0xc,%eax
}
80100716:	5d                   	pop    %ebp
80100717:	c3                   	ret    

80100718 <kva2offset>:
static inline uint32_t
kva2offset(void *va)
{
80100718:	55                   	push   %ebp
80100719:	89 e5                	mov    %esp,%ebp
    return kpa2offset(V2P_WO((uint32_t)va)); 
8010071b:	8b 45 08             	mov    0x8(%ebp),%eax
8010071e:	05 00 00 00 80       	add    $0x80000000,%eax
80100723:	50                   	push   %eax
80100724:	e8 db ff ff ff       	call   80100704 <kpa2offset>
80100729:	83 c4 04             	add    $0x4,%esp
}
8010072c:	c9                   	leave  
8010072d:	c3                   	ret    

8010072e <get_page_offset>:
const struct pmm_manager *pmm_manager;
uint32_t
get_page_offset(struct page* page)
{
8010072e:	55                   	push   %ebp
8010072f:	89 e5                	mov    %esp,%ebp
80100731:	53                   	push   %ebx
80100732:	83 ec 14             	sub    $0x14,%esp
    uint32_t ret;
    assert(page >= pmm_manager->ret_page_addr(0));
80100735:	a1 60 70 12 80       	mov    0x80127060,%eax
8010073a:	8b 40 18             	mov    0x18(%eax),%eax
8010073d:	83 ec 0c             	sub    $0xc,%esp
80100740:	6a 00                	push   $0x0
80100742:	ff d0                	call   *%eax
80100744:	83 c4 10             	add    $0x10,%esp
80100747:	3b 45 08             	cmp    0x8(%ebp),%eax
8010074a:	76 19                	jbe    80100765 <get_page_offset+0x37>
8010074c:	68 9c a8 10 80       	push   $0x8010a89c
80100751:	68 e1 a7 10 80       	push   $0x8010a7e1
80100756:	6a 6d                	push   $0x6d
80100758:	68 f7 a7 10 80       	push   $0x8010a7f7
8010075d:	e8 f2 fb ff ff       	call   80100354 <__panic>
80100762:	83 c4 10             	add    $0x10,%esp
    ret = page - pmm_manager->ret_page_addr(0);
80100765:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100768:	a1 60 70 12 80       	mov    0x80127060,%eax
8010076d:	8b 40 18             	mov    0x18(%eax),%eax
80100770:	83 ec 0c             	sub    $0xc,%esp
80100773:	6a 00                	push   $0x0
80100775:	ff d0                	call   *%eax
80100777:	83 c4 10             	add    $0x10,%esp
8010077a:	29 c3                	sub    %eax,%ebx
8010077c:	89 d8                	mov    %ebx,%eax
8010077e:	d1 f8                	sar    %eax
80100780:	69 c0 39 8e e3 38    	imul   $0x38e38e39,%eax,%eax
80100786:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return  ret;
80100789:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010078c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010078f:	c9                   	leave  
80100790:	c3                   	ret    

80100791 <alloc_pages>:

void*
alloc_pages(size_t n)
{
80100791:	55                   	push   %ebp
80100792:	89 e5                	mov    %esp,%ebp
80100794:	83 ec 18             	sub    $0x18,%esp
   uint32_t offset = pmm_manager->alloc_pages(n);
80100797:	a1 60 70 12 80       	mov    0x80127060,%eax
8010079c:	8b 40 08             	mov    0x8(%eax),%eax
8010079f:	83 ec 0c             	sub    $0xc,%esp
801007a2:	ff 75 08             	pushl  0x8(%ebp)
801007a5:	ff d0                	call   *%eax
801007a7:	83 c4 10             	add    $0x10,%esp
801007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if(offset != ALLOC_FALSE)
801007ad:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
801007b1:	74 10                	je     801007c3 <alloc_pages+0x32>
       return offset2kva(offset);  
801007b3:	83 ec 0c             	sub    $0xc,%esp
801007b6:	ff 75 f4             	pushl  -0xc(%ebp)
801007b9:	e8 2f ff ff ff       	call   801006ed <offset2kva>
801007be:	83 c4 10             	add    $0x10,%esp
801007c1:	eb 05                	jmp    801007c8 <alloc_pages+0x37>
   else
       return NULL;
801007c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801007c8:	c9                   	leave  
801007c9:	c3                   	ret    

801007ca <free_pages>:

void
free_pages(void *n)
{
801007ca:	55                   	push   %ebp
801007cb:	89 e5                	mov    %esp,%ebp
801007cd:	83 ec 18             	sub    $0x18,%esp
    assert((uint32_t)n >= KERNBASE);
801007d0:	8b 45 08             	mov    0x8(%ebp),%eax
801007d3:	85 c0                	test   %eax,%eax
801007d5:	78 19                	js     801007f0 <free_pages+0x26>
801007d7:	68 c2 a8 10 80       	push   $0x8010a8c2
801007dc:	68 e1 a7 10 80       	push   $0x8010a7e1
801007e1:	6a 7f                	push   $0x7f
801007e3:	68 f7 a7 10 80       	push   $0x8010a7f7
801007e8:	e8 67 fb ff ff       	call   80100354 <__panic>
801007ed:	83 c4 10             	add    $0x10,%esp
    uint32_t offset = kva2offset(n);    
801007f0:	83 ec 0c             	sub    $0xc,%esp
801007f3:	ff 75 08             	pushl  0x8(%ebp)
801007f6:	e8 1d ff ff ff       	call   80100718 <kva2offset>
801007fb:	83 c4 10             	add    $0x10,%esp
801007fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pmm_manager->free_pages(offset);
80100801:	a1 60 70 12 80       	mov    0x80127060,%eax
80100806:	8b 40 0c             	mov    0xc(%eax),%eax
80100809:	83 ec 0c             	sub    $0xc,%esp
8010080c:	ff 75 f4             	pushl  -0xc(%ebp)
8010080f:	ff d0                	call   *%eax
80100811:	83 c4 10             	add    $0x10,%esp
}
80100814:	90                   	nop
80100815:	c9                   	leave  
80100816:	c3                   	ret    

80100817 <alloc_page>:


/*not use swap ,the fuction is not use*//*use in do_exec*/
struct page*
alloc_page()
{
80100817:	55                   	push   %ebp
80100818:	89 e5                	mov    %esp,%ebp
8010081a:	83 ec 18             	sub    $0x18,%esp
   uint32_t offset;
   while(1)
   {
       offset = pmm_manager->alloc_pages(1);
8010081d:	a1 60 70 12 80       	mov    0x80127060,%eax
80100822:	8b 40 08             	mov    0x8(%eax),%eax
80100825:	83 ec 0c             	sub    $0xc,%esp
80100828:	6a 01                	push   $0x1
8010082a:	ff d0                	call   *%eax
8010082c:	83 c4 10             	add    $0x10,%esp
8010082f:	89 45 f4             	mov    %eax,-0xc(%ebp)
       if (offset != ALLOC_FALSE || swap_init_ok == 0) break;
80100832:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
80100836:	75 20                	jne    80100858 <alloc_page+0x41>
80100838:	a1 b8 6e 12 80       	mov    0x80126eb8,%eax
8010083d:	85 c0                	test   %eax,%eax
8010083f:	74 17                	je     80100858 <alloc_page+0x41>
       extern struct mm_struct *check_mm_struct;
       //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
       swap_out(check_mm_struct, 1, 0);
80100841:	a1 6c 70 12 80       	mov    0x8012706c,%eax
80100846:	83 ec 04             	sub    $0x4,%esp
80100849:	6a 00                	push   $0x0
8010084b:	6a 01                	push   $0x1
8010084d:	50                   	push   %eax
8010084e:	e8 97 03 00 00       	call   80100bea <swap_out>
80100853:	83 c4 10             	add    $0x10,%esp
   }
80100856:	eb c5                	jmp    8010081d <alloc_page+0x6>
   if(offset != ALLOC_FALSE && swap_init_ok == 1)
80100858:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
8010085c:	74 42                	je     801008a0 <alloc_page+0x89>
8010085e:	a1 b8 6e 12 80       	mov    0x80126eb8,%eax
80100863:	83 f8 01             	cmp    $0x1,%eax
80100866:	75 38                	jne    801008a0 <alloc_page+0x89>
   {
       struct page* page = pmm_manager->ret_page_addr(offset);  
80100868:	a1 60 70 12 80       	mov    0x80127060,%eax
8010086d:	8b 40 18             	mov    0x18(%eax),%eax
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	ff 75 f4             	pushl  -0xc(%ebp)
80100876:	ff d0                	call   *%eax
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	89 45 f0             	mov    %eax,-0x10(%ebp)
       page->pra_vaddr = (uintptr_t)offset2kva(offset);
8010087e:	83 ec 0c             	sub    $0xc,%esp
80100881:	ff 75 f4             	pushl  -0xc(%ebp)
80100884:	e8 64 fe ff ff       	call   801006ed <offset2kva>
80100889:	83 c4 10             	add    $0x10,%esp
8010088c:	89 c2                	mov    %eax,%edx
8010088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100891:	89 50 06             	mov    %edx,0x6(%eax)
       page->pgdir = kpgdir;
80100894:	8b 15 68 70 12 80    	mov    0x80127068,%edx
8010089a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010089d:	89 50 02             	mov    %edx,0x2(%eax)
   }

   return offset != ALLOC_FALSE ? pmm_manager->ret_page_addr(offset) : NULL;
801008a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
801008a4:	74 15                	je     801008bb <alloc_page+0xa4>
801008a6:	a1 60 70 12 80       	mov    0x80127060,%eax
801008ab:	8b 40 18             	mov    0x18(%eax),%eax
801008ae:	83 ec 0c             	sub    $0xc,%esp
801008b1:	ff 75 f4             	pushl  -0xc(%ebp)
801008b4:	ff d0                	call   *%eax
801008b6:	83 c4 10             	add    $0x10,%esp
801008b9:	eb 05                	jmp    801008c0 <alloc_page+0xa9>
801008bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801008c0:	c9                   	leave  
801008c1:	c3                   	ret    

801008c2 <free_page>:
//free one page
void
free_page(struct page* page)
{
801008c2:	55                   	push   %ebp
801008c3:	89 e5                	mov    %esp,%ebp
801008c5:	53                   	push   %ebx
801008c6:	83 ec 14             	sub    $0x14,%esp
    assert(page >= pmm_manager->ret_page_addr(0));
801008c9:	a1 60 70 12 80       	mov    0x80127060,%eax
801008ce:	8b 40 18             	mov    0x18(%eax),%eax
801008d1:	83 ec 0c             	sub    $0xc,%esp
801008d4:	6a 00                	push   $0x0
801008d6:	ff d0                	call   *%eax
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	3b 45 08             	cmp    0x8(%ebp),%eax
801008de:	76 1c                	jbe    801008fc <free_page+0x3a>
801008e0:	68 9c a8 10 80       	push   $0x8010a89c
801008e5:	68 e1 a7 10 80       	push   $0x8010a7e1
801008ea:	68 9f 00 00 00       	push   $0x9f
801008ef:	68 f7 a7 10 80       	push   $0x8010a7f7
801008f4:	e8 5b fa ff ff       	call   80100354 <__panic>
801008f9:	83 c4 10             	add    $0x10,%esp
    uint32_t offset = page - pmm_manager->ret_page_addr(0);
801008fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801008ff:	a1 60 70 12 80       	mov    0x80127060,%eax
80100904:	8b 40 18             	mov    0x18(%eax),%eax
80100907:	83 ec 0c             	sub    $0xc,%esp
8010090a:	6a 00                	push   $0x0
8010090c:	ff d0                	call   *%eax
8010090e:	83 c4 10             	add    $0x10,%esp
80100911:	29 c3                	sub    %eax,%ebx
80100913:	89 d8                	mov    %ebx,%eax
80100915:	d1 f8                	sar    %eax
80100917:	69 c0 39 8e e3 38    	imul   $0x38e38e39,%eax,%eax
8010091d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page->pra_vaddr = 0;
80100920:	8b 45 08             	mov    0x8(%ebp),%eax
80100923:	c7 40 06 00 00 00 00 	movl   $0x0,0x6(%eax)
    page->pgdir = NULL;
8010092a:	8b 45 08             	mov    0x8(%ebp),%eax
8010092d:	c7 40 02 00 00 00 00 	movl   $0x0,0x2(%eax)
    pmm_manager->free_pages(offset);
80100934:	a1 60 70 12 80       	mov    0x80127060,%eax
80100939:	8b 40 0c             	mov    0xc(%eax),%eax
8010093c:	83 ec 0c             	sub    $0xc,%esp
8010093f:	ff 75 f4             	pushl  -0xc(%ebp)
80100942:	ff d0                	call   *%eax
80100944:	83 c4 10             	add    $0x10,%esp
}
80100947:	90                   	nop
80100948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010094b:	c9                   	leave  
8010094c:	c3                   	ret    

8010094d <page2kva>:

/*************/

void*
page2kva(struct page* page)
{
8010094d:	55                   	push   %ebp
8010094e:	89 e5                	mov    %esp,%ebp
80100950:	53                   	push   %ebx
80100951:	83 ec 14             	sub    $0x14,%esp
    void * ret;
    assert(page >= pmm_manager->ret_page_addr(0));
80100954:	a1 60 70 12 80       	mov    0x80127060,%eax
80100959:	8b 40 18             	mov    0x18(%eax),%eax
8010095c:	83 ec 0c             	sub    $0xc,%esp
8010095f:	6a 00                	push   $0x0
80100961:	ff d0                	call   *%eax
80100963:	83 c4 10             	add    $0x10,%esp
80100966:	3b 45 08             	cmp    0x8(%ebp),%eax
80100969:	76 1c                	jbe    80100987 <page2kva+0x3a>
8010096b:	68 9c a8 10 80       	push   $0x8010a89c
80100970:	68 e1 a7 10 80       	push   $0x8010a7e1
80100975:	68 ac 00 00 00       	push   $0xac
8010097a:	68 f7 a7 10 80       	push   $0x8010a7f7
8010097f:	e8 d0 f9 ff ff       	call   80100354 <__panic>
80100984:	83 c4 10             	add    $0x10,%esp
    uint32_t offset = page - pmm_manager->ret_page_addr(0);
80100987:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010098a:	a1 60 70 12 80       	mov    0x80127060,%eax
8010098f:	8b 40 18             	mov    0x18(%eax),%eax
80100992:	83 ec 0c             	sub    $0xc,%esp
80100995:	6a 00                	push   $0x0
80100997:	ff d0                	call   *%eax
80100999:	83 c4 10             	add    $0x10,%esp
8010099c:	29 c3                	sub    %eax,%ebx
8010099e:	89 d8                	mov    %ebx,%eax
801009a0:	d1 f8                	sar    %eax
801009a2:	69 c0 39 8e e3 38    	imul   $0x38e38e39,%eax,%eax
801009a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ret = offset2kva(offset);
801009ab:	83 ec 0c             	sub    $0xc,%esp
801009ae:	ff 75 f4             	pushl  -0xc(%ebp)
801009b1:	e8 37 fd ff ff       	call   801006ed <offset2kva>
801009b6:	83 c4 10             	add    $0x10,%esp
801009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return ret;
801009bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801009bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801009c2:	c9                   	leave  
801009c3:	c3                   	ret    

801009c4 <kva2page>:

struct page*
kva2page(void *va)
{
801009c4:	55                   	push   %ebp
801009c5:	89 e5                	mov    %esp,%ebp
801009c7:	83 ec 18             	sub    $0x18,%esp
    struct page *ret;
    uint32_t offset = kva2offset(va);
801009ca:	ff 75 08             	pushl  0x8(%ebp)
801009cd:	e8 46 fd ff ff       	call   80100718 <kva2offset>
801009d2:	83 c4 04             	add    $0x4,%esp
801009d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ret = pmm_manager->ret_page_addr(offset);
801009d8:	a1 60 70 12 80       	mov    0x80127060,%eax
801009dd:	8b 40 18             	mov    0x18(%eax),%eax
801009e0:	83 ec 0c             	sub    $0xc,%esp
801009e3:	ff 75 f4             	pushl  -0xc(%ebp)
801009e6:	ff d0                	call   *%eax
801009e8:	83 c4 10             	add    $0x10,%esp
801009eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return ret;
801009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801009f1:	c9                   	leave  
801009f2:	c3                   	ret    

801009f3 <page2pa>:

uintptr_t
page2pa(struct page* page)
{
801009f3:	55                   	push   %ebp
801009f4:	89 e5                	mov    %esp,%ebp
801009f6:	83 ec 08             	sub    $0x8,%esp
    return V2P(page2kva(page));
801009f9:	83 ec 0c             	sub    $0xc,%esp
801009fc:	ff 75 08             	pushl  0x8(%ebp)
801009ff:	e8 49 ff ff ff       	call   8010094d <page2kva>
80100a04:	83 c4 10             	add    $0x10,%esp
80100a07:	05 00 00 00 80       	add    $0x80000000,%eax
}
80100a0c:	c9                   	leave  
80100a0d:	c3                   	ret    

80100a0e <pa2page>:

struct page*
pa2page(uintptr_t pa)
{
80100a0e:	55                   	push   %ebp
80100a0f:	89 e5                	mov    %esp,%ebp
80100a11:	83 ec 08             	sub    $0x8,%esp
    return kva2page(P2V(pa));
80100a14:	8b 45 08             	mov    0x8(%ebp),%eax
80100a17:	05 00 00 00 80       	add    $0x80000000,%eax
80100a1c:	83 ec 0c             	sub    $0xc,%esp
80100a1f:	50                   	push   %eax
80100a20:	e8 9f ff ff ff       	call   801009c4 <kva2page>
80100a25:	83 c4 10             	add    $0x10,%esp
}
80100a28:	c9                   	leave  
80100a29:	c3                   	ret    

80100a2a <nr_free_pages>:

size_t
nr_free_pages(void){
80100a2a:	55                   	push   %ebp
80100a2b:	89 e5                	mov    %esp,%ebp
80100a2d:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    ret = pmm_manager->nr_free_pages();
80100a30:	a1 60 70 12 80       	mov    0x80127060,%eax
80100a35:	8b 40 10             	mov    0x10(%eax),%eax
80100a38:	ff d0                	call   *%eax
80100a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
80100a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100a40:	c9                   	leave  
80100a41:	c3                   	ret    

80100a42 <init_pmm>:
void 
init_pmm(void)
{
80100a42:	55                   	push   %ebp
80100a43:	89 e5                	mov    %esp,%ebp
80100a45:	83 ec 08             	sub    $0x8,%esp

    print_e280map();
80100a48:	e8 f4 f9 ff ff       	call   80100441 <print_e280map>
    init_pmm_info();
80100a4d:	e8 c1 fa ff ff       	call   80100513 <init_pmm_info>
    print_pmm_info();
80100a52:	e8 4a fc ff ff       	call   801006a1 <print_pmm_info>
    pmm_manager = &buddy_pmm_manager;
80100a57:	c7 05 60 70 12 80 30 	movl   $0x8010b530,0x80127060
80100a5e:	b5 10 80 
    pmm_manager->init(&pmm_info.start, &pmm_info.size);
80100a61:	a1 60 70 12 80       	mov    0x80127060,%eax
80100a66:	8b 40 04             	mov    0x4(%eax),%eax
80100a69:	83 ec 08             	sub    $0x8,%esp
80100a6c:	68 b0 6e 12 80       	push   $0x80126eb0
80100a71:	68 a8 6e 12 80       	push   $0x80126ea8
80100a76:	ff d0                	call   *%eax
80100a78:	83 c4 10             	add    $0x10,%esp
    cprintf(INITOK"pmm init ok !\n");
80100a7b:	83 ec 0c             	sub    $0xc,%esp
80100a7e:	68 da a8 10 80       	push   $0x8010a8da
80100a83:	e8 4f 62 00 00       	call   80106cd7 <cprintf>
80100a88:	83 c4 10             	add    $0x10,%esp

    assert(pmm_info.size != 0 );
80100a8b:	a1 b0 6e 12 80       	mov    0x80126eb0,%eax
80100a90:	85 c0                	test   %eax,%eax
80100a92:	75 1c                	jne    80100ab0 <init_pmm+0x6e>
80100a94:	68 4e a8 10 80       	push   $0x8010a84e
80100a99:	68 e1 a7 10 80       	push   $0x8010a7e1
80100a9e:	68 d8 00 00 00       	push   $0xd8
80100aa3:	68 f7 a7 10 80       	push   $0x8010a7f7
80100aa8:	e8 a7 f8 ff ff       	call   80100354 <__panic>
80100aad:	83 c4 10             	add    $0x10,%esp

    vmm_init();
80100ab0:	e8 56 15 00 00       	call   8010200b <vmm_init>
    init_slab_allocator();
80100ab5:	e8 90 20 00 00       	call   80102b4a <init_slab_allocator>
    //suggest 1
    slab_allocator_test(1);   
80100aba:	83 ec 0c             	sub    $0xc,%esp
80100abd:	6a 01                	push   $0x1
80100abf:	e8 51 23 00 00       	call   80102e15 <slab_allocator_test>
80100ac4:	83 c4 10             	add    $0x10,%esp
}
80100ac7:	90                   	nop
80100ac8:	c9                   	leave  
80100ac9:	c3                   	ret    

80100aca <tlb_invalidate>:


// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
80100aca:	55                   	push   %ebp
80100acb:	89 e5                	mov    %esp,%ebp
    if (rcr3() == V2P(pgdir)) {
80100acd:	e8 52 f9 ff ff       	call   80100424 <rcr3>
80100ad2:	89 c2                	mov    %eax,%edx
80100ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ad7:	05 00 00 00 80       	add    $0x80000000,%eax
80100adc:	39 c2                	cmp    %eax,%edx
80100ade:	75 0c                	jne    80100aec <tlb_invalidate+0x22>
        invlpg((void *)la);
80100ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ae3:	50                   	push   %eax
80100ae4:	e8 4c f9 ff ff       	call   80100435 <invlpg>
80100ae9:	83 c4 04             	add    $0x4,%esp
    }
}
80100aec:	90                   	nop
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <swap_init>:

static void check_swap(void);

bool
swap_init(void)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	83 ec 18             	sub    $0x18,%esp
    swapfs_init();
80100af5:	e8 13 4a 00 00       	call   8010550d <swapfs_init>

    if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
80100afa:	a1 64 70 12 80       	mov    0x80127064,%eax
80100aff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
80100b04:	76 0c                	jbe    80100b12 <swap_init+0x23>
80100b06:	a1 64 70 12 80       	mov    0x80127064,%eax
80100b0b:	3d ff ff ff 00       	cmp    $0xffffff,%eax
80100b10:	76 1a                	jbe    80100b2c <swap_init+0x3d>
    {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
80100b12:	a1 64 70 12 80       	mov    0x80127064,%eax
80100b17:	50                   	push   %eax
80100b18:	68 f4 a8 10 80       	push   $0x8010a8f4
80100b1d:	6a 26                	push   $0x26
80100b1f:	68 0f a9 10 80       	push   $0x8010a90f
80100b24:	e8 2b f8 ff ff       	call   80100354 <__panic>
80100b29:	83 c4 10             	add    $0x10,%esp
    }



    sm = &swap_manager_lru;
80100b2c:	c7 05 c0 6e 12 80 40 	movl   $0x80124040,0x80126ec0
80100b33:	40 12 80 
    bool r = sm->init();
80100b36:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100b3b:	8b 40 04             	mov    0x4(%eax),%eax
80100b3e:	ff d0                	call   *%eax
80100b40:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (r)
80100b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100b47:	74 27                	je     80100b70 <swap_init+0x81>
    {
        swap_init_ok = 1;
80100b49:	c7 05 b8 6e 12 80 01 	movl   $0x1,0x80126eb8
80100b50:	00 00 00 
        cprintf("SWAP: manager = %s\n", sm->name);
80100b53:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100b58:	8b 00                	mov    (%eax),%eax
80100b5a:	83 ec 08             	sub    $0x8,%esp
80100b5d:	50                   	push   %eax
80100b5e:	68 1e a9 10 80       	push   $0x8010a91e
80100b63:	e8 6f 61 00 00       	call   80106cd7 <cprintf>
80100b68:	83 c4 10             	add    $0x10,%esp
        check_swap();
80100b6b:	e8 80 02 00 00       	call   80100df0 <check_swap>
    }

    return r;
80100b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100b73:	c9                   	leave  
80100b74:	c3                   	ret    

80100b75 <swap_init_mm>:


int
swap_init_mm(struct mm_struct *mm)
{
80100b75:	55                   	push   %ebp
80100b76:	89 e5                	mov    %esp,%ebp
80100b78:	83 ec 08             	sub    $0x8,%esp
    return sm->init_mm(mm);
80100b7b:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100b80:	8b 40 08             	mov    0x8(%eax),%eax
80100b83:	83 ec 0c             	sub    $0xc,%esp
80100b86:	ff 75 08             	pushl  0x8(%ebp)
80100b89:	ff d0                	call   *%eax
80100b8b:	83 c4 10             	add    $0x10,%esp
}
80100b8e:	c9                   	leave  
80100b8f:	c3                   	ret    

80100b90 <swap_tick_event>:


int
swap_tick_event(struct mm_struct *mm)
{
80100b90:	55                   	push   %ebp
80100b91:	89 e5                	mov    %esp,%ebp
80100b93:	83 ec 08             	sub    $0x8,%esp
    return sm->tick_event(mm);
80100b96:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100b9b:	8b 40 0c             	mov    0xc(%eax),%eax
80100b9e:	83 ec 0c             	sub    $0xc,%esp
80100ba1:	ff 75 08             	pushl  0x8(%ebp)
80100ba4:	ff d0                	call   *%eax
80100ba6:	83 c4 10             	add    $0x10,%esp
}
80100ba9:	c9                   	leave  
80100baa:	c3                   	ret    

80100bab <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct page *page, int swap_in)
{
80100bab:	55                   	push   %ebp
80100bac:	89 e5                	mov    %esp,%ebp
80100bae:	83 ec 08             	sub    $0x8,%esp
    return sm->map_swappable(mm, addr, page, swap_in);
80100bb1:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100bb6:	8b 40 10             	mov    0x10(%eax),%eax
80100bb9:	ff 75 14             	pushl  0x14(%ebp)
80100bbc:	ff 75 10             	pushl  0x10(%ebp)
80100bbf:	ff 75 0c             	pushl  0xc(%ebp)
80100bc2:	ff 75 08             	pushl  0x8(%ebp)
80100bc5:	ff d0                	call   *%eax
80100bc7:	83 c4 10             	add    $0x10,%esp
}
80100bca:	c9                   	leave  
80100bcb:	c3                   	ret    

80100bcc <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
80100bcc:	55                   	push   %ebp
80100bcd:	89 e5                	mov    %esp,%ebp
80100bcf:	83 ec 08             	sub    $0x8,%esp
    return sm->set_unswappable(mm, addr);
80100bd2:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100bd7:	8b 40 14             	mov    0x14(%eax),%eax
80100bda:	83 ec 08             	sub    $0x8,%esp
80100bdd:	ff 75 0c             	pushl  0xc(%ebp)
80100be0:	ff 75 08             	pushl  0x8(%ebp)
80100be3:	ff d0                	call   *%eax
80100be5:	83 c4 10             	add    $0x10,%esp
}
80100be8:	c9                   	leave  
80100be9:	c3                   	ret    

80100bea <swap_out>:
volatile unsigned int swap_out_num=0;


int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
80100bea:	55                   	push   %ebp
80100beb:	89 e5                	mov    %esp,%ebp
80100bed:	83 ec 28             	sub    $0x28,%esp
    int i;
    static int tmpi = 0;
    for (i = 0; i != n; ++ i)
80100bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100bf7:	e9 2f 01 00 00       	jmp    80100d2b <swap_out+0x141>
    {
        uintptr_t v;
        //struct Page **ptr_page=NULL;
        struct page *page;
        // cprintf("i %d, SWAP: call swap_out_victim\n",i);
        int r = sm->swap_out_victim(mm, &page, in_tick);
80100bfc:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100c01:	8b 40 18             	mov    0x18(%eax),%eax
80100c04:	83 ec 04             	sub    $0x4,%esp
80100c07:	ff 75 10             	pushl  0x10(%ebp)
80100c0a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
80100c0d:	52                   	push   %edx
80100c0e:	ff 75 08             	pushl  0x8(%ebp)
80100c11:	ff d0                	call   *%eax
80100c13:	83 c4 10             	add    $0x10,%esp
80100c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (r == false) {
80100c19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100c1d:	75 18                	jne    80100c37 <swap_out+0x4d>
            cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
80100c1f:	83 ec 08             	sub    $0x8,%esp
80100c22:	ff 75 f4             	pushl  -0xc(%ebp)
80100c25:	68 34 a9 10 80       	push   $0x8010a934
80100c2a:	e8 a8 60 00 00       	call   80106cd7 <cprintf>
80100c2f:	83 c4 10             	add    $0x10,%esp
80100c32:	e9 00 01 00 00       	jmp    80100d37 <swap_out+0x14d>
            break;
        }
        //assert(!PageReserved(page));

        //cprintf("SWAP: choose victim page 0x%08x\n", page);
        v=page->pra_vaddr;
80100c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c3a:	8b 40 06             	mov    0x6(%eax),%eax
80100c3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
         
        pte_t *ptep = read_pte_addr(mm->pgdir, v, 0);
80100c40:	8b 45 08             	mov    0x8(%ebp),%eax
80100c43:	8b 40 0c             	mov    0xc(%eax),%eax
80100c46:	83 ec 04             	sub    $0x4,%esp
80100c49:	6a 00                	push   $0x0
80100c4b:	ff 75 ec             	pushl  -0x14(%ebp)
80100c4e:	50                   	push   %eax
80100c4f:	e8 a2 02 00 00       	call   80100ef6 <read_pte_addr>
80100c54:	83 c4 10             	add    $0x10,%esp
80100c57:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert((*ptep & PTE_P) != 0);
80100c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c5d:	8b 00                	mov    (%eax),%eax
80100c5f:	83 e0 01             	and    $0x1,%eax
80100c62:	85 c0                	test   %eax,%eax
80100c64:	75 19                	jne    80100c7f <swap_out+0x95>
80100c66:	68 61 a9 10 80       	push   $0x8010a961
80100c6b:	68 76 a9 10 80       	push   $0x8010a976
80100c70:	6a 6b                	push   $0x6b
80100c72:	68 0f a9 10 80       	push   $0x8010a90f
80100c77:	e8 d8 f6 ff ff       	call   80100354 <__panic>
80100c7c:	83 c4 10             	add    $0x10,%esp
    
        //warning
        if (swapfs_write(tmpi<<8, page) != 0) {
80100c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c82:	8b 15 c4 6e 12 80    	mov    0x80126ec4,%edx
80100c88:	c1 e2 08             	shl    $0x8,%edx
80100c8b:	83 ec 08             	sub    $0x8,%esp
80100c8e:	50                   	push   %eax
80100c8f:	52                   	push   %edx
80100c90:	e8 4f 49 00 00       	call   801055e4 <swapfs_write>
80100c95:	83 c4 10             	add    $0x10,%esp
80100c98:	85 c0                	test   %eax,%eax
80100c9a:	74 2b                	je     80100cc7 <swap_out+0xdd>
            cprintf("SWAP: failed to save\n");
80100c9c:	83 ec 0c             	sub    $0xc,%esp
80100c9f:	68 8c a9 10 80       	push   $0x8010a98c
80100ca4:	e8 2e 60 00 00       	call   80106cd7 <cprintf>
80100ca9:	83 c4 10             	add    $0x10,%esp
            sm->map_swappable(mm, v, page, 0);
80100cac:	a1 c0 6e 12 80       	mov    0x80126ec0,%eax
80100cb1:	8b 40 10             	mov    0x10(%eax),%eax
80100cb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100cb7:	6a 00                	push   $0x0
80100cb9:	52                   	push   %edx
80100cba:	ff 75 ec             	pushl  -0x14(%ebp)
80100cbd:	ff 75 08             	pushl  0x8(%ebp)
80100cc0:	ff d0                	call   *%eax
80100cc2:	83 c4 10             	add    $0x10,%esp
80100cc5:	eb 60                	jmp    80100d27 <swap_out+0x13d>
            continue;
        }
        else {
            cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
80100cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cca:	8b 40 06             	mov    0x6(%eax),%eax
80100ccd:	c1 e8 0c             	shr    $0xc,%eax
80100cd0:	83 c0 01             	add    $0x1,%eax
80100cd3:	50                   	push   %eax
80100cd4:	ff 75 ec             	pushl  -0x14(%ebp)
80100cd7:	ff 75 f4             	pushl  -0xc(%ebp)
80100cda:	68 a4 a9 10 80       	push   $0x8010a9a4
80100cdf:	e8 f3 5f 00 00       	call   80106cd7 <cprintf>
80100ce4:	83 c4 10             	add    $0x10,%esp
            *ptep = (tmpi)<<8;
80100ce7:	a1 c4 6e 12 80       	mov    0x80126ec4,%eax
80100cec:	c1 e0 08             	shl    $0x8,%eax
80100cef:	89 c2                	mov    %eax,%edx
80100cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cf4:	89 10                	mov    %edx,(%eax)
            tmpi ++;
80100cf6:	a1 c4 6e 12 80       	mov    0x80126ec4,%eax
80100cfb:	83 c0 01             	add    $0x1,%eax
80100cfe:	a3 c4 6e 12 80       	mov    %eax,0x80126ec4
            free_page(page);
80100d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d06:	83 ec 0c             	sub    $0xc,%esp
80100d09:	50                   	push   %eax
80100d0a:	e8 b3 fb ff ff       	call   801008c2 <free_page>
80100d0f:	83 c4 10             	add    $0x10,%esp
        }

        tlb_invalidate(mm->pgdir, v);
80100d12:	8b 45 08             	mov    0x8(%ebp),%eax
80100d15:	8b 40 0c             	mov    0xc(%eax),%eax
80100d18:	83 ec 08             	sub    $0x8,%esp
80100d1b:	ff 75 ec             	pushl  -0x14(%ebp)
80100d1e:	50                   	push   %eax
80100d1f:	e8 a6 fd ff ff       	call   80100aca <tlb_invalidate>
80100d24:	83 c4 10             	add    $0x10,%esp
int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
    int i;
    static int tmpi = 0;
    for (i = 0; i != n; ++ i)
80100d27:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100d2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80100d31:	0f 85 c5 fe ff ff    	jne    80100bfc <swap_out+0x12>
            free_page(page);
        }

        tlb_invalidate(mm->pgdir, v);
    }
    return i;
80100d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100d3a:	c9                   	leave  
80100d3b:	c3                   	ret    

80100d3c <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct page **ptr_result)
{
80100d3c:	55                   	push   %ebp
80100d3d:	89 e5                	mov    %esp,%ebp
80100d3f:	83 ec 18             	sub    $0x18,%esp
     struct page *result = alloc_page();
80100d42:	e8 d0 fa ff ff       	call   80100817 <alloc_page>
80100d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
80100d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100d4e:	75 1c                	jne    80100d6c <swap_in+0x30>
80100d50:	68 e4 a9 10 80       	push   $0x8010a9e4
80100d55:	68 76 a9 10 80       	push   $0x8010a976
80100d5a:	68 83 00 00 00       	push   $0x83
80100d5f:	68 0f a9 10 80       	push   $0x8010a90f
80100d64:	e8 eb f5 ff ff       	call   80100354 <__panic>
80100d69:	83 c4 10             	add    $0x10,%esp

     pte_t *ptep = read_pte_addr(mm->pgdir, addr, 0);
80100d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6f:	8b 40 0c             	mov    0xc(%eax),%eax
80100d72:	83 ec 04             	sub    $0x4,%esp
80100d75:	6a 00                	push   $0x0
80100d77:	ff 75 0c             	pushl  0xc(%ebp)
80100d7a:	50                   	push   %eax
80100d7b:	e8 76 01 00 00       	call   80100ef6 <read_pte_addr>
80100d80:	83 c4 10             	add    $0x10,%esp
80100d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));

     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
80100d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d89:	8b 00                	mov    (%eax),%eax
80100d8b:	83 ec 08             	sub    $0x8,%esp
80100d8e:	ff 75 f4             	pushl  -0xc(%ebp)
80100d91:	50                   	push   %eax
80100d92:	e8 f3 47 00 00       	call   8010558a <swapfs_read>
80100d97:	83 c4 10             	add    $0x10,%esp
80100d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100da1:	74 22                	je     80100dc5 <swap_in+0x89>
     {
        assert(r!=0);
80100da3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100da7:	75 1c                	jne    80100dc5 <swap_in+0x89>
80100da9:	68 f1 a9 10 80       	push   $0x8010a9f1
80100dae:	68 76 a9 10 80       	push   $0x8010a976
80100db3:	68 8b 00 00 00       	push   $0x8b
80100db8:	68 0f a9 10 80       	push   $0x8010a90f
80100dbd:	e8 92 f5 ff ff       	call   80100354 <__panic>
80100dc2:	83 c4 10             	add    $0x10,%esp
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
80100dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100dc8:	8b 00                	mov    (%eax),%eax
80100dca:	c1 e8 08             	shr    $0x8,%eax
80100dcd:	83 ec 04             	sub    $0x4,%esp
80100dd0:	ff 75 0c             	pushl  0xc(%ebp)
80100dd3:	50                   	push   %eax
80100dd4:	68 f8 a9 10 80       	push   $0x8010a9f8
80100dd9:	e8 f9 5e 00 00       	call   80106cd7 <cprintf>
80100dde:	83 c4 10             	add    $0x10,%esp
     *ptr_result=result;
80100de1:	8b 45 10             	mov    0x10(%ebp),%eax
80100de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100de7:	89 10                	mov    %edx,(%eax)
     return 1;
80100de9:	b8 01 00 00 00       	mov    $0x1,%eax
}
80100dee:	c9                   	leave  
80100def:	c3                   	ret    

80100df0 <check_swap>:
}


static void
check_swap(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
     cprintf("count is %d, total is %d\n",count,total);
     //assert(count == 0);

     cprintf("check_swap() succeeded!\n");
#endif
}
80100df3:	90                   	nop
80100df4:	5d                   	pop    %ebp
80100df5:	c3                   	ret    

80100df6 <ltr>:
cli(void) {
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
80100df6:	55                   	push   %ebp
80100df7:	89 e5                	mov    %esp,%ebp
80100df9:	83 ec 04             	sub    $0x4,%esp
80100dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80100dff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    asm volatile ("ltr %0" :: "r" (sel));
80100e03:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80100e07:	0f 00 d8             	ltr    %ax
}
80100e0a:	90                   	nop
80100e0b:	c9                   	leave  
80100e0c:	c3                   	ret    

80100e0d <lgdt>:
  return eflags;
}

static inline void
lgdt(struct segdesc *p, int size)
{
80100e0d:	55                   	push   %ebp
80100e0e:	89 e5                	mov    %esp,%ebp
80100e10:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80100e13:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e16:	83 e8 01             	sub    $0x1,%eax
80100e19:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80100e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80100e20:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80100e24:	8b 45 08             	mov    0x8(%ebp),%eax
80100e27:	c1 e8 10             	shr    $0x10,%eax
80100e2a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80100e2e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80100e31:	0f 01 10             	lgdtl  (%eax)
}
80100e34:	90                   	nop
80100e35:	c9                   	leave  
80100e36:	c3                   	ret    

80100e37 <lcr3>:
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
}

static inline void
lcr3(uint32_t val)
{
80100e37:	55                   	push   %ebp
80100e38:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80100e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80100e3d:	0f 22 d8             	mov    %eax,%cr3
}
80100e40:	90                   	nop
80100e41:	5d                   	pop    %ebp
80100e42:	c3                   	ret    

80100e43 <mm_count_inc>:

bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write);


static inline int
mm_count_inc(struct mm_struct *mm) {
80100e43:	55                   	push   %ebp
80100e44:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
80100e46:	8b 45 08             	mov    0x8(%ebp),%eax
80100e49:	8b 40 14             	mov    0x14(%eax),%eax
80100e4c:	8d 50 01             	lea    0x1(%eax),%edx
80100e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80100e52:	89 50 14             	mov    %edx,0x14(%eax)
    return mm->mm_count;
80100e55:	8b 45 08             	mov    0x8(%ebp),%eax
80100e58:	8b 40 14             	mov    0x14(%eax),%eax
}
80100e5b:	5d                   	pop    %ebp
80100e5c:	c3                   	ret    

80100e5d <mm_count>:
    mm->mm_count -= 1;
    return mm->mm_count;
}

static inline int
mm_count(struct mm_struct *mm) {
80100e5d:	55                   	push   %ebp
80100e5e:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
80100e60:	8b 45 08             	mov    0x8(%ebp),%eax
80100e63:	8b 40 14             	mov    0x14(%eax),%eax
}
80100e66:	5d                   	pop    %ebp
80100e67:	c3                   	ret    

80100e68 <set_mm_count>:

static inline int
set_mm_count(struct mm_struct *mm, int val){
80100e68:	55                   	push   %ebp
80100e69:	89 e5                	mov    %esp,%ebp
   return mm->mm_count = val; 
80100e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
80100e71:	89 50 14             	mov    %edx,0x14(%eax)
80100e74:	8b 45 08             	mov    0x8(%ebp),%eax
80100e77:	8b 40 14             	mov    0x14(%eax),%eax
}
80100e7a:	5d                   	pop    %ebp
80100e7b:	c3                   	ret    

80100e7c <pte2page>:
};

pte_t *kpgdir;

static inline struct page *
pte2page(pte_t pte) {
80100e7c:	55                   	push   %ebp
80100e7d:	89 e5                	mov    %esp,%ebp
80100e7f:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
80100e82:	8b 45 08             	mov    0x8(%ebp),%eax
80100e85:	83 e0 01             	and    $0x1,%eax
80100e88:	85 c0                	test   %eax,%eax
80100e8a:	75 17                	jne    80100ea3 <pte2page+0x27>
        panic("pte2page called with invalid pte");
80100e8c:	83 ec 04             	sub    $0x4,%esp
80100e8f:	68 38 aa 10 80       	push   $0x8010aa38
80100e94:	6a 22                	push   $0x22
80100e96:	68 59 aa 10 80       	push   $0x8010aa59
80100e9b:	e8 b4 f4 ff ff       	call   80100354 <__panic>
80100ea0:	83 c4 10             	add    $0x10,%esp
    }
    return pa2page((pte) & ~0xFFF);
80100ea3:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100eab:	83 ec 0c             	sub    $0xc,%esp
80100eae:	50                   	push   %eax
80100eaf:	e8 5a fb ff ff       	call   80100a0e <pa2page>
80100eb4:	83 c4 10             	add    $0x10,%esp
}
80100eb7:	c9                   	leave  
80100eb8:	c3                   	ret    

80100eb9 <pde2page>:


static inline struct page *
pde2page(pte_t pte) {
80100eb9:	55                   	push   %ebp
80100eba:	89 e5                	mov    %esp,%ebp
80100ebc:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
80100ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80100ec2:	83 e0 01             	and    $0x1,%eax
80100ec5:	85 c0                	test   %eax,%eax
80100ec7:	75 17                	jne    80100ee0 <pde2page+0x27>
        panic("pte2page called with invalid pte");
80100ec9:	83 ec 04             	sub    $0x4,%esp
80100ecc:	68 38 aa 10 80       	push   $0x8010aa38
80100ed1:	6a 2b                	push   $0x2b
80100ed3:	68 59 aa 10 80       	push   $0x8010aa59
80100ed8:	e8 77 f4 ff ff       	call   80100354 <__panic>
80100edd:	83 c4 10             	add    $0x10,%esp
    }
    return pa2page((pte) & ~0xFFF);
80100ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	50                   	push   %eax
80100eec:	e8 1d fb ff ff       	call   80100a0e <pa2page>
80100ef1:	83 c4 10             	add    $0x10,%esp
}
80100ef4:	c9                   	leave  
80100ef5:	c3                   	ret    

80100ef6 <read_pte_addr>:

/**************************************PAGE***********************************/

pte_t*
read_pte_addr(pde_t *pgdir, uintptr_t va, int32_t alloc)
{
80100ef6:	55                   	push   %ebp
80100ef7:	89 e5                	mov    %esp,%ebp
80100ef9:	83 ec 18             	sub    $0x18,%esp
    pde_t* pde = &pgdir[PDX(va)];
80100efc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eff:	c1 e8 16             	shr    $0x16,%eax
80100f02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f09:	8b 45 08             	mov    0x8(%ebp),%eax
80100f0c:	01 d0                	add    %edx,%eax
80100f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    pte_t* pte; 
    if(*pde & PTE_P)
80100f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f14:	8b 00                	mov    (%eax),%eax
80100f16:	83 e0 01             	and    $0x1,%eax
80100f19:	85 c0                	test   %eax,%eax
80100f1b:	74 14                	je     80100f31 <read_pte_addr+0x3b>
    {
       pte = (pte_t*)P2V_WO(PTE_ADDR(*pde)); 
80100f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f20:	8b 00                	mov    (%eax),%eax
80100f22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100f27:	05 00 00 00 80       	add    $0x80000000,%eax
80100f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f2f:	eb 74                	jmp    80100fa5 <read_pte_addr+0xaf>
    }else{
       if(!alloc || (pte = (pte_t*)alloc_pages(1)) == NULL)
80100f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100f35:	74 16                	je     80100f4d <read_pte_addr+0x57>
80100f37:	83 ec 0c             	sub    $0xc,%esp
80100f3a:	6a 01                	push   $0x1
80100f3c:	e8 50 f8 ff ff       	call   80100791 <alloc_pages>
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100f4b:	75 07                	jne    80100f54 <read_pte_addr+0x5e>
            return NULL;
80100f4d:	b8 00 00 00 00       	mov    $0x0,%eax
80100f52:	eb 68                	jmp    80100fbc <read_pte_addr+0xc6>
       //make sure PTE_P bits are zero.
       memset(pte, 0 ,PGSIZE);
80100f54:	83 ec 04             	sub    $0x4,%esp
80100f57:	68 00 10 00 00       	push   $0x1000
80100f5c:	6a 00                	push   $0x0
80100f5e:	ff 75 f4             	pushl  -0xc(%ebp)
80100f61:	e8 e2 94 00 00       	call   8010a448 <memset>
80100f66:	83 c4 10             	add    $0x10,%esp
       assert(((uint32_t)pte & 0x3ff) == 0);
80100f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6c:	25 ff 03 00 00       	and    $0x3ff,%eax
80100f71:	85 c0                	test   %eax,%eax
80100f73:	74 19                	je     80100f8e <read_pte_addr+0x98>
80100f75:	68 67 aa 10 80       	push   $0x8010aa67
80100f7a:	68 84 aa 10 80       	push   $0x8010aa84
80100f7f:	6a 40                	push   $0x40
80100f81:	68 59 aa 10 80       	push   $0x8010aa59
80100f86:	e8 c9 f3 ff ff       	call   80100354 <__panic>
80100f8b:	83 c4 10             	add    $0x10,%esp
       //PTE_U maybe dangerous,but it is very convenient to create user's page table(just copy it).
       *pde = PTE_ADDR(V2P(pte)) | PTE_P | PTE_W | PTE_U ;   
80100f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f91:	05 00 00 00 80       	add    $0x80000000,%eax
80100f96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100f9b:	83 c8 07             	or     $0x7,%eax
80100f9e:	89 c2                	mov    %eax,%edx
80100fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100fa3:	89 10                	mov    %edx,(%eax)
    }
    return &pte[PTX(va)];
80100fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fa8:	c1 e8 0c             	shr    $0xc,%eax
80100fab:	25 ff 03 00 00       	and    $0x3ff,%eax
80100fb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fba:	01 d0                	add    %edx,%eax
}
80100fbc:	c9                   	leave  
80100fbd:	c3                   	ret    

80100fbe <page_remove_pte>:

//sub fuction for page_remove
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
80100fbe:	55                   	push   %ebp
80100fbf:	89 e5                	mov    %esp,%ebp
80100fc1:	83 ec 18             	sub    $0x18,%esp
    if (*ptep & PTE_P) {
80100fc4:	8b 45 10             	mov    0x10(%ebp),%eax
80100fc7:	8b 00                	mov    (%eax),%eax
80100fc9:	83 e0 01             	and    $0x1,%eax
80100fcc:	85 c0                	test   %eax,%eax
80100fce:	74 3c                	je     8010100c <page_remove_pte+0x4e>
        struct page *page = pte2page(*ptep);
80100fd0:	8b 45 10             	mov    0x10(%ebp),%eax
80100fd3:	8b 00                	mov    (%eax),%eax
80100fd5:	83 ec 0c             	sub    $0xc,%esp
80100fd8:	50                   	push   %eax
80100fd9:	e8 9e fe ff ff       	call   80100e7c <pte2page>
80100fde:	83 c4 10             	add    $0x10,%esp
80100fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        free_page(page);
80100fe4:	83 ec 0c             	sub    $0xc,%esp
80100fe7:	ff 75 f4             	pushl  -0xc(%ebp)
80100fea:	e8 d3 f8 ff ff       	call   801008c2 <free_page>
80100fef:	83 c4 10             	add    $0x10,%esp
        *ptep = 0;
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
80100ffb:	83 ec 08             	sub    $0x8,%esp
80100ffe:	ff 75 0c             	pushl  0xc(%ebp)
80101001:	ff 75 08             	pushl  0x8(%ebp)
80101004:	e8 c1 fa ff ff       	call   80100aca <tlb_invalidate>
80101009:	83 c4 10             	add    $0x10,%esp
    }
}
8010100c:	90                   	nop
8010100d:	c9                   	leave  
8010100e:	c3                   	ret    

8010100f <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
8010100f:	55                   	push   %ebp
80101010:	89 e5                	mov    %esp,%ebp
80101012:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = read_pte_addr(pgdir, la, 0);
80101015:	83 ec 04             	sub    $0x4,%esp
80101018:	6a 00                	push   $0x0
8010101a:	ff 75 0c             	pushl  0xc(%ebp)
8010101d:	ff 75 08             	pushl  0x8(%ebp)
80101020:	e8 d1 fe ff ff       	call   80100ef6 <read_pte_addr>
80101025:	83 c4 10             	add    $0x10,%esp
80101028:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
8010102b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010102f:	74 14                	je     80101045 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
80101031:	83 ec 04             	sub    $0x4,%esp
80101034:	ff 75 f4             	pushl  -0xc(%ebp)
80101037:	ff 75 0c             	pushl  0xc(%ebp)
8010103a:	ff 75 08             	pushl  0x8(%ebp)
8010103d:	e8 7c ff ff ff       	call   80100fbe <page_remove_pte>
80101042:	83 c4 10             	add    $0x10,%esp
    }
}
80101045:	90                   	nop
80101046:	c9                   	leave  
80101047:	c3                   	ret    

80101048 <page_insert>:

//insert page with page and perm in la
int
page_insert(pde_t *pgdir, struct page *page, uintptr_t la, uint32_t perm) {
80101048:	55                   	push   %ebp
80101049:	89 e5                	mov    %esp,%ebp
8010104b:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = read_pte_addr(pgdir, la, 1);
8010104e:	83 ec 04             	sub    $0x4,%esp
80101051:	6a 01                	push   $0x1
80101053:	ff 75 10             	pushl  0x10(%ebp)
80101056:	ff 75 08             	pushl  0x8(%ebp)
80101059:	e8 98 fe ff ff       	call   80100ef6 <read_pte_addr>
8010105e:	83 c4 10             	add    $0x10,%esp
80101061:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
80101064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101068:	75 07                	jne    80101071 <page_insert+0x29>
        return -1;
8010106a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010106f:	eb 6d                	jmp    801010de <page_insert+0x96>
    }
//    page_ref_inc(page);
    if (*ptep & PTE_P) {
80101071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101074:	8b 00                	mov    (%eax),%eax
80101076:	83 e0 01             	and    $0x1,%eax
80101079:	85 c0                	test   %eax,%eax
8010107b:	74 30                	je     801010ad <page_insert+0x65>
        struct page *p = pte2page(*ptep);
8010107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101080:	8b 00                	mov    (%eax),%eax
80101082:	83 ec 0c             	sub    $0xc,%esp
80101085:	50                   	push   %eax
80101086:	e8 f1 fd ff ff       	call   80100e7c <pte2page>
8010108b:	83 c4 10             	add    $0x10,%esp
8010108e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
80101091:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101094:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101097:	74 14                	je     801010ad <page_insert+0x65>
 //           page_ref_dec(page);
           ;
        }
        else {
            page_remove_pte(pgdir, la, ptep);
80101099:	83 ec 04             	sub    $0x4,%esp
8010109c:	ff 75 f4             	pushl  -0xc(%ebp)
8010109f:	ff 75 10             	pushl  0x10(%ebp)
801010a2:	ff 75 08             	pushl  0x8(%ebp)
801010a5:	e8 14 ff ff ff       	call   80100fbe <page_remove_pte>
801010aa:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	ff 75 0c             	pushl  0xc(%ebp)
801010b3:	e8 3b f9 ff ff       	call   801009f3 <page2pa>
801010b8:	83 c4 10             	add    $0x10,%esp
801010bb:	0b 45 14             	or     0x14(%ebp),%eax
801010be:	83 c8 01             	or     $0x1,%eax
801010c1:	89 c2                	mov    %eax,%edx
801010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010c6:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
801010c8:	83 ec 08             	sub    $0x8,%esp
801010cb:	ff 75 10             	pushl  0x10(%ebp)
801010ce:	ff 75 08             	pushl  0x8(%ebp)
801010d1:	e8 f4 f9 ff ff       	call   80100aca <tlb_invalidate>
801010d6:	83 c4 10             	add    $0x10,%esp
    return 0;
801010d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010de:	c9                   	leave  
801010df:	c3                   	ret    

801010e0 <pgdir_alloc_page>:

struct page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	83 ec 18             	sub    $0x18,%esp
    struct page *page = alloc_page();
801010e6:	e8 2c f7 ff ff       	call   80100817 <alloc_page>
801010eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
801010ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801010f2:	74 5e                	je     80101152 <pgdir_alloc_page+0x72>
        if (page_insert(pgdir, page, la, perm) != 0) {
801010f4:	ff 75 10             	pushl  0x10(%ebp)
801010f7:	ff 75 0c             	pushl  0xc(%ebp)
801010fa:	ff 75 f4             	pushl  -0xc(%ebp)
801010fd:	ff 75 08             	pushl  0x8(%ebp)
80101100:	e8 43 ff ff ff       	call   80101048 <page_insert>
80101105:	83 c4 10             	add    $0x10,%esp
80101108:	85 c0                	test   %eax,%eax
8010110a:	74 15                	je     80101121 <pgdir_alloc_page+0x41>
            free_page(page);
8010110c:	83 ec 0c             	sub    $0xc,%esp
8010110f:	ff 75 f4             	pushl  -0xc(%ebp)
80101112:	e8 ab f7 ff ff       	call   801008c2 <free_page>
80101117:	83 c4 10             	add    $0x10,%esp
            return NULL;
8010111a:	b8 00 00 00 00       	mov    $0x0,%eax
8010111f:	eb 34                	jmp    80101155 <pgdir_alloc_page+0x75>
        }
        
        if (swap_init_ok){
80101121:	a1 b8 6e 12 80       	mov    0x80126eb8,%eax
80101126:	85 c0                	test   %eax,%eax
80101128:	74 28                	je     80101152 <pgdir_alloc_page+0x72>
            page->pra_vaddr=la;
8010112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010112d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101130:	89 50 06             	mov    %edx,0x6(%eax)
            page->pgdir = pgdir;
80101133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101136:	8b 55 08             	mov    0x8(%ebp),%edx
80101139:	89 50 02             	mov    %edx,0x2(%eax)
            swap_map_swappable(check_mm_struct, la, page, 0);
8010113c:	a1 6c 70 12 80       	mov    0x8012706c,%eax
80101141:	6a 00                	push   $0x0
80101143:	ff 75 f4             	pushl  -0xc(%ebp)
80101146:	ff 75 0c             	pushl  0xc(%ebp)
80101149:	50                   	push   %eax
8010114a:	e8 5c fa ff ff       	call   80100bab <swap_map_swappable>
8010114f:	83 c4 10             	add    $0x10,%esp
        }

    }

    return page;
80101152:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101155:	c9                   	leave  
80101156:	c3                   	ret    

80101157 <map_pages>:



static int
map_pages(pde_t *pgdir, uintptr_t va_st, uintptr_t size, uintptr_t pa, int32_t perm)
{
80101157:	55                   	push   %ebp
80101158:	89 e5                	mov    %esp,%ebp
8010115a:	83 ec 18             	sub    $0x18,%esp
    uintptr_t va_i = PGROUNDDOWN(va_st);
8010115d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80101165:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t va_ed;
    pte_t* pte;
    size = PGROUNDUP(size);           
80101168:	8b 45 10             	mov    0x10(%ebp),%eax
8010116b:	05 ff 0f 00 00       	add    $0xfff,%eax
80101170:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80101175:	89 45 10             	mov    %eax,0x10(%ebp)
    pa = PGROUNDDOWN(pa);
80101178:	81 65 14 00 f0 ff ff 	andl   $0xfffff000,0x14(%ebp)
    va_ed = va_st + size;
8010117f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101182:	8b 45 10             	mov    0x10(%ebp),%eax
80101185:	01 d0                	add    %edx,%eax
80101187:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for( ;  ; )
    {
        if((pte = read_pte_addr(pgdir, va_i, 1)) == NULL)
8010118a:	83 ec 04             	sub    $0x4,%esp
8010118d:	6a 01                	push   $0x1
8010118f:	ff 75 f4             	pushl  -0xc(%ebp)
80101192:	ff 75 08             	pushl  0x8(%ebp)
80101195:	e8 5c fd ff ff       	call   80100ef6 <read_pte_addr>
8010119a:	83 c4 10             	add    $0x10,%esp
8010119d:	89 45 ec             	mov    %eax,-0x14(%ebp)
801011a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801011a4:	75 07                	jne    801011ad <map_pages+0x56>
        {
            return -1;
801011a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ab:	eb 56                	jmp    80101203 <map_pages+0xac>
        }
        assert(!(*pte & PTE_P));
801011ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011b0:	8b 00                	mov    (%eax),%eax
801011b2:	83 e0 01             	and    $0x1,%eax
801011b5:	85 c0                	test   %eax,%eax
801011b7:	74 1c                	je     801011d5 <map_pages+0x7e>
801011b9:	68 9a aa 10 80       	push   $0x8010aa9a
801011be:	68 84 aa 10 80       	push   $0x8010aa84
801011c3:	68 98 00 00 00       	push   $0x98
801011c8:	68 59 aa 10 80       	push   $0x8010aa59
801011cd:	e8 82 f1 ff ff       	call   80100354 <__panic>
801011d2:	83 c4 10             	add    $0x10,%esp
        *pte = pa | perm | PTE_P;
801011d5:	8b 45 18             	mov    0x18(%ebp),%eax
801011d8:	0b 45 14             	or     0x14(%ebp),%eax
801011db:	83 c8 01             	or     $0x1,%eax
801011de:	89 c2                	mov    %eax,%edx
801011e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011e3:	89 10                	mov    %edx,(%eax)
        va_i += PGSIZE, pa += PGSIZE;
801011e5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801011ec:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
        if(va_i == va_ed) break;
801011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801011f9:	74 02                	je     801011fd <map_pages+0xa6>
    }
801011fb:	eb 8d                	jmp    8010118a <map_pages+0x33>
            return -1;
        }
        assert(!(*pte & PTE_P));
        *pte = pa | perm | PTE_P;
        va_i += PGSIZE, pa += PGSIZE;
        if(va_i == va_ed) break;
801011fd:	90                   	nop
    }
    return 0;
801011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101203:	c9                   	leave  
80101204:	c3                   	ret    

80101205 <setup_kvm>:



pde_t* 
setup_kvm(void)
{
80101205:	55                   	push   %ebp
80101206:	89 e5                	mov    %esp,%ebp
80101208:	53                   	push   %ebx
80101209:	83 ec 14             	sub    $0x14,%esp
    pde_t *pgdir;
    struct kmap *k;

    if((pgdir = (pde_t*)alloc_pages(1)) == NULL)
8010120c:	83 ec 0c             	sub    $0xc,%esp
8010120f:	6a 01                	push   $0x1
80101211:	e8 7b f5 ff ff       	call   80100791 <alloc_pages>
80101216:	83 c4 10             	add    $0x10,%esp
80101219:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010121c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101220:	75 0a                	jne    8010122c <setup_kvm+0x27>
        return NULL;
80101222:	b8 00 00 00 00       	mov    $0x0,%eax
80101227:	e9 a1 00 00 00       	jmp    801012cd <setup_kvm+0xc8>
    memset(pgdir, 0, PGSIZE);
8010122c:	83 ec 04             	sub    $0x4,%esp
8010122f:	68 00 10 00 00       	push   $0x1000
80101234:	6a 00                	push   $0x0
80101236:	ff 75 f0             	pushl  -0x10(%ebp)
80101239:	e8 0a 92 00 00       	call   8010a448 <memset>
8010123e:	83 c4 10             	add    $0x10,%esp
    kmap[2].phys_end = pmm_info.end;
80101241:	a1 ac 6e 12 80       	mov    0x80126eac,%eax
80101246:	a3 28 40 12 80       	mov    %eax,0x80124028
    assert(P2V_WO(pmm_info.end) < DEVSPACE);
8010124b:	a1 ac 6e 12 80       	mov    0x80126eac,%eax
80101250:	05 00 00 00 80       	add    $0x80000000,%eax
80101255:	3d ff ff ff fd       	cmp    $0xfdffffff,%eax
8010125a:	76 1c                	jbe    80101278 <setup_kvm+0x73>
8010125c:	68 ac aa 10 80       	push   $0x8010aaac
80101261:	68 84 aa 10 80       	push   $0x8010aa84
80101266:	68 ac 00 00 00       	push   $0xac
8010126b:	68 59 aa 10 80       	push   $0x8010aa59
80101270:	e8 df f0 ff ff       	call   80100354 <__panic>
80101275:	83 c4 10             	add    $0x10,%esp
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80101278:	c7 45 f4 00 40 12 80 	movl   $0x80124000,-0xc(%ebp)
8010127f:	eb 40                	jmp    801012c1 <setup_kvm+0xbc>
    {
        if(map_pages(pgdir, k->virt, k->phys_end - k->phys_start,
80101281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101284:	8b 48 0c             	mov    0xc(%eax),%ecx
                    (uintptr_t)k->phys_start, k->perm) < 0)
80101287:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010128a:	8b 50 04             	mov    0x4(%eax),%edx
    memset(pgdir, 0, PGSIZE);
    kmap[2].phys_end = pmm_info.end;
    assert(P2V_WO(pmm_info.end) < DEVSPACE);
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    {
        if(map_pages(pgdir, k->virt, k->phys_end - k->phys_start,
8010128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101290:	8b 58 08             	mov    0x8(%eax),%ebx
80101293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101296:	8b 40 04             	mov    0x4(%eax),%eax
80101299:	29 c3                	sub    %eax,%ebx
8010129b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010129e:	8b 00                	mov    (%eax),%eax
801012a0:	83 ec 0c             	sub    $0xc,%esp
801012a3:	51                   	push   %ecx
801012a4:	52                   	push   %edx
801012a5:	53                   	push   %ebx
801012a6:	50                   	push   %eax
801012a7:	ff 75 f0             	pushl  -0x10(%ebp)
801012aa:	e8 a8 fe ff ff       	call   80101157 <map_pages>
801012af:	83 c4 20             	add    $0x20,%esp
801012b2:	85 c0                	test   %eax,%eax
801012b4:	79 07                	jns    801012bd <setup_kvm+0xb8>
                    (uintptr_t)k->phys_start, k->perm) < 0)
            return NULL;
801012b6:	b8 00 00 00 00       	mov    $0x0,%eax
801012bb:	eb 10                	jmp    801012cd <setup_kvm+0xc8>
    if((pgdir = (pde_t*)alloc_pages(1)) == NULL)
        return NULL;
    memset(pgdir, 0, PGSIZE);
    kmap[2].phys_end = pmm_info.end;
    assert(P2V_WO(pmm_info.end) < DEVSPACE);
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801012bd:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801012c1:	81 7d f4 40 40 12 80 	cmpl   $0x80124040,-0xc(%ebp)
801012c8:	72 b7                	jb     80101281 <setup_kvm+0x7c>
    {
        if(map_pages(pgdir, k->virt, k->phys_end - k->phys_start,
                    (uintptr_t)k->phys_start, k->perm) < 0)
            return NULL;
    }
    return pgdir;
801012ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801012cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012d0:	c9                   	leave  
801012d1:	c3                   	ret    

801012d2 <kvm_print>:

int 
kvm_print(pde_t* pgdir)
{
801012d2:	55                   	push   %ebp
801012d3:	89 e5                	mov    %esp,%ebp
801012d5:	83 ec 28             	sub    $0x28,%esp
    int32_t i = 0,j = 0;
801012d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801012df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    int32_t perm;
    uintptr_t start;
    uint32_t size,first;
    pte_t *pte;
    pde_t *pde;
    cprintf("-------------------- BEGIN --------------------\n");
801012e6:	83 ec 0c             	sub    $0xc,%esp
801012e9:	68 cc aa 10 80       	push   $0x8010aacc
801012ee:	e8 e4 59 00 00       	call   80106cd7 <cprintf>
801012f3:	83 c4 10             	add    $0x10,%esp
    for(i = 0,first = 0,size = 0 ; i < (PGSIZE / sizeof(uintptr_t)); i ++)
801012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801012fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80101304:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010130b:	e9 58 01 00 00       	jmp    80101468 <kvm_print+0x196>
    {
        pde = &pgdir[i]; 
80101310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010131a:	8b 45 08             	mov    0x8(%ebp),%eax
8010131d:	01 d0                	add    %edx,%eax
8010131f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if(*pde & PTE_P)
80101322:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101325:	8b 00                	mov    (%eax),%eax
80101327:	83 e0 01             	and    $0x1,%eax
8010132a:	85 c0                	test   %eax,%eax
8010132c:	0f 84 08 01 00 00    	je     8010143a <kvm_print+0x168>
        {

            pte = (pte_t*)P2V_WO(PTE_ADDR(*pde)); 
80101332:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101335:	8b 00                	mov    (%eax),%eax
80101337:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010133c:	05 00 00 00 80       	add    $0x80000000,%eax
80101341:	89 45 d8             	mov    %eax,-0x28(%ebp)

            for(j = 0 ; j < (PGSIZE / sizeof(uintptr_t)) ;j ++) 
80101344:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010134b:	e9 da 00 00 00       	jmp    8010142a <kvm_print+0x158>
            {
                if(pte[j] & PTE_P)
80101350:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010135a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010135d:	01 d0                	add    %edx,%eax
8010135f:	8b 00                	mov    (%eax),%eax
80101361:	83 e0 01             	and    $0x1,%eax
80101364:	85 c0                	test   %eax,%eax
80101366:	0f 84 90 00 00 00    	je     801013fc <kvm_print+0x12a>
                {
                    if(first == 0 || (first == 1 && (PTE_FLAGS(pte[j]) != perm) ))
8010136c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101370:	74 25                	je     80101397 <kvm_print+0xc5>
80101372:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
80101376:	75 7b                	jne    801013f3 <kvm_print+0x121>
80101378:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010137b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101382:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101385:	01 d0                	add    %edx,%eax
80101387:	8b 00                	mov    (%eax),%eax
80101389:	25 ff 0f 00 00       	and    $0xfff,%eax
8010138e:	89 c2                	mov    %eax,%edx
80101390:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101393:	39 c2                	cmp    %eax,%edx
80101395:	74 5c                	je     801013f3 <kvm_print+0x121>
                    {
                        if(size != 0)
80101397:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010139b:	74 16                	je     801013b3 <kvm_print+0xe1>
                        {
                            cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
8010139d:	ff 75 ec             	pushl  -0x14(%ebp)
801013a0:	ff 75 e4             	pushl  -0x1c(%ebp)
801013a3:	ff 75 e8             	pushl  -0x18(%ebp)
801013a6:	68 00 ab 10 80       	push   $0x8010ab00
801013ab:	e8 27 59 00 00       	call   80106cd7 <cprintf>
801013b0:	83 c4 10             	add    $0x10,%esp
                        }
                        perm = PTE_FLAGS(pte[j]);
801013b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801013bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801013c0:	01 d0                	add    %edx,%eax
801013c2:	8b 00                	mov    (%eax),%eax
801013c4:	25 ff 0f 00 00       	and    $0xfff,%eax
801013c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
                        first = 1;
801013cc:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
                        size = 0;
801013d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                        start = PTE_ADDR(pte[j]);
801013da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801013e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801013e7:	01 d0                	add    %edx,%eax
801013e9:	8b 00                	mov    (%eax),%eax
801013eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801013f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
                    }
                    size += PGSIZE;
801013f3:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
801013fa:	eb 2a                	jmp    80101426 <kvm_print+0x154>
                }else{
                    if(size != 0)
801013fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80101400:	74 1d                	je     8010141f <kvm_print+0x14d>
                    {
                        cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
80101402:	ff 75 ec             	pushl  -0x14(%ebp)
80101405:	ff 75 e4             	pushl  -0x1c(%ebp)
80101408:	ff 75 e8             	pushl  -0x18(%ebp)
8010140b:	68 00 ab 10 80       	push   $0x8010ab00
80101410:	e8 c2 58 00 00       	call   80106cd7 <cprintf>
80101415:	83 c4 10             	add    $0x10,%esp
                        size = 0;
80101418:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                    }
                    first = 0;
8010141f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        if(*pde & PTE_P)
        {

            pte = (pte_t*)P2V_WO(PTE_ADDR(*pde)); 

            for(j = 0 ; j < (PGSIZE / sizeof(uintptr_t)) ;j ++) 
80101426:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
80101432:	0f 86 18 ff ff ff    	jbe    80101350 <kvm_print+0x7e>
80101438:	eb 2a                	jmp    80101464 <kvm_print+0x192>
                }
                    
            }

        }else{
            if(size != 0)
8010143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010143e:	74 1d                	je     8010145d <kvm_print+0x18b>
            {
                cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
80101440:	ff 75 ec             	pushl  -0x14(%ebp)
80101443:	ff 75 e4             	pushl  -0x1c(%ebp)
80101446:	ff 75 e8             	pushl  -0x18(%ebp)
80101449:	68 00 ab 10 80       	push   $0x8010ab00
8010144e:	e8 84 58 00 00       	call   80106cd7 <cprintf>
80101453:	83 c4 10             	add    $0x10,%esp
                size = 0;
80101456:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            }
            first = 0;
8010145d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    uintptr_t start;
    uint32_t size,first;
    pte_t *pte;
    pde_t *pde;
    cprintf("-------------------- BEGIN --------------------\n");
    for(i = 0,first = 0,size = 0 ; i < (PGSIZE / sizeof(uintptr_t)); i ++)
80101464:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010146b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
80101470:	0f 86 9a fe ff ff    	jbe    80101310 <kvm_print+0x3e>
            first = 0;
        }


    }
    if(size != 0)
80101476:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010147a:	74 1d                	je     80101499 <kvm_print+0x1c7>
    {
        cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
8010147c:	ff 75 ec             	pushl  -0x14(%ebp)
8010147f:	ff 75 e4             	pushl  -0x1c(%ebp)
80101482:	ff 75 e8             	pushl  -0x18(%ebp)
80101485:	68 00 ab 10 80       	push   $0x8010ab00
8010148a:	e8 48 58 00 00       	call   80106cd7 <cprintf>
8010148f:	83 c4 10             	add    $0x10,%esp
        size = 0;
80101492:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }
    cprintf("--------------------- END ---------------------\n");
80101499:	83 ec 0c             	sub    $0xc,%esp
8010149c:	68 28 ab 10 80       	push   $0x8010ab28
801014a1:	e8 31 58 00 00       	call   80106cd7 <cprintf>
801014a6:	83 c4 10             	add    $0x10,%esp
    return 1;
801014a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
801014ae:	c9                   	leave  
801014af:	c3                   	ret    

801014b0 <switchkvm>:


void
switchkvm(void)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801014b3:	a1 68 70 12 80       	mov    0x80127068,%eax
801014b8:	05 00 00 00 80       	add    $0x80000000,%eax
801014bd:	50                   	push   %eax
801014be:	e8 74 f9 ff ff       	call   80100e37 <lcr3>
801014c3:	83 c4 04             	add    $0x4,%esp
}
801014c6:	90                   	nop
801014c7:	c9                   	leave  
801014c8:	c3                   	ret    

801014c9 <switchuvm>:

void 
switchuvm(struct proc *p)
{
801014c9:	55                   	push   %ebp
801014ca:	89 e5                	mov    %esp,%ebp
801014cc:	53                   	push   %ebx
801014cd:	83 ec 14             	sub    $0x14,%esp
  if(p == 0)
801014d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801014d4:	75 1a                	jne    801014f0 <switchuvm+0x27>
    panic("switchuvm: no process");
801014d6:	83 ec 04             	sub    $0x4,%esp
801014d9:	68 59 ab 10 80       	push   $0x8010ab59
801014de:	68 02 01 00 00       	push   $0x102
801014e3:	68 59 aa 10 80       	push   $0x8010aa59
801014e8:	e8 67 ee ff ff       	call   80100354 <__panic>
801014ed:	83 c4 10             	add    $0x10,%esp
  if(p->kstack == 0)
801014f0:	8b 45 08             	mov    0x8(%ebp),%eax
801014f3:	8b 40 30             	mov    0x30(%eax),%eax
801014f6:	85 c0                	test   %eax,%eax
801014f8:	75 1a                	jne    80101514 <switchuvm+0x4b>
    panic("switchuvm: no kstack");
801014fa:	83 ec 04             	sub    $0x4,%esp
801014fd:	68 6f ab 10 80       	push   $0x8010ab6f
80101502:	68 04 01 00 00       	push   $0x104
80101507:	68 59 aa 10 80       	push   $0x8010aa59
8010150c:	e8 43 ee ff ff       	call   80100354 <__panic>
80101511:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80101514:	8b 45 08             	mov    0x8(%ebp),%eax
80101517:	8b 40 28             	mov    0x28(%eax),%eax
8010151a:	85 c0                	test   %eax,%eax
8010151c:	75 1a                	jne    80101538 <switchuvm+0x6f>
    panic("switchuvm: no pgdir");
8010151e:	83 ec 04             	sub    $0x4,%esp
80101521:	68 84 ab 10 80       	push   $0x8010ab84
80101526:	68 06 01 00 00       	push   $0x106
8010152b:	68 59 aa 10 80       	push   $0x8010aa59
80101530:	e8 1f ee ff ff       	call   80100354 <__panic>
80101535:	83 c4 10             	add    $0x10,%esp

  push_cli();
80101538:	e8 58 61 00 00       	call   80107695 <push_cli>
  struct cpu *cpu = PCPU;
8010153d:	e8 29 50 00 00       	call   8010656b <get_cpu>
80101542:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80101548:	05 c0 78 12 80       	add    $0x801278c0,%eax
8010154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts), 0);
80101550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101553:	83 c0 40             	add    $0x40,%eax
80101556:	89 c3                	mov    %eax,%ebx
80101558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010155b:	83 c0 40             	add    $0x40,%eax
8010155e:	c1 e8 10             	shr    $0x10,%eax
80101561:	89 c2                	mov    %eax,%edx
80101563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101566:	83 c0 40             	add    $0x40,%eax
80101569:	c1 e8 18             	shr    $0x18,%eax
8010156c:	89 c1                	mov    %eax,%ecx
8010156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101571:	66 c7 40 34 68 00    	movw   $0x68,0x34(%eax)
80101577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010157a:	66 89 58 36          	mov    %bx,0x36(%eax)
8010157e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101581:	88 50 38             	mov    %dl,0x38(%eax)
80101584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101587:	0f b6 50 39          	movzbl 0x39(%eax),%edx
8010158b:	83 e2 f0             	and    $0xfffffff0,%edx
8010158e:	83 ca 09             	or     $0x9,%edx
80101591:	88 50 39             	mov    %dl,0x39(%eax)
80101594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101597:	0f b6 50 39          	movzbl 0x39(%eax),%edx
8010159b:	83 ca 10             	or     $0x10,%edx
8010159e:	88 50 39             	mov    %dl,0x39(%eax)
801015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a4:	0f b6 50 39          	movzbl 0x39(%eax),%edx
801015a8:	83 e2 9f             	and    $0xffffff9f,%edx
801015ab:	88 50 39             	mov    %dl,0x39(%eax)
801015ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015b1:	0f b6 50 39          	movzbl 0x39(%eax),%edx
801015b5:	83 ca 80             	or     $0xffffff80,%edx
801015b8:	88 50 39             	mov    %dl,0x39(%eax)
801015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015be:	0f b6 50 3a          	movzbl 0x3a(%eax),%edx
801015c2:	83 e2 f0             	and    $0xfffffff0,%edx
801015c5:	88 50 3a             	mov    %dl,0x3a(%eax)
801015c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015cb:	0f b6 50 3a          	movzbl 0x3a(%eax),%edx
801015cf:	83 e2 ef             	and    $0xffffffef,%edx
801015d2:	88 50 3a             	mov    %dl,0x3a(%eax)
801015d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d8:	0f b6 50 3a          	movzbl 0x3a(%eax),%edx
801015dc:	83 e2 df             	and    $0xffffffdf,%edx
801015df:	88 50 3a             	mov    %dl,0x3a(%eax)
801015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e5:	0f b6 50 3a          	movzbl 0x3a(%eax),%edx
801015e9:	83 ca 40             	or     $0x40,%edx
801015ec:	88 50 3a             	mov    %dl,0x3a(%eax)
801015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f2:	0f b6 50 3a          	movzbl 0x3a(%eax),%edx
801015f6:	83 e2 7f             	and    $0x7f,%edx
801015f9:	88 50 3a             	mov    %dl,0x3a(%eax)
801015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ff:	88 48 3b             	mov    %cl,0x3b(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80101602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101605:	0f b6 50 39          	movzbl 0x39(%eax),%edx
80101609:	83 e2 ef             	and    $0xffffffef,%edx
8010160c:	88 50 39             	mov    %dl,0x39(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101612:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  cpu->ts.esp0 = (uintptr_t)p->kstack + KSTACKSIZES;
80101618:	8b 45 08             	mov    0x8(%ebp),%eax
8010161b:	8b 40 30             	mov    0x30(%eax),%eax
8010161e:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80101624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101627:	89 50 44             	mov    %edx,0x44(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
8010162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010162d:	66 c7 80 a6 00 00 00 	movw   $0xffff,0xa6(%eax)
80101634:	ff ff 
  ltr(SEG_TSS << 3);
80101636:	83 ec 0c             	sub    $0xc,%esp
80101639:	6a 30                	push   $0x30
8010163b:	e8 b6 f7 ff ff       	call   80100df6 <ltr>
80101640:	83 c4 10             	add    $0x10,%esp

  lcr3(V2P(p->pgdir));  // switch to process's address space
80101643:	8b 45 08             	mov    0x8(%ebp),%eax
80101646:	8b 40 28             	mov    0x28(%eax),%eax
80101649:	05 00 00 00 80       	add    $0x80000000,%eax
8010164e:	83 ec 0c             	sub    $0xc,%esp
80101651:	50                   	push   %eax
80101652:	e8 e0 f7 ff ff       	call   80100e37 <lcr3>
80101657:	83 c4 10             	add    $0x10,%esp
  pop_cli();
8010165a:	e8 94 60 00 00       	call   801076f3 <pop_cli>
}
8010165f:	90                   	nop
80101660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101663:	c9                   	leave  
80101664:	c3                   	ret    

80101665 <init_kvm>:

int32_t 
init_kvm(void)
{
80101665:	55                   	push   %ebp
80101666:	89 e5                	mov    %esp,%ebp
80101668:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setup_kvm();
8010166b:	e8 95 fb ff ff       	call   80101205 <setup_kvm>
80101670:	a3 68 70 12 80       	mov    %eax,0x80127068
    if(kpgdir == NULL) return 1;
80101675:	a1 68 70 12 80       	mov    0x80127068,%eax
8010167a:	85 c0                	test   %eax,%eax
8010167c:	75 07                	jne    80101685 <init_kvm+0x20>
8010167e:	b8 01 00 00 00       	mov    $0x1,%eax
80101683:	eb 1b                	jmp    801016a0 <init_kvm+0x3b>
    kvm_print(kpgdir);
80101685:	a1 68 70 12 80       	mov    0x80127068,%eax
8010168a:	83 ec 0c             	sub    $0xc,%esp
8010168d:	50                   	push   %eax
8010168e:	e8 3f fc ff ff       	call   801012d2 <kvm_print>
80101693:	83 c4 10             	add    $0x10,%esp
    switchkvm();
80101696:	e8 15 fe ff ff       	call   801014b0 <switchkvm>
    return -1;
8010169b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801016a0:	c9                   	leave  
801016a1:	c3                   	ret    

801016a2 <seginit>:


void
seginit(void)
{
801016a2:	55                   	push   %ebp
801016a3:	89 e5                	mov    %esp,%ebp
801016a5:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[get_cpu()];
801016a8:	e8 be 4e 00 00       	call   8010656b <get_cpu>
801016ad:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801016b3:	05 c0 78 12 80       	add    $0x801278c0,%eax
801016b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801016bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016be:	66 c7 40 0c ff ff    	movw   $0xffff,0xc(%eax)
801016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c7:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
801016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d0:	c6 40 10 00          	movb   $0x0,0x10(%eax)
801016d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d7:	0f b6 50 11          	movzbl 0x11(%eax),%edx
801016db:	83 e2 f0             	and    $0xfffffff0,%edx
801016de:	83 ca 0a             	or     $0xa,%edx
801016e1:	88 50 11             	mov    %dl,0x11(%eax)
801016e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016e7:	0f b6 50 11          	movzbl 0x11(%eax),%edx
801016eb:	83 ca 10             	or     $0x10,%edx
801016ee:	88 50 11             	mov    %dl,0x11(%eax)
801016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f4:	0f b6 50 11          	movzbl 0x11(%eax),%edx
801016f8:	83 e2 9f             	and    $0xffffff9f,%edx
801016fb:	88 50 11             	mov    %dl,0x11(%eax)
801016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101701:	0f b6 50 11          	movzbl 0x11(%eax),%edx
80101705:	83 ca 80             	or     $0xffffff80,%edx
80101708:	88 50 11             	mov    %dl,0x11(%eax)
8010170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170e:	0f b6 50 12          	movzbl 0x12(%eax),%edx
80101712:	83 ca 0f             	or     $0xf,%edx
80101715:	88 50 12             	mov    %dl,0x12(%eax)
80101718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010171b:	0f b6 50 12          	movzbl 0x12(%eax),%edx
8010171f:	83 e2 ef             	and    $0xffffffef,%edx
80101722:	88 50 12             	mov    %dl,0x12(%eax)
80101725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101728:	0f b6 50 12          	movzbl 0x12(%eax),%edx
8010172c:	83 e2 df             	and    $0xffffffdf,%edx
8010172f:	88 50 12             	mov    %dl,0x12(%eax)
80101732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101735:	0f b6 50 12          	movzbl 0x12(%eax),%edx
80101739:	83 ca 40             	or     $0x40,%edx
8010173c:	88 50 12             	mov    %dl,0x12(%eax)
8010173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101742:	0f b6 50 12          	movzbl 0x12(%eax),%edx
80101746:	83 ca 80             	or     $0xffffff80,%edx
80101749:	88 50 12             	mov    %dl,0x12(%eax)
8010174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174f:	c6 40 13 00          	movb   $0x0,0x13(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80101753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101756:	66 c7 40 14 ff ff    	movw   $0xffff,0x14(%eax)
8010175c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175f:	66 c7 40 16 00 00    	movw   $0x0,0x16(%eax)
80101765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101768:	c6 40 18 00          	movb   $0x0,0x18(%eax)
8010176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176f:	0f b6 50 19          	movzbl 0x19(%eax),%edx
80101773:	83 e2 f0             	and    $0xfffffff0,%edx
80101776:	83 ca 02             	or     $0x2,%edx
80101779:	88 50 19             	mov    %dl,0x19(%eax)
8010177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177f:	0f b6 50 19          	movzbl 0x19(%eax),%edx
80101783:	83 ca 10             	or     $0x10,%edx
80101786:	88 50 19             	mov    %dl,0x19(%eax)
80101789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178c:	0f b6 50 19          	movzbl 0x19(%eax),%edx
80101790:	83 e2 9f             	and    $0xffffff9f,%edx
80101793:	88 50 19             	mov    %dl,0x19(%eax)
80101796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101799:	0f b6 50 19          	movzbl 0x19(%eax),%edx
8010179d:	83 ca 80             	or     $0xffffff80,%edx
801017a0:	88 50 19             	mov    %dl,0x19(%eax)
801017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a6:	0f b6 50 1a          	movzbl 0x1a(%eax),%edx
801017aa:	83 ca 0f             	or     $0xf,%edx
801017ad:	88 50 1a             	mov    %dl,0x1a(%eax)
801017b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b3:	0f b6 50 1a          	movzbl 0x1a(%eax),%edx
801017b7:	83 e2 ef             	and    $0xffffffef,%edx
801017ba:	88 50 1a             	mov    %dl,0x1a(%eax)
801017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c0:	0f b6 50 1a          	movzbl 0x1a(%eax),%edx
801017c4:	83 e2 df             	and    $0xffffffdf,%edx
801017c7:	88 50 1a             	mov    %dl,0x1a(%eax)
801017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cd:	0f b6 50 1a          	movzbl 0x1a(%eax),%edx
801017d1:	83 ca 40             	or     $0x40,%edx
801017d4:	88 50 1a             	mov    %dl,0x1a(%eax)
801017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017da:	0f b6 50 1a          	movzbl 0x1a(%eax),%edx
801017de:	83 ca 80             	or     $0xffffff80,%edx
801017e1:	88 50 1a             	mov    %dl,0x1a(%eax)
801017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e7:	c6 40 1b 00          	movb   $0x0,0x1b(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ee:	66 c7 40 24 ff ff    	movw   $0xffff,0x24(%eax)
801017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f7:	66 c7 40 26 00 00    	movw   $0x0,0x26(%eax)
801017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101800:	c6 40 28 00          	movb   $0x0,0x28(%eax)
80101804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101807:	0f b6 50 29          	movzbl 0x29(%eax),%edx
8010180b:	83 e2 f0             	and    $0xfffffff0,%edx
8010180e:	83 ca 0a             	or     $0xa,%edx
80101811:	88 50 29             	mov    %dl,0x29(%eax)
80101814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101817:	0f b6 50 29          	movzbl 0x29(%eax),%edx
8010181b:	83 ca 10             	or     $0x10,%edx
8010181e:	88 50 29             	mov    %dl,0x29(%eax)
80101821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101824:	0f b6 50 29          	movzbl 0x29(%eax),%edx
80101828:	83 ca 60             	or     $0x60,%edx
8010182b:	88 50 29             	mov    %dl,0x29(%eax)
8010182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101831:	0f b6 50 29          	movzbl 0x29(%eax),%edx
80101835:	83 ca 80             	or     $0xffffff80,%edx
80101838:	88 50 29             	mov    %dl,0x29(%eax)
8010183b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183e:	0f b6 50 2a          	movzbl 0x2a(%eax),%edx
80101842:	83 ca 0f             	or     $0xf,%edx
80101845:	88 50 2a             	mov    %dl,0x2a(%eax)
80101848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184b:	0f b6 50 2a          	movzbl 0x2a(%eax),%edx
8010184f:	83 e2 ef             	and    $0xffffffef,%edx
80101852:	88 50 2a             	mov    %dl,0x2a(%eax)
80101855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101858:	0f b6 50 2a          	movzbl 0x2a(%eax),%edx
8010185c:	83 e2 df             	and    $0xffffffdf,%edx
8010185f:	88 50 2a             	mov    %dl,0x2a(%eax)
80101862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101865:	0f b6 50 2a          	movzbl 0x2a(%eax),%edx
80101869:	83 ca 40             	or     $0x40,%edx
8010186c:	88 50 2a             	mov    %dl,0x2a(%eax)
8010186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101872:	0f b6 50 2a          	movzbl 0x2a(%eax),%edx
80101876:	83 ca 80             	or     $0xffffff80,%edx
80101879:	88 50 2a             	mov    %dl,0x2a(%eax)
8010187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187f:	c6 40 2b 00          	movb   $0x0,0x2b(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80101883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101886:	66 c7 40 2c ff ff    	movw   $0xffff,0x2c(%eax)
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	66 c7 40 2e 00 00    	movw   $0x0,0x2e(%eax)
80101895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101898:	c6 40 30 00          	movb   $0x0,0x30(%eax)
8010189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189f:	0f b6 50 31          	movzbl 0x31(%eax),%edx
801018a3:	83 e2 f0             	and    $0xfffffff0,%edx
801018a6:	83 ca 02             	or     $0x2,%edx
801018a9:	88 50 31             	mov    %dl,0x31(%eax)
801018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018af:	0f b6 50 31          	movzbl 0x31(%eax),%edx
801018b3:	83 ca 10             	or     $0x10,%edx
801018b6:	88 50 31             	mov    %dl,0x31(%eax)
801018b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018bc:	0f b6 50 31          	movzbl 0x31(%eax),%edx
801018c0:	83 ca 60             	or     $0x60,%edx
801018c3:	88 50 31             	mov    %dl,0x31(%eax)
801018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c9:	0f b6 50 31          	movzbl 0x31(%eax),%edx
801018cd:	83 ca 80             	or     $0xffffff80,%edx
801018d0:	88 50 31             	mov    %dl,0x31(%eax)
801018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d6:	0f b6 50 32          	movzbl 0x32(%eax),%edx
801018da:	83 ca 0f             	or     $0xf,%edx
801018dd:	88 50 32             	mov    %dl,0x32(%eax)
801018e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e3:	0f b6 50 32          	movzbl 0x32(%eax),%edx
801018e7:	83 e2 ef             	and    $0xffffffef,%edx
801018ea:	88 50 32             	mov    %dl,0x32(%eax)
801018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f0:	0f b6 50 32          	movzbl 0x32(%eax),%edx
801018f4:	83 e2 df             	and    $0xffffffdf,%edx
801018f7:	88 50 32             	mov    %dl,0x32(%eax)
801018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018fd:	0f b6 50 32          	movzbl 0x32(%eax),%edx
80101901:	83 ca 40             	or     $0x40,%edx
80101904:	88 50 32             	mov    %dl,0x32(%eax)
80101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190a:	0f b6 50 32          	movzbl 0x32(%eax),%edx
8010190e:	83 ca 80             	or     $0xffffff80,%edx
80101911:	88 50 32             	mov    %dl,0x32(%eax)
80101914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101917:	c6 40 33 00          	movb   $0x0,0x33(%eax)


  lgdt(c->gdt, sizeof(c->gdt) );
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	83 c0 04             	add    $0x4,%eax
80101921:	83 ec 08             	sub    $0x8,%esp
80101924:	6a 38                	push   $0x38
80101926:	50                   	push   %eax
80101927:	e8 e1 f4 ff ff       	call   80100e0d <lgdt>
8010192c:	83 c4 10             	add    $0x10,%esp
}
8010192f:	90                   	nop
80101930:	c9                   	leave  
80101931:	c3                   	ret    

80101932 <vma_create>:

/**************************************VMA&MM********************************************/

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
80101932:	55                   	push   %ebp
80101933:	89 e5                	mov    %esp,%ebp
80101935:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
80101938:	83 ec 0c             	sub    $0xc,%esp
8010193b:	6a 18                	push   $0x18
8010193d:	e8 ed 13 00 00       	call   80102d2f <kmalloc>
80101942:	83 c4 10             	add    $0x10,%esp
80101945:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
80101948:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010194c:	74 1b                	je     80101969 <vma_create+0x37>
        vma->vm_start = vm_start;
8010194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101951:	8b 55 08             	mov    0x8(%ebp),%edx
80101954:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
80101957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010195d:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
80101960:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101963:	8b 55 10             	mov    0x10(%ebp),%edx
80101966:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
80101969:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010196c:	c9                   	leave  
8010196d:	c3                   	ret    

8010196e <find_vma>:

// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
8010196e:	55                   	push   %ebp
8010196f:	89 e5                	mov    %esp,%ebp
80101971:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
80101974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
8010197b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010197f:	0f 84 95 00 00 00    	je     80101a1a <find_vma+0xac>
        vma = mm->mmap_cache;
80101985:	8b 45 08             	mov    0x8(%ebp),%eax
80101988:	8b 40 08             	mov    0x8(%eax),%eax
8010198b:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
8010198e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80101992:	74 16                	je     801019aa <find_vma+0x3c>
80101994:	8b 45 fc             	mov    -0x4(%ebp),%eax
80101997:	8b 40 04             	mov    0x4(%eax),%eax
8010199a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010199d:	77 0b                	ja     801019aa <find_vma+0x3c>
8010199f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801019a2:	8b 40 08             	mov    0x8(%eax),%eax
801019a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801019a8:	77 61                	ja     80101a0b <find_vma+0x9d>
                bool found = 0;
801019aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
801019b1:	8b 45 08             	mov    0x8(%ebp),%eax
801019b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
801019bd:	eb 28                	jmp    801019e7 <find_vma+0x79>
                    vma = le2vma(le, list_link);
801019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c2:	83 e8 10             	sub    $0x10,%eax
801019c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
801019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801019cb:	8b 40 04             	mov    0x4(%eax),%eax
801019ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
801019d1:	77 14                	ja     801019e7 <find_vma+0x79>
801019d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801019d6:	8b 40 08             	mov    0x8(%eax),%eax
801019d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801019dc:	76 09                	jbe    801019e7 <find_vma+0x79>
                        found = 1;
801019de:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
801019e5:	eb 17                	jmp    801019fe <find_vma+0x90>
801019e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm)
{
    return listelm->next;
801019ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801019f0:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
801019f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801019f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801019fc:	75 c1                	jne    801019bf <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
801019fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80101a02:	75 07                	jne    80101a0b <find_vma+0x9d>
                    vma = NULL;
80101a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
80101a0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80101a0f:	74 09                	je     80101a1a <find_vma+0xac>
            mm->mmap_cache = vma;
80101a11:	8b 45 08             	mov    0x8(%ebp),%eax
80101a14:	8b 55 fc             	mov    -0x4(%ebp),%edx
80101a17:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
80101a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80101a1d:	c9                   	leave  
80101a1e:	c3                   	ret    

80101a1f <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
80101a1f:	55                   	push   %ebp
80101a20:	89 e5                	mov    %esp,%ebp
80101a22:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
80101a25:	8b 45 08             	mov    0x8(%ebp),%eax
80101a28:	8b 50 04             	mov    0x4(%eax),%edx
80101a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2e:	8b 40 08             	mov    0x8(%eax),%eax
80101a31:	39 c2                	cmp    %eax,%edx
80101a33:	72 1c                	jb     80101a51 <check_vma_overlap+0x32>
80101a35:	68 98 ab 10 80       	push   $0x8010ab98
80101a3a:	68 84 aa 10 80       	push   $0x8010aa84
80101a3f:	68 68 01 00 00       	push   $0x168
80101a44:	68 59 aa 10 80       	push   $0x8010aa59
80101a49:	e8 06 e9 ff ff       	call   80100354 <__panic>
80101a4e:	83 c4 10             	add    $0x10,%esp
    assert(prev->vm_end <= next->vm_start);
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 50 08             	mov    0x8(%eax),%edx
80101a57:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a5a:	8b 40 04             	mov    0x4(%eax),%eax
80101a5d:	39 c2                	cmp    %eax,%edx
80101a5f:	76 1c                	jbe    80101a7d <check_vma_overlap+0x5e>
80101a61:	68 b8 ab 10 80       	push   $0x8010abb8
80101a66:	68 84 aa 10 80       	push   $0x8010aa84
80101a6b:	68 69 01 00 00       	push   $0x169
80101a70:	68 59 aa 10 80       	push   $0x8010aa59
80101a75:	e8 da e8 ff ff       	call   80100354 <__panic>
80101a7a:	83 c4 10             	add    $0x10,%esp
    assert(next->vm_start < next->vm_end);
80101a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a80:	8b 50 04             	mov    0x4(%eax),%edx
80101a83:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a86:	8b 40 08             	mov    0x8(%eax),%eax
80101a89:	39 c2                	cmp    %eax,%edx
80101a8b:	72 1c                	jb     80101aa9 <check_vma_overlap+0x8a>
80101a8d:	68 d7 ab 10 80       	push   $0x8010abd7
80101a92:	68 84 aa 10 80       	push   $0x8010aa84
80101a97:	68 6a 01 00 00       	push   $0x16a
80101a9c:	68 59 aa 10 80       	push   $0x8010aa59
80101aa1:	e8 ae e8 ff ff       	call   80100354 <__panic>
80101aa6:	83 c4 10             	add    $0x10,%esp
}
80101aa9:	90                   	nop
80101aaa:	c9                   	leave  
80101aab:	c3                   	ret    

80101aac <insert_vma_struct>:

// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
80101aac:	55                   	push   %ebp
80101aad:	89 e5                	mov    %esp,%ebp
80101aaf:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
80101ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ab5:	8b 50 04             	mov    0x4(%eax),%edx
80101ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abb:	8b 40 08             	mov    0x8(%eax),%eax
80101abe:	39 c2                	cmp    %eax,%edx
80101ac0:	72 1c                	jb     80101ade <insert_vma_struct+0x32>
80101ac2:	68 f5 ab 10 80       	push   $0x8010abf5
80101ac7:	68 84 aa 10 80       	push   $0x8010aa84
80101acc:	68 70 01 00 00       	push   $0x170
80101ad1:	68 59 aa 10 80       	push   $0x8010aa59
80101ad6:	e8 79 e8 ff ff       	call   80100354 <__panic>
80101adb:	83 c4 10             	add    $0x10,%esp
    list_entry_t *list = &(mm->mmap_list);
80101ade:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
80101ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)

    list_entry_t *le = list;
80101aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((le = list_next(le)) != list) {
80101af0:	eb 1f                	jmp    80101b11 <insert_vma_struct+0x65>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
80101af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af5:	83 e8 10             	sub    $0x10,%eax
80101af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (mmap_prev->vm_start > vma->vm_start) {
80101afb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101afe:	8b 50 04             	mov    0x4(%eax),%edx
80101b01:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b04:	8b 40 04             	mov    0x4(%eax),%eax
80101b07:	39 c2                	cmp    %eax,%edx
80101b09:	77 1f                	ja     80101b2a <insert_vma_struct+0x7e>
            break;
        }
        le_prev = le;
80101b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b14:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1a:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

    list_entry_t *le = list;
    while ((le = list_next(le)) != list) {
80101b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101b26:	75 ca                	jne    80101af2 <insert_vma_struct+0x46>
80101b28:	eb 01                	jmp    80101b2b <insert_vma_struct+0x7f>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start) {
            break;
80101b2a:	90                   	nop
80101b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101b34:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le_prev = le;
    }

    le_next = list_next(le_prev);
80101b37:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
80101b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b3d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101b40:	74 15                	je     80101b57 <insert_vma_struct+0xab>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
80101b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b45:	83 e8 10             	sub    $0x10,%eax
80101b48:	83 ec 08             	sub    $0x8,%esp
80101b4b:	ff 75 0c             	pushl  0xc(%ebp)
80101b4e:	50                   	push   %eax
80101b4f:	e8 cb fe ff ff       	call   80101a1f <check_vma_overlap>
80101b54:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
80101b57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101b5d:	74 15                	je     80101b74 <insert_vma_struct+0xc8>
        check_vma_overlap(vma, le2vma(le_next, list_link));
80101b5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b62:	83 e8 10             	sub    $0x10,%eax
80101b65:	83 ec 08             	sub    $0x8,%esp
80101b68:	50                   	push   %eax
80101b69:	ff 75 0c             	pushl  0xc(%ebp)
80101b6c:	e8 ae fe ff ff       	call   80101a1f <check_vma_overlap>
80101b71:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
80101b74:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b77:	8b 55 08             	mov    0x8(%ebp),%edx
80101b7a:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
80101b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b7f:	8d 50 10             	lea    0x10(%eax),%edx
80101b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b85:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm, listelm->next);
80101b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b8e:	8b 40 04             	mov    0x4(%eax),%eax
80101b91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80101b94:	89 55 d0             	mov    %edx,-0x30(%ebp)
80101b97:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101b9a:	89 55 cc             	mov    %edx,-0x34(%ebp)
80101b9d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
80101ba0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80101ba3:	8b 55 d0             	mov    -0x30(%ebp),%edx
80101ba6:	89 10                	mov    %edx,(%eax)
80101ba8:	8b 45 c8             	mov    -0x38(%ebp),%eax
80101bab:	8b 10                	mov    (%eax),%edx
80101bad:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101bb0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
80101bb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101bb6:	8b 55 c8             	mov    -0x38(%ebp),%edx
80101bb9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
80101bbc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101bbf:	8b 55 cc             	mov    -0x34(%ebp),%edx
80101bc2:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
80101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc7:	8b 40 10             	mov    0x10(%eax),%eax
80101bca:	8d 50 01             	lea    0x1(%eax),%edx
80101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd0:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bd3:	90                   	nop
80101bd4:	c9                   	leave  
80101bd5:	c3                   	ret    

80101bd6 <mm_create>:


/************************************MM*****************************************/
// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
80101bd6:	55                   	push   %ebp
80101bd7:	89 e5                	mov    %esp,%ebp
80101bd9:	83 ec 18             	sub    $0x18,%esp

    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
80101bdc:	83 ec 0c             	sub    $0xc,%esp
80101bdf:	6a 1c                	push   $0x1c
80101be1:	e8 49 11 00 00       	call   80102d2f <kmalloc>
80101be6:	83 c4 10             	add    $0x10,%esp
80101be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
80101bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bf0:	74 6b                	je     80101c5d <mm_create+0x87>
        list_init(&(mm->mmap_list));
80101bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80101bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101bfe:	89 50 04             	mov    %edx,0x4(%eax)
80101c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c04:	8b 50 04             	mov    0x4(%eax),%edx
80101c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c0a:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
80101c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
80101c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
80101c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c23:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        set_mm_count(mm, 0);
80101c2a:	83 ec 08             	sub    $0x8,%esp
80101c2d:	6a 00                	push   $0x0
80101c2f:	ff 75 f4             	pushl  -0xc(%ebp)
80101c32:	e8 31 f2 ff ff       	call   80100e68 <set_mm_count>
80101c37:	83 c4 10             	add    $0x10,%esp
        if (swap_init_ok) swap_init_mm(mm);
80101c3a:	a1 b8 6e 12 80       	mov    0x80126eb8,%eax
80101c3f:	85 c0                	test   %eax,%eax
80101c41:	74 10                	je     80101c53 <mm_create+0x7d>
80101c43:	83 ec 0c             	sub    $0xc,%esp
80101c46:	ff 75 f4             	pushl  -0xc(%ebp)
80101c49:	e8 27 ef ff ff       	call   80100b75 <swap_init_mm>
80101c4e:	83 c4 10             	add    $0x10,%esp
80101c51:	eb 0a                	jmp    80101c5d <mm_create+0x87>
        else mm->sm_priv = NULL;
80101c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c56:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    return mm;
80101c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101c60:	c9                   	leave  
80101c61:	c3                   	ret    

80101c62 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
80101c62:	55                   	push   %ebp
80101c63:	89 e5                	mov    %esp,%ebp
80101c65:	83 ec 28             	sub    $0x28,%esp
    assert(mm_count(mm) == 0);
80101c68:	ff 75 08             	pushl  0x8(%ebp)
80101c6b:	e8 ed f1 ff ff       	call   80100e5d <mm_count>
80101c70:	83 c4 04             	add    $0x4,%esp
80101c73:	85 c0                	test   %eax,%eax
80101c75:	74 1c                	je     80101c93 <mm_destroy+0x31>
80101c77:	68 11 ac 10 80       	push   $0x8010ac11
80101c7c:	68 84 aa 10 80       	push   $0x8010aa84
80101c81:	68 a3 01 00 00       	push   $0x1a3
80101c86:	68 59 aa 10 80       	push   $0x8010aa59
80101c8b:	e8 c4 e6 ff ff       	call   80100354 <__panic>
80101c90:	83 c4 10             	add    $0x10,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
80101c99:	eb 3a                	jmp    80101cd5 <mm_destroy+0x73>
80101c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80101ca1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ca4:	8b 40 04             	mov    0x4(%eax),%eax
80101ca7:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101caa:	8b 12                	mov    (%edx),%edx
80101cac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101caf:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80101cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101cb8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80101cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101cbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cc1:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
80101cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc6:	83 e8 10             	sub    $0x10,%eax
80101cc9:	83 ec 0c             	sub    $0xc,%esp
80101ccc:	50                   	push   %eax
80101ccd:	e8 1d 10 00 00       	call   80102cef <kfree>
80101cd2:	83 c4 10             	add    $0x10,%esp
80101cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm)
{
    return listelm->next;
80101cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cde:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
80101ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80101cea:	75 af                	jne    80101c9b <mm_destroy+0x39>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	ff 75 08             	pushl  0x8(%ebp)
80101cf2:	e8 f8 0f 00 00       	call   80102cef <kfree>
80101cf7:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
80101cfa:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
80101d01:	90                   	nop
80101d02:	c9                   	leave  
80101d03:	c3                   	ret    

80101d04 <mm_setup_pgdir>:
bool
mm_setup_pgdir(struct mm_struct *mm){
80101d04:	55                   	push   %ebp
80101d05:	89 e5                	mov    %esp,%ebp
80101d07:	83 ec 18             	sub    $0x18,%esp
    assert(mm != NULL);
80101d0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101d0e:	75 1c                	jne    80101d2c <mm_setup_pgdir+0x28>
80101d10:	68 23 ac 10 80       	push   $0x8010ac23
80101d15:	68 84 aa 10 80       	push   $0x8010aa84
80101d1a:	68 af 01 00 00       	push   $0x1af
80101d1f:	68 59 aa 10 80       	push   $0x8010aa59
80101d24:	e8 2b e6 ff ff       	call   80100354 <__panic>
80101d29:	83 c4 10             	add    $0x10,%esp
    pde_t *pgdir;
    if((pgdir = kmalloc(PGSIZE)) == NULL)
80101d2c:	83 ec 0c             	sub    $0xc,%esp
80101d2f:	68 00 10 00 00       	push   $0x1000
80101d34:	e8 f6 0f 00 00       	call   80102d2f <kmalloc>
80101d39:	83 c4 10             	add    $0x10,%esp
80101d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d43:	75 07                	jne    80101d4c <mm_setup_pgdir+0x48>
    {
        return false;
80101d45:	b8 00 00 00 00       	mov    $0x0,%eax
80101d4a:	eb 27                	jmp    80101d73 <mm_setup_pgdir+0x6f>
    }
    memcpy(pgdir, kpgdir, PGSIZE);
80101d4c:	a1 68 70 12 80       	mov    0x80127068,%eax
80101d51:	83 ec 04             	sub    $0x4,%esp
80101d54:	68 00 10 00 00       	push   $0x1000
80101d59:	50                   	push   %eax
80101d5a:	ff 75 f4             	pushl  -0xc(%ebp)
80101d5d:	e8 98 87 00 00       	call   8010a4fa <memcpy>
80101d62:	83 c4 10             	add    $0x10,%esp
    mm->pgdir = pgdir;
80101d65:	8b 45 08             	mov    0x8(%ebp),%eax
80101d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d6b:	89 50 0c             	mov    %edx,0xc(%eax)
    return true;
80101d6e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80101d73:	c9                   	leave  
80101d74:	c3                   	ret    

80101d75 <mm_copy>:

// mm_copy - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
int
mm_copy(uint32_t clone_flags, struct proc *proc) {
80101d75:	55                   	push   %ebp
80101d76:	89 e5                	mov    %esp,%ebp
80101d78:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm, *oldmm = CUR_PROC->mm;
80101d7b:	e8 eb 47 00 00       	call   8010656b <get_cpu>
80101d80:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80101d86:	05 70 79 12 80       	add    $0x80127970,%eax
80101d8b:	8b 00                	mov    (%eax),%eax
80101d8d:	8b 40 34             	mov    0x34(%eax),%eax
80101d90:	89 45 f0             	mov    %eax,-0x10(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
80101d93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101d97:	75 07                	jne    80101da0 <mm_copy+0x2b>
        return 0;
80101d99:	b8 00 00 00 00       	mov    $0x0,%eax
80101d9e:	eb 5a                	jmp    80101dfa <mm_copy+0x85>
    }

    if (!(clone_flags & CLONE_VM)) {
80101da0:	8b 45 08             	mov    0x8(%ebp),%eax
80101da3:	83 e0 01             	and    $0x1,%eax
80101da6:	85 c0                	test   %eax,%eax
80101da8:	75 08                	jne    80101db2 <mm_copy+0x3d>
        mm = oldmm;
80101daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
80101db0:	eb 1a                	jmp    80101dcc <mm_copy+0x57>
    }

    panic("now no support copy mm\n");
80101db2:	83 ec 04             	sub    $0x4,%esp
80101db5:	68 2e ac 10 80       	push   $0x8010ac2e
80101dba:	68 ca 01 00 00       	push   $0x1ca
80101dbf:	68 59 aa 10 80       	push   $0x8010aa59
80101dc4:	e8 8b e5 ff ff       	call   80100354 <__panic>
80101dc9:	83 c4 10             	add    $0x10,%esp
        goto bad_dup_cleanup_mmap;
    }

#endif
good_mm:
    mm_count_inc(mm);
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	ff 75 f4             	pushl  -0xc(%ebp)
80101dd2:	e8 6c f0 ff ff       	call   80100e43 <mm_count_inc>
80101dd7:	83 c4 10             	add    $0x10,%esp
    proc->mm = mm;
80101dda:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ddd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101de0:	89 50 34             	mov    %edx,0x34(%eax)
    proc->cr3 = V2P(mm->pgdir);
80101de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101de6:	8b 40 0c             	mov    0xc(%eax),%eax
80101de9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80101def:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df2:	89 50 2c             	mov    %edx,0x2c(%eax)
    return 0;
80101df5:	b8 00 00 00 00       	mov    $0x0,%eax
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    return ret;
#endif
}
80101dfa:	c9                   	leave  
80101dfb:	c3                   	ret    

80101dfc <mm_map>:

#endif

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
80101dfc:	55                   	push   %ebp
80101dfd:	89 e5                	mov    %esp,%ebp
80101dff:	83 ec 28             	sub    $0x28,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
80101e02:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80101e10:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101e13:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
80101e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e1d:	8b 45 10             	mov    0x10(%ebp),%eax
80101e20:	01 c2                	add    %eax,%edx
80101e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e25:	01 d0                	add    %edx,%eax
80101e27:	83 e8 01             	sub    $0x1,%eax
80101e2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e30:	ba 00 00 00 00       	mov    $0x0,%edx
80101e35:	f7 75 e8             	divl   -0x18(%ebp)
80101e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e3b:	29 d0                	sub    %edx,%eax
80101e3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
80101e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e43:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80101e46:	73 09                	jae    80101e51 <mm_map+0x55>
80101e48:	81 7d e0 00 00 00 04 	cmpl   $0x4000000,-0x20(%ebp)
80101e4f:	76 0a                	jbe    80101e5b <mm_map+0x5f>
        return -E_INVAL;
80101e51:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80101e56:	e9 a1 00 00 00       	jmp    80101efc <mm_map+0x100>
    }

    assert(mm != NULL);
80101e5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101e5f:	75 1c                	jne    80101e7d <mm_map+0x81>
80101e61:	68 23 ac 10 80       	push   $0x8010ac23
80101e66:	68 84 aa 10 80       	push   $0x8010aa84
80101e6b:	68 3c 02 00 00       	push   $0x23c
80101e70:	68 59 aa 10 80       	push   $0x8010aa59
80101e75:	e8 da e4 ff ff       	call   80100354 <__panic>
80101e7a:	83 c4 10             	add    $0x10,%esp

    int ret = -E_INVAL;
80101e7d:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
80101e84:	83 ec 08             	sub    $0x8,%esp
80101e87:	ff 75 ec             	pushl  -0x14(%ebp)
80101e8a:	ff 75 08             	pushl  0x8(%ebp)
80101e8d:	e8 dc fa ff ff       	call   8010196e <find_vma>
80101e92:	83 c4 10             	add    $0x10,%esp
80101e95:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e98:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101e9c:	74 0b                	je     80101ea9 <mm_map+0xad>
80101e9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ea1:	8b 40 04             	mov    0x4(%eax),%eax
80101ea4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80101ea7:	72 4c                	jb     80101ef5 <mm_map+0xf9>
        goto out;
    }
    ret = -E_NO_MEM;
80101ea9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
80101eb0:	83 ec 04             	sub    $0x4,%esp
80101eb3:	ff 75 14             	pushl  0x14(%ebp)
80101eb6:	ff 75 e0             	pushl  -0x20(%ebp)
80101eb9:	ff 75 ec             	pushl  -0x14(%ebp)
80101ebc:	e8 71 fa ff ff       	call   80101932 <vma_create>
80101ec1:	83 c4 10             	add    $0x10,%esp
80101ec4:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ec7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101ecb:	74 2b                	je     80101ef8 <mm_map+0xfc>
        goto out;
    }
    insert_vma_struct(mm, vma);
80101ecd:	83 ec 08             	sub    $0x8,%esp
80101ed0:	ff 75 dc             	pushl  -0x24(%ebp)
80101ed3:	ff 75 08             	pushl  0x8(%ebp)
80101ed6:	e8 d1 fb ff ff       	call   80101aac <insert_vma_struct>
80101edb:	83 c4 10             	add    $0x10,%esp
    if (vma_store != NULL) {
80101ede:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
80101ee2:	74 08                	je     80101eec <mm_map+0xf0>
        *vma_store = vma;
80101ee4:	8b 45 18             	mov    0x18(%ebp),%eax
80101ee7:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101eea:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
80101eec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ef3:	eb 04                	jmp    80101ef9 <mm_map+0xfd>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
        goto out;
80101ef5:	90                   	nop
80101ef6:	eb 01                	jmp    80101ef9 <mm_map+0xfd>
    }
    ret = -E_NO_MEM;

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
80101ef8:	90                   	nop
    if (vma_store != NULL) {
        *vma_store = vma;
    }
    ret = 0;
out:
    return ret;
80101ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101efc:	c9                   	leave  
80101efd:	c3                   	ret    

80101efe <exit_mmap>:


void
exit_mmap(struct mm_struct *mm) {
80101efe:	55                   	push   %ebp
80101eff:	89 e5                	mov    %esp,%ebp
80101f01:	83 ec 28             	sub    $0x28,%esp
    assert(mm != NULL && mm_count(mm) == 0);
80101f04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101f08:	74 0f                	je     80101f19 <exit_mmap+0x1b>
80101f0a:	ff 75 08             	pushl  0x8(%ebp)
80101f0d:	e8 4b ef ff ff       	call   80100e5d <mm_count>
80101f12:	83 c4 04             	add    $0x4,%esp
80101f15:	85 c0                	test   %eax,%eax
80101f17:	74 1c                	je     80101f35 <exit_mmap+0x37>
80101f19:	68 48 ac 10 80       	push   $0x8010ac48
80101f1e:	68 84 aa 10 80       	push   $0x8010aa84
80101f23:	68 55 02 00 00       	push   $0x255
80101f28:	68 59 aa 10 80       	push   $0x8010aa59
80101f2d:	e8 22 e4 ff ff       	call   80100354 <__panic>
80101f32:	83 c4 10             	add    $0x10,%esp
    pde_t *pgdir = mm->pgdir;
80101f35:	8b 45 08             	mov    0x8(%ebp),%eax
80101f38:	8b 40 0c             	mov    0xc(%eax),%eax
80101f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
80101f3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f41:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
80101f4a:	eb 25                	jmp    80101f71 <exit_mmap+0x73>
        struct vma_struct *vma = le2vma(le, list_link);
80101f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f4f:	83 e8 10             	sub    $0x10,%eax
80101f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
80101f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f58:	8b 50 08             	mov    0x8(%eax),%edx
80101f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f5e:	8b 40 04             	mov    0x4(%eax),%eax
80101f61:	83 ec 04             	sub    $0x4,%esp
80101f64:	52                   	push   %edx
80101f65:	50                   	push   %eax
80101f66:	ff 75 f0             	pushl  -0x10(%ebp)
80101f69:	e8 c0 00 00 00       	call   8010202e <unmap_range>
80101f6e:	83 c4 10             	add    $0x10,%esp
80101f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f74:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f7a:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
80101f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101f86:	75 c4                	jne    80101f4c <exit_mmap+0x4e>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
80101f88:	eb 25                	jmp    80101faf <exit_mmap+0xb1>
        struct vma_struct *vma = le2vma(le, list_link);
80101f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f8d:	83 e8 10             	sub    $0x10,%eax
80101f90:	89 45 e0             	mov    %eax,-0x20(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
80101f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f96:	8b 50 08             	mov    0x8(%eax),%edx
80101f99:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f9c:	8b 40 04             	mov    0x4(%eax),%eax
80101f9f:	83 ec 04             	sub    $0x4,%esp
80101fa2:	52                   	push   %edx
80101fa3:	50                   	push   %eax
80101fa4:	ff 75 f0             	pushl  -0x10(%ebp)
80101fa7:	e8 52 01 00 00       	call   801020fe <exit_range>
80101fac:	83 c4 10             	add    $0x10,%esp
80101faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fb8:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
80101fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fc1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101fc4:	75 c4                	jne    80101f8a <exit_mmap+0x8c>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
80101fc6:	90                   	nop
80101fc7:	c9                   	leave  
80101fc8:	c3                   	ret    

80101fc9 <put_pgdir>:

void
put_pgdir(struct mm_struct *mm) {
80101fc9:	55                   	push   %ebp
80101fca:	89 e5                	mov    %esp,%ebp
80101fcc:	83 ec 08             	sub    $0x8,%esp
    free_page(kva2page(mm->pgdir));
80101fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd2:	8b 40 0c             	mov    0xc(%eax),%eax
80101fd5:	83 ec 0c             	sub    $0xc,%esp
80101fd8:	50                   	push   %eax
80101fd9:	e8 e6 e9 ff ff       	call   801009c4 <kva2page>
80101fde:	83 c4 10             	add    $0x10,%esp
80101fe1:	83 ec 0c             	sub    $0xc,%esp
80101fe4:	50                   	push   %eax
80101fe5:	e8 d8 e8 ff ff       	call   801008c2 <free_page>
80101fea:	83 c4 10             	add    $0x10,%esp
}
80101fed:	90                   	nop
80101fee:	c9                   	leave  
80101fef:	c3                   	ret    

80101ff0 <put_kstack>:

void
put_kstack(struct proc *proc){
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	83 ec 08             	sub    $0x8,%esp
    kfree((proc->kstack));
80101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff9:	8b 40 30             	mov    0x30(%eax),%eax
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	50                   	push   %eax
80102000:	e8 ea 0c 00 00       	call   80102cef <kfree>
80102005:	83 c4 10             	add    $0x10,%esp
}
80102008:	90                   	nop
80102009:	c9                   	leave  
8010200a:	c3                   	ret    

8010200b <vmm_init>:


void
vmm_init(void) {
8010200b:	55                   	push   %ebp
8010200c:	89 e5                	mov    %esp,%ebp
8010200e:	83 ec 08             	sub    $0x8,%esp
    init_kvm();
80102011:	e8 4f f6 ff ff       	call   80101665 <init_kvm>
    seginit();
80102016:	e8 87 f6 ff ff       	call   801016a2 <seginit>
    cprintf(INITOK"init vmm ok!\n");
8010201b:	83 ec 0c             	sub    $0xc,%esp
8010201e:	68 68 ac 10 80       	push   $0x8010ac68
80102023:	e8 af 4c 00 00       	call   80106cd7 <cprintf>
80102028:	83 c4 10             	add    $0x10,%esp
}
8010202b:	90                   	nop
8010202c:	c9                   	leave  
8010202d:	c3                   	ret    

8010202e <unmap_range>:

#define PTSIZE 4096*1024
void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
8010202e:	55                   	push   %ebp
8010202f:	89 e5                	mov    %esp,%ebp
80102031:	83 ec 18             	sub    $0x18,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
80102034:	8b 45 0c             	mov    0xc(%ebp),%eax
80102037:	25 ff 0f 00 00       	and    $0xfff,%eax
8010203c:	85 c0                	test   %eax,%eax
8010203e:	75 0c                	jne    8010204c <unmap_range+0x1e>
80102040:	8b 45 10             	mov    0x10(%ebp),%eax
80102043:	25 ff 0f 00 00       	and    $0xfff,%eax
80102048:	85 c0                	test   %eax,%eax
8010204a:	74 1c                	je     80102068 <unmap_range+0x3a>
8010204c:	68 84 ac 10 80       	push   $0x8010ac84
80102051:	68 84 aa 10 80       	push   $0x8010aa84
80102056:	68 77 02 00 00       	push   $0x277
8010205b:	68 59 aa 10 80       	push   $0x8010aa59
80102060:	e8 ef e2 ff ff       	call   80100354 <__panic>
80102065:	83 c4 10             	add    $0x10,%esp
    assert(USER_ACCESS(start, end));
80102068:	8b 45 0c             	mov    0xc(%ebp),%eax
8010206b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010206e:	73 09                	jae    80102079 <unmap_range+0x4b>
80102070:	81 7d 10 00 00 00 04 	cmpl   $0x4000000,0x10(%ebp)
80102077:	76 1c                	jbe    80102095 <unmap_range+0x67>
80102079:	68 ad ac 10 80       	push   $0x8010acad
8010207e:	68 84 aa 10 80       	push   $0x8010aa84
80102083:	68 78 02 00 00       	push   $0x278
80102088:	68 59 aa 10 80       	push   $0x8010aa59
8010208d:	e8 c2 e2 ff ff       	call   80100354 <__panic>
80102092:	83 c4 10             	add    $0x10,%esp

    do {
        pte_t *ptep = read_pte_addr(pgdir, start, 0);
80102095:	83 ec 04             	sub    $0x4,%esp
80102098:	6a 00                	push   $0x0
8010209a:	ff 75 0c             	pushl  0xc(%ebp)
8010209d:	ff 75 08             	pushl  0x8(%ebp)
801020a0:	e8 51 ee ff ff       	call   80100ef6 <read_pte_addr>
801020a5:	83 c4 10             	add    $0x10,%esp
801020a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
801020ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801020af:	75 18                	jne    801020c9 <unmap_range+0x9b>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
801020b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b4:	05 00 00 40 00       	add    $0x400000,%eax
801020b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801020bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020bf:	25 00 00 c0 ff       	and    $0xffc00000,%eax
801020c4:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
801020c7:	eb 24                	jmp    801020ed <unmap_range+0xbf>
        }
        if (*ptep != 0) {
801020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020cc:	8b 00                	mov    (%eax),%eax
801020ce:	85 c0                	test   %eax,%eax
801020d0:	74 14                	je     801020e6 <unmap_range+0xb8>
            page_remove_pte(pgdir, start, ptep);
801020d2:	83 ec 04             	sub    $0x4,%esp
801020d5:	ff 75 f4             	pushl  -0xc(%ebp)
801020d8:	ff 75 0c             	pushl  0xc(%ebp)
801020db:	ff 75 08             	pushl  0x8(%ebp)
801020de:	e8 db ee ff ff       	call   80100fbe <page_remove_pte>
801020e3:	83 c4 10             	add    $0x10,%esp
        }
        start += PGSIZE;
801020e6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
801020ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801020f1:	74 08                	je     801020fb <unmap_range+0xcd>
801020f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801020f9:	72 9a                	jb     80102095 <unmap_range+0x67>
}
801020fb:	90                   	nop
801020fc:	c9                   	leave  
801020fd:	c3                   	ret    

801020fe <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
801020fe:	55                   	push   %ebp
801020ff:	89 e5                	mov    %esp,%ebp
80102101:	83 ec 18             	sub    $0x18,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
80102104:	8b 45 0c             	mov    0xc(%ebp),%eax
80102107:	25 ff 0f 00 00       	and    $0xfff,%eax
8010210c:	85 c0                	test   %eax,%eax
8010210e:	75 0c                	jne    8010211c <exit_range+0x1e>
80102110:	8b 45 10             	mov    0x10(%ebp),%eax
80102113:	25 ff 0f 00 00       	and    $0xfff,%eax
80102118:	85 c0                	test   %eax,%eax
8010211a:	74 1c                	je     80102138 <exit_range+0x3a>
8010211c:	68 84 ac 10 80       	push   $0x8010ac84
80102121:	68 84 aa 10 80       	push   $0x8010aa84
80102126:	68 89 02 00 00       	push   $0x289
8010212b:	68 59 aa 10 80       	push   $0x8010aa59
80102130:	e8 1f e2 ff ff       	call   80100354 <__panic>
80102135:	83 c4 10             	add    $0x10,%esp
    assert(USER_ACCESS(start, end));
80102138:	8b 45 0c             	mov    0xc(%ebp),%eax
8010213b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010213e:	73 09                	jae    80102149 <exit_range+0x4b>
80102140:	81 7d 10 00 00 00 04 	cmpl   $0x4000000,0x10(%ebp)
80102147:	76 1c                	jbe    80102165 <exit_range+0x67>
80102149:	68 ad ac 10 80       	push   $0x8010acad
8010214e:	68 84 aa 10 80       	push   $0x8010aa84
80102153:	68 8a 02 00 00       	push   $0x28a
80102158:	68 59 aa 10 80       	push   $0x8010aa59
8010215d:	e8 f2 e1 ff ff       	call   80100354 <__panic>
80102162:	83 c4 10             	add    $0x10,%esp

    start = ROUNDDOWN(start, PTSIZE);
80102165:	8b 45 0c             	mov    0xc(%ebp),%eax
80102168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010216e:	25 00 00 c0 ff       	and    $0xffc00000,%eax
80102173:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
80102176:	8b 45 0c             	mov    0xc(%ebp),%eax
80102179:	c1 e8 16             	shr    $0x16,%eax
8010217c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
8010217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102182:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102189:	8b 45 08             	mov    0x8(%ebp),%eax
8010218c:	01 d0                	add    %edx,%eax
8010218e:	8b 00                	mov    (%eax),%eax
80102190:	83 e0 01             	and    $0x1,%eax
80102193:	85 c0                	test   %eax,%eax
80102195:	74 3e                	je     801021d5 <exit_range+0xd7>
            free_page(pde2page(pgdir[pde_idx]));
80102197:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010219a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021a1:	8b 45 08             	mov    0x8(%ebp),%eax
801021a4:	01 d0                	add    %edx,%eax
801021a6:	8b 00                	mov    (%eax),%eax
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	50                   	push   %eax
801021ac:	e8 08 ed ff ff       	call   80100eb9 <pde2page>
801021b1:	83 c4 10             	add    $0x10,%esp
801021b4:	83 ec 0c             	sub    $0xc,%esp
801021b7:	50                   	push   %eax
801021b8:	e8 05 e7 ff ff       	call   801008c2 <free_page>
801021bd:	83 c4 10             	add    $0x10,%esp
            pgdir[pde_idx] = 0;
801021c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021ca:	8b 45 08             	mov    0x8(%ebp),%eax
801021cd:	01 d0                	add    %edx,%eax
801021cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
801021d5:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
801021dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801021e0:	74 08                	je     801021ea <exit_range+0xec>
801021e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801021e5:	3b 45 10             	cmp    0x10(%ebp),%eax
801021e8:	72 8c                	jb     80102176 <exit_range+0x78>
}
801021ea:	90                   	nop
801021eb:	c9                   	leave  
801021ec:	c3                   	ret    

801021ed <check_vmm>:



// check_vmm - check correctness of vmm
void
check_vmm(void) {
801021ed:	55                   	push   %ebp
801021ee:	89 e5                	mov    %esp,%ebp

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vmm() succeeded.\n");
#endif
}
801021f0:	90                   	nop
801021f1:	5d                   	pop    %ebp
801021f2:	c3                   	ret    

801021f3 <do_pgfault>:
#endif
volatile unsigned int pgfault_num=0;

//page fault fuction
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
801021f3:	55                   	push   %ebp
801021f4:	89 e5                	mov    %esp,%ebp
801021f6:	83 ec 28             	sub    $0x28,%esp
    int ret = -1;
801021f9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
80102200:	ff 75 10             	pushl  0x10(%ebp)
80102203:	ff 75 08             	pushl  0x8(%ebp)
80102206:	e8 63 f7 ff ff       	call   8010196e <find_vma>
8010220b:	83 c4 08             	add    $0x8,%esp
8010220e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
80102211:	a1 c8 6e 12 80       	mov    0x80126ec8,%eax
80102216:	83 c0 01             	add    $0x1,%eax
80102219:	a3 c8 6e 12 80       	mov    %eax,0x80126ec8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
8010221e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80102222:	74 0b                	je     8010222f <do_pgfault+0x3c>
80102224:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102227:	8b 40 04             	mov    0x4(%eax),%eax
8010222a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010222d:	76 18                	jbe    80102247 <do_pgfault+0x54>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
8010222f:	83 ec 08             	sub    $0x8,%esp
80102232:	ff 75 10             	pushl  0x10(%ebp)
80102235:	68 c8 ac 10 80       	push   $0x8010acc8
8010223a:	e8 98 4a 00 00       	call   80106cd7 <cprintf>
8010223f:	83 c4 10             	add    $0x10,%esp
        goto failed;
80102242:	e9 b6 01 00 00       	jmp    801023fd <do_pgfault+0x20a>
    }
    //check the error_code
    switch (error_code & 3) {
80102247:	8b 45 0c             	mov    0xc(%ebp),%eax
8010224a:	83 e0 03             	and    $0x3,%eax
8010224d:	85 c0                	test   %eax,%eax
8010224f:	74 3c                	je     8010228d <do_pgfault+0x9a>
80102251:	83 f8 01             	cmp    $0x1,%eax
80102254:	74 22                	je     80102278 <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
80102256:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102259:	8b 40 0c             	mov    0xc(%eax),%eax
8010225c:	83 e0 02             	and    $0x2,%eax
8010225f:	85 c0                	test   %eax,%eax
80102261:	75 4c                	jne    801022af <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 f8 ac 10 80       	push   $0x8010acf8
8010226b:	e8 67 4a 00 00       	call   80106cd7 <cprintf>
80102270:	83 c4 10             	add    $0x10,%esp
            goto failed;
80102273:	e9 85 01 00 00       	jmp    801023fd <do_pgfault+0x20a>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
80102278:	83 ec 0c             	sub    $0xc,%esp
8010227b:	68 58 ad 10 80       	push   $0x8010ad58
80102280:	e8 52 4a 00 00       	call   80106cd7 <cprintf>
80102285:	83 c4 10             	add    $0x10,%esp
        goto failed;
80102288:	e9 70 01 00 00       	jmp    801023fd <do_pgfault+0x20a>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
8010228d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102290:	8b 40 0c             	mov    0xc(%eax),%eax
80102293:	83 e0 05             	and    $0x5,%eax
80102296:	85 c0                	test   %eax,%eax
80102298:	75 16                	jne    801022b0 <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
8010229a:	83 ec 0c             	sub    $0xc,%esp
8010229d:	68 90 ad 10 80       	push   $0x8010ad90
801022a2:	e8 30 4a 00 00       	call   80106cd7 <cprintf>
801022a7:	83 c4 10             	add    $0x10,%esp
            goto failed;
801022aa:	e9 4e 01 00 00       	jmp    801023fd <do_pgfault+0x20a>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
801022af:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
801022b0:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
801022b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022ba:	8b 40 0c             	mov    0xc(%eax),%eax
801022bd:	83 e0 02             	and    $0x2,%eax
801022c0:	85 c0                	test   %eax,%eax
801022c2:	74 04                	je     801022c8 <do_pgfault+0xd5>
        perm |= PTE_W;
801022c4:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
801022c8:	8b 45 10             	mov    0x10(%ebp),%eax
801022cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
801022ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801022d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801022d6:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -1;
801022d9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)

    pte_t *ptep=NULL;
801022e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = read_pte_addr(mm->pgdir, addr, 1)) == NULL) {
801022e7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ea:	8b 40 0c             	mov    0xc(%eax),%eax
801022ed:	83 ec 04             	sub    $0x4,%esp
801022f0:	6a 01                	push   $0x1
801022f2:	ff 75 10             	pushl  0x10(%ebp)
801022f5:	50                   	push   %eax
801022f6:	e8 fb eb ff ff       	call   80100ef6 <read_pte_addr>
801022fb:	83 c4 10             	add    $0x10,%esp
801022fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102301:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80102305:	75 15                	jne    8010231c <do_pgfault+0x129>
        cprintf("get_pte in do_pgfault failed\n");
80102307:	83 ec 0c             	sub    $0xc,%esp
8010230a:	68 f3 ad 10 80       	push   $0x8010adf3
8010230f:	e8 c3 49 00 00       	call   80106cd7 <cprintf>
80102314:	83 c4 10             	add    $0x10,%esp
        goto failed;
80102317:	e9 e1 00 00 00       	jmp    801023fd <do_pgfault+0x20a>
    }
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
8010231c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010231f:	8b 00                	mov    (%eax),%eax
80102321:	85 c0                	test   %eax,%eax
80102323:	75 35                	jne    8010235a <do_pgfault+0x167>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
80102325:	8b 45 08             	mov    0x8(%ebp),%eax
80102328:	8b 40 0c             	mov    0xc(%eax),%eax
8010232b:	83 ec 04             	sub    $0x4,%esp
8010232e:	ff 75 f0             	pushl  -0x10(%ebp)
80102331:	ff 75 10             	pushl  0x10(%ebp)
80102334:	50                   	push   %eax
80102335:	e8 a6 ed ff ff       	call   801010e0 <pgdir_alloc_page>
8010233a:	83 c4 10             	add    $0x10,%esp
8010233d:	85 c0                	test   %eax,%eax
8010233f:	0f 85 b1 00 00 00    	jne    801023f6 <do_pgfault+0x203>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
80102345:	83 ec 0c             	sub    $0xc,%esp
80102348:	68 14 ae 10 80       	push   $0x8010ae14
8010234d:	e8 85 49 00 00       	call   80106cd7 <cprintf>
80102352:	83 c4 10             	add    $0x10,%esp
            goto failed;
80102355:	e9 a3 00 00 00       	jmp    801023fd <do_pgfault+0x20a>
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
8010235a:	a1 b8 6e 12 80       	mov    0x80126eb8,%eax
8010235f:	85 c0                	test   %eax,%eax
80102361:	74 7b                	je     801023de <do_pgfault+0x1eb>
            struct page *page=NULL;
80102363:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((ret = swap_in(mm, addr, &page)) == false) {
8010236a:	83 ec 04             	sub    $0x4,%esp
8010236d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102370:	50                   	push   %eax
80102371:	ff 75 10             	pushl  0x10(%ebp)
80102374:	ff 75 08             	pushl  0x8(%ebp)
80102377:	e8 c0 e9 ff ff       	call   80100d3c <swap_in>
8010237c:	83 c4 10             	add    $0x10,%esp
8010237f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102386:	75 12                	jne    8010239a <do_pgfault+0x1a7>
                cprintf("swap_in in do_pgfault failed\n");
80102388:	83 ec 0c             	sub    $0xc,%esp
8010238b:	68 3b ae 10 80       	push   $0x8010ae3b
80102390:	e8 42 49 00 00       	call   80106cd7 <cprintf>
80102395:	83 c4 10             	add    $0x10,%esp
80102398:	eb 63                	jmp    801023fd <do_pgfault+0x20a>
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm);
8010239a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010239d:	8b 45 08             	mov    0x8(%ebp),%eax
801023a0:	8b 40 0c             	mov    0xc(%eax),%eax
801023a3:	ff 75 f0             	pushl  -0x10(%ebp)
801023a6:	ff 75 10             	pushl  0x10(%ebp)
801023a9:	52                   	push   %edx
801023aa:	50                   	push   %eax
801023ab:	e8 98 ec ff ff       	call   80101048 <page_insert>
801023b0:	83 c4 10             	add    $0x10,%esp
            swap_map_swappable(mm, addr, page, 1);
801023b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023b6:	6a 01                	push   $0x1
801023b8:	50                   	push   %eax
801023b9:	ff 75 10             	pushl  0x10(%ebp)
801023bc:	ff 75 08             	pushl  0x8(%ebp)
801023bf:	e8 e7 e7 ff ff       	call   80100bab <swap_map_swappable>
801023c4:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr = addr;
801023c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023ca:	8b 55 10             	mov    0x10(%ebp),%edx
801023cd:	89 50 06             	mov    %edx,0x6(%eax)
            page->pgdir = mm->pgdir;
801023d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023d3:	8b 55 08             	mov    0x8(%ebp),%edx
801023d6:	8b 52 0c             	mov    0xc(%edx),%edx
801023d9:	89 50 02             	mov    %edx,0x2(%eax)
801023dc:	eb 18                	jmp    801023f6 <do_pgfault+0x203>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
801023de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801023e1:	8b 00                	mov    (%eax),%eax
801023e3:	83 ec 08             	sub    $0x8,%esp
801023e6:	50                   	push   %eax
801023e7:	68 5c ae 10 80       	push   $0x8010ae5c
801023ec:	e8 e6 48 00 00       	call   80106cd7 <cprintf>
801023f1:	83 c4 10             	add    $0x10,%esp
            goto failed;
801023f4:	eb 07                	jmp    801023fd <do_pgfault+0x20a>
        }
   }
   ret = 0;
801023f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
801023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102400:	c9                   	leave  
80102401:	c3                   	ret    

80102402 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write){
80102402:	55                   	push   %ebp
80102403:	89 e5                	mov    %esp,%ebp
80102405:	83 ec 18             	sub    $0x18,%esp
    if(mm != NULL){
80102408:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010240c:	0f 84 ed 00 00 00    	je     801024ff <user_mem_check+0xfd>
        if(!USER_ACCESS(addr, addr + len)){
80102412:	8b 55 0c             	mov    0xc(%ebp),%edx
80102415:	8b 45 10             	mov    0x10(%ebp),%eax
80102418:	01 d0                	add    %edx,%eax
8010241a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010241d:	76 0f                	jbe    8010242e <user_mem_check+0x2c>
8010241f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102422:	8b 45 10             	mov    0x10(%ebp),%eax
80102425:	01 d0                	add    %edx,%eax
80102427:	3d 00 00 00 04       	cmp    $0x4000000,%eax
8010242c:	76 0a                	jbe    80102438 <user_mem_check+0x36>
            return false;
8010242e:	b8 00 00 00 00       	mov    $0x0,%eax
80102433:	e9 cc 00 00 00       	jmp    80102504 <user_mem_check+0x102>
        }

        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
80102438:	8b 45 0c             	mov    0xc(%ebp),%eax
8010243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010243e:	8b 55 0c             	mov    0xc(%ebp),%edx
80102441:	8b 45 10             	mov    0x10(%ebp),%eax
80102444:	01 d0                	add    %edx,%eax
80102446:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while(start < end){
80102449:	e9 9e 00 00 00       	jmp    801024ec <user_mem_check+0xea>
            if((vma = find_vma(mm, start)) == NULL || start < vma->vm_start){
8010244e:	ff 75 f4             	pushl  -0xc(%ebp)
80102451:	ff 75 08             	pushl  0x8(%ebp)
80102454:	e8 15 f5 ff ff       	call   8010196e <find_vma>
80102459:	83 c4 08             	add    $0x8,%esp
8010245c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010245f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80102463:	74 0b                	je     80102470 <user_mem_check+0x6e>
80102465:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102468:	8b 40 04             	mov    0x4(%eax),%eax
8010246b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010246e:	76 0a                	jbe    8010247a <user_mem_check+0x78>
                return 0;
80102470:	b8 00 00 00 00       	mov    $0x0,%eax
80102475:	e9 8a 00 00 00       	jmp    80102504 <user_mem_check+0x102>
            }

            if(!(vma->vm_flags & ((write ? VM_WRITE : VM_READ)))){
8010247a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010247d:	8b 40 0c             	mov    0xc(%eax),%eax
80102480:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102484:	74 07                	je     8010248d <user_mem_check+0x8b>
80102486:	ba 02 00 00 00       	mov    $0x2,%edx
8010248b:	eb 05                	jmp    80102492 <user_mem_check+0x90>
8010248d:	ba 01 00 00 00       	mov    $0x1,%edx
80102492:	21 d0                	and    %edx,%eax
80102494:	85 c0                	test   %eax,%eax
80102496:	75 07                	jne    8010249f <user_mem_check+0x9d>
                return 0;
80102498:	b8 00 00 00 00       	mov    $0x0,%eax
8010249d:	eb 65                	jmp    80102504 <user_mem_check+0x102>
            }

            if(write && (vma->vm_flags & VM_STACK)){
8010249f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801024a3:	74 3e                	je     801024e3 <user_mem_check+0xe1>
801024a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801024a8:	8b 40 0c             	mov    0xc(%eax),%eax
801024ab:	83 e0 08             	and    $0x8,%eax
801024ae:	85 c0                	test   %eax,%eax
801024b0:	74 31                	je     801024e3 <user_mem_check+0xe1>
                panic("VM_STACK test maybe wrong");
801024b2:	83 ec 04             	sub    $0x4,%esp
801024b5:	68 84 ae 10 80       	push   $0x8010ae84
801024ba:	68 8d 03 00 00       	push   $0x38d
801024bf:	68 59 aa 10 80       	push   $0x8010aa59
801024c4:	e8 8b de ff ff       	call   80100354 <__panic>
801024c9:	83 c4 10             	add    $0x10,%esp
                if(start < vma->vm_start + PGSIZE){
801024cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801024cf:	8b 40 04             	mov    0x4(%eax),%eax
801024d2:	05 00 10 00 00       	add    $0x1000,%eax
801024d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801024da:	76 07                	jbe    801024e3 <user_mem_check+0xe1>
                    return 0;
801024dc:	b8 00 00 00 00       	mov    $0x0,%eax
801024e1:	eb 21                	jmp    80102504 <user_mem_check+0x102>
                } 
            }

            start = vma->vm_end;
801024e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801024e6:	8b 40 08             	mov    0x8(%eax),%eax
801024e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            return false;
        }

        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while(start < end){
801024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801024f2:	0f 82 56 ff ff ff    	jb     8010244e <user_mem_check+0x4c>
            }

            start = vma->vm_end;

        }
        return 1;
801024f8:	b8 01 00 00 00       	mov    $0x1,%eax
801024fd:	eb 05                	jmp    80102504 <user_mem_check+0x102>
    }
    return 1;
801024ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
80102504:	c9                   	leave  
80102505:	c3                   	ret    

80102506 <init_pra_list_manager>:
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */

static void
init_pra_list_manager(struct pra_list_manager *p)
{
80102506:	55                   	push   %ebp
80102507:	89 e5                	mov    %esp,%ebp
80102509:	83 ec 10             	sub    $0x10,%esp
     p->busy_count = p->free_count = 0;
8010250c:	8b 45 08             	mov    0x8(%ebp),%eax
8010250f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80102516:	8b 45 08             	mov    0x8(%ebp),%eax
80102519:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
     list_init(&p->free_list);
80102520:	8b 45 08             	mov    0x8(%ebp),%eax
80102523:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80102526:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102529:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010252c:	89 50 04             	mov    %edx,0x4(%eax)
8010252f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102532:	8b 50 04             	mov    0x4(%eax),%edx
80102535:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102538:	89 10                	mov    %edx,(%eax)
     list_init(&p->busy_list);
8010253a:	8b 45 08             	mov    0x8(%ebp),%eax
8010253d:	83 c0 0c             	add    $0xc,%eax
80102540:	89 45 f8             	mov    %eax,-0x8(%ebp)
80102543:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102546:	8b 55 f8             	mov    -0x8(%ebp),%edx
80102549:	89 50 04             	mov    %edx,0x4(%eax)
8010254c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010254f:	8b 50 04             	mov    0x4(%eax),%edx
80102552:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102555:	89 10                	mov    %edx,(%eax)
}
80102557:	90                   	nop
80102558:	c9                   	leave  
80102559:	c3                   	ret    

8010255a <_lru_init_mm>:
static int
_lru_init_mm(struct mm_struct *mm)
{
8010255a:	55                   	push   %ebp
8010255b:	89 e5                	mov    %esp,%ebp
     init_pra_list_manager(&_pra_list_manager);
8010255d:	68 70 70 12 80       	push   $0x80127070
80102562:	e8 9f ff ff ff       	call   80102506 <init_pra_list_manager>
80102567:	83 c4 04             	add    $0x4,%esp
     mm->sm_priv = &_pra_list_manager;
8010256a:	8b 45 08             	mov    0x8(%ebp),%eax
8010256d:	c7 40 18 70 70 12 80 	movl   $0x80127070,0x18(%eax)

     return 1;
80102574:	b8 01 00 00 00       	mov    $0x1,%eax
}
80102579:	c9                   	leave  
8010257a:	c3                   	ret    

8010257b <_lru_swap_cleanup>:

static list_entry_t*
_lru_swap_cleanup(struct mm_struct *mm, int32_t cleanup_len)
{
8010257b:	55                   	push   %ebp
8010257c:	89 e5                	mov    %esp,%ebp
8010257e:	81 ec 98 00 00 00    	sub    $0x98,%esp
    //init value
    struct pra_list_manager* p = (struct pra_list_manager*)mm->sm_priv;
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
80102587:	8b 40 18             	mov    0x18(%eax),%eax
8010258a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    list_entry_t *free_head = &p->free_list;
8010258d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102590:	89 45 e0             	mov    %eax,-0x20(%ebp)
    list_entry_t *busy_head = &p->busy_list;
80102593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102596:	83 c0 0c             	add    $0xc,%eax
80102599:	89 45 dc             	mov    %eax,-0x24(%ebp)

    int32_t free_i = MIN(cleanup_len, p->free_count), busy_i = MIN(cleanup_len, p->busy_count);
8010259c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010259f:	8b 50 08             	mov    0x8(%eax),%edx
801025a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801025a5:	39 c2                	cmp    %eax,%edx
801025a7:	0f 4e c2             	cmovle %edx,%eax
801025aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801025ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025b0:	8b 50 14             	mov    0x14(%eax),%edx
801025b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801025b6:	39 c2                	cmp    %eax,%edx
801025b8:	0f 46 c2             	cmovbe %edx,%eax
801025bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    list_entry_t *found = NULL;
801025be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int32_t i,delt;

    //find list_busy 
    list_entry_t *le = busy_head->next;
801025c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025c8:	8b 40 04             	mov    0x4(%eax),%eax
801025cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(i = 0, delt = 0 ; i < busy_i ; i ++,le = le->next)
801025ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801025d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801025dc:	e9 27 01 00 00       	jmp    80102708 <_lru_swap_cleanup+0x18d>
    {
       struct page *page = le2page(le, pra_page_link);
801025e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801025e4:	83 e8 0a             	sub    $0xa,%eax
801025e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
       if(page->pgdir == NULL)
801025ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025ed:	8b 40 02             	mov    0x2(%eax),%eax
801025f0:	85 c0                	test   %eax,%eax
801025f2:	75 3c                	jne    80102630 <_lru_swap_cleanup+0xb5>
801025f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801025f7:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
801025fa:	8b 45 ac             	mov    -0x54(%ebp),%eax
801025fd:	8b 40 04             	mov    0x4(%eax),%eax
80102600:	8b 55 ac             	mov    -0x54(%ebp),%edx
80102603:	8b 12                	mov    (%edx),%edx
80102605:	89 55 a8             	mov    %edx,-0x58(%ebp)
80102608:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
8010260b:	8b 45 a8             	mov    -0x58(%ebp),%eax
8010260e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80102611:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80102614:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80102617:	8b 55 a8             	mov    -0x58(%ebp),%edx
8010261a:	89 10                	mov    %edx,(%eax)
       {
           list_del(le);
           p->busy_count --;
8010261c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010261f:	8b 40 14             	mov    0x14(%eax),%eax
80102622:	8d 50 ff             	lea    -0x1(%eax),%edx
80102625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102628:	89 50 14             	mov    %edx,0x14(%eax)
           continue;
8010262b:	e9 cb 00 00 00       	jmp    801026fb <_lru_swap_cleanup+0x180>
       }
       pte_t* ptep = read_pte_addr(page->pgdir, page->pra_vaddr, 0);
80102630:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102633:	8b 50 06             	mov    0x6(%eax),%edx
80102636:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102639:	8b 40 02             	mov    0x2(%eax),%eax
8010263c:	83 ec 04             	sub    $0x4,%esp
8010263f:	6a 00                	push   $0x0
80102641:	52                   	push   %edx
80102642:	50                   	push   %eax
80102643:	e8 ae e8 ff ff       	call   80100ef6 <read_pte_addr>
80102648:	83 c4 10             	add    $0x10,%esp
8010264b:	89 45 c8             	mov    %eax,-0x38(%ebp)
       assert((*ptep & PTE_P) != 0);
8010264e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102651:	8b 00                	mov    (%eax),%eax
80102653:	83 e0 01             	and    $0x1,%eax
80102656:	85 c0                	test   %eax,%eax
80102658:	75 19                	jne    80102673 <_lru_swap_cleanup+0xf8>
8010265a:	68 a0 ae 10 80       	push   $0x8010aea0
8010265f:	68 b5 ae 10 80       	push   $0x8010aeb5
80102664:	6a 40                	push   $0x40
80102666:	68 cb ae 10 80       	push   $0x8010aecb
8010266b:	e8 e4 dc ff ff       	call   80100354 <__panic>
80102670:	83 c4 10             	add    $0x10,%esp
       if(!(*ptep & PTE_A || *ptep & PTE_D))
80102673:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102676:	8b 00                	mov    (%eax),%eax
80102678:	83 e0 20             	and    $0x20,%eax
8010267b:	85 c0                	test   %eax,%eax
8010267d:	75 7c                	jne    801026fb <_lru_swap_cleanup+0x180>
8010267f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102682:	8b 00                	mov    (%eax),%eax
80102684:	83 e0 40             	and    $0x40,%eax
80102687:	85 c0                	test   %eax,%eax
80102689:	75 70                	jne    801026fb <_lru_swap_cleanup+0x180>
8010268b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010268e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80102691:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102694:	8b 40 04             	mov    0x4(%eax),%eax
80102697:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010269a:	8b 12                	mov    (%edx),%edx
8010269c:	89 55 90             	mov    %edx,-0x70(%ebp)
8010269f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
801026a2:	8b 45 90             	mov    -0x70(%ebp),%eax
801026a5:	8b 55 8c             	mov    -0x74(%ebp),%edx
801026a8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
801026ab:	8b 45 8c             	mov    -0x74(%ebp),%eax
801026ae:	8b 55 90             	mov    -0x70(%ebp),%edx
801026b1:	89 10                	mov    %edx,(%eax)
801026b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801026b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
801026b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801026bc:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) 
{
    __list_add(elm, listelm->prev, listelm);    
801026bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
801026c2:	8b 00                	mov    (%eax),%eax
801026c4:	8b 55 a0             	mov    -0x60(%ebp),%edx
801026c7:	89 55 9c             	mov    %edx,-0x64(%ebp)
801026ca:	89 45 98             	mov    %eax,-0x68(%ebp)
801026cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801026d0:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
801026d3:	8b 45 94             	mov    -0x6c(%ebp),%eax
801026d6:	8b 55 9c             	mov    -0x64(%ebp),%edx
801026d9:	89 10                	mov    %edx,(%eax)
801026db:	8b 45 94             	mov    -0x6c(%ebp),%eax
801026de:	8b 10                	mov    (%eax),%edx
801026e0:	8b 45 98             	mov    -0x68(%ebp),%eax
801026e3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
801026e6:	8b 45 9c             	mov    -0x64(%ebp),%eax
801026e9:	8b 55 94             	mov    -0x6c(%ebp),%edx
801026ec:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
801026ef:	8b 45 9c             	mov    -0x64(%ebp),%eax
801026f2:	8b 55 98             	mov    -0x68(%ebp),%edx
801026f5:	89 10                	mov    %edx,(%eax)
       {
           list_del(le);
           list_add_before(free_head, le);
           delt ++;
801026f7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    list_entry_t *found = NULL;
    int32_t i,delt;

    //find list_busy 
    list_entry_t *le = busy_head->next;
    for(i = 0, delt = 0 ; i < busy_i ; i ++,le = le->next)
801026fb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801026ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102702:	8b 40 04             	mov    0x4(%eax),%eax
80102705:	89 45 e8             	mov    %eax,-0x18(%ebp)
80102708:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010270b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
8010270e:	0f 8c cd fe ff ff    	jl     801025e1 <_lru_swap_cleanup+0x66>
           list_del(le);
           list_add_before(free_head, le);
           delt ++;
       }
    }
    p->free_count += delt;
80102714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102717:	8b 50 08             	mov    0x8(%eax),%edx
8010271a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010271d:	01 c2                	add    %eax,%edx
8010271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102722:	89 50 08             	mov    %edx,0x8(%eax)
    p->busy_count -= delt;
80102725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102728:	8b 50 14             	mov    0x14(%eax),%edx
8010272b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010272e:	29 c2                	sub    %eax,%edx
80102730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102733:	89 50 14             	mov    %edx,0x14(%eax)

    //find list_free
    le = free_head->next;
80102736:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102739:	8b 40 04             	mov    0x4(%eax),%eax
8010273c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(i = 0, delt = 0 ; i < free_i ; i ++,le = le->next)
8010273f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80102746:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010274d:	e9 8f 01 00 00       	jmp    801028e1 <_lru_swap_cleanup+0x366>
    {
       struct page *page = le2page(le, pra_page_link);
80102752:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102755:	83 e8 0a             	sub    $0xa,%eax
80102758:	89 45 bc             	mov    %eax,-0x44(%ebp)
       if(page->pgdir == NULL)
8010275b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010275e:	8b 40 02             	mov    0x2(%eax),%eax
80102761:	85 c0                	test   %eax,%eax
80102763:	75 3c                	jne    801027a1 <_lru_swap_cleanup+0x226>
80102765:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102768:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
8010276b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010276e:	8b 40 04             	mov    0x4(%eax),%eax
80102771:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80102774:	8b 12                	mov    (%edx),%edx
80102776:	89 55 88             	mov    %edx,-0x78(%ebp)
80102779:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
8010277c:	8b 45 88             	mov    -0x78(%ebp),%eax
8010277f:	8b 55 84             	mov    -0x7c(%ebp),%edx
80102782:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80102785:	8b 45 84             	mov    -0x7c(%ebp),%eax
80102788:	8b 55 88             	mov    -0x78(%ebp),%edx
8010278b:	89 10                	mov    %edx,(%eax)
       {
           list_del(le);
           p->free_count --;
8010278d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102790:	8b 40 08             	mov    0x8(%eax),%eax
80102793:	8d 50 ff             	lea    -0x1(%eax),%edx
80102796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102799:	89 50 08             	mov    %edx,0x8(%eax)
           continue;
8010279c:	e9 33 01 00 00       	jmp    801028d4 <_lru_swap_cleanup+0x359>
       }
       assert(page->pgdir != NULL);
801027a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801027a4:	8b 40 02             	mov    0x2(%eax),%eax
801027a7:	85 c0                	test   %eax,%eax
801027a9:	75 19                	jne    801027c4 <_lru_swap_cleanup+0x249>
801027ab:	68 de ae 10 80       	push   $0x8010aede
801027b0:	68 b5 ae 10 80       	push   $0x8010aeb5
801027b5:	6a 56                	push   $0x56
801027b7:	68 cb ae 10 80       	push   $0x8010aecb
801027bc:	e8 93 db ff ff       	call   80100354 <__panic>
801027c1:	83 c4 10             	add    $0x10,%esp
       pte_t* ptep = read_pte_addr(page->pgdir, page->pra_vaddr, 0);
801027c4:	8b 45 bc             	mov    -0x44(%ebp),%eax
801027c7:	8b 50 06             	mov    0x6(%eax),%edx
801027ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
801027cd:	8b 40 02             	mov    0x2(%eax),%eax
801027d0:	83 ec 04             	sub    $0x4,%esp
801027d3:	6a 00                	push   $0x0
801027d5:	52                   	push   %edx
801027d6:	50                   	push   %eax
801027d7:	e8 1a e7 ff ff       	call   80100ef6 <read_pte_addr>
801027dc:	83 c4 10             	add    $0x10,%esp
801027df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
       assert(*ptep & PTE_P);
801027e2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801027e5:	8b 00                	mov    (%eax),%eax
801027e7:	83 e0 01             	and    $0x1,%eax
801027ea:	85 c0                	test   %eax,%eax
801027ec:	75 19                	jne    80102807 <_lru_swap_cleanup+0x28c>
801027ee:	68 f2 ae 10 80       	push   $0x8010aef2
801027f3:	68 b5 ae 10 80       	push   $0x8010aeb5
801027f8:	6a 58                	push   $0x58
801027fa:	68 cb ae 10 80       	push   $0x8010aecb
801027ff:	e8 50 db ff ff       	call   80100354 <__panic>
80102804:	83 c4 10             	add    $0x10,%esp
       if(*ptep & PTE_A || *ptep & PTE_D)
80102807:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010280a:	8b 00                	mov    (%eax),%eax
8010280c:	83 e0 20             	and    $0x20,%eax
8010280f:	85 c0                	test   %eax,%eax
80102811:	75 10                	jne    80102823 <_lru_swap_cleanup+0x2a8>
80102813:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80102816:	8b 00                	mov    (%eax),%eax
80102818:	83 e0 40             	and    $0x40,%eax
8010281b:	85 c0                	test   %eax,%eax
8010281d:	0f 84 a5 00 00 00    	je     801028c8 <_lru_swap_cleanup+0x34d>
80102823:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102826:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80102829:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010282c:	8b 40 04             	mov    0x4(%eax),%eax
8010282f:	8b 55 b0             	mov    -0x50(%ebp),%edx
80102832:	8b 12                	mov    (%edx),%edx
80102834:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
8010283a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80102840:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80102846:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
8010284c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
8010284f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80102855:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
8010285b:	89 10                	mov    %edx,(%eax)
8010285d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102860:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102863:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102866:	89 45 80             	mov    %eax,-0x80(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) 
{
    __list_add(elm, listelm->prev, listelm);    
80102869:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010286c:	8b 00                	mov    (%eax),%eax
8010286e:	8b 55 80             	mov    -0x80(%ebp),%edx
80102871:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
80102877:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
8010287d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102880:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
80102886:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
8010288c:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
80102892:	89 10                	mov    %edx,(%eax)
80102894:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
8010289a:	8b 10                	mov    (%eax),%edx
8010289c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
801028a2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
801028a5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
801028ab:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
801028b1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
801028b4:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
801028ba:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
801028c0:	89 10                	mov    %edx,(%eax)
       {
           list_del(le);
           list_add_before(busy_head, le);
           delt ++;
801028c2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801028c6:	eb 0c                	jmp    801028d4 <_lru_swap_cleanup+0x359>
       }else{
           if(found == NULL)
801028c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028cc:	75 06                	jne    801028d4 <_lru_swap_cleanup+0x359>
               found = le; 
801028ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801028d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p->free_count += delt;
    p->busy_count -= delt;

    //find list_free
    le = free_head->next;
    for(i = 0, delt = 0 ; i < free_i ; i ++,le = le->next)
801028d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801028d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801028db:	8b 40 04             	mov    0x4(%eax),%eax
801028de:	89 45 e8             	mov    %eax,-0x18(%ebp)
801028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028e4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
801028e7:	0f 8c 65 fe ff ff    	jl     80102752 <_lru_swap_cleanup+0x1d7>
       }else{
           if(found == NULL)
               found = le; 
       }
    }
    p->free_count -= delt;
801028ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801028f0:	8b 40 08             	mov    0x8(%eax),%eax
801028f3:	2b 45 ec             	sub    -0x14(%ebp),%eax
801028f6:	89 c2                	mov    %eax,%edx
801028f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801028fb:	89 50 08             	mov    %edx,0x8(%eax)
    p->busy_count += delt;
801028fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102901:	8b 50 14             	mov    0x14(%eax),%edx
80102904:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102907:	01 c2                	add    %eax,%edx
80102909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010290c:	89 50 14             	mov    %edx,0x14(%eax)

    return found;
8010290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102912:	c9                   	leave  
80102913:	c3                   	ret    

80102914 <_lru_swap_out_victim>:
 *                            then set the addr of addr of this page to ptr_page.
 */

static bool
_lru_swap_out_victim(struct mm_struct *mm, struct page ** ptr_page, int in_tick)
{
80102914:	55                   	push   %ebp
80102915:	89 e5                	mov    %esp,%ebp
80102917:	83 ec 28             	sub    $0x28,%esp
    struct pra_list_manager* p = (struct pra_list_manager*)mm->sm_priv;
8010291a:	8b 45 08             	mov    0x8(%ebp),%eax
8010291d:	8b 40 18             	mov    0x18(%eax),%eax
80102920:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *free_head = &p->free_list;
80102923:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102926:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *busy_head = &p->busy_list;
80102929:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010292c:	83 c0 0c             	add    $0xc,%eax
8010292f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    list_entry_t *found;

    assert(in_tick == 0);
80102932:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102936:	74 19                	je     80102951 <_lru_swap_out_victim+0x3d>
80102938:	68 00 af 10 80       	push   $0x8010af00
8010293d:	68 b5 ae 10 80       	push   $0x8010aeb5
80102942:	6a 76                	push   $0x76
80102944:	68 cb ae 10 80       	push   $0x8010aecb
80102949:	e8 06 da ff ff       	call   80100354 <__panic>
8010294e:	83 c4 10             	add    $0x10,%esp
    assert( free_head != NULL && busy_head != NULL);
80102951:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80102955:	74 06                	je     8010295d <_lru_swap_out_victim+0x49>
80102957:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010295b:	75 19                	jne    80102976 <_lru_swap_out_victim+0x62>
8010295d:	68 10 af 10 80       	push   $0x8010af10
80102962:	68 b5 ae 10 80       	push   $0x8010aeb5
80102967:	6a 77                	push   $0x77
80102969:	68 cb ae 10 80       	push   $0x8010aecb
8010296e:	e8 e1 d9 ff ff       	call   80100354 <__panic>
80102973:	83 c4 10             	add    $0x10,%esp

    found = _lru_swap_cleanup(mm, LEN);
80102976:	83 ec 08             	sub    $0x8,%esp
80102979:	6a 0a                	push   $0xa
8010297b:	ff 75 08             	pushl  0x8(%ebp)
8010297e:	e8 f8 fb ff ff       	call   8010257b <_lru_swap_cleanup>
80102983:	83 c4 10             	add    $0x10,%esp
80102986:	89 45 f4             	mov    %eax,-0xc(%ebp)

    //point the first one
    if(found == NULL) 
80102989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010298d:	75 4f                	jne    801029de <_lru_swap_out_victim+0xca>
    {
        if(p->free_count != 0)
8010298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102992:	8b 40 08             	mov    0x8(%eax),%eax
80102995:	85 c0                	test   %eax,%eax
80102997:	74 1a                	je     801029b3 <_lru_swap_out_victim+0x9f>
        {
            found = free_head->next;
80102999:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010299c:	8b 40 04             	mov    0x4(%eax),%eax
8010299f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->free_count --;
801029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029a5:	8b 40 08             	mov    0x8(%eax),%eax
801029a8:	8d 50 ff             	lea    -0x1(%eax),%edx
801029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029ae:	89 50 08             	mov    %edx,0x8(%eax)
801029b1:	eb 3a                	jmp    801029ed <_lru_swap_out_victim+0xd9>
        }
        else{
           if(p->busy_count == 0) return false;
801029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029b6:	8b 40 14             	mov    0x14(%eax),%eax
801029b9:	85 c0                	test   %eax,%eax
801029bb:	75 07                	jne    801029c4 <_lru_swap_out_victim+0xb0>
801029bd:	b8 00 00 00 00       	mov    $0x0,%eax
801029c2:	eb 61                	jmp    80102a25 <_lru_swap_out_victim+0x111>
           found = busy_head->next; 
801029c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801029c7:	8b 40 04             	mov    0x4(%eax),%eax
801029ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
           p->busy_count --;
801029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029d0:	8b 40 14             	mov    0x14(%eax),%eax
801029d3:	8d 50 ff             	lea    -0x1(%eax),%edx
801029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029d9:	89 50 14             	mov    %edx,0x14(%eax)
801029dc:	eb 0f                	jmp    801029ed <_lru_swap_out_victim+0xd9>
        }
    }else{
        p->free_count --;
801029de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029e1:	8b 40 08             	mov    0x8(%eax),%eax
801029e4:	8d 50 ff             	lea    -0x1(%eax),%edx
801029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029ea:	89 50 08             	mov    %edx,0x8(%eax)
801029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
801029f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801029f6:	8b 40 04             	mov    0x4(%eax),%eax
801029f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801029fc:	8b 12                	mov    (%edx),%edx
801029fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102a01:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80102a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102a07:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102a0a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80102a0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102a10:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102a13:	89 10                	mov    %edx,(%eax)
    }
    
    list_del(found); 
    *ptr_page = le2page(found, pra_page_link);
80102a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a18:	8d 50 f6             	lea    -0xa(%eax),%edx
80102a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a1e:	89 10                	mov    %edx,(%eax)


    return true;
80102a20:	b8 01 00 00 00       	mov    $0x1,%eax
}
80102a25:	c9                   	leave  
80102a26:	c3                   	ret    

80102a27 <_lru_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static bool
_lru_map_swappable(struct mm_struct *mm, uintptr_t addr, struct page *page, int swap_in)
{
80102a27:	55                   	push   %ebp
80102a28:	89 e5                	mov    %esp,%ebp
80102a2a:	83 ec 28             	sub    $0x28,%esp
    struct pra_list_manager* p = (struct pra_list_manager*)mm->sm_priv;
80102a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a30:	8b 40 18             	mov    0x18(%eax),%eax
80102a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *free_head = &p->free_list;
80102a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *entry = &(page->pra_page_link);
80102a3c:	8b 45 10             	mov    0x10(%ebp),%eax
80102a3f:	83 c0 0a             	add    $0xa,%eax
80102a42:	89 45 ec             	mov    %eax,-0x14(%ebp)
    _lru_swap_cleanup(mm, LEN);
80102a45:	83 ec 08             	sub    $0x8,%esp
80102a48:	6a 0a                	push   $0xa
80102a4a:	ff 75 08             	pushl  0x8(%ebp)
80102a4d:	e8 29 fb ff ff       	call   8010257b <_lru_swap_cleanup>
80102a52:	83 c4 10             	add    $0x10,%esp
80102a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a58:	89 45 e8             	mov    %eax,-0x18(%ebp)
80102a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) 
{
    __list_add(elm, listelm->prev, listelm);    
80102a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102a64:	8b 00                	mov    (%eax),%eax
80102a66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102a69:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102a6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102a72:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
80102a75:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102a78:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102a7b:	89 10                	mov    %edx,(%eax)
80102a7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102a80:	8b 10                	mov    (%eax),%edx
80102a82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102a85:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
80102a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102a8b:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102a8e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
80102a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102a94:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102a97:	89 10                	mov    %edx,(%eax)

    list_add_before(free_head, entry);
    p->free_count ++;
80102a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a9c:	8b 40 08             	mov    0x8(%eax),%eax
80102a9f:	8d 50 01             	lea    0x1(%eax),%edx
80102aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa5:	89 50 08             	mov    %edx,0x8(%eax)
    return true;
80102aa8:	b8 01 00 00 00       	mov    $0x1,%eax
}
80102aad:	c9                   	leave  
80102aae:	c3                   	ret    

80102aaf <_lru_check_swap>:


static int
_lru_check_swap(void) {
80102aaf:	55                   	push   %ebp
80102ab0:	89 e5                	mov    %esp,%ebp
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    */
    return 0;
80102ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ab7:	5d                   	pop    %ebp
80102ab8:	c3                   	ret    

80102ab9 <_lru_init>:

static bool
_lru_init(void)
{
80102ab9:	55                   	push   %ebp
80102aba:	89 e5                	mov    %esp,%ebp
    return true;
80102abc:	b8 01 00 00 00       	mov    $0x1,%eax
}
80102ac1:	5d                   	pop    %ebp
80102ac2:	c3                   	ret    

80102ac3 <_lru_set_unswappable>:


static int
_lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
80102ac3:	55                   	push   %ebp
80102ac4:	89 e5                	mov    %esp,%ebp
    return 0;
80102ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102acb:	5d                   	pop    %ebp
80102acc:	c3                   	ret    

80102acd <_lru_tick_event>:

static int
_lru_tick_event(struct mm_struct *mm)
{ return 0; }
80102acd:	55                   	push   %ebp
80102ace:	89 e5                	mov    %esp,%ebp
80102ad0:	b8 00 00 00 00       	mov    $0x0,%eax
80102ad5:	5d                   	pop    %ebp
80102ad6:	c3                   	ret    

80102ad7 <select_slab>:
};

//0 = normal, 1 = kmm_cache, 2 = kmm_slab 
static int32_t
select_slab(size_t size)
{
80102ad7:	55                   	push   %ebp
80102ad8:	89 e5                	mov    %esp,%ebp
80102ada:	83 ec 18             	sub    $0x18,%esp
    if(size > slab_size_map[SLAB_NORMAL - 1])
80102add:	a1 c8 40 12 80       	mov    0x801240c8,%eax
80102ae2:	3b 45 08             	cmp    0x8(%ebp),%eax
80102ae5:	73 1e                	jae    80102b05 <select_slab+0x2e>
    {
        panic("NO VALID SLAB");
80102ae7:	83 ec 04             	sub    $0x4,%esp
80102aea:	68 a7 af 10 80       	push   $0x8010afa7
80102aef:	6a 34                	push   $0x34
80102af1:	68 b5 af 10 80       	push   $0x8010afb5
80102af6:	e8 59 d8 ff ff       	call   80100354 <__panic>
80102afb:	83 c4 10             	add    $0x10,%esp
        return -1;
80102afe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b03:	eb 43                	jmp    80102b48 <select_slab+0x71>
    }
    //binfind will be better
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
80102b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b0c:	eb 18                	jmp    80102b26 <select_slab+0x4f>
    {
        if(slab_size_map[i] >= size)
80102b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b11:	8b 04 85 a0 40 12 80 	mov    -0x7fedbf60(,%eax,4),%eax
80102b18:	3b 45 08             	cmp    0x8(%ebp),%eax
80102b1b:	72 05                	jb     80102b22 <select_slab+0x4b>
        {
            return i;
80102b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b20:	eb 26                	jmp    80102b48 <select_slab+0x71>
        panic("NO VALID SLAB");
        return -1;
    }
    //binfind will be better
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
80102b22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b26:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80102b2a:	7e e2                	jle    80102b0e <select_slab+0x37>
        if(slab_size_map[i] >= size)
        {
            return i;
        }
    }
    panic("NO VALID SLAB");
80102b2c:	83 ec 04             	sub    $0x4,%esp
80102b2f:	68 a7 af 10 80       	push   $0x8010afa7
80102b34:	6a 40                	push   $0x40
80102b36:	68 b5 af 10 80       	push   $0x8010afb5
80102b3b:	e8 14 d8 ff ff       	call   80100354 <__panic>
80102b40:	83 c4 10             	add    $0x10,%esp
    return -1;
80102b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b48:	c9                   	leave  
80102b49:	c3                   	ret    

80102b4a <init_slab_allocator>:
static size_t init_before_page;
void 
init_slab_allocator()
{
80102b4a:	55                   	push   %ebp
80102b4b:	89 e5                	mov    %esp,%ebp
80102b4d:	83 ec 18             	sub    $0x18,%esp
    init_before_page = nr_free_pages();
80102b50:	e8 d5 de ff ff       	call   80100a2a <nr_free_pages>
80102b55:	a3 50 6f 12 80       	mov    %eax,0x80126f50
    //install special slab -> cache,slab
    slab_size_map[SLAB_NORMAL] = sizeof(struct kmm_cache); 
80102b5a:	c7 05 cc 40 12 80 78 	movl   $0x78,0x801240cc
80102b61:	00 00 00 
    slab_size_map[SLAB_NORMAL + 1] = sizeof(struct kmm_slab);
80102b64:	c7 05 d0 40 12 80 1c 	movl   $0x1c,0x801240d0
80102b6b:	00 00 00 

    //init 'slab cache' slab  
    slab_allocator[SLAB_NORMAL] = kmm_cache_create("KMM_CACHE",sizeof(struct kmm_cache));
80102b6e:	83 ec 08             	sub    $0x8,%esp
80102b71:	6a 78                	push   $0x78
80102b73:	68 c7 af 10 80       	push   $0x8010afc7
80102b78:	e8 79 1d 00 00       	call   801048f6 <kmm_cache_create>
80102b7d:	83 c4 10             	add    $0x10,%esp
80102b80:	a3 2c 6f 12 80       	mov    %eax,0x80126f2c
    slab_allocator[SLAB_NORMAL + 1] = kmm_cache_create("KMM_SLAB",sizeof(struct kmm_slab));
80102b85:	83 ec 08             	sub    $0x8,%esp
80102b88:	6a 1c                	push   $0x1c
80102b8a:	68 d1 af 10 80       	push   $0x8010afd1
80102b8f:	e8 62 1d 00 00       	call   801048f6 <kmm_cache_create>
80102b94:	83 c4 10             	add    $0x10,%esp
80102b97:	a3 30 6f 12 80       	mov    %eax,0x80126f30
    assert(slab_allocator[SLAB_NORMAL] && slab_allocator[SLAB_NORMAL + 1]);
80102b9c:	a1 2c 6f 12 80       	mov    0x80126f2c,%eax
80102ba1:	85 c0                	test   %eax,%eax
80102ba3:	74 09                	je     80102bae <init_slab_allocator+0x64>
80102ba5:	a1 30 6f 12 80       	mov    0x80126f30,%eax
80102baa:	85 c0                	test   %eax,%eax
80102bac:	75 19                	jne    80102bc7 <init_slab_allocator+0x7d>
80102bae:	68 dc af 10 80       	push   $0x8010afdc
80102bb3:	68 1b b0 10 80       	push   $0x8010b01b
80102bb8:	6a 4f                	push   $0x4f
80102bba:	68 b5 af 10 80       	push   $0x8010afb5
80102bbf:	e8 90 d7 ff ff       	call   80100354 <__panic>
80102bc4:	83 c4 10             	add    $0x10,%esp

    //init 'normal' slab
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
80102bc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102bce:	eb 31                	jmp    80102c01 <init_slab_allocator+0xb7>
    {
        slab_allocator[i] = kmm_cache_create(str[i],slab_size_map[i]);
80102bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd3:	8b 14 85 a0 40 12 80 	mov    -0x7fedbf60(,%eax,4),%edx
80102bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bdd:	8b 04 85 60 40 12 80 	mov    -0x7fedbfa0(,%eax,4),%eax
80102be4:	83 ec 08             	sub    $0x8,%esp
80102be7:	52                   	push   %edx
80102be8:	50                   	push   %eax
80102be9:	e8 08 1d 00 00       	call   801048f6 <kmm_cache_create>
80102bee:	83 c4 10             	add    $0x10,%esp
80102bf1:	89 c2                	mov    %eax,%edx
80102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf6:	89 14 85 00 6f 12 80 	mov    %edx,-0x7fed9100(,%eax,4)
    slab_allocator[SLAB_NORMAL + 1] = kmm_cache_create("KMM_SLAB",sizeof(struct kmm_slab));
    assert(slab_allocator[SLAB_NORMAL] && slab_allocator[SLAB_NORMAL + 1]);

    //init 'normal' slab
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
80102bfd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c01:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80102c05:	7e c9                	jle    80102bd0 <init_slab_allocator+0x86>
    {
        slab_allocator[i] = kmm_cache_create(str[i],slab_size_map[i]);
    }
    for(i = 0; i < 5 ; i ++)
80102c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c0e:	eb 60                	jmp    80102c70 <init_slab_allocator+0x126>
    {
        assert(kmm_slab_grow(slab_allocator[SLAB_NORMAL]));
80102c10:	a1 2c 6f 12 80       	mov    0x80126f2c,%eax
80102c15:	83 ec 0c             	sub    $0xc,%esp
80102c18:	50                   	push   %eax
80102c19:	e8 d8 1f 00 00       	call   80104bf6 <kmm_slab_grow>
80102c1e:	83 c4 10             	add    $0x10,%esp
80102c21:	85 c0                	test   %eax,%eax
80102c23:	75 19                	jne    80102c3e <init_slab_allocator+0xf4>
80102c25:	68 34 b0 10 80       	push   $0x8010b034
80102c2a:	68 1b b0 10 80       	push   $0x8010b01b
80102c2f:	6a 59                	push   $0x59
80102c31:	68 b5 af 10 80       	push   $0x8010afb5
80102c36:	e8 19 d7 ff ff       	call   80100354 <__panic>
80102c3b:	83 c4 10             	add    $0x10,%esp
        assert(kmm_slab_grow(slab_allocator[SLAB_NORMAL + 1]));
80102c3e:	a1 30 6f 12 80       	mov    0x80126f30,%eax
80102c43:	83 ec 0c             	sub    $0xc,%esp
80102c46:	50                   	push   %eax
80102c47:	e8 aa 1f 00 00       	call   80104bf6 <kmm_slab_grow>
80102c4c:	83 c4 10             	add    $0x10,%esp
80102c4f:	85 c0                	test   %eax,%eax
80102c51:	75 19                	jne    80102c6c <init_slab_allocator+0x122>
80102c53:	68 60 b0 10 80       	push   $0x8010b060
80102c58:	68 1b b0 10 80       	push   $0x8010b01b
80102c5d:	6a 5a                	push   $0x5a
80102c5f:	68 b5 af 10 80       	push   $0x8010afb5
80102c64:	e8 eb d6 ff ff       	call   80100354 <__panic>
80102c69:	83 c4 10             	add    $0x10,%esp
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
    {
        slab_allocator[i] = kmm_cache_create(str[i],slab_size_map[i]);
    }
    for(i = 0; i < 5 ; i ++)
80102c6c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c70:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80102c74:	7e 9a                	jle    80102c10 <init_slab_allocator+0xc6>
    {
        assert(kmm_slab_grow(slab_allocator[SLAB_NORMAL]));
        assert(kmm_slab_grow(slab_allocator[SLAB_NORMAL + 1]));
    }
    slab_allocator_activated = true; 
80102c76:	c7 05 e0 6e 12 80 01 	movl   $0x1,0x80126ee0
80102c7d:	00 00 00 
}
80102c80:	90                   	nop
80102c81:	c9                   	leave  
80102c82:	c3                   	ret    

80102c83 <deinit_slab_allocator>:
//just for test case 2
static void 
deinit_slab_allocator()
{
80102c83:	55                   	push   %ebp
80102c84:	89 e5                	mov    %esp,%ebp
80102c86:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
80102c89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for(i = 0 ; i <= 12 ; i ++)
80102c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c97:	eb 1a                	jmp    80102cb3 <deinit_slab_allocator+0x30>
    {
        kmm_cache_destroy(slab_allocator[i]);
80102c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c9c:	8b 04 85 00 6f 12 80 	mov    -0x7fed9100(,%eax,4),%eax
80102ca3:	83 ec 0c             	sub    $0xc,%esp
80102ca6:	50                   	push   %eax
80102ca7:	e8 3f 1d 00 00       	call   801049eb <kmm_cache_destroy>
80102cac:	83 c4 10             	add    $0x10,%esp
//just for test case 2
static void 
deinit_slab_allocator()
{
    int i = 0;
    for(i = 0 ; i <= 12 ; i ++)
80102caf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102cb3:	83 7d f4 0c          	cmpl   $0xc,-0xc(%ebp)
80102cb7:	7e e0                	jle    80102c99 <deinit_slab_allocator+0x16>
    {
        kmm_cache_destroy(slab_allocator[i]);
    }
    slab_allocator_activated = false; 
80102cb9:	c7 05 e0 6e 12 80 00 	movl   $0x0,0x80126ee0
80102cc0:	00 00 00 
    assert(nr_free_pages() == init_before_page);
80102cc3:	e8 62 dd ff ff       	call   80100a2a <nr_free_pages>
80102cc8:	89 c2                	mov    %eax,%edx
80102cca:	a1 50 6f 12 80       	mov    0x80126f50,%eax
80102ccf:	39 c2                	cmp    %eax,%edx
80102cd1:	74 19                	je     80102cec <deinit_slab_allocator+0x69>
80102cd3:	68 90 b0 10 80       	push   $0x8010b090
80102cd8:	68 1b b0 10 80       	push   $0x8010b01b
80102cdd:	6a 68                	push   $0x68
80102cdf:	68 b5 af 10 80       	push   $0x8010afb5
80102ce4:	e8 6b d6 ff ff       	call   80100354 <__panic>
80102ce9:	83 c4 10             	add    $0x10,%esp
}
80102cec:	90                   	nop
80102ced:	c9                   	leave  
80102cee:	c3                   	ret    

80102cef <kfree>:

void
kfree(void *n)
{
80102cef:	55                   	push   %ebp
80102cf0:	89 e5                	mov    %esp,%ebp
80102cf2:	83 ec 08             	sub    $0x8,%esp
    if(((uintptr_t)n&(PGSIZE-1)) && slab_allocator_activated)
80102cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf8:	25 ff 0f 00 00       	and    $0xfff,%eax
80102cfd:	85 c0                	test   %eax,%eax
80102cff:	74 1d                	je     80102d1e <kfree+0x2f>
80102d01:	a1 e0 6e 12 80       	mov    0x80126ee0,%eax
80102d06:	85 c0                	test   %eax,%eax
80102d08:	74 14                	je     80102d1e <kfree+0x2f>
    {
        kmm_free((bufctl_t)n - 1); 
80102d0a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d0d:	83 e8 0c             	sub    $0xc,%eax
80102d10:	83 ec 0c             	sub    $0xc,%esp
80102d13:	50                   	push   %eax
80102d14:	e8 09 27 00 00       	call   80105422 <kmm_free>
80102d19:	83 c4 10             	add    $0x10,%esp
80102d1c:	eb 0e                	jmp    80102d2c <kfree+0x3d>
    }else{
        free_pages(n);
80102d1e:	83 ec 0c             	sub    $0xc,%esp
80102d21:	ff 75 08             	pushl  0x8(%ebp)
80102d24:	e8 a1 da ff ff       	call   801007ca <free_pages>
80102d29:	83 c4 10             	add    $0x10,%esp
    }
}
80102d2c:	90                   	nop
80102d2d:	c9                   	leave  
80102d2e:	c3                   	ret    

80102d2f <kmalloc>:

void* 
kmalloc(int32_t n)
{
80102d2f:	55                   	push   %ebp
80102d30:	89 e5                	mov    %esp,%ebp
80102d32:	83 ec 18             	sub    $0x18,%esp
    void *ret = NULL;
80102d35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(n <= 0) return NULL;
80102d3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102d40:	7f 0a                	jg     80102d4c <kmalloc+0x1d>
80102d42:	b8 00 00 00 00       	mov    $0x0,%eax
80102d47:	e9 c7 00 00 00       	jmp    80102e13 <kmalloc+0xe4>

    if(slab_allocator_activated == false || n > slab_size_map[SLAB_NORMAL - 1])
80102d4c:	a1 e0 6e 12 80       	mov    0x80126ee0,%eax
80102d51:	85 c0                	test   %eax,%eax
80102d53:	74 0d                	je     80102d62 <kmalloc+0x33>
80102d55:	8b 15 c8 40 12 80    	mov    0x801240c8,%edx
80102d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80102d5e:	39 c2                	cmp    %eax,%edx
80102d60:	73 27                	jae    80102d89 <kmalloc+0x5a>
    {
        return alloc_pages( (PGSIZE + n - 1) / PGSIZE );
80102d62:	8b 45 08             	mov    0x8(%ebp),%eax
80102d65:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d6a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102d70:	85 c0                	test   %eax,%eax
80102d72:	0f 48 c2             	cmovs  %edx,%eax
80102d75:	c1 f8 0c             	sar    $0xc,%eax
80102d78:	83 ec 0c             	sub    $0xc,%esp
80102d7b:	50                   	push   %eax
80102d7c:	e8 10 da ff ff       	call   80100791 <alloc_pages>
80102d81:	83 c4 10             	add    $0x10,%esp
80102d84:	e9 8a 00 00 00       	jmp    80102e13 <kmalloc+0xe4>
    }else{
        if(n == sizeof(struct kmm_cache))
80102d89:	83 7d 08 78          	cmpl   $0x78,0x8(%ebp)
80102d8d:	75 1c                	jne    80102dab <kmalloc+0x7c>
        {
            ret = kmm_alloc(slab_allocator[SLAB_NORMAL]);  
80102d8f:	a1 2c 6f 12 80       	mov    0x80126f2c,%eax
80102d94:	83 ec 0c             	sub    $0xc,%esp
80102d97:	50                   	push   %eax
80102d98:	e8 52 22 00 00       	call   80104fef <kmm_alloc>
80102d9d:	83 c4 10             	add    $0x10,%esp
80102da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if(!ret) goto alloc_page; 
80102da3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102da7:	75 4f                	jne    80102df8 <kmalloc+0xc9>
80102da9:	eb 52                	jmp    80102dfd <kmalloc+0xce>
        }else if(n == sizeof(struct kmm_slab))
80102dab:	83 7d 08 1c          	cmpl   $0x1c,0x8(%ebp)
80102daf:	75 1c                	jne    80102dcd <kmalloc+0x9e>
        {
            ret = kmm_alloc(slab_allocator[SLAB_NORMAL + 1]);  
80102db1:	a1 30 6f 12 80       	mov    0x80126f30,%eax
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	50                   	push   %eax
80102dba:	e8 30 22 00 00       	call   80104fef <kmm_alloc>
80102dbf:	83 c4 10             	add    $0x10,%esp
80102dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if(!ret) goto alloc_page; 
80102dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102dc9:	75 2d                	jne    80102df8 <kmalloc+0xc9>
80102dcb:	eb 30                	jmp    80102dfd <kmalloc+0xce>
        }else{
            ret = kmm_alloc(slab_allocator[select_slab(n)]);
80102dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	50                   	push   %eax
80102dd4:	e8 fe fc ff ff       	call   80102ad7 <select_slab>
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	8b 04 85 00 6f 12 80 	mov    -0x7fed9100(,%eax,4),%eax
80102de3:	83 ec 0c             	sub    $0xc,%esp
80102de6:	50                   	push   %eax
80102de7:	e8 03 22 00 00       	call   80104fef <kmm_alloc>
80102dec:	83 c4 10             	add    $0x10,%esp
80102def:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if(!ret) goto ret_null; 
80102df2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102df6:	74 17                	je     80102e0f <kmalloc+0xe0>
        }
    }
    return ret;
80102df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dfb:	eb 16                	jmp    80102e13 <kmalloc+0xe4>
alloc_page:
    ret = alloc_pages(1);
80102dfd:	83 ec 0c             	sub    $0xc,%esp
80102e00:	6a 01                	push   $0x1
80102e02:	e8 8a d9 ff ff       	call   80100791 <alloc_pages>
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e0d:	eb 01                	jmp    80102e10 <kmalloc+0xe1>
        {
            ret = kmm_alloc(slab_allocator[SLAB_NORMAL + 1]);  
            if(!ret) goto alloc_page; 
        }else{
            ret = kmm_alloc(slab_allocator[select_slab(n)]);
            if(!ret) goto ret_null; 
80102e0f:	90                   	nop
    }
    return ret;
alloc_page:
    ret = alloc_pages(1);
ret_null:
    return ret; 
80102e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e13:	c9                   	leave  
80102e14:	c3                   	ret    

80102e15 <slab_allocator_test>:

//try X macro :-)

void
slab_allocator_test(size_t n)
{
80102e15:	55                   	push   %ebp
80102e16:	89 e5                	mov    %esp,%ebp
80102e18:	81 ec f8 01 00 00    	sub    $0x1f8,%esp
//    LOG_DEBUG("slab test start !\nbuf_size : %d \n", sizeof(struct bufctl));    
    //Case 1: only one data
    int *a = NULL, *tmp = NULL;
80102e1e:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
80102e25:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
    a = tmp = kmalloc(sizeof(int)); 
80102e2c:	83 ec 0c             	sub    $0xc,%esp
80102e2f:	6a 04                	push   $0x4
80102e31:	e8 f9 fe ff ff       	call   80102d2f <kmalloc>
80102e36:	83 c4 10             	add    $0x10,%esp
80102e39:	89 45 a0             	mov    %eax,-0x60(%ebp)
80102e3c:	8b 45 a0             	mov    -0x60(%ebp),%eax
80102e3f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    kfree(a);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	ff 75 a4             	pushl  -0x5c(%ebp)
80102e48:	e8 a2 fe ff ff       	call   80102cef <kfree>
80102e4d:	83 c4 10             	add    $0x10,%esp
    a = kmalloc(sizeof(int));     
80102e50:	83 ec 0c             	sub    $0xc,%esp
80102e53:	6a 04                	push   $0x4
80102e55:	e8 d5 fe ff ff       	call   80102d2f <kmalloc>
80102e5a:	83 c4 10             	add    $0x10,%esp
80102e5d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    kfree(a);
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	ff 75 a4             	pushl  -0x5c(%ebp)
80102e66:	e8 84 fe ff ff       	call   80102cef <kfree>
80102e6b:	83 c4 10             	add    $0x10,%esp
    a = kmalloc(sizeof(int));
80102e6e:	83 ec 0c             	sub    $0xc,%esp
80102e71:	6a 04                	push   $0x4
80102e73:	e8 b7 fe ff ff       	call   80102d2f <kmalloc>
80102e78:	83 c4 10             	add    $0x10,%esp
80102e7b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    assert(a == tmp);
80102e7e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80102e81:	3b 45 a0             	cmp    -0x60(%ebp),%eax
80102e84:	74 1c                	je     80102ea2 <slab_allocator_test+0x8d>
80102e86:	68 b4 b0 10 80       	push   $0x8010b0b4
80102e8b:	68 1b b0 10 80       	push   $0x8010b01b
80102e90:	68 a3 00 00 00       	push   $0xa3
80102e95:	68 b5 af 10 80       	push   $0x8010afb5
80102e9a:	e8 b5 d4 ff ff       	call   80100354 <__panic>
80102e9f:	83 c4 10             	add    $0x10,%esp
    kfree(tmp);
80102ea2:	83 ec 0c             	sub    $0xc,%esp
80102ea5:	ff 75 a0             	pushl  -0x60(%ebp)
80102ea8:	e8 42 fe ff ff       	call   80102cef <kfree>
80102ead:	83 c4 10             	add    $0x10,%esp
        FOR_EACH_INT(a,b)       \
        {                       \
            kfree(ptr[I(a)]);   \
        }               \
    }while(0);
    TEST_LIST
80102eb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102eb7:	eb 1d                	jmp    80102ed6 <slab_allocator_test+0xc1>
80102eb9:	83 ec 0c             	sub    $0xc,%esp
80102ebc:	6a 08                	push   $0x8
80102ebe:	e8 6c fe ff ff       	call   80102d2f <kmalloc>
80102ec3:	83 c4 10             	add    $0x10,%esp
80102ec6:	89 c2                	mov    %eax,%edx
80102ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ecb:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80102ed2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ed6:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
80102eda:	7e dd                	jle    80102eb9 <slab_allocator_test+0xa4>
80102edc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ee3:	eb 1a                	jmp    80102eff <slab_allocator_test+0xea>
80102ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ee8:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80102eef:	83 ec 0c             	sub    $0xc,%esp
80102ef2:	50                   	push   %eax
80102ef3:	e8 f7 fd ff ff       	call   80102cef <kfree>
80102ef8:	83 c4 10             	add    $0x10,%esp
80102efb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102eff:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
80102f03:	7e e0                	jle    80102ee5 <slab_allocator_test+0xd0>
80102f05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80102f0c:	eb 1d                	jmp    80102f2b <slab_allocator_test+0x116>
80102f0e:	83 ec 0c             	sub    $0xc,%esp
80102f11:	6a 10                	push   $0x10
80102f13:	e8 17 fe ff ff       	call   80102d2f <kmalloc>
80102f18:	83 c4 10             	add    $0x10,%esp
80102f1b:	89 c2                	mov    %eax,%edx
80102f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f20:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80102f27:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80102f2b:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
80102f2f:	7e dd                	jle    80102f0e <slab_allocator_test+0xf9>
80102f31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80102f38:	eb 1a                	jmp    80102f54 <slab_allocator_test+0x13f>
80102f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f3d:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	50                   	push   %eax
80102f48:	e8 a2 fd ff ff       	call   80102cef <kfree>
80102f4d:	83 c4 10             	add    $0x10,%esp
80102f50:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80102f54:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
80102f58:	7e e0                	jle    80102f3a <slab_allocator_test+0x125>
80102f5a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80102f61:	eb 1d                	jmp    80102f80 <slab_allocator_test+0x16b>
80102f63:	83 ec 0c             	sub    $0xc,%esp
80102f66:	6a 20                	push   $0x20
80102f68:	e8 c2 fd ff ff       	call   80102d2f <kmalloc>
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	89 c2                	mov    %eax,%edx
80102f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f75:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80102f7c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80102f80:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
80102f84:	7e dd                	jle    80102f63 <slab_allocator_test+0x14e>
80102f86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80102f8d:	eb 1a                	jmp    80102fa9 <slab_allocator_test+0x194>
80102f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f92:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80102f99:	83 ec 0c             	sub    $0xc,%esp
80102f9c:	50                   	push   %eax
80102f9d:	e8 4d fd ff ff       	call   80102cef <kfree>
80102fa2:	83 c4 10             	add    $0x10,%esp
80102fa5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80102fa9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
80102fad:	7e e0                	jle    80102f8f <slab_allocator_test+0x17a>
80102faf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80102fb6:	eb 1d                	jmp    80102fd5 <slab_allocator_test+0x1c0>
80102fb8:	83 ec 0c             	sub    $0xc,%esp
80102fbb:	6a 40                	push   $0x40
80102fbd:	e8 6d fd ff ff       	call   80102d2f <kmalloc>
80102fc2:	83 c4 10             	add    $0x10,%esp
80102fc5:	89 c2                	mov    %eax,%edx
80102fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102fca:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80102fd1:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80102fd5:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80102fd9:	7e dd                	jle    80102fb8 <slab_allocator_test+0x1a3>
80102fdb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80102fe2:	eb 1a                	jmp    80102ffe <slab_allocator_test+0x1e9>
80102fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102fe7:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	50                   	push   %eax
80102ff2:	e8 f8 fc ff ff       	call   80102cef <kfree>
80102ff7:	83 c4 10             	add    $0x10,%esp
80102ffa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80102ffe:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80103002:	7e e0                	jle    80102fe4 <slab_allocator_test+0x1cf>
80103004:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010300b:	eb 20                	jmp    8010302d <slab_allocator_test+0x218>
8010300d:	83 ec 0c             	sub    $0xc,%esp
80103010:	68 80 00 00 00       	push   $0x80
80103015:	e8 15 fd ff ff       	call   80102d2f <kmalloc>
8010301a:	83 c4 10             	add    $0x10,%esp
8010301d:	89 c2                	mov    %eax,%edx
8010301f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103022:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103029:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010302d:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80103031:	7e da                	jle    8010300d <slab_allocator_test+0x1f8>
80103033:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010303a:	eb 1a                	jmp    80103056 <slab_allocator_test+0x241>
8010303c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010303f:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80103046:	83 ec 0c             	sub    $0xc,%esp
80103049:	50                   	push   %eax
8010304a:	e8 a0 fc ff ff       	call   80102cef <kfree>
8010304f:	83 c4 10             	add    $0x10,%esp
80103052:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103056:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
8010305a:	7e e0                	jle    8010303c <slab_allocator_test+0x227>
8010305c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80103063:	eb 20                	jmp    80103085 <slab_allocator_test+0x270>
80103065:	83 ec 0c             	sub    $0xc,%esp
80103068:	68 c0 00 00 00       	push   $0xc0
8010306d:	e8 bd fc ff ff       	call   80102d2f <kmalloc>
80103072:	83 c4 10             	add    $0x10,%esp
80103075:	89 c2                	mov    %eax,%edx
80103077:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010307a:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103081:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80103085:	83 7d e0 31          	cmpl   $0x31,-0x20(%ebp)
80103089:	7e da                	jle    80103065 <slab_allocator_test+0x250>
8010308b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80103092:	eb 1a                	jmp    801030ae <slab_allocator_test+0x299>
80103094:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103097:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
8010309e:	83 ec 0c             	sub    $0xc,%esp
801030a1:	50                   	push   %eax
801030a2:	e8 48 fc ff ff       	call   80102cef <kfree>
801030a7:	83 c4 10             	add    $0x10,%esp
801030aa:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
801030ae:	83 7d e0 31          	cmpl   $0x31,-0x20(%ebp)
801030b2:	7e e0                	jle    80103094 <slab_allocator_test+0x27f>
801030b4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801030bb:	eb 20                	jmp    801030dd <slab_allocator_test+0x2c8>
801030bd:	83 ec 0c             	sub    $0xc,%esp
801030c0:	68 00 01 00 00       	push   $0x100
801030c5:	e8 65 fc ff ff       	call   80102d2f <kmalloc>
801030ca:	83 c4 10             	add    $0x10,%esp
801030cd:	89 c2                	mov    %eax,%edx
801030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801030d2:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
801030d9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801030dd:	83 7d dc 3d          	cmpl   $0x3d,-0x24(%ebp)
801030e1:	7e da                	jle    801030bd <slab_allocator_test+0x2a8>
801030e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801030ea:	eb 1a                	jmp    80103106 <slab_allocator_test+0x2f1>
801030ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801030ef:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
801030f6:	83 ec 0c             	sub    $0xc,%esp
801030f9:	50                   	push   %eax
801030fa:	e8 f0 fb ff ff       	call   80102cef <kfree>
801030ff:	83 c4 10             	add    $0x10,%esp
80103102:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80103106:	83 7d dc 3d          	cmpl   $0x3d,-0x24(%ebp)
8010310a:	7e e0                	jle    801030ec <slab_allocator_test+0x2d7>
8010310c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80103113:	eb 20                	jmp    80103135 <slab_allocator_test+0x320>
80103115:	83 ec 0c             	sub    $0xc,%esp
80103118:	68 00 02 00 00       	push   $0x200
8010311d:	e8 0d fc ff ff       	call   80102d2f <kmalloc>
80103122:	83 c4 10             	add    $0x10,%esp
80103125:	89 c2                	mov    %eax,%edx
80103127:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010312a:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103131:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
80103135:	83 7d d8 0b          	cmpl   $0xb,-0x28(%ebp)
80103139:	7e da                	jle    80103115 <slab_allocator_test+0x300>
8010313b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80103142:	eb 1a                	jmp    8010315e <slab_allocator_test+0x349>
80103144:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103147:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
8010314e:	83 ec 0c             	sub    $0xc,%esp
80103151:	50                   	push   %eax
80103152:	e8 98 fb ff ff       	call   80102cef <kfree>
80103157:	83 c4 10             	add    $0x10,%esp
8010315a:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
8010315e:	83 7d d8 0b          	cmpl   $0xb,-0x28(%ebp)
80103162:	7e e0                	jle    80103144 <slab_allocator_test+0x32f>
80103164:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010316b:	eb 20                	jmp    8010318d <slab_allocator_test+0x378>
8010316d:	83 ec 0c             	sub    $0xc,%esp
80103170:	68 00 04 00 00       	push   $0x400
80103175:	e8 b5 fb ff ff       	call   80102d2f <kmalloc>
8010317a:	83 c4 10             	add    $0x10,%esp
8010317d:	89 c2                	mov    %eax,%edx
8010317f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103182:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103189:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
8010318d:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
80103191:	7e da                	jle    8010316d <slab_allocator_test+0x358>
80103193:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010319a:	eb 1a                	jmp    801031b6 <slab_allocator_test+0x3a1>
8010319c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010319f:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
801031a6:	83 ec 0c             	sub    $0xc,%esp
801031a9:	50                   	push   %eax
801031aa:	e8 40 fb ff ff       	call   80102cef <kfree>
801031af:	83 c4 10             	add    $0x10,%esp
801031b2:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801031b6:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
801031ba:	7e e0                	jle    8010319c <slab_allocator_test+0x387>
801031bc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801031c3:	eb 20                	jmp    801031e5 <slab_allocator_test+0x3d0>
801031c5:	83 ec 0c             	sub    $0xc,%esp
801031c8:	68 00 08 00 00       	push   $0x800
801031cd:	e8 5d fb ff ff       	call   80102d2f <kmalloc>
801031d2:	83 c4 10             	add    $0x10,%esp
801031d5:	89 c2                	mov    %eax,%edx
801031d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
801031da:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
801031e1:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
801031e5:	83 7d d0 06          	cmpl   $0x6,-0x30(%ebp)
801031e9:	7e da                	jle    801031c5 <slab_allocator_test+0x3b0>
801031eb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801031f2:	eb 1a                	jmp    8010320e <slab_allocator_test+0x3f9>
801031f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
801031f7:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
801031fe:	83 ec 0c             	sub    $0xc,%esp
80103201:	50                   	push   %eax
80103202:	e8 e8 fa ff ff       	call   80102cef <kfree>
80103207:	83 c4 10             	add    $0x10,%esp
8010320a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
8010320e:	83 7d d0 06          	cmpl   $0x6,-0x30(%ebp)
80103212:	7e e0                	jle    801031f4 <slab_allocator_test+0x3df>
    TEST_LIST
80103214:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
8010321b:	eb 1d                	jmp    8010323a <slab_allocator_test+0x425>
8010321d:	83 ec 0c             	sub    $0xc,%esp
80103220:	6a 08                	push   $0x8
80103222:	e8 08 fb ff ff       	call   80102d2f <kmalloc>
80103227:	83 c4 10             	add    $0x10,%esp
8010322a:	89 c2                	mov    %eax,%edx
8010322c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010322f:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103236:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
8010323a:	83 7d cc 27          	cmpl   $0x27,-0x34(%ebp)
8010323e:	7e dd                	jle    8010321d <slab_allocator_test+0x408>
80103240:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
80103247:	eb 1a                	jmp    80103263 <slab_allocator_test+0x44e>
80103249:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010324c:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80103253:	83 ec 0c             	sub    $0xc,%esp
80103256:	50                   	push   %eax
80103257:	e8 93 fa ff ff       	call   80102cef <kfree>
8010325c:	83 c4 10             	add    $0x10,%esp
8010325f:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80103263:	83 7d cc 27          	cmpl   $0x27,-0x34(%ebp)
80103267:	7e e0                	jle    80103249 <slab_allocator_test+0x434>
80103269:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
80103270:	eb 1d                	jmp    8010328f <slab_allocator_test+0x47a>
80103272:	83 ec 0c             	sub    $0xc,%esp
80103275:	6a 10                	push   $0x10
80103277:	e8 b3 fa ff ff       	call   80102d2f <kmalloc>
8010327c:	83 c4 10             	add    $0x10,%esp
8010327f:	89 c2                	mov    %eax,%edx
80103281:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103284:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
8010328b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
8010328f:	83 7d c8 13          	cmpl   $0x13,-0x38(%ebp)
80103293:	7e dd                	jle    80103272 <slab_allocator_test+0x45d>
80103295:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
8010329c:	eb 1a                	jmp    801032b8 <slab_allocator_test+0x4a3>
8010329e:	8b 45 c8             	mov    -0x38(%ebp),%eax
801032a1:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
801032a8:	83 ec 0c             	sub    $0xc,%esp
801032ab:	50                   	push   %eax
801032ac:	e8 3e fa ff ff       	call   80102cef <kfree>
801032b1:	83 c4 10             	add    $0x10,%esp
801032b4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
801032b8:	83 7d c8 13          	cmpl   $0x13,-0x38(%ebp)
801032bc:	7e e0                	jle    8010329e <slab_allocator_test+0x489>
801032be:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
801032c5:	eb 1d                	jmp    801032e4 <slab_allocator_test+0x4cf>
801032c7:	83 ec 0c             	sub    $0xc,%esp
801032ca:	6a 20                	push   $0x20
801032cc:	e8 5e fa ff ff       	call   80102d2f <kmalloc>
801032d1:	83 c4 10             	add    $0x10,%esp
801032d4:	89 c2                	mov    %eax,%edx
801032d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801032d9:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
801032e0:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
801032e4:	83 7d c4 0d          	cmpl   $0xd,-0x3c(%ebp)
801032e8:	7e dd                	jle    801032c7 <slab_allocator_test+0x4b2>
801032ea:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
801032f1:	eb 1a                	jmp    8010330d <slab_allocator_test+0x4f8>
801032f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801032f6:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
801032fd:	83 ec 0c             	sub    $0xc,%esp
80103300:	50                   	push   %eax
80103301:	e8 e9 f9 ff ff       	call   80102cef <kfree>
80103306:	83 c4 10             	add    $0x10,%esp
80103309:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
8010330d:	83 7d c4 0d          	cmpl   $0xd,-0x3c(%ebp)
80103311:	7e e0                	jle    801032f3 <slab_allocator_test+0x4de>
80103313:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
8010331a:	eb 1d                	jmp    80103339 <slab_allocator_test+0x524>
8010331c:	83 ec 0c             	sub    $0xc,%esp
8010331f:	6a 40                	push   $0x40
80103321:	e8 09 fa ff ff       	call   80102d2f <kmalloc>
80103326:	83 c4 10             	add    $0x10,%esp
80103329:	89 c2                	mov    %eax,%edx
8010332b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010332e:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103335:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
80103339:	83 7d c0 0b          	cmpl   $0xb,-0x40(%ebp)
8010333d:	7e dd                	jle    8010331c <slab_allocator_test+0x507>
8010333f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
80103346:	eb 1a                	jmp    80103362 <slab_allocator_test+0x54d>
80103348:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010334b:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80103352:	83 ec 0c             	sub    $0xc,%esp
80103355:	50                   	push   %eax
80103356:	e8 94 f9 ff ff       	call   80102cef <kfree>
8010335b:	83 c4 10             	add    $0x10,%esp
8010335e:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
80103362:	83 7d c0 0b          	cmpl   $0xb,-0x40(%ebp)
80103366:	7e e0                	jle    80103348 <slab_allocator_test+0x533>
80103368:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
8010336f:	eb 20                	jmp    80103391 <slab_allocator_test+0x57c>
80103371:	83 ec 0c             	sub    $0xc,%esp
80103374:	68 80 00 00 00       	push   $0x80
80103379:	e8 b1 f9 ff ff       	call   80102d2f <kmalloc>
8010337e:	83 c4 10             	add    $0x10,%esp
80103381:	89 c2                	mov    %eax,%edx
80103383:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103386:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
8010338d:	83 45 bc 01          	addl   $0x1,-0x44(%ebp)
80103391:	83 7d bc 1f          	cmpl   $0x1f,-0x44(%ebp)
80103395:	7e da                	jle    80103371 <slab_allocator_test+0x55c>
80103397:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
8010339e:	eb 1a                	jmp    801033ba <slab_allocator_test+0x5a5>
801033a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033a3:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
801033aa:	83 ec 0c             	sub    $0xc,%esp
801033ad:	50                   	push   %eax
801033ae:	e8 3c f9 ff ff       	call   80102cef <kfree>
801033b3:	83 c4 10             	add    $0x10,%esp
801033b6:	83 45 bc 01          	addl   $0x1,-0x44(%ebp)
801033ba:	83 7d bc 1f          	cmpl   $0x1f,-0x44(%ebp)
801033be:	7e e0                	jle    801033a0 <slab_allocator_test+0x58b>
801033c0:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
801033c7:	eb 20                	jmp    801033e9 <slab_allocator_test+0x5d4>
801033c9:	83 ec 0c             	sub    $0xc,%esp
801033cc:	68 c0 00 00 00       	push   $0xc0
801033d1:	e8 59 f9 ff ff       	call   80102d2f <kmalloc>
801033d6:	83 c4 10             	add    $0x10,%esp
801033d9:	89 c2                	mov    %eax,%edx
801033db:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033de:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
801033e5:	83 45 b8 01          	addl   $0x1,-0x48(%ebp)
801033e9:	83 7d b8 31          	cmpl   $0x31,-0x48(%ebp)
801033ed:	7e da                	jle    801033c9 <slab_allocator_test+0x5b4>
801033ef:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
801033f6:	eb 1a                	jmp    80103412 <slab_allocator_test+0x5fd>
801033f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033fb:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80103402:	83 ec 0c             	sub    $0xc,%esp
80103405:	50                   	push   %eax
80103406:	e8 e4 f8 ff ff       	call   80102cef <kfree>
8010340b:	83 c4 10             	add    $0x10,%esp
8010340e:	83 45 b8 01          	addl   $0x1,-0x48(%ebp)
80103412:	83 7d b8 31          	cmpl   $0x31,-0x48(%ebp)
80103416:	7e e0                	jle    801033f8 <slab_allocator_test+0x5e3>
80103418:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
8010341f:	eb 20                	jmp    80103441 <slab_allocator_test+0x62c>
80103421:	83 ec 0c             	sub    $0xc,%esp
80103424:	68 00 01 00 00       	push   $0x100
80103429:	e8 01 f9 ff ff       	call   80102d2f <kmalloc>
8010342e:	83 c4 10             	add    $0x10,%esp
80103431:	89 c2                	mov    %eax,%edx
80103433:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80103436:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
8010343d:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
80103441:	83 7d b4 3d          	cmpl   $0x3d,-0x4c(%ebp)
80103445:	7e da                	jle    80103421 <slab_allocator_test+0x60c>
80103447:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
8010344e:	eb 1a                	jmp    8010346a <slab_allocator_test+0x655>
80103450:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80103453:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
8010345a:	83 ec 0c             	sub    $0xc,%esp
8010345d:	50                   	push   %eax
8010345e:	e8 8c f8 ff ff       	call   80102cef <kfree>
80103463:	83 c4 10             	add    $0x10,%esp
80103466:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
8010346a:	83 7d b4 3d          	cmpl   $0x3d,-0x4c(%ebp)
8010346e:	7e e0                	jle    80103450 <slab_allocator_test+0x63b>
80103470:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
80103477:	eb 20                	jmp    80103499 <slab_allocator_test+0x684>
80103479:	83 ec 0c             	sub    $0xc,%esp
8010347c:	68 00 02 00 00       	push   $0x200
80103481:	e8 a9 f8 ff ff       	call   80102d2f <kmalloc>
80103486:	83 c4 10             	add    $0x10,%esp
80103489:	89 c2                	mov    %eax,%edx
8010348b:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010348e:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103495:	83 45 b0 01          	addl   $0x1,-0x50(%ebp)
80103499:	83 7d b0 0b          	cmpl   $0xb,-0x50(%ebp)
8010349d:	7e da                	jle    80103479 <slab_allocator_test+0x664>
8010349f:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
801034a6:	eb 1a                	jmp    801034c2 <slab_allocator_test+0x6ad>
801034a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
801034ab:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
801034b2:	83 ec 0c             	sub    $0xc,%esp
801034b5:	50                   	push   %eax
801034b6:	e8 34 f8 ff ff       	call   80102cef <kfree>
801034bb:	83 c4 10             	add    $0x10,%esp
801034be:	83 45 b0 01          	addl   $0x1,-0x50(%ebp)
801034c2:	83 7d b0 0b          	cmpl   $0xb,-0x50(%ebp)
801034c6:	7e e0                	jle    801034a8 <slab_allocator_test+0x693>
801034c8:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
801034cf:	eb 20                	jmp    801034f1 <slab_allocator_test+0x6dc>
801034d1:	83 ec 0c             	sub    $0xc,%esp
801034d4:	68 00 04 00 00       	push   $0x400
801034d9:	e8 51 f8 ff ff       	call   80102d2f <kmalloc>
801034de:	83 c4 10             	add    $0x10,%esp
801034e1:	89 c2                	mov    %eax,%edx
801034e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
801034e6:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
801034ed:	83 45 ac 01          	addl   $0x1,-0x54(%ebp)
801034f1:	83 7d ac 09          	cmpl   $0x9,-0x54(%ebp)
801034f5:	7e da                	jle    801034d1 <slab_allocator_test+0x6bc>
801034f7:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
801034fe:	eb 1a                	jmp    8010351a <slab_allocator_test+0x705>
80103500:	8b 45 ac             	mov    -0x54(%ebp),%eax
80103503:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
8010350a:	83 ec 0c             	sub    $0xc,%esp
8010350d:	50                   	push   %eax
8010350e:	e8 dc f7 ff ff       	call   80102cef <kfree>
80103513:	83 c4 10             	add    $0x10,%esp
80103516:	83 45 ac 01          	addl   $0x1,-0x54(%ebp)
8010351a:	83 7d ac 09          	cmpl   $0x9,-0x54(%ebp)
8010351e:	7e e0                	jle    80103500 <slab_allocator_test+0x6eb>
80103520:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
80103527:	eb 20                	jmp    80103549 <slab_allocator_test+0x734>
80103529:	83 ec 0c             	sub    $0xc,%esp
8010352c:	68 00 08 00 00       	push   $0x800
80103531:	e8 f9 f7 ff ff       	call   80102d2f <kmalloc>
80103536:	83 c4 10             	add    $0x10,%esp
80103539:	89 c2                	mov    %eax,%edx
8010353b:	8b 45 a8             	mov    -0x58(%ebp),%eax
8010353e:	89 94 85 10 fe ff ff 	mov    %edx,-0x1f0(%ebp,%eax,4)
80103545:	83 45 a8 01          	addl   $0x1,-0x58(%ebp)
80103549:	83 7d a8 06          	cmpl   $0x6,-0x58(%ebp)
8010354d:	7e da                	jle    80103529 <slab_allocator_test+0x714>
8010354f:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
80103556:	eb 1a                	jmp    80103572 <slab_allocator_test+0x75d>
80103558:	8b 45 a8             	mov    -0x58(%ebp),%eax
8010355b:	8b 84 85 10 fe ff ff 	mov    -0x1f0(%ebp,%eax,4),%eax
80103562:	83 ec 0c             	sub    $0xc,%esp
80103565:	50                   	push   %eax
80103566:	e8 84 f7 ff ff       	call   80102cef <kfree>
8010356b:	83 c4 10             	add    $0x10,%esp
8010356e:	83 45 a8 01          	addl   $0x1,-0x58(%ebp)
80103572:	83 7d a8 06          	cmpl   $0x6,-0x58(%ebp)
80103576:	7e e0                	jle    80103558 <slab_allocator_test+0x743>
#undef ENTRY
#undef FOR_EACH_INT
#undef I
    deinit_slab_allocator();
80103578:	e8 06 f7 ff ff       	call   80102c83 <deinit_slab_allocator>
    init_slab_allocator();
8010357d:	e8 c8 f5 ff ff       	call   80102b4a <init_slab_allocator>
    if(n != 0)
80103582:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103586:	74 22                	je     801035aa <slab_allocator_test+0x795>
    {
        slab_allocator_test(--n);
80103588:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
8010358c:	83 ec 0c             	sub    $0xc,%esp
8010358f:	ff 75 08             	pushl  0x8(%ebp)
80103592:	e8 7e f8 ff ff       	call   80102e15 <slab_allocator_test>
80103597:	83 c4 10             	add    $0x10,%esp
        LOG_DEBUG(INITOK"slab test ok !\n");
8010359a:	83 ec 0c             	sub    $0xc,%esp
8010359d:	68 bd b0 10 80       	push   $0x8010b0bd
801035a2:	e8 30 37 00 00       	call   80106cd7 <cprintf>
801035a7:	83 c4 10             	add    $0x10,%esp
    }
}
801035aa:	90                   	nop
801035ab:	c9                   	leave  
801035ac:	c3                   	ret    

801035ad <fastlog2>:


//return log2(x)
static uint8_t
fastlog2(int x)
{
801035ad:	55                   	push   %ebp
801035ae:	89 e5                	mov    %esp,%ebp
801035b0:	83 ec 10             	sub    $0x10,%esp
    float fx;
    unsigned long ix, exp;

    fx = (float)x;
801035b3:	db 45 08             	fildl  0x8(%ebp)
801035b6:	d9 5d f4             	fstps  -0xc(%ebp)
    ix = *(unsigned long*)&fx;
801035b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801035bc:	8b 00                	mov    (%eax),%eax
801035be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    exp = (ix >> 23) & 0xff;
801035c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801035c4:	c1 e8 17             	shr    $0x17,%eax
801035c7:	25 ff 00 00 00       	and    $0xff,%eax
801035cc:	89 45 f8             	mov    %eax,-0x8(%ebp)

    return exp - 127;
801035cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801035d2:	83 e8 7f             	sub    $0x7f,%eax
}
801035d5:	c9                   	leave  
801035d6:	c3                   	ret    

801035d7 <fix_size>:


// return the power of 2 of size 
static uint32_t
fix_size(uint32_t size)
{
801035d7:	55                   	push   %ebp
801035d8:	89 e5                	mov    %esp,%ebp
    size |= size >> 1;
801035da:	8b 45 08             	mov    0x8(%ebp),%eax
801035dd:	d1 e8                	shr    %eax
801035df:	09 45 08             	or     %eax,0x8(%ebp)
    size |= size >> 2;
801035e2:	8b 45 08             	mov    0x8(%ebp),%eax
801035e5:	c1 e8 02             	shr    $0x2,%eax
801035e8:	09 45 08             	or     %eax,0x8(%ebp)
    size |= size >> 4;
801035eb:	8b 45 08             	mov    0x8(%ebp),%eax
801035ee:	c1 e8 04             	shr    $0x4,%eax
801035f1:	09 45 08             	or     %eax,0x8(%ebp)
    size |= size >> 8;
801035f4:	8b 45 08             	mov    0x8(%ebp),%eax
801035f7:	c1 e8 08             	shr    $0x8,%eax
801035fa:	09 45 08             	or     %eax,0x8(%ebp)
    size |= size >> 16;
801035fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103600:	c1 e8 10             	shr    $0x10,%eax
80103603:	09 45 08             	or     %eax,0x8(%ebp)
    return size + 1;
80103606:	8b 45 08             	mov    0x8(%ebp),%eax
80103609:	83 c0 01             	add    $0x1,%eax
}
8010360c:	5d                   	pop    %ebp
8010360d:	c3                   	ret    

8010360e <calc>:


//init the buddy  and calc the real start addr
static void 
calc(uintptr_t p_start, uint32_t pg_size)
{
8010360e:	55                   	push   %ebp
8010360f:	89 e5                	mov    %esp,%ebp
80103611:	53                   	push   %ebx
80103612:	83 ec 14             	sub    $0x14,%esp
     uint32_t tmp; 
     //calc new beginning
     tmp  = ROUNDUP((fix_size(pg_size) * 2 - 1) * sizeof(struct page) + BUDDY_SIZE_EXCEPT_VAL + p_start  , PGSIZE); 
80103615:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
8010361c:	ff 75 0c             	pushl  0xc(%ebp)
8010361f:	e8 b3 ff ff ff       	call   801035d7 <fix_size>
80103624:	83 c4 04             	add    $0x4,%esp
80103627:	89 c2                	mov    %eax,%edx
80103629:	89 d0                	mov    %edx,%eax
8010362b:	c1 e0 03             	shl    $0x3,%eax
8010362e:	01 d0                	add    %edx,%eax
80103630:	c1 e0 02             	shl    $0x2,%eax
80103633:	89 c2                	mov    %eax,%edx
80103635:	8b 45 08             	mov    0x8(%ebp),%eax
80103638:	01 c2                	add    %eax,%edx
8010363a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010363d:	01 d0                	add    %edx,%eax
8010363f:	83 c0 09             	add    $0x9,%eax
80103642:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103648:	ba 00 00 00 00       	mov    $0x0,%edx
8010364d:	f7 75 f4             	divl   -0xc(%ebp)
80103650:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103653:	29 d0                	sub    %edx,%eax
80103655:	89 45 ec             	mov    %eax,-0x14(%ebp)
     buddy =  (struct buddy*)P2V(p_start);
80103658:	8b 45 08             	mov    0x8(%ebp),%eax
8010365b:	05 00 00 00 80       	add    $0x80000000,%eax
80103660:	a3 88 70 12 80       	mov    %eax,0x80127088
     buddy->beginning_addr = tmp;
80103665:	a1 88 70 12 80       	mov    0x80127088,%eax
8010366a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010366d:	89 10                	mov    %edx,(%eax)
     assert(buddy->beginning_addr > p_start);
8010366f:	a1 88 70 12 80       	mov    0x80127088,%eax
80103674:	8b 00                	mov    (%eax),%eax
80103676:	3b 45 08             	cmp    0x8(%ebp),%eax
80103679:	77 19                	ja     80103694 <calc+0x86>
8010367b:	68 d8 b0 10 80       	push   $0x8010b0d8
80103680:	68 f8 b0 10 80       	push   $0x8010b0f8
80103685:	6a 44                	push   $0x44
80103687:	68 0e b1 10 80       	push   $0x8010b10e
8010368c:	e8 c3 cc ff ff       	call   80100354 <__panic>
80103691:	83 c4 10             	add    $0x10,%esp
     assert((buddy->beginning_addr - p_start) % PGSIZE == 0);
80103694:	a1 88 70 12 80       	mov    0x80127088,%eax
80103699:	8b 00                	mov    (%eax),%eax
8010369b:	2b 45 08             	sub    0x8(%ebp),%eax
8010369e:	25 ff 0f 00 00       	and    $0xfff,%eax
801036a3:	85 c0                	test   %eax,%eax
801036a5:	74 19                	je     801036c0 <calc+0xb2>
801036a7:	68 24 b1 10 80       	push   $0x8010b124
801036ac:	68 f8 b0 10 80       	push   $0x8010b0f8
801036b1:	6a 45                	push   $0x45
801036b3:	68 0e b1 10 80       	push   $0x8010b10e
801036b8:	e8 97 cc ff ff       	call   80100354 <__panic>
801036bd:	83 c4 10             	add    $0x10,%esp

     //
     buddy->pg_size = pg_size -  (buddy->beginning_addr - p_start) / PGSIZE - 1;
801036c0:	a1 88 70 12 80       	mov    0x80127088,%eax
801036c5:	8b 15 88 70 12 80    	mov    0x80127088,%edx
801036cb:	8b 12                	mov    (%edx),%edx
801036cd:	2b 55 08             	sub    0x8(%ebp),%edx
801036d0:	89 d1                	mov    %edx,%ecx
801036d2:	c1 e9 0c             	shr    $0xc,%ecx
801036d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801036d8:	29 ca                	sub    %ecx,%edx
801036da:	83 ea 01             	sub    $0x1,%edx
801036dd:	89 50 08             	mov    %edx,0x8(%eax)

     buddy->size  = fix_size(buddy->pg_size);
801036e0:	8b 1d 88 70 12 80    	mov    0x80127088,%ebx
801036e6:	a1 88 70 12 80       	mov    0x80127088,%eax
801036eb:	8b 40 08             	mov    0x8(%eax),%eax
801036ee:	83 ec 0c             	sub    $0xc,%esp
801036f1:	50                   	push   %eax
801036f2:	e8 e0 fe ff ff       	call   801035d7 <fix_size>
801036f7:	83 c4 10             	add    $0x10,%esp
801036fa:	89 43 0c             	mov    %eax,0xc(%ebx)
     buddy->free_pg = buddy->pg_size;
801036fd:	a1 88 70 12 80       	mov    0x80127088,%eax
80103702:	8b 15 88 70 12 80    	mov    0x80127088,%edx
80103708:	8b 52 08             	mov    0x8(%edx),%edx
8010370b:	89 50 04             	mov    %edx,0x4(%eax)
}
8010370e:	90                   	nop
8010370f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103712:	c9                   	leave  
80103713:	c3                   	ret    

80103714 <i2page_off>:

//return the offset of the i'th page
static inline
uint32_t i2page_off(uint32_t i, uint32_t size)
{
80103714:	55                   	push   %ebp
80103715:	89 e5                	mov    %esp,%ebp
    return (i + 1) * size - buddy->size ;
80103717:	8b 45 08             	mov    0x8(%ebp),%eax
8010371a:	83 c0 01             	add    $0x1,%eax
8010371d:	0f af 45 0c          	imul   0xc(%ebp),%eax
80103721:	89 c2                	mov    %eax,%edx
80103723:	a1 88 70 12 80       	mov    0x80127088,%eax
80103728:	8b 40 0c             	mov    0xc(%eax),%eax
8010372b:	29 c2                	sub    %eax,%edx
8010372d:	89 d0                	mov    %edx,%eax
}
8010372f:	5d                   	pop    %ebp
80103730:	c3                   	ret    

80103731 <ret_val32>:

//return the real val
static inline
uint32_t ret_val32(uint8_t val)
{
80103731:	55                   	push   %ebp
80103732:	89 e5                	mov    %esp,%ebp
80103734:	83 ec 04             	sub    $0x4,%esp
80103737:	8b 45 08             	mov    0x8(%ebp),%eax
8010373a:	88 45 fc             	mov    %al,-0x4(%ebp)
    return 1 << ((val & 0x7f) - 1);
8010373d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
80103741:	83 e0 7f             	and    $0x7f,%eax
80103744:	83 e8 01             	sub    $0x1,%eax
80103747:	ba 01 00 00 00       	mov    $0x1,%edx
8010374c:	89 c1                	mov    %eax,%ecx
8010374e:	d3 e2                	shl    %cl,%edx
80103750:	89 d0                	mov    %edx,%eax
}
80103752:	c9                   	leave  
80103753:	c3                   	ret    

80103754 <IsValid>:
static inline
bool IsValid(uint8_t i)
{
80103754:	55                   	push   %ebp
80103755:	89 e5                	mov    %esp,%ebp
80103757:	83 ec 04             	sub    $0x4,%esp
8010375a:	8b 45 08             	mov    0x8(%ebp),%eax
8010375d:	88 45 fc             	mov    %al,-0x4(%ebp)
    return (i & 0x80) ? false : true;
80103760:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
80103764:	f7 d0                	not    %eax
80103766:	c0 e8 07             	shr    $0x7,%al
80103769:	0f b6 c0             	movzbl %al,%eax
}
8010376c:	c9                   	leave  
8010376d:	c3                   	ret    

8010376e <adjust_i>:

//adjust by son node
static inline void
adjust_i(uint32_t i ,uint8_t power)
{
8010376e:	55                   	push   %ebp
8010376f:	89 e5                	mov    %esp,%ebp
80103771:	53                   	push   %ebx
80103772:	83 ec 14             	sub    $0x14,%esp
80103775:	8b 45 0c             	mov    0xc(%ebp),%eax
80103778:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint32_t left_son_i = BUDDY_VAL(LEFT_SON(i)), right_son_i = BUDDY_VAL(RIGHT_SON(i)) ;
8010377b:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103781:	8b 45 08             	mov    0x8(%ebp),%eax
80103784:	01 c0                	add    %eax,%eax
80103786:	8d 50 01             	lea    0x1(%eax),%edx
80103789:	89 d0                	mov    %edx,%eax
8010378b:	c1 e0 03             	shl    $0x3,%eax
8010378e:	01 d0                	add    %edx,%eax
80103790:	01 c0                	add    %eax,%eax
80103792:	01 c8                	add    %ecx,%eax
80103794:	83 c0 1c             	add    $0x1c,%eax
80103797:	0f b6 00             	movzbl (%eax),%eax
8010379a:	0f b6 c0             	movzbl %al,%eax
8010379d:	89 45 f8             	mov    %eax,-0x8(%ebp)
801037a0:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
801037a6:	8b 45 08             	mov    0x8(%ebp),%eax
801037a9:	83 c0 01             	add    $0x1,%eax
801037ac:	8d 14 00             	lea    (%eax,%eax,1),%edx
801037af:	89 d0                	mov    %edx,%eax
801037b1:	c1 e0 03             	shl    $0x3,%eax
801037b4:	01 d0                	add    %edx,%eax
801037b6:	01 c0                	add    %eax,%eax
801037b8:	01 c8                	add    %ecx,%eax
801037ba:	83 c0 1c             	add    $0x1c,%eax
801037bd:	0f b6 00             	movzbl (%eax),%eax
801037c0:	0f b6 c0             	movzbl %al,%eax
801037c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(IsValid(left_son_i) && IsValid(right_son_i))
801037c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801037c9:	0f b6 c0             	movzbl %al,%eax
801037cc:	50                   	push   %eax
801037cd:	e8 82 ff ff ff       	call   80103754 <IsValid>
801037d2:	83 c4 04             	add    $0x4,%esp
801037d5:	85 c0                	test   %eax,%eax
801037d7:	74 75                	je     8010384e <adjust_i+0xe0>
801037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037dc:	0f b6 c0             	movzbl %al,%eax
801037df:	50                   	push   %eax
801037e0:	e8 6f ff ff ff       	call   80103754 <IsValid>
801037e5:	83 c4 04             	add    $0x4,%esp
801037e8:	85 c0                	test   %eax,%eax
801037ea:	74 62                	je     8010384e <adjust_i+0xe0>
    {
        if((left_son_i == right_son_i)  && (right_son_i == power - 1))
801037ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
801037ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037f2:	75 30                	jne    80103824 <adjust_i+0xb6>
801037f4:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
801037f8:	83 e8 01             	sub    $0x1,%eax
801037fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037fe:	75 24                	jne    80103824 <adjust_i+0xb6>
        {
            BUDDY_VAL(i) = left_son_i + 1;
80103800:	8b 1d 88 70 12 80    	mov    0x80127088,%ebx
80103806:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103809:	8d 48 01             	lea    0x1(%eax),%ecx
8010380c:	8b 55 08             	mov    0x8(%ebp),%edx
8010380f:	89 d0                	mov    %edx,%eax
80103811:	c1 e0 03             	shl    $0x3,%eax
80103814:	01 d0                	add    %edx,%eax
80103816:	01 c0                	add    %eax,%eax
80103818:	01 d8                	add    %ebx,%eax
8010381a:	83 c0 1c             	add    $0x1c,%eax
8010381d:	88 08                	mov    %cl,(%eax)
adjust_i(uint32_t i ,uint8_t power)
{
    uint32_t left_son_i = BUDDY_VAL(LEFT_SON(i)), right_son_i = BUDDY_VAL(RIGHT_SON(i)) ;
    if(IsValid(left_son_i) && IsValid(right_son_i))
    {
        if((left_son_i == right_son_i)  && (right_son_i == power - 1))
8010381f:	e9 d0 00 00 00       	jmp    801038f4 <adjust_i+0x186>
        {
            BUDDY_VAL(i) = left_son_i + 1;
        }else{
            BUDDY_VAL(i) = MAX(left_son_i, right_son_i);               
80103824:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
8010382a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010382d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103830:	0f 43 45 f4          	cmovae -0xc(%ebp),%eax
80103834:	89 c3                	mov    %eax,%ebx
80103836:	8b 55 08             	mov    0x8(%ebp),%edx
80103839:	89 d0                	mov    %edx,%eax
8010383b:	c1 e0 03             	shl    $0x3,%eax
8010383e:	01 d0                	add    %edx,%eax
80103840:	01 c0                	add    %eax,%eax
80103842:	01 c8                	add    %ecx,%eax
80103844:	83 c0 1c             	add    $0x1c,%eax
80103847:	88 18                	mov    %bl,(%eax)
adjust_i(uint32_t i ,uint8_t power)
{
    uint32_t left_son_i = BUDDY_VAL(LEFT_SON(i)), right_son_i = BUDDY_VAL(RIGHT_SON(i)) ;
    if(IsValid(left_son_i) && IsValid(right_son_i))
    {
        if((left_son_i == right_son_i)  && (right_son_i == power - 1))
80103849:	e9 a6 00 00 00       	jmp    801038f4 <adjust_i+0x186>
            BUDDY_VAL(i) = left_son_i + 1;
        }else{
            BUDDY_VAL(i) = MAX(left_son_i, right_son_i);               
        }

    }else if(!IsValid(left_son_i) && IsValid(right_son_i))
8010384e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103851:	0f b6 c0             	movzbl %al,%eax
80103854:	50                   	push   %eax
80103855:	e8 fa fe ff ff       	call   80103754 <IsValid>
8010385a:	83 c4 04             	add    $0x4,%esp
8010385d:	85 c0                	test   %eax,%eax
8010385f:	75 33                	jne    80103894 <adjust_i+0x126>
80103861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103864:	0f b6 c0             	movzbl %al,%eax
80103867:	50                   	push   %eax
80103868:	e8 e7 fe ff ff       	call   80103754 <IsValid>
8010386d:	83 c4 04             	add    $0x4,%esp
80103870:	85 c0                	test   %eax,%eax
80103872:	74 20                	je     80103894 <adjust_i+0x126>
    {
        BUDDY_VAL(i) = right_son_i; 
80103874:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
8010387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010387d:	89 c3                	mov    %eax,%ebx
8010387f:	8b 55 08             	mov    0x8(%ebp),%edx
80103882:	89 d0                	mov    %edx,%eax
80103884:	c1 e0 03             	shl    $0x3,%eax
80103887:	01 d0                	add    %edx,%eax
80103889:	01 c0                	add    %eax,%eax
8010388b:	01 c8                	add    %ecx,%eax
8010388d:	83 c0 1c             	add    $0x1c,%eax
80103890:	88 18                	mov    %bl,(%eax)
80103892:	eb 60                	jmp    801038f4 <adjust_i+0x186>
    }else if(IsValid(left_son_i) && !IsValid(right_son_i))
80103894:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103897:	0f b6 c0             	movzbl %al,%eax
8010389a:	50                   	push   %eax
8010389b:	e8 b4 fe ff ff       	call   80103754 <IsValid>
801038a0:	83 c4 04             	add    $0x4,%esp
801038a3:	85 c0                	test   %eax,%eax
801038a5:	74 33                	je     801038da <adjust_i+0x16c>
801038a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038aa:	0f b6 c0             	movzbl %al,%eax
801038ad:	50                   	push   %eax
801038ae:	e8 a1 fe ff ff       	call   80103754 <IsValid>
801038b3:	83 c4 04             	add    $0x4,%esp
801038b6:	85 c0                	test   %eax,%eax
801038b8:	75 20                	jne    801038da <adjust_i+0x16c>
    {
        BUDDY_VAL(i) = left_son_i; 
801038ba:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
801038c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801038c3:	89 c3                	mov    %eax,%ebx
801038c5:	8b 55 08             	mov    0x8(%ebp),%edx
801038c8:	89 d0                	mov    %edx,%eax
801038ca:	c1 e0 03             	shl    $0x3,%eax
801038cd:	01 d0                	add    %edx,%eax
801038cf:	01 c0                	add    %eax,%eax
801038d1:	01 c8                	add    %ecx,%eax
801038d3:	83 c0 1c             	add    $0x1c,%eax
801038d6:	88 18                	mov    %bl,(%eax)
801038d8:	eb 1a                	jmp    801038f4 <adjust_i+0x186>
    }else{
        BUDDY_VAL(i) = 0x80;
801038da:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
801038e0:	8b 55 08             	mov    0x8(%ebp),%edx
801038e3:	89 d0                	mov    %edx,%eax
801038e5:	c1 e0 03             	shl    $0x3,%eax
801038e8:	01 d0                	add    %edx,%eax
801038ea:	01 c0                	add    %eax,%eax
801038ec:	01 c8                	add    %ecx,%eax
801038ee:	83 c0 1c             	add    $0x1c,%eax
801038f1:	c6 00 80             	movb   $0x80,(%eax)
    }
}
801038f4:	90                   	nop
801038f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    

801038fa <offset2i>:

static inline uint32_t 
offset2i(uint32_t offset, int32_t* node_size)
{
801038fa:	55                   	push   %ebp
801038fb:	89 e5                	mov    %esp,%ebp
801038fd:	83 ec 18             	sub    $0x18,%esp
    uint32_t i = buddy->size - 1 + offset;
80103900:	a1 88 70 12 80       	mov    0x80127088,%eax
80103905:	8b 50 0c             	mov    0xc(%eax),%edx
80103908:	8b 45 08             	mov    0x8(%ebp),%eax
8010390b:	01 d0                	add    %edx,%eax
8010390d:	83 e8 01             	sub    $0x1,%eax
80103910:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(*node_size == 1);
80103913:	8b 45 0c             	mov    0xc(%ebp),%eax
80103916:	8b 00                	mov    (%eax),%eax
80103918:	83 f8 01             	cmp    $0x1,%eax
8010391b:	74 36                	je     80103953 <offset2i+0x59>
8010391d:	68 54 b1 10 80       	push   $0x8010b154
80103922:	68 f8 b0 10 80       	push   $0x8010b0f8
80103927:	6a 7e                	push   $0x7e
80103929:	68 0e b1 10 80       	push   $0x8010b10e
8010392e:	e8 21 ca ff ff       	call   80100354 <__panic>
80103933:	83 c4 10             	add    $0x10,%esp
    while(BUDDY_VAL(i) != 0)
80103936:	eb 1b                	jmp    80103953 <offset2i+0x59>
    {
        i = PARENT(i);    
80103938:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010393b:	83 c0 01             	add    $0x1,%eax
8010393e:	d1 e8                	shr    %eax
80103940:	83 e8 01             	sub    $0x1,%eax
80103943:	89 45 f4             	mov    %eax,-0xc(%ebp)
        (*node_size) ++;
80103946:	8b 45 0c             	mov    0xc(%ebp),%eax
80103949:	8b 00                	mov    (%eax),%eax
8010394b:	8d 50 01             	lea    0x1(%eax),%edx
8010394e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103951:	89 10                	mov    %edx,(%eax)
static inline uint32_t 
offset2i(uint32_t offset, int32_t* node_size)
{
    uint32_t i = buddy->size - 1 + offset;
    assert(*node_size == 1);
    while(BUDDY_VAL(i) != 0)
80103953:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103959:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010395c:	89 d0                	mov    %edx,%eax
8010395e:	c1 e0 03             	shl    $0x3,%eax
80103961:	01 d0                	add    %edx,%eax
80103963:	01 c0                	add    %eax,%eax
80103965:	01 c8                	add    %ecx,%eax
80103967:	83 c0 1c             	add    $0x1c,%eax
8010396a:	0f b6 00             	movzbl (%eax),%eax
8010396d:	84 c0                	test   %al,%al
8010396f:	75 c7                	jne    80103938 <offset2i+0x3e>
    {
        i = PARENT(i);    
        (*node_size) ++;
    }
    return i;
80103971:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103974:	c9                   	leave  
80103975:	c3                   	ret    

80103976 <buddy_pmm_alloc>:


static uint32_t 
buddy_pmm_alloc(uint32_t size)
{
80103976:	55                   	push   %ebp
80103977:	89 e5                	mov    %esp,%ebp
80103979:	53                   	push   %ebx
8010397a:	83 ec 14             	sub    $0x14,%esp
    if(size <= 0)
8010397d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103981:	75 0a                	jne    8010398d <buddy_pmm_alloc+0x17>
        return ALLOC_FALSE;
80103983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103988:	e9 20 02 00 00       	jmp    80103bad <buddy_pmm_alloc+0x237>
    
    if(buddy == NULL)
8010398d:	a1 88 70 12 80       	mov    0x80127088,%eax
80103992:	85 c0                	test   %eax,%eax
80103994:	75 0a                	jne    801039a0 <buddy_pmm_alloc+0x2a>
        return ALLOC_FALSE;
80103996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010399b:	e9 0d 02 00 00       	jmp    80103bad <buddy_pmm_alloc+0x237>
    if(!IS_POWER_OF_2(size))
801039a0:	8b 45 08             	mov    0x8(%ebp),%eax
801039a3:	83 e8 01             	sub    $0x1,%eax
801039a6:	23 45 08             	and    0x8(%ebp),%eax
801039a9:	85 c0                	test   %eax,%eax
801039ab:	74 0e                	je     801039bb <buddy_pmm_alloc+0x45>
        size = fix_size(size);
801039ad:	ff 75 08             	pushl  0x8(%ebp)
801039b0:	e8 22 fc ff ff       	call   801035d7 <fix_size>
801039b5:	83 c4 04             	add    $0x4,%esp
801039b8:	89 45 08             	mov    %eax,0x8(%ebp)
    size = fastlog2(size) + 1;
801039bb:	8b 45 08             	mov    0x8(%ebp),%eax
801039be:	50                   	push   %eax
801039bf:	e8 e9 fb ff ff       	call   801035ad <fastlog2>
801039c4:	83 c4 04             	add    $0x4,%esp
801039c7:	0f b6 c0             	movzbl %al,%eax
801039ca:	83 c0 01             	add    $0x1,%eax
801039cd:	89 45 08             	mov    %eax,0x8(%ebp)

    uint32_t i = 0;
801039d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32_t node_size = fastlog2(buddy->size) + 1;
801039d7:	a1 88 70 12 80       	mov    0x80127088,%eax
801039dc:	8b 40 0c             	mov    0xc(%eax),%eax
801039df:	50                   	push   %eax
801039e0:	e8 c8 fb ff ff       	call   801035ad <fastlog2>
801039e5:	83 c4 04             	add    $0x4,%esp
801039e8:	0f b6 c0             	movzbl %al,%eax
801039eb:	83 c0 01             	add    $0x1,%eax
801039ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t offset;
    uint32_t offsize;
    ACQUIRE;
801039f1:	a1 88 70 12 80       	mov    0x80127088,%eax
801039f6:	83 c0 10             	add    $0x10,%eax
801039f9:	83 ec 0c             	sub    $0xc,%esp
801039fc:	50                   	push   %eax
801039fd:	e8 b9 3d 00 00       	call   801077bb <acquire>
80103a02:	83 c4 10             	add    $0x10,%esp
    //no enough space
    if((BUDDY_VAL(i) & 0x7f) < size)
80103a05:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a0e:	89 d0                	mov    %edx,%eax
80103a10:	c1 e0 03             	shl    $0x3,%eax
80103a13:	01 d0                	add    %edx,%eax
80103a15:	01 c0                	add    %eax,%eax
80103a17:	01 c8                	add    %ecx,%eax
80103a19:	83 c0 1c             	add    $0x1c,%eax
80103a1c:	0f b6 00             	movzbl (%eax),%eax
80103a1f:	0f b6 c0             	movzbl %al,%eax
80103a22:	83 e0 7f             	and    $0x7f,%eax
80103a25:	3b 45 08             	cmp    0x8(%ebp),%eax
80103a28:	73 64                	jae    80103a8e <buddy_pmm_alloc+0x118>
    {
        RELEASE;
80103a2a:	a1 88 70 12 80       	mov    0x80127088,%eax
80103a2f:	83 c0 10             	add    $0x10,%eax
80103a32:	83 ec 0c             	sub    $0xc,%esp
80103a35:	50                   	push   %eax
80103a36:	e8 df 3d 00 00       	call   8010781a <release>
80103a3b:	83 c4 10             	add    $0x10,%esp
        return ALLOC_FALSE;
80103a3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a43:	e9 65 01 00 00       	jmp    80103bad <buddy_pmm_alloc+0x237>
    }
     
    for(; size != node_size ; node_size --)
    {
       if((BUDDY_VAL(LEFT_SON(i)) & 0x7f) >= size)
80103a48:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a51:	01 c0                	add    %eax,%eax
80103a53:	8d 50 01             	lea    0x1(%eax),%edx
80103a56:	89 d0                	mov    %edx,%eax
80103a58:	c1 e0 03             	shl    $0x3,%eax
80103a5b:	01 d0                	add    %edx,%eax
80103a5d:	01 c0                	add    %eax,%eax
80103a5f:	01 c8                	add    %ecx,%eax
80103a61:	83 c0 1c             	add    $0x1c,%eax
80103a64:	0f b6 00             	movzbl (%eax),%eax
80103a67:	0f b6 c0             	movzbl %al,%eax
80103a6a:	83 e0 7f             	and    $0x7f,%eax
80103a6d:	3b 45 08             	cmp    0x8(%ebp),%eax
80103a70:	72 0d                	jb     80103a7f <buddy_pmm_alloc+0x109>
       {
           i = LEFT_SON(i);
80103a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a75:	01 c0                	add    %eax,%eax
80103a77:	83 c0 01             	add    $0x1,%eax
80103a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a7d:	eb 0b                	jmp    80103a8a <buddy_pmm_alloc+0x114>
       }else{
           i = RIGHT_SON(i);
80103a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a82:	83 c0 01             	add    $0x1,%eax
80103a85:	01 c0                	add    %eax,%eax
80103a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        RELEASE;
        return ALLOC_FALSE;
    }
     
    for(; size != node_size ; node_size --)
80103a8a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80103a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a91:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103a94:	75 b2                	jne    80103a48 <buddy_pmm_alloc+0xd2>
       }else{
           i = RIGHT_SON(i);
       }
    }

    assert(IsValid(BUDDY_VAL(i)) == true);
80103a96:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a9f:	89 d0                	mov    %edx,%eax
80103aa1:	c1 e0 03             	shl    $0x3,%eax
80103aa4:	01 d0                	add    %edx,%eax
80103aa6:	01 c0                	add    %eax,%eax
80103aa8:	01 c8                	add    %ecx,%eax
80103aaa:	83 c0 1c             	add    $0x1c,%eax
80103aad:	0f b6 00             	movzbl (%eax),%eax
80103ab0:	0f b6 c0             	movzbl %al,%eax
80103ab3:	83 ec 0c             	sub    $0xc,%esp
80103ab6:	50                   	push   %eax
80103ab7:	e8 98 fc ff ff       	call   80103754 <IsValid>
80103abc:	83 c4 10             	add    $0x10,%esp
80103abf:	83 f8 01             	cmp    $0x1,%eax
80103ac2:	74 1c                	je     80103ae0 <buddy_pmm_alloc+0x16a>
80103ac4:	68 64 b1 10 80       	push   $0x8010b164
80103ac9:	68 f8 b0 10 80       	push   $0x8010b0f8
80103ace:	68 aa 00 00 00       	push   $0xaa
80103ad3:	68 0e b1 10 80       	push   $0x8010b10e
80103ad8:	e8 77 c8 ff ff       	call   80100354 <__panic>
80103add:	83 c4 10             	add    $0x10,%esp
    BUDDY_VAL(i) = 0;
80103ae0:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103ae6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ae9:	89 d0                	mov    %edx,%eax
80103aeb:	c1 e0 03             	shl    $0x3,%eax
80103aee:	01 d0                	add    %edx,%eax
80103af0:	01 c0                	add    %eax,%eax
80103af2:	01 c8                	add    %ecx,%eax
80103af4:	83 c0 1c             	add    $0x1c,%eax
80103af7:	c6 00 00             	movb   $0x0,(%eax)
    BUDDY_REF(i) ++;
80103afa:	8b 15 88 70 12 80    	mov    0x80127088,%edx
80103b00:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103b03:	89 c8                	mov    %ecx,%eax
80103b05:	c1 e0 03             	shl    $0x3,%eax
80103b08:	01 c8                	add    %ecx,%eax
80103b0a:	01 c0                	add    %eax,%eax
80103b0c:	01 d0                	add    %edx,%eax
80103b0e:	83 c0 1d             	add    $0x1d,%eax
80103b11:	0f b6 00             	movzbl (%eax),%eax
80103b14:	8d 58 01             	lea    0x1(%eax),%ebx
80103b17:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103b1a:	89 c8                	mov    %ecx,%eax
80103b1c:	c1 e0 03             	shl    $0x3,%eax
80103b1f:	01 c8                	add    %ecx,%eax
80103b21:	01 c0                	add    %eax,%eax
80103b23:	01 d0                	add    %edx,%eax
80103b25:	83 c0 1d             	add    $0x1d,%eax
80103b28:	88 18                	mov    %bl,(%eax)
    offsize = ret_val32(node_size);
80103b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b2d:	0f b6 c0             	movzbl %al,%eax
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	50                   	push   %eax
80103b34:	e8 f8 fb ff ff       	call   80103731 <ret_val32>
80103b39:	83 c4 10             	add    $0x10,%esp
80103b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    offset = i2page_off(i,offsize );
80103b3f:	83 ec 08             	sub    $0x8,%esp
80103b42:	ff 75 ec             	pushl  -0x14(%ebp)
80103b45:	ff 75 f4             	pushl  -0xc(%ebp)
80103b48:	e8 c7 fb ff ff       	call   80103714 <i2page_off>
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	89 45 e8             	mov    %eax,-0x18(%ebp)

    while(i)
80103b53:	eb 27                	jmp    80103b7c <buddy_pmm_alloc+0x206>
    {
       adjust_i(i = PARENT(i), ++node_size); 
80103b55:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5c:	0f b6 c0             	movzbl %al,%eax
80103b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b62:	83 c2 01             	add    $0x1,%edx
80103b65:	d1 ea                	shr    %edx
80103b67:	83 ea 01             	sub    $0x1,%edx
80103b6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
80103b6d:	83 ec 08             	sub    $0x8,%esp
80103b70:	50                   	push   %eax
80103b71:	ff 75 f4             	pushl  -0xc(%ebp)
80103b74:	e8 f5 fb ff ff       	call   8010376e <adjust_i>
80103b79:	83 c4 10             	add    $0x10,%esp
    BUDDY_VAL(i) = 0;
    BUDDY_REF(i) ++;
    offsize = ret_val32(node_size);
    offset = i2page_off(i,offsize );

    while(i)
80103b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b80:	75 d3                	jne    80103b55 <buddy_pmm_alloc+0x1df>
    {
       adjust_i(i = PARENT(i), ++node_size); 
    }
    buddy->free_pg -= offsize;
80103b82:	a1 88 70 12 80       	mov    0x80127088,%eax
80103b87:	8b 15 88 70 12 80    	mov    0x80127088,%edx
80103b8d:	8b 52 04             	mov    0x4(%edx),%edx
80103b90:	2b 55 ec             	sub    -0x14(%ebp),%edx
80103b93:	89 50 04             	mov    %edx,0x4(%eax)
    RELEASE;
80103b96:	a1 88 70 12 80       	mov    0x80127088,%eax
80103b9b:	83 c0 10             	add    $0x10,%eax
80103b9e:	83 ec 0c             	sub    $0xc,%esp
80103ba1:	50                   	push   %eax
80103ba2:	e8 73 3c 00 00       	call   8010781a <release>
80103ba7:	83 c4 10             	add    $0x10,%esp
    //cprintf("offset : %x offsize : %x \n", offset, offsize);      
    return offset;
80103baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
80103bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb0:	c9                   	leave  
80103bb1:	c3                   	ret    

80103bb2 <buddy_pmm_free>:

static void 
buddy_pmm_free(uint32_t offset)
{
80103bb2:	55                   	push   %ebp
80103bb3:	89 e5                	mov    %esp,%ebp
80103bb5:	53                   	push   %ebx
80103bb6:	83 ec 14             	sub    $0x14,%esp
    assert(offset < buddy->size);
80103bb9:	a1 88 70 12 80       	mov    0x80127088,%eax
80103bbe:	8b 40 0c             	mov    0xc(%eax),%eax
80103bc1:	3b 45 08             	cmp    0x8(%ebp),%eax
80103bc4:	77 1c                	ja     80103be2 <buddy_pmm_free+0x30>
80103bc6:	68 82 b1 10 80       	push   $0x8010b182
80103bcb:	68 f8 b0 10 80       	push   $0x8010b0f8
80103bd0:	68 bd 00 00 00       	push   $0xbd
80103bd5:	68 0e b1 10 80       	push   $0x8010b10e
80103bda:	e8 75 c7 ff ff       	call   80100354 <__panic>
80103bdf:	83 c4 10             	add    $0x10,%esp
    ACQUIRE;
80103be2:	a1 88 70 12 80       	mov    0x80127088,%eax
80103be7:	83 c0 10             	add    $0x10,%eax
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	50                   	push   %eax
80103bee:	e8 c8 3b 00 00       	call   801077bb <acquire>
80103bf3:	83 c4 10             	add    $0x10,%esp
    int32_t node_size = 1;
80103bf6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    uint32_t i = offset2i(offset,&node_size);
80103bfd:	83 ec 08             	sub    $0x8,%esp
80103c00:	8d 45 f0             	lea    -0x10(%ebp),%eax
80103c03:	50                   	push   %eax
80103c04:	ff 75 08             	pushl  0x8(%ebp)
80103c07:	e8 ee fc ff ff       	call   801038fa <offset2i>
80103c0c:	83 c4 10             	add    $0x10,%esp
80103c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    BUDDY_VAL(i) = node_size;         
80103c12:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c1b:	89 c3                	mov    %eax,%ebx
80103c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c20:	89 d0                	mov    %edx,%eax
80103c22:	c1 e0 03             	shl    $0x3,%eax
80103c25:	01 d0                	add    %edx,%eax
80103c27:	01 c0                	add    %eax,%eax
80103c29:	01 c8                	add    %ecx,%eax
80103c2b:	83 c0 1c             	add    $0x1c,%eax
80103c2e:	88 18                	mov    %bl,(%eax)
    assert(BUDDY_REF(i) != 0);
80103c30:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c39:	89 d0                	mov    %edx,%eax
80103c3b:	c1 e0 03             	shl    $0x3,%eax
80103c3e:	01 d0                	add    %edx,%eax
80103c40:	01 c0                	add    %eax,%eax
80103c42:	01 c8                	add    %ecx,%eax
80103c44:	83 c0 1d             	add    $0x1d,%eax
80103c47:	0f b6 00             	movzbl (%eax),%eax
80103c4a:	84 c0                	test   %al,%al
80103c4c:	75 1c                	jne    80103c6a <buddy_pmm_free+0xb8>
80103c4e:	68 97 b1 10 80       	push   $0x8010b197
80103c53:	68 f8 b0 10 80       	push   $0x8010b0f8
80103c58:	68 c3 00 00 00       	push   $0xc3
80103c5d:	68 0e b1 10 80       	push   $0x8010b10e
80103c62:	e8 ed c6 ff ff       	call   80100354 <__panic>
80103c67:	83 c4 10             	add    $0x10,%esp
    BUDDY_REF(i) --;
80103c6a:	8b 15 88 70 12 80    	mov    0x80127088,%edx
80103c70:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103c73:	89 c8                	mov    %ecx,%eax
80103c75:	c1 e0 03             	shl    $0x3,%eax
80103c78:	01 c8                	add    %ecx,%eax
80103c7a:	01 c0                	add    %eax,%eax
80103c7c:	01 d0                	add    %edx,%eax
80103c7e:	83 c0 1d             	add    $0x1d,%eax
80103c81:	0f b6 00             	movzbl (%eax),%eax
80103c84:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103c87:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103c8a:	89 c8                	mov    %ecx,%eax
80103c8c:	c1 e0 03             	shl    $0x3,%eax
80103c8f:	01 c8                	add    %ecx,%eax
80103c91:	01 c0                	add    %eax,%eax
80103c93:	01 d0                	add    %edx,%eax
80103c95:	83 c0 1d             	add    $0x1d,%eax
80103c98:	88 18                	mov    %bl,(%eax)
//    cprintf("add pg: %x\n",node_size);
    buddy->free_pg += ret_val32(node_size); 
80103c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c9d:	0f b6 c0             	movzbl %al,%eax
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	50                   	push   %eax
80103ca4:	e8 88 fa ff ff       	call   80103731 <ret_val32>
80103ca9:	83 c4 10             	add    $0x10,%esp
80103cac:	89 c1                	mov    %eax,%ecx
80103cae:	a1 88 70 12 80       	mov    0x80127088,%eax
80103cb3:	8b 15 88 70 12 80    	mov    0x80127088,%edx
80103cb9:	8b 52 04             	mov    0x4(%edx),%edx
80103cbc:	01 ca                	add    %ecx,%edx
80103cbe:	89 50 04             	mov    %edx,0x4(%eax)

    while(i)
80103cc1:	eb 2c                	jmp    80103cef <buddy_pmm_free+0x13d>
    {
        adjust_i(i = PARENT(i), ++node_size); 
80103cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc6:	83 c0 01             	add    $0x1,%eax
80103cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ccf:	0f b6 c0             	movzbl %al,%eax
80103cd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cd5:	83 c2 01             	add    $0x1,%edx
80103cd8:	d1 ea                	shr    %edx
80103cda:	83 ea 01             	sub    $0x1,%edx
80103cdd:	89 55 f4             	mov    %edx,-0xc(%ebp)
80103ce0:	83 ec 08             	sub    $0x8,%esp
80103ce3:	50                   	push   %eax
80103ce4:	ff 75 f4             	pushl  -0xc(%ebp)
80103ce7:	e8 82 fa ff ff       	call   8010376e <adjust_i>
80103cec:	83 c4 10             	add    $0x10,%esp
    assert(BUDDY_REF(i) != 0);
    BUDDY_REF(i) --;
//    cprintf("add pg: %x\n",node_size);
    buddy->free_pg += ret_val32(node_size); 

    while(i)
80103cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cf3:	75 ce                	jne    80103cc3 <buddy_pmm_free+0x111>
    {
        adjust_i(i = PARENT(i), ++node_size); 
    }
    RELEASE;
80103cf5:	a1 88 70 12 80       	mov    0x80127088,%eax
80103cfa:	83 c0 10             	add    $0x10,%eax
80103cfd:	83 ec 0c             	sub    $0xc,%esp
80103d00:	50                   	push   %eax
80103d01:	e8 14 3b 00 00       	call   8010781a <release>
80103d06:	83 c4 10             	add    $0x10,%esp
}
80103d09:	90                   	nop
80103d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0d:	c9                   	leave  
80103d0e:	c3                   	ret    

80103d0f <buddy_change_page_ref>:


static int8_t
buddy_change_page_ref(uint32_t offset, int8_t ch)
{
80103d0f:	55                   	push   %ebp
80103d10:	89 e5                	mov    %esp,%ebp
80103d12:	53                   	push   %ebx
80103d13:	83 ec 24             	sub    $0x24,%esp
80103d16:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d19:	88 45 e4             	mov    %al,-0x1c(%ebp)
    ACQUIRE;
80103d1c:	a1 88 70 12 80       	mov    0x80127088,%eax
80103d21:	83 c0 10             	add    $0x10,%eax
80103d24:	83 ec 0c             	sub    $0xc,%esp
80103d27:	50                   	push   %eax
80103d28:	e8 8e 3a 00 00       	call   801077bb <acquire>
80103d2d:	83 c4 10             	add    $0x10,%esp
    assert(offset < buddy->size);
80103d30:	a1 88 70 12 80       	mov    0x80127088,%eax
80103d35:	8b 40 0c             	mov    0xc(%eax),%eax
80103d38:	3b 45 08             	cmp    0x8(%ebp),%eax
80103d3b:	77 1c                	ja     80103d59 <buddy_change_page_ref+0x4a>
80103d3d:	68 82 b1 10 80       	push   $0x8010b182
80103d42:	68 f8 b0 10 80       	push   $0x8010b0f8
80103d47:	68 d4 00 00 00       	push   $0xd4
80103d4c:	68 0e b1 10 80       	push   $0x8010b10e
80103d51:	e8 fe c5 ff ff       	call   80100354 <__panic>
80103d56:	83 c4 10             	add    $0x10,%esp
    int32_t node_size = 1;
80103d59:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    uint32_t i = offset2i(offset,&node_size);
80103d60:	83 ec 08             	sub    $0x8,%esp
80103d63:	8d 45 ec             	lea    -0x14(%ebp),%eax
80103d66:	50                   	push   %eax
80103d67:	ff 75 08             	pushl  0x8(%ebp)
80103d6a:	e8 8b fb ff ff       	call   801038fa <offset2i>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert((BUDDY_REF(i) + ch) >= 1);
80103d75:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80103d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d7e:	89 d0                	mov    %edx,%eax
80103d80:	c1 e0 03             	shl    $0x3,%eax
80103d83:	01 d0                	add    %edx,%eax
80103d85:	01 c0                	add    %eax,%eax
80103d87:	01 c8                	add    %ecx,%eax
80103d89:	83 c0 1d             	add    $0x1d,%eax
80103d8c:	0f b6 00             	movzbl (%eax),%eax
80103d8f:	0f b6 d0             	movzbl %al,%edx
80103d92:	0f be 45 e4          	movsbl -0x1c(%ebp),%eax
80103d96:	01 d0                	add    %edx,%eax
80103d98:	85 c0                	test   %eax,%eax
80103d9a:	7f 1c                	jg     80103db8 <buddy_change_page_ref+0xa9>
80103d9c:	68 a9 b1 10 80       	push   $0x8010b1a9
80103da1:	68 f8 b0 10 80       	push   $0x8010b0f8
80103da6:	68 d7 00 00 00       	push   $0xd7
80103dab:	68 0e b1 10 80       	push   $0x8010b10e
80103db0:	e8 9f c5 ff ff       	call   80100354 <__panic>
80103db5:	83 c4 10             	add    $0x10,%esp
    int8_t ret = BUDDY_REF(i) += ch;
80103db8:	8b 15 88 70 12 80    	mov    0x80127088,%edx
80103dbe:	8b 1d 88 70 12 80    	mov    0x80127088,%ebx
80103dc4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103dc7:	89 c8                	mov    %ecx,%eax
80103dc9:	c1 e0 03             	shl    $0x3,%eax
80103dcc:	01 c8                	add    %ecx,%eax
80103dce:	01 c0                	add    %eax,%eax
80103dd0:	01 d8                	add    %ebx,%eax
80103dd2:	83 c0 1d             	add    $0x1d,%eax
80103dd5:	0f b6 08             	movzbl (%eax),%ecx
80103dd8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80103ddc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
80103ddf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103de2:	89 c8                	mov    %ecx,%eax
80103de4:	c1 e0 03             	shl    $0x3,%eax
80103de7:	01 c8                	add    %ecx,%eax
80103de9:	01 c0                	add    %eax,%eax
80103deb:	01 d0                	add    %edx,%eax
80103ded:	83 c0 1d             	add    $0x1d,%eax
80103df0:	88 18                	mov    %bl,(%eax)
80103df2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103df5:	89 c8                	mov    %ecx,%eax
80103df7:	c1 e0 03             	shl    $0x3,%eax
80103dfa:	01 c8                	add    %ecx,%eax
80103dfc:	01 c0                	add    %eax,%eax
80103dfe:	01 d0                	add    %edx,%eax
80103e00:	83 c0 1d             	add    $0x1d,%eax
80103e03:	0f b6 00             	movzbl (%eax),%eax
80103e06:	88 45 f3             	mov    %al,-0xd(%ebp)
    RELEASE;
80103e09:	a1 88 70 12 80       	mov    0x80127088,%eax
80103e0e:	83 c0 10             	add    $0x10,%eax
80103e11:	83 ec 0c             	sub    $0xc,%esp
80103e14:	50                   	push   %eax
80103e15:	e8 00 3a 00 00       	call   8010781a <release>
80103e1a:	83 c4 10             	add    $0x10,%esp
    return ret;
80103e1d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
}
80103e21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e24:	c9                   	leave  
80103e25:	c3                   	ret    

80103e26 <buddy_pmm_test>:

static void 
buddy_pmm_test(uintptr_t p_start)
{
80103e26:	55                   	push   %ebp
80103e27:	89 e5                	mov    %esp,%ebp
80103e29:	83 ec 28             	sub    $0x28,%esp
    uint32_t i,free_num = 0;
80103e2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    uint32_t free_store = buddy->free_pg;
80103e33:	a1 88 70 12 80       	mov    0x80127088,%eax
80103e38:	8b 40 04             	mov    0x4(%eax),%eax
80103e3b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    assert((buddy->beginning_addr - p_start) >= (buddy->size + BUDDY_SIZE_EXCEPT_VAL));
80103e3e:	a1 88 70 12 80       	mov    0x80127088,%eax
80103e43:	8b 00                	mov    (%eax),%eax
80103e45:	2b 45 08             	sub    0x8(%ebp),%eax
80103e48:	89 c2                	mov    %eax,%edx
80103e4a:	a1 88 70 12 80       	mov    0x80127088,%eax
80103e4f:	8b 40 0c             	mov    0xc(%eax),%eax
80103e52:	83 c0 1c             	add    $0x1c,%eax
80103e55:	39 c2                	cmp    %eax,%edx
80103e57:	73 1c                	jae    80103e75 <buddy_pmm_test+0x4f>
80103e59:	68 c4 b1 10 80       	push   $0x8010b1c4
80103e5e:	68 f8 b0 10 80       	push   $0x8010b0f8
80103e63:	68 e3 00 00 00       	push   $0xe3
80103e68:	68 0e b1 10 80       	push   $0x8010b10e
80103e6d:	e8 e2 c4 ff ff       	call   80100354 <__panic>
80103e72:	83 c4 10             	add    $0x10,%esp
    for(i = (buddy->size - 1) ; i < 2 * buddy->size - 1 ; i  ++)
80103e75:	a1 88 70 12 80       	mov    0x80127088,%eax
80103e7a:	8b 40 0c             	mov    0xc(%eax),%eax
80103e7d:	83 e8 01             	sub    $0x1,%eax
80103e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e83:	eb 08                	jmp    80103e8d <buddy_pmm_test+0x67>
    {
       free_num ++; 
80103e85:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
{
    uint32_t i,free_num = 0;
    uint32_t free_store = buddy->free_pg;

    assert((buddy->beginning_addr - p_start) >= (buddy->size + BUDDY_SIZE_EXCEPT_VAL));
    for(i = (buddy->size - 1) ; i < 2 * buddy->size - 1 ; i  ++)
80103e89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e8d:	a1 88 70 12 80       	mov    0x80127088,%eax
80103e92:	8b 40 0c             	mov    0xc(%eax),%eax
80103e95:	01 c0                	add    %eax,%eax
80103e97:	83 e8 01             	sub    $0x1,%eax
80103e9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103e9d:	77 e6                	ja     80103e85 <buddy_pmm_test+0x5f>
    {
       free_num ++; 
    }
    assert(free_num == buddy->size);
80103e9f:	a1 88 70 12 80       	mov    0x80127088,%eax
80103ea4:	8b 40 0c             	mov    0xc(%eax),%eax
80103ea7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103eaa:	74 1c                	je     80103ec8 <buddy_pmm_test+0xa2>
80103eac:	68 0f b2 10 80       	push   $0x8010b20f
80103eb1:	68 f8 b0 10 80       	push   $0x8010b0f8
80103eb6:	68 e8 00 00 00       	push   $0xe8
80103ebb:	68 0e b1 10 80       	push   $0x8010b10e
80103ec0:	e8 8f c4 ff ff       	call   80100354 <__panic>
80103ec5:	83 c4 10             	add    $0x10,%esp
    //test 1
    uint32_t a,b,c;
    a = buddy_pmm_alloc(1); 
80103ec8:	83 ec 0c             	sub    $0xc,%esp
80103ecb:	6a 01                	push   $0x1
80103ecd:	e8 a4 fa ff ff       	call   80103976 <buddy_pmm_alloc>
80103ed2:	83 c4 10             	add    $0x10,%esp
80103ed5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    b = buddy_pmm_alloc(1);
80103ed8:	83 ec 0c             	sub    $0xc,%esp
80103edb:	6a 01                	push   $0x1
80103edd:	e8 94 fa ff ff       	call   80103976 <buddy_pmm_alloc>
80103ee2:	83 c4 10             	add    $0x10,%esp
80103ee5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    c = buddy_pmm_alloc(1);
80103ee8:	83 ec 0c             	sub    $0xc,%esp
80103eeb:	6a 01                	push   $0x1
80103eed:	e8 84 fa ff ff       	call   80103976 <buddy_pmm_alloc>
80103ef2:	83 c4 10             	add    $0x10,%esp
80103ef5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    
    assert(a != ALLOC_FALSE && b != ALLOC_FALSE && c != ALLOC_FALSE);
80103ef8:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
80103efc:	74 0c                	je     80103f0a <buddy_pmm_test+0xe4>
80103efe:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
80103f02:	74 06                	je     80103f0a <buddy_pmm_test+0xe4>
80103f04:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
80103f08:	75 1c                	jne    80103f26 <buddy_pmm_test+0x100>
80103f0a:	68 28 b2 10 80       	push   $0x8010b228
80103f0f:	68 f8 b0 10 80       	push   $0x8010b0f8
80103f14:	68 ef 00 00 00       	push   $0xef
80103f19:	68 0e b1 10 80       	push   $0x8010b10e
80103f1e:	e8 31 c4 ff ff       	call   80100354 <__panic>
80103f23:	83 c4 10             	add    $0x10,%esp
    assert(a == 0 && b == 1 && c == 2);
80103f26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f2a:	75 0c                	jne    80103f38 <buddy_pmm_test+0x112>
80103f2c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
80103f30:	75 06                	jne    80103f38 <buddy_pmm_test+0x112>
80103f32:	83 7d dc 02          	cmpl   $0x2,-0x24(%ebp)
80103f36:	74 1c                	je     80103f54 <buddy_pmm_test+0x12e>
80103f38:	68 61 b2 10 80       	push   $0x8010b261
80103f3d:	68 f8 b0 10 80       	push   $0x8010b0f8
80103f42:	68 f0 00 00 00       	push   $0xf0
80103f47:	68 0e b1 10 80       	push   $0x8010b10e
80103f4c:	e8 03 c4 ff ff       	call   80100354 <__panic>
80103f51:	83 c4 10             	add    $0x10,%esp
    
    buddy_pmm_free(b);
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	ff 75 e8             	pushl  -0x18(%ebp)
80103f5a:	e8 53 fc ff ff       	call   80103bb2 <buddy_pmm_free>
80103f5f:	83 c4 10             	add    $0x10,%esp
    b = buddy_pmm_alloc(2);
80103f62:	83 ec 0c             	sub    $0xc,%esp
80103f65:	6a 02                	push   $0x2
80103f67:	e8 0a fa ff ff       	call   80103976 <buddy_pmm_alloc>
80103f6c:	83 c4 10             	add    $0x10,%esp
80103f6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(b == 4);
80103f72:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
80103f76:	74 1c                	je     80103f94 <buddy_pmm_test+0x16e>
80103f78:	68 7c b2 10 80       	push   $0x8010b27c
80103f7d:	68 f8 b0 10 80       	push   $0x8010b0f8
80103f82:	68 f4 00 00 00       	push   $0xf4
80103f87:	68 0e b1 10 80       	push   $0x8010b10e
80103f8c:	e8 c3 c3 ff ff       	call   80100354 <__panic>
80103f91:	83 c4 10             	add    $0x10,%esp

    buddy_pmm_free(c);
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	ff 75 dc             	pushl  -0x24(%ebp)
80103f9a:	e8 13 fc ff ff       	call   80103bb2 <buddy_pmm_free>
80103f9f:	83 c4 10             	add    $0x10,%esp
    c = buddy_pmm_alloc(2);
80103fa2:	83 ec 0c             	sub    $0xc,%esp
80103fa5:	6a 02                	push   $0x2
80103fa7:	e8 ca f9 ff ff       	call   80103976 <buddy_pmm_alloc>
80103fac:	83 c4 10             	add    $0x10,%esp
80103faf:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(c == 2);
80103fb2:	83 7d dc 02          	cmpl   $0x2,-0x24(%ebp)
80103fb6:	74 1c                	je     80103fd4 <buddy_pmm_test+0x1ae>
80103fb8:	68 83 b2 10 80       	push   $0x8010b283
80103fbd:	68 f8 b0 10 80       	push   $0x8010b0f8
80103fc2:	68 f8 00 00 00       	push   $0xf8
80103fc7:	68 0e b1 10 80       	push   $0x8010b10e
80103fcc:	e8 83 c3 ff ff       	call   80100354 <__panic>
80103fd1:	83 c4 10             	add    $0x10,%esp

    buddy_pmm_free(a);
80103fd4:	83 ec 0c             	sub    $0xc,%esp
80103fd7:	ff 75 ec             	pushl  -0x14(%ebp)
80103fda:	e8 d3 fb ff ff       	call   80103bb2 <buddy_pmm_free>
80103fdf:	83 c4 10             	add    $0x10,%esp
    a = buddy_pmm_alloc(2);
80103fe2:	83 ec 0c             	sub    $0xc,%esp
80103fe5:	6a 02                	push   $0x2
80103fe7:	e8 8a f9 ff ff       	call   80103976 <buddy_pmm_alloc>
80103fec:	83 c4 10             	add    $0x10,%esp
80103fef:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(a == 0);
80103ff2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ff6:	74 1c                	je     80104014 <buddy_pmm_test+0x1ee>
80103ff8:	68 8a b2 10 80       	push   $0x8010b28a
80103ffd:	68 f8 b0 10 80       	push   $0x8010b0f8
80104002:	68 fc 00 00 00       	push   $0xfc
80104007:	68 0e b1 10 80       	push   $0x8010b10e
8010400c:	e8 43 c3 ff ff       	call   80100354 <__panic>
80104011:	83 c4 10             	add    $0x10,%esp

    assert(buddy_change_page_ref(a,0) == 1); 
80104014:	83 ec 08             	sub    $0x8,%esp
80104017:	6a 00                	push   $0x0
80104019:	ff 75 ec             	pushl  -0x14(%ebp)
8010401c:	e8 ee fc ff ff       	call   80103d0f <buddy_change_page_ref>
80104021:	83 c4 10             	add    $0x10,%esp
80104024:	3c 01                	cmp    $0x1,%al
80104026:	74 1c                	je     80104044 <buddy_pmm_test+0x21e>
80104028:	68 94 b2 10 80       	push   $0x8010b294
8010402d:	68 f8 b0 10 80       	push   $0x8010b0f8
80104032:	68 fe 00 00 00       	push   $0xfe
80104037:	68 0e b1 10 80       	push   $0x8010b10e
8010403c:	e8 13 c3 ff ff       	call   80100354 <__panic>
80104041:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(a); 
80104044:	83 ec 0c             	sub    $0xc,%esp
80104047:	ff 75 ec             	pushl  -0x14(%ebp)
8010404a:	e8 63 fb ff ff       	call   80103bb2 <buddy_pmm_free>
8010404f:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(b); 
80104052:	83 ec 0c             	sub    $0xc,%esp
80104055:	ff 75 e8             	pushl  -0x18(%ebp)
80104058:	e8 55 fb ff ff       	call   80103bb2 <buddy_pmm_free>
8010405d:	83 c4 10             	add    $0x10,%esp
    assert(buddy_change_page_ref(c,0) == 1);
80104060:	83 ec 08             	sub    $0x8,%esp
80104063:	6a 00                	push   $0x0
80104065:	ff 75 dc             	pushl  -0x24(%ebp)
80104068:	e8 a2 fc ff ff       	call   80103d0f <buddy_change_page_ref>
8010406d:	83 c4 10             	add    $0x10,%esp
80104070:	3c 01                	cmp    $0x1,%al
80104072:	74 1c                	je     80104090 <buddy_pmm_test+0x26a>
80104074:	68 b4 b2 10 80       	push   $0x8010b2b4
80104079:	68 f8 b0 10 80       	push   $0x8010b0f8
8010407e:	68 01 01 00 00       	push   $0x101
80104083:	68 0e b1 10 80       	push   $0x8010b10e
80104088:	e8 c7 c2 ff ff       	call   80100354 <__panic>
8010408d:	83 c4 10             	add    $0x10,%esp
    assert(buddy_change_page_ref(c,4) == 5);
80104090:	83 ec 08             	sub    $0x8,%esp
80104093:	6a 04                	push   $0x4
80104095:	ff 75 dc             	pushl  -0x24(%ebp)
80104098:	e8 72 fc ff ff       	call   80103d0f <buddy_change_page_ref>
8010409d:	83 c4 10             	add    $0x10,%esp
801040a0:	3c 05                	cmp    $0x5,%al
801040a2:	74 1c                	je     801040c0 <buddy_pmm_test+0x29a>
801040a4:	68 d4 b2 10 80       	push   $0x8010b2d4
801040a9:	68 f8 b0 10 80       	push   $0x8010b0f8
801040ae:	68 02 01 00 00       	push   $0x102
801040b3:	68 0e b1 10 80       	push   $0x8010b10e
801040b8:	e8 97 c2 ff ff       	call   80100354 <__panic>
801040bd:	83 c4 10             	add    $0x10,%esp
    assert(buddy_change_page_ref(c,-4) == 1);
801040c0:	83 ec 08             	sub    $0x8,%esp
801040c3:	6a fc                	push   $0xfffffffc
801040c5:	ff 75 dc             	pushl  -0x24(%ebp)
801040c8:	e8 42 fc ff ff       	call   80103d0f <buddy_change_page_ref>
801040cd:	83 c4 10             	add    $0x10,%esp
801040d0:	3c 01                	cmp    $0x1,%al
801040d2:	74 1c                	je     801040f0 <buddy_pmm_test+0x2ca>
801040d4:	68 f4 b2 10 80       	push   $0x8010b2f4
801040d9:	68 f8 b0 10 80       	push   $0x8010b0f8
801040de:	68 03 01 00 00       	push   $0x103
801040e3:	68 0e b1 10 80       	push   $0x8010b10e
801040e8:	e8 67 c2 ff ff       	call   80100354 <__panic>
801040ed:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(c); 
801040f0:	83 ec 0c             	sub    $0xc,%esp
801040f3:	ff 75 dc             	pushl  -0x24(%ebp)
801040f6:	e8 b7 fa ff ff       	call   80103bb2 <buddy_pmm_free>
801040fb:	83 c4 10             	add    $0x10,%esp
    
    assert(buddy->free_pg == buddy->pg_size);
801040fe:	a1 88 70 12 80       	mov    0x80127088,%eax
80104103:	8b 50 04             	mov    0x4(%eax),%edx
80104106:	a1 88 70 12 80       	mov    0x80127088,%eax
8010410b:	8b 40 08             	mov    0x8(%eax),%eax
8010410e:	39 c2                	cmp    %eax,%edx
80104110:	74 1c                	je     8010412e <buddy_pmm_test+0x308>
80104112:	68 18 b3 10 80       	push   $0x8010b318
80104117:	68 f8 b0 10 80       	push   $0x8010b0f8
8010411c:	68 06 01 00 00       	push   $0x106
80104121:	68 0e b1 10 80       	push   $0x8010b10e
80104126:	e8 29 c2 ff ff       	call   80100354 <__panic>
8010412b:	83 c4 10             	add    $0x10,%esp

    //test 2
    a = buddy_pmm_alloc(3); 
8010412e:	83 ec 0c             	sub    $0xc,%esp
80104131:	6a 03                	push   $0x3
80104133:	e8 3e f8 ff ff       	call   80103976 <buddy_pmm_alloc>
80104138:	83 c4 10             	add    $0x10,%esp
8010413b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(a == 0);
8010413e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104142:	74 1c                	je     80104160 <buddy_pmm_test+0x33a>
80104144:	68 8a b2 10 80       	push   $0x8010b28a
80104149:	68 f8 b0 10 80       	push   $0x8010b0f8
8010414e:	68 0a 01 00 00       	push   $0x10a
80104153:	68 0e b1 10 80       	push   $0x8010b10e
80104158:	e8 f7 c1 ff ff       	call   80100354 <__panic>
8010415d:	83 c4 10             	add    $0x10,%esp
    b = buddy_pmm_alloc(5);
80104160:	83 ec 0c             	sub    $0xc,%esp
80104163:	6a 05                	push   $0x5
80104165:	e8 0c f8 ff ff       	call   80103976 <buddy_pmm_alloc>
8010416a:	83 c4 10             	add    $0x10,%esp
8010416d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(b == 8);
80104170:	83 7d e8 08          	cmpl   $0x8,-0x18(%ebp)
80104174:	74 1c                	je     80104192 <buddy_pmm_test+0x36c>
80104176:	68 39 b3 10 80       	push   $0x8010b339
8010417b:	68 f8 b0 10 80       	push   $0x8010b0f8
80104180:	68 0c 01 00 00       	push   $0x10c
80104185:	68 0e b1 10 80       	push   $0x8010b10e
8010418a:	e8 c5 c1 ff ff       	call   80100354 <__panic>
8010418f:	83 c4 10             	add    $0x10,%esp
    c = buddy_pmm_alloc(7);
80104192:	83 ec 0c             	sub    $0xc,%esp
80104195:	6a 07                	push   $0x7
80104197:	e8 da f7 ff ff       	call   80103976 <buddy_pmm_alloc>
8010419c:	83 c4 10             	add    $0x10,%esp
8010419f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(c == 16);
801041a2:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
801041a6:	74 1c                	je     801041c4 <buddy_pmm_test+0x39e>
801041a8:	68 40 b3 10 80       	push   $0x8010b340
801041ad:	68 f8 b0 10 80       	push   $0x8010b0f8
801041b2:	68 0e 01 00 00       	push   $0x10e
801041b7:	68 0e b1 10 80       	push   $0x8010b10e
801041bc:	e8 93 c1 ff ff       	call   80100354 <__panic>
801041c1:	83 c4 10             	add    $0x10,%esp

    buddy_pmm_free(b);
801041c4:	83 ec 0c             	sub    $0xc,%esp
801041c7:	ff 75 e8             	pushl  -0x18(%ebp)
801041ca:	e8 e3 f9 ff ff       	call   80103bb2 <buddy_pmm_free>
801041cf:	83 c4 10             	add    $0x10,%esp
    b = buddy_pmm_alloc(3);
801041d2:	83 ec 0c             	sub    $0xc,%esp
801041d5:	6a 03                	push   $0x3
801041d7:	e8 9a f7 ff ff       	call   80103976 <buddy_pmm_alloc>
801041dc:	83 c4 10             	add    $0x10,%esp
801041df:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(b == 4);
801041e2:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
801041e6:	74 1c                	je     80104204 <buddy_pmm_test+0x3de>
801041e8:	68 7c b2 10 80       	push   $0x8010b27c
801041ed:	68 f8 b0 10 80       	push   $0x8010b0f8
801041f2:	68 12 01 00 00       	push   $0x112
801041f7:	68 0e b1 10 80       	push   $0x8010b10e
801041fc:	e8 53 c1 ff ff       	call   80100354 <__panic>
80104201:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(a);
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	ff 75 ec             	pushl  -0x14(%ebp)
8010420a:	e8 a3 f9 ff ff       	call   80103bb2 <buddy_pmm_free>
8010420f:	83 c4 10             	add    $0x10,%esp
    a = buddy_pmm_alloc(9);
80104212:	83 ec 0c             	sub    $0xc,%esp
80104215:	6a 09                	push   $0x9
80104217:	e8 5a f7 ff ff       	call   80103976 <buddy_pmm_alloc>
8010421c:	83 c4 10             	add    $0x10,%esp
8010421f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(a == 32);
80104222:	83 7d ec 20          	cmpl   $0x20,-0x14(%ebp)
80104226:	74 1c                	je     80104244 <buddy_pmm_test+0x41e>
80104228:	68 48 b3 10 80       	push   $0x8010b348
8010422d:	68 f8 b0 10 80       	push   $0x8010b0f8
80104232:	68 15 01 00 00       	push   $0x115
80104237:	68 0e b1 10 80       	push   $0x8010b10e
8010423c:	e8 13 c1 ff ff       	call   80100354 <__panic>
80104241:	83 c4 10             	add    $0x10,%esp
    
    buddy_pmm_free(a);
80104244:	83 ec 0c             	sub    $0xc,%esp
80104247:	ff 75 ec             	pushl  -0x14(%ebp)
8010424a:	e8 63 f9 ff ff       	call   80103bb2 <buddy_pmm_free>
8010424f:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(b); 
80104252:	83 ec 0c             	sub    $0xc,%esp
80104255:	ff 75 e8             	pushl  -0x18(%ebp)
80104258:	e8 55 f9 ff ff       	call   80103bb2 <buddy_pmm_free>
8010425d:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(c); 
80104260:	83 ec 0c             	sub    $0xc,%esp
80104263:	ff 75 dc             	pushl  -0x24(%ebp)
80104266:	e8 47 f9 ff ff       	call   80103bb2 <buddy_pmm_free>
8010426b:	83 c4 10             	add    $0x10,%esp


    assert(buddy->free_pg == buddy->pg_size);
8010426e:	a1 88 70 12 80       	mov    0x80127088,%eax
80104273:	8b 50 04             	mov    0x4(%eax),%edx
80104276:	a1 88 70 12 80       	mov    0x80127088,%eax
8010427b:	8b 40 08             	mov    0x8(%eax),%eax
8010427e:	39 c2                	cmp    %eax,%edx
80104280:	74 1c                	je     8010429e <buddy_pmm_test+0x478>
80104282:	68 18 b3 10 80       	push   $0x8010b318
80104287:	68 f8 b0 10 80       	push   $0x8010b0f8
8010428c:	68 1c 01 00 00       	push   $0x11c
80104291:	68 0e b1 10 80       	push   $0x8010b10e
80104296:	e8 b9 c0 ff ff       	call   80100354 <__panic>
8010429b:	83 c4 10             	add    $0x10,%esp
    //test 3
    uint32_t d,e;
    a = buddy_pmm_alloc(0x990);   
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	68 90 09 00 00       	push   $0x990
801042a6:	e8 cb f6 ff ff       	call   80103976 <buddy_pmm_alloc>
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    b = buddy_pmm_alloc(0x2000);
801042b1:	83 ec 0c             	sub    $0xc,%esp
801042b4:	68 00 20 00 00       	push   $0x2000
801042b9:	e8 b8 f6 ff ff       	call   80103976 <buddy_pmm_alloc>
801042be:	83 c4 10             	add    $0x10,%esp
801042c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(b == a + b && b == 0x2000);
801042c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801042c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042ca:	01 d0                	add    %edx,%eax
801042cc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801042cf:	75 09                	jne    801042da <buddy_pmm_test+0x4b4>
801042d1:	81 7d e8 00 20 00 00 	cmpl   $0x2000,-0x18(%ebp)
801042d8:	74 1c                	je     801042f6 <buddy_pmm_test+0x4d0>
801042da:	68 50 b3 10 80       	push   $0x8010b350
801042df:	68 f8 b0 10 80       	push   $0x8010b0f8
801042e4:	68 21 01 00 00       	push   $0x121
801042e9:	68 0e b1 10 80       	push   $0x8010b10e
801042ee:	e8 61 c0 ff ff       	call   80100354 <__panic>
801042f3:	83 c4 10             	add    $0x10,%esp
    c = buddy_pmm_alloc(0x2990);
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	68 90 29 00 00       	push   $0x2990
801042fe:	e8 73 f6 ff ff       	call   80103976 <buddy_pmm_alloc>
80104303:	83 c4 10             	add    $0x10,%esp
80104306:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(c == 0x4000);
80104309:	81 7d dc 00 40 00 00 	cmpl   $0x4000,-0x24(%ebp)
80104310:	74 1c                	je     8010432e <buddy_pmm_test+0x508>
80104312:	68 6a b3 10 80       	push   $0x8010b36a
80104317:	68 f8 b0 10 80       	push   $0x8010b0f8
8010431c:	68 23 01 00 00       	push   $0x123
80104321:	68 0e b1 10 80       	push   $0x8010b10e
80104326:	e8 29 c0 ff ff       	call   80100354 <__panic>
8010432b:	83 c4 10             	add    $0x10,%esp
    d = buddy_pmm_alloc(940);
8010432e:	83 ec 0c             	sub    $0xc,%esp
80104331:	68 ac 03 00 00       	push   $0x3ac
80104336:	e8 3b f6 ff ff       	call   80103976 <buddy_pmm_alloc>
8010433b:	83 c4 10             	add    $0x10,%esp
8010433e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(d == 0x1000);
80104341:	81 7d e4 00 10 00 00 	cmpl   $0x1000,-0x1c(%ebp)
80104348:	74 1c                	je     80104366 <buddy_pmm_test+0x540>
8010434a:	68 76 b3 10 80       	push   $0x8010b376
8010434f:	68 f8 b0 10 80       	push   $0x8010b0f8
80104354:	68 25 01 00 00       	push   $0x125
80104359:	68 0e b1 10 80       	push   $0x8010b10e
8010435e:	e8 f1 bf ff ff       	call   80100354 <__panic>
80104363:	83 c4 10             	add    $0x10,%esp
    e = buddy_pmm_alloc(buddy->size);
80104366:	a1 88 70 12 80       	mov    0x80127088,%eax
8010436b:	8b 40 0c             	mov    0xc(%eax),%eax
8010436e:	83 ec 0c             	sub    $0xc,%esp
80104371:	50                   	push   %eax
80104372:	e8 ff f5 ff ff       	call   80103976 <buddy_pmm_alloc>
80104377:	83 c4 10             	add    $0x10,%esp
8010437a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    assert(e == ALLOC_FALSE);
8010437d:	83 7d d8 ff          	cmpl   $0xffffffff,-0x28(%ebp)
80104381:	74 1c                	je     8010439f <buddy_pmm_test+0x579>
80104383:	68 82 b3 10 80       	push   $0x8010b382
80104388:	68 f8 b0 10 80       	push   $0x8010b0f8
8010438d:	68 27 01 00 00       	push   $0x127
80104392:	68 0e b1 10 80       	push   $0x8010b10e
80104397:	e8 b8 bf ff ff       	call   80100354 <__panic>
8010439c:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(d); 
8010439f:	83 ec 0c             	sub    $0xc,%esp
801043a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801043a5:	e8 08 f8 ff ff       	call   80103bb2 <buddy_pmm_free>
801043aa:	83 c4 10             	add    $0x10,%esp
    d = buddy_pmm_alloc(0x39);
801043ad:	83 ec 0c             	sub    $0xc,%esp
801043b0:	6a 39                	push   $0x39
801043b2:	e8 bf f5 ff ff       	call   80103976 <buddy_pmm_alloc>
801043b7:	83 c4 10             	add    $0x10,%esp
801043ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(d == 0x1000);
801043bd:	81 7d e4 00 10 00 00 	cmpl   $0x1000,-0x1c(%ebp)
801043c4:	74 1c                	je     801043e2 <buddy_pmm_test+0x5bc>
801043c6:	68 76 b3 10 80       	push   $0x8010b376
801043cb:	68 f8 b0 10 80       	push   $0x8010b0f8
801043d0:	68 2a 01 00 00       	push   $0x12a
801043d5:	68 0e b1 10 80       	push   $0x8010b10e
801043da:	e8 75 bf ff ff       	call   80100354 <__panic>
801043df:	83 c4 10             	add    $0x10,%esp
    assert((buddy->pg_size - buddy->free_pg) == (0x1000 + 0x2000 + 0x4000+ 0x40));
801043e2:	a1 88 70 12 80       	mov    0x80127088,%eax
801043e7:	8b 50 08             	mov    0x8(%eax),%edx
801043ea:	a1 88 70 12 80       	mov    0x80127088,%eax
801043ef:	8b 40 04             	mov    0x4(%eax),%eax
801043f2:	29 c2                	sub    %eax,%edx
801043f4:	89 d0                	mov    %edx,%eax
801043f6:	3d 40 70 00 00       	cmp    $0x7040,%eax
801043fb:	74 1c                	je     80104419 <buddy_pmm_test+0x5f3>
801043fd:	68 94 b3 10 80       	push   $0x8010b394
80104402:	68 f8 b0 10 80       	push   $0x8010b0f8
80104407:	68 2b 01 00 00       	push   $0x12b
8010440c:	68 0e b1 10 80       	push   $0x8010b10e
80104411:	e8 3e bf ff ff       	call   80100354 <__panic>
80104416:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(a);
80104419:	83 ec 0c             	sub    $0xc,%esp
8010441c:	ff 75 ec             	pushl  -0x14(%ebp)
8010441f:	e8 8e f7 ff ff       	call   80103bb2 <buddy_pmm_free>
80104424:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(b); 
80104427:	83 ec 0c             	sub    $0xc,%esp
8010442a:	ff 75 e8             	pushl  -0x18(%ebp)
8010442d:	e8 80 f7 ff ff       	call   80103bb2 <buddy_pmm_free>
80104432:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(c); 
80104435:	83 ec 0c             	sub    $0xc,%esp
80104438:	ff 75 dc             	pushl  -0x24(%ebp)
8010443b:	e8 72 f7 ff ff       	call   80103bb2 <buddy_pmm_free>
80104440:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_free(d); 
80104443:	83 ec 0c             	sub    $0xc,%esp
80104446:	ff 75 e4             	pushl  -0x1c(%ebp)
80104449:	e8 64 f7 ff ff       	call   80103bb2 <buddy_pmm_free>
8010444e:	83 c4 10             	add    $0x10,%esp
    
    assert(buddy->free_pg == buddy->pg_size);
80104451:	a1 88 70 12 80       	mov    0x80127088,%eax
80104456:	8b 50 04             	mov    0x4(%eax),%edx
80104459:	a1 88 70 12 80       	mov    0x80127088,%eax
8010445e:	8b 40 08             	mov    0x8(%eax),%eax
80104461:	39 c2                	cmp    %eax,%edx
80104463:	74 1c                	je     80104481 <buddy_pmm_test+0x65b>
80104465:	68 18 b3 10 80       	push   $0x8010b318
8010446a:	68 f8 b0 10 80       	push   $0x8010b0f8
8010446f:	68 31 01 00 00       	push   $0x131
80104474:	68 0e b1 10 80       	push   $0x8010b10e
80104479:	e8 d6 be ff ff       	call   80100354 <__panic>
8010447e:	83 c4 10             	add    $0x10,%esp

    //test 4
    b = 0;
80104481:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    for(a = buddy->size / 2 ; (a != 0) && ((c = buddy_pmm_alloc(a)) != ALLOC_FALSE) ; b += a, a /= 2 )
80104488:	a1 88 70 12 80       	mov    0x80127088,%eax
8010448d:	8b 40 0c             	mov    0xc(%eax),%eax
80104490:	d1 e8                	shr    %eax
80104492:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104495:	eb 32                	jmp    801044c9 <buddy_pmm_test+0x6a3>
    {
       assert(b == c); 
80104497:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010449a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
8010449d:	74 1c                	je     801044bb <buddy_pmm_test+0x695>
8010449f:	68 da b3 10 80       	push   $0x8010b3da
801044a4:	68 f8 b0 10 80       	push   $0x8010b0f8
801044a9:	68 37 01 00 00       	push   $0x137
801044ae:	68 0e b1 10 80       	push   $0x8010b10e
801044b3:	e8 9c be ff ff       	call   80100354 <__panic>
801044b8:	83 c4 10             	add    $0x10,%esp
    
    assert(buddy->free_pg == buddy->pg_size);

    //test 4
    b = 0;
    for(a = buddy->size / 2 ; (a != 0) && ((c = buddy_pmm_alloc(a)) != ALLOC_FALSE) ; b += a, a /= 2 )
801044bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044be:	01 45 e8             	add    %eax,-0x18(%ebp)
801044c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044c4:	d1 e8                	shr    %eax
801044c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801044c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801044cd:	74 17                	je     801044e6 <buddy_pmm_test+0x6c0>
801044cf:	83 ec 0c             	sub    $0xc,%esp
801044d2:	ff 75 ec             	pushl  -0x14(%ebp)
801044d5:	e8 9c f4 ff ff       	call   80103976 <buddy_pmm_alloc>
801044da:	83 c4 10             	add    $0x10,%esp
801044dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801044e0:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
801044e4:	75 b1                	jne    80104497 <buddy_pmm_test+0x671>
    {
       assert(b == c); 
    }
    assert(a > buddy->free_pg);
801044e6:	a1 88 70 12 80       	mov    0x80127088,%eax
801044eb:	8b 40 04             	mov    0x4(%eax),%eax
801044ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801044f1:	72 1c                	jb     8010450f <buddy_pmm_test+0x6e9>
801044f3:	68 e1 b3 10 80       	push   $0x8010b3e1
801044f8:	68 f8 b0 10 80       	push   $0x8010b0f8
801044fd:	68 39 01 00 00       	push   $0x139
80104502:	68 0e b1 10 80       	push   $0x8010b10e
80104507:	e8 48 be ff ff       	call   80100354 <__panic>
8010450c:	83 c4 10             	add    $0x10,%esp
    for(d = buddy->size / 2 , b = 0 ; d != a ; b += d, d /= 2 )
8010450f:	a1 88 70 12 80       	mov    0x80127088,%eax
80104514:	8b 40 0c             	mov    0xc(%eax),%eax
80104517:	d1 e8                	shr    %eax
80104519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010451c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104523:	eb 1c                	jmp    80104541 <buddy_pmm_test+0x71b>
    {
        buddy_pmm_free(b);
80104525:	83 ec 0c             	sub    $0xc,%esp
80104528:	ff 75 e8             	pushl  -0x18(%ebp)
8010452b:	e8 82 f6 ff ff       	call   80103bb2 <buddy_pmm_free>
80104530:	83 c4 10             	add    $0x10,%esp
    for(a = buddy->size / 2 ; (a != 0) && ((c = buddy_pmm_alloc(a)) != ALLOC_FALSE) ; b += a, a /= 2 )
    {
       assert(b == c); 
    }
    assert(a > buddy->free_pg);
    for(d = buddy->size / 2 , b = 0 ; d != a ; b += d, d /= 2 )
80104533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104536:	01 45 e8             	add    %eax,-0x18(%ebp)
80104539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010453c:	d1 e8                	shr    %eax
8010453e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104544:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104547:	75 dc                	jne    80104525 <buddy_pmm_test+0x6ff>
    {
        buddy_pmm_free(b);
    }
    assert(buddy->free_pg == buddy->pg_size);
80104549:	a1 88 70 12 80       	mov    0x80127088,%eax
8010454e:	8b 50 04             	mov    0x4(%eax),%edx
80104551:	a1 88 70 12 80       	mov    0x80127088,%eax
80104556:	8b 40 08             	mov    0x8(%eax),%eax
80104559:	39 c2                	cmp    %eax,%edx
8010455b:	74 1c                	je     80104579 <buddy_pmm_test+0x753>
8010455d:	68 18 b3 10 80       	push   $0x8010b318
80104562:	68 f8 b0 10 80       	push   $0x8010b0f8
80104567:	68 3e 01 00 00       	push   $0x13e
8010456c:	68 0e b1 10 80       	push   $0x8010b10e
80104571:	e8 de bd ff ff       	call   80100354 <__panic>
80104576:	83 c4 10             	add    $0x10,%esp



    free_num = 0;
80104579:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(i = (buddy->size - 1) ; i < 2 * buddy->size - 1 ; i  ++)
80104580:	a1 88 70 12 80       	mov    0x80127088,%eax
80104585:	8b 40 0c             	mov    0xc(%eax),%eax
80104588:	83 e8 01             	sub    $0x1,%eax
8010458b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010458e:	eb 08                	jmp    80104598 <buddy_pmm_test+0x772>
    {
       free_num ++; 
80104590:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    assert(buddy->free_pg == buddy->pg_size);



    free_num = 0;
    for(i = (buddy->size - 1) ; i < 2 * buddy->size - 1 ; i  ++)
80104594:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104598:	a1 88 70 12 80       	mov    0x80127088,%eax
8010459d:	8b 40 0c             	mov    0xc(%eax),%eax
801045a0:	01 c0                	add    %eax,%eax
801045a2:	83 e8 01             	sub    $0x1,%eax
801045a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801045a8:	77 e6                	ja     80104590 <buddy_pmm_test+0x76a>
    {
       free_num ++; 
    }
    assert(free_num == buddy->size);
801045aa:	a1 88 70 12 80       	mov    0x80127088,%eax
801045af:	8b 40 0c             	mov    0xc(%eax),%eax
801045b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801045b5:	74 1c                	je     801045d3 <buddy_pmm_test+0x7ad>
801045b7:	68 0f b2 10 80       	push   $0x8010b20f
801045bc:	68 f8 b0 10 80       	push   $0x8010b0f8
801045c1:	68 47 01 00 00       	push   $0x147
801045c6:	68 0e b1 10 80       	push   $0x8010b10e
801045cb:	e8 84 bd ff ff       	call   80100354 <__panic>
801045d0:	83 c4 10             	add    $0x10,%esp
    assert(free_store = buddy->free_pg);
801045d3:	a1 88 70 12 80       	mov    0x80127088,%eax
801045d8:	8b 40 04             	mov    0x4(%eax),%eax
801045db:	89 45 e0             	mov    %eax,-0x20(%ebp)
801045de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801045e2:	75 1c                	jne    80104600 <buddy_pmm_test+0x7da>
801045e4:	68 f4 b3 10 80       	push   $0x8010b3f4
801045e9:	68 f8 b0 10 80       	push   $0x8010b0f8
801045ee:	68 48 01 00 00       	push   $0x148
801045f3:	68 0e b1 10 80       	push   $0x8010b10e
801045f8:	e8 57 bd ff ff       	call   80100354 <__panic>
801045fd:	83 c4 10             	add    $0x10,%esp
}
80104600:	90                   	nop
80104601:	c9                   	leave  
80104602:	c3                   	ret    

80104603 <init_buddy_pmm>:
//init pmm in buddy system
static void
init_buddy_pmm(uintptr_t *p_start, uint32_t *pg_size)
{
80104603:	55                   	push   %ebp
80104604:	89 e5                	mov    %esp,%ebp
80104606:	53                   	push   %ebx
80104607:	83 ec 14             	sub    $0x14,%esp
    //
    calc(*p_start,*pg_size);
8010460a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010460d:	8b 10                	mov    (%eax),%edx
8010460f:	8b 45 08             	mov    0x8(%ebp),%eax
80104612:	8b 00                	mov    (%eax),%eax
80104614:	83 ec 08             	sub    $0x8,%esp
80104617:	52                   	push   %edx
80104618:	50                   	push   %eax
80104619:	e8 f0 ef ff ff       	call   8010360e <calc>
8010461e:	83 c4 10             	add    $0x10,%esp
    cprintf("buddy_start: %8x, buddy_pg_size: %8x, buddy_size: %8x\n",buddy->beginning_addr, buddy->pg_size, buddy->size); 
80104621:	a1 88 70 12 80       	mov    0x80127088,%eax
80104626:	8b 48 0c             	mov    0xc(%eax),%ecx
80104629:	a1 88 70 12 80       	mov    0x80127088,%eax
8010462e:	8b 50 08             	mov    0x8(%eax),%edx
80104631:	a1 88 70 12 80       	mov    0x80127088,%eax
80104636:	8b 00                	mov    (%eax),%eax
80104638:	51                   	push   %ecx
80104639:	52                   	push   %edx
8010463a:	50                   	push   %eax
8010463b:	68 10 b4 10 80       	push   $0x8010b410
80104640:	e8 92 26 00 00       	call   80106cd7 <cprintf>
80104645:	83 c4 10             	add    $0x10,%esp
    assert(buddy->size > 0);
80104648:	a1 88 70 12 80       	mov    0x80127088,%eax
8010464d:	8b 40 0c             	mov    0xc(%eax),%eax
80104650:	85 c0                	test   %eax,%eax
80104652:	75 1c                	jne    80104670 <init_buddy_pmm+0x6d>
80104654:	68 47 b4 10 80       	push   $0x8010b447
80104659:	68 f8 b0 10 80       	push   $0x8010b0f8
8010465e:	68 51 01 00 00       	push   $0x151
80104663:	68 0e b1 10 80       	push   $0x8010b10e
80104668:	e8 e7 bc ff ff       	call   80100354 <__panic>
8010466d:	83 c4 10             	add    $0x10,%esp
    assert(buddy->beginning_addr - *p_start >= (buddy->size + 12));
80104670:	a1 88 70 12 80       	mov    0x80127088,%eax
80104675:	8b 10                	mov    (%eax),%edx
80104677:	8b 45 08             	mov    0x8(%ebp),%eax
8010467a:	8b 00                	mov    (%eax),%eax
8010467c:	29 c2                	sub    %eax,%edx
8010467e:	a1 88 70 12 80       	mov    0x80127088,%eax
80104683:	8b 40 0c             	mov    0xc(%eax),%eax
80104686:	83 c0 0c             	add    $0xc,%eax
80104689:	39 c2                	cmp    %eax,%edx
8010468b:	73 1c                	jae    801046a9 <init_buddy_pmm+0xa6>
8010468d:	68 58 b4 10 80       	push   $0x8010b458
80104692:	68 f8 b0 10 80       	push   $0x8010b0f8
80104697:	68 52 01 00 00       	push   $0x152
8010469c:	68 0e b1 10 80       	push   $0x8010b10e
801046a1:	e8 ae bc ff ff       	call   80100354 <__panic>
801046a6:	83 c4 10             	add    $0x10,%esp

    int32_t i; 
    uint8_t node_size = 1 ; // fastlog2(buddy->size * 2);
801046a9:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
    assert((node_size & 0x80) == 0);
801046ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
801046b1:	84 c0                	test   %al,%al
801046b3:	79 1c                	jns    801046d1 <init_buddy_pmm+0xce>
801046b5:	68 8f b4 10 80       	push   $0x8010b48f
801046ba:	68 f8 b0 10 80       	push   $0x8010b0f8
801046bf:	68 56 01 00 00       	push   $0x156
801046c4:	68 0e b1 10 80       	push   $0x8010b10e
801046c9:	e8 86 bc ff ff       	call   80100354 <__panic>
801046ce:	83 c4 10             	add    $0x10,%esp
    for( i = buddy->size * 2 - 2 ; i >= 0 ; i --)
801046d1:	a1 88 70 12 80       	mov    0x80127088,%eax
801046d6:	8b 40 0c             	mov    0xc(%eax),%eax
801046d9:	05 ff ff ff 7f       	add    $0x7fffffff,%eax
801046de:	01 c0                	add    %eax,%eax
801046e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046e3:	e9 d2 00 00 00       	jmp    801047ba <init_buddy_pmm+0x1b7>
    {
        uint32_t page_off;
         

        BUDDY_REF(i) = 0;
801046e8:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
801046ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046f1:	89 d0                	mov    %edx,%eax
801046f3:	c1 e0 03             	shl    $0x3,%eax
801046f6:	01 d0                	add    %edx,%eax
801046f8:	01 c0                	add    %eax,%eax
801046fa:	01 c8                	add    %ecx,%eax
801046fc:	83 c0 1d             	add    $0x1d,%eax
801046ff:	c6 00 00             	movb   $0x0,(%eax)
        if(i < buddy->size - 1)
80104702:	a1 88 70 12 80       	mov    0x80127088,%eax
80104707:	8b 40 0c             	mov    0xc(%eax),%eax
8010470a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104710:	39 c2                	cmp    %eax,%edx
80104712:	76 16                	jbe    8010472a <init_buddy_pmm+0x127>
        {
            adjust_i(i, node_size);
80104714:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
80104718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471b:	83 ec 08             	sub    $0x8,%esp
8010471e:	52                   	push   %edx
8010471f:	50                   	push   %eax
80104720:	e8 49 f0 ff ff       	call   8010376e <adjust_i>
80104725:	83 c4 10             	add    $0x10,%esp
80104728:	eb 7b                	jmp    801047a5 <init_buddy_pmm+0x1a2>
        }else{

            BUDDY_VAL(i) = (node_size & 0x7f);
8010472a:	8b 1d 88 70 12 80    	mov    0x80127088,%ebx
80104730:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80104734:	83 e0 7f             	and    $0x7f,%eax
80104737:	89 c1                	mov    %eax,%ecx
80104739:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010473c:	89 d0                	mov    %edx,%eax
8010473e:	c1 e0 03             	shl    $0x3,%eax
80104741:	01 d0                	add    %edx,%eax
80104743:	01 c0                	add    %eax,%eax
80104745:	01 d8                	add    %ebx,%eax
80104747:	83 c0 1c             	add    $0x1c,%eax
8010474a:	88 08                	mov    %cl,(%eax)
            page_off = i2page_off(i,1);
8010474c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474f:	83 ec 08             	sub    $0x8,%esp
80104752:	6a 01                	push   $0x1
80104754:	50                   	push   %eax
80104755:	e8 ba ef ff ff       	call   80103714 <i2page_off>
8010475a:	83 c4 10             	add    $0x10,%esp
8010475d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if(page_off  >= buddy->pg_size)
80104760:	a1 88 70 12 80       	mov    0x80127088,%eax
80104765:	8b 40 08             	mov    0x8(%eax),%eax
80104768:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010476b:	77 38                	ja     801047a5 <init_buddy_pmm+0x1a2>
            {
                BUDDY_VAL(i) |= 1 << INVALID;
8010476d:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
80104773:	8b 1d 88 70 12 80    	mov    0x80127088,%ebx
80104779:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010477c:	89 d0                	mov    %edx,%eax
8010477e:	c1 e0 03             	shl    $0x3,%eax
80104781:	01 d0                	add    %edx,%eax
80104783:	01 c0                	add    %eax,%eax
80104785:	01 d8                	add    %ebx,%eax
80104787:	83 c0 1c             	add    $0x1c,%eax
8010478a:	0f b6 00             	movzbl (%eax),%eax
8010478d:	83 c8 80             	or     $0xffffff80,%eax
80104790:	89 c3                	mov    %eax,%ebx
80104792:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104795:	89 d0                	mov    %edx,%eax
80104797:	c1 e0 03             	shl    $0x3,%eax
8010479a:	01 d0                	add    %edx,%eax
8010479c:	01 c0                	add    %eax,%eax
8010479e:	01 c8                	add    %ecx,%eax
801047a0:	83 c0 1c             	add    $0x1c,%eax
801047a3:	88 18                	mov    %bl,(%eax)
            }
        }
        if(IS_POWER_OF_2(i + 1))
801047a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a8:	83 c0 01             	add    $0x1,%eax
801047ab:	23 45 f4             	and    -0xc(%ebp),%eax
801047ae:	85 c0                	test   %eax,%eax
801047b0:	75 04                	jne    801047b6 <init_buddy_pmm+0x1b3>
        {
            node_size += 1;
801047b2:	80 45 f3 01          	addb   $0x1,-0xd(%ebp)
    assert(buddy->beginning_addr - *p_start >= (buddy->size + 12));

    int32_t i; 
    uint8_t node_size = 1 ; // fastlog2(buddy->size * 2);
    assert((node_size & 0x80) == 0);
    for( i = buddy->size * 2 - 2 ; i >= 0 ; i --)
801047b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801047ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047be:	0f 89 24 ff ff ff    	jns    801046e8 <init_buddy_pmm+0xe5>
        {
            node_size += 1;
        }
    }

    assert(node_size == fastlog2(buddy->size * 2) + 1);
801047c4:	0f b6 5d f3          	movzbl -0xd(%ebp),%ebx
801047c8:	a1 88 70 12 80       	mov    0x80127088,%eax
801047cd:	8b 40 0c             	mov    0xc(%eax),%eax
801047d0:	01 c0                	add    %eax,%eax
801047d2:	83 ec 0c             	sub    $0xc,%esp
801047d5:	50                   	push   %eax
801047d6:	e8 d2 ed ff ff       	call   801035ad <fastlog2>
801047db:	83 c4 10             	add    $0x10,%esp
801047de:	0f b6 c0             	movzbl %al,%eax
801047e1:	83 c0 01             	add    $0x1,%eax
801047e4:	39 c3                	cmp    %eax,%ebx
801047e6:	74 1c                	je     80104804 <init_buddy_pmm+0x201>
801047e8:	68 a8 b4 10 80       	push   $0x8010b4a8
801047ed:	68 f8 b0 10 80       	push   $0x8010b0f8
801047f2:	68 6f 01 00 00       	push   $0x16f
801047f7:	68 0e b1 10 80       	push   $0x8010b10e
801047fc:	e8 53 bb ff ff       	call   80100354 <__panic>
80104801:	83 c4 10             	add    $0x10,%esp
    INIT_LOCK;
80104804:	a1 88 70 12 80       	mov    0x80127088,%eax
80104809:	83 c0 10             	add    $0x10,%eax
8010480c:	83 ec 08             	sub    $0x8,%esp
8010480f:	68 d3 b4 10 80       	push   $0x8010b4d3
80104814:	50                   	push   %eax
80104815:	e8 7f 2f 00 00       	call   80107799 <init_lock>
8010481a:	83 c4 10             	add    $0x10,%esp
    buddy_pmm_test(*p_start);
8010481d:	8b 45 08             	mov    0x8(%ebp),%eax
80104820:	8b 00                	mov    (%eax),%eax
80104822:	83 ec 0c             	sub    $0xc,%esp
80104825:	50                   	push   %eax
80104826:	e8 fb f5 ff ff       	call   80103e26 <buddy_pmm_test>
8010482b:	83 c4 10             	add    $0x10,%esp
         
    *p_start = buddy->beginning_addr;
8010482e:	a1 88 70 12 80       	mov    0x80127088,%eax
80104833:	8b 10                	mov    (%eax),%edx
80104835:	8b 45 08             	mov    0x8(%ebp),%eax
80104838:	89 10                	mov    %edx,(%eax)
    *pg_size = buddy->pg_size;
8010483a:	a1 88 70 12 80       	mov    0x80127088,%eax
8010483f:	8b 50 08             	mov    0x8(%eax),%edx
80104842:	8b 45 0c             	mov    0xc(%ebp),%eax
80104845:	89 10                	mov    %edx,(%eax)
    cprintf(INITOK"buddy init ok!\n");
80104847:	83 ec 0c             	sub    $0xc,%esp
8010484a:	68 e0 b4 10 80       	push   $0x8010b4e0
8010484f:	e8 83 24 00 00       	call   80106cd7 <cprintf>
80104854:	83 c4 10             	add    $0x10,%esp
}
80104857:	90                   	nop
80104858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010485b:	c9                   	leave  
8010485c:	c3                   	ret    

8010485d <buddy_pmm_free_pages>:

static size_t
buddy_pmm_free_pages()
{
8010485d:	55                   	push   %ebp
8010485e:	89 e5                	mov    %esp,%ebp
80104860:	83 ec 18             	sub    $0x18,%esp
    size_t t;
    ACQUIRE;
80104863:	a1 88 70 12 80       	mov    0x80127088,%eax
80104868:	83 c0 10             	add    $0x10,%eax
8010486b:	83 ec 0c             	sub    $0xc,%esp
8010486e:	50                   	push   %eax
8010486f:	e8 47 2f 00 00       	call   801077bb <acquire>
80104874:	83 c4 10             	add    $0x10,%esp
    t = buddy->free_pg;
80104877:	a1 88 70 12 80       	mov    0x80127088,%eax
8010487c:	8b 40 04             	mov    0x4(%eax),%eax
8010487f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    RELEASE;
80104882:	a1 88 70 12 80       	mov    0x80127088,%eax
80104887:	83 c0 10             	add    $0x10,%eax
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	50                   	push   %eax
8010488e:	e8 87 2f 00 00       	call   8010781a <release>
80104893:	83 c4 10             	add    $0x10,%esp
    return t;
80104896:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104899:	c9                   	leave  
8010489a:	c3                   	ret    

8010489b <buddy_pmm_ret_page_addr>:

static struct page*
buddy_pmm_ret_page_addr(size_t offset)
{
8010489b:	55                   	push   %ebp
8010489c:	89 e5                	mov    %esp,%ebp
8010489e:	83 ec 08             	sub    $0x8,%esp
    assert(offset <= (buddy->size / 2)); 
801048a1:	a1 88 70 12 80       	mov    0x80127088,%eax
801048a6:	8b 40 0c             	mov    0xc(%eax),%eax
801048a9:	d1 e8                	shr    %eax
801048ab:	3b 45 08             	cmp    0x8(%ebp),%eax
801048ae:	73 1c                	jae    801048cc <buddy_pmm_ret_page_addr+0x31>
801048b0:	68 fb b4 10 80       	push   $0x8010b4fb
801048b5:	68 f8 b0 10 80       	push   $0x8010b0f8
801048ba:	68 85 01 00 00       	push   $0x185
801048bf:	68 0e b1 10 80       	push   $0x8010b10e
801048c4:	e8 8b ba ff ff       	call   80100354 <__panic>
801048c9:	83 c4 10             	add    $0x10,%esp
    return BUDDY_PAGE_ADDR(buddy->size / 2 + offset);
801048cc:	8b 0d 88 70 12 80    	mov    0x80127088,%ecx
801048d2:	a1 88 70 12 80       	mov    0x80127088,%eax
801048d7:	8b 40 0c             	mov    0xc(%eax),%eax
801048da:	d1 e8                	shr    %eax
801048dc:	89 c2                	mov    %eax,%edx
801048de:	8b 45 08             	mov    0x8(%ebp),%eax
801048e1:	01 c2                	add    %eax,%edx
801048e3:	89 d0                	mov    %edx,%eax
801048e5:	c1 e0 03             	shl    $0x3,%eax
801048e8:	01 d0                	add    %edx,%eax
801048ea:	01 c0                	add    %eax,%eax
801048ec:	83 c0 10             	add    $0x10,%eax
801048ef:	01 c8                	add    %ecx,%eax
801048f1:	83 c0 0c             	add    $0xc,%eax
}
801048f4:	c9                   	leave  
801048f5:	c3                   	ret    

801048f6 <kmm_cache_create>:
static kmm_status get_status(kmm_slab_t slab);


kmm_cache_t
kmm_cache_create(const char *name,size_t size)
{
801048f6:	55                   	push   %ebp
801048f7:	89 e5                	mov    %esp,%ebp
801048f9:	83 ec 18             	sub    $0x18,%esp
    kmm_cache_t t = (kmm_cache_t)MALLOC(sizeof(struct kmm_cache));
801048fc:	83 ec 0c             	sub    $0xc,%esp
801048ff:	6a 78                	push   $0x78
80104901:	e8 29 e4 ff ff       	call   80102d2f <kmalloc>
80104906:	83 c4 10             	add    $0x10,%esp
80104909:	89 45 f0             	mov    %eax,-0x10(%ebp)
    size_t i;
    if(!t) return NULL;
8010490c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104910:	75 0a                	jne    8010491c <kmm_cache_create+0x26>
80104912:	b8 00 00 00 00       	mov    $0x0,%eax
80104917:	e9 cd 00 00 00       	jmp    801049e9 <kmm_cache_create+0xf3>
    t->size = size;
8010491c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104922:	89 50 04             	mov    %edx,0x4(%eax)
    t->name = name;
80104925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104928:	8b 55 08             	mov    0x8(%ebp),%edx
8010492b:	89 10                	mov    %edx,(%eax)
    for(i = 0 ; i < NCPU ; i ++)
8010492d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104934:	e9 a3 00 00 00       	jmp    801049dc <kmm_cache_create+0xe6>
    {
        list_init(&t->slab_list_cpu[i].slab_used);
80104939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493c:	89 c2                	mov    %eax,%edx
8010493e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104945:	89 c2                	mov    %eax,%edx
80104947:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
8010494e:	29 d0                	sub    %edx,%eax
80104950:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104953:	01 d0                	add    %edx,%eax
80104955:	83 c0 08             	add    $0x8,%eax
80104958:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
8010495b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010495e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104961:	89 50 04             	mov    %edx,0x4(%eax)
80104964:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104967:	8b 50 04             	mov    0x4(%eax),%edx
8010496a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010496d:	89 10                	mov    %edx,(%eax)
        list_init(&t->slab_list_cpu[i].slab_free);
8010496f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104972:	89 c2                	mov    %eax,%edx
80104974:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
8010497b:	89 c2                	mov    %eax,%edx
8010497d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104984:	29 d0                	sub    %edx,%eax
80104986:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104989:	01 d0                	add    %edx,%eax
8010498b:	83 c0 10             	add    $0x10,%eax
8010498e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104991:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104994:	8b 55 e8             	mov    -0x18(%ebp),%edx
80104997:	89 50 04             	mov    %edx,0x4(%eax)
8010499a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010499d:	8b 50 04             	mov    0x4(%eax),%edx
801049a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049a3:	89 10                	mov    %edx,(%eax)
        init_lock(&t->slab_list_cpu[i].lock, "slab");
801049a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a8:	89 c2                	mov    %eax,%edx
801049aa:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801049b1:	89 c2                	mov    %eax,%edx
801049b3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
801049ba:	29 d0                	sub    %edx,%eax
801049bc:	8d 50 10             	lea    0x10(%eax),%edx
801049bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c2:	01 d0                	add    %edx,%eax
801049c4:	83 c0 08             	add    $0x8,%eax
801049c7:	83 ec 08             	sub    $0x8,%esp
801049ca:	68 4c b5 10 80       	push   $0x8010b54c
801049cf:	50                   	push   %eax
801049d0:	e8 c4 2d 00 00       	call   80107799 <init_lock>
801049d5:	83 c4 10             	add    $0x10,%esp
    kmm_cache_t t = (kmm_cache_t)MALLOC(sizeof(struct kmm_cache));
    size_t i;
    if(!t) return NULL;
    t->size = size;
    t->name = name;
    for(i = 0 ; i < NCPU ; i ++)
801049d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801049dc:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
801049e0:	0f 86 53 ff ff ff    	jbe    80104939 <kmm_cache_create+0x43>
    {
        list_init(&t->slab_list_cpu[i].slab_used);
        list_init(&t->slab_list_cpu[i].slab_free);
        init_lock(&t->slab_list_cpu[i].lock, "slab");
    }
    return t;
801049e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801049e9:	c9                   	leave  
801049ea:	c3                   	ret    

801049eb <kmm_cache_destroy>:

bool
kmm_cache_destroy(kmm_cache_t cache)
{
801049eb:	55                   	push   %ebp
801049ec:	89 e5                	mov    %esp,%ebp
801049ee:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *l_used = &cache->slab_list_cpu[get_cpu()].slab_used;
801049f1:	e8 75 1b 00 00       	call   8010656b <get_cpu>
801049f6:	89 c2                	mov    %eax,%edx
801049f8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801049ff:	89 c2                	mov    %eax,%edx
80104a01:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104a08:	29 d0                	sub    %edx,%eax
80104a0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a0d:	01 d0                	add    %edx,%eax
80104a0f:	83 c0 08             	add    $0x8,%eax
80104a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *l_free = &cache->slab_list_cpu[get_cpu()].slab_free;
80104a15:	e8 51 1b 00 00       	call   8010656b <get_cpu>
80104a1a:	89 c2                	mov    %eax,%edx
80104a1c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104a23:	89 c2                	mov    %eax,%edx
80104a25:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104a2c:	29 d0                	sub    %edx,%eax
80104a2e:	8b 55 08             	mov    0x8(%ebp),%edx
80104a31:	01 d0                	add    %edx,%eax
80104a33:	83 c0 10             	add    $0x10,%eax
80104a36:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a3c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
80104a3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a42:	8b 40 04             	mov    0x4(%eax),%eax
80104a45:	39 45 dc             	cmp    %eax,-0x24(%ebp)
80104a48:	0f 94 c0             	sete   %al
80104a4b:	0f b6 c0             	movzbl %al,%eax
    list_entry_t *le,*tmp;
    assert(list_empty(l_used));
80104a4e:	85 c0                	test   %eax,%eax
80104a50:	75 19                	jne    80104a6b <kmm_cache_destroy+0x80>
80104a52:	68 51 b5 10 80       	push   $0x8010b551
80104a57:	68 64 b5 10 80       	push   $0x8010b564
80104a5c:	6a 33                	push   $0x33
80104a5e:	68 7a b5 10 80       	push   $0x8010b57a
80104a63:	e8 ec b8 ff ff       	call   80100354 <__panic>
80104a68:	83 c4 10             	add    $0x10,%esp
80104a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a74:	8b 40 04             	mov    0x4(%eax),%eax
80104a77:	39 45 e8             	cmp    %eax,-0x18(%ebp)
80104a7a:	0f 94 c0             	sete   %al
80104a7d:	0f b6 c0             	movzbl %al,%eax
    if(!list_empty(l_free)){
80104a80:	85 c0                	test   %eax,%eax
80104a82:	75 5c                	jne    80104ae0 <kmm_cache_destroy+0xf5>
        le = l_free->next; 
80104a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a87:	8b 40 04             	mov    0x4(%eax),%eax
80104a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(le != l_free)
80104a8d:	eb 49                	jmp    80104ad8 <kmm_cache_destroy+0xed>
        {
            tmp = le;
80104a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a92:	89 45 e0             	mov    %eax,-0x20(%ebp)
            le = le->next;
80104a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a98:	8b 40 04             	mov    0x4(%eax),%eax
80104a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aa1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80104aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104aa7:	8b 40 04             	mov    0x4(%eax),%eax
80104aaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104aad:	8b 12                	mov    (%edx),%edx
80104aaf:	89 55 d8             	mov    %edx,-0x28(%ebp)
80104ab2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80104ab5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104ab8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104abb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80104abe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ac1:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104ac4:	89 10                	mov    %edx,(%eax)
            list_del(tmp);
            kmm_slab_destroy(to_slab(tmp));
80104ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ac9:	83 e8 10             	sub    $0x10,%eax
80104acc:	83 ec 0c             	sub    $0xc,%esp
80104acf:	50                   	push   %eax
80104ad0:	e8 20 00 00 00       	call   80104af5 <kmm_slab_destroy>
80104ad5:	83 c4 10             	add    $0x10,%esp
    list_entry_t *l_free = &cache->slab_list_cpu[get_cpu()].slab_free;
    list_entry_t *le,*tmp;
    assert(list_empty(l_used));
    if(!list_empty(l_free)){
        le = l_free->next; 
        while(le != l_free)
80104ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104adb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104ade:	75 af                	jne    80104a8f <kmm_cache_destroy+0xa4>
            le = le->next;
            list_del(tmp);
            kmm_slab_destroy(to_slab(tmp));
        }
    }
    FREE(cache);
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	ff 75 08             	pushl  0x8(%ebp)
80104ae6:	e8 04 e2 ff ff       	call   80102cef <kfree>
80104aeb:	83 c4 10             	add    $0x10,%esp
    return true;
80104aee:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104af3:	c9                   	leave  
80104af4:	c3                   	ret    

80104af5 <kmm_slab_destroy>:

void
kmm_slab_destroy(kmm_slab_t slab)
{
80104af5:	55                   	push   %ebp
80104af6:	89 e5                	mov    %esp,%ebp
80104af8:	53                   	push   %ebx
80104af9:	83 ec 24             	sub    $0x24,%esp
    ACQUIRE_SLAB(slab);
80104afc:	8b 45 08             	mov    0x8(%ebp),%eax
80104aff:	8b 58 04             	mov    0x4(%eax),%ebx
80104b02:	e8 64 1a 00 00       	call   8010656b <get_cpu>
80104b07:	89 c2                	mov    %eax,%edx
80104b09:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104b10:	89 c2                	mov    %eax,%edx
80104b12:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104b19:	29 d0                	sub    %edx,%eax
80104b1b:	83 c0 10             	add    $0x10,%eax
80104b1e:	01 d8                	add    %ebx,%eax
80104b20:	83 c0 08             	add    $0x8,%eax
80104b23:	83 ec 0c             	sub    $0xc,%esp
80104b26:	50                   	push   %eax
80104b27:	e8 8f 2c 00 00       	call   801077bb <acquire>
80104b2c:	83 c4 10             	add    $0x10,%esp
    assert(slab->status == KMM_FREE_LIST);
80104b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80104b32:	8b 00                	mov    (%eax),%eax
80104b34:	83 f8 02             	cmp    $0x2,%eax
80104b37:	74 19                	je     80104b52 <kmm_slab_destroy+0x5d>
80104b39:	68 89 b5 10 80       	push   $0x8010b589
80104b3e:	68 64 b5 10 80       	push   $0x8010b564
80104b43:	6a 46                	push   $0x46
80104b45:	68 7a b5 10 80       	push   $0x8010b57a
80104b4a:	e8 05 b8 ff ff       	call   80100354 <__panic>
80104b4f:	83 c4 10             	add    $0x10,%esp
    list_del_init(&slab->list);
80104b52:	8b 45 08             	mov    0x8(%ebp),%eax
80104b55:	83 c0 10             	add    $0x10,%eax
80104b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80104b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b64:	8b 40 04             	mov    0x4(%eax),%eax
80104b67:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b6a:	8b 12                	mov    (%edx),%edx
80104b6c:	89 55 ec             	mov    %edx,-0x14(%ebp)
80104b6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80104b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b75:	8b 55 e8             	mov    -0x18(%ebp),%edx
80104b78:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80104b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b81:	89 10                	mov    %edx,(%eax)
80104b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80104b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b8f:	89 50 04             	mov    %edx,0x4(%eax)
80104b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b95:	8b 50 04             	mov    0x4(%eax),%edx
80104b98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b9b:	89 10                	mov    %edx,(%eax)
    FREE(slab->buffer);
80104b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80104ba0:	8b 40 0c             	mov    0xc(%eax),%eax
80104ba3:	83 ec 0c             	sub    $0xc,%esp
80104ba6:	50                   	push   %eax
80104ba7:	e8 43 e1 ff ff       	call   80102cef <kfree>
80104bac:	83 c4 10             	add    $0x10,%esp
    FREE(slab);
80104baf:	83 ec 0c             	sub    $0xc,%esp
80104bb2:	ff 75 08             	pushl  0x8(%ebp)
80104bb5:	e8 35 e1 ff ff       	call   80102cef <kfree>
80104bba:	83 c4 10             	add    $0x10,%esp
    RELEASE_SLAB(slab);
80104bbd:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc0:	8b 58 04             	mov    0x4(%eax),%ebx
80104bc3:	e8 a3 19 00 00       	call   8010656b <get_cpu>
80104bc8:	89 c2                	mov    %eax,%edx
80104bca:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104bd1:	89 c2                	mov    %eax,%edx
80104bd3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104bda:	29 d0                	sub    %edx,%eax
80104bdc:	83 c0 10             	add    $0x10,%eax
80104bdf:	01 d8                	add    %ebx,%eax
80104be1:	83 c0 08             	add    $0x8,%eax
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	50                   	push   %eax
80104be8:	e8 2d 2c 00 00       	call   8010781a <release>
80104bed:	83 c4 10             	add    $0x10,%esp
}
80104bf0:	90                   	nop
80104bf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf4:	c9                   	leave  
80104bf5:	c3                   	ret    

80104bf6 <kmm_slab_grow>:


bool
kmm_slab_grow(kmm_cache_t cache)
{
80104bf6:	55                   	push   %ebp
80104bf7:	89 e5                	mov    %esp,%ebp
80104bf9:	53                   	push   %ebx
80104bfa:	83 ec 14             	sub    $0x14,%esp
    assert(!HODING_CACHE(cache));
80104bfd:	e8 69 19 00 00       	call   8010656b <get_cpu>
80104c02:	89 c2                	mov    %eax,%edx
80104c04:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104c0b:	89 c2                	mov    %eax,%edx
80104c0d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104c14:	29 d0                	sub    %edx,%eax
80104c16:	8d 50 10             	lea    0x10(%eax),%edx
80104c19:	8b 45 08             	mov    0x8(%ebp),%eax
80104c1c:	01 d0                	add    %edx,%eax
80104c1e:	83 c0 08             	add    $0x8,%eax
80104c21:	83 ec 0c             	sub    $0xc,%esp
80104c24:	50                   	push   %eax
80104c25:	e8 3e 2b 00 00       	call   80107768 <holding>
80104c2a:	83 c4 10             	add    $0x10,%esp
80104c2d:	85 c0                	test   %eax,%eax
80104c2f:	74 19                	je     80104c4a <kmm_slab_grow+0x54>
80104c31:	68 a7 b5 10 80       	push   $0x8010b5a7
80104c36:	68 64 b5 10 80       	push   $0x8010b564
80104c3b:	6a 51                	push   $0x51
80104c3d:	68 7a b5 10 80       	push   $0x8010b57a
80104c42:	e8 0d b7 ff ff       	call   80100354 <__panic>
80104c47:	83 c4 10             	add    $0x10,%esp
    kmm_slab_t slab = (kmm_slab_t)MALLOC(sizeof(struct kmm_slab)); 
80104c4a:	83 ec 0c             	sub    $0xc,%esp
80104c4d:	6a 1c                	push   $0x1c
80104c4f:	e8 db e0 ff ff       	call   80102d2f <kmalloc>
80104c54:	83 c4 10             	add    $0x10,%esp
80104c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    size_t var;
    size_t size = cache->size + sizeof(struct bufctl);
80104c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c5d:	8b 40 04             	mov    0x4(%eax),%eax
80104c60:	83 c0 0c             	add    $0xc,%eax
80104c63:	89 45 ec             	mov    %eax,-0x14(%ebp)

    if(slab == NULL){
80104c66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c6a:	0f 84 32 01 00 00    	je     80104da2 <kmm_slab_grow+0x1ac>
        goto slab_fail;
    } 

    
    slab->cache = cache;
80104c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c73:	8b 55 08             	mov    0x8(%ebp),%edx
80104c76:	89 50 04             	mov    %edx,0x4(%eax)
    if(!(slab->buffer = MALLOC(BUFSIZE)))
80104c79:	83 ec 0c             	sub    $0xc,%esp
80104c7c:	68 00 10 00 00       	push   $0x1000
80104c81:	e8 a9 e0 ff ff       	call   80102d2f <kmalloc>
80104c86:	83 c4 10             	add    $0x10,%esp
80104c89:	89 c2                	mov    %eax,%edx
80104c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c8e:	89 50 0c             	mov    %edx,0xc(%eax)
80104c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c94:	8b 40 0c             	mov    0xc(%eax),%eax
80104c97:	85 c0                	test   %eax,%eax
80104c99:	0f 84 f2 00 00 00    	je     80104d91 <kmm_slab_grow+0x19b>
    {
        goto buf_fail;
    }
    slab->free_count = BUFSIZE / size;
80104c9f:	b8 00 10 00 00       	mov    $0x1000,%eax
80104ca4:	ba 00 00 00 00       	mov    $0x0,%edx
80104ca9:	f7 75 ec             	divl   -0x14(%ebp)
80104cac:	89 c2                	mov    %eax,%edx
80104cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb1:	89 50 08             	mov    %edx,0x8(%eax)
    list_init(&slab->list);
80104cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb7:	83 c0 10             	add    $0x10,%eax
80104cba:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104cc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
80104cc3:	89 50 04             	mov    %edx,0x4(%eax)
80104cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104cc9:	8b 50 04             	mov    0x4(%eax),%edx
80104ccc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104ccf:	89 10                	mov    %edx,(%eax)
    slab->next_free = NULL;
80104cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd4:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    for(var = 0 ; var < slab->free_count ; var ++)
80104cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ce2:	eb 22                	jmp    80104d06 <kmm_slab_grow+0x110>
    {
        kmm_slab_add_buf(slab, slab->buffer + size*var);
80104ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ce7:	8b 50 0c             	mov    0xc(%eax),%edx
80104cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ced:	0f af 45 f4          	imul   -0xc(%ebp),%eax
80104cf1:	01 d0                	add    %edx,%eax
80104cf3:	83 ec 08             	sub    $0x8,%esp
80104cf6:	50                   	push   %eax
80104cf7:	ff 75 f0             	pushl  -0x10(%ebp)
80104cfa:	e8 ae 00 00 00       	call   80104dad <kmm_slab_add_buf>
80104cff:	83 c4 10             	add    $0x10,%esp
        goto buf_fail;
    }
    slab->free_count = BUFSIZE / size;
    list_init(&slab->list);
    slab->next_free = NULL;
    for(var = 0 ; var < slab->free_count ; var ++)
80104d02:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d09:	8b 40 08             	mov    0x8(%eax),%eax
80104d0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104d0f:	77 d3                	ja     80104ce4 <kmm_slab_grow+0xee>
    {
        kmm_slab_add_buf(slab, slab->buffer + size*var);
    }
    ACQUIRE_SLAB(slab);
80104d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d14:	8b 58 04             	mov    0x4(%eax),%ebx
80104d17:	e8 4f 18 00 00       	call   8010656b <get_cpu>
80104d1c:	89 c2                	mov    %eax,%edx
80104d1e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104d25:	89 c2                	mov    %eax,%edx
80104d27:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104d2e:	29 d0                	sub    %edx,%eax
80104d30:	83 c0 10             	add    $0x10,%eax
80104d33:	01 d8                	add    %ebx,%eax
80104d35:	83 c0 08             	add    $0x8,%eax
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	50                   	push   %eax
80104d3c:	e8 7a 2a 00 00       	call   801077bb <acquire>
80104d41:	83 c4 10             	add    $0x10,%esp
    adjust_slab_list(cache, slab, KMM_FREE_LIST);
80104d44:	83 ec 04             	sub    $0x4,%esp
80104d47:	6a 02                	push   $0x2
80104d49:	ff 75 f0             	pushl  -0x10(%ebp)
80104d4c:	ff 75 08             	pushl  0x8(%ebp)
80104d4f:	e8 e5 00 00 00       	call   80104e39 <adjust_slab_list>
80104d54:	83 c4 10             	add    $0x10,%esp
    RELEASE_SLAB(slab);
80104d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d5a:	8b 58 04             	mov    0x4(%eax),%ebx
80104d5d:	e8 09 18 00 00       	call   8010656b <get_cpu>
80104d62:	89 c2                	mov    %eax,%edx
80104d64:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104d6b:	89 c2                	mov    %eax,%edx
80104d6d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104d74:	29 d0                	sub    %edx,%eax
80104d76:	83 c0 10             	add    $0x10,%eax
80104d79:	01 d8                	add    %ebx,%eax
80104d7b:	83 c0 08             	add    $0x8,%eax
80104d7e:	83 ec 0c             	sub    $0xc,%esp
80104d81:	50                   	push   %eax
80104d82:	e8 93 2a 00 00       	call   8010781a <release>
80104d87:	83 c4 10             	add    $0x10,%esp
    return true;
80104d8a:	b8 01 00 00 00       	mov    $0x1,%eax
80104d8f:	eb 17                	jmp    80104da8 <kmm_slab_grow+0x1b2>

    
    slab->cache = cache;
    if(!(slab->buffer = MALLOC(BUFSIZE)))
    {
        goto buf_fail;
80104d91:	90                   	nop
    ACQUIRE_SLAB(slab);
    adjust_slab_list(cache, slab, KMM_FREE_LIST);
    RELEASE_SLAB(slab);
    return true;
buf_fail:
    FREE(slab);
80104d92:	83 ec 0c             	sub    $0xc,%esp
80104d95:	ff 75 f0             	pushl  -0x10(%ebp)
80104d98:	e8 52 df ff ff       	call   80102cef <kfree>
80104d9d:	83 c4 10             	add    $0x10,%esp
80104da0:	eb 01                	jmp    80104da3 <kmm_slab_grow+0x1ad>
    kmm_slab_t slab = (kmm_slab_t)MALLOC(sizeof(struct kmm_slab)); 
    size_t var;
    size_t size = cache->size + sizeof(struct bufctl);

    if(slab == NULL){
        goto slab_fail;
80104da2:	90                   	nop
    RELEASE_SLAB(slab);
    return true;
buf_fail:
    FREE(slab);
slab_fail:
    return false;
80104da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104da8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dab:	c9                   	leave  
80104dac:	c3                   	ret    

80104dad <kmm_slab_add_buf>:

static void
kmm_slab_add_buf(kmm_slab_t slab, void *addr)
{
80104dad:	55                   	push   %ebp
80104dae:	89 e5                	mov    %esp,%ebp
80104db0:	53                   	push   %ebx
80104db1:	83 ec 14             	sub    $0x14,%esp
   assert(!HODING_SLAB(slab));
80104db4:	8b 45 08             	mov    0x8(%ebp),%eax
80104db7:	8b 58 04             	mov    0x4(%eax),%ebx
80104dba:	e8 ac 17 00 00       	call   8010656b <get_cpu>
80104dbf:	89 c2                	mov    %eax,%edx
80104dc1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104dc8:	89 c2                	mov    %eax,%edx
80104dca:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104dd1:	29 d0                	sub    %edx,%eax
80104dd3:	83 c0 10             	add    $0x10,%eax
80104dd6:	01 d8                	add    %ebx,%eax
80104dd8:	83 c0 08             	add    $0x8,%eax
80104ddb:	83 ec 0c             	sub    $0xc,%esp
80104dde:	50                   	push   %eax
80104ddf:	e8 84 29 00 00       	call   80107768 <holding>
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	85 c0                	test   %eax,%eax
80104de9:	74 19                	je     80104e04 <kmm_slab_add_buf+0x57>
80104deb:	68 bc b5 10 80       	push   $0x8010b5bc
80104df0:	68 64 b5 10 80       	push   $0x8010b564
80104df5:	6a 74                	push   $0x74
80104df7:	68 7a b5 10 80       	push   $0x8010b57a
80104dfc:	e8 53 b5 ff ff       	call   80100354 <__panic>
80104e01:	83 c4 10             	add    $0x10,%esp
   bufctl_t buf = (bufctl_t)addr;  
80104e04:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
   buf->slab = slab;
80104e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e10:	89 50 04             	mov    %edx,0x4(%eax)
   buf->addr = (buf + 1);
80104e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e16:	8d 50 0c             	lea    0xc(%eax),%edx
80104e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1c:	89 50 08             	mov    %edx,0x8(%eax)
   buf->next = slab->next_free;
80104e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e22:	8b 50 18             	mov    0x18(%eax),%edx
80104e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e28:	89 10                	mov    %edx,(%eax)
   slab->next_free = buf;
80104e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e30:	89 50 18             	mov    %edx,0x18(%eax)
}
80104e33:	90                   	nop
80104e34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e37:	c9                   	leave  
80104e38:	c3                   	ret    

80104e39 <adjust_slab_list>:

static void
adjust_slab_list(kmm_cache_t cache, kmm_slab_t slab, kmm_status status)
{
80104e39:	55                   	push   %ebp
80104e3a:	89 e5                	mov    %esp,%ebp
80104e3c:	53                   	push   %ebx
80104e3d:	83 ec 34             	sub    $0x34,%esp
    assert(HODING_SLAB(slab));
80104e40:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e43:	8b 58 04             	mov    0x4(%eax),%ebx
80104e46:	e8 20 17 00 00       	call   8010656b <get_cpu>
80104e4b:	89 c2                	mov    %eax,%edx
80104e4d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104e54:	89 c2                	mov    %eax,%edx
80104e56:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104e5d:	29 d0                	sub    %edx,%eax
80104e5f:	83 c0 10             	add    $0x10,%eax
80104e62:	01 d8                	add    %ebx,%eax
80104e64:	83 c0 08             	add    $0x8,%eax
80104e67:	83 ec 0c             	sub    $0xc,%esp
80104e6a:	50                   	push   %eax
80104e6b:	e8 f8 28 00 00       	call   80107768 <holding>
80104e70:	83 c4 10             	add    $0x10,%esp
80104e73:	85 c0                	test   %eax,%eax
80104e75:	75 19                	jne    80104e90 <adjust_slab_list+0x57>
80104e77:	68 cf b5 10 80       	push   $0x8010b5cf
80104e7c:	68 64 b5 10 80       	push   $0x8010b564
80104e81:	6a 7f                	push   $0x7f
80104e83:	68 7a b5 10 80       	push   $0x8010b57a
80104e88:	e8 c7 b4 ff ff       	call   80100354 <__panic>
80104e8d:	83 c4 10             	add    $0x10,%esp
    list_entry_t *l_head;
    size_t i_cpu = get_cpu();
80104e90:	e8 d6 16 00 00       	call   8010656b <get_cpu>
80104e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(slab && cache);
80104e98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e9c:	74 06                	je     80104ea4 <adjust_slab_list+0x6b>
80104e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104ea2:	75 1c                	jne    80104ec0 <adjust_slab_list+0x87>
80104ea4:	68 e1 b5 10 80       	push   $0x8010b5e1
80104ea9:	68 64 b5 10 80       	push   $0x8010b564
80104eae:	68 82 00 00 00       	push   $0x82
80104eb3:	68 7a b5 10 80       	push   $0x8010b57a
80104eb8:	e8 97 b4 ff ff       	call   80100354 <__panic>
80104ebd:	83 c4 10             	add    $0x10,%esp
    slab->status = status;
80104ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec3:	8b 55 10             	mov    0x10(%ebp),%edx
80104ec6:	89 10                	mov    %edx,(%eax)
    switch(status)
80104ec8:	8b 45 10             	mov    0x10(%ebp),%eax
80104ecb:	83 f8 01             	cmp    $0x1,%eax
80104ece:	74 0c                	je     80104edc <adjust_slab_list+0xa3>
80104ed0:	83 f8 01             	cmp    $0x1,%eax
80104ed3:	72 4f                	jb     80104f24 <adjust_slab_list+0xeb>
80104ed5:	83 f8 02             	cmp    $0x2,%eax
80104ed8:	74 26                	je     80104f00 <adjust_slab_list+0xc7>
80104eda:	eb 51                	jmp    80104f2d <adjust_slab_list+0xf4>
    {
        case KMM_USED_LIST:
            l_head = &cache->slab_list_cpu[i_cpu].slab_used;
80104edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104edf:	89 c2                	mov    %eax,%edx
80104ee1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104ee8:	89 c2                	mov    %eax,%edx
80104eea:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104ef1:	29 d0                	sub    %edx,%eax
80104ef3:	8b 55 08             	mov    0x8(%ebp),%edx
80104ef6:	01 d0                	add    %edx,%eax
80104ef8:	83 c0 08             	add    $0x8,%eax
80104efb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
80104efe:	eb 47                	jmp    80104f47 <adjust_slab_list+0x10e>
        case KMM_FREE_LIST:
            l_head = &cache->slab_list_cpu[i_cpu].slab_free;
80104f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f03:	89 c2                	mov    %eax,%edx
80104f05:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80104f0c:	89 c2                	mov    %eax,%edx
80104f0e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80104f15:	29 d0                	sub    %edx,%eax
80104f17:	8b 55 08             	mov    0x8(%ebp),%edx
80104f1a:	01 d0                	add    %edx,%eax
80104f1c:	83 c0 10             	add    $0x10,%eax
80104f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
80104f22:	eb 23                	jmp    80104f47 <adjust_slab_list+0x10e>
        case KMM_FULL_LIST:
            l_head = NULL;
80104f24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            break;
80104f2b:	eb 1a                	jmp    80104f47 <adjust_slab_list+0x10e>
        default:
            panic("status is unknow");
80104f2d:	83 ec 04             	sub    $0x4,%esp
80104f30:	68 ef b5 10 80       	push   $0x8010b5ef
80104f35:	68 90 00 00 00       	push   $0x90
80104f3a:	68 7a b5 10 80       	push   $0x8010b57a
80104f3f:	e8 10 b4 ff ff       	call   80100354 <__panic>
80104f44:	83 c4 10             	add    $0x10,%esp
    }
    list_del_init(&slab->list);
80104f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f4a:	83 c0 10             	add    $0x10,%eax
80104f4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104f50:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104f53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80104f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f59:	8b 40 04             	mov    0x4(%eax),%eax
80104f5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f5f:	8b 12                	mov    (%edx),%edx
80104f61:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104f64:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80104f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104f6d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80104f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f73:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104f76:	89 10                	mov    %edx,(%eax)
80104f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104f7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80104f7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104f81:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104f84:	89 50 04             	mov    %edx,0x4(%eax)
80104f87:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104f8a:	8b 50 04             	mov    0x4(%eax),%edx
80104f8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104f90:	89 10                	mov    %edx,(%eax)
    if(l_head)
80104f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f96:	74 48                	je     80104fe0 <adjust_slab_list+0x1a7>
    {
        list_add_after(l_head, &slab->list);
80104f98:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f9b:	8d 50 10             	lea    0x10(%eax),%edx
80104f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104fa4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm, listelm->next);
80104fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104faa:	8b 40 04             	mov    0x4(%eax),%eax
80104fad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104fb0:	89 55 d0             	mov    %edx,-0x30(%ebp)
80104fb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104fb6:	89 55 cc             	mov    %edx,-0x34(%ebp)
80104fb9:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
80104fbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104fbf:	8b 55 d0             	mov    -0x30(%ebp),%edx
80104fc2:	89 10                	mov    %edx,(%eax)
80104fc4:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104fc7:	8b 10                	mov    (%eax),%edx
80104fc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104fcc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
80104fcf:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104fd2:	8b 55 c8             	mov    -0x38(%ebp),%edx
80104fd5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
80104fd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104fdb:	8b 55 cc             	mov    -0x34(%ebp),%edx
80104fde:	89 10                	mov    %edx,(%eax)
    }
    slab->cache = cache;
80104fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe3:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe6:	89 50 04             	mov    %edx,0x4(%eax)
}
80104fe9:	90                   	nop
80104fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fed:	c9                   	leave  
80104fee:	c3                   	ret    

80104fef <kmm_alloc>:

void *
kmm_alloc(kmm_cache_t cache)
{
80104fef:	55                   	push   %ebp
80104ff0:	89 e5                	mov    %esp,%ebp
80104ff2:	83 ec 28             	sub    $0x28,%esp
    assert(cache);
80104ff5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104ff9:	75 1c                	jne    80105017 <kmm_alloc+0x28>
80104ffb:	68 00 b6 10 80       	push   $0x8010b600
80105000:	68 64 b5 10 80       	push   $0x8010b564
80105005:	68 9d 00 00 00       	push   $0x9d
8010500a:	68 7a b5 10 80       	push   $0x8010b57a
8010500f:	e8 40 b3 ff ff       	call   80100354 <__panic>
80105014:	83 c4 10             	add    $0x10,%esp
    ACQUIRE_CACHE(cache);
80105017:	e8 4f 15 00 00       	call   8010656b <get_cpu>
8010501c:	89 c2                	mov    %eax,%edx
8010501e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80105025:	89 c2                	mov    %eax,%edx
80105027:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
8010502e:	29 d0                	sub    %edx,%eax
80105030:	8d 50 10             	lea    0x10(%eax),%edx
80105033:	8b 45 08             	mov    0x8(%ebp),%eax
80105036:	01 d0                	add    %edx,%eax
80105038:	83 c0 08             	add    $0x8,%eax
8010503b:	83 ec 0c             	sub    $0xc,%esp
8010503e:	50                   	push   %eax
8010503f:	e8 77 27 00 00       	call   801077bb <acquire>
80105044:	83 c4 10             	add    $0x10,%esp
    list_entry_t *l_used = &cache->slab_list_cpu[get_cpu()].slab_used;
80105047:	e8 1f 15 00 00       	call   8010656b <get_cpu>
8010504c:	89 c2                	mov    %eax,%edx
8010504e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80105055:	89 c2                	mov    %eax,%edx
80105057:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
8010505e:	29 d0                	sub    %edx,%eax
80105060:	8b 55 08             	mov    0x8(%ebp),%edx
80105063:	01 d0                	add    %edx,%eax
80105065:	83 c0 08             	add    $0x8,%eax
80105068:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *l_free = &cache->slab_list_cpu[get_cpu()].slab_free;
8010506b:	e8 fb 14 00 00       	call   8010656b <get_cpu>
80105070:	89 c2                	mov    %eax,%edx
80105072:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80105079:	89 c2                	mov    %eax,%edx
8010507b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105082:	29 d0                	sub    %edx,%eax
80105084:	8b 55 08             	mov    0x8(%ebp),%edx
80105087:	01 d0                	add    %edx,%eax
80105089:	83 c0 10             	add    $0x10,%eax
8010508c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010508f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105092:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
80105095:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105098:	8b 40 04             	mov    0x4(%eax),%eax
8010509b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
8010509e:	0f 94 c0             	sete   %al
801050a1:	0f b6 c0             	movzbl %al,%eax
    kmm_slab_t slab;
    bufctl_t buf;

    if(!list_empty(l_used))
801050a4:	85 c0                	test   %eax,%eax
801050a6:	75 11                	jne    801050b9 <kmm_alloc+0xca>
    {
        slab = to_slab(l_used->next);
801050a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ab:	8b 40 04             	mov    0x4(%eax),%eax
801050ae:	83 e8 10             	sub    $0x10,%eax
801050b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050b4:	e9 b2 00 00 00       	jmp    8010516b <kmm_alloc+0x17c>
801050b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
801050bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801050c2:	8b 40 04             	mov    0x4(%eax),%eax
801050c5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
801050c8:	0f 94 c0             	sete   %al
801050cb:	0f b6 c0             	movzbl %al,%eax
    }else if(!list_empty(l_free))
801050ce:	85 c0                	test   %eax,%eax
801050d0:	75 11                	jne    801050e3 <kmm_alloc+0xf4>
    {
        slab = to_slab(l_free->next);  
801050d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050d5:	8b 40 04             	mov    0x4(%eax),%eax
801050d8:	83 e8 10             	sub    $0x10,%eax
801050db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050de:	e9 88 00 00 00       	jmp    8010516b <kmm_alloc+0x17c>
    }else{
        RELEASE_CACHE(cache);
801050e3:	e8 83 14 00 00       	call   8010656b <get_cpu>
801050e8:	89 c2                	mov    %eax,%edx
801050ea:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801050f1:	89 c2                	mov    %eax,%edx
801050f3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
801050fa:	29 d0                	sub    %edx,%eax
801050fc:	8d 50 10             	lea    0x10(%eax),%edx
801050ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105102:	01 d0                	add    %edx,%eax
80105104:	83 c0 08             	add    $0x8,%eax
80105107:	83 ec 0c             	sub    $0xc,%esp
8010510a:	50                   	push   %eax
8010510b:	e8 0a 27 00 00       	call   8010781a <release>
80105110:	83 c4 10             	add    $0x10,%esp
        if(!kmm_slab_grow(cache))
80105113:	83 ec 0c             	sub    $0xc,%esp
80105116:	ff 75 08             	pushl  0x8(%ebp)
80105119:	e8 d8 fa ff ff       	call   80104bf6 <kmm_slab_grow>
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	85 c0                	test   %eax,%eax
80105123:	75 0a                	jne    8010512f <kmm_alloc+0x140>
        {
            return NULL;
80105125:	b8 00 00 00 00       	mov    $0x0,%eax
8010512a:	e9 9a 00 00 00       	jmp    801051c9 <kmm_alloc+0x1da>
        }
        ACQUIRE_CACHE(cache);
8010512f:	e8 37 14 00 00       	call   8010656b <get_cpu>
80105134:	89 c2                	mov    %eax,%edx
80105136:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
8010513d:	89 c2                	mov    %eax,%edx
8010513f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105146:	29 d0                	sub    %edx,%eax
80105148:	8d 50 10             	lea    0x10(%eax),%edx
8010514b:	8b 45 08             	mov    0x8(%ebp),%eax
8010514e:	01 d0                	add    %edx,%eax
80105150:	83 c0 08             	add    $0x8,%eax
80105153:	83 ec 0c             	sub    $0xc,%esp
80105156:	50                   	push   %eax
80105157:	e8 5f 26 00 00       	call   801077bb <acquire>
8010515c:	83 c4 10             	add    $0x10,%esp
        slab = to_slab(l_free->next);
8010515f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105162:	8b 40 04             	mov    0x4(%eax),%eax
80105165:	83 e8 10             	sub    $0x10,%eax
80105168:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    buf = kmm_pull_buf(slab);
8010516b:	83 ec 0c             	sub    $0xc,%esp
8010516e:	ff 75 f4             	pushl  -0xc(%ebp)
80105171:	e8 54 01 00 00       	call   801052ca <kmm_pull_buf>
80105176:	83 c4 10             	add    $0x10,%esp
80105179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    adjust_slab_list(cache, slab, slab->status);
8010517c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517f:	8b 00                	mov    (%eax),%eax
80105181:	83 ec 04             	sub    $0x4,%esp
80105184:	50                   	push   %eax
80105185:	ff 75 f4             	pushl  -0xc(%ebp)
80105188:	ff 75 08             	pushl  0x8(%ebp)
8010518b:	e8 a9 fc ff ff       	call   80104e39 <adjust_slab_list>
80105190:	83 c4 10             	add    $0x10,%esp
    RELEASE_CACHE(cache);
80105193:	e8 d3 13 00 00       	call   8010656b <get_cpu>
80105198:	89 c2                	mov    %eax,%edx
8010519a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801051a1:	89 c2                	mov    %eax,%edx
801051a3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
801051aa:	29 d0                	sub    %edx,%eax
801051ac:	8d 50 10             	lea    0x10(%eax),%edx
801051af:	8b 45 08             	mov    0x8(%ebp),%eax
801051b2:	01 d0                	add    %edx,%eax
801051b4:	83 c0 08             	add    $0x8,%eax
801051b7:	83 ec 0c             	sub    $0xc,%esp
801051ba:	50                   	push   %eax
801051bb:	e8 5a 26 00 00       	call   8010781a <release>
801051c0:	83 c4 10             	add    $0x10,%esp
    return buf->addr;
801051c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051c6:	8b 40 08             	mov    0x8(%eax),%eax
}
801051c9:	c9                   	leave  
801051ca:	c3                   	ret    

801051cb <get_status>:

inline static kmm_status
get_status(kmm_slab_t slab)
{
801051cb:	55                   	push   %ebp
801051cc:	89 e5                	mov    %esp,%ebp
801051ce:	53                   	push   %ebx
801051cf:	83 ec 14             	sub    $0x14,%esp
    assert(HODING_SLAB(slab));
801051d2:	8b 45 08             	mov    0x8(%ebp),%eax
801051d5:	8b 58 04             	mov    0x4(%eax),%ebx
801051d8:	e8 8e 13 00 00       	call   8010656b <get_cpu>
801051dd:	89 c2                	mov    %eax,%edx
801051df:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801051e6:	89 c2                	mov    %eax,%edx
801051e8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
801051ef:	29 d0                	sub    %edx,%eax
801051f1:	83 c0 10             	add    $0x10,%eax
801051f4:	01 d8                	add    %ebx,%eax
801051f6:	83 c0 08             	add    $0x8,%eax
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 66 25 00 00       	call   80107768 <holding>
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	85 c0                	test   %eax,%eax
80105207:	75 1c                	jne    80105225 <get_status+0x5a>
80105209:	68 cf b5 10 80       	push   $0x8010b5cf
8010520e:	68 64 b5 10 80       	push   $0x8010b564
80105213:	68 bc 00 00 00       	push   $0xbc
80105218:	68 7a b5 10 80       	push   $0x8010b57a
8010521d:	e8 32 b1 ff ff       	call   80100354 <__panic>
80105222:	83 c4 10             	add    $0x10,%esp
    assert(slab && slab->cache);
80105225:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105229:	74 0a                	je     80105235 <get_status+0x6a>
8010522b:	8b 45 08             	mov    0x8(%ebp),%eax
8010522e:	8b 40 04             	mov    0x4(%eax),%eax
80105231:	85 c0                	test   %eax,%eax
80105233:	75 1c                	jne    80105251 <get_status+0x86>
80105235:	68 06 b6 10 80       	push   $0x8010b606
8010523a:	68 64 b5 10 80       	push   $0x8010b564
8010523f:	68 bd 00 00 00       	push   $0xbd
80105244:	68 7a b5 10 80       	push   $0x8010b57a
80105249:	e8 06 b1 ff ff       	call   80100354 <__panic>
8010524e:	83 c4 10             	add    $0x10,%esp
    size_t count = BUFSIZE / (slab->cache->size + sizeof(struct bufctl)); 
80105251:	8b 45 08             	mov    0x8(%ebp),%eax
80105254:	8b 40 04             	mov    0x4(%eax),%eax
80105257:	8b 40 04             	mov    0x4(%eax),%eax
8010525a:	8d 48 0c             	lea    0xc(%eax),%ecx
8010525d:	b8 00 10 00 00       	mov    $0x1000,%eax
80105262:	ba 00 00 00 00       	mov    $0x0,%edx
80105267:	f7 f1                	div    %ecx
80105269:	89 45 f4             	mov    %eax,-0xc(%ebp)

    assert(slab->free_count <= count && slab->free_count >= 0);
8010526c:	8b 45 08             	mov    0x8(%ebp),%eax
8010526f:	8b 40 08             	mov    0x8(%eax),%eax
80105272:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105275:	77 0a                	ja     80105281 <get_status+0xb6>
80105277:	8b 45 08             	mov    0x8(%ebp),%eax
8010527a:	8b 40 08             	mov    0x8(%eax),%eax
8010527d:	85 c0                	test   %eax,%eax
8010527f:	79 1c                	jns    8010529d <get_status+0xd2>
80105281:	68 1c b6 10 80       	push   $0x8010b61c
80105286:	68 64 b5 10 80       	push   $0x8010b564
8010528b:	68 c0 00 00 00       	push   $0xc0
80105290:	68 7a b5 10 80       	push   $0x8010b57a
80105295:	e8 ba b0 ff ff       	call   80100354 <__panic>
8010529a:	83 c4 10             	add    $0x10,%esp
    if(count == slab->free_count)
8010529d:	8b 45 08             	mov    0x8(%ebp),%eax
801052a0:	8b 40 08             	mov    0x8(%eax),%eax
801052a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801052a6:	75 07                	jne    801052af <get_status+0xe4>
    {
        return KMM_FREE_LIST;
801052a8:	b8 02 00 00 00       	mov    $0x2,%eax
801052ad:	eb 16                	jmp    801052c5 <get_status+0xfa>
    }else if(slab->free_count == 0)
801052af:	8b 45 08             	mov    0x8(%ebp),%eax
801052b2:	8b 40 08             	mov    0x8(%eax),%eax
801052b5:	85 c0                	test   %eax,%eax
801052b7:	75 07                	jne    801052c0 <get_status+0xf5>
    {
        return KMM_FULL_LIST;
801052b9:	b8 00 00 00 00       	mov    $0x0,%eax
801052be:	eb 05                	jmp    801052c5 <get_status+0xfa>
    }else{
        return KMM_USED_LIST;
801052c0:	b8 01 00 00 00       	mov    $0x1,%eax
    }
}
801052c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052c8:	c9                   	leave  
801052c9:	c3                   	ret    

801052ca <kmm_pull_buf>:

static bufctl_t
kmm_pull_buf(kmm_slab_t slab)
{
801052ca:	55                   	push   %ebp
801052cb:	89 e5                	mov    %esp,%ebp
801052cd:	53                   	push   %ebx
801052ce:	83 ec 14             	sub    $0x14,%esp
    assert(HODING_SLAB(slab));
801052d1:	8b 45 08             	mov    0x8(%ebp),%eax
801052d4:	8b 58 04             	mov    0x4(%eax),%ebx
801052d7:	e8 8f 12 00 00       	call   8010656b <get_cpu>
801052dc:	89 c2                	mov    %eax,%edx
801052de:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801052e5:	89 c2                	mov    %eax,%edx
801052e7:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
801052ee:	29 d0                	sub    %edx,%eax
801052f0:	83 c0 10             	add    $0x10,%eax
801052f3:	01 d8                	add    %ebx,%eax
801052f5:	83 c0 08             	add    $0x8,%eax
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	50                   	push   %eax
801052fc:	e8 67 24 00 00       	call   80107768 <holding>
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	85 c0                	test   %eax,%eax
80105306:	75 1c                	jne    80105324 <kmm_pull_buf+0x5a>
80105308:	68 cf b5 10 80       	push   $0x8010b5cf
8010530d:	68 64 b5 10 80       	push   $0x8010b564
80105312:	68 cf 00 00 00       	push   $0xcf
80105317:	68 7a b5 10 80       	push   $0x8010b57a
8010531c:	e8 33 b0 ff ff       	call   80100354 <__panic>
80105321:	83 c4 10             	add    $0x10,%esp
    bufctl_t ret;
    assert(slab->next_free);
80105324:	8b 45 08             	mov    0x8(%ebp),%eax
80105327:	8b 40 18             	mov    0x18(%eax),%eax
8010532a:	85 c0                	test   %eax,%eax
8010532c:	75 1c                	jne    8010534a <kmm_pull_buf+0x80>
8010532e:	68 4f b6 10 80       	push   $0x8010b64f
80105333:	68 64 b5 10 80       	push   $0x8010b564
80105338:	68 d1 00 00 00       	push   $0xd1
8010533d:	68 7a b5 10 80       	push   $0x8010b57a
80105342:	e8 0d b0 ff ff       	call   80100354 <__panic>
80105347:	83 c4 10             	add    $0x10,%esp
    ret = slab->next_free;
8010534a:	8b 45 08             	mov    0x8(%ebp),%eax
8010534d:	8b 40 18             	mov    0x18(%eax),%eax
80105350:	89 45 f4             	mov    %eax,-0xc(%ebp)
    slab->next_free = ret->next;
80105353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105356:	8b 10                	mov    (%eax),%edx
80105358:	8b 45 08             	mov    0x8(%ebp),%eax
8010535b:	89 50 18             	mov    %edx,0x18(%eax)
    slab->free_count --;
8010535e:	8b 45 08             	mov    0x8(%ebp),%eax
80105361:	8b 40 08             	mov    0x8(%eax),%eax
80105364:	8d 50 ff             	lea    -0x1(%eax),%edx
80105367:	8b 45 08             	mov    0x8(%ebp),%eax
8010536a:	89 50 08             	mov    %edx,0x8(%eax)
    slab->status = get_status(slab);
8010536d:	83 ec 0c             	sub    $0xc,%esp
80105370:	ff 75 08             	pushl  0x8(%ebp)
80105373:	e8 53 fe ff ff       	call   801051cb <get_status>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	89 c2                	mov    %eax,%edx
8010537d:	8b 45 08             	mov    0x8(%ebp),%eax
80105380:	89 10                	mov    %edx,(%eax)
    return ret;
80105382:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105388:	c9                   	leave  
80105389:	c3                   	ret    

8010538a <kmm_push_buf>:

static void
kmm_push_buf(kmm_slab_t slab, bufctl_t buf)
{
8010538a:	55                   	push   %ebp
8010538b:	89 e5                	mov    %esp,%ebp
8010538d:	53                   	push   %ebx
8010538e:	83 ec 04             	sub    $0x4,%esp
    assert(HODING_SLAB(slab));
80105391:	8b 45 08             	mov    0x8(%ebp),%eax
80105394:	8b 58 04             	mov    0x4(%eax),%ebx
80105397:	e8 cf 11 00 00       	call   8010656b <get_cpu>
8010539c:	89 c2                	mov    %eax,%edx
8010539e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801053a5:	89 c2                	mov    %eax,%edx
801053a7:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
801053ae:	29 d0                	sub    %edx,%eax
801053b0:	83 c0 10             	add    $0x10,%eax
801053b3:	01 d8                	add    %ebx,%eax
801053b5:	83 c0 08             	add    $0x8,%eax
801053b8:	83 ec 0c             	sub    $0xc,%esp
801053bb:	50                   	push   %eax
801053bc:	e8 a7 23 00 00       	call   80107768 <holding>
801053c1:	83 c4 10             	add    $0x10,%esp
801053c4:	85 c0                	test   %eax,%eax
801053c6:	75 1c                	jne    801053e4 <kmm_push_buf+0x5a>
801053c8:	68 cf b5 10 80       	push   $0x8010b5cf
801053cd:	68 64 b5 10 80       	push   $0x8010b564
801053d2:	68 dc 00 00 00       	push   $0xdc
801053d7:	68 7a b5 10 80       	push   $0x8010b57a
801053dc:	e8 73 af ff ff       	call   80100354 <__panic>
801053e1:	83 c4 10             	add    $0x10,%esp
    buf->next = slab->next_free;
801053e4:	8b 45 08             	mov    0x8(%ebp),%eax
801053e7:	8b 50 18             	mov    0x18(%eax),%edx
801053ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ed:	89 10                	mov    %edx,(%eax)
    slab->next_free = buf;
801053ef:	8b 45 08             	mov    0x8(%ebp),%eax
801053f2:	8b 55 0c             	mov    0xc(%ebp),%edx
801053f5:	89 50 18             	mov    %edx,0x18(%eax)
    slab->free_count ++;
801053f8:	8b 45 08             	mov    0x8(%ebp),%eax
801053fb:	8b 40 08             	mov    0x8(%eax),%eax
801053fe:	8d 50 01             	lea    0x1(%eax),%edx
80105401:	8b 45 08             	mov    0x8(%ebp),%eax
80105404:	89 50 08             	mov    %edx,0x8(%eax)
    slab->status = get_status(slab);
80105407:	83 ec 0c             	sub    $0xc,%esp
8010540a:	ff 75 08             	pushl  0x8(%ebp)
8010540d:	e8 b9 fd ff ff       	call   801051cb <get_status>
80105412:	83 c4 10             	add    $0x10,%esp
80105415:	89 c2                	mov    %eax,%edx
80105417:	8b 45 08             	mov    0x8(%ebp),%eax
8010541a:	89 10                	mov    %edx,(%eax)
}
8010541c:	90                   	nop
8010541d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105420:	c9                   	leave  
80105421:	c3                   	ret    

80105422 <kmm_free>:

void
kmm_free(bufctl_t addr)
{
80105422:	55                   	push   %ebp
80105423:	89 e5                	mov    %esp,%ebp
80105425:	53                   	push   %ebx
80105426:	83 ec 14             	sub    $0x14,%esp
    ACQUIRE_SLAB(addr->slab);
80105429:	8b 45 08             	mov    0x8(%ebp),%eax
8010542c:	8b 40 04             	mov    0x4(%eax),%eax
8010542f:	8b 58 04             	mov    0x4(%eax),%ebx
80105432:	e8 34 11 00 00       	call   8010656b <get_cpu>
80105437:	89 c2                	mov    %eax,%edx
80105439:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
80105440:	89 c2                	mov    %eax,%edx
80105442:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80105449:	29 d0                	sub    %edx,%eax
8010544b:	83 c0 10             	add    $0x10,%eax
8010544e:	01 d8                	add    %ebx,%eax
80105450:	83 c0 08             	add    $0x8,%eax
80105453:	83 ec 0c             	sub    $0xc,%esp
80105456:	50                   	push   %eax
80105457:	e8 5f 23 00 00       	call   801077bb <acquire>
8010545c:	83 c4 10             	add    $0x10,%esp
    assert(addr->slab && addr->slab->cache);
8010545f:	8b 45 08             	mov    0x8(%ebp),%eax
80105462:	8b 40 04             	mov    0x4(%eax),%eax
80105465:	85 c0                	test   %eax,%eax
80105467:	74 0d                	je     80105476 <kmm_free+0x54>
80105469:	8b 45 08             	mov    0x8(%ebp),%eax
8010546c:	8b 40 04             	mov    0x4(%eax),%eax
8010546f:	8b 40 04             	mov    0x4(%eax),%eax
80105472:	85 c0                	test   %eax,%eax
80105474:	75 1c                	jne    80105492 <kmm_free+0x70>
80105476:	68 60 b6 10 80       	push   $0x8010b660
8010547b:	68 64 b5 10 80       	push   $0x8010b564
80105480:	68 e7 00 00 00       	push   $0xe7
80105485:	68 7a b5 10 80       	push   $0x8010b57a
8010548a:	e8 c5 ae ff ff       	call   80100354 <__panic>
8010548f:	83 c4 10             	add    $0x10,%esp
    kmm_cache_t cache = addr->slab->cache;
80105492:	8b 45 08             	mov    0x8(%ebp),%eax
80105495:	8b 40 04             	mov    0x4(%eax),%eax
80105498:	8b 40 04             	mov    0x4(%eax),%eax
8010549b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    kmm_push_buf(addr->slab, addr); 
8010549e:	8b 45 08             	mov    0x8(%ebp),%eax
801054a1:	8b 40 04             	mov    0x4(%eax),%eax
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	ff 75 08             	pushl  0x8(%ebp)
801054aa:	50                   	push   %eax
801054ab:	e8 da fe ff ff       	call   8010538a <kmm_push_buf>
801054b0:	83 c4 10             	add    $0x10,%esp
    adjust_slab_list(cache, addr->slab, addr->slab->status);
801054b3:	8b 45 08             	mov    0x8(%ebp),%eax
801054b6:	8b 40 04             	mov    0x4(%eax),%eax
801054b9:	8b 10                	mov    (%eax),%edx
801054bb:	8b 45 08             	mov    0x8(%ebp),%eax
801054be:	8b 40 04             	mov    0x4(%eax),%eax
801054c1:	83 ec 04             	sub    $0x4,%esp
801054c4:	52                   	push   %edx
801054c5:	50                   	push   %eax
801054c6:	ff 75 f4             	pushl  -0xc(%ebp)
801054c9:	e8 6b f9 ff ff       	call   80104e39 <adjust_slab_list>
801054ce:	83 c4 10             	add    $0x10,%esp
    RELEASE_SLAB(addr->slab);
801054d1:	8b 45 08             	mov    0x8(%ebp),%eax
801054d4:	8b 40 04             	mov    0x4(%eax),%eax
801054d7:	8b 58 04             	mov    0x4(%eax),%ebx
801054da:	e8 8c 10 00 00       	call   8010656b <get_cpu>
801054df:	89 c2                	mov    %eax,%edx
801054e1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
801054e8:	89 c2                	mov    %eax,%edx
801054ea:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
801054f1:	29 d0                	sub    %edx,%eax
801054f3:	83 c0 10             	add    $0x10,%eax
801054f6:	01 d8                	add    %ebx,%eax
801054f8:	83 c0 08             	add    $0x8,%eax
801054fb:	83 ec 0c             	sub    $0xc,%esp
801054fe:	50                   	push   %eax
801054ff:	e8 16 23 00 00       	call   8010781a <release>
80105504:	83 c4 10             	add    $0x10,%esp
}
80105507:	90                   	nop
80105508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010550b:	c9                   	leave  
8010550c:	c3                   	ret    

8010550d <swapfs_init>:
#include "mmu.h"
#include "ide.h"
#include "kdebug.h"
#include "pmm.h"
void
swapfs_init(void) {
8010550d:	55                   	push   %ebp
8010550e:	89 e5                	mov    %esp,%ebp
80105510:	57                   	push   %edi
80105511:	81 ec 04 02 00 00    	sub    $0x204,%esp
    char buf[512] = {0};
80105517:	8d 95 f8 fd ff ff    	lea    -0x208(%ebp),%edx
8010551d:	b8 00 00 00 00       	mov    $0x0,%eax
80105522:	b9 80 00 00 00       	mov    $0x80,%ecx
80105527:	89 d7                	mov    %edx,%edi
80105529:	f3 ab                	rep stos %eax,%es:(%edi)
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
8010552b:	83 ec 0c             	sub    $0xc,%esp
8010552e:	6a 01                	push   $0x1
80105530:	e8 7e 1b 00 00       	call   801070b3 <ide_device_valid>
80105535:	83 c4 10             	add    $0x10,%esp
80105538:	85 c0                	test   %eax,%eax
8010553a:	75 17                	jne    80105553 <swapfs_init+0x46>
        panic("swap fs isn't available.\n");
8010553c:	83 ec 04             	sub    $0x4,%esp
8010553f:	68 80 b6 10 80       	push   $0x8010b680
80105544:	6a 0e                	push   $0xe
80105546:	68 9a b6 10 80       	push   $0x8010b69a
8010554b:	e8 04 ae ff ff       	call   80100354 <__panic>
80105550:	83 c4 10             	add    $0x10,%esp
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
80105553:	83 ec 0c             	sub    $0xc,%esp
80105556:	6a 01                	push   $0x1
80105558:	e8 96 1b 00 00       	call   801070f3 <ide_device_size>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	c1 e8 03             	shr    $0x3,%eax
80105563:	a3 64 70 12 80       	mov    %eax,0x80127064
    buf[256] = SWAP_MAGIC_NUM;
80105568:	c6 85 f8 fe ff ff 77 	movb   $0x77,-0x108(%ebp)
    ide_write_secs(SWAP_DEV_NO, 0, buf,1 );
8010556f:	6a 01                	push   $0x1
80105571:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
80105577:	50                   	push   %eax
80105578:	6a 00                	push   $0x0
8010557a:	6a 01                	push   $0x1
8010557c:	e8 ae 1d 00 00       	call   8010732f <ide_write_secs>
80105581:	83 c4 10             	add    $0x10,%esp
}
80105584:	90                   	nop
80105585:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105588:	c9                   	leave  
80105589:	c3                   	ret    

8010558a <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct page *page) {
8010558a:	55                   	push   %ebp
8010558b:	89 e5                	mov    %esp,%ebp
8010558d:	53                   	push   %ebx
8010558e:	83 ec 14             	sub    $0x14,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
80105591:	83 ec 0c             	sub    $0xc,%esp
80105594:	ff 75 0c             	pushl  0xc(%ebp)
80105597:	e8 b1 b3 ff ff       	call   8010094d <page2kva>
8010559c:	83 c4 10             	add    $0x10,%esp
8010559f:	89 c3                	mov    %eax,%ebx
801055a1:	8b 45 08             	mov    0x8(%ebp),%eax
801055a4:	c1 e8 08             	shr    $0x8,%eax
801055a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055aa:	a1 64 70 12 80       	mov    0x80127064,%eax
801055af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801055b2:	72 17                	jb     801055cb <swapfs_read+0x41>
801055b4:	ff 75 08             	pushl  0x8(%ebp)
801055b7:	68 ab b6 10 80       	push   $0x8010b6ab
801055bc:	6a 17                	push   $0x17
801055be:	68 9a b6 10 80       	push   $0x8010b69a
801055c3:	e8 8c ad ff ff       	call   80100354 <__panic>
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ce:	c1 e0 03             	shl    $0x3,%eax
801055d1:	6a 08                	push   $0x8
801055d3:	53                   	push   %ebx
801055d4:	50                   	push   %eax
801055d5:	6a 01                	push   $0x1
801055d7:	e8 57 1b 00 00       	call   80107133 <ide_read_secs>
801055dc:	83 c4 10             	add    $0x10,%esp
}
801055df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e2:	c9                   	leave  
801055e3:	c3                   	ret    

801055e4 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct page *page) {
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	53                   	push   %ebx
801055e8:	83 ec 14             	sub    $0x14,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
801055eb:	83 ec 0c             	sub    $0xc,%esp
801055ee:	ff 75 0c             	pushl  0xc(%ebp)
801055f1:	e8 57 b3 ff ff       	call   8010094d <page2kva>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	89 c3                	mov    %eax,%ebx
801055fb:	8b 45 08             	mov    0x8(%ebp),%eax
801055fe:	c1 e8 08             	shr    $0x8,%eax
80105601:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105604:	a1 64 70 12 80       	mov    0x80127064,%eax
80105609:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010560c:	72 17                	jb     80105625 <swapfs_write+0x41>
8010560e:	ff 75 08             	pushl  0x8(%ebp)
80105611:	68 ab b6 10 80       	push   $0x8010b6ab
80105616:	6a 1c                	push   $0x1c
80105618:	68 9a b6 10 80       	push   $0x8010b69a
8010561d:	e8 32 ad ff ff       	call   80100354 <__panic>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105628:	c1 e0 03             	shl    $0x3,%eax
8010562b:	6a 08                	push   $0x8
8010562d:	53                   	push   %ebx
8010562e:	50                   	push   %eax
8010562f:	6a 01                	push   $0x1
80105631:	e8 f9 1c 00 00       	call   8010732f <ide_write_secs>
80105636:	83 c4 10             	add    $0x10,%esp
}
80105639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010563c:	c9                   	leave  
8010563d:	c3                   	ret    

8010563e <sys_exec>:
[SYS_put]   sys_put,
};

int 
sys_exec()
{
8010563e:	55                   	push   %ebp
8010563f:	89 e5                	mov    %esp,%ebp
80105641:	83 ec 08             	sub    $0x8,%esp
    extern char _binary___user_user_test_start[];
    extern char _binary___user_user_test_size[];
    cprintf("sys_exec()\n");
80105644:	83 ec 0c             	sub    $0xc,%esp
80105647:	68 c9 b6 10 80       	push   $0x8010b6c9
8010564c:	e8 86 16 00 00       	call   80106cd7 <cprintf>
80105651:	83 c4 10             	add    $0x10,%esp
    do_execve(" ", 1, (unsigned char*)_binary___user_user_test_start, (size_t)_binary___user_user_test_size);
80105654:	b8 a0 0a 00 00       	mov    $0xaa0,%eax
80105659:	50                   	push   %eax
8010565a:	68 00 64 12 80       	push   $0x80126400
8010565f:	6a 01                	push   $0x1
80105661:	68 d5 b6 10 80       	push   $0x8010b6d5
80105666:	e8 ab 35 00 00       	call   80108c16 <do_execve>
8010566b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010566e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105673:	c9                   	leave  
80105674:	c3                   	ret    

80105675 <sys_exit>:
int 
sys_exit()
{
80105675:	55                   	push   %ebp
80105676:	89 e5                	mov    %esp,%ebp
80105678:	83 ec 08             	sub    $0x8,%esp
    do_exit(0); 
8010567b:	83 ec 0c             	sub    $0xc,%esp
8010567e:	6a 00                	push   $0x0
80105680:	e8 d3 3b 00 00       	call   80109258 <do_exit>
80105685:	83 c4 10             	add    $0x10,%esp
    return 0;
80105688:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010568d:	c9                   	leave  
8010568e:	c3                   	ret    

8010568f <syscall>:

void
syscall()
{
8010568f:	55                   	push   %ebp
80105690:	89 e5                	mov    %esp,%ebp
80105692:	53                   	push   %ebx
80105693:	83 ec 14             	sub    $0x14,%esp
    int num;
    num = CUR_PROC->tf->eax;
80105696:	e8 d0 0e 00 00       	call   8010656b <get_cpu>
8010569b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801056a1:	05 70 79 12 80       	add    $0x80127970,%eax
801056a6:	8b 00                	mov    (%eax),%eax
801056a8:	8b 40 24             	mov    0x24(%eax),%eax
801056ab:	8b 40 1c             	mov    0x1c(%eax),%eax
801056ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801056b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056b5:	7e 3c                	jle    801056f3 <syscall+0x64>
801056b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ba:	83 f8 16             	cmp    $0x16,%eax
801056bd:	77 34                	ja     801056f3 <syscall+0x64>
801056bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c2:	8b 04 85 00 41 12 80 	mov    -0x7fedbf00(,%eax,4),%eax
801056c9:	85 c0                	test   %eax,%eax
801056cb:	74 26                	je     801056f3 <syscall+0x64>
        cpus[get_cpu()].cur_proc->tf->eax= syscalls[num]();
801056cd:	e8 99 0e 00 00       	call   8010656b <get_cpu>
801056d2:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801056d8:	05 70 79 12 80       	add    $0x80127970,%eax
801056dd:	8b 00                	mov    (%eax),%eax
801056df:	8b 58 24             	mov    0x24(%eax),%ebx
801056e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e5:	8b 04 85 00 41 12 80 	mov    -0x7fedbf00(,%eax,4),%eax
801056ec:	ff d0                	call   *%eax
801056ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
801056f1:	eb 10                	jmp    80105703 <syscall+0x74>
    } else {
        cprintf("unknown sys call\n");
801056f3:	83 ec 0c             	sub    $0xc,%esp
801056f6:	68 d7 b6 10 80       	push   $0x8010b6d7
801056fb:	e8 d7 15 00 00       	call   80106cd7 <cprintf>
80105700:	83 c4 10             	add    $0x10,%esp
    }
}
80105703:	90                   	nop
80105704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105707:	c9                   	leave  
80105708:	c3                   	ret    

80105709 <argint>:

int
argint(int n, int *ip)
{
80105709:	55                   	push   %ebp
8010570a:	89 e5                	mov    %esp,%ebp
8010570c:	83 ec 08             	sub    $0x8,%esp
   *ip = cpus[get_cpu()].cur_proc->tf->ebx;
8010570f:	e8 57 0e 00 00       	call   8010656b <get_cpu>
80105714:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
8010571a:	05 70 79 12 80       	add    $0x80127970,%eax
8010571f:	8b 00                	mov    (%eax),%eax
80105721:	8b 40 24             	mov    0x24(%eax),%eax
80105724:	8b 40 10             	mov    0x10(%eax),%eax
80105727:	89 c2                	mov    %eax,%edx
80105729:	8b 45 0c             	mov    0xc(%ebp),%eax
8010572c:	89 10                	mov    %edx,(%eax)
   return 0;//cpus[get_cpu()].cur_proc->tf->ebx;
8010572e:	b8 00 00 00 00       	mov    $0x0,%eax
//    return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80105733:	c9                   	leave  
80105734:	c3                   	ret    

80105735 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80105735:	55                   	push   %ebp
80105736:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80105738:	a1 8c 70 12 80       	mov    0x8012708c,%eax
8010573d:	8b 55 08             	mov    0x8(%ebp),%edx
80105740:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80105742:	a1 8c 70 12 80       	mov    0x8012708c,%eax
80105747:	8b 40 10             	mov    0x10(%eax),%eax
}
8010574a:	5d                   	pop    %ebp
8010574b:	c3                   	ret    

8010574c <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010574c:	55                   	push   %ebp
8010574d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010574f:	a1 8c 70 12 80       	mov    0x8012708c,%eax
80105754:	8b 55 08             	mov    0x8(%ebp),%edx
80105757:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80105759:	a1 8c 70 12 80       	mov    0x8012708c,%eax
8010575e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105761:	89 50 10             	mov    %edx,0x10(%eax)
}
80105764:	90                   	nop
80105765:	5d                   	pop    %ebp
80105766:	c3                   	ret    

80105767 <ioapicinit>:

void
ioapicinit(void)
{
80105767:	55                   	push   %ebp
80105768:	89 e5                	mov    %esp,%ebp
8010576a:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
8010576d:	a1 a8 78 12 80       	mov    0x801278a8,%eax
80105772:	85 c0                	test   %eax,%eax
80105774:	0f 84 b0 00 00 00    	je     8010582a <ioapicinit+0xc3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010577a:	c7 05 8c 70 12 80 00 	movl   $0xfec00000,0x8012708c
80105781:	00 c0 fe 

  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80105784:	6a 01                	push   $0x1
80105786:	e8 aa ff ff ff       	call   80105735 <ioapicread>
8010578b:	83 c4 04             	add    $0x4,%esp
8010578e:	c1 e8 10             	shr    $0x10,%eax
80105791:	25 ff 00 00 00       	and    $0xff,%eax
80105796:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80105799:	6a 00                	push   $0x0
8010579b:	e8 95 ff ff ff       	call   80105735 <ioapicread>
801057a0:	83 c4 04             	add    $0x4,%esp
801057a3:	c1 e8 18             	shr    $0x18,%eax
801057a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801057a9:	0f b6 05 a4 78 12 80 	movzbl 0x801278a4,%eax
801057b0:	0f b6 c0             	movzbl %al,%eax
801057b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801057b6:	74 10                	je     801057c8 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801057b8:	83 ec 0c             	sub    $0xc,%esp
801057bb:	68 ec b6 10 80       	push   $0x8010b6ec
801057c0:	e8 12 15 00 00       	call   80106cd7 <cprintf>
801057c5:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801057c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801057cf:	eb 3f                	jmp    80105810 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801057d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d4:	83 c0 20             	add    $0x20,%eax
801057d7:	0d 00 00 01 00       	or     $0x10000,%eax
801057dc:	89 c2                	mov    %eax,%edx
801057de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e1:	83 c0 08             	add    $0x8,%eax
801057e4:	01 c0                	add    %eax,%eax
801057e6:	83 ec 08             	sub    $0x8,%esp
801057e9:	52                   	push   %edx
801057ea:	50                   	push   %eax
801057eb:	e8 5c ff ff ff       	call   8010574c <ioapicwrite>
801057f0:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
801057f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f6:	83 c0 08             	add    $0x8,%eax
801057f9:	01 c0                	add    %eax,%eax
801057fb:	83 c0 01             	add    $0x1,%eax
801057fe:	83 ec 08             	sub    $0x8,%esp
80105801:	6a 00                	push   $0x0
80105803:	50                   	push   %eax
80105804:	e8 43 ff ff ff       	call   8010574c <ioapicwrite>
80105809:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010580c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105813:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80105816:	7e b9                	jle    801057d1 <ioapicinit+0x6a>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
  cprintf(INITOK"ioapic init ok!\n");
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	68 1e b7 10 80       	push   $0x8010b71e
80105820:	e8 b2 14 00 00       	call   80106cd7 <cprintf>
80105825:	83 c4 10             	add    $0x10,%esp
80105828:	eb 01                	jmp    8010582b <ioapicinit+0xc4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
8010582a:	90                   	nop
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
  cprintf(INITOK"ioapic init ok!\n");
}
8010582b:	c9                   	leave  
8010582c:	c3                   	ret    

8010582d <ioapicenable>:


void
ioapicenable(int irq, int cpunum)

{
8010582d:	55                   	push   %ebp
8010582e:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80105830:	a1 a8 78 12 80       	mov    0x801278a8,%eax
80105835:	85 c0                	test   %eax,%eax
80105837:	74 39                	je     80105872 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80105839:	8b 45 08             	mov    0x8(%ebp),%eax
8010583c:	83 c0 20             	add    $0x20,%eax
8010583f:	89 c2                	mov    %eax,%edx
80105841:	8b 45 08             	mov    0x8(%ebp),%eax
80105844:	83 c0 08             	add    $0x8,%eax
80105847:	01 c0                	add    %eax,%eax
80105849:	52                   	push   %edx
8010584a:	50                   	push   %eax
8010584b:	e8 fc fe ff ff       	call   8010574c <ioapicwrite>
80105850:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80105853:	8b 45 0c             	mov    0xc(%ebp),%eax
80105856:	c1 e0 18             	shl    $0x18,%eax
80105859:	89 c2                	mov    %eax,%edx
8010585b:	8b 45 08             	mov    0x8(%ebp),%eax
8010585e:	83 c0 08             	add    $0x8,%eax
80105861:	01 c0                	add    %eax,%eax
80105863:	83 c0 01             	add    $0x1,%eax
80105866:	52                   	push   %edx
80105867:	50                   	push   %eax
80105868:	e8 df fe ff ff       	call   8010574c <ioapicwrite>
8010586d:	83 c4 08             	add    $0x8,%esp
80105870:	eb 01                	jmp    80105873 <ioapicenable+0x46>
void
ioapicenable(int irq, int cpunum)

{
  if(!ismp)
    return;
80105872:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80105873:	c9                   	leave  
80105874:	c3                   	ret    

80105875 <lidt>:
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
static inline void
lidt(struct gatedesc *p, int size)
{
80105875:	55                   	push   %ebp
80105876:	89 e5                	mov    %esp,%ebp
80105878:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010587b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010587e:	83 e8 01             	sub    $0x1,%eax
80105881:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105885:	8b 45 08             	mov    0x8(%ebp),%eax
80105888:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010588c:	8b 45 08             	mov    0x8(%ebp),%eax
8010588f:	c1 e8 10             	shr    $0x10,%eax
80105892:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105896:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105899:	0f 01 18             	lidtl  (%eax)
}
8010589c:	90                   	nop
8010589d:	c9                   	leave  
8010589e:	c3                   	ret    

8010589f <rcr2>:
    return oldbit != 0;
}


static inline uintptr_t
rcr2(void) {
8010589f:	55                   	push   %ebp
801058a0:	89 e5                	mov    %esp,%ebp
801058a2:	83 ec 10             	sub    $0x10,%esp
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
801058a5:	0f 20 d0             	mov    %cr2,%eax
801058a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return cr2;
801058ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058ae:	c9                   	leave  
801058af:	c3                   	ret    

801058b0 <tvinit>:



void
tvinit(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
801058b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801058bd:	e9 c3 00 00 00       	jmp    80105985 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058c5:	8b 04 85 00 60 12 80 	mov    -0x7feda000(,%eax,4),%eax
801058cc:	89 c2                	mov    %eax,%edx
801058ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d1:	66 89 14 c5 a0 70 12 	mov    %dx,-0x7fed8f60(,%eax,8)
801058d8:	80 
801058d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058dc:	66 c7 04 c5 a2 70 12 	movw   $0x8,-0x7fed8f5e(,%eax,8)
801058e3:	80 08 00 
801058e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e9:	0f b6 14 c5 a4 70 12 	movzbl -0x7fed8f5c(,%eax,8),%edx
801058f0:	80 
801058f1:	83 e2 e0             	and    $0xffffffe0,%edx
801058f4:	88 14 c5 a4 70 12 80 	mov    %dl,-0x7fed8f5c(,%eax,8)
801058fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058fe:	0f b6 14 c5 a4 70 12 	movzbl -0x7fed8f5c(,%eax,8),%edx
80105905:	80 
80105906:	83 e2 1f             	and    $0x1f,%edx
80105909:	88 14 c5 a4 70 12 80 	mov    %dl,-0x7fed8f5c(,%eax,8)
80105910:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105913:	0f b6 14 c5 a5 70 12 	movzbl -0x7fed8f5b(,%eax,8),%edx
8010591a:	80 
8010591b:	83 e2 f0             	and    $0xfffffff0,%edx
8010591e:	83 ca 0e             	or     $0xe,%edx
80105921:	88 14 c5 a5 70 12 80 	mov    %dl,-0x7fed8f5b(,%eax,8)
80105928:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010592b:	0f b6 14 c5 a5 70 12 	movzbl -0x7fed8f5b(,%eax,8),%edx
80105932:	80 
80105933:	83 e2 ef             	and    $0xffffffef,%edx
80105936:	88 14 c5 a5 70 12 80 	mov    %dl,-0x7fed8f5b(,%eax,8)
8010593d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105940:	0f b6 14 c5 a5 70 12 	movzbl -0x7fed8f5b(,%eax,8),%edx
80105947:	80 
80105948:	83 e2 9f             	and    $0xffffff9f,%edx
8010594b:	88 14 c5 a5 70 12 80 	mov    %dl,-0x7fed8f5b(,%eax,8)
80105952:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105955:	0f b6 14 c5 a5 70 12 	movzbl -0x7fed8f5b(,%eax,8),%edx
8010595c:	80 
8010595d:	83 ca 80             	or     $0xffffff80,%edx
80105960:	88 14 c5 a5 70 12 80 	mov    %dl,-0x7fed8f5b(,%eax,8)
80105967:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010596a:	8b 04 85 00 60 12 80 	mov    -0x7feda000(,%eax,4),%eax
80105971:	c1 e8 10             	shr    $0x10,%eax
80105974:	89 c2                	mov    %eax,%edx
80105976:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105979:	66 89 14 c5 a6 70 12 	mov    %dx,-0x7fed8f5a(,%eax,8)
80105980:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105981:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105985:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
8010598c:	0f 8e 30 ff ff ff    	jle    801058c2 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105992:	a1 00 61 12 80       	mov    0x80126100,%eax
80105997:	66 a3 a0 72 12 80    	mov    %ax,0x801272a0
8010599d:	66 c7 05 a2 72 12 80 	movw   $0x8,0x801272a2
801059a4:	08 00 
801059a6:	0f b6 05 a4 72 12 80 	movzbl 0x801272a4,%eax
801059ad:	83 e0 e0             	and    $0xffffffe0,%eax
801059b0:	a2 a4 72 12 80       	mov    %al,0x801272a4
801059b5:	0f b6 05 a4 72 12 80 	movzbl 0x801272a4,%eax
801059bc:	83 e0 1f             	and    $0x1f,%eax
801059bf:	a2 a4 72 12 80       	mov    %al,0x801272a4
801059c4:	0f b6 05 a5 72 12 80 	movzbl 0x801272a5,%eax
801059cb:	83 c8 0f             	or     $0xf,%eax
801059ce:	a2 a5 72 12 80       	mov    %al,0x801272a5
801059d3:	0f b6 05 a5 72 12 80 	movzbl 0x801272a5,%eax
801059da:	83 e0 ef             	and    $0xffffffef,%eax
801059dd:	a2 a5 72 12 80       	mov    %al,0x801272a5
801059e2:	0f b6 05 a5 72 12 80 	movzbl 0x801272a5,%eax
801059e9:	83 c8 60             	or     $0x60,%eax
801059ec:	a2 a5 72 12 80       	mov    %al,0x801272a5
801059f1:	0f b6 05 a5 72 12 80 	movzbl 0x801272a5,%eax
801059f8:	83 c8 80             	or     $0xffffff80,%eax
801059fb:	a2 a5 72 12 80       	mov    %al,0x801272a5
80105a00:	a1 00 61 12 80       	mov    0x80126100,%eax
80105a05:	c1 e8 10             	shr    $0x10,%eax
80105a08:	66 a3 a6 72 12 80    	mov    %ax,0x801272a6

//  initlock(&tickslock, "time");
}
80105a0e:	90                   	nop
80105a0f:	c9                   	leave  
80105a10:	c3                   	ret    

80105a11 <idtinit>:


void
idtinit(void)
{
80105a11:	55                   	push   %ebp
80105a12:	89 e5                	mov    %esp,%ebp
80105a14:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80105a17:	68 00 08 00 00       	push   $0x800
80105a1c:	68 a0 70 12 80       	push   $0x801270a0
80105a21:	e8 4f fe ff ff       	call   80105875 <lidt>
80105a26:	83 c4 08             	add    $0x8,%esp
  cprintf(INITOK"idt init ok!\n");
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	68 3c b7 10 80       	push   $0x8010b73c
80105a31:	e8 a1 12 00 00       	call   80106cd7 <cprintf>
80105a36:	83 c4 10             	add    $0x10,%esp
}
80105a39:	90                   	nop
80105a3a:	c9                   	leave  
80105a3b:	c3                   	ret    

80105a3c <print_pgfault>:


static inline void
print_pgfault(struct trapframe *tf) {
80105a3c:	55                   	push   %ebp
80105a3d:	89 e5                	mov    %esp,%ebp
80105a3f:	57                   	push   %edi
80105a40:	56                   	push   %esi
80105a41:	53                   	push   %ebx
80105a42:	83 ec 0c             	sub    $0xc,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->err & 4) ? 'U' : 'K',
            (tf->err & 2) ? 'W' : 'R',
            (tf->err & 1) ? "protection fault" : "no page found");
80105a45:	8b 45 08             	mov    0x8(%ebp),%eax
80105a48:	8b 40 34             	mov    0x34(%eax),%eax
80105a4b:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	74 07                	je     80105a59 <print_pgfault+0x1d>
80105a52:	bf 55 b7 10 80       	mov    $0x8010b755,%edi
80105a57:	eb 05                	jmp    80105a5e <print_pgfault+0x22>
80105a59:	bf 66 b7 10 80       	mov    $0x8010b766,%edi
            (tf->err & 4) ? 'U' : 'K',
            (tf->err & 2) ? 'W' : 'R',
80105a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80105a61:	8b 40 34             	mov    0x34(%eax),%eax
80105a64:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
80105a67:	85 c0                	test   %eax,%eax
80105a69:	74 07                	je     80105a72 <print_pgfault+0x36>
80105a6b:	be 57 00 00 00       	mov    $0x57,%esi
80105a70:	eb 05                	jmp    80105a77 <print_pgfault+0x3b>
80105a72:	be 52 00 00 00       	mov    $0x52,%esi
            (tf->err & 4) ? 'U' : 'K',
80105a77:	8b 45 08             	mov    0x8(%ebp),%eax
80105a7a:	8b 40 34             	mov    0x34(%eax),%eax
80105a7d:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
80105a80:	85 c0                	test   %eax,%eax
80105a82:	74 07                	je     80105a8b <print_pgfault+0x4f>
80105a84:	bb 55 00 00 00       	mov    $0x55,%ebx
80105a89:	eb 05                	jmp    80105a90 <print_pgfault+0x54>
80105a8b:	bb 4b 00 00 00       	mov    $0x4b,%ebx
80105a90:	e8 0a fe ff ff       	call   8010589f <rcr2>
80105a95:	83 ec 0c             	sub    $0xc,%esp
80105a98:	57                   	push   %edi
80105a99:	56                   	push   %esi
80105a9a:	53                   	push   %ebx
80105a9b:	50                   	push   %eax
80105a9c:	68 74 b7 10 80       	push   $0x8010b774
80105aa1:	e8 31 12 00 00       	call   80106cd7 <cprintf>
80105aa6:	83 c4 20             	add    $0x20,%esp
            (tf->err & 4) ? 'U' : 'K',
            (tf->err & 2) ? 'W' : 'R',
            (tf->err & 1) ? "protection fault" : "no page found");
}
80105aa9:	90                   	nop
80105aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aad:	5b                   	pop    %ebx
80105aae:	5e                   	pop    %esi
80105aaf:	5f                   	pop    %edi
80105ab0:	5d                   	pop    %ebp
80105ab1:	c3                   	ret    

80105ab2 <pgfault_handler>:

extern struct mm_struct *check_mm_struct;
static int
pgfault_handler(struct trapframe *tf) {
80105ab2:	55                   	push   %ebp
80105ab3:	89 e5                	mov    %esp,%ebp
80105ab5:	83 ec 08             	sub    $0x8,%esp
    print_pgfault(tf);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	ff 75 08             	pushl  0x8(%ebp)
80105abe:	e8 79 ff ff ff       	call   80105a3c <print_pgfault>
80105ac3:	83 c4 10             	add    $0x10,%esp
    if (check_mm_struct != NULL) {
80105ac6:	a1 6c 70 12 80       	mov    0x8012706c,%eax
80105acb:	85 c0                	test   %eax,%eax
80105acd:	74 22                	je     80105af1 <pgfault_handler+0x3f>
        return do_pgfault(check_mm_struct, tf->err, rcr2());
80105acf:	e8 cb fd ff ff       	call   8010589f <rcr2>
80105ad4:	89 c1                	mov    %eax,%ecx
80105ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad9:	8b 50 34             	mov    0x34(%eax),%edx
80105adc:	a1 6c 70 12 80       	mov    0x8012706c,%eax
80105ae1:	83 ec 04             	sub    $0x4,%esp
80105ae4:	51                   	push   %ecx
80105ae5:	52                   	push   %edx
80105ae6:	50                   	push   %eax
80105ae7:	e8 07 c7 ff ff       	call   801021f3 <do_pgfault>
80105aec:	83 c4 10             	add    $0x10,%esp
80105aef:	eb 1c                	jmp    80105b0d <pgfault_handler+0x5b>
    }
    panic("unhandled page fault.\n");
80105af1:	83 ec 04             	sub    $0x4,%esp
80105af4:	68 97 b7 10 80       	push   $0x8010b797
80105af9:	6a 3f                	push   $0x3f
80105afb:	68 ae b7 10 80       	push   $0x8010b7ae
80105b00:	e8 4f a8 ff ff       	call   80100354 <__panic>
80105b05:	83 c4 10             	add    $0x10,%esp
    return 0;
80105b08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b0d:	c9                   	leave  
80105b0e:	c3                   	ret    

80105b0f <trap>:


void
trap(struct trapframe *tf)
{
80105b0f:	55                   	push   %ebp
80105b10:	89 e5                	mov    %esp,%ebp
80105b12:	56                   	push   %esi
80105b13:	53                   	push   %ebx

    if(tf->trapno == T_SYSCALL){
80105b14:	8b 45 08             	mov    0x8(%ebp),%eax
80105b17:	8b 40 30             	mov    0x30(%eax),%eax
80105b1a:	83 f8 40             	cmp    $0x40,%eax
80105b1d:	75 22                	jne    80105b41 <trap+0x32>
        cpus[get_cpu()].cur_proc->tf = tf;
80105b1f:	e8 47 0a 00 00       	call   8010656b <get_cpu>
80105b24:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80105b2a:	05 70 79 12 80       	add    $0x80127970,%eax
80105b2f:	8b 00                	mov    (%eax),%eax
80105b31:	8b 55 08             	mov    0x8(%ebp),%edx
80105b34:	89 50 24             	mov    %edx,0x24(%eax)
           syscall();
80105b37:	e8 53 fb ff ff       	call   8010568f <syscall>
           proc->tf = tf;
           syscall();
           if(proc->killed)
           exit();
           */
        return;
80105b3c:	e9 da 01 00 00       	jmp    80105d1b <trap+0x20c>
    }
    switch(tf->trapno){
80105b41:	8b 45 08             	mov    0x8(%ebp),%eax
80105b44:	8b 40 30             	mov    0x30(%eax),%eax
80105b47:	83 e8 0e             	sub    $0xe,%eax
80105b4a:	83 f8 31             	cmp    $0x31,%eax
80105b4d:	0f 87 8e 00 00 00    	ja     80105be1 <trap+0xd2>
80105b53:	8b 04 85 b0 b8 10 80 	mov    -0x7fef4750(,%eax,4),%eax
80105b5a:	ff e0                	jmp    *%eax
        case T_PGFLT:
             pgfault_handler(tf);
80105b5c:	83 ec 0c             	sub    $0xc,%esp
80105b5f:	ff 75 08             	pushl  0x8(%ebp)
80105b62:	e8 4b ff ff ff       	call   80105ab2 <pgfault_handler>
80105b67:	83 c4 10             	add    $0x10,%esp
            break;
80105b6a:	e9 ac 01 00 00       	jmp    80105d1b <trap+0x20c>
        case T_IRQ0 + IRQ_TIMER:
            if(get_cpu() == 0){
80105b6f:	e8 f7 09 00 00       	call   8010656b <get_cpu>
80105b74:	85 c0                	test   %eax,%eax
80105b76:	75 0d                	jne    80105b85 <trap+0x76>
                ticks ++;
80105b78:	a1 a0 78 12 80       	mov    0x801278a0,%eax
80105b7d:	83 c0 01             	add    $0x1,%eax
80105b80:	a3 a0 78 12 80       	mov    %eax,0x801278a0
                   ticks++;
                   wakeup(&ticks);
                   release(&tickslock);
                   */
            }
            lapiceoi();
80105b85:	e8 27 03 00 00       	call   80105eb1 <lapiceoi>
            break;
80105b8a:	e9 8c 01 00 00       	jmp    80105d1b <trap+0x20c>
        case T_IRQ0 + IRQ_IDE0:
            //ideintr();
            lapiceoi();
80105b8f:	e8 1d 03 00 00       	call   80105eb1 <lapiceoi>
            break;
80105b94:	e9 82 01 00 00       	jmp    80105d1b <trap+0x20c>
        case T_IRQ0 + IRQ_IDE1:
            //ideintr();
            lapiceoi();
80105b99:	e8 13 03 00 00       	call   80105eb1 <lapiceoi>

            // Bochs generates spurious IDE1 interrupts.
            break;
80105b9e:	e9 78 01 00 00       	jmp    80105d1b <trap+0x20c>
        case T_IRQ0 + IRQ_KBD:
            kbd_intr();
80105ba3:	e8 ae 0d 00 00       	call   80106956 <kbd_intr>
            lapiceoi();
80105ba8:	e8 04 03 00 00       	call   80105eb1 <lapiceoi>
            break;
80105bad:	e9 69 01 00 00       	jmp    80105d1b <trap+0x20c>
               lapiceoi();
               */
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb5:	8b 70 38             	mov    0x38(%eax),%esi
                    get_cpu(), tf->cs, tf->eip);
80105bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80105bbb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
               lapiceoi();
               */
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bbf:	0f b7 d8             	movzwl %ax,%ebx
80105bc2:	e8 a4 09 00 00       	call   8010656b <get_cpu>
80105bc7:	56                   	push   %esi
80105bc8:	53                   	push   %ebx
80105bc9:	50                   	push   %eax
80105bca:	68 c0 b7 10 80       	push   $0x8010b7c0
80105bcf:	e8 03 11 00 00       	call   80106cd7 <cprintf>
80105bd4:	83 c4 10             	add    $0x10,%esp
                    get_cpu(), tf->cs, tf->eip);
            lapiceoi();
80105bd7:	e8 d5 02 00 00       	call   80105eb1 <lapiceoi>
            break;
80105bdc:	e9 3a 01 00 00       	jmp    80105d1b <trap+0x20c>

            //PAGEBREAK: 13
        default:
            ;
            cprintf("trapno : %d\n",tf->trapno);
80105be1:	8b 45 08             	mov    0x8(%ebp),%eax
80105be4:	8b 40 30             	mov    0x30(%eax),%eax
80105be7:	83 ec 08             	sub    $0x8,%esp
80105bea:	50                   	push   %eax
80105beb:	68 e4 b7 10 80       	push   $0x8010b7e4
80105bf0:	e8 e2 10 00 00       	call   80106cd7 <cprintf>
80105bf5:	83 c4 10             	add    $0x10,%esp
            if(tf->trapno == 13)
80105bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80105bfb:	8b 40 30             	mov    0x30(%eax),%eax
80105bfe:	83 f8 0d             	cmp    $0xd,%eax
80105c01:	0f 85 14 01 00 00    	jne    80105d1b <trap+0x20c>
            {
                cprintf("trapframe at %p\n", tf);
80105c07:	83 ec 08             	sub    $0x8,%esp
80105c0a:	ff 75 08             	pushl  0x8(%ebp)
80105c0d:	68 f1 b7 10 80       	push   $0x8010b7f1
80105c12:	e8 c0 10 00 00       	call   80106cd7 <cprintf>
80105c17:	83 c4 10             	add    $0x10,%esp
                cprintf("  ds   0x----%04x\n", tf->ds);
80105c1a:	8b 45 08             	mov    0x8(%ebp),%eax
80105c1d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
80105c21:	0f b7 c0             	movzwl %ax,%eax
80105c24:	83 ec 08             	sub    $0x8,%esp
80105c27:	50                   	push   %eax
80105c28:	68 02 b8 10 80       	push   $0x8010b802
80105c2d:	e8 a5 10 00 00       	call   80106cd7 <cprintf>
80105c32:	83 c4 10             	add    $0x10,%esp
                cprintf("  es   0x----%04x\n", tf->es);
80105c35:	8b 45 08             	mov    0x8(%ebp),%eax
80105c38:	0f b7 40 28          	movzwl 0x28(%eax),%eax
80105c3c:	0f b7 c0             	movzwl %ax,%eax
80105c3f:	83 ec 08             	sub    $0x8,%esp
80105c42:	50                   	push   %eax
80105c43:	68 15 b8 10 80       	push   $0x8010b815
80105c48:	e8 8a 10 00 00       	call   80106cd7 <cprintf>
80105c4d:	83 c4 10             	add    $0x10,%esp
                cprintf("  fs   0x----%04x\n", tf->fs);
80105c50:	8b 45 08             	mov    0x8(%ebp),%eax
80105c53:	0f b7 40 24          	movzwl 0x24(%eax),%eax
80105c57:	0f b7 c0             	movzwl %ax,%eax
80105c5a:	83 ec 08             	sub    $0x8,%esp
80105c5d:	50                   	push   %eax
80105c5e:	68 28 b8 10 80       	push   $0x8010b828
80105c63:	e8 6f 10 00 00       	call   80106cd7 <cprintf>
80105c68:	83 c4 10             	add    $0x10,%esp
                cprintf("  gs   0x----%04x\n", tf->gs);
80105c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c6e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
80105c72:	0f b7 c0             	movzwl %ax,%eax
80105c75:	83 ec 08             	sub    $0x8,%esp
80105c78:	50                   	push   %eax
80105c79:	68 3b b8 10 80       	push   $0x8010b83b
80105c7e:	e8 54 10 00 00       	call   80106cd7 <cprintf>
80105c83:	83 c4 10             	add    $0x10,%esp
                cprintf("  err  0x%08x\n", tf->err);
80105c86:	8b 45 08             	mov    0x8(%ebp),%eax
80105c89:	8b 40 34             	mov    0x34(%eax),%eax
80105c8c:	83 ec 08             	sub    $0x8,%esp
80105c8f:	50                   	push   %eax
80105c90:	68 4e b8 10 80       	push   $0x8010b84e
80105c95:	e8 3d 10 00 00       	call   80106cd7 <cprintf>
80105c9a:	83 c4 10             	add    $0x10,%esp
                cprintf("  eip  0x%08x\n", tf->eip);
80105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80105ca0:	8b 40 38             	mov    0x38(%eax),%eax
80105ca3:	83 ec 08             	sub    $0x8,%esp
80105ca6:	50                   	push   %eax
80105ca7:	68 5d b8 10 80       	push   $0x8010b85d
80105cac:	e8 26 10 00 00       	call   80106cd7 <cprintf>
80105cb1:	83 c4 10             	add    $0x10,%esp
                cprintf("  cs   0x----%04x\n", tf->cs);
80105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80105cb7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80105cbb:	0f b7 c0             	movzwl %ax,%eax
80105cbe:	83 ec 08             	sub    $0x8,%esp
80105cc1:	50                   	push   %eax
80105cc2:	68 6c b8 10 80       	push   $0x8010b86c
80105cc7:	e8 0b 10 00 00       	call   80106cd7 <cprintf>
80105ccc:	83 c4 10             	add    $0x10,%esp
                cprintf("  flag 0x%08x ", tf->eflags);
80105ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80105cd2:	8b 40 40             	mov    0x40(%eax),%eax
80105cd5:	83 ec 08             	sub    $0x8,%esp
80105cd8:	50                   	push   %eax
80105cd9:	68 7f b8 10 80       	push   $0x8010b87f
80105cde:	e8 f4 0f 00 00       	call   80106cd7 <cprintf>
80105ce3:	83 c4 10             	add    $0x10,%esp


                    cprintf("  esp  0x%08x\n", tf->esp);
80105ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80105ce9:	8b 40 44             	mov    0x44(%eax),%eax
80105cec:	83 ec 08             	sub    $0x8,%esp
80105cef:	50                   	push   %eax
80105cf0:	68 8e b8 10 80       	push   $0x8010b88e
80105cf5:	e8 dd 0f 00 00       	call   80106cd7 <cprintf>
80105cfa:	83 c4 10             	add    $0x10,%esp
                    cprintf("  ss   0x----%04x\n", tf->ss);
80105cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80105d00:	0f b7 40 48          	movzwl 0x48(%eax),%eax
80105d04:	0f b7 c0             	movzwl %ax,%eax
80105d07:	83 ec 08             	sub    $0x8,%esp
80105d0a:	50                   	push   %eax
80105d0b:	68 9d b8 10 80       	push   $0x8010b89d
80105d10:	e8 c2 0f 00 00       	call   80106cd7 <cprintf>
80105d15:	83 c4 10             	add    $0x10,%esp
                    while(1);
80105d18:	eb fe                	jmp    80105d18 <trap+0x209>
        case T_IRQ0 + IRQ_COM1:
            /*
               uartintr();
               lapiceoi();
               */
            break;
80105d1a:	90                   	nop

    // Check if the process has been killed since we yielded
    if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
    */
}
80105d1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d1e:	5b                   	pop    %ebx
80105d1f:	5e                   	pop    %esi
80105d20:	5d                   	pop    %ebp
80105d21:	c3                   	ret    

80105d22 <inb>:
    uint16_t limit;        // Limit
    uint32_t base;        // Base address
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
80105d22:	55                   	push   %ebp
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 14             	sub    $0x14,%esp
80105d28:	8b 45 08             	mov    0x8(%ebp),%eax
80105d2b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
80105d2f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80105d33:	89 c2                	mov    %eax,%edx
80105d35:	ec                   	in     (%dx),%al
80105d36:	88 45 ff             	mov    %al,-0x1(%ebp)
    return data;
80105d39:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80105d3d:	c9                   	leave  
80105d3e:	c3                   	ret    

80105d3f <outb>:
        : "d" (port), "0" (addr), "1" (cnt)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
80105d3f:	55                   	push   %ebp
80105d40:	89 e5                	mov    %esp,%ebp
80105d42:	83 ec 08             	sub    $0x8,%esp
80105d45:	8b 55 08             	mov    0x8(%ebp),%edx
80105d48:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d4b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80105d4f:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
80105d52:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80105d56:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80105d5a:	ee                   	out    %al,(%dx)
}
80105d5b:	90                   	nop
80105d5c:	c9                   	leave  
80105d5d:	c3                   	ret    

80105d5e <lapicw>:
#define TCCR    (0x0390/4)   // Timer Current Count
#define TDCR    (0x03E0/4)   // Timer Divide Configuration

static void
lapicw(int index, int value)
{
80105d5e:	55                   	push   %ebp
80105d5f:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80105d61:	a1 ac 78 12 80       	mov    0x801278ac,%eax
80105d66:	8b 55 08             	mov    0x8(%ebp),%edx
80105d69:	c1 e2 02             	shl    $0x2,%edx
80105d6c:	01 c2                	add    %eax,%edx
80105d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d71:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80105d73:	a1 ac 78 12 80       	mov    0x801278ac,%eax
80105d78:	83 c0 20             	add    $0x20,%eax
80105d7b:	8b 00                	mov    (%eax),%eax
}
80105d7d:	90                   	nop
80105d7e:	5d                   	pop    %ebp
80105d7f:	c3                   	ret    

80105d80 <lapicinit>:


void
lapicinit(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80105d86:	a1 ac 78 12 80       	mov    0x801278ac,%eax
80105d8b:	85 c0                	test   %eax,%eax
80105d8d:	0f 84 1b 01 00 00    	je     80105eae <lapicinit+0x12e>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80105d93:	68 3f 01 00 00       	push   $0x13f
80105d98:	6a 3c                	push   $0x3c
80105d9a:	e8 bf ff ff ff       	call   80105d5e <lapicw>
80105d9f:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80105da2:	6a 0b                	push   $0xb
80105da4:	68 f8 00 00 00       	push   $0xf8
80105da9:	e8 b0 ff ff ff       	call   80105d5e <lapicw>
80105dae:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80105db1:	68 20 00 02 00       	push   $0x20020
80105db6:	68 c8 00 00 00       	push   $0xc8
80105dbb:	e8 9e ff ff ff       	call   80105d5e <lapicw>
80105dc0:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80105dc3:	68 80 96 98 00       	push   $0x989680
80105dc8:	68 e0 00 00 00       	push   $0xe0
80105dcd:	e8 8c ff ff ff       	call   80105d5e <lapicw>
80105dd2:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80105dd5:	68 00 00 01 00       	push   $0x10000
80105dda:	68 d4 00 00 00       	push   $0xd4
80105ddf:	e8 7a ff ff ff       	call   80105d5e <lapicw>
80105de4:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80105de7:	68 00 00 01 00       	push   $0x10000
80105dec:	68 d8 00 00 00       	push   $0xd8
80105df1:	e8 68 ff ff ff       	call   80105d5e <lapicw>
80105df6:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80105df9:	a1 ac 78 12 80       	mov    0x801278ac,%eax
80105dfe:	83 c0 30             	add    $0x30,%eax
80105e01:	8b 00                	mov    (%eax),%eax
80105e03:	c1 e8 10             	shr    $0x10,%eax
80105e06:	0f b6 c0             	movzbl %al,%eax
80105e09:	83 f8 03             	cmp    $0x3,%eax
80105e0c:	76 12                	jbe    80105e20 <lapicinit+0xa0>
    lapicw(PCINT, MASKED);
80105e0e:	68 00 00 01 00       	push   $0x10000
80105e13:	68 d0 00 00 00       	push   $0xd0
80105e18:	e8 41 ff ff ff       	call   80105d5e <lapicw>
80105e1d:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80105e20:	6a 33                	push   $0x33
80105e22:	68 dc 00 00 00       	push   $0xdc
80105e27:	e8 32 ff ff ff       	call   80105d5e <lapicw>
80105e2c:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80105e2f:	6a 00                	push   $0x0
80105e31:	68 a0 00 00 00       	push   $0xa0
80105e36:	e8 23 ff ff ff       	call   80105d5e <lapicw>
80105e3b:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80105e3e:	6a 00                	push   $0x0
80105e40:	68 a0 00 00 00       	push   $0xa0
80105e45:	e8 14 ff ff ff       	call   80105d5e <lapicw>
80105e4a:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80105e4d:	6a 00                	push   $0x0
80105e4f:	6a 2c                	push   $0x2c
80105e51:	e8 08 ff ff ff       	call   80105d5e <lapicw>
80105e56:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80105e59:	6a 00                	push   $0x0
80105e5b:	68 c4 00 00 00       	push   $0xc4
80105e60:	e8 f9 fe ff ff       	call   80105d5e <lapicw>
80105e65:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80105e68:	68 00 85 08 00       	push   $0x88500
80105e6d:	68 c0 00 00 00       	push   $0xc0
80105e72:	e8 e7 fe ff ff       	call   80105d5e <lapicw>
80105e77:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80105e7a:	90                   	nop
80105e7b:	a1 ac 78 12 80       	mov    0x801278ac,%eax
80105e80:	05 00 03 00 00       	add    $0x300,%eax
80105e85:	8b 00                	mov    (%eax),%eax
80105e87:	25 00 10 00 00       	and    $0x1000,%eax
80105e8c:	85 c0                	test   %eax,%eax
80105e8e:	75 eb                	jne    80105e7b <lapicinit+0xfb>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80105e90:	6a 00                	push   $0x0
80105e92:	6a 20                	push   $0x20
80105e94:	e8 c5 fe ff ff       	call   80105d5e <lapicw>
80105e99:	83 c4 08             	add    $0x8,%esp
  cprintf(INITOK"lapic ok!\n");
80105e9c:	83 ec 0c             	sub    $0xc,%esp
80105e9f:	68 78 b9 10 80       	push   $0x8010b978
80105ea4:	e8 2e 0e 00 00       	call   80106cd7 <cprintf>
80105ea9:	83 c4 10             	add    $0x10,%esp
80105eac:	eb 01                	jmp    80105eaf <lapicinit+0x12f>

void
lapicinit(void)
{
  if(!lapic)
    return;
80105eae:	90                   	nop
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  cprintf(INITOK"lapic ok!\n");
}
80105eaf:	c9                   	leave  
80105eb0:	c3                   	ret    

80105eb1 <lapiceoi>:


// Acknowledge interrupt.
void
lapiceoi(void)
{
80105eb1:	55                   	push   %ebp
80105eb2:	89 e5                	mov    %esp,%ebp
  if(lapic)
80105eb4:	a1 ac 78 12 80       	mov    0x801278ac,%eax
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	74 0c                	je     80105ec9 <lapiceoi+0x18>
    lapicw(EOI, 0);
80105ebd:	6a 00                	push   $0x0
80105ebf:	6a 2c                	push   $0x2c
80105ec1:	e8 98 fe ff ff       	call   80105d5e <lapicw>
80105ec6:	83 c4 08             	add    $0x8,%esp
}
80105ec9:	90                   	nop
80105eca:	c9                   	leave  
80105ecb:	c3                   	ret    

80105ecc <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80105ecc:	55                   	push   %ebp
80105ecd:	89 e5                	mov    %esp,%ebp
}
80105ecf:	90                   	nop
80105ed0:	5d                   	pop    %ebp
80105ed1:	c3                   	ret    

80105ed2 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80105ed2:	55                   	push   %ebp
80105ed3:	89 e5                	mov    %esp,%ebp
80105ed5:	83 ec 14             	sub    $0x14,%esp
80105ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80105edb:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80105ede:	6a 0f                	push   $0xf
80105ee0:	6a 70                	push   $0x70
80105ee2:	e8 58 fe ff ff       	call   80105d3f <outb>
80105ee7:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80105eea:	6a 0a                	push   $0xa
80105eec:	6a 71                	push   $0x71
80105eee:	e8 4c fe ff ff       	call   80105d3f <outb>
80105ef3:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80105ef6:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80105efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f00:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80105f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f08:	83 c0 02             	add    $0x2,%eax
80105f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
80105f0e:	c1 ea 04             	shr    $0x4,%edx
80105f11:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80105f14:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80105f18:	c1 e0 18             	shl    $0x18,%eax
80105f1b:	50                   	push   %eax
80105f1c:	68 c4 00 00 00       	push   $0xc4
80105f21:	e8 38 fe ff ff       	call   80105d5e <lapicw>
80105f26:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80105f29:	68 00 c5 00 00       	push   $0xc500
80105f2e:	68 c0 00 00 00       	push   $0xc0
80105f33:	e8 26 fe ff ff       	call   80105d5e <lapicw>
80105f38:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80105f3b:	68 c8 00 00 00       	push   $0xc8
80105f40:	e8 87 ff ff ff       	call   80105ecc <microdelay>
80105f45:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80105f48:	68 00 85 00 00       	push   $0x8500
80105f4d:	68 c0 00 00 00       	push   $0xc0
80105f52:	e8 07 fe ff ff       	call   80105d5e <lapicw>
80105f57:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80105f5a:	6a 64                	push   $0x64
80105f5c:	e8 6b ff ff ff       	call   80105ecc <microdelay>
80105f61:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80105f64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105f6b:	eb 3d                	jmp    80105faa <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80105f6d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80105f71:	c1 e0 18             	shl    $0x18,%eax
80105f74:	50                   	push   %eax
80105f75:	68 c4 00 00 00       	push   $0xc4
80105f7a:	e8 df fd ff ff       	call   80105d5e <lapicw>
80105f7f:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80105f82:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f85:	c1 e8 0c             	shr    $0xc,%eax
80105f88:	80 cc 06             	or     $0x6,%ah
80105f8b:	50                   	push   %eax
80105f8c:	68 c0 00 00 00       	push   $0xc0
80105f91:	e8 c8 fd ff ff       	call   80105d5e <lapicw>
80105f96:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80105f99:	68 c8 00 00 00       	push   $0xc8
80105f9e:	e8 29 ff ff ff       	call   80105ecc <microdelay>
80105fa3:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80105fa6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105faa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80105fae:	7e bd                	jle    80105f6d <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80105fb0:	90                   	nop
80105fb1:	c9                   	leave  
80105fb2:	c3                   	ret    

80105fb3 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80105fb3:	55                   	push   %ebp
80105fb4:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80105fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb9:	0f b6 c0             	movzbl %al,%eax
80105fbc:	50                   	push   %eax
80105fbd:	6a 70                	push   $0x70
80105fbf:	e8 7b fd ff ff       	call   80105d3f <outb>
80105fc4:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80105fc7:	68 c8 00 00 00       	push   $0xc8
80105fcc:	e8 fb fe ff ff       	call   80105ecc <microdelay>
80105fd1:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80105fd4:	6a 71                	push   $0x71
80105fd6:	e8 47 fd ff ff       	call   80105d22 <inb>
80105fdb:	83 c4 04             	add    $0x4,%esp
80105fde:	0f b6 c0             	movzbl %al,%eax
}
80105fe1:	c9                   	leave  
80105fe2:	c3                   	ret    

80105fe3 <fill_rtcdate>:
static void fill_rtcdate(struct rtcdate *r)
{
80105fe3:	55                   	push   %ebp
80105fe4:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80105fe6:	6a 00                	push   $0x0
80105fe8:	e8 c6 ff ff ff       	call   80105fb3 <cmos_read>
80105fed:	83 c4 04             	add    $0x4,%esp
80105ff0:	89 c2                	mov    %eax,%edx
80105ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff5:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80105ff7:	6a 02                	push   $0x2
80105ff9:	e8 b5 ff ff ff       	call   80105fb3 <cmos_read>
80105ffe:	83 c4 04             	add    $0x4,%esp
80106001:	89 c2                	mov    %eax,%edx
80106003:	8b 45 08             	mov    0x8(%ebp),%eax
80106006:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80106009:	6a 04                	push   $0x4
8010600b:	e8 a3 ff ff ff       	call   80105fb3 <cmos_read>
80106010:	83 c4 04             	add    $0x4,%esp
80106013:	89 c2                	mov    %eax,%edx
80106015:	8b 45 08             	mov    0x8(%ebp),%eax
80106018:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
8010601b:	6a 07                	push   $0x7
8010601d:	e8 91 ff ff ff       	call   80105fb3 <cmos_read>
80106022:	83 c4 04             	add    $0x4,%esp
80106025:	89 c2                	mov    %eax,%edx
80106027:	8b 45 08             	mov    0x8(%ebp),%eax
8010602a:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010602d:	6a 08                	push   $0x8
8010602f:	e8 7f ff ff ff       	call   80105fb3 <cmos_read>
80106034:	83 c4 04             	add    $0x4,%esp
80106037:	89 c2                	mov    %eax,%edx
80106039:	8b 45 08             	mov    0x8(%ebp),%eax
8010603c:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010603f:	6a 09                	push   $0x9
80106041:	e8 6d ff ff ff       	call   80105fb3 <cmos_read>
80106046:	83 c4 04             	add    $0x4,%esp
80106049:	89 c2                	mov    %eax,%edx
8010604b:	8b 45 08             	mov    0x8(%ebp),%eax
8010604e:	89 50 14             	mov    %edx,0x14(%eax)
}
80106051:	90                   	nop
80106052:	c9                   	leave  
80106053:	c3                   	ret    

80106054 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010605a:	6a 0b                	push   $0xb
8010605c:	e8 52 ff ff ff       	call   80105fb3 <cmos_read>
80106061:	83 c4 04             	add    $0x4,%esp
80106064:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80106067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606a:	83 e0 04             	and    $0x4,%eax
8010606d:	85 c0                	test   %eax,%eax
8010606f:	0f 94 c0             	sete   %al
80106072:	0f b6 c0             	movzbl %al,%eax
80106075:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80106078:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010607b:	50                   	push   %eax
8010607c:	e8 62 ff ff ff       	call   80105fe3 <fill_rtcdate>
80106081:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80106084:	6a 0a                	push   $0xa
80106086:	e8 28 ff ff ff       	call   80105fb3 <cmos_read>
8010608b:	83 c4 04             	add    $0x4,%esp
8010608e:	25 80 00 00 00       	and    $0x80,%eax
80106093:	85 c0                	test   %eax,%eax
80106095:	75 27                	jne    801060be <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80106097:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010609a:	50                   	push   %eax
8010609b:	e8 43 ff ff ff       	call   80105fe3 <fill_rtcdate>
801060a0:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801060a3:	83 ec 04             	sub    $0x4,%esp
801060a6:	6a 18                	push   $0x18
801060a8:	8d 45 c0             	lea    -0x40(%ebp),%eax
801060ab:	50                   	push   %eax
801060ac:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060af:	50                   	push   %eax
801060b0:	e8 82 44 00 00       	call   8010a537 <memcmp>
801060b5:	83 c4 10             	add    $0x10,%esp
801060b8:	85 c0                	test   %eax,%eax
801060ba:	74 05                	je     801060c1 <cmostime+0x6d>
801060bc:	eb ba                	jmp    80106078 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801060be:	90                   	nop
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801060bf:	eb b7                	jmp    80106078 <cmostime+0x24>
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801060c1:	90                   	nop
  }

  // convert
  if(bcd) {
801060c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060c6:	0f 84 b4 00 00 00    	je     80106180 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801060cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801060cf:	c1 e8 04             	shr    $0x4,%eax
801060d2:	89 c2                	mov    %eax,%edx
801060d4:	89 d0                	mov    %edx,%eax
801060d6:	c1 e0 02             	shl    $0x2,%eax
801060d9:	01 d0                	add    %edx,%eax
801060db:	01 c0                	add    %eax,%eax
801060dd:	89 c2                	mov    %eax,%edx
801060df:	8b 45 d8             	mov    -0x28(%ebp),%eax
801060e2:	83 e0 0f             	and    $0xf,%eax
801060e5:	01 d0                	add    %edx,%eax
801060e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801060ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
801060ed:	c1 e8 04             	shr    $0x4,%eax
801060f0:	89 c2                	mov    %eax,%edx
801060f2:	89 d0                	mov    %edx,%eax
801060f4:	c1 e0 02             	shl    $0x2,%eax
801060f7:	01 d0                	add    %edx,%eax
801060f9:	01 c0                	add    %eax,%eax
801060fb:	89 c2                	mov    %eax,%edx
801060fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106100:	83 e0 0f             	and    $0xf,%eax
80106103:	01 d0                	add    %edx,%eax
80106105:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80106108:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010610b:	c1 e8 04             	shr    $0x4,%eax
8010610e:	89 c2                	mov    %eax,%edx
80106110:	89 d0                	mov    %edx,%eax
80106112:	c1 e0 02             	shl    $0x2,%eax
80106115:	01 d0                	add    %edx,%eax
80106117:	01 c0                	add    %eax,%eax
80106119:	89 c2                	mov    %eax,%edx
8010611b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010611e:	83 e0 0f             	and    $0xf,%eax
80106121:	01 d0                	add    %edx,%eax
80106123:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80106126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106129:	c1 e8 04             	shr    $0x4,%eax
8010612c:	89 c2                	mov    %eax,%edx
8010612e:	89 d0                	mov    %edx,%eax
80106130:	c1 e0 02             	shl    $0x2,%eax
80106133:	01 d0                	add    %edx,%eax
80106135:	01 c0                	add    %eax,%eax
80106137:	89 c2                	mov    %eax,%edx
80106139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010613c:	83 e0 0f             	and    $0xf,%eax
8010613f:	01 d0                	add    %edx,%eax
80106141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80106144:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106147:	c1 e8 04             	shr    $0x4,%eax
8010614a:	89 c2                	mov    %eax,%edx
8010614c:	89 d0                	mov    %edx,%eax
8010614e:	c1 e0 02             	shl    $0x2,%eax
80106151:	01 d0                	add    %edx,%eax
80106153:	01 c0                	add    %eax,%eax
80106155:	89 c2                	mov    %eax,%edx
80106157:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010615a:	83 e0 0f             	and    $0xf,%eax
8010615d:	01 d0                	add    %edx,%eax
8010615f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80106162:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106165:	c1 e8 04             	shr    $0x4,%eax
80106168:	89 c2                	mov    %eax,%edx
8010616a:	89 d0                	mov    %edx,%eax
8010616c:	c1 e0 02             	shl    $0x2,%eax
8010616f:	01 d0                	add    %edx,%eax
80106171:	01 c0                	add    %eax,%eax
80106173:	89 c2                	mov    %eax,%edx
80106175:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106178:	83 e0 0f             	and    $0xf,%eax
8010617b:	01 d0                	add    %edx,%eax
8010617d:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80106180:	8b 45 08             	mov    0x8(%ebp),%eax
80106183:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106186:	89 10                	mov    %edx,(%eax)
80106188:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010618b:	89 50 04             	mov    %edx,0x4(%eax)
8010618e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106191:	89 50 08             	mov    %edx,0x8(%eax)
80106194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106197:	89 50 0c             	mov    %edx,0xc(%eax)
8010619a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010619d:	89 50 10             	mov    %edx,0x10(%eax)
801061a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801061a3:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801061a6:	8b 45 08             	mov    0x8(%ebp),%eax
801061a9:	8b 40 14             	mov    0x14(%eax),%eax
801061ac:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801061b2:	8b 45 08             	mov    0x8(%ebp),%eax
801061b5:	89 50 14             	mov    %edx,0x14(%eax)
}
801061b8:	90                   	nop
801061b9:	c9                   	leave  
801061ba:	c3                   	ret    

801061bb <lapicid>:

int
lapicid(void)
{
801061bb:	55                   	push   %ebp
801061bc:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801061be:	a1 ac 78 12 80       	mov    0x801278ac,%eax
801061c3:	85 c0                	test   %eax,%eax
801061c5:	75 07                	jne    801061ce <lapicid+0x13>
    return 0;
801061c7:	b8 00 00 00 00       	mov    $0x0,%eax
801061cc:	eb 0d                	jmp    801061db <lapicid+0x20>
  return lapic[ID] >> 24;
801061ce:	a1 ac 78 12 80       	mov    0x801278ac,%eax
801061d3:	83 c0 20             	add    $0x20,%eax
801061d6:	8b 00                	mov    (%eax),%eax
801061d8:	c1 e8 18             	shr    $0x18,%eax
}
801061db:	5d                   	pop    %ebp
801061dc:	c3                   	ret    

801061dd <inb>:
    uint16_t limit;        // Limit
    uint32_t base;        // Base address
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
801061dd:	55                   	push   %ebp
801061de:	89 e5                	mov    %esp,%ebp
801061e0:	83 ec 14             	sub    $0x14,%esp
801061e3:	8b 45 08             	mov    0x8(%ebp),%eax
801061e6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
801061ea:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801061ee:	89 c2                	mov    %eax,%edx
801061f0:	ec                   	in     (%dx),%al
801061f1:	88 45 ff             	mov    %al,-0x1(%ebp)
    return data;
801061f4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801061f8:	c9                   	leave  
801061f9:	c3                   	ret    

801061fa <outb>:
        : "d" (port), "0" (addr), "1" (cnt)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
801061fa:	55                   	push   %ebp
801061fb:	89 e5                	mov    %esp,%ebp
801061fd:	83 ec 08             	sub    $0x8,%esp
80106200:	8b 55 08             	mov    0x8(%ebp),%edx
80106203:	8b 45 0c             	mov    0xc(%ebp),%eax
80106206:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010620a:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
8010620d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106211:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106215:	ee                   	out    %al,(%dx)
}
80106216:	90                   	nop
80106217:	c9                   	leave  
80106218:	c3                   	ret    

80106219 <sum>:
volatile uint *lapic;


    static uchar
sum(uchar *addr, int len)
{
80106219:	55                   	push   %ebp
8010621a:	89 e5                	mov    %esp,%ebp
8010621c:	83 ec 10             	sub    $0x10,%esp
    int i, sum;

    sum = 0;
8010621f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(i=0; i<len; i++)
80106226:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010622d:	eb 15                	jmp    80106244 <sum+0x2b>
        sum += addr[i];
8010622f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106232:	8b 45 08             	mov    0x8(%ebp),%eax
80106235:	01 d0                	add    %edx,%eax
80106237:	0f b6 00             	movzbl (%eax),%eax
8010623a:	0f b6 c0             	movzbl %al,%eax
8010623d:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
    int i, sum;

    sum = 0;
    for(i=0; i<len; i++)
80106240:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106244:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106247:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010624a:	7c e3                	jl     8010622f <sum+0x16>
        sum += addr[i];
    return sum;
8010624c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010624f:	c9                   	leave  
80106250:	c3                   	ret    

80106251 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
    static struct mp*
mpsearch1(uint a, int len)
{
80106251:	55                   	push   %ebp
80106252:	89 e5                	mov    %esp,%ebp
80106254:	83 ec 18             	sub    $0x18,%esp
    uchar *e, *p, *addr;

    addr = P2V(a);
80106257:	8b 45 08             	mov    0x8(%ebp),%eax
8010625a:	05 00 00 00 80       	add    $0x80000000,%eax
8010625f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    e = addr+len;
80106262:	8b 55 0c             	mov    0xc(%ebp),%edx
80106265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106268:	01 d0                	add    %edx,%eax
8010626a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(p = addr; p < e; p += sizeof(struct mp))
8010626d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106270:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106273:	eb 36                	jmp    801062ab <mpsearch1+0x5a>
        if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80106275:	83 ec 04             	sub    $0x4,%esp
80106278:	6a 04                	push   $0x4
8010627a:	68 90 b9 10 80       	push   $0x8010b990
8010627f:	ff 75 f4             	pushl  -0xc(%ebp)
80106282:	e8 b0 42 00 00       	call   8010a537 <memcmp>
80106287:	83 c4 10             	add    $0x10,%esp
8010628a:	85 c0                	test   %eax,%eax
8010628c:	75 19                	jne    801062a7 <mpsearch1+0x56>
8010628e:	83 ec 08             	sub    $0x8,%esp
80106291:	6a 10                	push   $0x10
80106293:	ff 75 f4             	pushl  -0xc(%ebp)
80106296:	e8 7e ff ff ff       	call   80106219 <sum>
8010629b:	83 c4 10             	add    $0x10,%esp
8010629e:	84 c0                	test   %al,%al
801062a0:	75 05                	jne    801062a7 <mpsearch1+0x56>
            return (struct mp*)p;
801062a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a5:	eb 11                	jmp    801062b8 <mpsearch1+0x67>
{
    uchar *e, *p, *addr;

    addr = P2V(a);
    e = addr+len;
    for(p = addr; p < e; p += sizeof(struct mp))
801062a7:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801062ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801062b1:	72 c2                	jb     80106275 <mpsearch1+0x24>
        if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
            return (struct mp*)p;
    return 0;
801062b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062b8:	c9                   	leave  
801062b9:	c3                   	ret    

801062ba <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xF0000 and 0xFFFFF.
    static struct mp*
mpsearch(void)
{
801062ba:	55                   	push   %ebp
801062bb:	89 e5                	mov    %esp,%ebp
801062bd:	83 ec 18             	sub    $0x18,%esp
    uchar *bda;
    uint p;
    struct mp *mp;

    bda = (uchar *) P2V(0x400);
801062c0:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
    if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801062c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ca:	83 c0 0f             	add    $0xf,%eax
801062cd:	0f b6 00             	movzbl (%eax),%eax
801062d0:	0f b6 c0             	movzbl %al,%eax
801062d3:	c1 e0 08             	shl    $0x8,%eax
801062d6:	89 c2                	mov    %eax,%edx
801062d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062db:	83 c0 0e             	add    $0xe,%eax
801062de:	0f b6 00             	movzbl (%eax),%eax
801062e1:	0f b6 c0             	movzbl %al,%eax
801062e4:	09 d0                	or     %edx,%eax
801062e6:	c1 e0 04             	shl    $0x4,%eax
801062e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062f0:	74 21                	je     80106313 <mpsearch+0x59>
        if((mp = mpsearch1(p, 1024)))
801062f2:	83 ec 08             	sub    $0x8,%esp
801062f5:	68 00 04 00 00       	push   $0x400
801062fa:	ff 75 f0             	pushl  -0x10(%ebp)
801062fd:	e8 4f ff ff ff       	call   80106251 <mpsearch1>
80106302:	83 c4 10             	add    $0x10,%esp
80106305:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106308:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010630c:	74 51                	je     8010635f <mpsearch+0xa5>
            return mp;
8010630e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106311:	eb 61                	jmp    80106374 <mpsearch+0xba>
    } else {
        p = ((bda[0x14]<<8)|bda[0x13])*1024;
80106313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106316:	83 c0 14             	add    $0x14,%eax
80106319:	0f b6 00             	movzbl (%eax),%eax
8010631c:	0f b6 c0             	movzbl %al,%eax
8010631f:	c1 e0 08             	shl    $0x8,%eax
80106322:	89 c2                	mov    %eax,%edx
80106324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106327:	83 c0 13             	add    $0x13,%eax
8010632a:	0f b6 00             	movzbl (%eax),%eax
8010632d:	0f b6 c0             	movzbl %al,%eax
80106330:	09 d0                	or     %edx,%eax
80106332:	c1 e0 0a             	shl    $0xa,%eax
80106335:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if((mp = mpsearch1(p-1024, 1024)))
80106338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010633b:	2d 00 04 00 00       	sub    $0x400,%eax
80106340:	83 ec 08             	sub    $0x8,%esp
80106343:	68 00 04 00 00       	push   $0x400
80106348:	50                   	push   %eax
80106349:	e8 03 ff ff ff       	call   80106251 <mpsearch1>
8010634e:	83 c4 10             	add    $0x10,%esp
80106351:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106354:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106358:	74 05                	je     8010635f <mpsearch+0xa5>
            return mp;
8010635a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010635d:	eb 15                	jmp    80106374 <mpsearch+0xba>
    }
    return mpsearch1(0xF0000, 0x10000);
8010635f:	83 ec 08             	sub    $0x8,%esp
80106362:	68 00 00 01 00       	push   $0x10000
80106367:	68 00 00 0f 00       	push   $0xf0000
8010636c:	e8 e0 fe ff ff       	call   80106251 <mpsearch1>
80106371:	83 c4 10             	add    $0x10,%esp
}
80106374:	c9                   	leave  
80106375:	c3                   	ret    

80106376 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
    static struct mpconf*
mpconfig(struct mp **pmp)
{
80106376:	55                   	push   %ebp
80106377:	89 e5                	mov    %esp,%ebp
80106379:	83 ec 18             	sub    $0x18,%esp
    struct mpconf *conf;
    struct mp *mp;

    if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010637c:	e8 39 ff ff ff       	call   801062ba <mpsearch>
80106381:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106388:	74 0a                	je     80106394 <mpconfig+0x1e>
8010638a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638d:	8b 40 04             	mov    0x4(%eax),%eax
80106390:	85 c0                	test   %eax,%eax
80106392:	75 07                	jne    8010639b <mpconfig+0x25>
        return 0;
80106394:	b8 00 00 00 00       	mov    $0x0,%eax
80106399:	eb 7a                	jmp    80106415 <mpconfig+0x9f>
    conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010639b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639e:	8b 40 04             	mov    0x4(%eax),%eax
801063a1:	05 00 00 00 80       	add    $0x80000000,%eax
801063a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(memcmp(conf, "PCMP", 4) != 0)
801063a9:	83 ec 04             	sub    $0x4,%esp
801063ac:	6a 04                	push   $0x4
801063ae:	68 95 b9 10 80       	push   $0x8010b995
801063b3:	ff 75 f0             	pushl  -0x10(%ebp)
801063b6:	e8 7c 41 00 00       	call   8010a537 <memcmp>
801063bb:	83 c4 10             	add    $0x10,%esp
801063be:	85 c0                	test   %eax,%eax
801063c0:	74 07                	je     801063c9 <mpconfig+0x53>
        return 0;
801063c2:	b8 00 00 00 00       	mov    $0x0,%eax
801063c7:	eb 4c                	jmp    80106415 <mpconfig+0x9f>
    if(conf->version != 1 && conf->version != 4)
801063c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063cc:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801063d0:	3c 01                	cmp    $0x1,%al
801063d2:	74 12                	je     801063e6 <mpconfig+0x70>
801063d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d7:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801063db:	3c 04                	cmp    $0x4,%al
801063dd:	74 07                	je     801063e6 <mpconfig+0x70>
        return 0;
801063df:	b8 00 00 00 00       	mov    $0x0,%eax
801063e4:	eb 2f                	jmp    80106415 <mpconfig+0x9f>
    if(sum((uchar*)conf, conf->length) != 0)
801063e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801063ed:	0f b7 c0             	movzwl %ax,%eax
801063f0:	83 ec 08             	sub    $0x8,%esp
801063f3:	50                   	push   %eax
801063f4:	ff 75 f0             	pushl  -0x10(%ebp)
801063f7:	e8 1d fe ff ff       	call   80106219 <sum>
801063fc:	83 c4 10             	add    $0x10,%esp
801063ff:	84 c0                	test   %al,%al
80106401:	74 07                	je     8010640a <mpconfig+0x94>
        return 0;
80106403:	b8 00 00 00 00       	mov    $0x0,%eax
80106408:	eb 0b                	jmp    80106415 <mpconfig+0x9f>
    *pmp = mp;
8010640a:	8b 45 08             	mov    0x8(%ebp),%eax
8010640d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106410:	89 10                	mov    %edx,(%eax)
    return conf;
80106412:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106415:	c9                   	leave  
80106416:	c3                   	ret    

80106417 <mpinit>:

    void
mpinit(void)
{
80106417:	55                   	push   %ebp
80106418:	89 e5                	mov    %esp,%ebp
8010641a:	83 ec 28             	sub    $0x28,%esp
    struct mpconf *conf;
    struct mpproc *proc;
    struct mpioapic *ioapic;


    if((conf = mpconfig(&mp)) == 0)
8010641d:	83 ec 0c             	sub    $0xc,%esp
80106420:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106423:	50                   	push   %eax
80106424:	e8 4d ff ff ff       	call   80106376 <mpconfig>
80106429:	83 c4 10             	add    $0x10,%esp
8010642c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010642f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106433:	0f 84 1f 01 00 00    	je     80106558 <mpinit+0x141>
        return;
    ismp = 1;
80106439:	c7 05 a8 78 12 80 01 	movl   $0x1,0x801278a8
80106440:	00 00 00 
    lapic = (uint*)conf->lapicaddr;
80106443:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106446:	8b 40 24             	mov    0x24(%eax),%eax
80106449:	a3 ac 78 12 80       	mov    %eax,0x801278ac
    for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010644e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106451:	83 c0 2c             	add    $0x2c,%eax
80106454:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106457:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010645a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010645e:	0f b7 d0             	movzwl %ax,%edx
80106461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106464:	01 d0                	add    %edx,%eax
80106466:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106469:	eb 7e                	jmp    801064e9 <mpinit+0xd2>
        switch(*p){
8010646b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646e:	0f b6 00             	movzbl (%eax),%eax
80106471:	0f b6 c0             	movzbl %al,%eax
80106474:	83 f8 04             	cmp    $0x4,%eax
80106477:	77 65                	ja     801064de <mpinit+0xc7>
80106479:	8b 04 85 9c b9 10 80 	mov    -0x7fef4664(,%eax,4),%eax
80106480:	ff e0                	jmp    *%eax
            case MPPROC:
                proc = (struct mpproc*)p;
80106482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106485:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if(ncpu < NCPU) {
80106488:	a1 54 6f 12 80       	mov    0x80126f54,%eax
8010648d:	83 f8 03             	cmp    $0x3,%eax
80106490:	77 28                	ja     801064ba <mpinit+0xa3>
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80106492:	8b 15 54 6f 12 80    	mov    0x80126f54,%edx
80106498:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010649b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010649f:	69 d2 b4 00 00 00    	imul   $0xb4,%edx,%edx
801064a5:	81 c2 fc 78 12 80    	add    $0x801278fc,%edx
801064ab:	88 02                	mov    %al,(%edx)
                    ncpu++;
801064ad:	a1 54 6f 12 80       	mov    0x80126f54,%eax
801064b2:	83 c0 01             	add    $0x1,%eax
801064b5:	a3 54 6f 12 80       	mov    %eax,0x80126f54
                }
                p += sizeof(struct mpproc);
801064ba:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
                continue;
801064be:	eb 29                	jmp    801064e9 <mpinit+0xd2>
            case MPIOAPIC:
                ioapic = (struct mpioapic*)p;
801064c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ioapicid = ioapic->apicno;
801064c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064c9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801064cd:	a2 a4 78 12 80       	mov    %al,0x801278a4
                p += sizeof(struct mpioapic);
801064d2:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
                continue;
801064d6:	eb 11                	jmp    801064e9 <mpinit+0xd2>
            case MPBUS:
            case MPIOINTR:
            case MPLINTR:
                p += 8;
801064d8:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
                continue;
801064dc:	eb 0b                	jmp    801064e9 <mpinit+0xd2>
            default:
                ismp = 0;
801064de:	c7 05 a8 78 12 80 00 	movl   $0x0,0x801278a8
801064e5:	00 00 00 
                break;
801064e8:	90                   	nop

    if((conf = mpconfig(&mp)) == 0)
        return;
    ismp = 1;
    lapic = (uint*)conf->lapicaddr;
    for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801064e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801064ef:	0f 82 76 ff ff ff    	jb     8010646b <mpinit+0x54>
            default:
                ismp = 0;
                break;
        }
    }
    if(!ismp){
801064f5:	a1 a8 78 12 80       	mov    0x801278a8,%eax
801064fa:	85 c0                	test   %eax,%eax
801064fc:	75 1d                	jne    8010651b <mpinit+0x104>
        // Didn't like what we found; fall back to no MP.
        ncpu = 1;
801064fe:	c7 05 54 6f 12 80 01 	movl   $0x1,0x80126f54
80106505:	00 00 00 
        lapic = 0;
80106508:	c7 05 ac 78 12 80 00 	movl   $0x0,0x801278ac
8010650f:	00 00 00 
        ioapicid = 0;
80106512:	c6 05 a4 78 12 80 00 	movb   $0x0,0x801278a4
        return;
80106519:	eb 3e                	jmp    80106559 <mpinit+0x142>
    }

    if(mp->imcrp){
8010651b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010651e:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80106522:	84 c0                	test   %al,%al
80106524:	74 33                	je     80106559 <mpinit+0x142>
        // Bochs doesn't support IMCR, so this doesn't run on Bochs.
        // But it would on real hardware.
        outb(0x22, 0x70);   // Select IMCR
80106526:	83 ec 08             	sub    $0x8,%esp
80106529:	6a 70                	push   $0x70
8010652b:	6a 22                	push   $0x22
8010652d:	e8 c8 fc ff ff       	call   801061fa <outb>
80106532:	83 c4 10             	add    $0x10,%esp
        outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80106535:	83 ec 0c             	sub    $0xc,%esp
80106538:	6a 23                	push   $0x23
8010653a:	e8 9e fc ff ff       	call   801061dd <inb>
8010653f:	83 c4 10             	add    $0x10,%esp
80106542:	83 c8 01             	or     $0x1,%eax
80106545:	0f b6 c0             	movzbl %al,%eax
80106548:	83 ec 08             	sub    $0x8,%esp
8010654b:	50                   	push   %eax
8010654c:	6a 23                	push   $0x23
8010654e:	e8 a7 fc ff ff       	call   801061fa <outb>
80106553:	83 c4 10             	add    $0x10,%esp
80106556:	eb 01                	jmp    80106559 <mpinit+0x142>
    struct mpproc *proc;
    struct mpioapic *ioapic;


    if((conf = mpconfig(&mp)) == 0)
        return;
80106558:	90                   	nop
        outb(0x22, 0x70);   // Select IMCR
        outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
    }

    //  cprintf("smp : %d , cpu_num : %d , lapic_addr: 0x%x\n", ismp, ncpu ,(uint)lapic);
}
80106559:	c9                   	leave  
8010655a:	c3                   	ret    

8010655b <readeflags>:
}


static inline uint
readeflags(void)
{
8010655b:	55                   	push   %ebp
8010655c:	89 e5                	mov    %esp,%ebp
8010655e:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106561:	9c                   	pushf  
80106562:	58                   	pop    %eax
80106563:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80106566:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106569:	c9                   	leave  
8010656a:	c3                   	ret    

8010656b <get_cpu>:
struct spinlock lock = {
  .locked = 0,
};

size_t get_cpu(void)
{
8010656b:	55                   	push   %ebp
8010656c:	89 e5                	mov    %esp,%ebp
8010656e:	83 ec 18             	sub    $0x18,%esp
//    return 0;
    int apicid;
    bool flag = false;
80106571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    size_t i;

    if(readeflags()&FL_IF)
80106578:	e8 de ff ff ff       	call   8010655b <readeflags>
8010657d:	25 00 02 00 00       	and    $0x200,%eax
80106582:	85 c0                	test   %eax,%eax
80106584:	74 08                	je     8010658e <get_cpu+0x23>
    {
        asm volatile("cli");
80106586:	fa                   	cli    
        flag = true;
80106587:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
;//        panic("mycpu called with interrupts enabled\n");

    }


    apicid = lapicid();
8010658e:	e8 28 fc ff ff       	call   801061bb <lapicid>
80106593:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(apicid == 0)
80106596:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010659a:	75 0e                	jne    801065aa <get_cpu+0x3f>
    {
        if (flag)     asm volatile("sti");
8010659c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065a0:	74 01                	je     801065a3 <get_cpu+0x38>
801065a2:	fb                   	sti    
        return 0;
801065a3:	b8 00 00 00 00       	mov    $0x0,%eax
801065a8:	eb 51                	jmp    801065fb <get_cpu+0x90>
    }
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
801065aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801065b1:	eb 22                	jmp    801065d5 <get_cpu+0x6a>
        if (cpus[i].apicid == apicid)
801065b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065b6:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801065bc:	05 fc 78 12 80       	add    $0x801278fc,%eax
801065c1:	0f b6 00             	movzbl (%eax),%eax
801065c4:	0f b6 c0             	movzbl %al,%eax
801065c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801065ca:	75 05                	jne    801065d1 <get_cpu+0x66>
        {
            return i;
801065cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065cf:	eb 2a                	jmp    801065fb <get_cpu+0x90>
        if (flag)     asm volatile("sti");
        return 0;
    }
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
801065d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801065d5:	a1 54 6f 12 80       	mov    0x80126f54,%eax
801065da:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801065dd:	72 d4                	jb     801065b3 <get_cpu+0x48>
        if (cpus[i].apicid == apicid)
        {
            return i;
        }
    }
    panic("unknown apicid\n");
801065df:	83 ec 04             	sub    $0x4,%esp
801065e2:	68 b0 b9 10 80       	push   $0x8010b9b0
801065e7:	6a 2d                	push   $0x2d
801065e9:	68 c0 b9 10 80       	push   $0x8010b9c0
801065ee:	e8 61 9d ff ff       	call   80100354 <__panic>
801065f3:	83 c4 10             	add    $0x10,%esp
    return 0;
801065f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065fb:	c9                   	leave  
801065fc:	c3                   	ret    

801065fd <inb>:
    uint16_t limit;        // Limit
    uint32_t base;        // Base address
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
801065fd:	55                   	push   %ebp
801065fe:	89 e5                	mov    %esp,%ebp
80106600:	83 ec 14             	sub    $0x14,%esp
80106603:	8b 45 08             	mov    0x8(%ebp),%eax
80106606:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
8010660a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010660e:	89 c2                	mov    %eax,%edx
80106610:	ec                   	in     (%dx),%al
80106611:	88 45 ff             	mov    %al,-0x1(%ebp)
    return data;
80106614:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106618:	c9                   	leave  
80106619:	c3                   	ret    

8010661a <outb>:
        : "d" (port), "0" (addr), "1" (cnt)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
8010661a:	55                   	push   %ebp
8010661b:	89 e5                	mov    %esp,%ebp
8010661d:	83 ec 08             	sub    $0x8,%esp
80106620:	8b 55 08             	mov    0x8(%ebp),%edx
80106623:	8b 45 0c             	mov    0xc(%ebp),%eax
80106626:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010662a:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
8010662d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106631:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106635:	ee                   	out    %al,(%dx)
}
80106636:	90                   	nop
80106637:	c9                   	leave  
80106638:	c3                   	ret    

80106639 <init_uart>:

static int is_uart;    // is there a uart?

    void
init_uart(void)
{
80106639:	55                   	push   %ebp
8010663a:	89 e5                	mov    %esp,%ebp
8010663c:	83 ec 18             	sub    $0x18,%esp
    char *p;

    // Turn off the FIFO
    outb(COM1+2, 0);
8010663f:	6a 00                	push   $0x0
80106641:	68 fa 03 00 00       	push   $0x3fa
80106646:	e8 cf ff ff ff       	call   8010661a <outb>
8010664b:	83 c4 08             	add    $0x8,%esp

    // 9600 baud, 8 data bits, 1 stop bit, parity off.
    outb(COM1+3, 0x80);    // Unlock divisor
8010664e:	68 80 00 00 00       	push   $0x80
80106653:	68 fb 03 00 00       	push   $0x3fb
80106658:	e8 bd ff ff ff       	call   8010661a <outb>
8010665d:	83 c4 08             	add    $0x8,%esp
    outb(COM1+0, 115200/9600);
80106660:	6a 0c                	push   $0xc
80106662:	68 f8 03 00 00       	push   $0x3f8
80106667:	e8 ae ff ff ff       	call   8010661a <outb>
8010666c:	83 c4 08             	add    $0x8,%esp
    outb(COM1+1, 0);
8010666f:	6a 00                	push   $0x0
80106671:	68 f9 03 00 00       	push   $0x3f9
80106676:	e8 9f ff ff ff       	call   8010661a <outb>
8010667b:	83 c4 08             	add    $0x8,%esp
    outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010667e:	6a 03                	push   $0x3
80106680:	68 fb 03 00 00       	push   $0x3fb
80106685:	e8 90 ff ff ff       	call   8010661a <outb>
8010668a:	83 c4 08             	add    $0x8,%esp
    outb(COM1+4, 0);
8010668d:	6a 00                	push   $0x0
8010668f:	68 fc 03 00 00       	push   $0x3fc
80106694:	e8 81 ff ff ff       	call   8010661a <outb>
80106699:	83 c4 08             	add    $0x8,%esp
    outb(COM1+1, 0x01);    // Enable receive interrupts.
8010669c:	6a 01                	push   $0x1
8010669e:	68 f9 03 00 00       	push   $0x3f9
801066a3:	e8 72 ff ff ff       	call   8010661a <outb>
801066a8:	83 c4 08             	add    $0x8,%esp

    // If status is 0xFF, no serial port.
    if(inb(COM1+5) == 0xFF)
801066ab:	68 fd 03 00 00       	push   $0x3fd
801066b0:	e8 48 ff ff ff       	call   801065fd <inb>
801066b5:	83 c4 04             	add    $0x4,%esp
801066b8:	3c ff                	cmp    $0xff,%al
801066ba:	74 52                	je     8010670e <init_uart+0xd5>
        return;
    is_uart = 1;
801066bc:	c7 05 64 6f 12 80 01 	movl   $0x1,0x80126f64
801066c3:	00 00 00 

    // Acknowledge pre-existing interrupt conditions;
    // enable interrupts.
    inb(COM1+2);
801066c6:	68 fa 03 00 00       	push   $0x3fa
801066cb:	e8 2d ff ff ff       	call   801065fd <inb>
801066d0:	83 c4 04             	add    $0x4,%esp
    inb(COM1+0);
801066d3:	68 f8 03 00 00       	push   $0x3f8
801066d8:	e8 20 ff ff ff       	call   801065fd <inb>
801066dd:	83 c4 04             	add    $0x4,%esp
    //  picenable(IRQ_COM1);
    //  ioapicenable(IRQ_COM1, 0);

    // Announce that we're here.
    for(p="uart...ok!\n"; *p; p++)
801066e0:	c7 45 f4 cf b9 10 80 	movl   $0x8010b9cf,-0xc(%ebp)
801066e7:	eb 19                	jmp    80106702 <init_uart+0xc9>
        putc_uart(*p);
801066e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ec:	0f b6 00             	movzbl (%eax),%eax
801066ef:	0f be c0             	movsbl %al,%eax
801066f2:	83 ec 0c             	sub    $0xc,%esp
801066f5:	50                   	push   %eax
801066f6:	e8 50 00 00 00       	call   8010674b <putc_uart>
801066fb:	83 c4 10             	add    $0x10,%esp
    inb(COM1+0);
    //  picenable(IRQ_COM1);
    //  ioapicenable(IRQ_COM1, 0);

    // Announce that we're here.
    for(p="uart...ok!\n"; *p; p++)
801066fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106705:	0f b6 00             	movzbl (%eax),%eax
80106708:	84 c0                	test   %al,%al
8010670a:	75 dd                	jne    801066e9 <init_uart+0xb0>
8010670c:	eb 01                	jmp    8010670f <init_uart+0xd6>
    outb(COM1+4, 0);
    outb(COM1+1, 0x01);    // Enable receive interrupts.

    // If status is 0xFF, no serial port.
    if(inb(COM1+5) == 0xFF)
        return;
8010670e:	90                   	nop
    //  ioapicenable(IRQ_COM1, 0);

    // Announce that we're here.
    for(p="uart...ok!\n"; *p; p++)
        putc_uart(*p);
}
8010670f:	c9                   	leave  
80106710:	c3                   	ret    

80106711 <delay>:

static void
delay(void) {
80106711:	55                   	push   %ebp
80106712:	89 e5                	mov    %esp,%ebp
    inb(0x84);
80106714:	68 84 00 00 00       	push   $0x84
80106719:	e8 df fe ff ff       	call   801065fd <inb>
8010671e:	83 c4 04             	add    $0x4,%esp
    inb(0x84);
80106721:	68 84 00 00 00       	push   $0x84
80106726:	e8 d2 fe ff ff       	call   801065fd <inb>
8010672b:	83 c4 04             	add    $0x4,%esp
    inb(0x84);
8010672e:	68 84 00 00 00       	push   $0x84
80106733:	e8 c5 fe ff ff       	call   801065fd <inb>
80106738:	83 c4 04             	add    $0x4,%esp
    inb(0x84);
8010673b:	68 84 00 00 00       	push   $0x84
80106740:	e8 b8 fe ff ff       	call   801065fd <inb>
80106745:	83 c4 04             	add    $0x4,%esp
}
80106748:	90                   	nop
80106749:	c9                   	leave  
8010674a:	c3                   	ret    

8010674b <putc_uart>:

    void
putc_uart(int c)
{
8010674b:	55                   	push   %ebp
8010674c:	89 e5                	mov    %esp,%ebp
8010674e:	83 ec 10             	sub    $0x10,%esp
    int i;

    if(!is_uart)
80106751:	a1 64 6f 12 80       	mov    0x80126f64,%eax
80106756:	85 c0                	test   %eax,%eax
80106758:	74 45                	je     8010679f <putc_uart+0x54>
        return;
    for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010675a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106761:	eb 09                	jmp    8010676c <putc_uart+0x21>
        delay();
80106763:	e8 a9 ff ff ff       	call   80106711 <delay>
{
    int i;

    if(!is_uart)
        return;
    for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106768:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010676c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
80106770:	7f 17                	jg     80106789 <putc_uart+0x3e>
80106772:	68 fd 03 00 00       	push   $0x3fd
80106777:	e8 81 fe ff ff       	call   801065fd <inb>
8010677c:	83 c4 04             	add    $0x4,%esp
8010677f:	0f b6 c0             	movzbl %al,%eax
80106782:	83 e0 20             	and    $0x20,%eax
80106785:	85 c0                	test   %eax,%eax
80106787:	74 da                	je     80106763 <putc_uart+0x18>
        delay();
    outb(COM1+0, c);
80106789:	8b 45 08             	mov    0x8(%ebp),%eax
8010678c:	0f b6 c0             	movzbl %al,%eax
8010678f:	50                   	push   %eax
80106790:	68 f8 03 00 00       	push   $0x3f8
80106795:	e8 80 fe ff ff       	call   8010661a <outb>
8010679a:	83 c4 08             	add    $0x8,%esp
8010679d:	eb 01                	jmp    801067a0 <putc_uart+0x55>
putc_uart(int c)
{
    int i;

    if(!is_uart)
        return;
8010679f:	90                   	nop
    for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
        delay();
    outb(COM1+0, c);
}
801067a0:	c9                   	leave  
801067a1:	c3                   	ret    

801067a2 <inb>:
    uint16_t limit;        // Limit
    uint32_t base;        // Base address
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
801067a2:	55                   	push   %ebp
801067a3:	89 e5                	mov    %esp,%ebp
801067a5:	83 ec 14             	sub    $0x14,%esp
801067a8:	8b 45 08             	mov    0x8(%ebp),%eax
801067ab:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
801067af:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801067b3:	89 c2                	mov    %eax,%edx
801067b5:	ec                   	in     (%dx),%al
801067b6:	88 45 ff             	mov    %al,-0x1(%ebp)
    return data;
801067b9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801067bd:	c9                   	leave  
801067be:	c3                   	ret    

801067bf <outb>:
        : "d" (port), "0" (addr), "1" (cnt)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
801067bf:	55                   	push   %ebp
801067c0:	89 e5                	mov    %esp,%ebp
801067c2:	83 ec 08             	sub    $0x8,%esp
801067c5:	8b 55 08             	mov    0x8(%ebp),%edx
801067c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801067cb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801067cf:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
801067d2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801067d6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801067da:	ee                   	out    %al,(%dx)
}
801067db:	90                   	nop
801067dc:	c9                   	leave  
801067dd:	c3                   	ret    

801067de <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
801067de:	55                   	push   %ebp
801067df:	89 e5                	mov    %esp,%ebp
801067e1:	83 ec 18             	sub    $0x18,%esp
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
801067e4:	6a 64                	push   $0x64
801067e6:	e8 b7 ff ff ff       	call   801067a2 <inb>
801067eb:	83 c4 04             	add    $0x4,%esp
801067ee:	0f b6 c0             	movzbl %al,%eax
801067f1:	83 e0 01             	and    $0x1,%eax
801067f4:	85 c0                	test   %eax,%eax
801067f6:	75 0a                	jne    80106802 <kbd_proc_data+0x24>
        return -1;
801067f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067fd:	e9 52 01 00 00       	jmp    80106954 <kbd_proc_data+0x176>
    }

    data = inb(KBDATAP);
80106802:	6a 60                	push   $0x60
80106804:	e8 99 ff ff ff       	call   801067a2 <inb>
80106809:	83 c4 04             	add    $0x4,%esp
8010680c:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
8010680f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
80106813:	75 17                	jne    8010682c <kbd_proc_data+0x4e>
        // E0 escape character
        shift |= E0ESC;
80106815:	a1 68 6f 12 80       	mov    0x80126f68,%eax
8010681a:	83 c8 40             	or     $0x40,%eax
8010681d:	a3 68 6f 12 80       	mov    %eax,0x80126f68
        return 0;
80106822:	b8 00 00 00 00       	mov    $0x0,%eax
80106827:	e9 28 01 00 00       	jmp    80106954 <kbd_proc_data+0x176>
    } else if (data & 0x80) {
8010682c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80106830:	84 c0                	test   %al,%al
80106832:	79 47                	jns    8010687b <kbd_proc_data+0x9d>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
80106834:	a1 68 6f 12 80       	mov    0x80126f68,%eax
80106839:	83 e0 40             	and    $0x40,%eax
8010683c:	85 c0                	test   %eax,%eax
8010683e:	75 09                	jne    80106849 <kbd_proc_data+0x6b>
80106840:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80106844:	83 e0 7f             	and    $0x7f,%eax
80106847:	eb 04                	jmp    8010684d <kbd_proc_data+0x6f>
80106849:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
8010684d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
80106850:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80106854:	0f b6 80 60 41 12 80 	movzbl -0x7fedbea0(%eax),%eax
8010685b:	83 c8 40             	or     $0x40,%eax
8010685e:	0f b6 c0             	movzbl %al,%eax
80106861:	f7 d0                	not    %eax
80106863:	89 c2                	mov    %eax,%edx
80106865:	a1 68 6f 12 80       	mov    0x80126f68,%eax
8010686a:	21 d0                	and    %edx,%eax
8010686c:	a3 68 6f 12 80       	mov    %eax,0x80126f68
        return 0;
80106871:	b8 00 00 00 00       	mov    $0x0,%eax
80106876:	e9 d9 00 00 00       	jmp    80106954 <kbd_proc_data+0x176>
    } else if (shift & E0ESC) {
8010687b:	a1 68 6f 12 80       	mov    0x80126f68,%eax
80106880:	83 e0 40             	and    $0x40,%eax
80106883:	85 c0                	test   %eax,%eax
80106885:	74 11                	je     80106898 <kbd_proc_data+0xba>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
80106887:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
8010688b:	a1 68 6f 12 80       	mov    0x80126f68,%eax
80106890:	83 e0 bf             	and    $0xffffffbf,%eax
80106893:	a3 68 6f 12 80       	mov    %eax,0x80126f68
    }

    shift |= shiftcode[data];
80106898:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
8010689c:	0f b6 80 60 41 12 80 	movzbl -0x7fedbea0(%eax),%eax
801068a3:	0f b6 d0             	movzbl %al,%edx
801068a6:	a1 68 6f 12 80       	mov    0x80126f68,%eax
801068ab:	09 d0                	or     %edx,%eax
801068ad:	a3 68 6f 12 80       	mov    %eax,0x80126f68
    shift ^= togglecode[data];
801068b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
801068b6:	0f b6 80 60 42 12 80 	movzbl -0x7fedbda0(%eax),%eax
801068bd:	0f b6 d0             	movzbl %al,%edx
801068c0:	a1 68 6f 12 80       	mov    0x80126f68,%eax
801068c5:	31 d0                	xor    %edx,%eax
801068c7:	a3 68 6f 12 80       	mov    %eax,0x80126f68

    c = charcode[shift & (CTL | SHIFT)][data];
801068cc:	a1 68 6f 12 80       	mov    0x80126f68,%eax
801068d1:	83 e0 03             	and    $0x3,%eax
801068d4:	8b 14 85 60 46 12 80 	mov    -0x7fedb9a0(,%eax,4),%edx
801068db:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
801068df:	01 d0                	add    %edx,%eax
801068e1:	0f b6 00             	movzbl (%eax),%eax
801068e4:	0f b6 c0             	movzbl %al,%eax
801068e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
801068ea:	a1 68 6f 12 80       	mov    0x80126f68,%eax
801068ef:	83 e0 08             	and    $0x8,%eax
801068f2:	85 c0                	test   %eax,%eax
801068f4:	74 22                	je     80106918 <kbd_proc_data+0x13a>
        if ('a' <= c && c <= 'z')
801068f6:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
801068fa:	7e 0c                	jle    80106908 <kbd_proc_data+0x12a>
801068fc:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
80106900:	7f 06                	jg     80106908 <kbd_proc_data+0x12a>
            c += 'A' - 'a';
80106902:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
80106906:	eb 10                	jmp    80106918 <kbd_proc_data+0x13a>
        else if ('A' <= c && c <= 'Z')
80106908:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
8010690c:	7e 0a                	jle    80106918 <kbd_proc_data+0x13a>
8010690e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
80106912:	7f 04                	jg     80106918 <kbd_proc_data+0x13a>
            c += 'a' - 'A';
80106914:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
80106918:	a1 68 6f 12 80       	mov    0x80126f68,%eax
8010691d:	f7 d0                	not    %eax
8010691f:	83 e0 06             	and    $0x6,%eax
80106922:	85 c0                	test   %eax,%eax
80106924:	75 2b                	jne    80106951 <kbd_proc_data+0x173>
80106926:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
8010692d:	75 22                	jne    80106951 <kbd_proc_data+0x173>
        cprintf("Rebooting!\n");
8010692f:	83 ec 0c             	sub    $0xc,%esp
80106932:	68 db b9 10 80       	push   $0x8010b9db
80106937:	e8 9b 03 00 00       	call   80106cd7 <cprintf>
8010693c:	83 c4 10             	add    $0x10,%esp
        outb(0x92, 0x3); // courtesy of Chris Frost
8010693f:	83 ec 08             	sub    $0x8,%esp
80106942:	6a 03                	push   $0x3
80106944:	68 92 00 00 00       	push   $0x92
80106949:	e8 71 fe ff ff       	call   801067bf <outb>
8010694e:	83 c4 10             	add    $0x10,%esp
    }
    return c;
80106951:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106954:	c9                   	leave  
80106955:	c3                   	ret    

80106956 <kbd_intr>:

void 
kbd_intr(void) {
80106956:	55                   	push   %ebp
80106957:	89 e5                	mov    %esp,%ebp
80106959:	83 ec 08             	sub    $0x8,%esp
    cprintf("kdb : %c\n",(char)kbd_proc_data());
8010695c:	e8 7d fe ff ff       	call   801067de <kbd_proc_data>
80106961:	0f be c0             	movsbl %al,%eax
80106964:	83 ec 08             	sub    $0x8,%esp
80106967:	50                   	push   %eax
80106968:	68 e7 b9 10 80       	push   $0x8010b9e7
8010696d:	e8 65 03 00 00       	call   80106cd7 <cprintf>
80106972:	83 c4 10             	add    $0x10,%esp
}
80106975:	90                   	nop
80106976:	c9                   	leave  
80106977:	c3                   	ret    

80106978 <kbd_init>:
void
kbd_init(void)
{
80106978:	55                   	push   %ebp
80106979:	89 e5                	mov    %esp,%ebp
8010697b:	83 ec 08             	sub    $0x8,%esp
    ioapicenable( IRQ_KBD,0);
8010697e:	83 ec 08             	sub    $0x8,%esp
80106981:	6a 00                	push   $0x0
80106983:	6a 01                	push   $0x1
80106985:	e8 a3 ee ff ff       	call   8010582d <ioapicenable>
8010698a:	83 c4 10             	add    $0x10,%esp
}
8010698d:	90                   	nop
8010698e:	c9                   	leave  
8010698f:	c3                   	ret    

80106990 <outb>:
        : "d" (port), "0" (addr), "1" (cnt)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	83 ec 08             	sub    $0x8,%esp
80106996:	8b 55 08             	mov    0x8(%ebp),%edx
80106999:	8b 45 0c             	mov    0xc(%ebp),%eax
8010699c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069a0:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
801069a3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069a7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069ab:	ee                   	out    %al,(%dx)
}
801069ac:	90                   	nop
801069ad:	c9                   	leave  
801069ae:	c3                   	ret    

801069af <move_cursor>:
} cons;


//set cursor location
static void move_cursor()
{
801069af:	55                   	push   %ebp
801069b0:	89 e5                	mov    %esp,%ebp
801069b2:	83 ec 10             	sub    $0x10,%esp
    uint16_t cursorLocation = cursor_y * 80 + cursor_x ;
801069b5:	0f b6 05 6d 6f 12 80 	movzbl 0x80126f6d,%eax
801069bc:	0f b6 d0             	movzbl %al,%edx
801069bf:	89 d0                	mov    %edx,%eax
801069c1:	c1 e0 02             	shl    $0x2,%eax
801069c4:	01 d0                	add    %edx,%eax
801069c6:	c1 e0 04             	shl    $0x4,%eax
801069c9:	89 c2                	mov    %eax,%edx
801069cb:	0f b6 05 6c 6f 12 80 	movzbl 0x80126f6c,%eax
801069d2:	0f b6 c0             	movzbl %al,%eax
801069d5:	01 d0                	add    %edx,%eax
801069d7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    outb(0x3D4, 14);
801069db:	6a 0e                	push   $0xe
801069dd:	68 d4 03 00 00       	push   $0x3d4
801069e2:	e8 a9 ff ff ff       	call   80106990 <outb>
801069e7:	83 c4 08             	add    $0x8,%esp
    outb(0x3D5, cursorLocation >> 8);
801069ea:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
801069ee:	66 c1 e8 08          	shr    $0x8,%ax
801069f2:	0f b6 c0             	movzbl %al,%eax
801069f5:	50                   	push   %eax
801069f6:	68 d5 03 00 00       	push   $0x3d5
801069fb:	e8 90 ff ff ff       	call   80106990 <outb>
80106a00:	83 c4 08             	add    $0x8,%esp
    outb(0x3D4, 15);
80106a03:	6a 0f                	push   $0xf
80106a05:	68 d4 03 00 00       	push   $0x3d4
80106a0a:	e8 81 ff ff ff       	call   80106990 <outb>
80106a0f:	83 c4 08             	add    $0x8,%esp
    outb(0x3D5, cursorLocation);
80106a12:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
80106a16:	0f b6 c0             	movzbl %al,%eax
80106a19:	50                   	push   %eax
80106a1a:	68 d5 03 00 00       	push   $0x3d5
80106a1f:	e8 6c ff ff ff       	call   80106990 <outb>
80106a24:	83 c4 08             	add    $0x8,%esp
}
80106a27:	90                   	nop
80106a28:	c9                   	leave  
80106a29:	c3                   	ret    

80106a2a <init_cons>:

void init_cons()
{
80106a2a:	55                   	push   %ebp
80106a2b:	89 e5                	mov    %esp,%ebp
80106a2d:	83 ec 08             	sub    $0x8,%esp
    init_lock(&cons.lock, "console");
80106a30:	83 ec 08             	sub    $0x8,%esp
80106a33:	68 f1 b9 10 80       	push   $0x8010b9f1
80106a38:	68 70 6f 12 80       	push   $0x80126f70
80106a3d:	e8 57 0d 00 00       	call   80107799 <init_lock>
80106a42:	83 c4 10             	add    $0x10,%esp
}
80106a45:	90                   	nop
80106a46:	c9                   	leave  
80106a47:	c3                   	ret    

80106a48 <clear_cons>:
//clear console
void clear_cons()
{
80106a48:	55                   	push   %ebp
80106a49:	89 e5                	mov    %esp,%ebp
80106a4b:	83 ec 18             	sub    $0x18,%esp
    acquire(&cons.lock);
80106a4e:	83 ec 0c             	sub    $0xc,%esp
80106a51:	68 70 6f 12 80       	push   $0x80126f70
80106a56:	e8 60 0d 00 00       	call   801077bb <acquire>
80106a5b:	83 c4 10             	add    $0x10,%esp
    uint8_t attribute_byte = (0 << 4) | (15 & 0x0F);
80106a5e:	c6 45 f3 0f          	movb   $0xf,-0xd(%ebp)
    uint16_t blank = 0x20 | (attribute_byte << 8);
80106a62:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80106a66:	c1 e0 08             	shl    $0x8,%eax
80106a69:	83 c8 20             	or     $0x20,%eax
80106a6c:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    int i;
    for(i = 0 ; i < 80 * 25 ; i ++)
80106a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a77:	eb 17                	jmp    80106a90 <clear_cons+0x48>
    {
        video_memory[i] = blank; 
80106a79:	a1 70 46 12 80       	mov    0x80124670,%eax
80106a7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a81:	01 d2                	add    %edx,%edx
80106a83:	01 c2                	add    %eax,%edx
80106a85:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
80106a89:	66 89 02             	mov    %ax,(%edx)
    acquire(&cons.lock);
    uint8_t attribute_byte = (0 << 4) | (15 & 0x0F);
    uint16_t blank = 0x20 | (attribute_byte << 8);

    int i;
    for(i = 0 ; i < 80 * 25 ; i ++)
80106a8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106a90:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
80106a97:	7e e0                	jle    80106a79 <clear_cons+0x31>
    {
        video_memory[i] = blank; 
    }
    cursor_x = 0;
80106a99:	c6 05 6c 6f 12 80 00 	movb   $0x0,0x80126f6c
    cursor_y = 0;
80106aa0:	c6 05 6d 6f 12 80 00 	movb   $0x0,0x80126f6d
    move_cursor();
80106aa7:	e8 03 ff ff ff       	call   801069af <move_cursor>
    release(&cons.lock);
80106aac:	83 ec 0c             	sub    $0xc,%esp
80106aaf:	68 70 6f 12 80       	push   $0x80126f70
80106ab4:	e8 61 0d 00 00       	call   8010781a <release>
80106ab9:	83 c4 10             	add    $0x10,%esp
}
80106abc:	90                   	nop
80106abd:	c9                   	leave  
80106abe:	c3                   	ret    

80106abf <scroll>:

// scroll console
static void scroll()
{
80106abf:	55                   	push   %ebp
80106ac0:	89 e5                	mov    %esp,%ebp
80106ac2:	83 ec 10             	sub    $0x10,%esp
    uint8_t attribute_byte = (0 << 4) | (15 & 0x0f);
80106ac5:	c6 45 fb 0f          	movb   $0xf,-0x5(%ebp)
    uint16_t blank = 0x20 | (attribute_byte << 8);
80106ac9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
80106acd:	c1 e0 08             	shl    $0x8,%eax
80106ad0:	83 c8 20             	or     $0x20,%eax
80106ad3:	66 89 45 f8          	mov    %ax,-0x8(%ebp)

    if(cursor_y >= 25)
80106ad7:	0f b6 05 6d 6f 12 80 	movzbl 0x80126f6d,%eax
80106ade:	3c 18                	cmp    $0x18,%al
80106ae0:	76 67                	jbe    80106b49 <scroll+0x8a>
    {
        int i;
        for(i = 0 ; i < 24 * 80 ; i ++)
80106ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106ae9:	eb 25                	jmp    80106b10 <scroll+0x51>
        {
            video_memory[i] = video_memory[i + 80]; 
80106aeb:	a1 70 46 12 80       	mov    0x80124670,%eax
80106af0:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106af3:	01 d2                	add    %edx,%edx
80106af5:	01 c2                	add    %eax,%edx
80106af7:	a1 70 46 12 80       	mov    0x80124670,%eax
80106afc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
80106aff:	83 c1 50             	add    $0x50,%ecx
80106b02:	01 c9                	add    %ecx,%ecx
80106b04:	01 c8                	add    %ecx,%eax
80106b06:	0f b7 00             	movzwl (%eax),%eax
80106b09:	66 89 02             	mov    %ax,(%edx)
    uint16_t blank = 0x20 | (attribute_byte << 8);

    if(cursor_y >= 25)
    {
        int i;
        for(i = 0 ; i < 24 * 80 ; i ++)
80106b0c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b10:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%ebp)
80106b17:	7e d2                	jle    80106aeb <scroll+0x2c>
        {
            video_memory[i] = video_memory[i + 80]; 
        }

        // fill blank
        for(i = 24 * 80; i < 25 * 80 ; i ++)
80106b19:	c7 45 fc 80 07 00 00 	movl   $0x780,-0x4(%ebp)
80106b20:	eb 17                	jmp    80106b39 <scroll+0x7a>
        {
            video_memory[i] = blank; 
80106b22:	a1 70 46 12 80       	mov    0x80124670,%eax
80106b27:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b2a:	01 d2                	add    %edx,%edx
80106b2c:	01 c2                	add    %eax,%edx
80106b2e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106b32:	66 89 02             	mov    %ax,(%edx)
        {
            video_memory[i] = video_memory[i + 80]; 
        }

        // fill blank
        for(i = 24 * 80; i < 25 * 80 ; i ++)
80106b35:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b39:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%ebp)
80106b40:	7e e0                	jle    80106b22 <scroll+0x63>
        {
            video_memory[i] = blank; 
        }
        cursor_y = 24;
80106b42:	c6 05 6d 6f 12 80 18 	movb   $0x18,0x80126f6d
    }
}
80106b49:	90                   	nop
80106b4a:	c9                   	leave  
80106b4b:	c3                   	ret    

80106b4c <putc_color_cons>:

void putc_color_cons(char c,real_color_t back, real_color_t fore)
{
80106b4c:	55                   	push   %ebp
80106b4d:	89 e5                	mov    %esp,%ebp
80106b4f:	83 ec 14             	sub    $0x14,%esp
80106b52:	8b 45 08             	mov    0x8(%ebp),%eax
80106b55:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t back_color = (uint8_t)back;
80106b58:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b5b:	88 45 ff             	mov    %al,-0x1(%ebp)
    uint8_t fore_color = (uint8_t)fore;
80106b5e:	8b 45 10             	mov    0x10(%ebp),%eax
80106b61:	88 45 fe             	mov    %al,-0x2(%ebp)

    uint8_t attribute_byte = (back_color << 4) | (fore_color & 0x0f);
80106b64:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80106b68:	c1 e0 04             	shl    $0x4,%eax
80106b6b:	89 c2                	mov    %eax,%edx
80106b6d:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
80106b71:	83 e0 0f             	and    $0xf,%eax
80106b74:	09 d0                	or     %edx,%eax
80106b76:	88 45 fd             	mov    %al,-0x3(%ebp)
    uint16_t attribute = (attribute_byte << 8);
80106b79:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
80106b7d:	c1 e0 08             	shl    $0x8,%eax
80106b80:	66 89 45 fa          	mov    %ax,-0x6(%ebp)

    // 0x08是退格键
    // 0x09是tab
    if(c == 0x08 && cursor_x != 0)
80106b84:	80 7d ec 08          	cmpb   $0x8,-0x14(%ebp)
80106b88:	75 1f                	jne    80106ba9 <putc_color_cons+0x5d>
80106b8a:	0f b6 05 6c 6f 12 80 	movzbl 0x80126f6c,%eax
80106b91:	84 c0                	test   %al,%al
80106b93:	74 14                	je     80106ba9 <putc_color_cons+0x5d>
    {
        cursor_x --; 
80106b95:	0f b6 05 6c 6f 12 80 	movzbl 0x80126f6c,%eax
80106b9c:	83 e8 01             	sub    $0x1,%eax
80106b9f:	a2 6c 6f 12 80       	mov    %al,0x80126f6c
80106ba4:	e9 96 00 00 00       	jmp    80106c3f <putc_color_cons+0xf3>
    }else if(c == 0x09)
80106ba9:	80 7d ec 09          	cmpb   $0x9,-0x14(%ebp)
80106bad:	75 14                	jne    80106bc3 <putc_color_cons+0x77>
    {
        cursor_x = (cursor_x + 8) & ~ (8 - 1);
80106baf:	0f b6 05 6c 6f 12 80 	movzbl 0x80126f6c,%eax
80106bb6:	83 c0 08             	add    $0x8,%eax
80106bb9:	83 e0 f8             	and    $0xfffffff8,%eax
80106bbc:	a2 6c 6f 12 80       	mov    %al,0x80126f6c
80106bc1:	eb 7c                	jmp    80106c3f <putc_color_cons+0xf3>
    }else if(c == '\r')
80106bc3:	80 7d ec 0d          	cmpb   $0xd,-0x14(%ebp)
80106bc7:	75 09                	jne    80106bd2 <putc_color_cons+0x86>
    {
        cursor_x = 0;
80106bc9:	c6 05 6c 6f 12 80 00 	movb   $0x0,0x80126f6c
80106bd0:	eb 6d                	jmp    80106c3f <putc_color_cons+0xf3>
    }else if(c == '\n')
80106bd2:	80 7d ec 0a          	cmpb   $0xa,-0x14(%ebp)
80106bd6:	75 18                	jne    80106bf0 <putc_color_cons+0xa4>
    {
        cursor_x = 0; 
80106bd8:	c6 05 6c 6f 12 80 00 	movb   $0x0,0x80126f6c
        cursor_y ++;
80106bdf:	0f b6 05 6d 6f 12 80 	movzbl 0x80126f6d,%eax
80106be6:	83 c0 01             	add    $0x1,%eax
80106be9:	a2 6d 6f 12 80       	mov    %al,0x80126f6d
80106bee:	eb 4f                	jmp    80106c3f <putc_color_cons+0xf3>
    }else if(c >= ' ')
80106bf0:	80 7d ec 1f          	cmpb   $0x1f,-0x14(%ebp)
80106bf4:	7e 49                	jle    80106c3f <putc_color_cons+0xf3>
    {
        video_memory[cursor_y * 80 + cursor_x] = c | attribute;
80106bf6:	8b 0d 70 46 12 80    	mov    0x80124670,%ecx
80106bfc:	0f b6 05 6d 6f 12 80 	movzbl 0x80126f6d,%eax
80106c03:	0f b6 d0             	movzbl %al,%edx
80106c06:	89 d0                	mov    %edx,%eax
80106c08:	c1 e0 02             	shl    $0x2,%eax
80106c0b:	01 d0                	add    %edx,%eax
80106c0d:	c1 e0 04             	shl    $0x4,%eax
80106c10:	89 c2                	mov    %eax,%edx
80106c12:	0f b6 05 6c 6f 12 80 	movzbl 0x80126f6c,%eax
80106c19:	0f b6 c0             	movzbl %al,%eax
80106c1c:	01 d0                	add    %edx,%eax
80106c1e:	01 c0                	add    %eax,%eax
80106c20:	01 c8                	add    %ecx,%eax
80106c22:	66 0f be 4d ec       	movsbw -0x14(%ebp),%cx
80106c27:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
80106c2b:	09 ca                	or     %ecx,%edx
80106c2d:	66 89 10             	mov    %dx,(%eax)
        cursor_x ++;
80106c30:	0f b6 05 6c 6f 12 80 	movzbl 0x80126f6c,%eax
80106c37:	83 c0 01             	add    $0x1,%eax
80106c3a:	a2 6c 6f 12 80       	mov    %al,0x80126f6c
    }

    //行数超过80换行
    if(cursor_x >= 80)
80106c3f:	0f b6 05 6c 6f 12 80 	movzbl 0x80126f6c,%eax
80106c46:	3c 4f                	cmp    $0x4f,%al
80106c48:	76 16                	jbe    80106c60 <putc_color_cons+0x114>
    {
        cursor_x = 0; 
80106c4a:	c6 05 6c 6f 12 80 00 	movb   $0x0,0x80126f6c
        cursor_y ++;
80106c51:	0f b6 05 6d 6f 12 80 	movzbl 0x80126f6d,%eax
80106c58:	83 c0 01             	add    $0x1,%eax
80106c5b:	a2 6d 6f 12 80       	mov    %al,0x80126f6d
    }

    //需要即滚动
    scroll();
80106c60:	e8 5a fe ff ff       	call   80106abf <scroll>

    //移动硬件的光标
    move_cursor();
80106c65:	e8 45 fd ff ff       	call   801069af <move_cursor>
}
80106c6a:	90                   	nop
80106c6b:	c9                   	leave  
80106c6c:	c3                   	ret    

80106c6d <putc_cons>:

void putc_cons(char cstr)
{
80106c6d:	55                   	push   %ebp
80106c6e:	89 e5                	mov    %esp,%ebp
80106c70:	83 ec 04             	sub    $0x4,%esp
80106c73:	8b 45 08             	mov    0x8(%ebp),%eax
80106c76:	88 45 fc             	mov    %al,-0x4(%ebp)
    putc_color_cons(cstr,rc_black, rc_white); 
80106c79:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
80106c7d:	6a 0f                	push   $0xf
80106c7f:	6a 00                	push   $0x0
80106c81:	50                   	push   %eax
80106c82:	e8 c5 fe ff ff       	call   80106b4c <putc_color_cons>
80106c87:	83 c4 0c             	add    $0xc,%esp
}
80106c8a:	90                   	nop
80106c8b:	c9                   	leave  
80106c8c:	c3                   	ret    

80106c8d <putch>:


//
static void putch(char ch)
{
80106c8d:	55                   	push   %ebp
80106c8e:	89 e5                	mov    %esp,%ebp
80106c90:	83 ec 18             	sub    $0x18,%esp
80106c93:	8b 45 08             	mov    0x8(%ebp),%eax
80106c96:	88 45 f4             	mov    %al,-0xc(%ebp)
    putc_cons(ch);
80106c99:	0f be 45 f4          	movsbl -0xc(%ebp),%eax
80106c9d:	50                   	push   %eax
80106c9e:	e8 ca ff ff ff       	call   80106c6d <putc_cons>
80106ca3:	83 c4 04             	add    $0x4,%esp
    putc_uart(ch);
80106ca6:	0f be 45 f4          	movsbl -0xc(%ebp),%eax
80106caa:	83 ec 0c             	sub    $0xc,%esp
80106cad:	50                   	push   %eax
80106cae:	e8 98 fa ff ff       	call   8010674b <putc_uart>
80106cb3:	83 c4 10             	add    $0x10,%esp
}
80106cb6:	90                   	nop
80106cb7:	c9                   	leave  
80106cb8:	c3                   	ret    

80106cb9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
80106cb9:	55                   	push   %ebp
80106cba:	89 e5                	mov    %esp,%ebp
80106cbc:	83 ec 08             	sub    $0x8,%esp
    return vprintfmt(putch,fmt,ap);
80106cbf:	83 ec 04             	sub    $0x4,%esp
80106cc2:	ff 75 0c             	pushl  0xc(%ebp)
80106cc5:	ff 75 08             	pushl  0x8(%ebp)
80106cc8:	68 8d 6c 10 80       	push   $0x80106c8d
80106ccd:	e8 f5 31 00 00       	call   80109ec7 <vprintfmt>
80106cd2:	83 c4 10             	add    $0x10,%esp
}
80106cd5:	c9                   	leave  
80106cd6:	c3                   	ret    

80106cd7 <cprintf>:
int cprintf(const char *fmt, ...)
{
80106cd7:	55                   	push   %ebp
80106cd8:	89 e5                	mov    %esp,%ebp
80106cda:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
//    acquire(&cons.lock);
    va_start(ap, fmt);
80106cdd:	8d 45 0c             	lea    0xc(%ebp),%eax
80106ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vprintfmt(putch,fmt,ap);
80106ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ce6:	83 ec 04             	sub    $0x4,%esp
80106ce9:	50                   	push   %eax
80106cea:	ff 75 08             	pushl  0x8(%ebp)
80106ced:	68 8d 6c 10 80       	push   $0x80106c8d
80106cf2:	e8 d0 31 00 00       	call   80109ec7 <vprintfmt>
80106cf7:	83 c4 10             	add    $0x10,%esp
80106cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
//    release(&cons.lock);
    return cnt;
80106cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d00:	c9                   	leave  
80106d01:	c3                   	ret    

80106d02 <inb>:
    uint16_t limit;        // Limit
    uint32_t base;        // Base address
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
80106d02:	55                   	push   %ebp
80106d03:	89 e5                	mov    %esp,%ebp
80106d05:	83 ec 14             	sub    $0x14,%esp
80106d08:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
80106d0f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106d13:	89 c2                	mov    %eax,%edx
80106d15:	ec                   	in     (%dx),%al
80106d16:	88 45 ff             	mov    %al,-0x1(%ebp)
    return data;
80106d19:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106d1d:	c9                   	leave  
80106d1e:	c3                   	ret    

80106d1f <insl>:
static inline void
insl(uint32_t port, void *addr, int cnt) {
80106d1f:	55                   	push   %ebp
80106d20:	89 e5                	mov    %esp,%ebp
80106d22:	57                   	push   %edi
80106d23:	53                   	push   %ebx
    asm volatile (
80106d24:	8b 55 08             	mov    0x8(%ebp),%edx
80106d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d2a:	8b 45 10             	mov    0x10(%ebp),%eax
80106d2d:	89 cb                	mov    %ecx,%ebx
80106d2f:	89 df                	mov    %ebx,%edi
80106d31:	89 c1                	mov    %eax,%ecx
80106d33:	fc                   	cld    
80106d34:	f2 6d                	repnz insl (%dx),%es:(%edi)
80106d36:	89 c8                	mov    %ecx,%eax
80106d38:	89 fb                	mov    %edi,%ebx
80106d3a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80106d3d:	89 45 10             	mov    %eax,0x10(%ebp)
            "cld;"
            "repne; insl;"
            : "=D" (addr), "=c" (cnt)
            : "d" (port), "0" (addr), "1" (cnt)
            : "memory", "cc");
}
80106d40:	90                   	nop
80106d41:	5b                   	pop    %ebx
80106d42:	5f                   	pop    %edi
80106d43:	5d                   	pop    %ebp
80106d44:	c3                   	ret    

80106d45 <outsl>:


static inline void
outsl(uint32_t port, const void *addr, int cnt) {
80106d45:	55                   	push   %ebp
80106d46:	89 e5                	mov    %esp,%ebp
80106d48:	56                   	push   %esi
80106d49:	53                   	push   %ebx
    asm volatile (
80106d4a:	8b 55 08             	mov    0x8(%ebp),%edx
80106d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d50:	8b 45 10             	mov    0x10(%ebp),%eax
80106d53:	89 cb                	mov    %ecx,%ebx
80106d55:	89 de                	mov    %ebx,%esi
80106d57:	89 c1                	mov    %eax,%ecx
80106d59:	fc                   	cld    
80106d5a:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
80106d5c:	89 c8                	mov    %ecx,%eax
80106d5e:	89 f3                	mov    %esi,%ebx
80106d60:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80106d63:	89 45 10             	mov    %eax,0x10(%ebp)
        "cld;"
        "repne; outsl;"
        : "=S" (addr), "=c" (cnt)
        : "d" (port), "0" (addr), "1" (cnt)
        : "memory", "cc");
}
80106d66:	90                   	nop
80106d67:	5b                   	pop    %ebx
80106d68:	5e                   	pop    %esi
80106d69:	5d                   	pop    %ebp
80106d6a:	c3                   	ret    

80106d6b <outb>:

static inline void
outb(uint16_t port, uint8_t data) {
80106d6b:	55                   	push   %ebp
80106d6c:	89 e5                	mov    %esp,%ebp
80106d6e:	83 ec 08             	sub    $0x8,%esp
80106d71:	8b 55 08             	mov    0x8(%ebp),%edx
80106d74:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d77:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d7b:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
80106d7e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d82:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d86:	ee                   	out    %al,(%dx)
}
80106d87:	90                   	nop
80106d88:	c9                   	leave  
80106d89:	c3                   	ret    

80106d8a <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
80106d8a:	55                   	push   %ebp
80106d8b:	89 e5                	mov    %esp,%ebp
80106d8d:	83 ec 14             	sub    $0x14,%esp
80106d90:	8b 45 08             	mov    0x8(%ebp),%eax
80106d93:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
80106d97:	90                   	nop
80106d98:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106d9c:	83 c0 07             	add    $0x7,%eax
80106d9f:	0f b7 c0             	movzwl %ax,%eax
80106da2:	50                   	push   %eax
80106da3:	e8 5a ff ff ff       	call   80106d02 <inb>
80106da8:	83 c4 04             	add    $0x4,%esp
80106dab:	0f b6 c0             	movzbl %al,%eax
80106dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106db4:	25 80 00 00 00       	and    $0x80,%eax
80106db9:	85 c0                	test   %eax,%eax
80106dbb:	75 db                	jne    80106d98 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
80106dbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106dc1:	74 11                	je     80106dd4 <ide_wait_ready+0x4a>
80106dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dc6:	83 e0 21             	and    $0x21,%eax
80106dc9:	85 c0                	test   %eax,%eax
80106dcb:	74 07                	je     80106dd4 <ide_wait_ready+0x4a>
        return -1;
80106dcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dd2:	eb 05                	jmp    80106dd9 <ide_wait_ready+0x4f>
    }
    return 0;
80106dd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106dd9:	c9                   	leave  
80106dda:	c3                   	ret    

80106ddb <ide_init>:

void
ide_init(void) {
80106ddb:	55                   	push   %ebp
80106ddc:	89 e5                	mov    %esp,%ebp
80106dde:	81 ec 38 02 00 00    	sub    $0x238,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
80106de4:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
80106dea:	e9 98 02 00 00       	jmp    80107087 <ide_init+0x2ac>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
80106def:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80106df3:	c1 e0 03             	shl    $0x3,%eax
80106df6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80106dfd:	29 c2                	sub    %eax,%edx
80106dff:	89 d0                	mov    %edx,%eax
80106e01:	05 80 6f 12 80       	add    $0x80126f80,%eax
80106e06:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
80106e09:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80106e0d:	66 d1 e8             	shr    %ax
80106e10:	0f b7 c0             	movzwl %ax,%eax
80106e13:	0f b7 04 85 fc b9 10 	movzwl -0x7fef4604(,%eax,4),%eax
80106e1a:	80 
80106e1b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
80106e1f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106e23:	6a 00                	push   $0x0
80106e25:	50                   	push   %eax
80106e26:	e8 5f ff ff ff       	call   80106d8a <ide_wait_ready>
80106e2b:	83 c4 08             	add    $0x8,%esp

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
80106e2e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80106e32:	83 e0 01             	and    $0x1,%eax
80106e35:	c1 e0 04             	shl    $0x4,%eax
80106e38:	83 c8 e0             	or     $0xffffffe0,%eax
80106e3b:	0f b6 d0             	movzbl %al,%edx
80106e3e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106e42:	83 c0 06             	add    $0x6,%eax
80106e45:	0f b7 c0             	movzwl %ax,%eax
80106e48:	52                   	push   %edx
80106e49:	50                   	push   %eax
80106e4a:	e8 1c ff ff ff       	call   80106d6b <outb>
80106e4f:	83 c4 08             	add    $0x8,%esp
        ide_wait_ready(iobase, 0);
80106e52:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106e56:	6a 00                	push   $0x0
80106e58:	50                   	push   %eax
80106e59:	e8 2c ff ff ff       	call   80106d8a <ide_wait_ready>
80106e5e:	83 c4 08             	add    $0x8,%esp

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
80106e61:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106e65:	83 c0 07             	add    $0x7,%eax
80106e68:	0f b7 c0             	movzwl %ax,%eax
80106e6b:	68 ec 00 00 00       	push   $0xec
80106e70:	50                   	push   %eax
80106e71:	e8 f5 fe ff ff       	call   80106d6b <outb>
80106e76:	83 c4 08             	add    $0x8,%esp
        ide_wait_ready(iobase, 0);
80106e79:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106e7d:	6a 00                	push   $0x0
80106e7f:	50                   	push   %eax
80106e80:	e8 05 ff ff ff       	call   80106d8a <ide_wait_ready>
80106e85:	83 c4 08             	add    $0x8,%esp

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
80106e88:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106e8c:	83 c0 07             	add    $0x7,%eax
80106e8f:	0f b7 c0             	movzwl %ax,%eax
80106e92:	50                   	push   %eax
80106e93:	e8 6a fe ff ff       	call   80106d02 <inb>
80106e98:	83 c4 04             	add    $0x4,%esp
80106e9b:	84 c0                	test   %al,%al
80106e9d:	0f 84 d8 01 00 00    	je     8010707b <ide_init+0x2a0>
80106ea3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106ea7:	6a 01                	push   $0x1
80106ea9:	50                   	push   %eax
80106eaa:	e8 db fe ff ff       	call   80106d8a <ide_wait_ready>
80106eaf:	83 c4 08             	add    $0x8,%esp
80106eb2:	85 c0                	test   %eax,%eax
80106eb4:	0f 85 c1 01 00 00    	jne    8010707b <ide_init+0x2a0>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
80106eba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80106ebe:	c1 e0 03             	shl    $0x3,%eax
80106ec1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80106ec8:	29 c2                	sub    %eax,%edx
80106eca:	89 d0                	mov    %edx,%eax
80106ecc:	05 80 6f 12 80       	add    $0x80126f80,%eax
80106ed1:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
80106ed4:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
80106ed8:	68 80 00 00 00       	push   $0x80
80106edd:	8d 95 d4 fd ff ff    	lea    -0x22c(%ebp),%edx
80106ee3:	52                   	push   %edx
80106ee4:	50                   	push   %eax
80106ee5:	e8 35 fe ff ff       	call   80106d1f <insl>
80106eea:	83 c4 0c             	add    $0xc,%esp

        unsigned char *ident = (unsigned char *)buffer;
80106eed:	8d 85 d4 fd ff ff    	lea    -0x22c(%ebp),%eax
80106ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
80106ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ef9:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80106eff:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
80106f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f05:	25 00 00 00 04       	and    $0x4000000,%eax
80106f0a:	85 c0                	test   %eax,%eax
80106f0c:	74 0e                	je     80106f1c <ide_init+0x141>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
80106f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f11:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
80106f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f1a:	eb 09                	jmp    80106f25 <ide_init+0x14a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
80106f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f1f:	8b 40 78             	mov    0x78(%eax),%eax
80106f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
80106f25:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80106f29:	c1 e0 03             	shl    $0x3,%eax
80106f2c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80106f33:	29 c2                	sub    %eax,%edx
80106f35:	89 d0                	mov    %edx,%eax
80106f37:	8d 90 84 6f 12 80    	lea    -0x7fed907c(%eax),%edx
80106f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f40:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
80106f42:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80106f46:	c1 e0 03             	shl    $0x3,%eax
80106f49:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80106f50:	29 c2                	sub    %eax,%edx
80106f52:	89 d0                	mov    %edx,%eax
80106f54:	8d 90 88 6f 12 80    	lea    -0x7fed9078(%eax),%edx
80106f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f5d:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
80106f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f62:	83 c0 62             	add    $0x62,%eax
80106f65:	0f b7 00             	movzwl (%eax),%eax
80106f68:	0f b7 c0             	movzwl %ax,%eax
80106f6b:	25 00 02 00 00       	and    $0x200,%eax
80106f70:	85 c0                	test   %eax,%eax
80106f72:	75 19                	jne    80106f8d <ide_init+0x1b2>
80106f74:	68 04 ba 10 80       	push   $0x8010ba04
80106f79:	68 47 ba 10 80       	push   $0x8010ba47
80106f7e:	6a 7d                	push   $0x7d
80106f80:	68 5d ba 10 80       	push   $0x8010ba5d
80106f85:	e8 ca 93 ff ff       	call   80100354 <__panic>
80106f8a:	83 c4 10             	add    $0x10,%esp

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
80106f8d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80106f91:	89 c2                	mov    %eax,%edx
80106f93:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80106f9a:	89 c2                	mov    %eax,%edx
80106f9c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80106fa3:	29 d0                	sub    %edx,%eax
80106fa5:	05 80 6f 12 80       	add    $0x80126f80,%eax
80106faa:	83 c0 0c             	add    $0xc,%eax
80106fad:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fb3:	83 c0 36             	add    $0x36,%eax
80106fb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
80106fb9:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
80106fc0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80106fc7:	eb 34                	jmp    80106ffd <ide_init+0x222>
            model[i] = data[i + 1], model[i + 1] = data[i];
80106fc9:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106fcf:	01 c2                	add    %eax,%edx
80106fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106fd4:	8d 48 01             	lea    0x1(%eax),%ecx
80106fd7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106fda:	01 c8                	add    %ecx,%eax
80106fdc:	0f b6 00             	movzbl (%eax),%eax
80106fdf:	88 02                	mov    %al,(%edx)
80106fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106fe4:	8d 50 01             	lea    0x1(%eax),%edx
80106fe7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106fea:	01 c2                	add    %eax,%edx
80106fec:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ff2:	01 c8                	add    %ecx,%eax
80106ff4:	0f b6 00             	movzbl (%eax),%eax
80106ff7:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
80106ff9:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
80106ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107000:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80107003:	72 c4                	jb     80106fc9 <ide_init+0x1ee>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
80107005:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107008:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010700b:	01 d0                	add    %edx,%eax
8010700d:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
80107010:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107013:	8d 50 ff             	lea    -0x1(%eax),%edx
80107016:	89 55 ec             	mov    %edx,-0x14(%ebp)
80107019:	85 c0                	test   %eax,%eax
8010701b:	74 0f                	je     8010702c <ide_init+0x251>
8010701d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107020:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107023:	01 d0                	add    %edx,%eax
80107025:	0f b6 00             	movzbl (%eax),%eax
80107028:	3c 20                	cmp    $0x20,%al
8010702a:	74 d9                	je     80107005 <ide_init+0x22a>

        cprintf("ide %d: %10d(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
8010702c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80107030:	89 c2                	mov    %eax,%edx
80107032:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80107039:	89 c2                	mov    %eax,%edx
8010703b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80107042:	29 d0                	sub    %edx,%eax
80107044:	05 80 6f 12 80       	add    $0x80126f80,%eax
80107049:	8d 48 0c             	lea    0xc(%eax),%ecx
8010704c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80107050:	c1 e0 03             	shl    $0x3,%eax
80107053:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010705a:	29 c2                	sub    %eax,%edx
8010705c:	89 d0                	mov    %edx,%eax
8010705e:	05 88 6f 12 80       	add    $0x80126f88,%eax
80107063:	8b 10                	mov    (%eax),%edx
80107065:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80107069:	51                   	push   %ecx
8010706a:	52                   	push   %edx
8010706b:	50                   	push   %eax
8010706c:	68 6f ba 10 80       	push   $0x8010ba6f
80107071:	e8 61 fc ff ff       	call   80106cd7 <cprintf>
80107076:	83 c4 10             	add    $0x10,%esp
80107079:	eb 01                	jmp    8010707c <ide_init+0x2a1>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
8010707b:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
8010707c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80107080:	83 c0 01             	add    $0x1,%eax
80107083:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80107087:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
8010708c:	0f 86 5d fd ff ff    	jbe    80106def <ide_init+0x14>
        cprintf("ide %d: %10d(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    
    ioapicenable(IRQ_IDE0,0);
80107092:	83 ec 08             	sub    $0x8,%esp
80107095:	6a 00                	push   $0x0
80107097:	6a 0e                	push   $0xe
80107099:	e8 8f e7 ff ff       	call   8010582d <ioapicenable>
8010709e:	83 c4 10             	add    $0x10,%esp
    ioapicenable(IRQ_IDE1,0);
801070a1:	83 ec 08             	sub    $0x8,%esp
801070a4:	6a 00                	push   $0x0
801070a6:	6a 0f                	push   $0xf
801070a8:	e8 80 e7 ff ff       	call   8010582d <ioapicenable>
801070ad:	83 c4 10             	add    $0x10,%esp
}
801070b0:	90                   	nop
801070b1:	c9                   	leave  
801070b2:	c3                   	ret    

801070b3 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
801070b3:	55                   	push   %ebp
801070b4:	89 e5                	mov    %esp,%ebp
801070b6:	83 ec 04             	sub    $0x4,%esp
801070b9:	8b 45 08             	mov    0x8(%ebp),%eax
801070bc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
801070c0:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
801070c5:	77 25                	ja     801070ec <ide_device_valid+0x39>
801070c7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801070cb:	c1 e0 03             	shl    $0x3,%eax
801070ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801070d5:	29 c2                	sub    %eax,%edx
801070d7:	89 d0                	mov    %edx,%eax
801070d9:	05 80 6f 12 80       	add    $0x80126f80,%eax
801070de:	0f b6 00             	movzbl (%eax),%eax
801070e1:	84 c0                	test   %al,%al
801070e3:	74 07                	je     801070ec <ide_device_valid+0x39>
801070e5:	b8 01 00 00 00       	mov    $0x1,%eax
801070ea:	eb 05                	jmp    801070f1 <ide_device_valid+0x3e>
801070ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801070f1:	c9                   	leave  
801070f2:	c3                   	ret    

801070f3 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
801070f3:	55                   	push   %ebp
801070f4:	89 e5                	mov    %esp,%ebp
801070f6:	83 ec 04             	sub    $0x4,%esp
801070f9:	8b 45 08             	mov    0x8(%ebp),%eax
801070fc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
80107100:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107104:	50                   	push   %eax
80107105:	e8 a9 ff ff ff       	call   801070b3 <ide_device_valid>
8010710a:	83 c4 04             	add    $0x4,%esp
8010710d:	85 c0                	test   %eax,%eax
8010710f:	74 1b                	je     8010712c <ide_device_size+0x39>
        return ide_devices[ideno].size;
80107111:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107115:	c1 e0 03             	shl    $0x3,%eax
80107118:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010711f:	29 c2                	sub    %eax,%edx
80107121:	89 d0                	mov    %edx,%eax
80107123:	05 88 6f 12 80       	add    $0x80126f88,%eax
80107128:	8b 00                	mov    (%eax),%eax
8010712a:	eb 05                	jmp    80107131 <ide_device_size+0x3e>
    }
    return 0;
8010712c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107131:	c9                   	leave  
80107132:	c3                   	ret    

80107133 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
80107133:	55                   	push   %ebp
80107134:	89 e5                	mov    %esp,%ebp
80107136:	83 ec 28             	sub    $0x28,%esp
80107139:	8b 45 08             	mov    0x8(%ebp),%eax
8010713c:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
80107140:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
80107147:	77 25                	ja     8010716e <ide_read_secs+0x3b>
80107149:	66 83 7d e4 03       	cmpw   $0x3,-0x1c(%ebp)
8010714e:	77 1e                	ja     8010716e <ide_read_secs+0x3b>
80107150:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107154:	c1 e0 03             	shl    $0x3,%eax
80107157:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010715e:	29 c2                	sub    %eax,%edx
80107160:	89 d0                	mov    %edx,%eax
80107162:	05 80 6f 12 80       	add    $0x80126f80,%eax
80107167:	0f b6 00             	movzbl (%eax),%eax
8010716a:	84 c0                	test   %al,%al
8010716c:	75 1c                	jne    8010718a <ide_read_secs+0x57>
8010716e:	68 90 ba 10 80       	push   $0x8010ba90
80107173:	68 47 ba 10 80       	push   $0x8010ba47
80107178:	68 a0 00 00 00       	push   $0xa0
8010717d:	68 5d ba 10 80       	push   $0x8010ba5d
80107182:	e8 cd 91 ff ff       	call   80100354 <__panic>
80107187:	83 c4 10             	add    $0x10,%esp
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
8010718a:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
80107191:	77 0f                	ja     801071a2 <ide_read_secs+0x6f>
80107193:	8b 55 0c             	mov    0xc(%ebp),%edx
80107196:	8b 45 14             	mov    0x14(%ebp),%eax
80107199:	01 d0                	add    %edx,%eax
8010719b:	3d 00 00 00 10       	cmp    $0x10000000,%eax
801071a0:	76 1c                	jbe    801071be <ide_read_secs+0x8b>
801071a2:	68 b8 ba 10 80       	push   $0x8010bab8
801071a7:	68 47 ba 10 80       	push   $0x8010ba47
801071ac:	68 a1 00 00 00       	push   $0xa1
801071b1:	68 5d ba 10 80       	push   $0x8010ba5d
801071b6:	e8 99 91 ff ff       	call   80100354 <__panic>
801071bb:	83 c4 10             	add    $0x10,%esp
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
801071be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801071c2:	66 d1 e8             	shr    %ax
801071c5:	0f b7 c0             	movzwl %ax,%eax
801071c8:	0f b7 04 85 fc b9 10 	movzwl -0x7fef4604(,%eax,4),%eax
801071cf:	80 
801071d0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
801071d4:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801071d8:	66 d1 e8             	shr    %ax
801071db:	0f b7 c0             	movzwl %ax,%eax
801071de:	0f b7 04 85 fe b9 10 	movzwl -0x7fef4602(,%eax,4),%eax
801071e5:	80 
801071e6:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
801071ea:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801071ee:	83 ec 08             	sub    $0x8,%esp
801071f1:	6a 00                	push   $0x0
801071f3:	50                   	push   %eax
801071f4:	e8 91 fb ff ff       	call   80106d8a <ide_wait_ready>
801071f9:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
801071fc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
80107200:	83 c0 02             	add    $0x2,%eax
80107203:	0f b7 c0             	movzwl %ax,%eax
80107206:	83 ec 08             	sub    $0x8,%esp
80107209:	6a 00                	push   $0x0
8010720b:	50                   	push   %eax
8010720c:	e8 5a fb ff ff       	call   80106d6b <outb>
80107211:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_SECCNT, nsecs);
80107214:	8b 45 14             	mov    0x14(%ebp),%eax
80107217:	0f b6 d0             	movzbl %al,%edx
8010721a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
8010721e:	83 c0 02             	add    $0x2,%eax
80107221:	0f b7 c0             	movzwl %ax,%eax
80107224:	83 ec 08             	sub    $0x8,%esp
80107227:	52                   	push   %edx
80107228:	50                   	push   %eax
80107229:	e8 3d fb ff ff       	call   80106d6b <outb>
8010722e:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_SECTOR, secno & 0xFF);
80107231:	8b 45 0c             	mov    0xc(%ebp),%eax
80107234:	0f b6 d0             	movzbl %al,%edx
80107237:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
8010723b:	83 c0 03             	add    $0x3,%eax
8010723e:	0f b7 c0             	movzwl %ax,%eax
80107241:	83 ec 08             	sub    $0x8,%esp
80107244:	52                   	push   %edx
80107245:	50                   	push   %eax
80107246:	e8 20 fb ff ff       	call   80106d6b <outb>
8010724b:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
8010724e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107251:	c1 e8 08             	shr    $0x8,%eax
80107254:	0f b6 d0             	movzbl %al,%edx
80107257:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
8010725b:	83 c0 04             	add    $0x4,%eax
8010725e:	0f b7 c0             	movzwl %ax,%eax
80107261:	83 ec 08             	sub    $0x8,%esp
80107264:	52                   	push   %edx
80107265:	50                   	push   %eax
80107266:	e8 00 fb ff ff       	call   80106d6b <outb>
8010726b:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
8010726e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107271:	c1 e8 10             	shr    $0x10,%eax
80107274:	0f b6 d0             	movzbl %al,%edx
80107277:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
8010727b:	83 c0 05             	add    $0x5,%eax
8010727e:	0f b7 c0             	movzwl %ax,%eax
80107281:	83 ec 08             	sub    $0x8,%esp
80107284:	52                   	push   %edx
80107285:	50                   	push   %eax
80107286:	e8 e0 fa ff ff       	call   80106d6b <outb>
8010728b:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
8010728e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107292:	83 e0 01             	and    $0x1,%eax
80107295:	c1 e0 04             	shl    $0x4,%eax
80107298:	89 c2                	mov    %eax,%edx
8010729a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010729d:	c1 e8 18             	shr    $0x18,%eax
801072a0:	83 e0 0f             	and    $0xf,%eax
801072a3:	09 d0                	or     %edx,%eax
801072a5:	83 c8 e0             	or     $0xffffffe0,%eax
801072a8:	0f b6 d0             	movzbl %al,%edx
801072ab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801072af:	83 c0 06             	add    $0x6,%eax
801072b2:	0f b7 c0             	movzwl %ax,%eax
801072b5:	83 ec 08             	sub    $0x8,%esp
801072b8:	52                   	push   %edx
801072b9:	50                   	push   %eax
801072ba:	e8 ac fa ff ff       	call   80106d6b <outb>
801072bf:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
801072c2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801072c6:	83 c0 07             	add    $0x7,%eax
801072c9:	0f b7 c0             	movzwl %ax,%eax
801072cc:	83 ec 08             	sub    $0x8,%esp
801072cf:	6a 20                	push   $0x20
801072d1:	50                   	push   %eax
801072d2:	e8 94 fa ff ff       	call   80106d6b <outb>
801072d7:	83 c4 10             	add    $0x10,%esp

    int ret = 0;
801072da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
801072e1:	eb 3e                	jmp    80107321 <ide_read_secs+0x1ee>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
801072e3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801072e7:	83 ec 08             	sub    $0x8,%esp
801072ea:	6a 01                	push   $0x1
801072ec:	50                   	push   %eax
801072ed:	e8 98 fa ff ff       	call   80106d8a <ide_wait_ready>
801072f2:	83 c4 10             	add    $0x10,%esp
801072f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072fc:	75 2b                	jne    80107329 <ide_read_secs+0x1f6>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
801072fe:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
80107302:	83 ec 04             	sub    $0x4,%esp
80107305:	68 80 00 00 00       	push   $0x80
8010730a:	ff 75 10             	pushl  0x10(%ebp)
8010730d:	50                   	push   %eax
8010730e:	e8 0c fa ff ff       	call   80106d1f <insl>
80107313:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
80107316:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
8010731a:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
80107321:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107325:	75 bc                	jne    801072e3 <ide_read_secs+0x1b0>
80107327:	eb 01                	jmp    8010732a <ide_read_secs+0x1f7>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
80107329:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
8010732a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010732d:	c9                   	leave  
8010732e:	c3                   	ret    

8010732f <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
8010732f:	55                   	push   %ebp
80107330:	89 e5                	mov    %esp,%ebp
80107332:	83 ec 28             	sub    $0x28,%esp
80107335:	8b 45 08             	mov    0x8(%ebp),%eax
80107338:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
8010733c:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
80107343:	77 25                	ja     8010736a <ide_write_secs+0x3b>
80107345:	66 83 7d e4 03       	cmpw   $0x3,-0x1c(%ebp)
8010734a:	77 1e                	ja     8010736a <ide_write_secs+0x3b>
8010734c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107350:	c1 e0 03             	shl    $0x3,%eax
80107353:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010735a:	29 c2                	sub    %eax,%edx
8010735c:	89 d0                	mov    %edx,%eax
8010735e:	05 80 6f 12 80       	add    $0x80126f80,%eax
80107363:	0f b6 00             	movzbl (%eax),%eax
80107366:	84 c0                	test   %al,%al
80107368:	75 1c                	jne    80107386 <ide_write_secs+0x57>
8010736a:	68 90 ba 10 80       	push   $0x8010ba90
8010736f:	68 47 ba 10 80       	push   $0x8010ba47
80107374:	68 bd 00 00 00       	push   $0xbd
80107379:	68 5d ba 10 80       	push   $0x8010ba5d
8010737e:	e8 d1 8f ff ff       	call   80100354 <__panic>
80107383:	83 c4 10             	add    $0x10,%esp
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
80107386:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
8010738d:	77 0f                	ja     8010739e <ide_write_secs+0x6f>
8010738f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107392:	8b 45 14             	mov    0x14(%ebp),%eax
80107395:	01 d0                	add    %edx,%eax
80107397:	3d 00 00 00 10       	cmp    $0x10000000,%eax
8010739c:	76 1c                	jbe    801073ba <ide_write_secs+0x8b>
8010739e:	68 b8 ba 10 80       	push   $0x8010bab8
801073a3:	68 47 ba 10 80       	push   $0x8010ba47
801073a8:	68 be 00 00 00       	push   $0xbe
801073ad:	68 5d ba 10 80       	push   $0x8010ba5d
801073b2:	e8 9d 8f ff ff       	call   80100354 <__panic>
801073b7:	83 c4 10             	add    $0x10,%esp
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
801073ba:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801073be:	66 d1 e8             	shr    %ax
801073c1:	0f b7 c0             	movzwl %ax,%eax
801073c4:	0f b7 04 85 fc b9 10 	movzwl -0x7fef4604(,%eax,4),%eax
801073cb:	80 
801073cc:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
801073d0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801073d4:	66 d1 e8             	shr    %ax
801073d7:	0f b7 c0             	movzwl %ax,%eax
801073da:	0f b7 04 85 fe b9 10 	movzwl -0x7fef4602(,%eax,4),%eax
801073e1:	80 
801073e2:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
801073e6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801073ea:	83 ec 08             	sub    $0x8,%esp
801073ed:	6a 00                	push   $0x0
801073ef:	50                   	push   %eax
801073f0:	e8 95 f9 ff ff       	call   80106d8a <ide_wait_ready>
801073f5:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
801073f8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
801073fc:	83 c0 02             	add    $0x2,%eax
801073ff:	0f b7 c0             	movzwl %ax,%eax
80107402:	83 ec 08             	sub    $0x8,%esp
80107405:	6a 00                	push   $0x0
80107407:	50                   	push   %eax
80107408:	e8 5e f9 ff ff       	call   80106d6b <outb>
8010740d:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_SECCNT, nsecs);
80107410:	8b 45 14             	mov    0x14(%ebp),%eax
80107413:	0f b6 d0             	movzbl %al,%edx
80107416:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
8010741a:	83 c0 02             	add    $0x2,%eax
8010741d:	0f b7 c0             	movzwl %ax,%eax
80107420:	83 ec 08             	sub    $0x8,%esp
80107423:	52                   	push   %edx
80107424:	50                   	push   %eax
80107425:	e8 41 f9 ff ff       	call   80106d6b <outb>
8010742a:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_SECTOR, secno & 0xFF);
8010742d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107430:	0f b6 d0             	movzbl %al,%edx
80107433:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
80107437:	83 c0 03             	add    $0x3,%eax
8010743a:	0f b7 c0             	movzwl %ax,%eax
8010743d:	83 ec 08             	sub    $0x8,%esp
80107440:	52                   	push   %edx
80107441:	50                   	push   %eax
80107442:	e8 24 f9 ff ff       	call   80106d6b <outb>
80107447:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
8010744a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010744d:	c1 e8 08             	shr    $0x8,%eax
80107450:	0f b6 d0             	movzbl %al,%edx
80107453:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
80107457:	83 c0 04             	add    $0x4,%eax
8010745a:	0f b7 c0             	movzwl %ax,%eax
8010745d:	83 ec 08             	sub    $0x8,%esp
80107460:	52                   	push   %edx
80107461:	50                   	push   %eax
80107462:	e8 04 f9 ff ff       	call   80106d6b <outb>
80107467:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
8010746a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010746d:	c1 e8 10             	shr    $0x10,%eax
80107470:	0f b6 d0             	movzbl %al,%edx
80107473:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
80107477:	83 c0 05             	add    $0x5,%eax
8010747a:	0f b7 c0             	movzwl %ax,%eax
8010747d:	83 ec 08             	sub    $0x8,%esp
80107480:	52                   	push   %edx
80107481:	50                   	push   %eax
80107482:	e8 e4 f8 ff ff       	call   80106d6b <outb>
80107487:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
8010748a:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010748e:	83 e0 01             	and    $0x1,%eax
80107491:	c1 e0 04             	shl    $0x4,%eax
80107494:	89 c2                	mov    %eax,%edx
80107496:	8b 45 0c             	mov    0xc(%ebp),%eax
80107499:	c1 e8 18             	shr    $0x18,%eax
8010749c:	83 e0 0f             	and    $0xf,%eax
8010749f:	09 d0                	or     %edx,%eax
801074a1:	83 c8 e0             	or     $0xffffffe0,%eax
801074a4:	0f b6 d0             	movzbl %al,%edx
801074a7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801074ab:	83 c0 06             	add    $0x6,%eax
801074ae:	0f b7 c0             	movzwl %ax,%eax
801074b1:	83 ec 08             	sub    $0x8,%esp
801074b4:	52                   	push   %edx
801074b5:	50                   	push   %eax
801074b6:	e8 b0 f8 ff ff       	call   80106d6b <outb>
801074bb:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
801074be:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801074c2:	83 c0 07             	add    $0x7,%eax
801074c5:	0f b7 c0             	movzwl %ax,%eax
801074c8:	83 ec 08             	sub    $0x8,%esp
801074cb:	6a 30                	push   $0x30
801074cd:	50                   	push   %eax
801074ce:	e8 98 f8 ff ff       	call   80106d6b <outb>
801074d3:	83 c4 10             	add    $0x10,%esp

    int ret = 0;
801074d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
801074dd:	eb 3e                	jmp    8010751d <ide_write_secs+0x1ee>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
801074df:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801074e3:	83 ec 08             	sub    $0x8,%esp
801074e6:	6a 01                	push   $0x1
801074e8:	50                   	push   %eax
801074e9:	e8 9c f8 ff ff       	call   80106d8a <ide_wait_ready>
801074ee:	83 c4 10             	add    $0x10,%esp
801074f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074f8:	75 2b                	jne    80107525 <ide_write_secs+0x1f6>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
801074fa:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
801074fe:	83 ec 04             	sub    $0x4,%esp
80107501:	68 80 00 00 00       	push   $0x80
80107506:	ff 75 10             	pushl  0x10(%ebp)
80107509:	50                   	push   %eax
8010750a:	e8 36 f8 ff ff       	call   80106d45 <outsl>
8010750f:	83 c4 10             	add    $0x10,%esp
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
80107512:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
80107516:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
8010751d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107521:	75 bc                	jne    801074df <ide_write_secs+0x1b0>
80107523:	eb 01                	jmp    80107526 <ide_write_secs+0x1f7>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
80107525:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
80107526:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107529:	c9                   	leave  
8010752a:	c3                   	ret    

8010752b <initsleeplock>:
#include "sche.h"
#include "kdebug.h"
#include "cpu.h"
void
initsleeplock(struct sleeplock *lk, char *name)
{
8010752b:	55                   	push   %ebp
8010752c:	89 e5                	mov    %esp,%ebp
8010752e:	83 ec 08             	sub    $0x8,%esp
  init_lock(&lk->lk, "sleep lock");
80107531:	8b 45 08             	mov    0x8(%ebp),%eax
80107534:	83 c0 04             	add    $0x4,%eax
80107537:	83 ec 08             	sub    $0x8,%esp
8010753a:	68 f2 ba 10 80       	push   $0x8010baf2
8010753f:	50                   	push   %eax
80107540:	e8 54 02 00 00       	call   80107799 <init_lock>
80107545:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80107548:	8b 45 08             	mov    0x8(%ebp),%eax
8010754b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010754e:	89 50 10             	mov    %edx,0x10(%eax)
  lk->locked = 0;
80107551:	8b 45 08             	mov    0x8(%ebp),%eax
80107554:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010755a:	8b 45 08             	mov    0x8(%ebp),%eax
8010755d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
80107564:	90                   	nop
80107565:	c9                   	leave  
80107566:	c3                   	ret    

80107567 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80107567:	55                   	push   %ebp
80107568:	89 e5                	mov    %esp,%ebp
8010756a:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010756d:	8b 45 08             	mov    0x8(%ebp),%eax
80107570:	83 c0 04             	add    $0x4,%eax
80107573:	83 ec 0c             	sub    $0xc,%esp
80107576:	50                   	push   %eax
80107577:	e8 3f 02 00 00       	call   801077bb <acquire>
8010757c:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010757f:	eb 15                	jmp    80107596 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80107581:	8b 45 08             	mov    0x8(%ebp),%eax
80107584:	83 c0 04             	add    $0x4,%eax
80107587:	83 ec 08             	sub    $0x8,%esp
8010758a:	50                   	push   %eax
8010758b:	ff 75 08             	pushl  0x8(%ebp)
8010758e:	e8 4c 0c 00 00       	call   801081df <sleep>
80107593:	83 c4 10             	add    $0x10,%esp

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80107596:	8b 45 08             	mov    0x8(%ebp),%eax
80107599:	8b 00                	mov    (%eax),%eax
8010759b:	85 c0                	test   %eax,%eax
8010759d:	75 e2                	jne    80107581 <acquiresleep+0x1a>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
8010759f:	8b 45 08             	mov    0x8(%ebp),%eax
801075a2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = CUR_PROC->pid;
801075a8:	e8 be ef ff ff       	call   8010656b <get_cpu>
801075ad:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801075b3:	05 70 79 12 80       	add    $0x80127970,%eax
801075b8:	8b 00                	mov    (%eax),%eax
801075ba:	8b 50 14             	mov    0x14(%eax),%edx
801075bd:	8b 45 08             	mov    0x8(%ebp),%eax
801075c0:	89 50 14             	mov    %edx,0x14(%eax)
  release(&lk->lk);
801075c3:	8b 45 08             	mov    0x8(%ebp),%eax
801075c6:	83 c0 04             	add    $0x4,%eax
801075c9:	83 ec 0c             	sub    $0xc,%esp
801075cc:	50                   	push   %eax
801075cd:	e8 48 02 00 00       	call   8010781a <release>
801075d2:	83 c4 10             	add    $0x10,%esp
}
801075d5:	90                   	nop
801075d6:	c9                   	leave  
801075d7:	c3                   	ret    

801075d8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801075d8:	55                   	push   %ebp
801075d9:	89 e5                	mov    %esp,%ebp
801075db:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801075de:	8b 45 08             	mov    0x8(%ebp),%eax
801075e1:	83 c0 04             	add    $0x4,%eax
801075e4:	83 ec 0c             	sub    $0xc,%esp
801075e7:	50                   	push   %eax
801075e8:	e8 ce 01 00 00       	call   801077bb <acquire>
801075ed:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801075f0:	8b 45 08             	mov    0x8(%ebp),%eax
801075f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801075f9:	8b 45 08             	mov    0x8(%ebp),%eax
801075fc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  wakeup(lk);
80107603:	83 ec 0c             	sub    $0xc,%esp
80107606:	ff 75 08             	pushl  0x8(%ebp)
80107609:	e8 5b 0d 00 00       	call   80108369 <wakeup>
8010760e:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80107611:	8b 45 08             	mov    0x8(%ebp),%eax
80107614:	83 c0 04             	add    $0x4,%eax
80107617:	83 ec 0c             	sub    $0xc,%esp
8010761a:	50                   	push   %eax
8010761b:	e8 fa 01 00 00       	call   8010781a <release>
80107620:	83 c4 10             	add    $0x10,%esp
}
80107623:	90                   	nop
80107624:	c9                   	leave  
80107625:	c3                   	ret    

80107626 <holdingsleep>:

bool
holdingsleep(struct sleeplock *lk)
{
80107626:	55                   	push   %ebp
80107627:	89 e5                	mov    %esp,%ebp
80107629:	83 ec 18             	sub    $0x18,%esp
  bool r;
  
  acquire(&lk->lk);
8010762c:	8b 45 08             	mov    0x8(%ebp),%eax
8010762f:	83 c0 04             	add    $0x4,%eax
80107632:	83 ec 0c             	sub    $0xc,%esp
80107635:	50                   	push   %eax
80107636:	e8 80 01 00 00       	call   801077bb <acquire>
8010763b:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
8010763e:	8b 45 08             	mov    0x8(%ebp),%eax
80107641:	8b 00                	mov    (%eax),%eax
80107643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80107646:	8b 45 08             	mov    0x8(%ebp),%eax
80107649:	83 c0 04             	add    $0x4,%eax
8010764c:	83 ec 0c             	sub    $0xc,%esp
8010764f:	50                   	push   %eax
80107650:	e8 c5 01 00 00       	call   8010781a <release>
80107655:	83 c4 10             	add    $0x10,%esp
  return r;
80107658:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010765b:	c9                   	leave  
8010765c:	c3                   	ret    

8010765d <sti>:
  asm volatile("lidt (%0)" : : "r" (pd));
}


static inline void
sti(void) {
8010765d:	55                   	push   %ebp
8010765e:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
80107660:	fb                   	sti    
}
80107661:	90                   	nop
80107662:	5d                   	pop    %ebp
80107663:	c3                   	ret    

80107664 <cli>:

static inline void
cli(void) {
80107664:	55                   	push   %ebp
80107665:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli");
80107667:	fa                   	cli    
}
80107668:	90                   	nop
80107669:	5d                   	pop    %ebp
8010766a:	c3                   	ret    

8010766b <readeflags>:
}


static inline uint
readeflags(void)
{
8010766b:	55                   	push   %ebp
8010766c:	89 e5                	mov    %esp,%ebp
8010766e:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80107671:	9c                   	pushf  
80107672:	58                   	pop    %eax
80107673:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80107676:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107679:	c9                   	leave  
8010767a:	c3                   	ret    

8010767b <xchg>:
}


static inline uint
xchg(volatile uint *addr, uint newval)
{
8010767b:	55                   	push   %ebp
8010767c:	89 e5                	mov    %esp,%ebp
8010767e:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80107681:	8b 55 08             	mov    0x8(%ebp),%edx
80107684:	8b 45 0c             	mov    0xc(%ebp),%eax
80107687:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010768a:	f0 87 02             	lock xchg %eax,(%edx)
8010768d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80107690:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107693:	c9                   	leave  
80107694:	c3                   	ret    

80107695 <push_cli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
push_cli(void)
{
80107695:	55                   	push   %ebp
80107696:	89 e5                	mov    %esp,%ebp
80107698:	83 ec 18             	sub    $0x18,%esp
  int eflags;
  eflags = readeflags();
8010769b:	e8 cb ff ff ff       	call   8010766b <readeflags>
801076a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801076a3:	e8 bc ff ff ff       	call   80107664 <cli>
  struct cpu* cpu = &cpus[get_cpu()];
801076a8:	e8 be ee ff ff       	call   8010656b <get_cpu>
801076ad:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801076b3:	05 c0 78 12 80       	add    $0x801278c0,%eax
801076b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cpu->ncli == 0)
801076bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076be:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801076c4:	85 c0                	test   %eax,%eax
801076c6:	75 13                	jne    801076db <push_cli+0x46>
    cpu->intena = eflags & FL_IF;
801076c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076cb:	25 00 02 00 00       	and    $0x200,%eax
801076d0:	89 c2                	mov    %eax,%edx
801076d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076d5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
  cpu->ncli += 1;
801076db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076de:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801076e4:	8d 50 01             	lea    0x1(%eax),%edx
801076e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076ea:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801076f0:	90                   	nop
801076f1:	c9                   	leave  
801076f2:	c3                   	ret    

801076f3 <pop_cli>:

void
pop_cli(void)
{
801076f3:	55                   	push   %ebp
801076f4:	89 e5                	mov    %esp,%ebp
801076f6:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801076f9:	e8 6d ff ff ff       	call   8010766b <readeflags>
801076fe:	25 00 02 00 00       	and    $0x200,%eax
80107703:	85 c0                	test   %eax,%eax
80107705:	74 17                	je     8010771e <pop_cli+0x2b>
    panic("popcli - interruptible");
80107707:	83 ec 04             	sub    $0x4,%esp
8010770a:	68 fd ba 10 80       	push   $0x8010bafd
8010770f:	6a 1c                	push   $0x1c
80107711:	68 14 bb 10 80       	push   $0x8010bb14
80107716:	e8 39 8c ff ff       	call   80100354 <__panic>
8010771b:	83 c4 10             	add    $0x10,%esp
  struct cpu* cpu = &cpus[get_cpu()];
8010771e:	e8 48 ee ff ff       	call   8010656b <get_cpu>
80107723:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107729:	05 c0 78 12 80       	add    $0x801278c0,%eax
8010772e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(--cpu->ncli < 0)
80107731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107734:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010773a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010773d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107740:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80107746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107749:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010774f:	85 c0                	test   %eax,%eax
80107751:	75 12                	jne    80107765 <pop_cli+0x72>
80107753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107756:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010775c:	85 c0                	test   %eax,%eax
8010775e:	74 05                	je     80107765 <pop_cli+0x72>
    sti();
80107760:	e8 f8 fe ff ff       	call   8010765d <sti>
}
80107765:	90                   	nop
80107766:	c9                   	leave  
80107767:	c3                   	ret    

80107768 <holding>:

// Check whether this cpu is holding the lock.
bool
holding(struct spinlock *lock)
{
80107768:	55                   	push   %ebp
80107769:	89 e5                	mov    %esp,%ebp
8010776b:	53                   	push   %ebx
8010776c:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == get_cpu();
8010776f:	8b 45 08             	mov    0x8(%ebp),%eax
80107772:	8b 00                	mov    (%eax),%eax
80107774:	85 c0                	test   %eax,%eax
80107776:	74 16                	je     8010778e <holding+0x26>
80107778:	8b 45 08             	mov    0x8(%ebp),%eax
8010777b:	8b 58 08             	mov    0x8(%eax),%ebx
8010777e:	e8 e8 ed ff ff       	call   8010656b <get_cpu>
80107783:	39 c3                	cmp    %eax,%ebx
80107785:	75 07                	jne    8010778e <holding+0x26>
80107787:	b8 01 00 00 00       	mov    $0x1,%eax
8010778c:	eb 05                	jmp    80107793 <holding+0x2b>
8010778e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107793:	83 c4 04             	add    $0x4,%esp
80107796:	5b                   	pop    %ebx
80107797:	5d                   	pop    %ebp
80107798:	c3                   	ret    

80107799 <init_lock>:

void
init_lock(struct spinlock *lk,const char *name)
{
80107799:	55                   	push   %ebp
8010779a:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010779c:	8b 45 08             	mov    0x8(%ebp),%eax
8010779f:	8b 55 0c             	mov    0xc(%ebp),%edx
801077a2:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801077a5:	8b 45 08             	mov    0x8(%ebp),%eax
801077a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801077ae:	8b 45 08             	mov    0x8(%ebp),%eax
801077b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801077b8:	90                   	nop
801077b9:	5d                   	pop    %ebp
801077ba:	c3                   	ret    

801077bb <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801077bb:	55                   	push   %ebp
801077bc:	89 e5                	mov    %esp,%ebp
801077be:	83 ec 08             	sub    $0x8,%esp
  push_cli(); // disable interrupts to avoid deadlock.
801077c1:	e8 cf fe ff ff       	call   80107695 <push_cli>
  if(holding(lk))
801077c6:	83 ec 0c             	sub    $0xc,%esp
801077c9:	ff 75 08             	pushl  0x8(%ebp)
801077cc:	e8 97 ff ff ff       	call   80107768 <holding>
801077d1:	83 c4 10             	add    $0x10,%esp
801077d4:	85 c0                	test   %eax,%eax
801077d6:	74 17                	je     801077ef <acquire+0x34>
    panic("acquire");
801077d8:	83 ec 04             	sub    $0x4,%esp
801077db:	68 29 bb 10 80       	push   $0x8010bb29
801077e0:	6a 3c                	push   $0x3c
801077e2:	68 14 bb 10 80       	push   $0x8010bb14
801077e7:	e8 68 8b ff ff       	call   80100354 <__panic>
801077ec:	83 c4 10             	add    $0x10,%esp

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801077ef:	90                   	nop
801077f0:	8b 45 08             	mov    0x8(%ebp),%eax
801077f3:	83 ec 08             	sub    $0x8,%esp
801077f6:	6a 01                	push   $0x1
801077f8:	50                   	push   %eax
801077f9:	e8 7d fe ff ff       	call   8010767b <xchg>
801077fe:	83 c4 10             	add    $0x10,%esp
80107801:	85 c0                	test   %eax,%eax
80107803:	75 eb                	jne    801077f0 <acquire+0x35>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80107805:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = get_cpu();
8010780a:	e8 5c ed ff ff       	call   8010656b <get_cpu>
8010780f:	89 c2                	mov    %eax,%edx
80107811:	8b 45 08             	mov    0x8(%ebp),%eax
80107814:	89 50 08             	mov    %edx,0x8(%eax)
//  getcallerpcs(&lk, lk->pcs);
}
80107817:	90                   	nop
80107818:	c9                   	leave  
80107819:	c3                   	ret    

8010781a <release>:


// Release the lock.
void
release(struct spinlock *lk)
{
8010781a:	55                   	push   %ebp
8010781b:	89 e5                	mov    %esp,%ebp
8010781d:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	ff 75 08             	pushl  0x8(%ebp)
80107826:	e8 3d ff ff ff       	call   80107768 <holding>
8010782b:	83 c4 10             	add    $0x10,%esp
8010782e:	85 c0                	test   %eax,%eax
80107830:	75 17                	jne    80107849 <release+0x2f>
    panic("release");
80107832:	83 ec 04             	sub    $0x4,%esp
80107835:	68 31 bb 10 80       	push   $0x8010bb31
8010783a:	6a 53                	push   $0x53
8010783c:	68 14 bb 10 80       	push   $0x8010bb14
80107841:	e8 0e 8b ff ff       	call   80100354 <__panic>
80107846:	83 c4 10             	add    $0x10,%esp

  lk->cpu = 0;
80107849:	8b 45 08             	mov    0x8(%ebp),%eax
8010784c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80107853:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80107858:	8b 45 08             	mov    0x8(%ebp),%eax
8010785b:	8b 55 08             	mov    0x8(%ebp),%edx
8010785e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  pop_cli();
80107864:	e8 8a fe ff ff       	call   801076f3 <pop_cli>
}
80107869:	90                   	nop
8010786a:	c9                   	leave  
8010786b:	c3                   	ret    

8010786c <main>:
#include "elf.h"
#include "kdebug.h"
#include "trap.h"
#include "proc.h"
#include "sche.h"
int main() {
8010786c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80107870:	83 e4 f0             	and    $0xfffffff0,%esp
80107873:	ff 71 fc             	pushl  -0x4(%ecx)
80107876:	55                   	push   %ebp
80107877:	89 e5                	mov    %esp,%ebp
80107879:	51                   	push   %ecx
8010787a:	83 ec 14             	sub    $0x14,%esp
    
    asm volatile("cli");
8010787d:	fa                   	cli    
    cprintf("cpu 0 : %d %d \n",cpus[0].ncli, cpus[0].intena);
8010787e:	8b 15 6c 79 12 80    	mov    0x8012796c,%edx
80107884:	a1 68 79 12 80       	mov    0x80127968,%eax
80107889:	83 ec 04             	sub    $0x4,%esp
8010788c:	52                   	push   %edx
8010788d:	50                   	push   %eax
8010788e:	68 3c bb 10 80       	push   $0x8010bb3c
80107893:	e8 3f f4 ff ff       	call   80106cd7 <cprintf>
80107898:	83 c4 10             	add    $0x10,%esp
    init_cons();
8010789b:	e8 8a f1 ff ff       	call   80106a2a <init_cons>
    clear_cons();
801078a0:	e8 a3 f1 ff ff       	call   80106a48 <clear_cons>
    init_uart();
801078a5:	e8 8f ed ff ff       	call   80106639 <init_uart>

    extern char data[],edata[],end[];
    cprintf("%s%2c%drl%x\n","Hello",'W',0,13);
801078aa:	83 ec 0c             	sub    $0xc,%esp
801078ad:	6a 0d                	push   $0xd
801078af:	6a 00                	push   $0x0
801078b1:	6a 57                	push   $0x57
801078b3:	68 4c bb 10 80       	push   $0x8010bb4c
801078b8:	68 52 bb 10 80       	push   $0x8010bb52
801078bd:	e8 15 f4 ff ff       	call   80106cd7 <cprintf>
801078c2:	83 c4 20             	add    $0x20,%esp
    cprintf("start cpu id = %d\n",get_cpu());
801078c5:	e8 a1 ec ff ff       	call   8010656b <get_cpu>
801078ca:	83 ec 08             	sub    $0x8,%esp
801078cd:	50                   	push   %eax
801078ce:	68 5f bb 10 80       	push   $0x8010bb5f
801078d3:	e8 ff f3 ff ff       	call   80106cd7 <cprintf>
801078d8:	83 c4 10             	add    $0x10,%esp
    cprintf("data : %08x , edata %x , end %x\n",(int)data,(int)edata,(int)end);
801078db:	b9 d0 9b 12 80       	mov    $0x80129bd0,%ecx
801078e0:	ba a0 6e 12 80       	mov    $0x80126ea0,%edx
801078e5:	b8 00 40 12 80       	mov    $0x80124000,%eax
801078ea:	51                   	push   %ecx
801078eb:	52                   	push   %edx
801078ec:	50                   	push   %eax
801078ed:	68 74 bb 10 80       	push   $0x8010bb74
801078f2:	e8 e0 f3 ff ff       	call   80106cd7 <cprintf>
801078f7:	83 c4 10             	add    $0x10,%esp

    init_pmm();
801078fa:	e8 43 91 ff ff       	call   80100a42 <init_pmm>

    mpinit();
801078ff:	e8 13 eb ff ff       	call   80106417 <mpinit>
    lapicinit();
80107904:	e8 77 e4 ff ff       	call   80105d80 <lapicinit>
    ioapicinit();
80107909:	e8 59 de ff ff       	call   80105767 <ioapicinit>


    cprintf("cpu id = %d\n",get_cpu());
8010790e:	e8 58 ec ff ff       	call   8010656b <get_cpu>
80107913:	83 ec 08             	sub    $0x8,%esp
80107916:	50                   	push   %eax
80107917:	68 95 bb 10 80       	push   $0x8010bb95
8010791c:	e8 b6 f3 ff ff       	call   80106cd7 <cprintf>
80107921:	83 c4 10             	add    $0x10,%esp
    tvinit();
80107924:	e8 87 df ff ff       	call   801058b0 <tvinit>
    idtinit();
80107929:	e8 e3 e0 ff ff       	call   80105a11 <idtinit>

    kbd_init();
8010792e:	e8 45 f0 ff ff       	call   80106978 <kbd_init>
    ide_init();
80107933:	e8 a3 f4 ff ff       	call   80106ddb <ide_init>
    }
    test[0] = 'B';
    ide_write_secs(1,0,test,1);
    cprintf("\n");
   */ 
    check_vmm();
80107938:	e8 b0 a8 ff ff       	call   801021ed <check_vmm>

    cprintf("cpunum : %d\n", ncpu);
8010793d:	a1 54 6f 12 80       	mov    0x80126f54,%eax
80107942:	83 ec 08             	sub    $0x8,%esp
80107945:	50                   	push   %eax
80107946:	68 a2 bb 10 80       	push   $0x8010bba2
8010794b:	e8 87 f3 ff ff       	call   80106cd7 <cprintf>
80107950:	83 c4 10             	add    $0x10,%esp
    cprintf("LAPIC : %x\n",(int)lapic);
80107953:	a1 ac 78 12 80       	mov    0x801278ac,%eax
80107958:	83 ec 08             	sub    $0x8,%esp
8010795b:	50                   	push   %eax
8010795c:	68 af bb 10 80       	push   $0x8010bbaf
80107961:	e8 71 f3 ff ff       	call   80106cd7 <cprintf>
80107966:	83 c4 10             	add    $0x10,%esp
    proc_init();
80107969:	e8 e9 0e 00 00       	call   80108857 <proc_init>
    cprintf("proc init\n");
8010796e:	83 ec 0c             	sub    $0xc,%esp
80107971:	68 bb bb 10 80       	push   $0x8010bbbb
80107976:	e8 5c f3 ff ff       	call   80106cd7 <cprintf>
8010797b:	83 c4 10             	add    $0x10,%esp

    cprintf("cpu 0 : %d %d \n",cpus[0].ncli, cpus[0].intena);
8010797e:	8b 15 6c 79 12 80    	mov    0x8012796c,%edx
80107984:	a1 68 79 12 80       	mov    0x80127968,%eax
80107989:	83 ec 04             	sub    $0x4,%esp
8010798c:	52                   	push   %edx
8010798d:	50                   	push   %eax
8010798e:	68 3c bb 10 80       	push   $0x8010bb3c
80107993:	e8 3f f3 ff ff       	call   80106cd7 <cprintf>
80107998:	83 c4 10             	add    $0x10,%esp
    asm volatile ("sti");
8010799b:	fb                   	sti    

    int *c = kmalloc(4);
8010799c:	83 ec 0c             	sub    $0xc,%esp
8010799f:	6a 04                	push   $0x4
801079a1:	e8 89 b3 ff ff       	call   80102d2f <kmalloc>
801079a6:	83 c4 10             	add    $0x10,%esp
801079a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *c = 1;
801079ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079af:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    cprintf("c : %x\n", c);
801079b5:	83 ec 08             	sub    $0x8,%esp
801079b8:	ff 75 f4             	pushl  -0xc(%ebp)
801079bb:	68 c6 bb 10 80       	push   $0x8010bbc6
801079c0:	e8 12 f3 ff ff       	call   80106cd7 <cprintf>
801079c5:	83 c4 10             	add    $0x10,%esp

    while(1)
    {
        sche();
801079c8:	e8 0b 04 00 00       	call   80107dd8 <sche>
    }
801079cd:	eb f9                	jmp    801079c8 <main+0x15c>

801079cf <find_proc>:
#define RELEASE release(LOCK)

void swtch(struct context **a, struct context *b);

struct proc*
find_proc(uint32_t pid){
801079cf:	55                   	push   %ebp
801079d0:	89 e5                	mov    %esp,%ebp
801079d2:	83 ec 28             	sub    $0x28,%esp
    ACQUIRE;
801079d5:	83 ec 0c             	sub    $0xc,%esp
801079d8:	68 a0 7b 12 80       	push   $0x80127ba0
801079dd:	e8 d9 fd ff ff       	call   801077bb <acquire>
801079e2:	83 c4 10             	add    $0x10,%esp
    list_entry_t *ready_queue = &proc_manager.ready;
801079e5:	c7 45 ec b0 7b 12 80 	movl   $0x80127bb0,-0x14(%ebp)
    list_entry_t *sleep_queue = &proc_manager.sleep;
801079ec:	c7 45 e8 b8 7b 12 80 	movl   $0x80127bb8,-0x18(%ebp)
    struct proc* proc = NULL;
801079f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(IDLE_PROC != NULL && IDLE_PROC->pid == pid)
801079fa:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
801079ff:	85 c0                	test   %eax,%eax
80107a01:	74 1a                	je     80107a1d <find_proc+0x4e>
80107a03:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
80107a08:	8b 40 14             	mov    0x14(%eax),%eax
80107a0b:	3b 45 08             	cmp    0x8(%ebp),%eax
80107a0e:	75 0d                	jne    80107a1d <find_proc+0x4e>
    {
        proc = IDLE_PROC;
80107a10:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
80107a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto found;
80107a18:	e9 c1 00 00 00       	jmp    80107ade <find_proc+0x10f>
    }
    if(INIT_PROC != NULL && INIT_PROC->pid == pid)
80107a1d:	a1 c0 7b 12 80       	mov    0x80127bc0,%eax
80107a22:	85 c0                	test   %eax,%eax
80107a24:	74 1a                	je     80107a40 <find_proc+0x71>
80107a26:	a1 c0 7b 12 80       	mov    0x80127bc0,%eax
80107a2b:	8b 40 14             	mov    0x14(%eax),%eax
80107a2e:	3b 45 08             	cmp    0x8(%ebp),%eax
80107a31:	75 0d                	jne    80107a40 <find_proc+0x71>
    {
        proc = INIT_PROC;
80107a33:	a1 c0 7b 12 80       	mov    0x80127bc0,%eax
80107a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto found;
80107a3b:	e9 9e 00 00 00       	jmp    80107ade <find_proc+0x10f>
    }

    list_entry_t *le = ready_queue; 
80107a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((le = list_next(le)) != ready_queue)
80107a46:	eb 14                	jmp    80107a5c <find_proc+0x8d>
    {
        proc = list2proc(le);
80107a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a4b:	83 e8 40             	sub    $0x40,%eax
80107a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(proc->pid == pid)
80107a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a54:	8b 40 14             	mov    0x14(%eax),%eax
80107a57:	3b 45 08             	cmp    0x8(%ebp),%eax
80107a5a:	74 7e                	je     80107ada <find_proc+0x10b>
80107a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm)
{
    return listelm->next;
80107a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a65:	8b 40 04             	mov    0x4(%eax),%eax
        proc = INIT_PROC;
        goto found;
    }

    list_entry_t *le = ready_queue; 
    while((le = list_next(le)) != ready_queue)
80107a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a6e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80107a71:	75 d5                	jne    80107a48 <find_proc+0x79>
        if(proc->pid == pid)
        {
            goto found;
        }
    }
    le = sleep_queue; 
80107a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((le = list_next(le)) != sleep_queue)
80107a79:	eb 14                	jmp    80107a8f <find_proc+0xc0>
    {
        proc = list2proc(le);
80107a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a7e:	83 e8 40             	sub    $0x40,%eax
80107a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(proc->pid == pid)
80107a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a87:	8b 40 14             	mov    0x14(%eax),%eax
80107a8a:	3b 45 08             	cmp    0x8(%ebp),%eax
80107a8d:	74 4e                	je     80107add <find_proc+0x10e>
80107a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a98:	8b 40 04             	mov    0x4(%eax),%eax
        {
            goto found;
        }
    }
    le = sleep_queue; 
    while((le = list_next(le)) != sleep_queue)
80107a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aa1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80107aa4:	75 d5                	jne    80107a7b <find_proc+0xac>
        if(proc->pid == pid)
        {
            goto found;
        }
    }
    RELEASE;
80107aa6:	83 ec 0c             	sub    $0xc,%esp
80107aa9:	68 a0 7b 12 80       	push   $0x80127ba0
80107aae:	e8 67 fd ff ff       	call   8010781a <release>
80107ab3:	83 c4 10             	add    $0x10,%esp
    assert(proc == NULL);
80107ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107aba:	74 19                	je     80107ad5 <find_proc+0x106>
80107abc:	68 ce bb 10 80       	push   $0x8010bbce
80107ac1:	68 db bb 10 80       	push   $0x8010bbdb
80107ac6:	6a 35                	push   $0x35
80107ac8:	68 f1 bb 10 80       	push   $0x8010bbf1
80107acd:	e8 82 88 ff ff       	call   80100354 <__panic>
80107ad2:	83 c4 10             	add    $0x10,%esp
    return proc;
80107ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad8:	eb 17                	jmp    80107af1 <find_proc+0x122>
    while((le = list_next(le)) != ready_queue)
    {
        proc = list2proc(le);
        if(proc->pid == pid)
        {
            goto found;
80107ada:	90                   	nop
80107adb:	eb 01                	jmp    80107ade <find_proc+0x10f>
    while((le = list_next(le)) != sleep_queue)
    {
        proc = list2proc(le);
        if(proc->pid == pid)
        {
            goto found;
80107add:	90                   	nop
    }
    RELEASE;
    assert(proc == NULL);
    return proc;
found:
    RELEASE;
80107ade:	83 ec 0c             	sub    $0xc,%esp
80107ae1:	68 a0 7b 12 80       	push   $0x80127ba0
80107ae6:	e8 2f fd ff ff       	call   8010781a <release>
80107aeb:	83 c4 10             	add    $0x10,%esp
    return proc;
80107aee:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
80107af1:	c9                   	leave  
80107af2:	c3                   	ret    

80107af3 <get_proc>:
struct proc*
get_proc(){
80107af3:	55                   	push   %ebp
80107af4:	89 e5                	mov    %esp,%ebp
80107af6:	83 ec 20             	sub    $0x20,%esp
    list_entry_t *head = &proc_manager.ready;
80107af9:	c7 45 fc b0 7b 12 80 	movl   $0x80127bb0,-0x4(%ebp)
80107b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
80107b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b09:	8b 40 04             	mov    0x4(%eax),%eax
80107b0c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107b0f:	0f 94 c0             	sete   %al
80107b12:	0f b6 c0             	movzbl %al,%eax
    if(!list_empty(head)){
80107b15:	85 c0                	test   %eax,%eax
80107b17:	75 5c                	jne    80107b75 <get_proc+0x82>
       struct proc *ret = list2proc(head->next);
80107b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b1c:	8b 40 04             	mov    0x4(%eax),%eax
80107b1f:	83 e8 40             	sub    $0x40,%eax
80107b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
       list_del_init(head->next);
80107b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b28:	8b 40 04             	mov    0x4(%eax),%eax
80107b2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
80107b2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107b31:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80107b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b37:	8b 40 04             	mov    0x4(%eax),%eax
80107b3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107b3d:	8b 12                	mov    (%edx),%edx
80107b3f:	89 55 e8             	mov    %edx,-0x18(%ebp)
80107b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80107b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107b48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b4b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80107b4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b51:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107b54:	89 10                	mov    %edx,(%eax)
80107b56:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107b59:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80107b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107b62:	89 50 04             	mov    %edx,0x4(%eax)
80107b65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b68:	8b 50 04             	mov    0x4(%eax),%edx
80107b6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b6e:	89 10                	mov    %edx,(%eax)
       return ret; 
80107b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b73:	eb 05                	jmp    80107b7a <get_proc+0x87>
    }
    return NULL;
80107b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b7a:	c9                   	leave  
80107b7b:	c3                   	ret    

80107b7c <put_proc>:

bool
put_proc(struct proc *proc){
80107b7c:	55                   	push   %ebp
80107b7d:	89 e5                	mov    %esp,%ebp
80107b7f:	83 ec 30             	sub    $0x30,%esp
    list_entry_t *head = &proc_manager.ready;
80107b82:	c7 45 fc b0 7b 12 80 	movl   $0x80127bb0,-0x4(%ebp)
    list_del_init(&proc->elm);
80107b89:	8b 45 08             	mov    0x8(%ebp),%eax
80107b8c:	83 c0 40             	add    $0x40,%eax
80107b8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
80107b92:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107b95:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80107b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b9b:	8b 40 04             	mov    0x4(%eax),%eax
80107b9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107ba1:	8b 12                	mov    (%edx),%edx
80107ba3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80107ba6:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80107ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107bac:	8b 55 d8             	mov    -0x28(%ebp),%edx
80107baf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80107bb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107bb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107bb8:	89 10                	mov    %edx,(%eax)
80107bba:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107bbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80107bc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107bc3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80107bc6:	89 50 04             	mov    %edx,0x4(%eax)
80107bc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107bcc:	8b 50 04             	mov    0x4(%eax),%edx
80107bcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107bd2:	89 10                	mov    %edx,(%eax)
    list_add_before(head, &proc->elm);
80107bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd7:	8d 50 40             	lea    0x40(%eax),%edx
80107bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107be0:	89 55 f0             	mov    %edx,-0x10(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) 
{
    __list_add(elm, listelm->prev, listelm);    
80107be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be6:	8b 00                	mov    (%eax),%eax
80107be8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107beb:	89 55 ec             	mov    %edx,-0x14(%ebp)
80107bee:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
80107bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107bfd:	89 10                	mov    %edx,(%eax)
80107bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c02:	8b 10                	mov    (%eax),%edx
80107c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c07:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
80107c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c10:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
80107c13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c16:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107c19:	89 10                	mov    %edx,(%eax)
    return true;
80107c1b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107c20:	c9                   	leave  
80107c21:	c3                   	ret    

80107c22 <put_proc_sleep>:

bool
put_proc_sleep(struct proc *proc){
80107c22:	55                   	push   %ebp
80107c23:	89 e5                	mov    %esp,%ebp
80107c25:	83 ec 30             	sub    $0x30,%esp
    list_entry_t *head = &proc_manager.sleep;
80107c28:	c7 45 fc b8 7b 12 80 	movl   $0x80127bb8,-0x4(%ebp)
    list_del_init(&proc->elm);
80107c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80107c32:	83 c0 40             	add    $0x40,%eax
80107c35:	89 45 f8             	mov    %eax,-0x8(%ebp)
80107c38:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107c3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80107c3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c41:	8b 40 04             	mov    0x4(%eax),%eax
80107c44:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107c47:	8b 12                	mov    (%edx),%edx
80107c49:	89 55 dc             	mov    %edx,-0x24(%ebp)
80107c4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80107c4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107c52:	8b 55 d8             	mov    -0x28(%ebp),%edx
80107c55:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
80107c58:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107c5b:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107c5e:	89 10                	mov    %edx,(%eax)
80107c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107c63:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80107c66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107c69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80107c6c:	89 50 04             	mov    %edx,0x4(%eax)
80107c6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107c72:	8b 50 04             	mov    0x4(%eax),%edx
80107c75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107c78:	89 10                	mov    %edx,(%eax)
    list_add_before(head, &proc->elm);
80107c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80107c7d:	8d 50 40             	lea    0x40(%eax),%edx
80107c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c86:	89 55 f0             	mov    %edx,-0x10(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) 
{
    __list_add(elm, listelm->prev, listelm);    
80107c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8c:	8b 00                	mov    (%eax),%eax
80107c8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107c91:	89 55 ec             	mov    %edx,-0x14(%ebp)
80107c94:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
80107c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ca0:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107ca3:	89 10                	mov    %edx,(%eax)
80107ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ca8:	8b 10                	mov    (%eax),%edx
80107caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107cad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
80107cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107cb6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
80107cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107cbf:	89 10                	mov    %edx,(%eax)
    return true;
80107cc1:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107cc6:	c9                   	leave  
80107cc7:	c3                   	ret    

80107cc8 <init_sche>:


void init_sche()
{
80107cc8:	55                   	push   %ebp
80107cc9:	89 e5                	mov    %esp,%ebp
80107ccb:	83 ec 18             	sub    $0x18,%esp
    init_lock(LOCK, "lock");
80107cce:	83 ec 08             	sub    $0x8,%esp
80107cd1:	68 02 bc 10 80       	push   $0x8010bc02
80107cd6:	68 a0 7b 12 80       	push   $0x80127ba0
80107cdb:	e8 b9 fa ff ff       	call   80107799 <init_lock>
80107ce0:	83 c4 10             	add    $0x10,%esp
80107ce3:	c7 45 f4 b0 7b 12 80 	movl   $0x80127bb0,-0xc(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80107cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cf0:	89 50 04             	mov    %edx,0x4(%eax)
80107cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf6:	8b 50 04             	mov    0x4(%eax),%edx
80107cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cfc:	89 10                	mov    %edx,(%eax)
80107cfe:	c7 45 f0 b8 7b 12 80 	movl   $0x80127bb8,-0x10(%ebp)
80107d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d0b:	89 50 04             	mov    %edx,0x4(%eax)
80107d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d11:	8b 50 04             	mov    0x4(%eax),%edx
80107d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d17:	89 10                	mov    %edx,(%eax)
    list_init(&proc_manager.ready);
    list_init(&proc_manager.sleep);
    proc_manager.n_process = 0;
80107d19:	c7 05 ac 7b 12 80 00 	movl   $0x0,0x80127bac
80107d20:	00 00 00 
    proc_manager.cur_use_pid = 0;
80107d23:	c7 05 c8 7b 12 80 00 	movl   $0x0,0x80127bc8
80107d2a:	00 00 00 
}
80107d2d:	90                   	nop
80107d2e:	c9                   	leave  
80107d2f:	c3                   	ret    

80107d30 <get_pid>:

uint32_t get_pid()
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	83 ec 18             	sub    $0x18,%esp
    uint32_t ret;
    ACQUIRE;
80107d36:	83 ec 0c             	sub    $0xc,%esp
80107d39:	68 a0 7b 12 80       	push   $0x80127ba0
80107d3e:	e8 78 fa ff ff       	call   801077bb <acquire>
80107d43:	83 c4 10             	add    $0x10,%esp
    ret = proc_manager.cur_use_pid ++;
80107d46:	a1 c8 7b 12 80       	mov    0x80127bc8,%eax
80107d4b:	8d 50 01             	lea    0x1(%eax),%edx
80107d4e:	89 15 c8 7b 12 80    	mov    %edx,0x80127bc8
80107d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    RELEASE;
80107d57:	83 ec 0c             	sub    $0xc,%esp
80107d5a:	68 a0 7b 12 80       	push   $0x80127ba0
80107d5f:	e8 b6 fa ff ff       	call   8010781a <release>
80107d64:	83 c4 10             	add    $0x10,%esp
    return ret;
80107d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107d6a:	c9                   	leave  
80107d6b:	c3                   	ret    

80107d6c <inc_proc_n>:
void inc_proc_n()
{
80107d6c:	55                   	push   %ebp
80107d6d:	89 e5                	mov    %esp,%ebp
80107d6f:	83 ec 08             	sub    $0x8,%esp
    ACQUIRE;
80107d72:	83 ec 0c             	sub    $0xc,%esp
80107d75:	68 a0 7b 12 80       	push   $0x80127ba0
80107d7a:	e8 3c fa ff ff       	call   801077bb <acquire>
80107d7f:	83 c4 10             	add    $0x10,%esp
    proc_manager.n_process ++;
80107d82:	a1 ac 7b 12 80       	mov    0x80127bac,%eax
80107d87:	83 c0 01             	add    $0x1,%eax
80107d8a:	a3 ac 7b 12 80       	mov    %eax,0x80127bac
    RELEASE;
80107d8f:	83 ec 0c             	sub    $0xc,%esp
80107d92:	68 a0 7b 12 80       	push   $0x80127ba0
80107d97:	e8 7e fa ff ff       	call   8010781a <release>
80107d9c:	83 c4 10             	add    $0x10,%esp
}
80107d9f:	90                   	nop
80107da0:	c9                   	leave  
80107da1:	c3                   	ret    

80107da2 <dec_proc_n>:
void dec_proc_n()
{
80107da2:	55                   	push   %ebp
80107da3:	89 e5                	mov    %esp,%ebp
80107da5:	83 ec 08             	sub    $0x8,%esp
    ACQUIRE;
80107da8:	83 ec 0c             	sub    $0xc,%esp
80107dab:	68 a0 7b 12 80       	push   $0x80127ba0
80107db0:	e8 06 fa ff ff       	call   801077bb <acquire>
80107db5:	83 c4 10             	add    $0x10,%esp
    proc_manager.n_process --;
80107db8:	a1 ac 7b 12 80       	mov    0x80127bac,%eax
80107dbd:	83 e8 01             	sub    $0x1,%eax
80107dc0:	a3 ac 7b 12 80       	mov    %eax,0x80127bac
    RELEASE;
80107dc5:	83 ec 0c             	sub    $0xc,%esp
80107dc8:	68 a0 7b 12 80       	push   $0x80127ba0
80107dcd:	e8 48 fa ff ff       	call   8010781a <release>
80107dd2:	83 c4 10             	add    $0x10,%esp
}
80107dd5:	90                   	nop
80107dd6:	c9                   	leave  
80107dd7:	c3                   	ret    

80107dd8 <sche>:

void sche()
{
80107dd8:	55                   	push   %ebp
80107dd9:	89 e5                	mov    %esp,%ebp
80107ddb:	83 ec 18             	sub    $0x18,%esp
    ACQUIRE;
80107dde:	83 ec 0c             	sub    $0xc,%esp
80107de1:	68 a0 7b 12 80       	push   $0x80127ba0
80107de6:	e8 d0 f9 ff ff       	call   801077bb <acquire>
80107deb:	83 c4 10             	add    $0x10,%esp
    assert(PCPU->ncli == 1);
80107dee:	e8 78 e7 ff ff       	call   8010656b <get_cpu>
80107df3:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107df9:	05 68 79 12 80       	add    $0x80127968,%eax
80107dfe:	8b 00                	mov    (%eax),%eax
80107e00:	83 f8 01             	cmp    $0x1,%eax
80107e03:	74 19                	je     80107e1e <sche+0x46>
80107e05:	68 07 bc 10 80       	push   $0x8010bc07
80107e0a:	68 db bb 10 80       	push   $0x8010bbdb
80107e0f:	6a 79                	push   $0x79
80107e11:	68 f1 bb 10 80       	push   $0x8010bbf1
80107e16:	e8 39 85 ff ff       	call   80100354 <__panic>
80107e1b:	83 c4 10             	add    $0x10,%esp
    struct proc *idleproc = IDLE_PROC;
80107e1e:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
80107e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct proc *current = CUR_PROC;
80107e26:	e8 40 e7 ff ff       	call   8010656b <get_cpu>
80107e2b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107e31:	05 70 79 12 80       	add    $0x80127970,%eax
80107e36:	8b 00                	mov    (%eax),%eax
80107e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(current && idleproc);
80107e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e3f:	74 06                	je     80107e47 <sche+0x6f>
80107e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107e45:	75 19                	jne    80107e60 <sche+0x88>
80107e47:	68 17 bc 10 80       	push   $0x8010bc17
80107e4c:	68 db bb 10 80       	push   $0x8010bbdb
80107e51:	6a 7c                	push   $0x7c
80107e53:	68 f1 bb 10 80       	push   $0x8010bbf1
80107e58:	e8 f7 84 ff ff       	call   80100354 <__panic>
80107e5d:	83 c4 10             	add    $0x10,%esp
    struct proc *new = get_proc();
80107e60:	e8 8e fc ff ff       	call   80107af3 <get_proc>
80107e65:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(new)
80107e68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e6c:	0f 84 99 00 00 00    	je     80107f0b <sche+0x133>
    {
        if(current->state == RUNNING || current->state == RUNNABLE)
80107e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e75:	8b 40 10             	mov    0x10(%eax),%eax
80107e78:	83 f8 04             	cmp    $0x4,%eax
80107e7b:	74 0b                	je     80107e88 <sche+0xb0>
80107e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e80:	8b 40 10             	mov    0x10(%eax),%eax
80107e83:	83 f8 03             	cmp    $0x3,%eax
80107e86:	75 10                	jne    80107e98 <sche+0xc0>
        {
            put_proc(current);
80107e88:	83 ec 0c             	sub    $0xc,%esp
80107e8b:	ff 75 f0             	pushl  -0x10(%ebp)
80107e8e:	e8 e9 fc ff ff       	call   80107b7c <put_proc>
80107e93:	83 c4 10             	add    $0x10,%esp
80107e96:	eb 25                	jmp    80107ebd <sche+0xe5>
        }
        else{
            cprintf("CURRENT->state : %d\n", current->state);
80107e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e9b:	8b 40 10             	mov    0x10(%eax),%eax
80107e9e:	83 ec 08             	sub    $0x8,%esp
80107ea1:	50                   	push   %eax
80107ea2:	68 2b bc 10 80       	push   $0x8010bc2b
80107ea7:	e8 2b ee ff ff       	call   80106cd7 <cprintf>
80107eac:	83 c4 10             	add    $0x10,%esp
            put_proc_sleep(current);
80107eaf:	83 ec 0c             	sub    $0xc,%esp
80107eb2:	ff 75 f0             	pushl  -0x10(%ebp)
80107eb5:	e8 68 fd ff ff       	call   80107c22 <put_proc_sleep>
80107eba:	83 c4 10             	add    $0x10,%esp
        }
        new->state = RUNNING;
80107ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ec0:	c7 40 10 04 00 00 00 	movl   $0x4,0x10(%eax)
        CUR_PROC = new;
80107ec7:	e8 9f e6 ff ff       	call   8010656b <get_cpu>
80107ecc:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107ed2:	8d 90 70 79 12 80    	lea    -0x7fed8690(%eax),%edx
80107ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107edb:	89 02                	mov    %eax,(%edx)
        switchuvm(new);
80107edd:	83 ec 0c             	sub    $0xc,%esp
80107ee0:	ff 75 ec             	pushl  -0x14(%ebp)
80107ee3:	e8 e1 95 ff ff       	call   801014c9 <switchuvm>
80107ee8:	83 c4 10             	add    $0x10,%esp
        swtch(&current->context, new->context);
80107eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107eee:	8b 40 20             	mov    0x20(%eax),%eax
80107ef1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107ef4:	83 c2 20             	add    $0x20,%edx
80107ef7:	83 ec 08             	sub    $0x8,%esp
80107efa:	50                   	push   %eax
80107efb:	52                   	push   %edx
80107efc:	e8 34 1f 00 00       	call   80109e35 <swtch>
80107f01:	83 c4 10             	add    $0x10,%esp
        switchkvm();
80107f04:	e8 a7 95 ff ff       	call   801014b0 <switchkvm>
80107f09:	eb 7a                	jmp    80107f85 <sche+0x1ad>
    }else{
        if(current != idleproc)
80107f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80107f11:	74 72                	je     80107f85 <sche+0x1ad>
        {
            new = idleproc;
80107f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f16:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if(current->state == RUNNABLE)
80107f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f1c:	8b 40 10             	mov    0x10(%eax),%eax
80107f1f:	83 f8 03             	cmp    $0x3,%eax
80107f22:	75 10                	jne    80107f34 <sche+0x15c>
            {
                put_proc(current);
80107f24:	83 ec 0c             	sub    $0xc,%esp
80107f27:	ff 75 f0             	pushl  -0x10(%ebp)
80107f2a:	e8 4d fc ff ff       	call   80107b7c <put_proc>
80107f2f:	83 c4 10             	add    $0x10,%esp
80107f32:	eb 0e                	jmp    80107f42 <sche+0x16a>
            }
            else{
                put_proc_sleep(current);
80107f34:	83 ec 0c             	sub    $0xc,%esp
80107f37:	ff 75 f0             	pushl  -0x10(%ebp)
80107f3a:	e8 e3 fc ff ff       	call   80107c22 <put_proc_sleep>
80107f3f:	83 c4 10             	add    $0x10,%esp
            }
            new->state = RUNNING;
80107f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f45:	c7 40 10 04 00 00 00 	movl   $0x4,0x10(%eax)
            switchkvm();
80107f4c:	e8 5f 95 ff ff       	call   801014b0 <switchkvm>
            CUR_PROC = new;
80107f51:	e8 15 e6 ff ff       	call   8010656b <get_cpu>
80107f56:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107f5c:	8d 90 70 79 12 80    	lea    -0x7fed8690(%eax),%edx
80107f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f65:	89 02                	mov    %eax,(%edx)
            swtch(&current->context, idleproc->context);
80107f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6a:	8b 40 20             	mov    0x20(%eax),%eax
80107f6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f70:	83 c2 20             	add    $0x20,%edx
80107f73:	83 ec 08             	sub    $0x8,%esp
80107f76:	50                   	push   %eax
80107f77:	52                   	push   %edx
80107f78:	e8 b8 1e 00 00       	call   80109e35 <swtch>
80107f7d:	83 c4 10             	add    $0x10,%esp
            switchkvm();
80107f80:	e8 2b 95 ff ff       	call   801014b0 <switchkvm>
        }else{
            ;;;;;;;;;;
        }
    }
    assert(PCPU->ncli == 1);
80107f85:	e8 e1 e5 ff ff       	call   8010656b <get_cpu>
80107f8a:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107f90:	05 68 79 12 80       	add    $0x80127968,%eax
80107f95:	8b 00                	mov    (%eax),%eax
80107f97:	83 f8 01             	cmp    $0x1,%eax
80107f9a:	74 1c                	je     80107fb8 <sche+0x1e0>
80107f9c:	68 07 bc 10 80       	push   $0x8010bc07
80107fa1:	68 db bb 10 80       	push   $0x8010bbdb
80107fa6:	68 a1 00 00 00       	push   $0xa1
80107fab:	68 f1 bb 10 80       	push   $0x8010bbf1
80107fb0:	e8 9f 83 ff ff       	call   80100354 <__panic>
80107fb5:	83 c4 10             	add    $0x10,%esp
    RELEASE;
80107fb8:	83 ec 0c             	sub    $0xc,%esp
80107fbb:	68 a0 7b 12 80       	push   $0x80127ba0
80107fc0:	e8 55 f8 ff ff       	call   8010781a <release>
80107fc5:	83 c4 10             	add    $0x10,%esp
}
80107fc8:	90                   	nop
80107fc9:	c9                   	leave  
80107fca:	c3                   	ret    

80107fcb <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
void
forkret(void) {
80107fcb:	55                   	push   %ebp
80107fcc:	89 e5                	mov    %esp,%ebp
80107fce:	83 ec 08             	sub    $0x8,%esp
    //traprets(current->tf);
    RELEASE;
80107fd1:	83 ec 0c             	sub    $0xc,%esp
80107fd4:	68 a0 7b 12 80       	push   $0x80127ba0
80107fd9:	e8 3c f8 ff ff       	call   8010781a <release>
80107fde:	83 c4 10             	add    $0x10,%esp
}
80107fe1:	90                   	nop
80107fe2:	c9                   	leave  
80107fe3:	c3                   	ret    

80107fe4 <add_child>:

bool
add_child(struct proc* parent, struct proc* child)
{
80107fe4:	55                   	push   %ebp
80107fe5:	89 e5                	mov    %esp,%ebp
80107fe7:	83 ec 38             	sub    $0x38,%esp
    assert(parent && child);
80107fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107fee:	74 06                	je     80107ff6 <add_child+0x12>
80107ff0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80107ff4:	75 1c                	jne    80108012 <add_child+0x2e>
80107ff6:	68 40 bc 10 80       	push   $0x8010bc40
80107ffb:	68 db bb 10 80       	push   $0x8010bbdb
80108000:	68 b1 00 00 00       	push   $0xb1
80108005:	68 f1 bb 10 80       	push   $0x8010bbf1
8010800a:	e8 45 83 ff ff       	call   80100354 <__panic>
8010800f:	83 c4 10             	add    $0x10,%esp
    list_del_init(&child->plink); 
80108012:	8b 45 0c             	mov    0xc(%ebp),%eax
80108015:	83 c0 48             	add    $0x48,%eax
80108018:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010801b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80108021:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108024:	8b 40 04             	mov    0x4(%eax),%eax
80108027:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010802a:	8b 12                	mov    (%edx),%edx
8010802c:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010802f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80108032:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108035:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108038:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
8010803b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010803e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80108041:	89 10                	mov    %edx,(%eax)
80108043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108046:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
80108049:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010804c:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010804f:	89 50 04             	mov    %edx,0x4(%eax)
80108052:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108055:	8b 50 04             	mov    0x4(%eax),%edx
80108058:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010805b:	89 10                	mov    %edx,(%eax)
    child->parent = parent;
8010805d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108060:	8b 55 08             	mov    0x8(%ebp),%edx
80108063:	89 50 1c             	mov    %edx,0x1c(%eax)
    list_add_before(&parent->child, &child->plink);
80108066:	8b 45 0c             	mov    0xc(%ebp),%eax
80108069:	83 c0 48             	add    $0x48,%eax
8010806c:	8b 55 08             	mov    0x8(%ebp),%edx
8010806f:	83 c2 50             	add    $0x50,%edx
80108072:	89 55 f0             	mov    %edx,-0x10(%ebp)
80108075:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) 
{
    __list_add(elm, listelm->prev, listelm);    
80108078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010807b:	8b 00                	mov    (%eax),%eax
8010807d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108080:	89 55 e8             	mov    %edx,-0x18(%ebp)
80108083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108086:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108089:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
8010808c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010808f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108092:	89 10                	mov    %edx,(%eax)
80108094:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108097:	8b 10                	mov    (%eax),%edx
80108099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010809c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
8010809f:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
801080a5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
801080a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801080ae:	89 10                	mov    %edx,(%eax)
    return true;
801080b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
801080b5:	c9                   	leave  
801080b6:	c3                   	ret    

801080b7 <change_childs>:

bool
change_childs(struct proc* old, struct proc* new)
{
801080b7:	55                   	push   %ebp
801080b8:	89 e5                	mov    %esp,%ebp
801080ba:	83 ec 28             	sub    $0x28,%esp
    assert(old && new);
801080bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801080c1:	74 06                	je     801080c9 <change_childs+0x12>
801080c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801080c7:	75 1c                	jne    801080e5 <change_childs+0x2e>
801080c9:	68 50 bc 10 80       	push   $0x8010bc50
801080ce:	68 db bb 10 80       	push   $0x8010bbdb
801080d3:	68 bb 00 00 00       	push   $0xbb
801080d8:	68 f1 bb 10 80       	push   $0x8010bbf1
801080dd:	e8 72 82 ff ff       	call   80100354 <__panic>
801080e2:	83 c4 10             	add    $0x10,%esp
    ACQUIRE;
801080e5:	83 ec 0c             	sub    $0xc,%esp
801080e8:	68 a0 7b 12 80       	push   $0x80127ba0
801080ed:	e8 c9 f6 ff ff       	call   801077bb <acquire>
801080f2:	83 c4 10             	add    $0x10,%esp

    FOR_EACH_LIST(&old->child, le)
801080f5:	8b 45 08             	mov    0x8(%ebp),%eax
801080f8:	83 c0 50             	add    $0x50,%eax
801080fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108101:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm)
{
    return listelm->next;
80108104:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108107:	8b 40 04             	mov    0x4(%eax),%eax
8010810a:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010810d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108110:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108113:	eb 2f                	jmp    80108144 <change_childs+0x8d>
80108115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108118:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010811b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108121:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108124:	8b 40 04             	mov    0x4(%eax),%eax
80108127:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        struct proc* child = list2proc(le);        
8010812a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010812d:	83 e8 40             	sub    $0x40,%eax
80108130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        add_child(new, child);
80108133:	83 ec 08             	sub    $0x8,%esp
80108136:	ff 75 e4             	pushl  -0x1c(%ebp)
80108139:	ff 75 0c             	pushl  0xc(%ebp)
8010813c:	e8 a3 fe ff ff       	call   80107fe4 <add_child>
80108141:	83 c4 10             	add    $0x10,%esp
change_childs(struct proc* old, struct proc* new)
{
    assert(old && new);
    ACQUIRE;

    FOR_EACH_LIST(&old->child, le)
80108144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108147:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010814a:	75 c9                	jne    80108115 <change_childs+0x5e>
        struct proc* child = list2proc(le);        
        add_child(new, child);
    }
    FOR_EACH_END

    RELEASE;
8010814c:	83 ec 0c             	sub    $0xc,%esp
8010814f:	68 a0 7b 12 80       	push   $0x80127ba0
80108154:	e8 c1 f6 ff ff       	call   8010781a <release>
80108159:	83 c4 10             	add    $0x10,%esp
    return true;
8010815c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80108161:	c9                   	leave  
80108162:	c3                   	ret    

80108163 <fetch_child>:
struct proc*
fetch_child(struct proc* p)
{
80108163:	55                   	push   %ebp
80108164:	89 e5                	mov    %esp,%ebp
80108166:	83 ec 20             	sub    $0x20,%esp
    list_entry_t *head = &p->child;
80108169:	8b 45 08             	mov    0x8(%ebp),%eax
8010816c:	83 c0 50             	add    $0x50,%eax
8010816f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(head->next != NULL)
80108172:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108175:	8b 40 04             	mov    0x4(%eax),%eax
80108178:	85 c0                	test   %eax,%eax
8010817a:	74 5c                	je     801081d8 <fetch_child+0x75>
    {
        struct proc *ret = list2proc(head->next);
8010817c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010817f:	8b 40 04             	mov    0x4(%eax),%eax
80108182:	83 e8 40             	sub    $0x40,%eax
80108185:	89 45 f8             	mov    %eax,-0x8(%ebp)
        list_del_init(head->next);
80108188:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010818b:	8b 40 04             	mov    0x4(%eax),%eax
8010818e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108194:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80108197:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010819a:	8b 40 04             	mov    0x4(%eax),%eax
8010819d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801081a0:	8b 12                	mov    (%edx),%edx
801081a2:	89 55 ec             	mov    %edx,-0x14(%ebp)
801081a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
801081a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
801081ae:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
801081b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801081b7:	89 10                	mov    %edx,(%eax)
801081b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
801081bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081c5:	89 50 04             	mov    %edx,0x4(%eax)
801081c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081cb:	8b 50 04             	mov    0x4(%eax),%edx
801081ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081d1:	89 10                	mov    %edx,(%eax)
        return ret;
801081d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801081d6:	eb 05                	jmp    801081dd <fetch_child+0x7a>
    }
    return NULL;
801081d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081dd:	c9                   	leave  
801081de:	c3                   	ret    

801081df <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// should add ptable.lock before and after the sleep
void
sleep(void *chan, struct spinlock *lk)
{
801081df:	55                   	push   %ebp
801081e0:	89 e5                	mov    %esp,%ebp
801081e2:	83 ec 18             	sub    $0x18,%esp
    struct proc *proc = CUR_PROC;
801081e5:	e8 81 e3 ff ff       	call   8010656b <get_cpu>
801081ea:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801081f0:	05 70 79 12 80       	add    $0x80127970,%eax
801081f5:	8b 00                	mov    (%eax),%eax
801081f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(proc == 0)
801081fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801081fe:	75 1a                	jne    8010821a <sleep+0x3b>
        panic("sleep in no proc");
80108200:	83 ec 04             	sub    $0x4,%esp
80108203:	68 5b bc 10 80       	push   $0x8010bc5b
80108208:	68 dd 00 00 00       	push   $0xdd
8010820d:	68 f1 bb 10 80       	push   $0x8010bbf1
80108212:	e8 3d 81 ff ff       	call   80100354 <__panic>
80108217:	83 c4 10             	add    $0x10,%esp

    if(lk == 0)
8010821a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010821e:	75 1a                	jne    8010823a <sleep+0x5b>
        panic("sleep without lk");
80108220:	83 ec 04             	sub    $0x4,%esp
80108223:	68 6c bc 10 80       	push   $0x8010bc6c
80108228:	68 e0 00 00 00       	push   $0xe0
8010822d:	68 f1 bb 10 80       	push   $0x8010bbf1
80108232:	e8 1d 81 ff ff       	call   80100354 <__panic>
80108237:	83 c4 10             	add    $0x10,%esp
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != LOCK){  //DOC: sleeplock0
8010823a:	81 7d 0c a0 7b 12 80 	cmpl   $0x80127ba0,0xc(%ebp)
80108241:	74 1e                	je     80108261 <sleep+0x82>
        ACQUIRE;
80108243:	83 ec 0c             	sub    $0xc,%esp
80108246:	68 a0 7b 12 80       	push   $0x80127ba0
8010824b:	e8 6b f5 ff ff       	call   801077bb <acquire>
80108250:	83 c4 10             	add    $0x10,%esp
        release(lk);
80108253:	83 ec 0c             	sub    $0xc,%esp
80108256:	ff 75 0c             	pushl  0xc(%ebp)
80108259:	e8 bc f5 ff ff       	call   8010781a <release>
8010825e:	83 c4 10             	add    $0x10,%esp
    }

    // Go to sleep.
    proc->chan = chan;
80108261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108264:	8b 55 08             	mov    0x8(%ebp),%edx
80108267:	89 50 3c             	mov    %edx,0x3c(%eax)
    proc->state = SLEEPING;
8010826a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826d:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)

    sche();
80108274:	e8 5f fb ff ff       	call   80107dd8 <sche>

    // Tidy up.
    proc->chan = 0;
80108279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827c:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)

    // Reacquire original lock.
    if(lk != LOCK){  //DOC: sleeplock2
80108283:	81 7d 0c a0 7b 12 80 	cmpl   $0x80127ba0,0xc(%ebp)
8010828a:	74 1e                	je     801082aa <sleep+0xcb>
        RELEASE;
8010828c:	83 ec 0c             	sub    $0xc,%esp
8010828f:	68 a0 7b 12 80       	push   $0x80127ba0
80108294:	e8 81 f5 ff ff       	call   8010781a <release>
80108299:	83 c4 10             	add    $0x10,%esp
        acquire(lk);
8010829c:	83 ec 0c             	sub    $0xc,%esp
8010829f:	ff 75 0c             	pushl  0xc(%ebp)
801082a2:	e8 14 f5 ff ff       	call   801077bb <acquire>
801082a7:	83 c4 10             	add    $0x10,%esp
    }
}
801082aa:	90                   	nop
801082ab:	c9                   	leave  
801082ac:	c3                   	ret    

801082ad <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801082ad:	55                   	push   %ebp
801082ae:	89 e5                	mov    %esp,%ebp
801082b0:	83 ec 30             	sub    $0x30,%esp
    FOR_EACH_LIST(&proc_manager.sleep, le)
801082b3:	c7 45 f8 b8 7b 12 80 	movl   $0x80127bb8,-0x8(%ebp)
801082ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
801082bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm)
{
    return listelm->next;
801082c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082c3:	8b 40 04             	mov    0x4(%eax),%eax
801082c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
801082cf:	e9 86 00 00 00       	jmp    8010835a <wakeup1+0xad>
801082d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801082e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e3:	8b 40 04             	mov    0x4(%eax),%eax
801082e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    {
        struct proc *ret = list2proc(le);
801082e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082ec:	83 e8 40             	sub    $0x40,%eax
801082ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(ret->chan == chan)
801082f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082f5:	8b 40 3c             	mov    0x3c(%eax),%eax
801082f8:	3b 45 08             	cmp    0x8(%ebp),%eax
801082fb:	75 5d                	jne    8010835a <wakeup1+0xad>
        {
            ret->state = RUNNABLE;
801082fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108300:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80108307:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010830a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010830d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108310:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
80108313:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108316:	8b 40 04             	mov    0x4(%eax),%eax
80108319:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010831c:	8b 12                	mov    (%edx),%edx
8010831e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80108321:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
80108324:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108327:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010832a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
8010832d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108330:	8b 55 dc             	mov    -0x24(%ebp),%edx
80108333:	89 10                	mov    %edx,(%eax)
80108335:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108338:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
8010833b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010833e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108341:	89 50 04             	mov    %edx,0x4(%eax)
80108344:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108347:	8b 50 04             	mov    0x4(%eax),%edx
8010834a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010834d:	89 10                	mov    %edx,(%eax)
            list_del_init(le);
            put_proc(ret);
8010834f:	ff 75 e8             	pushl  -0x18(%ebp)
80108352:	e8 25 f8 ff ff       	call   80107b7c <put_proc>
80108357:	83 c4 04             	add    $0x4,%esp
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
    FOR_EACH_LIST(&proc_manager.sleep, le)
8010835a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010835d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80108360:	0f 85 6e ff ff ff    	jne    801082d4 <wakeup1+0x27>
            list_del_init(le);
            put_proc(ret);
        }
    }
    FOR_EACH_END
}
80108366:	90                   	nop
80108367:	c9                   	leave  
80108368:	c3                   	ret    

80108369 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80108369:	55                   	push   %ebp
8010836a:	89 e5                	mov    %esp,%ebp
8010836c:	83 ec 08             	sub    $0x8,%esp
  ACQUIRE;
8010836f:	83 ec 0c             	sub    $0xc,%esp
80108372:	68 a0 7b 12 80       	push   $0x80127ba0
80108377:	e8 3f f4 ff ff       	call   801077bb <acquire>
8010837c:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010837f:	83 ec 0c             	sub    $0xc,%esp
80108382:	ff 75 08             	pushl  0x8(%ebp)
80108385:	e8 23 ff ff ff       	call   801082ad <wakeup1>
8010838a:	83 c4 10             	add    $0x10,%esp
  RELEASE;
8010838d:	83 ec 0c             	sub    $0xc,%esp
80108390:	68 a0 7b 12 80       	push   $0x80127ba0
80108395:	e8 80 f4 ff ff       	call   8010781a <release>
8010839a:	83 c4 10             	add    $0x10,%esp
}
8010839d:	90                   	nop
8010839e:	c9                   	leave  
8010839f:	c3                   	ret    

801083a0 <do_wait>:


int
do_wait()
{
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	83 ec 48             	sub    $0x48,%esp
    while(1)
    {
        struct proc *proc;
        struct proc *cproc;
        ACQUIRE;
801083a6:	83 ec 0c             	sub    $0xc,%esp
801083a9:	68 a0 7b 12 80       	push   $0x80127ba0
801083ae:	e8 08 f4 ff ff       	call   801077bb <acquire>
801083b3:	83 c4 10             	add    $0x10,%esp
        proc = CUR_PROC;
801083b6:	e8 b0 e1 ff ff       	call   8010656b <get_cpu>
801083bb:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801083c1:	05 70 79 12 80       	add    $0x80127970,%eax
801083c6:	8b 00                	mov    (%eax),%eax
801083c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        cprintf("pid = %d\n",proc->pid);
801083cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083ce:	8b 40 14             	mov    0x14(%eax),%eax
801083d1:	83 ec 08             	sub    $0x8,%esp
801083d4:	50                   	push   %eax
801083d5:	68 7d bc 10 80       	push   $0x8010bc7d
801083da:	e8 f8 e8 ff ff       	call   80106cd7 <cprintf>
801083df:	83 c4 10             	add    $0x10,%esp
        if(!has_child(proc))
801083e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e5:	83 c0 50             	add    $0x50,%eax
801083e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
801083eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
801083ee:	8b 40 04             	mov    0x4(%eax),%eax
801083f1:	39 45 d0             	cmp    %eax,-0x30(%ebp)
801083f4:	0f 94 c0             	sete   %al
801083f7:	0f b6 c0             	movzbl %al,%eax
801083fa:	85 c0                	test   %eax,%eax
801083fc:	74 2a                	je     80108428 <do_wait+0x88>
        {
            cprintf("NO CHILD\n");
801083fe:	83 ec 0c             	sub    $0xc,%esp
80108401:	68 87 bc 10 80       	push   $0x8010bc87
80108406:	e8 cc e8 ff ff       	call   80106cd7 <cprintf>
8010840b:	83 c4 10             	add    $0x10,%esp
            RELEASE;
8010840e:	83 ec 0c             	sub    $0xc,%esp
80108411:	68 a0 7b 12 80       	push   $0x80127ba0
80108416:	e8 ff f3 ff ff       	call   8010781a <release>
8010841b:	83 c4 10             	add    $0x10,%esp
            return -1;
8010841e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108423:	e9 06 01 00 00       	jmp    8010852e <do_wait+0x18e>
        }
        FOR_EACH_LIST(&proc->child, le)
80108428:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010842b:	83 c0 50             	add    $0x50,%eax
8010842e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108431:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108434:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm)
{
    return listelm->next;
80108437:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010843a:	8b 40 04             	mov    0x4(%eax),%eax
8010843d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108440:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108443:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108446:	e9 af 00 00 00       	jmp    801084fa <do_wait+0x15a>
8010844b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010845a:	8b 40 04             	mov    0x4(%eax),%eax
8010845d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        {
            cproc = clist2proc(le); 
80108460:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108463:	83 e8 48             	sub    $0x48,%eax
80108466:	89 45 d8             	mov    %eax,-0x28(%ebp)
            if(cproc->state == ZOMBIE)
80108469:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010846c:	8b 40 10             	mov    0x10(%eax),%eax
8010846f:	83 f8 05             	cmp    $0x5,%eax
80108472:	0f 85 82 00 00 00    	jne    801084fa <do_wait+0x15a>
            {
                int32_t pid = cproc->pid;            
80108478:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010847b:	8b 40 14             	mov    0x14(%eax),%eax
8010847e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                put_kstack(cproc);
80108481:	83 ec 0c             	sub    $0xc,%esp
80108484:	ff 75 d8             	pushl  -0x28(%ebp)
80108487:	e8 64 9b ff ff       	call   80101ff0 <put_kstack>
8010848c:	83 c4 10             	add    $0x10,%esp
                kfree(cproc);
8010848f:	83 ec 0c             	sub    $0xc,%esp
80108492:	ff 75 d8             	pushl  -0x28(%ebp)
80108495:	e8 55 a8 ff ff       	call   80102cef <kfree>
8010849a:	83 c4 10             	add    $0x10,%esp
8010849d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
801084a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801084a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm)
{
   __list_del(listelm->prev, listelm->next); 
801084a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801084ac:	8b 40 04             	mov    0x4(%eax),%eax
801084af:	8b 55 cc             	mov    -0x34(%ebp),%edx
801084b2:	8b 12                	mov    (%edx),%edx
801084b4:	89 55 c8             	mov    %edx,-0x38(%ebp)
801084b7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
801084ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
801084bd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801084c0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
801084c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801084c6:	8b 55 c8             	mov    -0x38(%ebp),%edx
801084c9:	89 10                	mov    %edx,(%eax)
801084cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801084ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
801084d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801084d4:	8b 55 c0             	mov    -0x40(%ebp),%edx
801084d7:	89 50 04             	mov    %edx,0x4(%eax)
801084da:	8b 45 c0             	mov    -0x40(%ebp),%eax
801084dd:	8b 50 04             	mov    0x4(%eax),%edx
801084e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801084e3:	89 10                	mov    %edx,(%eax)
                list_del_init(le);
                RELEASE;
801084e5:	83 ec 0c             	sub    $0xc,%esp
801084e8:	68 a0 7b 12 80       	push   $0x80127ba0
801084ed:	e8 28 f3 ff ff       	call   8010781a <release>
801084f2:	83 c4 10             	add    $0x10,%esp
                return pid;
801084f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801084f8:	eb 34                	jmp    8010852e <do_wait+0x18e>
        {
            cprintf("NO CHILD\n");
            RELEASE;
            return -1;
        }
        FOR_EACH_LIST(&proc->child, le)
801084fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084fd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80108500:	0f 85 45 ff ff ff    	jne    8010844b <do_wait+0xab>
                return pid;
            }
        }
        FOR_EACH_END

        sleep(proc, LOCK);
80108506:	83 ec 08             	sub    $0x8,%esp
80108509:	68 a0 7b 12 80       	push   $0x80127ba0
8010850e:	ff 75 f0             	pushl  -0x10(%ebp)
80108511:	e8 c9 fc ff ff       	call   801081df <sleep>
80108516:	83 c4 10             	add    $0x10,%esp
        RELEASE;
80108519:	83 ec 0c             	sub    $0xc,%esp
8010851c:	68 a0 7b 12 80       	push   $0x80127ba0
80108521:	e8 f4 f2 ff ff       	call   8010781a <release>
80108526:	83 c4 10             	add    $0x10,%esp
    }
80108529:	e9 78 fe ff ff       	jmp    801083a6 <do_wait+0x6>

    panic("no no no no no you shouldn't be here~_~\n");
    return 1;
}
8010852e:	c9                   	leave  
8010852f:	c3                   	ret    

80108530 <lcr3>:
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
}

static inline void
lcr3(uint32_t val)
{
80108530:	55                   	push   %ebp
80108531:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108533:	8b 45 08             	mov    0x8(%ebp),%eax
80108536:	0f 22 d8             	mov    %eax,%cr3
}
80108539:	90                   	nop
8010853a:	5d                   	pop    %ebp
8010853b:	c3                   	ret    

8010853c <mm_count_inc>:

bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write);


static inline int
mm_count_inc(struct mm_struct *mm) {
8010853c:	55                   	push   %ebp
8010853d:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
8010853f:	8b 45 08             	mov    0x8(%ebp),%eax
80108542:	8b 40 14             	mov    0x14(%eax),%eax
80108545:	8d 50 01             	lea    0x1(%eax),%edx
80108548:	8b 45 08             	mov    0x8(%ebp),%eax
8010854b:	89 50 14             	mov    %edx,0x14(%eax)
    return mm->mm_count;
8010854e:	8b 45 08             	mov    0x8(%ebp),%eax
80108551:	8b 40 14             	mov    0x14(%eax),%eax
}
80108554:	5d                   	pop    %ebp
80108555:	c3                   	ret    

80108556 <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
80108556:	55                   	push   %ebp
80108557:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
80108559:	8b 45 08             	mov    0x8(%ebp),%eax
8010855c:	8b 40 14             	mov    0x14(%eax),%eax
8010855f:	8d 50 ff             	lea    -0x1(%eax),%edx
80108562:	8b 45 08             	mov    0x8(%ebp),%eax
80108565:	89 50 14             	mov    %edx,0x14(%eax)
    return mm->mm_count;
80108568:	8b 45 08             	mov    0x8(%ebp),%eax
8010856b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010856e:	5d                   	pop    %ebp
8010856f:	c3                   	ret    

80108570 <alloc_proc>:

static int
init_main(void *arg);
static struct proc*
alloc_proc(void)
{
80108570:	55                   	push   %ebp
80108571:	89 e5                	mov    %esp,%ebp
80108573:	83 ec 18             	sub    $0x18,%esp
    struct proc *proc = kmalloc(sizeof(struct proc));
80108576:	83 ec 0c             	sub    $0xc,%esp
80108579:	6a 58                	push   $0x58
8010857b:	e8 af a7 ff ff       	call   80102d2f <kmalloc>
80108580:	83 c4 10             	add    $0x10,%esp
80108583:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(proc)
80108586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010858a:	0f 84 cb 00 00 00    	je     8010865b <alloc_proc+0xeb>
    {
        memset(proc->name, 0, sizeof(proc->name));
80108590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108593:	83 ec 04             	sub    $0x4,%esp
80108596:	6a 10                	push   $0x10
80108598:	6a 00                	push   $0x0
8010859a:	50                   	push   %eax
8010859b:	e8 a8 1e 00 00       	call   8010a448 <memset>
801085a0:	83 c4 10             	add    $0x10,%esp
        proc->state = EMBRYO;
801085a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a6:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
        proc->pid = -1;
801085ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b0:	c7 40 14 ff ff ff ff 	movl   $0xffffffff,0x14(%eax)
        proc->exit_code = 0;
801085b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ba:	c6 40 18 00          	movb   $0x0,0x18(%eax)
        proc->parent = NULL;
801085be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        proc->context = NULL;
801085c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085cb:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
        proc->tf = NULL;
801085d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d5:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        proc->pgdir = NULL;
801085dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085df:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%eax)
        proc->kstack = NULL;
801085e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e9:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
        proc->mm = NULL;
801085f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f3:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
        proc->wait_state = WT_NO;
801085fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fd:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
        list_init(&proc->elm);
80108604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108607:	83 c0 40             	add    $0x40,%eax
8010860a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010860d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108610:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108613:	89 50 04             	mov    %edx,0x4(%eax)
80108616:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108619:	8b 50 04             	mov    0x4(%eax),%edx
8010861c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010861f:	89 10                	mov    %edx,(%eax)
        list_init(&proc->child);
80108621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108624:	83 c0 50             	add    $0x50,%eax
80108627:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010862a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010862d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108630:	89 50 04             	mov    %edx,0x4(%eax)
80108633:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108636:	8b 50 04             	mov    0x4(%eax),%edx
80108639:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010863c:	89 10                	mov    %edx,(%eax)
        list_init(&proc->plink);
8010863e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108641:	83 c0 48             	add    $0x48,%eax
80108644:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108647:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010864a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010864d:	89 50 04             	mov    %edx,0x4(%eax)
80108650:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108653:	8b 50 04             	mov    0x4(%eax),%edx
80108656:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108659:	89 10                	mov    %edx,(%eax)
    }
    return proc;
8010865b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010865e:	c9                   	leave  
8010865f:	c3                   	ret    

80108660 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc *proc, uintptr_t esp, struct trapframe *tf) {
80108660:	55                   	push   %ebp
80108661:	89 e5                	mov    %esp,%ebp
80108663:	57                   	push   %edi
80108664:	56                   	push   %esi
80108665:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZES) - 1;
80108666:	8b 45 08             	mov    0x8(%ebp),%eax
80108669:	8b 40 30             	mov    0x30(%eax),%eax
8010866c:	8d 90 b4 1f 00 00    	lea    0x1fb4(%eax),%edx
80108672:	8b 45 08             	mov    0x8(%ebp),%eax
80108675:	89 50 24             	mov    %edx,0x24(%eax)
    *(proc->tf) = *tf;
80108678:	8b 45 08             	mov    0x8(%ebp),%eax
8010867b:	8b 50 24             	mov    0x24(%eax),%edx
8010867e:	8b 45 10             	mov    0x10(%ebp),%eax
80108681:	89 c3                	mov    %eax,%ebx
80108683:	b8 13 00 00 00       	mov    $0x13,%eax
80108688:	89 d7                	mov    %edx,%edi
8010868a:	89 de                	mov    %ebx,%esi
8010868c:	89 c1                	mov    %eax,%ecx
8010868e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    proc->tf->eax = 0;
80108690:	8b 45 08             	mov    0x8(%ebp),%eax
80108693:	8b 40 24             	mov    0x24(%eax),%eax
80108696:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->esp = esp;//(int)(proc->kstack + PGSIZE);
8010869d:	8b 45 08             	mov    0x8(%ebp),%eax
801086a0:	8b 40 24             	mov    0x24(%eax),%eax
801086a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801086a6:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->eflags |= FL_IF;
801086a9:	8b 45 08             	mov    0x8(%ebp),%eax
801086ac:	8b 40 24             	mov    0x24(%eax),%eax
801086af:	8b 55 08             	mov    0x8(%ebp),%edx
801086b2:	8b 52 24             	mov    0x24(%edx),%edx
801086b5:	8b 52 40             	mov    0x40(%edx),%edx
801086b8:	80 ce 02             	or     $0x2,%dh
801086bb:	89 50 40             	mov    %edx,0x40(%eax)
    extern char __traprets[];
    *((int*)(proc->tf) - 1) = (int)__traprets;
801086be:	8b 45 08             	mov    0x8(%ebp),%eax
801086c1:	8b 40 24             	mov    0x24(%eax),%eax
801086c4:	83 e8 04             	sub    $0x4,%eax
801086c7:	ba 85 93 10 80       	mov    $0x80109385,%edx
801086cc:	89 10                	mov    %edx,(%eax)
    proc->context = (struct context*)((int*)(proc->tf) - 1) - 1;
801086ce:	8b 45 08             	mov    0x8(%ebp),%eax
801086d1:	8b 40 24             	mov    0x24(%eax),%eax
801086d4:	8d 50 e8             	lea    -0x18(%eax),%edx
801086d7:	8b 45 08             	mov    0x8(%ebp),%eax
801086da:	89 50 20             	mov    %edx,0x20(%eax)
    proc->context->eip = (uintptr_t)forkret;
801086dd:	8b 45 08             	mov    0x8(%ebp),%eax
801086e0:	8b 40 20             	mov    0x20(%eax),%eax
801086e3:	ba cb 7f 10 80       	mov    $0x80107fcb,%edx
801086e8:	89 50 10             	mov    %edx,0x10(%eax)
}
801086eb:	90                   	nop
801086ec:	5b                   	pop    %ebx
801086ed:	5e                   	pop    %esi
801086ee:	5f                   	pop    %edi
801086ef:	5d                   	pop    %ebp
801086f0:	c3                   	ret    

801086f1 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
801086f1:	55                   	push   %ebp
801086f2:	89 e5                	mov    %esp,%ebp
801086f4:	83 ec 18             	sub    $0x18,%esp
    int ret = -E_NO_FREE_PROC;
801086f7:	c7 45 f4 fe ff ff ff 	movl   $0xfffffffe,-0xc(%ebp)
    struct proc *proc;
    if (N_PROC >= MAX_PROC) {
801086fe:	a1 ac 7b 12 80       	mov    0x80127bac,%eax
80108703:	83 f8 27             	cmp    $0x27,%eax
80108706:	0f 87 bf 00 00 00    	ja     801087cb <do_fork+0xda>
        goto fork_out;
    }

    ret = -E_NO_MEM;
8010870c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    if ((proc = alloc_proc()) == NULL) {
80108713:	e8 58 fe ff ff       	call   80108570 <alloc_proc>
80108718:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010871b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010871f:	0f 84 a9 00 00 00    	je     801087ce <do_fork+0xdd>
        goto fork_out;
    }

    add_child(CUR_PROC, proc);
80108725:	e8 41 de ff ff       	call   8010656b <get_cpu>
8010872a:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80108730:	05 70 79 12 80       	add    $0x80127970,%eax
80108735:	8b 00                	mov    (%eax),%eax
80108737:	83 ec 08             	sub    $0x8,%esp
8010873a:	ff 75 f0             	pushl  -0x10(%ebp)
8010873d:	50                   	push   %eax
8010873e:	e8 a1 f8 ff ff       	call   80107fe4 <add_child>
80108743:	83 c4 10             	add    $0x10,%esp
    if ((proc->kstack = kmalloc(KSTACKSIZES)) == NULL) {
80108746:	83 ec 0c             	sub    $0xc,%esp
80108749:	68 00 20 00 00       	push   $0x2000
8010874e:	e8 dc a5 ff ff       	call   80102d2f <kmalloc>
80108753:	83 c4 10             	add    $0x10,%esp
80108756:	89 c2                	mov    %eax,%edx
80108758:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010875b:	89 50 30             	mov    %edx,0x30(%eax)
8010875e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108761:	8b 40 30             	mov    0x30(%eax),%eax
80108764:	85 c0                	test   %eax,%eax
80108766:	74 7d                	je     801087e5 <do_fork+0xf4>
        goto bad_fork_cleanup_proc;
    }

    if (mm_copy(clone_flags, proc) != 0) {
80108768:	83 ec 08             	sub    $0x8,%esp
8010876b:	ff 75 f0             	pushl  -0x10(%ebp)
8010876e:	ff 75 08             	pushl  0x8(%ebp)
80108771:	e8 ff 95 ff ff       	call   80101d75 <mm_copy>
80108776:	83 c4 10             	add    $0x10,%esp
80108779:	85 c0                	test   %eax,%eax
8010877b:	75 57                	jne    801087d4 <do_fork+0xe3>
        goto bad_fork_cleanup_kstack;
    }

    proc->pgdir = proc->parent->pgdir;
8010877d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108780:	8b 40 1c             	mov    0x1c(%eax),%eax
80108783:	8b 50 28             	mov    0x28(%eax),%edx
80108786:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108789:	89 50 28             	mov    %edx,0x28(%eax)
    copy_thread(proc, stack, tf);
8010878c:	83 ec 04             	sub    $0x4,%esp
8010878f:	ff 75 10             	pushl  0x10(%ebp)
80108792:	ff 75 0c             	pushl  0xc(%ebp)
80108795:	ff 75 f0             	pushl  -0x10(%ebp)
80108798:	e8 c3 fe ff ff       	call   80108660 <copy_thread>
8010879d:	83 c4 10             	add    $0x10,%esp
    proc->pid = get_pid();
801087a0:	e8 8b f5 ff ff       	call   80107d30 <get_pid>
801087a5:	89 c2                	mov    %eax,%edx
801087a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087aa:	89 50 14             	mov    %edx,0x14(%eax)
    inc_proc_n();
801087ad:	e8 ba f5 ff ff       	call   80107d6c <inc_proc_n>
    wakeup_proc(proc);
801087b2:	83 ec 0c             	sub    $0xc,%esp
801087b5:	ff 75 f0             	pushl  -0x10(%ebp)
801087b8:	e8 3f 02 00 00       	call   801089fc <wakeup_proc>
801087bd:	83 c4 10             	add    $0x10,%esp

    ret = proc->pid;
801087c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087c3:	8b 40 14             	mov    0x14(%eax),%eax
801087c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801087c9:	eb 04                	jmp    801087cf <do_fork+0xde>
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc *proc;
    if (N_PROC >= MAX_PROC) {
        goto fork_out;
801087cb:	90                   	nop
801087cc:	eb 01                	jmp    801087cf <do_fork+0xde>
    }

    ret = -E_NO_MEM;
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
801087ce:	90                   	nop
    inc_proc_n();
    wakeup_proc(proc);

    ret = proc->pid;
fork_out:
    return ret;
801087cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d2:	eb 22                	jmp    801087f6 <do_fork+0x105>
    if ((proc->kstack = kmalloc(KSTACKSIZES)) == NULL) {
        goto bad_fork_cleanup_proc;
    }

    if (mm_copy(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
801087d4:	90                   	nop
    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
801087d5:	83 ec 0c             	sub    $0xc,%esp
801087d8:	ff 75 f0             	pushl  -0x10(%ebp)
801087db:	e8 10 98 ff ff       	call   80101ff0 <put_kstack>
801087e0:	83 c4 10             	add    $0x10,%esp
801087e3:	eb 01                	jmp    801087e6 <do_fork+0xf5>
        goto fork_out;
    }

    add_child(CUR_PROC, proc);
    if ((proc->kstack = kmalloc(KSTACKSIZES)) == NULL) {
        goto bad_fork_cleanup_proc;
801087e5:	90                   	nop
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
801087e6:	83 ec 0c             	sub    $0xc,%esp
801087e9:	ff 75 f0             	pushl  -0x10(%ebp)
801087ec:	e8 fe a4 ff ff       	call   80102cef <kfree>
801087f1:	83 c4 10             	add    $0x10,%esp
    goto fork_out;
801087f4:	eb d9                	jmp    801087cf <do_fork+0xde>
}
801087f6:	c9                   	leave  
801087f7:	c3                   	ret    

801087f8 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
801087f8:	55                   	push   %ebp
801087f9:	89 e5                	mov    %esp,%ebp
801087fb:	83 ec 58             	sub    $0x58,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
801087fe:	83 ec 04             	sub    $0x4,%esp
80108801:	6a 4c                	push   $0x4c
80108803:	6a 00                	push   $0x0
80108805:	8d 45 ac             	lea    -0x54(%ebp),%eax
80108808:	50                   	push   %eax
80108809:	e8 3a 1c 00 00       	call   8010a448 <memset>
8010880e:	83 c4 10             	add    $0x10,%esp
    tf.cs = SEG_KCODE << 3;
80108811:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.ds = tf.es = tf.ss = SEG_KDATA << 3;
80108817:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
8010881d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
80108821:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
80108825:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
80108829:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.ebx = (uint32_t)fn;
8010882d:	8b 45 08             	mov    0x8(%ebp),%eax
80108830:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.edx = (uint32_t)arg;
80108833:	8b 45 0c             	mov    0xc(%ebp),%eax
80108836:	89 45 c0             	mov    %eax,-0x40(%ebp)
    extern char kernel_thread_entry[];
    tf.eip = (uint32_t)kernel_thread_entry;
80108839:	b8 2c 9e 10 80       	mov    $0x80109e2c,%eax
8010883e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags, 0, &tf);
80108841:	83 ec 04             	sub    $0x4,%esp
80108844:	8d 45 ac             	lea    -0x54(%ebp),%eax
80108847:	50                   	push   %eax
80108848:	6a 00                	push   $0x0
8010884a:	ff 75 10             	pushl  0x10(%ebp)
8010884d:	e8 9f fe ff ff       	call   801086f1 <do_fork>
80108852:	83 c4 10             	add    $0x10,%esp
}
80108855:	c9                   	leave  
80108856:	c3                   	ret    

80108857 <proc_init>:


// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread "init"
void
proc_init(void) {
80108857:	55                   	push   %ebp
80108858:	89 e5                	mov    %esp,%ebp
8010885a:	53                   	push   %ebx
8010885b:	83 ec 14             	sub    $0x14,%esp
    init_sche();
8010885e:	e8 65 f4 ff ff       	call   80107cc8 <init_sche>
    //init idle
    if ((IDLE_PROC = alloc_proc()) == NULL) {
80108863:	e8 08 fd ff ff       	call   80108570 <alloc_proc>
80108868:	a3 c4 7b 12 80       	mov    %eax,0x80127bc4
8010886d:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
80108872:	85 c0                	test   %eax,%eax
80108874:	75 1a                	jne    80108890 <proc_init+0x39>
        panic("cannot alloc idleproc.\n");
80108876:	83 ec 04             	sub    $0x4,%esp
80108879:	68 94 bc 10 80       	push   $0x8010bc94
8010887e:	68 82 00 00 00       	push   $0x82
80108883:	68 ac bc 10 80       	push   $0x8010bcac
80108888:	e8 c7 7a ff ff       	call   80100354 <__panic>
8010888d:	83 c4 10             	add    $0x10,%esp
    }
    IDLE_PROC->context = kmalloc(sizeof(struct context));
80108890:	8b 1d c4 7b 12 80    	mov    0x80127bc4,%ebx
80108896:	83 ec 0c             	sub    $0xc,%esp
80108899:	6a 14                	push   $0x14
8010889b:	e8 8f a4 ff ff       	call   80102d2f <kmalloc>
801088a0:	83 c4 10             	add    $0x10,%esp
801088a3:	89 43 20             	mov    %eax,0x20(%ebx)
    IDLE_PROC->pid = get_pid();
801088a6:	8b 1d c4 7b 12 80    	mov    0x80127bc4,%ebx
801088ac:	e8 7f f4 ff ff       	call   80107d30 <get_pid>
801088b1:	89 43 14             	mov    %eax,0x14(%ebx)
    strcpy(IDLE_PROC->name, "idle");
801088b4:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
801088b9:	83 ec 08             	sub    $0x8,%esp
801088bc:	68 bd bc 10 80       	push   $0x8010bcbd
801088c1:	50                   	push   %eax
801088c2:	e8 b3 18 00 00       	call   8010a17a <strcpy>
801088c7:	83 c4 10             	add    $0x10,%esp
    IDLE_PROC->state = RUNNABLE;
801088ca:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
801088cf:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
    IDLE_PROC->pgdir = kpgdir;
801088d6:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
801088db:	8b 15 68 70 12 80    	mov    0x80127068,%edx
801088e1:	89 50 28             	mov    %edx,0x28(%eax)
    extern char _boot_stack[];
    IDLE_PROC->kstack = (char*)_boot_stack;
801088e4:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
801088e9:	c7 40 30 d0 7b 12 80 	movl   $0x80127bd0,0x30(%eax)
    inc_proc_n();
801088f0:	e8 77 f4 ff ff       	call   80107d6c <inc_proc_n>

    CUR_PROC = IDLE_PROC;
801088f5:	e8 71 dc ff ff       	call   8010656b <get_cpu>
801088fa:	89 c2                	mov    %eax,%edx
801088fc:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
80108901:	69 d2 b4 00 00 00    	imul   $0xb4,%edx,%edx
80108907:	81 c2 70 79 12 80    	add    $0x80127970,%edx
8010890d:	89 02                	mov    %eax,(%edx)

    cprintf("start init\n");
8010890f:	83 ec 0c             	sub    $0xc,%esp
80108912:	68 c2 bc 10 80       	push   $0x8010bcc2
80108917:	e8 bb e3 ff ff       	call   80106cd7 <cprintf>
8010891c:	83 c4 10             	add    $0x10,%esp
    int pid = kernel_thread(init_main, "Hello world!!", 0);
8010891f:	83 ec 04             	sub    $0x4,%esp
80108922:	6a 00                	push   $0x0
80108924:	68 ce bc 10 80       	push   $0x8010bcce
80108929:	68 cc 8a 10 80       	push   $0x80108acc
8010892e:	e8 c5 fe ff ff       	call   801087f8 <kernel_thread>
80108933:	83 c4 10             	add    $0x10,%esp
80108936:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (pid <= 0) {
80108939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010893d:	7f 1a                	jg     80108959 <proc_init+0x102>
        panic("create init_main failed.\n");
8010893f:	83 ec 04             	sub    $0x4,%esp
80108942:	68 dc bc 10 80       	push   $0x8010bcdc
80108947:	68 92 00 00 00       	push   $0x92
8010894c:	68 ac bc 10 80       	push   $0x8010bcac
80108951:	e8 fe 79 ff ff       	call   80100354 <__panic>
80108956:	83 c4 10             	add    $0x10,%esp
    }
    
    INIT_PROC = find_proc(pid);
80108959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895c:	83 ec 0c             	sub    $0xc,%esp
8010895f:	50                   	push   %eax
80108960:	e8 6a f0 ff ff       	call   801079cf <find_proc>
80108965:	83 c4 10             	add    $0x10,%esp
80108968:	a3 c0 7b 12 80       	mov    %eax,0x80127bc0
    strcpy((INIT_PROC)->name, "init");
8010896d:	a1 c0 7b 12 80       	mov    0x80127bc0,%eax
80108972:	83 ec 08             	sub    $0x8,%esp
80108975:	68 f6 bc 10 80       	push   $0x8010bcf6
8010897a:	50                   	push   %eax
8010897b:	e8 fa 17 00 00       	call   8010a17a <strcpy>
80108980:	83 c4 10             	add    $0x10,%esp
    cprintf("proc_init ok!\n");
80108983:	83 ec 0c             	sub    $0xc,%esp
80108986:	68 fb bc 10 80       	push   $0x8010bcfb
8010898b:	e8 47 e3 ff ff       	call   80106cd7 <cprintf>
80108990:	83 c4 10             	add    $0x10,%esp
    assert(IDLE_PROC != NULL && (IDLE_PROC)->pid == 0);
80108993:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
80108998:	85 c0                	test   %eax,%eax
8010899a:	74 0c                	je     801089a8 <proc_init+0x151>
8010899c:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
801089a1:	8b 40 14             	mov    0x14(%eax),%eax
801089a4:	85 c0                	test   %eax,%eax
801089a6:	74 1c                	je     801089c4 <proc_init+0x16d>
801089a8:	68 0c bd 10 80       	push   $0x8010bd0c
801089ad:	68 37 bd 10 80       	push   $0x8010bd37
801089b2:	68 98 00 00 00       	push   $0x98
801089b7:	68 ac bc 10 80       	push   $0x8010bcac
801089bc:	e8 93 79 ff ff       	call   80100354 <__panic>
801089c1:	83 c4 10             	add    $0x10,%esp
    assert(INIT_PROC != NULL && (INIT_PROC)->pid == 1);
801089c4:	a1 c0 7b 12 80       	mov    0x80127bc0,%eax
801089c9:	85 c0                	test   %eax,%eax
801089cb:	74 0d                	je     801089da <proc_init+0x183>
801089cd:	a1 c0 7b 12 80       	mov    0x80127bc0,%eax
801089d2:	8b 40 14             	mov    0x14(%eax),%eax
801089d5:	83 f8 01             	cmp    $0x1,%eax
801089d8:	74 1c                	je     801089f6 <proc_init+0x19f>
801089da:	68 50 bd 10 80       	push   $0x8010bd50
801089df:	68 37 bd 10 80       	push   $0x8010bd37
801089e4:	68 99 00 00 00       	push   $0x99
801089e9:	68 ac bc 10 80       	push   $0x8010bcac
801089ee:	e8 61 79 ff ff       	call   80100354 <__panic>
801089f3:	83 c4 10             	add    $0x10,%esp
}
801089f6:	90                   	nop
801089f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801089fa:	c9                   	leave  
801089fb:	c3                   	ret    

801089fc <wakeup_proc>:


void
wakeup_proc(struct proc *proc) {
801089fc:	55                   	push   %ebp
801089fd:	89 e5                	mov    %esp,%ebp
801089ff:	83 ec 08             	sub    $0x8,%esp
    assert(proc->state != RUNNABLE && proc->state != ZOMBIE);
80108a02:	8b 45 08             	mov    0x8(%ebp),%eax
80108a05:	8b 40 10             	mov    0x10(%eax),%eax
80108a08:	83 f8 03             	cmp    $0x3,%eax
80108a0b:	74 0b                	je     80108a18 <wakeup_proc+0x1c>
80108a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80108a10:	8b 40 10             	mov    0x10(%eax),%eax
80108a13:	83 f8 05             	cmp    $0x5,%eax
80108a16:	75 1c                	jne    80108a34 <wakeup_proc+0x38>
80108a18:	68 7c bd 10 80       	push   $0x8010bd7c
80108a1d:	68 37 bd 10 80       	push   $0x8010bd37
80108a22:	68 9f 00 00 00       	push   $0x9f
80108a27:	68 ac bc 10 80       	push   $0x8010bcac
80108a2c:	e8 23 79 ff ff       	call   80100354 <__panic>
80108a31:	83 c4 10             	add    $0x10,%esp
    proc->state = RUNNABLE;
80108a34:	8b 45 08             	mov    0x8(%ebp),%eax
80108a37:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
    put_proc(proc); 
80108a3e:	83 ec 0c             	sub    $0xc,%esp
80108a41:	ff 75 08             	pushl  0x8(%ebp)
80108a44:	e8 33 f1 ff ff       	call   80107b7c <put_proc>
80108a49:	83 c4 10             	add    $0x10,%esp
}
80108a4c:	90                   	nop
80108a4d:	c9                   	leave  
80108a4e:	c3                   	ret    

80108a4f <user_main>:


static int
user_main(void *arg){
80108a4f:	55                   	push   %ebp
80108a50:	89 e5                	mov    %esp,%ebp
80108a52:	53                   	push   %ebx
80108a53:	83 ec 14             	sub    $0x14,%esp
    struct proc *current = CUR_PROC;
80108a56:	e8 10 db ff ff       	call   8010656b <get_cpu>
80108a5b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80108a61:	05 70 79 12 80       	add    $0x80127970,%eax
80108a66:	8b 00                	mov    (%eax),%eax
80108a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, "user");
80108a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a6e:	8b 40 14             	mov    0x14(%eax),%eax
80108a71:	83 ec 04             	sub    $0x4,%esp
80108a74:	68 ad bd 10 80       	push   $0x8010bdad
80108a79:	50                   	push   %eax
80108a7a:	68 b4 bd 10 80       	push   $0x8010bdb4
80108a7f:	e8 53 e2 ff ff       	call   80106cd7 <cprintf>
80108a84:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"%s\".\n", (const char *)arg);
80108a87:	83 ec 08             	sub    $0x8,%esp
80108a8a:	ff 75 08             	pushl  0x8(%ebp)
80108a8d:	68 da bd 10 80       	push   $0x8010bdda
80108a92:	e8 40 e2 ff ff       	call   80106cd7 <cprintf>
80108a97:	83 c4 10             	add    $0x10,%esp
    asm volatile (
80108a9a:	ba 71 00 00 00       	mov    $0x71,%edx
80108a9f:	b8 07 00 00 00       	mov    $0x7,%eax
80108aa4:	89 d3                	mov    %edx,%ebx
80108aa6:	cd 40                	int    $0x40
            "int %0;"
            : 
            : "i" (T_SYSCALL),"b" ('q'),"a" (SYS_exec)
            : "memory");

    panic("should not at here\n");
80108aa8:	83 ec 04             	sub    $0x4,%esp
80108aab:	68 e7 bd 10 80       	push   $0x8010bde7
80108ab0:	68 b0 00 00 00       	push   $0xb0
80108ab5:	68 ac bc 10 80       	push   $0x8010bcac
80108aba:	e8 95 78 ff ff       	call   80100354 <__panic>
80108abf:	83 c4 10             	add    $0x10,%esp
    return 1;
80108ac2:	b8 01 00 00 00       	mov    $0x1,%eax
}
80108ac7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108aca:	c9                   	leave  
80108acb:	c3                   	ret    

80108acc <init_main>:
// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
80108acc:	55                   	push   %ebp
80108acd:	89 e5                	mov    %esp,%ebp
80108acf:	53                   	push   %ebx
80108ad0:	83 ec 14             	sub    $0x14,%esp
    struct proc *current = CUR_PROC;
80108ad3:	e8 93 da ff ff       	call   8010656b <get_cpu>
80108ad8:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80108ade:	05 70 79 12 80       	add    $0x80127970,%eax
80108ae3:	8b 00                	mov    (%eax),%eax
80108ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, "init");
80108ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aeb:	8b 40 14             	mov    0x14(%eax),%eax
80108aee:	83 ec 04             	sub    $0x4,%esp
80108af1:	68 f6 bc 10 80       	push   $0x8010bcf6
80108af6:	50                   	push   %eax
80108af7:	68 b4 bd 10 80       	push   $0x8010bdb4
80108afc:	e8 d6 e1 ff ff       	call   80106cd7 <cprintf>
80108b01:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"%s\".\n", (const char *)arg);
80108b04:	83 ec 08             	sub    $0x8,%esp
80108b07:	ff 75 08             	pushl  0x8(%ebp)
80108b0a:	68 da bd 10 80       	push   $0x8010bdda
80108b0f:	e8 c3 e1 ff ff       	call   80106cd7 <cprintf>
80108b14:	83 c4 10             	add    $0x10,%esp
    asm volatile (
80108b17:	ba 71 00 00 00       	mov    $0x71,%edx
80108b1c:	b8 16 00 00 00       	mov    $0x16,%eax
80108b21:	89 d3                	mov    %edx,%ebx
80108b23:	cd 40                	int    $0x40
            "int %0;"
            : 
            : "i" (T_SYSCALL),"b" ('q'),"a" (SYS_put)
            : "memory");

    size_t before = nr_free_pages();
80108b25:	e8 00 7f ff ff       	call   80100a2a <nr_free_pages>
80108b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int pid = kernel_thread(user_main, "first USER program", 0);
80108b2d:	83 ec 04             	sub    $0x4,%esp
80108b30:	6a 00                	push   $0x0
80108b32:	68 fb bd 10 80       	push   $0x8010bdfb
80108b37:	68 4f 8a 10 80       	push   $0x80108a4f
80108b3c:	e8 b7 fc ff ff       	call   801087f8 <kernel_thread>
80108b41:	83 c4 10             	add    $0x10,%esp
80108b44:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf("CUR_PID : %d\n", current->pid);
80108b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b4a:	8b 40 14             	mov    0x14(%eax),%eax
80108b4d:	83 ec 08             	sub    $0x8,%esp
80108b50:	50                   	push   %eax
80108b51:	68 0e be 10 80       	push   $0x8010be0e
80108b56:	e8 7c e1 ff ff       	call   80106cd7 <cprintf>
80108b5b:	83 c4 10             	add    $0x10,%esp
    if (pid <= 0) {
80108b5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b62:	7f 1a                	jg     80108b7e <init_main+0xb2>
        panic("create first USER failed.\n");
80108b64:	83 ec 04             	sub    $0x4,%esp
80108b67:	68 1c be 10 80       	push   $0x8010be1c
80108b6c:	68 c3 00 00 00       	push   $0xc3
80108b71:	68 ac bc 10 80       	push   $0x8010bcac
80108b76:	e8 d9 77 ff ff       	call   80100354 <__panic>
80108b7b:	83 c4 10             	add    $0x10,%esp
    }
    sche();
80108b7e:	e8 55 f2 ff ff       	call   80107dd8 <sche>

    struct proc* chi = find_proc(2);
80108b83:	83 ec 0c             	sub    $0xc,%esp
80108b86:	6a 02                	push   $0x2
80108b88:	e8 42 ee ff ff       	call   801079cf <find_proc>
80108b8d:	83 c4 10             	add    $0x10,%esp
80108b90:	89 45 e8             	mov    %eax,-0x18(%ebp)
    cprintf("pid == %d , status : %d parent_pid : %d \n",chi->pid, chi->state, chi->parent->pid);
80108b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b96:	8b 40 1c             	mov    0x1c(%eax),%eax
80108b99:	8b 48 14             	mov    0x14(%eax),%ecx
80108b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b9f:	8b 50 10             	mov    0x10(%eax),%edx
80108ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ba5:	8b 40 14             	mov    0x14(%eax),%eax
80108ba8:	51                   	push   %ecx
80108ba9:	52                   	push   %edx
80108baa:	50                   	push   %eax
80108bab:	68 38 be 10 80       	push   $0x8010be38
80108bb0:	e8 22 e1 ff ff       	call   80106cd7 <cprintf>
80108bb5:	83 c4 10             	add    $0x10,%esp
    

    while(do_wait() != -1)
80108bb8:	eb 10                	jmp    80108bca <init_main+0xfe>
    {
       cprintf("get a child\n");
80108bba:	83 ec 0c             	sub    $0xc,%esp
80108bbd:	68 62 be 10 80       	push   $0x8010be62
80108bc2:	e8 10 e1 ff ff       	call   80106cd7 <cprintf>
80108bc7:	83 c4 10             	add    $0x10,%esp

    struct proc* chi = find_proc(2);
    cprintf("pid == %d , status : %d parent_pid : %d \n",chi->pid, chi->state, chi->parent->pid);
    

    while(do_wait() != -1)
80108bca:	e8 d1 f7 ff ff       	call   801083a0 <do_wait>
80108bcf:	83 f8 ff             	cmp    $0xffffffff,%eax
80108bd2:	75 e6                	jne    80108bba <init_main+0xee>
    {
       cprintf("get a child\n");
    }
    assert(before == nr_free_pages());
80108bd4:	e8 51 7e ff ff       	call   80100a2a <nr_free_pages>
80108bd9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108bdc:	74 1c                	je     80108bfa <init_main+0x12e>
80108bde:	68 6f be 10 80       	push   $0x8010be6f
80108be3:	68 37 bd 10 80       	push   $0x8010bd37
80108be8:	68 cf 00 00 00       	push   $0xcf
80108bed:	68 ac bc 10 80       	push   $0x8010bcac
80108bf2:	e8 5d 77 ff ff       	call   80100354 <__panic>
80108bf7:	83 c4 10             	add    $0x10,%esp

    panic("now no wait function\n");
80108bfa:	83 ec 04             	sub    $0x4,%esp
80108bfd:	68 89 be 10 80       	push   $0x8010be89
80108c02:	68 d1 00 00 00       	push   $0xd1
80108c07:	68 ac bc 10 80       	push   $0x8010bcac
80108c0c:	e8 43 77 ff ff       	call   80100354 <__panic>
80108c11:	83 c4 10             	add    $0x10,%esp

    while(100);
80108c14:	eb fe                	jmp    80108c14 <init_main+0x148>

80108c16 <do_execve>:
static int
load_icode(unsigned char *binary, size_t size);

bool
do_execve(const char *name, size_t len, unsigned char *binary, size_t size)
{
80108c16:	55                   	push   %ebp
80108c17:	89 e5                	mov    %esp,%ebp
80108c19:	83 ec 18             	sub    $0x18,%esp
    struct proc *proc = CUR_PROC; 
80108c1c:	e8 4a d9 ff ff       	call   8010656b <get_cpu>
80108c21:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80108c27:	05 70 79 12 80       	add    $0x80127970,%eax
80108c2c:	8b 00                	mov    (%eax),%eax
80108c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct mm_struct *mm = proc->mm;
80108c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c34:	8b 40 34             	mov    0x34(%eax),%eax
80108c37:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if(!(user_mem_check(mm, (uintptr_t)name, len, 0)))
80108c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80108c3d:	6a 00                	push   $0x0
80108c3f:	ff 75 0c             	pushl  0xc(%ebp)
80108c42:	50                   	push   %eax
80108c43:	ff 75 f0             	pushl  -0x10(%ebp)
80108c46:	e8 b7 97 ff ff       	call   80102402 <user_mem_check>
80108c4b:	83 c4 10             	add    $0x10,%esp
80108c4e:	85 c0                	test   %eax,%eax
80108c50:	75 0a                	jne    80108c5c <do_execve+0x46>
    {
        return false;
80108c52:	b8 00 00 00 00       	mov    $0x0,%eax
80108c57:	e9 bc 00 00 00       	jmp    80108d18 <do_execve+0x102>
    }

    if(len > PROC_NAME)
80108c5c:	83 7d 0c 10          	cmpl   $0x10,0xc(%ebp)
80108c60:	76 07                	jbe    80108c69 <do_execve+0x53>
    {
        len = PROC_NAME;
80108c62:	c7 45 0c 10 00 00 00 	movl   $0x10,0xc(%ebp)
    }
    strcpy(IDLE_PROC->name, name);
80108c69:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
80108c6e:	83 ec 08             	sub    $0x8,%esp
80108c71:	ff 75 08             	pushl  0x8(%ebp)
80108c74:	50                   	push   %eax
80108c75:	e8 00 15 00 00       	call   8010a17a <strcpy>
80108c7a:	83 c4 10             	add    $0x10,%esp


    if(mm != NULL)
80108c7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108c81:	74 5c                	je     80108cdf <do_execve+0xc9>
    {
        lcr3(V2P(kpgdir));
80108c83:	a1 68 70 12 80       	mov    0x80127068,%eax
80108c88:	05 00 00 00 80       	add    $0x80000000,%eax
80108c8d:	83 ec 0c             	sub    $0xc,%esp
80108c90:	50                   	push   %eax
80108c91:	e8 9a f8 ff ff       	call   80108530 <lcr3>
80108c96:	83 c4 10             	add    $0x10,%esp
        if (mm_count_dec(mm) == 0) {
80108c99:	83 ec 0c             	sub    $0xc,%esp
80108c9c:	ff 75 f0             	pushl  -0x10(%ebp)
80108c9f:	e8 b2 f8 ff ff       	call   80108556 <mm_count_dec>
80108ca4:	83 c4 10             	add    $0x10,%esp
80108ca7:	85 c0                	test   %eax,%eax
80108ca9:	75 2a                	jne    80108cd5 <do_execve+0xbf>
            exit_mmap(mm);
80108cab:	83 ec 0c             	sub    $0xc,%esp
80108cae:	ff 75 f0             	pushl  -0x10(%ebp)
80108cb1:	e8 48 92 ff ff       	call   80101efe <exit_mmap>
80108cb6:	83 c4 10             	add    $0x10,%esp
            put_pgdir(mm);
80108cb9:	83 ec 0c             	sub    $0xc,%esp
80108cbc:	ff 75 f0             	pushl  -0x10(%ebp)
80108cbf:	e8 05 93 ff ff       	call   80101fc9 <put_pgdir>
80108cc4:	83 c4 10             	add    $0x10,%esp
            mm_destroy(mm);
80108cc7:	83 ec 0c             	sub    $0xc,%esp
80108cca:	ff 75 f0             	pushl  -0x10(%ebp)
80108ccd:	e8 90 8f ff ff       	call   80101c62 <mm_destroy>
80108cd2:	83 c4 10             	add    $0x10,%esp
        }
        proc->mm = NULL;
80108cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd8:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
    }

    int ret;
    if((ret = load_icode(binary, size)) != 0){
80108cdf:	83 ec 08             	sub    $0x8,%esp
80108ce2:	ff 75 14             	pushl  0x14(%ebp)
80108ce5:	ff 75 10             	pushl  0x10(%ebp)
80108ce8:	e8 2d 00 00 00       	call   80108d1a <load_icode>
80108ced:	83 c4 10             	add    $0x10,%esp
80108cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108cf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108cf7:	74 1a                	je     80108d13 <do_execve+0xfd>
        panic("go to execve_exit");
80108cf9:	83 ec 04             	sub    $0x4,%esp
80108cfc:	68 9f be 10 80       	push   $0x8010be9f
80108d01:	68 f9 00 00 00       	push   $0xf9
80108d06:	68 ac bc 10 80       	push   $0x8010bcac
80108d0b:	e8 44 76 ff ff       	call   80100354 <__panic>
80108d10:	83 c4 10             	add    $0x10,%esp
    }
    return 0;
80108d13:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d18:	c9                   	leave  
80108d19:	c3                   	ret    

80108d1a <load_icode>:
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size)
{
80108d1a:	55                   	push   %ebp
80108d1b:	89 e5                	mov    %esp,%ebp
80108d1d:	83 ec 58             	sub    $0x58,%esp
    struct proc *current = CUR_PROC;
80108d20:	e8 46 d8 ff ff       	call   8010656b <get_cpu>
80108d25:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80108d2b:	05 70 79 12 80       	add    $0x80127970,%eax
80108d30:	8b 00                	mov    (%eax),%eax
80108d32:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(current->mm != NULL){
80108d35:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d38:	8b 40 34             	mov    0x34(%eax),%eax
80108d3b:	85 c0                	test   %eax,%eax
80108d3d:	74 1a                	je     80108d59 <load_icode+0x3f>
        panic("load_icode: current->mm must be empty.\n");
80108d3f:	83 ec 04             	sub    $0x4,%esp
80108d42:	68 b4 be 10 80       	push   $0x8010beb4
80108d47:	68 08 01 00 00       	push   $0x108
80108d4c:	68 ac bc 10 80       	push   $0x8010bcac
80108d51:	e8 fe 75 ff ff       	call   80100354 <__panic>
80108d56:	83 c4 10             	add    $0x10,%esp
    }

    int ret = -E_NO_MEM;
80108d59:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if((mm = mm_create()) == NULL)
80108d60:	e8 71 8e ff ff       	call   80101bd6 <mm_create>
80108d65:	89 45 cc             	mov    %eax,-0x34(%ebp)
80108d68:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108d6c:	0f 84 b7 04 00 00    	je     80109229 <load_icode+0x50f>
    {
        goto bad_mm;
    }

    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if(mm_setup_pgdir(mm) ==false)
80108d72:	83 ec 0c             	sub    $0xc,%esp
80108d75:	ff 75 cc             	pushl  -0x34(%ebp)
80108d78:	e8 87 8f ff ff       	call   80101d04 <mm_setup_pgdir>
80108d7d:	83 c4 10             	add    $0x10,%esp
80108d80:	85 c0                	test   %eax,%eax
80108d82:	0f 84 a4 04 00 00    	je     8010922c <load_icode+0x512>
        goto bad_pgdir_cleanup_mm;
    }

    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct page *page;
    struct elfhdr *elf = (struct elfhdr *)binary;
80108d88:	8b 45 08             	mov    0x8(%ebp),%eax
80108d8b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
80108d8e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108d91:	8b 50 1c             	mov    0x1c(%eax),%edx
80108d94:	8b 45 08             	mov    0x8(%ebp),%eax
80108d97:	01 d0                	add    %edx,%eax
80108d99:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.1) This program is valid? 
    if(elf->e_magic != ELF_MAGIC){
80108d9c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108d9f:	8b 00                	mov    (%eax),%eax
80108da1:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80108da6:	74 0c                	je     80108db4 <load_icode+0x9a>
        ret = -E_INVAL_ELF;
80108da8:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
80108daf:	e9 85 04 00 00       	jmp    80109239 <load_icode+0x51f>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
80108db4:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108db7:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
80108dbb:	0f b7 c0             	movzwl %ax,%eax
80108dbe:	c1 e0 05             	shl    $0x5,%eax
80108dc1:	89 c2                	mov    %eax,%edx
80108dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dc6:	01 d0                	add    %edx,%eax
80108dc8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    for(; ph < ph_end ;ph ++)
80108dcb:	e9 e5 02 00 00       	jmp    801090b5 <load_icode+0x39b>
    {
        //(3.2) find every program section headers
        if (ph->p_type != ELF_PROG_LOAD) {
80108dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dd3:	8b 00                	mov    (%eax),%eax
80108dd5:	83 f8 01             	cmp    $0x1,%eax
80108dd8:	0f 85 cc 02 00 00    	jne    801090aa <load_icode+0x390>
            continue ;
        }
        if (ph->p_filesz > ph->p_memsz) {
80108dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108de1:	8b 50 10             	mov    0x10(%eax),%edx
80108de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108de7:	8b 40 14             	mov    0x14(%eax),%eax
80108dea:	39 c2                	cmp    %eax,%edx
80108dec:	76 0c                	jbe    80108dfa <load_icode+0xe0>
            ret = -E_INVAL_ELF;
80108dee:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
            goto bad_cleanup_mmap;
80108df5:	e9 3f 04 00 00       	jmp    80109239 <load_icode+0x51f>
        }
        if (ph->p_filesz == 0) {
80108dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dfd:	8b 40 10             	mov    0x10(%eax),%eax
80108e00:	85 c0                	test   %eax,%eax
80108e02:	0f 84 a5 02 00 00    	je     801090ad <load_icode+0x393>
            continue ;
        }

        //(3.3) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
80108e08:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80108e0f:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) vm_flags |= VM_EXEC;
80108e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e19:	8b 40 18             	mov    0x18(%eax),%eax
80108e1c:	83 e0 01             	and    $0x1,%eax
80108e1f:	85 c0                	test   %eax,%eax
80108e21:	74 04                	je     80108e27 <load_icode+0x10d>
80108e23:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) vm_flags |= VM_WRITE;
80108e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e2a:	8b 40 18             	mov    0x18(%eax),%eax
80108e2d:	83 e0 02             	and    $0x2,%eax
80108e30:	85 c0                	test   %eax,%eax
80108e32:	74 04                	je     80108e38 <load_icode+0x11e>
80108e34:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PROG_FLAG_READ) vm_flags |= VM_READ;
80108e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e3b:	8b 40 18             	mov    0x18(%eax),%eax
80108e3e:	83 e0 04             	and    $0x4,%eax
80108e41:	85 c0                	test   %eax,%eax
80108e43:	74 04                	je     80108e49 <load_icode+0x12f>
80108e45:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
80108e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e4c:	83 e0 02             	and    $0x2,%eax
80108e4f:	85 c0                	test   %eax,%eax
80108e51:	74 04                	je     80108e57 <load_icode+0x13d>
80108e53:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
80108e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e5a:	8b 50 14             	mov    0x14(%eax),%edx
80108e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e60:	8b 40 08             	mov    0x8(%eax),%eax
80108e63:	83 ec 0c             	sub    $0xc,%esp
80108e66:	6a 00                	push   $0x0
80108e68:	ff 75 e8             	pushl  -0x18(%ebp)
80108e6b:	52                   	push   %edx
80108e6c:	50                   	push   %eax
80108e6d:	ff 75 cc             	pushl  -0x34(%ebp)
80108e70:	e8 87 8f ff ff       	call   80101dfc <mm_map>
80108e75:	83 c4 20             	add    $0x20,%esp
80108e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108e7f:	0f 85 aa 03 00 00    	jne    8010922f <load_icode+0x515>
            goto bad_cleanup_mmap;
        }

        unsigned char *from = binary + ph->p_offset;
80108e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e88:	8b 50 04             	mov    0x4(%eax),%edx
80108e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80108e8e:	01 d0                	add    %edx,%eax
80108e90:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
80108e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e96:	8b 40 08             	mov    0x8(%eax),%eax
80108e99:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108e9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108e9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80108ea2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108ea5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108eaa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
80108ead:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)


        //(3.4) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
80108eb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108eb7:	8b 50 08             	mov    0x8(%eax),%edx
80108eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ebd:	8b 40 10             	mov    0x10(%eax),%eax
80108ec0:	01 d0                	add    %edx,%eax
80108ec2:	89 45 bc             	mov    %eax,-0x44(%ebp)
        //(3.4.1) copy TEXT/DATA section of bianry program
        while (start < end) {
80108ec5:	e9 84 00 00 00       	jmp    80108f4e <load_icode+0x234>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
80108eca:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108ecd:	8b 40 0c             	mov    0xc(%eax),%eax
80108ed0:	83 ec 04             	sub    $0x4,%esp
80108ed3:	ff 75 e4             	pushl  -0x1c(%ebp)
80108ed6:	ff 75 d4             	pushl  -0x2c(%ebp)
80108ed9:	50                   	push   %eax
80108eda:	e8 01 82 ff ff       	call   801010e0 <pgdir_alloc_page>
80108edf:	83 c4 10             	add    $0x10,%esp
80108ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108ee5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108ee9:	0f 84 43 03 00 00    	je     80109232 <load_icode+0x518>
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
80108eef:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108ef2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
80108ef5:	89 45 b8             	mov    %eax,-0x48(%ebp)
80108ef8:	b8 00 10 00 00       	mov    $0x1000,%eax
80108efd:	2b 45 b8             	sub    -0x48(%ebp),%eax
80108f00:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108f03:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
80108f0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108f0d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80108f10:	73 09                	jae    80108f1b <load_icode+0x201>
                size -= la - end;
80108f12:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108f15:	2b 45 d4             	sub    -0x2c(%ebp),%eax
80108f18:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
80108f1b:	83 ec 0c             	sub    $0xc,%esp
80108f1e:	ff 75 f0             	pushl  -0x10(%ebp)
80108f21:	e8 27 7a ff ff       	call   8010094d <page2kva>
80108f26:	83 c4 10             	add    $0x10,%esp
80108f29:	89 c2                	mov    %eax,%edx
80108f2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108f2e:	01 d0                	add    %edx,%eax
80108f30:	83 ec 04             	sub    $0x4,%esp
80108f33:	ff 75 dc             	pushl  -0x24(%ebp)
80108f36:	ff 75 e0             	pushl  -0x20(%ebp)
80108f39:	50                   	push   %eax
80108f3a:	e8 bb 15 00 00       	call   8010a4fa <memcpy>
80108f3f:	83 c4 10             	add    $0x10,%esp
            start += size, from += size;
80108f42:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108f45:	01 45 d8             	add    %eax,-0x28(%ebp)
80108f48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108f4b:	01 45 e0             	add    %eax,-0x20(%ebp)


        //(3.4) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
        //(3.4.1) copy TEXT/DATA section of bianry program
        while (start < end) {
80108f4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108f51:	3b 45 bc             	cmp    -0x44(%ebp),%eax
80108f54:	0f 82 70 ff ff ff    	jb     80108eca <load_icode+0x1b0>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

        //(3.4.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
80108f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f5d:	8b 50 08             	mov    0x8(%eax),%edx
80108f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f63:	8b 40 14             	mov    0x14(%eax),%eax
80108f66:	01 d0                	add    %edx,%eax
80108f68:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (start < la) {
80108f6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108f6e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80108f71:	0f 83 25 01 00 00    	jae    8010909c <load_icode+0x382>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
80108f77:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108f7a:	3b 45 bc             	cmp    -0x44(%ebp),%eax
80108f7d:	0f 84 2d 01 00 00    	je     801090b0 <load_icode+0x396>
                continue ;
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
80108f83:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108f86:	2b 45 d4             	sub    -0x2c(%ebp),%eax
80108f89:	05 00 10 00 00       	add    $0x1000,%eax
80108f8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80108f91:	b8 00 10 00 00       	mov    $0x1000,%eax
80108f96:	2b 45 b8             	sub    -0x48(%ebp),%eax
80108f99:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
80108f9c:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108f9f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80108fa2:	73 09                	jae    80108fad <load_icode+0x293>
                size -= la - end;
80108fa4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108fa7:	2b 45 d4             	sub    -0x2c(%ebp),%eax
80108faa:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
80108fad:	83 ec 0c             	sub    $0xc,%esp
80108fb0:	ff 75 f0             	pushl  -0x10(%ebp)
80108fb3:	e8 95 79 ff ff       	call   8010094d <page2kva>
80108fb8:	83 c4 10             	add    $0x10,%esp
80108fbb:	89 c2                	mov    %eax,%edx
80108fbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108fc0:	01 d0                	add    %edx,%eax
80108fc2:	83 ec 04             	sub    $0x4,%esp
80108fc5:	ff 75 dc             	pushl  -0x24(%ebp)
80108fc8:	6a 00                	push   $0x0
80108fca:	50                   	push   %eax
80108fcb:	e8 78 14 00 00       	call   8010a448 <memset>
80108fd0:	83 c4 10             	add    $0x10,%esp
            start += size;
80108fd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108fd6:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
80108fd9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108fdc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80108fdf:	73 0c                	jae    80108fed <load_icode+0x2d3>
80108fe1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108fe4:	3b 45 bc             	cmp    -0x44(%ebp),%eax
80108fe7:	0f 84 af 00 00 00    	je     8010909c <load_icode+0x382>
80108fed:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108ff0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80108ff3:	72 0c                	jb     80109001 <load_icode+0x2e7>
80108ff5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108ff8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80108ffb:	0f 84 9b 00 00 00    	je     8010909c <load_icode+0x382>
80109001:	68 dc be 10 80       	push   $0x8010bedc
80109006:	68 37 bd 10 80       	push   $0x8010bd37
8010900b:	68 60 01 00 00       	push   $0x160
80109010:	68 ac bc 10 80       	push   $0x8010bcac
80109015:	e8 3a 73 ff ff       	call   80100354 <__panic>
8010901a:	83 c4 10             	add    $0x10,%esp
        }

        while (start < end) {
8010901d:	eb 7d                	jmp    8010909c <load_icode+0x382>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
8010901f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80109022:	8b 40 0c             	mov    0xc(%eax),%eax
80109025:	83 ec 04             	sub    $0x4,%esp
80109028:	ff 75 e4             	pushl  -0x1c(%ebp)
8010902b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010902e:	50                   	push   %eax
8010902f:	e8 ac 80 ff ff       	call   801010e0 <pgdir_alloc_page>
80109034:	83 c4 10             	add    $0x10,%esp
80109037:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010903a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010903e:	0f 84 f1 01 00 00    	je     80109235 <load_icode+0x51b>
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
80109044:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109047:	2b 45 d4             	sub    -0x2c(%ebp),%eax
8010904a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010904d:	b8 00 10 00 00       	mov    $0x1000,%eax
80109052:	2b 45 b8             	sub    -0x48(%ebp),%eax
80109055:	89 45 dc             	mov    %eax,-0x24(%ebp)
80109058:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
8010905f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80109062:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80109065:	73 09                	jae    80109070 <load_icode+0x356>
                size -= la - end;
80109067:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010906a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
8010906d:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
80109070:	83 ec 0c             	sub    $0xc,%esp
80109073:	ff 75 f0             	pushl  -0x10(%ebp)
80109076:	e8 d2 78 ff ff       	call   8010094d <page2kva>
8010907b:	83 c4 10             	add    $0x10,%esp
8010907e:	89 c2                	mov    %eax,%edx
80109080:	8b 45 b8             	mov    -0x48(%ebp),%eax
80109083:	01 d0                	add    %edx,%eax
80109085:	83 ec 04             	sub    $0x4,%esp
80109088:	ff 75 dc             	pushl  -0x24(%ebp)
8010908b:	6a 00                	push   $0x0
8010908d:	50                   	push   %eax
8010908e:	e8 b5 13 00 00       	call   8010a448 <memset>
80109093:	83 c4 10             	add    $0x10,%esp
            start += size;
80109096:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109099:	01 45 d8             	add    %eax,-0x28(%ebp)
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }

        while (start < end) {
8010909c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010909f:	3b 45 bc             	cmp    -0x44(%ebp),%eax
801090a2:	0f 82 77 ff ff ff    	jb     8010901f <load_icode+0x305>
801090a8:	eb 07                	jmp    801090b1 <load_icode+0x397>
    struct proghdr *ph_end = ph + elf->e_phnum;
    for(; ph < ph_end ;ph ++)
    {
        //(3.2) find every program section headers
        if (ph->p_type != ELF_PROG_LOAD) {
            continue ;
801090aa:	90                   	nop
801090ab:	eb 04                	jmp    801090b1 <load_icode+0x397>
        if (ph->p_filesz > ph->p_memsz) {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        if (ph->p_filesz == 0) {
            continue ;
801090ad:	90                   	nop
801090ae:	eb 01                	jmp    801090b1 <load_icode+0x397>
        //(3.4.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
        if (start < la) {
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
                continue ;
801090b0:	90                   	nop
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for(; ph < ph_end ;ph ++)
801090b1:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
801090b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801090b8:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
801090bb:	0f 82 0f fd ff ff    	jb     80108dd0 <load_icode+0xb6>
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }

    vm_flags = VM_READ | VM_WRITE | VM_STACK;
801090c1:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USERTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
801090c8:	83 ec 0c             	sub    $0xc,%esp
801090cb:	6a 00                	push   $0x0
801090cd:	ff 75 e8             	pushl  -0x18(%ebp)
801090d0:	68 00 40 00 00       	push   $0x4000
801090d5:	68 00 c0 ff 03       	push   $0x3ffc000
801090da:	ff 75 cc             	pushl  -0x34(%ebp)
801090dd:	e8 1a 8d ff ff       	call   80101dfc <mm_map>
801090e2:	83 c4 20             	add    $0x20,%esp
801090e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801090e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801090ec:	0f 85 46 01 00 00    	jne    80109238 <load_icode+0x51e>
        goto bad_cleanup_mmap;
    }

    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE, (PTE_U | PTE_W | PTE_P));
801090f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801090f5:	8b 40 0c             	mov    0xc(%eax),%eax
801090f8:	83 ec 04             	sub    $0x4,%esp
801090fb:	6a 07                	push   $0x7
801090fd:	68 00 c0 ff 03       	push   $0x3ffc000
80109102:	50                   	push   %eax
80109103:	e8 d8 7f ff ff       	call   801010e0 <pgdir_alloc_page>
80109108:	83 c4 10             	add    $0x10,%esp
    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE + 4096, (PTE_U | PTE_W | PTE_P));
8010910b:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010910e:	8b 40 0c             	mov    0xc(%eax),%eax
80109111:	83 ec 04             	sub    $0x4,%esp
80109114:	6a 07                	push   $0x7
80109116:	68 00 d0 ff 03       	push   $0x3ffd000
8010911b:	50                   	push   %eax
8010911c:	e8 bf 7f ff ff       	call   801010e0 <pgdir_alloc_page>
80109121:	83 c4 10             	add    $0x10,%esp
    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE + 4096*2, (PTE_U | PTE_W | PTE_P));
80109124:	8b 45 cc             	mov    -0x34(%ebp),%eax
80109127:	8b 40 0c             	mov    0xc(%eax),%eax
8010912a:	83 ec 04             	sub    $0x4,%esp
8010912d:	6a 07                	push   $0x7
8010912f:	68 00 e0 ff 03       	push   $0x3ffe000
80109134:	50                   	push   %eax
80109135:	e8 a6 7f ff ff       	call   801010e0 <pgdir_alloc_page>
8010913a:	83 c4 10             	add    $0x10,%esp
    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE + 4096*3, (PTE_U | PTE_W | PTE_P));
8010913d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80109140:	8b 40 0c             	mov    0xc(%eax),%eax
80109143:	83 ec 04             	sub    $0x4,%esp
80109146:	6a 07                	push   $0x7
80109148:	68 00 f0 ff 03       	push   $0x3fff000
8010914d:	50                   	push   %eax
8010914e:	e8 8d 7f ff ff       	call   801010e0 <pgdir_alloc_page>
80109153:	83 c4 10             	add    $0x10,%esp


    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
80109156:	83 ec 0c             	sub    $0xc,%esp
80109159:	ff 75 cc             	pushl  -0x34(%ebp)
8010915c:	e8 db f3 ff ff       	call   8010853c <mm_count_inc>
80109161:	83 c4 10             	add    $0x10,%esp
    current->mm = mm;
80109164:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109167:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010916a:	89 50 34             	mov    %edx,0x34(%eax)
    current->cr3 = V2P(mm->pgdir);
8010916d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80109170:	8b 40 0c             	mov    0xc(%eax),%eax
80109173:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80109179:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010917c:	89 50 2c             	mov    %edx,0x2c(%eax)
    lcr3(V2P(mm->pgdir));
8010917f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80109182:	8b 40 0c             	mov    0xc(%eax),%eax
80109185:	05 00 00 00 80       	add    $0x80000000,%eax
8010918a:	83 ec 0c             	sub    $0xc,%esp
8010918d:	50                   	push   %eax
8010918e:	e8 9d f3 ff ff       	call   80108530 <lcr3>
80109193:	83 c4 10             	add    $0x10,%esp
    cprintf("mm->map_count : %d\n", mm->map_count);
80109196:	8b 45 cc             	mov    -0x34(%ebp),%eax
80109199:	8b 40 10             	mov    0x10(%eax),%eax
8010919c:	83 ec 08             	sub    $0x8,%esp
8010919f:	50                   	push   %eax
801091a0:	68 15 bf 10 80       	push   $0x8010bf15
801091a5:	e8 2d db ff ff       	call   80106cd7 <cprintf>
801091aa:	83 c4 10             	add    $0x10,%esp

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
801091ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
801091b0:	8b 40 24             	mov    0x24(%eax),%eax
801091b3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
801091b6:	83 ec 04             	sub    $0x4,%esp
801091b9:	6a 4c                	push   $0x4c
801091bb:	6a 00                	push   $0x0
801091bd:	ff 75 b4             	pushl  -0x4c(%ebp)
801091c0:	e8 83 12 00 00       	call   8010a448 <memset>
801091c5:	83 c4 10             	add    $0x10,%esp
    tf->cs = SEG_UCODE << 3 | DPL_USER;
801091c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801091cb:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    tf->ds = tf->es = tf->ss = SEG_UDATA << 3 | DPL_USER;
801091d1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801091d4:	66 c7 40 48 2b 00    	movw   $0x2b,0x48(%eax)
801091da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801091dd:	0f b7 50 48          	movzwl 0x48(%eax),%edx
801091e1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801091e4:	66 89 50 28          	mov    %dx,0x28(%eax)
801091e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801091eb:	0f b7 50 28          	movzwl 0x28(%eax),%edx
801091ef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801091f2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->esp = USERTOP - 4;
801091f6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801091f9:	c7 40 44 fc ff ff 03 	movl   $0x3fffffc,0x44(%eax)
    tf->eip = elf->e_entry;
80109200:	8b 45 c8             	mov    -0x38(%ebp),%eax
80109203:	8b 50 18             	mov    0x18(%eax),%edx
80109206:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80109209:	89 50 38             	mov    %edx,0x38(%eax)

    tf->eflags |= FL_IF;
8010920c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010920f:	8b 40 40             	mov    0x40(%eax),%eax
80109212:	80 cc 02             	or     $0x2,%ah
80109215:	89 c2                	mov    %eax,%edx
80109217:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010921a:	89 50 40             	mov    %edx,0x40(%eax)

    ret = 0;
8010921d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    return ret;
80109224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109227:	eb 2d                	jmp    80109256 <load_icode+0x53c>
    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if((mm = mm_create()) == NULL)
    {
        goto bad_mm;
80109229:	90                   	nop
8010922a:	eb 0d                	jmp    80109239 <load_icode+0x51f>
    }

    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if(mm_setup_pgdir(mm) ==false)
    {
        goto bad_pgdir_cleanup_mm;
8010922c:	90                   	nop
8010922d:	eb 0a                	jmp    80109239 <load_icode+0x51f>
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PROG_FLAG_READ) vm_flags |= VM_READ;
        if (vm_flags & VM_WRITE) perm |= PTE_W;
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
8010922f:	90                   	nop
80109230:	eb 07                	jmp    80109239 <load_icode+0x51f>
        //(3.4) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
        //(3.4.1) copy TEXT/DATA section of bianry program
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
80109232:	90                   	nop
80109233:	eb 04                	jmp    80109239 <load_icode+0x51f>
            assert((end < la && start == end) || (end >= la && start == la));
        }

        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
80109235:	90                   	nop
80109236:	eb 01                	jmp    80109239 <load_icode+0x51f>
        }
    }

    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USERTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
80109238:	90                   	nop
    return ret;
bad_mm:
bad_pgdir_cleanup_mm:
bad_elf_cleanup_pgdir:
bad_cleanup_mmap:
    panic("exec wrong\n");
80109239:	83 ec 04             	sub    $0x4,%esp
8010923c:	68 29 bf 10 80       	push   $0x8010bf29
80109241:	68 92 01 00 00       	push   $0x192
80109246:	68 ac bc 10 80       	push   $0x8010bcac
8010924b:	e8 04 71 ff ff       	call   80100354 <__panic>
80109250:	83 c4 10             	add    $0x10,%esp
    return ret;
80109253:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80109256:	c9                   	leave  
80109257:	c3                   	ret    

80109258 <do_exit>:

//realease mm struct
uint8_t
do_exit(int8_t error_code)
{
80109258:	55                   	push   %ebp
80109259:	89 e5                	mov    %esp,%ebp
8010925b:	83 ec 28             	sub    $0x28,%esp
8010925e:	8b 45 08             	mov    0x8(%ebp),%eax
80109261:	88 45 e4             	mov    %al,-0x1c(%ebp)
    struct proc *current = CUR_PROC;
80109264:	e8 02 d3 ff ff       	call   8010656b <get_cpu>
80109269:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
8010926f:	05 70 79 12 80       	add    $0x80127970,%eax
80109274:	8b 00                	mov    (%eax),%eax
80109276:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct proc *idleproc = IDLE_PROC;
80109279:	a1 c4 7b 12 80       	mov    0x80127bc4,%eax
8010927e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc *initproc = INIT_PROC;
80109281:	a1 c0 7b 12 80       	mov    0x80127bc0,%eax
80109286:	89 45 ec             	mov    %eax,-0x14(%ebp)

    if (current == idleproc) {
80109289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010928c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010928f:	75 1a                	jne    801092ab <do_exit+0x53>
        panic("idleproc exit.\n");
80109291:	83 ec 04             	sub    $0x4,%esp
80109294:	68 35 bf 10 80       	push   $0x8010bf35
80109299:	68 9f 01 00 00       	push   $0x19f
8010929e:	68 ac bc 10 80       	push   $0x8010bcac
801092a3:	e8 ac 70 ff ff       	call   80100354 <__panic>
801092a8:	83 c4 10             	add    $0x10,%esp
    }
    if (current == initproc) {
801092ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801092b1:	75 1a                	jne    801092cd <do_exit+0x75>
        panic("initproc exit.\n");
801092b3:	83 ec 04             	sub    $0x4,%esp
801092b6:	68 45 bf 10 80       	push   $0x8010bf45
801092bb:	68 a2 01 00 00       	push   $0x1a2
801092c0:	68 ac bc 10 80       	push   $0x8010bcac
801092c5:	e8 8a 70 ff ff       	call   80100354 <__panic>
801092ca:	83 c4 10             	add    $0x10,%esp
    }
    //release mm struct
    struct mm_struct *mm = current->mm;
801092cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092d0:	8b 40 34             	mov    0x34(%eax),%eax
801092d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mm != NULL) {
801092d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801092da:	74 5c                	je     80109338 <do_exit+0xe0>
        lcr3(V2P(kpgdir));
801092dc:	a1 68 70 12 80       	mov    0x80127068,%eax
801092e1:	05 00 00 00 80       	add    $0x80000000,%eax
801092e6:	83 ec 0c             	sub    $0xc,%esp
801092e9:	50                   	push   %eax
801092ea:	e8 41 f2 ff ff       	call   80108530 <lcr3>
801092ef:	83 c4 10             	add    $0x10,%esp
        if (mm_count_dec(mm) == 0) {
801092f2:	83 ec 0c             	sub    $0xc,%esp
801092f5:	ff 75 e8             	pushl  -0x18(%ebp)
801092f8:	e8 59 f2 ff ff       	call   80108556 <mm_count_dec>
801092fd:	83 c4 10             	add    $0x10,%esp
80109300:	85 c0                	test   %eax,%eax
80109302:	75 2a                	jne    8010932e <do_exit+0xd6>
            exit_mmap(mm);
80109304:	83 ec 0c             	sub    $0xc,%esp
80109307:	ff 75 e8             	pushl  -0x18(%ebp)
8010930a:	e8 ef 8b ff ff       	call   80101efe <exit_mmap>
8010930f:	83 c4 10             	add    $0x10,%esp
            put_pgdir(mm);
80109312:	83 ec 0c             	sub    $0xc,%esp
80109315:	ff 75 e8             	pushl  -0x18(%ebp)
80109318:	e8 ac 8c ff ff       	call   80101fc9 <put_pgdir>
8010931d:	83 c4 10             	add    $0x10,%esp
            mm_destroy(mm);
80109320:	83 ec 0c             	sub    $0xc,%esp
80109323:	ff 75 e8             	pushl  -0x18(%ebp)
80109326:	e8 37 89 ff ff       	call   80101c62 <mm_destroy>
8010932b:	83 c4 10             	add    $0x10,%esp
        }
        current->mm = NULL;
8010932e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109331:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
    }

    change_childs(current, current->parent); 
80109338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010933e:	83 ec 08             	sub    $0x8,%esp
80109341:	50                   	push   %eax
80109342:	ff 75 f4             	pushl  -0xc(%ebp)
80109345:	e8 6d ed ff ff       	call   801080b7 <change_childs>
8010934a:	83 c4 10             	add    $0x10,%esp
    current->exit_code = error_code;
8010934d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109350:	0f b6 55 e4          	movzbl -0x1c(%ebp),%edx
80109354:	88 50 18             	mov    %dl,0x18(%eax)
    current->state = ZOMBIE;
80109357:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935a:	c7 40 10 05 00 00 00 	movl   $0x5,0x10(%eax)

    sche();
80109361:	e8 72 ea ff ff       	call   80107dd8 <sche>
    return 1;
80109366:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010936b:	c9                   	leave  
8010936c:	c3                   	ret    

8010936d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010936d:	1e                   	push   %ds
  pushl %es
8010936e:	06                   	push   %es
  pushl %fs
8010936f:	0f a0                	push   %fs
  pushl %gs
80109371:	0f a8                	push   %gs
  pushal
80109373:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80109374:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80109378:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010937a:	8e c0                	mov    %eax,%es
#movw $(SEG_KCPU<<3), %ax
#  movw %ax, %fs
#  movw %ax, %gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010937c:	54                   	push   %esp
  call trap
8010937d:	e8 8d c7 ff ff       	call   80105b0f <trap>
  addl $4, %esp
80109382:	83 c4 04             	add    $0x4,%esp

80109385 <__traprets>:

  # Return falls through to trapret...
.globl __traprets
__traprets:
  popal
80109385:	61                   	popa   
  popl %gs
80109386:	0f a9                	pop    %gs
  popl %fs
80109388:	0f a1                	pop    %fs
  popl %es
8010938a:	07                   	pop    %es
  popl %ds
8010938b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010938c:	83 c4 08             	add    $0x8,%esp
  iret
8010938f:	cf                   	iret   

80109390 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80109390:	6a 00                	push   $0x0
  pushl $0
80109392:	6a 00                	push   $0x0
  jmp alltraps
80109394:	e9 d4 ff ff ff       	jmp    8010936d <alltraps>

80109399 <vector1>:
.globl vector1
vector1:
  pushl $0
80109399:	6a 00                	push   $0x0
  pushl $1
8010939b:	6a 01                	push   $0x1
  jmp alltraps
8010939d:	e9 cb ff ff ff       	jmp    8010936d <alltraps>

801093a2 <vector2>:
.globl vector2
vector2:
  pushl $0
801093a2:	6a 00                	push   $0x0
  pushl $2
801093a4:	6a 02                	push   $0x2
  jmp alltraps
801093a6:	e9 c2 ff ff ff       	jmp    8010936d <alltraps>

801093ab <vector3>:
.globl vector3
vector3:
  pushl $0
801093ab:	6a 00                	push   $0x0
  pushl $3
801093ad:	6a 03                	push   $0x3
  jmp alltraps
801093af:	e9 b9 ff ff ff       	jmp    8010936d <alltraps>

801093b4 <vector4>:
.globl vector4
vector4:
  pushl $0
801093b4:	6a 00                	push   $0x0
  pushl $4
801093b6:	6a 04                	push   $0x4
  jmp alltraps
801093b8:	e9 b0 ff ff ff       	jmp    8010936d <alltraps>

801093bd <vector5>:
.globl vector5
vector5:
  pushl $0
801093bd:	6a 00                	push   $0x0
  pushl $5
801093bf:	6a 05                	push   $0x5
  jmp alltraps
801093c1:	e9 a7 ff ff ff       	jmp    8010936d <alltraps>

801093c6 <vector6>:
.globl vector6
vector6:
  pushl $0
801093c6:	6a 00                	push   $0x0
  pushl $6
801093c8:	6a 06                	push   $0x6
  jmp alltraps
801093ca:	e9 9e ff ff ff       	jmp    8010936d <alltraps>

801093cf <vector7>:
.globl vector7
vector7:
  pushl $0
801093cf:	6a 00                	push   $0x0
  pushl $7
801093d1:	6a 07                	push   $0x7
  jmp alltraps
801093d3:	e9 95 ff ff ff       	jmp    8010936d <alltraps>

801093d8 <vector8>:
.globl vector8
vector8:
  pushl $8
801093d8:	6a 08                	push   $0x8
  jmp alltraps
801093da:	e9 8e ff ff ff       	jmp    8010936d <alltraps>

801093df <vector9>:
.globl vector9
vector9:
  pushl $0
801093df:	6a 00                	push   $0x0
  pushl $9
801093e1:	6a 09                	push   $0x9
  jmp alltraps
801093e3:	e9 85 ff ff ff       	jmp    8010936d <alltraps>

801093e8 <vector10>:
.globl vector10
vector10:
  pushl $10
801093e8:	6a 0a                	push   $0xa
  jmp alltraps
801093ea:	e9 7e ff ff ff       	jmp    8010936d <alltraps>

801093ef <vector11>:
.globl vector11
vector11:
  pushl $11
801093ef:	6a 0b                	push   $0xb
  jmp alltraps
801093f1:	e9 77 ff ff ff       	jmp    8010936d <alltraps>

801093f6 <vector12>:
.globl vector12
vector12:
  pushl $12
801093f6:	6a 0c                	push   $0xc
  jmp alltraps
801093f8:	e9 70 ff ff ff       	jmp    8010936d <alltraps>

801093fd <vector13>:
.globl vector13
vector13:
  pushl $13
801093fd:	6a 0d                	push   $0xd
  jmp alltraps
801093ff:	e9 69 ff ff ff       	jmp    8010936d <alltraps>

80109404 <vector14>:
.globl vector14
vector14:
  pushl $14
80109404:	6a 0e                	push   $0xe
  jmp alltraps
80109406:	e9 62 ff ff ff       	jmp    8010936d <alltraps>

8010940b <vector15>:
.globl vector15
vector15:
  pushl $0
8010940b:	6a 00                	push   $0x0
  pushl $15
8010940d:	6a 0f                	push   $0xf
  jmp alltraps
8010940f:	e9 59 ff ff ff       	jmp    8010936d <alltraps>

80109414 <vector16>:
.globl vector16
vector16:
  pushl $0
80109414:	6a 00                	push   $0x0
  pushl $16
80109416:	6a 10                	push   $0x10
  jmp alltraps
80109418:	e9 50 ff ff ff       	jmp    8010936d <alltraps>

8010941d <vector17>:
.globl vector17
vector17:
  pushl $17
8010941d:	6a 11                	push   $0x11
  jmp alltraps
8010941f:	e9 49 ff ff ff       	jmp    8010936d <alltraps>

80109424 <vector18>:
.globl vector18
vector18:
  pushl $0
80109424:	6a 00                	push   $0x0
  pushl $18
80109426:	6a 12                	push   $0x12
  jmp alltraps
80109428:	e9 40 ff ff ff       	jmp    8010936d <alltraps>

8010942d <vector19>:
.globl vector19
vector19:
  pushl $0
8010942d:	6a 00                	push   $0x0
  pushl $19
8010942f:	6a 13                	push   $0x13
  jmp alltraps
80109431:	e9 37 ff ff ff       	jmp    8010936d <alltraps>

80109436 <vector20>:
.globl vector20
vector20:
  pushl $0
80109436:	6a 00                	push   $0x0
  pushl $20
80109438:	6a 14                	push   $0x14
  jmp alltraps
8010943a:	e9 2e ff ff ff       	jmp    8010936d <alltraps>

8010943f <vector21>:
.globl vector21
vector21:
  pushl $0
8010943f:	6a 00                	push   $0x0
  pushl $21
80109441:	6a 15                	push   $0x15
  jmp alltraps
80109443:	e9 25 ff ff ff       	jmp    8010936d <alltraps>

80109448 <vector22>:
.globl vector22
vector22:
  pushl $0
80109448:	6a 00                	push   $0x0
  pushl $22
8010944a:	6a 16                	push   $0x16
  jmp alltraps
8010944c:	e9 1c ff ff ff       	jmp    8010936d <alltraps>

80109451 <vector23>:
.globl vector23
vector23:
  pushl $0
80109451:	6a 00                	push   $0x0
  pushl $23
80109453:	6a 17                	push   $0x17
  jmp alltraps
80109455:	e9 13 ff ff ff       	jmp    8010936d <alltraps>

8010945a <vector24>:
.globl vector24
vector24:
  pushl $0
8010945a:	6a 00                	push   $0x0
  pushl $24
8010945c:	6a 18                	push   $0x18
  jmp alltraps
8010945e:	e9 0a ff ff ff       	jmp    8010936d <alltraps>

80109463 <vector25>:
.globl vector25
vector25:
  pushl $0
80109463:	6a 00                	push   $0x0
  pushl $25
80109465:	6a 19                	push   $0x19
  jmp alltraps
80109467:	e9 01 ff ff ff       	jmp    8010936d <alltraps>

8010946c <vector26>:
.globl vector26
vector26:
  pushl $0
8010946c:	6a 00                	push   $0x0
  pushl $26
8010946e:	6a 1a                	push   $0x1a
  jmp alltraps
80109470:	e9 f8 fe ff ff       	jmp    8010936d <alltraps>

80109475 <vector27>:
.globl vector27
vector27:
  pushl $0
80109475:	6a 00                	push   $0x0
  pushl $27
80109477:	6a 1b                	push   $0x1b
  jmp alltraps
80109479:	e9 ef fe ff ff       	jmp    8010936d <alltraps>

8010947e <vector28>:
.globl vector28
vector28:
  pushl $0
8010947e:	6a 00                	push   $0x0
  pushl $28
80109480:	6a 1c                	push   $0x1c
  jmp alltraps
80109482:	e9 e6 fe ff ff       	jmp    8010936d <alltraps>

80109487 <vector29>:
.globl vector29
vector29:
  pushl $0
80109487:	6a 00                	push   $0x0
  pushl $29
80109489:	6a 1d                	push   $0x1d
  jmp alltraps
8010948b:	e9 dd fe ff ff       	jmp    8010936d <alltraps>

80109490 <vector30>:
.globl vector30
vector30:
  pushl $0
80109490:	6a 00                	push   $0x0
  pushl $30
80109492:	6a 1e                	push   $0x1e
  jmp alltraps
80109494:	e9 d4 fe ff ff       	jmp    8010936d <alltraps>

80109499 <vector31>:
.globl vector31
vector31:
  pushl $0
80109499:	6a 00                	push   $0x0
  pushl $31
8010949b:	6a 1f                	push   $0x1f
  jmp alltraps
8010949d:	e9 cb fe ff ff       	jmp    8010936d <alltraps>

801094a2 <vector32>:
.globl vector32
vector32:
  pushl $0
801094a2:	6a 00                	push   $0x0
  pushl $32
801094a4:	6a 20                	push   $0x20
  jmp alltraps
801094a6:	e9 c2 fe ff ff       	jmp    8010936d <alltraps>

801094ab <vector33>:
.globl vector33
vector33:
  pushl $0
801094ab:	6a 00                	push   $0x0
  pushl $33
801094ad:	6a 21                	push   $0x21
  jmp alltraps
801094af:	e9 b9 fe ff ff       	jmp    8010936d <alltraps>

801094b4 <vector34>:
.globl vector34
vector34:
  pushl $0
801094b4:	6a 00                	push   $0x0
  pushl $34
801094b6:	6a 22                	push   $0x22
  jmp alltraps
801094b8:	e9 b0 fe ff ff       	jmp    8010936d <alltraps>

801094bd <vector35>:
.globl vector35
vector35:
  pushl $0
801094bd:	6a 00                	push   $0x0
  pushl $35
801094bf:	6a 23                	push   $0x23
  jmp alltraps
801094c1:	e9 a7 fe ff ff       	jmp    8010936d <alltraps>

801094c6 <vector36>:
.globl vector36
vector36:
  pushl $0
801094c6:	6a 00                	push   $0x0
  pushl $36
801094c8:	6a 24                	push   $0x24
  jmp alltraps
801094ca:	e9 9e fe ff ff       	jmp    8010936d <alltraps>

801094cf <vector37>:
.globl vector37
vector37:
  pushl $0
801094cf:	6a 00                	push   $0x0
  pushl $37
801094d1:	6a 25                	push   $0x25
  jmp alltraps
801094d3:	e9 95 fe ff ff       	jmp    8010936d <alltraps>

801094d8 <vector38>:
.globl vector38
vector38:
  pushl $0
801094d8:	6a 00                	push   $0x0
  pushl $38
801094da:	6a 26                	push   $0x26
  jmp alltraps
801094dc:	e9 8c fe ff ff       	jmp    8010936d <alltraps>

801094e1 <vector39>:
.globl vector39
vector39:
  pushl $0
801094e1:	6a 00                	push   $0x0
  pushl $39
801094e3:	6a 27                	push   $0x27
  jmp alltraps
801094e5:	e9 83 fe ff ff       	jmp    8010936d <alltraps>

801094ea <vector40>:
.globl vector40
vector40:
  pushl $0
801094ea:	6a 00                	push   $0x0
  pushl $40
801094ec:	6a 28                	push   $0x28
  jmp alltraps
801094ee:	e9 7a fe ff ff       	jmp    8010936d <alltraps>

801094f3 <vector41>:
.globl vector41
vector41:
  pushl $0
801094f3:	6a 00                	push   $0x0
  pushl $41
801094f5:	6a 29                	push   $0x29
  jmp alltraps
801094f7:	e9 71 fe ff ff       	jmp    8010936d <alltraps>

801094fc <vector42>:
.globl vector42
vector42:
  pushl $0
801094fc:	6a 00                	push   $0x0
  pushl $42
801094fe:	6a 2a                	push   $0x2a
  jmp alltraps
80109500:	e9 68 fe ff ff       	jmp    8010936d <alltraps>

80109505 <vector43>:
.globl vector43
vector43:
  pushl $0
80109505:	6a 00                	push   $0x0
  pushl $43
80109507:	6a 2b                	push   $0x2b
  jmp alltraps
80109509:	e9 5f fe ff ff       	jmp    8010936d <alltraps>

8010950e <vector44>:
.globl vector44
vector44:
  pushl $0
8010950e:	6a 00                	push   $0x0
  pushl $44
80109510:	6a 2c                	push   $0x2c
  jmp alltraps
80109512:	e9 56 fe ff ff       	jmp    8010936d <alltraps>

80109517 <vector45>:
.globl vector45
vector45:
  pushl $0
80109517:	6a 00                	push   $0x0
  pushl $45
80109519:	6a 2d                	push   $0x2d
  jmp alltraps
8010951b:	e9 4d fe ff ff       	jmp    8010936d <alltraps>

80109520 <vector46>:
.globl vector46
vector46:
  pushl $0
80109520:	6a 00                	push   $0x0
  pushl $46
80109522:	6a 2e                	push   $0x2e
  jmp alltraps
80109524:	e9 44 fe ff ff       	jmp    8010936d <alltraps>

80109529 <vector47>:
.globl vector47
vector47:
  pushl $0
80109529:	6a 00                	push   $0x0
  pushl $47
8010952b:	6a 2f                	push   $0x2f
  jmp alltraps
8010952d:	e9 3b fe ff ff       	jmp    8010936d <alltraps>

80109532 <vector48>:
.globl vector48
vector48:
  pushl $0
80109532:	6a 00                	push   $0x0
  pushl $48
80109534:	6a 30                	push   $0x30
  jmp alltraps
80109536:	e9 32 fe ff ff       	jmp    8010936d <alltraps>

8010953b <vector49>:
.globl vector49
vector49:
  pushl $0
8010953b:	6a 00                	push   $0x0
  pushl $49
8010953d:	6a 31                	push   $0x31
  jmp alltraps
8010953f:	e9 29 fe ff ff       	jmp    8010936d <alltraps>

80109544 <vector50>:
.globl vector50
vector50:
  pushl $0
80109544:	6a 00                	push   $0x0
  pushl $50
80109546:	6a 32                	push   $0x32
  jmp alltraps
80109548:	e9 20 fe ff ff       	jmp    8010936d <alltraps>

8010954d <vector51>:
.globl vector51
vector51:
  pushl $0
8010954d:	6a 00                	push   $0x0
  pushl $51
8010954f:	6a 33                	push   $0x33
  jmp alltraps
80109551:	e9 17 fe ff ff       	jmp    8010936d <alltraps>

80109556 <vector52>:
.globl vector52
vector52:
  pushl $0
80109556:	6a 00                	push   $0x0
  pushl $52
80109558:	6a 34                	push   $0x34
  jmp alltraps
8010955a:	e9 0e fe ff ff       	jmp    8010936d <alltraps>

8010955f <vector53>:
.globl vector53
vector53:
  pushl $0
8010955f:	6a 00                	push   $0x0
  pushl $53
80109561:	6a 35                	push   $0x35
  jmp alltraps
80109563:	e9 05 fe ff ff       	jmp    8010936d <alltraps>

80109568 <vector54>:
.globl vector54
vector54:
  pushl $0
80109568:	6a 00                	push   $0x0
  pushl $54
8010956a:	6a 36                	push   $0x36
  jmp alltraps
8010956c:	e9 fc fd ff ff       	jmp    8010936d <alltraps>

80109571 <vector55>:
.globl vector55
vector55:
  pushl $0
80109571:	6a 00                	push   $0x0
  pushl $55
80109573:	6a 37                	push   $0x37
  jmp alltraps
80109575:	e9 f3 fd ff ff       	jmp    8010936d <alltraps>

8010957a <vector56>:
.globl vector56
vector56:
  pushl $0
8010957a:	6a 00                	push   $0x0
  pushl $56
8010957c:	6a 38                	push   $0x38
  jmp alltraps
8010957e:	e9 ea fd ff ff       	jmp    8010936d <alltraps>

80109583 <vector57>:
.globl vector57
vector57:
  pushl $0
80109583:	6a 00                	push   $0x0
  pushl $57
80109585:	6a 39                	push   $0x39
  jmp alltraps
80109587:	e9 e1 fd ff ff       	jmp    8010936d <alltraps>

8010958c <vector58>:
.globl vector58
vector58:
  pushl $0
8010958c:	6a 00                	push   $0x0
  pushl $58
8010958e:	6a 3a                	push   $0x3a
  jmp alltraps
80109590:	e9 d8 fd ff ff       	jmp    8010936d <alltraps>

80109595 <vector59>:
.globl vector59
vector59:
  pushl $0
80109595:	6a 00                	push   $0x0
  pushl $59
80109597:	6a 3b                	push   $0x3b
  jmp alltraps
80109599:	e9 cf fd ff ff       	jmp    8010936d <alltraps>

8010959e <vector60>:
.globl vector60
vector60:
  pushl $0
8010959e:	6a 00                	push   $0x0
  pushl $60
801095a0:	6a 3c                	push   $0x3c
  jmp alltraps
801095a2:	e9 c6 fd ff ff       	jmp    8010936d <alltraps>

801095a7 <vector61>:
.globl vector61
vector61:
  pushl $0
801095a7:	6a 00                	push   $0x0
  pushl $61
801095a9:	6a 3d                	push   $0x3d
  jmp alltraps
801095ab:	e9 bd fd ff ff       	jmp    8010936d <alltraps>

801095b0 <vector62>:
.globl vector62
vector62:
  pushl $0
801095b0:	6a 00                	push   $0x0
  pushl $62
801095b2:	6a 3e                	push   $0x3e
  jmp alltraps
801095b4:	e9 b4 fd ff ff       	jmp    8010936d <alltraps>

801095b9 <vector63>:
.globl vector63
vector63:
  pushl $0
801095b9:	6a 00                	push   $0x0
  pushl $63
801095bb:	6a 3f                	push   $0x3f
  jmp alltraps
801095bd:	e9 ab fd ff ff       	jmp    8010936d <alltraps>

801095c2 <vector64>:
.globl vector64
vector64:
  pushl $0
801095c2:	6a 00                	push   $0x0
  pushl $64
801095c4:	6a 40                	push   $0x40
  jmp alltraps
801095c6:	e9 a2 fd ff ff       	jmp    8010936d <alltraps>

801095cb <vector65>:
.globl vector65
vector65:
  pushl $0
801095cb:	6a 00                	push   $0x0
  pushl $65
801095cd:	6a 41                	push   $0x41
  jmp alltraps
801095cf:	e9 99 fd ff ff       	jmp    8010936d <alltraps>

801095d4 <vector66>:
.globl vector66
vector66:
  pushl $0
801095d4:	6a 00                	push   $0x0
  pushl $66
801095d6:	6a 42                	push   $0x42
  jmp alltraps
801095d8:	e9 90 fd ff ff       	jmp    8010936d <alltraps>

801095dd <vector67>:
.globl vector67
vector67:
  pushl $0
801095dd:	6a 00                	push   $0x0
  pushl $67
801095df:	6a 43                	push   $0x43
  jmp alltraps
801095e1:	e9 87 fd ff ff       	jmp    8010936d <alltraps>

801095e6 <vector68>:
.globl vector68
vector68:
  pushl $0
801095e6:	6a 00                	push   $0x0
  pushl $68
801095e8:	6a 44                	push   $0x44
  jmp alltraps
801095ea:	e9 7e fd ff ff       	jmp    8010936d <alltraps>

801095ef <vector69>:
.globl vector69
vector69:
  pushl $0
801095ef:	6a 00                	push   $0x0
  pushl $69
801095f1:	6a 45                	push   $0x45
  jmp alltraps
801095f3:	e9 75 fd ff ff       	jmp    8010936d <alltraps>

801095f8 <vector70>:
.globl vector70
vector70:
  pushl $0
801095f8:	6a 00                	push   $0x0
  pushl $70
801095fa:	6a 46                	push   $0x46
  jmp alltraps
801095fc:	e9 6c fd ff ff       	jmp    8010936d <alltraps>

80109601 <vector71>:
.globl vector71
vector71:
  pushl $0
80109601:	6a 00                	push   $0x0
  pushl $71
80109603:	6a 47                	push   $0x47
  jmp alltraps
80109605:	e9 63 fd ff ff       	jmp    8010936d <alltraps>

8010960a <vector72>:
.globl vector72
vector72:
  pushl $0
8010960a:	6a 00                	push   $0x0
  pushl $72
8010960c:	6a 48                	push   $0x48
  jmp alltraps
8010960e:	e9 5a fd ff ff       	jmp    8010936d <alltraps>

80109613 <vector73>:
.globl vector73
vector73:
  pushl $0
80109613:	6a 00                	push   $0x0
  pushl $73
80109615:	6a 49                	push   $0x49
  jmp alltraps
80109617:	e9 51 fd ff ff       	jmp    8010936d <alltraps>

8010961c <vector74>:
.globl vector74
vector74:
  pushl $0
8010961c:	6a 00                	push   $0x0
  pushl $74
8010961e:	6a 4a                	push   $0x4a
  jmp alltraps
80109620:	e9 48 fd ff ff       	jmp    8010936d <alltraps>

80109625 <vector75>:
.globl vector75
vector75:
  pushl $0
80109625:	6a 00                	push   $0x0
  pushl $75
80109627:	6a 4b                	push   $0x4b
  jmp alltraps
80109629:	e9 3f fd ff ff       	jmp    8010936d <alltraps>

8010962e <vector76>:
.globl vector76
vector76:
  pushl $0
8010962e:	6a 00                	push   $0x0
  pushl $76
80109630:	6a 4c                	push   $0x4c
  jmp alltraps
80109632:	e9 36 fd ff ff       	jmp    8010936d <alltraps>

80109637 <vector77>:
.globl vector77
vector77:
  pushl $0
80109637:	6a 00                	push   $0x0
  pushl $77
80109639:	6a 4d                	push   $0x4d
  jmp alltraps
8010963b:	e9 2d fd ff ff       	jmp    8010936d <alltraps>

80109640 <vector78>:
.globl vector78
vector78:
  pushl $0
80109640:	6a 00                	push   $0x0
  pushl $78
80109642:	6a 4e                	push   $0x4e
  jmp alltraps
80109644:	e9 24 fd ff ff       	jmp    8010936d <alltraps>

80109649 <vector79>:
.globl vector79
vector79:
  pushl $0
80109649:	6a 00                	push   $0x0
  pushl $79
8010964b:	6a 4f                	push   $0x4f
  jmp alltraps
8010964d:	e9 1b fd ff ff       	jmp    8010936d <alltraps>

80109652 <vector80>:
.globl vector80
vector80:
  pushl $0
80109652:	6a 00                	push   $0x0
  pushl $80
80109654:	6a 50                	push   $0x50
  jmp alltraps
80109656:	e9 12 fd ff ff       	jmp    8010936d <alltraps>

8010965b <vector81>:
.globl vector81
vector81:
  pushl $0
8010965b:	6a 00                	push   $0x0
  pushl $81
8010965d:	6a 51                	push   $0x51
  jmp alltraps
8010965f:	e9 09 fd ff ff       	jmp    8010936d <alltraps>

80109664 <vector82>:
.globl vector82
vector82:
  pushl $0
80109664:	6a 00                	push   $0x0
  pushl $82
80109666:	6a 52                	push   $0x52
  jmp alltraps
80109668:	e9 00 fd ff ff       	jmp    8010936d <alltraps>

8010966d <vector83>:
.globl vector83
vector83:
  pushl $0
8010966d:	6a 00                	push   $0x0
  pushl $83
8010966f:	6a 53                	push   $0x53
  jmp alltraps
80109671:	e9 f7 fc ff ff       	jmp    8010936d <alltraps>

80109676 <vector84>:
.globl vector84
vector84:
  pushl $0
80109676:	6a 00                	push   $0x0
  pushl $84
80109678:	6a 54                	push   $0x54
  jmp alltraps
8010967a:	e9 ee fc ff ff       	jmp    8010936d <alltraps>

8010967f <vector85>:
.globl vector85
vector85:
  pushl $0
8010967f:	6a 00                	push   $0x0
  pushl $85
80109681:	6a 55                	push   $0x55
  jmp alltraps
80109683:	e9 e5 fc ff ff       	jmp    8010936d <alltraps>

80109688 <vector86>:
.globl vector86
vector86:
  pushl $0
80109688:	6a 00                	push   $0x0
  pushl $86
8010968a:	6a 56                	push   $0x56
  jmp alltraps
8010968c:	e9 dc fc ff ff       	jmp    8010936d <alltraps>

80109691 <vector87>:
.globl vector87
vector87:
  pushl $0
80109691:	6a 00                	push   $0x0
  pushl $87
80109693:	6a 57                	push   $0x57
  jmp alltraps
80109695:	e9 d3 fc ff ff       	jmp    8010936d <alltraps>

8010969a <vector88>:
.globl vector88
vector88:
  pushl $0
8010969a:	6a 00                	push   $0x0
  pushl $88
8010969c:	6a 58                	push   $0x58
  jmp alltraps
8010969e:	e9 ca fc ff ff       	jmp    8010936d <alltraps>

801096a3 <vector89>:
.globl vector89
vector89:
  pushl $0
801096a3:	6a 00                	push   $0x0
  pushl $89
801096a5:	6a 59                	push   $0x59
  jmp alltraps
801096a7:	e9 c1 fc ff ff       	jmp    8010936d <alltraps>

801096ac <vector90>:
.globl vector90
vector90:
  pushl $0
801096ac:	6a 00                	push   $0x0
  pushl $90
801096ae:	6a 5a                	push   $0x5a
  jmp alltraps
801096b0:	e9 b8 fc ff ff       	jmp    8010936d <alltraps>

801096b5 <vector91>:
.globl vector91
vector91:
  pushl $0
801096b5:	6a 00                	push   $0x0
  pushl $91
801096b7:	6a 5b                	push   $0x5b
  jmp alltraps
801096b9:	e9 af fc ff ff       	jmp    8010936d <alltraps>

801096be <vector92>:
.globl vector92
vector92:
  pushl $0
801096be:	6a 00                	push   $0x0
  pushl $92
801096c0:	6a 5c                	push   $0x5c
  jmp alltraps
801096c2:	e9 a6 fc ff ff       	jmp    8010936d <alltraps>

801096c7 <vector93>:
.globl vector93
vector93:
  pushl $0
801096c7:	6a 00                	push   $0x0
  pushl $93
801096c9:	6a 5d                	push   $0x5d
  jmp alltraps
801096cb:	e9 9d fc ff ff       	jmp    8010936d <alltraps>

801096d0 <vector94>:
.globl vector94
vector94:
  pushl $0
801096d0:	6a 00                	push   $0x0
  pushl $94
801096d2:	6a 5e                	push   $0x5e
  jmp alltraps
801096d4:	e9 94 fc ff ff       	jmp    8010936d <alltraps>

801096d9 <vector95>:
.globl vector95
vector95:
  pushl $0
801096d9:	6a 00                	push   $0x0
  pushl $95
801096db:	6a 5f                	push   $0x5f
  jmp alltraps
801096dd:	e9 8b fc ff ff       	jmp    8010936d <alltraps>

801096e2 <vector96>:
.globl vector96
vector96:
  pushl $0
801096e2:	6a 00                	push   $0x0
  pushl $96
801096e4:	6a 60                	push   $0x60
  jmp alltraps
801096e6:	e9 82 fc ff ff       	jmp    8010936d <alltraps>

801096eb <vector97>:
.globl vector97
vector97:
  pushl $0
801096eb:	6a 00                	push   $0x0
  pushl $97
801096ed:	6a 61                	push   $0x61
  jmp alltraps
801096ef:	e9 79 fc ff ff       	jmp    8010936d <alltraps>

801096f4 <vector98>:
.globl vector98
vector98:
  pushl $0
801096f4:	6a 00                	push   $0x0
  pushl $98
801096f6:	6a 62                	push   $0x62
  jmp alltraps
801096f8:	e9 70 fc ff ff       	jmp    8010936d <alltraps>

801096fd <vector99>:
.globl vector99
vector99:
  pushl $0
801096fd:	6a 00                	push   $0x0
  pushl $99
801096ff:	6a 63                	push   $0x63
  jmp alltraps
80109701:	e9 67 fc ff ff       	jmp    8010936d <alltraps>

80109706 <vector100>:
.globl vector100
vector100:
  pushl $0
80109706:	6a 00                	push   $0x0
  pushl $100
80109708:	6a 64                	push   $0x64
  jmp alltraps
8010970a:	e9 5e fc ff ff       	jmp    8010936d <alltraps>

8010970f <vector101>:
.globl vector101
vector101:
  pushl $0
8010970f:	6a 00                	push   $0x0
  pushl $101
80109711:	6a 65                	push   $0x65
  jmp alltraps
80109713:	e9 55 fc ff ff       	jmp    8010936d <alltraps>

80109718 <vector102>:
.globl vector102
vector102:
  pushl $0
80109718:	6a 00                	push   $0x0
  pushl $102
8010971a:	6a 66                	push   $0x66
  jmp alltraps
8010971c:	e9 4c fc ff ff       	jmp    8010936d <alltraps>

80109721 <vector103>:
.globl vector103
vector103:
  pushl $0
80109721:	6a 00                	push   $0x0
  pushl $103
80109723:	6a 67                	push   $0x67
  jmp alltraps
80109725:	e9 43 fc ff ff       	jmp    8010936d <alltraps>

8010972a <vector104>:
.globl vector104
vector104:
  pushl $0
8010972a:	6a 00                	push   $0x0
  pushl $104
8010972c:	6a 68                	push   $0x68
  jmp alltraps
8010972e:	e9 3a fc ff ff       	jmp    8010936d <alltraps>

80109733 <vector105>:
.globl vector105
vector105:
  pushl $0
80109733:	6a 00                	push   $0x0
  pushl $105
80109735:	6a 69                	push   $0x69
  jmp alltraps
80109737:	e9 31 fc ff ff       	jmp    8010936d <alltraps>

8010973c <vector106>:
.globl vector106
vector106:
  pushl $0
8010973c:	6a 00                	push   $0x0
  pushl $106
8010973e:	6a 6a                	push   $0x6a
  jmp alltraps
80109740:	e9 28 fc ff ff       	jmp    8010936d <alltraps>

80109745 <vector107>:
.globl vector107
vector107:
  pushl $0
80109745:	6a 00                	push   $0x0
  pushl $107
80109747:	6a 6b                	push   $0x6b
  jmp alltraps
80109749:	e9 1f fc ff ff       	jmp    8010936d <alltraps>

8010974e <vector108>:
.globl vector108
vector108:
  pushl $0
8010974e:	6a 00                	push   $0x0
  pushl $108
80109750:	6a 6c                	push   $0x6c
  jmp alltraps
80109752:	e9 16 fc ff ff       	jmp    8010936d <alltraps>

80109757 <vector109>:
.globl vector109
vector109:
  pushl $0
80109757:	6a 00                	push   $0x0
  pushl $109
80109759:	6a 6d                	push   $0x6d
  jmp alltraps
8010975b:	e9 0d fc ff ff       	jmp    8010936d <alltraps>

80109760 <vector110>:
.globl vector110
vector110:
  pushl $0
80109760:	6a 00                	push   $0x0
  pushl $110
80109762:	6a 6e                	push   $0x6e
  jmp alltraps
80109764:	e9 04 fc ff ff       	jmp    8010936d <alltraps>

80109769 <vector111>:
.globl vector111
vector111:
  pushl $0
80109769:	6a 00                	push   $0x0
  pushl $111
8010976b:	6a 6f                	push   $0x6f
  jmp alltraps
8010976d:	e9 fb fb ff ff       	jmp    8010936d <alltraps>

80109772 <vector112>:
.globl vector112
vector112:
  pushl $0
80109772:	6a 00                	push   $0x0
  pushl $112
80109774:	6a 70                	push   $0x70
  jmp alltraps
80109776:	e9 f2 fb ff ff       	jmp    8010936d <alltraps>

8010977b <vector113>:
.globl vector113
vector113:
  pushl $0
8010977b:	6a 00                	push   $0x0
  pushl $113
8010977d:	6a 71                	push   $0x71
  jmp alltraps
8010977f:	e9 e9 fb ff ff       	jmp    8010936d <alltraps>

80109784 <vector114>:
.globl vector114
vector114:
  pushl $0
80109784:	6a 00                	push   $0x0
  pushl $114
80109786:	6a 72                	push   $0x72
  jmp alltraps
80109788:	e9 e0 fb ff ff       	jmp    8010936d <alltraps>

8010978d <vector115>:
.globl vector115
vector115:
  pushl $0
8010978d:	6a 00                	push   $0x0
  pushl $115
8010978f:	6a 73                	push   $0x73
  jmp alltraps
80109791:	e9 d7 fb ff ff       	jmp    8010936d <alltraps>

80109796 <vector116>:
.globl vector116
vector116:
  pushl $0
80109796:	6a 00                	push   $0x0
  pushl $116
80109798:	6a 74                	push   $0x74
  jmp alltraps
8010979a:	e9 ce fb ff ff       	jmp    8010936d <alltraps>

8010979f <vector117>:
.globl vector117
vector117:
  pushl $0
8010979f:	6a 00                	push   $0x0
  pushl $117
801097a1:	6a 75                	push   $0x75
  jmp alltraps
801097a3:	e9 c5 fb ff ff       	jmp    8010936d <alltraps>

801097a8 <vector118>:
.globl vector118
vector118:
  pushl $0
801097a8:	6a 00                	push   $0x0
  pushl $118
801097aa:	6a 76                	push   $0x76
  jmp alltraps
801097ac:	e9 bc fb ff ff       	jmp    8010936d <alltraps>

801097b1 <vector119>:
.globl vector119
vector119:
  pushl $0
801097b1:	6a 00                	push   $0x0
  pushl $119
801097b3:	6a 77                	push   $0x77
  jmp alltraps
801097b5:	e9 b3 fb ff ff       	jmp    8010936d <alltraps>

801097ba <vector120>:
.globl vector120
vector120:
  pushl $0
801097ba:	6a 00                	push   $0x0
  pushl $120
801097bc:	6a 78                	push   $0x78
  jmp alltraps
801097be:	e9 aa fb ff ff       	jmp    8010936d <alltraps>

801097c3 <vector121>:
.globl vector121
vector121:
  pushl $0
801097c3:	6a 00                	push   $0x0
  pushl $121
801097c5:	6a 79                	push   $0x79
  jmp alltraps
801097c7:	e9 a1 fb ff ff       	jmp    8010936d <alltraps>

801097cc <vector122>:
.globl vector122
vector122:
  pushl $0
801097cc:	6a 00                	push   $0x0
  pushl $122
801097ce:	6a 7a                	push   $0x7a
  jmp alltraps
801097d0:	e9 98 fb ff ff       	jmp    8010936d <alltraps>

801097d5 <vector123>:
.globl vector123
vector123:
  pushl $0
801097d5:	6a 00                	push   $0x0
  pushl $123
801097d7:	6a 7b                	push   $0x7b
  jmp alltraps
801097d9:	e9 8f fb ff ff       	jmp    8010936d <alltraps>

801097de <vector124>:
.globl vector124
vector124:
  pushl $0
801097de:	6a 00                	push   $0x0
  pushl $124
801097e0:	6a 7c                	push   $0x7c
  jmp alltraps
801097e2:	e9 86 fb ff ff       	jmp    8010936d <alltraps>

801097e7 <vector125>:
.globl vector125
vector125:
  pushl $0
801097e7:	6a 00                	push   $0x0
  pushl $125
801097e9:	6a 7d                	push   $0x7d
  jmp alltraps
801097eb:	e9 7d fb ff ff       	jmp    8010936d <alltraps>

801097f0 <vector126>:
.globl vector126
vector126:
  pushl $0
801097f0:	6a 00                	push   $0x0
  pushl $126
801097f2:	6a 7e                	push   $0x7e
  jmp alltraps
801097f4:	e9 74 fb ff ff       	jmp    8010936d <alltraps>

801097f9 <vector127>:
.globl vector127
vector127:
  pushl $0
801097f9:	6a 00                	push   $0x0
  pushl $127
801097fb:	6a 7f                	push   $0x7f
  jmp alltraps
801097fd:	e9 6b fb ff ff       	jmp    8010936d <alltraps>

80109802 <vector128>:
.globl vector128
vector128:
  pushl $0
80109802:	6a 00                	push   $0x0
  pushl $128
80109804:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80109809:	e9 5f fb ff ff       	jmp    8010936d <alltraps>

8010980e <vector129>:
.globl vector129
vector129:
  pushl $0
8010980e:	6a 00                	push   $0x0
  pushl $129
80109810:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80109815:	e9 53 fb ff ff       	jmp    8010936d <alltraps>

8010981a <vector130>:
.globl vector130
vector130:
  pushl $0
8010981a:	6a 00                	push   $0x0
  pushl $130
8010981c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80109821:	e9 47 fb ff ff       	jmp    8010936d <alltraps>

80109826 <vector131>:
.globl vector131
vector131:
  pushl $0
80109826:	6a 00                	push   $0x0
  pushl $131
80109828:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010982d:	e9 3b fb ff ff       	jmp    8010936d <alltraps>

80109832 <vector132>:
.globl vector132
vector132:
  pushl $0
80109832:	6a 00                	push   $0x0
  pushl $132
80109834:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80109839:	e9 2f fb ff ff       	jmp    8010936d <alltraps>

8010983e <vector133>:
.globl vector133
vector133:
  pushl $0
8010983e:	6a 00                	push   $0x0
  pushl $133
80109840:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80109845:	e9 23 fb ff ff       	jmp    8010936d <alltraps>

8010984a <vector134>:
.globl vector134
vector134:
  pushl $0
8010984a:	6a 00                	push   $0x0
  pushl $134
8010984c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80109851:	e9 17 fb ff ff       	jmp    8010936d <alltraps>

80109856 <vector135>:
.globl vector135
vector135:
  pushl $0
80109856:	6a 00                	push   $0x0
  pushl $135
80109858:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010985d:	e9 0b fb ff ff       	jmp    8010936d <alltraps>

80109862 <vector136>:
.globl vector136
vector136:
  pushl $0
80109862:	6a 00                	push   $0x0
  pushl $136
80109864:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80109869:	e9 ff fa ff ff       	jmp    8010936d <alltraps>

8010986e <vector137>:
.globl vector137
vector137:
  pushl $0
8010986e:	6a 00                	push   $0x0
  pushl $137
80109870:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80109875:	e9 f3 fa ff ff       	jmp    8010936d <alltraps>

8010987a <vector138>:
.globl vector138
vector138:
  pushl $0
8010987a:	6a 00                	push   $0x0
  pushl $138
8010987c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80109881:	e9 e7 fa ff ff       	jmp    8010936d <alltraps>

80109886 <vector139>:
.globl vector139
vector139:
  pushl $0
80109886:	6a 00                	push   $0x0
  pushl $139
80109888:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010988d:	e9 db fa ff ff       	jmp    8010936d <alltraps>

80109892 <vector140>:
.globl vector140
vector140:
  pushl $0
80109892:	6a 00                	push   $0x0
  pushl $140
80109894:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80109899:	e9 cf fa ff ff       	jmp    8010936d <alltraps>

8010989e <vector141>:
.globl vector141
vector141:
  pushl $0
8010989e:	6a 00                	push   $0x0
  pushl $141
801098a0:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801098a5:	e9 c3 fa ff ff       	jmp    8010936d <alltraps>

801098aa <vector142>:
.globl vector142
vector142:
  pushl $0
801098aa:	6a 00                	push   $0x0
  pushl $142
801098ac:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801098b1:	e9 b7 fa ff ff       	jmp    8010936d <alltraps>

801098b6 <vector143>:
.globl vector143
vector143:
  pushl $0
801098b6:	6a 00                	push   $0x0
  pushl $143
801098b8:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801098bd:	e9 ab fa ff ff       	jmp    8010936d <alltraps>

801098c2 <vector144>:
.globl vector144
vector144:
  pushl $0
801098c2:	6a 00                	push   $0x0
  pushl $144
801098c4:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801098c9:	e9 9f fa ff ff       	jmp    8010936d <alltraps>

801098ce <vector145>:
.globl vector145
vector145:
  pushl $0
801098ce:	6a 00                	push   $0x0
  pushl $145
801098d0:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801098d5:	e9 93 fa ff ff       	jmp    8010936d <alltraps>

801098da <vector146>:
.globl vector146
vector146:
  pushl $0
801098da:	6a 00                	push   $0x0
  pushl $146
801098dc:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801098e1:	e9 87 fa ff ff       	jmp    8010936d <alltraps>

801098e6 <vector147>:
.globl vector147
vector147:
  pushl $0
801098e6:	6a 00                	push   $0x0
  pushl $147
801098e8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801098ed:	e9 7b fa ff ff       	jmp    8010936d <alltraps>

801098f2 <vector148>:
.globl vector148
vector148:
  pushl $0
801098f2:	6a 00                	push   $0x0
  pushl $148
801098f4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801098f9:	e9 6f fa ff ff       	jmp    8010936d <alltraps>

801098fe <vector149>:
.globl vector149
vector149:
  pushl $0
801098fe:	6a 00                	push   $0x0
  pushl $149
80109900:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80109905:	e9 63 fa ff ff       	jmp    8010936d <alltraps>

8010990a <vector150>:
.globl vector150
vector150:
  pushl $0
8010990a:	6a 00                	push   $0x0
  pushl $150
8010990c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80109911:	e9 57 fa ff ff       	jmp    8010936d <alltraps>

80109916 <vector151>:
.globl vector151
vector151:
  pushl $0
80109916:	6a 00                	push   $0x0
  pushl $151
80109918:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010991d:	e9 4b fa ff ff       	jmp    8010936d <alltraps>

80109922 <vector152>:
.globl vector152
vector152:
  pushl $0
80109922:	6a 00                	push   $0x0
  pushl $152
80109924:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80109929:	e9 3f fa ff ff       	jmp    8010936d <alltraps>

8010992e <vector153>:
.globl vector153
vector153:
  pushl $0
8010992e:	6a 00                	push   $0x0
  pushl $153
80109930:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80109935:	e9 33 fa ff ff       	jmp    8010936d <alltraps>

8010993a <vector154>:
.globl vector154
vector154:
  pushl $0
8010993a:	6a 00                	push   $0x0
  pushl $154
8010993c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80109941:	e9 27 fa ff ff       	jmp    8010936d <alltraps>

80109946 <vector155>:
.globl vector155
vector155:
  pushl $0
80109946:	6a 00                	push   $0x0
  pushl $155
80109948:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010994d:	e9 1b fa ff ff       	jmp    8010936d <alltraps>

80109952 <vector156>:
.globl vector156
vector156:
  pushl $0
80109952:	6a 00                	push   $0x0
  pushl $156
80109954:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80109959:	e9 0f fa ff ff       	jmp    8010936d <alltraps>

8010995e <vector157>:
.globl vector157
vector157:
  pushl $0
8010995e:	6a 00                	push   $0x0
  pushl $157
80109960:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80109965:	e9 03 fa ff ff       	jmp    8010936d <alltraps>

8010996a <vector158>:
.globl vector158
vector158:
  pushl $0
8010996a:	6a 00                	push   $0x0
  pushl $158
8010996c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80109971:	e9 f7 f9 ff ff       	jmp    8010936d <alltraps>

80109976 <vector159>:
.globl vector159
vector159:
  pushl $0
80109976:	6a 00                	push   $0x0
  pushl $159
80109978:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010997d:	e9 eb f9 ff ff       	jmp    8010936d <alltraps>

80109982 <vector160>:
.globl vector160
vector160:
  pushl $0
80109982:	6a 00                	push   $0x0
  pushl $160
80109984:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80109989:	e9 df f9 ff ff       	jmp    8010936d <alltraps>

8010998e <vector161>:
.globl vector161
vector161:
  pushl $0
8010998e:	6a 00                	push   $0x0
  pushl $161
80109990:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80109995:	e9 d3 f9 ff ff       	jmp    8010936d <alltraps>

8010999a <vector162>:
.globl vector162
vector162:
  pushl $0
8010999a:	6a 00                	push   $0x0
  pushl $162
8010999c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801099a1:	e9 c7 f9 ff ff       	jmp    8010936d <alltraps>

801099a6 <vector163>:
.globl vector163
vector163:
  pushl $0
801099a6:	6a 00                	push   $0x0
  pushl $163
801099a8:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801099ad:	e9 bb f9 ff ff       	jmp    8010936d <alltraps>

801099b2 <vector164>:
.globl vector164
vector164:
  pushl $0
801099b2:	6a 00                	push   $0x0
  pushl $164
801099b4:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801099b9:	e9 af f9 ff ff       	jmp    8010936d <alltraps>

801099be <vector165>:
.globl vector165
vector165:
  pushl $0
801099be:	6a 00                	push   $0x0
  pushl $165
801099c0:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801099c5:	e9 a3 f9 ff ff       	jmp    8010936d <alltraps>

801099ca <vector166>:
.globl vector166
vector166:
  pushl $0
801099ca:	6a 00                	push   $0x0
  pushl $166
801099cc:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801099d1:	e9 97 f9 ff ff       	jmp    8010936d <alltraps>

801099d6 <vector167>:
.globl vector167
vector167:
  pushl $0
801099d6:	6a 00                	push   $0x0
  pushl $167
801099d8:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801099dd:	e9 8b f9 ff ff       	jmp    8010936d <alltraps>

801099e2 <vector168>:
.globl vector168
vector168:
  pushl $0
801099e2:	6a 00                	push   $0x0
  pushl $168
801099e4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801099e9:	e9 7f f9 ff ff       	jmp    8010936d <alltraps>

801099ee <vector169>:
.globl vector169
vector169:
  pushl $0
801099ee:	6a 00                	push   $0x0
  pushl $169
801099f0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801099f5:	e9 73 f9 ff ff       	jmp    8010936d <alltraps>

801099fa <vector170>:
.globl vector170
vector170:
  pushl $0
801099fa:	6a 00                	push   $0x0
  pushl $170
801099fc:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80109a01:	e9 67 f9 ff ff       	jmp    8010936d <alltraps>

80109a06 <vector171>:
.globl vector171
vector171:
  pushl $0
80109a06:	6a 00                	push   $0x0
  pushl $171
80109a08:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80109a0d:	e9 5b f9 ff ff       	jmp    8010936d <alltraps>

80109a12 <vector172>:
.globl vector172
vector172:
  pushl $0
80109a12:	6a 00                	push   $0x0
  pushl $172
80109a14:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80109a19:	e9 4f f9 ff ff       	jmp    8010936d <alltraps>

80109a1e <vector173>:
.globl vector173
vector173:
  pushl $0
80109a1e:	6a 00                	push   $0x0
  pushl $173
80109a20:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80109a25:	e9 43 f9 ff ff       	jmp    8010936d <alltraps>

80109a2a <vector174>:
.globl vector174
vector174:
  pushl $0
80109a2a:	6a 00                	push   $0x0
  pushl $174
80109a2c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80109a31:	e9 37 f9 ff ff       	jmp    8010936d <alltraps>

80109a36 <vector175>:
.globl vector175
vector175:
  pushl $0
80109a36:	6a 00                	push   $0x0
  pushl $175
80109a38:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80109a3d:	e9 2b f9 ff ff       	jmp    8010936d <alltraps>

80109a42 <vector176>:
.globl vector176
vector176:
  pushl $0
80109a42:	6a 00                	push   $0x0
  pushl $176
80109a44:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80109a49:	e9 1f f9 ff ff       	jmp    8010936d <alltraps>

80109a4e <vector177>:
.globl vector177
vector177:
  pushl $0
80109a4e:	6a 00                	push   $0x0
  pushl $177
80109a50:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80109a55:	e9 13 f9 ff ff       	jmp    8010936d <alltraps>

80109a5a <vector178>:
.globl vector178
vector178:
  pushl $0
80109a5a:	6a 00                	push   $0x0
  pushl $178
80109a5c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80109a61:	e9 07 f9 ff ff       	jmp    8010936d <alltraps>

80109a66 <vector179>:
.globl vector179
vector179:
  pushl $0
80109a66:	6a 00                	push   $0x0
  pushl $179
80109a68:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80109a6d:	e9 fb f8 ff ff       	jmp    8010936d <alltraps>

80109a72 <vector180>:
.globl vector180
vector180:
  pushl $0
80109a72:	6a 00                	push   $0x0
  pushl $180
80109a74:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80109a79:	e9 ef f8 ff ff       	jmp    8010936d <alltraps>

80109a7e <vector181>:
.globl vector181
vector181:
  pushl $0
80109a7e:	6a 00                	push   $0x0
  pushl $181
80109a80:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80109a85:	e9 e3 f8 ff ff       	jmp    8010936d <alltraps>

80109a8a <vector182>:
.globl vector182
vector182:
  pushl $0
80109a8a:	6a 00                	push   $0x0
  pushl $182
80109a8c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80109a91:	e9 d7 f8 ff ff       	jmp    8010936d <alltraps>

80109a96 <vector183>:
.globl vector183
vector183:
  pushl $0
80109a96:	6a 00                	push   $0x0
  pushl $183
80109a98:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80109a9d:	e9 cb f8 ff ff       	jmp    8010936d <alltraps>

80109aa2 <vector184>:
.globl vector184
vector184:
  pushl $0
80109aa2:	6a 00                	push   $0x0
  pushl $184
80109aa4:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80109aa9:	e9 bf f8 ff ff       	jmp    8010936d <alltraps>

80109aae <vector185>:
.globl vector185
vector185:
  pushl $0
80109aae:	6a 00                	push   $0x0
  pushl $185
80109ab0:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80109ab5:	e9 b3 f8 ff ff       	jmp    8010936d <alltraps>

80109aba <vector186>:
.globl vector186
vector186:
  pushl $0
80109aba:	6a 00                	push   $0x0
  pushl $186
80109abc:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80109ac1:	e9 a7 f8 ff ff       	jmp    8010936d <alltraps>

80109ac6 <vector187>:
.globl vector187
vector187:
  pushl $0
80109ac6:	6a 00                	push   $0x0
  pushl $187
80109ac8:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80109acd:	e9 9b f8 ff ff       	jmp    8010936d <alltraps>

80109ad2 <vector188>:
.globl vector188
vector188:
  pushl $0
80109ad2:	6a 00                	push   $0x0
  pushl $188
80109ad4:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80109ad9:	e9 8f f8 ff ff       	jmp    8010936d <alltraps>

80109ade <vector189>:
.globl vector189
vector189:
  pushl $0
80109ade:	6a 00                	push   $0x0
  pushl $189
80109ae0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80109ae5:	e9 83 f8 ff ff       	jmp    8010936d <alltraps>

80109aea <vector190>:
.globl vector190
vector190:
  pushl $0
80109aea:	6a 00                	push   $0x0
  pushl $190
80109aec:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80109af1:	e9 77 f8 ff ff       	jmp    8010936d <alltraps>

80109af6 <vector191>:
.globl vector191
vector191:
  pushl $0
80109af6:	6a 00                	push   $0x0
  pushl $191
80109af8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80109afd:	e9 6b f8 ff ff       	jmp    8010936d <alltraps>

80109b02 <vector192>:
.globl vector192
vector192:
  pushl $0
80109b02:	6a 00                	push   $0x0
  pushl $192
80109b04:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80109b09:	e9 5f f8 ff ff       	jmp    8010936d <alltraps>

80109b0e <vector193>:
.globl vector193
vector193:
  pushl $0
80109b0e:	6a 00                	push   $0x0
  pushl $193
80109b10:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80109b15:	e9 53 f8 ff ff       	jmp    8010936d <alltraps>

80109b1a <vector194>:
.globl vector194
vector194:
  pushl $0
80109b1a:	6a 00                	push   $0x0
  pushl $194
80109b1c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80109b21:	e9 47 f8 ff ff       	jmp    8010936d <alltraps>

80109b26 <vector195>:
.globl vector195
vector195:
  pushl $0
80109b26:	6a 00                	push   $0x0
  pushl $195
80109b28:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80109b2d:	e9 3b f8 ff ff       	jmp    8010936d <alltraps>

80109b32 <vector196>:
.globl vector196
vector196:
  pushl $0
80109b32:	6a 00                	push   $0x0
  pushl $196
80109b34:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80109b39:	e9 2f f8 ff ff       	jmp    8010936d <alltraps>

80109b3e <vector197>:
.globl vector197
vector197:
  pushl $0
80109b3e:	6a 00                	push   $0x0
  pushl $197
80109b40:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80109b45:	e9 23 f8 ff ff       	jmp    8010936d <alltraps>

80109b4a <vector198>:
.globl vector198
vector198:
  pushl $0
80109b4a:	6a 00                	push   $0x0
  pushl $198
80109b4c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80109b51:	e9 17 f8 ff ff       	jmp    8010936d <alltraps>

80109b56 <vector199>:
.globl vector199
vector199:
  pushl $0
80109b56:	6a 00                	push   $0x0
  pushl $199
80109b58:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80109b5d:	e9 0b f8 ff ff       	jmp    8010936d <alltraps>

80109b62 <vector200>:
.globl vector200
vector200:
  pushl $0
80109b62:	6a 00                	push   $0x0
  pushl $200
80109b64:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80109b69:	e9 ff f7 ff ff       	jmp    8010936d <alltraps>

80109b6e <vector201>:
.globl vector201
vector201:
  pushl $0
80109b6e:	6a 00                	push   $0x0
  pushl $201
80109b70:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80109b75:	e9 f3 f7 ff ff       	jmp    8010936d <alltraps>

80109b7a <vector202>:
.globl vector202
vector202:
  pushl $0
80109b7a:	6a 00                	push   $0x0
  pushl $202
80109b7c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80109b81:	e9 e7 f7 ff ff       	jmp    8010936d <alltraps>

80109b86 <vector203>:
.globl vector203
vector203:
  pushl $0
80109b86:	6a 00                	push   $0x0
  pushl $203
80109b88:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80109b8d:	e9 db f7 ff ff       	jmp    8010936d <alltraps>

80109b92 <vector204>:
.globl vector204
vector204:
  pushl $0
80109b92:	6a 00                	push   $0x0
  pushl $204
80109b94:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80109b99:	e9 cf f7 ff ff       	jmp    8010936d <alltraps>

80109b9e <vector205>:
.globl vector205
vector205:
  pushl $0
80109b9e:	6a 00                	push   $0x0
  pushl $205
80109ba0:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80109ba5:	e9 c3 f7 ff ff       	jmp    8010936d <alltraps>

80109baa <vector206>:
.globl vector206
vector206:
  pushl $0
80109baa:	6a 00                	push   $0x0
  pushl $206
80109bac:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80109bb1:	e9 b7 f7 ff ff       	jmp    8010936d <alltraps>

80109bb6 <vector207>:
.globl vector207
vector207:
  pushl $0
80109bb6:	6a 00                	push   $0x0
  pushl $207
80109bb8:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80109bbd:	e9 ab f7 ff ff       	jmp    8010936d <alltraps>

80109bc2 <vector208>:
.globl vector208
vector208:
  pushl $0
80109bc2:	6a 00                	push   $0x0
  pushl $208
80109bc4:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80109bc9:	e9 9f f7 ff ff       	jmp    8010936d <alltraps>

80109bce <vector209>:
.globl vector209
vector209:
  pushl $0
80109bce:	6a 00                	push   $0x0
  pushl $209
80109bd0:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80109bd5:	e9 93 f7 ff ff       	jmp    8010936d <alltraps>

80109bda <vector210>:
.globl vector210
vector210:
  pushl $0
80109bda:	6a 00                	push   $0x0
  pushl $210
80109bdc:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80109be1:	e9 87 f7 ff ff       	jmp    8010936d <alltraps>

80109be6 <vector211>:
.globl vector211
vector211:
  pushl $0
80109be6:	6a 00                	push   $0x0
  pushl $211
80109be8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80109bed:	e9 7b f7 ff ff       	jmp    8010936d <alltraps>

80109bf2 <vector212>:
.globl vector212
vector212:
  pushl $0
80109bf2:	6a 00                	push   $0x0
  pushl $212
80109bf4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80109bf9:	e9 6f f7 ff ff       	jmp    8010936d <alltraps>

80109bfe <vector213>:
.globl vector213
vector213:
  pushl $0
80109bfe:	6a 00                	push   $0x0
  pushl $213
80109c00:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80109c05:	e9 63 f7 ff ff       	jmp    8010936d <alltraps>

80109c0a <vector214>:
.globl vector214
vector214:
  pushl $0
80109c0a:	6a 00                	push   $0x0
  pushl $214
80109c0c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80109c11:	e9 57 f7 ff ff       	jmp    8010936d <alltraps>

80109c16 <vector215>:
.globl vector215
vector215:
  pushl $0
80109c16:	6a 00                	push   $0x0
  pushl $215
80109c18:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80109c1d:	e9 4b f7 ff ff       	jmp    8010936d <alltraps>

80109c22 <vector216>:
.globl vector216
vector216:
  pushl $0
80109c22:	6a 00                	push   $0x0
  pushl $216
80109c24:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80109c29:	e9 3f f7 ff ff       	jmp    8010936d <alltraps>

80109c2e <vector217>:
.globl vector217
vector217:
  pushl $0
80109c2e:	6a 00                	push   $0x0
  pushl $217
80109c30:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80109c35:	e9 33 f7 ff ff       	jmp    8010936d <alltraps>

80109c3a <vector218>:
.globl vector218
vector218:
  pushl $0
80109c3a:	6a 00                	push   $0x0
  pushl $218
80109c3c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80109c41:	e9 27 f7 ff ff       	jmp    8010936d <alltraps>

80109c46 <vector219>:
.globl vector219
vector219:
  pushl $0
80109c46:	6a 00                	push   $0x0
  pushl $219
80109c48:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80109c4d:	e9 1b f7 ff ff       	jmp    8010936d <alltraps>

80109c52 <vector220>:
.globl vector220
vector220:
  pushl $0
80109c52:	6a 00                	push   $0x0
  pushl $220
80109c54:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80109c59:	e9 0f f7 ff ff       	jmp    8010936d <alltraps>

80109c5e <vector221>:
.globl vector221
vector221:
  pushl $0
80109c5e:	6a 00                	push   $0x0
  pushl $221
80109c60:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80109c65:	e9 03 f7 ff ff       	jmp    8010936d <alltraps>

80109c6a <vector222>:
.globl vector222
vector222:
  pushl $0
80109c6a:	6a 00                	push   $0x0
  pushl $222
80109c6c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80109c71:	e9 f7 f6 ff ff       	jmp    8010936d <alltraps>

80109c76 <vector223>:
.globl vector223
vector223:
  pushl $0
80109c76:	6a 00                	push   $0x0
  pushl $223
80109c78:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80109c7d:	e9 eb f6 ff ff       	jmp    8010936d <alltraps>

80109c82 <vector224>:
.globl vector224
vector224:
  pushl $0
80109c82:	6a 00                	push   $0x0
  pushl $224
80109c84:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80109c89:	e9 df f6 ff ff       	jmp    8010936d <alltraps>

80109c8e <vector225>:
.globl vector225
vector225:
  pushl $0
80109c8e:	6a 00                	push   $0x0
  pushl $225
80109c90:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80109c95:	e9 d3 f6 ff ff       	jmp    8010936d <alltraps>

80109c9a <vector226>:
.globl vector226
vector226:
  pushl $0
80109c9a:	6a 00                	push   $0x0
  pushl $226
80109c9c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80109ca1:	e9 c7 f6 ff ff       	jmp    8010936d <alltraps>

80109ca6 <vector227>:
.globl vector227
vector227:
  pushl $0
80109ca6:	6a 00                	push   $0x0
  pushl $227
80109ca8:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80109cad:	e9 bb f6 ff ff       	jmp    8010936d <alltraps>

80109cb2 <vector228>:
.globl vector228
vector228:
  pushl $0
80109cb2:	6a 00                	push   $0x0
  pushl $228
80109cb4:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80109cb9:	e9 af f6 ff ff       	jmp    8010936d <alltraps>

80109cbe <vector229>:
.globl vector229
vector229:
  pushl $0
80109cbe:	6a 00                	push   $0x0
  pushl $229
80109cc0:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80109cc5:	e9 a3 f6 ff ff       	jmp    8010936d <alltraps>

80109cca <vector230>:
.globl vector230
vector230:
  pushl $0
80109cca:	6a 00                	push   $0x0
  pushl $230
80109ccc:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80109cd1:	e9 97 f6 ff ff       	jmp    8010936d <alltraps>

80109cd6 <vector231>:
.globl vector231
vector231:
  pushl $0
80109cd6:	6a 00                	push   $0x0
  pushl $231
80109cd8:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80109cdd:	e9 8b f6 ff ff       	jmp    8010936d <alltraps>

80109ce2 <vector232>:
.globl vector232
vector232:
  pushl $0
80109ce2:	6a 00                	push   $0x0
  pushl $232
80109ce4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80109ce9:	e9 7f f6 ff ff       	jmp    8010936d <alltraps>

80109cee <vector233>:
.globl vector233
vector233:
  pushl $0
80109cee:	6a 00                	push   $0x0
  pushl $233
80109cf0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80109cf5:	e9 73 f6 ff ff       	jmp    8010936d <alltraps>

80109cfa <vector234>:
.globl vector234
vector234:
  pushl $0
80109cfa:	6a 00                	push   $0x0
  pushl $234
80109cfc:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109d01:	e9 67 f6 ff ff       	jmp    8010936d <alltraps>

80109d06 <vector235>:
.globl vector235
vector235:
  pushl $0
80109d06:	6a 00                	push   $0x0
  pushl $235
80109d08:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80109d0d:	e9 5b f6 ff ff       	jmp    8010936d <alltraps>

80109d12 <vector236>:
.globl vector236
vector236:
  pushl $0
80109d12:	6a 00                	push   $0x0
  pushl $236
80109d14:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80109d19:	e9 4f f6 ff ff       	jmp    8010936d <alltraps>

80109d1e <vector237>:
.globl vector237
vector237:
  pushl $0
80109d1e:	6a 00                	push   $0x0
  pushl $237
80109d20:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80109d25:	e9 43 f6 ff ff       	jmp    8010936d <alltraps>

80109d2a <vector238>:
.globl vector238
vector238:
  pushl $0
80109d2a:	6a 00                	push   $0x0
  pushl $238
80109d2c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109d31:	e9 37 f6 ff ff       	jmp    8010936d <alltraps>

80109d36 <vector239>:
.globl vector239
vector239:
  pushl $0
80109d36:	6a 00                	push   $0x0
  pushl $239
80109d38:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80109d3d:	e9 2b f6 ff ff       	jmp    8010936d <alltraps>

80109d42 <vector240>:
.globl vector240
vector240:
  pushl $0
80109d42:	6a 00                	push   $0x0
  pushl $240
80109d44:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80109d49:	e9 1f f6 ff ff       	jmp    8010936d <alltraps>

80109d4e <vector241>:
.globl vector241
vector241:
  pushl $0
80109d4e:	6a 00                	push   $0x0
  pushl $241
80109d50:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80109d55:	e9 13 f6 ff ff       	jmp    8010936d <alltraps>

80109d5a <vector242>:
.globl vector242
vector242:
  pushl $0
80109d5a:	6a 00                	push   $0x0
  pushl $242
80109d5c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80109d61:	e9 07 f6 ff ff       	jmp    8010936d <alltraps>

80109d66 <vector243>:
.globl vector243
vector243:
  pushl $0
80109d66:	6a 00                	push   $0x0
  pushl $243
80109d68:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80109d6d:	e9 fb f5 ff ff       	jmp    8010936d <alltraps>

80109d72 <vector244>:
.globl vector244
vector244:
  pushl $0
80109d72:	6a 00                	push   $0x0
  pushl $244
80109d74:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80109d79:	e9 ef f5 ff ff       	jmp    8010936d <alltraps>

80109d7e <vector245>:
.globl vector245
vector245:
  pushl $0
80109d7e:	6a 00                	push   $0x0
  pushl $245
80109d80:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80109d85:	e9 e3 f5 ff ff       	jmp    8010936d <alltraps>

80109d8a <vector246>:
.globl vector246
vector246:
  pushl $0
80109d8a:	6a 00                	push   $0x0
  pushl $246
80109d8c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80109d91:	e9 d7 f5 ff ff       	jmp    8010936d <alltraps>

80109d96 <vector247>:
.globl vector247
vector247:
  pushl $0
80109d96:	6a 00                	push   $0x0
  pushl $247
80109d98:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80109d9d:	e9 cb f5 ff ff       	jmp    8010936d <alltraps>

80109da2 <vector248>:
.globl vector248
vector248:
  pushl $0
80109da2:	6a 00                	push   $0x0
  pushl $248
80109da4:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80109da9:	e9 bf f5 ff ff       	jmp    8010936d <alltraps>

80109dae <vector249>:
.globl vector249
vector249:
  pushl $0
80109dae:	6a 00                	push   $0x0
  pushl $249
80109db0:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80109db5:	e9 b3 f5 ff ff       	jmp    8010936d <alltraps>

80109dba <vector250>:
.globl vector250
vector250:
  pushl $0
80109dba:	6a 00                	push   $0x0
  pushl $250
80109dbc:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80109dc1:	e9 a7 f5 ff ff       	jmp    8010936d <alltraps>

80109dc6 <vector251>:
.globl vector251
vector251:
  pushl $0
80109dc6:	6a 00                	push   $0x0
  pushl $251
80109dc8:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80109dcd:	e9 9b f5 ff ff       	jmp    8010936d <alltraps>

80109dd2 <vector252>:
.globl vector252
vector252:
  pushl $0
80109dd2:	6a 00                	push   $0x0
  pushl $252
80109dd4:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80109dd9:	e9 8f f5 ff ff       	jmp    8010936d <alltraps>

80109dde <vector253>:
.globl vector253
vector253:
  pushl $0
80109dde:	6a 00                	push   $0x0
  pushl $253
80109de0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80109de5:	e9 83 f5 ff ff       	jmp    8010936d <alltraps>

80109dea <vector254>:
.globl vector254
vector254:
  pushl $0
80109dea:	6a 00                	push   $0x0
  pushl $254
80109dec:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109df1:	e9 77 f5 ff ff       	jmp    8010936d <alltraps>

80109df6 <vector255>:
.globl vector255
vector255:
  pushl $0
80109df6:	6a 00                	push   $0x0
  pushl $255
80109df8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109dfd:	e9 6b f5 ff ff       	jmp    8010936d <alltraps>
80109e02:	66 90                	xchg   %ax,%ax

80109e04 <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
80109e04:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
80109e07:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80109e0a:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80109e0d:	b8 00 50 12 00       	mov    $0x125000,%eax
  movl    %eax, %cr3
80109e12:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
80109e15:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80109e18:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80109e1d:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(_boot_stack + KSTACKSIZES), %esp
80109e20:	bc d0 9b 12 80       	mov    $0x80129bd0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
80109e25:	b8 6c 78 10 80       	mov    $0x8010786c,%eax
  jmp *%eax
80109e2a:	ff e0                	jmp    *%eax

80109e2c <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
80109e2c:	52                   	push   %edx
    call *%ebx              # call fn
80109e2d:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
80109e2f:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
80109e30:	e8 23 f4 ff ff       	call   80109258 <do_exit>

80109e35 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80109e35:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80109e39:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80109e3d:	55                   	push   %ebp
  pushl %ebx
80109e3e:	53                   	push   %ebx
  pushl %esi
80109e3f:	56                   	push   %esi
  pushl %edi
80109e40:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80109e41:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80109e43:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80109e45:	5f                   	pop    %edi
  popl %esi
80109e46:	5e                   	pop    %esi
  popl %ebx
80109e47:	5b                   	pop    %ebx
  popl %ebp
80109e48:	5d                   	pop    %ebp
  ret
80109e49:	c3                   	ret    

80109e4a <print_int>:
#include "defs.h"
#include "stdarg.h"
#include "string.h"
#define CH_MAX 15
static void print_int(void (*putch)(char),int num, int base, int width, char epch)
{
80109e4a:	55                   	push   %ebp
80109e4b:	89 e5                	mov    %esp,%ebp
80109e4d:	83 ec 38             	sub    $0x38,%esp
80109e50:	8b 45 18             	mov    0x18(%ebp),%eax
80109e53:	88 45 d4             	mov    %al,-0x2c(%ebp)
    char strr[CH_MAX];
    char *str = strr;
80109e56:	8d 45 e1             	lea    -0x1f(%ebp),%eax
80109e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int len;
    itoa(num, str, base);
80109e5c:	83 ec 04             	sub    $0x4,%esp
80109e5f:	ff 75 10             	pushl  0x10(%ebp)
80109e62:	ff 75 f4             	pushl  -0xc(%ebp)
80109e65:	ff 75 0c             	pushl  0xc(%ebp)
80109e68:	e8 84 07 00 00       	call   8010a5f1 <itoa>
80109e6d:	83 c4 10             	add    $0x10,%esp
    len = strlen(str);
80109e70:	83 ec 0c             	sub    $0xc,%esp
80109e73:	ff 75 f4             	pushl  -0xc(%ebp)
80109e76:	e8 a7 02 00 00       	call   8010a122 <strlen>
80109e7b:	83 c4 10             	add    $0x10,%esp
80109e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(width > len)
80109e81:	eb 14                	jmp    80109e97 <print_int+0x4d>
    {
        putch(epch);
80109e83:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
80109e87:	83 ec 0c             	sub    $0xc,%esp
80109e8a:	50                   	push   %eax
80109e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80109e8e:	ff d0                	call   *%eax
80109e90:	83 c4 10             	add    $0x10,%esp
        width --;
80109e93:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
    char strr[CH_MAX];
    char *str = strr;
    int len;
    itoa(num, str, base);
    len = strlen(str);
    while(width > len)
80109e97:	8b 45 14             	mov    0x14(%ebp),%eax
80109e9a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109e9d:	7f e4                	jg     80109e83 <print_int+0x39>
    {
        putch(epch);
        width --;
    }
    while(*str != '\0')
80109e9f:	eb 19                	jmp    80109eba <print_int+0x70>
    {
        putch(*str);
80109ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ea4:	0f b6 00             	movzbl (%eax),%eax
80109ea7:	0f be c0             	movsbl %al,%eax
80109eaa:	83 ec 0c             	sub    $0xc,%esp
80109ead:	50                   	push   %eax
80109eae:	8b 45 08             	mov    0x8(%ebp),%eax
80109eb1:	ff d0                	call   *%eax
80109eb3:	83 c4 10             	add    $0x10,%esp
        str ++;
80109eb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while(width > len)
    {
        putch(epch);
        width --;
    }
    while(*str != '\0')
80109eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ebd:	0f b6 00             	movzbl (%eax),%eax
80109ec0:	84 c0                	test   %al,%al
80109ec2:	75 dd                	jne    80109ea1 <print_int+0x57>
    {
        putch(*str);
        str ++;
    }
}
80109ec4:	90                   	nop
80109ec5:	c9                   	leave  
80109ec6:	c3                   	ret    

80109ec7 <vprintfmt>:
int vprintfmt(void (*putch)(char), const char *fmt, va_list ap)
{
80109ec7:	55                   	push   %ebp
80109ec8:	89 e5                	mov    %esp,%ebp
80109eca:	83 ec 28             	sub    $0x28,%esp
    char ch;
    char *str;
    int len = 0;
80109ecd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    int num = 0;
80109ed4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    int width = 0;
80109edb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    char epch = ' ';
80109ee2:	c6 45 e7 20          	movb   $0x20,-0x19(%ebp)
    while((ch = *fmt) != '\0')
80109ee6:	e9 1c 02 00 00       	jmp    8010a107 <vprintfmt+0x240>
    {
       if(ch == '%' || width != 0 || epch != ' ')
80109eeb:	80 7d f7 25          	cmpb   $0x25,-0x9(%ebp)
80109eef:	74 10                	je     80109f01 <vprintfmt+0x3a>
80109ef1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109ef5:	75 0a                	jne    80109f01 <vprintfmt+0x3a>
80109ef7:	80 7d e7 20          	cmpb   $0x20,-0x19(%ebp)
80109efb:	0f 84 f2 01 00 00    	je     8010a0f3 <vprintfmt+0x22c>
       {
           if(width == 0 && epch == ' ')
80109f01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109f05:	75 13                	jne    80109f1a <vprintfmt+0x53>
80109f07:	80 7d e7 20          	cmpb   $0x20,-0x19(%ebp)
80109f0b:	75 0d                	jne    80109f1a <vprintfmt+0x53>
           {
               ch = *(++fmt);
80109f0d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80109f11:	8b 45 0c             	mov    0xc(%ebp),%eax
80109f14:	0f b6 00             	movzbl (%eax),%eax
80109f17:	88 45 f7             	mov    %al,-0x9(%ebp)
           }
           if(ch == '\0')
80109f1a:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
80109f1e:	0f 84 f8 01 00 00    	je     8010a11c <vprintfmt+0x255>
           {
               break;
           }

           switch(ch)
80109f24:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
80109f28:	83 f8 39             	cmp    $0x39,%eax
80109f2b:	7f 18                	jg     80109f45 <vprintfmt+0x7e>
80109f2d:	83 f8 31             	cmp    $0x31,%eax
80109f30:	7d 70                	jge    80109fa2 <vprintfmt+0xdb>
80109f32:	83 f8 25             	cmp    $0x25,%eax
80109f35:	0f 84 a4 01 00 00    	je     8010a0df <vprintfmt+0x218>
80109f3b:	83 f8 30             	cmp    $0x30,%eax
80109f3e:	74 34                	je     80109f74 <vprintfmt+0xad>
80109f40:	e9 a8 01 00 00       	jmp    8010a0ed <vprintfmt+0x226>
80109f45:	83 f8 64             	cmp    $0x64,%eax
80109f48:	74 77                	je     80109fc1 <vprintfmt+0xfa>
80109f4a:	83 f8 64             	cmp    $0x64,%eax
80109f4d:	7f 0e                	jg     80109f5d <vprintfmt+0x96>
80109f4f:	83 f8 63             	cmp    $0x63,%eax
80109f52:	0f 84 52 01 00 00    	je     8010a0aa <vprintfmt+0x1e3>
80109f58:	e9 90 01 00 00       	jmp    8010a0ed <vprintfmt+0x226>
80109f5d:	83 f8 73             	cmp    $0x73,%eax
80109f60:	0f 84 8f 00 00 00    	je     80109ff5 <vprintfmt+0x12e>
80109f66:	83 f8 78             	cmp    $0x78,%eax
80109f69:	0f 84 fa 00 00 00    	je     8010a069 <vprintfmt+0x1a2>
80109f6f:	e9 79 01 00 00       	jmp    8010a0ed <vprintfmt+0x226>
           {
               case '0':
                   if(width == 0)
80109f74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109f78:	75 09                	jne    80109f83 <vprintfmt+0xbc>
                   {
                       epch = '0';
80109f7a:	c6 45 e7 30          	movb   $0x30,-0x19(%ebp)
                   }else{
                       width = width * 10 +  ch - '0';
                   }
                   break;
80109f7e:	e9 6a 01 00 00       	jmp    8010a0ed <vprintfmt+0x226>
               case '0':
                   if(width == 0)
                   {
                       epch = '0';
                   }else{
                       width = width * 10 +  ch - '0';
80109f83:	8b 55 e8             	mov    -0x18(%ebp),%edx
80109f86:	89 d0                	mov    %edx,%eax
80109f88:	c1 e0 02             	shl    $0x2,%eax
80109f8b:	01 d0                	add    %edx,%eax
80109f8d:	01 c0                	add    %eax,%eax
80109f8f:	89 c2                	mov    %eax,%edx
80109f91:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
80109f95:	01 d0                	add    %edx,%eax
80109f97:	83 e8 30             	sub    $0x30,%eax
80109f9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
                   }
                   break;
80109f9d:	e9 4b 01 00 00       	jmp    8010a0ed <vprintfmt+0x226>
               case '1' ... '9':
                   width = width * 10 +  ch - '0';
80109fa2:	8b 55 e8             	mov    -0x18(%ebp),%edx
80109fa5:	89 d0                	mov    %edx,%eax
80109fa7:	c1 e0 02             	shl    $0x2,%eax
80109faa:	01 d0                	add    %edx,%eax
80109fac:	01 c0                	add    %eax,%eax
80109fae:	89 c2                	mov    %eax,%edx
80109fb0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
80109fb4:	01 d0                	add    %edx,%eax
80109fb6:	83 e8 30             	sub    $0x30,%eax
80109fb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
                   break;
80109fbc:	e9 2c 01 00 00       	jmp    8010a0ed <vprintfmt+0x226>
               case 'd' :
                   print_int(putch, va_arg(ap, int),10, width, epch);
80109fc1:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
80109fc5:	8b 45 10             	mov    0x10(%ebp),%eax
80109fc8:	8d 48 04             	lea    0x4(%eax),%ecx
80109fcb:	89 4d 10             	mov    %ecx,0x10(%ebp)
80109fce:	8b 00                	mov    (%eax),%eax
80109fd0:	83 ec 0c             	sub    $0xc,%esp
80109fd3:	52                   	push   %edx
80109fd4:	ff 75 e8             	pushl  -0x18(%ebp)
80109fd7:	6a 0a                	push   $0xa
80109fd9:	50                   	push   %eax
80109fda:	ff 75 08             	pushl  0x8(%ebp)
80109fdd:	e8 68 fe ff ff       	call   80109e4a <print_int>
80109fe2:	83 c4 20             	add    $0x20,%esp
                   width = 0;
80109fe5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   epch = ' ';
80109fec:	c6 45 e7 20          	movb   $0x20,-0x19(%ebp)
                   break;
80109ff0:	e9 f8 00 00 00       	jmp    8010a0ed <vprintfmt+0x226>
               case 's' :
                   str = va_arg(ap, char*);
80109ff5:	8b 45 10             	mov    0x10(%ebp),%eax
80109ff8:	8d 50 04             	lea    0x4(%eax),%edx
80109ffb:	89 55 10             	mov    %edx,0x10(%ebp)
80109ffe:	8b 00                	mov    (%eax),%eax
8010a000:	89 45 f0             	mov    %eax,-0x10(%ebp)
                   len = strlen(str);
8010a003:	83 ec 0c             	sub    $0xc,%esp
8010a006:	ff 75 f0             	pushl  -0x10(%ebp)
8010a009:	e8 14 01 00 00       	call   8010a122 <strlen>
8010a00e:	83 c4 10             	add    $0x10,%esp
8010a011:	89 45 e0             	mov    %eax,-0x20(%ebp)
                   while(width > len)
8010a014:	eb 14                	jmp    8010a02a <vprintfmt+0x163>
                   {
                       putch(epch);
8010a016:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
8010a01a:	83 ec 0c             	sub    $0xc,%esp
8010a01d:	50                   	push   %eax
8010a01e:	8b 45 08             	mov    0x8(%ebp),%eax
8010a021:	ff d0                	call   *%eax
8010a023:	83 c4 10             	add    $0x10,%esp
                       width --;
8010a026:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
                   epch = ' ';
                   break;
               case 's' :
                   str = va_arg(ap, char*);
                   len = strlen(str);
                   while(width > len)
8010a02a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a02d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010a030:	7f e4                	jg     8010a016 <vprintfmt+0x14f>
                   {
                       putch(epch);
                       width --;
                   }
                   while(*str != '\0') 
8010a032:	eb 1b                	jmp    8010a04f <vprintfmt+0x188>
                   {
                       putch(*str ++);
8010a034:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a037:	8d 50 01             	lea    0x1(%eax),%edx
8010a03a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010a03d:	0f b6 00             	movzbl (%eax),%eax
8010a040:	0f be c0             	movsbl %al,%eax
8010a043:	83 ec 0c             	sub    $0xc,%esp
8010a046:	50                   	push   %eax
8010a047:	8b 45 08             	mov    0x8(%ebp),%eax
8010a04a:	ff d0                	call   *%eax
8010a04c:	83 c4 10             	add    $0x10,%esp
                   while(width > len)
                   {
                       putch(epch);
                       width --;
                   }
                   while(*str != '\0') 
8010a04f:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a052:	0f b6 00             	movzbl (%eax),%eax
8010a055:	84 c0                	test   %al,%al
8010a057:	75 db                	jne    8010a034 <vprintfmt+0x16d>
                   {
                       putch(*str ++);
                   }
                   width = 0;
8010a059:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   epch = ' ';
8010a060:	c6 45 e7 20          	movb   $0x20,-0x19(%ebp)
                   break;
8010a064:	e9 84 00 00 00       	jmp    8010a0ed <vprintfmt+0x226>
               case 'x' :
                   print_int(putch, va_arg(ap,int), 16, width, epch);
8010a069:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
8010a06d:	8b 45 10             	mov    0x10(%ebp),%eax
8010a070:	8d 48 04             	lea    0x4(%eax),%ecx
8010a073:	89 4d 10             	mov    %ecx,0x10(%ebp)
8010a076:	8b 00                	mov    (%eax),%eax
8010a078:	83 ec 0c             	sub    $0xc,%esp
8010a07b:	52                   	push   %edx
8010a07c:	ff 75 e8             	pushl  -0x18(%ebp)
8010a07f:	6a 10                	push   $0x10
8010a081:	50                   	push   %eax
8010a082:	ff 75 08             	pushl  0x8(%ebp)
8010a085:	e8 c0 fd ff ff       	call   80109e4a <print_int>
8010a08a:	83 c4 20             	add    $0x20,%esp
                   width = 0;
8010a08d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   epch = ' ';
8010a094:	c6 45 e7 20          	movb   $0x20,-0x19(%ebp)
                   break;
8010a098:	eb 53                	jmp    8010a0ed <vprintfmt+0x226>
               case 'c' :
                   while(width-- > 1)
                   {
                       putch(epch);
8010a09a:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
8010a09e:	83 ec 0c             	sub    $0xc,%esp
8010a0a1:	50                   	push   %eax
8010a0a2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0a5:	ff d0                	call   *%eax
8010a0a7:	83 c4 10             	add    $0x10,%esp
                   print_int(putch, va_arg(ap,int), 16, width, epch);
                   width = 0;
                   epch = ' ';
                   break;
               case 'c' :
                   while(width-- > 1)
8010a0aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a0ad:	8d 50 ff             	lea    -0x1(%eax),%edx
8010a0b0:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010a0b3:	83 f8 01             	cmp    $0x1,%eax
8010a0b6:	7f e2                	jg     8010a09a <vprintfmt+0x1d3>
                   {
                       putch(epch);
                   }
                   putch(va_arg(ap,int));
8010a0b8:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0bb:	8d 50 04             	lea    0x4(%eax),%edx
8010a0be:	89 55 10             	mov    %edx,0x10(%ebp)
8010a0c1:	8b 00                	mov    (%eax),%eax
8010a0c3:	0f be c0             	movsbl %al,%eax
8010a0c6:	83 ec 0c             	sub    $0xc,%esp
8010a0c9:	50                   	push   %eax
8010a0ca:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0cd:	ff d0                	call   *%eax
8010a0cf:	83 c4 10             	add    $0x10,%esp
                   width = 0;
8010a0d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   epch = ' ';
8010a0d9:	c6 45 e7 20          	movb   $0x20,-0x19(%ebp)
                   break;
8010a0dd:	eb 0e                	jmp    8010a0ed <vprintfmt+0x226>
               case '%' :
                   putch('%');
8010a0df:	83 ec 0c             	sub    $0xc,%esp
8010a0e2:	6a 25                	push   $0x25
8010a0e4:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0e7:	ff d0                	call   *%eax
8010a0e9:	83 c4 10             	add    $0x10,%esp
                   break;
8010a0ec:	90                   	nop
               default:
                   ;
           }
           num ++;
8010a0ed:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a0f1:	eb 10                	jmp    8010a103 <vprintfmt+0x23c>
       }else{
           putch(ch);
8010a0f3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
8010a0f7:	83 ec 0c             	sub    $0xc,%esp
8010a0fa:	50                   	push   %eax
8010a0fb:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0fe:	ff d0                	call   *%eax
8010a100:	83 c4 10             	add    $0x10,%esp
       }
       fmt ++;
8010a103:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    char *str;
    int len = 0;
    int num = 0;
    int width = 0;
    char epch = ' ';
    while((ch = *fmt) != '\0')
8010a107:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a10a:	0f b6 00             	movzbl (%eax),%eax
8010a10d:	88 45 f7             	mov    %al,-0x9(%ebp)
8010a110:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
8010a114:	0f 85 d1 fd ff ff    	jne    80109eeb <vprintfmt+0x24>
8010a11a:	eb 01                	jmp    8010a11d <vprintfmt+0x256>
           {
               ch = *(++fmt);
           }
           if(ch == '\0')
           {
               break;
8010a11c:	90                   	nop
       }else{
           putch(ch);
       }
       fmt ++;
    }
    return num;
8010a11d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010a120:	c9                   	leave  
8010a121:	c3                   	ret    

8010a122 <strlen>:
 * @s   the input string
 * Return:  the length of string @s
 */
size_t 
strlen(const char *s)
{
8010a122:	55                   	push   %ebp
8010a123:	89 e5                	mov    %esp,%ebp
8010a125:	83 ec 10             	sub    $0x10,%esp
    size_t n = 0;
8010a128:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s ++ != '\0')
8010a12f:	eb 04                	jmp    8010a135 <strlen+0x13>
    {
        n ++;
8010a131:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 */
size_t 
strlen(const char *s)
{
    size_t n = 0;
    while(*s ++ != '\0')
8010a135:	8b 45 08             	mov    0x8(%ebp),%eax
8010a138:	8d 50 01             	lea    0x1(%eax),%edx
8010a13b:	89 55 08             	mov    %edx,0x8(%ebp)
8010a13e:	0f b6 00             	movzbl (%eax),%eax
8010a141:	84 c0                	test   %al,%al
8010a143:	75 ec                	jne    8010a131 <strlen+0xf>
    {
        n ++;
    }
    return n;
8010a145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a148:	c9                   	leave  
8010a149:	c3                   	ret    

8010a14a <strnlen>:
/*
 * calculate the length of the string @s,stop when it meet '\0' character, but at most @len
 */
size_t
strnlen(const char *s, size_t len)
{
8010a14a:	55                   	push   %ebp
8010a14b:	89 e5                	mov    %esp,%ebp
8010a14d:	83 ec 10             	sub    $0x10,%esp
  size_t cnt = 0;  
8010a150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while( cnt < len && *s ++ != '\0')
8010a157:	eb 04                	jmp    8010a15d <strnlen+0x13>
  {
      cnt ++;
8010a159:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 */
size_t
strnlen(const char *s, size_t len)
{
  size_t cnt = 0;  
  while( cnt < len && *s ++ != '\0')
8010a15d:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a160:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010a163:	73 10                	jae    8010a175 <strnlen+0x2b>
8010a165:	8b 45 08             	mov    0x8(%ebp),%eax
8010a168:	8d 50 01             	lea    0x1(%eax),%edx
8010a16b:	89 55 08             	mov    %edx,0x8(%ebp)
8010a16e:	0f b6 00             	movzbl (%eax),%eax
8010a171:	84 c0                	test   %al,%al
8010a173:	75 e4                	jne    8010a159 <strnlen+0xf>
  {
      cnt ++;
  }
  return cnt;
8010a175:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a178:	c9                   	leave  
8010a179:	c3                   	ret    

8010a17a <strcpy>:
/*
 * copies the string pointed by @src into the array pointed by @dst.
 */
char*
strcpy(char *dst, const char *src)
{
8010a17a:	55                   	push   %ebp
8010a17b:	89 e5                	mov    %esp,%ebp
8010a17d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
8010a180:	8b 45 08             	mov    0x8(%ebp),%eax
8010a183:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while((*p ++ = *src ++) != '\0')
8010a186:	90                   	nop
8010a187:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a18a:	8d 50 01             	lea    0x1(%eax),%edx
8010a18d:	89 55 fc             	mov    %edx,-0x4(%ebp)
8010a190:	8b 55 0c             	mov    0xc(%ebp),%edx
8010a193:	8d 4a 01             	lea    0x1(%edx),%ecx
8010a196:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010a199:	0f b6 12             	movzbl (%edx),%edx
8010a19c:	88 10                	mov    %dl,(%eax)
8010a19e:	0f b6 00             	movzbl (%eax),%eax
8010a1a1:	84 c0                	test   %al,%al
8010a1a3:	75 e2                	jne    8010a187 <strcpy+0xd>
        ;
    return dst;
8010a1a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010a1a8:	c9                   	leave  
8010a1a9:	c3                   	ret    

8010a1aa <strncpy>:
 * copies the string pointed by @src into the array pointed by @dst, but at most @len.
 * if found character '\0' before @len characters, it won't copy any characters.
 */
char*
strncpy(char *dst, const char *src, size_t len)
{
8010a1aa:	55                   	push   %ebp
8010a1ab:	89 e5                	mov    %esp,%ebp
8010a1ad:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
8010a1b0:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(len > 0)
8010a1b6:	eb 21                	jmp    8010a1d9 <strncpy+0x2f>
    {
       if((*p = *src) != '\0')
8010a1b8:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a1bb:	0f b6 10             	movzbl (%eax),%edx
8010a1be:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a1c1:	88 10                	mov    %dl,(%eax)
8010a1c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a1c6:	0f b6 00             	movzbl (%eax),%eax
8010a1c9:	84 c0                	test   %al,%al
8010a1cb:	74 14                	je     8010a1e1 <strncpy+0x37>
       {
           src ++;
8010a1cd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
           p ++;
8010a1d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
           len --;
8010a1d5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 */
char*
strncpy(char *dst, const char *src, size_t len)
{
    char *p = dst;
    while(len > 0)
8010a1d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010a1dd:	75 d9                	jne    8010a1b8 <strncpy+0xe>
8010a1df:	eb 01                	jmp    8010a1e2 <strncpy+0x38>
       {
           src ++;
           p ++;
           len --;
       }else{
           break;
8010a1e1:	90                   	nop
       }

    }
    return dst;
8010a1e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010a1e5:	c9                   	leave  
8010a1e6:	c3                   	ret    

8010a1e7 <strcmp>:
/*
 * compares the string @s1 and @s2.
 */
int
strcmp(const char *s1, const char *s2)
{
8010a1e7:	55                   	push   %ebp
8010a1e8:	89 e5                	mov    %esp,%ebp
    while(*s2 != '\0' && *s2 != '\0')
8010a1ea:	eb 18                	jmp    8010a204 <strcmp+0x1d>
    {
        if(*s1 != *s2)
8010a1ec:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1ef:	0f b6 10             	movzbl (%eax),%edx
8010a1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a1f5:	0f b6 00             	movzbl (%eax),%eax
8010a1f8:	38 c2                	cmp    %al,%dl
8010a1fa:	75 1e                	jne    8010a21a <strcmp+0x33>
        {
            break;
        }
        s1 ++;
8010a1fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        s2 ++;
8010a200:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * compares the string @s1 and @s2.
 */
int
strcmp(const char *s1, const char *s2)
{
    while(*s2 != '\0' && *s2 != '\0')
8010a204:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a207:	0f b6 00             	movzbl (%eax),%eax
8010a20a:	84 c0                	test   %al,%al
8010a20c:	74 0d                	je     8010a21b <strcmp+0x34>
8010a20e:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a211:	0f b6 00             	movzbl (%eax),%eax
8010a214:	84 c0                	test   %al,%al
8010a216:	75 d4                	jne    8010a1ec <strcmp+0x5>
8010a218:	eb 01                	jmp    8010a21b <strcmp+0x34>
    {
        if(*s1 != *s2)
        {
            break;
8010a21a:	90                   	nop
        }
        s1 ++;
        s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
8010a21b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a21e:	0f b6 00             	movzbl (%eax),%eax
8010a221:	0f b6 d0             	movzbl %al,%edx
8010a224:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a227:	0f b6 00             	movzbl (%eax),%eax
8010a22a:	0f b6 c0             	movzbl %al,%eax
8010a22d:	29 c2                	sub    %eax,%edx
8010a22f:	89 d0                	mov    %edx,%eax
}
8010a231:	5d                   	pop    %ebp
8010a232:	c3                   	ret    

8010a233 <strncmp>:
 * if found character '\0' before @len characters, it won't copy any characters.
 * but at most @n.
 */
int
strncmp(const char *s1, const char *s2, size_t n)
{
8010a233:	55                   	push   %ebp
8010a234:	89 e5                	mov    %esp,%ebp
    while(n > 0 && *s1 != '\0' && *s1 == *s2)
8010a236:	eb 0c                	jmp    8010a244 <strncmp+0x11>
    {
        n --, s1 ++ ,s2 ++;
8010a238:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010a23c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010a240:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * but at most @n.
 */
int
strncmp(const char *s1, const char *s2, size_t n)
{
    while(n > 0 && *s1 != '\0' && *s1 == *s2)
8010a244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010a248:	74 1a                	je     8010a264 <strncmp+0x31>
8010a24a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a24d:	0f b6 00             	movzbl (%eax),%eax
8010a250:	84 c0                	test   %al,%al
8010a252:	74 10                	je     8010a264 <strncmp+0x31>
8010a254:	8b 45 08             	mov    0x8(%ebp),%eax
8010a257:	0f b6 10             	movzbl (%eax),%edx
8010a25a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a25d:	0f b6 00             	movzbl (%eax),%eax
8010a260:	38 c2                	cmp    %al,%dl
8010a262:	74 d4                	je     8010a238 <strncmp+0x5>
    {
        n --, s1 ++ ,s2 ++;
    }
    return n == 0 ? 0 : ((int)((unsigned char)*s1 - (unsigned char)*s2));
8010a264:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010a268:	74 18                	je     8010a282 <strncmp+0x4f>
8010a26a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a26d:	0f b6 00             	movzbl (%eax),%eax
8010a270:	0f b6 d0             	movzbl %al,%edx
8010a273:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a276:	0f b6 00             	movzbl (%eax),%eax
8010a279:	0f b6 c0             	movzbl %al,%eax
8010a27c:	29 c2                	sub    %eax,%edx
8010a27e:	89 d0                	mov    %edx,%eax
8010a280:	eb 05                	jmp    8010a287 <strncmp+0x54>
8010a282:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a287:	5d                   	pop    %ebp
8010a288:	c3                   	ret    

8010a289 <strchr>:
/*
 * locates first occurrence of character in string.
 */
char*
strchr(const char *s, char c)
{
8010a289:	55                   	push   %ebp
8010a28a:	89 e5                	mov    %esp,%ebp
8010a28c:	83 ec 04             	sub    $0x4,%esp
8010a28f:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a292:	88 45 fc             	mov    %al,-0x4(%ebp)
    while(*s != '\0')
8010a295:	eb 14                	jmp    8010a2ab <strchr+0x22>
    {
        if(*s == c)
8010a297:	8b 45 08             	mov    0x8(%ebp),%eax
8010a29a:	0f b6 00             	movzbl (%eax),%eax
8010a29d:	3a 45 fc             	cmp    -0x4(%ebp),%al
8010a2a0:	75 05                	jne    8010a2a7 <strchr+0x1e>
        {
            return (char*)s;
8010a2a2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2a5:	eb 13                	jmp    8010a2ba <strchr+0x31>
        }
        s ++;
8010a2a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * locates first occurrence of character in string.
 */
char*
strchr(const char *s, char c)
{
    while(*s != '\0')
8010a2ab:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2ae:	0f b6 00             	movzbl (%eax),%eax
8010a2b1:	84 c0                	test   %al,%al
8010a2b3:	75 e2                	jne    8010a297 <strchr+0xe>
        {
            return (char*)s;
        }
        s ++;
    }
    return NULL;
8010a2b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a2ba:	c9                   	leave  
8010a2bb:	c3                   	ret    

8010a2bc <strfind>:
/*
 * locates first occurrence of character in string ,but it returns the end of character instead of character NULL.
 */
char*
strfind(const char *s, char c)
{
8010a2bc:	55                   	push   %ebp
8010a2bd:	89 e5                	mov    %esp,%ebp
8010a2bf:	83 ec 04             	sub    $0x4,%esp
8010a2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a2c5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while(*s != '\0')
8010a2c8:	eb 0f                	jmp    8010a2d9 <strfind+0x1d>
    {
        if(*s == c)
8010a2ca:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2cd:	0f b6 00             	movzbl (%eax),%eax
8010a2d0:	3a 45 fc             	cmp    -0x4(%ebp),%al
8010a2d3:	74 10                	je     8010a2e5 <strfind+0x29>
        {
            break;
        }
        s ++;
8010a2d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * locates first occurrence of character in string ,but it returns the end of character instead of character NULL.
 */
char*
strfind(const char *s, char c)
{
    while(*s != '\0')
8010a2d9:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2dc:	0f b6 00             	movzbl (%eax),%eax
8010a2df:	84 c0                	test   %al,%al
8010a2e1:	75 e7                	jne    8010a2ca <strfind+0xe>
8010a2e3:	eb 01                	jmp    8010a2e6 <strfind+0x2a>
    {
        if(*s == c)
        {
            break;
8010a2e5:	90                   	nop
        }
        s ++;
    }
    return (char*)s;
8010a2e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010a2e9:	c9                   	leave  
8010a2ea:	c3                   	ret    

8010a2eb <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
8010a2eb:	55                   	push   %ebp
8010a2ec:	89 e5                	mov    %esp,%ebp
8010a2ee:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
8010a2f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
8010a2f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
8010a2ff:	eb 04                	jmp    8010a305 <strtol+0x1a>
        s ++;
8010a301:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
8010a305:	8b 45 08             	mov    0x8(%ebp),%eax
8010a308:	0f b6 00             	movzbl (%eax),%eax
8010a30b:	3c 20                	cmp    $0x20,%al
8010a30d:	74 f2                	je     8010a301 <strtol+0x16>
8010a30f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a312:	0f b6 00             	movzbl (%eax),%eax
8010a315:	3c 09                	cmp    $0x9,%al
8010a317:	74 e8                	je     8010a301 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
8010a319:	8b 45 08             	mov    0x8(%ebp),%eax
8010a31c:	0f b6 00             	movzbl (%eax),%eax
8010a31f:	3c 2b                	cmp    $0x2b,%al
8010a321:	75 06                	jne    8010a329 <strtol+0x3e>
        s ++;
8010a323:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010a327:	eb 15                	jmp    8010a33e <strtol+0x53>
    }
    else if (*s == '-') {
8010a329:	8b 45 08             	mov    0x8(%ebp),%eax
8010a32c:	0f b6 00             	movzbl (%eax),%eax
8010a32f:	3c 2d                	cmp    $0x2d,%al
8010a331:	75 0b                	jne    8010a33e <strtol+0x53>
        s ++, neg = 1;
8010a333:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010a337:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
8010a33e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010a342:	74 06                	je     8010a34a <strtol+0x5f>
8010a344:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
8010a348:	75 24                	jne    8010a36e <strtol+0x83>
8010a34a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a34d:	0f b6 00             	movzbl (%eax),%eax
8010a350:	3c 30                	cmp    $0x30,%al
8010a352:	75 1a                	jne    8010a36e <strtol+0x83>
8010a354:	8b 45 08             	mov    0x8(%ebp),%eax
8010a357:	83 c0 01             	add    $0x1,%eax
8010a35a:	0f b6 00             	movzbl (%eax),%eax
8010a35d:	3c 78                	cmp    $0x78,%al
8010a35f:	75 0d                	jne    8010a36e <strtol+0x83>
        s += 2, base = 16;
8010a361:	83 45 08 02          	addl   $0x2,0x8(%ebp)
8010a365:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
8010a36c:	eb 2a                	jmp    8010a398 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
8010a36e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010a372:	75 17                	jne    8010a38b <strtol+0xa0>
8010a374:	8b 45 08             	mov    0x8(%ebp),%eax
8010a377:	0f b6 00             	movzbl (%eax),%eax
8010a37a:	3c 30                	cmp    $0x30,%al
8010a37c:	75 0d                	jne    8010a38b <strtol+0xa0>
        s ++, base = 8;
8010a37e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010a382:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
8010a389:	eb 0d                	jmp    8010a398 <strtol+0xad>
    }
    else if (base == 0) {
8010a38b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010a38f:	75 07                	jne    8010a398 <strtol+0xad>
        base = 10;
8010a391:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
8010a398:	8b 45 08             	mov    0x8(%ebp),%eax
8010a39b:	0f b6 00             	movzbl (%eax),%eax
8010a39e:	3c 2f                	cmp    $0x2f,%al
8010a3a0:	7e 1b                	jle    8010a3bd <strtol+0xd2>
8010a3a2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3a5:	0f b6 00             	movzbl (%eax),%eax
8010a3a8:	3c 39                	cmp    $0x39,%al
8010a3aa:	7f 11                	jg     8010a3bd <strtol+0xd2>
            dig = *s - '0';
8010a3ac:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3af:	0f b6 00             	movzbl (%eax),%eax
8010a3b2:	0f be c0             	movsbl %al,%eax
8010a3b5:	83 e8 30             	sub    $0x30,%eax
8010a3b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010a3bb:	eb 48                	jmp    8010a405 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
8010a3bd:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3c0:	0f b6 00             	movzbl (%eax),%eax
8010a3c3:	3c 60                	cmp    $0x60,%al
8010a3c5:	7e 1b                	jle    8010a3e2 <strtol+0xf7>
8010a3c7:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3ca:	0f b6 00             	movzbl (%eax),%eax
8010a3cd:	3c 7a                	cmp    $0x7a,%al
8010a3cf:	7f 11                	jg     8010a3e2 <strtol+0xf7>
            dig = *s - 'a' + 10;
8010a3d1:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3d4:	0f b6 00             	movzbl (%eax),%eax
8010a3d7:	0f be c0             	movsbl %al,%eax
8010a3da:	83 e8 57             	sub    $0x57,%eax
8010a3dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010a3e0:	eb 23                	jmp    8010a405 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
8010a3e2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3e5:	0f b6 00             	movzbl (%eax),%eax
8010a3e8:	3c 40                	cmp    $0x40,%al
8010a3ea:	7e 3c                	jle    8010a428 <strtol+0x13d>
8010a3ec:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3ef:	0f b6 00             	movzbl (%eax),%eax
8010a3f2:	3c 5a                	cmp    $0x5a,%al
8010a3f4:	7f 32                	jg     8010a428 <strtol+0x13d>
            dig = *s - 'A' + 10;
8010a3f6:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3f9:	0f b6 00             	movzbl (%eax),%eax
8010a3fc:	0f be c0             	movsbl %al,%eax
8010a3ff:	83 e8 37             	sub    $0x37,%eax
8010a402:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
8010a405:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a408:	3b 45 10             	cmp    0x10(%ebp),%eax
8010a40b:	7d 1a                	jge    8010a427 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
8010a40d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010a411:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a414:	0f af 45 10          	imul   0x10(%ebp),%eax
8010a418:	89 c2                	mov    %eax,%edx
8010a41a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a41d:	01 d0                	add    %edx,%eax
8010a41f:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
8010a422:	e9 71 ff ff ff       	jmp    8010a398 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
8010a427:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
8010a428:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010a42c:	74 08                	je     8010a436 <strtol+0x14b>
        *endptr = (char *) s;
8010a42e:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a431:	8b 55 08             	mov    0x8(%ebp),%edx
8010a434:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
8010a436:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010a43a:	74 07                	je     8010a443 <strtol+0x158>
8010a43c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a43f:	f7 d8                	neg    %eax
8010a441:	eb 03                	jmp    8010a446 <strtol+0x15b>
8010a443:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010a446:	c9                   	leave  
8010a447:	c3                   	ret    

8010a448 <memset>:
 * sets the first @n bytes of the memory area pointed by @s
 * to the specified value @c.
 */
void*
memset(void *s, char c, size_t n)
{
8010a448:	55                   	push   %ebp
8010a449:	89 e5                	mov    %esp,%ebp
8010a44b:	83 ec 14             	sub    $0x14,%esp
8010a44e:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a451:	88 45 ec             	mov    %al,-0x14(%ebp)
    char *p = s;
8010a454:	8b 45 08             	mov    0x8(%ebp),%eax
8010a457:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(n > 0)
8010a45a:	eb 13                	jmp    8010a46f <memset+0x27>
    {
        *p ++ = c;
8010a45c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a45f:	8d 50 01             	lea    0x1(%eax),%edx
8010a462:	89 55 fc             	mov    %edx,-0x4(%ebp)
8010a465:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
8010a469:	88 10                	mov    %dl,(%eax)
        n --;
8010a46b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 */
void*
memset(void *s, char c, size_t n)
{
    char *p = s;
    while(n > 0)
8010a46f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010a473:	75 e7                	jne    8010a45c <memset+0x14>
    {
        *p ++ = c;
        n --;
    }
    return s;
8010a475:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010a478:	c9                   	leave  
8010a479:	c3                   	ret    

8010a47a <memmove>:
 * copies the values of @n bytes from the location pointed by @src to
 * the memory area pointed by @dst. @src and @dst are allowed to overlap.
 */
void*
memmove(void *dst, const void *src, size_t n)
{
8010a47a:	55                   	push   %ebp
8010a47b:	89 e5                	mov    %esp,%ebp
8010a47d:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
8010a480:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a483:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
8010a486:	8b 45 08             	mov    0x8(%ebp),%eax
8010a489:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
8010a48c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a48f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010a492:	73 54                	jae    8010a4e8 <memmove+0x6e>
8010a494:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a497:	8b 45 10             	mov    0x10(%ebp),%eax
8010a49a:	01 d0                	add    %edx,%eax
8010a49c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010a49f:	76 47                	jbe    8010a4e8 <memmove+0x6e>
        s += n, d += n;
8010a4a1:	8b 45 10             	mov    0x10(%ebp),%eax
8010a4a4:	01 45 fc             	add    %eax,-0x4(%ebp)
8010a4a7:	8b 45 10             	mov    0x10(%ebp),%eax
8010a4aa:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
8010a4ad:	eb 13                	jmp    8010a4c2 <memmove+0x48>
            *-- d = *-- s;
8010a4af:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010a4b3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010a4b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a4ba:	0f b6 10             	movzbl (%eax),%edx
8010a4bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a4c0:	88 10                	mov    %dl,(%eax)
{
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
8010a4c2:	8b 45 10             	mov    0x10(%ebp),%eax
8010a4c5:	8d 50 ff             	lea    -0x1(%eax),%edx
8010a4c8:	89 55 10             	mov    %edx,0x10(%ebp)
8010a4cb:	85 c0                	test   %eax,%eax
8010a4cd:	75 e0                	jne    8010a4af <memmove+0x35>
void*
memmove(void *dst, const void *src, size_t n)
{
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
8010a4cf:	eb 24                	jmp    8010a4f5 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
8010a4d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a4d4:	8d 50 01             	lea    0x1(%eax),%edx
8010a4d7:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010a4da:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a4dd:	8d 4a 01             	lea    0x1(%edx),%ecx
8010a4e0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010a4e3:	0f b6 12             	movzbl (%edx),%edx
8010a4e6:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
8010a4e8:	8b 45 10             	mov    0x10(%ebp),%eax
8010a4eb:	8d 50 ff             	lea    -0x1(%eax),%edx
8010a4ee:	89 55 10             	mov    %edx,0x10(%ebp)
8010a4f1:	85 c0                	test   %eax,%eax
8010a4f3:	75 dc                	jne    8010a4d1 <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
8010a4f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010a4f8:	c9                   	leave  
8010a4f9:	c3                   	ret    

8010a4fa <memcpy>:
 * copies the value of @n bytes from the location pointed by @src to
 * the memory area pointed by @dst.
 */
void*
memcpy(void *dst, const void *src, size_t n)
{
8010a4fa:	55                   	push   %ebp
8010a4fb:	89 e5                	mov    %esp,%ebp
8010a4fd:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
8010a500:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a503:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
8010a506:	8b 45 08             	mov    0x8(%ebp),%eax
8010a509:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
8010a50c:	eb 17                	jmp    8010a525 <memcpy+0x2b>
        *d ++ = *s ++;
8010a50e:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a511:	8d 50 01             	lea    0x1(%eax),%edx
8010a514:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010a517:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a51a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010a51d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010a520:	0f b6 12             	movzbl (%edx),%edx
8010a523:	88 10                	mov    %dl,(%eax)
void*
memcpy(void *dst, const void *src, size_t n)
{
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
8010a525:	8b 45 10             	mov    0x10(%ebp),%eax
8010a528:	8d 50 ff             	lea    -0x1(%eax),%edx
8010a52b:	89 55 10             	mov    %edx,0x10(%ebp)
8010a52e:	85 c0                	test   %eax,%eax
8010a530:	75 dc                	jne    8010a50e <memcpy+0x14>
        *d ++ = *s ++;
    }
    return dst;
8010a532:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010a535:	c9                   	leave  
8010a536:	c3                   	ret    

8010a537 <memcmp>:
/*
 * compares two blocks of memory
 */
int
memcmp(const void *v1, const void *v2, size_t n)
{
8010a537:	55                   	push   %ebp
8010a538:	89 e5                	mov    %esp,%ebp
8010a53a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
8010a53d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a540:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
8010a543:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a546:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
8010a549:	eb 30                	jmp    8010a57b <memcmp+0x44>
        if (*s1 != *s2) {
8010a54b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a54e:	0f b6 10             	movzbl (%eax),%edx
8010a551:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a554:	0f b6 00             	movzbl (%eax),%eax
8010a557:	38 c2                	cmp    %al,%dl
8010a559:	74 18                	je     8010a573 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
8010a55b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a55e:	0f b6 00             	movzbl (%eax),%eax
8010a561:	0f b6 d0             	movzbl %al,%edx
8010a564:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a567:	0f b6 00             	movzbl (%eax),%eax
8010a56a:	0f b6 c0             	movzbl %al,%eax
8010a56d:	29 c2                	sub    %eax,%edx
8010a56f:	89 d0                	mov    %edx,%eax
8010a571:	eb 1a                	jmp    8010a58d <memcmp+0x56>
        }
        s1 ++, s2 ++;
8010a573:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010a577:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
int
memcmp(const void *v1, const void *v2, size_t n)
{
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
8010a57b:	8b 45 10             	mov    0x10(%ebp),%eax
8010a57e:	8d 50 ff             	lea    -0x1(%eax),%edx
8010a581:	89 55 10             	mov    %edx,0x10(%ebp)
8010a584:	85 c0                	test   %eax,%eax
8010a586:	75 c3                	jne    8010a54b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
8010a588:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a58d:	c9                   	leave  
8010a58e:	c3                   	ret    

8010a58f <swap>:
void swap(void *a,void *b,int sz)
{
8010a58f:	55                   	push   %ebp
8010a590:	89 e5                	mov    %esp,%ebp
8010a592:	83 ec 10             	sub    $0x10,%esp
    char *n = (char*)a;
8010a595:	8b 45 08             	mov    0x8(%ebp),%eax
8010a598:	89 45 f8             	mov    %eax,-0x8(%ebp)
    char *m = (char*)b;
8010a59b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a59e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    char tmp;
    int i = 0;
8010a5a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(i = 0 ; i < sz ; i ++)
8010a5a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010a5af:	eb 35                	jmp    8010a5e6 <swap+0x57>
    {
       tmp = n[i];
8010a5b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a5b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a5b7:	01 d0                	add    %edx,%eax
8010a5b9:	0f b6 00             	movzbl (%eax),%eax
8010a5bc:	88 45 f3             	mov    %al,-0xd(%ebp)
       n[i] = m[i];
8010a5bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a5c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a5c5:	01 c2                	add    %eax,%edx
8010a5c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
8010a5ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a5cd:	01 c8                	add    %ecx,%eax
8010a5cf:	0f b6 00             	movzbl (%eax),%eax
8010a5d2:	88 02                	mov    %al,(%edx)
       m[i] = tmp;
8010a5d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a5d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a5da:	01 c2                	add    %eax,%edx
8010a5dc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
8010a5e0:	88 02                	mov    %al,(%edx)
{
    char *n = (char*)a;
    char *m = (char*)b;
    char tmp;
    int i = 0;
    for(i = 0 ; i < sz ; i ++)
8010a5e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010a5e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a5e9:	3b 45 10             	cmp    0x10(%ebp),%eax
8010a5ec:	7c c3                	jl     8010a5b1 <swap+0x22>
    {
       tmp = n[i];
       n[i] = m[i];
       m[i] = tmp;
    }
}
8010a5ee:	90                   	nop
8010a5ef:	c9                   	leave  
8010a5f0:	c3                   	ret    

8010a5f1 <itoa>:
char* itoa(int num, char* str, int radix)
{
8010a5f1:	55                   	push   %ebp
8010a5f2:	89 e5                	mov    %esp,%ebp
8010a5f4:	53                   	push   %ebx
8010a5f5:	83 ec 20             	sub    $0x20,%esp
    char index[] = "0123456789ABCDEF";
8010a5f8:	c7 45 df 30 31 32 33 	movl   $0x33323130,-0x21(%ebp)
8010a5ff:	c7 45 e3 34 35 36 37 	movl   $0x37363534,-0x1d(%ebp)
8010a606:	c7 45 e7 38 39 41 42 	movl   $0x42413938,-0x19(%ebp)
8010a60d:	c7 45 eb 43 44 45 46 	movl   $0x46454443,-0x15(%ebp)
8010a614:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    uint32_t unum;
    int32_t i = 0,j = 0;
8010a618:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010a61f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    if(num < 0 && radix == 10)
8010a626:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010a62a:	79 23                	jns    8010a64f <itoa+0x5e>
8010a62c:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
8010a630:	75 1d                	jne    8010a64f <itoa+0x5e>
    {
        unum = -num;
8010a632:	8b 45 08             	mov    0x8(%ebp),%eax
8010a635:	f7 d8                	neg    %eax
8010a637:	89 45 f8             	mov    %eax,-0x8(%ebp)
        str[i ++] = '-';
8010a63a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a63d:	8d 50 01             	lea    0x1(%eax),%edx
8010a640:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010a643:	89 c2                	mov    %eax,%edx
8010a645:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a648:	01 d0                	add    %edx,%eax
8010a64a:	c6 00 2d             	movb   $0x2d,(%eax)
8010a64d:	eb 06                	jmp    8010a655 <itoa+0x64>
    }else{
        unum = num; 
8010a64f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a652:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }

    do{
       str[i ++] = index[unum % radix]; 
8010a655:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a658:	8d 50 01             	lea    0x1(%eax),%edx
8010a65b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010a65e:	89 c2                	mov    %eax,%edx
8010a660:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a663:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010a666:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010a669:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a66c:	ba 00 00 00 00       	mov    $0x0,%edx
8010a671:	f7 f3                	div    %ebx
8010a673:	89 d0                	mov    %edx,%eax
8010a675:	0f b6 44 05 df       	movzbl -0x21(%ebp,%eax,1),%eax
8010a67a:	88 01                	mov    %al,(%ecx)
       unum /= radix;
8010a67c:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010a67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a682:	ba 00 00 00 00       	mov    $0x0,%edx
8010a687:	f7 f3                	div    %ebx
8010a689:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }while(unum != 0);
8010a68c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
8010a690:	75 c3                	jne    8010a655 <itoa+0x64>
    
    str[i] = '\0';
8010a692:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a695:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a698:	01 d0                	add    %edx,%eax
8010a69a:	c6 00 00             	movb   $0x0,(%eax)

    if(str[0] == '-')
8010a69d:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a6a0:	0f b6 00             	movzbl (%eax),%eax
8010a6a3:	3c 2d                	cmp    $0x2d,%al
8010a6a5:	75 04                	jne    8010a6ab <itoa+0xba>
    {
        j ++;        
8010a6a7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    for(i -= 1 ; j < i ; i --, j ++)
8010a6ab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010a6af:	eb 24                	jmp    8010a6d5 <itoa+0xe4>
    {
        swap(&str[i],&str[j],sizeof(char));
8010a6b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010a6b4:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a6b7:	01 c2                	add    %eax,%edx
8010a6b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010a6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a6bf:	01 c8                	add    %ecx,%eax
8010a6c1:	6a 01                	push   $0x1
8010a6c3:	52                   	push   %edx
8010a6c4:	50                   	push   %eax
8010a6c5:	e8 c5 fe ff ff       	call   8010a58f <swap>
8010a6ca:	83 c4 0c             	add    $0xc,%esp

    if(str[0] == '-')
    {
        j ++;        
    }
    for(i -= 1 ; j < i ; i --, j ++)
8010a6cd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010a6d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a6d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a6d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010a6db:	7c d4                	jl     8010a6b1 <itoa+0xc0>
    {
        swap(&str[i],&str[j],sizeof(char));
    }
    return str;
8010a6dd:	8b 45 0c             	mov    0xc(%ebp),%eax
}
8010a6e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010a6e3:	c9                   	leave  
8010a6e4:	c3                   	ret    

8010a6e5 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
8010a6e5:	55                   	push   %ebp
8010a6e6:	89 e5                	mov    %esp,%ebp
8010a6e8:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
8010a6eb:	8b 45 08             	mov    0x8(%ebp),%eax
8010a6ee:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
8010a6f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
8010a6f7:	b8 20 00 00 00       	mov    $0x20,%eax
8010a6fc:	2b 45 0c             	sub    0xc(%ebp),%eax
8010a6ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a702:	89 c1                	mov    %eax,%ecx
8010a704:	d3 ea                	shr    %cl,%edx
8010a706:	89 d0                	mov    %edx,%eax
}
8010a708:	c9                   	leave  
8010a709:	c3                   	ret    
