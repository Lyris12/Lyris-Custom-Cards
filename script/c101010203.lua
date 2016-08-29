--Cosmostech Astronomical Dragon
function c101010203.initial_effect(c)
c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c101010203.fscondition)
	e1:SetOperation(c101010203.fsoperation)
	c:RegisterEffect(e1)
	--add LIGHT attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c101010203.splimit)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101010203)
	e3:SetLabel(3)
	e3:SetCondition(c101010203.con)
	e3:SetTarget(c101010203.thtg)
	e3:SetOperation(c101010203.thop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,101010203)
	e4:SetLabel(4)
	e4:SetCondition(c101010203.con)
	e4:SetTarget(c101010203.rmtg)
	e4:SetOperation(c101010203.rmop)
	c:RegisterEffect(e4)
	--extra attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,101010203)
	e5:SetLabel(5)
	e5:SetCondition(c101010203.con)
	e5:SetCost(c101010203.cost)
	e5:SetOperation(c101010203.atkop)
	c:RegisterEffect(e5)
end
function c101010203.ffilter(c)
	return c:IsSetCard(0x4093)
end
function c101010203.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then return c101010203.ffilter(gc) and g:IsExists(c101010203.ffilter,2,gc) end
	local g1=g:Filter(c101010203.ffilter,nil)
	if chkf~=PLAYER_NONE then
		return g1:FilterCount(Card.IsOnField,nil)~=0 and g1:GetCount()>=3
	else return g1:GetCount()>=3 end
end
function c101010203.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=eg:FilterSelect(tp,c101010203.ffilter,2,63,gc)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(c101010203.ffilter,nil)
	if chkf==PLAYER_NONE or sg:GetCount()==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,3,63,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,2,63,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c101010203.splimit(e,se,sp,st)
	return (bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_FUSION+0xFA0)==SUMMON_TYPE_FUSION+0xFA0) and se:GetHandler():IsSetCard(0x4093) --true
end
function c101010203.csfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4093)
end
function c101010203.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101010203.csfilter,tp,LOCATION_REMOVED,0,e:GetLabel(),nil) and aux.bdogcon
end
function c101010203.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4093) and c:IsAbleToHand()
end
function c101010203.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c101010203.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010203.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101010203.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101010203.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101010203.csfilter,tp,LOCATION_REMOVED,0,e:GetLabel(),nil) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c101010203.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101010203.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c101010203.csfilter,tp,LOCATION_REMOVED,0,e:GetLabel(),nil) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c101010203.cfilter(c)
	return c:IsSetCard(0x4093) and c:IsAbleToRemoveAsCost()
end
function c101010203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010203.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010203.cfilter,tp,LOCATION_HAND,0,1,63,nil)
	e:SetLabelObject(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010203.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101010203.csfilter,tp,LOCATION_REMOVED,0,e:GetLabel(),nil) then return end
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetCount()
	if ct>0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
