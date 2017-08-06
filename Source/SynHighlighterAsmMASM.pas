{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynHighlighterASM.pas, released 2000-04-18.
The Original Code is based on the nhAsmSyn.pas file from the
mwEdit component suite by Martin Waldenburg and other developers, the Initial
Author of this file is Nick Hoddinott.
Unicode translation by Ma�l H�rz.
All Rights Reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: SynHighlighterAsmMASM.pas,v 1.0 2017/02/12 tjaeger Exp $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

Known Issues:
-------------------------------------------------------------------------------}
{
@abstract(Provides Microsoft Macro Assembler (MASM) highlighter for SynEdit)
@author(Thomas Jaeger <thomasjaeger@gmail.com>)
@created(February 12th, 2017)
@lastmod(July 1st, 2017)
The SynHighlighterASM unit provides SynEdit with a Microsoft Macro Assembler (MASM) highlighter.
The highlighter supports all MASM features including directives and macros.
}

unit SynHighlighterAsmMASM;

{$I SynEdit.inc}

interface

uses
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
  SynHighlighterHashEntries,
  SynUnicode,
  SysUtils,
  System.IOUtils,
  SynColors,
  SynMemo,
  Classes;

type
  TtkTokenKind = (tkComment, tkIdentifier, tkKey, tkNull, tkNumber, tkSpace,
    tkString, tkSymbol, tkUnknown, tkDirectives, tkRegister, tkApi, tkInclude,
    tkOperator, tkSelection,
    tkFtpLink, tkGopherLink, tkHttpLink, tkHttpsLink, tkMailtoLink, tkNewsLink,
    tkNntpLink, tkProsperoLink, tkTelnetLink, tkWaisLink, tkWebLink, tkNullChar);

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function (Key: Integer): TtkTokenKind of object;
  TAlreadyVisitedURIFunc = function (URI: string): Boolean of object;

  TSynAsmMASMSyn = class(TSynCustomHighlighter)
  private
    fTokenID: TtkTokenKind;
    fCommentAttri: TSynHighlighterAttributes;
    fIncludeAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fKeywords: TSynHashEntryList;
    fDirectivesKeywords: TSynHashEntryList;
    fDirectivesAttri: TSynHighlighterAttributes;
    fRegisterKeywords: TSynHashEntryList;
    fRegisterAttri: TSynHighlighterAttributes;
    fApiKeywords: TSynHashEntryList;
    fApiAttri: TSynHighlighterAttributes;
    fOperatorKeywords: TSynHashEntryList;
    fOperatorAttri: TSynHighlighterAttributes;
    FSynColors: TSynColors;
    FApis: UnicodeString;

    fIdentFuncTable: array[0..15] of TIdentFuncTableFunc;
    fURIAttri: TSynHighlighterAttributes;
    fVisitedURIAttri: TSynHighlighterAttributes;
    fAlreadyVisitedURI: TAlreadyVisitedURIFunc;
    procedure InitIdent;
    procedure ProtocolProc;
    function AltFunc(Key: Integer): TtkTokenKind;
    function FuncFtp(Key: Integer): TtkTokenKind;
    function FuncGopher(Key: Integer): TtkTokenKind;
    function FuncHttp(Key: Integer): TtkTokenKind;
    function FuncHttps(Key: Integer): TtkTokenKind;
    function FuncMailto(Key: Integer): TtkTokenKind;
    function FuncNews(Key: Integer): TtkTokenKind;
    function FuncNntp(Key: Integer): TtkTokenKind;
    function FuncProspero(Key: Integer): TtkTokenKind;
    function FuncTelnet(Key: Integer): TtkTokenKind;
    function FuncWais(Key: Integer): TtkTokenKind;
    function FuncWeb(Key: Integer): TtkTokenKind;
    function IsAlphaNum(AChar: WideChar): Boolean;
    function IsMark(AChar: WideChar): Boolean;
    function IsReserved(AChar: WideChar): Boolean;
    function IsUnreserved(AChar: WideChar): Boolean;
    function IsURIChar(AChar: WideChar): Boolean;
    function IsNeverAtEnd(AChar: WideChar): Boolean;
    function IsEMailAddressChar(AChar: WideChar): Boolean;
    function IsNeverAtEMailAddressEnd(AChar: WideChar): Boolean;
    function IsValidEmailAddress: Boolean;
    function IsValidURI: Boolean;
    function IsValidWebLink: Boolean;
    procedure SetURIAttri(const Value: TSynHighlighterAttributes);
    procedure SetVisitedURIAttri(const Value: TSynHighlighterAttributes);

    function HashKey(Str: PWideChar): Cardinal;
//    function HashKey(Str: PWideChar): Integer;
    procedure CommentProc;
    procedure CRProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure LFProc;
    procedure LowerProc;
    procedure NullProc;
    procedure NumberProc;
    procedure SlashProc;
    procedure IncludeProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure SingleQuoteStringProc;
    procedure SymbolProc;
    procedure UnknownProc;
    procedure DoAddKeyword(AKeyword: UnicodeString; AKind: integer);
    procedure DoAddDirectivesKeyword(AKeyword: UnicodeString; AKind: integer);
    procedure DoAddRegisterKeyword(AKeyword: UnicodeString; AKind: integer);
    procedure DoAddApiKeyword(AKeyword: UnicodeString; AKind: integer);
    procedure DoAddOperatorKeyword(AKeyword: UnicodeString; AKind: integer);
    function IdentKind(MayBe: PWideChar): TtkTokenKind;
    function GetElement(find: string): TSynColorsElement;
  protected
    function GetSampleSource: UnicodeString; override;
    function IsFilterStored: Boolean; override;
