{
 *****************************************************************************
 *                                                                           *
 *  See the file COPYING.modifiedLGPL, included in this distribution,        *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************

  Author: Mattias Gaertner
  
  Abstract:
    IDE interface to the IDE projects.
}
unit ProjectIntf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLProc, FileUtil;
  
const
  FileDescNamePascalUnit = 'unit';
  FileDescNameLCLForm = 'form';
  FileDescNameDatamodule = 'datamodule';
  FileDescNameText = 'text';
  
  ProjDescNameApplication = 'application';
  ProjDescNameProgram = 'program';
  ProjDescNameCustomProgram = 'custom program';

type
  { TLazCompilerOptions }
  
  TCompilationGenerateCode = (
    cgcNormalCode,
    cgcFasterCode,
    cgcSmallerCode
    );

  TLazCompilerOptions = class(TPersistent)
  private
    FOnModified: TNotifyEvent;
    fOwner: TObject;
  protected
    FModified: boolean;

    // Paths:
    fIncludeFiles: String;
    fLibraries: String;
    fOtherUnitFiles: String;
    FObjectPath: string;
    FSrcPath: string;
    fUnitOutputDir: string;
    fDebugPath: string;
    fLCLWidgetType: string;

    // Parsing:
    // assembler style
    fAssemblerStyle: Integer;
    // symantec checking
    fD2Ext: Boolean;
    fCStyleOp: Boolean;
    fIncludeAssertionCode: Boolean;
    fDelphiCompat: Boolean;
    fAllowLabel: Boolean;
    fUseAnsiStr: Boolean;
    fCPPInline: Boolean;
    fCMacros: Boolean;
    fTPCompat: Boolean;
    fGPCCompat: Boolean;
    fInitConst: Boolean;
    fStaticKwd: Boolean;

    // Code generation:
    fUnitStyle: Integer;
    fIOChecks: Boolean;
    fRangeChecks: Boolean;
    fOverflowChecks: Boolean;
    fStackChecks: Boolean;
    FEmulatedFloatOpcodes: boolean;
    fHeapSize: LongInt;
    fVerifyObjMethodCall: boolean;
    fGenerate: TCompilationGenerateCode;
    fTargetProc: Integer;
    fTargetCPU: string;
    fVarsInReg: Boolean;
    fUncertainOpt: Boolean;
    fOptLevel: Integer;
    fTargetOS: String;

    // Linking:
    fGenDebugInfo: Boolean;
    fGenDebugDBX: Boolean;
    fUseLineInfoUnit: Boolean;
    fUseHeaptrc: Boolean;
    fUseValgrind: Boolean;
    fGenGProfCode: Boolean;
    fStripSymbols: Boolean;
    fLinkStyle: Integer;
    fPassLinkerOpt: Boolean;
    fLinkerOptions: String;
    FWin32GraphicApp: boolean;

    // Messages:
    fShowErrors: Boolean;
    fShowWarn: Boolean;
    fShowNotes: Boolean;
    fShowHints: Boolean;
    fShowGenInfo: Boolean;
    fShowLineNum: Boolean;
    fShowAll: Boolean;
    fShowAllProcsOnError: Boolean;
    fShowDebugInfo: Boolean;
    fShowUsedFiles: Boolean;
    fShowTriedFiles: Boolean;
    fShowDefMacros: Boolean;
    fShowCompProc: Boolean;
    fShowCond: Boolean;
    fShowNothing: Boolean;
    fShowHintsForUnusedUnitsInMainSrc: Boolean;
    fWriteFPCLogo: Boolean;
    fStopAfterErrCount: integer;

    // Other:
    fDontUseConfigFile: Boolean;
    fAdditionalConfigFile: Boolean;
    fConfigFilePath: String;
    fCustomOptions: string;
  protected
    procedure SetBaseDirectory(const AValue: string); virtual; abstract;
    procedure SetCompilerPath(const AValue: String); virtual; abstract;
    procedure SetCustomOptions(const AValue: string); virtual; abstract;
    procedure SetIncludeFiles(const AValue: String); virtual; abstract;
    procedure SetLibraries(const AValue: String); virtual; abstract;
    procedure SetLinkerOptions(const AValue: String); virtual; abstract;
    procedure SetOtherUnitFiles(const AValue: String); virtual; abstract;
    procedure SetUnitOutputDir(const AValue: string); virtual; abstract;
    procedure SetObjectPath(const AValue: string); virtual; abstract;
    procedure SetSrcPath(const AValue: string); virtual; abstract;
    procedure SetDebugPath(const AValue: string); virtual; abstract;
    procedure SetTargetCPU(const AValue: string); virtual; abstract;
    procedure SetTargetProc(const AValue: Integer); virtual; abstract;
    procedure SetTargetOS(const AValue: string); virtual; abstract;
    procedure SetModified(const AValue: boolean); virtual; abstract;
  public
    constructor Create(const TheOwner: TObject); virtual;
  public
    property Owner: TObject read fOwner write fOwner;
    property Modified: boolean read FModified write SetModified;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;

    // search paths:
    property IncludeFiles: String read fIncludeFiles write SetIncludeFiles;
    property Libraries: String read fLibraries write SetLibraries;
    property OtherUnitFiles: String read fOtherUnitFiles write SetOtherUnitFiles;
    property ObjectPath: string read FObjectPath write SetObjectPath;
    property SrcPath: string read FSrcPath write SetSrcPath;
    property UnitOutputDirectory: string read fUnitOutputDir write SetUnitOutputDir;
    property DebugPath: string read FDebugPath write SetDebugPath;
    property LCLWidgetType: string read fLCLWidgetType write fLCLWidgetType;

    // parsing:
    property AssemblerStyle: Integer read fAssemblerStyle write fAssemblerStyle;
    property D2Extensions: Boolean read fD2Ext write fD2Ext;
    property CStyleOperators: Boolean read fCStyleOp write fCStyleOp;
    property IncludeAssertionCode: Boolean
                         read fIncludeAssertionCode write fIncludeAssertionCode;
    property DelphiCompat: Boolean read fDelphiCompat write fDelphiCompat;
    property AllowLabel: Boolean read fAllowLabel write fAllowLabel;
    property UseAnsiStrings: Boolean read fUseAnsiStr write fUseAnsiStr;
    property CPPInline: Boolean read fCPPInline write fCPPInline;
    property CStyleMacros: Boolean read fCMacros write fCMacros;
    property TPCompatible: Boolean read fTPCompat write fTPCompat;
    property GPCCompat: Boolean read fGPCCompat write fGPCCompat;
    property InitConstructor: Boolean read fInitConst write fInitConst;
    property StaticKeyword: Boolean read fStaticKwd write fStaticKwd;

    // code generation:
    property UnitStyle: Integer read fUnitStyle write fUnitStyle;
    property IOChecks: Boolean read fIOChecks write fIOChecks;
    property RangeChecks: Boolean read fRangeChecks write fRangeChecks;
    property OverflowChecks: Boolean read fOverflowChecks write fOverflowChecks;
    property StackChecks: Boolean read fStackChecks write fStackChecks;
    property EmulatedFloatOpcodes: boolean read FEmulatedFloatOpcodes
                                           write FEmulatedFloatOpcodes;
    property HeapSize: Integer read fHeapSize write fHeapSize;
    property VerifyObjMethodCall: boolean read FEmulatedFloatOpcodes
                                          write FEmulatedFloatOpcodes;
    property Generate: TCompilationGenerateCode read fGenerate write fGenerate;
    property TargetCPU: string read fTargetCPU write SetTargetCPU; // general type
    property TargetProcessor: Integer read fTargetProc write SetTargetProc; // specific
    property TargetOS: string read fTargetOS write SetTargetOS;
    property VariablesInRegisters: Boolean read fVarsInReg write fVarsInReg;
    property UncertainOptimizations: Boolean read fUncertainOpt write fUncertainOpt;
    property OptimizationLevel: Integer read fOptLevel write fOptLevel;

    // linking:
    property GenerateDebugInfo: Boolean read fGenDebugInfo write fGenDebugInfo;
    property GenerateDebugDBX: Boolean read fGenDebugDBX write fGenDebugDBX;
    property UseLineInfoUnit: Boolean read fUseLineInfoUnit write fUseLineInfoUnit;
    property UseHeaptrc: Boolean read fUseHeaptrc write fUseHeaptrc;
    property UseValgrind: Boolean read fUseValgrind write fUseValgrind;
    property GenGProfCode: Boolean read fGenGProfCode write fGenGProfCode;
    property StripSymbols: Boolean read fStripSymbols write fStripSymbols;
    property LinkStyle: Integer read fLinkStyle write fLinkStyle;
    property PassLinkerOptions: Boolean read fPassLinkerOpt write fPassLinkerOpt;
    property LinkerOptions: String read fLinkerOptions write SetLinkerOptions;
    property Win32GraphicApp: boolean read FWin32GraphicApp write FWin32GraphicApp;

    // messages:
    property ShowErrors: Boolean read fShowErrors write fShowErrors;
    property ShowWarn: Boolean read fShowWarn write fShowWarn;
    property ShowNotes: Boolean read fShowNotes write fShowNotes;
    property ShowHints: Boolean read fShowHints write fShowHints;
    property ShowGenInfo: Boolean read fShowGenInfo write fShowGenInfo;
    property ShowLineNum: Boolean read fShowLineNum write fShowLineNum;
    property ShowAll: Boolean read fShowAll write fShowAll;
    property ShowAllProcsOnError: Boolean
      read fShowAllProcsOnError write fShowAllProcsOnError;
    property ShowDebugInfo: Boolean read fShowDebugInfo write fShowDebugInfo;
    property ShowUsedFiles: Boolean read fShowUsedFiles write fShowUsedFiles;
    property ShowTriedFiles: Boolean read fShowTriedFiles write fShowTriedFiles;
    property ShowDefMacros: Boolean read fShowDefMacros write fShowDefMacros;
    property ShowCompProc: Boolean read fShowCompProc write fShowCompProc;
    property ShowCond: Boolean read fShowCond write fShowCond;
    property ShowNothing: Boolean read fShowNothing write fShowNothing;
    property ShowHintsForUnusedUnitsInMainSrc: Boolean
      read fShowHintsForUnusedUnitsInMainSrc write fShowHintsForUnusedUnitsInMainSrc;
    property WriteFPCLogo: Boolean read fWriteFPCLogo write fWriteFPCLogo;
    property StopAfterErrCount: integer
      read fStopAfterErrCount write fStopAfterErrCount;

    // other
    property DontUseConfigFile: Boolean read fDontUseConfigFile
                                        write fDontUseConfigFile;
    property AdditionalConfigFile: Boolean read fAdditionalConfigFile
                                           write fAdditionalConfigFile;
    property ConfigFilePath: String read fConfigFilePath write fConfigFilePath;
    property CustomOptions: string read fCustomOptions write SetCustomOptions;
  end;

  { TLazProjectFile }

  TLazProjectFile = class(TPersistent)
  private
    FIsPartOfProject: boolean;
  protected
    function GetFilename: string; virtual; abstract;
    procedure SetIsPartOfProject(const AValue: boolean); virtual;
  public
    procedure SetSourceText(const SourceText: string); virtual; abstract;
    function GetSourceText: string; virtual; abstract;
  public
    property IsPartOfProject: boolean read FIsPartOfProject
                                      write SetIsPartOfProject;
    property Filename: string read GetFilename;
  end;

  { TProjectFileDescriptor }

  TProjectFileDescriptor = class(TPersistent)
  private
    FAddToProject: boolean;
    FDefaultFileExt: string;
    FDefaultFilename: string;
    FDefaultResFileExt: string;
    FDefaultResourceName: string;
    FDefaultSourceName: string;
    FIsComponent: boolean;
    FIsPascalUnit: boolean;
    FName: string;
    FReferenceCount: integer;
    FResourceClass: TPersistentClass;
    FRequiredPackages: string;
    FUseCreateFormStatements: boolean;
    FVisibleInNewDialog: boolean;
  protected
    procedure SetDefaultFilename(const AValue: string); virtual;
    procedure SetDefaultFileExt(const AValue: string); virtual;
    procedure SetDefaultSourceName(const AValue: string); virtual;
    procedure SetDefaultResFileExt(const AValue: string); virtual;
    procedure SetName(const AValue: string); virtual;
    procedure SetRequiredPackages(const AValue: string); virtual;
    procedure SetResourceClass(const AValue: TPersistentClass); virtual;
  public
    constructor Create; virtual;
    function GetLocalizedName: string; virtual;
    function GetLocalizedDescription: string; virtual;
    procedure Release;
    procedure Reference;
    function CreateSource(const Filename, SourceName,
                          ResourceName: string): string; virtual;
    procedure UpdateDefaultPascalFileExtension(const DefPasExt: string); virtual;
  public
    property Name: string read FName write SetName;
    property DefaultFilename: string read FDefaultFilename write SetDefaultFilename;
    property DefaultFileExt: string read FDefaultFileExt write SetDefaultFileExt;
    property DefaultSourceName: string read FDefaultSourceName write SetDefaultSourceName;
    property DefaultResFileExt: string read FDefaultResFileExt write SetDefaultResFileExt;
    property DefaultResourceName: string read FDefaultResourceName write FDefaultResourceName;
    property RequiredPackages: string read FRequiredPackages write SetRequiredPackages; // package names separated by semicolon
    property ResourceClass: TPersistentClass read FResourceClass write SetResourceClass;
    property IsComponent: boolean read FIsComponent;
    property UseCreateFormStatements: boolean read FUseCreateFormStatements write FUseCreateFormStatements;
    property VisibleInNewDialog: boolean read FVisibleInNewDialog write FVisibleInNewDialog;
    property IsPascalUnit: boolean read FIsPascalUnit write FIsPascalUnit;
    property AddToProject: boolean read FAddToProject write FAddToProject;
  end;
  
  
  { TFileDescPascalUnit }

  TFileDescPascalUnit = class(TProjectFileDescriptor)
  public
    constructor Create; override;
    function CreateSource(const Filename, SourceName,
                          ResourceName: string): string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function GetInterfaceUsesSection: string; virtual;
    function GetInterfaceSource(const Filename, SourceName,
                                ResourceName: string): string; virtual;
    function GetImplementationSource(const Filename, SourceName,
                                     ResourceName: string): string; virtual;
  end;


  { TFileDescPascalUnitWithResource }

  TFileDescPascalUnitWithResource = class(TFileDescPascalUnit)
  public
    function GetInterfaceSource(const Filename, SourceName,
                                ResourceName: string): string; override;
    function GetImplementationSource(const Filename, SourceName,
                                     ResourceName: string): string; override;
  end;


  { TProjectFileDescriptors }
  
  TProjectFileDescriptors = class(TPersistent)
  protected
    function GetItems(Index: integer): TProjectFileDescriptor; virtual; abstract;
  public
    function Count: integer; virtual; abstract;
    function GetUniqueName(const Name: string): string; virtual; abstract;
    function IndexOf(const Name: string): integer; virtual; abstract;
    function FindByName(const Name: string): TProjectFileDescriptor; virtual; abstract;
    procedure RegisterFileDescriptor(FileDescriptor: TProjectFileDescriptor); virtual; abstract;
    procedure UnregisterFileDescriptor(FileDescriptor: TProjectFileDescriptor); virtual; abstract;
  public
    property Items[Index: integer]: TProjectFileDescriptor read GetItems; default;
  end;
  
