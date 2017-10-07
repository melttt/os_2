
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
80100119:	c7 45 f4 40 17 10 80 	movl   $0x80101740,-0xc(%ebp)
80100120:	c7 45 f0 68 4c 10 80 	movl   $0x80104c68,-0x10(%ebp)
    char * strst_begin = (char*)__STABSTR_BEGIN__;
80100127:	c7 45 ec 69 4c 10 80 	movl   $0x80104c69,-0x14(%ebp)
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
801001ef:	e8 a4 0f 00 00       	call   80101198 <strfind>
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
80100214:	e8 6d 0e 00 00       	call   80101086 <strncpy>
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
80100276:	68 c4 15 10 80       	push   $0x801015c4
8010027b:	e8 91 01 00 00       	call   80100411 <cprintf>
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
801002b5:	a1 04 90 10 80       	mov    0x80109004,%eax
801002ba:	83 ec 04             	sub    $0x4,%esp
801002bd:	52                   	push   %edx
801002be:	50                   	push   %eax
801002bf:	68 ea 15 10 80       	push   $0x801015ea
801002c4:	e8 48 01 00 00       	call   80100411 <cprintf>
801002c9:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: cs = %x\n", round, reg1);
801002cc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
801002d0:	0f b7 d0             	movzwl %ax,%edx
801002d3:	a1 04 90 10 80       	mov    0x80109004,%eax
801002d8:	83 ec 04             	sub    $0x4,%esp
801002db:	52                   	push   %edx
801002dc:	50                   	push   %eax
801002dd:	68 f8 15 10 80       	push   $0x801015f8
801002e2:	e8 2a 01 00 00       	call   80100411 <cprintf>
801002e7:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: ds = %x\n", round, reg2);
801002ea:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
801002ee:	0f b7 d0             	movzwl %ax,%edx
801002f1:	a1 04 90 10 80       	mov    0x80109004,%eax
801002f6:	83 ec 04             	sub    $0x4,%esp
801002f9:	52                   	push   %edx
801002fa:	50                   	push   %eax
801002fb:	68 05 16 10 80       	push   $0x80101605
80100300:	e8 0c 01 00 00       	call   80100411 <cprintf>
80100305:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: es = %x\n", round, reg3);
80100308:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
8010030c:	0f b7 d0             	movzwl %ax,%edx
8010030f:	a1 04 90 10 80       	mov    0x80109004,%eax
80100314:	83 ec 04             	sub    $0x4,%esp
80100317:	52                   	push   %edx
80100318:	50                   	push   %eax
80100319:	68 12 16 10 80       	push   $0x80101612
8010031e:	e8 ee 00 00 00       	call   80100411 <cprintf>
80100323:	83 c4 10             	add    $0x10,%esp
    cprintf("%d: ss = %x\n", round, reg4);
80100326:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
8010032a:	0f b7 d0             	movzwl %ax,%edx
8010032d:	a1 04 90 10 80       	mov    0x80109004,%eax
80100332:	83 ec 04             	sub    $0x4,%esp
80100335:	52                   	push   %edx
80100336:	50                   	push   %eax
80100337:	68 1f 16 10 80       	push   $0x8010161f
8010033c:	e8 d0 00 00 00       	call   80100411 <cprintf>
80100341:	83 c4 10             	add    $0x10,%esp
    ++ round; 
80100344:	a1 04 90 10 80       	mov    0x80109004,%eax
80100349:	83 c0 01             	add    $0x1,%eax
8010034c:	a3 04 90 10 80       	mov    %eax,0x80109004
    
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
8010035a:	a1 00 90 10 80       	mov    0x80109000,%eax
8010035f:	85 c0                	test   %eax,%eax
80100361:	74 02                	je     80100365 <__panic+0x11>
   {
       goto panic_dead;
80100363:	eb 5d                	jmp    801003c2 <__panic+0x6e>
   }
   is_panic = 1;
80100365:	c7 05 00 90 10 80 01 	movl   $0x1,0x80109000
8010036c:	00 00 00 
   va_list ap;
   va_start(ap, fmt);
8010036f:	8d 45 14             	lea    0x14(%ebp),%eax
80100372:	89 45 f4             	mov    %eax,-0xc(%ebp)
   cprintf("*****************PANIC!!!*******************\n");
80100375:	83 ec 0c             	sub    $0xc,%esp
80100378:	68 2c 16 10 80       	push   $0x8010162c
8010037d:	e8 8f 00 00 00       	call   80100411 <cprintf>
80100382:	83 c4 10             	add    $0x10,%esp
   cprintf("kernel panic at %s:%d:\n", file, line);
80100385:	83 ec 04             	sub    $0x4,%esp
80100388:	ff 75 0c             	pushl  0xc(%ebp)
8010038b:	ff 75 08             	pushl  0x8(%ebp)
8010038e:	68 5a 16 10 80       	push   $0x8010165a
80100393:	e8 79 00 00 00       	call   80100411 <cprintf>
80100398:	83 c4 10             	add    $0x10,%esp
   vcprintf(fmt, ap);
8010039b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	ff 75 10             	pushl  0x10(%ebp)
801003a5:	e8 49 00 00 00       	call   801003f3 <vcprintf>
801003aa:	83 c4 10             	add    $0x10,%esp
   cprintf("\n");
801003ad:	83 ec 0c             	sub    $0xc,%esp
801003b0:	68 72 16 10 80       	push   $0x80101672
801003b5:	e8 57 00 00 00       	call   80100411 <cprintf>
801003ba:	83 c4 10             	add    $0x10,%esp
   print_stack_trace();
801003bd:	e8 6f fe ff ff       	call   80100231 <print_stack_trace>
   va_end(ap);
panic_dead:
   while(1)
   {
       ;
   }
801003c2:	eb fe                	jmp    801003c2 <__panic+0x6e>

801003c4 <putch>:
#include "string.h"
#include "console.h"
#include "uart.h"

static void putch(char ch)
{
801003c4:	55                   	push   %ebp
801003c5:	89 e5                	mov    %esp,%ebp
801003c7:	83 ec 18             	sub    $0x18,%esp
801003ca:	8b 45 08             	mov    0x8(%ebp),%eax
801003cd:	88 45 f4             	mov    %al,-0xc(%ebp)
   console_putc(ch); 
801003d0:	0f be 45 f4          	movsbl -0xc(%ebp),%eax
801003d4:	83 ec 0c             	sub    $0xc,%esp
801003d7:	50                   	push   %eax
801003d8:	e8 27 08 00 00       	call   80100c04 <console_putc>
801003dd:	83 c4 10             	add    $0x10,%esp
   uartputc(ch);
801003e0:	0f be 45 f4          	movsbl -0xc(%ebp),%eax
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	50                   	push   %eax
801003e8:	e8 21 05 00 00       	call   8010090e <uartputc>
801003ed:	83 c4 10             	add    $0x10,%esp
}
801003f0:	90                   	nop
801003f1:	c9                   	leave  
801003f2:	c3                   	ret    

801003f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
801003f3:	55                   	push   %ebp
801003f4:	89 e5                	mov    %esp,%ebp
801003f6:	83 ec 08             	sub    $0x8,%esp
    return vprintfmt(putch,fmt,ap);
801003f9:	83 ec 04             	sub    $0x4,%esp
801003fc:	ff 75 0c             	pushl  0xc(%ebp)
801003ff:	ff 75 08             	pushl  0x8(%ebp)
80100402:	68 c4 03 10 80       	push   $0x801003c4
80100407:	e8 04 0a 00 00       	call   80100e10 <vprintfmt>
8010040c:	83 c4 10             	add    $0x10,%esp
}
8010040f:	c9                   	leave  
80100410:	c3                   	ret    

80100411 <cprintf>:
int cprintf(const char *fmt, ...)
{
80100411:	55                   	push   %ebp
80100412:	89 e5                	mov    %esp,%ebp
80100414:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
80100417:	8d 45 0c             	lea    0xc(%ebp),%eax
8010041a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vprintfmt(putch,fmt,ap);
8010041d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100420:	83 ec 04             	sub    $0x4,%esp
80100423:	50                   	push   %eax
80100424:	ff 75 08             	pushl  0x8(%ebp)
80100427:	68 c4 03 10 80       	push   $0x801003c4
8010042c:	e8 df 09 00 00       	call   80100e10 <vprintfmt>
80100431:	83 c4 10             	add    $0x10,%esp
80100434:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
80100437:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010043a:	c9                   	leave  
8010043b:	c3                   	ret    

8010043c <inb>:
    uint16_t limit;        // Limit
    uint32_t base;        // Base address
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
8010043c:	55                   	push   %ebp
8010043d:	89 e5                	mov    %esp,%ebp
8010043f:	83 ec 14             	sub    $0x14,%esp
80100442:	8b 45 08             	mov    0x8(%ebp),%eax
80100445:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
80100449:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010044d:	89 c2                	mov    %eax,%edx
8010044f:	ec                   	in     (%dx),%al
80100450:	88 45 ff             	mov    %al,-0x1(%ebp)
    return data;
80100453:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100457:	c9                   	leave  
80100458:	c3                   	ret    

80100459 <outb>:
            : "d" (port), "0" (addr), "1" (cnt)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
80100459:	55                   	push   %ebp
8010045a:	89 e5                	mov    %esp,%ebp
8010045c:	83 ec 08             	sub    $0x8,%esp
8010045f:	8b 55 08             	mov    0x8(%ebp),%edx
80100462:	8b 45 0c             	mov    0xc(%ebp),%eax
80100465:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100469:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
8010046c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100470:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100474:	ee                   	out    %al,(%dx)
}
80100475:	90                   	nop
80100476:	c9                   	leave  
80100477:	c3                   	ret    

80100478 <sum>:
struct cpu cpus[NCPU];


static uchar
sum(uchar *addr, int len)
{
80100478:	55                   	push   %ebp
80100479:	89 e5                	mov    %esp,%ebp
8010047b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
8010047e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80100485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010048c:	eb 15                	jmp    801004a3 <sum+0x2b>
    sum += addr[i];
8010048e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100491:	8b 45 08             	mov    0x8(%ebp),%eax
80100494:	01 d0                	add    %edx,%eax
80100496:	0f b6 00             	movzbl (%eax),%eax
80100499:	0f b6 c0             	movzbl %al,%eax
8010049c:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010049f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801004a9:	7c e3                	jl     8010048e <sum+0x16>
    sum += addr[i];
  return sum;
801004ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801004ae:	c9                   	leave  
801004af:	c3                   	ret    

801004b0 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801004b0:	55                   	push   %ebp
801004b1:	89 e5                	mov    %esp,%ebp
801004b3:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
801004b6:	8b 45 08             	mov    0x8(%ebp),%eax
801004b9:	05 00 00 00 80       	add    $0x80000000,%eax
801004be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801004c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	01 d0                	add    %edx,%eax
801004c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801004cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801004d2:	eb 36                	jmp    8010050a <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801004d4:	83 ec 04             	sub    $0x4,%esp
801004d7:	6a 04                	push   $0x4
801004d9:	68 74 16 10 80       	push   $0x80101674
801004de:	ff 75 f4             	pushl  -0xc(%ebp)
801004e1:	e8 2d 0f 00 00       	call   80101413 <memcmp>
801004e6:	83 c4 10             	add    $0x10,%esp
801004e9:	85 c0                	test   %eax,%eax
801004eb:	75 19                	jne    80100506 <mpsearch1+0x56>
801004ed:	83 ec 08             	sub    $0x8,%esp
801004f0:	6a 10                	push   $0x10
801004f2:	ff 75 f4             	pushl  -0xc(%ebp)
801004f5:	e8 7e ff ff ff       	call   80100478 <sum>
801004fa:	83 c4 10             	add    $0x10,%esp
801004fd:	84 c0                	test   %al,%al
801004ff:	75 05                	jne    80100506 <mpsearch1+0x56>
      return (struct mp*)p;
80100501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100504:	eb 11                	jmp    80100517 <mpsearch1+0x67>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80100506:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010050a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100510:	72 c2                	jb     801004d4 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80100512:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100517:	c9                   	leave  
80100518:	c3                   	ret    

80100519 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xF0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80100519:	55                   	push   %ebp
8010051a:	89 e5                	mov    %esp,%ebp
8010051c:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
8010051f:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80100526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100529:	83 c0 0f             	add    $0xf,%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	0f b6 c0             	movzbl %al,%eax
80100532:	c1 e0 08             	shl    $0x8,%eax
80100535:	89 c2                	mov    %eax,%edx
80100537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010053a:	83 c0 0e             	add    $0xe,%eax
8010053d:	0f b6 00             	movzbl (%eax),%eax
80100540:	0f b6 c0             	movzbl %al,%eax
80100543:	09 d0                	or     %edx,%eax
80100545:	c1 e0 04             	shl    $0x4,%eax
80100548:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010054b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010054f:	74 21                	je     80100572 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80100551:	83 ec 08             	sub    $0x8,%esp
80100554:	68 00 04 00 00       	push   $0x400
80100559:	ff 75 f0             	pushl  -0x10(%ebp)
8010055c:	e8 4f ff ff ff       	call   801004b0 <mpsearch1>
80100561:	83 c4 10             	add    $0x10,%esp
80100564:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100567:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010056b:	74 51                	je     801005be <mpsearch+0xa5>
      return mp;
8010056d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100570:	eb 61                	jmp    801005d3 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80100572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100575:	83 c0 14             	add    $0x14,%eax
80100578:	0f b6 00             	movzbl (%eax),%eax
8010057b:	0f b6 c0             	movzbl %al,%eax
8010057e:	c1 e0 08             	shl    $0x8,%eax
80100581:	89 c2                	mov    %eax,%edx
80100583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100586:	83 c0 13             	add    $0x13,%eax
80100589:	0f b6 00             	movzbl (%eax),%eax
8010058c:	0f b6 c0             	movzbl %al,%eax
8010058f:	09 d0                	or     %edx,%eax
80100591:	c1 e0 0a             	shl    $0xa,%eax
80100594:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80100597:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010059a:	2d 00 04 00 00       	sub    $0x400,%eax
8010059f:	83 ec 08             	sub    $0x8,%esp
801005a2:	68 00 04 00 00       	push   $0x400
801005a7:	50                   	push   %eax
801005a8:	e8 03 ff ff ff       	call   801004b0 <mpsearch1>
801005ad:	83 c4 10             	add    $0x10,%esp
801005b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801005b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801005b7:	74 05                	je     801005be <mpsearch+0xa5>
      return mp;
801005b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801005bc:	eb 15                	jmp    801005d3 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
801005be:	83 ec 08             	sub    $0x8,%esp
801005c1:	68 00 00 01 00       	push   $0x10000
801005c6:	68 00 00 0f 00       	push   $0xf0000
801005cb:	e8 e0 fe ff ff       	call   801004b0 <mpsearch1>
801005d0:	83 c4 10             	add    $0x10,%esp
}
801005d3:	c9                   	leave  
801005d4:	c3                   	ret    

