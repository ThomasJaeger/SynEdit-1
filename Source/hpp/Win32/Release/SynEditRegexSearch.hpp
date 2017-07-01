// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SynEditRegexSearch.pas' rev: 25.00 (Windows)

#ifndef SyneditregexsearchHPP
#define SyneditregexsearchHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <SynEditTypes.hpp>	// Pascal unit
#include <SynRegExpr.hpp>	// Pascal unit
#include <SynEditMiscClasses.hpp>	// Pascal unit
#include <SynUnicode.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Syneditregexsearch
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TSynEditRegexSearch;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSynEditRegexSearch : public Syneditmiscclasses::TSynEditSearchCustom
{
	typedef Syneditmiscclasses::TSynEditSearchCustom inherited;
	
private:
	Synregexpr::TRegExpr* fRegex;
	System::Classes::TList* fPositions;
	System::Classes::TList* fLengths;
	
protected:
	virtual System::UnicodeString __fastcall GetPattern(void);
	virtual void __fastcall SetPattern(const System::UnicodeString Value);
	virtual void __fastcall SetOptions(const Synedittypes::TSynSearchOptions Value);
	virtual int __fastcall GetLength(int Index);
	virtual int __fastcall GetResult(int Index);
	virtual int __fastcall GetResultCount(void);
	
public:
	__fastcall virtual TSynEditRegexSearch(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TSynEditRegexSearch(void);
	virtual int __fastcall FindAll(const System::UnicodeString NewText);
	virtual System::UnicodeString __fastcall Replace(const System::UnicodeString aOccurrence, const System::UnicodeString aReplacement);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Syneditregexsearch */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SYNEDITREGEXSEARCH)
using namespace Syneditregexsearch;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SyneditregexsearchHPP
