--ＳＳ－Ｓ・Ｖｉｎｅ スターモス
function c101010285.initial_effect(c)
--synchro
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_ADD_TYPE)
	ae1:SetValue(TYPE_SYNCHRO)
	ae1:SetCondition(c101010285.atcon)
	c:RegisterEffect(ae1)
	--boost
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD)
	ae2:SetCode(EFFECT_UPDATE_ATTACK)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetTargetRange(LOCATION_MZONE,0)
	ae2:SetTarget(c101010285.syntg)
	ae2:SetValue(1000)
	c:RegisterEffect(ae2)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101010285.spcon)
	e1:SetOperation(c101010285.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+7150)==SUMMON_TYPE_XYZ+7150 end)
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
function c101010285.spfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c101010285.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c101010285.spfilter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsNotTuner()
end
function c101010285.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c101010285.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c101010285.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c101010285.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cd=tc:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,c101010285.spfilter2,tp,LOCATION_MZONE,0,1,1,cd)
	tc:Merge(g2)
	c:SetMaterial(tc)
	local fg=tc:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	local atk=10
	local rg=tc:GetFirst()
	while rg do
		local atk1=rg:GetDefense()
		atk=atk+atk1
		rg=tc:GetNext()
	end
	Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+7150)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end
function c101010285.atcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function c101010285.syntg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c~=e:GetHandler()
end
