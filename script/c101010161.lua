--ポワー・エンフォースメント
function c101010161.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetOperation(c101010161.operation)
	c:RegisterEffect(e1)
end
function c101010161.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c101010161.tg)
	e1:SetLabel(1)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetLabel(2)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	Duel.RegisterEffect(e2,tp)
	--
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c101010161.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c101010161.tg(e,c)
	if not c:IsType(TYPE_SYNCHRO+TYPE_FUSION) then return false end
	if e:GetLabel()==1 then return c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND) else return true end
end
function c101010161.splimit(e,c,tp,sumtp,sumpos)
	return c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
end
