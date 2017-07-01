unit SynColors;

interface

uses
  SysUtils, Classes, JsonDataObjects, Vcl.Graphics, System.Generics.Collections;

type
  TSynColorsElement = class(TPersistent)
    private
      FName: string;
      FForeground: TColor;
      FBackground: TColor;
      FStyle: TFontStyles;
    public
    published
      property Name: string read FName write FName;
      property Foreground: TColor read FForeground write FForeground default clBlack;
      property Background: TColor read FBackground write FBackground default clNone;
      property Style: TFontStyles read FStyle write FStyle;
  end;

  TSynColorsEditorColors = class(TPersistent)
    private
      FBackground: TColor;
      FActiveLineBackground: TColor;
      FGutter: TColor;
      FGutterLineNumber: TColor;
      FGutterBorder: TColor;
      FGutterGradientStart: TColor;
      FGutterGradientEnd: TColor;
      FRightEdge: TColor;
      FScrollHint: TColor;
      FSelectiondBackground: TColor;
      FSelectionForeground: TColor;
      FSearchSelectiondBackground: TColor;
      FSearchSelectionForeground: TColor;
      FCompletionProposalBackground: TColor;
      FCompletionProposalBackgroundBorder: TColor;
      FCompletionProposalSelection: TColor;
      FCompletionProposalSelectionText: TColor;
      FCompletionProposalTitle: TColor;
    public
    published
      property Background: TColor read FBackground write FBackground default clBlack;
      property ActiveLineBackground: TColor read FActiveLineBackground write FActiveLineBackground;
      property Gutter: TColor read FGutter write FGutter;
      property GutterLineNumber: TColor read FGutter write FGutter;
      property GutterBorder: TColor read FGutterBorder write FGutterBorder;
      property GutterGradientStart: TColor read FGutterGradientStart write FGutterGradientStart;
      property GutterGradientEnd: TColor read FGutterGradientEnd write FGutterGradientEnd;
      property RightEdge: TColor read FRightEdge write FRightEdge;
      property ScrollHint: TColor read FScrollHint write FScrollHint;
      property SelectiondBackground: TColor read FSelectiondBackground write FSelectiondBackground;
      property SelectionForeground: TColor read FSelectionForeground write FSelectionForeground;
      property SearchSelectiondBackground: TColor read FSearchSelectiondBackground write FSearchSelectiondBackground;
      property SearchSelectionForeground: TColor read FSearchSelectionForeground write FSearchSelectionForeground;
      property CompletionProposalBackground: TColor read FCompletionProposalBackground write FCompletionProposalBackground;
      property CompletionProposalBackgroundBorder: TColor read FCompletionProposalBackgroundBorder write FCompletionProposalBackgroundBorder;
      property CompletionProposalSelection: TColor read FCompletionProposalSelection write FCompletionProposalSelection;
      property CompletionProposalSelectionText: TColor read FCompletionProposalSelectionText write FCompletionProposalSelectionText;
      property CompletionProposalTitle: TColor read FCompletionProposalTitle write FCompletionProposalTitle;
  end;

  TSynColorsEditorFonts = class(TPersistent)
    private
      FText: TFontName;
      FCompletionProposal: TFontName;
      FGutter: TFontName;
    public
    published
      property Text: TFontName read FText write FText;
      property CompletionProposal: TFontName read FCompletionProposal write FCompletionProposal;
      property Gutter: TFontName read FGutter write FGutter;
  end;

  TSynColorsEditorFontSizes = class(TPersistent)
    private
      FText: integer;
      FCompletionProposal: integer;
      FGutter: integer;
    public
    published
      property Text: integer read FText write FText;
      property CompletionProposal: integer read FCompletionProposal write FCompletionProposal;
      property Gutter: integer read FGutter write FGutter;
  end;

  TSynColorsEditor = class(TPersistent)
    private
      FColors: TSynColorsEditorColors;
      FFonts: TSynColorsEditorFonts;
      FFontSizes: TSynColorsEditorFontSizes;
    public
    published
      property Colors: TSynColorsEditorColors read FColors write FColors;
      property Fonts: TSynColorsEditorFonts read FFonts write FFonts;
      property FontSizes: TSynColorsEditorFontSizes read FFontSizes write FFontSizes;
  end;

  TSynColors = class(TPersistent)
    private
      FVersion: integer;
      FName: string;
      FEditor: TSynColorsEditor;
      FElements: TList<TSynColorsElement>;
    public
      constructor Create; overload;
      procedure SaveFile(fileName: string);
      procedure LoadFile(fileName: string);
    published
      property Version: integer read FVersion;
      property Name: string read FName write FName;
      property Editor: TSynColorsEditor read FEditor write FEditor;
      property Elements: TList<TSynColorsElement> read FElements write FElements;
  end;