801005d5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801005d5:	55                   	push   %ebp
801005d6:	89 e5                	mov    %esp,%ebp
801005d8:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801005db:	e8 39 ff ff ff       	call   80100519 <mpsearch>
801005e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801005e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801005e7:	74 0a                	je     801005f3 <mpconfig+0x1e>
801005e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005ec:	8b 40 04             	mov    0x4(%eax),%eax
801005ef:	85 c0                	test   %eax,%eax
801005f1:	75 07                	jne    801005fa <mpconfig+0x25>
    return 0;
801005f3:	b8 00 00 00 00       	mov    $0x0,%eax
801005f8:	eb 7a                	jmp    80100674 <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005fd:	8b 40 04             	mov    0x4(%eax),%eax
80100600:	05 00 00 00 80       	add    $0x80000000,%eax
80100605:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80100608:	83 ec 04             	sub    $0x4,%esp
8010060b:	6a 04                	push   $0x4
8010060d:	68 79 16 10 80       	push   $0x80101679
80100612:	ff 75 f0             	pushl  -0x10(%ebp)
80100615:	e8 f9 0d 00 00       	call   80101413 <memcmp>
8010061a:	83 c4 10             	add    $0x10,%esp
8010061d:	85 c0                	test   %eax,%eax
8010061f:	74 07                	je     80100628 <mpconfig+0x53>
    return 0;
80100621:	b8 00 00 00 00       	mov    $0x0,%eax
80100626:	eb 4c                	jmp    80100674 <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
80100628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010062b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010062f:	3c 01                	cmp    $0x1,%al
80100631:	74 12                	je     80100645 <mpconfig+0x70>
80100633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100636:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010063a:	3c 04                	cmp    $0x4,%al
8010063c:	74 07                	je     80100645 <mpconfig+0x70>
    return 0;
8010063e:	b8 00 00 00 00       	mov    $0x0,%eax
80100643:	eb 2f                	jmp    80100674 <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
80100645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100648:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010064c:	0f b7 c0             	movzwl %ax,%eax
8010064f:	83 ec 08             	sub    $0x8,%esp
80100652:	50                   	push   %eax
80100653:	ff 75 f0             	pushl  -0x10(%ebp)
80100656:	e8 1d fe ff ff       	call   80100478 <sum>
8010065b:	83 c4 10             	add    $0x10,%esp
8010065e:	84 c0                	test   %al,%al
80100660:	74 07                	je     80100669 <mpconfig+0x94>
    return 0;
80100662:	b8 00 00 00 00       	mov    $0x0,%eax
80100667:	eb 0b                	jmp    80100674 <mpconfig+0x9f>
  *pmp = mp;
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010066f:	89 10                	mov    %edx,(%eax)
  return conf;
80100671:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80100674:	c9                   	leave  
80100675:	c3                   	ret    

80100676 <mpinit>:

void
mpinit(void)
{
80100676:	55                   	push   %ebp
80100677:	89 e5                	mov    %esp,%ebp
80100679:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;


  if((conf = mpconfig(&mp)) == 0)
8010067c:	83 ec 0c             	sub    $0xc,%esp
8010067f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100682:	50                   	push   %eax
80100683:	e8 4d ff ff ff       	call   801005d5 <mpconfig>
80100688:	83 c4 10             	add    $0x10,%esp
8010068b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010068e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100692:	0f 84 25 01 00 00    	je     801007bd <mpinit+0x147>
    return;
  ismp = 1;
80100698:	c7 05 24 90 10 80 01 	movl   $0x1,0x80109024
8010069f:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801006a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801006a5:	8b 40 24             	mov    0x24(%eax),%eax
801006a8:	a3 e0 90 10 80       	mov    %eax,0x801090e0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801006b0:	83 c0 2c             	add    $0x2c,%eax
801006b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801006b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801006b9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801006bd:	0f b7 d0             	movzwl %ax,%edx
801006c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801006c3:	01 d0                	add    %edx,%eax
801006c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801006c8:	e9 81 00 00 00       	jmp    8010074e <mpinit+0xd8>
    switch(*p){
801006cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006d0:	0f b6 00             	movzbl (%eax),%eax
801006d3:	0f b6 c0             	movzbl %al,%eax
801006d6:	83 f8 04             	cmp    $0x4,%eax
801006d9:	77 68                	ja     80100743 <mpinit+0xcd>
801006db:	8b 04 85 80 16 10 80 	mov    -0x7fefe980(,%eax,4),%eax
801006e2:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801006e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu < NCPU) {
801006ea:	a1 e4 90 10 80       	mov    0x801090e4,%eax
801006ef:	83 f8 07             	cmp    $0x7,%eax
801006f2:	7f 2b                	jg     8010071f <mpinit+0xa9>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801006f4:	8b 15 e4 90 10 80    	mov    0x801090e4,%edx
801006fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801006fd:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80100701:	89 d0                	mov    %edx,%eax
80100703:	c1 e0 02             	shl    $0x2,%eax
80100706:	01 d0                	add    %edx,%eax
80100708:	c1 e0 02             	shl    $0x2,%eax
8010070b:	05 40 90 10 80       	add    $0x80109040,%eax
80100710:	88 08                	mov    %cl,(%eax)
        ncpu++;
80100712:	a1 e4 90 10 80       	mov    0x801090e4,%eax
80100717:	83 c0 01             	add    $0x1,%eax
8010071a:	a3 e4 90 10 80       	mov    %eax,0x801090e4
      }
      p += sizeof(struct mpproc);
8010071f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80100723:	eb 29                	jmp    8010074e <mpinit+0xd8>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
8010072b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80100732:	a2 20 90 10 80       	mov    %al,0x80109020
      p += sizeof(struct mpioapic);
80100737:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010073b:	eb 11                	jmp    8010074e <mpinit+0xd8>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010073d:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80100741:	eb 0b                	jmp    8010074e <mpinit+0xd8>
    default:
      ismp = 0;
80100743:	c7 05 24 90 10 80 00 	movl   $0x0,0x80109024
8010074a:	00 00 00 
      break;
8010074d:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100751:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100754:	0f 82 73 ff ff ff    	jb     801006cd <mpinit+0x57>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
8010075a:	a1 24 90 10 80       	mov    0x80109024,%eax
8010075f:	85 c0                	test   %eax,%eax
80100761:	75 1d                	jne    80100780 <mpinit+0x10a>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80100763:	c7 05 e4 90 10 80 01 	movl   $0x1,0x801090e4
8010076a:	00 00 00 
    lapic = 0;
8010076d:	c7 05 e0 90 10 80 00 	movl   $0x0,0x801090e0
80100774:	00 00 00 
    ioapicid = 0;
80100777:	c6 05 20 90 10 80 00 	movb   $0x0,0x80109020
    return;
8010077e:	eb 3e                	jmp    801007be <mpinit+0x148>
  }

  if(mp->imcrp){
80100780:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100783:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80100787:	84 c0                	test   %al,%al
80100789:	74 33                	je     801007be <mpinit+0x148>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010078b:	83 ec 08             	sub    $0x8,%esp
8010078e:	6a 70                	push   $0x70
80100790:	6a 22                	push   $0x22
80100792:	e8 c2 fc ff ff       	call   80100459 <outb>
80100797:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010079a:	83 ec 0c             	sub    $0xc,%esp
8010079d:	6a 23                	push   $0x23
8010079f:	e8 98 fc ff ff       	call   8010043c <inb>
801007a4:	83 c4 10             	add    $0x10,%esp
801007a7:	83 c8 01             	or     $0x1,%eax
801007aa:	0f b6 c0             	movzbl %al,%eax
801007ad:	83 ec 08             	sub    $0x8,%esp
801007b0:	50                   	push   %eax
801007b1:	6a 23                	push   $0x23
801007b3:	e8 a1 fc ff ff       	call   80100459 <outb>
801007b8:	83 c4 10             	add    $0x10,%esp
801007bb:	eb 01                	jmp    801007be <mpinit+0x148>
  struct mpproc *proc;
  struct mpioapic *ioapic;


  if((conf = mpconfig(&mp)) == 0)
    return;
801007bd:	90                   	nop
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }

//  cprintf("smp : %d , cpu_num : %d , lapic_addr: 0x%x\n", ismp, ncpu ,(uint)lapic);
}
801007be:	c9                   	leave  
801007bf:	c3                   	ret    

801007c0 <inb>:
    uint16_t limit;        // Limit
    uint32_t base;        // Base address
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
801007c0:	55                   	push   %ebp
801007c1:	89 e5                	mov    %esp,%ebp
801007c3:	83 ec 14             	sub    $0x14,%esp
801007c6:	8b 45 08             	mov    0x8(%ebp),%eax
801007c9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
801007cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801007d1:	89 c2                	mov    %eax,%edx
801007d3:	ec                   	in     (%dx),%al
801007d4:	88 45 ff             	mov    %al,-0x1(%ebp)
    return data;
801007d7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801007db:	c9                   	leave  
801007dc:	c3                   	ret    

801007dd <outb>:
            : "d" (port), "0" (addr), "1" (cnt)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
801007dd:	55                   	push   %ebp
801007de:	89 e5                	mov    %esp,%ebp
801007e0:	83 ec 08             	sub    $0x8,%esp
801007e3:	8b 55 08             	mov    0x8(%ebp),%edx
801007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801007e9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801007ed:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
801007f0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801007f4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801007f8:	ee                   	out    %al,(%dx)
}
801007f9:	90                   	nop
801007fa:	c9                   	leave  
801007fb:	c3                   	ret    

