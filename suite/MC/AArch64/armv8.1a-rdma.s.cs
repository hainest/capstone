# CS_ARCH_AARCH64, 0, None
0x20,0x84,0x42,0x2e = sqrdmlah	v0.4h, v1.4h, v2.4h
0x20,0x8c,0x42,0x2e = sqrdmlsh	v0.4h, v1.4h, v2.4h
0x20,0x84,0x82,0x2e = sqrdmlah	v0.2s, v1.2s, v2.2s
0x20,0x8c,0x82,0x2e = sqrdmlsh	v0.2s, v1.2s, v2.2s
0x20,0x84,0x82,0x6e = sqrdmlah	v0.4s, v1.4s, v2.4s
0x20,0x8c,0x82,0x6e = sqrdmlsh	v0.4s, v1.4s, v2.4s
0x20,0x84,0x42,0x6e = sqrdmlah	v0.8h, v1.8h, v2.8h
0x20,0x8c,0x42,0x6e = sqrdmlsh	v0.8h, v1.8h, v2.8h
0x20,0x84,0x42,0x7e = sqrdmlah	h0, h1, h2
0x20,0x8c,0x42,0x7e = sqrdmlsh	h0, h1, h2
0x20,0x84,0x82,0x7e = sqrdmlah	s0, s1, s2
0x20,0x8c,0x82,0x7e = sqrdmlsh	s0, s1, s2
0x20,0xd0,0x72,0x2f = sqrdmlah	v0.4h, v1.4h, v2.h[3]
0x20,0xf0,0x72,0x2f = sqrdmlsh	v0.4h, v1.4h, v2.h[3]
0x20,0xd0,0xa2,0x2f = sqrdmlah	v0.2s, v1.2s, v2.s[1]
0x20,0xf0,0xa2,0x2f = sqrdmlsh	v0.2s, v1.2s, v2.s[1]
0x20,0xd0,0x72,0x6f = sqrdmlah	v0.8h, v1.8h, v2.h[3]
0x20,0xf0,0x72,0x6f = sqrdmlsh	v0.8h, v1.8h, v2.h[3]
0x20,0xd8,0xa2,0x6f = sqrdmlah	v0.4s, v1.4s, v2.s[3]
0x20,0xf8,0xa2,0x6f = sqrdmlsh	v0.4s, v1.4s, v2.s[3]
0x20,0xd0,0x72,0x7f = sqrdmlah	h0, h1, v2.h[3]
0x20,0xf0,0x72,0x7f = sqrdmlsh	h0, h1, v2.h[3]
0x20,0xd8,0xa2,0x7f = sqrdmlah	s0, s1, v2.s[3]
0x20,0xf8,0xa2,0x7f = sqrdmlsh	s0, s1, v2.s[3]