implementation

uses
  Vcl.GraphUtil;

const
  csfsBold      = '|Bold';
  csfsItalic    = '|Italic';
  csfsUnderline = '|Underline';
  csfsStrikeout = '|Strikeout';

function StringToColorDef(const AString: string; const DefaultColor: TColor): Integer;
begin
  if Trim(AString) = '' then
    Result := DefaultColor
  else
  if Pos('clWeb', AString) = 1 then
    Result := WebColorNameToColor(AString)
  else
    Result := StringToColor(AString);
end;

function FontToString(Style: TFontStyles) : string;
var
  sStyle : string;
begin
  sStyle := '';
  if (fsBold in Style) then
    sStyle := sStyle + csfsBold;
  if (fsItalic in Style) then
    sStyle := sStyle + csfsItalic;
  if (fsUnderline in Style) then
    sStyle := sStyle + csfsUnderline;
  if (fsStrikeout in Style) then
    sStyle := sStyle + csfsStrikeout;
  if ((Length( sStyle ) > 0) and ('|' = sStyle[1]))then
    sStyle := Copy(sStyle, 2, Length(sStyle) - 1);
  result := sStyle;
end;

function StrToFontStyle(const AString: string): TFontStyles;
begin
  Result := [];
  if Pos('Bold', AString) > 0 then
    Include(Result, fsBold);
  if Pos('Italic', AString) > 0 then
    Include(Result, fsItalic);
  if Pos('Underline', AString) > 0 then
    Include(Result, fsUnderline);
  if Pos('StrikeOut', AString) > 0 then
    Include(Result, fsStrikeOut);
end;

constructor TSynColors.Create;
var
  element: TSynColorsElement;
begin
  inherited Create;

  FVersion := 1;
  FName := 'Default';
  FEditor := TSynColorsEditor.Create;
  FEditor.Colors := TSynColorsEditorColors.Create;
  FEditor.Colors.Background := clBlack;
  FEditor.Colors.ActiveLineBackground := $313131;
  FEditor.Colors.Gutter := $313131;
  FEditor.Colors.GutterLineNumber := clSilver;
  FEditor.Colors.GutterBorder := clSilver;
  FEditor.Colors.GutterGradientStart := $313131;
  FEditor.Colors.GutterGradientEnd := clBlack;
  FEditor.Colors.RightEdge := $313131;
  FEditor.Colors.ScrollHint := clBlack;
  FEditor.Colors.SelectionForeground := clWhite;
  FEditor.Colors.SelectiondBackground := clBlue;
  FEditor.Colors.SearchSelectionForeground := clYellow;
  FEditor.Colors.SearchSelectiondBackground := clBlack;

  FEditor.Fonts := TSynColorsEditorFonts.Create;
  FEditor.Fonts.Text := 'Courier New';
  FEditor.Fonts.CompletionProposal := 'Courier New';
  FEditor.Fonts.Gutter := 'Courier New';

  FEditor.FontSizes := TSynColorsEditorFontSizes.Create;
  FEditor.FontSizes.Text := 12;
  FEditor.FontSizes.CompletionProposal := 11;
  FEditor.FontSizes.Gutter := 11;

  FElements := TList<TSynColorsElement>.Create;

  element := TSynColorsElement.Create;
  element.Name := 'Comment';
  element.Foreground := clSilver;
  element.Background := clNone;
  element.Style := [fsItalic];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Identifier';
  element.Foreground := clSilver;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Keywords';
  element.Foreground := clSkyBlue;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Directive';
  element.Foreground := $004080FF;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Register';
  element.Foreground := $0032CD32;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Api';
  element.Foreground := clYellow;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Include';
  element.Foreground := clMoneyGreen;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'String';
  element.Foreground := clMoneyGreen;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Symbol';
  element.Foreground := clFuchsia;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Number';
  element.Foreground := clWhite;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);

  element := TSynColorsElement.Create;
  element.Name := 'Operator';
  element.Foreground := clSkyBlue;
  element.Background := clNone;
  element.Style := [fsBold];
  FElements.Add(element);