801007fc <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801007fc:	55                   	push   %ebp
801007fd:	89 e5                	mov    %esp,%ebp
801007ff:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80100802:	6a 00                	push   $0x0
80100804:	68 fa 03 00 00       	push   $0x3fa
80100809:	e8 cf ff ff ff       	call   801007dd <outb>
8010080e:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80100811:	68 80 00 00 00       	push   $0x80
80100816:	68 fb 03 00 00       	push   $0x3fb
8010081b:	e8 bd ff ff ff       	call   801007dd <outb>
80100820:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80100823:	6a 0c                	push   $0xc
80100825:	68 f8 03 00 00       	push   $0x3f8
8010082a:	e8 ae ff ff ff       	call   801007dd <outb>
8010082f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80100832:	6a 00                	push   $0x0
80100834:	68 f9 03 00 00       	push   $0x3f9
80100839:	e8 9f ff ff ff       	call   801007dd <outb>
8010083e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80100841:	6a 03                	push   $0x3
80100843:	68 fb 03 00 00       	push   $0x3fb
80100848:	e8 90 ff ff ff       	call   801007dd <outb>
8010084d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80100850:	6a 00                	push   $0x0
80100852:	68 fc 03 00 00       	push   $0x3fc
80100857:	e8 81 ff ff ff       	call   801007dd <outb>
8010085c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010085f:	6a 01                	push   $0x1
80100861:	68 f9 03 00 00       	push   $0x3f9
80100866:	e8 72 ff ff ff       	call   801007dd <outb>
8010086b:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010086e:	68 fd 03 00 00       	push   $0x3fd
80100873:	e8 48 ff ff ff       	call   801007c0 <inb>
80100878:	83 c4 04             	add    $0x4,%esp
8010087b:	3c ff                	cmp    $0xff,%al
8010087d:	74 52                	je     801008d1 <uartinit+0xd5>
    return;
  uart = 1;
8010087f:	c7 05 08 90 10 80 01 	movl   $0x1,0x80109008
80100886:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80100889:	68 fa 03 00 00       	push   $0x3fa
8010088e:	e8 2d ff ff ff       	call   801007c0 <inb>
80100893:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80100896:	68 f8 03 00 00       	push   $0x3f8
8010089b:	e8 20 ff ff ff       	call   801007c0 <inb>
801008a0:	83 c4 04             	add    $0x4,%esp
//  picenable(IRQ_COM1);
//  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="uart...ok!\n"; *p; p++)
801008a3:	c7 45 f4 94 16 10 80 	movl   $0x80101694,-0xc(%ebp)
801008aa:	eb 19                	jmp    801008c5 <uartinit+0xc9>
    uartputc(*p);
801008ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008af:	0f b6 00             	movzbl (%eax),%eax
801008b2:	0f be c0             	movsbl %al,%eax
801008b5:	83 ec 0c             	sub    $0xc,%esp
801008b8:	50                   	push   %eax
801008b9:	e8 50 00 00 00       	call   8010090e <uartputc>
801008be:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
//  picenable(IRQ_COM1);
//  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="uart...ok!\n"; *p; p++)
801008c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c8:	0f b6 00             	movzbl (%eax),%eax
801008cb:	84 c0                	test   %al,%al
801008cd:	75 dd                	jne    801008ac <uartinit+0xb0>
801008cf:	eb 01                	jmp    801008d2 <uartinit+0xd6>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801008d1:	90                   	nop
//  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="uart...ok!\n"; *p; p++)
    uartputc(*p);
}
801008d2:	c9                   	leave  
801008d3:	c3                   	ret    

801008d4 <delay>:
static void
delay(void) {
801008d4:	55                   	push   %ebp
801008d5:	89 e5                	mov    %esp,%ebp
    inb(0x84);
801008d7:	68 84 00 00 00       	push   $0x84
801008dc:	e8 df fe ff ff       	call   801007c0 <inb>
801008e1:	83 c4 04             	add    $0x4,%esp
    inb(0x84);
801008e4:	68 84 00 00 00       	push   $0x84
801008e9:	e8 d2 fe ff ff       	call   801007c0 <inb>
801008ee:	83 c4 04             	add    $0x4,%esp
    inb(0x84);
801008f1:	68 84 00 00 00       	push   $0x84
801008f6:	e8 c5 fe ff ff       	call   801007c0 <inb>
801008fb:	83 c4 04             	add    $0x4,%esp
    inb(0x84);
801008fe:	68 84 00 00 00       	push   $0x84
80100903:	e8 b8 fe ff ff       	call   801007c0 <inb>
80100908:	83 c4 04             	add    $0x4,%esp
}
8010090b:	90                   	nop
8010090c:	c9                   	leave  
8010090d:	c3                   	ret    

8010090e <uartputc>:

void
uartputc(int c)
{
8010090e:	55                   	push   %ebp
8010090f:	89 e5                	mov    %esp,%ebp
80100911:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
80100914:	a1 08 90 10 80       	mov    0x80109008,%eax
80100919:	85 c0                	test   %eax,%eax
8010091b:	74 45                	je     80100962 <uartputc+0x54>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010091d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80100924:	eb 09                	jmp    8010092f <uartputc+0x21>
    delay();
80100926:	e8 a9 ff ff ff       	call   801008d4 <delay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010092b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010092f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
80100933:	7f 17                	jg     8010094c <uartputc+0x3e>
80100935:	68 fd 03 00 00       	push   $0x3fd
8010093a:	e8 81 fe ff ff       	call   801007c0 <inb>
8010093f:	83 c4 04             	add    $0x4,%esp
80100942:	0f b6 c0             	movzbl %al,%eax
80100945:	83 e0 20             	and    $0x20,%eax
80100948:	85 c0                	test   %eax,%eax
8010094a:	74 da                	je     80100926 <uartputc+0x18>
    delay();
  outb(COM1+0, c);
8010094c:	8b 45 08             	mov    0x8(%ebp),%eax
8010094f:	0f b6 c0             	movzbl %al,%eax
80100952:	50                   	push   %eax
80100953:	68 f8 03 00 00       	push   $0x3f8
80100958:	e8 80 fe ff ff       	call   801007dd <outb>
8010095d:	83 c4 08             	add    $0x8,%esp
80100960:	eb 01                	jmp    80100963 <uartputc+0x55>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80100962:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    delay();
  outb(COM1+0, c);
}
80100963:	c9                   	leave  
80100964:	c3                   	ret    

80100965 <outb>:
            : "d" (port), "0" (addr), "1" (cnt)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
80100965:	55                   	push   %ebp
80100966:	89 e5                	mov    %esp,%ebp
80100968:	83 ec 08             	sub    $0x8,%esp
8010096b:	8b 55 08             	mov    0x8(%ebp),%edx
8010096e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100971:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100975:	88 45 f8             	mov    %al,-0x8(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
80100978:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010097c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100980:	ee                   	out    %al,(%dx)
}
80100981:	90                   	nop
80100982:	c9                   	leave  
80100983:	c3                   	ret    

80100984 <move_cursor>:
static uint8_t cursor_x = 0;
static uint8_t cursor_y = 0;

//set cursor location
static void move_cursor()
{
80100984:	55                   	push   %ebp
80100985:	89 e5                	mov    %esp,%ebp
80100987:	83 ec 10             	sub    $0x10,%esp
    uint16_t cursorLocation = cursor_y * 80 + cursor_x ;
8010098a:	0f b6 05 0d 90 10 80 	movzbl 0x8010900d,%eax
80100991:	0f b6 d0             	movzbl %al,%edx
80100994:	89 d0                	mov    %edx,%eax
80100996:	c1 e0 02             	shl    $0x2,%eax
80100999:	01 d0                	add    %edx,%eax
8010099b:	c1 e0 04             	shl    $0x4,%eax
8010099e:	89 c2                	mov    %eax,%edx
801009a0:	0f b6 05 0c 90 10 80 	movzbl 0x8010900c,%eax
801009a7:	0f b6 c0             	movzbl %al,%eax
801009aa:	01 d0                	add    %edx,%eax
801009ac:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    outb(0x3D4, 14);
801009b0:	6a 0e                	push   $0xe
801009b2:	68 d4 03 00 00       	push   $0x3d4
801009b7:	e8 a9 ff ff ff       	call   80100965 <outb>
801009bc:	83 c4 08             	add    $0x8,%esp
    outb(0x3D5, cursorLocation >> 8);
801009bf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
801009c3:	66 c1 e8 08          	shr    $0x8,%ax
801009c7:	0f b6 c0             	movzbl %al,%eax
801009ca:	50                   	push   %eax
801009cb:	68 d5 03 00 00       	push   $0x3d5
801009d0:	e8 90 ff ff ff       	call   80100965 <outb>
801009d5:	83 c4 08             	add    $0x8,%esp
    outb(0x3D4, 15);
801009d8:	6a 0f                	push   $0xf
801009da:	68 d4 03 00 00       	push   $0x3d4
801009df:	e8 81 ff ff ff       	call   80100965 <outb>
801009e4:	83 c4 08             	add    $0x8,%esp
    outb(0x3D5, cursorLocation);
801009e7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
801009eb:	0f b6 c0             	movzbl %al,%eax
801009ee:	50                   	push   %eax
801009ef:	68 d5 03 00 00       	push   $0x3d5
801009f4:	e8 6c ff ff ff       	call   80100965 <outb>
801009f9:	83 c4 08             	add    $0x8,%esp
}
801009fc:	90                   	nop
801009fd:	c9                   	leave  
801009fe:	c3                   	ret    

801009ff <console_clear>:

