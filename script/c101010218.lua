--Starnight Cyber Dragon
local id,ref=GIR()
function ref.initial_effect(c)
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ae4:SetCode(EVENT_BECOME_TARGET)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetCondition(ref.rmcon)
	ae4:SetOperation(ref.rmop)
	c:RegisterEffect(ae4)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCondition(ref.tgcon)
	ae1:SetValue(aux.tgval)
	c:RegisterEffect(ae1)
	local ae3=ae1:Clone()
	ae3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	ae3:SetValue(aux.imval1)
	c:RegisterEffect(ae3)
	local ae2=Effect.CreateEffect(c)
	ae2:SetCategory(CATEGORY_ATKCHANGE)
	ae2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ae2:SetCode(EVENT_SPSUMMON_SUCCESS)
	ae2:SetCondition(ref.atkucon)
	ae2:SetOperation(ref.atkuop)
	c:RegisterEffect(ae2)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.spatial=true
--Spatial Formula filter(s)
-- ref.material1=nil
-- ref.material2=function(mc) return true end -- Invert this block of code on Division Spatial Monsters (begin)
ref.divs_spatial=true --Division Procedure /
ref.stat=function(mc) return mc:GetAttack()-mc:GetDefence() end
ref.indicator=function(mc) return mc:GetRank() end -- Invert this block of code on Division Spatial Monsters (end)
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
end
function ref.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local st=c:GetSummonType()
	if bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ or bit.band(st,SUMMON_TYPE_SPECIAL)==0 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g:IsContains(c)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CONTROLER)
	if p==tp then return end
	Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function ref.tgcon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x7150)==0x7150
end
function ref.atkucon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x7150)==0
end
function ref.atfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsReason(REASON_MATERIAL)
end
function ref.atkuop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(ref.atfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(c:GetBaseAttack()*ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_CODE)
		e0:SetValue(70095154)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0)
	end
end