//    function IsCurrentToken(const Token: string): Boolean; override;
    procedure SetAlreadyVisitedURIFunc(Value: TAlreadyVisitedURIFunc);
  public
    class function GetLanguageName: string; override;
    class function GetFriendlyLanguageName: UnicodeString; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetTokenID: TtkTokenKind;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    procedure Next; override;
    procedure SaveFile(fName: string);
    procedure LoadFile(fName: string);
    procedure AssignColors(memo: TSynMemo);
//    function IsIdentChar(AChar: WideChar): Boolean; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri write fSymbolAttri;
    property DirectivesAttri: TSynHighlighterAttributes read fDirectivesAttri write fDirectivesAttri;
    property RegisterAttri: TSynHighlighterAttributes read fRegisterAttri write fRegisterAttri;
    property ApiAttri: TSynHighlighterAttributes read fApiAttri write fApiAttri;
    property IncludeAttri: TSynHighlighterAttributes read fIncludeAttri write fIncludeAttri;
    property SynColors: TSynColors read FSynColors write FSynColors;
    property OperatorAttri: TSynHighlighterAttributes read fOperatorAttri write fOperatorAttri;
    property URIAttri: TSynHighlighterAttributes read fURIAttri write SetURIAttri;
    property VisitedURIAttri: TSynHighlighterAttributes read fVisitedURIAttri write SetVisitedURIAttri;
  end;

const
  SYN_ATTR_URI = 6;
  SYN_ATTR_VISITEDURI = 7;

  Mnemonics: UnicodeString =
    'aaa,aad,aam,adc,add,and,arpl,bound,bsf,bsr,bswap,bt,btc,' +
    'btr,bts,call,cbw,cdq,clc,cld,cli,clts,cmc,cmp,cmps,cmpsb,cmpsd,cmpsw,' +
    'cmpxchg,cwd,cwde,daa,das,dec,div,emms,enter,f2xm1,fabs,fadd,faddp,fbld,' +
    'fbstp,fchs,fclex,fcmovb,fcmovbe,fcmove,fcmovnb,fcmovnbe,fcmovne,fcmovnu,' +
    'fcmovu,fcom,fcomi,fcomip,fcomp,fcompp,fcos,fdecstp,fdiv,fdivp,fdivr,' +
    'fdivrp,femms,ffree,fiadd,ficom,ficomp,fidiv,fidivr,fild,fimul,fincstp,' +
    'finit,fist,fistp,fisub,fisubr,fld,fld1,fldcw,fldenv,fldl2e,fldl2t,fldlg2,' +
    'fldln2,fldpi,fldz,fmul,fmulp,fnclex,fninit,fnop,fnsave,fnstcw,fnstenv,' +
    'fnstsw,fpatan,fprem1,fptan,frndint,frstor,fsave,fscale,fsin,fsincos,' +
    'fsqrt,fst,fstcw,fstenv,fstp,fstsw,fsub,fsubp,fsubr,fsubrp,ftst,' +
    'fucom,fucomi,fucomip,fucomp,fucompp,fwait,fxch,fxtract,fyl2xp1,hlt,idiv,' +
    'imul,in,inc,ins,insb,insd,insw,int,into,invd,invlpg,iret,iretd,iretw,' +
    'ja,jae,jb,jbe,jc,jcxz,je,jecxz,jg,jge,jl,jle,jmp,jna,jnae,jnb,jnbe,jnc,' +
    'jne,jng,jnge,jnl,jnle,jno,jnp,jns,jnz,jo,jp,jpe,jpo,js,jz,lahf,lar,lds,' +
    'lea,leave,les,lfs,lgdt,lgs,lidt,lldt,lmsw,lock,lods,lodsb,lodsd,lodsw,' +
    'loop,loope,loopne,loopnz,loopz,lsl,lss,ltr,mov,movd,movq, movs,movsb,' +
    'movsd,movsw,movsx,movzx,mul,neg,nop,not,or,out,outs,outsb,outsd,outsw,' +
    'packssdw,packsswb,packuswb,paddb,paddd,paddsb,paddsw,paddusb,paddusw,' +
    'paddw,pand,pandn,pavgusb,pcmpeqb,pcmpeqd,pcmpeqw,pcmpgtb,pcmpgtd,pcmpgtw,' +
    'pf2id,pfacc,pfadd,pfcmpeq,pfcmpge,pfcmpgt,pfmax,pfmin,pfmul,pfrcp,' +
    'pfrcpit1,pfrcpit2,pfrsqit1,pfrsqrt,pfsub,pfsubr,pi2fd,pmaddwd,pmulhrw,' +
    'pmulhw,pmullw,pop,popa,popad,popaw,popf,popfd,popfw,por,prefetch,prefetchw,' +
    'pslld,psllq,psllw,psrad,psraw,psrld,psrlq,psrlw,psubb,psubd,psubsb,' +
    'psubsw,psubusb,psubusw,psubw,punpckhbw,punpckhdq,punpckhwd,punpcklbw,' +
    'punpckldq,punpcklwd,push,pusha,pushad,pushaw,pushf,pushfd,pushfw,pxor,' +
    'rcl,rcr,rep,repe,repne,repnz,repz,ret,rol,ror,sahf,sal,sar,sbb,scas,' +
    'scasb,scasd,scasw,seta,setae,setb,setbe,setc,sete,setg,setge,setl,setle,' +
    'setna,setnae,setnb,setnbe,setnc,setne,setng,setnge,setnl,setnle,setno,' +
    'setnp,setns,setnz,seto,setp,setpo,sets,setz,sgdt,shl,shld,shr,shrd,sidt,' +
    'sldt,smsw,stc,std,sti,stos,stosb,stosd,stosw,str,sub,test,verr,verw,' +
    'wait,wbinvd,xadd,xchg,xlat,xlatb,xor';

  Registers: UnicodeString =
    'ah,al,ax,bh,bl,bx,ch,cl,cs,cx,dh,di,dl,ds,dx,'+
    'eax,ebp,ebx,ecx,edi,edx,es,esi,esp,fs,gs,ip,eip,'+
    'rax,rcx,rdx,rbx,rsp,rbp,rsi,rdisi,ss,'+
    'r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,'+
    'r0D,r1D,r2D,r3D,r4D,r5D,r6D,r7D,r8D,r9D,r10D,r11D,r12D,r13D,r14D,r15D,'+
    'r0W,r1W,r2W,r3W,r4W,r5W,r6W,r7W,r8W,r9W,r10W,r11W,r12W,r13W,r14W,r15W,'+
    'r0L,r1L,r2L,r3L,r4L,r5L,r6L,r7L,r8L,r9L,r10L,r11L,r12L,r13L,r14L,r15L';

  Operators: UnicodeString = '+,-,*,/,==,!=,>,>=,<,<=,||,&&,&,!,carry?,overflow?,'+
                              'parity?,sign?,zero?,%,&&,abs,addr,and,dup,eq,ge,'+
                              'gt,high,high32,highword,imagerel,le,length,lengthof,' +
                              'low,low32,lowword,lroffset,lt,mask,mod,ne,not,offset,' +
                              'opattr,or,ptr,seg,shl,.type,sectionrel,short,shr,' +
                              'size,sizeof,this,type,width,xor';
