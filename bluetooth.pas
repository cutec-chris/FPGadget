unit Bluetooth;

{$mode objfpc}{$H+}

interface

{$ifdef unix}
  {$linklib bluetooth}
{$endif}

uses
  Classes, SysUtils, Device;

type
  TBluetoothMacAddress = String;
  TBluetoothType = (btUnknown, btClassic, btLE, btDual);
  TBluetoothAdapterState = (basOff, basOn, basDiscovering);
  TBluetoothDeviceState = (bdsNone, bdsPaired, bdsConnected);
  TBluetoothConnectionState = (bcsDisconnected, bcsConnected);

  EBluetoothException = class(Exception);
  EBluetoothAdapterException = class(EBluetoothException);
  EBluetoothDeviceException = class(EBluetoothException);
  EBluetoothFormatException = class(EBluetoothException);
  EBluetoothManagerException = class(EBluetoothException);
  EBluetoothServiceException = class(EBluetoothException);
  EBluetoothSocketException = class(EBluetoothException);

  TBluetoothServerSocket = class
  end;

  TBluetoothUUID = TGUID;

  { TBluetoothService }

  TBluetoothService = record
    Name: string;
    UUID: TBluetoothUUID;
  end;

  TBluetoothServiceList = class(TList);

  { TBluetoothCustomDevice }

  TBluetoothCustomDevice = class(TDevice)
  private
    function GetBluetoothType: TBluetoothType;
  protected
    FAddress: TBluetoothMacAddress;
    FActualFound : Boolean;
    FDeviceName: string;
  public
    property Address: TBluetoothMacAddress read FAddress;
    property BluetoothType: TBluetoothType read GetBluetoothType;
    property DeviceName: string read FDeviceName;
  end;

  { TBluetoothDevice }

  TBluetoothDevice = class(TBluetoothCustomDevice)
  private
    function GetServiceList: TBluetoothServiceList;
    function GetState: TBluetoothDeviceState;
  protected
    FMajor: Integer;
    FMinor: Integer;
    FPaired: Boolean;
  public
    function GetServices: TBluetoothServiceList;
    property LastServiceList: TBluetoothServiceList read GetServiceList;
    property ClassDevice: Integer read FMinor;
    property ClassDeviceMajor: Integer read FMajor;
    property IsPaired: Boolean read FPaired;
    property State: TBluetoothDeviceState read GetState;
  end;

  { TBluetoothDeviceList }

  TBluetoothDeviceList = class(TList)
  private
    function GetDevice(Index: Integer): TBluetoothDevice;
  public
    property Items[Index: Integer]: TBluetoothDevice read GetDevice; default;
  end;

  TIdentifyUUIDEvent = function(Sender : TObject;const AUID : TGUID) : string of object;
  TDiscoveryEndEvent = function(Sender : TObject;const ADeviceList : TBluetoothDeviceList) : string of object;
  TDiscoverableEndEvent = TNotifyEvent;

  { TBluetoothCustomAdapter }

  TBluetoothCustomAdapter = class
  private
    function GetAdapterName: string;
    function GetAddress: TBluetoothMacAddress;
    function GetState: TBluetoothAdapterState;
    procedure SetAdapterName(AValue: string);
  public
    property AdapterName: string read GetAdapterName write SetAdapterName;
    property Address: TBluetoothMacAddress read GetAddress;
    property State: TBluetoothAdapterState read GetState;
  end;

  TBluetoothAdapter = class(TBluetoothCustomAdapter)

  end;

  { TBluetoothManager }

  TBluetoothManager = class
  private
    {$ifdef UNIX}
      {$I bluetooth_linux_h.inc}
    {$else}
      {$I bluetooth_win_h.inc}
    {$endif}
    FDiscoveredDevices: TBluetoothDeviceList;
    FLastDiscoveredTimeStamp: TDateTime;
    FOnDiscoverableEnd: TDiscoverableEndEvent;
    FOnDiscoveryEnd: TDiscoveryEndEvent;
    class var FOnIdentifyCustomUUID: TIdentifyUUIDEvent;
    class var FSocketTimeout: Integer;
    function GetConnectionState: TBluetoothConnectionState;
    function GetCurrentAdapter: TBluetoothAdapter;
    function InternalGetBluetoothManager: TBluetoothManager;
  public
    constructor Create;
    destructor Destroy; override;
    property Current: TBluetoothManager read InternalGetBluetoothManager;
    class property SocketTimeout: Integer read FSocketTimeout write FSocketTimeout default 5000;
    class function GetKnownServiceName(const AServiceUUID: TGUID): string; static;
    class property OnIdentifyCustomUUID: TIdentifyUUIDEvent read FOnIdentifyCustomUUID write FOnIdentifyCustomUUID;
    procedure StartDiscoverable(Timeout: Integer);
    procedure StartDiscovery(Timeout: Integer);
    procedure CancelDiscovery;
    property ConnectionState: TBluetoothConnectionState read GetConnectionState;
    function CreateServerSocket(const AName: string; const AUUID: TGUID; Secure: Boolean): TBluetoothServerSocket;
    function GetPairedDevices(const AnAdapter: TBluetoothAdapter): TBluetoothDeviceList; overload;
    function GetPairedDevices: TBluetoothDeviceList; overload;
    property CurrentAdapter: TBluetoothAdapter read GetCurrentAdapter;
    property LastDiscoveredDevices: TBluetoothDeviceList read FDiscoveredDevices;
    property LastDiscoveredTimeStamp: TDateTime read FLastDiscoveredTimeStamp;
    property OnDiscoverableEnd: TDiscoverableEndEvent read FOnDiscoverableEnd write FOnDiscoverableEnd;
    property OnDiscoveryEnd: TDiscoveryEndEvent read FOnDiscoveryEnd write FOnDiscoveryEnd;
  end;

var
  BluetoothManager : TBluetoothManager;

implementation

{$ifdef UNIX}
  {$I bluetooth_linux.inc}
{$else}
  {$I bluetooth_win.inc}
{$endif}

{ TBluetoothDevice }

function TBluetoothDevice.GetServiceList: TBluetoothServiceList;
begin

end;

function TBluetoothDevice.GetState: TBluetoothDeviceState;
begin

end;

function TBluetoothDevice.GetServices: TBluetoothServiceList;
begin

end;

{ TBluetoothCustomAdapter }

function TBluetoothCustomAdapter.GetAdapterName: string;
begin

end;

function TBluetoothCustomAdapter.GetAddress: TBluetoothMacAddress;
begin

end;

function TBluetoothCustomAdapter.GetState: TBluetoothAdapterState;
begin

end;

procedure TBluetoothCustomAdapter.SetAdapterName(AValue: string);
begin

end;

{ TBluetoothManager }

function TBluetoothManager.InternalGetBluetoothManager: TBluetoothManager;
begin
  Result := BluetoothManager;
end;

constructor TBluetoothManager.Create;
begin
  FDiscoveredDevices := TBluetoothDeviceList.Create;
end;

destructor TBluetoothManager.Destroy;
begin
  FDiscoveredDevices.Destroy;
  inherited Destroy;
end;

{ TBluetoothCustomDevice }

function TBluetoothCustomDevice.GetBluetoothType: TBluetoothType;
begin

end;

initialization
  BluetoothManager := TBluetoothManager.Create;
finalization
  BluetoothManager.Free;
end.

