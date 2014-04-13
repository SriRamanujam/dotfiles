import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

-- Setting up definitions for things
myTerminal = "urxvt"
myModMask = mod4Mask
myBorderWidth = 2

-- Personal settings
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Floating windows go here, if you think of any


main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/sri/.xmobarrc"
  xmonad $ defaultConfig
    { -- Simple stuff to start out with
      terminal = myTerminal
    , modMask = myModMask
    , borderWidth = myBorderWidth
    , manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts $ layoutHook defaultConfig
    , logHook = dynamicLogWithPP xmobarPP
		{
		  ppOutput = hPutStrLn xmproc
		, ppTitle = xmobarColor "green" "" . shorten 50 
		}
    } `additionalKeys`
    [ ((mod4Mask, xK_l), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/screenshots/'")
    ]