var
  ProjectFileDescriptors: TProjectFileDescriptors; // will be set by the IDE

function FileDescriptorUnit: TProjectFileDescriptor;
function FileDescriptorForm: TProjectFileDescriptor;
function FileDescriptorDatamodule: TProjectFileDescriptor;
function FileDescriptorText: TProjectFileDescriptor;


type
  TLazProject = class;

  { TProjectDescriptor }
  
  TProjectFlag = (
    pfSaveClosedUnits,     // save info about closed files (not part of project)
    pfSaveOnlyProjectUnits, // save no info about foreign files
    pfMainUnitIsPascalSource,// main unit is pascal, even it does not end in .pas/.pp
    pfMainUnitHasUsesSectionForAllUnits,// add/remove pascal units to main uses section
    pfMainUnitHasCreateFormStatements,// add/remove Application.CreateForm statements
    pfMainUnitHasTitleStatement,// add/remove Application.Title:= statements
    pfRunnable // project can be run
    );
  TProjectFlags = set of TProjectFlag;

  TProjectDescriptor = class(TPersistent)
  private
    FDefaultExt: string;
    FFlags: TProjectFlags;
    FName: string;
    FReferenceCount: integer;
    FVisibleInNewDialog: boolean;
  protected
    procedure SetName(const AValue: string); virtual;
    procedure SetFlags(const AValue: TProjectFlags); virtual;
  public
    constructor Create; virtual;
    function GetLocalizedName: string; virtual;
    function GetLocalizedDescription: string; virtual;
    procedure Release;
    procedure Reference;
    procedure InitProject(AProject: TLazProject); virtual;
    procedure CreateStartFiles(AProject: TLazProject); virtual;
  public
    property Name: string read FName write SetName;
    property VisibleInNewDialog: boolean read FVisibleInNewDialog write FVisibleInNewDialog;
    property Flags: TProjectFlags read FFlags write SetFlags;
    property DefaultExt: string read FDefaultExt write FDefaultExt;
  end;


  { TLazProject }

  TLazProject = class(TPersistent)
  private
    FFlags: TProjectFlags;
    FLazCompilerOptions: TLazCompilerOptions;
    fTitle: String;
  protected
    procedure SetLazCompilerOptions(const AValue: TLazCompilerOptions);
    function GetMainFile: TLazProjectFile; virtual; abstract;
    function GetMainFileID: Integer; virtual; abstract;
    procedure SetMainFileID(const AValue: Integer); virtual; abstract;
    function GetFiles(Index: integer): TLazProjectFile; virtual; abstract;
    procedure SetFiles(Index: integer; const AValue: TLazProjectFile); virtual; abstract;
    procedure SetTitle(const AValue: String); virtual;
    procedure SetFlags(const AValue: TProjectFlags); virtual;
  public
    constructor Create(ProjectDescription: TProjectDescriptor); virtual;
    function CreateProjectFile(const Filename: string
                               ): TLazProjectFile; virtual; abstract;
    procedure AddFile(ProjectFile: TLazProjectFile;
                      AddToProjectUsesClause: boolean); virtual; abstract;
    procedure RemoveUnit(Index: integer); virtual; abstract;
    function GetFileCount: integer; virtual; abstract;
    procedure AddSrcPath(const SrcPathAddition: string); virtual; abstract;
    procedure AddPackageDependency(const PackageName: string); virtual; abstract;
  public
    property MainFileID: Integer read GetMainFileID write SetMainFileID;
    property Files[Index: integer]: TLazProjectFile read GetFiles write SetFiles;
    property FileCount: integer read GetFileCount;
    property MainFile: TLazProjectFile read GetMainFile;
    property Title: String read fTitle write SetTitle;
    property Flags: TProjectFlags read FFlags write SetFlags;
    property LazCompilerOptions: TLazCompilerOptions read FLazCompilerOptions
                                                     write SetLazCompilerOptions;
  end;


  { TProjectDescriptors }

  TProjectDescriptors = class(TPersistent)
  protected
    function GetItems(Index: integer): TProjectDescriptor; virtual; abstract;
  public
    function Count: integer; virtual; abstract;
    function GetUniqueName(const Name: string): string; virtual; abstract;
    function IndexOf(const Name: string): integer; virtual; abstract;
    function FindByName(const Name: string): TProjectDescriptor; virtual; abstract;
    procedure RegisterDescriptor(Descriptor: TProjectDescriptor); virtual; abstract;
    procedure UnregisterDescriptor(Descriptor: TProjectDescriptor); virtual; abstract;
  public
    property Items[Index: integer]: TProjectDescriptor read GetItems; default;
  end;

