local currentChannel = RSRP.PoliceRadio.Channels[1]
local radioState = false 
local recievedAudioState = false
local lply = LocalPlayer()


net.Receive("rsrp_policeradio_updatechannel", function()
    currentChannel = RSRP.PoliceRadio.Channels[net.ReadInt(11)]
    surface.PlaySound("npc/combine_soldier/vo/off2.wav")
end)
net.Receive("rsrp_policeradio_toggleradio", function()
    radioState = net.ReadBool()
    if !radioState then
        surface.PlaySound("npc/metropolice/vo/off4.wav")
    else
        surface.PlaySound("npc/metropolice/vo/on1.wav")
    end
end)
net.Receive("rsrp_policeradio_toggleaudio", function()
    recievedAudioState = net.ReadBool()
    if !recievedAudioState then
        surface.PlaySound("npc/metropolice/vo/off4.wav")
    else
        surface.PlaySound("npc/metropolice/vo/on1.wav")
    end
end)
hook.Add("HUDPaint", "rsrp_drawpoliceradio", function()
    if not LocalPlayer():isCP() and not LocalPlayer():isMedic() and not RSRP.PoliceRadio.AllowedJobs[team.GetName(LocalPlayer():Team())] then return end
    draw.SimpleText(string.format("Current Channel: %s (G)", currentChannel), "rsrp_policeradio30", ScrW()*0.99, ScrH()*0.48, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText(string.format("Radio is %s (H)", (radioState and "on") or "off"), "rsrp_policeradio30", ScrW()*0.99, ScrH()*0.5, (radioState and Color(250, 210, 35 )) or Color( 255,255,255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText(string.format("Received audio is %s (I)", (recievedAudioState and "On") or "Off"), "rsrp_policeradio30", ScrW()*0.99, ScrH()*0.52, (recievedAudioState and Color(250, 210, 35 )) or Color( 255,255,255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
end)
hook.Add("PlayerStartVoice", "rsrp_policeradio_startsound", function(ply)
    if not IsValid(ply) or not IsValid(LocalPlayer()) then return end
    if ply:GetNWBool("PoliceRadio_radioEnabled") and (ply:isCP() and LocalPlayer():isCP() or (ply:isMedic() and LocalPlayer():isMedic())) then
        surface.PlaySound("npc/combine_soldier/vo/on2.wav")
    end
end)
hook.Add("PlayerEndVoice", "rsrp_policeradio_endsound", function()
    if not IsValid(ply) or not IsValid(LocalPlayer()) then return end
    if ply:GetNWBool("PoliceRadio_radioEnabled") and (ply:isCP() and LocalPlayer():isCP() or (ply:isMedic() and LocalPlayer():isMedic())) then
        surface.PlaySound("riverside_policeradio/sendingmessage.wav")
    end
end)

surface.CreateFont("rsrp_policeradio30", {
    font = "Bebas Neue Regular",
    size = 30
})