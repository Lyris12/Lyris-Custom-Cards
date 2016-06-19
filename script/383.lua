--Blade Flight
function c101010651.initial_effect(c)
	--"Blademaster" and "Bladewing" monsters you control cannot be targeted by your opponent's card effects. Once per turn, when a Spell, Trap, or Spell/Trap effect targets a "Blademaster" or "Bladewing" monster you control: You can return 1 of those targets to your hand, then you can Special Summon 1 monster from your hand with a different name than the returned monster.
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010651.target1)
	e1:SetOperation(c101010651.operation1)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(101010651,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c101010651.condition2)
	e2:SetTarget(c101010651.target2)
	e2:SetOperation(c101010651.operation2)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c101010651.tg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c101010651.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c101010651.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local ct=Duel.GetCurrentChain()
	if ct==1 then return end
	local pe=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	if not pe:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not pe:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) or not pe:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local tg=Duel.GetChainInfo(ct-1,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsExists(c101010651.cfilter,1,nil) then return end
	if not Duel.IsChainNegatable(ct-1) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(101010651,0)) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	end
end
function c101010651.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2) and c:IsAbleToHand()
end
function c101010651.sfilter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c101010651.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=1 then return end
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	local tg=Duel.GetChainInfo(ct-1,CHAININFO_TARGET_CARDS)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=tg:FilterSelect(tp,c101010651.filter,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101010651.sfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101010651.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not re:GetHandler():IsType(TYPE_TRAP) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsExists(c101010651.cfilter,1,nil) then return false end
	return Duel.IsChainNegatable(ev)
end
function c101010651.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if eg:GetFirst():IsDestructable() then
		eg:GetFirst():CreateEffectRelation(e)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010651.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=tg:FilterSelect(tp,c101010651.filter,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101010651.sfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101010651.tg(e,c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end