var
  ProjectDescriptors: TProjectDescriptors; // will be set by the IDE

function ProjectDescriptorApplication: TProjectDescriptor;
function ProjectDescriptorProgram: TProjectDescriptor;
function ProjectDescriptorCustomProgram: TProjectDescriptor;

const
  DefaultProjectFlags = [pfSaveClosedUnits,
                         pfMainUnitIsPascalSource,
                         pfMainUnitHasUsesSectionForAllUnits,
                         pfMainUnitHasCreateFormStatements,
                         pfMainUnitHasTitleStatement,
                         pfRunnable];
  ProjectFlagNames : array[TProjectFlag] of string = (
      'SaveClosedFiles',
      'SaveOnlyProjectUnits',
      'MainUnitIsPascalSource',
      'MainUnitHasUsesSectionForAllUnits',
      'MainUnitHasCreateFormStatements',
      'MainUnitHasTitleStatement',
      'Runnable'
    );

function ProjectFlagsToStr(Flags: TProjectFlags): string;


implementation

function FileDescriptorUnit: TProjectFileDescriptor;
begin
  Result:=ProjectFileDescriptors.FindByName(FileDescNamePascalUnit);
end;

function FileDescriptorForm: TProjectFileDescriptor;
begin
  Result:=ProjectFileDescriptors.FindByName(FileDescNameLCLForm);
