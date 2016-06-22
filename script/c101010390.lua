--Galactic Mirror Force
local id,ref=GIR()
function ref.start(c)
	--When an opponent's monster declares an attack: Apply this effect, depending on the number of Attack Position monsters your opponent controls; (effects below)
	local e1=c:AddActivateProc()
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:Set
end
--1 or 2: Banish all Attack Position monsters your opponent controls.
--3 or more: The ATK of all Attack Position monsters your opponent controls becomes 0.
