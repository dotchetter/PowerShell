

<# math function. 
arguments is sum of strings from input costs and multipliers assigned.#>

function compute ($array, $x, $y) {
    
    $cost_sum = 0
    foreach ($num in $array) {
        $num = ($num / 1)
    
        if ($num -le 500) {
            $num = $num * $x
        } 
        elseif ($num -ge 500) {
            $num = $num * $y
        }
        $cost_sum += $num
    }
    
    $cost_sum = [math]::round($cost_sum, [system.midpointrounding]::awayfromzero)
    return "$cost_sum Kr"
}



# hide console window
function hide_console {
    $console_window = [console.window]::getconsolewindow()
    [console.window]::showwindow($console_window, 0) #0 = hide
}