end;

function FileDescriptorDatamodule: TProjectFileDescriptor;
begin
  Result:=ProjectFileDescriptors.FindByName(FileDescNameDatamodule);
end;

function FileDescriptorText: TProjectFileDescriptor;
begin
  Result:=ProjectFileDescriptors.FindByName(FileDescNameText);
end;

function ProjectDescriptorApplication: TProjectDescriptor;
begin
  Result:=ProjectDescriptors.FindByName(ProjDescNameApplication);
end;

function ProjectDescriptorProgram: TProjectDescriptor;
begin
  Result:=ProjectDescriptors.FindByName(ProjDescNameProgram);
end;

function ProjectDescriptorCustomProgram: TProjectDescriptor;
begin
  Result:=ProjectDescriptors.FindByName(ProjDescNameCustomProgram);
end;

function ProjectFlagsToStr(Flags: TProjectFlags): string;
var f: TProjectFlag;
begin
  Result:='';
  for f:=Low(TProjectFlag) to High(TProjectFlag) do begin
    if f in Flags then begin
      if Result='' then Result:=Result+',';
      Result:=Result+ProjectFlagNames[f];
    end;
  end;
end;

{ TProjectFileDescriptor }

procedure TProjectFileDescriptor.SetResourceClass(
  const AValue: TPersistentClass);
