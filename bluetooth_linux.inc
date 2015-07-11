uses bluez,ctypes,Sockets,unix;

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
begin
  // get the id of the first bluetooth device.
  device_id := hci_get_route(nil);
  if (device_id < 0) then
    raise Exception.Create('FindBlueTooth: hci_get_route')
  else
    writeln('device_id = ',device_id);

  // create a socket to the device
  device_sock := hci_open_dev(device_id);
  if (device_sock < 0) then
    raise Exception.Create('FindBlueTooth: hci_open_dev')
  else
    writeln('device_sock = ',device_sock);

  // scan for bluetooth devices for 'timeout1' seconds
  scan_info_ptr:=@scan_info[0];
  FillByte(scan_info[0],SizeOf(inquiry_info)*128,0);
  found_devices := hci_inquiry_1(device_id, timeout div 1000, 128, nil, @scan_info_ptr, IREQ_CACHE_FLUSH);

  writeln('found_devices (if any) = ',found_devices);

  for i := 0 to found_devices-1 do
    begin
      PDevName:=@DevName[0];
      ba2str(@scan_info[0].bdaddr, PDevName);
      writeln('Bluetooth Device Address (bdaddr) DevName = ',PChar(PDevName));

      PRemoteName:=@RemoteName[0];
      // Read the remote name for 'timeout2' milliseconds
      if (hci_read_remote_name(device_sock,@scan_info[0].bdaddr,255,PRemoteName,Timeout) < 0) then
        writeln('No remote name found, check timeout.')
      else
        writeln('RemoteName = ',PChar(RemoteName));
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

