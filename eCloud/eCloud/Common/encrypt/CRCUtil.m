// 获取crc校验数据

#import "CRCUtil.h"
#include <stdlib.h>
#include <stdio.h>

int  crc8(unsigned char *pIn, int iInLen,  char*pOut)
{
	unsigned char i;
	unsigned char crc=0;
	while(iInLen-- != 0)
	{
		for(i=0x80; i!=0; i/=2)
		{
			if((crc&0x80)!=0)
			{
				crc*=2;
				crc^=0x07;
			} /* 余式CRC乘以2再求CRC */
			else
				crc*=2;
			if((*pIn&i)!=0)
				crc^=0x07; /* 再加上本位的CRC */
		}
		pIn++;
	}
	sprintf(pOut,"%0x", crc);
	if(crc == 0)
		return -1;
	else
		return 0;
}

@implementation CRCUtil

+ (NSString *)getCrc8:(NSString *)srcStr
{
    NSString *retStr = @"";
    
    const char* buf = [srcStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    char outcrc[255];
    memset(outcrc, 0, sizeof(outcrc));

    int ret = crc8((unsigned char *)buf, strlen(buf), outcrc);
    
    if (ret == 0) {
        retStr = [NSString stringWithCString:outcrc encoding:NSUTF8StringEncoding];
    }
    
    return retStr;
}

@end

//
//unsigned CRCcode[] =
//{
//	0x0,0x07,0x0e,0x09,0x1c,0x1b,0x12,0x15, // ;00-07
//	0x38,0x3f,0x36,0x31,0x24,0x23,0x2a,0x2d, //;08--0f
//	0x70,0x77,0x7e,0x79,0x6c,0x6b,0x62,0x65,  //;10-17
//	0x48,0x4f,0x46,0x41,0x54,0x53,0x5a,0x5d,  //;18-1f
//	0xe0,0xe7,0xee,0xe9,0xfc,0xfb,0xf2,0xf5,  //;20-27
//	0xd8,0xdf,0xd6,0xd1,0xc4,0xc3,0xca,0xcd,  //;28-2f
//	0x90,0x97,0x9e,0x99,0x8c,0x8b,0x82,0x85,  //;30-37
//	0xa8,0xaf,0xa6,0xa1,0xb4,0xb3,0xba,0xbd,  //;38-3f
//	0xc7,0xc0,0xc9,0xce,0xdb,0xdc,0xd5,0xd2,  //;40-47
//	0xff,0xf8,0xf1,0xf6,0xe3,0xe4,0xed,0xea,  //;48-4f
//	0xb7,0xb0,0xb9,0xbe,0xab,0xac,0xa5,0xa2,  //;50-57
//	0x8f,0x88,0x81,0x86,0x93,0x94,0x9d,0x9a,  //;58-5f
//	0x27,0x20,0x29,0x2e,0x3b,0x3c,0x35,0x32,  //;60-67
//	0x1f,0x18,0x11,0x16,0x03,0x04,0x0d,0x0a,  //;68-6f
//	0x57,0x50,0x59,0x5e,0x4b,0x4c,0x45,0x42,  //;70-77
//	0x6f,0x68,0x61,0x66,0x73,0x74,0x7d,0x7a,  //;78-7f
//
//	0x89,0x8e,0x87,0x80,0x95,0x92,0x9b,0x9c,  //;80-87
//	0xb1,0xb6,0xbf,0xb8,0xad,0xaa,0xa3,0xa4,  //;88-8f
//	0xf9,0xfe,0xf7,0xf0,0xe5,0xe2,0xeb,0xec,  //;90-97
//	0xc1,0xc6,0xcf,0xc8,0xdd,0xda,0xd3,0xd4,  //;98-9f
//	0x69,0x6e,0x67,0x60,0x75,0x72,0x7b,0x7c,  //;a0-a7
//	0x51,0x56,0x5f,0x58,0x4d,0x4a,0x43,0x44,  //;a8-af
//	0x19,0x1e,0x17,0x10,0x05,0x02,0x0b,0x0c,  //;b0-b7
//	0x21,0x26,0x2f,0x28,0x3d,0x3a,0x33,0x34,  //;b8-bf
//	0x4e,0x49,0x40,0x47,0x52,0x55,0x5c,0x5b,  //;c0-c7
//	0x76,0x71,0x78,0x7f,0x6a,0x6d,0x64,0x63,  //;c8-cf
//	0x3e,0x39,0x30,0x37,0x22,0x25,0x2c,0x2b,  //;d0-d7
//	0x06,0x01,0x08,0x0f,0x1a,0x1d,0x14,0x13,  //;d8-df
//	0xae,0xa9,0xa0,0xa7,0xb2,0xb5,0xbc,0xbb,  //;e0-e7
//	0x96,0x91,0x98,0x9f,0x8a,0x8d,0x84,0x83,  //;e8-ef
//	0xde,0xd9,0xd0,0xd7,0xc2,0xc5,0xcc,0xcb,  //;f0-f7
//	0xe6,0xe1,0xe8,0xef,0xfa,0xfd,0xf4,0xf3,  //;f8-ff
//};
//
//unsigned char getcrccode(void *x, unsigned char len)
//{
//	unsigned char volatile *p=(unsigned char*)x;
//	unsigned char volatile i,crc;
//
//	crc = p[0];
//	for(i=0;i<len-1;i++)
//	{crc = CRCcode[crc];
//        crc = crc^p[i+1];
//    }crc = CRCcode[crc];crc = crc^0xff;
//    return crc;
//}