begin
  if FResourceClass=AValue then exit;
  FResourceClass:=AValue;
  FIsComponent:=(FResourceClass<>nil)
                and (FResourceClass.InheritsFrom(TComponent));
  if FResourceClass=nil then
    FDefaultResourceName:=''
  else begin
    FDefaultResourceName:=
      copy(FResourceClass.ClassName,2,length(FResourceClass.ClassName)-1);
  end;
end;

procedure TProjectFileDescriptor.SetDefaultFileExt(const AValue: string);
begin
  if FDefaultFileExt=AValue then exit;
  FDefaultFileExt:=AValue;
end;

procedure TProjectFileDescriptor.SetDefaultResFileExt(const AValue: string);
begin
  if FDefaultResFileExt=AValue then exit;
  FDefaultResFileExt:=AValue;
end;

procedure TProjectFileDescriptor.SetDefaultSourceName(const AValue: string);
begin
  if FDefaultSourceName=AValue then exit;
  FDefaultSourceName:=AValue;
end;

procedure TProjectFileDescriptor.SetDefaultFilename(const AValue: string);
begin
  if FDefaultFilename=AValue then exit;
  FDefaultFilename:=AValue;
  DefaultFileExt:=ExtractFileExt(FDefaultFilename);
  FIsPascalUnit:=(CompareFileExt(DefaultFileExt,'.pp',false)=0)
              or (CompareFileExt(DefaultFileExt,'.pas',false)=0);