//  Operators: UnicodeString = 'abs,addr,and,dup,eq,ge,'+
//                              'gt,high,high32,highword,imagerel,le,length,lengthof,' +
//                              'low,low32,lowword,lroffset,lt,mask,mod,ne,not,offset,' +
//                              'opattr,or,ptr,seg,shl,.type,sectionrel,short,shr,' +
//                              'size,sizeof,this,type,width,xor';

  Directives: UnicodeString =
    '=,.386,.386p,.387,.486,.486p,.586,.586p,.686,.686p,alias,align,.allocstack,'+
    '.alpha,assume,.break,byte,catstr,.code,comm,comment,.const,.continue,.cref,'+
    '.data,.data?,db,dd,df,.dosseg,dosseg,dq,dt,dw,dword,echo,.else,else,elseif,'+
  	'.elseif,'+
    'elseif2,end,.endif,endif,endm,endp,.endprolog,ends,.endw,equ,.err,.err2,.errb,'+
    '.errdef,.errdif[[i]],.erre,.erridn[[i]],.errnb,.errndef,.errnz,even,.exit,'+
    'exitm,extern,externdef,extrn,.fardata,.fardata?,for,forc,.fpo,fword,goto,'+
    'group,.if,if,if2,ifb,ifdef,ifdif[[i]],ife,ifidn[[i]],ifnb,ifndef,include,'+
    'includelib,instr,invoke,irp,irpc,.k3d,label,.lall,.lfcond,.list,.listall,'+
    '.listif,.listmacro,.listmacroall,local,macro,mmword,.mmx,.model,name,'+
    '.nocref,.nollist,.nolistif,.nolistmacro,offset,option,org,%out,oword,page,'+
    'popcontext,proc,proto,public,purge,pushcontext,.pushframe,.pushreg,qword,'+
    '.radix,real10,real4,real8,record,.repeat,repeat,rept,.safeseh,.sall,'+
    '.savereg,.savexmm128,sbyte,sdword,segment,.seq,.setframe,.sfcond,sizestr,'+
    'sqword,.stack,.startup,struc,struct,substr,subtitle,subttl,sword,tbyte,'+
    'textequ,.tfcond,title,typedef,union,.until,.untilcxz,.while,while,word,'+
    '.xall,.xcref,.xlist,.xmm,xmmword,ymmword,'+
    'tiny,small,compact,medium,large,huge,flat,nearstack,farstack'; // .MODEL options

  // Directives for Masm and Tasm
//  ProcessorSpecification: UnicodeString =
//    '.186,.286,.286C,.286P,.287,.386,.386C,.386P,.387,' +
//    '.486,.486C,.486P,.586,.8086,.8087,.NO87,P186,P286,P286N,P286P,P287,P386,P386N,' +
//    'P386P,P387,P486,P486N,P8086,P8087,PNO87';
//
//  GlobalControl: UnicodeString =
//    'align,emul,ideal,jumps,largestack,masm,masm51,.msfloat,' +
//    'multerrs,name,noemul,nojumps,nomasm51,nomulterrs,nosmart,nowarn,option,popcontext,' +
//    'pushcontext,quirks,.radix,radix,smallstack,smart,version,warn';
//
//  SegmentControl: UnicodeString =
//    '.alpha,alpha,assume,.code,codeseg,.const,const,.data,.data?,' +
//    'dataseg,.dosseg,end,ends,.exit,exitcode,.fardata,fardata,.fardata?,group,.model,' +
//    'model,org,segment,.seq,seq,.stack,stack,.startup,startupcode,udataseg,ufardata';
//
//  Procedures: UnicodeString =
//    'arg,endp,invoke,label,local,locals,nolocals,proc,proto,uses';
//
//  Scope: UnicodeString =
//    'comm,extern.externdef,extrn,global,include,includelib,publicdll,public';
//
//  DataAllocation: UnicodeString =
//    'byte,db,dd,df,dp,dt,dw,dword,dq,fword,qword,real4,real8,' +
//    'real10,sbyte,sdword,sword,tbyte,word';
//
//  ComplexDataTypes: UnicodeString =
//    'align,ends,enum,even,evendata,record,struc,struct,table,' +
//    'tblptr,typedef,union';
//
//  Macros: UnicodeString =
//    'endm,exitm,for,forc,goto,irp,irpc,macro,purge,repeat,rept,textequ,while';
//
//  ConditionalAssembly: UnicodeString =
//    'else,elseif,endif,if,if1,if2,ifb,ifdef,ifdif,ifdif1,ife,' +
//    'ifidn,ifidni,ifnb,ifndef';
//
//  ConditionalError: UnicodeString =
//    '.err,err,.err1,.err2,.errb,.errdef,.errdif,.errdifi,.erredifni'+
//    'errif,errif1,errif2,errifb,errifdef,errifdif,errifdifi,errife,errifidn,errifidni,' +
//    'errifnn,errifndef,.errnb,.errndef,.errnz';
//
//  ListingControl: UnicodeString =
//    '%bin,%conds,%cref,.cref,%crefall,%crefref,%crefuref,%ctls,%depth,' +
//    '%incl,.lall,.lfcond,%linum,%list,.list,.listall,.listif,.listmacro,.listmacroall,%macs,' +
//    '%newpage,%noconds,%nocref,.nocref,%noctls,%noincl,%nolist,.nolist,.nolistif,.nolistmacro,' +
//    '%nomacs,%nosyms,%notrunc,page,$pagesize,%pcnt,%poplctl,%pushlctl,.sall,.sfcond,subtitle,' +
//    '%subttl,subttl,$syms,%tablsize,%text,.tfcond,%title,title,%trunc,.xall,.xcref,.xlist';
//
//  StringControl: UnicodeString = 'catstr,instr,sizestr,substr';
//
//  Miscellaneous: UnicodeString = '=,comment,display,echo,equ,%out';

