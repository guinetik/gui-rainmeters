#SingleInstance Force
#Persistent
Menu, Tray, Icon, Keylaunch.ico, 1
Menu, Tray, NoStandard

OnMessage(0x404, "AHK_NOTIFYICON")
AHK_NOTIFYICON(wParam, lParam, uMsg, hWnd)
{
    if (lParam = 0x201) ;WM_LBUTTONDOWN := 0x201
    {
        if(A_IsSuspended){
            Menu, Tray, Icon, Keylaunch.ico, , 1
        } else {
            Menu, Tray, Icon, KeylaunchPaused.ico, , 1
        }
        Suspend
    }
}
IniRead, Key1, C:\Users\enhan\Documents\Rainmeter\CoreData\Keylaunch\Hotkeys.inc, Variables, Key1
Try Hotkey, %Key1%, Action1
Return
Action1:
    SendToReceiver(1)
Return
SendToReceiver(index)
{
    IniRead, RainmeterPath, C:\Users\enhan\Documents\Rainmeter\CoreData\Keylaunch\Hotkeys.inc, Variables, RMPATH
    Run "%RainmeterPath% "!CommandMEasure "Receiver:M" "Launch(%index%)" "Keylaunch\Main" " "
}

