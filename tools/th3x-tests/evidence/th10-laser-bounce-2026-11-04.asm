; 原版TH10.exe静态反汇编；未运行EXE。
; SHA-256: 2f14760b6fbbf57549541583283badb9a19a4222b90f0a146d5aa17f01dc9040
; 虚表46DA60，第15槽；X/Y分支分别调用EnemyFireLaser。
0041cfd0  sub      esp, 0xc
0041cfd3  push     ebx
0041cfd4  mov      ebx, ecx
0041cfd6  mov      eax, dword ptr [ebx + 0x40]
0041cfd9  mov      ecx, dword ptr [ebx + 0x3c]
0041cfdc  push     eax
0041cfdd  push     ecx
0041cfde  lea      ecx, [esp + 0xc]
0041cfe2  call     0x41f800
0041cfe7  fld      dword ptr [esp + 4]
0041cfeb  fadd     dword ptr [ebx + 0x24]
0041cfee  mov      dword ptr [esp + 0xc], 0
0041cff6  fstp     dword ptr [esp + 4]
0041cffa  fld      dword ptr [esp + 8]
0041cffe  fadd     dword ptr [ebx + 0x28]
0041d001  fstp     dword ptr [esp + 8]
0041d005  fld      dword ptr [esp + 4]
0041d009  fcomp    dword ptr [0x470b40]
0041d00f  fnstsw   ax
0041d011  test     ah, 0x41
0041d014  jnp      0x41d04d
0041d016  fld      dword ptr [esp + 4]
0041d01a  fcomp    dword ptr [0x470b3c]
0041d020  fnstsw   ax
0041d022  test     ah, 1
0041d025  je       0x41d04d
0041d027  fld      dword ptr [esp + 8]
0041d02b  fcomp    dword ptr [0x470b04]
0041d031  fnstsw   ax
0041d033  test     ah, 0x41
0041d036  jnp      0x41d04d
0041d038  fld      dword ptr [esp + 8]
0041d03c  fcomp    dword ptr [0x470b38]
0041d042  fnstsw   ax
0041d044  test     ah, 1
0041d047  jne      0x41d165
0041d04d  push     ebp
0041d04e  push     edi
0041d04f  mov      edi, dword ptr [ebx + 0x40c]
0041d055  xor      ebp, ebp
0041d057  test     edi, edi
0041d059  jl       0x41d066
0041d05b  push     ebp
0041d05c  mov      ecx, 0x492590
0041d061  call     0x43dc90
0041d066  fld      dword ptr [esp + 0xc]
0041d06a  push     esi
0041d06b  fcomp    dword ptr [0x470b40]
0041d071  fnstsw   ax
0041d073  test     ah, 5
0041d076  jnp      0x41d089
0041d078  fld      dword ptr [esp + 0x10]
0041d07c  fcomp    dword ptr [0x470b3c]
0041d082  fnstsw   ax
0041d084  test     ah, 1
0041d087  jne      0x41d0dd
0041d089  fld      dword ptr [ebx + 0x3c]
0041d08c  mov      eax, dword ptr [esp + 0x10]
0041d090  mov      ecx, dword ptr [esp + 0x14]
0041d094  fchs
0041d096  fsub     dword ptr [0x470b18]
0041d09c  lea      edi, [ebx + 0x424]
0041d0a2  mov      edx, edi
0041d0a4  mov      dword ptr [edx], eax
0041d0a6  mov      eax, dword ptr [esp + 0x18]
0041d0aa  mov      dword ptr [edx + 4], ecx
0041d0ad  push     ecx
0041d0ae  fstp     dword ptr [esp]
0041d0b1  mov      dword ptr [edx + 8], eax
0041d0b4  call     0x44bc70
0041d0b9  fstp     dword ptr [ebx + 0x430]
0041d0bf  mov      ecx, dword ptr [ebx + 0x13c]
0041d0c5  mov      esi, dword ptr [0x47781c]
0041d0cb  push     0
0041d0cd  mov      dword ptr [ebx + 0x444], ecx
0041d0d3  mov      ebp, 1
0041d0d8  call     0x41c510
0041d0dd  mov      ecx, dword ptr [ebx + 0x404]
0041d0e3  test     ecx, 0x8000000
0041d0e9  jne      0x41d154
0041d0eb  fld      dword ptr [esp + 0x14]
0041d0ef  fcomp    dword ptr [0x470b04]
0041d0f5  fnstsw   ax
0041d0f7  test     ah, 5
0041d0fa  jnp      0x41d112
0041d0fc  fld      dword ptr [esp + 0x14]
0041d100  fcomp    dword ptr [0x470b38]
0041d106  fnstsw   ax
0041d108  test     ah, 1
0041d10b  jne      0x41d154
0041d10d  test     ch, 4
0041d110  je       0x41d154
0041d112  mov      eax, dword ptr [esp + 0x10]
0041d116  fld      dword ptr [ebx + 0x3c]
0041d119  mov      ecx, dword ptr [esp + 0x14]
0041d11d  fchs
0041d11f  mov      esi, dword ptr [0x47781c]
0041d125  fstp     dword ptr [ebx + 0x430]
0041d12b  lea      edi, [ebx + 0x424]
0041d131  mov      edx, edi
0041d133  mov      dword ptr [edx], eax
0041d135  mov      eax, dword ptr [esp + 0x18]
0041d139  mov      dword ptr [edx + 4], ecx
0041d13c  mov      ecx, dword ptr [ebx + 0x13c]
0041d142  push     0
0041d144  mov      dword ptr [edx + 8], eax
0041d147  mov      dword ptr [ebx + 0x444], ecx
0041d14d  call     0x41c510
0041d152  jmp      0x41d158
0041d154  test     ebp, ebp
0041d156  je       0x41d162
0041d158  and      dword ptr [ebx + 0x404], 0xf7fff3ff
0041d162  pop      esi
0041d163  pop      edi
0041d164  pop      ebp
0041d165  pop      ebx
0041d166  add      esp, 0xc
0041d169  ret
0041d16a  int3
0041d16b  int3
0041d16c  int3
0041d16d  int3
0041d16e  int3
0041d16f  int3
