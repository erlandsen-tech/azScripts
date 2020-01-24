New-AzResourceGroup -Name hybrid-cloud -Location northeurope

$virtualnetwork = New-AzVirtualNetwork `
-ResourceGroupName hybrid-cloud `
-Location northeurope `
-Name hybrid-cloud-network `
-AddressPrefix 10.1.0.0/16

$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
-Name Frontend `
-AddressPrefix 10.1.0.0/24 `
-VirtualNetwork $virtualnetwork

$virtualnetwork | Set-AzVirtualNetwork

$vnet = Get-AzVirtualNetwork -ResourceGroupName hybrid-cloud -Name hybrid-cloud-network

Add-AzVirtualNetworkSubnetConfig -Name 'GateWaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork

$gwip = New-AzPublicIpAddress -Name hybrid-cloud-network-ip -ResourceGroupName hybrid-cloud `
-Location 'North Europe' -AllocationMethod Dynamic

$vnet = Get-AzVirtualNetwork -Name hybrid-cloud-network -ResourceGroupName hybrid-cloud
$subnet = Get-AzVirtualNetworkSubnetConfig -Name 'GateWaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $subnet.Id -PublicIpAddressId $gwip.Id