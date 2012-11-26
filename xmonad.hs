{-# LANGUAGE DeriveDataTypeable #-}
import XMonad

--import XMonad.Config.Gnome
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Spacing
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Util.EZConfig
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Util.Run

{-
XMonad.Actions.WIndowMenu ?
<allbery_b> (also see X.A.WindowBringer, X.A.WindowGo, X.Prompt.Window)
<aavogt> willtim: you can also do it with X.A.GridSelect

minimize?
-}

myWorkspaces = ["1:main","2:emacs","3:web","4:web","5:dev","6:mend","7:chat","8:email","9:misc"]

myManageHook :: [ManageHook]
myManageHook =
    [   --,  className =? "Vlc" --> doFloat
        --, title     =? "VLC (XVideo output)" --> doFullFloat
        --, className =? "Vmplayer" --> doFloat
          className =? "." --> doCenterFloat
        , className =? "Gimp" --> doFloat
        , className =? "Thunderbird" --> doShift "8:email"
        , className =? "Thunderbird" <&&> resource =? "Msgcompose" --> doFloat
        , className =? "Mendeleydesktop.x86_64" --> doShift "6:mend"
        , className =? "Skype" --> doShift "7:chat"
        , className =? "Pidgin" --> doShift "7:chat"
        , title     =? "Eclipse" --> doFloat -- Eclipse splash
        , className =? "Eclipse" --> doShift "5:dev"
        , className =? "Vmplayer" --> doShift "9:misc"
        , isDialog  --> doCenterFloat
	, isFullscreen --> doFullFloat
        , manageDocks ]

myLayout =  smartBorders $ mkToggle (single FULL) (tiled ||| Mirror tiled)
 where
     -- default tiling algorithm partitions the screen into two panes
     -- tiled   = spacing 1 $ Tall nmaster delta ratio
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

main = do
xmproc <- spawnPipe "xmobar /home/tim/.xmonad/xmobarrc"
xmonad $ defaultConfig
    {
      workspaces = myWorkspaces,
      startupHook = setWMName "LG3D",
      terminal = "urxvt",
      borderWidth = 2,
      normalBorderColor = "#000000",
--      focusedBorderColor = "#000000",
      modMask = mod4Mask, -- set mod key to the windows key
      manageHook = manageHook defaultConfig <+> composeAll myManageHook,
      layoutHook = desktopLayoutModifiers $ myLayout,
      logHook = dynamicLogWithPP xmobarPP  
             { ppOutput = hPutStrLn xmproc  
             , ppTitle = xmobarColor "#2CE3FF" "" . shorten 64  
             }  

    } `additionalKeysP`
        [ ("M-p", spawn "exe=`dmenu_path | yeganesh` && eval \"exec $exe\"")
        , ("M-m", sendMessage $ Toggle FULL)
        , ("M-S-g", windowPromptGoto defaultXPConfig)
        , ("M-S-b", windowPromptBring defaultXPConfig)
        , ("<XF86ScreenSaver>", spawn "xscreensaver-command -lock")
        , ("<XF86Sleep>", spawn "xscreensaver-command -lock; sudo pm-suspend") -- check /etc/sudoers
        , ("<XF86AudioMute>", spawn "amixer set Master mute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 2dB+ unmute")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 2dB- unmute")
        , ("<XF86MonBrightnessUp>", return ()) -- TODO notify?
        , ("<XF86MonBrightnessDown>", return ()) -- TODO notify?
        , ("<XF86Launch1>", spawn "alsamixer-x11") ]
