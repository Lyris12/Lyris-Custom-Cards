--created & coded by Lyris
--サイバー・ドラゴン・丸藤NEO
function c101010288.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),8,3)
	local ar=Effect.CreateEffect(c)
	ar:SetType(EFFECT_TYPE_FIELD)
	ar:SetTarget(c101010288.artg)
	ar:SetRange(LOCATION_MZONE)
	ar:SetTargetRange(LOCATION_MZONE,0)
	ar:SetCode(EFFECT_ADD_RACE)
	ar:SetValue(RACE_MACHINE)
	ar:SetCondition(c101010288.efcon)
	c:RegisterEffect(ar)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c101010288.condition)
	e0:SetOperation(c101010288.copy)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101010288)
	e1:SetCondition(c101010288.olcon)
	e1:SetTarget(c101010288.oltg)
	e1:SetOperation(c101010288.olop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010288.condition)
	e2:SetValue(c101010288.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101010288.rmcon)
	e3:SetOperation(c101010288.rmop)
	c:RegisterEffect(e3)
end
function c101010288.effilter
	return c:GetOriginalRace()~=RACE_MACHINE
end
function c101010288.efcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101010288.effilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c101010288.artg(e,c)
	return c==e:GetHandler()
end
function c101010288.condition(e,tp,eg,ep,ev,re,r,rp)
	return c101010288.efcon(e,tp) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,101010288)
end
function c101010288.olcon(e,tp,eg,ep,ev,re,r,rp)
	return c101010288.efcon(e,tp) and e:GetHandler():GetOverlayCount()==0
end
function c101010288.oltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_ONFIELD,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,101010288) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c101010288.olop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		Duel.Damage(1-tp,atk,REASON_BATTLE)
		Duel.BreakEffect()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.Overlay(c,Group.FromCards(og))
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c101010288.cpfilter(c)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:GetCode()~=101010288 and not c:IsType(TYPE_TUNER)
end
function c101010288.copy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(c101010288.cpfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_END,1)
			c:RegisterFlagEffect(code,RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_END,0,1)
		end
		wbc=wg:GetNext()
	end
end
function c101010288.efilter(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c101010288.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return c101010288.rmcon(e,tp) and Duel.GetTurnPlayer()~=tp
end
function c101010288.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
