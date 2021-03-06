program mashc;

{$Apptype console}
{$Mode objfpc}
{$H+}

uses
  SysUtils,
  Classes,
  u_imports,
  u_global,
  u_consts,
  u_variables,
  u_globalvars,
  u_codesect,
  u_preprocessor,
  u_optimizator,
  u_classes,
  u_prep_global,
  u_prep_codeblock,
  u_prep_methods,
  u_prep_expressions,
  u_prep_array,
  u_prep_enums,
  u_prep_vardefs,
  u_prep_c_methods,
  u_prep_c_ifelse,
  u_prep_c_global,
  u_prep_c_try,
  u_prep_c_loops,
  u_prep_c_classes,
  u_writers,
  u_fast_prep,
  u_prep_switch;

{** Main **}

var
  Code: TStringList;
  c, x: cardinal;
  Output: TMemoryStream;
  varmgr: TVarManager;
  Imports: TImportSection;
  CodeSection: TCodeSection;
  Tm, Tm2: cardinal;
  OutFilePath, OutDebugInfoFilePath, s: string;
  dbgig:boolean = false;
  outasmp:boolean = false;
begin
  try
  writeln('Mash lang!');
  writeln('Version: 1.3, Pavel Shiryaev (c) from 2018.');
  writeln('See more at: https://github.com/RoPi0n/mash-lang');
  if ParamCount = 0 then
  begin
    writeln('Use: ', ExtractFileName(ParamStr(0)), ' <input file> [arguments]');
    writeln('Arguments:');
    writeln(' /cns           - make console program (default).');
    writeln(' /gui           - make GUI program.');
    writeln(' /bin           - make program without header.');
    writeln(' /o-            - build without optimisation.');
    writeln(' /o+            - build with optimization (default).');
    writeln(' /olvl <lvl>    - optimization level: light - 1 (default), middle - 2, full - 3.');
    writeln(' /out <file>    - write output in <file> (default - change extension to "*.vmc").');
    writeln(' /rtti-         - disable RTTI support.');
    writeln(' /rtti+         - enable RTTI support (default).');
    writeln(' /ccargcs+      - enable passing the number of arguments to methods (default).');
    writeln(' /ccargcs-      - disable passing the number of arguments to methods.');
    writeln(' /mdbg+         - enable debug mode.');
    writeln(' /mdbg-         - disable debug mode (default).');
    writeln(' /gdbg+         - enable debug info generation (default enabled if enabled debug mode).');
    writeln(' /gdbg-         - disable debug info generation (default).');
    writeln(' /mdbgo <file>  - write debug info in <file> (default - change extension to "*.mdbg").');
    writeln(' /outinf+       - enable output hints.');
    writeln(' /outinf-       - disable output hints (default).');
    writeln(' /oasmp         - out assembly listing of common part of code.');
    halt;
  end;

  FastPrep_Defines := TStringList.Create;
  OutFilePath := ChangeFileExt(ParamStr(1), '.vmc');
  OutDebugInfoFilePath := ChangeFileExt(ParamStr(1), '.mdbg');

  c := 2;
    while c <= ParamCount do
    begin
      s := Trim(LowerCase(ParamStr(c)));

      if s = '/bin' then
       AppMode := amBin;

      if s = '/gui' then
       AppMode := amGUI;

      if s = '/cns' then
       AppMode := amConsole;

      if s = '/o+' then
       EnableOptimization := True;

      if s = '/o-' then
       EnableOptimization := False;

      if s = '/olvl' then
      begin
        OptimizationLvl := StrToInt(ParamStr(c + 1));
        Inc(c);
      end;

      if s = '/rtti+' then
       RTTI_Enable := True;

      if s = '/rtti-' then
       RTTI_Enable := False;

      if s = '/ccargcs+' then
       ARGC_Enable := True;

      if s = '/ccargcs-' then
       ARGC_Enable := False;

      if s = '/out' then
      begin
        OutFilePath := ParamStr(c + 1);
        Inc(c);
      end;

      if s = '/mdbg+' then
       Debug_Enable := true;

      if s = '/mdbg-' then
       Debug_Enable := false;

      if s = '/gdbg+' then
      begin
        dbgig := true;
        Debug_InfoGen := true;
      end;

      if s = '/gdbg-' then
      begin
        dbgig := true;
        Debug_InfoGen := false;
      end;

      if s = '/mdbgo' then
      begin
        OutDebugInfoFilePath := ParamStr(c + 1);
        Inc(c);
      end;

      if s = '/outinf+' then
       Hints_Enable := true;

      if s = '/outinf-' then
       Hints_Enable := false;

      if s = '/oasmp' then
       outasmp := true;

      Inc(c);
    end;

  if RTTI_Enable then
   FastPrep_Defines.Add('rtti');

  if ARGC_Enable then
   FastPrep_Defines.Add('argcounter');

  if Debug_Enable then
   begin
     FastPrep_Defines.Add('debug');
     if not dbgig then
      Debug_InfoGen := true;
   end;

  Tm := GetTickCount;
  writeln('Building started.');
  DecimalSeparator := '.';
  IncludedFiles := TStringList.Create;
  Code := TStringList.Create;
  Code.LoadFromFile(ParamStr(1));

  varmgr := TVarManager.Create;
  Constants := TConstantManager.Create(Code);
  InitPreprocessor(varmgr);

  varmgr := TVarManager.Create;
  Constants := TConstantManager.Create(Code);
  InitPreprocessor(varmgr);

  //pre-processing code
  c := 0;
  while c < Code.Count do
   begin
     Code[c] := PreprocessClassCalls(FastPrep(TrimCodeStr(Code[c])));
     inc(c);
   end;

  PrepLines(Code);

  //pre-processing code
  c := 0;
  while c < Code.Count do
   begin
     PreprocessDefinitions(Code[c], varmgr);
     inc(c);
   end;

  //compile
  Current_CodeFile := ParamStr(1);
  IncludedFiles.Clear;
  c := 0;
  while c < Code.Count do
  begin
    if Trim(Code[c]) <> '' then
      Code[c] := Trim(PreprocessStr(Code[c], varmgr));
    Inc(c);
  end;
  FreePreprocessor(varmgr);

  code.Text := 'word __addrtsz ' + IntToStr(varmgr.DefinedVars.Count) +
    sLineBreak + 'pushc __addrtsz' + sLineBreak + 'gpm' + sLineBreak +
    'msz' + sLineBreak + 'gc' + sLineBreak + InitCode.Text + sLineBreak +
    'pushc __entrypoint' + slinebreak + 'gpm' + slinebreak + 'jc' +
    sLineBreak + 'pushc __haltpoint' + sLineBreak + 'gpm' + sLineBreak +
    'jp' + sLineBreak + code.Text + sLineBreak + PostInitCode.Text + sLineBreak +
    '__haltpoint:' + sLineBreak + 'gc';

  code.SaveToFile('data.tmp');
  code.LoadFromFile('data.tmp');
  DeleteFile('data.tmp');

  if Code.Count > 0 then
  begin
    Output := TMemoryStream.Create;

    if AppMode <> amBin then
    begin
      Output.WriteByte(Ord('S'));
      Output.WriteByte(Ord('V'));
      Output.WriteByte(Ord('M'));
      Output.WriteByte(Ord('E'));
      Output.WriteByte(Ord('X'));
      Output.WriteByte(Ord('E'));
      Output.WriteByte(Ord('_'));
      if AppMode = amGUI then
      begin
        Output.WriteByte(Ord('G'));
        Output.WriteByte(Ord('U'));
        Output.WriteByte(Ord('I'));
        writeln('Header: Executable GUI program.');
      end
      else
      begin
        Output.WriteByte(Ord('C'));
        Output.WriteByte(Ord('N'));
        Output.WriteByte(Ord('S'));
        writeln('Header: Executable console program.');
      end;
    end
    else
      writeln('Header: Executable object file.');

    if EnableOptimization then
      OptimizeCode(Code);

    if outasmp then
      Code.SaveToFile(ChangeFileExt(OutFilePath, '.partof.asm'));

    Imports := TImportSection.Create(Code);
    Imports.ParseSection;
    Imports.GenerateCode(Output);

    Constants.AppendImports(Imports);
    Constants.ParseSection;

    for c := code.Count - 1 downto 0 do
      if trim(code[c]) = '' then
        code.Delete(c);

    CodeSection := TCodeSection.Create(Code, Constants);
    CodeSection.ParseSection;
    Constants.GenerateCode(Output);
    //writeln('Constants defined: ', Constants.Constants.Count, '.');

    CodeSection.GenerateCode(Output);

    writeln('Success.');
    Tm2 := GetTickCount;
    writeln('Build time: ', trunc((Tm2 - Tm) / 1000), ',', Copy(
      FloatToStr(frac((Tm2 - Tm) / 1000)), 3, 6), ' sec.');
    writeln('Executable file size: ', Output.Size, ' bytes.');

    FreeAndNil(CodeSection);

    Output.SaveToFile(OutFilePath);
    FreeAndNil(Output);

    if Debug_InfoGen then
     begin
       Output := TMemoryStream.Create;
       Output.Clear;
       c := Varmgr.DefinedVars.Count;
       Output.Write(c, sizeof(c));
       c := 0;
       while c < Varmgr.DefinedVars.Count do
        begin
          x := Length(Varmgr.DefinedVars[c]);
          Output.Write(x, sizeof(x));
          s := Varmgr.DefinedVars[c];
          Output.Write(s[1], x);
          inc(c);
        end;
       Output.SaveToFile(OutDebugInfoFilePath);
       FreeAndNil(Output);
     end;

    FreeAndNil(varmgr);
    FreeAndNil(Imports);
    FreeAndNil(Constants);
  end;
  FreeAndNil(Code);
  FreeAndNil(IncludedFiles);

  except
    on E:EOutOfMemory do
     writeln('Internal compiler exception: out of memory.');
    on E:EInOutError do
     writeln('I/O exception.');
    on E:Exception do
     writeln('Internal compiler exception: "' + E.Message + '".');
  end;
end.
