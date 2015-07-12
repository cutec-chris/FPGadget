unit ubluetooth;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Bluetooth;

type

  { TForm1 }

  TForm1 = class(TForm)
    Discover: TButton;
    lbDevices: TListBox;
    procedure DiscoverClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.DiscoverClick(Sender: TObject);
var
  aM: TBluetoothManager;
  i: Integer;
  tmp: String;
begin
  aM := Bluetooth.BluetoothManager;
  aM.StartDiscovery(5000);
  lbDevices.Clear;
  for i := 0 to aM.LastDiscoveredDevices.Count-1 do
    begin
      tmp := aM.LastDiscoveredDevices[i].DeviceName+' ('+am.LastDiscoveredDevices[i].Address+')';
      lbDevices.Items.Add(tmp);
    end;
end;

end.