//clear console
void console_clear()
{
801009ff:	55                   	push   %ebp
80100a00:	89 e5                	mov    %esp,%ebp
80100a02:	83 ec 10             	sub    $0x10,%esp
    uint8_t attribute_byte = (0 << 4) | (15 & 0x0F);
80100a05:	c6 45 fb 0f          	movb   $0xf,-0x5(%ebp)
    uint16_t blank = 0x20 | (attribute_byte << 8);
80100a09:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
80100a0d:	c1 e0 08             	shl    $0x8,%eax
80100a10:	83 c8 20             	or     $0x20,%eax
80100a13:	66 89 45 f8          	mov    %ax,-0x8(%ebp)

    int i;
    for(i = 0 ; i < 80 * 25 ; i ++)
80100a17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80100a1e:	eb 17                	jmp    80100a37 <console_clear+0x38>
    {
        video_memory[i] = blank; 
80100a20:	a1 00 70 10 80       	mov    0x80107000,%eax
80100a25:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100a28:	01 d2                	add    %edx,%edx
80100a2a:	01 c2                	add    %eax,%edx
80100a2c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80100a30:	66 89 02             	mov    %ax,(%edx)
{
    uint8_t attribute_byte = (0 << 4) | (15 & 0x0F);
    uint16_t blank = 0x20 | (attribute_byte << 8);

    int i;
    for(i = 0 ; i < 80 * 25 ; i ++)
80100a33:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80100a37:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%ebp)
80100a3e:	7e e0                	jle    80100a20 <console_clear+0x21>
    {
        video_memory[i] = blank; 
    }

    cursor_x = 0;
80100a40:	c6 05 0c 90 10 80 00 	movb   $0x0,0x8010900c
    cursor_y = 0;
80100a47:	c6 05 0d 90 10 80 00 	movb   $0x0,0x8010900d
    move_cursor();
80100a4e:	e8 31 ff ff ff       	call   80100984 <move_cursor>

}
80100a53:	90                   	nop
80100a54:	c9                   	leave  
80100a55:	c3                   	ret    

80100a56 <scroll>:

// scroll console
static void scroll()
{
80100a56:	55                   	push   %ebp
80100a57:	89 e5                	mov    %esp,%ebp
80100a59:	83 ec 10             	sub    $0x10,%esp
    uint8_t attribute_byte = (0 << 4) | (15 & 0x0f);
80100a5c:	c6 45 fb 0f          	movb   $0xf,-0x5(%ebp)
    uint16_t blank = 0x20 | (attribute_byte << 8);
80100a60:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
80100a64:	c1 e0 08             	shl    $0x8,%eax
80100a67:	83 c8 20             	or     $0x20,%eax
80100a6a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    
    if(cursor_y >= 25)
80100a6e:	0f b6 05 0d 90 10 80 	movzbl 0x8010900d,%eax
80100a75:	3c 18                	cmp    $0x18,%al
80100a77:	76 67                	jbe    80100ae0 <scroll+0x8a>
    {
        int i;
        for(i = 0 ; i < 24 * 80 ; i ++)
80100a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80100a80:	eb 25                	jmp    80100aa7 <scroll+0x51>
        {
            video_memory[i] = video_memory[i + 80]; 
80100a82:	a1 00 70 10 80       	mov    0x80107000,%eax
80100a87:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100a8a:	01 d2                	add    %edx,%edx
80100a8c:	01 c2                	add    %eax,%edx
80100a8e:	a1 00 70 10 80       	mov    0x80107000,%eax
80100a93:	8b 4d fc             	mov    -0x4(%ebp),%ecx
80100a96:	83 c1 50             	add    $0x50,%ecx
80100a99:	01 c9                	add    %ecx,%ecx
80100a9b:	01 c8                	add    %ecx,%eax
80100a9d:	0f b7 00             	movzwl (%eax),%eax
80100aa0:	66 89 02             	mov    %ax,(%edx)
    uint16_t blank = 0x20 | (attribute_byte << 8);
    
    if(cursor_y >= 25)
    {
        int i;
        for(i = 0 ; i < 24 * 80 ; i ++)
80100aa3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80100aa7:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%ebp)
80100aae:	7e d2                	jle    80100a82 <scroll+0x2c>
        {
            video_memory[i] = video_memory[i + 80]; 
        }

        // fill blank
        for(i = 24 * 80; i < 25 * 80 ; i ++)
80100ab0:	c7 45 fc 80 07 00 00 	movl   $0x780,-0x4(%ebp)
80100ab7:	eb 17                	jmp    80100ad0 <scroll+0x7a>
        {
            video_memory[i] = blank; 
80100ab9:	a1 00 70 10 80       	mov    0x80107000,%eax
80100abe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100ac1:	01 d2                	add    %edx,%edx
80100ac3:	01 c2                	add    %eax,%edx
80100ac5:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80100ac9:	66 89 02             	mov    %ax,(%edx)
        {
            video_memory[i] = video_memory[i + 80]; 
        }

        // fill blank
        for(i = 24 * 80; i < 25 * 80 ; i ++)
80100acc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80100ad0:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%ebp)
80100ad7:	7e e0                	jle    80100ab9 <scroll+0x63>
        {
            video_memory[i] = blank; 
        }
        cursor_y = 24;
80100ad9:	c6 05 0d 90 10 80 18 	movb   $0x18,0x8010900d
    }
}
80100ae0:	90                   	nop
80100ae1:	c9                   	leave  
80100ae2:	c3                   	ret    

80100ae3 <console_putc_color>:

void console_putc_color(char c,real_color_t back, real_color_t fore)
{
80100ae3:	55                   	push   %ebp
80100ae4:	89 e5                	mov    %esp,%ebp
80100ae6:	83 ec 14             	sub    $0x14,%esp
80100ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80100aec:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t back_color = (uint8_t)back;
80100aef:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af2:	88 45 ff             	mov    %al,-0x1(%ebp)
    uint8_t fore_color = (uint8_t)fore;
80100af5:	8b 45 10             	mov    0x10(%ebp),%eax
80100af8:	88 45 fe             	mov    %al,-0x2(%ebp)

    uint8_t attribute_byte = (back_color << 4) | (fore_color & 0x0f);
80100afb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80100aff:	c1 e0 04             	shl    $0x4,%eax
80100b02:	89 c2                	mov    %eax,%edx
80100b04:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
80100b08:	83 e0 0f             	and    $0xf,%eax
80100b0b:	09 d0                	or     %edx,%eax
80100b0d:	88 45 fd             	mov    %al,-0x3(%ebp)
    uint16_t attribute = (attribute_byte << 8);
80100b10:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
80100b14:	c1 e0 08             	shl    $0x8,%eax
80100b17:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    
    // 0x08是退格键
    // 0x09是tab
    if(c == 0x08 && cursor_x != 0)
80100b1b:	80 7d ec 08          	cmpb   $0x8,-0x14(%ebp)
80100b1f:	75 1f                	jne    80100b40 <console_putc_color+0x5d>
80100b21:	0f b6 05 0c 90 10 80 	movzbl 0x8010900c,%eax
80100b28:	84 c0                	test   %al,%al
80100b2a:	74 14                	je     80100b40 <console_putc_color+0x5d>
    {
        cursor_x --; 
80100b2c:	0f b6 05 0c 90 10 80 	movzbl 0x8010900c,%eax
80100b33:	83 e8 01             	sub    $0x1,%eax
80100b36:	a2 0c 90 10 80       	mov    %al,0x8010900c
80100b3b:	e9 96 00 00 00       	jmp    80100bd6 <console_putc_color+0xf3>
    }else if(c == 0x09)
80100b40:	80 7d ec 09          	cmpb   $0x9,-0x14(%ebp)
80100b44:	75 14                	jne    80100b5a <console_putc_color+0x77>
    {
        cursor_x = (cursor_x + 8) & ~ (8 - 1);
80100b46:	0f b6 05 0c 90 10 80 	movzbl 0x8010900c,%eax
80100b4d:	83 c0 08             	add    $0x8,%eax
80100b50:	83 e0 f8             	and    $0xfffffff8,%eax
80100b53:	a2 0c 90 10 80       	mov    %al,0x8010900c
80100b58:	eb 7c                	jmp    80100bd6 <console_putc_color+0xf3>
    }else if(c == '\r')
80100b5a:	80 7d ec 0d          	cmpb   $0xd,-0x14(%ebp)
80100b5e:	75 09                	jne    80100b69 <console_putc_color+0x86>
    {
        cursor_x = 0;
80100b60:	c6 05 0c 90 10 80 00 	movb   $0x0,0x8010900c
80100b67:	eb 6d                	jmp    80100bd6 <console_putc_color+0xf3>
    }else if(c == '\n')
80100b69:	80 7d ec 0a          	cmpb   $0xa,-0x14(%ebp)
80100b6d:	75 18                	jne    80100b87 <console_putc_color+0xa4>
    {
        cursor_x = 0; 
80100b6f:	c6 05 0c 90 10 80 00 	movb   $0x0,0x8010900c
        cursor_y ++;
80100b76:	0f b6 05 0d 90 10 80 	movzbl 0x8010900d,%eax
80100b7d:	83 c0 01             	add    $0x1,%eax
80100b80:	a2 0d 90 10 80       	mov    %al,0x8010900d
80100b85:	eb 4f                	jmp    80100bd6 <console_putc_color+0xf3>
    }else if(c >= ' ')
80100b87:	80 7d ec 1f          	cmpb   $0x1f,-0x14(%ebp)
80100b8b:	7e 49                	jle    80100bd6 <console_putc_color+0xf3>
    {
        video_memory[cursor_y * 80 + cursor_x] = c | attribute;
80100b8d:	8b 0d 00 70 10 80    	mov    0x80107000,%ecx
80100b93:	0f b6 05 0d 90 10 80 	movzbl 0x8010900d,%eax
80100b9a:	0f b6 d0             	movzbl %al,%edx
80100b9d:	89 d0                	mov    %edx,%eax
80100b9f:	c1 e0 02             	shl    $0x2,%eax
80100ba2:	01 d0                	add    %edx,%eax
80100ba4:	c1 e0 04             	shl    $0x4,%eax
80100ba7:	89 c2                	mov    %eax,%edx
80100ba9:	0f b6 05 0c 90 10 80 	movzbl 0x8010900c,%eax
80100bb0:	0f b6 c0             	movzbl %al,%eax
80100bb3:	01 d0                	add    %edx,%eax
80100bb5:	01 c0                	add    %eax,%eax
80100bb7:	01 c8                	add    %ecx,%eax
80100bb9:	66 0f be 4d ec       	movsbw -0x14(%ebp),%cx
80100bbe:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
80100bc2:	09 ca                	or     %ecx,%edx
80100bc4:	66 89 10             	mov    %dx,(%eax)
        cursor_x ++;
80100bc7:	0f b6 05 0c 90 10 80 	movzbl 0x8010900c,%eax
80100bce:	83 c0 01             	add    $0x1,%eax
80100bd1:	a2 0c 90 10 80       	mov    %al,0x8010900c
    }

    //行数超过80换行
    if(cursor_x >= 80)
80100bd6:	0f b6 05 0c 90 10 80 	movzbl 0x8010900c,%eax
80100bdd:	3c 4f                	cmp    $0x4f,%al
80100bdf:	76 16                	jbe    80100bf7 <console_putc_color+0x114>
    {
        cursor_x = 0; 
80100be1:	c6 05 0c 90 10 80 00 	movb   $0x0,0x8010900c
        cursor_y ++;
80100be8:	0f b6 05 0d 90 10 80 	movzbl 0x8010900d,%eax
80100bef:	83 c0 01             	add    $0x1,%eax
80100bf2:	a2 0d 90 10 80       	mov    %al,0x8010900d
    }

    //需要即滚动
    scroll();
80100bf7:	e8 5a fe ff ff       	call   80100a56 <scroll>

    //移动硬件的光标
    move_cursor();
80100bfc:	e8 83 fd ff ff       	call   80100984 <move_cursor>

}
80100c01:	90                   	nop
80100c02:	c9                   	leave  
80100c03:	c3                   	ret    

80100c04 <console_putc>:

void console_putc(char cstr)
{
80100c04:	55                   	push   %ebp
80100c05:	89 e5                	mov    %esp,%ebp
80100c07:	83 ec 04             	sub    $0x4,%esp
80100c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80100c0d:	88 45 fc             	mov    %al,-0x4(%ebp)
        console_putc_color(cstr,rc_black, rc_white); 
80100c10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
80100c14:	6a 0f                	push   $0xf
80100c16:	6a 00                	push   $0x0
80100c18:	50                   	push   %eax
80100c19:	e8 c5 fe ff ff       	call   80100ae3 <console_putc_color>
80100c1e:	83 c4 0c             	add    $0xc,%esp
}
80100c21:	90                   	nop
80100c22:	c9                   	leave  
80100c23:	c3                   	ret    

80100c24 <g>:
        long type;

    }map[30];
} *emap;
void g()
{
80100c24:	55                   	push   %ebp
80100c25:	89 e5                	mov    %esp,%ebp
80100c27:	83 ec 08             	sub    $0x8,%esp
    assert(1 == 2);
80100c2a:	68 a0 16 10 80       	push   $0x801016a0
80100c2f:	68 a7 16 10 80       	push   $0x801016a7
80100c34:	6a 18                	push   $0x18
80100c36:	68 bd 16 10 80       	push   $0x801016bd
80100c3b:	e8 14 f7 ff ff       	call   80100354 <__panic>
80100c40:	83 c4 10             	add    $0x10,%esp
}
80100c43:	90                   	nop
80100c44:	c9                   	leave  
80100c45:	c3                   	ret    

80100c46 <f>:
void f()
{
80100c46:	55                   	push   %ebp
80100c47:	89 e5                	mov    %esp,%ebp
80100c49:	83 ec 08             	sub    $0x8,%esp
    g();
80100c4c:	e8 d3 ff ff ff       	call   80100c24 <g>
}
80100c51:	90                   	nop
80100c52:	c9                   	leave  
80100c53:	c3                   	ret    