implementation

uses
  SynEditStrConst;

const
  KeyWords: array[0..15] of string = (
    '', 'http://', '', 'https://', 'news:', 'gopher://', '', 'prospero://',
    'news://', 'www', 'nntp://', 'ftp://', 'wais://', '', 'telnet://', 'mailto:'
  );

procedure TSynAsmMASMSyn.InitIdent;
var
  i: Integer;
begin
  for i := Low(fIdentFuncTable) to High(fIdentFuncTable) do
    fIdentFuncTable[i] := AltFunc;

  fIdentFuncTable[11] := FuncFtp;
  fIdentFuncTable[5] := FuncGopher;
  fIdentFuncTable[1] := FuncHttp;
  fIdentFuncTable[3] := FuncHttps;
  fIdentFuncTable[15] := FuncMailto;
  fIdentFuncTable[4] := FuncNews;
  fIdentFuncTable[8] := FuncNews;
  fIdentFuncTable[10] := FuncNntp;
  fIdentFuncTable[7] := FuncProspero;
  fIdentFuncTable[14] := FuncTelnet;
  fIdentFuncTable[12] := FuncWais;
  fIdentFuncTable[9] := FuncWeb;
end;

//function TSynAsmMASMSyn.IsCurrentToken(const Token: string): Boolean;
//var
//  I: Integer;
//  Temp: PWideChar;
//begin
//  Temp := fToIdent;
//  if Length(Token) = fStringLen then
//  begin
//    Result := True;
//    for i := 1 to fStringLen do
//    begin
//      if Temp^ <> Token[i] then
//      begin
//        Result := False;
//        break;
//      end;
//      inc(Temp);
//    end;
//  end
//  else
//    Result := False;
//end;

function TSynAsmMASMSyn.AltFunc(Key: Integer): TtkTokenKind;
begin
  Result := tkUnknown;
end;

procedure TSynAsmMASMSyn.DoAddKeyword(AKeyword: UnicodeString; AKind: integer);
var
  HashValue: Cardinal;
begin
  HashValue := HashKey(PWideChar(AKeyword));
  fKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

procedure TSynAsmMASMSyn.DoAddDirectivesKeyword(AKeyword: UnicodeString; AKind: integer);
var
  HashValue: Cardinal;
begin
  HashValue := HashKey(PWideChar(AKeyword));
  fDirectivesKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

procedure TSynAsmMASMSyn.DoAddRegisterKeyword(AKeyword: UnicodeString; AKind: integer);
var
  HashValue: Cardinal;
begin
  HashValue := HashKey(PWideChar(AKeyword));
  fRegisterKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

procedure TSynAsmMASMSyn.DoAddApiKeyword(AKeyword: UnicodeString; AKind: integer);
var
  HashValue: Cardinal;
begin
  HashValue := HashKey(PWideChar(AKeyword));
  fApiKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

procedure TSynAsmMASMSyn.DoAddOperatorKeyword(AKeyword: UnicodeString; AKind: integer);
var
  HashValue: Cardinal;
begin
  HashValue := HashKey(PWideChar(AKeyword));
  fOperatorKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

//{$Q-}
function TSynAsmMASMSyn.HashKey(Str: PWideChar): Cardinal;
begin
  Result := 0;
  while IsIdentChar(Str^) do
  begin
    Result := Result * 197 + Ord(Str^) * 14;
    inc(Str);
  end;
  Result := Result mod 4561;
  fStringLen := Str - fToIdent;
end;
//{$Q+}

//function TSynAsmMASMSyn.HashKey(Str: PWideChar): Integer;
//begin
//  Result := 0;
//  while CharInSet(Str^, ['A'..'Z', 'a'..'z']) do
//  begin
//    Result := (Result * 3 + Ord(Str^) div 9) mod 16;
//    inc(Str);
//  end;
//
//  if Str^ = ':' then
//  begin
//    Result := (Result * 3 + Ord(Str^) div 9) mod 16;
//    inc(Str);
//  end;
//
//  if Str^ = '/' then
//  begin
//    Result := (Result * 3 + Ord(Str^) div 9) mod 16;
//    inc(Str);
//  end;
//
//  if Str^ = '/' then
//  begin
//    Result := (Result * 3 + Ord(Str^) div 9) mod 16;
//    inc(Str);
//  end;
//
//  fStringLen := Str - fToIdent;
//end;

function TSynAsmMASMSyn.IdentKind(MayBe: PWideChar): TtkTokenKind;
var
  Entry: TSynHashEntry;
