--White Wisteria Widow
function c101010387.initial_effect(c)
	c:EnableCounterPermit(0x63)
	aux.EnablePendulumAttribute(c,false)
	--You cannot Pendulum Summon monsters, except Normal Monsters. This effect cannot be negated.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetCondition(aux.nfbdncon)
	e0:SetTarget(c101010387.splimit)
	c:RegisterEffect(e0)
	--Pendulum Summoned Normal Monsters you control cannot be destroyed by card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101010387.pcttg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--When this card is activated: You can add 1 "White Wisteria" Spell/Trap Card from your Deck to your hand.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c101010387.activate)
	c:RegisterEffect(e2)
	--If a "White Wisteria" Spell/Trap Card(s) you control is targeted by a card effect your opponent controls: You can return 1 of those cards to your hand and place 1 Wisteria Counter on this card. When the 5th Wisteria Counter is placed on this card, Special Summon this card in face-down Attack Position.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c101010387.con)
	e3:SetTarget(c101010387.tg)
	e3:SetOperation(c101010387.op)
	c:RegisterEffect(e3)
	--You can only control 1 "White Wisteria Widow".
	c:SetUniqueOnField(1,0,101010387)
end
function c101010387.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010387.pcttg(e,c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and c:IsType(TYPE_NORMAL)
end
function c101010387.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb0) and c:IsAbleToHand()
end
function c101010387.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101010387.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010387,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101010387.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb0)
end
function c101010387.con(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and not tg:IsContains(e:GetHandler()) and tc+tg:FilterCount(c101010387.cfilter,nil,tp)-tg:GetCount()>0
end
function c101010387.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	tg=tg:Filter(c101010387.cfilter,e:GetHandler(),tp)
	if chk==0 then return tg:IsExists(Card.IsAbleToHand,1,nil) and c:IsCanAddCounter(0x63,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x63)
end
function c101010387.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	tg=tg:Filter(c101010387.cfilter,e:GetHandler(),tp)
	if not c:IsRelateToEffect(e) or not c:IsCanAddCounter(0x63,1) or not tg:IsExists(Card.IsAbleToHand,1,nil) then return end
	local g=tg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		c:AddCounter(0x63,1)
		if c:GetCounter(0x63)==5 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_ATTACK)
				Duel.ConfirmCards(1-tp,c)
			else Duel.SendtoGrave(c,REASON_EFFECT) end
		end
	end
end
