// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SynEditDD.pas' rev: 25.00 (Windows)

#ifndef SyneditddHPP
#define SyneditddHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <SynEditReg.hpp>	// Pascal unit
#include <SynEditPropertyReg.hpp>	// Pascal unit
#include <SynHighlighterManager.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.Internal.ExcUtils.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.VarUtils.hpp>	// Pascal unit
#include <System.Variants.hpp>	// Pascal unit
#include <System.AnsiStrings.hpp>	// Pascal unit
#include <System.Math.hpp>	// Pascal unit
#include <System.TimeSpan.hpp>	// Pascal unit
#include <System.SyncObjs.hpp>	// Pascal unit
#include <System.Generics.Defaults.hpp>	// Pascal unit
#include <System.Rtti.hpp>	// Pascal unit
#include <System.TypInfo.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.DateUtils.hpp>	// Pascal unit
#include <System.IOUtils.hpp>	// Pascal unit
#include <System.Win.Registry.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <System.Actions.hpp>	// Pascal unit
#include <Vcl.ActnList.hpp>	// Pascal unit
#include <System.HelpIntfs.hpp>	// Pascal unit
#include <Winapi.UxTheme.hpp>	// Pascal unit
#include <Vcl.GraphUtil.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Winapi.ShellAPI.hpp>	// Pascal unit
#include <Vcl.Printers.hpp>	// Pascal unit
#include <Vcl.Clipbrd.hpp>	// Pascal unit
#include <Vcl.ComCtrls.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <Vcl.Themes.hpp>	// Pascal unit
#include <Winapi.FlatSB.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Menus.hpp>	// Pascal unit
#include <System.Win.ComObj.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <SynEditMiscClasses.hpp>	// Pascal unit
#include <SynEditHighlighter.hpp>	// Pascal unit
#include <SynRegExpr.hpp>	// Pascal unit
#include <SynUnicode.hpp>	// Pascal unit
#include <SynTextDrawer.hpp>	// Pascal unit
#include <SynEditKeyCmds.hpp>	// Pascal unit
#include <SynEdit.hpp>	// Pascal unit
#include <Vcl.Buttons.hpp>	// Pascal unit
#include <Data.SqlTimSt.hpp>	// Pascal unit
#include <Data.FmtBcd.hpp>	// Pascal unit
#include <Data.DB.hpp>	// Pascal unit
#include <Vcl.DBLogDlg.hpp>	// Pascal unit
#include <Vcl.DBPWDlg.hpp>	// Pascal unit
#include <Vcl.DBCtrls.hpp>	// Pascal unit
#include <SynEditExport.hpp>	// Pascal unit
#include <SynExportHTML.hpp>	// Pascal unit
#include <SynExportRTF.hpp>	// Pascal unit
#include <Vcl.CheckLst.hpp>	// Pascal unit
#include <SynHighlighterADSP21xx.hpp>	// Pascal unit
#include <SynHighlighterAsm.hpp>	// Pascal unit
#include <JsonDataObjects.hpp>	// Pascal unit
#include <SynHighlighterAsmMASM.hpp>	// Pascal unit
#include <SynHighlighterAWK.hpp>	// Pascal unit
#include <SynHighlighterBaan.hpp>	// Pascal unit
#include <SynHighlighterBat.hpp>	// Pascal unit
#include <SynHighlighterCAC.hpp>	// Pascal unit
#include <SynHighlighterCache.hpp>	// Pascal unit
#include <SynHighlighterCobol.hpp>	// Pascal unit
#include <SynHighlighterCpp.hpp>	// Pascal unit
#include <SynHighlighterCS.hpp>	// Pascal unit
#include <SynHighlighterCSS.hpp>	// Pascal unit
#include <SynHighlighterDfm.hpp>	// Pascal unit
#include <SynHighlighterDml.hpp>	// Pascal unit
#include <SynHighlighterDOT.hpp>	// Pascal unit
#include <SynHighlighterDWS.hpp>	// Pascal unit
#include <SynHighlighterEiffel.hpp>	// Pascal unit
#include <SynHighlighterFortran.hpp>	// Pascal unit
#include <SynHighlighterFoxpro.hpp>	// Pascal unit
#include <SynHighlighterGalaxy.hpp>	// Pascal unit
#include <SynHighlighterGeneral.hpp>	// Pascal unit
#include <SynHighlighterHaskell.hpp>	// Pascal unit
#include <SynHighlighterHC11.hpp>	// Pascal unit
#include <SynHighlighterHP48.hpp>	// Pascal unit
#include <SynHighlighterHtml.hpp>	// Pascal unit
#include <SynHighlighterIni.hpp>	// Pascal unit
#include <SynHighlighterInno.hpp>	// Pascal unit
#include <SynHighlighterJava.hpp>	// Pascal unit
#include <SynHighlighterJScript.hpp>	// Pascal unit
#include <SynHighlighterJSON.hpp>	// Pascal unit
#include <SynHighlighterKix.hpp>	// Pascal unit
#include <SynHighlighterModelica.hpp>	// Pascal unit
#include <SynHighlighterM3.hpp>	// Pascal unit
#include <SynHighlighterPas.hpp>	// Pascal unit
#include <SynHighlighterPerl.hpp>	// Pascal unit
#include <SynHighlighterPHP.hpp>	// Pascal unit
#include <SynHighlighterProgress.hpp>	// Pascal unit
#include <SynHighlighterPython.hpp>	// Pascal unit
#include <SynHighlighterRC.hpp>	// Pascal unit
#include <SynHighlighterRuby.hpp>	// Pascal unit
#include <SynHighlighterSml.hpp>	// Pascal unit
#include <SynHighlighterSQL.hpp>	// Pascal unit
#include <SynHighlighterTclTk.hpp>	// Pascal unit
#include <SynHighlighterTeX.hpp>	// Pascal unit
#include <SynHighlighterUNIXShellScript.hpp>	// Pascal unit
#include <SynHighlighterURI.hpp>	// Pascal unit
#include <SynHighlighterVB.hpp>	// Pascal unit
#include <SynHighlighterVBScript.hpp>	// Pascal unit
#include <SynHighlighterVrml97.hpp>	// Pascal unit
#include <SynHighlighterGWS.hpp>	// Pascal unit
#include <SynHighlighterCPM.hpp>	// Pascal unit
#include <SynHighlighterSDD.hpp>	// Pascal unit
#include <SynHighlighterXML.hpp>	// Pascal unit
#include <SynHighlighterMsg.hpp>	// Pascal unit
#include <SynHighlighterIDL.hpp>	// Pascal unit
#include <SynHighlighterUnreal.hpp>	// Pascal unit
#include <SynHighlighterST.hpp>	// Pascal unit
#include <SynHighlighterLDraw.hpp>	// Pascal unit
#include <SynURIOpener.hpp>	// Pascal unit
#include <IDEMessages.hpp>	// Pascal unit
#include <Vcl.CaptionedDockTree.hpp>	// Pascal unit
#include <Vcl.DockTabSet.hpp>	// Pascal unit
#include <PercentageDockTree.hpp>	// Pascal unit
#include <Vcl.ExtDlgs.hpp>	// Pascal unit
#include <Winapi.Mapi.hpp>	// Pascal unit
#include <Vcl.ExtActns.hpp>	// Pascal unit
#include <Vcl.ActnMenus.hpp>	// Pascal unit
#include <Vcl.ActnMan.hpp>	// Pascal unit
#include <Vcl.PlatformDefaultStyleActnCtrls.hpp>	// Pascal unit
#include <BaseDock.hpp>	// Pascal unit
#include <DeskUtil.hpp>	// Pascal unit
#include <DeskForm.hpp>	// Pascal unit
#include <DockForm.hpp>	// Pascal unit
#include <Xml.Win.msxmldom.hpp>	// Pascal unit
#include <Xml.Xmldom.hpp>	// Pascal unit
#include <ToolsAPI.hpp>	// Pascal unit
#include <Proxies.hpp>	// Pascal unit
#include <DesignEditors.hpp>	// Pascal unit
#include <Vcl.AxCtrls.hpp>	// Pascal unit
#include <Vcl.AppEvnts.hpp>	// Pascal unit
#include <TreeIntf.hpp>	// Pascal unit
#include <TopLevels.hpp>	// Pascal unit
#include <StFilSys.hpp>	// Pascal unit
#include <IDEHelp.hpp>	// Pascal unit
#include <ComponentDesigner.hpp>	// Pascal unit
#include <VCLEditors.hpp>	// Pascal unit
#include <Vcl.Grids.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Syneditdd
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
}	/* namespace Syneditdd */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SYNEDITDD)
using namespace Syneditdd;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SyneditddHPP
