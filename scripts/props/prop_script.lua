if(sim_call_type == sim_childscriptcall_initialization) then 
	-- do init
end

if(sim_call_type == sim_childscriptcall_actuation) then
    dofile(PWD..'/scripts/props/prop_actual.lua');
end 