end;

procedure TProjectFileDescriptor.SetName(const AValue: string);
begin
  if FName=AValue then exit;
  FName:=AValue;
end;

procedure TProjectFileDescriptor.SetRequiredPackages(const AValue: string);
begin
  if FRequiredPackages=AValue then exit;
  FRequiredPackages:=AValue;
end;

constructor TProjectFileDescriptor.Create;
begin
  FReferenceCount:=1;
  DefaultResFileExt:='.lrs';
  AddToProject:=true;
end;

function TProjectFileDescriptor.GetLocalizedName: string;
begin
  Result:=Name;
end;

function TProjectFileDescriptor.GetLocalizedDescription: string;
begin
  Result:=GetLocalizedName;
end;

procedure TProjectFileDescriptor.Release;
begin
  //debugln('TProjectFileDescriptor.Release A ',Name,' ',dbgs(FReferenceCount));
  if FReferenceCount=0 then
    raise Exception.Create('');
  dec(FReferenceCount);
  if FReferenceCount=0 then Free;
end;

procedure TProjectFileDescriptor.Reference;
begin
  inc(FReferenceCount);
end;

function TProjectFileDescriptor.CreateSource(const Filename, SourceName,
  ResourceName: string): string;
begin
  Result:='';
end;

procedure TProjectFileDescriptor.UpdateDefaultPascalFileExtension(
  const DefPasExt: string);
