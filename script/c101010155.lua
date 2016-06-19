--ＳＳ－トライデニュート
function c101010220.initial_effect(c)
	--limit synch
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c101010220.val)
	c:RegisterEffect(e0)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(3)
	e1:SetCondition(c101010220.con)
	e1:SetOperation(c101010220.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c101010220.spcon)
	c:RegisterEffect(e2)
end
function c101010220.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5cd)
end
function c101010220.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101010220.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and e:GetHandler():IsLevelAbove(1)
end
function c101010220.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-1)
		c:RegisterEffect(e1)
	end
end
function c101010220.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(e:GetHandler():GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0
end
function c101010220.val(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
