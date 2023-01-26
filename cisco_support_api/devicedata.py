#!/usr/bin/env python3

import concurrent.futures, socket
from netmiko import ConnectHandler
from netmiko.exceptions import AuthenticationException, NetmikoTimeoutException, SSHException, ReadException
from tqdm import tqdm

offline,Ddata = [],[]
offline_file = open("offline.txt","w")
offline_file.close()

def data(conn, device):
    output = conn.send_command('show version',use_textfsm=True)
    try:
        if "version" in output[0].keys():
            hostname = output[0]["hostname"]
            model = output[0]["hardware"][0]
            serial = output[0]["serial"][0]
            os = output[0]["rommon"]
            version = output[0]["version"]
        elif "platform" in output[0].keys():
            hostname = output[0]["hostname"]
            model = output[0]["platform"]
            serial = output[0]["serial"]
            os = "NX-OS"
            version = output[0]["os"]
        Ddata.append({"Hostname":hostname,"ProductID":model,"SerialNumber":serial,"OS":os,"OSVersion":version})
    except(AttributeError,KeyError):
        offline.append(device)
        offline_file = open("offline.txt","a")
        offline_file.write(f"{device},Attribute/Key error"+"\n")
        offline_file.close()
    conn.disconnect()

def connection(device,offline,offline_file,user,pas,ios,nxos,pbar):
    try:
        if device in ios:
            conn = ConnectHandler(device_type="cisco_ios_ssh", host=device, username=user, password=pas, fast_cli=False, auth_timeout=180)
            data(conn, device)
        elif device in nxos:
            conn = ConnectHandler(device_type="cisco_nxos_ssh", host=device, username=user, password=pas, fast_cli=False, auth_timeout=180)
            data(conn, device)
    except(ConnectionRefusedError, ConnectionResetError):
        offline.append(device)
        offline_file = open("offline.txt","a")
        offline_file.write(f"{device},ConnectionRefused error"+"\n")
        offline_file.close()
    except(TimeoutError, socket.timeout, ReadException):
        offline.append(device)
        offline_file = open("offline.txt","a")
        offline_file.write(f"{device},Timeout error"+"\n")
        offline_file.close()
    except(AuthenticationException):
        offline.append(device)
        offline_file = open("offline.txt","a")
        offline_file.write(f"{device},Authentication error"+"\n")
        offline_file.close()
    except(SSHException, NetmikoTimeoutException):
        try:
            conn = ConnectHandler(device_type= "cisco_ios_telnet", host=device, username=user, password=pas, fast_cli=False, auth_timeout=180)
            data(conn, device)
        except(ConnectionRefusedError, ConnectionResetError):
            offline.append(device)
            offline_file = open("offline.txt","a")
            offline_file.write(f"{device},ConnectionRefused error"+"\n")
            offline_file.close()
        except(TimeoutError, socket.timeout, ReadException):
            offline.append(device)
            offline_file = open("offline.txt","a")
            offline_file.write(f"{device},Timeout error"+"\n")
            offline_file.close()
        except(AuthenticationException):
            offline.append(device)
            offline_file = open("offline.txt","a")
            offline_file.write(f"{device},Authentication error"+"\n")
            offline_file.close()
    except(EOFError):
        offline.append(device)
        offline_file = open("offline.txt","a")
        offline_file.write(f"{device},EOF error"+"\n")
        offline_file.close()
    except(socket.gaierror):
        offline.append(device)
        offline_file = open("offline.txt","a")
        offline_file.write(f"{device},gai error"+"\n")
        offline_file.close()
    pbar.update(1)

def device_data(devices,offline,offline_file,env_vars,ios,nxos):

    user = env_vars["user"]
    pas = env_vars["sdn_pass"]
    with tqdm(total=len(devices), desc="Extracting device data") as pbar:
        with concurrent.futures.ThreadPoolExecutor(max_workers=40) as executor:
            ejecucion = {executor.submit(connection,device,offline,offline_file,user,pas,ios,nxos,pbar): device for device in devices}
        for output in concurrent.futures.as_completed(ejecucion):
            output.result()