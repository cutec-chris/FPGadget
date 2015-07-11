unit Device;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TDevice }

  TDevice = class
  private
    function GetDeviceName: string;
  public
    property DeviceName: string read GetDeviceName;
  end;

implementation

{ TDevice }

function TDevice.GetDeviceName: string;
begin

end;

end.

