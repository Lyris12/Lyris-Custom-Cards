--Monument Shattered Pyramid
function c101010462.initial_effect(c)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_TRAP)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c101010462.spcon)
	e1:SetTarget(c101010462.sptg)
	e1:SetOperation(c101010462.spop)
	c:RegisterEffect(e1)
	--check: from field to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c101010462.regop)
	c:RegisterEffect(e2)
	--If this card is Special Summoned from the Graveyard after being sent there from the field: You can target 1 Set Spell/Trap Card on the field; destroy that target and 1 card on the field that is not controlled by that target's controller. You can only use this effect of "Monument Shattered Pyramid" once per turn.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,101010462)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c101010462.descon)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetTarget(c101010462.destg)
	e3:SetOperation(c101010462.desop)
	c:RegisterEffect(e3)
end
function c101010462.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c101010462.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010462.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010462.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		c:RegisterFlagEffect(101010462,RESET_EVENT+0xfe0000,0,1)
	end
end
function c101010462.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101010462)~=0
end
function c101010462.filter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable() and Duel.IsExistingMatchingCard(Card.IsDestructable,c:GetControler(),0,LOCATION_ONFIELD,1,nil)
end
function c101010462.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101010462.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010462.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010462.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,1-g:GetFirst():GetControler(),LOCATION_ONFIELD)
end
function c101010462.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not c101010462.filter(tc) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tc:GetControler(),0,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(g)
	g:AddCard(tc)
	Duel.Destroy(g,REASON_EFFECT)
end
