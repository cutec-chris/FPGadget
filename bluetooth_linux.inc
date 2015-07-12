uses bluez,ctypes,Sockets,unix;

{ TBluetoothDeviceList }

function TBluetoothDeviceList.GetDevice(Index: Integer): TBluetoothDevice;
begin
  Result := TBluetoothDevice(Get(Index));
end;

function TBluetoothManager.GetConnectionState: TBluetoothConnectionState;
begin

end;

function TBluetoothManager.GetCurrentAdapter: TBluetoothAdapter;
begin

end;

class function TBluetoothManager.GetKnownServiceName(const AServiceUUID: TGUID
  ): string;
begin

end;

procedure TBluetoothManager.StartDiscoverable(Timeout: Integer);
begin

end;

procedure TBluetoothManager.StartDiscovery(Timeout: Integer);
var
  device_id, device_sock: cint;
  scan_info: array[0..127] of inquiry_info;
  scan_info_ptr: Pinquiry_info;
  found_devices: cint;
  DevName: array[0..255] of Char;
  PDevName: PCChar;
  RemoteName: array[0..255] of Char;
  PRemoteName: PCChar;
  i: Integer;
  a: Integer;
  aDev: TBluetoothDevice;
  Found: Boolean;
begin
  // get the id of the first bluetooth device.
  device_id := hci_get_route(nil);
  if (device_id < 0) then
    raise EBluetoothAdapterException.Create('FindBlueTooth: hci_get_route');

  // create a socket to the device
  device_sock := hci_open_dev(device_id);
  if (device_sock < 0) then
    raise EBluetoothDeviceException.Create('FindBlueTooth: hci_open_dev');

  // scan for bluetooth devices for 'timeout1' seconds
  scan_info_ptr:=@scan_info[0];
  FillByte(scan_info[0],SizeOf(inquiry_info)*128,0);
  found_devices := hci_inquiry_1(device_id, timeout div 1000, 128, nil, @scan_info_ptr, IREQ_CACHE_FLUSH);

  for a := 0 to FDiscoveredDevices.Count-1 do
    TBluetoothDevice(FDiscoveredDevices[a]).FActualFound:=False;
  for i := 0 to found_devices-1 do
    begin
      PDevName:=@DevName[i];
      ba2str(@scan_info[i].bdaddr, PDevName);
      Found := False;
      for a := 0 to FDiscoveredDevices.Count-1 do
        if TBluetoothDevice(FDiscoveredDevices[a]).Address=PChar(PDevName) then
          with TBluetoothDevice(FDiscoveredDevices[a]) do
            begin
              FActualFound:=True;
              Found := True;
            end;
      if not Found then
        begin
          aDev := TBluetoothDevice.Create;
          FDiscoveredDevices.Add(aDev);
          aDev.FAddress:=PChar(PDevName);
          PRemoteName:=@RemoteName[i];
          aDev.FMajor := (scan_info[i].dev_class[1] and $1F) shl 8;
          aDev.FMinor := aDev.FMajor or scan_info[i].dev_class[0];
          // Read the remote name for 'timeout2' milliseconds
          if (hci_read_remote_name(device_sock,@scan_info[i].bdaddr,255,PRemoteName,Timeout) >= 0) then
            aDev.FDeviceName :=  PChar(RemoteName);
        end;
    end;

  c_close(device_sock);
end;

procedure TBluetoothManager.CancelDiscovery;
begin

end;

function TBluetoothManager.CreateServerSocket(const AName: string;
  const AUUID: TGUID; Secure: Boolean): TBluetoothServerSocket;
begin

end;

function TBluetoothManager.GetPairedDevices(const AnAdapter: TBluetoothAdapter
  ): TBluetoothDeviceList;
begin

end;

function TBluetoothManager.GetPairedDevices: TBluetoothDeviceList;
begin

end;

