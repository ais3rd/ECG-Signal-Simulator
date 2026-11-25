unit KPP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls,
  VCLTee.TeEngine, VCLTee.Series, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    OpenDialog1: TOpenDialog;
    ComboBox1: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Series1: TLineSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    CSVData: TStringList;
    CurrentPage: Integer;
    TotalSamples: Integer;
    procedure UpdateChartDisplay;
    function ExtractNumber(const S: string): Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.StrUtils, System.Math;

const
  SamplingRate = 360.0;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CSVData := TStringList.Create;
  CurrentPage := 0;
  TotalSamples := 0;

  ComboBox1.Items.Add('1 second');
  ComboBox1.Items.Add('5 seconds');
  ComboBox1.Items.Add('10 seconds');
  ComboBox1.Items.Add('15 seconds');
  ComboBox1.Items.Add('20 seconds');
  ComboBox1.Items.Add('30 seconds');
  ComboBox1.Items.Add('35 seconds');
  ComboBox1.Items.Add('40 seconds');
  ComboBox1.Items.Add('45 seconds');
  ComboBox1.Items.Add('50 seconds');
  ComboBox1.Items.Add('55 seconds');
  ComboBox1.Items.Add('60 seconds');
  ComboBox1.ItemIndex := 2;

  Chart1.Title.Text.Clear;
  Chart1.Title.Text.Add('Simulator Sinyal ECG');
  Chart1.LeftAxis.Title.Caption := 'mV';
  Chart1.BottomAxis.Title.Caption := 'Time (s)';
  Chart1.Legend.Visible := True;

  Button2.Enabled := False;
  Button3.Enabled := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  CSVData.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  LastLine: string;
  LineValues: TStringList;
  TotalDuration: Double;
  MessageStr: string;
begin
  OpenDialog1.Filter := 'CSV Files (*.csv)|*.csv';
  if OpenDialog1.Execute then
  begin
    CSVData.LoadFromFile(OpenDialog1.FileName);

    if CSVData.Count > 1 then
    begin
      LineValues := TStringList.Create;
      try
        LastLine := CSVData[CSVData.Count - 1];
        LineValues.Delimiter := ',';
        LineValues.StrictDelimiter := True;
        LineValues.DelimitedText := StringReplace(LastLine, '"', '', [rfReplaceAll]);
        if LineValues.Count > 0 then
          TryStrToInt(LineValues[0], TotalSamples)
        else
          TotalSamples := 0;
      finally
        LineValues.Free;
      end;
    end
    else
    begin
      TotalSamples := 0;
    end;

    if TotalSamples > 0 then
    begin
      TotalDuration := TotalSamples / SamplingRate;

      MessageStr := Format('File Loaded Successfully.' + sLineBreak + sLineBreak +
                           'Total Samples: %d' + sLineBreak +
                           'Total Time: %.2f seconds', [TotalSamples, TotalDuration]);

      ShowMessage(MessageStr);
    end
    else
    begin
      ShowMessage('Could not determine the number of samples from the file.');
    end;

    CurrentPage := 0;
    UpdateChartDisplay;
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  CurrentPage := 0;
  UpdateChartDisplay;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if CurrentPage > 0 then
  begin
    Dec(CurrentPage);
    UpdateChartDisplay;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Inc(CurrentPage);
  UpdateChartDisplay;
end;

procedure TForm1.UpdateChartDisplay;
var
  TimeRangeSec: Integer;
  StartTime, EndTime, TotalDuration: Double;
  i: Integer;
  Line: string;
  LineValues: TStringList;
  SampleNum, TimeX, MLII, V5: Double;
  seriesMLII, seriesV5: TLineSeries;
begin
  if Chart1.SeriesCount < 2 then Exit;
  seriesMLII := Chart1.Series[0] as TLineSeries;
  seriesV5 := Chart1.Series[1] as TLineSeries;

  if (CSVData.Count <= 1) or (ComboBox1.ItemIndex < 0) then
  begin
    seriesMLII.Clear;
    seriesV5.Clear;
    Button2.Enabled := False;
    Button3.Enabled := False;
    Exit;
  end;

  TimeRangeSec := ExtractNumber(ComboBox1.Text);
  if TimeRangeSec <= 0 then TimeRangeSec := 1;

  StartTime := CurrentPage * TimeRangeSec;
  EndTime := StartTime + TimeRangeSec;

  seriesMLII.Clear;
  seriesV5.Clear;

  LineValues := TStringList.Create;
  try
    for i := 1 to CSVData.Count - 1 do
    begin
      Line := CSVData[i];

      LineValues.Delimiter := ',';
      LineValues.StrictDelimiter := True;
      LineValues.DelimitedText := StringReplace(Line, '"', '', [rfReplaceAll]);

      if LineValues.Count = 3 then
      begin
        if TryStrToFloat(LineValues[0], SampleNum) and
           TryStrToFloat(LineValues[1], MLII) and
           TryStrToFloat(LineValues[2], V5) then
        begin
          TimeX := SampleNum / SamplingRate ;

          if (TimeX >= StartTime) and (TimeX < EndTime) then
          begin
            seriesMLII.AddXY(TimeX, MLII);
            seriesV5.AddXY(TimeX, V5);
          end;

          if TimeX >= EndTime then
            Break;
        end;
      end;
    end;
  finally
    LineValues.Free;
  end;

  Chart1.BottomAxis.SetMinMax(StartTime, EndTime);
  Label1.Caption := Format('Showing Time Interval: %.2fs - %.2fs', [StartTime, EndTime]);

  Button2.Enabled := (CurrentPage > 0);

  TotalDuration := TotalSamples / SamplingRate ;
  Button3.Enabled := (EndTime < TotalDuration);
end;

function TForm1.ExtractNumber(const S: string): Integer;
var
  i: Integer;
  ResStr: string;
begin
  ResStr := '';
  for i := 1 to Length(S) do
  begin
    if CharInSet(S[i], ['0'..'9']) then
    begin
      ResStr := ResStr + S[i];
    end;
  end;

  if ResStr <> '' then
    Result := StrToInt(ResStr)
  else
    Result := 0;
end;

end.