80100c54 <main>:
int main()
{
80100c54:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80100c58:	83 e4 f0             	and    $0xfffffff0,%esp
80100c5b:	ff 71 fc             	pushl  -0x4(%ecx)
80100c5e:	55                   	push   %ebp
80100c5f:	89 e5                	mov    %esp,%ebp
80100c61:	56                   	push   %esi
80100c62:	53                   	push   %ebx
80100c63:	51                   	push   %ecx
80100c64:	83 ec 1c             	sub    $0x1c,%esp
    /*
    extern char __STABSTR_BEGIN__[],__STAB_BEGIN__[],__STAB_END__[];
    struct stab *sts,*ste;
    int left,right;
    */
    console_clear();
80100c67:	e8 93 fd ff ff       	call   801009ff <console_clear>
    uartinit();
80100c6c:	e8 8b fb ff ff       	call   801007fc <uartinit>
    cprintf("data : %x , edata %x , end %x\n",(int)data,(int)edata,(int)end);
80100c71:	b9 f0 a0 10 80       	mov    $0x8010a0f0,%ecx
80100c76:	ba 00 90 10 80       	mov    $0x80109000,%edx
80100c7b:	b8 00 70 10 80       	mov    $0x80107000,%eax
80100c80:	51                   	push   %ecx
80100c81:	52                   	push   %edx
80100c82:	50                   	push   %eax
80100c83:	68 d0 16 10 80       	push   $0x801016d0
80100c88:	e8 84 f7 ff ff       	call   80100411 <cprintf>
80100c8d:	83 c4 10             	add    $0x10,%esp
    //cprintf("%x\n",(int)__STABSTR_BEGIN__);
    cprintf("%s%2c%drl%x\n","Hello",'W',0,13);
80100c90:	83 ec 0c             	sub    $0xc,%esp
80100c93:	6a 0d                	push   $0xd
80100c95:	6a 00                	push   $0x0
80100c97:	6a 57                	push   $0x57
80100c99:	68 ef 16 10 80       	push   $0x801016ef
80100c9e:	68 f5 16 10 80       	push   $0x801016f5
80100ca3:	e8 69 f7 ff ff       	call   80100411 <cprintf>
80100ca8:	83 c4 20             	add    $0x20,%esp
    emap = (struct e820map*)P2V(0x8000);
80100cab:	c7 05 e8 90 10 80 00 	movl   $0x80008000,0x801090e8
80100cb2:	80 00 80 
    if(emap->nr_map == 12345)
80100cb5:	a1 e8 90 10 80       	mov    0x801090e8,%eax
80100cba:	8b 00                	mov    (%eax),%eax
80100cbc:	3d 39 30 00 00       	cmp    $0x3039,%eax
80100cc1:	75 12                	jne    80100cd5 <main+0x81>
        cprintf("error!");
80100cc3:	83 ec 0c             	sub    $0xc,%esp
80100cc6:	68 02 17 10 80       	push   $0x80101702
80100ccb:	e8 41 f7 ff ff       	call   80100411 <cprintf>
80100cd0:	83 c4 10             	add    $0x10,%esp
80100cd3:	eb 7b                	jmp    80100d50 <main+0xfc>
    else
    {
        for(i = 0 ; i < emap->nr_map ; i ++) { 
80100cd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cdc:	eb 66                	jmp    80100d44 <main+0xf0>
            cprintf("start : %8x ,size : %8x, flag : %x\n",(int)emap->map[i].addr,(int)emap->map[i].size,(int)emap->map[i].type);
80100cde:	8b 0d e8 90 10 80    	mov    0x801090e8,%ecx
80100ce4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100ce7:	89 d0                	mov    %edx,%eax
80100ce9:	c1 e0 02             	shl    $0x2,%eax
80100cec:	01 d0                	add    %edx,%eax
80100cee:	c1 e0 02             	shl    $0x2,%eax
80100cf1:	01 c8                	add    %ecx,%eax
80100cf3:	83 c0 14             	add    $0x14,%eax
80100cf6:	8b 08                	mov    (%eax),%ecx
80100cf8:	8b 1d e8 90 10 80    	mov    0x801090e8,%ebx
80100cfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100d01:	89 d0                	mov    %edx,%eax
80100d03:	c1 e0 02             	shl    $0x2,%eax
80100d06:	01 d0                	add    %edx,%eax
80100d08:	c1 e0 02             	shl    $0x2,%eax
80100d0b:	01 d8                	add    %ebx,%eax
80100d0d:	8b 50 10             	mov    0x10(%eax),%edx
80100d10:	8b 40 0c             	mov    0xc(%eax),%eax
80100d13:	89 c6                	mov    %eax,%esi
80100d15:	8b 1d e8 90 10 80    	mov    0x801090e8,%ebx
80100d1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100d1e:	89 d0                	mov    %edx,%eax
80100d20:	c1 e0 02             	shl    $0x2,%eax
80100d23:	01 d0                	add    %edx,%eax
80100d25:	c1 e0 02             	shl    $0x2,%eax
80100d28:	01 d8                	add    %ebx,%eax
80100d2a:	8b 50 08             	mov    0x8(%eax),%edx
80100d2d:	8b 40 04             	mov    0x4(%eax),%eax
80100d30:	51                   	push   %ecx
80100d31:	56                   	push   %esi
80100d32:	50                   	push   %eax
80100d33:	68 0c 17 10 80       	push   $0x8010170c
80100d38:	e8 d4 f6 ff ff       	call   80100411 <cprintf>
80100d3d:	83 c4 10             	add    $0x10,%esp
    emap = (struct e820map*)P2V(0x8000);
    if(emap->nr_map == 12345)
        cprintf("error!");
    else
    {
        for(i = 0 ; i < emap->nr_map ; i ++) { 
80100d40:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d44:	a1 e8 90 10 80       	mov    0x801090e8,%eax
80100d49:	8b 00                	mov    (%eax),%eax
80100d4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80100d4e:	7f 8e                	jg     80100cde <main+0x8a>
            cprintf("start : %8x ,size : %8x, flag : %x\n",(int)emap->map[i].addr,(int)emap->map[i].size,(int)emap->map[i].type);
        }

    }
    mpinit();
80100d50:	e8 21 f9 ff ff       	call   80100676 <mpinit>
    cprintf("cpunum : %d\n", ncpu);
80100d55:	a1 e4 90 10 80       	mov    0x801090e4,%eax
80100d5a:	83 ec 08             	sub    $0x8,%esp
80100d5d:	50                   	push   %eax
80100d5e:	68 30 17 10 80       	push   $0x80101730
80100d63:	e8 a9 f6 ff ff       	call   80100411 <cprintf>
80100d68:	83 c4 10             	add    $0x10,%esp
//    *(int*)(0x80109010 - 4) = 0x12345678;
    f();
80100d6b:	e8 d6 fe ff ff       	call   80100c46 <f>
    cprintf("total : %d\n", right);
    stab_binsearch(sts,&left,&right,N_SO,0x80100007);
    stab_binsearch(sts,&left,&right,N_FUN,0x80100007);
    cprintf("left : %d , right : %d",left, right); 
    */
    while(1);
80100d70:	eb fe                	jmp    80100d70 <main+0x11c>
80100d72:	66 90                	xchg   %ax,%ax

80100d74 <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
80100d74:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
80100d77:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100d7a:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100d7d:	b8 00 80 10 00       	mov    $0x108000,%eax
  movl    %eax, %cr3
80100d82:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
80100d85:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100d88:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100d8d:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE ), %esp
80100d90:	bc f0 a0 10 80       	mov    $0x8010a0f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
80100d95:	b8 54 0c 10 80       	mov    $0x80100c54,%eax
  jmp *%eax
80100d9a:	ff e0                	jmp    *%eax

80100d9c <print_int>:
#include "defs.h"
#include "stdarg.h"
#include "string.h"
#define CH_MAX 15
static void print_int(void (*putch)(char),int num, int base, int width)
{
80100d9c:	55                   	push   %ebp
80100d9d:	89 e5                	mov    %esp,%ebp
80100d9f:	83 ec 28             	sub    $0x28,%esp
    char strr[CH_MAX];
    char *str = strr;
80100da2:	8d 45 e1             	lea    -0x1f(%ebp),%eax
80100da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int len;
    itoa(num, str, base);
80100da8:	83 ec 04             	sub    $0x4,%esp
80100dab:	ff 75 10             	pushl  0x10(%ebp)
80100dae:	ff 75 f4             	pushl  -0xc(%ebp)
80100db1:	ff 75 0c             	pushl  0xc(%ebp)
80100db4:	e8 14 07 00 00       	call   801014cd <itoa>
80100db9:	83 c4 10             	add    $0x10,%esp
    len = strlen(str);
80100dbc:	83 ec 0c             	sub    $0xc,%esp
80100dbf:	ff 75 f4             	pushl  -0xc(%ebp)
80100dc2:	e8 37 02 00 00       	call   80100ffe <strlen>
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(width > len)
80100dcd:	eb 11                	jmp    80100de0 <print_int+0x44>
    {
        putch(' ');
80100dcf:	83 ec 0c             	sub    $0xc,%esp
80100dd2:	6a 20                	push   $0x20
80100dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80100dd7:	ff d0                	call   *%eax
80100dd9:	83 c4 10             	add    $0x10,%esp
        width --;
80100ddc:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
    char strr[CH_MAX];
    char *str = strr;
    int len;
    itoa(num, str, base);
    len = strlen(str);
    while(width > len)
80100de0:	8b 45 14             	mov    0x14(%ebp),%eax
80100de3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80100de6:	7f e7                	jg     80100dcf <print_int+0x33>
    {
        putch(' ');
        width --;
    }
    while(*str != '\0')
80100de8:	eb 19                	jmp    80100e03 <print_int+0x67>
    {
        putch(*str);
80100dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ded:	0f b6 00             	movzbl (%eax),%eax
80100df0:	0f be c0             	movsbl %al,%eax
80100df3:	83 ec 0c             	sub    $0xc,%esp
80100df6:	50                   	push   %eax
80100df7:	8b 45 08             	mov    0x8(%ebp),%eax
80100dfa:	ff d0                	call   *%eax
80100dfc:	83 c4 10             	add    $0x10,%esp
        str ++;
80100dff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while(width > len)
    {
        putch(' ');
        width --;
    }
    while(*str != '\0')
80100e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e06:	0f b6 00             	movzbl (%eax),%eax
80100e09:	84 c0                	test   %al,%al
80100e0b:	75 dd                	jne    80100dea <print_int+0x4e>
    {
        putch(*str);
        str ++;
    }
}
80100e0d:	90                   	nop
80100e0e:	c9                   	leave  
80100e0f:	c3                   	ret    

80100e10 <vprintfmt>:
int vprintfmt(void (*putch)(char), const char *fmt, va_list ap)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 28             	sub    $0x28,%esp
    char ch;
    char *str;
    int len = 0;
80100e16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    int num = 0;
80100e1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    int width = 0;
80100e24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while((ch = *fmt) != '\0')
80100e2b:	e9 b3 01 00 00       	jmp    80100fe3 <vprintfmt+0x1d3>
    {
       if(ch == '%' || width != 0)
80100e30:	80 7d f7 25          	cmpb   $0x25,-0x9(%ebp)
80100e34:	74 0a                	je     80100e40 <vprintfmt+0x30>
80100e36:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100e3a:	0f 84 8f 01 00 00    	je     80100fcf <vprintfmt+0x1bf>
       {
           if(width == 0)
80100e40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100e44:	75 0d                	jne    80100e53 <vprintfmt+0x43>
           ch = *(++fmt);
80100e46:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80100e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e4d:	0f b6 00             	movzbl (%eax),%eax
80100e50:	88 45 f7             	mov    %al,-0x9(%ebp)
           if(ch == '\0')
80100e53:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
80100e57:	0f 84 9b 01 00 00    	je     80100ff8 <vprintfmt+0x1e8>
           {
               break;
           }

           switch(ch)
80100e5d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
80100e61:	83 f8 63             	cmp    $0x63,%eax
80100e64:	0f 84 20 01 00 00    	je     80100f8a <vprintfmt+0x17a>
80100e6a:	83 f8 63             	cmp    $0x63,%eax
80100e6d:	7f 20                	jg     80100e8f <vprintfmt+0x7f>
80100e6f:	83 f8 25             	cmp    $0x25,%eax
80100e72:	0f 84 43 01 00 00    	je     80100fbb <vprintfmt+0x1ab>
80100e78:	83 f8 25             	cmp    $0x25,%eax
80100e7b:	0f 8c 48 01 00 00    	jl     80100fc9 <vprintfmt+0x1b9>
80100e81:	83 e8 31             	sub    $0x31,%eax
80100e84:	83 f8 08             	cmp    $0x8,%eax
80100e87:	0f 87 3c 01 00 00    	ja     80100fc9 <vprintfmt+0x1b9>
80100e8d:	eb 18                	jmp    80100ea7 <vprintfmt+0x97>
80100e8f:	83 f8 73             	cmp    $0x73,%eax
80100e92:	74 5a                	je     80100eee <vprintfmt+0xde>
80100e94:	83 f8 78             	cmp    $0x78,%eax
80100e97:	0f 84 bb 00 00 00    	je     80100f58 <vprintfmt+0x148>
80100e9d:	83 f8 64             	cmp    $0x64,%eax
80100ea0:	74 24                	je     80100ec6 <vprintfmt+0xb6>
80100ea2:	e9 22 01 00 00       	jmp    80100fc9 <vprintfmt+0x1b9>
           {
               case '1' ... '9':
                   width = width * 10 +  ch - '0';
80100ea7:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100eaa:	89 d0                	mov    %edx,%eax
80100eac:	c1 e0 02             	shl    $0x2,%eax
80100eaf:	01 d0                	add    %edx,%eax
80100eb1:	01 c0                	add    %eax,%eax
80100eb3:	89 c2                	mov    %eax,%edx
80100eb5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
80100eb9:	01 d0                	add    %edx,%eax
80100ebb:	83 e8 30             	sub    $0x30,%eax
80100ebe:	89 45 e8             	mov    %eax,-0x18(%ebp)
                   break;
80100ec1:	e9 03 01 00 00       	jmp    80100fc9 <vprintfmt+0x1b9>
               case 'd' :
                   print_int(putch, va_arg(ap, int),10, width);
80100ec6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ec9:	8d 50 04             	lea    0x4(%eax),%edx
80100ecc:	89 55 10             	mov    %edx,0x10(%ebp)
80100ecf:	8b 00                	mov    (%eax),%eax
80100ed1:	ff 75 e8             	pushl  -0x18(%ebp)
80100ed4:	6a 0a                	push   $0xa
80100ed6:	50                   	push   %eax
80100ed7:	ff 75 08             	pushl  0x8(%ebp)
80100eda:	e8 bd fe ff ff       	call   80100d9c <print_int>
80100edf:	83 c4 10             	add    $0x10,%esp
                   width = 0;
80100ee2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   break;
80100ee9:	e9 db 00 00 00       	jmp    80100fc9 <vprintfmt+0x1b9>
               case 's' :
                   str = va_arg(ap, char*);
80100eee:	8b 45 10             	mov    0x10(%ebp),%eax
80100ef1:	8d 50 04             	lea    0x4(%eax),%edx
80100ef4:	89 55 10             	mov    %edx,0x10(%ebp)
80100ef7:	8b 00                	mov    (%eax),%eax
80100ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
                   len = strlen(str);
80100efc:	83 ec 0c             	sub    $0xc,%esp
80100eff:	ff 75 f0             	pushl  -0x10(%ebp)
80100f02:	e8 f7 00 00 00       	call   80100ffe <strlen>
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                   while(width > len)
80100f0d:	eb 11                	jmp    80100f20 <vprintfmt+0x110>
                   {
                       putch(' ');
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	6a 20                	push   $0x20
80100f14:	8b 45 08             	mov    0x8(%ebp),%eax
80100f17:	ff d0                	call   *%eax
80100f19:	83 c4 10             	add    $0x10,%esp
                       width --;
80100f1c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
                   width = 0;
                   break;
               case 's' :
                   str = va_arg(ap, char*);
                   len = strlen(str);
                   while(width > len)
80100f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100f23:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80100f26:	7f e7                	jg     80100f0f <vprintfmt+0xff>
                   {
                       putch(' ');
                       width --;
                   }
                   while(*str != '\0') 
80100f28:	eb 1b                	jmp    80100f45 <vprintfmt+0x135>
                   {
                       putch(*str ++);
80100f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f2d:	8d 50 01             	lea    0x1(%eax),%edx
80100f30:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100f33:	0f b6 00             	movzbl (%eax),%eax
80100f36:	0f be c0             	movsbl %al,%eax
80100f39:	83 ec 0c             	sub    $0xc,%esp
80100f3c:	50                   	push   %eax
80100f3d:	8b 45 08             	mov    0x8(%ebp),%eax
80100f40:	ff d0                	call   *%eax
80100f42:	83 c4 10             	add    $0x10,%esp
                   while(width > len)
                   {
                       putch(' ');
                       width --;
                   }
                   while(*str != '\0') 
80100f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f48:	0f b6 00             	movzbl (%eax),%eax
80100f4b:	84 c0                	test   %al,%al
80100f4d:	75 db                	jne    80100f2a <vprintfmt+0x11a>
                   {
                       putch(*str ++);
                   }
                   width = 0;
80100f4f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   break;
80100f56:	eb 71                	jmp    80100fc9 <vprintfmt+0x1b9>
               case 'x' :
                   print_int(putch, va_arg(ap,int), 16, width);
80100f58:	8b 45 10             	mov    0x10(%ebp),%eax
80100f5b:	8d 50 04             	lea    0x4(%eax),%edx
80100f5e:	89 55 10             	mov    %edx,0x10(%ebp)
80100f61:	8b 00                	mov    (%eax),%eax
80100f63:	ff 75 e8             	pushl  -0x18(%ebp)
80100f66:	6a 10                	push   $0x10
80100f68:	50                   	push   %eax
80100f69:	ff 75 08             	pushl  0x8(%ebp)
80100f6c:	e8 2b fe ff ff       	call   80100d9c <print_int>
80100f71:	83 c4 10             	add    $0x10,%esp
                   width = 0;
80100f74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   break;
80100f7b:	eb 4c                	jmp    80100fc9 <vprintfmt+0x1b9>
               case 'c' :
                   while(width-- > 1)
                   {
                       putch(' ');
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	6a 20                	push   $0x20
80100f82:	8b 45 08             	mov    0x8(%ebp),%eax
80100f85:	ff d0                	call   *%eax
80100f87:	83 c4 10             	add    $0x10,%esp
               case 'x' :
                   print_int(putch, va_arg(ap,int), 16, width);
                   width = 0;
                   break;
               case 'c' :
                   while(width-- > 1)
80100f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
80100f90:	89 55 e8             	mov    %edx,-0x18(%ebp)
80100f93:	83 f8 01             	cmp    $0x1,%eax
80100f96:	7f e5                	jg     80100f7d <vprintfmt+0x16d>
                   {
                       putch(' ');
                   }
                   putch(va_arg(ap,int));
80100f98:	8b 45 10             	mov    0x10(%ebp),%eax
80100f9b:	8d 50 04             	lea    0x4(%eax),%edx
80100f9e:	89 55 10             	mov    %edx,0x10(%ebp)
80100fa1:	8b 00                	mov    (%eax),%eax
80100fa3:	0f be c0             	movsbl %al,%eax
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	50                   	push   %eax
80100faa:	8b 45 08             	mov    0x8(%ebp),%eax
80100fad:	ff d0                	call   *%eax
80100faf:	83 c4 10             	add    $0x10,%esp
                   width = 0;
80100fb2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
                   break;
80100fb9:	eb 0e                	jmp    80100fc9 <vprintfmt+0x1b9>
               case '%' :
                   putch('%');
80100fbb:	83 ec 0c             	sub    $0xc,%esp
80100fbe:	6a 25                	push   $0x25
80100fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc3:	ff d0                	call   *%eax
80100fc5:	83 c4 10             	add    $0x10,%esp
                   break;
80100fc8:	90                   	nop
               default:
                   ;
           }
           num ++;
80100fc9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100fcd:	eb 10                	jmp    80100fdf <vprintfmt+0x1cf>
       }else{
           putch(ch);
80100fcf:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
80100fd3:	83 ec 0c             	sub    $0xc,%esp
80100fd6:	50                   	push   %eax
80100fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100fda:	ff d0                	call   *%eax
80100fdc:	83 c4 10             	add    $0x10,%esp
       }
       fmt ++;
80100fdf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    char ch;
    char *str;
    int len = 0;
    int num = 0;
    int width = 0;
    while((ch = *fmt) != '\0')
80100fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fe6:	0f b6 00             	movzbl (%eax),%eax
80100fe9:	88 45 f7             	mov    %al,-0x9(%ebp)
80100fec:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
80100ff0:	0f 85 3a fe ff ff    	jne    80100e30 <vprintfmt+0x20>
80100ff6:	eb 01                	jmp    80100ff9 <vprintfmt+0x1e9>
       {
           if(width == 0)
           ch = *(++fmt);
           if(ch == '\0')
           {
               break;
80100ff8:	90                   	nop
       }else{
           putch(ch);
       }
       fmt ++;
    }
    return num;
80100ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80100ffc:	c9                   	leave  
80100ffd:	c3                   	ret    

80100ffe <strlen>:
 * @s   the input string
 * Return:  the length of string @s
 */
size_t 
strlen(const char *s)
{
80100ffe:	55                   	push   %ebp
80100fff:	89 e5                	mov    %esp,%ebp
80101001:	83 ec 10             	sub    $0x10,%esp
    size_t n = 0;
80101004:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s ++ != '\0')
8010100b:	eb 04                	jmp    80101011 <strlen+0x13>
    {
        n ++;
8010100d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 */
size_t 
strlen(const char *s)
{
    size_t n = 0;
    while(*s ++ != '\0')
80101011:	8b 45 08             	mov    0x8(%ebp),%eax
80101014:	8d 50 01             	lea    0x1(%eax),%edx
80101017:	89 55 08             	mov    %edx,0x8(%ebp)
8010101a:	0f b6 00             	movzbl (%eax),%eax
8010101d:	84 c0                	test   %al,%al
8010101f:	75 ec                	jne    8010100d <strlen+0xf>
    {
        n ++;
    }
    return n;
80101021:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80101024:	c9                   	leave  
80101025:	c3                   	ret    

80101026 <strnlen>:
/*
 * calculate the length of the string @s,stop when it meet '\0' character, but at most @len
 */
size_t
strnlen(const char *s, size_t len)
{
80101026:	55                   	push   %ebp
80101027:	89 e5                	mov    %esp,%ebp
80101029:	83 ec 10             	sub    $0x10,%esp
  size_t cnt = 0;  
8010102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while( cnt < len && *s ++ != '\0')
80101033:	eb 04                	jmp    80101039 <strnlen+0x13>
  {
      cnt ++;
80101035:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 */
size_t
strnlen(const char *s, size_t len)
{
  size_t cnt = 0;  
  while( cnt < len && *s ++ != '\0')
80101039:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010103c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010103f:	73 10                	jae    80101051 <strnlen+0x2b>
80101041:	8b 45 08             	mov    0x8(%ebp),%eax
80101044:	8d 50 01             	lea    0x1(%eax),%edx
80101047:	89 55 08             	mov    %edx,0x8(%ebp)
8010104a:	0f b6 00             	movzbl (%eax),%eax
8010104d:	84 c0                	test   %al,%al
8010104f:	75 e4                	jne    80101035 <strnlen+0xf>
  {
      cnt ++;
  }
  return cnt;
80101051:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80101054:	c9                   	leave  
80101055:	c3                   	ret    

80101056 <strcpy>:
/*
 * copies the string pointed by @src into the array pointed by @dst.
 */
char*
strcpy(char *dst, const char *src)
{
80101056:	55                   	push   %ebp
80101057:	89 e5                	mov    %esp,%ebp
80101059:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
8010105c:	8b 45 08             	mov    0x8(%ebp),%eax
8010105f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while((*p ++ = *src ++) != '\0')
80101062:	90                   	nop
80101063:	8b 45 fc             	mov    -0x4(%ebp),%eax
80101066:	8d 50 01             	lea    0x1(%eax),%edx
80101069:	89 55 fc             	mov    %edx,-0x4(%ebp)
8010106c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010106f:	8d 4a 01             	lea    0x1(%edx),%ecx
80101072:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80101075:	0f b6 12             	movzbl (%edx),%edx
80101078:	88 10                	mov    %dl,(%eax)
8010107a:	0f b6 00             	movzbl (%eax),%eax
8010107d:	84 c0                	test   %al,%al
8010107f:	75 e2                	jne    80101063 <strcpy+0xd>
        ;
    return dst;
80101081:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101084:	c9                   	leave  
80101085:	c3                   	ret    

80101086 <strncpy>:
 * copies the string pointed by @src into the array pointed by @dst, but at most @len.
 * if found character '\0' before @len characters, it won't copy any characters.
 */
char*
strncpy(char *dst, const char *src, size_t len)
{
80101086:	55                   	push   %ebp
80101087:	89 e5                	mov    %esp,%ebp
80101089:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
8010108c:	8b 45 08             	mov    0x8(%ebp),%eax
8010108f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(len > 0)
80101092:	eb 21                	jmp    801010b5 <strncpy+0x2f>
    {
       if((*p = *src) != '\0')
80101094:	8b 45 0c             	mov    0xc(%ebp),%eax
80101097:	0f b6 10             	movzbl (%eax),%edx
8010109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010109d:	88 10                	mov    %dl,(%eax)
8010109f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801010a2:	0f b6 00             	movzbl (%eax),%eax
801010a5:	84 c0                	test   %al,%al
801010a7:	74 14                	je     801010bd <strncpy+0x37>
       {
           src ++;
801010a9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
           p ++;
801010ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
           len --;
801010b1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 */
char*
strncpy(char *dst, const char *src, size_t len)
{
    char *p = dst;
    while(len > 0)
801010b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801010b9:	75 d9                	jne    80101094 <strncpy+0xe>
801010bb:	eb 01                	jmp    801010be <strncpy+0x38>
       {
           src ++;
           p ++;
           len --;
       }else{
           break;
801010bd:	90                   	nop
       }

    }
    return dst;
801010be:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010c1:	c9                   	leave  
801010c2:	c3                   	ret    

801010c3 <strcmp>:
/*
 * compares the string @s1 and @s2.
 */
int
strcmp(const char *s1, const char *s2)
{
801010c3:	55                   	push   %ebp
801010c4:	89 e5                	mov    %esp,%ebp
    while(*s2 != '\0' && *s2 != '\0')
801010c6:	eb 18                	jmp    801010e0 <strcmp+0x1d>
    {
        if(*s1 != *s2)
801010c8:	8b 45 08             	mov    0x8(%ebp),%eax
801010cb:	0f b6 10             	movzbl (%eax),%edx
801010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801010d1:	0f b6 00             	movzbl (%eax),%eax
801010d4:	38 c2                	cmp    %al,%dl
801010d6:	75 1e                	jne    801010f6 <strcmp+0x33>
        {
            break;
        }
        s1 ++;
801010d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        s2 ++;
801010dc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * compares the string @s1 and @s2.
 */
int
strcmp(const char *s1, const char *s2)
{
    while(*s2 != '\0' && *s2 != '\0')
801010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801010e3:	0f b6 00             	movzbl (%eax),%eax
801010e6:	84 c0                	test   %al,%al
801010e8:	74 0d                	je     801010f7 <strcmp+0x34>
801010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801010ed:	0f b6 00             	movzbl (%eax),%eax
801010f0:	84 c0                	test   %al,%al
801010f2:	75 d4                	jne    801010c8 <strcmp+0x5>
801010f4:	eb 01                	jmp    801010f7 <strcmp+0x34>
    {
        if(*s1 != *s2)
        {
            break;
801010f6:	90                   	nop
        }
        s1 ++;
        s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
801010f7:	8b 45 08             	mov    0x8(%ebp),%eax
801010fa:	0f b6 00             	movzbl (%eax),%eax
801010fd:	0f b6 d0             	movzbl %al,%edx
80101100:	8b 45 0c             	mov    0xc(%ebp),%eax
80101103:	0f b6 00             	movzbl (%eax),%eax
80101106:	0f b6 c0             	movzbl %al,%eax
80101109:	29 c2                	sub    %eax,%edx
8010110b:	89 d0                	mov    %edx,%eax
}
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    

8010110f <strncmp>:
 * if found character '\0' before @len characters, it won't copy any characters.
 * but at most @n.
 */
int
strncmp(const char *s1, const char *s2, size_t n)
{
8010110f:	55                   	push   %ebp
80101110:	89 e5                	mov    %esp,%ebp
    while(n > 0 && *s1 != '\0' && *s1 == *s2)
80101112:	eb 0c                	jmp    80101120 <strncmp+0x11>
    {
        n --, s1 ++ ,s2 ++;
80101114:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80101118:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010111c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * but at most @n.
 */
int
strncmp(const char *s1, const char *s2, size_t n)
{
    while(n > 0 && *s1 != '\0' && *s1 == *s2)
80101120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101124:	74 1a                	je     80101140 <strncmp+0x31>
80101126:	8b 45 08             	mov    0x8(%ebp),%eax
80101129:	0f b6 00             	movzbl (%eax),%eax
8010112c:	84 c0                	test   %al,%al
8010112e:	74 10                	je     80101140 <strncmp+0x31>
80101130:	8b 45 08             	mov    0x8(%ebp),%eax
80101133:	0f b6 10             	movzbl (%eax),%edx
80101136:	8b 45 0c             	mov    0xc(%ebp),%eax
80101139:	0f b6 00             	movzbl (%eax),%eax
8010113c:	38 c2                	cmp    %al,%dl
8010113e:	74 d4                	je     80101114 <strncmp+0x5>
    {
        n --, s1 ++ ,s2 ++;
    }
    return n == 0 ? 0 : ((int)((unsigned char)*s1 - (unsigned char)*s2));
80101140:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101144:	74 18                	je     8010115e <strncmp+0x4f>
80101146:	8b 45 08             	mov    0x8(%ebp),%eax
80101149:	0f b6 00             	movzbl (%eax),%eax
8010114c:	0f b6 d0             	movzbl %al,%edx
8010114f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101152:	0f b6 00             	movzbl (%eax),%eax
80101155:	0f b6 c0             	movzbl %al,%eax
80101158:	29 c2                	sub    %eax,%edx
8010115a:	89 d0                	mov    %edx,%eax
8010115c:	eb 05                	jmp    80101163 <strncmp+0x54>
8010115e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101163:	5d                   	pop    %ebp
80101164:	c3                   	ret    

80101165 <strchr>:
/*
 * locates first occurrence of character in string.
 */
char*
strchr(const char *s, char c)
{
80101165:	55                   	push   %ebp
80101166:	89 e5                	mov    %esp,%ebp
80101168:	83 ec 04             	sub    $0x4,%esp
8010116b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010116e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while(*s != '\0')
80101171:	eb 14                	jmp    80101187 <strchr+0x22>
    {
        if(*s == c)
80101173:	8b 45 08             	mov    0x8(%ebp),%eax
80101176:	0f b6 00             	movzbl (%eax),%eax
80101179:	3a 45 fc             	cmp    -0x4(%ebp),%al
8010117c:	75 05                	jne    80101183 <strchr+0x1e>
        {
            return (char*)s;
8010117e:	8b 45 08             	mov    0x8(%ebp),%eax
80101181:	eb 13                	jmp    80101196 <strchr+0x31>
        }
        s ++;
80101183:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * locates first occurrence of character in string.
 */
char*
strchr(const char *s, char c)
{
    while(*s != '\0')
80101187:	8b 45 08             	mov    0x8(%ebp),%eax
8010118a:	0f b6 00             	movzbl (%eax),%eax
8010118d:	84 c0                	test   %al,%al
8010118f:	75 e2                	jne    80101173 <strchr+0xe>
        {
            return (char*)s;
        }
        s ++;
    }
    return NULL;
80101191:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101196:	c9                   	leave  
80101197:	c3                   	ret    

80101198 <strfind>:
/*
 * locates first occurrence of character in string ,but it returns the end of character instead of character NULL.
 */
char*
strfind(const char *s, char c)
{
80101198:	55                   	push   %ebp
80101199:	89 e5                	mov    %esp,%ebp
8010119b:	83 ec 04             	sub    $0x4,%esp
8010119e:	8b 45 0c             	mov    0xc(%ebp),%eax
801011a1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while(*s != '\0')
801011a4:	eb 0f                	jmp    801011b5 <strfind+0x1d>
    {
        if(*s == c)
801011a6:	8b 45 08             	mov    0x8(%ebp),%eax
801011a9:	0f b6 00             	movzbl (%eax),%eax
801011ac:	3a 45 fc             	cmp    -0x4(%ebp),%al
801011af:	74 10                	je     801011c1 <strfind+0x29>
        {
            break;
        }
        s ++;
801011b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * locates first occurrence of character in string ,but it returns the end of character instead of character NULL.
 */
char*
strfind(const char *s, char c)
{
    while(*s != '\0')
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	0f b6 00             	movzbl (%eax),%eax
801011bb:	84 c0                	test   %al,%al
801011bd:	75 e7                	jne    801011a6 <strfind+0xe>
801011bf:	eb 01                	jmp    801011c2 <strfind+0x2a>
    {
        if(*s == c)
        {
            break;
801011c1:	90                   	nop
        }
        s ++;
    }
    return (char*)s;
801011c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801011c5:	c9                   	leave  
801011c6:	c3                   	ret    

801011c7 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
801011c7:	55                   	push   %ebp
801011c8:	89 e5                	mov    %esp,%ebp
801011ca:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
801011cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
801011d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
801011db:	eb 04                	jmp    801011e1 <strtol+0x1a>
        s ++;
801011dd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	0f b6 00             	movzbl (%eax),%eax
801011e7:	3c 20                	cmp    $0x20,%al
801011e9:	74 f2                	je     801011dd <strtol+0x16>
801011eb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ee:	0f b6 00             	movzbl (%eax),%eax
801011f1:	3c 09                	cmp    $0x9,%al
801011f3:	74 e8                	je     801011dd <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
801011f5:	8b 45 08             	mov    0x8(%ebp),%eax
801011f8:	0f b6 00             	movzbl (%eax),%eax
801011fb:	3c 2b                	cmp    $0x2b,%al
801011fd:	75 06                	jne    80101205 <strtol+0x3e>
        s ++;
801011ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80101203:	eb 15                	jmp    8010121a <strtol+0x53>
    }
    else if (*s == '-') {
80101205:	8b 45 08             	mov    0x8(%ebp),%eax
80101208:	0f b6 00             	movzbl (%eax),%eax
8010120b:	3c 2d                	cmp    $0x2d,%al
8010120d:	75 0b                	jne    8010121a <strtol+0x53>
        s ++, neg = 1;
8010120f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80101213:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
8010121a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010121e:	74 06                	je     80101226 <strtol+0x5f>
80101220:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
80101224:	75 24                	jne    8010124a <strtol+0x83>
80101226:	8b 45 08             	mov    0x8(%ebp),%eax
80101229:	0f b6 00             	movzbl (%eax),%eax
8010122c:	3c 30                	cmp    $0x30,%al
8010122e:	75 1a                	jne    8010124a <strtol+0x83>
80101230:	8b 45 08             	mov    0x8(%ebp),%eax
80101233:	83 c0 01             	add    $0x1,%eax
80101236:	0f b6 00             	movzbl (%eax),%eax
80101239:	3c 78                	cmp    $0x78,%al
8010123b:	75 0d                	jne    8010124a <strtol+0x83>
        s += 2, base = 16;
8010123d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
80101241:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
80101248:	eb 2a                	jmp    80101274 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
8010124a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010124e:	75 17                	jne    80101267 <strtol+0xa0>
80101250:	8b 45 08             	mov    0x8(%ebp),%eax
80101253:	0f b6 00             	movzbl (%eax),%eax
80101256:	3c 30                	cmp    $0x30,%al
80101258:	75 0d                	jne    80101267 <strtol+0xa0>
        s ++, base = 8;
8010125a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010125e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
80101265:	eb 0d                	jmp    80101274 <strtol+0xad>
    }
    else if (base == 0) {
80101267:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010126b:	75 07                	jne    80101274 <strtol+0xad>
        base = 10;
8010126d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
80101274:	8b 45 08             	mov    0x8(%ebp),%eax
80101277:	0f b6 00             	movzbl (%eax),%eax
8010127a:	3c 2f                	cmp    $0x2f,%al
8010127c:	7e 1b                	jle    80101299 <strtol+0xd2>
8010127e:	8b 45 08             	mov    0x8(%ebp),%eax
80101281:	0f b6 00             	movzbl (%eax),%eax
80101284:	3c 39                	cmp    $0x39,%al
80101286:	7f 11                	jg     80101299 <strtol+0xd2>
            dig = *s - '0';
80101288:	8b 45 08             	mov    0x8(%ebp),%eax
8010128b:	0f b6 00             	movzbl (%eax),%eax
8010128e:	0f be c0             	movsbl %al,%eax
80101291:	83 e8 30             	sub    $0x30,%eax
80101294:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101297:	eb 48                	jmp    801012e1 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	0f b6 00             	movzbl (%eax),%eax
8010129f:	3c 60                	cmp    $0x60,%al
801012a1:	7e 1b                	jle    801012be <strtol+0xf7>
801012a3:	8b 45 08             	mov    0x8(%ebp),%eax
801012a6:	0f b6 00             	movzbl (%eax),%eax
801012a9:	3c 7a                	cmp    $0x7a,%al
801012ab:	7f 11                	jg     801012be <strtol+0xf7>
            dig = *s - 'a' + 10;
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	0f b6 00             	movzbl (%eax),%eax
801012b3:	0f be c0             	movsbl %al,%eax
801012b6:	83 e8 57             	sub    $0x57,%eax
801012b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012bc:	eb 23                	jmp    801012e1 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
801012be:	8b 45 08             	mov    0x8(%ebp),%eax
801012c1:	0f b6 00             	movzbl (%eax),%eax
801012c4:	3c 40                	cmp    $0x40,%al
801012c6:	7e 3c                	jle    80101304 <strtol+0x13d>
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	0f b6 00             	movzbl (%eax),%eax
801012ce:	3c 5a                	cmp    $0x5a,%al
801012d0:	7f 32                	jg     80101304 <strtol+0x13d>
            dig = *s - 'A' + 10;
801012d2:	8b 45 08             	mov    0x8(%ebp),%eax
801012d5:	0f b6 00             	movzbl (%eax),%eax
801012d8:	0f be c0             	movsbl %al,%eax
801012db:	83 e8 37             	sub    $0x37,%eax
801012de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
801012e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e7:	7d 1a                	jge    80101303 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
801012e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
801012f0:	0f af 45 10          	imul   0x10(%ebp),%eax
801012f4:	89 c2                	mov    %eax,%edx
801012f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012f9:	01 d0                	add    %edx,%eax
801012fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
801012fe:	e9 71 ff ff ff       	jmp    80101274 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
80101303:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
80101304:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80101308:	74 08                	je     80101312 <strtol+0x14b>
        *endptr = (char *) s;
8010130a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010130d:	8b 55 08             	mov    0x8(%ebp),%edx
80101310:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
80101312:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80101316:	74 07                	je     8010131f <strtol+0x158>
80101318:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010131b:	f7 d8                	neg    %eax
8010131d:	eb 03                	jmp    80101322 <strtol+0x15b>
8010131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80101322:	c9                   	leave  
80101323:	c3                   	ret    

80101324 <memset>:
 * sets the first @n bytes of the memory area pointed by @s
 * to the specified value @c.
 */
void*
memset(void *s, char c, size_t n)
{
80101324:	55                   	push   %ebp
80101325:	89 e5                	mov    %esp,%ebp
80101327:	83 ec 14             	sub    $0x14,%esp
8010132a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010132d:	88 45 ec             	mov    %al,-0x14(%ebp)
    char *p = s;
80101330:	8b 45 08             	mov    0x8(%ebp),%eax
80101333:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while(n > 0)
80101336:	eb 13                	jmp    8010134b <memset+0x27>
    {
        *p ++ = c;
80101338:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010133b:	8d 50 01             	lea    0x1(%eax),%edx
8010133e:	89 55 fc             	mov    %edx,-0x4(%ebp)
80101341:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
80101345:	88 10                	mov    %dl,(%eax)
        n --;
80101347:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 */
void*
memset(void *s, char c, size_t n)
{
    char *p = s;
    while(n > 0)
8010134b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010134f:	75 e7                	jne    80101338 <memset+0x14>
    {
        *p ++ = c;
        n --;
    }
    return s;
80101351:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101354:	c9                   	leave  
80101355:	c3                   	ret    

80101356 <memmove>:
 * copies the values of @n bytes from the location pointed by @src to
 * the memory area pointed by @dst. @src and @dst are allowed to overlap.
 */
void*
memmove(void *dst, const void *src, size_t n)
{
80101356:	55                   	push   %ebp
80101357:	89 e5                	mov    %esp,%ebp
80101359:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
8010135c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010135f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
80101362:	8b 45 08             	mov    0x8(%ebp),%eax
80101365:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
80101368:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010136b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010136e:	73 54                	jae    801013c4 <memmove+0x6e>
80101370:	8b 55 fc             	mov    -0x4(%ebp),%edx
80101373:	8b 45 10             	mov    0x10(%ebp),%eax
80101376:	01 d0                	add    %edx,%eax
80101378:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010137b:	76 47                	jbe    801013c4 <memmove+0x6e>
        s += n, d += n;
8010137d:	8b 45 10             	mov    0x10(%ebp),%eax
80101380:	01 45 fc             	add    %eax,-0x4(%ebp)
80101383:	8b 45 10             	mov    0x10(%ebp),%eax
80101386:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
80101389:	eb 13                	jmp    8010139e <memmove+0x48>
            *-- d = *-- s;
8010138b:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010138f:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80101393:	8b 45 fc             	mov    -0x4(%ebp),%eax
80101396:	0f b6 10             	movzbl (%eax),%edx
80101399:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010139c:	88 10                	mov    %dl,(%eax)
{
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
8010139e:	8b 45 10             	mov    0x10(%ebp),%eax
801013a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801013a4:	89 55 10             	mov    %edx,0x10(%ebp)
801013a7:	85 c0                	test   %eax,%eax
801013a9:	75 e0                	jne    8010138b <memmove+0x35>
void*
memmove(void *dst, const void *src, size_t n)
{
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
801013ab:	eb 24                	jmp    801013d1 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
801013ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
801013b0:	8d 50 01             	lea    0x1(%eax),%edx
801013b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
801013b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801013b9:	8d 4a 01             	lea    0x1(%edx),%ecx
801013bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801013bf:	0f b6 12             	movzbl (%edx),%edx
801013c2:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
801013c4:	8b 45 10             	mov    0x10(%ebp),%eax
801013c7:	8d 50 ff             	lea    -0x1(%eax),%edx
801013ca:	89 55 10             	mov    %edx,0x10(%ebp)
801013cd:	85 c0                	test   %eax,%eax
801013cf:	75 dc                	jne    801013ad <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
801013d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801013d4:	c9                   	leave  
801013d5:	c3                   	ret    

801013d6 <memcpy>:
 * copies the value of @n bytes from the location pointed by @src to
 * the memory area pointed by @dst.
 */
void*
memcpy(void *dst, const void *src, size_t n)
{
801013d6:	55                   	push   %ebp
801013d7:	89 e5                	mov    %esp,%ebp
801013d9:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
801013dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801013df:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
801013e2:	8b 45 08             	mov    0x8(%ebp),%eax
801013e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
801013e8:	eb 17                	jmp    80101401 <memcpy+0x2b>
        *d ++ = *s ++;
801013ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
801013ed:	8d 50 01             	lea    0x1(%eax),%edx
801013f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
801013f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801013f6:	8d 4a 01             	lea    0x1(%edx),%ecx
801013f9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801013fc:	0f b6 12             	movzbl (%edx),%edx
801013ff:	88 10                	mov    %dl,(%eax)
void*
memcpy(void *dst, const void *src, size_t n)
{
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
80101401:	8b 45 10             	mov    0x10(%ebp),%eax
80101404:	8d 50 ff             	lea    -0x1(%eax),%edx
80101407:	89 55 10             	mov    %edx,0x10(%ebp)
8010140a:	85 c0                	test   %eax,%eax
8010140c:	75 dc                	jne    801013ea <memcpy+0x14>
        *d ++ = *s ++;
    }
    return dst;
8010140e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101411:	c9                   	leave  
80101412:	c3                   	ret    

80101413 <memcmp>:
/*
 * compares two blocks of memory
 */
int
memcmp(const void *v1, const void *v2, size_t n)
{
80101413:	55                   	push   %ebp
80101414:	89 e5                	mov    %esp,%ebp
80101416:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
80101419:	8b 45 08             	mov    0x8(%ebp),%eax
8010141c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
8010141f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101422:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
80101425:	eb 30                	jmp    80101457 <memcmp+0x44>
        if (*s1 != *s2) {
80101427:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010142a:	0f b6 10             	movzbl (%eax),%edx
8010142d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80101430:	0f b6 00             	movzbl (%eax),%eax
80101433:	38 c2                	cmp    %al,%dl
80101435:	74 18                	je     8010144f <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
80101437:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010143a:	0f b6 00             	movzbl (%eax),%eax
8010143d:	0f b6 d0             	movzbl %al,%edx
80101440:	8b 45 f8             	mov    -0x8(%ebp),%eax
80101443:	0f b6 00             	movzbl (%eax),%eax
80101446:	0f b6 c0             	movzbl %al,%eax
80101449:	29 c2                	sub    %eax,%edx
8010144b:	89 d0                	mov    %edx,%eax
8010144d:	eb 1a                	jmp    80101469 <memcmp+0x56>
        }
        s1 ++, s2 ++;
8010144f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80101453:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
int
memcmp(const void *v1, const void *v2, size_t n)
{
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
80101457:	8b 45 10             	mov    0x10(%ebp),%eax
8010145a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010145d:	89 55 10             	mov    %edx,0x10(%ebp)
80101460:	85 c0                	test   %eax,%eax
80101462:	75 c3                	jne    80101427 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
80101464:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101469:	c9                   	leave  
8010146a:	c3                   	ret    

8010146b <swap>:
void swap(void *a,void *b,int sz)
{
8010146b:	55                   	push   %ebp
8010146c:	89 e5                	mov    %esp,%ebp
8010146e:	83 ec 10             	sub    $0x10,%esp
    char *n = (char*)a;
80101471:	8b 45 08             	mov    0x8(%ebp),%eax
80101474:	89 45 f8             	mov    %eax,-0x8(%ebp)
    char *m = (char*)b;
80101477:	8b 45 0c             	mov    0xc(%ebp),%eax
8010147a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    char tmp;
    int i = 0;
8010147d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(i = 0 ; i < sz ; i ++)
80101484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010148b:	eb 35                	jmp    801014c2 <swap+0x57>
    {
       tmp = n[i];
8010148d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80101490:	8b 45 f8             	mov    -0x8(%ebp),%eax
80101493:	01 d0                	add    %edx,%eax
80101495:	0f b6 00             	movzbl (%eax),%eax
80101498:	88 45 f3             	mov    %al,-0xd(%ebp)
       n[i] = m[i];
8010149b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
801014a1:	01 c2                	add    %eax,%edx
801014a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
801014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a9:	01 c8                	add    %ecx,%eax
801014ab:	0f b6 00             	movzbl (%eax),%eax
801014ae:	88 02                	mov    %al,(%edx)
       m[i] = tmp;
801014b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801014b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b6:	01 c2                	add    %eax,%edx
801014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
801014bc:	88 02                	mov    %al,(%edx)
{
    char *n = (char*)a;
    char *m = (char*)b;
    char tmp;
    int i = 0;
    for(i = 0 ; i < sz ; i ++)
801014be:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801014c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801014c5:	3b 45 10             	cmp    0x10(%ebp),%eax
801014c8:	7c c3                	jl     8010148d <swap+0x22>
    {
       tmp = n[i];
       n[i] = m[i];
       m[i] = tmp;
    }
}
801014ca:	90                   	nop
801014cb:	c9                   	leave  
801014cc:	c3                   	ret    

801014cd <itoa>:
char* itoa(int num, char* str, int radix)
{
801014cd:	55                   	push   %ebp
801014ce:	89 e5                	mov    %esp,%ebp
801014d0:	53                   	push   %ebx
801014d1:	83 ec 20             	sub    $0x20,%esp
    char index[] = "0123456789ABCDEF";
801014d4:	c7 45 df 30 31 32 33 	movl   $0x33323130,-0x21(%ebp)
801014db:	c7 45 e3 34 35 36 37 	movl   $0x37363534,-0x1d(%ebp)
801014e2:	c7 45 e7 38 39 41 42 	movl   $0x42413938,-0x19(%ebp)
801014e9:	c7 45 eb 43 44 45 46 	movl   $0x46454443,-0x15(%ebp)
801014f0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
    uint32_t unum;
    int32_t i = 0,j = 0;
801014f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    if(num < 0 && radix == 10)
80101502:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101506:	79 23                	jns    8010152b <itoa+0x5e>
80101508:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
8010150c:	75 1d                	jne    8010152b <itoa+0x5e>
    {
        unum = -num;
8010150e:	8b 45 08             	mov    0x8(%ebp),%eax
80101511:	f7 d8                	neg    %eax
80101513:	89 45 f8             	mov    %eax,-0x8(%ebp)
        str[i ++] = '-';
80101516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101519:	8d 50 01             	lea    0x1(%eax),%edx
8010151c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010151f:	89 c2                	mov    %eax,%edx
80101521:	8b 45 0c             	mov    0xc(%ebp),%eax
80101524:	01 d0                	add    %edx,%eax
80101526:	c6 00 2d             	movb   $0x2d,(%eax)
80101529:	eb 06                	jmp    80101531 <itoa+0x64>
    }else{
        unum = num; 
8010152b:	8b 45 08             	mov    0x8(%ebp),%eax
8010152e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }

    do{
       str[i ++] = index[unum % radix]; 
80101531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101534:	8d 50 01             	lea    0x1(%eax),%edx
80101537:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010153a:	89 c2                	mov    %eax,%edx
8010153c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010153f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101542:	8b 5d 10             	mov    0x10(%ebp),%ebx
80101545:	8b 45 f8             	mov    -0x8(%ebp),%eax
80101548:	ba 00 00 00 00       	mov    $0x0,%edx
8010154d:	f7 f3                	div    %ebx
8010154f:	89 d0                	mov    %edx,%eax
80101551:	0f b6 44 05 df       	movzbl -0x21(%ebp,%eax,1),%eax
80101556:	88 01                	mov    %al,(%ecx)
       unum /= radix;
80101558:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010155b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010155e:	ba 00 00 00 00       	mov    $0x0,%edx
80101563:	f7 f3                	div    %ebx
80101565:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }while(unum != 0);
80101568:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
8010156c:	75 c3                	jne    80101531 <itoa+0x64>
    
    str[i] = '\0';
8010156e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101571:	8b 45 0c             	mov    0xc(%ebp),%eax
80101574:	01 d0                	add    %edx,%eax
80101576:	c6 00 00             	movb   $0x0,(%eax)

    if(str[0] == '-')
80101579:	8b 45 0c             	mov    0xc(%ebp),%eax
8010157c:	0f b6 00             	movzbl (%eax),%eax
8010157f:	3c 2d                	cmp    $0x2d,%al
80101581:	75 04                	jne    80101587 <itoa+0xba>
    {
        j ++;        
80101583:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    for(i -= 1 ; j < i ; i --, j ++)
80101587:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010158b:	eb 24                	jmp    801015b1 <itoa+0xe4>
    {
        swap(&str[i],&str[j],sizeof(char));
8010158d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101590:	8b 45 0c             	mov    0xc(%ebp),%eax
80101593:	01 c2                	add    %eax,%edx
80101595:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80101598:	8b 45 0c             	mov    0xc(%ebp),%eax
8010159b:	01 c8                	add    %ecx,%eax
8010159d:	6a 01                	push   $0x1
8010159f:	52                   	push   %edx
801015a0:	50                   	push   %eax
801015a1:	e8 c5 fe ff ff       	call   8010146b <swap>
801015a6:	83 c4 0c             	add    $0xc,%esp

    if(str[0] == '-')
    {
        j ++;        
    }
    for(i -= 1 ; j < i ; i --, j ++)
801015a9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801015ad:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801015b7:	7c d4                	jl     8010158d <itoa+0xc0>
    {
        swap(&str[i],&str[j],sizeof(char));
    }
    return str;
801015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
}
801015bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015bf:	c9                   	leave  
801015c0:	c3                   	ret    
