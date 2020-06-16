import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.UpdatePointer
import qualified XMonad.StackSet as W
import qualified Data.Map	 as M
myLayout = spacingRaw True (Border 0 5 5 5 ) True (Border 7 7 7 7 ) True $ Tall 1 (3/100) (58/100) ||| spiral (107/125)
myFont :: [Char]
myFont = "xft:Mononoki Nerd Font:bold:pixelsize=13"
myBorderWidth :: Dimension
myBorderWidth = 3

myNormColor = "#C7C5C1"
myFocusColor = "#8C7565"     

myWsBar = "xmobar $HOME/.config/xmobar/xmobarrc"
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


myManageHook = (isFullscreen --> doFullFloat) <+> insertPosition End Newer   

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
        [ ((modm .|. shiftMask, xK_q), kill)
        , ((modm, xK_space), sendMessage NextLayout)
	, ((modm, xK_Tab), windows W.focusDown)
	, ((modm, xK_j), windows W.focusDown)
	, ((modm, xK_k), windows W.focusUp)
        , ((modm, xK_h), sendMessage Shrink)
        , ((modm, xK_l), sendMessage Expand)
	, ((modm, xK_m), windows W.focusMaster)
        , ((modm .|. shiftMask, xK_space), sendMessage NextLayout)
	, ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
	, ((modm .|. shiftMask, xK_j), windows W.swapDown)
	, ((modm .|. shiftMask, xK_k), windows W.swapUp)
	, ((modm, xK_t), withFocused $ windows . W.sink)
	, ((modm, xK_comma), sendMessage (IncMasterN 1))
	, ((modm, xK_period), sendMessage (IncMasterN (-1)))
	, ((modm, xK_space), spawn $ "dmenu_run")
	, ((modm .|. shiftMask, xK_c), restart "xmonad" True)
	]
        ++
        [((m .|. modm, k), windows $ f i)
		| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]



main = do
        xmproc <- spawnPipe myWsBar
        xmonad $ docks def {
                terminal        = "alacritty"
		, modMask       = mod4Mask
		, keys          = myKeys
                , borderWidth        = myBorderWidth
                , normalBorderColor  = myNormColor
                , focusedBorderColor = myFocusColor
		, layoutHook    = avoidStruts $ myLayout 
		, manageHook    = myManageHook 
                , logHook =dynamicLogWithPP $ xmobarPP { ppOutput = \x -> hPutStrLn xmproc x 
                                                       , ppCurrent = xmobarColor "#c7c5c1" "" . wrap "[" "]" -- Current workspace in xmobar
                                                       , ppVisible = xmobarColor "#8C7565" ""                -- Visible but not current workspace
                                                       , ppHidden = xmobarColor "#C29D75" "" . wrap "|" "|"   -- Hidden workspaces in xmobar
                                                       , ppHiddenNoWindows = xmobarColor "#7A8277" ""        -- Hidden workspaces (no windows)
                                                       , ppTitle = xmobarColor "#d0d0d0" "" . shorten 60     -- Title of active window in xmobar
                                                       , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                                                       , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                                                       , ppExtras  = [windowCount]                           -- # of windows current workspace
                                                       , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                                                       }    
                }