begin
  fToIdent := MayBe;
  Entry := fKeywords[HashKey(MayBe)];
  while Assigned(Entry) do
  begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if IsCurrentToken(Entry.Keyword) then
      begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;

  Entry := fDirectivesKeywords[HashKey(MayBe)];
  while Assigned(Entry) do
  begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if IsCurrentToken(Entry.Keyword) then
      begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;

  Entry := fRegisterKeywords[HashKey(MayBe)];
  while Assigned(Entry) do
  begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if IsCurrentToken(Entry.Keyword) then
      begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;

  Entry := fApiKeywords[HashKey(MayBe)];
  while Assigned(Entry) do
  begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if IsCurrentToken(Entry.Keyword) then
      begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;

  Entry := fOperatorKeywords[HashKey(MayBe)];
  while Assigned(Entry) do
  begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if IsCurrentToken(Entry.Keyword) then
      begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;

  Result := tkIdentifier;
end;

constructor TSynAsmMASMSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSynColors := TSynColors.Create;
  fCaseSensitive := False;

  fKeywords := TSynHashEntryList.Create;
  fDirectivesKeywords := TSynHashEntryList.Create;
  fRegisterKeywords := TSynHashEntryList.Create;
  fApiKeywords := TSynHashEntryList.Create;
  fOperatorKeywords := TSynHashEntryList.Create;

  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment, SYNS_FriendlyAttrComment);
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);

  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier, SYNS_FriendlyAttrIdentifier);
  AddAttribute(fIdentifierAttri);

  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord, SYNS_FriendlyAttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);

  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber, SYNS_FriendlyAttrNumber);
  fNumberAttri.Foreground := clRed;
  AddAttribute(fNumberAttri);

  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
  AddAttribute(fSpaceAttri);

  fStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrString, SYNS_FriendlyAttrString);
  AddAttribute(fStringAttri);

  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol, SYNS_FriendlyAttrSymbol);
  AddAttribute(fSymbolAttri);

  fDirectivesAttri   := TSynHighlighterAttributes.Create('Directives', 'Directives');
  fDirectivesAttri.Foreground := $008CFF;
  fDirectivesAttri.Style := [fsBold];
  AddAttribute(fDirectivesAttri);

  fRegisterAttri := TSynHighlighterAttributes.Create('Register', 'Register');
  fRegisterAttri.Foreground := $32CD32;
  fRegisterAttri.Style := [fsBold];
  AddAttribute(fRegisterAttri);

  fApiAttri := TSynHighlighterAttributes.Create('Api', 'Api');
  fApiAttri.Foreground := clYellow;
  fApiAttri.Style := [fsBold];
  AddAttribute(fApiAttri);

  fIncludeAttri := TSynHighlighterAttributes.Create('Include', 'Include');
  fIncludeAttri.Foreground := clMoneyGreen;
  fIncludeAttri.Style := [fsBold];
  AddAttribute(fIncludeAttri);

  fOperatorAttri := TSynHighlighterAttributes.Create('Operator', 'Operator');
  fOperatorAttri.Foreground := clLime;
  fOperatorAttri.Style := [fsBold];
  AddAttribute(fOperatorAttri);

  EnumerateKeywords(Ord(tkKey), Mnemonics, IsIdentChar, DoAddKeyword);
  EnumerateKeywords(Ord(tkDirectives), Directives, IsIdentChar, DoAddDirectivesKeyword);
  EnumerateKeywords(Ord(tkRegister), Registers, IsIdentChar, DoAddRegisterKeyword);

  if FileExists('WinAPIInsertList.txt') then
    FApis := TFile.ReadAllText('WinAPIInsertList.txt');
  EnumerateKeywords(Ord(tkApi), FApis, IsIdentChar, DoAddApiKeyword);

  EnumerateKeywords(Ord(tkOperator), Operators, IsIdentChar, DoAddOperatorKeyword);

  fURIAttri := TSynHighlighterAttributes.Create(SYNS_AttrURI, SYNS_FriendlyAttrURI);
  fURIAttri.Foreground := clBlue;
  fURIAttri.Style := [fsUnderline];
  AddAttribute(fURIAttri);

  fVisitedURIAttri := TSynHighlighterAttributes.Create(SYNS_AttrVisitedURI, SYNS_FriendlyAttrVisitedURI);
  fVisitedURIAttri.Foreground := clPurple;
  fVisitedURIAttri.Style := [fsUnderline];
  AddAttribute(fVisitedURIAttri);

  InitIdent;

  SetAttributesOnChange(DefHighlightChange);
  fDefaultFilter      := SYNS_FilterX86Assembly;
end;

destructor TSynAsmMASMSyn.Destroy;
begin
  fKeywords.Free;
  fDirectivesKeywords.Free;
  fRegisterKeywords.Free;
  fApiKeywords.Free;
  fOperatorKeywords.Free;
  inherited Destroy;
end;

procedure TSynAsmMASMSyn.CommentProc;
begin
  if IsValidEmailAddress then
    fTokenID := tkMailtoLink
  else begin
    fTokenID := tkComment;
    repeat
      Inc(Run);
    until IsLineEnd(Run);
  end;
end;

procedure TSynAsmMASMSyn.CRProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
  if fLine[Run] = #10 then Inc(Run);
end;

procedure TSynAsmMASMSyn.GreaterProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
  if fLine[Run] = '=' then Inc(Run);
end;

procedure TSynAsmMASMSyn.IdentProc;
begin
  if IsValidEmailAddress then
    fTokenID := tkMailtoLink
  else begin
    fTokenID := IdentKind((fLine + Run));
    inc(Run, fStringLen);
    while IsIdentChar(fLine[Run]) do inc(Run);
  end;

//  if IsValidEmailAddress then
//    fTokenID := tkMailtoLink
//  else
//  begin
//    fToIdent := fLine + Run;
//    Key := HashKey(fToIdent);
//    inc(Run, fStringLen);
//
//    if Key <= 15 then
//      fTokenID := fIdentFuncTable[Key](Key)
//    else
//    begin
//      fTokenID := tkUnknown;
//    end;
//  end;
end;

