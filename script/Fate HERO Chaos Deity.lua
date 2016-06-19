--F・HEROカオスガル
function c101010174.initial_effect(c)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010161,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101010174.actcon)
	e2:SetCost(c101010174.actcost)
	e2:SetTarget(c101010174.acttg)
	e2:SetOperation(c101010174.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101010161,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
	--change battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101010174.cbcon)
	e5:SetTarget(c101010174.cbtg)
	e5:SetOperation(c101010174.cbop)
	c:RegisterEffect(e5)
	--change effect target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101010174.cecon)
	e4:SetTarget(c101010174.cetg)
	e4:SetOperation(c101010174.ceop)
	c:RegisterEffect(e4)
	--During your turn, halve this card's ATK.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c101010174.dcon)
	e6:SetValue(2000)
	c:RegisterEffect(e6)
end
function c101010174.mat_filter(c)
	return c:GetLevel()~=12
end
function c101010174.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010170)~=0
end
function c101010174.cfilter(c)
	return c:IsReleasableByEffect() and (c:IsLevelBelow(11) or c101010174.star(c))
end
function c101010174.star(c)
	return c:IsCode(101010176) and c:IsHasEffect(101010176)
end
function c101010174.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c101010174.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if chk==0 then return cg:IsExists(c101010174.star,1,nil) or cg:CheckWithSumEqual(Card.GetLevel,12,1,99) end
	local g=nil
	if not cg:CheckWithSumEqual(Card.GetLevel,12,1,99) or (cg:IsExists(c101010165.star,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101010176,0))) then
		g=cg:FilterSelect(tp,c101010165.star,1,1,nil)
	else
		g=cg:SelectWithSumEqual(tp,Card.GetLevel,12,1,99)
	end
	Duel.Release(g,REASON_COST)
end
function c101010174.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010174.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		c:CompleteProcedure()
		c101010174.after(e,tp)
	end
end
function c101010174.drk(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c101010174.lgt(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGraveAsCost()
end
function c101010174.after(e,tp)
	local g1=Duel.GetMatchingGroup(c101010174.drk,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(c101010174.lgt,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		if g1:GetCount()>0 then
		Duel.BreakEffect()
		if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.SendtoGrave(g2,REASON_EFFECT+REASON_RETURN)
		end
	end
end
function c101010174.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE and eg:GetFirst():GetControler()==e:GetHandler():GetControler()
end
function c101010174.cbfilter(c)
	return c:IsFacedown() or c:IsSetCard(0x9008)
end
function c101010174.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c101010174.cbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010174.cbfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101010174.cbfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101010174.cbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
function c101010174.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or Duel.GetTurnPlayer()==tp or rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:GetCount()==1 and g:GetFirst():IsControler(tp)
end
function c101010174.cefilter(c,ev)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return c:IsFacedown() or c:IsSetCard(0x9008) --tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c101010174.cetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsLocation(g:GetFirst():GetLocation()) and chkc:IsControler(tp) and c101010174.cefilter(chkc,ev) end
	if chk==0 then return Duel.IsExistingTarget(c101010174.cefilter,tp,g:GetFirst():GetLocation(),0,1,g:GetFirst(),ev) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101010174.cefilter,tp,g:GetFirst():GetLocation(),0,1,1,g:GetFirst(),ev)
end
function c101010174.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
function c101010174.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