end;

procedure TSynColors.SaveFile(fileName: string);
var
  json, jEditor, jElements, jColors, jFonts, jFontSizes: TJSONObject;
  fileContent: TStringList;
  element: TSynColorsElement;
begin
  json := TJSONObject.Create();
  json.I['Version'] := FVersion;
  json.S['Name'] := FName;

  jEditor := json.O['Editor'];
  jColors := jEditor.O['Colors'];
  jColors.S['Background'] := ColorToString(FEditor.Colors.Background);
  jColors.S['ActiveLineBackground'] := ColorToString(FEditor.Colors.ActiveLineBackground);
  jColors.S['Gutter'] := ColorToString(FEditor.Colors.Gutter);
  jColors.S['GutterLineNumber'] := ColorToString(FEditor.Colors.GutterLineNumber);
  jColors.S['GutterBorder'] := ColorToString(FEditor.Colors.GutterBorder);
  jColors.S['GutterGradientStart'] := ColorToString(FEditor.Colors.GutterGradientStart);
  jColors.S['GutterGradientEnd'] := ColorToString(FEditor.Colors.GutterGradientEnd);
  jColors.S['RightEdge'] := ColorToString(FEditor.Colors.RightEdge);
  jColors.S['ScrollHint'] := ColorToString(FEditor.Colors.ScrollHint);
  jColors.S['SelectiondBackground'] := ColorToString(FEditor.Colors.SelectiondBackground);
  jColors.S['SelectionForeground'] := ColorToString(FEditor.Colors.SelectionForeground);
  jColors.S['SearchSelectiondBackground'] := ColorToString(FEditor.Colors.SearchSelectiondBackground);
  jColors.S['SearchSelectionForeground'] := ColorToString(FEditor.Colors.SearchSelectionForeground);
  jColors.S['CompletionProposalBackground'] := ColorToString(FEditor.Colors.CompletionProposalBackground);
  jColors.S['CompletionProposalBackgroundBorder'] := ColorToString(FEditor.Colors.CompletionProposalBackgroundBorder);
  jColors.S['CompletionProposalSelection'] := ColorToString(FEditor.Colors.CompletionProposalSelection);
  jColors.S['CompletionProposalSelectionText'] := ColorToString(FEditor.Colors.CompletionProposalSelectionText);
  jColors.S['CompletionProposalTitle'] := ColorToString(FEditor.Colors.CompletionProposalTitle);

  jFonts := jEditor.O['Fonts'];
  jFonts.S['Text'] := FEditor.FFonts.Text;
  jFonts.S['CompletionProposal'] := FEditor.FFonts.CompletionProposal;
  jFonts.S['Gutter'] := FEditor.FFonts.Gutter;

  jFontSizes := jEditor.O['FontSizes'];
  jFontSizes.I['Text'] := FEditor.FontSizes.Text;
  jFontSizes.I['CompletionProposal'] := FEditor.FontSizes.CompletionProposal;
  jFontSizes.I['Gutter'] := FEditor.FontSizes.Gutter;

  for element in FElements do
  begin
    jElements := json.A['Elements'].AddObject;
    jElements.S['Name'] := element.Name;
    jElements.S['Foreground'] := ColorToString(element.Foreground);
    jElements.S['Background'] := ColorToString(element.Background);
    jElements.S['Style'] := FontToString(element.Style);
  end;

  fileContent := TStringList.Create;
  fileContent.Text := json.ToJSON(false);
  fileContent.SaveToFile(fileName);
end;

procedure TSynColors.LoadFile(fileName: string);
var
  json: TJSONObject;
  element: TSynColorsElement;
  I: Integer;
