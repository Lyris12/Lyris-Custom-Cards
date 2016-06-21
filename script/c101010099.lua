--クリアー・バード
local id,ref=GIR()
function ref.start(c)
--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(ref.con)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(ref.slcon)
	e2:SetValue(6)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	--spell effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,id)
	e6:SetTarget(ref.tg)
	e6:SetOperation(ref.op)
	c:RegisterEffect(e6)
	--remove attribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(ref.ratg)
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(ref.con)
	e7:SetTarget(ref.tdtg)
	e7:SetOperation(ref.tdop)
	c:RegisterEffect(e7)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_MZONE,1,nil,ATTRIBUTE_WIND)
end
function ref.ratg(e)
	return e:GetHandler()
end
function ref.slcon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or (not tc:IsSetCard(0x306))
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_EARTH)
	tc:RegisterEffect(e5)
end
function ref.filter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToDeck()
end
function ref.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,ref.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function ref.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