begin
  if DefPasExt='' then exit;
  if FilenameIsPascalUnit(DefaultFileExt) then
    DefaultFileExt:=DefPasExt;
  if FilenameIsPascalUnit(DefaultFilename) then
    DefaultFilename:=ChangeFileExt(DefaultFilename,DefPasExt);
end;

{ TFileDescPascalUnit }

constructor TFileDescPascalUnit.Create;
begin
  inherited Create;
  Name:=FileDescNamePascalUnit;
  DefaultFilename:='unit.pas';
  DefaultSourceName:='Unit1';
end;

function TFileDescPascalUnit.CreateSource(const Filename, SourceName,
  ResourceName: string): string;
var
  LE: string;
begin
  LE:=LineEnding;
  Result:=
     'unit '+SourceName+';'+LE
    +LE
    +'{$mode objfpc}{$H+}'+LE
    +LE
    +'interface'+LE
    +LE
    +'uses'+LE
    +'  '+GetInterfaceUsesSection+';'+LE
    +LE
    +GetInterfaceSource(Filename,SourceName,ResourceName)
    +'implementation'+LE
    +LE
    +GetImplementationSource(Filename,SourceName,ResourceName)
    +'end.'+LE
    +LE;
end;

function TFileDescPascalUnit.GetLocalizedName: string;
begin
  Result:='Unit';
end;

function TFileDescPascalUnit.GetLocalizedDescription: string;
begin
  Result:='Create a new pascal unit.';
end;

function TFileDescPascalUnit.GetInterfaceUsesSection: string;
begin
  Result:='Classes, SysUtils';
end;

function TFileDescPascalUnit.GetInterfaceSource(const Filename, SourceName,
  ResourceName: string): string;
begin
  Result:='';
end;

function TFileDescPascalUnit.GetImplementationSource(const Filename,
  SourceName, ResourceName: string): string;
begin
  Result:='';
end;

{ TFileDescPascalUnitWithResource }

function TFileDescPascalUnitWithResource.GetInterfaceSource(const Filename,
  SourceName, ResourceName: string): string;
var
  LE: string;
begin
  LE:=LineEnding;
  Result:=
     'type'+LE
    +'  T'+ResourceName+' = class('+ResourceClass.ClassName+')'+LE
    +'  private'+LE
    +'    { private declarations }'+LE
    +'  public'+LE
    +'    { public declarations }'+LE
    +'  end;'+LE
    +LE
    +'var'+LE
    +'  '+ResourceName+': T'+ResourceName+';'+LE
    +LE;
end;

function TFileDescPascalUnitWithResource.GetImplementationSource(
  const Filename, SourceName, ResourceName: string): string;
var
  ResourceFilename: String;
  LE: String;
begin
  ResourceFilename:=TrimFilename(ExtractFilenameOnly(Filename)+DefaultResFileExt);
  LE:=LineEnding;
  Result:='initialization'+LE
    +'  {$I '+ResourceFilename+'}'+LE
    +LE
end;

{ TProjectDescriptor }

procedure TProjectDescriptor.SetFlags(const AValue: TProjectFlags);
begin
  FFlags:=AValue;
end;

procedure TProjectDescriptor.SetName(const AValue: string);
begin
  if FName=AValue then exit;
  FName:=AValue;
end;

constructor TProjectDescriptor.Create;
begin
  FReferenceCount:=1;
  FFlags:=DefaultProjectFlags;
  fVisibleInNewDialog:=true;
  FDefaultExt:='.pas';
end;

function TProjectDescriptor.GetLocalizedName: string;
begin
  Result:=Name;
end;

function TProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=GetLocalizedName;
end;

procedure TProjectDescriptor.Release;
begin
  //debugln('TProjectDescriptor.Release A ',Name,' ',dbgs(FReferenceCount));
  if FReferenceCount=0 then
    raise Exception.Create('');
  dec(FReferenceCount);
  if FReferenceCount=0 then Free;
end;

procedure TProjectDescriptor.Reference;
begin
  inc(FReferenceCount);
end;

procedure TProjectDescriptor.InitProject(AProject: TLazProject);
begin
  AProject.Title:='project1';
  AProject.Flags:=Flags;
end;

procedure TProjectDescriptor.CreateStartFiles(AProject: TLazProject);
begin

end;

{ TLazProject }

procedure TLazProject.SetFlags(const AValue: TProjectFlags);
begin
  if FFlags=AValue then exit;
  FFlags:=AValue;
end;

procedure TLazProject.SetLazCompilerOptions(const AValue: TLazCompilerOptions);
begin
  if FLazCompilerOptions=AValue then exit;
  FLazCompilerOptions:=AValue;
end;

procedure TLazProject.SetTitle(const AValue: String);
begin
  if fTitle=AValue then exit;
  fTitle:=AValue;
end;

constructor TLazProject.Create(ProjectDescription: TProjectDescriptor);
begin
  inherited Create;
end;

{ TLazProjectFile }

procedure TLazProjectFile.SetIsPartOfProject(const AValue: boolean);
begin
  FIsPartOfProject:=AValue;
end;

{ TLazCompilerOptions }

constructor TLazCompilerOptions.Create(const TheOwner: TObject);
begin
  inherited Create;
  FOwner := TheOwner;
end;

initialization
  ProjectFileDescriptors:=nil;

end.

