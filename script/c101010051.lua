--アースの有志
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
ref.earth_enforcer_list=true
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xeeb,0x11,0,2000,4,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xeeb,0x11,0,2000,4,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
	c:AddTrapMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_EARTH,RACE_WARRIOR,4,0,2000)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0xeeb)
	c:RegisterEffect(e6)
end
