# PBO File Format - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/PBO_File_Format#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Category: [Category:Real Virtuality File Formats](https://community.bistudio.com/wiki/Category:Real_Virtuality_File_Formats)

[Bohemia Interactive](https://community.bistudio.com/wiki/Bohemia_Interactive)

**Disclaimer: This page describes internal undocumented structures of [Bohemia Interactive](https://community.bistudio.com/wiki/Bohemia_Interactive) software.**

This page contains unofficial information.

Some usage of this information may constitute a violation of the rights of Bohemia Interactive and is in no way endorsed or recommended by Bohemia Interactive.

Bohemia Interactive is not willing to tolerate use of such tools if it contravenes any general licenses granted to end users of this community wiki or BI products.

**PBO** means "**p**acked **b**ank **o**f files". A **.pbo** is identical in purpose to a zip or rar. It is a container for folder(s) and file(s).

The engine will internally expand any ***.pbo** back out to its original, tree-folder, form.

#### Pbo .ext types[Link](https://community.bistudio.com/wiki/PBO_File_Format#Pbo_.ext_types)

generically called 'pbo' there are in fact different extension names employed, dependent on the engine being used. In all cases, the contents ultimately are identical to pbos.

- ifa: A World War2 mod hard wired to only accept ifa files.
- ebo: initially used by VBS, then by Arma, to encrypt the contents of a pbo and call it a different extension.
- xbo: Used by vbsLite encrypt with a different algorithm to above.
  - the encryption method used for vbslite UK and vbslite US is different.

### Legend[Link](https://community.bistudio.com/wiki/PBO_File_Format#Legend)

See [Generic FileFormat Data Types](https://community.bistudio.com/wiki/Generic_FileFormat_Data_Types).

### Compression[Link](https://community.bistudio.com/wiki/PBO_File_Format#Compression)

In addition to simply packaging all files and folders in a tree into a single file, some, all, or none of the files within can be compressed using Apple's method of LZSS compression. Which type of files are compressed is *entirely* optional. Ones that won't benefit normally are not and some files in the Arma engines cannot be because bis forgot they had this code. The intent behind compression **was** for internet use and, in the 'good old days', simply to reduce hard disk storage requirements. The *actual* use of compression is becoming less 'popular' as it does represent a small load on the engine. Operation Flashpoint: Elite cannot work with *compressed .pbo* files - see [Elite PBOs](https://community.bistudio.com/wiki/PBO_File_Format#Operation_Flashpoint:_Elite_PBO).

### PboTypes[Link](https://community.bistudio.com/wiki/PBO_File_Format#PboTypes)

#### Mission Versus Addon[Link](https://community.bistudio.com/wiki/PBO_File_Format#Mission_Versus_Addon)

Across all engines there are two distinct types of pbo.

- Mission pbos do not contain config.cpps and live in a mission folder (be it campaign, single, or multiplayer). They have no use for a pboPrefix, nor a Properties header.
- Addon pbos contain a config.cpp/bin which at-the-least identifies the addon name, and, with the exception of the initial cwc engine, rely on a pbo properties header. They live in an addons\ folder.

#### pbo engine differences[Link](https://community.bistudio.com/wiki/PBO_File_Format#pbo_engine_differences)

- Cold War Crisis: the very first in the series (disregarding the 'proof of concept' release a year earlier) has no pboProperties header and no checksums. It does however form the core of all other engines. It's format has never been altered
- Resistance: added a Properties header as the first 'entry' of the pbo.
- Vbs1: same as Resistance (but encrypted).
- Xbox Elite: added a 0 plus 4 byte checksum to end of file.
- Arma: changed Elite's checksum to a 0 plus 20 byte sha key to end of file.
- VBS2: same as Arma (but encrypted)
- Dayz: same as Arma

Note also that in almost all cases both the properties header and/or the sha key are optional.

## Main format[Link](https://community.bistudio.com/wiki/PBO_File_Format#Main_format)

The format of a .pbo contains:

1. a header consisting of 21byte contiguous file name structures called 'entries'. The very first entry might exceed 21 bytes (see below)
2. one, contiguous data block.
3. an (optional) 5 byte checksum (Elite) or a 21 byte signature key (Arma)

With exceptions, each entry defines a file contained in the .pbo, its size, date, name, it is whether it is compressed.

Because entries and data are contiguous, there is no need for an offset to the 'next' file. Every file, even zero-length ones, are recorded in the header.

However, note that there is no provision for, and no ability to, store empty folders. Folders as such are indicated simply by being part of the filename. There are no, folder entries, and consequently, empty folders, cannot be included in a .pbo because there is no filename associated with them. Put another way, an empty folder, if it could be stored (and it can't), would appear to be an empty filename when dePbo'd.

The last header 'entry' is filled with zeroes. The next byte is the beginning of the data block.

## PBO Header Entry[Link](https://community.bistudio.com/wiki/PBO_File_Format#PBO_Header_Entry)

A standard .pbo entry as follows:

```cpp
struct entry
{
	Asciiz filename;	// a zero terminated string defining the path and filename,
						// ''relative to the name of this .pbo'' or it is prefix.
						// Zero length filenames ('\0') indicate the first (optional), or last (non optional) entry in header.
						// Other fields in the last entry are filled by zero bytes.

	char[4] MimeType;	// 0x56657273 'Vers' properties entry (only first entry if at all)
						// 0x43707273 'Cprs' compressed entry
						// 0x456e6372 'Enco' comressed (vbs)
						// 0x00000000 dummy last header entry

	ulong OriginalSize;	// Uncompressed: 0 or same value as the DataSize
						// compressed: Size of file after unpacking.
						// This value is needed for byte boundary unpacking
						// since unpacking itself can lead to bleeding of up
						// to 7 extra bytes.

	ulong Offset;		// not actually used, always zeros (but vbs = encryption data)

	ulong TimeStamp;	// meant to be the unix filetime of Jan 1 1970 +, but often 0

	ulong DataSize;		// The size in the data block.
						// This is also the file size when '''not''' packed
};
```

### Null Entries[Link](https://community.bistudio.com/wiki/PBO_File_Format#Null_Entries)

Entries with no file name indicate:

1. End of header, content all zeros and ignored regardless.
2. PboProperties entry as the very first entry of the file (not present for cwc or any mission.pbo)

### PboProperties[Link](https://community.bistudio.com/wiki/PBO_File_Format#PboProperties)

```cpp
struct standard entry
{
	Asciiz	filename;		// = 0
	char[4]	MimeType;		// 0x56657273 'Vers' properties entry (only first entry if at all)
	ulong	OriginalSize;	// = 0
	ulong	Reserved;		// = 0
	ulong	TimeStamp;		// = 0
	ulong	DataSize;		// = 0
} // end of 'standard' entry

struct properties
{
	Asciiz this1, that1;	// eg this=that;
}[...];

byte end; // = 0
```

There can be as many contiguos paired Strings as, well, as many as, a piece of string!

The **LAST** (or only!) String is a zero length [ASCIIZ](https://en.wikipedia.org/wiki/Null-terminated_string) string (eg. '\0').

#### Operation Flashpoint: Resistance PBO[Link](https://community.bistudio.com/wiki/PBO_File_Format#Operation_Flashpoint:_Resistance_PBO)

```cpp
struct properties
{
	"product" = "OFP: Resistance"
};
```

#### Operation Flashpoint: Elite PBO[Link](https://community.bistudio.com/wiki/PBO_File_Format#Operation_Flashpoint:_Elite_PBO)

```cpp
struct properties
{
	"prefix" = "Addon\FOLDER\Name"
};
```

#### Arma PBO[Link](https://community.bistudio.com/wiki/PBO_File_Format#Arma_PBO)

```cpp
prefix=Addon\FOLDER\Name
version="123"
engine="arma3"
author=I am famous"
anything=else that takes your fancy
```

## End of File Checksum or Sha[Link](https://community.bistudio.com/wiki/PBO_File_Format#End_of_File_Checksum_or_Sha)

### Operation Flashpoint[Link](https://community.bistudio.com/wiki/PBO_File_Format#Operation_Flashpoint)

Not present for Operation Flashpoint pbos

### Operation Flashpoint: Elite[Link](https://community.bistudio.com/wiki/PBO_File_Format#Operation_Flashpoint:_Elite)

```cpp
{
	byte always0;
	int checksum;
}
```

### Arma[Link](https://community.bistudio.com/wiki/PBO_File_Format#Arma)

```cpp
{
	byte always0;
	byte sha[20]; //std md5 checksum only used for MP play
}
```

## Data compression[Link](https://community.bistudio.com/wiki/PBO_File_Format#Data_compression)

Data compression is a mild, but effective use of Apple Corps LZSS (a variant of liv-zempel & Huffman), allowing (up to) 8k of previous data to repeat itself.

Compression is indicated when a signature of 0x43707273 **and** the file sizes do not match in the entry.

The following code also applies to the packing method employed in wrp (OPRW) and pac/paa files which have no header info simply a block of known output length that must be decoded. In all cases, the OUTPUT size is known. With .pbo's, the INPUT size is only a boundary definition to the next block of compressed data. It is not used or relevant to decoding data because (up to) 7 residual bytes could exist in the last flag word of the block. As such, only the fixed in concrete output size is relevant.

The compressed data block is in contiguous 'packets' of different lengths:

```cpp
block {packet1}...{packetN} {4 byte checksum}

packet
{
	byte flagbits;
	byte packetdata[...];	// no fixed length
}
```

The contents of the packetdata contain mixtures of raw data that is passed directly to the output, and, 2byte pointers.

Format: bit values determine what the packetdata is. It is interpeted **lsb** first thus:

```
BitN = 1	-	append byte directly to file (read single byte)
BitN = 0	-	pointer (read two bytes)
```

for example:

format byte, is 0x45, binary notation is: 01000101.

There are three bytes in the block a little further past the format flag that will be passed directly to the output when encountered, and there are FIVE pointers.

In this example, first byte of packetdata is passed to output, 2 bytes are read to make a pointer, next byte is passed (ultimately) to output and so on.

```
For the very last packet in the block, it is almost inevitable that there will be
excessive bits. These are ignored (truncated) as the final output length is always
known from the Entry. You cannot rely on the ignored bits in the format flag (up to seven
of them) to be any particular value (0 or 1) and must be ignored.
```

A pointer consists of a 12 bits address and 4 bit run length.

The pointer is a reference to somewhere in the previous 4k max of built output. Given Intel's endian word format the bytes b1 and b2 form a short word value B2B1

The format of B2B1 is unfortunately in Big Endian (motorola) AAAA LLLL AAAAAAAA, requiring some shift and mask fiddling.

The address refers to the start of some data in the currently rebuilt part of the file. It is a value, relative to the current length of the reconstructed part of the file (FL).

The run length of the data to be copied, the 'pattern' has 4 bits and therefore, in theory, 0 to 15 bytes can be duplicated. In practice the values are 3..18 bytes because copying 0,1 or 2 bytes makes no sense.

Relative position (rpos) into the currently built output is calculated as

```
rpos = FL  - ((B2B1 &0x00FF) + (B2B1 & 0xF000)>>4) )
```

The length of the data block: rlen

```
rlen = (B2B1 & 0x0F00>>8) + 3
```

With the values of rpos and rlen there are three basic situations possible:

```
rpos + rlen < FL // bytes to copy are within the existing reconstructed data
block is added to the end of the file, giving a new length of FL = FL + rlen.
```

```
rpos + rlen > FL // data to copy exceeds what's available
In this situation the data block has a length of FL – rpos and it is added to the reconstructed file until FL = rpos + rlen.
```

```
rpos + rlen < 0
This is a special case where spaces are added to the decoded file until FL = FL,Initial + rlen
```

The checksum, the last four bytes of any compressed data block. It is an unsigned long (Intel Little Endian order). It is simply a byte-at-a-time, unsigned additive spillover of the **decompressed** data.

Each and every compressed data block, contains its own, unique checksum.

There is no checksum or other protective device, employed on a .pbo overall. Exceptions: Elite and Arma have residual data after the end of contiguous data block that do represent a signature for the file.

## Bibliography[Link](https://community.bistudio.com/wiki/PBO_File_Format#Bibliography)

- DosTools: *-dead link-*
- cpbo: [http://www.kegetys.net/arma/](http://www.kegetys.net/arma/)

## Open Source PBO Libraries[Link](https://community.bistudio.com/wiki/PBO_File_Format#Open_Source_PBO_Libraries)

### C[Link](https://community.bistudio.com/wiki/PBO_File_Format#C)

- JAPM: [[1]](https://github.com/RaJiska/JAPM)
- armake: [[2]](https://github.com/KoffeinFlummi/armake)
- libpbo: [[3]](https://github.com/Learath2/libpbo)

### C++[Link](https://community.bistudio.com/wiki/PBO_File_Format#C++)

- libpbo: [[4]](https://github.com/StidOfficial/libpbo)

### C#[Link](https://community.bistudio.com/wiki/PBO_File_Format#C#)

- SwiftPbo: [[5]](https://github.com/headswe/SwiftPbo)
- PboSharp: [[6]](https://github.com/Shix/PBOSharp)

### Python[Link](https://community.bistudio.com/wiki/PBO_File_Format#Python)

- yapbol: [[7]](https://github.com/overfl0/yapbol)
- pbo-fuse: [[8]](https://github.com/Dahlgren/python-pbo-fuse/blob/master/pbo.py)
- arma3pbo: [[9]](https://github.com/danielgran/arma3pbo)

### Rust[Link](https://community.bistudio.com/wiki/PBO_File_Format#Rust)

- armake2: [[10]](https://github.com/KoffeinFlummi/armake2)

### Java[Link](https://community.bistudio.com/wiki/PBO_File_Format#Java)

- ArmaFiles: [[11]](https://github.com/Krzmbrzl/ArmaFiles)

### JavaScript[Link](https://community.bistudio.com/wiki/PBO_File_Format#JavaScript)

- Pbo.js: [[12]](https://github.com/eelislynne/pbo.js)

Retrieved from "[https://community.bistudio.com/wiki?title=PBO_File_Format&oldid=373444](https://community.bistudio.com/wiki?title=PBO_File_Format&oldid=373444)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Real Virtuality File Formats](https://community.bistudio.com/wiki/Category:Real_Virtuality_File_Formats)