--スターナイト・サイバー・ドラゴン
function c101010028.initial_effect(c)
	--additional effects
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ae4:SetCode(EVENT_BECOME_TARGET)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetCondition(c101010028.rmcon)
	ae4:SetOperation(c101010028.rmop)
	c:RegisterEffect(ae4)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCondition(c101010028.tgcon)
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
	ae2:SetCondition(c101010028.atkucon)
	ae2:SetOperation(c101010028.atkuop)
	c:RegisterEffect(ae2)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101010028.spcon)
	e1:SetOperation(c101010028.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+0x7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+0x7150)==SUMMON_TYPE_XYZ+0x7150 end)
	c:RegisterEffect(e2)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
end
function c101010028.spfilter(c,v,y,z)
	local atk=math.abs(c:GetAttack()-c:GetDefence())
	return c:GetRank()==v and atk>=y and atk<=z and c:IsAbleToRemoveAsCost()
end
function c101010028.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c101010028.spfilter,tp,LOCATION_MZONE,0,1,nil,5,250,750)
end
function c101010028.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c101010028.spfilter,tp,LOCATION_MZONE,0,1,1,nil,5,250,750)
	local fg=g:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x7150)
end
function c101010028.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local st=c:GetSummonType()
	if bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ or bit.band(st,SUMMON_TYPE_SPECIAL)==0 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g:IsContains(c)
end
function c101010028.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CONTROLER)
	if p==tp then return end
	Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c101010028.tgcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c101010028.atkucon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==0
end
function c101010028.atfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsReason(REASON_MATERIAL)
end
function c101010028.atkuop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c101010028.atfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
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
