// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SynEditPrintMarginsDialog.pas' rev: 25.00 (Windows)

#ifndef SyneditprintmarginsdialogHPP
#define SyneditprintmarginsdialogHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.Buttons.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <SynEditPrint.hpp>	// Pascal unit
#include <SynEditPrintTypes.hpp>	// Pascal unit
#include <SynEditPrintMargins.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Syneditprintmarginsdialog
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TSynEditPrintMarginsDlg;
class PASCALIMPLEMENTATION TSynEditPrintMarginsDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	Vcl::Extctrls::TImage* Image1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TLabel* Label7;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TCheckBox* CBMirrorMargins;
	Vcl::Stdctrls::TLabel* Label10;
	Vcl::Stdctrls::TLabel* Label11;
	Vcl::Stdctrls::TEdit* EditLeft;
	Vcl::Stdctrls::TEdit* EditRight;
	Vcl::Stdctrls::TEdit* EditTop;
	Vcl::Stdctrls::TEdit* EditBottom;
	Vcl::Stdctrls::TEdit* EditGutter;
	Vcl::Stdctrls::TEdit* EditHeader;
	Vcl::Stdctrls::TEdit* EditFooter;
	Vcl::Stdctrls::TEdit* EditHFInternalMargin;
	Vcl::Stdctrls::TEdit* EditLeftHFTextIndent;
	Vcl::Stdctrls::TEdit* EditRightHFTextIndent;
	Vcl::Stdctrls::TComboBox* CBUnits;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall CBUnitsChange(System::TObject* Sender);
	
private:
	Syneditprintmargins::TSynEditPrintMargins* FMargins;
	bool FInternalCall;
	
public:
	HIDESBASE void __fastcall SetMargins(Syneditprintmargins::TSynEditPrintMargins* SynEditMargins);
	void __fastcall GetMargins(Syneditprintmargins::TSynEditPrintMargins* SynEditMargins);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TSynEditPrintMarginsDlg(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TSynEditPrintMarginsDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TSynEditPrintMarginsDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TSynEditPrintMarginsDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Syneditprintmarginsdialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SYNEDITPRINTMARGINSDIALOG)
using namespace Syneditprintmarginsdialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SyneditprintmarginsdialogHPP
