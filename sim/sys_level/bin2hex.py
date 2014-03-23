

import binascii;

def bin2hex(bin_prog):
	hex_prog = "";
	j = 0;
	for i in range(int(len(bin_prog)/8)):
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+4]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+5]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+6]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+7]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+0]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+1]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+2]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(i*8)+3]));
		hex_prog = hex_prog + "\n";
		j = j + 1;
	if((len(bin_prog)%8 != 0)):
		hex_prog = hex_prog + "00";
		hex_prog = hex_prog + "00";
		hex_prog = hex_prog + "00";
		hex_prog = hex_prog + "00";
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(j*8)+0]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(j*8)+1]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(j*8)+2]));
		hex_prog = hex_prog + (binascii.b2a_hex(bin_prog[(j*8)+3]));
		hex_prog = hex_prog + "\n";
	return hex_prog;