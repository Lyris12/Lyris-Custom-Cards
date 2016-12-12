--Fate's Chaos Deity
function c101010272.initial_effect(c)
	c:EnableReviveLimit()
	--If exactly 1 card you control (and no other cards) would be targeted by battle or card effect, you can change the target of that battle/effect to another, appropriate target you control.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c101010272.tgchange)
	c:RegisterEffect(e2)
	--If this card is Ritual Summoned or Special Summoned with a "Fate's" card: Banish all DARK monsters from the Graveyard, and if you do, return all banished LIGHT monsters to the Graveyard.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetCondition(c101010272.condition)
	e3:SetTarget(c101010272.target)
	e3:SetOperation(c101010272.operation)
	c:RegisterEffect(e3)
end
function c101010272.mat_filter(c)
	return c:GetLevel()~=12
end
function c101010272.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==SUMMON_TYPE_RITUAL then return true end
	return re:GetHandler():IsSetCard(0xf7a)
end
function c101010272.filter1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c101010272.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101010272.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	local g1=Duel.GetMatchingGroup(c101010272.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 then
		local g2=Duel.GetMatchingGroup(c101010272.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,g2:GetCount(),0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c101010272.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c101010272.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(c101010272.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.SendtoGrave(g2,REASON_EFFECT+REASON_RETURN)
	end
end
function c101010272.cefilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) and c:IsCanBeEffectTarget(re)
end
function c101010272.tgchange(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return end
	local fc=g:GetFirst()
	if not fc:IsControler(tp) or not fc:IsOnField() then return end
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	local nc=Duel.GetMatchingGroup(c101010272.cefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,fc,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	if nc:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010272,0)) then
		local tc=nc:Select(tp,1,1,nil)
		Duel.Hint(HINT_CARD,0,101010272)
		Duel.HintSelection(tc)
		Duel.ChangeTargetCard(ev,tc)
	end
end
