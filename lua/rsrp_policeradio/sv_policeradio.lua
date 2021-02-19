local channels = RSRP.PoliceRadio.Channels

function RSRP.PoliceRadio.ToggleChannel(ply)

    if not ply.PoliceRadioChannel then ply.PoliceRadioChannel = 1 end
    if ply.PoliceRadioChannel > #channels then ply.PoliceRadioChannel = 1 end
    
    local channel = ply.PoliceRadioChannel
    
    net.Start("rsrp_policeradio_updatechannel")
        net.WriteInt(channel, 11)
    net.Send(ply)
    
    ply.PoliceRadioChannel = ply.PoliceRadioChannel + 1
   
end
function RSRP.PoliceRadio.ToggleRadio(ply, bool)
    if ply.PoliceRadio == nil then ply.PoliceRadio = false end

    local state = (bool != nil and bool) or ply.PoliceRadio
    

    
    if not ply.PoliceRadio and not ply.PoliceRadioAudio then
        RSRP.PoliceRadio.ToggleAudio(ply, true)
    end
    ply.PoliceRadio = (bool != nil and bool) or !ply.PoliceRadio

    net.Start("rsrp_policeradio_toggleradio")
        net.WriteBool(ply.PoliceRadio)
    net.Send(ply)
    ply:SetNWBool("PoliceRadio_radioEnabled",ply.PoliceRadio)

end
function RSRP.PoliceRadio.ToggleAudio(ply, bool)
    if ply.PoliceRadioAudio == nil then ply.PoliceRadioAudio = true end
    
    local state = (bool != nil and bool) or ply.PoliceRadioAudio

    if ply.PoliceRadio and ply.PoliceRadioAudio then
        RSRP.PoliceRadio.ToggleRadio(ply, false)
    end

    ply.PoliceRadioAudio = (bool != nil and bool) or (!ply.PoliceRadioAudio and true) or false
    net.Start("rsrp_policeradio_toggleaudio")
        net.WriteBool(ply.PoliceRadioAudio)
    net.Send(ply)

end

hook.Add("PlayerButtonDown", "rsrp_policeradio_toggle", function(ply, button)

    if not ply:isCP() and not RSRP.PoliceRadio.AllowedJobs[ply:Team()] and not ply:isMedic() then return end
    if button == KEY_G then
        RSRP.PoliceRadio.ToggleChannel(ply)
    elseif button == KEY_H then
        RSRP.PoliceRadio.ToggleRadio(ply)
    elseif button == KEY_I then
        RSRP.PoliceRadio.ToggleAudio(ply)
    end

end)

hook.Add("PlayerCanHearPlayersVoice", "rsrp_policeradio_globalvoice", function(listener, talker)
    if (listener:isCP() or listener:isMedic() or talker:isCP() or talker:isMedic() or RSRP.PoliceRadio.AllowedJobs[team.GetName(talker:Team())] or RSRP.PoliceRadio.AllowedJobs[team.GetName(listener:Team())])
			and listener.PoliceRadioAudio and talker.PoliceRadio
			and (listener.PoliceRadioChannel == talker.PoliceRadioChannel or listener:Team() == TEAM_DISPATCHER or talker:Team() == TEAM_DISPATCHER) then
            return true, false
        end
    end
end)

hook.Add("OnPlayerChangedTeam", "rsrp_policeradio_onjobchange", function(ply, old, new)

	if not GAMEMODE.CivilProtection[new] then
		ply.PoliceRadioAudio 	= nil 
		ply.PoliceRadio 	= nil
	end

end)