begin
  if not FileExists(fileName) then exit;

  json := TJSONObject.ParseFromFile(fileName) as TJsonObject;

  FName := json.S['Name'];

  FEditor := TSynColorsEditor.Create;
  FEditor.Colors := TSynColorsEditorColors.Create;
  FEditor.Colors.Background := StringToColorDef(json['Editor']['Colors'].S['Background'], clBlack);
  FEditor.Colors.ActiveLineBackground := StringToColorDef(json['Editor']['Colors'].S['ActiveLineBackground'], $313131);
  FEditor.Colors.Gutter := StringToColorDef(json['Editor']['Colors'].S['Gutter'], $313131);
  FEditor.Colors.GutterLineNumber := StringToColorDef(json['Editor']['Colors'].S['GutterLineNumber'], clSilver);
  FEditor.Colors.GutterBorder := StringToColorDef(json['Editor']['Colors'].S['GutterBorder'], clSilver);
  FEditor.Colors.GutterGradientStart := StringToColorDef(json['Editor']['Colors'].S['GutterGradientStart'], clBlack);
  FEditor.Colors.GutterGradientEnd := StringToColorDef(json['Editor']['Colors'].S['GutterGradientEnd'], ClBlack);
  FEditor.Colors.RightEdge := StringToColorDef(json['Editor']['Colors'].S['RightEdge'], $313131);
  FEditor.Colors.ScrollHint := StringToColorDef(json['Editor']['Colors'].S['ScrollHint'], clBlack);
  FEditor.Colors.SelectiondBackground := StringToColorDef(json['Editor']['Colors'].S['SelectiondBackground'], clBlue);
  FEditor.Colors.SelectionForeground := StringToColorDef(json['Editor']['Colors'].S['SelectionForeground'], clWhite);
  FEditor.Colors.SearchSelectiondBackground := StringToColorDef(json['Editor']['Colors'].S['SearchSelectiondBackground'], clYellow);
  FEditor.Colors.SearchSelectionForeground := StringToColorDef(json['Editor']['Colors'].S['SearchSelectionForeground'], clBlack);
  FEditor.Colors.CompletionProposalBackground := StringToColorDef(json['Editor']['Colors'].S['CompletionProposalBackground'], clWhite);
  FEditor.Colors.CompletionProposalBackgroundBorder := StringToColorDef(json['Editor']['Colors'].S['CompletionProposalBackgroundBorder'], clBlack);
  FEditor.Colors.CompletionProposalSelection := StringToColorDef(json['Editor']['Colors'].S['CompletionProposalSelection'], clBlue);
  FEditor.Colors.CompletionProposalSelectionText := StringToColorDef(json['Editor']['Colors'].S['CompletionProposalSelectionText'], clWhite);
  FEditor.Colors.CompletionProposalTitle := StringToColorDef(json['Editor']['Colors'].S['CompletionProposalTitle'], clSilver);

  FEditor.Fonts := TSynColorsEditorFonts.Create;
  FEditor.Fonts.Text := json['Editor']['Fonts'].S['Text'];
  FEditor.Fonts.CompletionProposal := json['Editor']['Fonts'].S['CompletionProposal'];
  FEditor.Fonts.Gutter := json['Editor']['Fonts'].S['Gutter'];

  FEditor.FontSizes := TSynColorsEditorFontSizes.Create;
  FEditor.FontSizes.Text := json['Editor']['FontSizes'].I['Text'];
  FEditor.FontSizes.CompletionProposal := json['Editor']['FontSizes'].I['CompletionProposal'];
  FEditor.FontSizes.Gutter := json['Editor']['FontSizes'].I['Gutter'];

  FElements := TList<TSynColorsElement>.Create;
  for I := 0 to json['Elements'].Count-1 do
  begin
    element := TSynColorsElement.Create;
    element.Name := json['Elements'].Items[I].S['Name'];
    element.Foreground := StringToColor(json['Elements'].Items[I].S['Foreground']);
    element.Background := StringToColor(json['Elements'].Items[I].S['Background']);
    element.Style := StrToFontStyle(json['Elements'].Items[I].S['Style']);
    FElements.Add(element);
  end;
end;

end.
