// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SynEditExport.pas' rev: 25.00 (Windows)

#ifndef SyneditexportHPP
#define SyneditexportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Clipbrd.hpp>	// Pascal unit
#include <SynEditHighlighter.hpp>	// Pascal unit
#include <SynEditTypes.hpp>	// Pascal unit
#include <SynUnicode.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Syneditexport
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS ESynEncoding;
#pragma pack(push,4)
class PASCALIMPLEMENTATION ESynEncoding : public Synedittypes::ESynError
{
	typedef Synedittypes::ESynError inherited;
	
public:
	/* Exception.Create */ inline __fastcall ESynEncoding(const System::UnicodeString Msg) : Synedittypes::ESynError(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ESynEncoding(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Synedittypes::ESynError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall ESynEncoding(NativeUInt Ident)/* overload */ : Synedittypes::ESynError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ESynEncoding(System::PResStringRec ResStringRec)/* overload */ : Synedittypes::ESynError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ESynEncoding(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Synedittypes::ESynError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall ESynEncoding(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Synedittypes::ESynError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall ESynEncoding(const System::UnicodeString Msg, int AHelpContext) : Synedittypes::ESynError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ESynEncoding(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Synedittypes::ESynError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESynEncoding(NativeUInt Ident, int AHelpContext)/* overload */ : Synedittypes::ESynError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESynEncoding(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Synedittypes::ESynError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESynEncoding(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Synedittypes::ESynError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESynEncoding(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Synedittypes::ESynError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ESynEncoding(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TSynCustomExporter;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSynCustomExporter : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	System::Classes::TMemoryStream* fBuffer;
	int FCharSize;
	bool fFirstAttribute;
	bool FStreaming;
	void __fastcall AssignFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetEncoding(const Synunicode::TSynEncoding Value);
	void __fastcall SetExportAsText(bool Value);
	void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetHighlighter(Synedithighlighter::TSynCustomHighlighter* Value);
	void __fastcall SetTitle(const System::UnicodeString Value);
	void __fastcall SetUseBackground(const bool Value);
	int __fastcall StringSize(const System::UnicodeString AText);
	void __fastcall WriteString(const System::UnicodeString AText);
	
protected:
	System::Uitypes::TColor fBackgroundColor;
	unsigned fClipboardFormat;
	System::UnicodeString fDefaultFilter;
	Synunicode::TSynEncoding FEncoding;
	bool fExportAsText;
	Vcl::Graphics::TFont* fFont;
	Synedithighlighter::TSynCustomHighlighter* fHighlighter;
	System::Uitypes::TColor fLastBG;
	System::Uitypes::TColor fLastFG;
	System::Uitypes::TFontStyles fLastStyle;
	System::UnicodeString fTitle;
	bool fUseBackground;
	void __fastcall AddData(const System::UnicodeString AText);
	void __fastcall AddDataNewLine(const System::UnicodeString AText);
	void __fastcall AddNewLine(void);
	void __fastcall CopyToClipboardFormat(unsigned AFormat);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall FormatAttributeDone(bool BackgroundChanged, bool ForegroundChanged, System::Uitypes::TFontStyles FontStylesChanged) = 0 ;
	virtual void __fastcall FormatAttributeInit(bool BackgroundChanged, bool ForegroundChanged, System::Uitypes::TFontStyles FontStylesChanged) = 0 ;
	virtual void __fastcall FormatAfterLastAttribute(void) = 0 ;
	virtual void __fastcall FormatBeforeFirstAttribute(bool BackgroundChanged, bool ForegroundChanged, System::Uitypes::TFontStyles FontStylesChanged) = 0 ;
	virtual void __fastcall FormatToken(System::UnicodeString Token);
	virtual void __fastcall FormatNewLine(void) = 0 ;
	int __fastcall GetBufferSize(void);
	virtual unsigned __fastcall GetClipboardFormat(void);
	virtual System::UnicodeString __fastcall GetFooter(void) = 0 ;
	virtual System::UnicodeString __fastcall GetFormatName(void);
	virtual System::UnicodeString __fastcall GetHeader(void) = 0 ;
	void __fastcall InsertData(int APos, const System::UnicodeString AText);
	virtual System::UnicodeString __fastcall ReplaceReservedChar(System::WideChar AChar) = 0 ;
	System::UnicodeString __fastcall ReplaceReservedChars(System::UnicodeString AToken);
	virtual void __fastcall SetTokenAttribute(Synedithighlighter::TSynHighlighterAttributes* Attri);
	virtual bool __fastcall UseBom(void) = 0 ;
	
public:
	__fastcall virtual TSynCustomExporter(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TSynCustomExporter(void);
	virtual void __fastcall Clear(void);
	void __fastcall CopyToClipboard(void);
	void __fastcall ExportAll(System::Classes::TStrings* ALines);
	void __fastcall ExportRange(System::Classes::TStrings* ALines, const Synedittypes::TBufferCoord &Start, const Synedittypes::TBufferCoord &Stop);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	virtual Synunicode::TSynEncodings __fastcall SupportedEncodings(void) = 0 ;
	__property System::Uitypes::TColor Color = {read=fBackgroundColor, write=fBackgroundColor, nodefault};
	__property System::UnicodeString DefaultFilter = {read=fDefaultFilter, write=fDefaultFilter};
	__property Synunicode::TSynEncoding Encoding = {read=FEncoding, write=SetEncoding, default=0};
	__property bool ExportAsText = {read=fExportAsText, write=SetExportAsText, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=fFont, write=SetFont};
	__property System::UnicodeString FormatName = {read=GetFormatName};
	__property Synedithighlighter::TSynCustomHighlighter* Highlighter = {read=fHighlighter, write=SetHighlighter};
	__property System::UnicodeString Title = {read=fTitle, write=SetTitle};
	__property bool UseBackground = {read=fUseBackground, write=SetUseBackground, nodefault};
};

#pragma pack(pop)

typedef System::StaticArray<System::UnicodeString, 4> Syneditexport__3;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Syneditexport__3 EncodingStrs;
extern DELPHI_PACKAGE System::ResourceString _SEncodingError;
#define Syneditexport_SEncodingError System::LoadResourceString(&Syneditexport::_SEncodingError)
}	/* namespace Syneditexport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SYNEDITEXPORT)
using namespace Syneditexport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SyneditexportHPP
