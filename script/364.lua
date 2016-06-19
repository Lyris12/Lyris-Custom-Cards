--Bladewing Brynhildr
function c101010648.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xbb2),4,2)
	--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--This card gains 200 ATK for each "Blademaster" monster you control, plus an additonal 300 ATK for each other "Bladewing" monster you control.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c101010648.val)
	c:RegisterEffect(e1)
	--If your opponent activates a card or effect during your Battle Phase: You can detach 1 Xyz Material from this card; negate the activation, and if you do, destroy it, then you can perform damage calculation with this card and 1 monster your opponent controls.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010648,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010648.discon)
	e2:SetCost(c101010648.cost)
	e2:SetTarget(c101010648.distg)
	e2:SetOperation(c101010648.disop)
	c:RegisterEffect(e2)
end
function c101010648.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c101010648.val(e)
	return (e:GetHandler():GetOverlayCount()*200)+(Duel.GetMatchingGroupCount(c101010648.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())*300)
end
function c101010648.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and Duel.GetTurnPlayer()==tp
		and bit.band(Duel.GetCurrentPhase(),0x38)~=0 and Duel.IsChainNegatable(ev)
end
function c101010648.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101010648.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010648.filter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c101010648.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		Duel.NegateActivation(ev)
		if tc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local c=e:GetHandler()
			if not c:IsRelateToEffect(e) then return end
			local ag=Duel.GetMatchingGroup(c101010648.filter,tp,0,LOCATION_MZONE,nil,e)
			if ag:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010648,0)) then
				local a=ag:Select(tp,1,1,nil):GetFirst()
				--if Duel.GetAttacker() then Duel.NegateAttack() end
				Duel.CalculateDamage(c,a)
				--local dam=math.abs(c:GetAttack()-a:GetAttack())
			end
		end
	end
end