procedure TSynAsmMASMSyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynAsmMASMSyn.LowerProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
  if CharInSet(fLine[Run], ['=', '>']) then Inc(Run);
end;

procedure TSynAsmMASMSyn.NullProc;
begin
  fTokenID := tkNull;
  inc(Run);
end;

procedure TSynAsmMASMSyn.NumberProc;

  function IsNumberChar: Boolean;
  begin
    case fLine[Run] of
      '0'..'9', 'a'..'f', 'h', 'A'..'F', 'H': Result := True;
      else
        Result := False;
    end;
  end;

begin
  inc(Run);
  fTokenID := tkNumber;
  while IsNumberChar do
    Inc(Run);
end;

procedure TSynAsmMASMSyn.SlashProc;
begin
  Inc(Run);
  if fLine[Run] = '/' then begin
    fTokenID := tkComment;
    repeat
      Inc(Run);
    until IsLineEnd(Run);
  end else
    fTokenID := tkSymbol;
end;

procedure TSynAsmMASMSyn.IncludeProc;
begin
  fTokenID := tkInclude;
  repeat
    Inc(Run);
  until IsLineEnd(Run);
end;

procedure TSynAsmMASMSyn.SpaceProc;
begin
  fTokenID := tkSpace;
  repeat
    Inc(Run);
  until (fLine[Run] > #32) or IsLineEnd(Run);
end;

procedure TSynAsmMASMSyn.StringProc;
begin
  fTokenID := tkString;
  if (FLine[Run + 1] = #34) and (FLine[Run + 2] = #34) then
    inc(Run, 2);
  repeat
    case FLine[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FLine[Run] = #34;
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TSynAsmMASMSyn.SingleQuoteStringProc;
begin
  fTokenID := tkString;
  if (FLine[Run + 1] = #39) and (FLine[Run + 2] = #39) then
    inc(Run, 2);
  repeat
    case FLine[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FLine[Run] = #39;
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TSynAsmMASMSyn.SymbolProc;
begin
  inc(Run);
  fTokenID := tkSymbol;
end;

procedure TSynAsmMASMSyn.UnknownProc;
begin
  inc(Run);
  fTokenID := tkIdentifier;
end;

procedure TSynAsmMASMSyn.Next;
begin
  fTokenPos := Run;
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
    #34: StringProc;
    #39: SingleQuoteStringProc;
    '>': GreaterProc;
    '<': LowerProc;
//    '/': SlashProc;
//    '\': IncludeProc;
    //'A'..'Z', 'a'..'z', '_': IdentProc;
    'A'..'Z', 'a'..'z', '_', '.', '?', '[', ']': IdentProc;   // THJ
//    'A'..'Z', 'a'..'z': ProtocolProc;   // THJ
    '0'..'9': NumberProc;
    #1..#9, #11, #12, #14..#32: SpaceProc;
    ';': CommentProc;
    //'.', ':', '&', '{', '}', '=', '^', '-', '+', '(', ')', '*': SymbolProc;
    ':', '&', '{', '}', '^', '-', '+', '(', ')', '*', '/', '\': SymbolProc;
    else
      UnknownProc;
  end;
  inherited;
end;

function TSynAsmMASMSyn.GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
    SYN_ATTR_URI: Result := fURIAttri;
    SYN_ATTR_VISITEDURI: Result := fVisitedURIAttri;
  else
    Result := nil;
  end;
end;

function TSynAsmMASMSyn.GetEol: Boolean;
begin
  Result := Run = fLineLen + 1;
end;

function TSynAsmMASMSyn.GetTokenAttribute: TSynHighlighterAttributes;
var
  Visited: Boolean;
begin
  case fTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkUnknown: Result := fIdentifierAttri;
    tkDirectives: Result := fDirectivesAttri;
    tkRegister: Result := fRegisterAttri;
    tkApi: Result := fApiAttri;
    tkInclude: Result := fIncludeAttri;
    tkOperator: Result := fOperatorAttri;
    tkFtpLink, tkGopherLink, tkHttpLink, tkHttpsLink, tkMailtoLink, tkNewsLink,
    tkNntpLink, tkProsperoLink, tkTelnetLink, tkWaisLink, tkWebLink:
    begin
      Visited := False;
      if Assigned(FAlreadyVisitedURI) then
        Visited := FAlreadyVisitedURI(GetToken);
      if Visited then
        Result := fVisitedURIAttri
      else
        Result := fURIAttri;
    end;
    else Result := nil;
  end;
end;

function TSynAsmMASMSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynAsmMASMSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

class function TSynAsmMASMSyn.GetLanguageName: string;
begin
  Result := SYNS_LangMASM;
end;

function TSynAsmMASMSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterX86Assembly;
end;

function TSynAsmMASMSyn.GetSampleSource: UnicodeString;
begin
  Result := '; x86 assembly sample source'#13#10 +
            '  CODE	SEGMENT	BYTE PUBLIC'#13#10 +
            '    ASSUME	CS:CODE'#13#10 +
            #13#10 +
            '    PUSH SS'#13#10 +
            '    POP DS'#13#10 +
            '    MOV AX, AABBh'#13#10 +
            '    MOV	BYTE PTR ES:[DI], 255'#13#10 +
            '    JMP SHORT AsmEnd'#13#10 +
            #13#10 +
            '  welcomeMsg DB ''Hello World'', 0'#13#10 +
            #13#10 +
            '  AsmEnd:'#13#10 +
            '    MOV AX, 0'#13#10 +
            #13#10 +
            '  CODE	ENDS'#13#10 +
            'END';
end;

procedure TSynAsmMASMSyn.SaveFile(fName: string);
begin
  FSynColors.SaveFile(fName);
end;

procedure TSynAsmMASMSyn.LoadFile(fName: string);
begin
  FSynColors.LoadFile(fName);
end;

class function TSynAsmMASMSyn.GetFriendlyLanguageName: UnicodeString;
begin
  Result := SYNS_FriendlyLangMASM;
end;

//function TSynAsmMASMSyn.IsIdentChar(AChar: WideChar): Boolean;
//begin
//  Result := SynIsCharAlphaNumeric(AChar);
//end;

procedure TSynAsmMASMSyn.SetAlreadyVisitedURIFunc(Value: TAlreadyVisitedURIFunc);
begin
  FAlreadyVisitedURI := Value;
end;

procedure TSynAsmMASMSyn.SetURIAttri(const Value: TSynHighlighterAttributes);
begin
  fURIAttri.Assign(Value);
end;

procedure TSynAsmMASMSyn.SetVisitedURIAttri(const Value: TSynHighlighterAttributes);
begin
  fVisitedURIAttri.Assign(Value);
end;

procedure TSynAsmMASMSyn.AssignColors(memo: TSynMemo);
var
  e: TSynColorsElement;
begin
  memo.Color := FSynColors.Editor.Colors.Background;
  memo.ActiveLineColor := FSynColors.Editor.Colors.ActiveLineBackground;
  //memo.Gutter.Color := FSynColors.Editor.Colors.Gutter;
  //memo.Gutter.Font.Color := FSynColors.Editor.Colors.GutterLineNumber;
  //memo.Gutter.UseFontStyle := true;
//  memo.Gutter.Color := $313131;
//  memo.Gutter.Font.Color := clSilver;
//  memo.Gutter.UseFontStyle := true;
//  memo.Gutter.BorderColor := FSynColors.Editor.Colors.GutterBorder;
//  memo.Gutter.GradientStartColor := FSynColors.Editor.Colors.GutterGradientStart;
//  memo.Gutter.GradientEndColor := FSynColors.Editor.Colors.GutterGradientEnd;
//  memo.RightEdgeColor := FSynColors.Editor.Colors.RightEdge;
//  memo.ScrollHintColor := FSynColors.Editor.Colors.ScrollHint;
//  memo.SelectedColor.Background := FSynColors.Editor.Colors.SelectiondBackground;
//  memo.SelectedColor.Foreground := FSynColors.Editor.Colors.SelectionForeground;

  memo.Font.Size := FSynColors.Editor.FontSizes.Text;
  memo.Font.Name := FSynColors.Editor.Fonts.Text;
  memo.Gutter.Font.Size := FSynColors.Editor.FontSizes.Gutter;
  memo.Gutter.Font.Name := FSynColors.Editor.Fonts.Gutter;

  e := GetElement('Comment');
  if e <> nil then begin
    fCommentAttri.Foreground := e.Foreground;
    fCommentAttri.Background := e.Background;
    fCommentAttri.Style := e.Style;
  end;

  e := GetElement('Identifier');
  if e <> nil then begin
    fIdentifierAttri.Foreground := e.Foreground;
    fIdentifierAttri.Background := e.Background;
    fIdentifierAttri.Style := e.Style;
  end;

  e := GetElement('Keywords');
  if e <> nil then begin
    fKeyAttri.Foreground := e.Foreground;
    fKeyAttri.Background := e.Background;
    fKeyAttri.Style := e.Style;
  end;

  e := GetElement('Directive');
  if e <> nil then begin
    fDirectivesAttri.Foreground := e.Foreground;
    fDirectivesAttri.Background := e.Background;
    fDirectivesAttri.Style := e.Style;
  end;

  e := GetElement('Register');
  if e <> nil then begin
    fRegisterAttri.Foreground := e.Foreground;
    fRegisterAttri.Background := e.Background;
    fRegisterAttri.Style := e.Style;
  end;

  e := GetElement('Api');
  if e <> nil then begin
    fApiAttri.Foreground := e.Foreground;
    fApiAttri.Background := e.Background;
    fApiAttri.Style := e.Style;
  end;

  e := GetElement('Include');
  if e <> nil then begin
    fIncludeAttri.Foreground := e.Foreground;
    fIncludeAttri.Background := e.Background;
    fIncludeAttri.Style := e.Style;
  end;

  e := GetElement('String');
  if e <> nil then begin
    fStringAttri.Foreground := e.Foreground;
    fStringAttri.Background := e.Background;
    fStringAttri.Style := e.Style;
  end;

  e := GetElement('Symbol');
  if e <> nil then begin
    fSymbolAttri.Foreground := e.Foreground;
    fSymbolAttri.Background := e.Background;
    fSymbolAttri.Style := e.Style;
  end;

  e := GetElement('Number');
  if e <> nil then begin
    fNumberAttri.Foreground := e.Foreground;
    fNumberAttri.Background := e.Background;
    fNumberAttri.Style := e.Style;
  end;

  e := GetElement('Operator');
  if e <> nil then begin
    fOperatorAttri.Foreground := e.Foreground;
    fOperatorAttri.Background := e.Background;
    fOperatorAttri.Style := e.Style;
  end;

//  fSpaceAttri: TSynHighlighterAttributes;
end;

function TSynAsmMASMSyn.GetElement(find: string): TSynColorsElement;
var
  I: Integer;
begin
  for I := 0 to FSynColors.Elements.Count-1 do
  begin
    if FSynColors.Elements.Items[I].Name = find then
    begin
      result := FSynColors.Elements.Items[I];
      exit;
    end;
  end;
end;

procedure TSynAsmMASMSyn.ProtocolProc;
var
  Key: Integer;
begin
  if IsValidEmailAddress then
    fTokenID := tkMailtoLink
  else
  begin
    fToIdent := fLine + Run;
    Key := HashKey(fToIdent);
    inc(Run, fStringLen);

    if Key <= 15 then
      fTokenID := fIdentFuncTable[Key](Key)
    else
      fTokenID := tkUnknown;
  end;
end;

function TSynAsmMASMSyn.FuncFtp(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkFtpLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncGopher(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkGopherLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncHttp(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkHttpLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncHttps(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkHttpsLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncMailto(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkMailtoLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncNews(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkNewsLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncNntp(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkNntpLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncProspero(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkProsperoLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncTelnet(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkTelnetLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncWais(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidURI then
    Result := tkWaisLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.FuncWeb(Key: Integer): TtkTokenKind;
begin
  if IsCurrentToken(KeyWords[Key]) and IsValidWebLink then
    Result := tkWebLink
  else
    Result := tkUnknown;
end;

function TSynAsmMASMSyn.IsAlphaNum(AChar: WideChar): Boolean;
begin
  Result := SynIsCharAlphaNumeric(AChar);
end;

function TSynAsmMASMSyn.IsMark(AChar: WideChar): Boolean;
begin
  case AChar of
    '-', '_', '.', '!', '~', '*', '''', '(' , ')':
      Result := True;
    else
      Result := False;
  end;
end;

function TSynAsmMASMSyn.IsReserved(AChar: WideChar): Boolean;
begin
  case AChar of
    ';', '/', '?', ':', '@', '&', '=', '+', '$', ',', '%', '#':
      Result := True;
    else
      Result := False;
  end;
end;

function TSynAsmMASMSyn.IsUnreserved(AChar: WideChar): Boolean;
begin
  Result := IsAlphaNum(AChar) or IsMark(AChar);
end;

function TSynAsmMASMSyn.IsURIChar(AChar: WideChar): Boolean;
begin
  Result := IsReserved(AChar) or IsUnreserved(AChar);
end;

function TSynAsmMASMSyn.IsNeverAtEnd(AChar: WideChar): Boolean;
begin
  Result := (IsMark(AChar) and (AChar <> '''')) or
            (IsReserved(AChar) and (AChar <> '/') and (AChar <> '$'));
end;

function TSynAsmMASMSyn.IsEMailAddressChar(AChar: WideChar): Boolean;
begin
  case AChar of
    '.', '_', '-', '@', ';':
      Result := True;
    else
      Result := IsAlphaNum(AChar);
  end;
end;

function TSynAsmMASMSyn.IsNeverAtEMailAddressEnd(AChar: WideChar): Boolean;
begin
  Result := (AChar = '.') or (AChar = '@');
end;

function TSynAsmMASMSyn.IsValidEmailAddress: Boolean;
var
  StartPos, AtPos, DotPos: Integer;
begin
  StartPos := Run;

  AtPos := -1;
  DotPos := -1;
  while IsEMailAddressChar(fLine[Run]) do
  begin
    if fLine[Run] = '@' then
      AtPos := Run
    else if fLine[Run] = '.' then
      // reject array of dots: "neighbour" dots are not allowed
      if (Run = StartPos) or (DotPos >= 0) and (DotPos = Run - 1) then
        break
      else
        DotPos := Run;
    Inc(Run);
  end;

  while (Run > StartPos) and (IsNeverAtEMailAddressEnd(fLine[Run - 1])) do
    dec(Run);

  while (DotPos >= Run) or (DotPos > -1) and (fLine[DotPos] <> '.') do
    Dec(DotPos);

  Result := (StartPos < AtPos) and (AtPos < Run - 1) and (DotPos > AtPos + 1);
  if not Result then Run := StartPos;
end;

function TSynAsmMASMSyn.IsValidURI: Boolean;
var
  ProtocolEndPos, DotPos: Integer;

  function IsRelativePath: Boolean;
  begin
    Result := (DotPos - 1 >= 0) and
      ((fLine[DotPos - 1] = '/') and (fLine[DotPos + 2] = '/')) or
      ((fLine[DotPos - 1] = '\') and (fLine[DotPos + 2] = '\'));
  end;

begin
  ProtocolEndPos := Run;

  DotPos := -1;
  while IsURIChar(fLine[Run]) do
  begin
    if fLine[Run] = '.' then
      // reject array of dots: "neighbour" dots are not allowed
      if (DotPos >= 0) and (DotPos = Run - 1) and not IsRelativePath then
        break
      else
        DotPos := Run;
    inc(Run);
  end;

  while (Run > ProtocolEndPos) and IsNeverAtEnd(fLine[Run - 1]) do
    dec(Run);

  Result := Run > ProtocolEndPos;
end;

function TSynAsmMASMSyn.IsValidWebLink: Boolean;
var
  WWWEndPos, DotPos, SecondDotPos: Integer;

  function IsRelativePath: Boolean;
  begin
    Result := (DotPos - 1 >= 0) and
      ((fLine[DotPos - 1] = '/') and (fLine[DotPos + 2] = '/')) or
      ((fLine[DotPos - 1] = '\') and (fLine[DotPos + 2] = '\'));
  end;

begin
  WWWEndPos := Run;

  DotPos := -1;
  SecondDotPos := -1;
  while IsURIChar(fLine[Run]) do
  begin
    if fLine[Run] = '.' then
      // reject array of dots: "neighbour" dots are not allowed
      if (DotPos >= 0) and (DotPos = Run - 1) and not IsRelativePath then
        break
      else
      begin
        DotPos := Run;
        if SecondDotPos = -2 then SecondDotPos := DotPos;
        if SecondDotPos = -1 then SecondDotPos := -2;
      end;
    inc(Run);
  end;

  while (Run > WWWEndPos) and IsNeverAtEnd(fLine[Run - 1]) do
    dec(Run);

  Result := (Run > WWWEndPos) and (fLine[WWWEndPos] = '.') and
            (SecondDotPos > WWWEndPos + 1) and (SecondDotPos < Run);
end;

initialization
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynAsmMASMSyn);
{$ENDIF}
end.

